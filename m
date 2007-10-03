From: akpm@linux-foundation.org
Subject: + ps3av-dont-distinguish-between-boot-and-non-boot-autodetection.patch added to -mm tree
Date: Wed, 03 Oct 2007 13:53:26 -0700
Message-ID: <200710032053.l93KrQPl008110@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34151 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757066AbXJCUxa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Oct 2007 16:53:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: Geert.Uytterhoeven@sonycom.com, adaplas@gmail.com


The patch titled
     ps3av: dont distinguish between `boot' and `non-boot' autodetection
has been added to the -mm tree.  Its filename is
     ps3av-dont-distinguish-between-boot-and-non-boot-autodetection.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: ps3av: dont distinguish between `boot' and `non-boot' autodetection
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>

don't distinguish between `boot' and `non-boot' autodetection now the
autodetection code has been improved

Signed-off-by: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Signed-off-by: Antonino Daplas <adaplas@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN drivers/ps3/ps3av.c~ps3av-dont-distinguish-between-boot-and-non-boot-autodetection drivers/ps3/ps3av.c
--- a/drivers/ps3/ps3av.c~ps3av-dont-distinguish-between-boot-and-non-boot-autodetection
+++ a/drivers/ps3/ps3av.c
@@ -760,8 +760,7 @@ static void ps3av_fixup_monitor_info(str
 	}
 }
 
-static int ps3av_auto_videomode(struct ps3av_pkt_av_get_hw_conf *av_hw_conf,
-				int boot)
+static int ps3av_auto_videomode(struct ps3av_pkt_av_get_hw_conf *av_hw_conf)
 {
 	int i, res, id = 0, dvi = 0, rgb = 0;
 	struct ps3av_pkt_av_get_monitor_info monitor_info;
@@ -799,28 +798,6 @@ static int ps3av_auto_videomode(struct p
 		if (ps3av->region & PS3AV_REGION_RGB)
 			rgb = PS3AV_MODE_RGB;
 		pr_debug("%s: Using avmulti mode %d\n", __func__, id);
-	} else if (boot) {
-		/* HDMI: using DEFAULT HDMI_MODE_ID while booting up */
-		info = &monitor_info.info;
-		if (ps3av->region & PS3AV_REGION_60) {
-			if (info->res_60.res_bits & PS3AV_RESBIT_720x480P)
-				id = PS3AV_DEFAULT_HDMI_MODE_ID_REG_60;
-			else if (info->res_50.res_bits & PS3AV_RESBIT_720x576P)
-				id = PS3AV_DEFAULT_HDMI_MODE_ID_REG_50;
-			else {
-				/* default */
-				id = PS3AV_DEFAULT_HDMI_MODE_ID_REG_60;
-			}
-		} else {
-			if (info->res_50.res_bits & PS3AV_RESBIT_720x576P)
-				id = PS3AV_DEFAULT_HDMI_MODE_ID_REG_50;
-			else if (info->res_60.res_bits & PS3AV_RESBIT_720x480P)
-				id = PS3AV_DEFAULT_HDMI_MODE_ID_REG_60;
-			else {
-				/* default */
-				id = PS3AV_DEFAULT_HDMI_MODE_ID_REG_50;
-			}
-		}
 	}
 
 	return id | dvi | rgb;
@@ -862,7 +839,7 @@ static int ps3av_get_hw_conf(struct ps3a
 }
 
 /* set mode using id */
-int ps3av_set_video_mode(u32 id, int boot)
+int ps3av_set_video_mode(u32 id)
 {
 	int size;
 	u32 option;
@@ -876,7 +853,7 @@ int ps3av_set_video_mode(u32 id, int boo
 	/* auto mode */
 	option = id & ~PS3AV_MODE_MASK;
 	if ((id & PS3AV_MODE_MASK) == 0) {
-		id = ps3av_auto_videomode(&ps3av->av_hw_conf, boot);
+		id = ps3av_auto_videomode(&ps3av->av_hw_conf);
 		if (id < 1) {
 			printk(KERN_ERR "%s: invalid id :%d\n", __func__, id);
 			return -EINVAL;
@@ -896,9 +873,9 @@ int ps3av_set_video_mode(u32 id, int boo
 
 EXPORT_SYMBOL_GPL(ps3av_set_video_mode);
 
-int ps3av_get_auto_mode(int boot)
+int ps3av_get_auto_mode(void)
 {
-	return ps3av_auto_videomode(&ps3av->av_hw_conf, boot);
+	return ps3av_auto_videomode(&ps3av->av_hw_conf);
 }
 
 EXPORT_SYMBOL_GPL(ps3av_get_auto_mode);
@@ -1044,7 +1021,7 @@ static int ps3av_probe(struct ps3_system
 		       res);
 
 	ps3av_get_hw_conf(ps3av);
-	id = ps3av_auto_videomode(&ps3av->av_hw_conf, 1);
+	id = ps3av_auto_videomode(&ps3av->av_hw_conf);
 	mutex_lock(&ps3av->mutex);
 	ps3av->ps3av_mode = id;
 	mutex_unlock(&ps3av->mutex);
diff -puN drivers/video/ps3fb.c~ps3av-dont-distinguish-between-boot-and-non-boot-autodetection drivers/video/ps3fb.c
--- a/drivers/video/ps3fb.c~ps3av-dont-distinguish-between-boot-and-non-boot-autodetection
+++ a/drivers/video/ps3fb.c
@@ -548,7 +548,6 @@ static int ps3fb_set_par(struct fb_info 
 	unsigned int mode;
 	int i;
 	unsigned long offset;
-	static int first = 1;
 
 	DPRINTK("xres:%d xv:%d yres:%d yv:%d clock:%d\n",
 		info->var.xres, info->var.xres_virtual,
@@ -572,10 +571,9 @@ static int ps3fb_set_par(struct fb_info 
 	/* Keep the special bits we cannot set using fb_var_screeninfo */
 	ps3fb_mode = (ps3fb_mode & ~PS3AV_MODE_MASK) | mode;
 
-	if (ps3av_set_video_mode(ps3fb_mode, first))
+	if (ps3av_set_video_mode(ps3fb_mode))
 		return -EINVAL;
 
-	first = 0;
 	return 0;
 }
 
@@ -737,7 +735,7 @@ static int ps3fb_ioctl(struct fb_info *i
 				break;
 
 			if (!(val & PS3AV_MODE_MASK)) {
-				u32 id = ps3av_get_auto_mode(0);
+				u32 id = ps3av_get_auto_mode();
 				if (id > 0)
 					val = (val & ~PS3AV_MODE_MASK) | id;
 			}
diff -puN include/asm-powerpc/ps3av.h~ps3av-dont-distinguish-between-boot-and-non-boot-autodetection include/asm-powerpc/ps3av.h
--- a/include/asm-powerpc/ps3av.h~ps3av-dont-distinguish-between-boot-and-non-boot-autodetection
+++ a/include/asm-powerpc/ps3av.h
@@ -709,9 +709,9 @@ extern int ps3av_cmd_av_get_hw_conf(stru
 extern int ps3av_cmd_video_get_monitor_info(struct ps3av_pkt_av_get_monitor_info *,
 					    u32);
 
-extern int ps3av_set_video_mode(u32, int);
+extern int ps3av_set_video_mode(u32);
 extern int ps3av_set_audio_mode(u32, u32, u32, u32, u32);
-extern int ps3av_get_auto_mode(int);
+extern int ps3av_get_auto_mode(void);
 extern int ps3av_get_mode(void);
 extern int ps3av_get_scanmode(int);
 extern int ps3av_get_refresh_rate(int);
_

Patches currently in -mm which might be from Geert.Uytterhoeven@sonycom.com are

git-powerpc.patch
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
