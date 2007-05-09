From: akpm@linux-foundation.org
Subject: - char-cyclades-simplify-variables-initialization.patch removed from -mm tree
Date: Tue, 08 May 2007 19:57:41 -0700
Message-ID: <200705090257.l492vfWY010218@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:41608 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1032842AbXEIC5s (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 22:57:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jirislaby@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Char: cyclades, simplify variables initialization
has been removed from the -mm tree.  Its filename was
     char-cyclades-simplify-variables-initialization.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
git-dvb.patch
cinergyt2-fix-file-release-handler.patch
auerswald-fix-file-release-handler.patch
unify-queue_delayed_work-and-queue_delayed_work_on.patch
vmstat-use-our-own-timer-events-fix.patch
shrink_slab-handle-bad-shrinkers.patch
