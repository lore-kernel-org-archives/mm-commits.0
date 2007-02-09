From: akpm@linux-foundation.org
Subject: + ps3-av-settings-driver.patch added to -mm tree
Date: Fri, 09 Feb 2007 01:26:34 -0800
Message-ID: <200702090926.l199QYji009493@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:38643 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946245AbXBIJ17 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 9 Feb 2007 04:27:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: Geert.Uytterhoeven@sonycom.com, benh@kernel.crashing.org, jsimmons@infradead.org, paulus@samba.org


The patch titled
     ps3: AV Settings Driver
has been added to the -mm tree.  Its filename is
     ps3-av-settings-driver.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: ps3: AV Settings Driver
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>

Add the PS3 AV Settings Driver.

The AV Settings driver is used to control Audio and Video settings.  It
communicates with the policy manager through the virtual uart.

Signed-off-by: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Cc: James Simmons <jsimmons@infradead.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/platforms/ps3/Kconfig |   11 
 drivers/ps3/Makefile               |    1 
 drivers/ps3/ps3av.c                |  974 +++++++++++++++++++++++++
 drivers/ps3/ps3av_cmd.c            | 1017 +++++++++++++++++++++++++++
 include/asm-powerpc/ps3av.h        |  738 +++++++++++++++++++
 5 files changed, 2741 insertions(+)

diff -puN arch/powerpc/platforms/ps3/Kconfig~ps3-av-settings-driver arch/powerpc/platforms/ps3/Kconfig
--- a/arch/powerpc/platforms/ps3/Kconfig~ps3-av-settings-driver
+++ a/arch/powerpc/platforms/ps3/Kconfig
@@ -51,4 +51,15 @@ config PS3_VUART
 	  including the System Manager and AV Settings.  In
 	  general, all users will say Y.
 
+config PS3_PS3AV
+	tristate "PS3 AV settings driver"
+	depends on PPC_PS3
+	select PS3_VUART
+	default y
+	help
+	  Include support for the PS3 AV Settings driver.
+
+	  This support is required for graphics and sound. In
+	  general, all users will say Y or M.
+
 endmenu
diff -puN drivers/ps3/Makefile~ps3-av-settings-driver drivers/ps3/Makefile
--- a/drivers/ps3/Makefile~ps3-av-settings-driver
+++ a/drivers/ps3/Makefile
@@ -1 +1,2 @@
 obj-$(CONFIG_PS3_VUART) += vuart.o
+obj-$(CONFIG_PS3_PS3AV) += ps3av.o ps3av_cmd.o
diff -puN /dev/null drivers/ps3/ps3av.c
--- /dev/null
+++ a/drivers/ps3/ps3av.c
@@ -0,0 +1,974 @@
+/*
+ * Copyright (C) 2006 Sony Computer Entertainment Inc.
+ * Copyright 2006, 2007 Sony Corporation
+ *
+ * AV backend support for PS3
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License as published
+ * by the Free Software Foundation; version 2 of the License.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License along
+ * with this program; if not, write to the Free Software Foundation, Inc.,
+ * 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
+ */
+
+#include <linux/module.h>
+#include <linux/delay.h>
+#include <linux/notifier.h>
+#include <linux/reboot.h>
+#include <linux/kernel.h>
+#include <linux/ioctl.h>
+#include <asm/lv1call.h>
+#include <asm/ps3av.h>
+#include <asm/ps3.h>
+
+#include "vuart.h"
+
+#define BUFSIZE          4096	/* vuart buf size */
+#define PS3AV_BUF_SIZE   512	/* max packet size */
+
+static int timeout = 5000;	/* in msec ( 5 sec ) */
+module_param(timeout, int, 0644);
+
+static struct ps3av ps3av;
+
+static struct ps3_vuart_port_device ps3av_dev = {
+	.match_id = PS3_MATCH_ID_AV_SETTINGS
+};
+
+/* color space */
+#define YUV444 PS3AV_CMD_VIDEO_CS_YUV444_8
+#define RGB8   PS3AV_CMD_VIDEO_CS_RGB_8
+/* format */
+#define XRGB   PS3AV_CMD_VIDEO_FMT_X8R8G8B8
+/* aspect */
+#define A_N    PS3AV_CMD_AV_ASPECT_4_3
+#define A_W    PS3AV_CMD_AV_ASPECT_16_9
+static const struct avset_video_mode {
+	u32 cs;
+	u32 fmt;
+	u32 vid;
+	u32 aspect;
+	u32 x;
+	u32 y;
+	u32 interlace;
+	u32 freq;
+} video_mode_table[] = {
+	{     0, }, /* auto */
+	{YUV444, XRGB, PS3AV_CMD_VIDEO_VID_480I,       A_N,  720,  480, 1, 60},
+	{YUV444, XRGB, PS3AV_CMD_VIDEO_VID_480P,       A_N,  720,  480, 0, 60},
+	{YUV444, XRGB, PS3AV_CMD_VIDEO_VID_720P_60HZ,  A_N, 1280,  720, 0, 60},
+	{YUV444, XRGB, PS3AV_CMD_VIDEO_VID_1080I_60HZ, A_W, 1920, 1080, 1, 60},
+	{YUV444, XRGB, PS3AV_CMD_VIDEO_VID_1080P_60HZ, A_W, 1920, 1080, 0, 60},
+	{YUV444, XRGB, PS3AV_CMD_VIDEO_VID_576I,       A_N,  720,  576, 1, 50},
+	{YUV444, XRGB, PS3AV_CMD_VIDEO_VID_576P,       A_N,  720,  576, 0, 50},
+	{YUV444, XRGB, PS3AV_CMD_VIDEO_VID_720P_50HZ,  A_N, 1280,  720, 0, 50},
+	{YUV444, XRGB, PS3AV_CMD_VIDEO_VID_1080I_50HZ, A_W, 1920, 1080, 1, 50},
+	{YUV444, XRGB, PS3AV_CMD_VIDEO_VID_1080P_50HZ, A_W, 1920, 1080, 0, 50},
+	{  RGB8, XRGB, PS3AV_CMD_VIDEO_VID_WXGA,       A_W, 1280,  768, 0, 60},
+	{  RGB8, XRGB, PS3AV_CMD_VIDEO_VID_SXGA,       A_N, 1280, 1024, 0, 60},
+	{  RGB8, XRGB, PS3AV_CMD_VIDEO_VID_WUXGA,      A_W, 1920, 1200, 0, 60},
+};
+
+/* supported CIDs */
+static u32 cmd_table[] = {
+	/* init */
+	PS3AV_CID_AV_INIT,
+	PS3AV_CID_AV_FIN,
+	PS3AV_CID_VIDEO_INIT,
+	PS3AV_CID_AUDIO_INIT,
+
+	/* set */
+	PS3AV_CID_AV_ENABLE_EVENT,
+	PS3AV_CID_AV_DISABLE_EVENT,
+
+	PS3AV_CID_AV_VIDEO_CS,
+	PS3AV_CID_AV_VIDEO_MUTE,
+	PS3AV_CID_AV_VIDEO_DISABLE_SIG,
+	PS3AV_CID_AV_AUDIO_PARAM,
+	PS3AV_CID_AV_AUDIO_MUTE,
+	PS3AV_CID_AV_HDMI_MODE,
+	PS3AV_CID_AV_TV_MUTE,
+
+	PS3AV_CID_VIDEO_MODE,
+	PS3AV_CID_VIDEO_FORMAT,
+	PS3AV_CID_VIDEO_PITCH,
+
+	PS3AV_CID_AUDIO_MODE,
+	PS3AV_CID_AUDIO_MUTE,
+	PS3AV_CID_AUDIO_ACTIVE,
+	PS3AV_CID_AUDIO_INACTIVE,
+	PS3AV_CID_AVB_PARAM,
+
+	/* get */
+	PS3AV_CID_AV_GET_HW_CONF,
+	PS3AV_CID_AV_GET_MONITOR_INFO,
+
+	/* event */
+	PS3AV_CID_EVENT_UNPLUGGED,
+	PS3AV_CID_EVENT_PLUGGED,
+	PS3AV_CID_EVENT_HDCP_DONE,
+	PS3AV_CID_EVENT_HDCP_FAIL,
+	PS3AV_CID_EVENT_HDCP_AUTH,
+	PS3AV_CID_EVENT_HDCP_ERROR,
+
+	0
+};
+
+#define PS3AV_EVENT_CMD_MASK           0x10000000
+#define PS3AV_EVENT_ID_MASK            0x0000ffff
+#define PS3AV_CID_MASK                 0xffffffff
+#define PS3AV_REPLY_BIT                0x80000000
+
+#define ps3av_event_get_port_id(cid)   ((cid >> 16) & 0xff)
+
+static u32 *ps3av_search_cmd_table(u32 cid, u32 mask)
+{
+	u32 *table;
+	int i;
+
+	table = cmd_table;
+	for (i = 0;; table++, i++) {
+		if ((*table & mask) == (cid & mask))
+			break;
+		if (*table == 0)
+			return NULL;
+	}
+	return table;
+}
+
+static int ps3av_parse_event_packet(const struct ps3av_reply_hdr *hdr)
+{
+	u32 *table;
+
+	if (hdr->cid & PS3AV_EVENT_CMD_MASK) {
+		table = ps3av_search_cmd_table(hdr->cid, PS3AV_EVENT_CMD_MASK);
+		if (table)
+			dev_dbg(&ps3av_dev.core,
+				"recv event packet cid:%08x port:0x%x size:%d\n",
+				hdr->cid, ps3av_event_get_port_id(hdr->cid),
+				hdr->size);
+		else
+			printk(KERN_ERR
+			       "%s: failed event packet, cid:%08x size:%d\n",
+			       __FUNCTION__, hdr->cid, hdr->size);
+		return 1;	/* receive event packet */
+	}
+	return 0;
+}
+
+static int ps3av_send_cmd_pkt(const struct ps3av_send_hdr *send_buf,
+			      struct ps3av_reply_hdr *recv_buf, int write_len,
+			      int read_len)
+{
+	int res;
+	u32 cmd;
+	int event;
+
+	if (!ps3av.available)
+		return -ENODEV;
+
+	/* send pkt */
+	res = ps3av_vuart_write(ps3av.dev, send_buf, write_len);
+	if (res < 0) {
+		dev_dbg(&ps3av_dev.core,
+			"%s: ps3av_vuart_write() failed (result=%d)\n",
+			__FUNCTION__, res);
+		return res;
+	}
+
+	/* recv pkt */
+	cmd = send_buf->cid;
+	do {
+		/* read header */
+		res = ps3av_vuart_read(ps3av.dev, recv_buf, PS3AV_HDR_SIZE,
+				       timeout);
+		if (res != PS3AV_HDR_SIZE) {
+			dev_dbg(&ps3av_dev.core,
+				"%s: ps3av_vuart_read() failed (result=%d)\n",
+				__FUNCTION__, res);
+			return res;
+		}
+
+		/* read body */
+		res = ps3av_vuart_read(ps3av.dev, &recv_buf->cid,
+				       recv_buf->size, timeout);
+		if (res < 0) {
+			dev_dbg(&ps3av_dev.core,
+				"%s: ps3av_vuart_read() failed (result=%d)\n",
+				__FUNCTION__, res);
+			return res;
+		}
+		res += PS3AV_HDR_SIZE;	/* total len */
+		event = ps3av_parse_event_packet(recv_buf);
+		/* ret > 0 event packet */
+	} while (event);
+
+	if ((cmd | PS3AV_REPLY_BIT) != recv_buf->cid) {
+		dev_dbg(&ps3av_dev.core, "%s: reply err (result=%x)\n",
+			__FUNCTION__, recv_buf->cid);
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static int ps3av_process_reply_packet(struct ps3av_send_hdr *cmd_buf,
+				      const struct ps3av_reply_hdr *recv_buf,
+				      int user_buf_size)
+{
+	int return_len;
+
+	if (recv_buf->version != PS3AV_VERSION) {
+		dev_dbg(&ps3av_dev.core, "reply_packet invalid version:%x\n",
+			recv_buf->version);
+		return -EFAULT;
+	}
+	return_len = recv_buf->size + PS3AV_HDR_SIZE;
+	if (return_len > user_buf_size)
+		return_len = user_buf_size;
+	memcpy(cmd_buf, recv_buf, return_len);
+	return 0;		/* success */
+}
+
+void ps3av_set_hdr(u32 cid, u16 size, struct ps3av_send_hdr *hdr)
+{
+	hdr->version = PS3AV_VERSION;
+	hdr->size = size - PS3AV_HDR_SIZE;
+	hdr->cid = cid;
+}
+
+int ps3av_do_pkt(u32 cid, u16 send_len, size_t usr_buf_size,
+		 struct ps3av_send_hdr *buf)
+{
+	int res = 0;
+	union {
+		struct ps3av_reply_hdr reply_hdr;
+		u8 raw[PS3AV_BUF_SIZE];
+	} recv_buf;
+
+	u32 *table;
+
+	BUG_ON(!ps3av.available);
+
+	if (down_interruptible(&ps3av.sem))
+		return -ERESTARTSYS;
+
+	table = ps3av_search_cmd_table(cid, PS3AV_CID_MASK);
+	BUG_ON(!table);
+	BUG_ON(send_len < PS3AV_HDR_SIZE);
+	BUG_ON(usr_buf_size < send_len);
+	BUG_ON(usr_buf_size > PS3AV_BUF_SIZE);
+
+	/* create header */
+	ps3av_set_hdr(cid, send_len, buf);
+
+	/* send packet via vuart */
+	res = ps3av_send_cmd_pkt(buf, &recv_buf.reply_hdr, send_len,
+				 usr_buf_size);
+	if (res < 0) {
+		printk(KERN_ERR
+		       "%s: ps3av_send_cmd_pkt() failed (result=%d)\n",
+		       __FUNCTION__, res);
+		goto err;
+	}
+
+	/* process reply packet */
+	res = ps3av_process_reply_packet(buf, &recv_buf.reply_hdr,
+					 usr_buf_size);
+	if (res < 0) {
+		printk(KERN_ERR "%s: put_return_status() failed (result=%d)\n",
+		       __FUNCTION__, res);
+		goto err;
+	}
+
+	up(&ps3av.sem);
+	return 0;
+
+      err:
+	up(&ps3av.sem);
+	printk(KERN_ERR "%s: failed cid:%x res:%d\n", __FUNCTION__, cid, res);
+	return res;
+}
+
+static int ps3av_set_av_video_mute(u32 mute)
+{
+	int i, num_of_av_port, res;
+
+	num_of_av_port = ps3av.av_hw_conf.num_of_hdmi +
+			 ps3av.av_hw_conf.num_of_avmulti;
+	/* video mute on */
+	for (i = 0; i < num_of_av_port; i++) {
+		res = ps3av_cmd_av_video_mute(1, &ps3av.av_port[i], mute);
+		if (res < 0)
+			return -1;
+	}
+
+	return 0;
+}
+
+static int ps3av_set_video_disable_sig(void)
+{
+	int i, num_of_hdmi_port, num_of_av_port, res;
+
+	num_of_hdmi_port = ps3av.av_hw_conf.num_of_hdmi;
+	num_of_av_port = ps3av.av_hw_conf.num_of_hdmi +
+			 ps3av.av_hw_conf.num_of_avmulti;
+
+	/* tv mute */
+	for (i = 0; i < num_of_hdmi_port; i++) {
+		res = ps3av_cmd_av_tv_mute(ps3av.av_port[i],
+					   PS3AV_CMD_MUTE_ON);
+		if (res < 0)
+			return -1;
+	}
+	msleep(100);
+
+	/* video mute on */
+	for (i = 0; i < num_of_av_port; i++) {
+		res = ps3av_cmd_av_video_disable_sig(ps3av.av_port[i]);
+		if (res < 0)
+			return -1;
+		if (i < num_of_hdmi_port) {
+			res = ps3av_cmd_av_tv_mute(ps3av.av_port[i],
+						   PS3AV_CMD_MUTE_OFF);
+			if (res < 0)
+				return -1;
+		}
+	}
+	msleep(300);
+
+	return 0;
+}
+
+static int ps3av_set_audio_mute(u32 mute)
+{
+	int i, num_of_av_port, num_of_opt_port, res;
+
+	num_of_av_port = ps3av.av_hw_conf.num_of_hdmi +
+			 ps3av.av_hw_conf.num_of_avmulti;
+	num_of_opt_port = ps3av.av_hw_conf.num_of_spdif;
+
+	for (i = 0; i < num_of_av_port; i++) {
+		res = ps3av_cmd_av_audio_mute(1, &ps3av.av_port[i], mute);
+		if (res < 0)
+			return -1;
+	}
+	for (i = 0; i < num_of_opt_port; i++) {
+		res = ps3av_cmd_audio_mute(1, &ps3av.opt_port[i], mute);
+		if (res < 0)
+			return -1;
+	}
+
+	return 0;
+}
+
+int ps3av_set_audio_mode(u32 ch, u32 fs, u32 word_bits, u32 format, u32 source)
+{
+	struct ps3av_pkt_avb_param avb_param;
+	int i, num_of_audio, vid, res;
+	struct ps3av_pkt_audio_mode audio_mode;
+	u32 len = 0;
+
+	num_of_audio = ps3av.av_hw_conf.num_of_hdmi +
+		       ps3av.av_hw_conf.num_of_avmulti +
+		       ps3av.av_hw_conf.num_of_spdif;
+
+	avb_param.num_of_video_pkt = 0;
+	avb_param.num_of_audio_pkt = PS3AV_AVB_NUM_AUDIO;	/* always 0 */
+	avb_param.num_of_av_video_pkt = 0;
+	avb_param.num_of_av_audio_pkt = ps3av.av_hw_conf.num_of_hdmi;
+
+	vid = video_mode_table[ps3av.ps3av_mode].vid;
+
+	/* audio mute */
+	ps3av_set_audio_mute(PS3AV_CMD_MUTE_ON);
+
+	/* audio inactive */
+	res = ps3av_cmd_audio_active(0, ps3av.audio_port);
+	if (res < 0)
+		dev_dbg(&ps3av_dev.core,
+			"ps3av_cmd_audio_active OFF failed\n");
+
+	/* audio_pkt */
+	for (i = 0; i < num_of_audio; i++) {
+		ps3av_cmd_set_audio_mode(&audio_mode, ps3av.av_port[i], ch, fs,
+					 word_bits, format, source);
+		if (i < ps3av.av_hw_conf.num_of_hdmi) {
+			/* hdmi only */
+			len += ps3av_cmd_set_av_audio_param(&avb_param.buf[len],
+							    ps3av.av_port[i],
+							    &audio_mode, vid);
+		}
+		/* audio_mode pkt should be sent separately */
+		res = ps3av_cmd_audio_mode(&audio_mode);
+		if (res < 0)
+			dev_dbg(&ps3av_dev.core,
+				"ps3av_cmd_audio_mode failed, port:%x\n", i);
+	}
+
+	/* send command using avb pkt */
+	len += offsetof(struct ps3av_pkt_avb_param, buf);
+	res = ps3av_cmd_avb_param(&avb_param, len);
+	if (res < 0)
+		dev_dbg(&ps3av_dev.core, "ps3av_cmd_avb_param failed\n");
+
+	/* audio mute */
+	ps3av_set_audio_mute(PS3AV_CMD_MUTE_OFF);
+
+	/* audio active */
+	res = ps3av_cmd_audio_active(1, ps3av.audio_port);
+	if (res < 0)
+		dev_dbg(&ps3av_dev.core, "ps3av_cmd_audio_active ON failed\n");
+
+	return 0;
+}
+
+EXPORT_SYMBOL_GPL(ps3av_set_audio_mode);
+
+static int ps3av_set_videomode(void)
+{
+	/* av video mute */
+	ps3av_set_av_video_mute(PS3AV_CMD_MUTE_ON);
+
+	/* wake up ps3avd to do the actual video mode setting */
+	up(&ps3av.ping);
+
+	return 0;
+}
+
+static void ps3av_set_videomode_cont(u32 id, u32 old_id)
+{
+	struct ps3av_pkt_avb_param avb_param;
+	int i;
+	u32 len = 0, av_video_cs;
+	const struct avset_video_mode *video_mode;
+	int res;
+
+	video_mode = &video_mode_table[id & PS3AV_MODE_MASK];
+
+	avb_param.num_of_video_pkt = PS3AV_AVB_NUM_VIDEO;	/* num of head */
+	avb_param.num_of_audio_pkt = 0;
+	avb_param.num_of_av_video_pkt = ps3av.av_hw_conf.num_of_hdmi +
+					ps3av.av_hw_conf.num_of_avmulti;
+	avb_param.num_of_av_audio_pkt = 0;
+
+	/* video signal off */
+	ps3av_set_video_disable_sig();
+
+	/* Retail PS3 product doesn't support this */
+	if (id & PS3AV_MODE_HDCP_OFF) {
+		res = ps3av_cmd_av_hdmi_mode(PS3AV_CMD_AV_HDMI_HDCP_OFF);
+		if (res == PS3AV_STATUS_UNSUPPORTED_HDMI_MODE)
+			dev_dbg(&ps3av_dev.core, "Not supported\n");
+		else if (res)
+			dev_dbg(&ps3av_dev.core,
+				"ps3av_cmd_av_hdmi_mode failed\n");
+	} else if (old_id & PS3AV_MODE_HDCP_OFF) {
+		res = ps3av_cmd_av_hdmi_mode(PS3AV_CMD_AV_HDMI_MODE_NORMAL);
+		if (res < 0 && res != PS3AV_STATUS_UNSUPPORTED_HDMI_MODE)
+			dev_dbg(&ps3av_dev.core,
+				"ps3av_cmd_av_hdmi_mode failed\n");
+	}
+
+	/* video_pkt */
+	for (i = 0; i < avb_param.num_of_video_pkt; i++)
+		len += ps3av_cmd_set_video_mode(&avb_param.buf[len],
+						ps3av.head[i], video_mode->vid,
+						video_mode->fmt, id);
+	/* av_video_pkt */
+	for (i = 0; i < avb_param.num_of_av_video_pkt; i++) {
+		if (id & PS3AV_MODE_DVI || id & PS3AV_MODE_RGB)
+			av_video_cs = RGB8;
+		else
+			av_video_cs = video_mode->cs;
+#ifndef PS3AV_HDMI_YUV
+		if (ps3av.av_port[i] == PS3AV_CMD_AVPORT_HDMI_0 ||
+		    ps3av.av_port[i] == PS3AV_CMD_AVPORT_HDMI_1)
+			av_video_cs = RGB8;	/* use RGB for HDMI */
+#endif
+		len += ps3av_cmd_set_av_video_cs(&avb_param.buf[len],
+						 ps3av.av_port[i],
+						 video_mode->vid, av_video_cs,
+						 video_mode->aspect, id);
+	}
+	/* send command using avb pkt */
+	len += offsetof(struct ps3av_pkt_avb_param, buf);
+	res = ps3av_cmd_avb_param(&avb_param, len);
+	if (res == PS3AV_STATUS_NO_SYNC_HEAD)
+		printk(KERN_WARNING
+		       "%s: Command failed. Please try your request again. \n",
+		       __FUNCTION__);
+	else if (res)
+		dev_dbg(&ps3av_dev.core, "ps3av_cmd_avb_param failed\n");
+
+	msleep(1500);
+	/* av video mute */
+	ps3av_set_av_video_mute(PS3AV_CMD_MUTE_OFF);
+}
+
+static int ps3avd(void *p)
+{
+	struct ps3av *info = p;
+
+	daemonize("ps3avd");
+	while (1) {
+		down(&info->ping);
+		ps3av_set_videomode_cont(info->ps3av_mode,
+					 info->ps3av_mode_old);
+		up(&info->pong);
+	}
+	return 0;
+}
+
+static int ps3av_vid2table_id(int vid)
+{
+	int i;
+
+	for (i = 1; i < ARRAY_SIZE(video_mode_table); i++)
+		if (video_mode_table[i].vid == vid)
+			return i;
+	return -1;
+}
+
+static int ps3av_resbit2vid(u32 res_50, u32 res_60)
+{
+	int vid = -1;
+
+	if (res_50 > res_60) {	/* if res_50 == res_60, res_60 will be used */
+		if (res_50 & PS3AV_RESBIT_1920x1080P)
+			vid = PS3AV_CMD_VIDEO_VID_1080P_50HZ;
+		else if (res_50 & PS3AV_RESBIT_1920x1080I)
+			vid = PS3AV_CMD_VIDEO_VID_1080I_50HZ;
+		else if (res_50 & PS3AV_RESBIT_1280x720P)
+			vid = PS3AV_CMD_VIDEO_VID_720P_50HZ;
+		else if (res_50 & PS3AV_RESBIT_720x576P)
+			vid = PS3AV_CMD_VIDEO_VID_576P;
+		else
+			vid = -1;
+	} else {
+		if (res_60 & PS3AV_RESBIT_1920x1080P)
+			vid = PS3AV_CMD_VIDEO_VID_1080P_60HZ;
+		else if (res_60 & PS3AV_RESBIT_1920x1080I)
+			vid = PS3AV_CMD_VIDEO_VID_1080I_60HZ;
+		else if (res_60 & PS3AV_RESBIT_1280x720P)
+			vid = PS3AV_CMD_VIDEO_VID_720P_60HZ;
+		else if (res_60 & PS3AV_RESBIT_720x480P)
+			vid = PS3AV_CMD_VIDEO_VID_480P;
+		else
+			vid = -1;
+	}
+	return vid;
+}
+
+static int ps3av_hdmi_get_vid(struct ps3av_info_monitor *info)
+{
+	u32 res_50, res_60;
+	int vid = -1;
+
+	if (info->monitor_type != PS3AV_MONITOR_TYPE_HDMI)
+		return -1;
+
+	/* check native resolution */
+	res_50 = info->res_50.native & PS3AV_RES_MASK_50;
+	res_60 = info->res_60.native & PS3AV_RES_MASK_60;
+	if (res_50 || res_60) {
+		vid = ps3av_resbit2vid(res_50, res_60);
+		return vid;
+	}
+
+	/* check resolution */
+	res_50 = info->res_50.res_bits & PS3AV_RES_MASK_50;
+	res_60 = info->res_60.res_bits & PS3AV_RES_MASK_60;
+	if (res_50 || res_60) {
+		vid = ps3av_resbit2vid(res_50, res_60);
+		return vid;
+	}
+
+	if (ps3av.region & PS3AV_REGION_60)
+		vid = PS3AV_DEFAULT_HDMI_VID_REG_60;
+	else
+		vid = PS3AV_DEFAULT_HDMI_VID_REG_50;
+	return vid;
+}
+
+static int ps3av_auto_videomode(struct ps3av_pkt_av_get_hw_conf *av_hw_conf,
+				int boot)
+{
+	int i, res, vid = -1, dvi = 0, rgb = 0;
+	struct ps3av_pkt_av_get_monitor_info monitor_info;
+	struct ps3av_info_monitor *info;
+
+	/* get vid for hdmi */
+	for (i = 0; i < av_hw_conf->num_of_hdmi; i++) {
+		res = ps3av_cmd_video_get_monitor_info(&monitor_info,
+						       PS3AV_CMD_AVPORT_HDMI_0 +
+						       i);
+		if (res < 0)
+			return -1;
+
+		ps3av_cmd_av_monitor_info_dump(&monitor_info);
+		info = &monitor_info.info;
+		/* check DVI */
+		if (info->monitor_type == PS3AV_MONITOR_TYPE_DVI) {
+			dvi = PS3AV_MODE_DVI;
+			break;
+		}
+		/* check HDMI */
+		vid = ps3av_hdmi_get_vid(info);
+		if (vid != -1) {
+			/* got valid vid */
+			break;
+		}
+	}
+
+	if (dvi) {
+		/* DVI mode */
+		vid = PS3AV_DEFAULT_DVI_VID;
+	} else if (vid == -1) {
+		/* no HDMI interface or HDMI is off */
+		if (ps3av.region & PS3AV_REGION_60)
+			vid = PS3AV_DEFAULT_AVMULTI_VID_REG_60;
+		else
+			vid = PS3AV_DEFAULT_AVMULTI_VID_REG_50;
+		if (ps3av.region & PS3AV_REGION_RGB)
+			rgb = PS3AV_MODE_RGB;
+	} else if (boot) {
+		/* HDMI: using DEFAULT HDMI_VID while booting up */
+		info = &monitor_info.info;
+		if (ps3av.region & PS3AV_REGION_60) {
+			if (info->res_60.res_bits & PS3AV_RESBIT_720x480P)
+				vid = PS3AV_DEFAULT_HDMI_VID_REG_60;
+			else if (info->res_50.res_bits & PS3AV_RESBIT_720x576P)
+				vid = PS3AV_DEFAULT_HDMI_VID_REG_50;
+			else {
+				/* default */
+				vid = PS3AV_DEFAULT_HDMI_VID_REG_60;
+			}
+		} else {
+			if (info->res_50.res_bits & PS3AV_RESBIT_720x576P)
+				vid = PS3AV_DEFAULT_HDMI_VID_REG_50;
+			else if (info->res_60.res_bits & PS3AV_RESBIT_720x480P)
+				vid = PS3AV_DEFAULT_HDMI_VID_REG_60;
+			else {
+				/* default */
+				vid = PS3AV_DEFAULT_HDMI_VID_REG_50;
+			}
+		}
+	}
+
+	return (ps3av_vid2table_id(vid) | dvi | rgb);
+}
+
+static int ps3av_get_hw_conf(struct ps3av *ps3av)
+{
+	int i, j, k, res;
+
+	/* get av_hw_conf */
+	res = ps3av_cmd_av_get_hw_conf(&ps3av->av_hw_conf);
+	if (res < 0)
+		return -1;
+
+	ps3av_cmd_av_hw_conf_dump(&ps3av->av_hw_conf);
+
+	for (i = 0; i < PS3AV_HEAD_MAX; i++)
+		ps3av->head[i] = PS3AV_CMD_VIDEO_HEAD_A + i;
+	for (i = 0; i < PS3AV_OPT_PORT_MAX; i++)
+		ps3av->opt_port[i] = PS3AV_CMD_AVPORT_SPDIF_0 + i;
+	for (i = 0; i < ps3av->av_hw_conf.num_of_hdmi; i++)
+		ps3av->av_port[i] = PS3AV_CMD_AVPORT_HDMI_0 + i;
+	for (j = 0; j < ps3av->av_hw_conf.num_of_avmulti; j++)
+		ps3av->av_port[i + j] = PS3AV_CMD_AVPORT_AVMULTI_0 + j;
+	for (k = 0; k < ps3av->av_hw_conf.num_of_spdif; k++)
+		ps3av->av_port[i + j + k] = PS3AV_CMD_AVPORT_SPDIF_0 + k;
+
+	/* set all audio port */
+	ps3av->audio_port = PS3AV_CMD_AUDIO_PORT_HDMI_0
+	    | PS3AV_CMD_AUDIO_PORT_HDMI_1
+	    | PS3AV_CMD_AUDIO_PORT_AVMULTI_0
+	    | PS3AV_CMD_AUDIO_PORT_SPDIF_0 | PS3AV_CMD_AUDIO_PORT_SPDIF_1;
+
+	return 0;
+}
+
+/* set mode using id */
+int ps3av_set_video_mode(u32 id, int boot)
+{
+	int size;
+	u32 option;
+
+	size = ARRAY_SIZE(video_mode_table);
+	if ((id & PS3AV_MODE_MASK) > size - 1 || id < 0) {
+		dev_dbg(&ps3av_dev.core, "%s: error id :%d\n", __FUNCTION__,
+			id);
+		return -EINVAL;
+	}
+
+	/* auto mode */
+	option = id & ~PS3AV_MODE_MASK;
+	if ((id & PS3AV_MODE_MASK) == 0) {
+		id = ps3av_auto_videomode(&ps3av.av_hw_conf, boot);
+		if (id < 1) {
+			printk(KERN_ERR "%s: invalid id :%d\n", __FUNCTION__,
+			       id);
+			return -EINVAL;
+		}
+		id |= option;
+	}
+
+	/* set videomode */
+	down(&ps3av.pong);
+	ps3av.ps3av_mode_old = ps3av.ps3av_mode;
+	ps3av.ps3av_mode = id;
+	if (ps3av_set_videomode())
+		ps3av.ps3av_mode = ps3av.ps3av_mode_old;
+
+	return 0;
+}
+
+EXPORT_SYMBOL_GPL(ps3av_set_video_mode);
+
+int ps3av_set_mode(u32 id, int boot)
+{
+	int res;
+
+	res = ps3av_set_video_mode(id, boot);
+	if (res)
+		return res;
+
+	res = ps3av_set_audio_mode(PS3AV_CMD_AUDIO_NUM_OF_CH_2,
+				   PS3AV_CMD_AUDIO_FS_48K,
+				   PS3AV_CMD_AUDIO_WORD_BITS_16,
+				   PS3AV_CMD_AUDIO_FORMAT_PCM,
+				   PS3AV_CMD_AUDIO_SOURCE_SERIAL);
+	if (res)
+		return res;
+
+	return 0;
+}
+
+EXPORT_SYMBOL_GPL(ps3av_set_mode);
+
+int ps3av_get_mode(void)
+{
+	return ps3av.ps3av_mode;
+}
+
+EXPORT_SYMBOL_GPL(ps3av_get_mode);
+
+int ps3av_get_scanmode(int id)
+{
+	int size;
+
+	id = id & PS3AV_MODE_MASK;
+	size = ARRAY_SIZE(video_mode_table);
+	if (id > size - 1 || id < 0) {
+		printk(KERN_ERR "%s: invalid mode %d\n", __FUNCTION__, id);
+		return -EINVAL;
+	}
+	return video_mode_table[id].interlace;
+}
+
+EXPORT_SYMBOL_GPL(ps3av_get_scanmode);
+
+int ps3av_get_refresh_rate(int id)
+{
+	int size;
+
+	id = id & PS3AV_MODE_MASK;
+	size = ARRAY_SIZE(video_mode_table);
+	if (id > size - 1 || id < 0) {
+		printk(KERN_ERR "%s: invalid mode %d\n", __FUNCTION__, id);
+		return -EINVAL;
+	}
+	return video_mode_table[id].freq;
+}
+
+EXPORT_SYMBOL_GPL(ps3av_get_refresh_rate);
+
+/* get resolution by video_mode */
+int ps3av_video_mode2res(u32 id, u32 *xres, u32 *yres)
+{
+	int size;
+
+	id = id & PS3AV_MODE_MASK;
+	size = ARRAY_SIZE(video_mode_table);
+	if (id > size - 1 || id < 0) {
+		printk(KERN_ERR "%s: invalid mode %d\n", __FUNCTION__, id);
+		return -EINVAL;
+	}
+	*xres = video_mode_table[id].x;
+	*yres = video_mode_table[id].y;
+	return 0;
+}
+
+EXPORT_SYMBOL_GPL(ps3av_video_mode2res);
+
+/* mute */
+int ps3av_video_mute(int mute)
+{
+	return ps3av_set_av_video_mute(mute ? PS3AV_CMD_MUTE_ON
+					    : PS3AV_CMD_MUTE_OFF);
+}
+
+EXPORT_SYMBOL_GPL(ps3av_video_mute);
+
+int ps3av_audio_mute(int mute)
+{
+	return ps3av_set_audio_mute(mute ? PS3AV_CMD_MUTE_ON
+					 : PS3AV_CMD_MUTE_OFF);
+}
+
+EXPORT_SYMBOL_GPL(ps3av_audio_mute);
+
+int ps3av_dev_open(void)
+{
+	int status = 0;
+
+	mutex_lock(&ps3av.mutex);
+	if (!ps3av.open_count++) {
+		status = lv1_gpu_open(0);
+		if (status) {
+			printk(KERN_ERR "%s: lv1_gpu_open failed %d\n",
+			       __FUNCTION__, status);
+			ps3av.open_count--;
+		}
+	}
+	mutex_unlock(&ps3av.mutex);
+
+	return status;
+}
+
+EXPORT_SYMBOL_GPL(ps3av_dev_open);
+
+int ps3av_dev_close(void)
+{
+	int status = 0;
+
+	mutex_lock(&ps3av.mutex);
+	if (ps3av.open_count <= 0) {
+		printk(KERN_ERR "%s: GPU already closed\n", __FUNCTION__);
+		status = -1;
+	} else if (!--ps3av.open_count) {
+		status = lv1_gpu_close();
+		if (status)
+			printk(KERN_WARNING "%s: lv1_gpu_close failed %d\n",
+			       __FUNCTION__, status);
+	}
+	mutex_unlock(&ps3av.mutex);
+
+	return status;
+}
+
+EXPORT_SYMBOL_GPL(ps3av_dev_close);
+
+static int ps3av_probe(struct ps3_vuart_port_device *dev)
+{
+	int res;
+	u32 id;
+
+	dev_dbg(&ps3av_dev.core, "init ...\n");
+	dev_dbg(&ps3av_dev.core, "  timeout=%d\n", timeout);
+
+	memset(&ps3av, 0, sizeof(ps3av));
+
+	init_MUTEX(&ps3av.sem);
+	init_MUTEX_LOCKED(&ps3av.ping);
+	init_MUTEX(&ps3av.pong);
+	mutex_init(&ps3av.mutex);
+	ps3av.ps3av_mode = 0;
+	ps3av.dev = dev;
+	kernel_thread(ps3avd, &ps3av, CLONE_KERNEL);
+
+	ps3av.available = 1;
+	switch (ps3_os_area_get_av_multi_out()) {
+	case PS3_PARAM_AV_MULTI_OUT_NTSC:
+		ps3av.region = PS3AV_REGION_60;
+		break;
+	case PS3_PARAM_AV_MULTI_OUT_PAL_YCBCR:
+	case PS3_PARAM_AV_MULTI_OUT_SECAM:
+		ps3av.region = PS3AV_REGION_50;
+		break;
+	case PS3_PARAM_AV_MULTI_OUT_PAL_RGB:
+		ps3av.region = PS3AV_REGION_50 | PS3AV_REGION_RGB;
+		break;
+	default:
+		ps3av.region = PS3AV_REGION_60;
+		break;
+	}
+
+	/* init avsetting modules */
+	res = ps3av_cmd_init();
+	if (res < 0)
+		printk(KERN_ERR "%s: ps3av_cmd_init failed %d\n", __FUNCTION__,
+		       res);
+
+	ps3av_get_hw_conf(&ps3av);
+	id = ps3av_auto_videomode(&ps3av.av_hw_conf, 1);
+	mutex_lock(&ps3av.mutex);
+	ps3av.ps3av_mode = id;
+	mutex_unlock(&ps3av.mutex);
+
+	dev_dbg(&ps3av_dev.core, "init...done\n");
+
+	return 0;
+}
+
+static int ps3av_remove(struct ps3_vuart_port_device *dev)
+{
+	if (ps3av.available) {
+		ps3av_cmd_fin();
+		ps3av.available = 0;
+	}
+
+	return 0;
+}
+
+static void ps3av_shutdown(struct ps3_vuart_port_device *dev)
+{
+	ps3av_remove(dev);
+}
+
+static struct ps3_vuart_port_driver ps3av_driver = {
+	.match_id = PS3_MATCH_ID_AV_SETTINGS,
+	.core = {
+		.name = "ps3_av",
+	},
+	.probe = ps3av_probe,
+	.remove = ps3av_remove,
+	.shutdown = ps3av_shutdown,
+};
+
+static int ps3av_module_init(void)
+{
+	int error = ps3_vuart_port_driver_register(&ps3av_driver);
+	if (error) {
+		printk(KERN_ERR
+		       "%s: ps3_vuart_port_driver_register failed %d\n",
+		       __FUNCTION__, error);
+		return error;
+	}
+
+	error = ps3_vuart_port_device_register(&ps3av_dev);
+	if (error)
+		printk(KERN_ERR
+		       "%s: ps3_vuart_port_device_register failed %d\n",
+		       __FUNCTION__, error);
+
+	return error;
+}
+
+static void __exit ps3av_module_exit(void)
+{
+	device_unregister(&ps3av_dev.core);
+	ps3_vuart_port_driver_unregister(&ps3av_driver);
+}
+
+subsys_initcall(ps3av_module_init);
+module_exit(ps3av_module_exit);
diff -puN /dev/null drivers/ps3/ps3av_cmd.c
--- /dev/null
+++ a/drivers/ps3/ps3av_cmd.c
@@ -0,0 +1,1017 @@
+/*
+ * Copyright (C) 2006 Sony Computer Entertainment Inc.
+ * Copyright 2006, 2007 Sony Corporation
+ *
+ * AV backend support for PS3
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License as published
+ * by the Free Software Foundation; version 2 of the License.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License along
+ * with this program; if not, write to the Free Software Foundation, Inc.,
+ * 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
+ */
+
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/delay.h>
+#include <asm/ps3av.h>
+#include <asm/ps3.h>
+
+#include "vuart.h"
+
+static const struct video_fmt {
+	u32 format;
+	u32 order;
+} ps3av_video_fmt_table[] = {
+	{ PS3AV_CMD_VIDEO_FORMAT_ARGB_8BIT, PS3AV_CMD_VIDEO_ORDER_RGB },
+	{ PS3AV_CMD_VIDEO_FORMAT_ARGB_8BIT, PS3AV_CMD_VIDEO_ORDER_BGR },
+};
+
+static const struct {
+	int cs;
+	u32 av;
+	u32 bl;
+} ps3av_cs_video2av_table[] = {
+	{
+		.cs = PS3AV_CMD_VIDEO_CS_RGB_8,
+		.av = PS3AV_CMD_AV_CS_RGB_8,
+		.bl = PS3AV_CMD_AV_CS_8
+	}, {
+		.cs = PS3AV_CMD_VIDEO_CS_RGB_10,
+		.av = PS3AV_CMD_AV_CS_RGB_8,
+		.bl = PS3AV_CMD_AV_CS_8
+	}, {
+		.cs = PS3AV_CMD_VIDEO_CS_RGB_12,
+		.av = PS3AV_CMD_AV_CS_RGB_8,
+		.bl = PS3AV_CMD_AV_CS_8
+	}, {
+		.cs = PS3AV_CMD_VIDEO_CS_YUV444_8,
+		.av = PS3AV_CMD_AV_CS_YUV444_8,
+		.bl = PS3AV_CMD_AV_CS_8
+	}, {
+		.cs = PS3AV_CMD_VIDEO_CS_YUV444_10,
+		.av = PS3AV_CMD_AV_CS_YUV444_8,
+		.bl = PS3AV_CMD_AV_CS_10
+	}, {
+		.cs = PS3AV_CMD_VIDEO_CS_YUV444_12,
+		.av = PS3AV_CMD_AV_CS_YUV444_8,
+		.bl = PS3AV_CMD_AV_CS_10
+	}, {
+		.cs = PS3AV_CMD_VIDEO_CS_YUV422_8,
+		.av = PS3AV_CMD_AV_CS_YUV422_8,
+		.bl = PS3AV_CMD_AV_CS_10
+	}, {
+		.cs = PS3AV_CMD_VIDEO_CS_YUV422_10,
+		.av = PS3AV_CMD_AV_CS_YUV422_8,
+		.bl = PS3AV_CMD_AV_CS_10
+	}, {
+		.cs = PS3AV_CMD_VIDEO_CS_YUV422_12,
+		.av = PS3AV_CMD_AV_CS_YUV422_8,
+		.bl = PS3AV_CMD_AV_CS_12
+	}, {
+		.cs = PS3AV_CMD_VIDEO_CS_XVYCC_8,
+		.av = PS3AV_CMD_AV_CS_XVYCC_8,
+		.bl = PS3AV_CMD_AV_CS_12
+	}, {
+		.cs = PS3AV_CMD_VIDEO_CS_XVYCC_10,
+		.av = PS3AV_CMD_AV_CS_XVYCC_8,
+		.bl = PS3AV_CMD_AV_CS_12
+	}, {
+		.cs = PS3AV_CMD_VIDEO_CS_XVYCC_12,
+		.av = PS3AV_CMD_AV_CS_XVYCC_8,
+		.bl = PS3AV_CMD_AV_CS_12
+	}
+};
+
+static u32 ps3av_cs_video2av(int cs)
+{
+	unsigned int i;
+
+	for (i = 0; i < ARRAY_SIZE(ps3av_cs_video2av_table); i++)
+		if (ps3av_cs_video2av_table[i].cs == cs)
+			return ps3av_cs_video2av_table[i].av;
+
+	return PS3AV_CMD_AV_CS_RGB_8;
+}
+
+static u32 ps3av_cs_video2av_bitlen(int cs)
+{
+	unsigned int i;
+
+	for (i = 0; i < ARRAY_SIZE(ps3av_cs_video2av_table); i++)
+		if (ps3av_cs_video2av_table[i].cs == cs)
+			return ps3av_cs_video2av_table[i].bl;
+
+	return PS3AV_CMD_AV_CS_8;
+}
+
+static const struct {
+	int vid;
+	u32 av;
+} ps3av_vid_video2av_table[] = {
+	{ PS3AV_CMD_VIDEO_VID_480I, PS3AV_CMD_AV_VID_480I },
+	{ PS3AV_CMD_VIDEO_VID_480P, PS3AV_CMD_AV_VID_480P },
+	{ PS3AV_CMD_VIDEO_VID_576I, PS3AV_CMD_AV_VID_576I },
+	{ PS3AV_CMD_VIDEO_VID_576P, PS3AV_CMD_AV_VID_576P },
+	{ PS3AV_CMD_VIDEO_VID_1080I_60HZ, PS3AV_CMD_AV_VID_1080I_60HZ },
+	{ PS3AV_CMD_VIDEO_VID_720P_60HZ, PS3AV_CMD_AV_VID_720P_60HZ },
+	{ PS3AV_CMD_VIDEO_VID_1080P_60HZ, PS3AV_CMD_AV_VID_1080P_60HZ },
+	{ PS3AV_CMD_VIDEO_VID_1080I_50HZ, PS3AV_CMD_AV_VID_1080I_50HZ },
+	{ PS3AV_CMD_VIDEO_VID_720P_50HZ, PS3AV_CMD_AV_VID_720P_50HZ },
+	{ PS3AV_CMD_VIDEO_VID_1080P_50HZ, PS3AV_CMD_AV_VID_1080P_50HZ },
+	{ PS3AV_CMD_VIDEO_VID_WXGA, PS3AV_CMD_AV_VID_WXGA },
+	{ PS3AV_CMD_VIDEO_VID_SXGA, PS3AV_CMD_AV_VID_SXGA },
+	{ PS3AV_CMD_VIDEO_VID_WUXGA, PS3AV_CMD_AV_VID_WUXGA }
+};
+
+static u32 ps3av_vid_video2av(int vid)
+{
+	unsigned int i;
+
+	for (i = 0; i < ARRAY_SIZE(ps3av_vid_video2av_table); i++)
+		if (ps3av_vid_video2av_table[i].vid == vid)
+			return ps3av_vid_video2av_table[i].av;
+
+	return PS3AV_CMD_AV_VID_480P;
+}
+
+int ps3av_cmd_init(void)
+{
+	int res;
+	struct ps3av_pkt_av_init av_init;
+	struct ps3av_pkt_video_init video_init;
+	struct ps3av_pkt_audio_init audio_init;
+
+	/* video init */
+	memset(&video_init, 0, sizeof(video_init));
+
+	res = ps3av_do_pkt(PS3AV_CID_VIDEO_INIT, sizeof(video_init.send_hdr),
+			   sizeof(video_init), &video_init.send_hdr);
+	if (res < 0)
+		return res;
+
+	res = get_status(&video_init);
+	if (res) {
+		printk(KERN_ERR "PS3AV_CID_VIDEO_INIT: failed %x\n", res);
+		return res;
+	}
+
+	/* audio init */
+	memset(&audio_init, 0, sizeof(audio_init));
+
+	res = ps3av_do_pkt(PS3AV_CID_AUDIO_INIT, sizeof(audio_init.send_hdr),
+			   sizeof(audio_init), &audio_init.send_hdr);
+	if (res < 0)
+		return res;
+
+	res = get_status(&audio_init);
+	if (res) {
+		printk(KERN_ERR "PS3AV_CID_AUDIO_INIT: failed %x\n", res);
+		return res;
+	}
+
+	/* av init */
+	memset(&av_init, 0, sizeof(av_init));
+	av_init.event_bit = 0;
+
+	res = ps3av_do_pkt(PS3AV_CID_AV_INIT, sizeof(av_init), sizeof(av_init),
+			   &av_init.send_hdr);
+	if (res < 0)
+		return res;
+
+	res = get_status(&av_init);
+	if (res)
+		printk(KERN_ERR "PS3AV_CID_AV_INIT: failed %x\n", res);
+
+	return res;
+}
+
+int ps3av_cmd_fin(void)
+{
+	int res;
+	struct ps3av_pkt_av_fin av_fin;
+
+	memset(&av_fin, 0, sizeof(av_fin));
+
+	res = ps3av_do_pkt(PS3AV_CID_AV_FIN, sizeof(av_fin.send_hdr),
+			   sizeof(av_fin), &av_fin.send_hdr);
+	if (res < 0)
+		return res;
+
+	res = get_status(&av_fin);
+	if (res)
+		printk(KERN_ERR "PS3AV_CID_AV_FIN: failed %x\n", res);
+
+	return res;
+}
+
+int ps3av_cmd_av_video_mute(int num_of_port, u32 *port, u32 mute)
+{
+	int i, send_len, res;
+	struct ps3av_pkt_av_video_mute av_video_mute;
+
+	if (num_of_port > PS3AV_MUTE_PORT_MAX)
+		return -EINVAL;
+
+	memset(&av_video_mute, 0, sizeof(av_video_mute));
+	for (i = 0; i < num_of_port; i++) {
+		av_video_mute.mute[i].avport = port[i];
+		av_video_mute.mute[i].mute = mute;
+	}
+
+	send_len = sizeof(av_video_mute.send_hdr) +
+	    sizeof(struct ps3av_av_mute) * num_of_port;
+	res = ps3av_do_pkt(PS3AV_CID_AV_VIDEO_MUTE, send_len,
+			   sizeof(av_video_mute), &av_video_mute.send_hdr);
+	if (res < 0)
+		return res;
+
+	res = get_status(&av_video_mute);
+	if (res)
+		printk(KERN_ERR "PS3AV_CID_AV_VIDEO_MUTE: failed %x\n", res);
+
+	return res;
+}
+
+int ps3av_cmd_av_video_disable_sig(u32 port)
+{
+	int res;
+	struct ps3av_pkt_av_video_disable_sig av_video_sig;
+
+	memset(&av_video_sig, 0, sizeof(av_video_sig));
+	av_video_sig.avport = port;
+
+	res = ps3av_do_pkt(PS3AV_CID_AV_VIDEO_DISABLE_SIG,
+			   sizeof(av_video_sig), sizeof(av_video_sig),
+			   &av_video_sig.send_hdr);
+	if (res < 0)
+		return res;
+
+	res = get_status(&av_video_sig);
+	if (res)
+		printk(KERN_ERR
+		       "PS3AV_CID_AV_VIDEO_DISABLE_SIG: failed %x port:%x\n",
+		       res, port);
+
+	return res;
+}
+
+int ps3av_cmd_av_tv_mute(u32 avport, u32 mute)
+{
+	int res;
+	struct ps3av_pkt_av_tv_mute tv_mute;
+
+	memset(&tv_mute, 0, sizeof(tv_mute));
+	tv_mute.avport = avport;
+	tv_mute.mute = mute;
+
+	res = ps3av_do_pkt(PS3AV_CID_AV_TV_MUTE, sizeof(tv_mute),
+			   sizeof(tv_mute), &tv_mute.send_hdr);
+	if (res < 0)
+		return res;
+
+	res = get_status(&tv_mute);
+	if (res)
+		printk(KERN_ERR "PS3AV_CID_AV_TV_MUTE: failed %x port:%x\n",
+		       res, avport);
+
+	return res;
+}
+
+int ps3av_cmd_enable_event(void)
+{
+	int res;
+	struct ps3av_pkt_av_event av_event;
+
+	memset(&av_event, 0, sizeof(av_event));
+	av_event.event_bit = PS3AV_CMD_EVENT_BIT_UNPLUGGED |
+	    PS3AV_CMD_EVENT_BIT_PLUGGED | PS3AV_CMD_EVENT_BIT_HDCP_DONE;
+
+	res = ps3av_do_pkt(PS3AV_CID_AV_ENABLE_EVENT, sizeof(av_event),
+			   sizeof(av_event), &av_event.send_hdr);
+	if (res < 0)
+		return res;
+
+	res = get_status(&av_event);
+	if (res)
+		printk(KERN_ERR "PS3AV_CID_AV_ENABLE_EVENT: failed %x\n", res);
+
+	return res;
+}
+
+int ps3av_cmd_av_hdmi_mode(u8 mode)
+{
+	int res;
+	struct ps3av_pkt_av_hdmi_mode hdmi_mode;
+
+	memset(&hdmi_mode, 0, sizeof(hdmi_mode));
+	hdmi_mode.mode = mode;
+
+	res = ps3av_do_pkt(PS3AV_CID_AV_HDMI_MODE, sizeof(hdmi_mode),
+			   sizeof(hdmi_mode), &hdmi_mode.send_hdr);
+	if (res < 0)
+		return res;
+
+	res = get_status(&hdmi_mode);
+	if (res && res != PS3AV_STATUS_UNSUPPORTED_HDMI_MODE)
+		printk(KERN_ERR "PS3AV_CID_AV_HDMI_MODE: failed %x\n", res);
+
+	return res;
+}
+
+u32 ps3av_cmd_set_av_video_cs(void *p, u32 avport, int video_vid, int cs_out,
+			      int aspect, u32 id)
+{
+	struct ps3av_pkt_av_video_cs *av_video_cs;
+
+	av_video_cs = (struct ps3av_pkt_av_video_cs *)p;
+	if (video_vid == -1)
+		video_vid = PS3AV_CMD_VIDEO_VID_720P_60HZ;
+	if (cs_out == -1)
+		cs_out = PS3AV_CMD_VIDEO_CS_YUV444_8;
+	if (aspect == -1)
+		aspect = 0;
+
+	memset(av_video_cs, 0, sizeof(*av_video_cs));
+	ps3av_set_hdr(PS3AV_CID_AV_VIDEO_CS, sizeof(*av_video_cs),
+		      &av_video_cs->send_hdr);
+	av_video_cs->avport = avport;
+	/* should be same as video_mode.resolution */
+	av_video_cs->av_vid = ps3av_vid_video2av(video_vid);
+	av_video_cs->av_cs_out = ps3av_cs_video2av(cs_out);
+	/* should be same as video_mode.video_cs_out */
+	av_video_cs->av_cs_in = ps3av_cs_video2av(PS3AV_CMD_VIDEO_CS_RGB_8);
+	av_video_cs->bitlen_out = ps3av_cs_video2av_bitlen(cs_out);
+	av_video_cs->aspect = aspect;
+	if (id & PS3AV_MODE_DITHER) {
+		av_video_cs->dither = PS3AV_CMD_AV_DITHER_ON
+		    | PS3AV_CMD_AV_DITHER_8BIT;
+	} else {
+		/* default off */
+		av_video_cs->dither = PS3AV_CMD_AV_DITHER_OFF;
+	}
+
+	return sizeof(*av_video_cs);
+}
+
+u32 ps3av_cmd_set_video_mode(void *p, u32 head, int video_vid, int video_fmt,
+			     u32 id)
+{
+	struct ps3av_pkt_video_mode *video_mode;
+	u32 x, y;
+
+	video_mode = (struct ps3av_pkt_video_mode *)p;
+	if (video_vid == -1)
+		video_vid = PS3AV_CMD_VIDEO_VID_720P_60HZ;
+	if (video_fmt == -1)
+		video_fmt = PS3AV_CMD_VIDEO_FMT_X8R8G8B8;
+
+	if (ps3av_video_mode2res(id, &x, &y))
+		return 0;
+
+	/* video mode */
+	memset(video_mode, 0, sizeof(*video_mode));
+	ps3av_set_hdr(PS3AV_CID_VIDEO_MODE, sizeof(*video_mode),
+		      &video_mode->send_hdr);
+	video_mode->video_head = head;
+	if (video_vid == PS3AV_CMD_VIDEO_VID_480I
+	    && head == PS3AV_CMD_VIDEO_HEAD_B)
+		video_mode->video_vid = PS3AV_CMD_VIDEO_VID_480I_A;
+	else
+		video_mode->video_vid = video_vid;
+	video_mode->width = (u16) x;
+	video_mode->height = (u16) y;
+	video_mode->pitch = video_mode->width * 4;	/* line_length */
+	video_mode->video_out_format = PS3AV_CMD_VIDEO_OUT_FORMAT_RGB_12BIT;
+	video_mode->video_format = ps3av_video_fmt_table[video_fmt].format;
+	video_mode->video_order = ps3av_video_fmt_table[video_fmt].order;
+
+	pr_debug("%s: video_mode:vid:%x width:%d height:%d pitch:%d out_format:%d format:%x order:%x\n",
+		__FUNCTION__, video_vid, video_mode->width, video_mode->height,
+		video_mode->pitch, video_mode->video_out_format,
+		video_mode->video_format, video_mode->video_order);
+	return sizeof(*video_mode);
+}
+
+int ps3av_cmd_video_format_black(u32 head, u32 video_fmt, u32 mute)
+{
+	int res;
+	struct ps3av_pkt_video_format video_format;
+
+	memset(&video_format, 0, sizeof(video_format));
+	video_format.video_head = head;
+	if (mute != PS3AV_CMD_MUTE_OFF)
+		video_format.video_format = PS3AV_CMD_VIDEO_FORMAT_BLACK;
+	else
+		video_format.video_format =
+		    ps3av_video_fmt_table[video_fmt].format;
+	video_format.video_order = ps3av_video_fmt_table[video_fmt].order;
+
+	res = ps3av_do_pkt(PS3AV_CID_VIDEO_FORMAT, sizeof(video_format),
+			   sizeof(video_format), &video_format.send_hdr);
+	if (res < 0)
+		return res;
+
+	res = get_status(&video_format);
+	if (res)
+		printk(KERN_ERR "PS3AV_CID_VIDEO_FORMAT: failed %x\n", res);
+
+	return res;
+}
+
+
+int ps3av_cmd_av_audio_mute(int num_of_port, u32 *port, u32 mute)
+{
+	int i, res;
+	struct ps3av_pkt_av_audio_mute av_audio_mute;
+
+	if (num_of_port > PS3AV_MUTE_PORT_MAX)
+		return -EINVAL;
+
+	/* audio mute */
+	memset(&av_audio_mute, 0, sizeof(av_audio_mute));
+	for (i = 0; i < num_of_port; i++) {
+		av_audio_mute.mute[i].avport = port[i];
+		av_audio_mute.mute[i].mute = mute;
+	}
+
+	res = ps3av_do_pkt(PS3AV_CID_AV_AUDIO_MUTE,
+			   sizeof(av_audio_mute.send_hdr) +
+			   sizeof(struct ps3av_av_mute) * num_of_port,
+			   sizeof(av_audio_mute), &av_audio_mute.send_hdr);
+	if (res < 0)
+		return res;
+
+	res = get_status(&av_audio_mute);
+	if (res)
+		printk(KERN_ERR "PS3AV_CID_AV_AUDIO_MUTE: failed %x\n", res);
+
+	return res;
+}
+
+static const struct {
+	u32 fs;
+	u8 mclk;
+} ps3av_cnv_mclk_table[] = {
+	{ PS3AV_CMD_AUDIO_FS_44K, PS3AV_CMD_AV_MCLK_512 },
+	{ PS3AV_CMD_AUDIO_FS_48K, PS3AV_CMD_AV_MCLK_512 },
+	{ PS3AV_CMD_AUDIO_FS_88K, PS3AV_CMD_AV_MCLK_256 },
+	{ PS3AV_CMD_AUDIO_FS_96K, PS3AV_CMD_AV_MCLK_256 },
+	{ PS3AV_CMD_AUDIO_FS_176K, PS3AV_CMD_AV_MCLK_128 },
+	{ PS3AV_CMD_AUDIO_FS_192K, PS3AV_CMD_AV_MCLK_128 }
+};
+
+static u8 ps3av_cnv_mclk(u32 fs)
+{
+	unsigned int i;
+
+	for (i = 0; i < ARRAY_SIZE(ps3av_cnv_mclk_table); i++)
+		if (ps3av_cnv_mclk_table[i].fs == fs)
+			return ps3av_cnv_mclk_table[i].mclk;
+
+	printk(KERN_ERR "%s failed, fs:%x\n", __FUNCTION__, fs);
+	return 0;
+}
+
+#define BASE	PS3AV_CMD_AUDIO_FS_44K
+
+static const u32 ps3av_ns_table[][5] = {
+					/*   D1,    D2,    D3,    D4,    D5 */
+	[PS3AV_CMD_AUDIO_FS_44K-BASE]	{  6272,  6272, 17836, 17836,  8918 },
+	[PS3AV_CMD_AUDIO_FS_48K-BASE]	{  6144,  6144, 11648, 11648,  5824 },
+	[PS3AV_CMD_AUDIO_FS_88K-BASE]	{ 12544, 12544, 35672, 35672, 17836 },
+	[PS3AV_CMD_AUDIO_FS_96K-BASE]	{ 12288, 12288, 23296, 23296, 11648 },
+	[PS3AV_CMD_AUDIO_FS_176K-BASE]	{ 25088, 25088, 71344, 71344, 35672 },
+	[PS3AV_CMD_AUDIO_FS_192K-BASE]	{ 24576, 24576, 46592, 46592, 23296 }
+};
+
+static void ps3av_cnv_ns(u8 *ns, u32 fs, u32 video_vid)
+{
+	u32 av_vid, ns_val;
+	u8 *p = ns;
+	int d;
+
+	d = ns_val = 0;
+	av_vid = ps3av_vid_video2av(video_vid);
+	switch (av_vid) {
+	case PS3AV_CMD_AV_VID_480I:
+	case PS3AV_CMD_AV_VID_576I:
+		d = 0;
+		break;
+	case PS3AV_CMD_AV_VID_480P:
+	case PS3AV_CMD_AV_VID_576P:
+		d = 1;
+		break;
+	case PS3AV_CMD_AV_VID_1080I_60HZ:
+	case PS3AV_CMD_AV_VID_1080I_50HZ:
+		d = 2;
+		break;
+	case PS3AV_CMD_AV_VID_720P_60HZ:
+	case PS3AV_CMD_AV_VID_720P_50HZ:
+		d = 3;
+		break;
+	case PS3AV_CMD_AV_VID_1080P_60HZ:
+	case PS3AV_CMD_AV_VID_1080P_50HZ:
+	case PS3AV_CMD_AV_VID_WXGA:
+	case PS3AV_CMD_AV_VID_SXGA:
+	case PS3AV_CMD_AV_VID_WUXGA:
+		d = 4;
+		break;
+	default:
+		printk(KERN_ERR "%s failed, vid:%x\n", __FUNCTION__,
+		       video_vid);
+		break;
+	}
+
+	if (fs < PS3AV_CMD_AUDIO_FS_44K || fs > PS3AV_CMD_AUDIO_FS_192K)
+		printk(KERN_ERR "%s failed, fs:%x\n", __FUNCTION__, fs);
+	else
+		ns_val = ps3av_ns_table[PS3AV_CMD_AUDIO_FS_44K-BASE][d];
+
+	*p++ = ns_val & 0x000000FF;
+	*p++ = (ns_val & 0x0000FF00) >> 8;
+	*p = (ns_val & 0x00FF0000) >> 16;
+}
+
+#undef BASE
+
+static u8 ps3av_cnv_enable(u32 source, u8 *enable)
+{
+	u8 *p, ret = 0;
+
+	if (source == PS3AV_CMD_AUDIO_SOURCE_SPDIF) {
+		ret = 0x03;
+	} else if (source == PS3AV_CMD_AUDIO_SOURCE_SERIAL) {
+		p = enable;
+		ret = ((p[0] << 4) + (p[1] << 5) + (p[2] << 6) + (p[3] << 7)) |
+		      0x01;
+	} else
+		printk(KERN_ERR "%s failed, source:%x\n", __FUNCTION__,
+		       source);
+	return ret;
+}
+
+static u8 ps3av_cnv_fifomap(u8 *map)
+{
+	u8 *p, ret = 0;
+
+	p = map;
+	ret = p[0] + (p[1] << 2) + (p[2] << 4) + (p[3] << 6);
+	return ret;
+}
+
+static u8 ps3av_cnv_inputlen(u32 word_bits)
+{
+	u8 ret = 0;
+
+	switch (word_bits) {
+	case PS3AV_CMD_AUDIO_WORD_BITS_16:
+		ret = PS3AV_CMD_AV_INPUTLEN_16;
+		break;
+	case PS3AV_CMD_AUDIO_WORD_BITS_20:
+		ret = PS3AV_CMD_AV_INPUTLEN_20;
+		break;
+	case PS3AV_CMD_AUDIO_WORD_BITS_24:
+		ret = PS3AV_CMD_AV_INPUTLEN_24;
+		break;
+	default:
+		printk(KERN_ERR "%s failed, word_bits:%x\n", __FUNCTION__,
+		       word_bits);
+		break;
+	}
+	return ret;
+}
+
+static u8 ps3av_cnv_layout(u32 num_of_ch)
+{
+	if (num_of_ch > PS3AV_CMD_AUDIO_NUM_OF_CH_8) {
+		printk(KERN_ERR "%s failed, num_of_ch:%x\n", __FUNCTION__,
+		       num_of_ch);
+		return 0;
+	}
+
+	return num_of_ch == PS3AV_CMD_AUDIO_NUM_OF_CH_2 ? 0x0 : 0x1;
+}
+
+static void ps3av_cnv_info(struct ps3av_audio_info_frame *info,
+			   const struct ps3av_pkt_audio_mode *mode)
+{
+	info->pb1.cc = mode->audio_num_of_ch + 1;	/* CH2:0x01 --- CH8:0x07 */
+	info->pb1.ct = 0;
+	info->pb2.sf = 0;
+	info->pb2.ss = 0;
+
+	info->pb3 = 0;		/* check mode->audio_format ?? */
+	info->pb4 = mode->audio_layout;
+	info->pb5.dm = mode->audio_downmix;
+	info->pb5.lsv = mode->audio_downmix_level;
+}
+
+static void ps3av_cnv_chstat(u8 *chstat, u8 *cs_info)
+{
+	memcpy(chstat, cs_info, 5);
+}
+
+u32 ps3av_cmd_set_av_audio_param(void *p, u32 port,
+				 const struct ps3av_pkt_audio_mode *audio_mode,
+				 u32 video_vid)
+{
+	struct ps3av_pkt_av_audio_param *param;
+
+	param = (struct ps3av_pkt_av_audio_param *)p;
+
+	memset(param, 0, sizeof(*param));
+	ps3av_set_hdr(PS3AV_CID_AV_AUDIO_PARAM, sizeof(*param),
+		      &param->send_hdr);
+
+	param->avport = port;
+	param->mclk = ps3av_cnv_mclk(audio_mode->audio_fs) | 0x80;
+	ps3av_cnv_ns(param->ns, audio_mode->audio_fs, video_vid);
+	param->enable = ps3av_cnv_enable(audio_mode->audio_source,
+					 audio_mode->audio_enable);
+	param->swaplr = 0x09;
+	param->fifomap = ps3av_cnv_fifomap(audio_mode->audio_map);
+	param->inputctrl = 0x49;
+	param->inputlen = ps3av_cnv_inputlen(audio_mode->audio_word_bits);
+	param->layout = ps3av_cnv_layout(audio_mode->audio_num_of_ch);
+	ps3av_cnv_info(&param->info, audio_mode);
+	ps3av_cnv_chstat(param->chstat, audio_mode->audio_cs_info);
+
+	return sizeof(*param);
+}
+
+/* default cs val */
+static const u8 ps3av_mode_cs_info[] = {
+	0x00, 0x09, 0x00, 0x02, 0x01, 0x00, 0x00, 0x00
+};
+
+#define CS_44	0x00
+#define CS_48	0x02
+#define CS_88	0x08
+#define CS_96	0x0a
+#define CS_176	0x0c
+#define CS_192	0x0e
+#define CS_MASK	0x0f
+#define CS_BIT	0x40
+
+void ps3av_cmd_set_audio_mode(struct ps3av_pkt_audio_mode *audio, u32 avport,
+			      u32 ch, u32 fs, u32 word_bits, u32 format,
+			      u32 source)
+{
+	int spdif_through, spdif_bitstream;
+	int i;
+
+	if (!(ch | fs | format | word_bits | source)) {
+		ch = PS3AV_CMD_AUDIO_NUM_OF_CH_2;
+		fs = PS3AV_CMD_AUDIO_FS_48K;
+		word_bits = PS3AV_CMD_AUDIO_WORD_BITS_16;
+		format = PS3AV_CMD_AUDIO_FORMAT_PCM;
+		source = PS3AV_CMD_AUDIO_SOURCE_SERIAL;
+	}
+	spdif_through = spdif_bitstream = 0;	/* XXX not supported */
+
+	/* audio mode */
+	memset(audio, 0, sizeof(*audio));
+	ps3av_set_hdr(PS3AV_CID_AUDIO_MODE, sizeof(*audio), &audio->send_hdr);
+
+	audio->avport = (u8) avport;
+	audio->mask = 0x0FFF;	/* XXX set all */
+	audio->audio_num_of_ch = ch;
+	audio->audio_fs = fs;
+	audio->audio_word_bits = word_bits;
+	audio->audio_format = format;
+	audio->audio_source = source;
+
+	switch (ch) {
+	case PS3AV_CMD_AUDIO_NUM_OF_CH_8:
+		audio->audio_enable[3] = 1;
+		/* fall through */
+	case PS3AV_CMD_AUDIO_NUM_OF_CH_6:
+		audio->audio_enable[2] = 1;
+		audio->audio_enable[1] = 1;
+		/* fall through */
+	case PS3AV_CMD_AUDIO_NUM_OF_CH_2:
+	default:
+		audio->audio_enable[0] = 1;
+	}
+
+	/* audio swap L/R */
+	for (i = 0; i < 4; i++)
+		audio->audio_swap[i] = PS3AV_CMD_AUDIO_SWAP_0;	/* no swap */
+
+	/* audio serial input mapping */
+	audio->audio_map[0] = PS3AV_CMD_AUDIO_MAP_OUTPUT_0;
+	audio->audio_map[1] = PS3AV_CMD_AUDIO_MAP_OUTPUT_1;
+	audio->audio_map[2] = PS3AV_CMD_AUDIO_MAP_OUTPUT_2;
+	audio->audio_map[3] = PS3AV_CMD_AUDIO_MAP_OUTPUT_3;
+
+	/* audio speaker layout */
+	if (avport == PS3AV_CMD_AVPORT_HDMI_0 ||
+	    avport == PS3AV_CMD_AVPORT_HDMI_1) {
+		switch (ch) {
+		case PS3AV_CMD_AUDIO_NUM_OF_CH_8:
+			audio->audio_layout = PS3AV_CMD_AUDIO_LAYOUT_8CH;
+			break;
+		case PS3AV_CMD_AUDIO_NUM_OF_CH_6:
+			audio->audio_layout = PS3AV_CMD_AUDIO_LAYOUT_6CH;
+			break;
+		case PS3AV_CMD_AUDIO_NUM_OF_CH_2:
+		default:
+			audio->audio_layout = PS3AV_CMD_AUDIO_LAYOUT_2CH;
+			break;
+		}
+	} else {
+		audio->audio_layout = PS3AV_CMD_AUDIO_LAYOUT_2CH;
+	}
+
+	/* audio downmix permission */
+	audio->audio_downmix = PS3AV_CMD_AUDIO_DOWNMIX_PERMITTED;
+	/* audio downmix level shift (0:0dB to 15:15dB) */
+	audio->audio_downmix_level = 0;	/* 0dB */
+
+	/* set ch status */
+	for (i = 0; i < 8; i++)
+		audio->audio_cs_info[i] = ps3av_mode_cs_info[i];
+
+	switch (fs) {
+	case PS3AV_CMD_AUDIO_FS_44K:
+		audio->audio_cs_info[3] &= ~CS_MASK;
+		audio->audio_cs_info[3] |= CS_44;
+		break;
+	case PS3AV_CMD_AUDIO_FS_88K:
+		audio->audio_cs_info[3] &= ~CS_MASK;
+		audio->audio_cs_info[3] |= CS_88;
+		break;
+	case PS3AV_CMD_AUDIO_FS_96K:
+		audio->audio_cs_info[3] &= ~CS_MASK;
+		audio->audio_cs_info[3] |= CS_96;
+		break;
+	case PS3AV_CMD_AUDIO_FS_176K:
+		audio->audio_cs_info[3] &= ~CS_MASK;
+		audio->audio_cs_info[3] |= CS_176;
+		break;
+	case PS3AV_CMD_AUDIO_FS_192K:
+		audio->audio_cs_info[3] &= ~CS_MASK;
+		audio->audio_cs_info[3] |= CS_192;
+		break;
+	default:
+		break;
+	}
+
+	/* pass through setting */
+	if (spdif_through &&
+	    (avport == PS3AV_CMD_AVPORT_SPDIF_0 ||
+	     avport == PS3AV_CMD_AVPORT_SPDIF_1)) {
+		audio->audio_word_bits = PS3AV_CMD_AUDIO_WORD_BITS_16;
+		audio->audio_source = PS3AV_CMD_AUDIO_SOURCE_SPDIF;
+		if (spdif_bitstream) {
+			audio->audio_format = PS3AV_CMD_AUDIO_FORMAT_BITSTREAM;
+			audio->audio_cs_info[0] |= CS_BIT;
+		}
+	}
+}
+
+int ps3av_cmd_audio_mode(struct ps3av_pkt_audio_mode *audio_mode)
+{
+	int res;
+
+	res = ps3av_do_pkt(PS3AV_CID_AUDIO_MODE, sizeof(*audio_mode),
+			   sizeof(*audio_mode), &audio_mode->send_hdr);
+	if (res < 0)
+		return res;
+
+	res = get_status(audio_mode);
+	if (res)
+		printk(KERN_ERR "PS3AV_CID_AUDIO_MODE: failed %x\n", res);
+
+	return res;
+}
+
+int ps3av_cmd_audio_mute(int num_of_port, u32 *port, u32 mute)
+{
+	int i, res;
+	struct ps3av_pkt_audio_mute audio_mute;
+
+	if (num_of_port > PS3AV_OPT_PORT_MAX)
+		return -EINVAL;
+
+	/* audio mute */
+	memset(&audio_mute, 0, sizeof(audio_mute));
+	for (i = 0; i < num_of_port; i++) {
+		audio_mute.mute[i].avport = port[i];
+		audio_mute.mute[i].mute = mute;
+	}
+
+	res = ps3av_do_pkt(PS3AV_CID_AUDIO_MUTE,
+			   sizeof(audio_mute.send_hdr) +
+			   sizeof(struct ps3av_audio_mute) * num_of_port,
+			   sizeof(audio_mute), &audio_mute.send_hdr);
+	if (res < 0)
+		return res;
+
+	res = get_status(&audio_mute);
+	if (res)
+		printk(KERN_ERR "PS3AV_CID_AUDIO_MUTE: failed %x\n", res);
+
+	return res;
+}
+
+int ps3av_cmd_audio_active(int active, u32 port)
+{
+	int res;
+	struct ps3av_pkt_audio_active audio_active;
+	u32 cid;
+
+	/* audio active */
+	memset(&audio_active, 0, sizeof(audio_active));
+	audio_active.audio_port = port;
+	cid = active ? PS3AV_CID_AUDIO_ACTIVE : PS3AV_CID_AUDIO_INACTIVE;
+
+	res = ps3av_do_pkt(cid, sizeof(audio_active), sizeof(audio_active),
+			   &audio_active.send_hdr);
+	if (res < 0)
+		return res;
+
+	res = get_status(&audio_active);
+	if (res)
+		printk(KERN_ERR "PS3AV_CID_AUDIO_ACTIVE:%x failed %x\n", cid,
+		       res);
+
+	return res;
+}
+
+int ps3av_cmd_avb_param(struct ps3av_pkt_avb_param *avb, u32 send_len)
+{
+	int res;
+
+	/* avb packet */
+
+	res = ps3av_do_pkt(PS3AV_CID_AVB_PARAM, send_len, sizeof(*avb),
+			   &avb->send_hdr);
+	if (res < 0)
+		goto out;
+
+	res = get_status(avb);
+	if (res)
+		pr_debug("%s: PS3AV_CID_AVB_PARAM: failed %x\n", __FUNCTION__,
+			 res);
+
+      out:
+	return res;
+}
+
+int ps3av_cmd_av_get_hw_conf(struct ps3av_pkt_av_get_hw_conf *hw_conf)
+{
+	int res;
+
+	memset(hw_conf, 0, sizeof(*hw_conf));
+
+	res = ps3av_do_pkt(PS3AV_CID_AV_GET_HW_CONF, sizeof(hw_conf->send_hdr),
+			   sizeof(*hw_conf), &hw_conf->send_hdr);
+	if (res < 0)
+		return res;
+
+	res = get_status(hw_conf);
+	if (res)
+		printk(KERN_ERR "PS3AV_CID_AV_GET_HW_CONF: failed %x\n", res);
+
+	return res;
+}
+
+int ps3av_cmd_video_get_monitor_info(struct ps3av_pkt_av_get_monitor_info *info,
+				     u32 avport)
+{
+	int res;
+
+	memset(info, 0, sizeof(*info));
+	info->avport = avport;
+
+	res = ps3av_do_pkt(PS3AV_CID_AV_GET_MONITOR_INFO,
+			   sizeof(info->send_hdr) + sizeof(info->avport) +
+			   sizeof(info->reserved),
+			   sizeof(*info), &info->send_hdr);
+	if (res < 0)
+		return res;
+
+	res = get_status(info);
+	if (res)
+		printk(KERN_ERR "PS3AV_CID_AV_GET_MONITOR_INFO: failed %x\n",
+		       res);
+
+	return res;
+}
+
+#ifdef PS3AV_DEBUG
+void ps3av_cmd_av_hw_conf_dump(const struct ps3av_pkt_av_get_hw_conf *hw_conf)
+{
+	printk("av_h_conf:num of hdmi:%d\n", hw_conf->num_of_hdmi);
+	printk("av_h_conf:num of avmulti:%d\n", hw_conf->num_of_avmulti);
+	printk("av_h_conf:num of spdif:%d\n", hw_conf->num_of_spdif);
+}
+
+void ps3av_cmd_av_monitor_info_dump(const struct ps3av_pkt_av_get_monitor_info *monitor_info)
+{
+	const struct ps3av_info_monitor *info = &monitor_info->info;
+	const struct ps3av_info_audio *audio = info->audio;
+	int i;
+
+	printk("Monitor Info: size%d\n", monitor_info->send_hdr.size);
+
+	printk("avport:%02x\n", info->avport);
+	printk("monitor_id:");
+	for (i = 0; i < 10; i++)
+		printk("%02x ", info->monitor_id[i]);
+	printk("\nmonitor_type:%02x\n", info->monitor_type);
+	printk("monitor_name:");
+	for (i = 0; i < 16; i++)
+		printk("%c", info->monitor_name[i]);
+
+	/* resolution */
+	printk("\nresolution_60: bits:%08x native:%08x\n",
+	       info->res_60.res_bits, info->res_60.native);
+	printk("resolution_50: bits:%08x native:%08x\n",
+	       info->res_50.res_bits, info->res_50.native);
+	printk("resolution_other: bits:%08x native:%08x\n",
+	       info->res_other.res_bits, info->res_other.native);
+	printk("resolution_vesa: bits:%08x native:%08x\n",
+	       info->res_vesa.res_bits, info->res_vesa.native);
+
+	/* color space */
+	printk("color space    rgb:%02x\n", info->cs.rgb);
+	printk("color space yuv444:%02x\n", info->cs.yuv444);
+	printk("color space yuv422:%02x\n", info->cs.yuv422);
+
+	/* color info */
+	printk("color info   red:X %04x Y %04x\n",
+	       info->color.red_x, info->color.red_y);
+	printk("color info green:X %04x Y %04x\n",
+	       info->color.green_x, info->color.green_y);
+	printk("color info  blue:X %04x Y %04x\n",
+	       info->color.blue_x, info->color.blue_y);
+	printk("color info white:X %04x Y %04x\n",
+	       info->color.white_x, info->color.white_y);
+	printk("color info gamma: %08x\n", info->color.gamma);
+
+	/* other info */
+	printk("supported_AI:%02x\n", info->supported_ai);
+	printk("speaker_info:%02x\n", info->speaker_info);
+	printk("num of audio:%02x\n", info->num_of_audio_block);
+
+	/* audio block */
+	for (i = 0; i < info->num_of_audio_block; i++) {
+		printk("audio[%d] type:%02x max_ch:%02x fs:%02x sbit:%02x\n",
+		       i, audio->type, audio->max_num_of_ch, audio->fs,
+		       audio->sbit);
+		audio++;
+	}
+}
+#endif /* PS3AV_DEBUG */
+
+#define PS3AV_AV_LAYOUT_0 (PS3AV_CMD_AV_LAYOUT_32 \
+		| PS3AV_CMD_AV_LAYOUT_44 \
+		| PS3AV_CMD_AV_LAYOUT_48)
+
+#define PS3AV_AV_LAYOUT_1 (PS3AV_AV_LAYOUT_0 \
+		| PS3AV_CMD_AV_LAYOUT_88 \
+		| PS3AV_CMD_AV_LAYOUT_96 \
+		| PS3AV_CMD_AV_LAYOUT_176 \
+		| PS3AV_CMD_AV_LAYOUT_192)
+
+/************************* vuart ***************************/
+
+#define POLLING_INTERVAL  25	/* in msec */
+
+int ps3av_vuart_write(struct ps3_vuart_port_device *dev, const void *buf,
+		      unsigned long size)
+{
+	int error = ps3_vuart_write(dev, buf, size);
+	return error ? error : size;
+}
+
+int ps3av_vuart_read(struct ps3_vuart_port_device *dev, void *buf,
+		     unsigned long size, int timeout)
+{
+	int error;
+	int loopcnt = 0;
+
+	timeout = (timeout + POLLING_INTERVAL - 1) / POLLING_INTERVAL;
+	while (loopcnt++ <= timeout) {
+		error = ps3_vuart_read(dev, buf, size);
+		if (!error)
+			return size;
+		if (error != -EAGAIN) {
+			printk(KERN_ERR "%s: ps3_vuart_read failed %d\n",
+			       __FUNCTION__, error);
+			return error;
+		}
+		msleep(POLLING_INTERVAL);
+	}
+	return -EWOULDBLOCK;
+}
diff -puN /dev/null include/asm-powerpc/ps3av.h
--- /dev/null
+++ a/include/asm-powerpc/ps3av.h
@@ -0,0 +1,738 @@
+/*
+ * Copyright (C) 2006 Sony Computer Entertainment Inc.
+ * Copyright 2006, 2007 Sony Corporation
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License as published
+ * by the Free Software Foundation; version 2 of the License.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License along
+ * with this program; if not, write to the Free Software Foundation, Inc.,
+ * 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
+ */
+#ifndef _ASM_POWERPC_PS3AV_H_
+#define _ASM_POWERPC_PS3AV_H_
+
+#include <linux/mutex.h>
+
+/** command for ioctl() **/
+#define PS3AV_VERSION 0x205	/* version of ps3av command */
+
+#define PS3AV_CID_AV_INIT              0x00000001
+#define PS3AV_CID_AV_FIN               0x00000002
+#define PS3AV_CID_AV_GET_HW_CONF       0x00000003
+#define PS3AV_CID_AV_GET_MONITOR_INFO  0x00000004
+#define PS3AV_CID_AV_ENABLE_EVENT      0x00000006
+#define PS3AV_CID_AV_DISABLE_EVENT     0x00000007
+#define PS3AV_CID_AV_TV_MUTE           0x0000000a
+
+#define PS3AV_CID_AV_VIDEO_CS          0x00010001
+#define PS3AV_CID_AV_VIDEO_MUTE        0x00010002
+#define PS3AV_CID_AV_VIDEO_DISABLE_SIG 0x00010003
+#define PS3AV_CID_AV_AUDIO_PARAM       0x00020001
+#define PS3AV_CID_AV_AUDIO_MUTE        0x00020002
+#define PS3AV_CID_AV_HDMI_MODE         0x00040001
+
+#define PS3AV_CID_VIDEO_INIT           0x01000001
+#define PS3AV_CID_VIDEO_MODE           0x01000002
+#define PS3AV_CID_VIDEO_FORMAT         0x01000004
+#define PS3AV_CID_VIDEO_PITCH          0x01000005
+
+#define PS3AV_CID_AUDIO_INIT           0x02000001
+#define PS3AV_CID_AUDIO_MODE           0x02000002
+#define PS3AV_CID_AUDIO_MUTE           0x02000003
+#define PS3AV_CID_AUDIO_ACTIVE         0x02000004
+#define PS3AV_CID_AUDIO_INACTIVE       0x02000005
+#define PS3AV_CID_AUDIO_SPDIF_BIT      0x02000006
+#define PS3AV_CID_AUDIO_CTRL           0x02000007
+
+#define PS3AV_CID_EVENT_UNPLUGGED      0x10000001
+#define PS3AV_CID_EVENT_PLUGGED        0x10000002
+#define PS3AV_CID_EVENT_HDCP_DONE      0x10000003
+#define PS3AV_CID_EVENT_HDCP_FAIL      0x10000004
+#define PS3AV_CID_EVENT_HDCP_AUTH      0x10000005
+#define PS3AV_CID_EVENT_HDCP_ERROR     0x10000006
+
+#define PS3AV_CID_AVB_PARAM            0x04000001
+
+/* max backend ports */
+#define PS3AV_HDMI_MAX                 2	/* HDMI_0 HDMI_1 */
+#define PS3AV_AVMULTI_MAX              1	/* AVMULTI_0 */
+#define PS3AV_AV_PORT_MAX              (PS3AV_HDMI_MAX + PS3AV_AVMULTI_MAX)
+#define PS3AV_OPT_PORT_MAX             1	/* SPDIF0 */
+#define PS3AV_HEAD_MAX                 2	/* HEAD_A HEAD_B */
+
+/* num of pkt for PS3AV_CID_AVB_PARAM */
+#define PS3AV_AVB_NUM_VIDEO            PS3AV_HEAD_MAX
+#define PS3AV_AVB_NUM_AUDIO            0	/* not supported */
+#define PS3AV_AVB_NUM_AV_VIDEO         PS3AV_AV_PORT_MAX
+#define PS3AV_AVB_NUM_AV_AUDIO         PS3AV_HDMI_MAX
+
+#define PS3AV_MUTE_PORT_MAX            1	/* num of ports in mute pkt */
+
+/* event_bit */
+#define PS3AV_CMD_EVENT_BIT_UNPLUGGED			(1 << 0)
+#define PS3AV_CMD_EVENT_BIT_PLUGGED			(1 << 1)
+#define PS3AV_CMD_EVENT_BIT_HDCP_DONE			(1 << 2)
+#define PS3AV_CMD_EVENT_BIT_HDCP_FAIL			(1 << 3)
+#define PS3AV_CMD_EVENT_BIT_HDCP_REAUTH			(1 << 4)
+#define PS3AV_CMD_EVENT_BIT_HDCP_TOPOLOGY		(1 << 5)
+
+/* common params */
+/* mute */
+#define PS3AV_CMD_MUTE_OFF				0x0000
+#define PS3AV_CMD_MUTE_ON				0x0001
+/* avport */
+#define PS3AV_CMD_AVPORT_HDMI_0				0x0000
+#define PS3AV_CMD_AVPORT_HDMI_1				0x0001
+#define PS3AV_CMD_AVPORT_AVMULTI_0			0x0010
+#define PS3AV_CMD_AVPORT_SPDIF_0			0x0020
+#define PS3AV_CMD_AVPORT_SPDIF_1			0x0021
+
+/* for av backend */
+/* av_mclk */
+#define PS3AV_CMD_AV_MCLK_128				0x0000
+#define PS3AV_CMD_AV_MCLK_256				0x0001
+#define PS3AV_CMD_AV_MCLK_512				0x0003
+/* av_inputlen */
+#define PS3AV_CMD_AV_INPUTLEN_16			0x02
+#define PS3AV_CMD_AV_INPUTLEN_20			0x0a
+#define PS3AV_CMD_AV_INPUTLEN_24			0x0b
+/* alayout */
+#define PS3AV_CMD_AV_LAYOUT_32				(1 << 0)
+#define PS3AV_CMD_AV_LAYOUT_44				(1 << 1)
+#define PS3AV_CMD_AV_LAYOUT_48				(1 << 2)
+#define PS3AV_CMD_AV_LAYOUT_88				(1 << 3)
+#define PS3AV_CMD_AV_LAYOUT_96				(1 << 4)
+#define PS3AV_CMD_AV_LAYOUT_176				(1 << 5)
+#define PS3AV_CMD_AV_LAYOUT_192				(1 << 6)
+/* hdmi_mode */
+#define PS3AV_CMD_AV_HDMI_MODE_NORMAL			0xff
+#define PS3AV_CMD_AV_HDMI_HDCP_OFF			0x01
+#define PS3AV_CMD_AV_HDMI_EDID_PASS			0x80
+#define PS3AV_CMD_AV_HDMI_DVI				0x40
+
+/* for video module */
+/* video_head */
+#define PS3AV_CMD_VIDEO_HEAD_A				0x0000
+#define PS3AV_CMD_VIDEO_HEAD_B				0x0001
+/* video_cs_out video_cs_in */
+#define PS3AV_CMD_VIDEO_CS_NONE				0x0000
+#define PS3AV_CMD_VIDEO_CS_RGB_8			0x0001
+#define PS3AV_CMD_VIDEO_CS_YUV444_8			0x0002
+#define PS3AV_CMD_VIDEO_CS_YUV422_8			0x0003
+#define PS3AV_CMD_VIDEO_CS_XVYCC_8			0x0004
+#define PS3AV_CMD_VIDEO_CS_RGB_10			0x0005
+#define PS3AV_CMD_VIDEO_CS_YUV444_10			0x0006
+#define PS3AV_CMD_VIDEO_CS_YUV422_10			0x0007
+#define PS3AV_CMD_VIDEO_CS_XVYCC_10			0x0008
+#define PS3AV_CMD_VIDEO_CS_RGB_12			0x0009
+#define PS3AV_CMD_VIDEO_CS_YUV444_12			0x000a
+#define PS3AV_CMD_VIDEO_CS_YUV422_12			0x000b
+#define PS3AV_CMD_VIDEO_CS_XVYCC_12			0x000c
+/* video_vid */
+#define PS3AV_CMD_VIDEO_VID_NONE			0x0000
+#define PS3AV_CMD_VIDEO_VID_480I			0x0001
+#define PS3AV_CMD_VIDEO_VID_576I			0x0003
+#define PS3AV_CMD_VIDEO_VID_480P			0x0005
+#define PS3AV_CMD_VIDEO_VID_576P			0x0006
+#define PS3AV_CMD_VIDEO_VID_1080I_60HZ			0x0007
+#define PS3AV_CMD_VIDEO_VID_1080I_50HZ			0x0008
+#define PS3AV_CMD_VIDEO_VID_720P_60HZ			0x0009
+#define PS3AV_CMD_VIDEO_VID_720P_50HZ			0x000a
+#define PS3AV_CMD_VIDEO_VID_1080P_60HZ			0x000b
+#define PS3AV_CMD_VIDEO_VID_1080P_50HZ			0x000c
+#define PS3AV_CMD_VIDEO_VID_WXGA			0x000d
+#define PS3AV_CMD_VIDEO_VID_SXGA			0x000e
+#define PS3AV_CMD_VIDEO_VID_WUXGA			0x000f
+#define PS3AV_CMD_VIDEO_VID_480I_A			0x0010
+/* video_format */
+#define PS3AV_CMD_VIDEO_FORMAT_BLACK			0x0000
+#define PS3AV_CMD_VIDEO_FORMAT_ARGB_8BIT		0x0007
+/* video_order */
+#define PS3AV_CMD_VIDEO_ORDER_RGB			0x0000
+#define PS3AV_CMD_VIDEO_ORDER_BGR			0x0001
+/* video_fmt */
+#define PS3AV_CMD_VIDEO_FMT_X8R8G8B8			0x0000
+/* video_out_format */
+#define PS3AV_CMD_VIDEO_OUT_FORMAT_RGB_12BIT		0x0000
+/* video_sync */
+#define PS3AV_CMD_VIDEO_SYNC_VSYNC			0x0001
+#define PS3AV_CMD_VIDEO_SYNC_CSYNC			0x0004
+#define PS3AV_CMD_VIDEO_SYNC_HSYNC			0x0010
+
+/* for audio module */
+/* num_of_ch */
+#define PS3AV_CMD_AUDIO_NUM_OF_CH_2			0x0000
+#define PS3AV_CMD_AUDIO_NUM_OF_CH_3			0x0001
+#define PS3AV_CMD_AUDIO_NUM_OF_CH_4			0x0002
+#define PS3AV_CMD_AUDIO_NUM_OF_CH_5			0x0003
+#define PS3AV_CMD_AUDIO_NUM_OF_CH_6			0x0004
+#define PS3AV_CMD_AUDIO_NUM_OF_CH_7			0x0005
+#define PS3AV_CMD_AUDIO_NUM_OF_CH_8			0x0006
+/* audio_fs */
+#define PS3AV_CMD_AUDIO_FS_32K				0x0001
+#define PS3AV_CMD_AUDIO_FS_44K				0x0002
+#define PS3AV_CMD_AUDIO_FS_48K				0x0003
+#define PS3AV_CMD_AUDIO_FS_88K				0x0004
+#define PS3AV_CMD_AUDIO_FS_96K				0x0005
+#define PS3AV_CMD_AUDIO_FS_176K				0x0006
+#define PS3AV_CMD_AUDIO_FS_192K				0x0007
+/* audio_word_bits */
+#define PS3AV_CMD_AUDIO_WORD_BITS_16			0x0001
+#define PS3AV_CMD_AUDIO_WORD_BITS_20			0x0002
+#define PS3AV_CMD_AUDIO_WORD_BITS_24			0x0003
+/* audio_format */
+#define PS3AV_CMD_AUDIO_FORMAT_PCM			0x0001
+#define PS3AV_CMD_AUDIO_FORMAT_BITSTREAM		0x00ff
+/* audio_source */
+#define PS3AV_CMD_AUDIO_SOURCE_SERIAL			0x0000
+#define PS3AV_CMD_AUDIO_SOURCE_SPDIF			0x0001
+/* audio_swap */
+#define PS3AV_CMD_AUDIO_SWAP_0				0x0000
+#define PS3AV_CMD_AUDIO_SWAP_1				0x0000
+/* audio_map */
+#define PS3AV_CMD_AUDIO_MAP_OUTPUT_0			0x0000
+#define PS3AV_CMD_AUDIO_MAP_OUTPUT_1			0x0001
+#define PS3AV_CMD_AUDIO_MAP_OUTPUT_2			0x0002
+#define PS3AV_CMD_AUDIO_MAP_OUTPUT_3			0x0003
+/* audio_layout */
+#define PS3AV_CMD_AUDIO_LAYOUT_2CH			0x0000
+#define PS3AV_CMD_AUDIO_LAYOUT_6CH			0x000b	/* LREClr */
+#define PS3AV_CMD_AUDIO_LAYOUT_8CH			0x001f	/* LREClrXY */
+/* audio_downmix */
+#define PS3AV_CMD_AUDIO_DOWNMIX_PERMITTED		0x0000
+#define PS3AV_CMD_AUDIO_DOWNMIX_PROHIBITED		0x0001
+
+/* audio_port */
+#define PS3AV_CMD_AUDIO_PORT_HDMI_0			( 1 << 0 )
+#define PS3AV_CMD_AUDIO_PORT_HDMI_1			( 1 << 1 )
+#define PS3AV_CMD_AUDIO_PORT_AVMULTI_0			( 1 << 10 )
+#define PS3AV_CMD_AUDIO_PORT_SPDIF_0			( 1 << 20 )
+#define PS3AV_CMD_AUDIO_PORT_SPDIF_1			( 1 << 21 )
+
+/* audio_ctrl_id */
+#define PS3AV_CMD_AUDIO_CTRL_ID_DAC_RESET		0x0000
+#define PS3AV_CMD_AUDIO_CTRL_ID_DAC_DE_EMPHASIS		0x0001
+#define PS3AV_CMD_AUDIO_CTRL_ID_AVCLK			0x0002
+/* audio_ctrl_data[0] reset */
+#define PS3AV_CMD_AUDIO_CTRL_RESET_NEGATE		0x0000
+#define PS3AV_CMD_AUDIO_CTRL_RESET_ASSERT		0x0001
+/* audio_ctrl_data[0] de-emphasis */
+#define PS3AV_CMD_AUDIO_CTRL_DE_EMPHASIS_OFF		0x0000
+#define PS3AV_CMD_AUDIO_CTRL_DE_EMPHASIS_ON		0x0001
+/* audio_ctrl_data[0] avclk */
+#define PS3AV_CMD_AUDIO_CTRL_AVCLK_22			0x0000
+#define PS3AV_CMD_AUDIO_CTRL_AVCLK_18			0x0001
+
+/* av_vid */
+/* do not use these params directly, use vid_video2av */
+#define PS3AV_CMD_AV_VID_480I				0x0000
+#define PS3AV_CMD_AV_VID_480P				0x0001
+#define PS3AV_CMD_AV_VID_720P_60HZ			0x0002
+#define PS3AV_CMD_AV_VID_1080I_60HZ			0x0003
+#define PS3AV_CMD_AV_VID_1080P_60HZ			0x0004
+#define PS3AV_CMD_AV_VID_576I				0x0005
+#define PS3AV_CMD_AV_VID_576P				0x0006
+#define PS3AV_CMD_AV_VID_720P_50HZ			0x0007
+#define PS3AV_CMD_AV_VID_1080I_50HZ			0x0008
+#define PS3AV_CMD_AV_VID_1080P_50HZ			0x0009
+#define PS3AV_CMD_AV_VID_WXGA				0x000a
+#define PS3AV_CMD_AV_VID_SXGA				0x000b
+#define PS3AV_CMD_AV_VID_WUXGA				0x000c
+/* av_cs_out av_cs_in */
+/* use cs_video2av() */
+#define PS3AV_CMD_AV_CS_RGB_8				0x0000
+#define PS3AV_CMD_AV_CS_YUV444_8			0x0001
+#define PS3AV_CMD_AV_CS_YUV422_8			0x0002
+#define PS3AV_CMD_AV_CS_XVYCC_8				0x0003
+#define PS3AV_CMD_AV_CS_RGB_10				0x0004
+#define PS3AV_CMD_AV_CS_YUV444_10			0x0005
+#define PS3AV_CMD_AV_CS_YUV422_10			0x0006
+#define PS3AV_CMD_AV_CS_XVYCC_10			0x0007
+#define PS3AV_CMD_AV_CS_RGB_12				0x0008
+#define PS3AV_CMD_AV_CS_YUV444_12			0x0009
+#define PS3AV_CMD_AV_CS_YUV422_12			0x000a
+#define PS3AV_CMD_AV_CS_XVYCC_12			0x000b
+#define PS3AV_CMD_AV_CS_8				0x0000
+#define PS3AV_CMD_AV_CS_10				0x0001
+#define PS3AV_CMD_AV_CS_12				0x0002
+/* dither */
+#define PS3AV_CMD_AV_DITHER_OFF				0x0000
+#define PS3AV_CMD_AV_DITHER_ON				0x0001
+#define PS3AV_CMD_AV_DITHER_8BIT			0x0000
+#define PS3AV_CMD_AV_DITHER_10BIT			0x0002
+#define PS3AV_CMD_AV_DITHER_12BIT			0x0004
+/* super_white */
+#define PS3AV_CMD_AV_SUPER_WHITE_OFF			0x0000
+#define PS3AV_CMD_AV_SUPER_WHITE_ON			0x0001
+/* aspect */
+#define PS3AV_CMD_AV_ASPECT_16_9			0x0000
+#define PS3AV_CMD_AV_ASPECT_4_3				0x0001
+/* video_cs_cnv() */
+#define PS3AV_CMD_VIDEO_CS_RGB				0x0001
+#define PS3AV_CMD_VIDEO_CS_YUV422			0x0002
+#define PS3AV_CMD_VIDEO_CS_YUV444			0x0003
+
+/* for automode */
+#define PS3AV_RESBIT_720x480P			0x0003	/* 0x0001 | 0x0002 */
+#define PS3AV_RESBIT_720x576P			0x0003	/* 0x0001 | 0x0002 */
+#define PS3AV_RESBIT_1280x720P			0x0004
+#define PS3AV_RESBIT_1920x1080I			0x0008
+#define PS3AV_RESBIT_1920x1080P			0x4000
+#define PS3AV_RES_MASK_60			(PS3AV_RESBIT_720x480P \
+						| PS3AV_RESBIT_1280x720P \
+						| PS3AV_RESBIT_1920x1080I \
+						| PS3AV_RESBIT_1920x1080P)
+#define PS3AV_RES_MASK_50			(PS3AV_RESBIT_720x576P \
+						| PS3AV_RESBIT_1280x720P \
+						| PS3AV_RESBIT_1920x1080I \
+						| PS3AV_RESBIT_1920x1080P)
+
+#define PS3AV_MONITOR_TYPE_HDMI			1	/* HDMI */
+#define PS3AV_MONITOR_TYPE_DVI			2	/* DVI */
+#define PS3AV_DEFAULT_HDMI_VID_REG_60		PS3AV_CMD_VIDEO_VID_480P
+#define PS3AV_DEFAULT_AVMULTI_VID_REG_60	PS3AV_CMD_VIDEO_VID_480I
+#define PS3AV_DEFAULT_HDMI_VID_REG_50		PS3AV_CMD_VIDEO_VID_576P
+#define PS3AV_DEFAULT_AVMULTI_VID_REG_50	PS3AV_CMD_VIDEO_VID_576I
+#define PS3AV_DEFAULT_DVI_VID			PS3AV_CMD_VIDEO_VID_480P
+
+#define PS3AV_REGION_60				0x01
+#define PS3AV_REGION_50				0x02
+#define PS3AV_REGION_RGB			0x10
+
+#define get_status(buf)				(((__u32 *)buf)[2])
+#define PS3AV_HDR_SIZE				4	/* version + size */
+
+/* for video mode */
+#define PS3AV_MODE_MASK				0x000F
+#define PS3AV_MODE_HDCP_OFF			0x1000	/* Retail PS3 product doesn't support this */
+#define PS3AV_MODE_DITHER			0x0800
+#define PS3AV_MODE_FULL				0x0080
+#define PS3AV_MODE_DVI				0x0040
+#define PS3AV_MODE_RGB				0x0020
+
+
+/** command packet structure **/
+struct ps3av_send_hdr {
+	u16 version;
+	u16 size;		/* size of command packet */
+	u32 cid;		/* command id */
+};
+
+struct ps3av_reply_hdr {
+	u16 version;
+	u16 size;
+	u32 cid;
+	u32 status;
+};
+
+/* backend: initialization */
+struct ps3av_pkt_av_init {
+	struct ps3av_send_hdr send_hdr;
+	u32 event_bit;
+};
+
+/* backend: finalize */
+struct ps3av_pkt_av_fin {
+	struct ps3av_send_hdr send_hdr;
+	/* recv */
+	u32 reserved;
+};
+
+/* backend: get port */
+struct ps3av_pkt_av_get_hw_conf {
+	struct ps3av_send_hdr send_hdr;
+	/* recv */
+	u32 status;
+	u16 num_of_hdmi;	/* out: number of hdmi */
+	u16 num_of_avmulti;	/* out: number of avmulti */
+	u16 num_of_spdif;	/* out: number of hdmi */
+	u16 reserved;
+};
+
+/* backend: get monitor info */
+struct ps3av_info_resolution {
+	u32 res_bits;
+	u32 native;
+};
+
+struct ps3av_info_cs {
+	u8 rgb;
+	u8 yuv444;
+	u8 yuv422;
+	u8 reserved;
+};
+
+struct ps3av_info_color {
+	u16 red_x;
+	u16 red_y;
+	u16 green_x;
+	u16 green_y;
+	u16 blue_x;
+	u16 blue_y;
+	u16 white_x;
+	u16 white_y;
+	u32 gamma;
+};
+
+struct ps3av_info_audio {
+	u8 type;
+	u8 max_num_of_ch;
+	u8 fs;
+	u8 sbit;
+};
+
+struct ps3av_info_monitor {
+	u8 avport;
+	u8 monitor_id[10];
+	u8 monitor_type;
+	u8 monitor_name[16];
+	struct ps3av_info_resolution res_60;
+	struct ps3av_info_resolution res_50;
+	struct ps3av_info_resolution res_other;
+	struct ps3av_info_resolution res_vesa;
+	struct ps3av_info_cs cs;
+	struct ps3av_info_color color;
+	u8 supported_ai;
+	u8 speaker_info;
+	u8 num_of_audio_block;
+	struct ps3av_info_audio audio[0];	/* 0 or more audio blocks */
+	u8 reserved[169];
+} __attribute__ ((packed));
+
+struct ps3av_pkt_av_get_monitor_info {
+	struct ps3av_send_hdr send_hdr;
+	u16 avport;		/* in: avport */
+	u16 reserved;
+	/* recv */
+	struct ps3av_info_monitor info;	/* out: monitor info */
+};
+
+/* backend: enable/disable event */
+struct ps3av_pkt_av_event {
+	struct ps3av_send_hdr send_hdr;
+	u32 event_bit;		/* in */
+};
+
+/* backend: video cs param */
+struct ps3av_pkt_av_video_cs {
+	struct ps3av_send_hdr send_hdr;
+	u16 avport;		/* in: avport */
+	u16 av_vid;		/* in: video resolution */
+	u16 av_cs_out;		/* in: output color space */
+	u16 av_cs_in;		/* in: input color space */
+	u8 dither;		/* in: dither bit length */
+	u8 bitlen_out;		/* in: bit length */
+	u8 super_white;		/* in: super white */
+	u8 aspect;		/* in: aspect ratio */
+};
+
+/* backend: video mute */
+struct ps3av_av_mute {
+	u16 avport;		/* in: avport */
+	u16 mute;		/* in: mute on/off */
+};
+
+struct ps3av_pkt_av_video_mute {
+	struct ps3av_send_hdr send_hdr;
+	struct ps3av_av_mute mute[PS3AV_MUTE_PORT_MAX];
+};
+
+/* backend: video disable signal */
+struct ps3av_pkt_av_video_disable_sig {
+	struct ps3av_send_hdr send_hdr;
+	u16 avport;		/* in: avport */
+	u16 reserved;
+};
+
+/* backend: audio param */
+struct ps3av_audio_info_frame {
+	struct pb1_bit {
+		u8 ct:4;
+		u8 rsv:1;
+		u8 cc:3;
+	} pb1;
+	struct pb2_bit {
+		u8 rsv:3;
+		u8 sf:3;
+		u8 ss:2;
+	} pb2;
+	u8 pb3;
+	u8 pb4;
+	struct pb5_bit {
+		u8 dm:1;
+		u8 lsv:4;
+		u8 rsv:3;
+	} pb5;
+};
+
+struct ps3av_pkt_av_audio_param {
+	struct ps3av_send_hdr send_hdr;
+	u16 avport;		/* in: avport */
+	u16 reserved;
+	u8 mclk;		/* in: audio mclk */
+	u8 ns[3];		/* in: audio ns val */
+	u8 enable;		/* in: audio enable */
+	u8 swaplr;		/* in: audio swap */
+	u8 fifomap;		/* in: audio fifomap */
+	u8 inputctrl;		/* in: audio input ctrl */
+	u8 inputlen;		/* in: sample bit size */
+	u8 layout;		/* in: speaker layout param */
+	struct ps3av_audio_info_frame info;	/* in: info */
+	u8 chstat[5];		/* in: ch stat */
+};
+
+/* backend: audio_mute */
+struct ps3av_pkt_av_audio_mute {
+	struct ps3av_send_hdr send_hdr;
+	struct ps3av_av_mute mute[PS3AV_MUTE_PORT_MAX];
+};
+
+/* backend: hdmi_mode */
+struct ps3av_pkt_av_hdmi_mode {
+	struct ps3av_send_hdr send_hdr;
+	u8 mode;		/* in: hdmi_mode */
+	u8 reserved0;
+	u8 reserved1;
+	u8 reserved2;
+};
+
+/* backend: tv_mute */
+struct ps3av_pkt_av_tv_mute {
+	struct ps3av_send_hdr send_hdr;
+	u16 avport;		/* in: avport HDMI only */
+	u16 mute;		/* in: mute */
+};
+
+/* video: initialize */
+struct ps3av_pkt_video_init {
+	struct ps3av_send_hdr send_hdr;
+	/* recv */
+	u32 reserved;
+};
+
+/* video: mode setting */
+struct ps3av_pkt_video_mode {
+	struct ps3av_send_hdr send_hdr;
+	u32 video_head;		/* in: head */
+	u32 reserved;
+	u32 video_vid;		/* in: video resolution */
+	u16 reserved1;
+	u16 width;		/* in: width in pixel */
+	u16 reserved2;
+	u16 height;		/* in: height in pixel */
+	u32 pitch;		/* in: line size in byte */
+	u32 video_out_format;	/* in: out format */
+	u32 video_format;	/* in: input frame buffer format */
+	u8 reserved3;
+	u8 reserved4;
+	u16 video_order;	/* in: input RGB order */
+	u32 reserved5;
+};
+
+/* video: format */
+struct ps3av_pkt_video_format {
+	struct ps3av_send_hdr send_hdr;
+	u32 video_head;		/* in: head */
+	u32 video_format;	/* in: frame buffer format */
+	u16 reserved;
+	u16 video_order;	/* in: input RGB order */
+};
+
+/* video: pitch */
+struct ps3av_pkt_video_pitch {
+	u16 version;
+	u16 size;		/* size of command packet */
+	u32 cid;		/* command id */
+	u32 video_head;		/* in: head */
+	u32 pitch;		/* in: line size in byte */
+};
+
+/* audio: initialize */
+struct ps3av_pkt_audio_init {
+	struct ps3av_send_hdr send_hdr;
+	/* recv */
+	u32 reserved;
+};
+
+/* audio: mode setting */
+struct ps3av_pkt_audio_mode {
+	struct ps3av_send_hdr send_hdr;
+	u8 avport;		/* in: avport */
+	u8 reserved0[3];
+	u32 mask;		/* in: mask */
+	u32 audio_num_of_ch;	/* in: number of ch */
+	u32 audio_fs;		/* in: sampling freq */
+	u32 audio_word_bits;	/* in: sample bit size */
+	u32 audio_format;	/* in: audio output format */
+	u32 audio_source;	/* in: audio source */
+	u8 audio_enable[4];	/* in: audio enable */
+	u8 audio_swap[4];	/* in: audio swap */
+	u8 audio_map[4];	/* in: audio map */
+	u32 audio_layout;	/* in: speaker layout */
+	u32 audio_downmix;	/* in: audio downmix permission */
+	u32 audio_downmix_level;
+	u8 audio_cs_info[8];	/* in: IEC channel status */
+};
+
+/* audio: mute */
+struct ps3av_audio_mute {
+	u8 avport;		/* in: opt_port optical */
+	u8 reserved[3];
+	u32 mute;		/* in: mute */
+};
+
+struct ps3av_pkt_audio_mute {
+	struct ps3av_send_hdr send_hdr;
+	struct ps3av_audio_mute mute[PS3AV_OPT_PORT_MAX];
+};
+
+/* audio: active/inactive */
+struct ps3av_pkt_audio_active {
+	struct ps3av_send_hdr send_hdr;
+	u32 audio_port;		/* in: audio active/inactive port */
+};
+
+/* audio: SPDIF user bit */
+struct ps3av_pkt_audio_spdif_bit {
+	u16 version;
+	u16 size;		/* size of command packet */
+	u32 cid;		/* command id */
+	u8 avport;		/* in: avport SPDIF only */
+	u8 reserved[3];
+	u32 audio_port;		/* in: SPDIF only */
+	u32 spdif_bit_data[12];	/* in: user bit data */
+};
+
+/* audio: audio control */
+struct ps3av_pkt_audio_ctrl {
+	u16 version;
+	u16 size;		/* size of command packet */
+	u32 cid;		/* command id */
+	u32 audio_ctrl_id;	/* in: control id */
+	u32 audio_ctrl_data[4];	/* in: control data */
+};
+
+/* avb:param */
+#define PS3AV_PKT_AVB_PARAM_MAX_BUF_SIZE	\
+	(PS3AV_AVB_NUM_VIDEO*sizeof(struct ps3av_pkt_video_mode) + \
+	 PS3AV_AVB_NUM_AUDIO*sizeof(struct ps3av_pkt_audio_mode) + \
+	 PS3AV_AVB_NUM_AV_VIDEO*sizeof(struct ps3av_pkt_av_video_cs) + \
+	 PS3AV_AVB_NUM_AV_AUDIO*sizeof(struct ps3av_pkt_av_audio_param))
+
+struct ps3av_pkt_avb_param {
+	struct ps3av_send_hdr send_hdr;
+	u16 num_of_video_pkt;
+	u16 num_of_audio_pkt;
+	u16 num_of_av_video_pkt;
+	u16 num_of_av_audio_pkt;
+	/*
+	 * The actual buffer layout depends on the fields above:
+	 *
+	 * struct ps3av_pkt_video_mode video[num_of_video_pkt];
+	 * struct ps3av_pkt_audio_mode audio[num_of_audio_pkt];
+	 * struct ps3av_pkt_av_video_cs av_video[num_of_av_video_pkt];
+	 * struct ps3av_pkt_av_audio_param av_audio[num_of_av_audio_pkt];
+	 */
+	u8 buf[PS3AV_PKT_AVB_PARAM_MAX_BUF_SIZE];
+};
+
+struct ps3av {
+	int available;
+	struct semaphore sem;
+	struct semaphore ping;
+	struct semaphore pong;
+	struct mutex mutex;
+	int open_count;
+	struct ps3_vuart_port_device *dev;
+
+	int region;
+	struct ps3av_pkt_av_get_hw_conf av_hw_conf;
+	u32 av_port[PS3AV_AV_PORT_MAX + PS3AV_OPT_PORT_MAX];
+	u32 opt_port[PS3AV_OPT_PORT_MAX];
+	u32 head[PS3AV_HEAD_MAX];
+	u32 audio_port;
+	int ps3av_mode;
+	int ps3av_mode_old;
+};
+
+/** command status **/
+#define PS3AV_STATUS_SUCCESS			0x0000	/* success */
+#define PS3AV_STATUS_RECEIVE_VUART_ERROR	0x0001	/* receive vuart error */
+#define PS3AV_STATUS_SYSCON_COMMUNICATE_FAIL	0x0002	/* syscon communication error */
+#define PS3AV_STATUS_INVALID_COMMAND		0x0003	/* obsolete invalid CID */
+#define PS3AV_STATUS_INVALID_PORT		0x0004	/* invalid port number */
+#define PS3AV_STATUS_INVALID_VID		0x0005	/* invalid video format */
+#define PS3AV_STATUS_INVALID_COLOR_SPACE	0x0006	/* invalid video colose space */
+#define PS3AV_STATUS_INVALID_FS			0x0007	/* invalid audio sampling freq */
+#define PS3AV_STATUS_INVALID_AUDIO_CH		0x0008	/* invalid audio channel number */
+#define PS3AV_STATUS_UNSUPPORTED_VERSION	0x0009	/* version mismatch  */
+#define PS3AV_STATUS_INVALID_SAMPLE_SIZE	0x000a	/* invalid audio sample bit size */
+#define PS3AV_STATUS_FAILURE			0x000b	/* other failures */
+#define PS3AV_STATUS_UNSUPPORTED_COMMAND	0x000c	/* unsupported cid */
+#define PS3AV_STATUS_BUFFER_OVERFLOW		0x000d	/* write buffer overflow */
+#define PS3AV_STATUS_INVALID_VIDEO_PARAM	0x000e	/* invalid video param */
+#define PS3AV_STATUS_NO_SEL			0x000f	/* not exist selector */
+#define PS3AV_STATUS_INVALID_AV_PARAM		0x0010	/* invalid backend param */
+#define PS3AV_STATUS_INVALID_AUDIO_PARAM	0x0011	/* invalid audio param */
+#define PS3AV_STATUS_UNSUPPORTED_HDMI_MODE	0x0012	/* unsupported hdmi mode */
+#define PS3AV_STATUS_NO_SYNC_HEAD		0x0013	/* sync head failed */
+
+extern void ps3av_set_hdr(u32, u16, struct ps3av_send_hdr *);
+extern int ps3av_do_pkt(u32, u16, size_t, struct ps3av_send_hdr *);
+
+extern int ps3av_cmd_init(void);
+extern int ps3av_cmd_fin(void);
+extern int ps3av_cmd_av_video_mute(int, u32 *, u32);
+extern int ps3av_cmd_av_video_disable_sig(u32);
+extern int ps3av_cmd_av_tv_mute(u32, u32);
+extern int ps3av_cmd_enable_event(void);
+extern int ps3av_cmd_av_hdmi_mode(u8);
+extern u32 ps3av_cmd_set_av_video_cs(void *, u32, int, int, int, u32);
+extern u32 ps3av_cmd_set_video_mode(void *, u32, int, int, u32);
+extern int ps3av_cmd_video_format_black(u32, u32, u32);
+extern int ps3av_cmd_av_audio_mute(int, u32 *, u32);
+extern u32 ps3av_cmd_set_av_audio_param(void *, u32,
+					const struct ps3av_pkt_audio_mode *,
+					u32);
+extern void ps3av_cmd_set_audio_mode(struct ps3av_pkt_audio_mode *, u32, u32,
+				     u32, u32, u32, u32);
+extern int ps3av_cmd_audio_mode(struct ps3av_pkt_audio_mode *);
+extern int ps3av_cmd_audio_mute(int, u32 *, u32);
+extern int ps3av_cmd_audio_active(int, u32);
+extern int ps3av_cmd_avb_param(struct ps3av_pkt_avb_param *, u32);
+extern int ps3av_cmd_av_get_hw_conf(struct ps3av_pkt_av_get_hw_conf *);
+#ifdef PS3AV_DEBUG
+extern void ps3av_cmd_av_hw_conf_dump(const struct ps3av_pkt_av_get_hw_conf *);
+extern void ps3av_cmd_av_monitor_info_dump(const struct ps3av_pkt_av_get_monitor_info *);
+#else
+static inline void ps3av_cmd_av_hw_conf_dump(const struct ps3av_pkt_av_get_hw_conf *hw_conf) {}
+static inline void ps3av_cmd_av_monitor_info_dump(const struct ps3av_pkt_av_get_monitor_info *monitor_info) {}
+#endif
+extern int ps3av_cmd_video_get_monitor_info(struct ps3av_pkt_av_get_monitor_info *,
+					    u32);
+
+extern int ps3av_vuart_write(struct ps3_vuart_port_device *dev,
+			     const void *buf, unsigned long size);
+extern int ps3av_vuart_read(struct ps3_vuart_port_device *dev, void *buf,
+			    unsigned long size, int timeout);
+
+extern int ps3av_set_video_mode(u32, int);
+extern int ps3av_set_audio_mode(u32, u32, u32, u32, u32);
+extern int ps3av_set_mode(u32, int);
+extern int ps3av_get_mode(void);
+extern int ps3av_get_scanmode(int);
+extern int ps3av_get_refresh_rate(int);
+extern int ps3av_video_mode2res(u32, u32 *, u32 *);
+extern int ps3av_video_mute(int);
+extern int ps3av_audio_mute(int);
+extern int ps3av_dev_open(void);
+extern int ps3av_dev_close(void);
+
+#endif	/* _ASM_POWERPC_PS3AV_H_ */
_

Patches currently in -mm which might be from Geert.Uytterhoeven@sonycom.com are

origin.patch
ps3-add-shutdown-to-virtual-uart-port-driver-framework.patch
ps3-av-settings-driver.patch
fbdev-modedb-allow-refresh-rates-for-named-video-modes.patch
fbdev-modedb-make-more-pointer-parameters-const.patch
fb_videomode_to_var-reset-virtual-screen-parameters.patch
ps3-preallocate-bootmem-memory-for-ps3fb.patch
ps3-virtual-frame-buffer-driver.patch
ps3-disable-display-flipping-during-mode-changes.patch
ps3-cleanup-ps3fb-before-clearing-hpte.patch
ps3-ps3av-fb-defconfig-updates.patch
