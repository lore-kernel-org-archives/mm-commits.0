From: akpm@linux-foundation.org
Subject: - ps3-fix-black-and-white-stripes.patch removed from -mm tree
Date: Tue, 16 Oct 2007 13:44:18 -0700
Message-ID: <200710162044.l9GKiIBu016134@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35188 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965372AbXJPVcO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 17:32:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Masashi_Kimoto@hq.scei.sony.co.jp, Geert.Uytterhoeven@sonycom.com, adaplas@gmail.com, geoffrey.levand@am.sony.com, mm-commits@vger.kernel.org


The patch titled
     ps3: Fix black and white stripes
has been removed from the -mm tree.  Its filename was
     ps3-fix-black-and-white-stripes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: ps3: Fix black and white stripes
From: Masashi Kimoto <Masashi_Kimoto@hq.scei.sony.co.jp>

Fix the black and white stripes issue with WUXGA monitor via HDMI.

It seems that when we use a VESA resolution from boot up, the AV settings
driver could not be initialized correctly.  In that case we need a dummy
packet before VESA setting.

[Geert] Refactored to reduce code duplication.

Signed-off-by: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
CC: Geoff Levand <geoffrey.levand@am.sony.com>
Signed-off-by: Antonino Daplas <adaplas@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ps3/ps3av.c |   58 +++++++++++++++++++++++++++---------------
 1 file changed, 38 insertions(+), 20 deletions(-)

diff -puN drivers/ps3/ps3av.c~ps3-fix-black-and-white-stripes drivers/ps3/ps3av.c
--- a/drivers/ps3/ps3av.c~ps3-fix-black-and-white-stripes
+++ a/drivers/ps3/ps3av.c
@@ -491,10 +491,10 @@ static int ps3av_set_videomode(void)
 	return 0;
 }
 
-static void ps3av_set_videomode_cont(u32 id, u32 old_id)
+static void ps3av_set_videomode_packet(u32 id)
 {
 	struct ps3av_pkt_avb_param avb_param;
-	int i;
+	unsigned int i;
 	u32 len = 0, av_video_cs;
 	const struct avset_video_mode *video_mode;
 	int res;
@@ -507,24 +507,6 @@ static void ps3av_set_videomode_cont(u32
 					ps3av->av_hw_conf.num_of_avmulti;
 	avb_param.num_of_av_audio_pkt = 0;
 
-	/* video signal off */
-	ps3av_set_video_disable_sig();
-
-	/* Retail PS3 product doesn't support this */
-	if (id & PS3AV_MODE_HDCP_OFF) {
-		res = ps3av_cmd_av_hdmi_mode(PS3AV_CMD_AV_HDMI_HDCP_OFF);
-		if (res == PS3AV_STATUS_UNSUPPORTED_HDMI_MODE)
-			dev_dbg(&ps3av->dev->core, "Not supported\n");
-		else if (res)
-			dev_dbg(&ps3av->dev->core,
-				"ps3av_cmd_av_hdmi_mode failed\n");
-	} else if (old_id & PS3AV_MODE_HDCP_OFF) {
-		res = ps3av_cmd_av_hdmi_mode(PS3AV_CMD_AV_HDMI_MODE_NORMAL);
-		if (res < 0 && res != PS3AV_STATUS_UNSUPPORTED_HDMI_MODE)
-			dev_dbg(&ps3av->dev->core,
-				"ps3av_cmd_av_hdmi_mode failed\n");
-	}
-
 	/* video_pkt */
 	for (i = 0; i < avb_param.num_of_video_pkt; i++)
 		len += ps3av_cmd_set_video_mode(&avb_param.buf[len],
@@ -555,6 +537,42 @@ static void ps3av_set_videomode_cont(u32
 		       __func__);
 	else if (res)
 		dev_dbg(&ps3av->dev->core, "ps3av_cmd_avb_param failed\n");
+}
+
+static void ps3av_set_videomode_cont(u32 id, u32 old_id)
+{
+	static int vesa = 0;
+	int res;
+
+	/* video signal off */
+	ps3av_set_video_disable_sig();
+
+	/*
+	 * AV backend needs non-VESA mode setting at least one time
+	 * when VESA mode is used.
+	 */
+	if (vesa == 0 && (id & PS3AV_MODE_MASK) >= 11) {
+		/* vesa mode */
+		ps3av_set_videomode_packet(2);	/* 480P */
+	}
+	vesa = 1;
+
+	/* Retail PS3 product doesn't support this */
+	if (id & PS3AV_MODE_HDCP_OFF) {
+		res = ps3av_cmd_av_hdmi_mode(PS3AV_CMD_AV_HDMI_HDCP_OFF);
+		if (res == PS3AV_STATUS_UNSUPPORTED_HDMI_MODE)
+			dev_dbg(&ps3av->dev->core, "Not supported\n");
+		else if (res)
+			dev_dbg(&ps3av->dev->core,
+				"ps3av_cmd_av_hdmi_mode failed\n");
+	} else if (old_id & PS3AV_MODE_HDCP_OFF) {
+		res = ps3av_cmd_av_hdmi_mode(PS3AV_CMD_AV_HDMI_MODE_NORMAL);
+		if (res < 0 && res != PS3AV_STATUS_UNSUPPORTED_HDMI_MODE)
+			dev_dbg(&ps3av->dev->core,
+				"ps3av_cmd_av_hdmi_mode failed\n");
+	}
+
+	ps3av_set_videomode_packet(id);
 
 	msleep(1500);
 	/* av video mute */
_

Patches currently in -mm which might be from Masashi_Kimoto@hq.scei.sony.co.jp are

origin.patch
