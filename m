From: akpm@linux-foundation.org
Subject: + ps3fb-thread-updates-2.patch added to -mm tree
Date: Wed, 21 Feb 2007 15:21:02 -0800
Message-ID: <200702212321.l1LNL6xe029727@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:56603 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423257AbXBUXV3 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 21 Feb 2007 18:21:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: Geert.Uytterhoeven@sonycom.com


The patch titled
     ps3fb: thread updates 2
has been added to the -mm tree.  Its filename is
     ps3fb-thread-updates-2.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: ps3fb: thread updates 2
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>

Replace the kernel_thread and the semaphore by a proper kthread, which is
simply woken up when the screen must be updated

Signed-off-by: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/ps3fb.c |   16 ++++++----------
 1 files changed, 6 insertions(+), 10 deletions(-)

diff -puN drivers/video/ps3fb.c~ps3fb-thread-updates-2 drivers/video/ps3fb.c
--- a/drivers/video/ps3fb.c~ps3fb-thread-updates-2
+++ a/drivers/video/ps3fb.c
@@ -32,7 +32,6 @@
 #include <linux/ioctl.h>
 #include <linux/notifier.h>
 #include <linux/reboot.h>
-#include <linux/freezer.h>
 #include <linux/kthread.h>
 
 #include <asm/uaccess.h>
@@ -808,16 +807,13 @@ static int ps3fb_ioctl(struct fb_info *i
 
 static int ps3fbd(void *arg)
 {
-	DEFINE_WAIT(wait);
-	DECLARE_WAIT_QUEUE_HEAD(wq);
-
 	while (!kthread_should_stop()) {
-		prepare_to_wait(&wq, &wait, TASK_INTERRUPTIBLE);
-		if (!ps3fb.is_kicked)
-			schedule();
-		finish_wait(&wq, &wait);
-		ps3fb.is_kicked = 0;
-		ps3fb_sync(0);	/* single buffer */
+		set_current_state(TASK_INTERRUPTIBLE);
+		if (ps3fb.is_kicked) {
+			ps3fb.is_kicked = 0;
+			ps3fb_sync(0);	/* single buffer */
+		}
+		schedule();
 	}
 	return 0;
 }
_

Patches currently in -mm which might be from Geert.Uytterhoeven@sonycom.com are

ps3fb-thread-updates.patch
ps3fb-thread-updates-update.patch
ps3fb-thread-updates-2.patch
ps3av-thread-updates.patch
ps3fb-kill-superfluous-zero-initializations.patch
ps3fb-atomic-fixes.patch
ps3av-misc-updates.patch
