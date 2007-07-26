From: akpm@linux-foundation.org
Subject: + sm501fb-call-fb-suspend-function-during-suspend-and-resume.patch added to -mm tree
Date: Thu, 26 Jul 2007 12:00:42 -0700
Message-ID: <200707261900.l6QJ0gp6015660@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60843 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932708AbXGZTNC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 26 Jul 2007 15:13:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ben-linux@fluff.org, adaplas@gmail.com


The patch titled
     sm501fb: Call fb suspend function during suspend and  resume
has been added to the -mm tree.  Its filename is
     sm501fb-call-fb-suspend-function-during-suspend-and-resume.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: sm501fb: Call fb suspend function during suspend and  resume
From: Ben Dooks <ben-linux@fluff.org>

Call the fb_set_suspend() over suspend and resume.

Signed-off-by: Antonino Daplas <adaplas@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/sm501fb.c |    9 +++++++++
 1 file changed, 9 insertions(+)

diff -puN drivers/video/sm501fb.c~sm501fb-call-fb-suspend-function-during-suspend-and-resume drivers/video/sm501fb.c
--- a/drivers/video/sm501fb.c~sm501fb-call-fb-suspend-function-during-suspend-and-resume
+++ a/drivers/video/sm501fb.c
@@ -28,6 +28,7 @@
 #include <linux/wait.h>
 #include <linux/platform_device.h>
 #include <linux/clk.h>
+#include <linux/console.h>
 
 #include <asm/io.h>
 #include <asm/uaccess.h>
@@ -1697,6 +1698,10 @@ static int sm501fb_suspend_fb(struct sm5
 	/* blank the relevant interface to ensure unit power minimised */
 	(par->ops.fb_blank)(FB_BLANK_POWERDOWN, fbi);
 
+	acquire_console_sem();
+	fb_set_suspend(fbi, 1);
+	release_console_sem();
+
 	return 0;
 
  err_nocursor:
@@ -1732,6 +1737,10 @@ static void sm501fb_resume_fb(struct sm5
 		memcpy_toio(par->cursor.k_addr, par->store_cursor,
 			    par->cursor.size);
 
+	acquire_console_sem();
+	fb_set_suspend(fbi, 0);
+	release_console_sem();
+
 	vfree(par->store_fb);
 	vfree(par->store_cursor);
 }
_

Patches currently in -mm which might be from ben-linux@fluff.org are

fixup-s3c24xx-build-after-arch-moves.patch
git-mtd.patch
git-watchdog.patch
s3c2410fb-fix-s3c2410-compilation.patch
sm501fb-update-suspend-and-resume-code.patch
sm501fb-call-fb-suspend-function-during-suspend-and-resume.patch
sm501fb-ensure-panel-interface-is-not-tristated-when-setup.patch
