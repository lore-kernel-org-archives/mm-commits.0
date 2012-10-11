From: akpm@linux-foundation.org
Subject: [merged] rapidio-update-asynchronous-discovery-initialization.patch removed from -mm tree
Date: Thu, 11 Oct 2012 13:59:06 -0700
Message-ID: <20121011205906.B96E2100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f74.google.com ([209.85.212.74]:62654 "EHLO
	mail-vb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755431Ab2JKU7H (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 11 Oct 2012 16:59:07 -0400
Received: by mail-vb0-f74.google.com with SMTP id s24so251836vbi.1
        for <mm-commits@vger.kernel.org>; Thu, 11 Oct 2012 13:59:07 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alexandre.bounine@idt.com, leoli@freescale.com, mporter@kernel.crashing.org, mm-commits@vger.kernel.org


The patch titled
     Subject: rapidio: update asynchronous discovery initialization
has been removed from the -mm tree.  Its filename was
     rapidio-update-asynchronous-discovery-initialization.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Alexandre Bounine <alexandre.bounine@idt.com>
Subject: rapidio: update asynchronous discovery initialization

Update discovery process initialization based on Andrew Morton's comments:
https://lkml.org/lkml/2012/10/3/552.

This update processes all enumerating mports first and schedules discovery
work after that. If the initialization routine fails to allocate resources
needed to execute discovery, it abandons discovery for all ports.

Signed-off-by: Alexandre Bounine <alexandre.bounine@idt.com>
Cc: Matt Porter <mporter@kernel.crashing.org>
Cc: Li Yang <leoli@freescale.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rapidio/rio.c |   75 +++++++++++++++++++++++++---------------
 1 file changed, 47 insertions(+), 28 deletions(-)

diff -puN drivers/rapidio/rio.c~rapidio-update-asynchronous-discovery-initialization drivers/rapidio/rio.c
--- a/drivers/rapidio/rio.c~rapidio-update-asynchronous-discovery-initialization
+++ a/drivers/rapidio/rio.c
@@ -1275,49 +1275,68 @@ static void __devinit disc_work_handler(
 	pr_debug("RIO: discovery work for mport %d %s\n",
 		 work->mport->id, work->mport->name);
 	rio_disc_mport(work->mport);
-
-	kfree(work);
 }
 
 int __devinit rio_init_mports(void)
 {
 	struct rio_mport *port;
 	struct rio_disc_work *work;
-	int no_disc = 0;
+	int n = 0;
 
+	if (!next_portid)
+		return -ENODEV;
+
+	/*
+	 * First, run enumerations and check if we need to perform discovery
+	 * on any of the registered mports.
+	 */
 	list_for_each_entry(port, &rio_mports, node) {
 		if (port->host_deviceid >= 0)
 			rio_enum_mport(port);
-		else if (!no_disc) {
-			if (!rio_wq) {
-				rio_wq = alloc_workqueue("riodisc", 0, 0);
-				if (!rio_wq) {
-					pr_err("RIO: unable allocate rio_wq\n");
-					no_disc = 1;
-					continue;
-				}
-			}
-
-			work = kzalloc(sizeof *work, GFP_KERNEL);
-			if (!work) {
-				pr_err("RIO: no memory for work struct\n");
-				no_disc = 1;
-				continue;
-			}
-
-			work->mport = port;
-			INIT_WORK(&work->work, disc_work_handler);
-			queue_work(rio_wq, &work->work);
-		}
+		else
+			n++;
+	}
+
+	if (!n)
+		goto no_disc;
+
+	/*
+	 * If we have mports that require discovery schedule a discovery work
+	 * for each of them. If the code below fails to allocate needed
+	 * resources, exit without error to keep results of enumeration
+	 * process (if any).
+	 * TODO: Implement restart of dicovery process for all or
+	 * individual discovering mports.
+	 */
+	rio_wq = alloc_workqueue("riodisc", 0, 0);
+	if (!rio_wq) {
+		pr_err("RIO: unable allocate rio_wq\n");
+		goto no_disc;
 	}
 
-	if (rio_wq) {
-		pr_debug("RIO: flush discovery workqueue\n");
-		flush_workqueue(rio_wq);
-		pr_debug("RIO: flush discovery workqueue finished\n");
+	work = kcalloc(n, sizeof *work, GFP_KERNEL);
+	if (!work) {
+		pr_err("RIO: no memory for work struct\n");
 		destroy_workqueue(rio_wq);
+		goto no_disc;
 	}
 
+	n = 0;
+	list_for_each_entry(port, &rio_mports, node) {
+		if (port->host_deviceid < 0) {
+			work[n].mport = port;
+			INIT_WORK(&work[n].work, disc_work_handler);
+			queue_work(rio_wq, &work[n].work);
+			n++;
+		}
+	}
+
+	flush_workqueue(rio_wq);
+	pr_debug("RIO: destroy discovery workqueue\n");
+	destroy_workqueue(rio_wq);
+	kfree(work);
+
+no_disc:
 	rio_init();
 
 	return 0;
_

Patches currently in -mm which might be from alexandre.bounine@idt.com are

origin.patch

