From: akpm@linux-foundation.org
Subject: + ps3av-treat-dvi-d-like-hdmi-in-autodetect.patch added to -mm tree
Date: Wed, 03 Oct 2007 13:53:18 -0700
Message-ID: <200710032053.l93KrIHa008090@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49654 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756271AbXJCUxW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Oct 2007 16:53:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: Geert.Uytterhoeven@sonycom.com, adaplas@gmail.com


The patch titled
     ps3av: treat DVI-D like HDMI in autodetect
has been added to the -mm tree.  Its filename is
     ps3av-treat-dvi-d-like-hdmi-in-autodetect.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: ps3av: treat DVI-D like HDMI in autodetect
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>

treat DVI-D monitors like HDMI monitors when autodetecting the best video mode

Signed-off-by: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Signed-off-by: Antonino Daplas <adaplas@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN drivers/ps3/ps3av.c~ps3av-treat-dvi-d-like-hdmi-in-autodetect drivers/ps3/ps3av.c
--- a/drivers/ps3/ps3av.c~ps3av-treat-dvi-d-like-hdmi-in-autodetect
+++ a/drivers/ps3/ps3av.c
@@ -620,9 +620,6 @@ static int ps3av_hdmi_get_id(struct ps3a
 	u32 res_50, res_60;
 	int id;
 
-	if (info->monitor_type != PS3AV_MONITOR_TYPE_HDMI)
-		return 0;
-
 	/* check native resolution */
 	res_50 = info->res_50.native & PS3AV_RES_MASK_50;
 	res_60 = info->res_60.native & PS3AV_RES_MASK_60;
@@ -712,7 +709,7 @@ static int ps3av_auto_videomode(struct p
 	struct ps3av_info_monitor *info;
 
 	/* get mode id for hdmi */
-	for (i = 0; i < av_hw_conf->num_of_hdmi; i++) {
+	for (i = 0; i < av_hw_conf->num_of_hdmi && !id; i++) {
 		res = ps3av_cmd_video_get_monitor_info(&monitor_info,
 						       PS3AV_CMD_AVPORT_HDMI_0 +
 						       i);
@@ -720,24 +717,19 @@ static int ps3av_auto_videomode(struct p
 			return -1;
 
 		ps3av_monitor_info_dump(&monitor_info);
+
 		info = &monitor_info.info;
-		/* check DVI */
-		if (info->monitor_type == PS3AV_MONITOR_TYPE_DVI) {
+		switch (info->monitor_type) {
+		case PS3AV_MONITOR_TYPE_DVI:
 			dvi = PS3AV_MODE_DVI;
-			break;
-		}
-		/* check HDMI */
-		id = ps3av_hdmi_get_id(info);
-		if (id) {
-			/* got valid mode id */
+			/* fall through */
+		case PS3AV_MONITOR_TYPE_HDMI:
+			id = ps3av_hdmi_get_id(info);
 			break;
 		}
 	}
 
-	if (dvi) {
-		/* DVI mode */
-		id = PS3AV_DEFAULT_DVI_MODE_ID;
-	} else if (!id) {
+	if (!id) {
 		/* no HDMI interface or HDMI is off */
 		if (ps3av->region & PS3AV_REGION_60)
 			id = PS3AV_DEFAULT_AVMULTI_MODE_ID_REG_60;
diff -puN include/asm-powerpc/ps3av.h~ps3av-treat-dvi-d-like-hdmi-in-autodetect include/asm-powerpc/ps3av.h
--- a/include/asm-powerpc/ps3av.h~ps3av-treat-dvi-d-like-hdmi-in-autodetect
+++ a/include/asm-powerpc/ps3av.h
@@ -305,7 +305,6 @@
 #define PS3AV_DEFAULT_AVMULTI_MODE_ID_REG_60	1	/* 480i */
 #define PS3AV_DEFAULT_HDMI_MODE_ID_REG_50	7	/* 576p */
 #define PS3AV_DEFAULT_AVMULTI_MODE_ID_REG_50	6	/* 576i */
-#define PS3AV_DEFAULT_DVI_MODE_ID		2	/* 480p */
 
 #define PS3AV_REGION_60				0x01
 #define PS3AV_REGION_50				0x02
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
