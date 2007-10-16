From: akpm@linux-foundation.org
Subject: - ps3av-add-autodetection-for-vesa-modes.patch removed from -mm tree
Date: Tue, 16 Oct 2007 13:45:14 -0700
Message-ID: <200710162045.l9GKjE5v016243@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55752 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965776AbXJPU5A (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 16:57:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Geert.Uytterhoeven@sonycom.com, adaplas@gmail.com, mm-commits@vger.kernel.org


The patch titled
     ps3av: add autodetection for VESA modes
has been removed from the -mm tree.  Its filename was
     ps3av-add-autodetection-for-vesa-modes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: ps3av: add autodetection for VESA modes
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>

add autodetection for VESA modes

Signed-off-by: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Signed-off-by: Antonino Daplas <adaplas@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ps3/ps3av.c         |   93 ++++++++++++++++++++--------------
 include/asm-powerpc/ps3av.h |   11 +++-
 2 files changed, 67 insertions(+), 37 deletions(-)

diff -puN drivers/ps3/ps3av.c~ps3av-add-autodetection-for-vesa-modes drivers/ps3/ps3av.c
--- a/drivers/ps3/ps3av.c~ps3av-add-autodetection-for-vesa-modes
+++ a/drivers/ps3/ps3av.c
@@ -585,54 +585,73 @@ static void ps3avd(struct work_struct *w
 	complete(&ps3av->done);
 }
 
-static int ps3av_resbit2id(u32 res_50, u32 res_60)
+#define SHIFT_50	0
+#define SHIFT_60	4
+#define SHIFT_VESA	8
+
+static const struct {
+	unsigned mask : 19;
+	unsigned id :  4;
+} ps3av_preferred_modes[] = {
+	{ .mask = PS3AV_RESBIT_WUXGA		<< SHIFT_VESA,	.id = 13 },
+	{ .mask = PS3AV_RESBIT_1920x1080P	<< SHIFT_60,	.id = 5 },
+	{ .mask = PS3AV_RESBIT_1920x1080P	<< SHIFT_50,	.id = 10 },
+	{ .mask = PS3AV_RESBIT_1920x1080I	<< SHIFT_60,	.id = 4 },
+	{ .mask = PS3AV_RESBIT_1920x1080I	<< SHIFT_50,	.id = 9 },
+	{ .mask = PS3AV_RESBIT_SXGA		<< SHIFT_VESA,	.id = 12 },
+	{ .mask = PS3AV_RESBIT_WXGA		<< SHIFT_VESA,	.id = 11 },
+	{ .mask = PS3AV_RESBIT_1280x720P	<< SHIFT_60,	.id = 3 },
+	{ .mask = PS3AV_RESBIT_1280x720P	<< SHIFT_50,	.id = 8 },
+	{ .mask = PS3AV_RESBIT_720x480P		<< SHIFT_60,	.id = 2 },
+	{ .mask = PS3AV_RESBIT_720x576P		<< SHIFT_50,	.id = 7 },
+};
+
+static int ps3av_resbit2id(u32 res_50, u32 res_60, u32 res_vesa)
 {
-	int id = 0;
+	unsigned int i;
+	u32 res_all;
 
-	if (res_50 > res_60) {	/* if res_50 == res_60, res_60 will be used */
-		if (res_50 & PS3AV_RESBIT_1920x1080P)
-			id = 10;
-		else if (res_50 & PS3AV_RESBIT_1920x1080I)
-			id = 9;
-		else if (res_50 & PS3AV_RESBIT_1280x720P)
-			id = 8;
-		else if (res_50 & PS3AV_RESBIT_720x576P)
-			id = 7;
-		else
-			id = 0;
-	} else {
-		if (res_60 & PS3AV_RESBIT_1920x1080P)
-			id = 5;
-		else if (res_60 & PS3AV_RESBIT_1920x1080I)
-			id = 4;
-		else if (res_60 & PS3AV_RESBIT_1280x720P)
-			id = 3;
-		else if (res_60 & PS3AV_RESBIT_720x480P)
-			id = 2;
-		else
-			id = 0;
-	}
-	return id;
+	/*
+	 * We mask off the resolution bits we care about and combine the
+	 * results in one bitfield, so make sure there's no overlap
+	 */
+	BUILD_BUG_ON(PS3AV_RES_MASK_50 << SHIFT_50 &
+		     PS3AV_RES_MASK_60 << SHIFT_60);
+	BUILD_BUG_ON(PS3AV_RES_MASK_50 << SHIFT_50 &
+		     PS3AV_RES_MASK_VESA << SHIFT_VESA);
+	BUILD_BUG_ON(PS3AV_RES_MASK_60 << SHIFT_60 &
+		     PS3AV_RES_MASK_VESA << SHIFT_VESA);
+	res_all = (res_50 & PS3AV_RES_MASK_50) << SHIFT_50 |
+		  (res_60 & PS3AV_RES_MASK_60) << SHIFT_60 |
+		  (res_vesa & PS3AV_RES_MASK_VESA) << SHIFT_VESA;
+
+	if (!res_all)
+		return 0;
+
+	for (i = 0; i < ARRAY_SIZE(ps3av_preferred_modes); i++)
+		if (res_all & ps3av_preferred_modes[i].mask)
+			return ps3av_preferred_modes[i].id;
+
+	return 0;
 }
 
 static int ps3av_hdmi_get_id(struct ps3av_info_monitor *info)
 {
-	u32 res_50, res_60;
 	int id;
 
 	/* check native resolution */
-	res_50 = info->res_50.native & PS3AV_RES_MASK_50;
-	res_60 = info->res_60.native & PS3AV_RES_MASK_60;
-	if (res_50 || res_60) {
-		id = ps3av_resbit2id(res_50, res_60);
+	id = ps3av_resbit2id(info->res_50.native, info->res_60.native,
+			     info->res_vesa.native);
+	if (id) {
+		pr_debug("%s: Using native mode %d\n", __func__, id);
 		return id;
 	}
 
-	/* check resolution */
-	res_50 = info->res_50.res_bits & PS3AV_RES_MASK_50;
-	res_60 = info->res_60.res_bits & PS3AV_RES_MASK_60;
-	if (res_50 || res_60) {
-		id = ps3av_resbit2id(res_50, res_60);
+	/* check supported resolutions */
+	id = ps3av_resbit2id(info->res_50.res_bits, info->res_60.res_bits,
+			     info->res_vesa.res_bits);
+	if (id) {
+		pr_debug("%s: Using supported mode %d\n", __func__, id);
 		return id;
 	}
 
@@ -640,6 +659,7 @@ static int ps3av_hdmi_get_id(struct ps3a
 		id = PS3AV_DEFAULT_HDMI_MODE_ID_REG_60;
 	else
 		id = PS3AV_DEFAULT_HDMI_MODE_ID_REG_50;
+	pr_debug("%s: Using default mode %d\n", __func__, id);
 	return id;
 }
 
@@ -737,6 +757,7 @@ static int ps3av_auto_videomode(struct p
 			id = PS3AV_DEFAULT_AVMULTI_MODE_ID_REG_50;
 		if (ps3av->region & PS3AV_REGION_RGB)
 			rgb = PS3AV_MODE_RGB;
+		pr_debug("%s: Using avmulti mode %d\n", __func__, id);
 	} else if (boot) {
 		/* HDMI: using DEFAULT HDMI_MODE_ID while booting up */
 		info = &monitor_info.info;
diff -puN include/asm-powerpc/ps3av.h~ps3av-add-autodetection-for-vesa-modes include/asm-powerpc/ps3av.h
--- a/include/asm-powerpc/ps3av.h~ps3av-add-autodetection-for-vesa-modes
+++ a/include/asm-powerpc/ps3av.h
@@ -283,7 +283,7 @@
 #define PS3AV_CMD_VIDEO_CS_YUV422			0x0002
 #define PS3AV_CMD_VIDEO_CS_YUV444			0x0003
 
-/* for automode */
+/* for broadcast automode */
 #define PS3AV_RESBIT_720x480P			0x0003	/* 0x0001 | 0x0002 */
 #define PS3AV_RESBIT_720x576P			0x0003	/* 0x0001 | 0x0002 */
 #define PS3AV_RESBIT_1280x720P			0x0004
@@ -298,6 +298,15 @@
 						| PS3AV_RESBIT_1920x1080I \
 						| PS3AV_RESBIT_1920x1080P)
 
+/* for VESA automode */
+#define PS3AV_RESBIT_VGA			0x0001
+#define PS3AV_RESBIT_WXGA			0x0002
+#define PS3AV_RESBIT_SXGA			0x0004
+#define PS3AV_RESBIT_WUXGA			0x0008
+#define PS3AV_RES_MASK_VESA			(PS3AV_RESBIT_WXGA |\
+						 PS3AV_RESBIT_SXGA |\
+						 PS3AV_RESBIT_WUXGA)
+
 #define PS3AV_MONITOR_TYPE_HDMI			1	/* HDMI */
 #define PS3AV_MONITOR_TYPE_DVI			2	/* DVI */
 
_

Patches currently in -mm which might be from Geert.Uytterhoeven@sonycom.com are

origin.patch
