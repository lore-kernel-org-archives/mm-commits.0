From: akpm@linux-foundation.org
Subject: + char-cyclades-move-card-entries-init-into-function.patch added to -mm tree
Date: Thu, 19 Apr 2007 21:54:01 -0700
Message-ID: <200704200454.l3K4s10g007150@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:58102 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1422727AbXDTEyF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 20 Apr 2007 00:54:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jirislaby@gmail.com


The patch titled
     Char: cyclades, move card entries init into function
has been added to the -mm tree.  Its filename is
     char-cyclades-move-card-entries-init-into-function.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Char: cyclades, move card entries init into function
From: Jiri Slaby <jirislaby@gmail.com>

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/cyclades.c |  311 +++++++++++++++++++-------------------
 1 file changed, 156 insertions(+), 155 deletions(-)

diff -puN drivers/char/cyclades.c~char-cyclades-move-card-entries-init-into-function drivers/char/cyclades.c
--- a/drivers/char/cyclades.c~char-cyclades-move-card-entries-init-into-function
+++ a/drivers/char/cyclades.c
@@ -4503,6 +4503,159 @@ static void cy_hangup(struct tty_struct 
  * ---------------------------------------------------------------------
  */
 
+static void __devinit cy_init_card(struct cyclades_card *cinfo,
+		const unsigned int board)
+{
+	struct cyclades_port *info;
+	u32 mailbox;
+	unsigned int nports;
+	unsigned short chip_number;
+	int index, port;
+
+	if (cinfo->num_chips == -1) {	/* Cyclades-Z */
+		mailbox = readl(&((struct RUNTIME_9060 __iomem *)
+				     cinfo->ctl_addr)->mail_box_0);
+		nports = (mailbox == ZE_V1) ? ZE_V1_NPORTS : 8;
+		cinfo->intr_enabled = 0;
+		cinfo->nports = 0;	/* Will be correctly set later, after
+					   Z FW is loaded */
+		spin_lock_init(&cinfo->card_lock);
+		for (port = cinfo->first_line;
+		     port < cinfo->first_line + nports; port++) {
+			info = &cy_port[port];
+			info->magic = CYCLADES_MAGIC;
+			info->type = PORT_STARTECH;
+			info->card = board;
+			info->line = port;
+			info->chip_rev = 0;
+			info->flags = STD_COM_FLAGS;
+			info->tty = NULL;
+			if (mailbox == ZO_V1)
+				info->xmit_fifo_size = CYZ_FIFO_SIZE;
+			else
+				info->xmit_fifo_size =
+				    4 * CYZ_FIFO_SIZE;
+			info->cor1 = 0;
+			info->cor2 = 0;
+			info->cor3 = 0;
+			info->cor4 = 0;
+			info->cor5 = 0;
+			info->tbpr = 0;
+			info->tco = 0;
+			info->rbpr = 0;
+			info->rco = 0;
+			info->custom_divisor = 0;
+			info->close_delay = 5 * HZ / 10;
+			info->closing_wait = CLOSING_WAIT_DELAY;
+			info->icount.cts = info->icount.dsr =
+			    info->icount.rng = info->icount.dcd = 0;
+			info->icount.rx = info->icount.tx = 0;
+			info->icount.frame = info->icount.parity = 0;
+			info->icount.overrun = info->icount.brk = 0;
+			info->x_char = 0;
+			info->event = 0;
+			info->count = 0;
+			info->blocked_open = 0;
+			info->default_threshold = 0;
+			info->default_timeout = 0;
+			INIT_WORK(&info->tqueue, do_softint);
+			init_waitqueue_head(&info->open_wait);
+			init_waitqueue_head(&info->close_wait);
+			init_waitqueue_head(&info->shutdown_wait);
+			init_waitqueue_head(&info->delta_msr_wait);
+			/* info->session */
+			/* info->pgrp */
+			info->read_status_mask = 0;
+			/* info->timeout */
+			/* Bentson's vars */
+			info->jiffies[0] = 0;
+			info->jiffies[1] = 0;
+			info->jiffies[2] = 0;
+			info->rflush_count = 0;
+#ifdef CONFIG_CYZ_INTR
+			init_timer(&cyz_rx_full_timer[port]);
+			cyz_rx_full_timer[port].function = NULL;
+#endif
+		}
+#ifndef CONFIG_CYZ_INTR
+		if (!timer_pending(&cyz_timerlist)) {
+			mod_timer(&cyz_timerlist, jiffies + 1);
+#ifdef CY_PCI_DEBUG
+			printk("Cyclades-Z polling initialized\n");
+#endif
+		}
+#endif				/* CONFIG_CYZ_INTR */
+
+	} else {	/* Cyclom-Y of some kind */
+		index = cinfo->bus_index;
+		spin_lock_init(&cinfo->card_lock);
+		cinfo->nports = CyPORTS_PER_CHIP * cinfo->num_chips;
+		for (port = cinfo->first_line;
+		     port < cinfo->first_line + cinfo->nports; port++) {
+			info = &cy_port[port];
+			info->magic = CYCLADES_MAGIC;
+			info->type = PORT_CIRRUS;
+			info->card = board;
+			info->line = port;
+			info->flags = STD_COM_FLAGS;
+			info->tty = NULL;
+			info->xmit_fifo_size = CyMAX_CHAR_FIFO;
+			info->cor1 =
+			    CyPARITY_NONE | Cy_1_STOP | Cy_8_BITS;
+			info->cor2 = CyETC;
+			info->cor3 = 0x08;	/* _very_ small rcv threshold */
+			info->cor4 = 0;
+			info->cor5 = 0;
+			info->custom_divisor = 0;
+			info->close_delay = 5 * HZ / 10;
+			info->closing_wait = CLOSING_WAIT_DELAY;
+			info->icount.cts = info->icount.dsr =
+			    info->icount.rng = info->icount.dcd = 0;
+			info->icount.rx = info->icount.tx = 0;
+			info->icount.frame = info->icount.parity = 0;
+			info->icount.overrun = info->icount.brk = 0;
+			chip_number = (port - cinfo->first_line) / 4;
+			if ((info->chip_rev =
+			     readb(cinfo->base_addr +
+				      (cy_chip_offset[chip_number] <<
+				       index) + (CyGFRCR << index))) >=
+			    CD1400_REV_J) {
+				/* It is a CD1400 rev. J or later */
+				info->tbpr = baud_bpr_60[13];	/* Tx BPR */
+				info->tco = baud_co_60[13];	/* Tx CO */
+				info->rbpr = baud_bpr_60[13];	/* Rx BPR */
+				info->rco = baud_co_60[13];	/* Rx CO */
+				info->rflow = 0;
+				info->rtsdtr_inv = 1;
+			} else {
+				info->tbpr = baud_bpr_25[13];	/* Tx BPR */
+				info->tco = baud_co_25[13];	/* Tx CO */
+				info->rbpr = baud_bpr_25[13];	/* Rx BPR */
+				info->rco = baud_co_25[13];	/* Rx CO */
+				info->rflow = 0;
+				info->rtsdtr_inv = 0;
+			}
+			info->x_char = 0;
+			info->event = 0;
+			info->count = 0;
+			info->blocked_open = 0;
+			info->default_threshold = 0;
+			info->default_timeout = 0;
+			INIT_WORK(&info->tqueue, do_softint);
+			init_waitqueue_head(&info->open_wait);
+			init_waitqueue_head(&info->close_wait);
+			init_waitqueue_head(&info->shutdown_wait);
+			init_waitqueue_head(&info->delta_msr_wait);
+			/* info->session */
+			/* info->pgrp */
+			info->read_status_mask =
+			    CyTIMEOUT | CySPECHAR | CyBREAK
+			    | CyPARITY | CyFRAME | CyOVERRUN;
+			/* info->timeout */
+		}
+	}
+}
+
 /* initialize chips on Cyclom-Y card -- return number of valid
    chips (which is number of ports/4) */
 static unsigned short __init
@@ -5300,13 +5453,7 @@ static const struct tty_operations cy_op
 
 static int __init cy_init(void)
 {
-	struct cyclades_port *info;
-	struct cyclades_card *cinfo;
-	int number_z_boards = 0;
-	int board, port, i, index;
-	unsigned long mailbox;
-	unsigned short chip_number;
-	int nports;
+	unsigned int i;
 
 	cy_serial_driver = alloc_tty_driver(NR_PORTS);
 	if (!cy_serial_driver)
@@ -5369,154 +5516,8 @@ static int __init cy_init(void)
 	}
 
 	/* initialize per-port data structures for each valid board found */
-	for (board = 0; board < cy_nboard; board++) {
-		cinfo = &cy_card[board];
-		if (cinfo->num_chips == -1) {	/* Cyclades-Z */
-			number_z_boards++;
-			mailbox = readl(&((struct RUNTIME_9060 __iomem *)
-					     cy_card[board].ctl_addr)->
-					   mail_box_0);
-			nports = (mailbox == ZE_V1) ? ZE_V1_NPORTS : 8;
-			cinfo->intr_enabled = 0;
-			cinfo->nports = 0;	/* Will be correctly set later, after 
-						   Z FW is loaded */
-			spin_lock_init(&cinfo->card_lock);
-			for (port = cinfo->first_line;
-			     port < cinfo->first_line + nports; port++) {
-				info = &cy_port[port];
-				info->magic = CYCLADES_MAGIC;
-				info->type = PORT_STARTECH;
-				info->card = board;
-				info->line = port;
-				info->chip_rev = 0;
-				info->flags = STD_COM_FLAGS;
-				info->tty = NULL;
-				if (mailbox == ZO_V1)
-					info->xmit_fifo_size = CYZ_FIFO_SIZE;
-				else
-					info->xmit_fifo_size =
-					    4 * CYZ_FIFO_SIZE;
-				info->cor1 = 0;
-				info->cor2 = 0;
-				info->cor3 = 0;
-				info->cor4 = 0;
-				info->cor5 = 0;
-				info->tbpr = 0;
-				info->tco = 0;
-				info->rbpr = 0;
-				info->rco = 0;
-				info->custom_divisor = 0;
-				info->close_delay = 5 * HZ / 10;
-				info->closing_wait = CLOSING_WAIT_DELAY;
-				info->icount.cts = info->icount.dsr =
-				    info->icount.rng = info->icount.dcd = 0;
-				info->icount.rx = info->icount.tx = 0;
-				info->icount.frame = info->icount.parity = 0;
-				info->icount.overrun = info->icount.brk = 0;
-				info->x_char = 0;
-				info->event = 0;
-				info->count = 0;
-				info->blocked_open = 0;
-				info->default_threshold = 0;
-				info->default_timeout = 0;
-				INIT_WORK(&info->tqueue, do_softint);
-				init_waitqueue_head(&info->open_wait);
-				init_waitqueue_head(&info->close_wait);
-				init_waitqueue_head(&info->shutdown_wait);
-				init_waitqueue_head(&info->delta_msr_wait);
-				/* info->session */
-				/* info->pgrp */
-				info->read_status_mask = 0;
-				/* info->timeout */
-				/* Bentson's vars */
-				info->jiffies[0] = 0;
-				info->jiffies[1] = 0;
-				info->jiffies[2] = 0;
-				info->rflush_count = 0;
-#ifdef CONFIG_CYZ_INTR
-				init_timer(&cyz_rx_full_timer[port]);
-				cyz_rx_full_timer[port].function = NULL;
-#endif
-			}
-			continue;
-		} else {	/* Cyclom-Y of some kind */
-			index = cinfo->bus_index;
-			spin_lock_init(&cinfo->card_lock);
-			cinfo->nports = CyPORTS_PER_CHIP * cinfo->num_chips;
-			for (port = cinfo->first_line;
-			     port < cinfo->first_line + cinfo->nports; port++) {
-				info = &cy_port[port];
-				info->magic = CYCLADES_MAGIC;
-				info->type = PORT_CIRRUS;
-				info->card = board;
-				info->line = port;
-				info->flags = STD_COM_FLAGS;
-				info->tty = NULL;
-				info->xmit_fifo_size = CyMAX_CHAR_FIFO;
-				info->cor1 =
-				    CyPARITY_NONE | Cy_1_STOP | Cy_8_BITS;
-				info->cor2 = CyETC;
-				info->cor3 = 0x08;	/* _very_ small rcv threshold */
-				info->cor4 = 0;
-				info->cor5 = 0;
-				info->custom_divisor = 0;
-				info->close_delay = 5 * HZ / 10;
-				info->closing_wait = CLOSING_WAIT_DELAY;
-				info->icount.cts = info->icount.dsr =
-				    info->icount.rng = info->icount.dcd = 0;
-				info->icount.rx = info->icount.tx = 0;
-				info->icount.frame = info->icount.parity = 0;
-				info->icount.overrun = info->icount.brk = 0;
-				chip_number = (port - cinfo->first_line) / 4;
-				if ((info->chip_rev =
-				     readb(cinfo->base_addr +
-					      (cy_chip_offset[chip_number] <<
-					       index) + (CyGFRCR << index))) >=
-				    CD1400_REV_J) {
-					/* It is a CD1400 rev. J or later */
-					info->tbpr = baud_bpr_60[13];	/* Tx BPR */
-					info->tco = baud_co_60[13];	/* Tx CO */
-					info->rbpr = baud_bpr_60[13];	/* Rx BPR */
-					info->rco = baud_co_60[13];	/* Rx CO */
-					info->rflow = 0;
-					info->rtsdtr_inv = 1;
-				} else {
-					info->tbpr = baud_bpr_25[13];	/* Tx BPR */
-					info->tco = baud_co_25[13];	/* Tx CO */
-					info->rbpr = baud_bpr_25[13];	/* Rx BPR */
-					info->rco = baud_co_25[13];	/* Rx CO */
-					info->rflow = 0;
-					info->rtsdtr_inv = 0;
-				}
-				info->x_char = 0;
-				info->event = 0;
-				info->count = 0;
-				info->blocked_open = 0;
-				info->default_threshold = 0;
-				info->default_timeout = 0;
-				INIT_WORK(&info->tqueue, do_softint);
-				init_waitqueue_head(&info->open_wait);
-				init_waitqueue_head(&info->close_wait);
-				init_waitqueue_head(&info->shutdown_wait);
-				init_waitqueue_head(&info->delta_msr_wait);
-				/* info->session */
-				/* info->pgrp */
-				info->read_status_mask =
-				    CyTIMEOUT | CySPECHAR | CyBREAK
-				    | CyPARITY | CyFRAME | CyOVERRUN;
-				/* info->timeout */
-			}
-		}
-	}
-
-#ifndef CONFIG_CYZ_INTR
-	if (number_z_boards) {
-		mod_timer(&cyz_timerlist, jiffies + 1);
-#ifdef CY_PCI_DEBUG
-		printk("Cyclades-Z polling initialized\n");
-#endif
-	}
-#endif				/* CONFIG_CYZ_INTR */
+	for (i = 0; i < cy_nboard; i++)
+		cy_init_card(&cy_card[i], i);
 
 	return 0;
 
_

Patches currently in -mm which might be from jirislaby@gmail.com are

acpi-asus_acpi-support-f2je-model.patch
char-rocket-add-module_device_table.patch
char-cs5535_gpio-add-module_device_table.patch
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
shrink_slab-handle-bad-shrinkers.patch
