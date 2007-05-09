From: akpm@linux-foundation.org
Subject: - char-cyclades-remove-unused-timestamps.patch removed from -mm tree
Date: Tue, 08 May 2007 19:58:36 -0700
Message-ID: <200705090258.l492waOf010302@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:34138 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S970185AbXEIC6o (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 22:58:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jirislaby@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Char: cyclades, remove unused timestamps
has been removed from the -mm tree.  Its filename was
     char-cyclades-remove-unused-timestamps.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Char: cyclades, remove unused timestamps
From: Jiri Slaby <jirislaby@gmail.com>

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/cyclades.c  |   12 ------------
 include/linux/cyclades.h |    2 --
 2 files changed, 14 deletions(-)

diff -puN drivers/char/cyclades.c~char-cyclades-remove-unused-timestamps drivers/char/cyclades.c
--- a/drivers/char/cyclades.c~char-cyclades-remove-unused-timestamps
+++ a/drivers/char/cyclades.c
@@ -1049,7 +1049,6 @@ static void cyy_intr_chip(struct cyclade
 		channel = (u_short) (save_xir & CyIRChannel);
 		i = channel + chip * 4 + cinfo->first_line;
 		info = &cy_port[i];
-		info->last_active = jiffies;
 		save_car = readb(base_addr + (CyCAR << index));
 		cy_writeb(base_addr + (CyCAR << index), save_xir);
 
@@ -1225,7 +1224,6 @@ static void cyy_intr_chip(struct cyclade
 			goto txend;
 		}
 		info = &cy_port[i];
-		info->last_active = jiffies;
 		if (info->tty == 0) {
 			cy_writeb(base_addr + (CySRER << index),
 				  readb(base_addr + (CySRER << index)) &
@@ -1339,7 +1337,6 @@ txend:
 		save_xir = (u_char) readb(base_addr + (CyMIR << index));
 		channel = (u_short) (save_xir & CyIRChannel);
 		info = &cy_port[channel + chip * 4 + cinfo->first_line];
-		info->last_active = jiffies;
 		save_car = readb(base_addr + (CyCAR << index));
 		cy_writeb(base_addr + (CyCAR << index), save_xir);
 
@@ -1570,9 +1567,6 @@ cyz_handle_rx(struct cyclades_port *info
 		char_count = rx_put - rx_get + rx_bufsize;
 
 	if (char_count) {
-		info->last_active = jiffies;
-		info->jiffies[1] = jiffies;
-
 #ifdef CY_ENABLE_MONITORING
 		info->mon.int_count++;
 		info->mon.char_count += char_count;
@@ -1678,8 +1672,6 @@ cyz_handle_tx(struct cyclades_port *info
 			info->x_char = 0;
 			char_count--;
 			info->icount.tx++;
-			info->last_active = jiffies;
-			info->jiffies[2] = jiffies;
 		}
 #ifdef BLOCKMOVE
 		while (0 < (small_count = min_t(unsigned int,
@@ -1699,8 +1691,6 @@ cyz_handle_tx(struct cyclades_port *info
 			info->xmit_cnt -= small_count;
 			info->xmit_tail = (info->xmit_tail + small_count) &
 					(SERIAL_XMIT_SIZE - 1);
-			info->last_active = jiffies;
-			info->jiffies[2] = jiffies;
 		}
 #else
 		while (info->xmit_cnt && char_count) {
@@ -1713,8 +1703,6 @@ cyz_handle_tx(struct cyclades_port *info
 			tx_put = (tx_put + 1) & (tx_bufsize - 1);
 			char_count--;
 			info->icount.tx++;
-			info->last_active = jiffies;
-			info->jiffies[2] = jiffies;
 		}
 #endif
 ztxdone:
diff -puN include/linux/cyclades.h~char-cyclades-remove-unused-timestamps include/linux/cyclades.h
--- a/include/linux/cyclades.h~char-cyclades-remove-unused-timestamps
+++ a/include/linux/cyclades.h
@@ -569,7 +569,6 @@ struct cyclades_port {
 	int			close_delay;
 	unsigned short		closing_wait;
 	unsigned long		event;
-	unsigned long		last_active;
 	int			count;	/* # of fd on device */
 	int                     breakon;
 	int                     breakoff;
@@ -580,7 +579,6 @@ struct cyclades_port {
 	int			xmit_cnt;
         int                     default_threshold;
         int                     default_timeout;
-	unsigned long		jiffies[3];
 	unsigned long		rflush_count;
 	struct cyclades_monitor	mon;
 	struct cyclades_idle_stats	idle_stats;
_

Patches currently in -mm which might be from jirislaby@gmail.com are

origin.patch
git-dvb.patch
cinergyt2-fix-file-release-handler.patch
auerswald-fix-file-release-handler.patch
unify-queue_delayed_work-and-queue_delayed_work_on.patch
vmstat-use-our-own-timer-events-fix.patch
shrink_slab-handle-bad-shrinkers.patch
