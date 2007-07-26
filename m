From: akpm@linux-foundation.org
Subject: + sm501fb-update-suspend-and-resume-code.patch added to -mm tree
Date: Thu, 26 Jul 2007 12:00:41 -0700
Message-ID: <200707261900.l6QJ0fXE015655@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57706 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932876AbXGZTNE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 26 Jul 2007 15:13:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ben-linux@fluff.org, adaplas@gmail.com


The patch titled
     sm501fb: update suspend and resume code
has been added to the -mm tree.  Its filename is
     sm501fb-update-suspend-and-resume-code.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: sm501fb: update suspend and resume code
From: Ben Dooks <ben-linux@fluff.org>

The suspend and resume code is failing to restore the CRT control
register, thus causing the CRT data-path to get changed if the
SM501 experiences a reset over suspend.

Also move some of the debug messages to dev_dbg() level and ensure
that the suspend code does not try and restore anything it did not
manage to save.

Signed-off-by: Ben Dooks <ben-linux@fluff.org>
Signed-off-by: Antonino Daplas <adaplas@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/sm501fb.c |   35 +++++++++++++++++++++++++++++++----
 1 file changed, 31 insertions(+), 4 deletions(-)

diff -puN drivers/video/sm501fb.c~sm501fb-update-suspend-and-resume-code drivers/video/sm501fb.c
--- a/drivers/video/sm501fb.c~sm501fb-update-suspend-and-resume-code
+++ a/drivers/video/sm501fb.c
@@ -62,6 +62,8 @@ struct sm501fb_info {
 	struct resource		*regs_res;	/* registers resource */
 	struct sm501_platdata_fb *pdata;	/* our platform data */
 
+	unsigned long		 pm_crt_ctrl;	/* pm: crt ctrl save */
+
 	int			 irq;
 	int			 swap_endian;	/* set to swap rgb=>bgr */
 	void __iomem		*regs;		/* remapped registers */
@@ -1687,9 +1689,11 @@ static int sm501fb_suspend_fb(struct sm5
 		goto err_nocursor;
 	}
 
+	dev_dbg(info->dev, "suspending screen to %p\n", par->store_fb);
+	dev_dbg(info->dev, "suspending cursor to %p\n", par->store_cursor);
+
 	memcpy_fromio(par->store_fb, par->screen.k_addr, par->screen.size);
 	memcpy_fromio(par->store_cursor, par->cursor.k_addr, par->cursor.size);
-
 	/* blank the relevant interface to ensure unit power minimised */
 	(par->ops.fb_blank)(FB_BLANK_POWERDOWN, fbi);
 
@@ -1697,9 +1701,9 @@ static int sm501fb_suspend_fb(struct sm5
 
  err_nocursor:
 	vfree(par->store_fb);
+	par->store_fb = NULL;
 
 	return -ENOMEM;
-
 }
 
 static void sm501fb_resume_fb(struct sm501fb_info *info,
@@ -1717,8 +1721,16 @@ static void sm501fb_resume_fb(struct sm5
 
 	/* restore the data */
 
-	memcpy_toio(par->screen.k_addr, par->store_fb, par->screen.size);
-	memcpy_toio(par->cursor.k_addr, par->store_cursor, par->cursor.size);
+	dev_dbg(info->dev, "restoring screen from %p\n", par->store_fb);
+	dev_dbg(info->dev, "restoring cursor from %p\n", par->store_cursor);
+
+	if (par->store_fb)
+		memcpy_toio(par->screen.k_addr, par->store_fb,
+			    par->screen.size);
+
+	if (par->store_cursor)
+		memcpy_toio(par->cursor.k_addr, par->store_cursor,
+			    par->cursor.size);
 
 	vfree(par->store_fb);
 	vfree(par->store_cursor);
@@ -1731,6 +1743,9 @@ static int sm501fb_suspend(struct platfo
 {
 	struct sm501fb_info *info = platform_get_drvdata(pdev);
 
+	/* store crt control to resume with */
+	info->pm_crt_ctrl = readl(info->regs + SM501_DC_CRT_CONTROL);
+
 	sm501fb_suspend_fb(info, HEAD_CRT);
 	sm501fb_suspend_fb(info, HEAD_PANEL);
 
@@ -1740,12 +1755,24 @@ static int sm501fb_suspend(struct platfo
 	return 0;
 }
 
+#define SM501_CRT_CTRL_SAVE (SM501_DC_CRT_CONTROL_TVP |        \
+			     SM501_DC_CRT_CONTROL_SEL)
+
+
 static int sm501fb_resume(struct platform_device *pdev)
 {
 	struct sm501fb_info *info = platform_get_drvdata(pdev);
+	unsigned long crt_ctrl;
 
 	sm501_unit_power(info->dev->parent, SM501_GATE_DISPLAY, 1);
 
+	/* restore the items we want to be saved for crt control */
+
+	crt_ctrl = readl(info->regs + SM501_DC_CRT_CONTROL);
+	crt_ctrl &= ~SM501_CRT_CTRL_SAVE;
+	crt_ctrl |= info->pm_crt_ctrl & SM501_CRT_CTRL_SAVE;
+	writel(crt_ctrl, info->regs + SM501_DC_CRT_CONTROL);
+
 	sm501fb_resume_fb(info, HEAD_CRT);
 	sm501fb_resume_fb(info, HEAD_PANEL);
 
_

Patches currently in -mm which might be from ben-linux@fluff.org are

fixup-s3c24xx-build-after-arch-moves.patch
git-mtd.patch
git-watchdog.patch
s3c2410fb-fix-s3c2410-compilation.patch
sm501fb-update-suspend-and-resume-code.patch
sm501fb-call-fb-suspend-function-during-suspend-and-resume.patch
sm501fb-ensure-panel-interface-is-not-tristated-when-setup.patch
