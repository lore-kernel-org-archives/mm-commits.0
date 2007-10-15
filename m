From: akpm@linux-foundation.org
Subject: + ps3fb-default-to-480p-on-dvi-d-hdmi-if-video=safe.patch added to -mm tree
Date: Mon, 15 Oct 2007 14:36:27 -0700
Message-ID: <200710152136.l9FLaRFT026164@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33505 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755796AbXJOVgb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Oct 2007 17:36:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: Geert.Uytterhoeven@sonycom.com, adaplas@pol.net


The patch titled
     ps3fb: default to 480p on DVI-D/HDMI if video=safe
has been added to the -mm tree.  Its filename is
     ps3fb-default-to-480p-on-dvi-d-hdmi-if-video=safe.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: ps3fb: default to 480p on DVI-D/HDMI if video=safe
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>

Default to the 480p video mode on DVI-D and HDMI displays if `video=safe' is
passed on the kernel command line.

This is intended to be used by `kboot'-style boot loaders (i.e. first-stage
kernels) for the PS3, to provide a failsafe video mode.

Signed-off-by: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ps3/ps3av.c |   13 +++++++++++++
 1 file changed, 13 insertions(+)

diff -puN drivers/ps3/ps3av.c~ps3fb-default-to-480p-on-dvi-d-hdmi-if-video=safe drivers/ps3/ps3av.c
--- a/drivers/ps3/ps3av.c~ps3fb-default-to-480p-on-dvi-d-hdmi-if-video=safe
+++ a/drivers/ps3/ps3av.c
@@ -23,6 +23,7 @@
 #include <linux/delay.h>
 #include <linux/notifier.h>
 #include <linux/ioctl.h>
+#include <linux/fb.h>
 
 #include <asm/firmware.h>
 #include <asm/ps3av.h>
@@ -33,6 +34,8 @@
 #define BUFSIZE          4096	/* vuart buf size */
 #define PS3AV_BUF_SIZE   512	/* max packet size */
 
+static int safe_mode;
+
 static int timeout = 5000;	/* in msec ( 5 sec ) */
 module_param(timeout, int, 0644);
 
@@ -639,6 +642,9 @@ static int ps3av_hdmi_get_id(struct ps3a
 {
 	int id;
 
+	if (safe_mode)
+		return PS3AV_DEFAULT_HDMI_MODE_ID_REG_60;
+
 	/* check native resolution */
 	id = ps3av_resbit2id(info->res_50.native, info->res_60.native,
 			     info->res_vesa.native);
@@ -1021,7 +1027,14 @@ static int ps3av_probe(struct ps3_system
 		       res);
 
 	ps3av_get_hw_conf(ps3av);
+
+#ifdef CONFIG_FB
+	if (fb_mode_option && !strcmp(fb_mode_option, "safe"))
+		safe_mode = 1;
+#endif /* CONFIG_FB */
 	id = ps3av_auto_videomode(&ps3av->av_hw_conf);
+	safe_mode = 0;
+
 	mutex_lock(&ps3av->mutex);
 	ps3av->ps3av_mode = id;
 	mutex_unlock(&ps3av->mutex);
_

Patches currently in -mm which might be from Geert.Uytterhoeven@sonycom.com are

origin.patch
git-scsi-misc.patch
fbdev-fb_create_modedb-non-static-int-first-=-1.patch
fbdev-fb_create_modedb-non-static-int-first-=-1-fix.patch
ps3-fix-black-and-white-stripes.patch
ps3fb-fix-spurious-mode-change-failures.patch
ps3av-eliminate-unneeded-temporary-variables.patch
ps3av-eliminate-ps3av_debug.patch
ps3av-use-ps3-video-mode-ids-in-autodetect-code.patch
ps3av-treat-dvi-d-like-hdmi-in-autodetect.patch
ps3av-add-autodetection-for-vesa-modes.patch
ps3av-add-quirk-database-for-broken-monitors.patch
ps3av-remove-unused-ps3av_set_mode.patch
ps3av-dont-distinguish-between-boot-and-non-boot-autodetection.patch
ps3fb-convert-from-printk-dprintk-to-dev_-pr_.patch
ps3fb-do-not-print-warnings-on-invalid-frame-numbers.patch
ps3fb-clean-up-includes.patch
ps3fb-make-ps3fb_wait_for_vsync-and-ps3fb_flip_ctl-static.patch
ps3fb-fix-possible-overlap-of-gpu-command-buffer-and-frame-buffer.patch
ps3fb-use-fb_infopar-properly.patch
ps3fb-dont-keep-the-borders-for-non-fullscreen-modes-in-xdr-memory.patch
ps3fb-add-virtual-screen-and-panning-support.patch
ps3fb-enhance-horizontal-panning-on-firmware-190-and-up.patch
fb-move-and-rename-extern-declaration-for-global_mode_option.patch
ps3fb-default-to-480p-on-dvi-d-hdmi-if-video=safe.patch
