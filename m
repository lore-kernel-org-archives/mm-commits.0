From: akpm@linux-foundation.org
Subject: + ps3av-eliminate-ps3av_debug.patch added to -mm tree
Date: Wed, 03 Oct 2007 13:53:09 -0700
Message-ID: <200710032053.l93Kr9Kk008083@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49434 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755880AbXJCUxQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Oct 2007 16:53:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: Geert.Uytterhoeven@sonycom.com, adaplas@gmail.com


The patch titled
     ps3av: eliminate PS3AV_DEBUG
has been added to the -mm tree.  Its filename is
     ps3av-eliminate-ps3av_debug.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: ps3av: eliminate PS3AV_DEBUG
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>

ps3av: eliminate PS3AV_DEBUG
  - Move ps3av_cmd_av_monitor_info_dump from ps3av_cmd.c to ps3av.c, as
it's
    used there only
  - Integrate ps3av_cmd_av_hw_conf_dump() into its sole user
  - Use pr_debug() for printing debug info

Signed-off-by: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Signed-off-by: Antonino Daplas <adaplas@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN drivers/ps3/ps3av.c~ps3av-eliminate-ps3av_debug drivers/ps3/ps3av.c
--- a/drivers/ps3/ps3av.c~ps3av-eliminate-ps3av_debug
+++ a/drivers/ps3/ps3av.c
@@ -656,6 +656,64 @@ static int ps3av_hdmi_get_vid(struct ps3
 	return vid;
 }
 
+static void ps3av_monitor_info_dump(const struct ps3av_pkt_av_get_monitor_info *monitor_info)
+{
+	const struct ps3av_info_monitor *info = &monitor_info->info;
+	const struct ps3av_info_audio *audio = info->audio;
+	char id[sizeof(info->monitor_id)*3+1];
+	int i;
+
+	pr_debug("Monitor Info: size %u\n", monitor_info->send_hdr.size);
+
+	pr_debug("avport: %02x\n", info->avport);
+	for (i = 0; i < sizeof(info->monitor_id); i++)
+		sprintf(&id[i*3], " %02x", info->monitor_id[i]);
+	pr_debug("monitor_id: %s\n", id);
+	pr_debug("monitor_type: %02x\n", info->monitor_type);
+	pr_debug("monitor_name: %.*s\n", (int)sizeof(info->monitor_name),
+		 info->monitor_name);
+
+	/* resolution */
+	pr_debug("resolution_60: bits: %08x native: %08x\n",
+		 info->res_60.res_bits, info->res_60.native);
+	pr_debug("resolution_50: bits: %08x native: %08x\n",
+		 info->res_50.res_bits, info->res_50.native);
+	pr_debug("resolution_other: bits: %08x native: %08x\n",
+		 info->res_other.res_bits, info->res_other.native);
+	pr_debug("resolution_vesa: bits: %08x native: %08x\n",
+		 info->res_vesa.res_bits, info->res_vesa.native);
+
+	/* color space */
+	pr_debug("color space    rgb: %02x\n", info->cs.rgb);
+	pr_debug("color space yuv444: %02x\n", info->cs.yuv444);
+	pr_debug("color space yuv422: %02x\n", info->cs.yuv422);
+
+	/* color info */
+	pr_debug("color info   red: X %04x Y %04x\n", info->color.red_x,
+		 info->color.red_y);
+	pr_debug("color info green: X %04x Y %04x\n", info->color.green_x,
+		 info->color.green_y);
+	pr_debug("color info  blue: X %04x Y %04x\n", info->color.blue_x,
+		 info->color.blue_y);
+	pr_debug("color info white: X %04x Y %04x\n", info->color.white_x,
+		 info->color.white_y);
+	pr_debug("color info gamma:  %08x\n", info->color.gamma);
+
+	/* other info */
+	pr_debug("supported_AI: %02x\n", info->supported_ai);
+	pr_debug("speaker_info: %02x\n", info->speaker_info);
+	pr_debug("num of audio: %02x\n", info->num_of_audio_block);
+
+	/* audio block */
+	for (i = 0; i < info->num_of_audio_block; i++) {
+		pr_debug("audio[%d] type: %02x max_ch: %02x fs: %02x sbit: "
+			 "%02x\n",
+			 i, audio->type, audio->max_num_of_ch, audio->fs,
+			 audio->sbit);
+		audio++;
+	}
+}
+
 static int ps3av_auto_videomode(struct ps3av_pkt_av_get_hw_conf *av_hw_conf,
 				int boot)
 {
@@ -671,7 +729,7 @@ static int ps3av_auto_videomode(struct p
 		if (res < 0)
 			return -1;
 
-		ps3av_cmd_av_monitor_info_dump(&monitor_info);
+		ps3av_monitor_info_dump(&monitor_info);
 		info = &monitor_info.info;
 		/* check DVI */
 		if (info->monitor_type == PS3AV_MONITOR_TYPE_DVI) {
@@ -727,23 +785,27 @@ static int ps3av_auto_videomode(struct p
 static int ps3av_get_hw_conf(struct ps3av *ps3av)
 {
 	int i, j, k, res;
+	const struct ps3av_pkt_av_get_hw_conf *hw_conf;
 
 	/* get av_hw_conf */
 	res = ps3av_cmd_av_get_hw_conf(&ps3av->av_hw_conf);
 	if (res < 0)
 		return -1;
 
-	ps3av_cmd_av_hw_conf_dump(&ps3av->av_hw_conf);
+	hw_conf = &ps3av->av_hw_conf;
+	pr_debug("av_h_conf: num of hdmi: %u\n", hw_conf->num_of_hdmi);
+	pr_debug("av_h_conf: num of avmulti: %u\n", hw_conf->num_of_avmulti);
+	pr_debug("av_h_conf: num of spdif: %u\n", hw_conf->num_of_spdif);
 
 	for (i = 0; i < PS3AV_HEAD_MAX; i++)
 		ps3av->head[i] = PS3AV_CMD_VIDEO_HEAD_A + i;
 	for (i = 0; i < PS3AV_OPT_PORT_MAX; i++)
 		ps3av->opt_port[i] = PS3AV_CMD_AVPORT_SPDIF_0 + i;
-	for (i = 0; i < ps3av->av_hw_conf.num_of_hdmi; i++)
+	for (i = 0; i < hw_conf->num_of_hdmi; i++)
 		ps3av->av_port[i] = PS3AV_CMD_AVPORT_HDMI_0 + i;
-	for (j = 0; j < ps3av->av_hw_conf.num_of_avmulti; j++)
+	for (j = 0; j < hw_conf->num_of_avmulti; j++)
 		ps3av->av_port[i + j] = PS3AV_CMD_AVPORT_AVMULTI_0 + j;
-	for (k = 0; k < ps3av->av_hw_conf.num_of_spdif; k++)
+	for (k = 0; k < hw_conf->num_of_spdif; k++)
 		ps3av->av_port[i + j + k] = PS3AV_CMD_AVPORT_SPDIF_0 + k;
 
 	/* set all audio port */
diff -puN drivers/ps3/ps3av_cmd.c~ps3av-eliminate-ps3av_debug drivers/ps3/ps3av_cmd.c
--- a/drivers/ps3/ps3av_cmd.c~ps3av-eliminate-ps3av_debug
+++ a/drivers/ps3/ps3av_cmd.c
@@ -922,72 +922,6 @@ int ps3av_cmd_video_get_monitor_info(str
 	return res;
 }
 
-#ifdef PS3AV_DEBUG
-void ps3av_cmd_av_hw_conf_dump(const struct ps3av_pkt_av_get_hw_conf *hw_conf)
-{
-	printk("av_h_conf:num of hdmi:%d\n", hw_conf->num_of_hdmi);
-	printk("av_h_conf:num of avmulti:%d\n", hw_conf->num_of_avmulti);
-	printk("av_h_conf:num of spdif:%d\n", hw_conf->num_of_spdif);
-}
-
-void ps3av_cmd_av_monitor_info_dump(const struct ps3av_pkt_av_get_monitor_info *monitor_info)
-{
-	const struct ps3av_info_monitor *info = &monitor_info->info;
-	const struct ps3av_info_audio *audio = info->audio;
-	int i;
-
-	printk("Monitor Info: size%d\n", monitor_info->send_hdr.size);
-
-	printk("avport:%02x\n", info->avport);
-	printk("monitor_id:");
-	for (i = 0; i < 10; i++)
-		printk("%02x ", info->monitor_id[i]);
-	printk("\nmonitor_type:%02x\n", info->monitor_type);
-	printk("monitor_name:");
-	for (i = 0; i < 16; i++)
-		printk("%c", info->monitor_name[i]);
-
-	/* resolution */
-	printk("\nresolution_60: bits:%08x native:%08x\n",
-	       info->res_60.res_bits, info->res_60.native);
-	printk("resolution_50: bits:%08x native:%08x\n",
-	       info->res_50.res_bits, info->res_50.native);
-	printk("resolution_other: bits:%08x native:%08x\n",
-	       info->res_other.res_bits, info->res_other.native);
-	printk("resolution_vesa: bits:%08x native:%08x\n",
-	       info->res_vesa.res_bits, info->res_vesa.native);
-
-	/* color space */
-	printk("color space    rgb:%02x\n", info->cs.rgb);
-	printk("color space yuv444:%02x\n", info->cs.yuv444);
-	printk("color space yuv422:%02x\n", info->cs.yuv422);
-
-	/* color info */
-	printk("color info   red:X %04x Y %04x\n",
-	       info->color.red_x, info->color.red_y);
-	printk("color info green:X %04x Y %04x\n",
-	       info->color.green_x, info->color.green_y);
-	printk("color info  blue:X %04x Y %04x\n",
-	       info->color.blue_x, info->color.blue_y);
-	printk("color info white:X %04x Y %04x\n",
-	       info->color.white_x, info->color.white_y);
-	printk("color info gamma: %08x\n", info->color.gamma);
-
-	/* other info */
-	printk("supported_AI:%02x\n", info->supported_ai);
-	printk("speaker_info:%02x\n", info->speaker_info);
-	printk("num of audio:%02x\n", info->num_of_audio_block);
-
-	/* audio block */
-	for (i = 0; i < info->num_of_audio_block; i++) {
-		printk("audio[%d] type:%02x max_ch:%02x fs:%02x sbit:%02x\n",
-		       i, audio->type, audio->max_num_of_ch, audio->fs,
-		       audio->sbit);
-		audio++;
-	}
-}
-#endif /* PS3AV_DEBUG */
-
 #define PS3AV_AV_LAYOUT_0 (PS3AV_CMD_AV_LAYOUT_32 \
 		| PS3AV_CMD_AV_LAYOUT_44 \
 		| PS3AV_CMD_AV_LAYOUT_48)
diff -puN include/asm-powerpc/ps3av.h~ps3av-eliminate-ps3av_debug include/asm-powerpc/ps3av.h
--- a/include/asm-powerpc/ps3av.h~ps3av-eliminate-ps3av_debug
+++ a/include/asm-powerpc/ps3av.h
@@ -697,13 +697,6 @@ extern int ps3av_cmd_audio_mute(int, u32
 extern int ps3av_cmd_audio_active(int, u32);
 extern int ps3av_cmd_avb_param(struct ps3av_pkt_avb_param *, u32);
 extern int ps3av_cmd_av_get_hw_conf(struct ps3av_pkt_av_get_hw_conf *);
-#ifdef PS3AV_DEBUG
-extern void ps3av_cmd_av_hw_conf_dump(const struct ps3av_pkt_av_get_hw_conf *);
-extern void ps3av_cmd_av_monitor_info_dump(const struct ps3av_pkt_av_get_monitor_info *);
-#else
-static inline void ps3av_cmd_av_hw_conf_dump(const struct ps3av_pkt_av_get_hw_conf *hw_conf) {}
-static inline void ps3av_cmd_av_monitor_info_dump(const struct ps3av_pkt_av_get_monitor_info *monitor_info) {}
-#endif
 extern int ps3av_cmd_video_get_monitor_info(struct ps3av_pkt_av_get_monitor_info *,
 					    u32);
 
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
