From: akpm@linux-foundation.org
Subject: [merged] char-cyclades-convert-macros-to-inlines.patch removed from -mm tree
Date: Wed, 29 Apr 2009 12:18:07 -0700
Message-ID: <200904291918.n3TJI7eG030956@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60263 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755239AbZD2TUh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 29 Apr 2009 15:20:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jirislaby@gmail.com, alan@lxorguk.ukuu.org.uk, khc@pm.waw.pl, mm-commits@vger.kernel.org


The patch titled
     char: cyclades, convert macros to inlines
has been removed from the -mm tree.  Its filename was
     char-cyclades-convert-macros-to-inlines.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: char: cyclades, convert macros to inlines
From: Jiri Slaby <jirislaby@gmail.com>

Remove ugly macros and add inlines instead of them.  This improves
readability and type checking a much.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Krzysztof Halasa <khc@pm.waw.pl>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/cyclades.c |  130 ++++++++++++++++++++------------------
 1 file changed, 71 insertions(+), 59 deletions(-)

diff -puN drivers/char/cyclades.c~char-cyclades-convert-macros-to-inlines drivers/char/cyclades.c
--- a/drivers/char/cyclades.c~char-cyclades-convert-macros-to-inlines
+++ a/drivers/char/cyclades.c
@@ -663,15 +663,6 @@
 static void cy_throttle(struct tty_struct *tty);
 static void cy_send_xchar(struct tty_struct *tty, char ch);
 
-#define IS_CYC_Z(card) ((card).num_chips == (unsigned int)-1)
-
-#define Z_FPGA_CHECK(card) \
-	((readl(&(card).ctl_addr.p9060->init_ctrl) & (1<<17)) != 0)
-
-#define ISZLOADED(card)	((ZO_V1 == (card).hw_ver || Z_FPGA_CHECK(card)) && \
-			(ZFIRM_ID == readl(&((struct FIRM_ID __iomem *) \
-			((card).base_addr+ID_ADDRESS))->signature)))
-
 #ifndef SERIAL_XMIT_SIZE
 #define	SERIAL_XMIT_SIZE	(min(PAGE_SIZE, 4096))
 #endif
@@ -684,8 +675,6 @@ static void cy_send_xchar(struct tty_str
 #define DRIVER_VERSION	0x02010203
 #define RAM_SIZE 0x80000
 
-#define Z_FPGA_LOADED(X)	((readl(&(X)->init_ctrl) & (1<<17)) != 0)
-
 enum zblock_type {
 	ZBLOCK_PRG = 0,
 	ZBLOCK_FPGA = 1
@@ -880,6 +869,29 @@ static void cyz_rx_restart(unsigned long
 static struct timer_list cyz_rx_full_timer[NR_PORTS];
 #endif				/* CONFIG_CYZ_INTR */
 
+static inline bool cy_is_Z(struct cyclades_card *card)
+{
+	return card->num_chips == (unsigned int)-1;
+}
+
+static inline bool __cyz_fpga_loaded(struct RUNTIME_9060 __iomem *ctl_addr)
+{
+	return readl(&ctl_addr->init_ctrl) & (1 << 17);
+}
+
+static inline bool cyz_fpga_loaded(struct cyclades_card *card)
+{
+	return __cyz_fpga_loaded(card->ctl_addr.p9060);
+}
+
+static inline bool cyz_is_loaded(struct cyclades_card *card)
+{
+	struct FIRM_ID __iomem *fw_id = card->base_addr + ID_ADDRESS;
+
+	return (card->hw_ver == ZO_V1 || cyz_fpga_loaded(card)) &&
+			readl(&fw_id->signature) == ZFIRM_ID;
+}
+
 static inline int serial_paranoia_check(struct cyclades_port *info,
 		char *name, const char *routine)
 {
@@ -1417,7 +1429,7 @@ cyz_issue_cmd(struct cyclades_card *cinf
 	unsigned int index;
 
 	firm_id = cinfo->base_addr + ID_ADDRESS;
-	if (!ISZLOADED(*cinfo))
+	if (!cyz_is_loaded(cinfo))
 		return -1;
 
 	zfw_ctrl = cinfo->base_addr + (readl(&firm_id->zfwctrl_addr) & 0xfffff);
@@ -1725,7 +1737,7 @@ static irqreturn_t cyz_interrupt(int irq
 {
 	struct cyclades_card *cinfo = dev_id;
 
-	if (unlikely(!ISZLOADED(*cinfo))) {
+	if (unlikely(!cyz_is_loaded(cinfo))) {
 #ifdef CY_DEBUG_INTERRUPTS
 		printk(KERN_DEBUG "cyz_interrupt: board not yet loaded "
 				"(IRQ%d).\n", irq);
@@ -1773,9 +1785,9 @@ static void cyz_poll(unsigned long arg)
 	for (card = 0; card < NR_CARDS; card++) {
 		cinfo = &cy_card[card];
 
-		if (!IS_CYC_Z(*cinfo))
+		if (!cy_is_Z(cinfo))
 			continue;
-		if (!ISZLOADED(*cinfo))
+		if (!cyz_is_loaded(cinfo))
 			continue;
 
 		firm_id = cinfo->base_addr + ID_ADDRESS;
@@ -1854,7 +1866,7 @@ static int startup(struct cyclades_port 
 
 	set_line_char(info);
 
-	if (!IS_CYC_Z(*card)) {
+	if (!cy_is_Z(card)) {
 		chip = channel >> 2;
 		channel &= 0x03;
 		index = card->bus_index;
@@ -1911,7 +1923,7 @@ static int startup(struct cyclades_port 
 		base_addr = card->base_addr;
 
 		firm_id = base_addr + ID_ADDRESS;
-		if (!ISZLOADED(*card))
+		if (!cyz_is_loaded(card))
 			return -ENODEV;
 
 		zfw_ctrl = card->base_addr +
@@ -2006,7 +2018,7 @@ static void start_xmit(struct cyclades_p
 
 	card = info->card;
 	channel = info->line - card->first_line;
-	if (!IS_CYC_Z(*card)) {
+	if (!cy_is_Z(card)) {
 		chip = channel >> 2;
 		channel &= 0x03;
 		index = card->bus_index;
@@ -2050,7 +2062,7 @@ static void shutdown(struct cyclades_por
 
 	card = info->card;
 	channel = info->line - card->first_line;
-	if (!IS_CYC_Z(*card)) {
+	if (!cy_is_Z(card)) {
 		chip = channel >> 2;
 		channel &= 0x03;
 		index = card->bus_index;
@@ -2106,7 +2118,7 @@ static void shutdown(struct cyclades_por
 #endif
 
 		firm_id = base_addr + ID_ADDRESS;
-		if (!ISZLOADED(*card))
+		if (!cyz_is_loaded(card))
 			return;
 
 		zfw_ctrl = card->base_addr +
@@ -2213,7 +2225,7 @@ block_til_ready(struct tty_struct *tty, 
 #endif
 	info->port.blocked_open++;
 
-	if (!IS_CYC_Z(*cinfo)) {
+	if (!cy_is_Z(cinfo)) {
 		chip = channel >> 2;
 		channel &= 0x03;
 		index = cinfo->bus_index;
@@ -2276,7 +2288,7 @@ block_til_ready(struct tty_struct *tty, 
 
 		base_addr = cinfo->base_addr;
 		firm_id = base_addr + ID_ADDRESS;
-		if (!ISZLOADED(*cinfo)) {
+		if (!cyz_is_loaded(cinfo)) {
 			__set_current_state(TASK_RUNNING);
 			remove_wait_queue(&info->port.open_wait, &wait);
 			return -EINVAL;
@@ -2377,12 +2389,12 @@ static int cy_open(struct tty_struct *tt
 	   treat it as absent from the system.  This
 	   will make the user pay attention.
 	 */
-	if (IS_CYC_Z(*info->card)) {
+	if (cy_is_Z(info->card)) {
 		struct cyclades_card *cinfo = info->card;
 		struct FIRM_ID __iomem *firm_id = cinfo->base_addr + ID_ADDRESS;
 
-		if (!ISZLOADED(*cinfo)) {
-			if (cinfo->hw_ver == ZE_V1 && Z_FPGA_CHECK(*cinfo) &&
+		if (!cyz_is_loaded(cinfo)) {
+			if (cinfo->hw_ver == ZE_V1 && cyz_fpga_loaded(cinfo) &&
 					readl(&firm_id->signature) ==
 					ZFIRM_HLT) {
 				printk(KERN_ERR "cyc:Cyclades-Z Error: you "
@@ -2537,7 +2549,7 @@ static void cy_wait_until_sent(struct tt
 #endif
 	card = info->card;
 	channel = (info->line) - (card->first_line);
-	if (!IS_CYC_Z(*card)) {
+	if (!cy_is_Z(card)) {
 		chip = channel >> 2;
 		channel &= 0x03;
 		index = card->bus_index;
@@ -2582,7 +2594,7 @@ static void cy_flush_buffer(struct tty_s
 	info->xmit_cnt = info->xmit_head = info->xmit_tail = 0;
 	spin_unlock_irqrestore(&card->card_lock, flags);
 
-	if (IS_CYC_Z(*card)) {	/* If it is a Z card, flush the on-board
+	if (cy_is_Z(card)) {	/* If it is a Z card, flush the on-board
 					   buffers as well */
 		spin_lock_irqsave(&card->card_lock, flags);
 		retval = cyz_issue_cmd(card, channel, C_CM_FLUSH_TX, 0L);
@@ -2663,7 +2675,7 @@ static void cy_close(struct tty_struct *
 
 	spin_lock_irqsave(&card->card_lock, flags);
 
-	if (!IS_CYC_Z(*card)) {
+	if (!cy_is_Z(card)) {
 		int channel = info->line - card->first_line;
 		int index = card->bus_index;
 		void __iomem *base_addr = card->base_addr +
@@ -2883,7 +2895,7 @@ static int cy_chars_in_buffer(struct tty
 	channel = (info->line) - (card->first_line);
 
 #ifdef Z_EXT_CHARS_IN_BUFFER
-	if (!IS_CYC_Z(cy_card[card])) {
+	if (!cy_is_Z(card)) {
 #endif				/* Z_EXT_CHARS_IN_BUFFER */
 #ifdef CY_DEBUG_IO
 		printk(KERN_DEBUG "cyc:cy_chars_in_buffer ttyC%d %d\n",
@@ -2996,7 +3008,7 @@ static void set_line_char(struct cyclade
 	channel = info->line - card->first_line;
 	chip_number = channel / 4;
 
-	if (!IS_CYC_Z(*card)) {
+	if (!cy_is_Z(card)) {
 
 		index = card->bus_index;
 
@@ -3221,7 +3233,7 @@ static void set_line_char(struct cyclade
 		int retval;
 
 		firm_id = card->base_addr + ID_ADDRESS;
-		if (!ISZLOADED(*card))
+		if (!cyz_is_loaded(card))
 			return;
 
 		zfw_ctrl = card->base_addr +
@@ -3438,7 +3450,7 @@ static int get_lsr_info(struct cyclades_
 
 	card = info->card;
 	channel = (info->line) - (card->first_line);
-	if (!IS_CYC_Z(*card)) {
+	if (!cy_is_Z(card)) {
 		chip = channel >> 2;
 		channel &= 0x03;
 		index = card->bus_index;
@@ -3478,7 +3490,7 @@ static int cy_tiocmget(struct tty_struct
 
 	card = info->card;
 	channel = info->line - card->first_line;
-	if (!IS_CYC_Z(*card)) {
+	if (!cy_is_Z(card)) {
 		chip = channel >> 2;
 		channel &= 0x03;
 		index = card->bus_index;
@@ -3504,7 +3516,7 @@ static int cy_tiocmget(struct tty_struct
 	} else {
 		base_addr = card->base_addr;
 		firm_id = card->base_addr + ID_ADDRESS;
-		if (ISZLOADED(*card)) {
+		if (cyz_is_loaded(card)) {
 			zfw_ctrl = card->base_addr +
 				(readl(&firm_id->zfwctrl_addr) & 0xfffff);
 			board_ctrl = &zfw_ctrl->board_ctrl;
@@ -3547,7 +3559,7 @@ cy_tiocmset(struct tty_struct *tty, stru
 
 	card = info->card;
 	channel = (info->line) - (card->first_line);
-	if (!IS_CYC_Z(*card)) {
+	if (!cy_is_Z(card)) {
 		chip = channel >> 2;
 		channel &= 0x03;
 		index = card->bus_index;
@@ -3622,7 +3634,7 @@ cy_tiocmset(struct tty_struct *tty, stru
 		base_addr = card->base_addr;
 
 		firm_id = card->base_addr + ID_ADDRESS;
-		if (ISZLOADED(*card)) {
+		if (cyz_is_loaded(card)) {
 			zfw_ctrl = card->base_addr +
 				(readl(&firm_id->zfwctrl_addr) & 0xfffff);
 			board_ctrl = &zfw_ctrl->board_ctrl;
@@ -3694,7 +3706,7 @@ static int cy_break(struct tty_struct *t
 	card = info->card;
 
 	spin_lock_irqsave(&card->card_lock, flags);
-	if (!IS_CYC_Z(*card)) {
+	if (!cy_is_Z(card)) {
 		/* Let the transmit ISR take care of this (since it
 		   requires stuffing characters into the output stream).
 		 */
@@ -3763,7 +3775,7 @@ static int set_threshold(struct cyclades
 
 	card = info->card;
 	channel = info->line - card->first_line;
-	if (!IS_CYC_Z(*card)) {
+	if (!cy_is_Z(card)) {
 		chip = channel >> 2;
 		channel &= 0x03;
 		index = card->bus_index;
@@ -3791,7 +3803,7 @@ static int get_threshold(struct cyclades
 
 	card = info->card;
 	channel = info->line - card->first_line;
-	if (!IS_CYC_Z(*card)) {
+	if (!cy_is_Z(card)) {
 		chip = channel >> 2;
 		channel &= 0x03;
 		index = card->bus_index;
@@ -3825,7 +3837,7 @@ static int set_timeout(struct cyclades_p
 
 	card = info->card;
 	channel = info->line - card->first_line;
-	if (!IS_CYC_Z(*card)) {
+	if (!cy_is_Z(card)) {
 		chip = channel >> 2;
 		channel &= 0x03;
 		index = card->bus_index;
@@ -3848,7 +3860,7 @@ static int get_timeout(struct cyclades_p
 
 	card = info->card;
 	channel = info->line - card->first_line;
-	if (!IS_CYC_Z(*card)) {
+	if (!cy_is_Z(card)) {
 		chip = channel >> 2;
 		channel &= 0x03;
 		index = card->bus_index;
@@ -4102,7 +4114,7 @@ static void cy_send_xchar(struct tty_str
 	card = info->card;
 	channel = info->line - card->first_line;
 
-	if (IS_CYC_Z(*card)) {
+	if (cy_is_Z(card)) {
 		if (ch == STOP_CHAR(tty))
 			cyz_issue_cmd(card, channel, C_CM_SENDXOFF, 0L);
 		else if (ch == START_CHAR(tty))
@@ -4135,7 +4147,7 @@ static void cy_throttle(struct tty_struc
 	card = info->card;
 
 	if (I_IXOFF(tty)) {
-		if (!IS_CYC_Z(*card))
+		if (!cy_is_Z(card))
 			cy_send_xchar(tty, STOP_CHAR(tty));
 		else
 			info->throttle = 1;
@@ -4143,7 +4155,7 @@ static void cy_throttle(struct tty_struc
 
 	if (tty->termios->c_cflag & CRTSCTS) {
 		channel = info->line - card->first_line;
-		if (!IS_CYC_Z(*card)) {
+		if (!cy_is_Z(card)) {
 			chip = channel >> 2;
 			channel &= 0x03;
 			index = card->bus_index;
@@ -4200,7 +4212,7 @@ static void cy_unthrottle(struct tty_str
 	if (tty->termios->c_cflag & CRTSCTS) {
 		card = info->card;
 		channel = info->line - card->first_line;
-		if (!IS_CYC_Z(*card)) {
+		if (!cy_is_Z(card)) {
 			chip = channel >> 2;
 			channel &= 0x03;
 			index = card->bus_index;
@@ -4244,7 +4256,7 @@ static void cy_stop(struct tty_struct *t
 
 	cinfo = info->card;
 	channel = info->line - cinfo->first_line;
-	if (!IS_CYC_Z(*cinfo)) {
+	if (!cy_is_Z(cinfo)) {
 		index = cinfo->bus_index;
 		chip = channel >> 2;
 		channel &= 0x03;
@@ -4277,7 +4289,7 @@ static void cy_start(struct tty_struct *
 	cinfo = info->card;
 	channel = info->line - cinfo->first_line;
 	index = cinfo->bus_index;
-	if (!IS_CYC_Z(*cinfo)) {
+	if (!cy_is_Z(cinfo)) {
 		chip = channel >> 2;
 		channel &= 0x03;
 		base_addr = cinfo->base_addr + (cy_chip_offset[chip] << index);
@@ -4334,7 +4346,7 @@ static int __devinit cy_init_card(struct
 
 	spin_lock_init(&cinfo->card_lock);
 
-	if (IS_CYC_Z(*cinfo)) {	/* Cyclades-Z */
+	if (cy_is_Z(cinfo)) {	/* Cyclades-Z */
 		nports = (cinfo->hw_ver == ZE_V1) ? ZE_V1_NPORTS : 8;
 		cinfo->intr_enabled = 0;
 		cinfo->nports = 0;	/* Will be correctly set later, after
@@ -4365,7 +4377,7 @@ static int __devinit cy_init_card(struct
 		init_completion(&info->shutdown_wait);
 		init_waitqueue_head(&info->delta_msr_wait);
 
-		if (IS_CYC_Z(*cinfo)) {
+		if (cy_is_Z(cinfo)) {
 			info->type = PORT_STARTECH;
 			if (cinfo->hw_ver == ZO_V1)
 				info->xmit_fifo_size = CYZ_FIFO_SIZE;
@@ -4408,7 +4420,7 @@ static int __devinit cy_init_card(struct
 	}
 
 #ifndef CONFIG_CYZ_INTR
-	if (IS_CYC_Z(*cinfo) && !timer_pending(&cyz_timerlist)) {
+	if (cy_is_Z(cinfo) && !timer_pending(&cyz_timerlist)) {
 		mod_timer(&cyz_timerlist, jiffies + 1);
 #ifdef CY_PCI_DEBUG
 		printk(KERN_DEBUG "Cyclades-Z polling initialized\n");
@@ -4771,7 +4783,7 @@ static int __devinit cyz_load_fw(struct 
 
 	/* Check whether the firmware is already loaded and running. If
 	   positive, skip this board */
-	if (Z_FPGA_LOADED(ctl_addr) && readl(&fid->signature) == ZFIRM_ID) {
+	if (__cyz_fpga_loaded(ctl_addr) && readl(&fid->signature) == ZFIRM_ID) {
 		u32 cntval = readl(base_addr + 0x190);
 
 		udelay(100);
@@ -4790,7 +4802,7 @@ static int __devinit cyz_load_fw(struct 
 
 	mailbox = readl(&ctl_addr->mail_box_0);
 
-	if (mailbox == 0 || Z_FPGA_LOADED(ctl_addr)) {
+	if (mailbox == 0 || __cyz_fpga_loaded(ctl_addr)) {
 		/* stops CPU and set window to beginning of RAM */
 		cy_writel(&ctl_addr->loc_addr_base, WIN_CREG);
 		cy_writel(&cust->cpu_stop, 0);
@@ -4806,7 +4818,7 @@ static int __devinit cyz_load_fw(struct 
 				base_addr);
 		if (retval)
 			goto err_rel;
-		if (!Z_FPGA_LOADED(ctl_addr)) {
+		if (!__cyz_fpga_loaded(ctl_addr)) {
 			dev_err(&pdev->dev, "fw upload successful, but fw is "
 					"not loaded\n");
 			goto err_rel;
@@ -4865,7 +4877,7 @@ static int __devinit cyz_load_fw(struct 
 				"system before loading the new FW to the "
 				"Cyclades-Z.\n");
 
-			if (Z_FPGA_LOADED(ctl_addr))
+			if (__cyz_fpga_loaded(ctl_addr))
 				plx_init(pdev, irq, ctl_addr);
 
 			retval = -EIO;
@@ -4889,7 +4901,7 @@ static int __devinit cyz_load_fw(struct 
 			"check the connection between the Z host card and the "
 			"serial expanders.\n");
 
-		if (Z_FPGA_LOADED(ctl_addr))
+		if (__cyz_fpga_loaded(ctl_addr))
 			plx_init(pdev, irq, ctl_addr);
 
 		dev_info(&pdev->dev, "Null number of ports detected. Board "
@@ -5156,12 +5168,12 @@ static void __devexit cy_pci_remove(stru
 	unsigned int i;
 
 	/* non-Z with old PLX */
-	if (!IS_CYC_Z(*cinfo) && (readb(cinfo->base_addr + CyPLX_VER) & 0x0f) ==
+	if (!cy_is_Z(cinfo) && (readb(cinfo->base_addr + CyPLX_VER) & 0x0f) ==
 			PLX_9050)
 		cy_writeb(cinfo->ctl_addr.p9050 + 0x4c, 0);
 	else
 #ifndef CONFIG_CYZ_INTR
-		if (!IS_CYC_Z(*cinfo))
+		if (!cy_is_Z(cinfo))
 #endif
 		cy_writew(&cinfo->ctl_addr.p9060->intr_ctrl_stat,
 			readw(&cinfo->ctl_addr.p9060->intr_ctrl_stat) &
@@ -5172,7 +5184,7 @@ static void __devexit cy_pci_remove(stru
 		iounmap(cinfo->ctl_addr.p9050);
 	if (cinfo->irq
 #ifndef CONFIG_CYZ_INTR
-		&& !IS_CYC_Z(*cinfo)
+		&& !cy_is_Z(cinfo)
 #endif /* CONFIG_CYZ_INTR */
 		)
 		free_irq(cinfo->irq, cinfo);
@@ -5368,7 +5380,7 @@ static void __exit cy_cleanup_module(voi
 				iounmap(card->ctl_addr.p9050);
 			if (card->irq
 #ifndef CONFIG_CYZ_INTR
-				&& !IS_CYC_Z(*card)
+				&& !cy_is_Z(card)
 #endif /* CONFIG_CYZ_INTR */
 				)
 				free_irq(card->irq, card);
_

Patches currently in -mm which might be from jirislaby@gmail.com are

linux-next.patch
icom-converting-space-to-tabs.patch
char-isicom-fix-build-warning.patch
reiser4.patch
shrink_slab-handle-bad-shrinkers.patch

