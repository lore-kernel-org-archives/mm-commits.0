From: akpm@linux-foundation.org
Subject: + char-cyclades-simplify-variables-initialization.patch added to -mm tree
Date: Thu, 03 May 2007 23:45:33 -0700
Message-ID: <200705040645.l446jXSP030880@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:55215 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965736AbXEDGph (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 May 2007 02:45:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jirislaby@gmail.com


The patch titled
     Char: cyclades, simplify variables initialization
has been added to the -mm tree.  Its filename is
     char-cyclades-simplify-variables-initialization.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Char: cyclades, simplify variables initialization
From: Jiri Slaby <jirislaby@gmail.com>

- do not init static variables to 0
- simplify cy_init_card -- use memset(0) and do not zero each element
  separately, also reorder init, so that same entries are inited at one
  place

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/cyclades.c |  156 ++++++++++----------------------------
 1 file changed, 44 insertions(+), 112 deletions(-)

diff -puN drivers/char/cyclades.c~char-cyclades-simplify-variables-initialization drivers/char/cyclades.c
--- a/drivers/char/cyclades.c~char-cyclades-simplify-variables-initialization
+++ a/drivers/char/cyclades.c
@@ -718,8 +718,8 @@ static unsigned int cy_isa_addresses[] =
 #define NR_ISA_ADDRS ARRAY_SIZE(cy_isa_addresses)
 
 #ifdef MODULE
-static long maddr[NR_CARDS] = { 0, };
-static int irq[NR_CARDS] = { 0, };
+static long maddr[NR_CARDS];
+static int irq[NR_CARDS];
 
 module_param_array(maddr, long, NULL, 0);
 module_param_array(irq, int, NULL, 0);
@@ -4505,6 +4505,8 @@ static void __devinit cy_init_card(struc
 	unsigned short chip_number;
 	int index, port;
 
+	spin_lock_init(&cinfo->card_lock);
+
 	if (IS_CYC_Z(*cinfo)) {	/* Cyclades-Z */
 		mailbox = readl(&((struct RUNTIME_9060 __iomem *)
 				     cinfo->ctl_addr)->mail_box_0);
@@ -4512,104 +4514,47 @@ static void __devinit cy_init_card(struc
 		cinfo->intr_enabled = 0;
 		cinfo->nports = 0;	/* Will be correctly set later, after
 					   Z FW is loaded */
-		spin_lock_init(&cinfo->card_lock);
-		for (port = cinfo->first_line;
-		     port < cinfo->first_line + nports; port++) {
-			info = &cy_port[port];
-			info->magic = CYCLADES_MAGIC;
+	} else {
+		index = cinfo->bus_index;
+		nports = cinfo->nports = CyPORTS_PER_CHIP * cinfo->num_chips;
+	}
+
+	for (port = cinfo->first_line; port < cinfo->first_line + nports;
+			port++) {
+		info = &cy_port[port];
+		memset(info, 0, sizeof(*info));
+		info->magic = CYCLADES_MAGIC;
+		info->card = board;
+		info->line = port;
+		info->flags = STD_COM_FLAGS;
+		info->closing_wait = CLOSING_WAIT_DELAY;
+		info->close_delay = 5 * HZ / 10;
+
+		INIT_WORK(&info->tqueue, do_softint);
+		init_waitqueue_head(&info->open_wait);
+		init_waitqueue_head(&info->close_wait);
+		init_waitqueue_head(&info->shutdown_wait);
+		init_waitqueue_head(&info->delta_msr_wait);
+
+		if (IS_CYC_Z(*cinfo)) {
 			info->type = PORT_STARTECH;
-			info->card = board;
-			info->line = port;
-			info->chip_rev = 0;
-			info->flags = STD_COM_FLAGS;
-			info->tty = NULL;
 			if (mailbox == ZO_V1)
 				info->xmit_fifo_size = CYZ_FIFO_SIZE;
 			else
-				info->xmit_fifo_size =
-				    4 * CYZ_FIFO_SIZE;
-			info->cor1 = 0;
-			info->cor2 = 0;
-			info->cor3 = 0;
-			info->cor4 = 0;
-			info->cor5 = 0;
-			info->tbpr = 0;
-			info->tco = 0;
-			info->rbpr = 0;
-			info->rco = 0;
-			info->custom_divisor = 0;
-			info->close_delay = 5 * HZ / 10;
-			info->closing_wait = CLOSING_WAIT_DELAY;
-			info->icount.cts = info->icount.dsr =
-			    info->icount.rng = info->icount.dcd = 0;
-			info->icount.rx = info->icount.tx = 0;
-			info->icount.frame = info->icount.parity = 0;
-			info->icount.overrun = info->icount.brk = 0;
-			info->x_char = 0;
-			info->event = 0;
-			info->count = 0;
-			info->blocked_open = 0;
-			info->default_threshold = 0;
-			info->default_timeout = 0;
-			INIT_WORK(&info->tqueue, do_softint);
-			init_waitqueue_head(&info->open_wait);
-			init_waitqueue_head(&info->close_wait);
-			init_waitqueue_head(&info->shutdown_wait);
-			init_waitqueue_head(&info->delta_msr_wait);
-			/* info->session */
-			/* info->pgrp */
-			info->read_status_mask = 0;
-			/* info->timeout */
-			/* Bentson's vars */
-			info->jiffies[0] = 0;
-			info->jiffies[1] = 0;
-			info->jiffies[2] = 0;
-			info->rflush_count = 0;
+				info->xmit_fifo_size = 4 * CYZ_FIFO_SIZE;
 #ifdef CONFIG_CYZ_INTR
 			init_timer(&cyz_rx_full_timer[port]);
 			cyz_rx_full_timer[port].function = NULL;
 #endif
-		}
-#ifndef CONFIG_CYZ_INTR
-		if (!timer_pending(&cyz_timerlist)) {
-			mod_timer(&cyz_timerlist, jiffies + 1);
-#ifdef CY_PCI_DEBUG
-			printk(KERN_DEBUG "Cyclades-Z polling initialized\n");
-#endif
-		}
-#endif				/* CONFIG_CYZ_INTR */
-
-	} else {	/* Cyclom-Y of some kind */
-		index = cinfo->bus_index;
-		spin_lock_init(&cinfo->card_lock);
-		cinfo->nports = CyPORTS_PER_CHIP * cinfo->num_chips;
-		for (port = cinfo->first_line;
-		     port < cinfo->first_line + cinfo->nports; port++) {
-			info = &cy_port[port];
-			info->magic = CYCLADES_MAGIC;
+		} else {
 			info->type = PORT_CIRRUS;
-			info->card = board;
-			info->line = port;
-			info->flags = STD_COM_FLAGS;
-			info->tty = NULL;
 			info->xmit_fifo_size = CyMAX_CHAR_FIFO;
-			info->cor1 =
-			    CyPARITY_NONE | Cy_1_STOP | Cy_8_BITS;
+			info->cor1 = CyPARITY_NONE | Cy_1_STOP | Cy_8_BITS;
 			info->cor2 = CyETC;
 			info->cor3 = 0x08;	/* _very_ small rcv threshold */
-			info->cor4 = 0;
-			info->cor5 = 0;
-			info->custom_divisor = 0;
-			info->close_delay = 5 * HZ / 10;
-			info->closing_wait = CLOSING_WAIT_DELAY;
-			info->icount.cts = info->icount.dsr =
-			    info->icount.rng = info->icount.dcd = 0;
-			info->icount.rx = info->icount.tx = 0;
-			info->icount.frame = info->icount.parity = 0;
-			info->icount.overrun = info->icount.brk = 0;
+
 			chip_number = (port - cinfo->first_line) / 4;
-			if ((info->chip_rev =
-			     readb(cinfo->base_addr +
+			if ((info->chip_rev = readb(cinfo->base_addr +
 				      (cy_chip_offset[chip_number] <<
 				       index) + (CyGFRCR << index))) >=
 			    CD1400_REV_J) {
@@ -4618,35 +4563,28 @@ static void __devinit cy_init_card(struc
 				info->tco = baud_co_60[13];	/* Tx CO */
 				info->rbpr = baud_bpr_60[13];	/* Rx BPR */
 				info->rco = baud_co_60[13];	/* Rx CO */
-				info->rflow = 0;
 				info->rtsdtr_inv = 1;
 			} else {
 				info->tbpr = baud_bpr_25[13];	/* Tx BPR */
 				info->tco = baud_co_25[13];	/* Tx CO */
 				info->rbpr = baud_bpr_25[13];	/* Rx BPR */
 				info->rco = baud_co_25[13];	/* Rx CO */
-				info->rflow = 0;
 				info->rtsdtr_inv = 0;
 			}
-			info->x_char = 0;
-			info->event = 0;
-			info->count = 0;
-			info->blocked_open = 0;
-			info->default_threshold = 0;
-			info->default_timeout = 0;
-			INIT_WORK(&info->tqueue, do_softint);
-			init_waitqueue_head(&info->open_wait);
-			init_waitqueue_head(&info->close_wait);
-			init_waitqueue_head(&info->shutdown_wait);
-			init_waitqueue_head(&info->delta_msr_wait);
-			/* info->session */
-			/* info->pgrp */
-			info->read_status_mask =
-			    CyTIMEOUT | CySPECHAR | CyBREAK
-			    | CyPARITY | CyFRAME | CyOVERRUN;
-			/* info->timeout */
+			info->read_status_mask = CyTIMEOUT | CySPECHAR |
+				CyBREAK | CyPARITY | CyFRAME | CyOVERRUN;
 		}
+
+	}
+
+#ifndef CONFIG_CYZ_INTR
+	if (IS_CYC_Z(*cinfo) && !timer_pending(&cyz_timerlist)) {
+		mod_timer(&cyz_timerlist, jiffies + 1);
+#ifdef CY_PCI_DEBUG
+		printk(KERN_DEBUG "Cyclades-Z polling initialized\n");
+#endif
 	}
+#endif
 }
 
 /* initialize chips on Cyclom-Y card -- return number of valid
@@ -5369,12 +5307,6 @@ static int __init cy_init(void)
 		goto err_frtty;
 	}
 
-	for (i = 0; i < NR_CARDS; i++) {
-		/* base_addr=0 indicates board not found */
-		cy_card[i].base_addr = NULL;
-	}
-
-	/* invalidate remaining cy_port structures */
 	for (i = 0; i < NR_PORTS; i++) {
 		cy_port[i].line = -1;
 		cy_port[i].magic = -1;
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
