From: akpm@linux-foundation.org
Subject: - ps3av-misc-updates.patch removed from -mm tree
Date: Mon, 07 May 2007 00:00:20 -0700
Message-ID: <200705070700.l4770KK4021008@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:42932 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754119AbXEGHBH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 May 2007 03:01:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Geert.Uytterhoeven@sonycom.com, benh@kernel.crashing.org, hch@lst.de, jsimmons@infradead.org, paulus@samba.org, mm-commits@vger.kernel.org


The patch titled
     ps3av: misc updates
has been removed from the -mm tree.  Its filename was
     ps3av-misc-updates.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: ps3av: misc updates
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>

ps3av:
  - Move the definition of struct ps3av to ps3av.c, as it's used locally only.
  - Kill ps3av.sem, use the existing ps3av.mutex instead.
  - Make the 512-byte buffer in ps3av_do_pkt() static to reduce stack usage.
    Its use is protected by a semaphore anyway.

Signed-off-by: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Christoph Hellwig <hch@lst.de>
Acked-by: James Simmons <jsimmons@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ps3/ps3av.c         |   29 ++++++++++++++++++++++-------
 include/asm-powerpc/ps3av.h |   22 +---------------------
 2 files changed, 23 insertions(+), 28 deletions(-)

diff -puN drivers/ps3/ps3av.c~ps3av-misc-updates drivers/ps3/ps3av.c
--- a/drivers/ps3/ps3av.c~ps3av-misc-updates
+++ a/drivers/ps3/ps3av.c
@@ -38,7 +38,24 @@
 static int timeout = 5000;	/* in msec ( 5 sec ) */
 module_param(timeout, int, 0644);
 
-static struct ps3av ps3av;
+static struct ps3av {
+	int available;
+	struct mutex mutex;
+	struct work_struct work;
+	struct completion done;
+	struct workqueue_struct *wq;
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
+} ps3av;
 
 static struct ps3_vuart_port_device ps3av_dev = {
 	.match_id = PS3_MATCH_ID_AV_SETTINGS
@@ -250,7 +267,7 @@ int ps3av_do_pkt(u32 cid, u16 send_len, 
 		 struct ps3av_send_hdr *buf)
 {
 	int res = 0;
-	union {
+	static union {
 		struct ps3av_reply_hdr reply_hdr;
 		u8 raw[PS3AV_BUF_SIZE];
 	} recv_buf;
@@ -259,8 +276,7 @@ int ps3av_do_pkt(u32 cid, u16 send_len, 
 
 	BUG_ON(!ps3av.available);
 
-	if (down_interruptible(&ps3av.sem))
-		return -ERESTARTSYS;
+	mutex_lock(&ps3av.mutex);
 
 	table = ps3av_search_cmd_table(cid, PS3AV_CID_MASK);
 	BUG_ON(!table);
@@ -290,11 +306,11 @@ int ps3av_do_pkt(u32 cid, u16 send_len, 
 		goto err;
 	}
 
-	up(&ps3av.sem);
+	mutex_unlock(&ps3av.mutex);
 	return 0;
 
       err:
-	up(&ps3av.sem);
+	mutex_unlock(&ps3av.mutex);
 	printk(KERN_ERR "%s: failed cid:%x res:%d\n", __FUNCTION__, cid, res);
 	return res;
 }
@@ -872,7 +888,6 @@ static int ps3av_probe(struct ps3_vuart_
 
 	memset(&ps3av, 0, sizeof(ps3av));
 
-	init_MUTEX(&ps3av.sem);
 	mutex_init(&ps3av.mutex);
 	ps3av.ps3av_mode = 0;
 	ps3av.dev = dev;
diff -puN include/asm-powerpc/ps3av.h~ps3av-misc-updates include/asm-powerpc/ps3av.h
--- a/include/asm-powerpc/ps3av.h~ps3av-misc-updates
+++ a/include/asm-powerpc/ps3av.h
@@ -18,8 +18,6 @@
 #ifndef _ASM_POWERPC_PS3AV_H_
 #define _ASM_POWERPC_PS3AV_H_
 
-#include <linux/mutex.h>
-
 /** command for ioctl() **/
 #define PS3AV_VERSION 0x205	/* version of ps3av command */
 
@@ -643,25 +641,6 @@ struct ps3av_pkt_avb_param {
 	u8 buf[PS3AV_PKT_AVB_PARAM_MAX_BUF_SIZE];
 };
 
-struct ps3av {
-	int available;
-	struct semaphore sem;
-	struct work_struct work;
-	struct completion done;
-	struct workqueue_struct *wq;
-	struct mutex mutex;
-	int open_count;
-	struct ps3_vuart_port_device *dev;
-
-	int region;
-	struct ps3av_pkt_av_get_hw_conf av_hw_conf;
-	u32 av_port[PS3AV_AV_PORT_MAX + PS3AV_OPT_PORT_MAX];
-	u32 opt_port[PS3AV_OPT_PORT_MAX];
-	u32 head[PS3AV_HEAD_MAX];
-	u32 audio_port;
-	int ps3av_mode;
-	int ps3av_mode_old;
-};
 
 /** command status **/
 #define PS3AV_STATUS_SUCCESS			0x0000	/* success */
@@ -719,6 +698,7 @@ static inline void ps3av_cmd_av_monitor_
 extern int ps3av_cmd_video_get_monitor_info(struct ps3av_pkt_av_get_monitor_info *,
 					    u32);
 
+struct ps3_vuart_port_device;
 extern int ps3av_vuart_write(struct ps3_vuart_port_device *dev,
 			     const void *buf, unsigned long size);
 extern int ps3av_vuart_read(struct ps3_vuart_port_device *dev, void *buf,
_

Patches currently in -mm which might be from Geert.Uytterhoeven@sonycom.com are

origin.patch
fbdev-avoid-vertical-overflow-when-making-space-for-the-logo.patch
fbdev-fb_do_show_logo-updates.patch
fbdev-correct-image-offsets-when-rotating-logo.patch
