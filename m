From: akpm@linux-foundation.org
Subject: - cyclades-coding-style-review.patch removed from -mm tree
Date: Thu, 01 May 2008 02:29:53 -0700
Message-ID: <200805010929.m419TrDL030718@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51562 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756537AbYEAJaW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 May 2008 05:30:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@lxorguk.ukuu.org.uk, acme@ghostprotocols.net, alan@redhat.com, jirislaby@gmail.com, mm-commits@vger.kernel.org


The patch titled
     cyclades: coding style & review
has been removed from the -mm tree.  Its filename was
     cyclades-coding-style-review.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cyclades: coding style & review
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

Signed-off-by: Alan Cox <alan@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/cyclades.c |  308 ++++++++++++++++++--------------------
 1 file changed, 149 insertions(+), 159 deletions(-)

diff -puN drivers/char/cyclades.c~cyclades-coding-style-review drivers/char/cyclades.c
--- a/drivers/char/cyclades.c~cyclades-coding-style-review
+++ a/drivers/char/cyclades.c
@@ -21,7 +21,6 @@
  *
  * This version supports shared IRQ's (only for PCI boards).
  *
- * $Log: cyclades.c,v $
  * Prevent users from opening non-existing Z ports.
  *
  * Revision 2.3.2.8   2000/07/06 18:14:16 ivan
@@ -62,7 +61,7 @@
  * Driver now makes sure that the constant SERIAL_XMIT_SIZE is defined;
  *
  * Revision 2.3.2.2   1999/10/01 11:27:43 ivan
- * Fixed bug in cyz_poll that would make all ports but port 0 
+ * Fixed bug in cyz_poll that would make all ports but port 0
  * unable to transmit/receive data (Cyclades-Z only);
  * Implemented logic to prevent the RX buffer from being stuck with data
  * due to a driver / firmware race condition in interrupt op mode
@@ -83,25 +82,25 @@
  * Revision 2.3.1.1   1999/07/15 16:45:53 ivan
  * Removed CY_PROC conditional compilation;
  * Implemented SMP-awareness for the driver;
- * Implemented a new ISA IRQ autoprobe that uses the irq_probe_[on|off] 
+ * Implemented a new ISA IRQ autoprobe that uses the irq_probe_[on|off]
  * functions;
  * The driver now accepts memory addresses (maddr=0xMMMMM) and IRQs
  * (irq=NN) as parameters (only for ISA boards);
- * Fixed bug in set_line_char that would prevent the Cyclades-Z 
+ * Fixed bug in set_line_char that would prevent the Cyclades-Z
  * ports from being configured at speeds above 115.2Kbps;
  * Fixed bug in cy_set_termios that would prevent XON/XOFF flow control
  * switching from working properly;
- * The driver now only prints IRQ info for the Cyclades-Z if it's 
+ * The driver now only prints IRQ info for the Cyclades-Z if it's
  * configured to work in interrupt mode;
  *
  * Revision 2.2.2.3   1999/06/28 11:13:29 ivan
  * Added support for interrupt mode operation for the Z cards;
  * Removed the driver inactivity control for the Z;
- * Added a missing MOD_DEC_USE_COUNT in the cy_open function for when 
+ * Added a missing MOD_DEC_USE_COUNT in the cy_open function for when
  * the Z firmware is not loaded yet;
- * Replaced the "manual" Z Tx flush buffer by a call to a FW command of 
+ * Replaced the "manual" Z Tx flush buffer by a call to a FW command of
  * same functionality;
- * Implemented workaround for IRQ setting loss on the PCI configuration 
+ * Implemented workaround for IRQ setting loss on the PCI configuration
  * registers after a PCI bridge EEPROM reload (affects PLX9060 only);
  *
  * Revision 2.2.2.2  1999/05/14 17:18:15 ivan
@@ -112,22 +111,22 @@
  * BREAK implementation changed in order to make use of the 'break_ctl'
  * TTY facility;
  * Fixed typo in TTY structure field 'driver_name';
- * Included a PCI bridge reset and EEPROM reload in the board 
+ * Included a PCI bridge reset and EEPROM reload in the board
  * initialization code (for both Y and Z series).
  *
  * Revision 2.2.2.1  1999/04/08 16:17:43 ivan
- * Fixed a bug in cy_wait_until_sent that was preventing the port to be 
+ * Fixed a bug in cy_wait_until_sent that was preventing the port to be
  * closed properly after a SIGINT;
  * Module usage counter scheme revisited;
  * Added support to the upcoming Y PCI boards (i.e., support to additional
  * PCI Device ID's).
- * 
+ *
  * Revision 2.2.1.10 1999/01/20 16:14:29 ivan
  * Removed all unnecessary page-alignement operations in ioremap calls
  * (ioremap is currently safe for these operations).
  *
  * Revision 2.2.1.9  1998/12/30 18:18:30 ivan
- * Changed access to PLX PCI bridge registers from I/O to MMIO, in 
+ * Changed access to PLX PCI bridge registers from I/O to MMIO, in
  * order to make PLX9050-based boards work with certain motherboards.
  *
  * Revision 2.2.1.8  1998/11/13 12:46:20 ivan
@@ -148,7 +147,7 @@
  * Fixed Cyclom-4Yo hardware detection bug.
  *
  * Revision 2.2.1.4  1998/08/04 11:02:50 ivan
- * /proc/cyclades implementation with great collaboration of 
+ * /proc/cyclades implementation with great collaboration of
  * Marc Lewis <marc@blarg.net>;
  * cyy_interrupt was changed to avoid occurrence of kernel oopses
  * during PPP operation.
@@ -157,7 +156,7 @@
  * General code review in order to comply with 2.1 kernel standards;
  * data loss prevention for slow devices revisited (cy_wait_until_sent
  * was created);
- * removed conditional compilation for new/old PCI structure support 
+ * removed conditional compilation for new/old PCI structure support
  * (now the driver only supports the new PCI structure).
  *
  * Revision 2.2.1.1  1998/03/19 16:43:12 ivan
@@ -168,7 +167,7 @@
  * cleaned up the data loss fix;
  * fixed XON/XOFF handling once more (Cyclades-Z);
  * general review of the driver routines;
- * introduction of a mechanism to prevent data loss with slow 
+ * introduction of a mechanism to prevent data loss with slow
  * printers, by forcing a delay before closing the port.
  *
  * Revision 2.1.1.2  1998/02/17 16:50:00 ivan
@@ -182,12 +181,12 @@
  * Code review for the module cleanup routine;
  * fixed RTS and DTR status report for new CD1400's in get_modem_info;
  * includes anonymous changes regarding signal_pending.
- * 
+ *
  * Revision 2.1  1997/11/01 17:42:41 ivan
  * Changes in the driver to support Alpha systems (except 8Zo V_1);
  * BREAK fix for the Cyclades-Z boards;
  * driver inactivity control by FW implemented;
- * introduction of flag that allows driver to take advantage of 
+ * introduction of flag that allows driver to take advantage of
  * a special CD1400 feature related to HW flow control;
  * added support for the CD1400  rev. J (Cyclom-Y boards);
  * introduction of ioctls to:
@@ -196,17 +195,17 @@
  *  - adjust the polling interval (Cyclades-Z);
  *
  * Revision 1.36.4.33  1997/06/27 19:00:00  ivan
- * Fixes related to kernel version conditional 
+ * Fixes related to kernel version conditional
  * compilation.
- *  
+ *
  * Revision 1.36.4.32  1997/06/14 19:30:00  ivan
- * Compatibility issues between kernels 2.0.x and 
+ * Compatibility issues between kernels 2.0.x and
  * 2.1.x (mainly related to clear_bit function).
- *  
+ *
  * Revision 1.36.4.31  1997/06/03 15:30:00  ivan
- * Changes to define the memory window according to the 
+ * Changes to define the memory window according to the
  * board type.
- *  
+ *
  * Revision 1.36.4.30  1997/05/16 15:30:00  daniel
  * Changes to support new cycladesZ boards.
  *
@@ -624,7 +623,7 @@
 #undef	CY_PCI_DEBUG
 
 /*
- * Include section 
+ * Include section
  */
 #include <linux/module.h>
 #include <linux/errno.h>
@@ -649,9 +648,9 @@
 #include <linux/firmware.h>
 
 #include <asm/system.h>
-#include <asm/io.h>
+#include <linux/io.h>
 #include <asm/irq.h>
-#include <asm/uaccess.h>
+#include <linux/uaccess.h>
 
 #include <linux/kernel.h>
 #include <linux/pci.h>
@@ -668,10 +667,10 @@ static void cy_send_xchar(struct tty_str
 	((readl(&((struct RUNTIME_9060 __iomem *) \
 		((card).ctl_addr))->init_ctrl) & (1<<17)) != 0)
 
-#define ISZLOADED(card)	(((ZO_V1==readl(&((struct RUNTIME_9060 __iomem *) \
+#define ISZLOADED(card)	(((ZO_V1 == readl(&((struct RUNTIME_9060 __iomem *) \
 			((card).ctl_addr))->mail_box_0)) || \
 			Z_FPGA_CHECK(card)) && \
-			(ZFIRM_ID==readl(&((struct FIRM_ID __iomem *) \
+			(ZFIRM_ID == readl(&((struct FIRM_ID __iomem *) \
 			((card).base_addr+ID_ADDRESS))->signature)))
 
 #ifndef SERIAL_XMIT_SIZE
@@ -809,12 +808,12 @@ static char baud_cor3[] = {	/* receive t
 
 /*
  * The Cyclades driver implements HW flow control as any serial driver.
- * The cyclades_port structure member rflow and the vector rflow_thr 
- * allows us to take advantage of a special feature in the CD1400 to avoid 
- * data loss even when the system interrupt latency is too high. These flags 
- * are to be used only with very special applications. Setting these flags 
- * requires the use of a special cable (DTR and RTS reversed). In the new 
- * CD1400-based boards (rev. 6.00 or later), there is no need for special 
+ * The cyclades_port structure member rflow and the vector rflow_thr
+ * allows us to take advantage of a special feature in the CD1400 to avoid
+ * data loss even when the system interrupt latency is too high. These flags
+ * are to be used only with very special applications. Setting these flags
+ * requires the use of a special cable (DTR and RTS reversed). In the new
+ * CD1400-based boards (rev. 6.00 or later), there is no need for special
  * cables.
  */
 
@@ -841,14 +840,22 @@ static int cy_chip_offset[] = { 0x0000,
 
 #ifdef CONFIG_PCI
 static struct pci_device_id cy_pci_dev_id[] __devinitdata = {
-	{ PCI_DEVICE(PCI_VENDOR_ID_CYCLADES, PCI_DEVICE_ID_CYCLOM_Y_Lo) },	/* PCI < 1Mb */
-	{ PCI_DEVICE(PCI_VENDOR_ID_CYCLADES, PCI_DEVICE_ID_CYCLOM_Y_Hi) },	/* PCI > 1Mb */
-	{ PCI_DEVICE(PCI_VENDOR_ID_CYCLADES, PCI_DEVICE_ID_CYCLOM_4Y_Lo) },	/* 4Y PCI < 1Mb */
-	{ PCI_DEVICE(PCI_VENDOR_ID_CYCLADES, PCI_DEVICE_ID_CYCLOM_4Y_Hi) },	/* 4Y PCI > 1Mb */
-	{ PCI_DEVICE(PCI_VENDOR_ID_CYCLADES, PCI_DEVICE_ID_CYCLOM_8Y_Lo) },	/* 8Y PCI < 1Mb */
-	{ PCI_DEVICE(PCI_VENDOR_ID_CYCLADES, PCI_DEVICE_ID_CYCLOM_8Y_Hi) },	/* 8Y PCI > 1Mb */
-	{ PCI_DEVICE(PCI_VENDOR_ID_CYCLADES, PCI_DEVICE_ID_CYCLOM_Z_Lo) },	/* Z PCI < 1Mb */
-	{ PCI_DEVICE(PCI_VENDOR_ID_CYCLADES, PCI_DEVICE_ID_CYCLOM_Z_Hi) },	/* Z PCI > 1Mb */
+	/* PCI < 1Mb */
+	{ PCI_DEVICE(PCI_VENDOR_ID_CYCLADES, PCI_DEVICE_ID_CYCLOM_Y_Lo) },
+	/* PCI > 1Mb */
+	{ PCI_DEVICE(PCI_VENDOR_ID_CYCLADES, PCI_DEVICE_ID_CYCLOM_Y_Hi) },
+	/* 4Y PCI < 1Mb */
+	{ PCI_DEVICE(PCI_VENDOR_ID_CYCLADES, PCI_DEVICE_ID_CYCLOM_4Y_Lo) },
+	/* 4Y PCI > 1Mb */
+	{ PCI_DEVICE(PCI_VENDOR_ID_CYCLADES, PCI_DEVICE_ID_CYCLOM_4Y_Hi) },
+	/* 8Y PCI < 1Mb */
+	{ PCI_DEVICE(PCI_VENDOR_ID_CYCLADES, PCI_DEVICE_ID_CYCLOM_8Y_Lo) },
+	/* 8Y PCI > 1Mb */
+	{ PCI_DEVICE(PCI_VENDOR_ID_CYCLADES, PCI_DEVICE_ID_CYCLOM_8Y_Hi) },
+	/* Z PCI < 1Mb */
+	{ PCI_DEVICE(PCI_VENDOR_ID_CYCLADES, PCI_DEVICE_ID_CYCLOM_Z_Lo) },
+	/* Z PCI > 1Mb */
+	{ PCI_DEVICE(PCI_VENDOR_ID_CYCLADES, PCI_DEVICE_ID_CYCLOM_Z_Hi) },
 	{ }			/* end of table */
 };
 MODULE_DEVICE_TABLE(pci, cy_pci_dev_id);
@@ -905,15 +912,14 @@ static inline int serial_paranoia_check(
 
    This function is only called from inside spinlock-protected code.
  */
-static int cyy_issue_cmd(void __iomem * base_addr, u_char cmd, int index)
+static int cyy_issue_cmd(void __iomem *base_addr, u_char cmd, int index)
 {
 	unsigned int i;
 
 	/* Check to see that the previous command has completed */
 	for (i = 0; i < 100; i++) {
-		if (readb(base_addr + (CyCCR << index)) == 0) {
+		if (readb(base_addr + (CyCCR << index)) == 0)
 			break;
-		}
 		udelay(10L);
 	}
 	/* if the CCR never cleared, the previous command
@@ -929,7 +935,7 @@ static int cyy_issue_cmd(void __iomem * 
 
 #ifdef CONFIG_ISA
 /* ISA interrupt detection code */
-static unsigned detect_isa_irq(void __iomem * address)
+static unsigned detect_isa_irq(void __iomem *address)
 {
 	int irq;
 	unsigned long irqs, flags;
@@ -1038,7 +1044,7 @@ static void cyy_chip_rx(struct cyclades_
 					if (info->flags & ASYNC_SAK)
 						do_SAK(tty);
 				} else if (data & CyFRAME) {
-					tty_insert_flip_char( tty,
+					tty_insert_flip_char(tty,
 						readb(base_addr + (CyRDSR <<
 							index)), TTY_FRAME);
 					info->icount.rx++;
@@ -1320,7 +1326,8 @@ static irqreturn_t cyy_interrupt(int irq
 
 	if (unlikely(cinfo == NULL)) {
 #ifdef CY_DEBUG_INTERRUPTS
-		printk(KERN_DEBUG "cyy_interrupt: spurious interrupt %d\n",irq);
+		printk(KERN_DEBUG "cyy_interrupt: spurious interrupt %d\n",
+				irq);
 #endif
 		return IRQ_NONE;	/* spurious interrupt */
 	}
@@ -1375,12 +1382,12 @@ static irqreturn_t cyy_interrupt(int irq
 
 /***********************************************************/
 /********* End of block of Cyclom-Y specific code **********/
-/******** Start of block of Cyclades-Z specific code *********/
+/******** Start of block of Cyclades-Z specific code *******/
 /***********************************************************/
 
 static int
 cyz_fetch_msg(struct cyclades_card *cinfo,
-		__u32 * channel, __u8 * cmd, __u32 * param)
+		__u32 *channel, __u8 *cmd, __u32 *param)
 {
 	struct FIRM_ID __iomem *firm_id;
 	struct ZFW_CTRL __iomem *zfw_ctrl;
@@ -1388,9 +1395,8 @@ cyz_fetch_msg(struct cyclades_card *cinf
 	unsigned long loc_doorbell;
 
 	firm_id = cinfo->base_addr + ID_ADDRESS;
-	if (!ISZLOADED(*cinfo)) {
+	if (!ISZLOADED(*cinfo))
 		return -1;
-	}
 	zfw_ctrl = cinfo->base_addr + (readl(&firm_id->zfwctrl_addr) & 0xfffff);
 	board_ctrl = &zfw_ctrl->board_ctrl;
 
@@ -1418,9 +1424,9 @@ cyz_issue_cmd(struct cyclades_card *cinf
 	unsigned int index;
 
 	firm_id = cinfo->base_addr + ID_ADDRESS;
-	if (!ISZLOADED(*cinfo)) {
+	if (!ISZLOADED(*cinfo))
 		return -1;
-	}
+
 	zfw_ctrl = cinfo->base_addr + (readl(&firm_id->zfwctrl_addr) & 0xfffff);
 	board_ctrl = &zfw_ctrl->board_ctrl;
 
@@ -1428,9 +1434,8 @@ cyz_issue_cmd(struct cyclades_card *cinf
 	pci_doorbell =
 	    &((struct RUNTIME_9060 __iomem *)(cinfo->ctl_addr))->pci_doorbell;
 	while ((readl(pci_doorbell) & 0xff) != 0) {
-		if (index++ == 1000) {
+		if (index++ == 1000)
 			return (int)(readl(pci_doorbell) & 0xff);
-		}
 		udelay(50L);
 	}
 	cy_writel(&board_ctrl->hcmd_channel, channel);
@@ -1504,7 +1509,8 @@ static void cyz_handle_rx(struct cyclade
 			while (len--) {
 				data = readb(cinfo->base_addr + rx_bufaddr +
 						new_rx_get);
-				new_rx_get = (new_rx_get + 1)& (rx_bufsize - 1);
+				new_rx_get = (new_rx_get + 1) &
+							(rx_bufsize - 1);
 				tty_insert_flip_char(tty, data, TTY_NORMAL);
 				info->idle_stats.recv_bytes++;
 				info->icount.rx++;
@@ -1636,7 +1642,8 @@ static void cyz_handle_cmd(struct cyclad
 		special_count = 0;
 		delta_count = 0;
 		info = &cinfo->ports[channel];
-		if ((tty = info->tty) == NULL)
+		tty = info->tty;
+		if (tty == NULL)
 			continue;
 
 		ch_ctrl = &(zfw_ctrl->ch_ctrl[channel]);
@@ -1732,7 +1739,8 @@ static irqreturn_t cyz_interrupt(int irq
 
 	if (unlikely(cinfo == NULL)) {
 #ifdef CY_DEBUG_INTERRUPTS
-		printk(KERN_DEBUG "cyz_interrupt: spurious interrupt %d\n",irq);
+		printk(KERN_DEBUG "cyz_interrupt: spurious interrupt %d\n",
+									irq);
 #endif
 		return IRQ_NONE;	/* spurious interrupt */
 	}
@@ -1851,9 +1859,8 @@ static int startup(struct cyclades_port 
 	}
 
 	if (!info->type) {
-		if (info->tty) {
+		if (info->tty)
 			set_bit(TTY_IO_ERROR, &info->tty->flags);
-		}
 		free_page(page);
 		goto errout;
 	}
@@ -1904,9 +1911,8 @@ static int startup(struct cyclades_port 
 			readb(base_addr + (CySRER << index)) | CyRxData);
 		info->flags |= ASYNC_INITIALIZED;
 
-		if (info->tty) {
+		if (info->tty)
 			clear_bit(TTY_IO_ERROR, &info->tty->flags);
-		}
 		info->xmit_cnt = info->xmit_head = info->xmit_tail = 0;
 		info->breakon = info->breakoff = 0;
 		memset((char *)&info->idle_stats, 0, sizeof(info->idle_stats));
@@ -1925,9 +1931,8 @@ static int startup(struct cyclades_port 
 		base_addr = card->base_addr;
 
 		firm_id = base_addr + ID_ADDRESS;
-		if (!ISZLOADED(*card)) {
+		if (!ISZLOADED(*card))
 			return -ENODEV;
-		}
 
 		zfw_ctrl = card->base_addr +
 				(readl(&firm_id->zfwctrl_addr) & 0xfffff);
@@ -1990,9 +1995,8 @@ static int startup(struct cyclades_port 
 		/* enable send, recv, modem !!! */
 
 		info->flags |= ASYNC_INITIALIZED;
-		if (info->tty) {
+		if (info->tty)
 			clear_bit(TTY_IO_ERROR, &info->tty->flags);
-		}
 		info->xmit_cnt = info->xmit_head = info->xmit_tail = 0;
 		info->breakon = info->breakoff = 0;
 		memset((char *)&info->idle_stats, 0, sizeof(info->idle_stats));
@@ -2061,9 +2065,8 @@ static void shutdown(struct cyclades_por
 	void __iomem *base_addr;
 	int chip, channel, index;
 
-	if (!(info->flags & ASYNC_INITIALIZED)) {
+	if (!(info->flags & ASYNC_INITIALIZED))
 		return;
-	}
 
 	card = info->card;
 	channel = info->line - card->first_line;
@@ -2105,9 +2108,8 @@ static void shutdown(struct cyclades_por
 		/* it may be appropriate to clear _XMIT at
 		   some later date (after testing)!!! */
 
-		if (info->tty) {
+		if (info->tty)
 			set_bit(TTY_IO_ERROR, &info->tty->flags);
-		}
 		info->flags &= ~ASYNC_INITIALIZED;
 		spin_unlock_irqrestore(&card->card_lock, flags);
 	} else {
@@ -2124,9 +2126,8 @@ static void shutdown(struct cyclades_por
 #endif
 
 		firm_id = base_addr + ID_ADDRESS;
-		if (!ISZLOADED(*card)) {
+		if (!ISZLOADED(*card))
 			return;
-		}
 
 		zfw_ctrl = card->base_addr +
 				(readl(&firm_id->zfwctrl_addr) & 0xfffff);
@@ -2157,9 +2158,8 @@ static void shutdown(struct cyclades_por
 #endif
 		}
 
-		if (info->tty) {
+		if (info->tty)
 			set_bit(TTY_IO_ERROR, &info->tty->flags);
-		}
 		info->flags &= ~ASYNC_INITIALIZED;
 
 		spin_unlock_irqrestore(&card->card_lock, flags);
@@ -2204,7 +2204,8 @@ block_til_ready(struct tty_struct *tty, 
 	 * If non-blocking mode is set, then make the check up front
 	 * and then exit.
 	 */
-	if ((filp->f_flags & O_NONBLOCK) || (tty->flags & (1 << TTY_IO_ERROR))) {
+	if ((filp->f_flags & O_NONBLOCK) ||
+					(tty->flags & (1 << TTY_IO_ERROR))) {
 		info->flags |= ASYNC_NORMAL_ACTIVE;
 		return 0;
 	}
@@ -2301,7 +2302,8 @@ block_til_ready(struct tty_struct *tty, 
 			return -EINVAL;
 		}
 
-		zfw_ctrl = base_addr + (readl(&firm_id->zfwctrl_addr)& 0xfffff);
+		zfw_ctrl = base_addr + (readl(&firm_id->zfwctrl_addr)
+								& 0xfffff);
 		board_ctrl = &zfw_ctrl->board_ctrl;
 		ch_ctrl = zfw_ctrl->ch_ctrl;
 
@@ -2378,9 +2380,9 @@ static int cy_open(struct tty_struct *tt
 	int retval;
 
 	line = tty->index;
-	if ((tty->index < 0) || (NR_PORTS <= line)) {
+	if (tty->index < 0 || NR_PORTS <= line)
 		return -ENODEV;
-	}
+
 	for (i = 0; i < NR_CARDS; i++)
 		if (line < cy_card[i].first_line + cy_card[i].nports &&
 				line >= cy_card[i].first_line)
@@ -2388,9 +2390,8 @@ static int cy_open(struct tty_struct *tt
 	if (i >= NR_CARDS)
 		return -ENODEV;
 	info = &cy_card[i].ports[line - cy_card[i].first_line];
-	if (info->line < 0) {
+	if (info->line < 0)
 		return -ENODEV;
-	}
 
 	/* If the card's firmware hasn't been loaded,
 	   treat it as absent from the system.  This
@@ -2456,9 +2457,9 @@ static int cy_open(struct tty_struct *tt
 #endif
 	tty->driver_data = info;
 	info->tty = tty;
-	if (serial_paranoia_check(info, tty->name, "cy_open")) {
+	if (serial_paranoia_check(info, tty->name, "cy_open"))
 		return -ENODEV;
-	}
+
 #ifdef CY_DEBUG_OPEN
 	printk(KERN_DEBUG "cyc:cy_open ttyC%d, count = %d\n", info->line,
 			info->count);
@@ -2482,9 +2483,8 @@ static int cy_open(struct tty_struct *tt
 	 * Start up serial port
 	 */
 	retval = startup(info);
-	if (retval) {
+	if (retval)
 		return retval;
-	}
 
 	retval = block_til_ready(tty, filp, info);
 	if (retval) {
@@ -2591,9 +2591,8 @@ static void cy_close(struct tty_struct *
 	printk(KERN_DEBUG "cyc:cy_close ttyC%d\n", info->line);
 #endif
 
-	if (!info || serial_paranoia_check(info, tty->name, "cy_close")) {
+	if (!info || serial_paranoia_check(info, tty->name, "cy_close"))
 		return;
-	}
 
 	card = info->card;
 
@@ -2641,9 +2640,9 @@ static void cy_close(struct tty_struct *
 	 */
 	tty->closing = 1;
 	spin_unlock_irqrestore(&card->card_lock, flags);
-	if (info->closing_wait != CY_CLOSING_WAIT_NONE) {
+	if (info->closing_wait != CY_CLOSING_WAIT_NONE)
 		tty_wait_until_sent(tty, info->closing_wait);
-	}
+
 	spin_lock_irqsave(&card->card_lock, flags);
 
 	if (!IS_CYC_Z(*card)) {
@@ -2657,15 +2656,16 @@ static void cy_close(struct tty_struct *
 		cy_writeb(base_addr + (CySRER << index),
 			  readb(base_addr + (CySRER << index)) & ~CyRxData);
 		if (info->flags & ASYNC_INITIALIZED) {
-			/* Waiting for on-board buffers to be empty before closing
-			   the port */
+			/* Waiting for on-board buffers to be empty before
+			   closing the port */
 			spin_unlock_irqrestore(&card->card_lock, flags);
 			cy_wait_until_sent(tty, info->timeout);
 			spin_lock_irqsave(&card->card_lock, flags);
 		}
 	} else {
 #ifdef Z_WAKE
-		/* Waiting for on-board buffers to be empty before closing the port */
+		/* Waiting for on-board buffers to be empty before closing
+		   the port */
 		void __iomem *base_addr = card->base_addr;
 		struct FIRM_ID __iomem *firm_id = base_addr + ID_ADDRESS;
 		struct ZFW_CTRL __iomem *zfw_ctrl =
@@ -2738,9 +2738,8 @@ static int cy_write(struct tty_struct *t
 	printk(KERN_DEBUG "cyc:cy_write ttyC%d\n", info->line);
 #endif
 
-	if (serial_paranoia_check(info, tty->name, "cy_write")) {
+	if (serial_paranoia_check(info, tty->name, "cy_write"))
 		return 0;
-	}
 
 	if (!info->xmit_buf)
 		return 0;
@@ -2766,9 +2765,9 @@ static int cy_write(struct tty_struct *t
 	info->idle_stats.xmit_bytes += ret;
 	info->idle_stats.xmit_idle = jiffies;
 
-	if (info->xmit_cnt && !tty->stopped && !tty->hw_stopped) {
+	if (info->xmit_cnt && !tty->stopped && !tty->hw_stopped)
 		start_xmit(info);
-	}
+
 	return ret;
 }				/* cy_write */
 
@@ -2810,7 +2809,7 @@ static void cy_put_char(struct tty_struc
 
 /*
  * This routine is called by the kernel after it has written a
- * series of characters to the tty device using put_char().  
+ * series of characters to the tty device using put_char().
  */
 static void cy_flush_chars(struct tty_struct *tty)
 {
@@ -2950,12 +2949,12 @@ static void set_line_char(struct cyclade
 	int baud, baud_rate = 0;
 	int i;
 
-	if (!info->tty || !info->tty->termios) {
+	if (!info->tty || !info->tty->termios)
 		return;
-	}
-	if (info->line == -1) {
+
+	if (info->line == -1)
 		return;
-	}
+
 	cflag = info->tty->termios->c_cflag;
 	iflag = info->tty->termios->c_iflag;
 
@@ -2994,13 +2993,11 @@ static void set_line_char(struct cyclade
 		}
 		/* find the baud index */
 		for (i = 0; i < 20; i++) {
-			if (baud == baud_table[i]) {
+			if (baud == baud_table[i])
 				break;
-			}
 		}
-		if (i == 20) {
+		if (i == 20)
 			i = 19;	/* CD1400_MAX_SPEED */
-		}
 
 		if (baud == 38400 && (info->flags & ASYNC_SPD_MASK) ==
 				ASYNC_SPD_CUST) {
@@ -3059,18 +3056,16 @@ static void set_line_char(struct cyclade
 			info->cor1 = Cy_8_BITS;
 			break;
 		}
-		if (cflag & CSTOPB) {
+		if (cflag & CSTOPB)
 			info->cor1 |= Cy_2_STOP;
-		}
+
 		if (cflag & PARENB) {
-			if (cflag & PARODD) {
+			if (cflag & PARODD)
 				info->cor1 |= CyPARITY_O;
-			} else {
+			else
 				info->cor1 |= CyPARITY_E;
-			}
-		} else {
+		} else
 			info->cor1 |= CyPARITY_NONE;
-		}
 
 		/* CTS flow control flag */
 		if (cflag & CRTSCTS) {
@@ -3123,7 +3118,8 @@ static void set_line_char(struct cyclade
 		cyy_issue_cmd(base_addr, CyCOR_CHANGE | CyCOR1ch | CyCOR2ch |
 				CyCOR3ch, index);
 
-		cy_writeb(base_addr + (CyCAR << index), (u_char) channel);	/* !!! Is this needed? */
+		/* !!! Is this needed? */
+		cy_writeb(base_addr + (CyCAR << index), (u_char) channel);
 		cy_writeb(base_addr + (CyRTPR << index),
 			(info->default_timeout ? info->default_timeout : 0x02));
 		/* 10ms rx timeout */
@@ -3191,9 +3187,8 @@ static void set_line_char(struct cyclade
 #endif
 		}
 
-		if (info->tty) {
+		if (info->tty)
 			clear_bit(TTY_IO_ERROR, &info->tty->flags);
-		}
 		spin_unlock_irqrestore(&card->card_lock, flags);
 
 	} else {
@@ -3206,9 +3201,8 @@ static void set_line_char(struct cyclade
 		int retval;
 
 		firm_id = card->base_addr + ID_ADDRESS;
-		if (!ISZLOADED(*card)) {
+		if (!ISZLOADED(*card))
 			return;
-		}
 
 		zfw_ctrl = card->base_addr +
 			(readl(&firm_id->zfwctrl_addr) & 0xfffff);
@@ -3268,14 +3262,12 @@ static void set_line_char(struct cyclade
 				  readl(&ch_ctrl->comm_data_l) | C_DL_1STOP);
 		}
 		if (cflag & PARENB) {
-			if (cflag & PARODD) {
+			if (cflag & PARODD)
 				cy_writel(&ch_ctrl->comm_parity, C_PR_ODD);
-			} else {
+			else
 				cy_writel(&ch_ctrl->comm_parity, C_PR_EVEN);
-			}
-		} else {
+		} else
 			cy_writel(&ch_ctrl->comm_parity, C_PR_NONE);
-		}
 
 		/* CTS flow control flag */
 		if (cflag & CRTSCTS) {
@@ -3305,11 +3297,10 @@ static void set_line_char(struct cyclade
 		}
 
 		/* CD sensitivity */
-		if (cflag & CLOCAL) {
+		if (cflag & CLOCAL)
 			info->flags &= ~ASYNC_CHECK_CD;
-		} else {
+		else
 			info->flags |= ASYNC_CHECK_CD;
-		}
 
 		if (baud == 0) {	/* baud rate is zero, turn off line */
 			cy_writel(&ch_ctrl->rs_control,
@@ -3325,21 +3316,20 @@ static void set_line_char(struct cyclade
 #endif
 		}
 
-		retval = cyz_issue_cmd(card, channel, C_CM_IOCTLM,0L);
+		retval = cyz_issue_cmd(card, channel, C_CM_IOCTLM, 0L);
 		if (retval != 0) {
 			printk(KERN_ERR "cyc:set_line_char(2) retval on ttyC%d "
 				"was %x\n", info->line, retval);
 		}
 
-		if (info->tty) {
+		if (info->tty)
 			clear_bit(TTY_IO_ERROR, &info->tty->flags);
-		}
 	}
 }				/* set_line_char */
 
 static int
 get_serial_info(struct cyclades_port *info,
-		struct serial_struct __user * retinfo)
+		struct serial_struct __user *retinfo)
 {
 	struct serial_struct tmp;
 	struct cyclades_card *cinfo = info->card;
@@ -3363,7 +3353,7 @@ get_serial_info(struct cyclades_port *in
 
 static int
 set_serial_info(struct cyclades_port *info,
-		struct serial_struct __user * new_info)
+		struct serial_struct __user *new_info)
 {
 	struct serial_struct new_serial;
 	struct cyclades_port old_info;
@@ -3417,7 +3407,7 @@ check_and_exit:
  *	    transmit holding register is empty.  This functionality
  *	    allows an RS485 driver to be written in user space.
  */
-static int get_lsr_info(struct cyclades_port *info, unsigned int __user * value)
+static int get_lsr_info(struct cyclades_port *info, unsigned int __user *value)
 {
 	struct cyclades_card *card;
 	int chip, channel, index;
@@ -3731,8 +3721,8 @@ static void cy_break(struct tty_struct *
 	spin_unlock_irqrestore(&card->card_lock, flags);
 }				/* cy_break */
 
-static int
-get_mon_info(struct cyclades_port *info, struct cyclades_monitor __user * mon)
+static int get_mon_info(struct cyclades_port *info,
+				struct cyclades_monitor __user *mon)
 {
 
 	if (copy_to_user(mon, &info->mon, sizeof(struct cyclades_monitor)))
@@ -3771,8 +3761,8 @@ static int set_threshold(struct cyclades
 	return 0;
 }				/* set_threshold */
 
-static int
-get_threshold(struct cyclades_port *info, unsigned long __user * value)
+static int get_threshold(struct cyclades_port *info,
+						unsigned long __user *value)
 {
 	struct cyclades_card *card;
 	void __iomem *base_addr;
@@ -3793,15 +3783,15 @@ get_threshold(struct cyclades_port *info
 	return 0;
 }				/* get_threshold */
 
-static int
-set_default_threshold(struct cyclades_port *info, unsigned long value)
+static int set_default_threshold(struct cyclades_port *info,
+							unsigned long value)
 {
 	info->default_threshold = value & 0x0f;
 	return 0;
 }				/* set_default_threshold */
 
-static int
-get_default_threshold(struct cyclades_port *info, unsigned long __user * value)
+static int get_default_threshold(struct cyclades_port *info,
+						unsigned long __user *value)
 {
 	return put_user(info->default_threshold, value);
 }				/* get_default_threshold */
@@ -3828,7 +3818,8 @@ static int set_timeout(struct cyclades_p
 	return 0;
 }				/* set_timeout */
 
-static int get_timeout(struct cyclades_port *info, unsigned long __user * value)
+static int get_timeout(struct cyclades_port *info,
+						unsigned long __user *value)
 {
 	struct cyclades_card *card;
 	void __iomem *base_addr;
@@ -3855,8 +3846,8 @@ static int set_default_timeout(struct cy
 	return 0;
 }				/* set_default_timeout */
 
-static int
-get_default_timeout(struct cyclades_port *info, unsigned long __user * value)
+static int get_default_timeout(struct cyclades_port *info,
+					unsigned long __user *value)
 {
 	return put_user(info->default_timeout, value);
 }				/* get_default_timeout */
@@ -3941,7 +3932,7 @@ cy_ioctl(struct tty_struct *tty, struct 
 		break;
 #endif				/* CONFIG_CYZ_INTR */
 	case CYSETWAIT:
-		info->closing_wait = (unsigned short)arg *HZ / 100;
+		info->closing_wait = (unsigned short)arg * HZ / 100;
 		ret_val = 0;
 		break;
 	case CYGETWAIT:
@@ -4118,9 +4109,8 @@ static void cy_throttle(struct tty_struc
 			tty->ldisc.chars_in_buffer(tty), info->line);
 #endif
 
-	if (serial_paranoia_check(info, tty->name, "cy_throttle")) {
+	if (serial_paranoia_check(info, tty->name, "cy_throttle"))
 		return;
-	}
 
 	card = info->card;
 
@@ -4174,12 +4164,11 @@ static void cy_unthrottle(struct tty_str
 	char buf[64];
 
 	printk(KERN_DEBUG "cyc:unthrottle %s: %ld...ttyC%d\n",
-		tty_name(tty, buf), tty->ldisc.chars_in_buffer(tty),info->line);
+		tty_name(tty, buf), tty_chars_in_buffer(tty), info->line);
 #endif
 
-	if (serial_paranoia_check(info, tty->name, "cy_unthrottle")) {
+	if (serial_paranoia_check(info, tty->name, "cy_unthrottle"))
 		return;
-	}
 
 	if (I_IXOFF(tty)) {
 		if (info->x_char)
@@ -4274,7 +4263,8 @@ static void cy_start(struct tty_struct *
 		base_addr = cinfo->base_addr + (cy_chip_offset[chip] << index);
 
 		spin_lock_irqsave(&cinfo->card_lock, flags);
-		cy_writeb(base_addr + (CyCAR << index), (u_char) (channel & 0x0003));	/* index channel */
+		cy_writeb(base_addr + (CyCAR << index),
+			(u_char) (channel & 0x0003));	/* index channel */
 		cy_writeb(base_addr + (CySRER << index),
 			  readb(base_addr + (CySRER << index)) | CyTxRdy);
 		spin_unlock_irqrestore(&cinfo->card_lock, flags);
@@ -4411,10 +4401,11 @@ static int __devinit cy_init_card(struct
 			info->cor3 = 0x08;	/* _very_ small rcv threshold */
 
 			chip_number = (port - cinfo->first_line) / 4;
-			if ((info->chip_rev = readb(cinfo->base_addr +
-				      (cy_chip_offset[chip_number] <<
-				       index) + (CyGFRCR << index))) >=
-			    CD1400_REV_J) {
+			info->chip_rev = readb(cinfo->base_addr +
+				      (cy_chip_offset[chip_number] << index) +
+				      (CyGFRCR << index));
+
+			if (info->chip_rev >= CD1400_REV_J) {
 				/* It is a CD1400 rev. J or later */
 				info->tbpr = baud_bpr_60[13];	/* Tx BPR */
 				info->tco = baud_co_60[13];	/* Tx CO */
@@ -4459,7 +4450,8 @@ static unsigned short __devinit cyy_init
 	/* Cy_ClrIntr is 0x1800 */
 	udelay(500L);
 
-	for (chip_number = 0; chip_number < CyMAX_CHIPS_PER_CARD; chip_number++) {
+	for (chip_number = 0; chip_number < CyMAX_CHIPS_PER_CARD;
+							chip_number++) {
 		base_addr =
 		    true_base_addr + (cy_chip_offset[chip_number] << index);
 		mdelay(1);
@@ -4560,9 +4552,8 @@ static int __init cy_detect_isa(void)
 	/* scan the address table probing for Cyclom-Y/ISA boards */
 	for (i = 0; i < NR_ISA_ADDRS; i++) {
 		unsigned int isa_address = cy_isa_addresses[i];
-		if (isa_address == 0x0000) {
+		if (isa_address == 0x0000)
 			return nboard;
-		}
 
 		/* probe for CD1400... */
 		cy_isa_address = ioremap(isa_address, CyISA_Ywin);
@@ -4852,12 +4843,10 @@ static int __devinit cyz_load_fw(struct 
 	if (mailbox != 0) {
 		/* set window to last 512K of RAM */
 		cy_writel(&ctl_addr->loc_addr_base, WIN_RAM + RAM_SIZE);
-		//sleep(1);
 		for (tmp = base_addr; tmp < base_addr + RAM_SIZE; tmp++)
 			cy_writeb(tmp, 255);
 		/* set window to beginning of RAM */
 		cy_writel(&ctl_addr->loc_addr_base, WIN_RAM);
-		//sleep(1);
 	}
 
 	retval = __cyz_load_fw(fw, "Cyclom-Z", mailbox, base_addr, NULL);
@@ -5387,7 +5376,8 @@ static void __exit cy_cleanup_module(voi
 	del_timer_sync(&cyz_timerlist);
 #endif /* CONFIG_CYZ_INTR */
 
-	if ((e1 = tty_unregister_driver(cy_serial_driver)))
+	e1 = tty_unregister_driver(cy_serial_driver);
+	if (e1)
 		printk(KERN_ERR "failed to unregister Cyclades serial "
 				"driver(%d)\n", e1);
 
_

Patches currently in -mm which might be from alan@lxorguk.ukuu.org.uk are

origin.patch
add-time_is_after_jiffies-and-others-which-compare-with-jiffies.patch
pata_atiixp-simplex-clear.patch
pata_atiixp-dont-disable.patch
8390-split-8390-support-into-a-pausing-and-a-non-pausing-driver-core.patch
parisc-new-termios-definitions.patch
generic-irq-let-setup_irq-reenable-a-shared-irq.patch
8250-switch-8250-drivers-to-use-_nocache-ioremaps.patch
sxc-fix-printk-warnings-on-sparc32.patch
put_pid-make-sure-we-dont-free-the-live-pid.patch

