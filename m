From: akpm@linux-foundation.org
Subject: - char-genrtc-use-wait_event_interruptible.patch removed from -mm tree
Date: Mon, 16 Jul 2007 13:55:00 -0700
Message-ID: <200707162055.l6GKt0hX001870@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36642 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758933AbXGPVTy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 16 Jul 2007 17:19:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jirislaby@gmail.com, a.zummo@towertech.it, david-b@pacbell.net, zippel@linux-m68k.org, mm-commits@vger.kernel.org


The patch titled
     Char: genrtc, use wait_event_interruptible
has been removed from the -mm tree.  Its filename was
     char-genrtc-use-wait_event_interruptible.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Char: genrtc, use wait_event_interruptible
From: Jiri Slaby <jirislaby@gmail.com>

genrtc, use wait_event_interruptible

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Roman Zippel <zippel@linux-m68k.org>
Cc: David Brownell <david-b@pacbell.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/genrtc.c |   22 +++++-----------------
 1 file changed, 5 insertions(+), 17 deletions(-)

diff -puN drivers/char/genrtc.c~char-genrtc-use-wait_event_interruptible drivers/char/genrtc.c
--- a/drivers/char/genrtc.c~char-genrtc-use-wait_event_interruptible
+++ a/drivers/char/genrtc.c
@@ -173,7 +173,6 @@ static void gen_rtc_interrupt(unsigned l
 static ssize_t gen_rtc_read(struct file *file, char __user *buf,
 			size_t count, loff_t *ppos)
 {
-	DECLARE_WAITQUEUE(wait, current);
 	unsigned long data;
 	ssize_t retval;
 
@@ -183,18 +182,10 @@ static ssize_t gen_rtc_read(struct file 
 	if (file->f_flags & O_NONBLOCK && !gen_rtc_irq_data)
 		return -EAGAIN;
 
-	add_wait_queue(&gen_rtc_wait, &wait);
-	retval = -ERESTARTSYS;
-
-	while (1) {
-		set_current_state(TASK_INTERRUPTIBLE);
-		data = xchg(&gen_rtc_irq_data, 0);
-		if (data)
-			break;
-		if (signal_pending(current))
-			goto out;
-		schedule();
-	}
+	retval = wait_event_interruptible(gen_rtc_wait,
+			(data = xchg(&gen_rtc_irq_data, 0)));
+	if (retval)
+		goto out;
 
 	/* first test allows optimizer to nuke this case for 32-bit machines */
 	if (sizeof (int) != sizeof (long) && count == sizeof (unsigned int)) {
@@ -206,10 +197,7 @@ static ssize_t gen_rtc_read(struct file 
 		retval = put_user(data, (unsigned long __user *)buf) ?:
 			sizeof(unsigned long);
 	}
- out:
-	__set_current_state(TASK_RUNNING);
-	remove_wait_queue(&gen_rtc_wait, &wait);
-
+out:
 	return retval;
 }
 
_

Patches currently in -mm which might be from jirislaby@gmail.com are

origin.patch
char-cyclades-add-firmware-loading.patch
char-cyclades-fix-sparse-warning.patch
char-isicom-cleanup-locking.patch
char-isicom-del_timer-at-exit.patch
char-isicom-proper-variables-types.patch
char-moxa-eliminate-busy-waiting.patch
char-specialix-remove-busy-waiting.patch
char-riscom8-eliminate-busy-loop.patch
char-vt-use-kzalloc.patch
char-vt-use-array_size.patch
char-kconfig-mxser_new-remove-experimental-comment.patch
char-stallion-remove-user-class-report-request.patch
char-istallion-initlocking-fixes-try-2.patch
stallion-remove-unneeded-lock_kernel.patch
some-kmalloc-memset-kzalloc-tree-wide.patch
shrink_slab-handle-bad-shrinkers.patch
