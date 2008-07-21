From: akpm@linux-foundation.org
Subject: - synclink_gt-add-rx-dma-buffer-fill-level-control.patch removed from -mm tree
Date: Mon, 21 Jul 2008 14:34:25 -0700
Message-ID: <200807212134.m6LLYPRY025666@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42301 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751027AbYGUVgd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 21 Jul 2008 17:36:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: paulkf@microgate.com, alan@lxorguk.ukuu.org.uk, mm-commits@vger.kernel.org


The patch titled
     synclink_gt: add rx DMA buffer fill level control
has been removed from the -mm tree.  Its filename was
     synclink_gt-add-rx-dma-buffer-fill-level-control.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: synclink_gt: add rx DMA buffer fill level control
From: Paul Fulghum <paulkf@microgate.com>

Add run time control for receive DMA buffer fill level to allow
application to control receive latency when using stream oriented serial
protocols that pass receive data to application only after a DMA buffer
fills.  This was previously a compile time option, but run time control is
needed when application changes data rate (and latency requirements) or
uses different data rates on different ports.

Signed-off-by: Paul Fulghum <paulkf@microgate.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/synclink_gt.c |   42 ++++++++++++++++++++++-------------
 1 file changed, 27 insertions(+), 15 deletions(-)

diff -puN drivers/char/synclink_gt.c~synclink_gt-add-rx-dma-buffer-fill-level-control drivers/char/synclink_gt.c
--- a/drivers/char/synclink_gt.c~synclink_gt-add-rx-dma-buffer-fill-level-control
+++ a/drivers/char/synclink_gt.c
@@ -299,7 +299,7 @@ struct slgt_info {
 	u32 idle_mode;
 	u32 max_frame_size;       /* as set by device config */
 
-	unsigned int raw_rx_size;
+	unsigned int rbuf_fill_level;
 	unsigned int if_mode;
 
 	/* device status */
@@ -2676,8 +2676,29 @@ static int tx_abort(struct slgt_info *in
 static int rx_enable(struct slgt_info *info, int enable)
 {
  	unsigned long flags;
-	DBGINFO(("%s rx_enable(%d)\n", info->device_name, enable));
+	unsigned int rbuf_fill_level;
+	DBGINFO(("%s rx_enable(%08x)\n", info->device_name, enable));
 	spin_lock_irqsave(&info->lock,flags);
+	/*
+	 * enable[31..16] = receive DMA buffer fill level
+	 * 0 = noop (leave fill level unchanged)
+	 * fill level must be multiple of 4 and <= buffer size
+	 */
+	rbuf_fill_level = ((unsigned int)enable) >> 16;
+	if (rbuf_fill_level) {
+		if ((rbuf_fill_level > DMABUFSIZE) || (rbuf_fill_level % 4))
+			return -EINVAL;
+		info->rbuf_fill_level = rbuf_fill_level;
+		rx_stop(info); /* restart receiver to use new fill level */
+	}
+
+	/*
+	 * enable[1..0] = receiver enable command
+	 * 0 = disable
+	 * 1 = enable
+	 * 2 = enable or force hunt mode if already enabled
+	 */
+	enable &= 3;
 	if (enable) {
 		if (!info->rx_enabled)
 			rx_start(info);
@@ -3443,7 +3464,7 @@ static struct slgt_info *alloc_dev(int a
 		info->magic = MGSL_MAGIC;
 		INIT_WORK(&info->task, bh_handler);
 		info->max_frame_size = 4096;
-		info->raw_rx_size = DMABUFSIZE;
+		info->rbuf_fill_level = DMABUFSIZE;
 		info->port.close_delay = 5*HZ/10;
 		info->port.closing_wait = 30*HZ;
 		init_waitqueue_head(&info->status_event_wait_q);
@@ -4454,16 +4475,7 @@ static void free_rbufs(struct slgt_info 
 	while(!done) {
 		/* reset current buffer for reuse */
 		info->rbufs[i].status = 0;
-		switch(info->params.mode) {
-		case MGSL_MODE_RAW:
-		case MGSL_MODE_MONOSYNC:
-		case MGSL_MODE_BISYNC:
-			set_desc_count(info->rbufs[i], info->raw_rx_size);
-			break;
-		default:
-			set_desc_count(info->rbufs[i], DMABUFSIZE);
-		}
-
+		set_desc_count(info->rbufs[i], info->rbuf_fill_level);
 		if (i == last)
 			done = 1;
 		if (++i == info->rbuf_count)
@@ -4570,7 +4582,7 @@ check_again:
 
 	DBGBH(("%s rx frame status=%04X size=%d\n",
 		info->device_name, status, framesize));
-	DBGDATA(info, info->rbufs[start].buf, min_t(int, framesize, DMABUFSIZE), "rx");
+	DBGDATA(info, info->rbufs[start].buf, min_t(int, framesize, info->rbuf_fill_level), "rx");
 
 	if (framesize) {
 		if (!(info->params.crc_type & HDLC_CRC_RETURN_EX)) {
@@ -4590,7 +4602,7 @@ check_again:
 			info->icount.rxok++;
 
 			while(copy_count) {
-				int partial_count = min(copy_count, DMABUFSIZE);
+				int partial_count = min_t(int, copy_count, info->rbuf_fill_level);
 				memcpy(p, info->rbufs[i].buf, partial_count);
 				p += partial_count;
 				copy_count -= partial_count;
_

Patches currently in -mm which might be from paulkf@microgate.com are

linux-next.patch

