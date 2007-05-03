From: akpm@linux-foundation.org
Subject: + ps3av-use-__func__-instead-of-__function__.patch added to -mm tree
Date: Wed, 02 May 2007 23:22:00 -0700
Message-ID: <200705030622.l436M0bQ006242@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:53441 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754570AbXECGWy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 3 May 2007 02:22:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: Geert.Uytterhoeven@sonycom.com, adaplas@pol.net


The patch titled
     ps3av: Use __func__ instead of __FUNCTION__
has been added to the -mm tree.  Its filename is
     ps3av-use-__func__-instead-of-__function__.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: ps3av: Use __func__ instead of __FUNCTION__
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>

ps3av: Replace GNU extension `__FUNCTION__' by C99 `__func__'

Signed-off-by: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ps3/ps3av.c     |   42 ++++++++++++++++++--------------------
 drivers/ps3/ps3av_cmd.c |   20 ++++++++----------
 2 files changed, 29 insertions(+), 33 deletions(-)

diff -puN drivers/ps3/ps3av.c~ps3av-use-__func__-instead-of-__function__ drivers/ps3/ps3av.c
--- a/drivers/ps3/ps3av.c~ps3av-use-__func__-instead-of-__function__
+++ a/drivers/ps3/ps3av.c
@@ -176,7 +176,7 @@ static int ps3av_parse_event_packet(cons
 		else
 			printk(KERN_ERR
 			       "%s: failed event packet, cid:%08x size:%d\n",
-			       __FUNCTION__, hdr->cid, hdr->size);
+			       __func__, hdr->cid, hdr->size);
 		return 1;	/* receive event packet */
 	}
 	return 0;
@@ -198,7 +198,7 @@ static int ps3av_send_cmd_pkt(const stru
 	if (res < 0) {
 		dev_dbg(&ps3av_dev.core,
 			"%s: ps3av_vuart_write() failed (result=%d)\n",
-			__FUNCTION__, res);
+			__func__, res);
 		return res;
 	}
 
@@ -211,7 +211,7 @@ static int ps3av_send_cmd_pkt(const stru
 		if (res != PS3AV_HDR_SIZE) {
 			dev_dbg(&ps3av_dev.core,
 				"%s: ps3av_vuart_read() failed (result=%d)\n",
-				__FUNCTION__, res);
+				__func__, res);
 			return res;
 		}
 
@@ -221,7 +221,7 @@ static int ps3av_send_cmd_pkt(const stru
 		if (res < 0) {
 			dev_dbg(&ps3av_dev.core,
 				"%s: ps3av_vuart_read() failed (result=%d)\n",
-				__FUNCTION__, res);
+				__func__, res);
 			return res;
 		}
 		res += PS3AV_HDR_SIZE;	/* total len */
@@ -231,7 +231,7 @@ static int ps3av_send_cmd_pkt(const stru
 
 	if ((cmd | PS3AV_REPLY_BIT) != recv_buf->cid) {
 		dev_dbg(&ps3av_dev.core, "%s: reply err (result=%x)\n",
-			__FUNCTION__, recv_buf->cid);
+			__func__, recv_buf->cid);
 		return -EINVAL;
 	}
 
@@ -293,7 +293,7 @@ int ps3av_do_pkt(u32 cid, u16 send_len, 
 	if (res < 0) {
 		printk(KERN_ERR
 		       "%s: ps3av_send_cmd_pkt() failed (result=%d)\n",
-		       __FUNCTION__, res);
+		       __func__, res);
 		goto err;
 	}
 
@@ -302,7 +302,7 @@ int ps3av_do_pkt(u32 cid, u16 send_len, 
 					 usr_buf_size);
 	if (res < 0) {
 		printk(KERN_ERR "%s: put_return_status() failed (result=%d)\n",
-		       __FUNCTION__, res);
+		       __func__, res);
 		goto err;
 	}
 
@@ -311,7 +311,7 @@ int ps3av_do_pkt(u32 cid, u16 send_len, 
 
       err:
 	mutex_unlock(&ps3av.mutex);
-	printk(KERN_ERR "%s: failed cid:%x res:%d\n", __FUNCTION__, cid, res);
+	printk(KERN_ERR "%s: failed cid:%x res:%d\n", __func__, cid, res);
 	return res;
 }
 
@@ -522,7 +522,7 @@ static void ps3av_set_videomode_cont(u32
 	if (res == PS3AV_STATUS_NO_SYNC_HEAD)
 		printk(KERN_WARNING
 		       "%s: Command failed. Please try your request again. \n",
-		       __FUNCTION__);
+		       __func__);
 	else if (res)
 		dev_dbg(&ps3av_dev.core, "ps3av_cmd_avb_param failed\n");
 
@@ -715,8 +715,7 @@ int ps3av_set_video_mode(u32 id, int boo
 
 	size = ARRAY_SIZE(video_mode_table);
 	if ((id & PS3AV_MODE_MASK) > size - 1 || id < 0) {
-		dev_dbg(&ps3av_dev.core, "%s: error id :%d\n", __FUNCTION__,
-			id);
+		dev_dbg(&ps3av_dev.core, "%s: error id :%d\n", __func__, id);
 		return -EINVAL;
 	}
 
@@ -725,8 +724,7 @@ int ps3av_set_video_mode(u32 id, int boo
 	if ((id & PS3AV_MODE_MASK) == 0) {
 		id = ps3av_auto_videomode(&ps3av.av_hw_conf, boot);
 		if (id < 1) {
-			printk(KERN_ERR "%s: invalid id :%d\n", __FUNCTION__,
-			       id);
+			printk(KERN_ERR "%s: invalid id :%d\n", __func__, id);
 			return -EINVAL;
 		}
 		id |= option;
@@ -786,7 +784,7 @@ int ps3av_get_scanmode(int id)
 	id = id & PS3AV_MODE_MASK;
 	size = ARRAY_SIZE(video_mode_table);
 	if (id > size - 1 || id < 0) {
-		printk(KERN_ERR "%s: invalid mode %d\n", __FUNCTION__, id);
+		printk(KERN_ERR "%s: invalid mode %d\n", __func__, id);
 		return -EINVAL;
 	}
 	return video_mode_table[id].interlace;
@@ -801,7 +799,7 @@ int ps3av_get_refresh_rate(int id)
 	id = id & PS3AV_MODE_MASK;
 	size = ARRAY_SIZE(video_mode_table);
 	if (id > size - 1 || id < 0) {
-		printk(KERN_ERR "%s: invalid mode %d\n", __FUNCTION__, id);
+		printk(KERN_ERR "%s: invalid mode %d\n", __func__, id);
 		return -EINVAL;
 	}
 	return video_mode_table[id].freq;
@@ -817,7 +815,7 @@ int ps3av_video_mode2res(u32 id, u32 *xr
 	id = id & PS3AV_MODE_MASK;
 	size = ARRAY_SIZE(video_mode_table);
 	if (id > size - 1 || id < 0) {
-		printk(KERN_ERR "%s: invalid mode %d\n", __FUNCTION__, id);
+		printk(KERN_ERR "%s: invalid mode %d\n", __func__, id);
 		return -EINVAL;
 	}
 	*xres = video_mode_table[id].x;
@@ -853,7 +851,7 @@ int ps3av_dev_open(void)
 		status = lv1_gpu_open(0);
 		if (status) {
 			printk(KERN_ERR "%s: lv1_gpu_open failed %d\n",
-			       __FUNCTION__, status);
+			       __func__, status);
 			ps3av.open_count--;
 		}
 	}
@@ -870,13 +868,13 @@ int ps3av_dev_close(void)
 
 	mutex_lock(&ps3av.mutex);
 	if (ps3av.open_count <= 0) {
-		printk(KERN_ERR "%s: GPU already closed\n", __FUNCTION__);
+		printk(KERN_ERR "%s: GPU already closed\n", __func__);
 		status = -1;
 	} else if (!--ps3av.open_count) {
 		status = lv1_gpu_close();
 		if (status)
 			printk(KERN_WARNING "%s: lv1_gpu_close failed %d\n",
-			       __FUNCTION__, status);
+			       __func__, status);
 	}
 	mutex_unlock(&ps3av.mutex);
 
@@ -926,7 +924,7 @@ static int ps3av_probe(struct ps3_vuart_
 	/* init avsetting modules */
 	res = ps3av_cmd_init();
 	if (res < 0)
-		printk(KERN_ERR "%s: ps3av_cmd_init failed %d\n", __FUNCTION__,
+		printk(KERN_ERR "%s: ps3av_cmd_init failed %d\n", __func__,
 		       res);
 
 	ps3av_get_hw_conf(&ps3av);
@@ -978,7 +976,7 @@ static int ps3av_module_init(void)
 	if (error) {
 		printk(KERN_ERR
 		       "%s: ps3_vuart_port_driver_register failed %d\n",
-		       __FUNCTION__, error);
+		       __func__, error);
 		return error;
 	}
 
@@ -986,7 +984,7 @@ static int ps3av_module_init(void)
 	if (error)
 		printk(KERN_ERR
 		       "%s: ps3_vuart_port_device_register failed %d\n",
-		       __FUNCTION__, error);
+		       __func__, error);
 
 	return error;
 }
diff -puN drivers/ps3/ps3av_cmd.c~ps3av-use-__func__-instead-of-__function__ drivers/ps3/ps3av_cmd.c
--- a/drivers/ps3/ps3av_cmd.c~ps3av-use-__func__-instead-of-__function__
+++ a/drivers/ps3/ps3av_cmd.c
@@ -395,7 +395,7 @@ u32 ps3av_cmd_set_video_mode(void *p, u3
 	video_mode->video_order = ps3av_video_fmt_table[video_fmt].order;
 
 	pr_debug("%s: video_mode:vid:%x width:%d height:%d pitch:%d out_format:%d format:%x order:%x\n",
-		__FUNCTION__, video_vid, video_mode->width, video_mode->height,
+		__func__, video_vid, video_mode->width, video_mode->height,
 		video_mode->pitch, video_mode->video_out_format,
 		video_mode->video_format, video_mode->video_order);
 	return sizeof(*video_mode);
@@ -477,7 +477,7 @@ static u8 ps3av_cnv_mclk(u32 fs)
 		if (ps3av_cnv_mclk_table[i].fs == fs)
 			return ps3av_cnv_mclk_table[i].mclk;
 
-	printk(KERN_ERR "%s failed, fs:%x\n", __FUNCTION__, fs);
+	printk(KERN_ERR "%s failed, fs:%x\n", __func__, fs);
 	return 0;
 }
 
@@ -526,13 +526,12 @@ static void ps3av_cnv_ns(u8 *ns, u32 fs,
 		d = 4;
 		break;
 	default:
-		printk(KERN_ERR "%s failed, vid:%x\n", __FUNCTION__,
-		       video_vid);
+		printk(KERN_ERR "%s failed, vid:%x\n", __func__, video_vid);
 		break;
 	}
 
 	if (fs < PS3AV_CMD_AUDIO_FS_44K || fs > PS3AV_CMD_AUDIO_FS_192K)
-		printk(KERN_ERR "%s failed, fs:%x\n", __FUNCTION__, fs);
+		printk(KERN_ERR "%s failed, fs:%x\n", __func__, fs);
 	else
 		ns_val = ps3av_ns_table[PS3AV_CMD_AUDIO_FS_44K-BASE][d];
 
@@ -555,8 +554,7 @@ static u8 ps3av_cnv_enable(u32 source, c
 		ret = ((p[0] << 4) + (p[1] << 5) + (p[2] << 6) + (p[3] << 7)) |
 		      0x01;
 	} else
-		printk(KERN_ERR "%s failed, source:%x\n", __FUNCTION__,
-		       source);
+		printk(KERN_ERR "%s failed, source:%x\n", __func__, source);
 	return ret;
 }
 
@@ -585,7 +583,7 @@ static u8 ps3av_cnv_inputlen(u32 word_bi
 		ret = PS3AV_CMD_AV_INPUTLEN_24;
 		break;
 	default:
-		printk(KERN_ERR "%s failed, word_bits:%x\n", __FUNCTION__,
+		printk(KERN_ERR "%s failed, word_bits:%x\n", __func__,
 		       word_bits);
 		break;
 	}
@@ -595,7 +593,7 @@ static u8 ps3av_cnv_inputlen(u32 word_bi
 static u8 ps3av_cnv_layout(u32 num_of_ch)
 {
 	if (num_of_ch > PS3AV_CMD_AUDIO_NUM_OF_CH_8) {
-		printk(KERN_ERR "%s failed, num_of_ch:%x\n", __FUNCTION__,
+		printk(KERN_ERR "%s failed, num_of_ch:%x\n", __func__,
 		       num_of_ch);
 		return 0;
 	}
@@ -864,7 +862,7 @@ int ps3av_cmd_avb_param(struct ps3av_pkt
 
 	res = get_status(avb);
 	if (res)
-		pr_debug("%s: PS3AV_CID_AVB_PARAM: failed %x\n", __FUNCTION__,
+		pr_debug("%s: PS3AV_CID_AVB_PARAM: failed %x\n", __func__,
 			 res);
 
       out:
@@ -1013,7 +1011,7 @@ int ps3av_vuart_read(struct ps3_vuart_po
 			return size;
 		if (error != -EAGAIN) {
 			printk(KERN_ERR "%s: ps3_vuart_read failed %d\n",
-			       __FUNCTION__, error);
+			       __func__, error);
 			return error;
 		}
 		msleep(POLLING_INTERVAL);
_

Patches currently in -mm which might be from Geert.Uytterhoeven@sonycom.com are

origin.patch
ps3fb-thread-updates.patch
ps3av-thread-updates.patch
ps3fb-kill-superfluous-zero-initializations.patch
ps3fb-atomic-fixes.patch
ps3av-misc-updates.patch
ps3-make-ps3videomode-v-0-auto-mode-work-again.patch
ps3fb-use-__func__-instead-of-__function__.patch
ps3av-use-__func__-instead-of-__function__.patch
fbdev-avoid-vertical-overflow-when-making-space-for-the-logo.patch
fbdev-fb_do_show_logo-updates.patch
fbdev-correct-image-offsets-when-rotating-logo.patch
