From: akpm@linux-foundation.org
Subject: + synclink_gt-improve-tiocoutq-accuracy.patch added to -mm tree
Date: Thu, 17 Jul 2008 14:13:04 -0700
Message-ID: <200807172113.m6HLD4b6006477@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54641 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760216AbYGQVNr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 17 Jul 2008 17:13:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: paulkf@microgate.com, alan@lxorguk.ukuu.org.uk


The patch titled
     synclink_gt: improve TIOCOUTQ accuracy
has been added to the -mm tree.  Its filename is
     synclink_gt-improve-tiocoutq-accuracy.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: synclink_gt: improve TIOCOUTQ accuracy
From: Paul Fulghum <paulkf@microgate.com>

Improve the accuracy of TIOCOUTQ value as implemented in chars_in_buffer()
method by walking and counting tx DMA buffers, reading controller tx FIFO
level and accounting for controller tx shift register.  The greatly
improves application control of transmit latency at lower data rates.

Signed-off-by: Paul Fulghum <paulkf@microgate.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/synclink_gt.c |   59 +++++++++++++++++++++++++++++++++--
 1 file changed, 57 insertions(+), 2 deletions(-)

diff -puN drivers/char/synclink_gt.c~synclink_gt-improve-tiocoutq-accuracy drivers/char/synclink_gt.c
--- a/drivers/char/synclink_gt.c~synclink_gt-improve-tiocoutq-accuracy
+++ a/drivers/char/synclink_gt.c
@@ -211,6 +211,7 @@ struct slgt_desc
 	char *buf;          /* virtual  address of data buffer */
     	unsigned int pdesc; /* physical address of this descriptor */
 	dma_addr_t buf_dma_addr;
+	unsigned short buf_count;
 };
 
 #define set_desc_buffer(a,b) (a).pbuf = cpu_to_le32((unsigned int)(b))
@@ -470,6 +471,7 @@ static void tx_start(struct slgt_info *i
 static void tx_stop(struct slgt_info *info);
 static void tx_set_idle(struct slgt_info *info);
 static unsigned int free_tbuf_count(struct slgt_info *info);
+static unsigned int tbuf_bytes(struct slgt_info *info);
 static void reset_tbufs(struct slgt_info *info);
 static void tdma_reset(struct slgt_info *info);
 static void tdma_start(struct slgt_info *info);
@@ -1400,10 +1402,12 @@ done:
 static int chars_in_buffer(struct tty_struct *tty)
 {
 	struct slgt_info *info = tty->driver_data;
+	int count;
 	if (sanity_check(info, tty->name, "chars_in_buffer"))
 		return 0;
-	DBGINFO(("%s chars_in_buffer()=%d\n", info->device_name, info->tx_count));
-	return info->tx_count;
+	count = tbuf_bytes(info);
+	DBGINFO(("%s chars_in_buffer()=%d\n", info->device_name, count));
+	return count;
 }
 
 /*
@@ -4702,6 +4706,56 @@ static unsigned int free_tbuf_count(stru
 }
 
 /*
+ * return number of bytes in unsent transmit DMA buffers
+ * and the serial controller tx FIFO
+ */
+static unsigned int tbuf_bytes(struct slgt_info *info)
+{
+	unsigned int total_count = 0;
+	unsigned int i = info->tbuf_current;
+	unsigned int reg_value;
+	unsigned int count;
+	unsigned int active_buf_count = 0;
+
+	/*
+	 * Add descriptor counts for all tx DMA buffers.
+	 * If count is zero (cleared by DMA controller after read),
+	 * the buffer is complete or is actively being read from.
+	 *
+	 * Record buf_count of last buffer with zero count starting
+	 * from current ring position. buf_count is mirror
+	 * copy of count and is not cleared by serial controller.
+	 * If DMA controller is active, that buffer is actively
+	 * being read so add to total.
+	 */
+	do {
+		count = desc_count(info->tbufs[i]);
+		if (count)
+			total_count += count;
+		else if (!total_count)
+			active_buf_count = info->tbufs[i].buf_count;
+		if (++i == info->tbuf_count)
+			i = 0;
+	} while (i != info->tbuf_current);
+
+	/* read tx DMA status register */
+	reg_value = rd_reg32(info, TDCSR);
+
+	/* if tx DMA active, last zero count buffer is in use */
+	if (reg_value & BIT0)
+		total_count += active_buf_count;
+
+	/* add tx FIFO count = reg_value[15..8] */
+	total_count += (reg_value >> 8) & 0xff;
+
+	/* if transmitter active add one byte for shift register */
+	if (info->tx_active)
+		total_count++;
+
+	return total_count;
+}
+
+/*
  * load transmit DMA buffer(s) with data
  */
 static void tx_load(struct slgt_info *info, const char *buf, unsigned int size)
@@ -4739,6 +4793,7 @@ static void tx_load(struct slgt_info *in
 			set_desc_eof(*d, 0);
 
 		set_desc_count(*d, count);
+		d->buf_count = count;
 	}
 
 	info->tbuf_current = i;
_

Patches currently in -mm which might be from paulkf@microgate.com are

synclink_gt-add-rx-dma-buffer-fill-level-control.patch
synclink_gt-add-serial-bit-order-control.patch
synclink_gt-improve-tiocoutq-accuracy.patch
synclink_gt-improve-and-simplify-write-method.patch

