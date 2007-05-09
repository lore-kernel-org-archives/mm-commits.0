From: akpm@linux-foundation.org
Subject: - char-cyclades-printk-cleanups.patch removed from -mm tree
Date: Tue, 08 May 2007 19:57:34 -0700
Message-ID: <200705090257.l492vYFn010208@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:57151 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1032828AbXEIC5i (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 22:57:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jirislaby@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Char: cyclades, printk cleanups
has been removed from the -mm tree.  Its filename was
     char-cyclades-printk-cleanups.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Char: cyclades, printk cleanups
From: Jiri Slaby <jirislaby@gmail.com>

- add printk KERN_ levels to each printk
- substitute printk with dev_* when device struct is available

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/cyclades.c |  530 +++++++++++++++-----------------------
 1 file changed, 220 insertions(+), 310 deletions(-)

diff -puN drivers/char/cyclades.c~char-cyclades-printk-cleanups drivers/char/cyclades.c
--- a/drivers/char/cyclades.c~char-cyclades-printk-cleanups
+++ a/drivers/char/cyclades.c
@@ -860,21 +860,21 @@ static inline int serial_paranoia_check(
 {
 #ifdef SERIAL_PARANOIA_CHECK
 	if (!info) {
-		printk("cyc Warning: null cyclades_port for (%s) in %s\n",
-				name, routine);
+		printk(KERN_WARNING "cyc Warning: null cyclades_port for (%s) "
+				"in %s\n", name, routine);
 		return 1;
 	}
 
 	if ((long)info < (long)(&cy_port[0]) ||
 			(long)(&cy_port[NR_PORTS]) < (long)info) {
-		printk("cyc Warning: cyclades_port out of range for (%s) in "
-				"%s\n", name, routine);
+		printk(KERN_WARNING "cyc Warning: cyclades_port out of range "
+				"for (%s) in %s\n", name, routine);
 		return 1;
 	}
 
 	if (info->magic != CYCLADES_MAGIC) {
-		printk("cyc Warning: bad magic number for serial struct (%s) "
-				"in %s\n", name, routine);
+		printk(KERN_WARNING "cyc Warning: bad magic number for serial "
+				"struct (%s) in %s\n", name, routine);
 		return 1;
 	}
 #endif
@@ -1047,7 +1047,7 @@ static void cyy_intr_chip(struct cyclade
 
 	if (status & CySRReceive) {	/* reception interrupt */
 #ifdef CY_DEBUG_INTERRUPTS
-		printk("cyy_interrupt: rcvd intr, chip %d\n\r", chip);
+		printk(KERN_DEBUG "cyy_interrupt: rcvd intr, chip %d\n", chip);
 #endif
 		/* determine the channel & change to that context */
 		spin_lock(&cinfo->card_lock);
@@ -1212,7 +1212,7 @@ static void cyy_intr_chip(struct cyclade
 		   is empty, we know we can always stuff a dozen
 		   characters. */
 #ifdef CY_DEBUG_INTERRUPTS
-		printk("cyy_interrupt: xmit intr, chip %d\n\r", chip);
+		printk(KERN_DEBUG "cyy_interrupt: xmit intr, chip %d\n", chip);
 #endif
 
 		/* determine the channel & change to that context */
@@ -1436,7 +1436,7 @@ static irqreturn_t cyy_interrupt(int irq
 
 	if ((cinfo = (struct cyclades_card *)dev_id) == 0) {
 #ifdef CY_DEBUG_INTERRUPTS
-		printk("cyy_interrupt: spurious interrupt %d\n\r", irq);
+		printk(KERN_DEBUG "cyy_interrupt: spurious interrupt %d\n",irq);
 #endif
 		return IRQ_NONE;	/* spurious interrupt */
 	}
@@ -1820,8 +1820,8 @@ static void cyz_handle_cmd(struct cyclad
 		case C_CM_INTBACK2:
 			/* Reception Interrupt */
 #ifdef CY_DEBUG_INTERRUPTS
-			printk("cyz_interrupt: rcvd intr, card %d, "
-					"port %ld\n\r", info->card, channel);
+			printk(KERN_DEBUG "cyz_interrupt: rcvd intr, card %d, "
+					"port %ld\n", info->card, channel);
 #endif
 			cyz_handle_rx(info, ch_ctrl, buf_ctrl);
 			break;
@@ -1830,8 +1830,8 @@ static void cyz_handle_cmd(struct cyclad
 		case C_CM_INTBACK:
 			/* Transmission Interrupt */
 #ifdef CY_DEBUG_INTERRUPTS
-			printk("cyz_interrupt: xmit intr, card %d, "
-					"port %ld\n\r", info->card, channel);
+			printk(KERN_DEBUG "cyz_interrupt: xmit intr, card %d, "
+					"port %ld\n", info->card, channel);
 #endif
 			cyz_handle_tx(info, ch_ctrl, buf_ctrl);
 			break;
@@ -1856,14 +1856,15 @@ static irqreturn_t cyz_interrupt(int irq
 
 	if ((cinfo = (struct cyclades_card *)dev_id) == 0) {
 #ifdef CY_DEBUG_INTERRUPTS
-		printk("cyz_interrupt: spurious interrupt %d\n\r", irq);
+		printk(KERN_DEBUG "cyz_interrupt: spurious interrupt %d\n",irq);
 #endif
 		return IRQ_NONE;	/* spurious interrupt */
 	}
 
 	if (!ISZLOADED(*cinfo)) {
 #ifdef CY_DEBUG_INTERRUPTS
-		printk("cyz_interrupt: board not yet loaded (IRQ%d).\n\r", irq);
+		printk(KERN_DEBUG "cyz_interrupt: board not yet loaded "
+				"(IRQ%d).\n", irq);
 #endif
 		return IRQ_NONE;
 	}
@@ -1885,7 +1886,7 @@ static void cyz_rx_restart(unsigned long
 	CY_LOCK(info, flags);
 	retval = cyz_issue_cmd(&cy_card[card], channel, C_CM_INTBACK2, 0L);
 	if (retval != 0) {
-		printk("cyc:cyz_rx_restart retval on ttyC%d was %x\n",
+		printk(KERN_ERR "cyc:cyz_rx_restart retval on ttyC%d was %x\n",
 			info->line, retval);
 	}
 	cyz_rx_full_timer[info->line].function = NULL;
@@ -2000,10 +2001,9 @@ static int startup(struct cyclades_port 
 				(cy_chip_offset[chip] << index);
 
 #ifdef CY_DEBUG_OPEN
-		printk("cyc startup card %d, chip %d, channel %d, "
-				"base_addr %lx\n",
-				card, chip, channel, (long)base_addr);
-		/**/
+		printk(KERN_DEBUG "cyc startup card %d, chip %d, channel %d, "
+				"base_addr %p\n",
+				card, chip, channel, base_addr);
 #endif
 		CY_LOCK(info, flags);
 
@@ -2021,8 +2021,8 @@ static int startup(struct cyclades_port 
 		cy_writeb(base_addr + (CyMSVR2 << index), CyDTR);
 
 #ifdef CY_DEBUG_DTR
-		printk("cyc:startup raising DTR\n");
-		printk("     status: 0x%x, 0x%x\n",
+		printk(KERN_DEBUG "cyc:startup raising DTR\n");
+		printk(KERN_DEBUG "     status: 0x%x, 0x%x\n",
 			readb(base_addr + (CyMSVR1 << index)),
 			readb(base_addr + (CyMSVR2 << index)));
 #endif
@@ -2063,9 +2063,8 @@ static int startup(struct cyclades_port 
 		ch_ctrl = zfw_ctrl->ch_ctrl;
 
 #ifdef CY_DEBUG_OPEN
-		printk("cyc startup Z card %d, channel %d, base_addr %lx\n",
-			card, channel, (long)base_addr);
-		/**/
+		printk(KERN_DEBUG "cyc startup Z card %d, channel %d, "
+			"base_addr %p\n", card, channel, base_addr);
 #endif
 		CY_LOCK(info, flags);
 
@@ -2091,16 +2090,16 @@ static int startup(struct cyclades_port 
 
 		retval = cyz_issue_cmd(&cy_card[card], channel, C_CM_IOCTL, 0L);
 		if (retval != 0) {
-			printk("cyc:startup(1) retval on ttyC%d was %x\n",
-				info->line, retval);
+			printk(KERN_ERR "cyc:startup(1) retval on ttyC%d was "
+				"%x\n", info->line, retval);
 		}
 
 		/* Flush RX buffers before raising DTR and RTS */
 		retval = cyz_issue_cmd(&cy_card[card], channel, C_CM_FLUSH_RX,
 				0L);
 		if (retval != 0) {
-			printk("cyc:startup(2) retval on ttyC%d was %x\n",
-				info->line, retval);
+			printk(KERN_ERR "cyc:startup(2) retval on ttyC%d was "
+				"%x\n", info->line, retval);
 		}
 
 		/* set timeout !!! */
@@ -2111,11 +2110,11 @@ static int startup(struct cyclades_port 
 		retval = cyz_issue_cmd(&cy_card[info->card], channel,
 				C_CM_IOCTLM, 0L);
 		if (retval != 0) {
-			printk("cyc:startup(3) retval on ttyC%d was %x\n",
-				info->line, retval);
+			printk(KERN_ERR "cyc:startup(3) retval on ttyC%d was "
+				"%x\n", info->line, retval);
 		}
 #ifdef CY_DEBUG_DTR
-		printk("cyc:startup raising Z DTR\n");
+		printk(KERN_DEBUG "cyc:startup raising Z DTR\n");
 #endif
 
 		/* enable send, recv, modem !!! */
@@ -2135,7 +2134,7 @@ static int startup(struct cyclades_port 
 	}
 
 #ifdef CY_DEBUG_OPEN
-	printk(" cyc startup done\n");
+	printk(KERN_DEBUG "cyc startup done\n");
 #endif
 	return 0;
 
@@ -2172,8 +2171,8 @@ static void start_xmit(struct cyclades_p
 		retval = cyz_issue_cmd(&cy_card[card], channel, C_CM_INTBACK,
 				0L);
 		if (retval != 0) {
-			printk("cyc:start_xmit retval on ttyC%d was %x\n",
-				info->line, retval);
+			printk(KERN_ERR "cyc:start_xmit retval on ttyC%d was "
+				"%x\n", info->line, retval);
 		}
 		CY_UNLOCK(info, flags);
 #else				/* CONFIG_CYZ_INTR */
@@ -2206,9 +2205,9 @@ static void shutdown(struct cyclades_por
 				(cy_chip_offset[chip] << index);
 
 #ifdef CY_DEBUG_OPEN
-		printk("cyc shutdown Y card %d, chip %d, channel %d, "
-				"base_addr %lx\n",
-				card, chip, channel, (long)base_addr);
+		printk(KERN_DEBUG "cyc shutdown Y card %d, chip %d, "
+				"channel %d, base_addr %p\n",
+				card, chip, channel, base_addr);
 #endif
 
 		CY_LOCK(info, flags);
@@ -2227,8 +2226,8 @@ static void shutdown(struct cyclades_por
 			cy_writeb(base_addr + (CyMSVR1 << index), ~CyRTS);
 			cy_writeb(base_addr + (CyMSVR2 << index), ~CyDTR);
 #ifdef CY_DEBUG_DTR
-			printk("cyc shutdown dropping DTR\n");
-			printk("     status: 0x%x, 0x%x\n",
+			printk(KERN_DEBUG "cyc shutdown dropping DTR\n");
+			printk(KERN_DEBUG "     status: 0x%x, 0x%x\n",
 				readb(base_addr + (CyMSVR1 << index)),
 				readb(base_addr + (CyMSVR2 << index)));
 #endif
@@ -2251,8 +2250,8 @@ static void shutdown(struct cyclades_por
 
 		base_addr = cy_card[card].base_addr;
 #ifdef CY_DEBUG_OPEN
-		printk("cyc shutdown Z card %d, channel %d, base_addr %lx\n",
-			card, channel, (long)base_addr);
+		printk(KERN_DEBUG "cyc shutdown Z card %d, channel %d, "
+			"base_addr %p\n", card, channel, base_addr);
 #endif
 
 		firm_id = base_addr + ID_ADDRESS;
@@ -2281,11 +2280,11 @@ static void shutdown(struct cyclades_por
 			retval = cyz_issue_cmd(&cy_card[info->card], channel,
 					C_CM_IOCTLM, 0L);
 			if (retval != 0) {
-				printk("cyc:shutdown retval on ttyC%d was %x\n",
-					info->line, retval);
+				printk(KERN_ERR"cyc:shutdown retval on ttyC%d "
+					"was %x\n", info->line, retval);
 			}
 #ifdef CY_DEBUG_DTR
-			printk("cyc:shutdown dropping Z DTR\n");
+			printk(KERN_DEBUG "cyc:shutdown dropping Z DTR\n");
 #endif
 		}
 
@@ -2298,7 +2297,7 @@ static void shutdown(struct cyclades_por
 	}
 
 #ifdef CY_DEBUG_OPEN
-	printk(" cyc shutdown done\n");
+	printk(KERN_DEBUG "cyc shutdown done\n");
 #endif
 }				/* shutdown */
 
@@ -2352,17 +2351,16 @@ block_til_ready(struct tty_struct *tty, 
 	retval = 0;
 	add_wait_queue(&info->open_wait, &wait);
 #ifdef CY_DEBUG_OPEN
-	printk("cyc block_til_ready before block: ttyC%d, count = %d\n",
-		info->line, info->count);
-	/**/
+	printk(KERN_DEBUG "cyc block_til_ready before block: ttyC%d, "
+		"count = %d\n", info->line, info->count);
 #endif
 	CY_LOCK(info, flags);
 	if (!tty_hung_up_p(filp))
 		info->count--;
 	CY_UNLOCK(info, flags);
 #ifdef CY_DEBUG_COUNT
-	printk("cyc block_til_ready: (%d): decrementing count to %d\n",
-		current->pid, info->count);
+	printk(KERN_DEBUG "cyc block_til_ready: (%d): decrementing count to "
+		"%d\n", current->pid, info->count);
 #endif
 	info->blocked_open++;
 
@@ -2382,8 +2380,9 @@ block_til_ready(struct tty_struct *tty, 
 				cy_writeb(base_addr + (CyMSVR2 << index),
 					  CyDTR);
 #ifdef CY_DEBUG_DTR
-				printk("cyc:block_til_ready raising DTR\n");
-				printk("     status: 0x%x, 0x%x\n",
+				printk(KERN_DEBUG "cyc:block_til_ready raising "
+					"DTR\n");
+				printk(KERN_DEBUG "     status: 0x%x, 0x%x\n",
 					readb(base_addr + (CyMSVR1 << index)),
 					readb(base_addr + (CyMSVR2 << index)));
 #endif
@@ -2414,10 +2413,9 @@ block_til_ready(struct tty_struct *tty, 
 				break;
 			}
 #ifdef CY_DEBUG_OPEN
-			printk("cyc block_til_ready blocking: ttyC%d, "
-					"count = %d\n",
-					info->line, info->count);
-			/**/
+			printk(KERN_DEBUG "cyc block_til_ready blocking: "
+				"ttyC%d, count = %d\n",
+				info->line, info->count);
 #endif
 			schedule();
 		}
@@ -2448,12 +2446,13 @@ block_til_ready(struct tty_struct *tty, 
 				retval = cyz_issue_cmd(&cy_card[info->card],
 					channel, C_CM_IOCTLM, 0L);
 				if (retval != 0) {
-					printk("cyc:block_til_ready retval on "
-						"ttyC%d was %x\n",
+					printk(KERN_ERR "cyc:block_til_ready "
+						"retval on ttyC%d was %x\n",
 						info->line, retval);
 				}
 #ifdef CY_DEBUG_DTR
-				printk("cyc:block_til_ready raising Z DTR\n");
+				printk(KERN_DEBUG "cyc:block_til_ready raising "
+					"Z DTR\n");
 #endif
 			}
 
@@ -2474,10 +2473,9 @@ block_til_ready(struct tty_struct *tty, 
 				break;
 			}
 #ifdef CY_DEBUG_OPEN
-			printk("cyc block_til_ready blocking: ttyC%d, "
-					"count = %d\n",
-					info->line, info->count);
-			/**/
+			printk(KERN_DEBUG "cyc block_til_ready blocking: "
+				"ttyC%d, count = %d\n",
+				info->line, info->count);
 #endif
 			schedule();
 		}
@@ -2487,15 +2485,14 @@ block_til_ready(struct tty_struct *tty, 
 	if (!tty_hung_up_p(filp)) {
 		info->count++;
 #ifdef CY_DEBUG_COUNT
-		printk("cyc:block_til_ready (%d): incrementing count to %d\n",
-			current->pid, info->count);
+		printk(KERN_DEBUG "cyc:block_til_ready (%d): incrementing "
+			"count to %d\n", current->pid, info->count);
 #endif
 	}
 	info->blocked_open--;
 #ifdef CY_DEBUG_OPEN
-	printk("cyc:block_til_ready after blocking: ttyC%d, count = %d\n",
-		info->line, info->count);
-	/**/
+	printk(KERN_DEBUG "cyc:block_til_ready after blocking: ttyC%d, "
+		"count = %d\n", info->line, info->count);
 #endif
 	if (retval)
 		return retval;
@@ -2535,12 +2532,13 @@ static int cy_open(struct tty_struct *tt
 					Z_FPGA_CHECK(*cinfo)) &&
 					(ZFIRM_HLT == readl(
 						&firm_id->signature))) {
-				printk("cyc:Cyclades-Z Error: you need an "
-					"external power supply for this number "
-					"of ports.\n\rFirmware halted.\r\n");
+				printk(KERN_ERR "cyc:Cyclades-Z Error: you "
+					"need an external power supply for "
+					"this number of ports.\nFirmware "
+					"halted.\n");
 			} else {
-				printk("cyc:Cyclades-Z firmware not yet "
-					"loaded\n");
+				printk(KERN_ERR "cyc:Cyclades-Z firmware not "
+					"yet loaded\n");
 			}
 			return -ENODEV;
 		}
@@ -2566,8 +2564,8 @@ static int cy_open(struct tty_struct *tt
 				retval = cyz_issue_cmd(cinfo, 0,
 						C_CM_IRQ_ENBL, 0L);
 				if (retval != 0) {
-					printk("cyc:IRQ enable retval was %x\n",
-						retval);
+					printk(KERN_ERR "cyc:IRQ enable retval "
+						"was %x\n", retval);
 				}
 				cinfo->nports =
 					(int)readl(&board_ctrl->n_channel);
@@ -2580,7 +2578,7 @@ static int cy_open(struct tty_struct *tt
 			return -ENODEV;
 	}
 #ifdef CY_DEBUG_OTHER
-	printk("cyc:cy_open ttyC%d\n", info->line);	/* */
+	printk(KERN_DEBUG "cyc:cy_open ttyC%d\n", info->line);
 #endif
 	tty->driver_data = info;
 	info->tty = tty;
@@ -2588,12 +2586,12 @@ static int cy_open(struct tty_struct *tt
 		return -ENODEV;
 	}
 #ifdef CY_DEBUG_OPEN
-	printk("cyc:cy_open ttyC%d, count = %d\n", info->line, info->count);
-	/**/
+	printk(KERN_DEBUG "cyc:cy_open ttyC%d, count = %d\n", info->line,
+			info->count);
 #endif
 	info->count++;
 #ifdef CY_DEBUG_COUNT
-	printk("cyc:cy_open (%d): incrementing count to %d\n",
+	printk(KERN_DEBUG "cyc:cy_open (%d): incrementing count to %d\n",
 		current->pid, info->count);
 #endif
 
@@ -2617,8 +2615,8 @@ static int cy_open(struct tty_struct *tt
 	retval = block_til_ready(tty, filp, info);
 	if (retval) {
 #ifdef CY_DEBUG_OPEN
-		printk("cyc:cy_open returning after block_til_ready with %d\n",
-			retval);
+		printk(KERN_DEBUG "cyc:cy_open returning after block_til_ready "
+			"with %d\n", retval);
 #endif
 		return retval;
 	}
@@ -2626,8 +2624,7 @@ static int cy_open(struct tty_struct *tt
 	info->throttle = 0;
 
 #ifdef CY_DEBUG_OPEN
-	printk(" cyc:cy_open done\n");
-	/**/
+	printk(KERN_DEBUG "cyc:cy_open done\n");
 #endif
 	return 0;
 }				/* cy_open */
@@ -2678,8 +2675,8 @@ static void cy_wait_until_sent(struct tt
 	if (!timeout || timeout > 2 * info->timeout)
 		timeout = 2 * info->timeout;
 #ifdef CY_DEBUG_WAIT_UNTIL_SENT
-	printk("In cy_wait_until_sent(%d) check=%lu...", timeout, char_time);
-	printk("jiff=%lu...", jiffies);
+	printk(KERN_DEBUG "In cy_wait_until_sent(%d) check=%d, jiff=%lu...",
+		timeout, char_time, jiffies);
 #endif
 	card = info->card;
 	channel = (info->line) - (cy_card[card].first_line);
@@ -2691,7 +2688,7 @@ static void cy_wait_until_sent(struct tt
 		    cy_card[card].base_addr + (cy_chip_offset[chip] << index);
 		while (readb(base_addr + (CySRER << index)) & CyTxRdy) {
 #ifdef CY_DEBUG_WAIT_UNTIL_SENT
-			printk("Not clean (jiff=%lu)...", jiffies);
+			printk(KERN_DEBUG "Not clean (jiff=%lu)...", jiffies);
 #endif
 			if (msleep_interruptible(jiffies_to_msecs(char_time)))
 				break;
@@ -2705,7 +2702,7 @@ static void cy_wait_until_sent(struct tt
 	/* Run one more char cycle */
 	msleep_interruptible(jiffies_to_msecs(char_time * 5));
 #ifdef CY_DEBUG_WAIT_UNTIL_SENT
-	printk("Clean (jiff=%lu)...done\n", jiffies);
+	printk(KERN_DEBUG "Clean (jiff=%lu)...done\n", jiffies);
 #endif
 }
 
@@ -2718,7 +2715,7 @@ static void cy_close(struct tty_struct *
 	unsigned long flags;
 
 #ifdef CY_DEBUG_OTHER
-	printk("cyc:cy_close ttyC%d\n", info->line);
+	printk(KERN_DEBUG "cyc:cy_close ttyC%d\n", info->line);
 #endif
 
 	if (!info || serial_paranoia_check(info, tty->name, "cy_close")) {
@@ -2732,7 +2729,8 @@ static void cy_close(struct tty_struct *
 		return;
 	}
 #ifdef CY_DEBUG_OPEN
-	printk("cyc:cy_close ttyC%d, count = %d\n", info->line, info->count);
+	printk(KERN_DEBUG "cyc:cy_close ttyC%d, count = %d\n", info->line,
+		info->count);
 #endif
 	if ((tty->count == 1) && (info->count != 1)) {
 		/*
@@ -2742,17 +2740,17 @@ static void cy_close(struct tty_struct *
 		 * one, we've got real problems, since it means the
 		 * serial port won't be shutdown.
 		 */
-		printk("cyc:cy_close: bad serial port count; tty->count is 1, "
-			"info->count is %d\n", info->count);
+		printk(KERN_ERR "cyc:cy_close: bad serial port count; "
+			"tty->count is 1, info->count is %d\n", info->count);
 		info->count = 1;
 	}
 #ifdef CY_DEBUG_COUNT
-	printk("cyc:cy_close at (%d): decrementing count to %d\n",
+	printk(KERN_DEBUG  "cyc:cy_close at (%d): decrementing count to %d\n",
 		current->pid, info->count - 1);
 #endif
 	if (--info->count < 0) {
 #ifdef CY_DEBUG_COUNT
-		printk("cyc:cyc_close setting count to 0\n");
+		printk(KERN_DEBUG "cyc:cyc_close setting count to 0\n");
 #endif
 		info->count = 0;
 	}
@@ -2805,8 +2803,8 @@ static void cy_close(struct tty_struct *
 			retval = cyz_issue_cmd(&cy_card[info->card], channel,
 						C_CM_IOCTLW, 0L);
 			if (retval != 0) {
-				printk("cyc:cy_close retval on ttyC%d was %x\n",
-					info->line, retval);
+				printk(KERN_DEBUG "cyc:cy_close retval on "
+					"ttyC%d was %x\n", info->line, retval);
 			}
 			CY_UNLOCK(info, flags);
 			interruptible_sleep_on(&info->shutdown_wait);
@@ -2838,7 +2836,7 @@ static void cy_close(struct tty_struct *
 	wake_up_interruptible(&info->close_wait);
 
 #ifdef CY_DEBUG_OTHER
-	printk(" cyc:cy_close done\n");
+	printk(KERN_DEBUG "cyc:cy_close done\n");
 #endif
 
 	CY_UNLOCK(info, flags);
@@ -2864,7 +2862,7 @@ static int cy_write(struct tty_struct *t
 	int c, ret = 0;
 
 #ifdef CY_DEBUG_IO
-	printk("cyc:cy_write ttyC%d\n", info->line);	/* */
+	printk(KERN_DEBUG "cyc:cy_write ttyC%d\n", info->line);
 #endif
 
 	if (serial_paranoia_check(info, tty->name, "cy_write")) {
@@ -2914,7 +2912,7 @@ static void cy_put_char(struct tty_struc
 	unsigned long flags;
 
 #ifdef CY_DEBUG_IO
-	printk("cyc:cy_put_char ttyC%d\n", info->line);
+	printk(KERN_DEBUG "cyc:cy_put_char ttyC%d\n", info->line);
 #endif
 
 	if (serial_paranoia_check(info, tty->name, "cy_put_char"))
@@ -2946,7 +2944,7 @@ static void cy_flush_chars(struct tty_st
 	struct cyclades_port *info = tty->driver_data;
 
 #ifdef CY_DEBUG_IO
-	printk("cyc:cy_flush_chars ttyC%d\n", info->line);	/* */
+	printk(KERN_DEBUG "cyc:cy_flush_chars ttyC%d\n", info->line);
 #endif
 
 	if (serial_paranoia_check(info, tty->name, "cy_flush_chars"))
@@ -2971,7 +2969,7 @@ static int cy_write_room(struct tty_stru
 	int ret;
 
 #ifdef CY_DEBUG_IO
-	printk("cyc:cy_write_room ttyC%d\n", info->line);	/* */
+	printk(KERN_DEBUG "cyc:cy_write_room ttyC%d\n", info->line);
 #endif
 
 	if (serial_paranoia_check(info, tty->name, "cy_write_room"))
@@ -2997,7 +2995,8 @@ static int cy_chars_in_buffer(struct tty
 	if (!IS_CYC_Z(cy_card[card])) {
 #endif				/* Z_EXT_CHARS_IN_BUFFER */
 #ifdef CY_DEBUG_IO
-		printk("cyc:cy_chars_in_buffer ttyC%d %d\n", info->line, info->xmit_cnt);	/* */
+		printk(KERN_DEBUG "cyc:cy_chars_in_buffer ttyC%d %d\n",
+			info->line, info->xmit_cnt);
 #endif
 		return info->xmit_cnt;
 #ifdef Z_EXT_CHARS_IN_BUFFER
@@ -3023,7 +3022,8 @@ static int cy_chars_in_buffer(struct tty
 		else
 			char_count = tx_put - tx_get + tx_bufsize;
 #ifdef CY_DEBUG_IO
-		printk("cyc:cy_chars_in_buffer ttyC%d %d\n", info->line, info->xmit_cnt + char_count);	/* */
+		printk(KERN_DEBUG "cyc:cy_chars_in_buffer ttyC%d %d\n",
+			info->line, info->xmit_cnt + char_count);
 #endif
 		return info->xmit_cnt + char_count;
 	}
@@ -3296,8 +3296,8 @@ static void set_line_char(struct cyclade
 					  ~CyDTR);
 			}
 #ifdef CY_DEBUG_DTR
-			printk("cyc:set_line_char dropping DTR\n");
-			printk("     status: 0x%x, 0x%x\n",
+			printk(KERN_DEBUG "cyc:set_line_char dropping DTR\n");
+			printk(KERN_DEBUG "     status: 0x%x, 0x%x\n",
 				readb(base_addr + (CyMSVR1 << index)),
 				readb(base_addr + (CyMSVR2 << index)));
 #endif
@@ -3310,8 +3310,8 @@ static void set_line_char(struct cyclade
 					  CyDTR);
 			}
 #ifdef CY_DEBUG_DTR
-			printk("cyc:set_line_char raising DTR\n");
-			printk("     status: 0x%x, 0x%x\n",
+			printk(KERN_DEBUG "cyc:set_line_char raising DTR\n");
+			printk(KERN_DEBUG "     status: 0x%x, 0x%x\n",
 				readb(base_addr + (CyMSVR1 << index)),
 				readb(base_addr + (CyMSVR2 << index)));
 #endif
@@ -3426,8 +3426,8 @@ static void set_line_char(struct cyclade
 
 		retval = cyz_issue_cmd(&cy_card[card], channel, C_CM_IOCTL, 0L);
 		if (retval != 0) {
-			printk("cyc:set_line_char retval on ttyC%d was %x\n",
-				info->line, retval);
+			printk(KERN_ERR "cyc:set_line_char retval on ttyC%d "
+				"was %x\n", info->line, retval);
 		}
 
 		/* CD sensitivity */
@@ -3441,20 +3441,20 @@ static void set_line_char(struct cyclade
 			cy_writel(&ch_ctrl->rs_control,
 				  readl(&ch_ctrl->rs_control) & ~C_RS_DTR);
 #ifdef CY_DEBUG_DTR
-			printk("cyc:set_line_char dropping Z DTR\n");
+			printk(KERN_DEBUG "cyc:set_line_char dropping Z DTR\n");
 #endif
 		} else {
 			cy_writel(&ch_ctrl->rs_control,
 				  readl(&ch_ctrl->rs_control) | C_RS_DTR);
 #ifdef CY_DEBUG_DTR
-			printk("cyc:set_line_char raising Z DTR\n");
+			printk(KERN_DEBUG "cyc:set_line_char raising Z DTR\n");
 #endif
 		}
 
 		retval = cyz_issue_cmd(&cy_card[card], channel, C_CM_IOCTLM,0L);
 		if (retval != 0) {
-			printk("cyc:set_line_char(2) retval on ttyC%d was %x\n",
-				info->line, retval);
+			printk(KERN_ERR "cyc:set_line_char(2) retval on ttyC%d "
+				"was %x\n", info->line, retval);
 		}
 
 		if (info->tty) {
@@ -3702,8 +3702,8 @@ cy_tiocmset(struct tty_struct *tty, stru
 					  CyDTR);
 			}
 #ifdef CY_DEBUG_DTR
-			printk("cyc:set_modem_info raising DTR\n");
-			printk("     status: 0x%x, 0x%x\n",
+			printk(KERN_DEBUG "cyc:set_modem_info raising DTR\n");
+			printk(KERN_DEBUG "     status: 0x%x, 0x%x\n",
 				readb(base_addr + (CyMSVR1 << index)),
 				readb(base_addr + (CyMSVR2 << index)));
 #endif
@@ -3722,8 +3722,8 @@ cy_tiocmset(struct tty_struct *tty, stru
 			}
 
 #ifdef CY_DEBUG_DTR
-			printk("cyc:set_modem_info dropping DTR\n");
-			printk("     status: 0x%x, 0x%x\n",
+			printk(KERN_DEBUG "cyc:set_modem_info dropping DTR\n");
+			printk(KERN_DEBUG "     status: 0x%x, 0x%x\n",
 				readb(base_addr + (CyMSVR1 << index)),
 				readb(base_addr + (CyMSVR2 << index)));
 #endif
@@ -3759,7 +3759,8 @@ cy_tiocmset(struct tty_struct *tty, stru
 					readl(&ch_ctrl[channel].rs_control) |
 					C_RS_DTR);
 #ifdef CY_DEBUG_DTR
-				printk("cyc:set_modem_info raising Z DTR\n");
+				printk(KERN_DEBUG "cyc:set_modem_info raising "
+					"Z DTR\n");
 #endif
 				CY_UNLOCK(info, flags);
 			}
@@ -3769,7 +3770,8 @@ cy_tiocmset(struct tty_struct *tty, stru
 					readl(&ch_ctrl[channel].rs_control) &
 					~C_RS_DTR);
 #ifdef CY_DEBUG_DTR
-				printk("cyc:set_modem_info clearing Z DTR\n");
+				printk(KERN_DEBUG "cyc:set_modem_info clearing "
+					"Z DTR\n");
 #endif
 				CY_UNLOCK(info, flags);
 			}
@@ -3780,8 +3782,8 @@ cy_tiocmset(struct tty_struct *tty, stru
 		retval = cyz_issue_cmd(&cy_card[info->card],
 					channel, C_CM_IOCTLM, 0L);
 		if (retval != 0) {
-			printk("cyc:set_modem_info retval on ttyC%d was %x\n",
-				info->line, retval);
+			printk(KERN_ERR "cyc:set_modem_info retval on ttyC%d "
+				"was %x\n", info->line, retval);
 		}
 		CY_UNLOCK(info, flags);
 	}
@@ -3831,16 +3833,17 @@ static void cy_break(struct tty_struct *
 				info->line - cy_card[info->card].first_line,
 				C_CM_SET_BREAK, 0L);
 			if (retval != 0) {
-				printk("cyc:cy_break (set) retval on ttyC%d "
-					"was %x\n", info->line, retval);
+				printk(KERN_ERR "cyc:cy_break (set) retval on "
+					"ttyC%d was %x\n", info->line, retval);
 			}
 		} else {
 			retval = cyz_issue_cmd(&cy_card[info->card],
 				info->line - cy_card[info->card].first_line,
 				C_CM_CLR_BREAK, 0L);
 			if (retval != 0) {
-				printk("cyc:cy_break (clr) retval on ttyC%d "
-					"was %x\n", info->line, retval);
+				printk(KERN_DEBUG "cyc:cy_break (clr) retval "
+					"on ttyC%d was %x\n", info->line,
+					retval);
 			}
 		}
 	}
@@ -4004,7 +4007,8 @@ cy_ioctl(struct tty_struct *tty, struct 
 		return -ENODEV;
 
 #ifdef CY_DEBUG_OTHER
-	printk("cyc:cy_ioctl ttyC%d, cmd = %x arg = %lx\n", info->line, cmd, arg);	/* */
+	printk(KERN_DEBUG "cyc:cy_ioctl ttyC%d, cmd = %x arg = %lx\n",
+		info->line, cmd, arg);
 #endif
 
 	switch (cmd) {
@@ -4164,7 +4168,7 @@ cy_ioctl(struct tty_struct *tty, struct 
 	}
 
 #ifdef CY_DEBUG_OTHER
-	printk(" cyc:cy_ioctl done\n");
+	printk(KERN_DEBUG "cyc:cy_ioctl done\n");
 #endif
 
 	return ret_val;
@@ -4181,7 +4185,7 @@ static void cy_set_termios(struct tty_st
 	struct cyclades_port *info = tty->driver_data;
 
 #ifdef CY_DEBUG_OTHER
-	printk("cyc:cy_set_termios ttyC%d\n", info->line);
+	printk(KERN_DEBUG "cyc:cy_set_termios ttyC%d\n", info->line);
 #endif
 
 	if (tty->termios->c_cflag == old_termios->c_cflag &&
@@ -4251,7 +4255,7 @@ static void cy_throttle(struct tty_struc
 #ifdef CY_DEBUG_THROTTLE
 	char buf[64];
 
-	printk("cyc:throttle %s: %d....ttyC%d\n", tty_name(tty, buf),
+	printk(KERN_DEBUG "cyc:throttle %s: %ld...ttyC%d\n", tty_name(tty, buf),
 			tty->ldisc.chars_in_buffer(tty), info->line);
 #endif
 
@@ -4309,8 +4313,8 @@ static void cy_unthrottle(struct tty_str
 #ifdef CY_DEBUG_THROTTLE
 	char buf[64];
 
-	printk("cyc:unthrottle %s: %d....ttyC%d\n", tty_name(tty, buf),
-		tty->ldisc.chars_in_buffer(tty), info->line);
+	printk(KERN_DEBUG "cyc:unthrottle %s: %ld...ttyC%d\n",
+		tty_name(tty, buf), tty->ldisc.chars_in_buffer(tty),info->line);
 #endif
 
 	if (serial_paranoia_check(info, tty->name, "cy_unthrottle")) {
@@ -4363,7 +4367,7 @@ static void cy_stop(struct tty_struct *t
 	unsigned long flags;
 
 #ifdef CY_DEBUG_OTHER
-	printk("cyc:cy_stop ttyC%d\n", info->line);	/* */
+	printk(KERN_DEBUG "cyc:cy_stop ttyC%d\n", info->line);
 #endif
 
 	if (serial_paranoia_check(info, tty->name, "cy_stop"))
@@ -4398,7 +4402,7 @@ static void cy_start(struct tty_struct *
 	unsigned long flags;
 
 #ifdef CY_DEBUG_OTHER
-	printk("cyc:cy_start ttyC%d\n", info->line);	/* */
+	printk(KERN_DEBUG "cyc:cy_start ttyC%d\n", info->line);
 #endif
 
 	if (serial_paranoia_check(info, tty->name, "cy_start"))
@@ -4430,7 +4434,7 @@ static void cy_flush_buffer(struct tty_s
 	unsigned long flags;
 
 #ifdef CY_DEBUG_IO
-	printk("cyc:cy_flush_buffer ttyC%d\n", info->line);	/* */
+	printk(KERN_DEBUG "cyc:cy_flush_buffer ttyC%d\n", info->line);
 #endif
 
 	if (serial_paranoia_check(info, tty->name, "cy_flush_buffer"))
@@ -4449,8 +4453,8 @@ static void cy_flush_buffer(struct tty_s
 		retval =
 		    cyz_issue_cmd(&cy_card[card], channel, C_CM_FLUSH_TX, 0L);
 		if (retval != 0) {
-			printk("cyc: flush_buffer retval on ttyC%d was %x\n",
-				info->line, retval);
+			printk(KERN_ERR "cyc: flush_buffer retval on ttyC%d "
+				"was %x\n", info->line, retval);
 		}
 		CY_UNLOCK(info, flags);
 	}
@@ -4465,7 +4469,7 @@ static void cy_hangup(struct tty_struct 
 	struct cyclades_port *info = tty->driver_data;
 
 #ifdef CY_DEBUG_OTHER
-	printk("cyc:cy_hangup ttyC%d\n", info->line);	/* */
+	printk(KERN_DEBUG "cyc:cy_hangup ttyC%d\n", info->line);
 #endif
 
 	if (serial_paranoia_check(info, tty->name, "cy_hangup"))
@@ -4476,7 +4480,8 @@ static void cy_hangup(struct tty_struct 
 	info->event = 0;
 	info->count = 0;
 #ifdef CY_DEBUG_COUNT
-	printk("cyc:cy_hangup (%d): setting count to 0\n", current->pid);
+	printk(KERN_DEBUG "cyc:cy_hangup (%d): setting count to 0\n",
+		current->pid);
 #endif
 	info->tty = NULL;
 	info->flags &= ~ASYNC_NORMAL_ACTIVE;
@@ -4569,7 +4574,7 @@ static void __devinit cy_init_card(struc
 		if (!timer_pending(&cyz_timerlist)) {
 			mod_timer(&cyz_timerlist, jiffies + 1);
 #ifdef CY_PCI_DEBUG
-			printk("Cyclades-Z polling initialized\n");
+			printk(KERN_DEBUG "Cyclades-Z polling initialized\n");
 #endif
 		}
 #endif				/* CONFIG_CYZ_INTR */
@@ -4778,18 +4783,17 @@ static int __init cy_detect_isa(void)
 			/* find out the board's irq by probing */
 			cy_isa_irq = detect_isa_irq(cy_isa_address);
 		if (cy_isa_irq == 0) {
-			printk("Cyclom-Y/ISA found at 0x%lx ",
+			printk(KERN_ERR "Cyclom-Y/ISA found at 0x%lx, but the "
+				"IRQ could not be detected.\n",
 				(unsigned long)cy_isa_address);
-			printk("but the IRQ could not be detected.\n");
 			continue;
 		}
 
 		if ((cy_next_channel + cy_isa_nchan) > NR_PORTS) {
-			printk("Cyclom-Y/ISA found at 0x%lx ",
+			printk(KERN_ERR "Cyclom-Y/ISA found at 0x%lx, but no "
+				"more channels are available. Change NR_PORTS "
+				"in cyclades.c and recompile kernel.\n",
 				(unsigned long)cy_isa_address);
-			printk("but no more channels are available.\n");
-			printk("Change NR_PORTS in cyclades.c and recompile "
-					"kernel.\n");
 			return nboard;
 		}
 		/* fill the next cy_card structure available */
@@ -4798,20 +4802,19 @@ static int __init cy_detect_isa(void)
 				break;
 		}
 		if (j == NR_CARDS) {	/* no more cy_cards available */
-			printk("Cyclom-Y/ISA found at 0x%lx ",
+			printk(KERN_ERR "Cyclom-Y/ISA found at 0x%lx, but no "
+				"more cards can be used. Change NR_CARDS in "
+				"cyclades.c and recompile kernel.\n",
 				(unsigned long)cy_isa_address);
-			printk("but no more cards can be used .\n");
-			printk("Change NR_CARDS in cyclades.c and recompile "
-					"kernel.\n");
 			return nboard;
 		}
 
 		/* allocate IRQ */
 		if (request_irq(cy_isa_irq, cyy_interrupt,
 				IRQF_DISABLED, "Cyclom-Y", &cy_card[j])) {
-			printk("Cyclom-Y/ISA found at 0x%lx ",
-				(unsigned long)cy_isa_address);
-			printk("but could not allocate IRQ#%d.\n", cy_isa_irq);
+			printk(KERN_ERR "Cyclom-Y/ISA found at 0x%lx, but "
+				"could not allocate IRQ#%d.\n",
+				(unsigned long)cy_isa_address, cy_isa_irq);
 			return nboard;
 		}
 
@@ -4825,13 +4828,12 @@ static int __init cy_detect_isa(void)
 		cy_init_card(&cy_card[j], j);
 		nboard++;
 
-		/* print message */
-		printk("Cyclom-Y/ISA #%d: 0x%lx-0x%lx, IRQ%d, ",
+		printk(KERN_INFO "Cyclom-Y/ISA #%d: 0x%lx-0x%lx, IRQ%d found: "
+			"%d channels starting from port %d\n",
 			j + 1, (unsigned long)cy_isa_address,
 			(unsigned long)(cy_isa_address + (CyISA_Ywin - 1)),
-			cy_isa_irq);
-		printk("%d channels starting from port %d.\n",
-			cy_isa_nchan, cy_next_channel);
+			cy_isa_irq, cy_isa_nchan, cy_next_channel);
+
 		for (j = cy_next_channel;
 				j < cy_next_channel + cy_isa_nchan; j++)
 			tty_register_device(cy_serial_driver, j, NULL);
@@ -4869,20 +4871,15 @@ static int __devinit cy_init_Ze(unsigned
 	cy_pci_addr2 = pci_iomap(pdev, 2, CyPCI_Ze_win);
 
 	readl(&cy_pci_addr0->mail_box_0);
-#ifdef CY_PCI_DEBUG
-	printk("Cyclades-Z/PCI: relocate winaddr=0x%lx ctladdr=0x%lx\n",
-		(ulong)cy_pci_addr2, (ulong)cy_pci_addr0);
-	printk("Cyclades-Z/PCI: New Cyclades-Z board.  FPGA not "
-			"loaded\n");
-#endif
+	dev_dbg(&pdev->dev, "new Cyclades-Z board.  FPGA not loaded\n");
+
 	/* This must be the new Cyclades-Ze/PCI. */
 	cy_pci_nchan = ZE_V1_NPORTS;
 
 	if ((cy_next_channel + cy_pci_nchan) > NR_PORTS) {
-		printk("Cyclades-Ze/PCI found at 0x%lx but no channels "
+		dev_err(&pdev->dev, "Cyclades-Ze/PCI found, but no channels "
 			"are available.\nChange NR_PORTS in cyclades.c "
-			"and recompile kernel.\n",
-			(ulong) cy_pci_phys2);
+			"and recompile kernel.\n");
 		return -EIO;
 	}
 
@@ -4892,10 +4889,9 @@ static int __devinit cy_init_Ze(unsigned
 			break;
 	}
 	if (j == NR_CARDS) {	/* no more cy_cards available */
-		printk("Cyclades-Ze/PCI found at 0x%lx but no more "
+		dev_err(&pdev->dev, "Cyclades-Ze/PCI found, but no more "
 			"cards can be used.\nChange NR_CARDS in "
-			"cyclades.c and recompile kernel.\n",
-			(ulong) cy_pci_phys2);
+			"cyclades.c and recompile kernel.\n");
 		return -EIO;
 	}
 #ifdef CONFIG_CYZ_INTR
@@ -4904,10 +4900,7 @@ static int __devinit cy_init_Ze(unsigned
 		if (request_irq(cy_pci_irq, cyz_interrupt,
 				IRQF_SHARED, "Cyclades-Z",
 				&cy_card[j])) {
-			printk("Cyclom-Ze/PCI found at 0x%lx ",
-				(ulong) cy_pci_phys2);
-			printk("but could not allocate IRQ%d.\n",
-				cy_pci_irq);
+			dev_err(&pdev->dev, "could not allocate IRQ.\n");
 			return -EIO;
 		}
 	}
@@ -4923,21 +4916,9 @@ static int __devinit cy_init_Ze(unsigned
 	cy_init_card(&cy_card[j], j);
 	pci_set_drvdata(pdev, &cy_card[j]);
 
-	/* print message */
-#ifdef CONFIG_CYZ_INTR
-	/* don't report IRQ if board is no IRQ */
-	if ((cy_pci_irq != 0) && (cy_pci_irq != 255))
-		printk("Cyclades-Ze/PCI #%d: 0x%lx-0x%lx, IRQ%d, ",
-			j + 1, (ulong) cy_pci_phys2,
-			(ulong) (cy_pci_phys2 + CyPCI_Ze_win - 1), cy_pci_irq);
-	else
-#endif				/* CONFIG_CYZ_INTR */
-		printk("Cyclades-Ze/PCI #%d: 0x%lx-0x%lx, ",
-			j + 1, (ulong) cy_pci_phys2,
-			(ulong) (cy_pci_phys2 + CyPCI_Ze_win - 1));
+	dev_info(&pdev->dev, "Cyclades-Ze/PCI #%d found: %d channels starting "
+		"from port %d.\n", j + 1, cy_pci_nchan, cy_next_channel);
 
-	printk("%d channels starting from port %d.\n",
-		cy_pci_nchan, cy_next_channel);
 	for (j = cy_next_channel; j < cy_next_channel + cy_pci_nchan; j++)
 		tty_register_device(cy_serial_driver, j, &pdev->dev);
 	cy_next_channel += cy_pci_nchan;
@@ -4972,17 +4953,10 @@ static int __devinit cy_pci_probe(struct
 
 	if (device_id == PCI_DEVICE_ID_CYCLOM_Y_Lo ||
 			device_id == PCI_DEVICE_ID_CYCLOM_Y_Hi) {
-#ifdef CY_PCI_DEBUG
-		printk("Cyclom-Y/PCI (bus=0x0%x, pci_id=0x%x, ",
-			pdev->bus->number, pdev->devfn);
-		printk("rev_id=%d) IRQ%d\n", cyy_rev_id, cy_pci_irq);
-		printk("Cyclom-Y/PCI:found  winaddr=0x%lx "
-			"ctladdr=0x%lx\n",
-			(ulong)cy_pci_phys2, (ulong)cy_pci_phys0);
-#endif
+		dev_dbg(&pdev->dev, "Cyclom-Y/PCI found\n");
 
 		if (pci_resource_flags(pdev, 2) & IORESOURCE_IO) {
-			printk("  Warning: PCI I/O bit incorrectly "
+			dev_warn(&pdev->dev, "PCI I/O bit incorrectly "
 				"set. Ignoring it...\n");
 			pdev->resource[2].flags &= ~IORESOURCE_IO;
 		}
@@ -4992,47 +4966,33 @@ static int __devinit cy_pci_probe(struct
 		   with other drivers accessing it. */
 		retval = pci_request_regions(pdev, "Cyclom-Y");
 		if (retval) {
-			printk(KERN_ERR "cyclades: failed to reserve "
-					"PCI resources\n");
+			dev_err(&pdev->dev, "failed to reserve resources\n");
 			return retval;
 		}
 #if defined(__alpha__)
 		if (device_id == PCI_DEVICE_ID_CYCLOM_Y_Lo) {	/* below 1M? */
-			printk("Cyclom-Y/PCI (bus=0x0%x, pci_id=0x%x, ",
-				pdev->bus->number, pdev->devfn);
-			printk("rev_id=%d) IRQ%d\n",
-				cyy_rev_id, cy_pci_irq);
-			printk("Cyclom-Y/PCI:found  winaddr=0x%lx "
-				"ctladdr=0x%lx\n",
-				(ulong)cy_pci_phys2,
-				(ulong)cy_pci_phys0);
-			printk("Cyclom-Y/PCI not supported for low "
-				"addresses in Alpha systems.\n");
+			dev_err(&pdev->dev, "Cyclom-Y/PCI not supported for "
+				"low addresses on Alpha systems.\n");
 			return -EIO;
 		}
 #endif
 		cy_pci_addr0 = pci_iomap(pdev, 0, CyPCI_Yctl);
 		cy_pci_addr2 = pci_iomap(pdev, 2, CyPCI_Ywin);
 
-#ifdef CY_PCI_DEBUG
-		printk("Cyclom-Y/PCI: relocate winaddr=0x%lx "
-			"ctladdr=0x%lx\n",
-			(u_long)cy_pci_addr2, (u_long)cy_pci_addr0);
-#endif
+		dev_dbg(&pdev->dev, "Cyclom-Y/PCI: relocate winaddr=0x%p "
+			"ctladdr=0x%p\n", cy_pci_addr2, cy_pci_addr0);
+
 		cy_pci_nchan = (unsigned short)(CyPORTS_PER_CHIP *
 				cyy_init_card(cy_pci_addr2, 1));
 		if (cy_pci_nchan == 0) {
-			printk("Cyclom-Y PCI host card with ");
-			printk("no Serial-Modules at 0x%lx.\n",
-				(ulong) cy_pci_phys2);
+			dev_err(&pdev->dev, "Cyclom-Y PCI host card with no "
+					"Serial-Modules\n");
 			return -EIO;
 		}
 		if ((cy_next_channel + cy_pci_nchan) > NR_PORTS) {
-			printk("Cyclom-Y/PCI found at 0x%lx ",
-				(ulong) cy_pci_phys2);
-			printk("but no channels are available.\n");
-			printk("Change NR_PORTS in cyclades.c and "
-					"recompile kernel.\n");
+			dev_err(&pdev->dev, "Cyclom-Y/PCI found, but no "
+				"channels are available. Change NR_PORTS in "
+				"cyclades.c and recompile kernel.\n");
 			return -EIO;
 		}
 		/* fill the next cy_card structure available */
@@ -5041,11 +5001,9 @@ static int __devinit cy_pci_probe(struct
 				break;
 		}
 		if (j == NR_CARDS) {	/* no more cy_cards available */
-			printk("Cyclom-Y/PCI found at 0x%lx ",
-				(ulong) cy_pci_phys2);
-			printk("but no more cards can be used.\n");
-			printk("Change NR_CARDS in cyclades.c and "
-					"recompile kernel.\n");
+			dev_err(&pdev->dev, "Cyclom-Y/PCI found, but no more "
+				"cards can be used. Change NR_CARDS in "
+				"cyclades.c and recompile kernel.\n");
 			return -EIO;
 		}
 
@@ -5053,10 +5011,7 @@ static int __devinit cy_pci_probe(struct
 		retval = request_irq(cy_pci_irq, cyy_interrupt,
 				IRQF_SHARED, "Cyclom-Y", &cy_card[j]);
 		if (retval) {
-			printk("Cyclom-Y/PCI found at 0x%lx ",
-				(ulong) cy_pci_phys2);
-			printk("but could not allocate IRQ%d.\n",
-				cy_pci_irq);
+			dev_err(&pdev->dev, "could not allocate IRQ\n");
 			return retval;
 		}
 
@@ -5096,37 +5051,22 @@ static int __devinit cy_pci_probe(struct
 			break;
 		}
 
-		/* print message */
-		printk("Cyclom-Y/PCI #%d: 0x%lx-0x%lx, IRQ%d, ",
-			j + 1, (ulong)cy_pci_phys2,
-			(ulong) (cy_pci_phys2 + CyPCI_Ywin - 1), cy_pci_irq);
-		printk("%d channels starting from port %d.\n",
-			cy_pci_nchan, cy_next_channel);
+		dev_info(&pdev->dev, "Cyclom-Y/PCI #%d found: %d channels "
+			"starting from port %d.\n", j + 1, cy_pci_nchan,
+			cy_next_channel);
+
 		for (j = cy_next_channel;
 				j < cy_next_channel + cy_pci_nchan; j++)
 			tty_register_device(cy_serial_driver, j, &pdev->dev);
 
 		cy_next_channel += cy_pci_nchan;
 	} else if (device_id == PCI_DEVICE_ID_CYCLOM_Z_Lo) {
-		/* print message */
-		printk("Cyclades-Z/PCI (bus=0x0%x, pci_id=0x%x, ",
-			pdev->bus->number, pdev->devfn);
-		printk("rev_id=%d) IRQ%d\n", cyy_rev_id, cy_pci_irq);
-		printk("Cyclades-Z/PCI: found winaddr=0x%lx "
-			"ctladdr=0x%lx\n",
-			(ulong)cy_pci_phys2, (ulong)cy_pci_phys0);
-		printk("Cyclades-Z/PCI not supported for low "
-			"addresses\n");
+		dev_err(&pdev->dev, "Cyclades-Z/PCI not supported for "
+			"low addresses\n");
 		return -EIO;
 	} else if (device_id == PCI_DEVICE_ID_CYCLOM_Z_Hi) {
-#ifdef CY_PCI_DEBUG
-		printk("Cyclades-Z/PCI (bus=0x0%x, pci_id=0x%x, ",
-			pdev->bus->number, pdev->devfn);
-		printk("rev_id=%d) IRQ%d\n", cyy_rev_id, cy_pci_irq);
-		printk("Cyclades-Z/PCI: found winaddr=0x%lx "
-			"ctladdr=0x%lx\n",
-			(ulong) cy_pci_phys2, (ulong) cy_pci_phys0);
-#endif
+		dev_dbg(&pdev->dev, "Cyclades-Z/PCI found\n");
+
 		cy_pci_addr0 = pci_iomap(pdev, 0, CyPCI_Zctl);
 
 		/* Disable interrupts on the PLX before resetting it */
@@ -5145,7 +5085,7 @@ static int __devinit cy_pci_probe(struct
 				cy_pci_addr0)->mail_box_0);
 
 		if (pci_resource_flags(pdev, 2) & IORESOURCE_IO) {
-			printk("  Warning: PCI I/O bit incorrectly "
+			dev_warn(&pdev->dev, "PCI I/O bit incorrectly "
 				"set. Ignoring it...\n");
 			pdev->resource[2].flags &= ~IORESOURCE_IO;
 		}
@@ -5155,8 +5095,7 @@ static int __devinit cy_pci_probe(struct
 		   with other drivers accessing it. */
 		retval = pci_request_regions(pdev, "Cyclades-Z");
 		if (retval) {
-			printk(KERN_ERR "cyclades: failed to reserve "
-				"PCI resources\n");
+			dev_err(&pdev->dev, "failed to reserve resources\n");
 			return retval;
 		}
 
@@ -5168,28 +5107,24 @@ static int __devinit cy_pci_probe(struct
 			cy_pci_addr2 = pci_iomap(pdev, 2, CyPCI_Zwin);
 		}
 
+		dev_dbg(&pdev->dev, "Cyclades-Z/PCI: relocate winaddr=0x%p "
+			"ctladdr=0x%p\n", cy_pci_addr2, cy_pci_addr0);
 #ifdef CY_PCI_DEBUG
-		printk("Cyclades-Z/PCI: relocate winaddr=0x%lx "
-			"ctladdr=0x%lx\n",
-			(ulong) cy_pci_addr2, (ulong) cy_pci_addr0);
 		if (mailbox == ZO_V1) {
 			cy_writel(&((struct RUNTIME_9060 *)
 				(cy_pci_addr0))->loc_addr_base,
 				WIN_CREG);
-			printk("Cyclades-8Zo/PCI: FPGA id %lx, ver "
-				"%lx\n", (ulong) (0xff &
-				readl(&((struct CUSTOM_REG *)
-					(cy_pci_addr2))->fpga_id)),
-				(ulong)(0xff &
+			dev_info(&pdev->dev, "Cyclades-8Zo/PCI: FPGA id %lx, "
+				"ver %lx\n", (ulong)(0xff &
 				readl(&((struct CUSTOM_REG *)
-					(cy_pci_addr2))->
-						fpga_version)));
+					cy_pci_addr2)->fpga_id)),
+				(ulong)(0xff & readl(&((struct CUSTOM_REG *)
+					cy_pci_addr2)->fpga_version)));
 			cy_writel(&((struct RUNTIME_9060 *)
-				(cy_pci_addr0))->loc_addr_base,
-				WIN_RAM);
+				cy_pci_addr0)->loc_addr_base, WIN_RAM);
 		} else {
-			printk("Cyclades-Z/PCI: New Cyclades-Z board.  "
-					"FPGA not loaded\n");
+			dev_info(&pdev->dev, "Cyclades-Z/PCI: New Cyclades-Z "
+				"board.  FPGA not loaded\n");
 		}
 #endif
 		/* The following clears the firmware id word.  This
@@ -5205,10 +5140,9 @@ static int __devinit cy_pci_probe(struct
 		cy_pci_nchan = 8;
 
 		if ((cy_next_channel + cy_pci_nchan) > NR_PORTS) {
-			printk("Cyclades-8Zo/PCI found at 0x%lx but"
-				"no channels are available.\nChange "
-				"NR_PORTS in cyclades.c and recompile "
-				"kernel.\n", (ulong)cy_pci_phys2);
+			dev_err(&pdev->dev, "Cyclades-8Zo/PCI found, but no "
+				"channels are available. Change NR_PORTS in "
+				"cyclades.c and recompile kernel.\n");
 			return -EIO;
 		}
 
@@ -5218,10 +5152,9 @@ static int __devinit cy_pci_probe(struct
 				break;
 		}
 		if (j == NR_CARDS) {	/* no more cy_cards available */
-			printk("Cyclades-8Zo/PCI found at 0x%lx but"
-				"no more cards can be used.\nChange "
-				"NR_CARDS in cyclades.c and recompile "
-				"kernel.\n", (ulong)cy_pci_phys2);
+			dev_err(&pdev->dev, "Cyclades-8Zo/PCI found, but no "
+				"more cards can be used. Change NR_CARDS in "
+				"cyclades.c and recompile kernel.\n");
 			return -EIO;
 		}
 #ifdef CONFIG_CYZ_INTR
@@ -5231,10 +5164,7 @@ static int __devinit cy_pci_probe(struct
 					IRQF_SHARED, "Cyclades-Z",
 					&cy_card[j]);
 			if (retval) {
-				printk("Cyclom-8Zo/PCI found at 0x%lx "
-					"but could not allocate "
-					"IRQ%d.\n", (ulong)cy_pci_phys2,
-					cy_pci_irq);
+				dev_err(&pdev->dev, "could not allocate IRQ\n");
 				return retval;
 			}
 		}
@@ -5250,22 +5180,10 @@ static int __devinit cy_pci_probe(struct
 		cy_init_card(&cy_card[j], j);
 		pci_set_drvdata(pdev, &cy_card[j]);
 
-		/* print message */
-#ifdef CONFIG_CYZ_INTR
-		/* don't report IRQ if board is no IRQ */
-		if ((cy_pci_irq != 0) && (cy_pci_irq != 255))
-			printk("Cyclades-8Zo/PCI #%d: 0x%lx-0x%lx, "
-				"IRQ%d, ", j + 1, (ulong)cy_pci_phys2,
-				(ulong) (cy_pci_phys2 + CyPCI_Zwin - 1),
-				cy_pci_irq);
-		else
-#endif				/* CONFIG_CYZ_INTR */
-			printk("Cyclades-8Zo/PCI #%d: 0x%lx-0x%lx, ",
-				j + 1, (ulong)cy_pci_phys2,
-				(ulong)(cy_pci_phys2 + CyPCI_Zwin - 1));
+		dev_info(&pdev->dev, "Cyclades-8Zo/PCI #%d found: %d channels "
+			"starting from port %d.\n", j + 1, cy_pci_nchan,
+			cy_next_channel);
 
-		printk("%d channels starting from port %d.\n",
-				cy_pci_nchan, cy_next_channel);
 		for (j = cy_next_channel;
 				j < cy_next_channel + cy_pci_nchan; j++)
 			tty_register_device(cy_serial_driver, j, &pdev->dev);
@@ -5320,16 +5238,6 @@ static struct pci_driver cy_pci_driver =
 };
 #endif
 
-/*
- * This routine prints out the appropriate serial driver version number
- * and identifies which options were configured into this driver.
- */
-static inline void show_version(void)
-{
-	printk("Cyclades driver " CY_VERSION "\n");
-	printk("        built %s %s\n", __DATE__, __TIME__);
-}				/* show_version */
-
 static int
 cyclades_get_proc_info(char *buf, char **start, off_t offset, int length,
 		int *eof, void *data)
@@ -5436,7 +5344,9 @@ static int __init cy_init(void)
 	cy_serial_driver = alloc_tty_driver(NR_PORTS);
 	if (!cy_serial_driver)
 		goto err;
-	show_version();
+
+	printk(KERN_INFO "Cyclades driver " CY_VERSION " (built %s %s)\n",
+			__DATE__, __TIME__);
 
 	/* Initialize the tty_driver structure */
 
@@ -5505,8 +5415,8 @@ static void __exit cy_cleanup_module(voi
 #endif /* CONFIG_CYZ_INTR */
 
 	if ((e1 = tty_unregister_driver(cy_serial_driver)))
-		printk("cyc: failed to unregister Cyclades serial driver(%d)\n",
-			e1);
+		printk(KERN_ERR "failed to unregister Cyclades serial "
+				"driver(%d)\n", e1);
 
 	put_tty_driver(cy_serial_driver);
 
_

Patches currently in -mm which might be from jirislaby@gmail.com are

origin.patch
git-dvb.patch
cinergyt2-fix-file-release-handler.patch
auerswald-fix-file-release-handler.patch
unify-queue_delayed_work-and-queue_delayed_work_on.patch
vmstat-use-our-own-timer-events-fix.patch
shrink_slab-handle-bad-shrinkers.patch
