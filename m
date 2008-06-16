From: akpm@linux-foundation.org
Subject: - mmc-wbsd-initialize-tasklets-before-requesting-interrupt.patch removed from -mm tree
Date: Sun, 15 Jun 2008 23:03:41 -0700
Message-ID: <200806160603.m5G63fsw010617@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51816 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751384AbYFPGEL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 16 Jun 2008 02:04:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cebbert@redhat.com, drzeus@drzeus.cx, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     mmc: wbsd: initialize tasklets before requesting interrupt
has been removed from the -mm tree.  Its filename was
     mmc-wbsd-initialize-tasklets-before-requesting-interrupt.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mmc: wbsd: initialize tasklets before requesting interrupt
From: Chuck Ebbert <cebbert@redhat.com>

With CONFIG_DEBUG_SHIRQ set we will get an interrupt as soon as we
allocate one.  Tasklets may be scheduled in the interrupt handler but they
will be initialized after the handler returns, causing a BUG() in
kernel/softirq.c when they run.

Should fix this Fedora bug report:
https://bugzilla.redhat.com/show_bug.cgi?id=449817

Signed-off-by: Chuck Ebbert <cebbert@redhat.com>
Acked-by: Pierre Ossman <drzeus@drzeus.cx>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mmc/host/wbsd.c |   21 ++++++++++-----------
 1 file changed, 10 insertions(+), 11 deletions(-)

diff -puN drivers/mmc/host/wbsd.c~mmc-wbsd-initialize-tasklets-before-requesting-interrupt drivers/mmc/host/wbsd.c
--- a/drivers/mmc/host/wbsd.c~mmc-wbsd-initialize-tasklets-before-requesting-interrupt
+++ a/drivers/mmc/host/wbsd.c
@@ -1457,17 +1457,7 @@ static int __devinit wbsd_request_irq(st
 	int ret;
 
 	/*
-	 * Allocate interrupt.
-	 */
-
-	ret = request_irq(irq, wbsd_irq, IRQF_SHARED, DRIVER_NAME, host);
-	if (ret)
-		return ret;
-
-	host->irq = irq;
-
-	/*
-	 * Set up tasklets.
+	 * Set up tasklets. Must be done before requesting interrupt.
 	 */
 	tasklet_init(&host->card_tasklet, wbsd_tasklet_card,
 			(unsigned long)host);
@@ -1480,6 +1470,15 @@ static int __devinit wbsd_request_irq(st
 	tasklet_init(&host->finish_tasklet, wbsd_tasklet_finish,
 			(unsigned long)host);
 
+	/*
+	 * Allocate interrupt.
+	 */
+	ret = request_irq(irq, wbsd_irq, IRQF_SHARED, DRIVER_NAME, host);
+	if (ret)
+		return ret;
+
+	host->irq = irq;
+
 	return 0;
 }
 
_

Patches currently in -mm which might be from cebbert@redhat.com are

origin.patch

