From: akpm@linux-foundation.org
Subject: [merged] rapidio-run-discovery-as-an-asynchronous-process.patch removed from -mm tree
Date: Fri, 05 Oct 2012 13:20:41 -0700
Message-ID: <20121005202042.2D41920004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lb0-f202.google.com ([209.85.217.202]:63280 "EHLO
	mail-lb0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932319Ab2JEUUo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Oct 2012 16:20:44 -0400
Received: by mail-lb0-f202.google.com with SMTP id l12so141181lbo.1
        for <mm-commits@vger.kernel.org>; Fri, 05 Oct 2012 13:20:43 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alexandre.bounine@idt.com, leoli@freescale.com, mporter@kernel.crashing.org, mm-commits@vger.kernel.org


The patch titled
     Subject: rapidio: run discovery as an asynchronous process
has been removed from the -mm tree.  Its filename was
     rapidio-run-discovery-as-an-asynchronous-process.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Alexandre Bounine <alexandre.bounine@idt.com>
Subject: rapidio: run discovery as an asynchronous process

Modify mport initialization routine to run the RapidIO discovery process
asynchronously.  This allows to have an arbitrary order of enumerating and
discovering ports in systems with multiple RapidIO controllers without
creating a deadlock situation if enumerator port is registered after a
discovering one.

Making netID matching to mportID ensures consistent net ID assignment in
multiport RapidIO systems with asynchronous discovery process (global
counter implementation is affected by race between threads).

[akpm@linux-foundation.org: tweak code layput]
Signed-off-by: Alexandre Bounine <alexandre.bounine@idt.com>
Cc: Matt Porter <mporter@kernel.crashing.org>
Cc: Li Yang <leoli@freescale.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rapidio/rio-scan.c |    3 --
 drivers/rapidio/rio.c      |   51 +++++++++++++++++++++++++++++++++--
 2 files changed, 50 insertions(+), 4 deletions(-)

diff -puN drivers/rapidio/rio-scan.c~rapidio-run-discovery-as-an-asynchronous-process drivers/rapidio/rio-scan.c
--- a/drivers/rapidio/rio-scan.c~rapidio-run-discovery-as-an-asynchronous-process
+++ a/drivers/rapidio/rio-scan.c
@@ -44,7 +44,6 @@ static void rio_init_em(struct rio_dev *
 DEFINE_SPINLOCK(rio_global_list_lock);
 
 static int next_destid = 0;
-static int next_net = 0;
 static int next_comptag = 1;
 
 static int rio_mport_phys_table[] = {
@@ -1062,7 +1061,7 @@ static struct rio_net __devinit *rio_all
 		INIT_LIST_HEAD(&net->mports);
 		list_add_tail(&port->nnode, &net->mports);
 		net->hport = port;
-		net->id = next_net++;
+		net->id = port->id;
 	}
 	return net;
 }
diff -puN drivers/rapidio/rio.c~rapidio-run-discovery-as-an-asynchronous-process drivers/rapidio/rio.c
--- a/drivers/rapidio/rio.c~rapidio-run-discovery-as-an-asynchronous-process
+++ a/drivers/rapidio/rio.c
@@ -1260,15 +1260,62 @@ static int __devinit rio_init(void)
 	return 0;
 }
 
+static struct workqueue_struct *rio_wq;
+
+struct rio_disc_work {
+	struct work_struct	work;
+	struct rio_mport	*mport;
+};
+
+static void __devinit disc_work_handler(struct work_struct *_work)
+{
+	struct rio_disc_work *work;
+
+	work = container_of(_work, struct rio_disc_work, work);
+	pr_debug("RIO: discovery work for mport %d %s\n",
+		 work->mport->id, work->mport->name);
+	rio_disc_mport(work->mport);
+
+	kfree(work);
+}
+
 int __devinit rio_init_mports(void)
 {
 	struct rio_mport *port;
+	struct rio_disc_work *work;
+	int no_disc = 0;
 
 	list_for_each_entry(port, &rio_mports, node) {
 		if (port->host_deviceid >= 0)
 			rio_enum_mport(port);
-		else
-			rio_disc_mport(port);
+		else if (!no_disc) {
+			if (!rio_wq) {
+				rio_wq = alloc_workqueue("riodisc", 0, 0);
+				if (!rio_wq) {
+					pr_err("RIO: unable allocate rio_wq\n");
+					no_disc = 1;
+					continue;
+				}
+			}
+
+			work = kzalloc(sizeof *work, GFP_KERNEL);
+			if (!work) {
+				pr_err("RIO: no memory for work struct\n");
+				no_disc = 1;
+				continue;
+			}
+
+			work->mport = port;
+			INIT_WORK(&work->work, disc_work_handler);
+			queue_work(rio_wq, &work->work);
+		}
+	}
+
+	if (rio_wq) {
+		pr_debug("RIO: flush discovery workqueue\n");
+		flush_workqueue(rio_wq);
+		pr_debug("RIO: flush discovery workqueue finished\n");
+		destroy_workqueue(rio_wq);
 	}
 
 	rio_init();
_

Patches currently in -mm which might be from alexandre.bounine@idt.com are

origin.patch

