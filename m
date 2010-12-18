From: akpm@linux-foundation.org
Subject: + pps-fix-race-in-pps_fetch-handler.patch added to -mm tree
Date: Fri, 17 Dec 2010 16:19:52 -0800
Message-ID: <201012180019.oBI0JqJX004858@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46578 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752948Ab0LRAT7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 17 Dec 2010 19:19:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lasaine@lvk.cs.msu.su, giometti@linux.it


The patch titled
     pps: fix race in PPS_FETCH handler
has been added to the -mm tree.  Its filename is
     pps-fix-race-in-pps_fetch-handler.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: pps: fix race in PPS_FETCH handler
From: Alexander Gordeev <lasaine@lvk.cs.msu.su>

There was a race in PPS_FETCH ioctl handler when several processes want to
obtain PPS data simultaneously using sleeping PPS_FETCH.  They all sleep
most of the time in the system call.

With the old approach when the first process waiting on the pps queue is
waken up it makes new system call right away and zeroes pps->go.  So other
processes continue to sleep.  This is a clear race condition because of
the global 'go' variable.

With the new approach pps->last_ev holds some value increasing at each PPS
event.  PPS_FETCH ioctl handler saves current value to the local variable
at the very beginning so it can safely check that there is a new event by
just comparing both variables.

Signed-off-by: Alexander Gordeev <lasaine@lvk.cs.msu.su>
Acked-by: Rodolfo Giometti <giometti@linux.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pps/kapi.c         |    4 ++--
 drivers/pps/pps.c          |   10 +++++++---
 include/linux/pps_kernel.h |    2 +-
 3 files changed, 10 insertions(+), 6 deletions(-)

diff -puN drivers/pps/kapi.c~pps-fix-race-in-pps_fetch-handler drivers/pps/kapi.c
--- a/drivers/pps/kapi.c~pps-fix-race-in-pps_fetch-handler
+++ a/drivers/pps/kapi.c
@@ -326,8 +326,8 @@ void pps_event(int source, struct pps_kt
 
 	/* Wake up if captured something */
 	if (captured) {
-		pps->go = ~0;
-		wake_up_interruptible(&pps->queue);
+		pps->last_ev++;
+		wake_up_interruptible_all(&pps->queue);
 
 		kill_fasync(&pps->async_queue, SIGIO, POLL_IN);
 	}
diff -puN drivers/pps/pps.c~pps-fix-race-in-pps_fetch-handler drivers/pps/pps.c
--- a/drivers/pps/pps.c~pps-fix-race-in-pps_fetch-handler
+++ a/drivers/pps/pps.c
@@ -136,6 +136,7 @@ static long pps_cdev_ioctl(struct file *
 
 	case PPS_FETCH: {
 		struct pps_fdata fdata;
+		unsigned int ev;
 
 		pr_debug("PPS_FETCH: source %d\n", pps->id);
 
@@ -143,11 +144,12 @@ static long pps_cdev_ioctl(struct file *
 		if (err)
 			return -EFAULT;
 
-		pps->go = 0;
+		ev = pps->last_ev;
 
 		/* Manage the timeout */
 		if (fdata.timeout.flags & PPS_TIME_INVALID)
-			err = wait_event_interruptible(pps->queue, pps->go);
+			err = wait_event_interruptible(pps->queue,
+					ev != pps->last_ev);
 		else {
 			unsigned long ticks;
 
@@ -159,7 +161,9 @@ static long pps_cdev_ioctl(struct file *
 
 			if (ticks != 0) {
 				err = wait_event_interruptible_timeout(
-						pps->queue, pps->go, ticks);
+						pps->queue,
+						ev != pps->last_ev,
+						ticks);
 				if (err == 0)
 					return -ETIMEDOUT;
 			}
diff -puN include/linux/pps_kernel.h~pps-fix-race-in-pps_fetch-handler include/linux/pps_kernel.h
--- a/include/linux/pps_kernel.h~pps-fix-race-in-pps_fetch-handler
+++ a/include/linux/pps_kernel.h
@@ -55,7 +55,7 @@ struct pps_device {
 	struct pps_ktime clear_tu;
 	int current_mode;			/* PPS mode at event time */
 
-	int go;					/* PPS event is arrived? */
+	unsigned int last_ev;			/* last PPS event id */
 	wait_queue_head_t queue;		/* PPS event queue */
 
 	unsigned int id;			/* PPS source unique ID */
_

Patches currently in -mm which might be from lasaine@lvk.cs.msu.su are

pps-trivial-fixes.patch
pps-declare-variables-where-they-are-used-in-switch.patch
pps-fix-race-in-pps_fetch-handler.patch
pps-unify-timestamp-gathering.patch
pps-access-pps-device-by-direct-pointer.patch
pps-convert-printk-pr_-to-dev_.patch
pps-move-idr-stuff-to-ppsc.patch
pps-do-not-disable-interrupts-for-idr-operations.patch
pps-use-bug_on-for-kernel-api-safety-checks.patch
pps-simplify-conditions-a-bit.patch
pps-timestamp-is-always-passed-to-dcd_change.patch
ntp-add-hardpps-implementation.patch
pps-capture-monotonic_raw-timestamps-as-well.patch
pps-add-kernel-consumer-support.patch
pps-add-parallel-port-pps-client.patch
pps-add-parallel-port-pps-signal-generator.patch

