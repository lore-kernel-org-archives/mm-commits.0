From: akpm@linux-foundation.org
Subject: - synclink_gt-improve-and-simplify-write-method.patch removed from -mm tree
Date: Mon, 21 Jul 2008 14:34:31 -0700
Message-ID: <200807212134.m6LLYVne025677@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46077 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753185AbYGUVfM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 21 Jul 2008 17:35:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: paulkf@microgate.com, alan@lxorguk.ukuu.org.uk, mm-commits@vger.kernel.org


The patch titled
     synclink_gt: improve and simplify write method
has been removed from the -mm tree.  Its filename was
     synclink_gt-improve-and-simplify-write-method.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: synclink_gt: improve and simplify write method
From: Paul Fulghum <paulkf@microgate.com>

Improve write method by allowing multiple HDLC frames to be loaded into tx
DMA buffer ring for continuous frame transmission.  This simplifies the
transmit code by using the common procedures for all serial protocols.

Signed-off-by: Paul Fulghum <paulkf@microgate.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/synclink_gt.c |   38 ++++++++++-------------------------
 1 file changed, 11 insertions(+), 27 deletions(-)

diff -puN drivers/char/synclink_gt.c~synclink_gt-improve-and-simplify-write-method drivers/char/synclink_gt.c
--- a/drivers/char/synclink_gt.c~synclink_gt-improve-and-simplify-write-method
+++ a/drivers/char/synclink_gt.c
@@ -855,6 +855,7 @@ static int write(struct tty_struct *tty,
 	int ret = 0;
 	struct slgt_info *info = tty->driver_data;
 	unsigned long flags;
+	unsigned int bufs_needed;
 
 	if (sanity_check(info, tty->name, "write"))
 		goto cleanup;
@@ -871,25 +872,16 @@ static int write(struct tty_struct *tty,
 	if (!count)
 		goto cleanup;
 
-	if (info->params.mode == MGSL_MODE_RAW ||
-	    info->params.mode == MGSL_MODE_MONOSYNC ||
-	    info->params.mode == MGSL_MODE_BISYNC) {
-		unsigned int bufs_needed = (count/DMABUFSIZE);
-		unsigned int bufs_free = free_tbuf_count(info);
-		if (count % DMABUFSIZE)
-			++bufs_needed;
-		if (bufs_needed > bufs_free)
-			goto cleanup;
-	} else {
-		if (info->tx_active)
-			goto cleanup;
-		if (info->tx_count) {
-			/* send accumulated data from send_char() calls */
-			/* as frame and wait before accepting more data. */
-			tx_load(info, info->tx_buf, info->tx_count);
-			goto start;
-		}
+	if (!info->tx_active && info->tx_count) {
+		/* send accumulated data from send_char() */
+		tx_load(info, info->tx_buf, info->tx_count);
+		goto start;
 	}
+	bufs_needed = (count/DMABUFSIZE);
+	if (count % DMABUFSIZE)
+		++bufs_needed;
+	if (bufs_needed > free_tbuf_count(info))
+		goto cleanup;
 
 	ret = info->tx_count = count;
 	tx_load(info, buf, count);
@@ -3963,15 +3955,7 @@ static void tdma_start(struct slgt_info 
 
 	/* set 1st descriptor address */
 	wr_reg32(info, TDDAR, info->tbufs[info->tbuf_start].pdesc);
-	switch(info->params.mode) {
-	case MGSL_MODE_RAW:
-	case MGSL_MODE_MONOSYNC:
-	case MGSL_MODE_BISYNC:
-		wr_reg32(info, TDCSR, BIT2 + BIT0); /* IRQ + DMA enable */
-		break;
-	default:
-		wr_reg32(info, TDCSR, BIT0); /* DMA enable */
-	}
+	wr_reg32(info, TDCSR, BIT2 + BIT0); /* IRQ + DMA enable */
 }
 
 static void tx_stop(struct slgt_info *info)
_

Patches currently in -mm which might be from paulkf@microgate.com are

linux-next.patch

