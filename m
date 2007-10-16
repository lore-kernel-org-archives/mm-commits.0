From: akpm@linux-foundation.org
Subject: - ps3av-use-ps3-video-mode-ids-in-autodetect-code.patch removed from -mm tree
Date: Tue, 16 Oct 2007 13:45:10 -0700
Message-ID: <200710162045.l9GKjATO016237@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45075 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965804AbXJPU5H (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 16:57:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Geert.Uytterhoeven@sonycom.com, adaplas@gmail.com, mm-commits@vger.kernel.org


The patch titled
     ps3av: use PS3 video mode ids in autodetect code
has been removed from the -mm tree.  Its filename was
     ps3av-use-ps3-video-mode-ids-in-autodetect-code.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: ps3av: use PS3 video mode ids in autodetect code
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>

It doesn't make much sense to use the PS3AV_CMD_VIDEO_VID_* values in the
autodetection code, just to convert them to PS3 video mode ids afterwards.

Signed-off-by: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Signed-off-by: Antonino Daplas <adaplas@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ps3/ps3av.c         |   90 +++++++++++++++-------------------
 include/asm-powerpc/ps3av.h |   11 ++--
 2 files changed, 46 insertions(+), 55 deletions(-)

diff -puN drivers/ps3/ps3av.c~ps3av-use-ps3-video-mode-ids-in-autodetect-code drivers/ps3/ps3av.c
--- a/drivers/ps3/ps3av.c~ps3av-use-ps3-video-mode-ids-in-autodetect-code
+++ a/drivers/ps3/ps3av.c
@@ -585,75 +585,65 @@ static void ps3avd(struct work_struct *w
 	complete(&ps3av->done);
 }
 
-static int ps3av_vid2table_id(int vid)
+static int ps3av_resbit2id(u32 res_50, u32 res_60)
 {
-	int i;
-
-	for (i = 1; i < ARRAY_SIZE(video_mode_table); i++)
-		if (video_mode_table[i].vid == vid)
-			return i;
-	return -1;
-}
-
-static int ps3av_resbit2vid(u32 res_50, u32 res_60)
-{
-	int vid = -1;
+	int id = 0;
 
 	if (res_50 > res_60) {	/* if res_50 == res_60, res_60 will be used */
 		if (res_50 & PS3AV_RESBIT_1920x1080P)
-			vid = PS3AV_CMD_VIDEO_VID_1080P_50HZ;
+			id = 10;
 		else if (res_50 & PS3AV_RESBIT_1920x1080I)
-			vid = PS3AV_CMD_VIDEO_VID_1080I_50HZ;
+			id = 9;
 		else if (res_50 & PS3AV_RESBIT_1280x720P)
-			vid = PS3AV_CMD_VIDEO_VID_720P_50HZ;
+			id = 8;
 		else if (res_50 & PS3AV_RESBIT_720x576P)
-			vid = PS3AV_CMD_VIDEO_VID_576P;
+			id = 7;
 		else
-			vid = -1;
+			id = 0;
 	} else {
 		if (res_60 & PS3AV_RESBIT_1920x1080P)
-			vid = PS3AV_CMD_VIDEO_VID_1080P_60HZ;
+			id = 5;
 		else if (res_60 & PS3AV_RESBIT_1920x1080I)
-			vid = PS3AV_CMD_VIDEO_VID_1080I_60HZ;
+			id = 4;
 		else if (res_60 & PS3AV_RESBIT_1280x720P)
-			vid = PS3AV_CMD_VIDEO_VID_720P_60HZ;
+			id = 3;
 		else if (res_60 & PS3AV_RESBIT_720x480P)
-			vid = PS3AV_CMD_VIDEO_VID_480P;
+			id = 2;
 		else
-			vid = -1;
+			id = 0;
 	}
-	return vid;
+	return id;
 }
 
-static int ps3av_hdmi_get_vid(struct ps3av_info_monitor *info)
+static int ps3av_hdmi_get_id(struct ps3av_info_monitor *info)
 {
 	u32 res_50, res_60;
-	int vid = -1;
+	int id;
 
 	if (info->monitor_type != PS3AV_MONITOR_TYPE_HDMI)
-		return -1;
+		return 0;
 
 	/* check native resolution */
 	res_50 = info->res_50.native & PS3AV_RES_MASK_50;
 	res_60 = info->res_60.native & PS3AV_RES_MASK_60;
 	if (res_50 || res_60) {
-		vid = ps3av_resbit2vid(res_50, res_60);
-		return vid;
+		id = ps3av_resbit2id(res_50, res_60);
+		return id;
 	}
 
 	/* check resolution */
 	res_50 = info->res_50.res_bits & PS3AV_RES_MASK_50;
 	res_60 = info->res_60.res_bits & PS3AV_RES_MASK_60;
 	if (res_50 || res_60) {
-		vid = ps3av_resbit2vid(res_50, res_60);
-		return vid;
+		id = ps3av_resbit2id(res_50, res_60);
+		return id;
 	}
 
 	if (ps3av->region & PS3AV_REGION_60)
-		vid = PS3AV_DEFAULT_HDMI_VID_REG_60;
+		id = PS3AV_DEFAULT_HDMI_MODE_ID_REG_60;
 	else
-		vid = PS3AV_DEFAULT_HDMI_VID_REG_50;
-	return vid;
+		id = PS3AV_DEFAULT_HDMI_MODE_ID_REG_50;
+	return id;
 }
 
 static void ps3av_monitor_info_dump(const struct ps3av_pkt_av_get_monitor_info *monitor_info)
@@ -717,11 +707,11 @@ static void ps3av_monitor_info_dump(cons
 static int ps3av_auto_videomode(struct ps3av_pkt_av_get_hw_conf *av_hw_conf,
 				int boot)
 {
-	int i, res, vid = -1, dvi = 0, rgb = 0;
+	int i, res, id = 0, dvi = 0, rgb = 0;
 	struct ps3av_pkt_av_get_monitor_info monitor_info;
 	struct ps3av_info_monitor *info;
 
-	/* get vid for hdmi */
+	/* get mode id for hdmi */
 	for (i = 0; i < av_hw_conf->num_of_hdmi; i++) {
 		res = ps3av_cmd_video_get_monitor_info(&monitor_info,
 						       PS3AV_CMD_AVPORT_HDMI_0 +
@@ -737,49 +727,49 @@ static int ps3av_auto_videomode(struct p
 			break;
 		}
 		/* check HDMI */
-		vid = ps3av_hdmi_get_vid(info);
-		if (vid != -1) {
-			/* got valid vid */
+		id = ps3av_hdmi_get_id(info);
+		if (id) {
+			/* got valid mode id */
 			break;
 		}
 	}
 
 	if (dvi) {
 		/* DVI mode */
-		vid = PS3AV_DEFAULT_DVI_VID;
-	} else if (vid == -1) {
+		id = PS3AV_DEFAULT_DVI_MODE_ID;
+	} else if (!id) {
 		/* no HDMI interface or HDMI is off */
 		if (ps3av->region & PS3AV_REGION_60)
-			vid = PS3AV_DEFAULT_AVMULTI_VID_REG_60;
+			id = PS3AV_DEFAULT_AVMULTI_MODE_ID_REG_60;
 		else
-			vid = PS3AV_DEFAULT_AVMULTI_VID_REG_50;
+			id = PS3AV_DEFAULT_AVMULTI_MODE_ID_REG_50;
 		if (ps3av->region & PS3AV_REGION_RGB)
 			rgb = PS3AV_MODE_RGB;
 	} else if (boot) {
-		/* HDMI: using DEFAULT HDMI_VID while booting up */
+		/* HDMI: using DEFAULT HDMI_MODE_ID while booting up */
 		info = &monitor_info.info;
 		if (ps3av->region & PS3AV_REGION_60) {
 			if (info->res_60.res_bits & PS3AV_RESBIT_720x480P)
-				vid = PS3AV_DEFAULT_HDMI_VID_REG_60;
+				id = PS3AV_DEFAULT_HDMI_MODE_ID_REG_60;
 			else if (info->res_50.res_bits & PS3AV_RESBIT_720x576P)
-				vid = PS3AV_DEFAULT_HDMI_VID_REG_50;
+				id = PS3AV_DEFAULT_HDMI_MODE_ID_REG_50;
 			else {
 				/* default */
-				vid = PS3AV_DEFAULT_HDMI_VID_REG_60;
+				id = PS3AV_DEFAULT_HDMI_MODE_ID_REG_60;
 			}
 		} else {
 			if (info->res_50.res_bits & PS3AV_RESBIT_720x576P)
-				vid = PS3AV_DEFAULT_HDMI_VID_REG_50;
+				id = PS3AV_DEFAULT_HDMI_MODE_ID_REG_50;
 			else if (info->res_60.res_bits & PS3AV_RESBIT_720x480P)
-				vid = PS3AV_DEFAULT_HDMI_VID_REG_60;
+				id = PS3AV_DEFAULT_HDMI_MODE_ID_REG_60;
 			else {
 				/* default */
-				vid = PS3AV_DEFAULT_HDMI_VID_REG_50;
+				id = PS3AV_DEFAULT_HDMI_MODE_ID_REG_50;
 			}
 		}
 	}
 
-	return (ps3av_vid2table_id(vid) | dvi | rgb);
+	return id | dvi | rgb;
 }
 
 static int ps3av_get_hw_conf(struct ps3av *ps3av)
diff -puN include/asm-powerpc/ps3av.h~ps3av-use-ps3-video-mode-ids-in-autodetect-code include/asm-powerpc/ps3av.h
--- a/include/asm-powerpc/ps3av.h~ps3av-use-ps3-video-mode-ids-in-autodetect-code
+++ a/include/asm-powerpc/ps3av.h
@@ -300,11 +300,12 @@
 
 #define PS3AV_MONITOR_TYPE_HDMI			1	/* HDMI */
 #define PS3AV_MONITOR_TYPE_DVI			2	/* DVI */
-#define PS3AV_DEFAULT_HDMI_VID_REG_60		PS3AV_CMD_VIDEO_VID_480P
-#define PS3AV_DEFAULT_AVMULTI_VID_REG_60	PS3AV_CMD_VIDEO_VID_480I
-#define PS3AV_DEFAULT_HDMI_VID_REG_50		PS3AV_CMD_VIDEO_VID_576P
-#define PS3AV_DEFAULT_AVMULTI_VID_REG_50	PS3AV_CMD_VIDEO_VID_576I
-#define PS3AV_DEFAULT_DVI_VID			PS3AV_CMD_VIDEO_VID_480P
+
+#define PS3AV_DEFAULT_HDMI_MODE_ID_REG_60	2	/* 480p */
+#define PS3AV_DEFAULT_AVMULTI_MODE_ID_REG_60	1	/* 480i */
+#define PS3AV_DEFAULT_HDMI_MODE_ID_REG_50	7	/* 576p */
+#define PS3AV_DEFAULT_AVMULTI_MODE_ID_REG_50	6	/* 576i */
+#define PS3AV_DEFAULT_DVI_MODE_ID		2	/* 480p */
 
 #define PS3AV_REGION_60				0x01
 #define PS3AV_REGION_50				0x02
_

Patches currently in -mm which might be from Geert.Uytterhoeven@sonycom.com are

origin.patch
