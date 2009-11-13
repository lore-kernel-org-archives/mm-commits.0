From: akpm@linux-foundation.org
Subject: [merged] pps-events-reporting-fix-up.patch removed from -mm tree
Date: Fri, 13 Nov 2009 11:27:29 -0800
Message-ID: <200911131927.nADJRTOe030766@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59908 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757188AbZKMT2E (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 13 Nov 2009 14:28:04 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: giometti@linux.it, billb958@door.net, clemens@dwf.com, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     pps: events reporting fix up
has been removed from the -mm tree.  Its filename was
     pps-events-reporting-fix-up.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: pps: events reporting fix up
From: Rodolfo Giometti <giometti@linux.it>

PPS events must be recorded according to PPS's mode settings.

If a process asks for (i.e.) capture-assert events only, when the PPS
client calls the pps_event() function to save the current PPS event, we
should verify the event type and then discard unwanted ones.

Also, without this patch userland processes waiting for a specific PPS
event (assert or clear but not both) may be awakened at wrong time.

Signed-off-by: Rodolfo Giometti <giometti@linux.it>
Tested-by: William S. Brasher <billb958@door.net>
Tested-by: Reg Clemens <clemens@dwf.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN drivers/pps/kapi.c~pps-events-reporting-fix-up drivers/pps/kapi.c
--- a/drivers/pps/kapi.c~pps-events-reporting-fix-up
+++ a/drivers/pps/kapi.c
@@ -271,6 +271,7 @@ void pps_event(int source, struct pps_kt
 {
 	struct pps_device *pps;
 	unsigned long flags;
+	int captured = 0;
 
 	if ((event & (PPS_CAPTUREASSERT | PPS_CAPTURECLEAR)) == 0) {
 		printk(KERN_ERR "pps: unknown event (%x) for source %d\n",
@@ -293,7 +294,8 @@ void pps_event(int source, struct pps_kt
 
 	/* Check the event */
 	pps->current_mode = pps->params.mode;
-	if (event & PPS_CAPTUREASSERT) {
+	if ((event & PPS_CAPTUREASSERT) &
+			(pps->params.mode & PPS_CAPTUREASSERT)) {
 		/* We have to add an offset? */
 		if (pps->params.mode & PPS_OFFSETASSERT)
 			pps_add_offset(ts, &pps->params.assert_off_tu);
@@ -303,8 +305,11 @@ void pps_event(int source, struct pps_kt
 		pps->assert_sequence++;
 		pr_debug("capture assert seq #%u for source %d\n",
 			pps->assert_sequence, source);
+
+		captured = ~0;
 	}
-	if (event & PPS_CAPTURECLEAR) {
+	if ((event & PPS_CAPTURECLEAR) &
+			(pps->params.mode & PPS_CAPTURECLEAR)) {
 		/* We have to add an offset? */
 		if (pps->params.mode & PPS_OFFSETCLEAR)
 			pps_add_offset(ts, &pps->params.clear_off_tu);
@@ -314,12 +319,17 @@ void pps_event(int source, struct pps_kt
 		pps->clear_sequence++;
 		pr_debug("capture clear seq #%u for source %d\n",
 			pps->clear_sequence, source);
+
+		captured = ~0;
 	}
 
-	pps->go = ~0;
-	wake_up_interruptible(&pps->queue);
+	/* Wake up iif captured somthing */
+	if (captured) {
+		pps->go = ~0;
+		wake_up_interruptible(&pps->queue);
 
-	kill_fasync(&pps->async_queue, SIGIO, POLL_IN);
+		kill_fasync(&pps->async_queue, SIGIO, POLL_IN);
+	}
 
 	spin_unlock_irqrestore(&pps->lock, flags);
 
_

Patches currently in -mm which might be from giometti@linux.it are

linux-next.patch

