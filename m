From: akpm@linux-foundation.org
Subject: + ps3fb-thread-updates-42.patch added to -mm tree
Date: Tue, 27 Feb 2007 13:09:20 -0800
Message-ID: <200702272109.l1RL9OFO028644@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:52260 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752625AbXB0VJs (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 27 Feb 2007 16:09:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: Geert.Uytterhoeven@sonycom.com


The patch titled
     ps3fb: thread updates (final)
has been added to the -mm tree.  Its filename is
     ps3fb-thread-updates-42.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: ps3fb: thread updates (final)
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>

Signed-off-by: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/ps3fb.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN drivers/video/ps3fb.c~ps3fb-thread-updates-42 drivers/video/ps3fb.c
--- a/drivers/video/ps3fb.c~ps3fb-thread-updates-42
+++ a/drivers/video/ps3fb.c
@@ -33,6 +33,7 @@
 #include <linux/notifier.h>
 #include <linux/reboot.h>
 #include <linux/kthread.h>
+#include <linux/freezer.h>
 
 #include <asm/uaccess.h>
 #include <linux/fb.h>
@@ -808,6 +809,7 @@ static int ps3fb_ioctl(struct fb_info *i
 static int ps3fbd(void *arg)
 {
 	while (!kthread_should_stop()) {
+		try_to_freeze();
 		set_current_state(TASK_INTERRUPTIBLE);
 		if (ps3fb.is_kicked) {
 			ps3fb.is_kicked = 0;
_

Patches currently in -mm which might be from Geert.Uytterhoeven@sonycom.com are

ps3-introduce-config_ps3_advanced.patch
ps3fb-thread-updates.patch
ps3fb-thread-updates-update.patch
ps3fb-thread-updates-2.patch
ps3fb-thread-updates-42.patch
ps3av-thread-updates.patch
ps3fb-kill-superfluous-zero-initializations.patch
ps3fb-atomic-fixes.patch
ps3av-misc-updates.patch
