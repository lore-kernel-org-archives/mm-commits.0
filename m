From: akpm@linux-foundation.org
Subject: - char-cyclades-fix-some-w-warnings.patch removed from -mm tree
Date: Tue, 31 Jul 2007 01:25:11 -0700
Message-ID: <200707310829.l6V8Tsv8024203@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40317 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750908AbXGaIaD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 31 Jul 2007 04:30:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jirislaby@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Char: cyclades, fix some -W warnings
has been removed from the -mm tree.  Its filename was
     char-cyclades-fix-some-w-warnings.patch

This patch was dropped because it had testing failures

------------------------------------------------------
Subject: Char: cyclades, fix some -W warnings
From: Jiri Slaby <jirislaby@gmail.com>

Most of them are signedness, the rest unused function parameters.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/cyclades.c  |   84 ++++++++++++++++---------------------
 include/linux/cyclades.h |   12 ++---
 2 files changed, 43 insertions(+), 53 deletions(-)

diff -puN drivers/char/cyclades.c~char-cyclades-fix-some-w-warnings drivers/char/cyclades.c
--- a/drivers/char/cyclades.c~char-cyclades-fix-some-w-warnings
+++ a/drivers/char/cyclades.c
@@ -662,7 +662,7 @@
 static void cy_throttle(struct tty_struct *tty);
 static void cy_send_xchar(struct tty_struct *tty, char ch);
 
-#define IS_CYC_Z(card) ((card).num_chips == -1)
+#define IS_CYC_Z(card) ((card).num_chips == (unsigned int)-1)
 
 #define Z_FPGA_CHECK(card) \
 	((readl(&((struct RUNTIME_9060 __iomem *) \
@@ -985,25 +985,23 @@ static void cyy_chip_rx(struct cyclades_
 {
 	struct cyclades_port *info;
 	struct tty_struct *tty;
-	int char_count;
-	int j, len, index = cinfo->bus_index;
-	int save_xir, channel, save_car;
-	char data;
+	int len, index = cinfo->bus_index;
+	u8 save_xir, channel, save_car, data, char_count;
 
 #ifdef CY_DEBUG_INTERRUPTS
 	printk(KERN_DEBUG "cyy_interrupt: rcvd intr, chip %d\n", chip);
 #endif
 	/* determine the channel & change to that context */
-	save_xir = (u_char) readb(base_addr + (CyRIR << index));
-	channel = (u_short) (save_xir & CyIRChannel);
+	save_xir = readb(base_addr + (CyRIR << index));
+	channel = save_xir & CyIRChannel;
 	info = &cinfo->ports[channel + chip * 4];
 	save_car = readb(base_addr + (CyCAR << index));
 	cy_writeb(base_addr + (CyCAR << index), save_xir);
 
 	/* if there is nowhere to put the data, discard it */
 	if (info->tty == NULL) {
-		j = (readb(base_addr + (CyRIVR << index)) & CyIVRMask);
-		if (j == CyIVRRxEx) {	/* exception */
+		if ((readb(base_addr + (CyRIVR << index)) & CyIVRMask) ==
+				CyIVRRxEx) {	/* exception */
 			data = readb(base_addr + (CyRDSR << index));
 		} else {	/* normal character reception */
 			char_count = readb(base_addr + (CyRDCR << index));
@@ -1014,8 +1012,8 @@ static void cyy_chip_rx(struct cyclades_
 	}
 	/* there is an open port for this data */
 	tty = info->tty;
-	j = readb(base_addr + (CyRIVR << index)) & CyIVRMask;
-	if (j == CyIVRRxEx) {	/* exception */
+	if ((readb(base_addr + (CyRIVR << index)) & CyIVRMask) ==
+			CyIVRRxEx) {	/* exception */
 		data = readb(base_addr + (CyRDSR << index));
 
 		/* For statistics only */
@@ -1116,13 +1114,12 @@ end:
 	cy_writeb(base_addr + (CyCAR << index), save_car);
 }
 
-static void cyy_chip_tx(struct cyclades_card *cinfo, int chip,
+static void cyy_chip_tx(struct cyclades_card *cinfo, unsigned int chip,
 		void __iomem *base_addr)
 {
 	struct cyclades_port *info;
-	int char_count;
-	int outch;
-	int save_xir, channel, save_car, index = cinfo->bus_index;
+	int char_count, index = cinfo->bus_index;
+	u8 save_xir, channel, save_car, outch;
 
 	/* Since we only get here when the transmit buffer
 	   is empty, we know we can always stuff a dozen
@@ -1132,8 +1129,8 @@ static void cyy_chip_tx(struct cyclades_
 #endif
 
 	/* determine the channel & change to that context */
-	save_xir = (u_char) readb(base_addr + (CyTIR << index));
-	channel = (u_short) (save_xir & CyIRChannel);
+	save_xir = readb(base_addr + (CyTIR << index));
+	channel = save_xir & CyIRChannel;
 	save_car = readb(base_addr + (CyCAR << index));
 	cy_writeb(base_addr + (CyCAR << index), save_xir);
 
@@ -1242,12 +1239,12 @@ static void cyy_chip_modem(struct cyclad
 		void __iomem *base_addr)
 {
 	struct cyclades_port *info;
-	int mdm_change, mdm_status;
-	int save_xir, channel, save_car, index = cinfo->bus_index;
+	int index = cinfo->bus_index;
+	u8 save_xir, channel, save_car, mdm_change, mdm_status;
 
 	/* determine the channel & change to that context */
-	save_xir = (u_char) readb(base_addr + (CyMIR << index));
-	channel = (u_short) (save_xir & CyIRChannel);
+	save_xir = readb(base_addr + (CyMIR << index));
+	channel = save_xir & CyIRChannel;
 	info = &cinfo->ports[channel + chip * 4];
 	save_car = readb(base_addr + (CyCAR << index));
 	cy_writeb(base_addr + (CyCAR << index), save_xir);
@@ -1320,10 +1317,8 @@ static irqreturn_t cyy_interrupt(int irq
 	int status;
 	struct cyclades_card *cinfo = dev_id;
 	void __iomem *base_addr, *card_base_addr;
-	int chip;
+	unsigned int chip, too_many, had_work;
 	int index;
-	int too_many;
-	int had_work;
 
 	if (unlikely(cinfo == NULL)) {
 #ifdef CY_DEBUG_INTERRUPTS
@@ -1422,7 +1417,7 @@ cyz_issue_cmd(struct cyclades_card *cinf
 	struct ZFW_CTRL __iomem *zfw_ctrl;
 	struct BOARD_CTRL __iomem *board_ctrl;
 	__u32 __iomem *pci_doorbell;
-	int index;
+	unsigned int index;
 
 	firm_id = cinfo->base_addr + ID_ADDRESS;
 	if (!ISZLOADED(*cinfo)) {
@@ -1447,13 +1442,12 @@ cyz_issue_cmd(struct cyclades_card *cinf
 	return 0;
 }				/* cyz_issue_cmd */
 
-static void
-cyz_handle_rx(struct cyclades_port *info, struct CH_CTRL __iomem *ch_ctrl,
+static void cyz_handle_rx(struct cyclades_port *info,
 		struct BUF_CTRL __iomem *buf_ctrl)
 {
 	struct cyclades_card *cinfo = info->card;
 	struct tty_struct *tty = info->tty;
-	int char_count;
+	unsigned int char_count;
 	int len;
 #ifdef BLOCKMOVE
 	unsigned char *buf;
@@ -1526,7 +1520,7 @@ cyz_handle_rx(struct cyclades_port *info
 				char_count = rx_put - rx_get;
 			else
 				char_count = rx_put - rx_get + rx_bufsize;
-			if (char_count >= (int)readl(&buf_ctrl->rx_threshold) &&
+			if (char_count >= readl(&buf_ctrl->rx_threshold) &&
 					!timer_pending(&cyz_rx_full_timer[
 							info->line]))
 				mod_timer(&cyz_rx_full_timer[info->line],
@@ -1540,14 +1534,13 @@ cyz_handle_rx(struct cyclades_port *info
 	}
 }
 
-static void
-cyz_handle_tx(struct cyclades_port *info, struct CH_CTRL __iomem *ch_ctrl,
+static void cyz_handle_tx(struct cyclades_port *info,
 		struct BUF_CTRL __iomem *buf_ctrl)
 {
 	struct cyclades_card *cinfo = info->card;
 	struct tty_struct *tty = info->tty;
-	char data;
-	int char_count;
+	u8 data;
+	unsigned int char_count;
 #ifdef BLOCKMOVE
 	int small_count;
 #endif
@@ -1787,10 +1780,9 @@ static void cyz_poll(unsigned long arg)
 	struct FIRM_ID __iomem *firm_id;
 	struct ZFW_CTRL __iomem *zfw_ctrl;
 	struct BOARD_CTRL __iomem *board_ctrl;
-	struct CH_CTRL __iomem *ch_ctrl;
 	struct BUF_CTRL __iomem *buf_ctrl;
 	unsigned long expires = jiffies + HZ;
-	int card, port;
+	unsigned int port, card;
 
 	for (card = 0; card < NR_CARDS; card++) {
 		cinfo = &cy_card[card];
@@ -1817,12 +1809,11 @@ static void cyz_poll(unsigned long arg)
 		for (port = 0; port < cinfo->nports; port++) {
 			info = &cinfo->ports[port];
 			tty = info->tty;
-			ch_ctrl = &(zfw_ctrl->ch_ctrl[port]);
 			buf_ctrl = &(zfw_ctrl->buf_ctrl[port]);
 
 			if (!info->throttle)
-				cyz_handle_rx(info, ch_ctrl, buf_ctrl);
-			cyz_handle_tx(info, ch_ctrl, buf_ctrl);
+				cyz_handle_rx(info, buf_ctrl);
+			cyz_handle_tx(info, buf_ctrl);
 		}
 		/* poll every 'cyz_polling_cycle' period */
 		expires = jiffies + cyz_polling_cycle;
@@ -2385,11 +2376,11 @@ block_til_ready(struct tty_struct *tty, 
 static int cy_open(struct tty_struct *tty, struct file *filp)
 {
 	struct cyclades_port *info;
-	unsigned int i;
-	int retval, line;
+	unsigned int i, line;
+	int retval;
 
 	line = tty->index;
-	if ((line < 0) || (NR_PORTS <= line)) {
+	if ((tty->index < 0) || (NR_PORTS <= line)) {
 		return -ENODEV;
 	}
 	for (i = 0; i < NR_CARDS; i++)
@@ -4359,9 +4350,9 @@ static int __devinit cy_init_card(struct
 {
 	struct cyclades_port *info;
 	u32 uninitialized_var(mailbox);
-	unsigned int nports;
+	unsigned int nports, port;
 	unsigned short chip_number;
-	int uninitialized_var(index), port;
+	int uninitialized_var(index);
 
 	spin_lock_init(&cinfo->card_lock);
 
@@ -5127,7 +5118,7 @@ static int __devinit cy_pci_probe(struct
 			}
 		}
 #endif				/* CONFIG_CYZ_INTR */
-		cy_card[card_no].num_chips = -1;
+		cy_card[card_no].num_chips = (unsigned int)-1;
 	}
 
 	/* set cy_card */
@@ -5387,7 +5378,7 @@ err:
 static void __exit cy_cleanup_module(void)
 {
 	struct cyclades_card *card;
-	int i, e1;
+	unsigned int i, e1;
 
 #ifndef CONFIG_CYZ_INTR
 	del_timer_sync(&cyz_timerlist);
@@ -5415,8 +5406,7 @@ static void __exit cy_cleanup_module(voi
 #endif /* CONFIG_CYZ_INTR */
 				)
 				free_irq(card->irq, card);
-			for (e1 = card->first_line;
-					e1 < card->first_line +
+			for (e1 = card->first_line; e1 < card->first_line +
 					card->nports; e1++)
 				tty_unregister_device(cy_serial_driver, e1);
 			kfree(card->ports);
diff -puN include/linux/cyclades.h~char-cyclades-fix-some-w-warnings include/linux/cyclades.h
--- a/include/linux/cyclades.h~char-cyclades-fix-some-w-warnings
+++ a/include/linux/cyclades.h
@@ -512,11 +512,11 @@ struct cyclades_card {
     void __iomem *base_addr;
     void __iomem *ctl_addr;
     int irq;
-    int num_chips;	/* 0 if card absent, -1 if Z/PCI, else Y */
-    int first_line;	/* minor number of first channel on card */
-    int nports;		/* Number of ports in the card */
-    int bus_index;	/* address shift - 0 for ISA, 1 for PCI */
-    int	intr_enabled;	/* FW Interrupt flag - 0 disabled, 1 enabled */
+    unsigned int num_chips;	/* 0 if card absent, -1 if Z/PCI, else Y */
+    unsigned int first_line;	/* minor number of first channel on card */
+    unsigned int nports;	/* Number of ports in the card */
+    int bus_index;		/* address shift - 0 for ISA, 1 for PCI */
+    int intr_enabled;		/* FW Interrupt flag - 0 disabled, 1 enabled */
     spinlock_t card_lock;
     struct cyclades_port *ports;
 };
@@ -566,7 +566,7 @@ struct cyclades_port {
 	int			rtsdtr_inv;
 	int			chip_rev;
 	int			custom_divisor;
-	int                     x_char; /* to be pushed out ASAP */
+	u8			x_char; /* to be pushed out ASAP */
 	int			close_delay;
 	unsigned short		closing_wait;
 	int			count;	/* # of fd on device */
_

Patches currently in -mm which might be from jirislaby@gmail.com are

origin.patch
epcac-reformat-comments-and-coding-style-improvements.patch
char-moxa-fix-and-optimise-empty-timer.patch
char-cyclades-remove-bottom-half-processing.patch
char-cyclades-make-the-isr-code-readable.patch
char-cyclades-move-spin_lock-to-one-place.patch
char-cyclades-fix-some-w-warnings.patch
shrink_slab-handle-bad-shrinkers.patch
