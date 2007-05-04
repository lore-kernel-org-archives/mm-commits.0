From: akpm@linux-foundation.org
Subject: + char-cyclades-make-info-card-a-pointer.patch added to -mm tree
Date: Thu, 03 May 2007 23:45:37 -0700
Message-ID: <200705040645.l446jbPN030886@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:34787 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965714AbXEDGpm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 May 2007 02:45:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jirislaby@gmail.com


The patch titled
     Char: cyclades, make info->card a pointer
has been added to the -mm tree.  Its filename is
     char-cyclades-make-info-card-a-pointer.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Char: cyclades, make info->card a pointer
From: Jiri Slaby <jirislaby@gmail.com>

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/cyclades.c  |  323 ++++++++++++++++++-------------------
 include/linux/cyclades.h |    2 
 2 files changed, 163 insertions(+), 162 deletions(-)

diff -puN drivers/char/cyclades.c~char-cyclades-make-info-card-a-pointer drivers/char/cyclades.c
--- a/drivers/char/cyclades.c~char-cyclades-make-info-card-a-pointer
+++ a/drivers/char/cyclades.c
@@ -655,12 +655,12 @@
 
 #define	CY_LOCK(info,flags)					\
 		do {						\
-		spin_lock_irqsave(&cy_card[info->card].card_lock, flags); \
+		spin_lock_irqsave(&info->card->card_lock, flags); \
 		} while (0)
 
 #define	CY_UNLOCK(info,flags)					\
 		do {						\
-		spin_unlock_irqrestore(&cy_card[info->card].card_lock, flags); \
+		spin_unlock_irqrestore(&info->card->card_lock, flags); \
 		} while (0)
 
 #include <linux/kernel.h>
@@ -1555,7 +1555,7 @@ static void
 cyz_handle_rx(struct cyclades_port *info, struct CH_CTRL __iomem *ch_ctrl,
 		struct BUF_CTRL __iomem *buf_ctrl)
 {
-	struct cyclades_card *cinfo = &cy_card[info->card];
+	struct cyclades_card *cinfo = info->card;
 	struct tty_struct *tty = info->tty;
 	int char_count;
 	int len;
@@ -1651,7 +1651,7 @@ static void
 cyz_handle_tx(struct cyclades_port *info, struct CH_CTRL __iomem *ch_ctrl,
 		struct BUF_CTRL __iomem *buf_ctrl)
 {
-	struct cyclades_card *cinfo = &cy_card[info->card];
+	struct cyclades_card *cinfo = info->card;
 	struct tty_struct *tty = info->tty;
 	char data;
 	int char_count;
@@ -1878,13 +1878,13 @@ static irqreturn_t cyz_interrupt(int irq
 static void cyz_rx_restart(unsigned long arg)
 {
 	struct cyclades_port *info = (struct cyclades_port *)arg;
+	struct cyclades_card *card = info->card;
 	int retval;
-	int card = info->card;
-	__u32 channel = (info->line) - (cy_card[card].first_line);
+	__u32 channel = info->line - card->first_line;
 	unsigned long flags;
 
 	CY_LOCK(info, flags);
-	retval = cyz_issue_cmd(&cy_card[card], channel, C_CM_INTBACK2, 0L);
+	retval = cyz_issue_cmd(card, channel, C_CM_INTBACK2, 0L);
 	if (retval != 0) {
 		printk(KERN_ERR "cyc:cyz_rx_restart retval on ttyC%d was %x\n",
 			info->line, retval);
@@ -1956,14 +1956,15 @@ static void cyz_poll(unsigned long arg)
  */
 static int startup(struct cyclades_port *info)
 {
+	struct cyclades_card *card;
 	unsigned long flags;
 	int retval = 0;
 	void __iomem *base_addr;
-	int card, chip, channel, index;
+	int chip, channel, index;
 	unsigned long page;
 
 	card = info->card;
-	channel = (info->line) - (cy_card[card].first_line);
+	channel = info->line - card->first_line;
 
 	page = get_zeroed_page(GFP_KERNEL);
 	if (!page)
@@ -1993,12 +1994,11 @@ static int startup(struct cyclades_port 
 
 	set_line_char(info);
 
-	if (!IS_CYC_Z(cy_card[card])) {
+	if (!IS_CYC_Z(*card)) {
 		chip = channel >> 2;
 		channel &= 0x03;
-		index = cy_card[card].bus_index;
-		base_addr = cy_card[card].base_addr +
-				(cy_chip_offset[chip] << index);
+		index = card->bus_index;
+		base_addr = card->base_addr + (cy_chip_offset[chip] << index);
 
 #ifdef CY_DEBUG_OPEN
 		printk(KERN_DEBUG "cyc startup card %d, chip %d, channel %d, "
@@ -2050,14 +2050,14 @@ static int startup(struct cyclades_port 
 		struct CH_CTRL __iomem *ch_ctrl;
 		int retval;
 
-		base_addr = cy_card[card].base_addr;
+		base_addr = card->base_addr;
 
 		firm_id = base_addr + ID_ADDRESS;
-		if (!ISZLOADED(cy_card[card])) {
+		if (!ISZLOADED(*card)) {
 			return -ENODEV;
 		}
 
-		zfw_ctrl = cy_card[card].base_addr +
+		zfw_ctrl = card->base_addr +
 				(readl(&firm_id->zfwctrl_addr) & 0xfffff);
 		board_ctrl = &zfw_ctrl->board_ctrl;
 		ch_ctrl = zfw_ctrl->ch_ctrl;
@@ -2088,15 +2088,14 @@ static int startup(struct cyclades_port 
 #endif				/* CONFIG_CYZ_INTR */
 #endif				/* Z_WAKE */
 
-		retval = cyz_issue_cmd(&cy_card[card], channel, C_CM_IOCTL, 0L);
+		retval = cyz_issue_cmd(card, channel, C_CM_IOCTL, 0L);
 		if (retval != 0) {
 			printk(KERN_ERR "cyc:startup(1) retval on ttyC%d was "
 				"%x\n", info->line, retval);
 		}
 
 		/* Flush RX buffers before raising DTR and RTS */
-		retval = cyz_issue_cmd(&cy_card[card], channel, C_CM_FLUSH_RX,
-				0L);
+		retval = cyz_issue_cmd(card, channel, C_CM_FLUSH_RX, 0L);
 		if (retval != 0) {
 			printk(KERN_ERR "cyc:startup(2) retval on ttyC%d was "
 				"%x\n", info->line, retval);
@@ -2107,7 +2106,7 @@ static int startup(struct cyclades_port 
 		cy_writel(&ch_ctrl[channel].rs_control,
 			readl(&ch_ctrl[channel].rs_control) | C_RS_RTS |
 			C_RS_DTR);
-		retval = cyz_issue_cmd(&cy_card[info->card], channel,
+		retval = cyz_issue_cmd(info->card, channel,
 				C_CM_IOCTLM, 0L);
 		if (retval != 0) {
 			printk(KERN_ERR "cyc:startup(3) retval on ttyC%d was "
@@ -2145,18 +2144,18 @@ errout:
 
 static void start_xmit(struct cyclades_port *info)
 {
+	struct cyclades_card *card;
 	unsigned long flags;
 	void __iomem *base_addr;
-	int card, chip, channel, index;
+	int chip, channel, index;
 
 	card = info->card;
-	channel = (info->line) - (cy_card[card].first_line);
-	if (!IS_CYC_Z(cy_card[card])) {
+	channel = info->line - card->first_line;
+	if (!IS_CYC_Z(*card)) {
 		chip = channel >> 2;
 		channel &= 0x03;
-		index = cy_card[card].bus_index;
-		base_addr = cy_card[card].base_addr +
-				(cy_chip_offset[chip] << index);
+		index = card->bus_index;
+		base_addr = card->base_addr + (cy_chip_offset[chip] << index);
 
 		CY_LOCK(info, flags);
 		cy_writeb(base_addr + (CyCAR << index), channel);
@@ -2168,8 +2167,7 @@ static void start_xmit(struct cyclades_p
 		int retval;
 
 		CY_LOCK(info, flags);
-		retval = cyz_issue_cmd(&cy_card[card], channel, C_CM_INTBACK,
-				0L);
+		retval = cyz_issue_cmd(card, channel, C_CM_INTBACK, 0L);
 		if (retval != 0) {
 			printk(KERN_ERR "cyc:start_xmit retval on ttyC%d was "
 				"%x\n", info->line, retval);
@@ -2187,22 +2185,22 @@ static void start_xmit(struct cyclades_p
  */
 static void shutdown(struct cyclades_port *info)
 {
+	struct cyclades_card *card;
 	unsigned long flags;
 	void __iomem *base_addr;
-	int card, chip, channel, index;
+	int chip, channel, index;
 
 	if (!(info->flags & ASYNC_INITIALIZED)) {
 		return;
 	}
 
 	card = info->card;
-	channel = info->line - cy_card[card].first_line;
-	if (!IS_CYC_Z(cy_card[card])) {
+	channel = info->line - card->first_line;
+	if (!IS_CYC_Z(*card)) {
 		chip = channel >> 2;
 		channel &= 0x03;
-		index = cy_card[card].bus_index;
-		base_addr = cy_card[card].base_addr +
-				(cy_chip_offset[chip] << index);
+		index = card->bus_index;
+		base_addr = card->base_addr + (cy_chip_offset[chip] << index);
 
 #ifdef CY_DEBUG_OPEN
 		printk(KERN_DEBUG "cyc shutdown Y card %d, chip %d, "
@@ -2248,18 +2246,18 @@ static void shutdown(struct cyclades_por
 		struct CH_CTRL __iomem *ch_ctrl;
 		int retval;
 
-		base_addr = cy_card[card].base_addr;
+		base_addr = card->base_addr;
 #ifdef CY_DEBUG_OPEN
 		printk(KERN_DEBUG "cyc shutdown Z card %d, channel %d, "
 			"base_addr %p\n", card, channel, base_addr);
 #endif
 
 		firm_id = base_addr + ID_ADDRESS;
-		if (!ISZLOADED(cy_card[card])) {
+		if (!ISZLOADED(*card)) {
 			return;
 		}
 
-		zfw_ctrl = cy_card[card].base_addr +
+		zfw_ctrl = card->base_addr +
 				(readl(&firm_id->zfwctrl_addr) & 0xfffff);
 		board_ctrl = &zfw_ctrl->board_ctrl;
 		ch_ctrl = zfw_ctrl->ch_ctrl;
@@ -2277,7 +2275,7 @@ static void shutdown(struct cyclades_por
 			cy_writel(&ch_ctrl[channel].rs_control,
 				(__u32)(readl(&ch_ctrl[channel].rs_control) &
 					~(C_RS_RTS | C_RS_DTR)));
-			retval = cyz_issue_cmd(&cy_card[info->card], channel,
+			retval = cyz_issue_cmd(info->card, channel,
 					C_CM_IOCTLM, 0L);
 			if (retval != 0) {
 				printk(KERN_ERR"cyc:shutdown retval on ttyC%d "
@@ -2318,7 +2316,7 @@ block_til_ready(struct tty_struct *tty, 
 	int retval;
 	void __iomem *base_addr;
 
-	cinfo = &cy_card[info->card];
+	cinfo = info->card;
 	channel = info->line - cinfo->first_line;
 
 	/*
@@ -2443,7 +2441,7 @@ block_til_ready(struct tty_struct *tty, 
 				cy_writel(&ch_ctrl[channel].rs_control,
 					readl(&ch_ctrl[channel].rs_control) |
 					C_RS_RTS | C_RS_DTR);
-				retval = cyz_issue_cmd(&cy_card[info->card],
+				retval = cyz_issue_cmd(info->card,
 					channel, C_CM_IOCTLM, 0L);
 				if (retval != 0) {
 					printk(KERN_ERR "cyc:block_til_ready "
@@ -2522,8 +2520,8 @@ static int cy_open(struct tty_struct *tt
 	   treat it as absent from the system.  This
 	   will make the user pay attention.
 	 */
-	if (IS_CYC_Z(cy_card[info->card])) {
-		struct cyclades_card *cinfo = &cy_card[info->card];
+	if (IS_CYC_Z(*info->card)) {
+		struct cyclades_card *cinfo = info->card;
 		struct FIRM_ID __iomem *firm_id = cinfo->base_addr + ID_ADDRESS;
 
 		if (!ISZLOADED(*cinfo)) {
@@ -2634,9 +2632,10 @@ static int cy_open(struct tty_struct *tt
  */
 static void cy_wait_until_sent(struct tty_struct *tty, int timeout)
 {
+	struct cyclades_card *card;
 	struct cyclades_port *info = tty->driver_data;
 	void __iomem *base_addr;
-	int card, chip, channel, index;
+	int chip, channel, index;
 	unsigned long orig_jiffies;
 	int char_time;
 
@@ -2679,13 +2678,12 @@ static void cy_wait_until_sent(struct tt
 		timeout, char_time, jiffies);
 #endif
 	card = info->card;
-	channel = (info->line) - (cy_card[card].first_line);
-	if (!IS_CYC_Z(cy_card[card])) {
+	channel = (info->line) - (card->first_line);
+	if (!IS_CYC_Z(*card)) {
 		chip = channel >> 2;
 		channel &= 0x03;
-		index = cy_card[card].bus_index;
-		base_addr =
-		    cy_card[card].base_addr + (cy_chip_offset[chip] << index);
+		index = card->bus_index;
+		base_addr = card->base_addr + (cy_chip_offset[chip] << index);
 		while (readb(base_addr + (CySRER << index)) & CyTxRdy) {
 #ifdef CY_DEBUG_WAIT_UNTIL_SENT
 			printk(KERN_DEBUG "Not clean (jiff=%lu)...", jiffies);
@@ -2771,10 +2769,10 @@ static void cy_close(struct tty_struct *
 	}
 	CY_LOCK(info, flags);
 
-	if (!IS_CYC_Z(cy_card[info->card])) {
-		int channel = info->line - cy_card[info->card].first_line;
-		int index = cy_card[info->card].bus_index;
-		void __iomem *base_addr = cy_card[info->card].base_addr +
+	if (!IS_CYC_Z(*info->card)) {
+		int channel = info->line - info->card->first_line;
+		int index = info->card->bus_index;
+		void __iomem *base_addr = info->card->base_addr +
 			(cy_chip_offset[channel >> 2] << index);
 		/* Stop accepting input */
 		channel &= 0x03;
@@ -2791,16 +2789,16 @@ static void cy_close(struct tty_struct *
 	} else {
 #ifdef Z_WAKE
 		/* Waiting for on-board buffers to be empty before closing the port */
-		void __iomem *base_addr = cy_card[info->card].base_addr;
+		void __iomem *base_addr = info->card->base_addr;
 		struct FIRM_ID __iomem *firm_id = base_addr + ID_ADDRESS;
 		struct ZFW_CTRL __iomem *zfw_ctrl =
 		    base_addr + (readl(&firm_id->zfwctrl_addr) & 0xfffff);
 		struct CH_CTRL __iomem *ch_ctrl = zfw_ctrl->ch_ctrl;
-		int channel = info->line - cy_card[info->card].first_line;
+		int channel = info->line - info->card->first_line;
 		int retval;
 
 		if (readl(&ch_ctrl[channel].flow_status) != C_FS_TXIDLE) {
-			retval = cyz_issue_cmd(&cy_card[info->card], channel,
+			retval = cyz_issue_cmd(info->card, channel,
 						C_CM_IOCTLW, 0L);
 			if (retval != 0) {
 				printk(KERN_DEBUG "cyc:cy_close retval on "
@@ -2982,14 +2980,15 @@ static int cy_write_room(struct tty_stru
 
 static int cy_chars_in_buffer(struct tty_struct *tty)
 {
+	struct cyclades_card *card;
 	struct cyclades_port *info = tty->driver_data;
-	int card, channel;
+	int channel;
 
 	if (serial_paranoia_check(info, tty->name, "cy_chars_in_buffer"))
 		return 0;
 
 	card = info->card;
-	channel = (info->line) - (cy_card[card].first_line);
+	channel = (info->line) - (card->first_line);
 
 #ifdef Z_EXT_CHARS_IN_BUFFER
 	if (!IS_CYC_Z(cy_card[card])) {
@@ -3008,8 +3007,8 @@ static int cy_chars_in_buffer(struct tty
 		int char_count;
 		__u32 tx_put, tx_get, tx_bufsize;
 
-		firm_id = cy_card[card].base_addr + ID_ADDRESS;
-		zfw_ctrl = cy_card[card].base_addr +
+		firm_id = card->base_addr + ID_ADDRESS;
+		zfw_ctrl = card->base_addr +
 			(readl(&firm_id->zfwctrl_addr) & 0xfffff);
 		ch_ctrl = &(zfw_ctrl->ch_ctrl[channel]);
 		buf_ctrl = &(zfw_ctrl->buf_ctrl[channel]);
@@ -3067,9 +3066,10 @@ static void cyy_baud_calc(struct cyclade
  */
 static void set_line_char(struct cyclades_port *info)
 {
+	struct cyclades_card *card;
 	unsigned long flags;
 	void __iomem *base_addr;
-	int card, chip, channel, index;
+	int chip, channel, index;
 	unsigned cflag, iflag;
 	unsigned short chip_number;
 	int baud, baud_rate = 0;
@@ -3099,12 +3099,12 @@ static void set_line_char(struct cyclade
 	}
 
 	card = info->card;
-	channel = (info->line) - (cy_card[card].first_line);
+	channel = info->line - card->first_line;
 	chip_number = channel / 4;
 
-	if (!IS_CYC_Z(cy_card[card])) {
+	if (!IS_CYC_Z(*card)) {
 
-		index = cy_card[card].bus_index;
+		index = card->bus_index;
 
 		/* baud rate */
 		baud = tty_get_baud_rate(info->tty);
@@ -3222,8 +3222,7 @@ static void set_line_char(struct cyclade
 
 		chip = channel >> 2;
 		channel &= 0x03;
-		base_addr = cy_card[card].base_addr +
-			(cy_chip_offset[chip] << index);
+		base_addr = card->base_addr + (cy_chip_offset[chip] << index);
 
 		CY_LOCK(info, flags);
 		cy_writeb(base_addr + (CyCAR << index), (u_char) channel);
@@ -3331,12 +3330,12 @@ static void set_line_char(struct cyclade
 		__u32 sw_flow;
 		int retval;
 
-		firm_id = cy_card[card].base_addr + ID_ADDRESS;
-		if (!ISZLOADED(cy_card[card])) {
+		firm_id = card->base_addr + ID_ADDRESS;
+		if (!ISZLOADED(*card)) {
 			return;
 		}
 
-		zfw_ctrl = cy_card[card].base_addr +
+		zfw_ctrl = card->base_addr +
 			(readl(&firm_id->zfwctrl_addr) & 0xfffff);
 		board_ctrl = &zfw_ctrl->board_ctrl;
 		ch_ctrl = &(zfw_ctrl->ch_ctrl[channel]);
@@ -3424,7 +3423,7 @@ static void set_line_char(struct cyclade
 		}
 		cy_writel(&ch_ctrl->sw_flow, sw_flow);
 
-		retval = cyz_issue_cmd(&cy_card[card], channel, C_CM_IOCTL, 0L);
+		retval = cyz_issue_cmd(card, channel, C_CM_IOCTL, 0L);
 		if (retval != 0) {
 			printk(KERN_ERR "cyc:set_line_char retval on ttyC%d "
 				"was %x\n", info->line, retval);
@@ -3451,7 +3450,7 @@ static void set_line_char(struct cyclade
 #endif
 		}
 
-		retval = cyz_issue_cmd(&cy_card[card], channel, C_CM_IOCTLM,0L);
+		retval = cyz_issue_cmd(card, channel, C_CM_IOCTLM,0L);
 		if (retval != 0) {
 			printk(KERN_ERR "cyc:set_line_char(2) retval on ttyC%d "
 				"was %x\n", info->line, retval);
@@ -3468,14 +3467,15 @@ get_serial_info(struct cyclades_port *in
 		struct serial_struct __user * retinfo)
 {
 	struct serial_struct tmp;
-	struct cyclades_card *cinfo = &cy_card[info->card];
+	struct cyclades_card *cinfo = info->card;
 
 	if (!retinfo)
 		return -EFAULT;
 	memset(&tmp, 0, sizeof(tmp));
 	tmp.type = info->type;
 	tmp.line = info->line;
-	tmp.port = info->card * 0x100 + info->line - cinfo->first_line;
+	tmp.port = (info->card - cy_card) * 0x100 + info->line -
+		cinfo->first_line;
 	tmp.irq = cinfo->irq;
 	tmp.flags = info->flags;
 	tmp.close_delay = info->close_delay;
@@ -3544,20 +3544,20 @@ check_and_exit:
  */
 static int get_lsr_info(struct cyclades_port *info, unsigned int __user * value)
 {
-	int card, chip, channel, index;
+	struct cyclades_card *card;
+	int chip, channel, index;
 	unsigned char status;
 	unsigned int result;
 	unsigned long flags;
 	void __iomem *base_addr;
 
 	card = info->card;
-	channel = (info->line) - (cy_card[card].first_line);
-	if (!IS_CYC_Z(cy_card[card])) {
+	channel = (info->line) - (card->first_line);
+	if (!IS_CYC_Z(*card)) {
 		chip = channel >> 2;
 		channel &= 0x03;
-		index = cy_card[card].bus_index;
-		base_addr =
-		    cy_card[card].base_addr + (cy_chip_offset[chip] << index);
+		index = card->bus_index;
+		base_addr = card->base_addr + (cy_chip_offset[chip] << index);
 
 		CY_LOCK(info, flags);
 		status = readb(base_addr + (CySRER << index)) &
@@ -3574,7 +3574,8 @@ static int get_lsr_info(struct cyclades_
 static int cy_tiocmget(struct tty_struct *tty, struct file *file)
 {
 	struct cyclades_port *info = tty->driver_data;
-	int card, chip, channel, index;
+	struct cyclades_card *card;
+	int chip, channel, index;
 	void __iomem *base_addr;
 	unsigned long flags;
 	unsigned char status;
@@ -3589,13 +3590,12 @@ static int cy_tiocmget(struct tty_struct
 		return -ENODEV;
 
 	card = info->card;
-	channel = (info->line) - (cy_card[card].first_line);
-	if (!IS_CYC_Z(cy_card[card])) {
+	channel = info->line - card->first_line;
+	if (!IS_CYC_Z(*card)) {
 		chip = channel >> 2;
 		channel &= 0x03;
-		index = cy_card[card].bus_index;
-		base_addr =
-		    cy_card[card].base_addr + (cy_chip_offset[chip] << index);
+		index = card->bus_index;
+		base_addr = card->base_addr + (cy_chip_offset[chip] << index);
 
 		CY_LOCK(info, flags);
 		cy_writeb(base_addr + (CyCAR << index), (u_char) channel);
@@ -3615,10 +3615,10 @@ static int cy_tiocmget(struct tty_struct
 			((status & CyDSR) ? TIOCM_DSR : 0) |
 			((status & CyCTS) ? TIOCM_CTS : 0);
 	} else {
-		base_addr = cy_card[card].base_addr;
-		firm_id = cy_card[card].base_addr + ID_ADDRESS;
-		if (ISZLOADED(cy_card[card])) {
-			zfw_ctrl = cy_card[card].base_addr +
+		base_addr = card->base_addr;
+		firm_id = card->base_addr + ID_ADDRESS;
+		if (ISZLOADED(*card)) {
+			zfw_ctrl = card->base_addr +
 				(readl(&firm_id->zfwctrl_addr) & 0xfffff);
 			board_ctrl = &zfw_ctrl->board_ctrl;
 			ch_ctrl = zfw_ctrl->ch_ctrl;
@@ -3643,7 +3643,8 @@ cy_tiocmset(struct tty_struct *tty, stru
 		unsigned int set, unsigned int clear)
 {
 	struct cyclades_port *info = tty->driver_data;
-	int card, chip, channel, index;
+	struct cyclades_card *card;
+	int chip, channel, index;
 	void __iomem *base_addr;
 	unsigned long flags;
 	struct FIRM_ID __iomem *firm_id;
@@ -3656,13 +3657,12 @@ cy_tiocmset(struct tty_struct *tty, stru
 		return -ENODEV;
 
 	card = info->card;
-	channel = (info->line) - (cy_card[card].first_line);
-	if (!IS_CYC_Z(cy_card[card])) {
+	channel = (info->line) - (card->first_line);
+	if (!IS_CYC_Z(*card)) {
 		chip = channel >> 2;
 		channel &= 0x03;
-		index = cy_card[card].bus_index;
-		base_addr =
-		    cy_card[card].base_addr + (cy_chip_offset[chip] << index);
+		index = card->bus_index;
+		base_addr = card->base_addr + (cy_chip_offset[chip] << index);
 
 		if (set & TIOCM_RTS) {
 			CY_LOCK(info, flags);
@@ -3730,11 +3730,11 @@ cy_tiocmset(struct tty_struct *tty, stru
 			CY_UNLOCK(info, flags);
 		}
 	} else {
-		base_addr = cy_card[card].base_addr;
+		base_addr = card->base_addr;
 
-		firm_id = cy_card[card].base_addr + ID_ADDRESS;
-		if (ISZLOADED(cy_card[card])) {
-			zfw_ctrl = cy_card[card].base_addr +
+		firm_id = card->base_addr + ID_ADDRESS;
+		if (ISZLOADED(*card)) {
+			zfw_ctrl = card->base_addr +
 				(readl(&firm_id->zfwctrl_addr) & 0xfffff);
 			board_ctrl = &zfw_ctrl->board_ctrl;
 			ch_ctrl = zfw_ctrl->ch_ctrl;
@@ -3779,7 +3779,7 @@ cy_tiocmset(struct tty_struct *tty, stru
 			return -ENODEV;
 		}
 		CY_LOCK(info, flags);
-		retval = cyz_issue_cmd(&cy_card[info->card],
+		retval = cyz_issue_cmd(info->card,
 					channel, C_CM_IOCTLM, 0L);
 		if (retval != 0) {
 			printk(KERN_ERR "cyc:set_modem_info retval on ttyC%d "
@@ -3802,7 +3802,7 @@ static void cy_break(struct tty_struct *
 		return;
 
 	CY_LOCK(info, flags);
-	if (!IS_CYC_Z(cy_card[info->card])) {
+	if (!IS_CYC_Z(*info->card)) {
 		/* Let the transmit ISR take care of this (since it
 		   requires stuffing characters into the output stream).
 		 */
@@ -3829,16 +3829,16 @@ static void cy_break(struct tty_struct *
 		int retval;
 
 		if (break_state == -1) {
-			retval = cyz_issue_cmd(&cy_card[info->card],
-				info->line - cy_card[info->card].first_line,
+			retval = cyz_issue_cmd(info->card,
+				info->line - info->card->first_line,
 				C_CM_SET_BREAK, 0L);
 			if (retval != 0) {
 				printk(KERN_ERR "cyc:cy_break (set) retval on "
 					"ttyC%d was %x\n", info->line, retval);
 			}
 		} else {
-			retval = cyz_issue_cmd(&cy_card[info->card],
-				info->line - cy_card[info->card].first_line,
+			retval = cyz_issue_cmd(info->card,
+				info->line - info->card->first_line,
 				C_CM_CLR_BREAK, 0L);
 			if (retval != 0) {
 				printk(KERN_DEBUG "cyc:cy_break (clr) retval "
@@ -3865,18 +3865,19 @@ get_mon_info(struct cyclades_port *info,
 
 static int set_threshold(struct cyclades_port *info, unsigned long value)
 {
+	struct cyclades_card *card;
 	void __iomem *base_addr;
-	int card, channel, chip, index;
+	int channel, chip, index;
 	unsigned long flags;
 
 	card = info->card;
-	channel = info->line - cy_card[card].first_line;
-	if (!IS_CYC_Z(cy_card[card])) {
+	channel = info->line - card->first_line;
+	if (!IS_CYC_Z(*card)) {
 		chip = channel >> 2;
 		channel &= 0x03;
-		index = cy_card[card].bus_index;
+		index = card->bus_index;
 		base_addr =
-		    cy_card[card].base_addr + (cy_chip_offset[chip] << index);
+		    card->base_addr + (cy_chip_offset[chip] << index);
 
 		info->cor3 &= ~CyREC_FIFO;
 		info->cor3 |= value & CyREC_FIFO;
@@ -3894,18 +3895,18 @@ static int set_threshold(struct cyclades
 static int
 get_threshold(struct cyclades_port *info, unsigned long __user * value)
 {
+	struct cyclades_card *card;
 	void __iomem *base_addr;
-	int card, channel, chip, index;
+	int channel, chip, index;
 	unsigned long tmp;
 
 	card = info->card;
-	channel = info->line - cy_card[card].first_line;
-	if (!IS_CYC_Z(cy_card[card])) {
+	channel = info->line - card->first_line;
+	if (!IS_CYC_Z(*card)) {
 		chip = channel >> 2;
 		channel &= 0x03;
-		index = cy_card[card].bus_index;
-		base_addr =
-		    cy_card[card].base_addr + (cy_chip_offset[chip] << index);
+		index = card->bus_index;
+		base_addr = card->base_addr + (cy_chip_offset[chip] << index);
 
 		tmp = readb(base_addr + (CyCOR3 << index)) & CyREC_FIFO;
 		return put_user(tmp, value);
@@ -3930,18 +3931,18 @@ get_default_threshold(struct cyclades_po
 
 static int set_timeout(struct cyclades_port *info, unsigned long value)
 {
+	struct cyclades_card *card;
 	void __iomem *base_addr;
-	int card, channel, chip, index;
+	int channel, chip, index;
 	unsigned long flags;
 
 	card = info->card;
-	channel = info->line - cy_card[card].first_line;
-	if (!IS_CYC_Z(cy_card[card])) {
+	channel = info->line - card->first_line;
+	if (!IS_CYC_Z(*card)) {
 		chip = channel >> 2;
 		channel &= 0x03;
-		index = cy_card[card].bus_index;
-		base_addr =
-		    cy_card[card].base_addr + (cy_chip_offset[chip] << index);
+		index = card->bus_index;
+		base_addr = card->base_addr + (cy_chip_offset[chip] << index);
 
 		CY_LOCK(info, flags);
 		cy_writeb(base_addr + (CyRTPR << index), value & 0xff);
@@ -3954,18 +3955,18 @@ static int set_timeout(struct cyclades_p
 
 static int get_timeout(struct cyclades_port *info, unsigned long __user * value)
 {
+	struct cyclades_card *card;
 	void __iomem *base_addr;
-	int card, channel, chip, index;
+	int channel, chip, index;
 	unsigned long tmp;
 
 	card = info->card;
-	channel = info->line - cy_card[card].first_line;
-	if (!IS_CYC_Z(cy_card[card])) {
+	channel = info->line - card->first_line;
+	if (!IS_CYC_Z(*card)) {
 		chip = channel >> 2;
 		channel &= 0x03;
-		index = cy_card[card].bus_index;
-		base_addr =
-		    cy_card[card].base_addr + (cy_chip_offset[chip] << index);
+		index = card->bus_index;
+		base_addr = card->base_addr + (cy_chip_offset[chip] << index);
 
 		tmp = readb(base_addr + (CyRTPR << index));
 		return put_user(tmp, value);
@@ -4218,7 +4219,8 @@ static void cy_set_termios(struct tty_st
 static void cy_send_xchar(struct tty_struct *tty, char ch)
 {
 	struct cyclades_port *info = tty->driver_data;
-	int card, channel;
+	struct cyclades_card *card;
+	int channel;
 
 	if (serial_paranoia_check(info, tty->name, "cy_send_xchar"))
 		return;
@@ -4229,15 +4231,13 @@ static void cy_send_xchar(struct tty_str
 		cy_start(tty);
 
 	card = info->card;
-	channel = info->line - cy_card[card].first_line;
+	channel = info->line - card->first_line;
 
-	if (IS_CYC_Z(cy_card[card])) {
+	if (IS_CYC_Z(*card)) {
 		if (ch == STOP_CHAR(tty))
-			cyz_issue_cmd(&cy_card[card], channel, C_CM_SENDXOFF,
-					0L);
+			cyz_issue_cmd(card, channel, C_CM_SENDXOFF, 0L);
 		else if (ch == START_CHAR(tty))
-			cyz_issue_cmd(&cy_card[card], channel, C_CM_SENDXON,
-					0L);
+			cyz_issue_cmd(card, channel, C_CM_SENDXON, 0L);
 	}
 }
 
@@ -4248,9 +4248,10 @@ static void cy_send_xchar(struct tty_str
 static void cy_throttle(struct tty_struct *tty)
 {
 	struct cyclades_port *info = tty->driver_data;
+	struct cyclades_card *card;
 	unsigned long flags;
 	void __iomem *base_addr;
-	int card, chip, channel, index;
+	int chip, channel, index;
 
 #ifdef CY_DEBUG_THROTTLE
 	char buf[64];
@@ -4266,19 +4267,19 @@ static void cy_throttle(struct tty_struc
 	card = info->card;
 
 	if (I_IXOFF(tty)) {
-		if (!IS_CYC_Z(cy_card[card]))
+		if (!IS_CYC_Z(*card))
 			cy_send_xchar(tty, STOP_CHAR(tty));
 		else
 			info->throttle = 1;
 	}
 
 	if (tty->termios->c_cflag & CRTSCTS) {
-		channel = info->line - cy_card[card].first_line;
-		if (!IS_CYC_Z(cy_card[card])) {
+		channel = info->line - card->first_line;
+		if (!IS_CYC_Z(*card)) {
 			chip = channel >> 2;
 			channel &= 0x03;
-			index = cy_card[card].bus_index;
-			base_addr = cy_card[card].base_addr +
+			index = card->bus_index;
+			base_addr = card->base_addr +
 				(cy_chip_offset[chip] << index);
 
 			CY_LOCK(info, flags);
@@ -4306,9 +4307,10 @@ static void cy_throttle(struct tty_struc
 static void cy_unthrottle(struct tty_struct *tty)
 {
 	struct cyclades_port *info = tty->driver_data;
+	struct cyclades_card *card;
 	unsigned long flags;
 	void __iomem *base_addr;
-	int card, chip, channel, index;
+	int chip, channel, index;
 
 #ifdef CY_DEBUG_THROTTLE
 	char buf[64];
@@ -4330,12 +4332,12 @@ static void cy_unthrottle(struct tty_str
 
 	if (tty->termios->c_cflag & CRTSCTS) {
 		card = info->card;
-		channel = info->line - cy_card[card].first_line;
-		if (!IS_CYC_Z(cy_card[card])) {
+		channel = info->line - card->first_line;
+		if (!IS_CYC_Z(*card)) {
 			chip = channel >> 2;
 			channel &= 0x03;
-			index = cy_card[card].bus_index;
-			base_addr = cy_card[card].base_addr +
+			index = card->bus_index;
+			base_addr = card->base_addr +
 				(cy_chip_offset[chip] << index);
 
 			CY_LOCK(info, flags);
@@ -4373,13 +4375,13 @@ static void cy_stop(struct tty_struct *t
 	if (serial_paranoia_check(info, tty->name, "cy_stop"))
 		return;
 
-	cinfo = &cy_card[info->card];
+	cinfo = info->card;
 	channel = info->line - cinfo->first_line;
 	if (!IS_CYC_Z(*cinfo)) {
 		index = cinfo->bus_index;
 		chip = channel >> 2;
 		channel &= 0x03;
-		base_addr = cy_card[info->card].base_addr +
+		base_addr = info->card->base_addr +
 			(cy_chip_offset[chip] << index);
 
 		CY_LOCK(info, flags);
@@ -4408,13 +4410,13 @@ static void cy_start(struct tty_struct *
 	if (serial_paranoia_check(info, tty->name, "cy_start"))
 		return;
 
-	cinfo = &cy_card[info->card];
+	cinfo = info->card;
 	channel = info->line - cinfo->first_line;
 	index = cinfo->bus_index;
 	if (!IS_CYC_Z(*cinfo)) {
 		chip = channel >> 2;
 		channel &= 0x03;
-		base_addr = cy_card[info->card].base_addr +
+		base_addr = info->card->base_addr +
 			(cy_chip_offset[chip] << index);
 
 		CY_LOCK(info, flags);
@@ -4430,7 +4432,8 @@ static void cy_start(struct tty_struct *
 static void cy_flush_buffer(struct tty_struct *tty)
 {
 	struct cyclades_port *info = tty->driver_data;
-	int card, channel, retval;
+	struct cyclades_card *card;
+	int channel, retval;
 	unsigned long flags;
 
 #ifdef CY_DEBUG_IO
@@ -4441,17 +4444,16 @@ static void cy_flush_buffer(struct tty_s
 		return;
 
 	card = info->card;
-	channel = (info->line) - (cy_card[card].first_line);
+	channel = info->line - card->first_line;
 
 	CY_LOCK(info, flags);
 	info->xmit_cnt = info->xmit_head = info->xmit_tail = 0;
 	CY_UNLOCK(info, flags);
 
-	if (IS_CYC_Z(cy_card[card])) {	/* If it is a Z card, flush the on-board
+	if (IS_CYC_Z(*card)) {	/* If it is a Z card, flush the on-board
 					   buffers as well */
 		CY_LOCK(info, flags);
-		retval =
-		    cyz_issue_cmd(&cy_card[card], channel, C_CM_FLUSH_TX, 0L);
+		retval = cyz_issue_cmd(card, channel, C_CM_FLUSH_TX, 0L);
 		if (retval != 0) {
 			printk(KERN_ERR "cyc: flush_buffer retval on ttyC%d "
 				"was %x\n", info->line, retval);
@@ -4496,8 +4498,7 @@ static void cy_hangup(struct tty_struct 
  * ---------------------------------------------------------------------
  */
 
-static void __devinit cy_init_card(struct cyclades_card *cinfo,
-		const unsigned int board)
+static void __devinit cy_init_card(struct cyclades_card *cinfo)
 {
 	struct cyclades_port *info;
 	u32 mailbox;
@@ -4524,7 +4525,7 @@ static void __devinit cy_init_card(struc
 		info = &cy_port[port];
 		memset(info, 0, sizeof(*info));
 		info->magic = CYCLADES_MAGIC;
-		info->card = board;
+		info->card = cinfo;
 		info->line = port;
 		info->flags = STD_COM_FLAGS;
 		info->closing_wait = CLOSING_WAIT_DELAY;
@@ -4763,7 +4764,7 @@ static int __init cy_detect_isa(void)
 		cy_card[j].bus_index = 0;
 		cy_card[j].first_line = cy_next_channel;
 		cy_card[j].num_chips = cy_isa_nchan / 4;
-		cy_init_card(&cy_card[j], j);
+		cy_init_card(&cy_card[j]);
 		nboard++;
 
 		printk(KERN_INFO "Cyclom-Y/ISA #%d: 0x%lx-0x%lx, IRQ%d found: "
@@ -4849,7 +4850,7 @@ static int __devinit cy_init_Ze(struct R
 	cy_card[j].bus_index = 1;
 	cy_card[j].first_line = cy_next_channel;
 	cy_card[j].num_chips = -1;
-	cy_init_card(&cy_card[j], j);
+	cy_init_card(&cy_card[j]);
 	pci_set_drvdata(pdev, &cy_card[j]);
 
 	dev_info(&pdev->dev, "Cyclades-Ze/PCI #%d found: %d channels starting "
@@ -4956,7 +4957,7 @@ static int __devinit cy_pci_probe(struct
 		cy_card[j].bus_index = 1;
 		cy_card[j].first_line = cy_next_channel;
 		cy_card[j].num_chips = cy_pci_nchan / 4;
-		cy_init_card(&cy_card[j], j);
+		cy_init_card(&cy_card[j]);
 		pci_set_drvdata(pdev, &cy_card[j]);
 
 		/* enable interrupts in the PCI interface */
@@ -5110,7 +5111,7 @@ static int __devinit cy_pci_probe(struct
 		cy_card[j].bus_index = 1;
 		cy_card[j].first_line = cy_next_channel;
 		cy_card[j].num_chips = -1;
-		cy_init_card(&cy_card[j], j);
+		cy_init_card(&cy_card[j]);
 		pci_set_drvdata(pdev, &cy_card[j]);
 
 		dev_info(&pdev->dev, "Cyclades-8Zo/PCI #%d found: %d channels "
diff -puN include/linux/cyclades.h~char-cyclades-make-info-card-a-pointer include/linux/cyclades.h
--- a/include/linux/cyclades.h~char-cyclades-make-info-card-a-pointer
+++ a/include/linux/cyclades.h
@@ -549,7 +549,7 @@ struct cyclades_icount {
 
 struct cyclades_port {
 	int                     magic;
-	int			card;
+	struct cyclades_card	*card;
 	int			line;
 	int			flags; 		/* defined in tty.h */
 	int                     type;		/* UART type */
_

Patches currently in -mm which might be from jirislaby@gmail.com are

serial-serial_core-use-pr_debug.patch
cinergyt2-fix-file-release-handler.patch
auerswald-fix-file-release-handler.patch
char-rocket-add-module_device_table.patch
char-cs5535_gpio-add-module_device_table.patch
drivers-char-use-__set_current_state.patch
misc-add-sensable-phantom-driver.patch
misc-add-sensable-phantom-driver-v3.patch
unify-queue_delayed_work-and-queue_delayed_work_on.patch
char-cyclades-remove-pause.patch
char-cyclades-cy_readx-writex-cleanup.patch
char-cyclades-timer-cleanup.patch
char-cyclades-remove-volatiles.patch
char-cyclades-remove-useless-casts.patch
char-cyclades-create-cy_init_ze.patch
char-cyclades-use-pci_iomap-unmap.patch
char-cyclades-init-ze-immediately.patch
char-cyclades-create-cy_pci_probe.patch
char-cyclades-move-card-entries-init-into-function.patch
char-cyclades-init-card-struct-immediately.patch
char-cyclades-remove-some-global-vars.patch
char-cyclades-cy_init-error-handling.patch
char-cyclades-tty_register_device-separately-for-each-device.patch
char-cyclades-clear-interrupts-before-releasing.patch
char-cyclades-allow-debug_shirq.patch
char-mxser-schedule-for-removal.patch
char-isicom-use-pr_debug.patch
char-cyclades-use-is_cyc_z-macro.patch
char-cyclades-switch-to-pci-probing.patch
char-cyclades-depends-on-pci-or-isa.patch
char-cyclades-unexport-struct-cyclades_card.patch
char-cyclades-remove-useless-fileds-from-cyclades_card.patch
char-cyclades-irq-is-int.patch
char-cyclades-printk-cleanups.patch
char-cyclades-mark-cyy_init_card-as-__devinit-not-__init.patch
char-cyclades-simplify-variables-initialization.patch
char-cyclades-get-rid-of-phys-addresses.patch
char-cyclades-make-info-card-a-pointer.patch
char-cyclades-remove-sleep_on.patch
char-cyclades-fix-blockmove.patch
char-cyclades-timers-cleanup.patch
char-cyclades-remove-unused-timestamps.patch
char-cyclades-remove-locking-macros.patch
char-cyclades-conditions-cleanup.patch
char-cyclades-fix-tty-device-unregister.patch
char-cyclades-dynamic-ports.patch
char-cyclades-probe-cleanup.patch
char-cyclades-copyright-and-version-changes.patch
shrink_slab-handle-bad-shrinkers.patch
