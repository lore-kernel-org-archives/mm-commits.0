From: akpm@linux-foundation.org
Subject: - char-cyclades-remove-locking-macros.patch removed from -mm tree
Date: Tue, 08 May 2007 19:58:47 -0700
Message-ID: <200705090258.l492wlCa010313@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:37981 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S970218AbXEIC6v (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 22:58:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jirislaby@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Char: cyclades, remove locking macros
has been removed from the -mm tree.  Its filename was
     char-cyclades-remove-locking-macros.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Char: cyclades, remove locking macros
From: Jiri Slaby <jirislaby@gmail.com>

and use locally stored card structure if possible

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/cyclades.c |  245 ++++++++++++++++++--------------------
 1 file changed, 118 insertions(+), 127 deletions(-)

diff -puN drivers/char/cyclades.c~char-cyclades-remove-locking-macros drivers/char/cyclades.c
--- a/drivers/char/cyclades.c~char-cyclades-remove-locking-macros
+++ a/drivers/char/cyclades.c
@@ -653,16 +653,6 @@
 #include <asm/irq.h>
 #include <asm/uaccess.h>
 
-#define	CY_LOCK(info,flags)					\
-		do {						\
-		spin_lock_irqsave(&info->card->card_lock, flags); \
-		} while (0)
-
-#define	CY_UNLOCK(info,flags)					\
-		do {						\
-		spin_unlock_irqrestore(&info->card->card_lock, flags); \
-		} while (0)
-
 #include <linux/kernel.h>
 #include <linux/pci.h>
 
@@ -1863,13 +1853,13 @@ static void cyz_rx_restart(unsigned long
 	__u32 channel = info->line - card->first_line;
 	unsigned long flags;
 
-	CY_LOCK(info, flags);
+	spin_lock_irqsave(&card->card_lock, flags);
 	retval = cyz_issue_cmd(card, channel, C_CM_INTBACK2, 0L);
 	if (retval != 0) {
 		printk(KERN_ERR "cyc:cyz_rx_restart retval on ttyC%d was %x\n",
 			info->line, retval);
 	}
-	CY_UNLOCK(info, flags);
+	spin_unlock_irqrestore(&card->card_lock, flags);
 }
 
 #else				/* CONFIG_CYZ_INTR */
@@ -1949,7 +1939,7 @@ static int startup(struct cyclades_port 
 	if (!page)
 		return -ENOMEM;
 
-	CY_LOCK(info, flags);
+	spin_lock_irqsave(&card->card_lock, flags);
 
 	if (info->flags & ASYNC_INITIALIZED) {
 		free_page(page);
@@ -1969,7 +1959,7 @@ static int startup(struct cyclades_port 
 	else
 		info->xmit_buf = (unsigned char *)page;
 
-	CY_UNLOCK(info, flags);
+	spin_unlock_irqrestore(&card->card_lock, flags);
 
 	set_line_char(info);
 
@@ -1984,7 +1974,7 @@ static int startup(struct cyclades_port 
 				"base_addr %p\n",
 				card, chip, channel, base_addr);
 #endif
-		CY_LOCK(info, flags);
+		spin_lock_irqsave(&card->card_lock, flags);
 
 		cy_writeb(base_addr + (CyCAR << index), (u_char) channel);
 
@@ -2020,7 +2010,7 @@ static int startup(struct cyclades_port 
 		info->idle_stats.recv_idle =
 		info->idle_stats.xmit_idle = jiffies;
 
-		CY_UNLOCK(info, flags);
+		spin_unlock_irqrestore(&card->card_lock, flags);
 
 	} else {
 		struct FIRM_ID __iomem *firm_id;
@@ -2045,7 +2035,7 @@ static int startup(struct cyclades_port 
 		printk(KERN_DEBUG "cyc startup Z card %d, channel %d, "
 			"base_addr %p\n", card, channel, base_addr);
 #endif
-		CY_LOCK(info, flags);
+		spin_lock_irqsave(&card->card_lock, flags);
 
 		cy_writel(&ch_ctrl[channel].op_mode, C_CH_ENABLE);
 #ifdef Z_WAKE
@@ -2085,8 +2075,7 @@ static int startup(struct cyclades_port 
 		cy_writel(&ch_ctrl[channel].rs_control,
 			readl(&ch_ctrl[channel].rs_control) | C_RS_RTS |
 			C_RS_DTR);
-		retval = cyz_issue_cmd(info->card, channel,
-				C_CM_IOCTLM, 0L);
+		retval = cyz_issue_cmd(card, channel, C_CM_IOCTLM, 0L);
 		if (retval != 0) {
 			printk(KERN_ERR "cyc:startup(3) retval on ttyC%d was "
 				"%x\n", info->line, retval);
@@ -2108,7 +2097,7 @@ static int startup(struct cyclades_port 
 		info->idle_stats.recv_idle =
 		info->idle_stats.xmit_idle = jiffies;
 
-		CY_UNLOCK(info, flags);
+		spin_unlock_irqrestore(&card->card_lock, flags);
 	}
 
 #ifdef CY_DEBUG_OPEN
@@ -2117,7 +2106,7 @@ static int startup(struct cyclades_port 
 	return 0;
 
 errout:
-	CY_UNLOCK(info, flags);
+	spin_unlock_irqrestore(&card->card_lock, flags);
 	return retval;
 }				/* startup */
 
@@ -2136,22 +2125,22 @@ static void start_xmit(struct cyclades_p
 		index = card->bus_index;
 		base_addr = card->base_addr + (cy_chip_offset[chip] << index);
 
-		CY_LOCK(info, flags);
+		spin_lock_irqsave(&card->card_lock, flags);
 		cy_writeb(base_addr + (CyCAR << index), channel);
 		cy_writeb(base_addr + (CySRER << index),
 			readb(base_addr + (CySRER << index)) | CyTxRdy);
-		CY_UNLOCK(info, flags);
+		spin_unlock_irqrestore(&card->card_lock, flags);
 	} else {
 #ifdef CONFIG_CYZ_INTR
 		int retval;
 
-		CY_LOCK(info, flags);
+		spin_lock_irqsave(&card->card_lock, flags);
 		retval = cyz_issue_cmd(card, channel, C_CM_INTBACK, 0L);
 		if (retval != 0) {
 			printk(KERN_ERR "cyc:start_xmit retval on ttyC%d was "
 				"%x\n", info->line, retval);
 		}
-		CY_UNLOCK(info, flags);
+		spin_unlock_irqrestore(&card->card_lock, flags);
 #else				/* CONFIG_CYZ_INTR */
 		/* Don't have to do anything at this time */
 #endif				/* CONFIG_CYZ_INTR */
@@ -2187,7 +2176,7 @@ static void shutdown(struct cyclades_por
 				card, chip, channel, base_addr);
 #endif
 
-		CY_LOCK(info, flags);
+		spin_lock_irqsave(&card->card_lock, flags);
 
 		/* Clear delta_msr_wait queue to avoid mem leaks. */
 		wake_up_interruptible(&info->delta_msr_wait);
@@ -2217,7 +2206,7 @@ static void shutdown(struct cyclades_por
 			set_bit(TTY_IO_ERROR, &info->tty->flags);
 		}
 		info->flags &= ~ASYNC_INITIALIZED;
-		CY_UNLOCK(info, flags);
+		spin_unlock_irqrestore(&card->card_lock, flags);
 	} else {
 		struct FIRM_ID __iomem *firm_id;
 		struct ZFW_CTRL __iomem *zfw_ctrl;
@@ -2241,7 +2230,7 @@ static void shutdown(struct cyclades_por
 		board_ctrl = &zfw_ctrl->board_ctrl;
 		ch_ctrl = zfw_ctrl->ch_ctrl;
 
-		CY_LOCK(info, flags);
+		spin_lock_irqsave(&card->card_lock, flags);
 
 		if (info->xmit_buf) {
 			unsigned char *temp;
@@ -2270,7 +2259,7 @@ static void shutdown(struct cyclades_por
 		}
 		info->flags &= ~ASYNC_INITIALIZED;
 
-		CY_UNLOCK(info, flags);
+		spin_unlock_irqrestore(&card->card_lock, flags);
 	}
 
 #ifdef CY_DEBUG_OPEN
@@ -2330,10 +2319,10 @@ block_til_ready(struct tty_struct *tty, 
 	printk(KERN_DEBUG "cyc block_til_ready before block: ttyC%d, "
 		"count = %d\n", info->line, info->count);
 #endif
-	CY_LOCK(info, flags);
+	spin_lock_irqsave(&cinfo->card_lock, flags);
 	if (!tty_hung_up_p(filp))
 		info->count--;
-	CY_UNLOCK(info, flags);
+	spin_unlock_irqrestore(&cinfo->card_lock, flags);
 #ifdef CY_DEBUG_COUNT
 	printk(KERN_DEBUG "cyc block_til_ready: (%d): decrementing count to "
 		"%d\n", current->pid, info->count);
@@ -2347,7 +2336,7 @@ block_til_ready(struct tty_struct *tty, 
 		base_addr = cinfo->base_addr + (cy_chip_offset[chip] << index);
 
 		while (1) {
-			CY_LOCK(info, flags);
+			spin_lock_irqsave(&cinfo->card_lock, flags);
 			if ((tty->termios->c_cflag & CBAUD)) {
 				cy_writeb(base_addr + (CyCAR << index),
 					  (u_char) channel);
@@ -2363,7 +2352,7 @@ block_til_ready(struct tty_struct *tty, 
 					readb(base_addr + (CyMSVR2 << index)));
 #endif
 			}
-			CY_UNLOCK(info, flags);
+			spin_unlock_irqrestore(&cinfo->card_lock, flags);
 
 			set_current_state(TASK_INTERRUPTIBLE);
 			if (tty_hung_up_p(filp) ||
@@ -2373,16 +2362,16 @@ block_til_ready(struct tty_struct *tty, 
 				break;
 			}
 
-			CY_LOCK(info, flags);
+			spin_lock_irqsave(&cinfo->card_lock, flags);
 			cy_writeb(base_addr + (CyCAR << index),
 				  (u_char) channel);
 			if (!(info->flags & ASYNC_CLOSING) && (C_CLOCAL(tty) ||
 					(readb(base_addr +
 						(CyMSVR1 << index)) & CyDCD))) {
-				CY_UNLOCK(info, flags);
+				spin_unlock_irqrestore(&cinfo->card_lock, flags);
 				break;
 			}
-			CY_UNLOCK(info, flags);
+			spin_unlock_irqrestore(&cinfo->card_lock, flags);
 
 			if (signal_pending(current)) {
 				retval = -ERESTARTSYS;
@@ -2419,7 +2408,7 @@ block_til_ready(struct tty_struct *tty, 
 				cy_writel(&ch_ctrl[channel].rs_control,
 					readl(&ch_ctrl[channel].rs_control) |
 					C_RS_RTS | C_RS_DTR);
-				retval = cyz_issue_cmd(info->card,
+				retval = cyz_issue_cmd(cinfo,
 					channel, C_CM_IOCTLM, 0L);
 				if (retval != 0) {
 					printk(KERN_ERR "cyc:block_til_ready "
@@ -2688,6 +2677,7 @@ static void cy_wait_until_sent(struct tt
 static void cy_close(struct tty_struct *tty, struct file *filp)
 {
 	struct cyclades_port *info = tty->driver_data;
+	struct cyclades_card *card;
 	unsigned long flags;
 
 #ifdef CY_DEBUG_OTHER
@@ -2698,10 +2688,12 @@ static void cy_close(struct tty_struct *
 		return;
 	}
 
-	CY_LOCK(info, flags);
+	card = info->card;
+
+	spin_lock_irqsave(&card->card_lock, flags);
 	/* If the TTY is being hung up, nothing to do */
 	if (tty_hung_up_p(filp)) {
-		CY_UNLOCK(info, flags);
+		spin_unlock_irqrestore(&card->card_lock, flags);
 		return;
 	}
 #ifdef CY_DEBUG_OPEN
@@ -2731,7 +2723,7 @@ static void cy_close(struct tty_struct *
 		info->count = 0;
 	}
 	if (info->count) {
-		CY_UNLOCK(info, flags);
+		spin_unlock_irqrestore(&card->card_lock, flags);
 		return;
 	}
 	info->flags |= ASYNC_CLOSING;
@@ -2741,16 +2733,16 @@ static void cy_close(struct tty_struct *
 	 * the line discipline to only process XON/XOFF characters.
 	 */
 	tty->closing = 1;
-	CY_UNLOCK(info, flags);
+	spin_unlock_irqrestore(&card->card_lock, flags);
 	if (info->closing_wait != CY_CLOSING_WAIT_NONE) {
 		tty_wait_until_sent(tty, info->closing_wait);
 	}
-	CY_LOCK(info, flags);
+	spin_lock_irqsave(&card->card_lock, flags);
 
-	if (!IS_CYC_Z(*info->card)) {
-		int channel = info->line - info->card->first_line;
-		int index = info->card->bus_index;
-		void __iomem *base_addr = info->card->base_addr +
+	if (!IS_CYC_Z(*card)) {
+		int channel = info->line - card->first_line;
+		int index = card->bus_index;
+		void __iomem *base_addr = card->base_addr +
 			(cy_chip_offset[channel >> 2] << index);
 		/* Stop accepting input */
 		channel &= 0x03;
@@ -2760,53 +2752,52 @@ static void cy_close(struct tty_struct *
 		if (info->flags & ASYNC_INITIALIZED) {
 			/* Waiting for on-board buffers to be empty before closing
 			   the port */
-			CY_UNLOCK(info, flags);
+			spin_unlock_irqrestore(&card->card_lock, flags);
 			cy_wait_until_sent(tty, info->timeout);
-			CY_LOCK(info, flags);
+			spin_lock_irqsave(&card->card_lock, flags);
 		}
 	} else {
 #ifdef Z_WAKE
 		/* Waiting for on-board buffers to be empty before closing the port */
-		void __iomem *base_addr = info->card->base_addr;
+		void __iomem *base_addr = card->base_addr;
 		struct FIRM_ID __iomem *firm_id = base_addr + ID_ADDRESS;
 		struct ZFW_CTRL __iomem *zfw_ctrl =
 		    base_addr + (readl(&firm_id->zfwctrl_addr) & 0xfffff);
 		struct CH_CTRL __iomem *ch_ctrl = zfw_ctrl->ch_ctrl;
-		int channel = info->line - info->card->first_line;
+		int channel = info->line - card->first_line;
 		int retval;
 
 		if (readl(&ch_ctrl[channel].flow_status) != C_FS_TXIDLE) {
-			retval = cyz_issue_cmd(info->card, channel,
-						C_CM_IOCTLW, 0L);
+			retval = cyz_issue_cmd(card, channel, C_CM_IOCTLW, 0L);
 			if (retval != 0) {
 				printk(KERN_DEBUG "cyc:cy_close retval on "
 					"ttyC%d was %x\n", info->line, retval);
 			}
-			CY_UNLOCK(info, flags);
+			spin_unlock_irqrestore(&card->card_lock, flags);
 			wait_for_completion_interruptible(&info->shutdown_wait);
-			CY_LOCK(info, flags);
+			spin_lock_irqsave(&card->card_lock, flags);
 		}
 #endif
 	}
 
-	CY_UNLOCK(info, flags);
+	spin_unlock_irqrestore(&card->card_lock, flags);
 	shutdown(info);
 	if (tty->driver->flush_buffer)
 		tty->driver->flush_buffer(tty);
 	tty_ldisc_flush(tty);
-	CY_LOCK(info, flags);
+	spin_lock_irqsave(&card->card_lock, flags);
 
 	tty->closing = 0;
 	info->event = 0;
 	info->tty = NULL;
 	if (info->blocked_open) {
-		CY_UNLOCK(info, flags);
+		spin_unlock_irqrestore(&card->card_lock, flags);
 		if (info->close_delay) {
 			msleep_interruptible(jiffies_to_msecs
 						(info->close_delay));
 		}
 		wake_up_interruptible(&info->open_wait);
-		CY_LOCK(info, flags);
+		spin_lock_irqsave(&card->card_lock, flags);
 	}
 	info->flags &= ~(ASYNC_NORMAL_ACTIVE | ASYNC_CLOSING);
 	wake_up_interruptible(&info->close_wait);
@@ -2815,7 +2806,7 @@ static void cy_close(struct tty_struct *
 	printk(KERN_DEBUG "cyc:cy_close done\n");
 #endif
 
-	CY_UNLOCK(info, flags);
+	spin_unlock_irqrestore(&card->card_lock, flags);
 }				/* cy_close */
 
 /* This routine gets called when tty_write has put something into
@@ -2848,7 +2839,7 @@ static int cy_write(struct tty_struct *t
 	if (!info->xmit_buf)
 		return 0;
 
-	CY_LOCK(info, flags);
+	spin_lock_irqsave(&info->card->card_lock, flags);
 	while (1) {
 		c = min(count, min((int)(SERIAL_XMIT_SIZE - info->xmit_cnt - 1),
 				   (int)(SERIAL_XMIT_SIZE - info->xmit_head)));
@@ -2864,7 +2855,7 @@ static int cy_write(struct tty_struct *t
 		count -= c;
 		ret += c;
 	}
-	CY_UNLOCK(info, flags);
+	spin_unlock_irqrestore(&info->card->card_lock, flags);
 
 	info->idle_stats.xmit_bytes += ret;
 	info->idle_stats.xmit_idle = jiffies;
@@ -2897,9 +2888,9 @@ static void cy_put_char(struct tty_struc
 	if (!info->xmit_buf)
 		return;
 
-	CY_LOCK(info, flags);
+	spin_lock_irqsave(&info->card->card_lock, flags);
 	if (info->xmit_cnt >= (int)(SERIAL_XMIT_SIZE - 1)) {
-		CY_UNLOCK(info, flags);
+		spin_unlock_irqrestore(&info->card->card_lock, flags);
 		return;
 	}
 
@@ -2908,7 +2899,7 @@ static void cy_put_char(struct tty_struc
 	info->xmit_cnt++;
 	info->idle_stats.xmit_bytes++;
 	info->idle_stats.xmit_idle = jiffies;
-	CY_UNLOCK(info, flags);
+	spin_unlock_irqrestore(&info->card->card_lock, flags);
 }				/* cy_put_char */
 
 /*
@@ -3202,7 +3193,7 @@ static void set_line_char(struct cyclade
 		channel &= 0x03;
 		base_addr = card->base_addr + (cy_chip_offset[chip] << index);
 
-		CY_LOCK(info, flags);
+		spin_lock_irqsave(&card->card_lock, flags);
 		cy_writeb(base_addr + (CyCAR << index), (u_char) channel);
 
 		/* tx and rx baud rate */
@@ -3297,7 +3288,7 @@ static void set_line_char(struct cyclade
 		if (info->tty) {
 			clear_bit(TTY_IO_ERROR, &info->tty->flags);
 		}
-		CY_UNLOCK(info, flags);
+		spin_unlock_irqrestore(&card->card_lock, flags);
 
 	} else {
 		struct FIRM_ID __iomem *firm_id;
@@ -3537,10 +3528,10 @@ static int get_lsr_info(struct cyclades_
 		index = card->bus_index;
 		base_addr = card->base_addr + (cy_chip_offset[chip] << index);
 
-		CY_LOCK(info, flags);
+		spin_lock_irqsave(&card->card_lock, flags);
 		status = readb(base_addr + (CySRER << index)) &
 				(CyTxRdy | CyTxMpty);
-		CY_UNLOCK(info, flags);
+		spin_unlock_irqrestore(&card->card_lock, flags);
 		result = (status ? 0 : TIOCSER_TEMT);
 	} else {
 		/* Not supported yet */
@@ -3575,11 +3566,11 @@ static int cy_tiocmget(struct tty_struct
 		index = card->bus_index;
 		base_addr = card->base_addr + (cy_chip_offset[chip] << index);
 
-		CY_LOCK(info, flags);
+		spin_lock_irqsave(&card->card_lock, flags);
 		cy_writeb(base_addr + (CyCAR << index), (u_char) channel);
 		status = readb(base_addr + (CyMSVR1 << index));
 		status |= readb(base_addr + (CyMSVR2 << index));
-		CY_UNLOCK(info, flags);
+		spin_unlock_irqrestore(&card->card_lock, flags);
 
 		if (info->rtsdtr_inv) {
 			result = ((status & CyRTS) ? TIOCM_DTR : 0) |
@@ -3643,7 +3634,7 @@ cy_tiocmset(struct tty_struct *tty, stru
 		base_addr = card->base_addr + (cy_chip_offset[chip] << index);
 
 		if (set & TIOCM_RTS) {
-			CY_LOCK(info, flags);
+			spin_lock_irqsave(&card->card_lock, flags);
 			cy_writeb(base_addr + (CyCAR << index),
 				  (u_char) channel);
 			if (info->rtsdtr_inv) {
@@ -3653,10 +3644,10 @@ cy_tiocmset(struct tty_struct *tty, stru
 				cy_writeb(base_addr + (CyMSVR1 << index),
 					  CyRTS);
 			}
-			CY_UNLOCK(info, flags);
+			spin_unlock_irqrestore(&card->card_lock, flags);
 		}
 		if (clear & TIOCM_RTS) {
-			CY_LOCK(info, flags);
+			spin_lock_irqsave(&card->card_lock, flags);
 			cy_writeb(base_addr + (CyCAR << index),
 				  (u_char) channel);
 			if (info->rtsdtr_inv) {
@@ -3666,10 +3657,10 @@ cy_tiocmset(struct tty_struct *tty, stru
 				cy_writeb(base_addr + (CyMSVR1 << index),
 					  ~CyRTS);
 			}
-			CY_UNLOCK(info, flags);
+			spin_unlock_irqrestore(&card->card_lock, flags);
 		}
 		if (set & TIOCM_DTR) {
-			CY_LOCK(info, flags);
+			spin_lock_irqsave(&card->card_lock, flags);
 			cy_writeb(base_addr + (CyCAR << index),
 				  (u_char) channel);
 			if (info->rtsdtr_inv) {
@@ -3685,10 +3676,10 @@ cy_tiocmset(struct tty_struct *tty, stru
 				readb(base_addr + (CyMSVR1 << index)),
 				readb(base_addr + (CyMSVR2 << index)));
 #endif
-			CY_UNLOCK(info, flags);
+			spin_unlock_irqrestore(&card->card_lock, flags);
 		}
 		if (clear & TIOCM_DTR) {
-			CY_LOCK(info, flags);
+			spin_lock_irqsave(&card->card_lock, flags);
 			cy_writeb(base_addr + (CyCAR << index),
 				  (u_char) channel);
 			if (info->rtsdtr_inv) {
@@ -3705,7 +3696,7 @@ cy_tiocmset(struct tty_struct *tty, stru
 				readb(base_addr + (CyMSVR1 << index)),
 				readb(base_addr + (CyMSVR2 << index)));
 #endif
-			CY_UNLOCK(info, flags);
+			spin_unlock_irqrestore(&card->card_lock, flags);
 		}
 	} else {
 		base_addr = card->base_addr;
@@ -3718,21 +3709,21 @@ cy_tiocmset(struct tty_struct *tty, stru
 			ch_ctrl = zfw_ctrl->ch_ctrl;
 
 			if (set & TIOCM_RTS) {
-				CY_LOCK(info, flags);
+				spin_lock_irqsave(&card->card_lock, flags);
 				cy_writel(&ch_ctrl[channel].rs_control,
 					readl(&ch_ctrl[channel].rs_control) |
 					C_RS_RTS);
-				CY_UNLOCK(info, flags);
+				spin_unlock_irqrestore(&card->card_lock, flags);
 			}
 			if (clear & TIOCM_RTS) {
-				CY_LOCK(info, flags);
+				spin_lock_irqsave(&card->card_lock, flags);
 				cy_writel(&ch_ctrl[channel].rs_control,
 					readl(&ch_ctrl[channel].rs_control) &
 					~C_RS_RTS);
-				CY_UNLOCK(info, flags);
+				spin_unlock_irqrestore(&card->card_lock, flags);
 			}
 			if (set & TIOCM_DTR) {
-				CY_LOCK(info, flags);
+				spin_lock_irqsave(&card->card_lock, flags);
 				cy_writel(&ch_ctrl[channel].rs_control,
 					readl(&ch_ctrl[channel].rs_control) |
 					C_RS_DTR);
@@ -3740,10 +3731,10 @@ cy_tiocmset(struct tty_struct *tty, stru
 				printk(KERN_DEBUG "cyc:set_modem_info raising "
 					"Z DTR\n");
 #endif
-				CY_UNLOCK(info, flags);
+				spin_unlock_irqrestore(&card->card_lock, flags);
 			}
 			if (clear & TIOCM_DTR) {
-				CY_LOCK(info, flags);
+				spin_lock_irqsave(&card->card_lock, flags);
 				cy_writel(&ch_ctrl[channel].rs_control,
 					readl(&ch_ctrl[channel].rs_control) &
 					~C_RS_DTR);
@@ -3751,19 +3742,18 @@ cy_tiocmset(struct tty_struct *tty, stru
 				printk(KERN_DEBUG "cyc:set_modem_info clearing "
 					"Z DTR\n");
 #endif
-				CY_UNLOCK(info, flags);
+				spin_unlock_irqrestore(&card->card_lock, flags);
 			}
 		} else {
 			return -ENODEV;
 		}
-		CY_LOCK(info, flags);
-		retval = cyz_issue_cmd(info->card,
-					channel, C_CM_IOCTLM, 0L);
+		spin_lock_irqsave(&card->card_lock, flags);
+		retval = cyz_issue_cmd(card, channel, C_CM_IOCTLM, 0L);
 		if (retval != 0) {
 			printk(KERN_ERR "cyc:set_modem_info retval on ttyC%d "
 				"was %x\n", info->line, retval);
 		}
-		CY_UNLOCK(info, flags);
+		spin_unlock_irqrestore(&card->card_lock, flags);
 	}
 	return 0;
 }				/* cy_tiocmset */
@@ -3774,13 +3764,16 @@ cy_tiocmset(struct tty_struct *tty, stru
 static void cy_break(struct tty_struct *tty, int break_state)
 {
 	struct cyclades_port *info = tty->driver_data;
+	struct cyclades_card *card;
 	unsigned long flags;
 
 	if (serial_paranoia_check(info, tty->name, "cy_break"))
 		return;
 
-	CY_LOCK(info, flags);
-	if (!IS_CYC_Z(*info->card)) {
+	card = info->card;
+
+	spin_lock_irqsave(&card->card_lock, flags);
+	if (!IS_CYC_Z(*card)) {
 		/* Let the transmit ISR take care of this (since it
 		   requires stuffing characters into the output stream).
 		 */
@@ -3788,18 +3781,18 @@ static void cy_break(struct tty_struct *
 			if (!info->breakon) {
 				info->breakon = 1;
 				if (!info->xmit_cnt) {
-					CY_UNLOCK(info, flags);
+					spin_unlock_irqrestore(&card->card_lock, flags);
 					start_xmit(info);
-					CY_LOCK(info, flags);
+					spin_lock_irqsave(&card->card_lock, flags);
 				}
 			}
 		} else {
 			if (!info->breakoff) {
 				info->breakoff = 1;
 				if (!info->xmit_cnt) {
-					CY_UNLOCK(info, flags);
+					spin_unlock_irqrestore(&card->card_lock, flags);
 					start_xmit(info);
-					CY_LOCK(info, flags);
+					spin_lock_irqsave(&card->card_lock, flags);
 				}
 			}
 		}
@@ -3807,16 +3800,16 @@ static void cy_break(struct tty_struct *
 		int retval;
 
 		if (break_state == -1) {
-			retval = cyz_issue_cmd(info->card,
-				info->line - info->card->first_line,
+			retval = cyz_issue_cmd(card,
+				info->line - card->first_line,
 				C_CM_SET_BREAK, 0L);
 			if (retval != 0) {
 				printk(KERN_ERR "cyc:cy_break (set) retval on "
 					"ttyC%d was %x\n", info->line, retval);
 			}
 		} else {
-			retval = cyz_issue_cmd(info->card,
-				info->line - info->card->first_line,
+			retval = cyz_issue_cmd(card,
+				info->line - card->first_line,
 				C_CM_CLR_BREAK, 0L);
 			if (retval != 0) {
 				printk(KERN_DEBUG "cyc:cy_break (clr) retval "
@@ -3825,7 +3818,7 @@ static void cy_break(struct tty_struct *
 			}
 		}
 	}
-	CY_UNLOCK(info, flags);
+	spin_unlock_irqrestore(&card->card_lock, flags);
 }				/* cy_break */
 
 static int
@@ -3860,10 +3853,10 @@ static int set_threshold(struct cyclades
 		info->cor3 &= ~CyREC_FIFO;
 		info->cor3 |= value & CyREC_FIFO;
 
-		CY_LOCK(info, flags);
+		spin_lock_irqsave(&card->card_lock, flags);
 		cy_writeb(base_addr + (CyCOR3 << index), info->cor3);
 		cyy_issue_cmd(base_addr, CyCOR_CHANGE | CyCOR3ch, index);
-		CY_UNLOCK(info, flags);
+		spin_unlock_irqrestore(&card->card_lock, flags);
 	} else {
 		/* Nothing to do! */
 	}
@@ -3922,9 +3915,9 @@ static int set_timeout(struct cyclades_p
 		index = card->bus_index;
 		base_addr = card->base_addr + (cy_chip_offset[chip] << index);
 
-		CY_LOCK(info, flags);
+		spin_lock_irqsave(&card->card_lock, flags);
 		cy_writeb(base_addr + (CyRTPR << index), value & 0xff);
-		CY_UNLOCK(info, flags);
+		spin_unlock_irqrestore(&card->card_lock, flags);
 	} else {
 		/* Nothing to do! */
 	}
@@ -4067,15 +4060,15 @@ cy_ioctl(struct tty_struct *tty, struct 
 		 * Caller should use TIOCGICOUNT to see which one it was
 		 */
 	case TIOCMIWAIT:
-		CY_LOCK(info, flags);
+		spin_lock_irqsave(&info->card->card_lock, flags);
 		/* note the counters on entry */
 		cnow = info->icount;
-		CY_UNLOCK(info, flags);
+		spin_unlock_irqrestore(&info->card->card_lock, flags);
 		ret_val = wait_event_interruptible(info->delta_msr_wait, ({
 			cprev = cnow;
-			CY_LOCK(info, flags);
+			spin_lock_irqsave(&info->card->card_lock, flags);
 			cnow = info->icount;	/* atomic copy */
-			CY_UNLOCK(info, flags);
+			spin_unlock_irqrestore(&info->card->card_lock, flags);
 
 			((arg & TIOCM_RNG) && (cnow.rng != cprev.rng)) ||
 			((arg & TIOCM_DSR) && (cnow.dsr != cprev.dsr)) ||
@@ -4091,9 +4084,9 @@ cy_ioctl(struct tty_struct *tty, struct 
 		 *     RI where only 0->1 is counted.
 		 */
 	case TIOCGICOUNT:
-		CY_LOCK(info, flags);
+		spin_lock_irqsave(&info->card->card_lock, flags);
 		cnow = info->icount;
-		CY_UNLOCK(info, flags);
+		spin_unlock_irqrestore(&info->card->card_lock, flags);
 		p_cuser = argp;
 		ret_val = put_user(cnow.cts, &p_cuser->cts);
 		if (ret_val)
@@ -4248,7 +4241,7 @@ static void cy_throttle(struct tty_struc
 			base_addr = card->base_addr +
 				(cy_chip_offset[chip] << index);
 
-			CY_LOCK(info, flags);
+			spin_lock_irqsave(&card->card_lock, flags);
 			cy_writeb(base_addr + (CyCAR << index),
 				  (u_char) channel);
 			if (info->rtsdtr_inv) {
@@ -4258,7 +4251,7 @@ static void cy_throttle(struct tty_struc
 				cy_writeb(base_addr + (CyMSVR1 << index),
 					  ~CyRTS);
 			}
-			CY_UNLOCK(info, flags);
+			spin_unlock_irqrestore(&card->card_lock, flags);
 		} else {
 			info->throttle = 1;
 		}
@@ -4306,7 +4299,7 @@ static void cy_unthrottle(struct tty_str
 			base_addr = card->base_addr +
 				(cy_chip_offset[chip] << index);
 
-			CY_LOCK(info, flags);
+			spin_lock_irqsave(&card->card_lock, flags);
 			cy_writeb(base_addr + (CyCAR << index),
 				  (u_char) channel);
 			if (info->rtsdtr_inv) {
@@ -4316,7 +4309,7 @@ static void cy_unthrottle(struct tty_str
 				cy_writeb(base_addr + (CyMSVR1 << index),
 					  CyRTS);
 			}
-			CY_UNLOCK(info, flags);
+			spin_unlock_irqrestore(&card->card_lock, flags);
 		} else {
 			info->throttle = 0;
 		}
@@ -4347,15 +4340,14 @@ static void cy_stop(struct tty_struct *t
 		index = cinfo->bus_index;
 		chip = channel >> 2;
 		channel &= 0x03;
-		base_addr = info->card->base_addr +
-			(cy_chip_offset[chip] << index);
+		base_addr = cinfo->base_addr + (cy_chip_offset[chip] << index);
 
-		CY_LOCK(info, flags);
+		spin_lock_irqsave(&cinfo->card_lock, flags);
 		cy_writeb(base_addr + (CyCAR << index),
 			(u_char)(channel & 0x0003)); /* index channel */
 		cy_writeb(base_addr + (CySRER << index),
 			  readb(base_addr + (CySRER << index)) & ~CyTxRdy);
-		CY_UNLOCK(info, flags);
+		spin_unlock_irqrestore(&cinfo->card_lock, flags);
 	} else {
 		/* Nothing to do! */
 	}
@@ -4382,14 +4374,13 @@ static void cy_start(struct tty_struct *
 	if (!IS_CYC_Z(*cinfo)) {
 		chip = channel >> 2;
 		channel &= 0x03;
-		base_addr = info->card->base_addr +
-			(cy_chip_offset[chip] << index);
+		base_addr = cinfo->base_addr + (cy_chip_offset[chip] << index);
 
-		CY_LOCK(info, flags);
+		spin_lock_irqsave(&cinfo->card_lock, flags);
 		cy_writeb(base_addr + (CyCAR << index), (u_char) (channel & 0x0003));	/* index channel */
 		cy_writeb(base_addr + (CySRER << index),
 			  readb(base_addr + (CySRER << index)) | CyTxRdy);
-		CY_UNLOCK(info, flags);
+		spin_unlock_irqrestore(&cinfo->card_lock, flags);
 	} else {
 		/* Nothing to do! */
 	}
@@ -4412,19 +4403,19 @@ static void cy_flush_buffer(struct tty_s
 	card = info->card;
 	channel = info->line - card->first_line;
 
-	CY_LOCK(info, flags);
+	spin_lock_irqsave(&card->card_lock, flags);
 	info->xmit_cnt = info->xmit_head = info->xmit_tail = 0;
-	CY_UNLOCK(info, flags);
+	spin_unlock_irqrestore(&card->card_lock, flags);
 
 	if (IS_CYC_Z(*card)) {	/* If it is a Z card, flush the on-board
 					   buffers as well */
-		CY_LOCK(info, flags);
+		spin_lock_irqsave(&card->card_lock, flags);
 		retval = cyz_issue_cmd(card, channel, C_CM_FLUSH_TX, 0L);
 		if (retval != 0) {
 			printk(KERN_ERR "cyc: flush_buffer retval on ttyC%d "
 				"was %x\n", info->line, retval);
 		}
-		CY_UNLOCK(info, flags);
+		spin_unlock_irqrestore(&card->card_lock, flags);
 	}
 	tty_wakeup(tty);
 }				/* cy_flush_buffer */
_

Patches currently in -mm which might be from jirislaby@gmail.com are

origin.patch
git-dvb.patch
cinergyt2-fix-file-release-handler.patch
auerswald-fix-file-release-handler.patch
unify-queue_delayed_work-and-queue_delayed_work_on.patch
vmstat-use-our-own-timer-events-fix.patch
shrink_slab-handle-bad-shrinkers.patch
