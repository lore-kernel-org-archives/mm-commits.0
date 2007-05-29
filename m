From: akpm@linux-foundation.org
Subject: - ps3fb-use-fb_sys_-instead-of-fb_cfb_.patch removed from -mm tree
Date: Tue, 29 May 2007 11:51:21 -0700
Message-ID: <200705291851.l4TIpK25008337@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:60520 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757003AbXE2SwI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 May 2007 14:52:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Geert.Uytterhoeven@sonycom.com, adaplas@gmail.com, mm-commits@vger.kernel.org


The patch titled
     ps3fb: use FB_SYS_* instead of FB_CFB_*
has been removed from the -mm tree.  Its filename was
     ps3fb-use-fb_sys_-instead-of-fb_cfb_.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: ps3fb: use FB_SYS_* instead of FB_CFB_*
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>

ps3fb: Use the FB_SYS_* operations instead of the FB_CFB_* operations as the
actual frame buffer memory is part of system RAM

Signed-off-by: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Signed-off-by: Antonino Daplas <adaplas@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/Kconfig |    7 ++++---
 drivers/video/ps3fb.c |    8 +++++---
 2 files changed, 9 insertions(+), 6 deletions(-)

diff -puN drivers/video/Kconfig~ps3fb-use-fb_sys_-instead-of-fb_cfb_ drivers/video/Kconfig
--- a/drivers/video/Kconfig~ps3fb-use-fb_sys_-instead-of-fb_cfb_
+++ a/drivers/video/Kconfig
@@ -1792,9 +1792,10 @@ config FB_IBM_GXT4500
 config FB_PS3
 	bool "PS3 GPU framebuffer driver"
 	depends on (FB = y) && PS3_PS3AV
-	select FB_CFB_FILLRECT
-	select FB_CFB_COPYAREA
-	select FB_CFB_IMAGEBLIT
+	select FB_SYS_FILLRECT
+	select FB_SYS_COPYAREA
+	select FB_SYS_IMAGEBLIT
+	select FB_SYS_FOPS
 	---help---
 	  Include support for the virtual frame buffer in the PS3 platform.
 
diff -puN drivers/video/ps3fb.c~ps3fb-use-fb_sys_-instead-of-fb_cfb_ drivers/video/ps3fb.c
--- a/drivers/video/ps3fb.c~ps3fb-use-fb_sys_-instead-of-fb_cfb_
+++ a/drivers/video/ps3fb.c
@@ -951,12 +951,14 @@ static int ps3fb_xdr_settings(u64 xdr_lp
 static struct fb_ops ps3fb_ops = {
 	.fb_open	= ps3fb_open,
 	.fb_release	= ps3fb_release,
+	.fb_read        = fb_sys_read,
+	.fb_write       = fb_sys_write,
 	.fb_check_var	= ps3fb_check_var,
 	.fb_set_par	= ps3fb_set_par,
 	.fb_setcolreg	= ps3fb_setcolreg,
-	.fb_fillrect	= cfb_fillrect,
-	.fb_copyarea	= cfb_copyarea,
-	.fb_imageblit	= cfb_imageblit,
+	.fb_fillrect	= sys_fillrect,
+	.fb_copyarea	= sys_copyarea,
+	.fb_imageblit	= sys_imageblit,
 	.fb_mmap	= ps3fb_mmap,
 	.fb_blank	= ps3fb_blank,
 	.fb_ioctl	= ps3fb_ioctl,
_

Patches currently in -mm which might be from Geert.Uytterhoeven@sonycom.com are
