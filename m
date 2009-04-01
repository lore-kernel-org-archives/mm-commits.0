From: akpm@linux-foundation.org
Subject: + synclink_gt-add-clock-options.patch added to -mm tree
Date: Wed, 01 Apr 2009 12:30:17 -0700
Message-ID: <200904011930.n31JUHAu023701@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43010 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755756AbZDATcu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Apr 2009 15:32:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: paulkf@microgate.com, alan@lxorguk.ukuu.org.uk


The patch titled
     synclink_gt: add clock options
has been added to the -mm tree.  Its filename is
     synclink_gt-add-clock-options.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: synclink_gt: add clock options
From: Paul Fulghum <paulkf@microgate.com>

Add support for x8 asynchronous sample rate and ability to specify base
clock frequency.

Signed-off-by: Paul Fulghum <paulkf@microgate.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/synclink_gt.c |   58 ++++++++++++++++++++++-------------
 include/linux/synclink.h   |    1 
 2 files changed, 39 insertions(+), 20 deletions(-)

diff -puN drivers/char/synclink_gt.c~synclink_gt-add-clock-options drivers/char/synclink_gt.c
--- a/drivers/char/synclink_gt.c~synclink_gt-add-clock-options
+++ a/drivers/char/synclink_gt.c
@@ -298,6 +298,7 @@ struct slgt_info {
 
 	unsigned int rbuf_fill_level;
 	unsigned int if_mode;
+	unsigned int base_clock;
 
 	/* device status */
 
@@ -1156,22 +1157,26 @@ static long set_params32(struct slgt_inf
 		return -EFAULT;
 
 	spin_lock(&info->lock);
-	info->params.mode            = tmp_params.mode;
-	info->params.loopback        = tmp_params.loopback;
-	info->params.flags           = tmp_params.flags;
-	info->params.encoding        = tmp_params.encoding;
-	info->params.clock_speed     = tmp_params.clock_speed;
-	info->params.addr_filter     = tmp_params.addr_filter;
-	info->params.crc_type        = tmp_params.crc_type;
-	info->params.preamble_length = tmp_params.preamble_length;
-	info->params.preamble        = tmp_params.preamble;
-	info->params.data_rate       = tmp_params.data_rate;
-	info->params.data_bits       = tmp_params.data_bits;
-	info->params.stop_bits       = tmp_params.stop_bits;
-	info->params.parity          = tmp_params.parity;
+	if (tmp_params.mode == MGSL_MODE_BASE_CLOCK) {
+		info->base_clock = tmp_params.clock_speed;
+	} else {
+		info->params.mode            = tmp_params.mode;
+		info->params.loopback        = tmp_params.loopback;
+		info->params.flags           = tmp_params.flags;
+		info->params.encoding        = tmp_params.encoding;
+		info->params.clock_speed     = tmp_params.clock_speed;
+		info->params.addr_filter     = tmp_params.addr_filter;
+		info->params.crc_type        = tmp_params.crc_type;
+		info->params.preamble_length = tmp_params.preamble_length;
+		info->params.preamble        = tmp_params.preamble;
+		info->params.data_rate       = tmp_params.data_rate;
+		info->params.data_bits       = tmp_params.data_bits;
+		info->params.stop_bits       = tmp_params.stop_bits;
+		info->params.parity          = tmp_params.parity;
+	}
 	spin_unlock(&info->lock);
 
- 	change_params(info);
+	program_hw(info);
 
 	return 0;
 }
@@ -2559,10 +2564,13 @@ static int set_params(struct slgt_info *
 		return -EFAULT;
 
 	spin_lock_irqsave(&info->lock, flags);
-	memcpy(&info->params, &tmp_params, sizeof(MGSL_PARAMS));
+	if (tmp_params.mode == MGSL_MODE_BASE_CLOCK)
+		info->base_clock = tmp_params.clock_speed;
+	else
+		memcpy(&info->params, &tmp_params, sizeof(MGSL_PARAMS));
 	spin_unlock_irqrestore(&info->lock, flags);
 
- 	change_params(info);
+	program_hw(info);
 
 	return 0;
 }
@@ -3432,6 +3440,7 @@ static struct slgt_info *alloc_dev(int a
 		info->magic = MGSL_MAGIC;
 		INIT_WORK(&info->task, bh_handler);
 		info->max_frame_size = 4096;
+		info->base_clock = 14745600;
 		info->rbuf_fill_level = DMABUFSIZE;
 		info->port.close_delay = 5*HZ/10;
 		info->port.closing_wait = 30*HZ;
@@ -3779,7 +3788,7 @@ static void enable_loopback(struct slgt_
 static void set_rate(struct slgt_info *info, u32 rate)
 {
 	unsigned int div;
-	static unsigned int osc = 14745600;
+	unsigned int osc = info->base_clock;
 
 	/* div = osc/rate - 1
 	 *
@@ -4083,18 +4092,27 @@ static void async_mode(struct slgt_info 
 	 * 06  CTS      IRQ enable
 	 * 05  DCD      IRQ enable
 	 * 04  RI       IRQ enable
-	 * 03  reserved, must be zero
+	 * 03  0=16x sampling, 1=8x sampling
 	 * 02  1=txd->rxd internal loopback enable
 	 * 01  reserved, must be zero
 	 * 00  1=master IRQ enable
 	 */
 	val = BIT15 + BIT14 + BIT0;
+	/* JCR[8] : 1 = x8 async mode feature available */
+	if ((rd_reg32(info, JCR) & BIT8) && info->params.data_rate &&
+	    ((info->base_clock < (info->params.data_rate * 16)) ||
+	     (info->base_clock % (info->params.data_rate * 16)))) {
+		/* use 8x sampling */
+		val |= BIT3;
+		set_rate(info, info->params.data_rate * 8);
+	} else {
+		/* use 16x sampling */
+		set_rate(info, info->params.data_rate * 16);
+	}
 	wr_reg16(info, SCR, val);
 
 	slgt_irq_on(info, IRQ_RXBREAK | IRQ_RXOVER);
 
-	set_rate(info, info->params.data_rate * 16);
