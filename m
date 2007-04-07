From: akpm@linux-foundation.org
Subject: + char-cyclades-cy_readx-writex-cleanup.patch added to -mm tree
Date: Fri, 06 Apr 2007 17:14:16 -0700
Message-ID: <200704070014.l370EGjt023445@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:39911 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933584AbXDGAOj (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 6 Apr 2007 20:14:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jirislaby@gmail.com


The patch titled
     Char: cyclades, cy_readX/writeX cleanup
has been added to the -mm tree.  Its filename is
     char-cyclades-cy_readx-writex-cleanup.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Char: cyclades, cy_readX/writeX cleanup
From: Jiri Slaby <jirislaby@gmail.com>

cyclades, cy_readX/writeX cleanup

- cy_readX are placeholders for readX, remove it
- move cy_writeX macros into do {} while(0) to be safe

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/cyclades.c  |  315 +++++++++++++++++--------------------
 include/linux/cyclades.h |   10 -
 2 files changed, 153 insertions(+), 172 deletions(-)

diff -puN drivers/char/cyclades.c~char-cyclades-cy_readx-writex-cleanup drivers/char/cyclades.c
--- a/drivers/char/cyclades.c~char-cyclades-cy_readx-writex-cleanup
+++ a/drivers/char/cyclades.c
@@ -675,13 +675,13 @@ static void cy_send_xchar(struct tty_str
 #define IS_CYC_Z(card) ((card).num_chips == -1)
 
 #define Z_FPGA_CHECK(card) \
-	((cy_readl(&((struct RUNTIME_9060 __iomem *) \
+	((readl(&((struct RUNTIME_9060 __iomem *) \
 		((card).ctl_addr))->init_ctrl) & (1<<17)) != 0)
 
-#define ISZLOADED(card)	(((ZO_V1==cy_readl(&((struct RUNTIME_9060 __iomem *) \
+#define ISZLOADED(card)	(((ZO_V1==readl(&((struct RUNTIME_9060 __iomem *) \
 			((card).ctl_addr))->mail_box_0)) || \
 			Z_FPGA_CHECK(card)) && \
-			(ZFIRM_ID==cy_readl(&((struct FIRM_ID __iomem *) \
+			(ZFIRM_ID==readl(&((struct FIRM_ID __iomem *) \
 			((card).base_addr+ID_ADDRESS))->signature)))
 
 #ifndef SERIAL_XMIT_SIZE
@@ -972,7 +972,7 @@ static int cyy_issue_cmd(void __iomem * 
 
 	/* Check to see that the previous command has completed */
 	for (i = 0; i < 100; i++) {
-		if (cy_readb(base_addr + (CyCCR << index)) == 0) {
+		if (readb(base_addr + (CyCCR << index)) == 0) {
 			break;
 		}
 		udelay(10L);
@@ -1015,7 +1015,7 @@ static unsigned detect_isa_irq(void __io
 
 	cy_writeb(address + (CyCAR << index), 0);
 	cy_writeb(address + (CySRER << index),
-		  cy_readb(address + (CySRER << index)) | CyTxRdy);
+		  readb(address + (CySRER << index)) | CyTxRdy);
 	local_irq_restore(flags);
 
 	/* Wait ... */
@@ -1025,11 +1025,11 @@ static unsigned detect_isa_irq(void __io
 	irq = probe_irq_off(irqs);
 
 	/* Clean up */
-	save_xir = (u_char) cy_readb(address + (CyTIR << index));
-	save_car = cy_readb(address + (CyCAR << index));
+	save_xir = (u_char) readb(address + (CyTIR << index));
+	save_car = readb(address + (CyCAR << index));
 	cy_writeb(address + (CyCAR << index), (save_xir & 0x3));
 	cy_writeb(address + (CySRER << index),
-		  cy_readb(address + (CySRER << index)) & ~CyTxRdy);
+		  readb(address + (CySRER << index)) & ~CyTxRdy);
 	cy_writeb(address + (CyTIR << index), (save_xir & 0x3f));
 	cy_writeb(address + (CyCAR << index), (save_car));
 	cy_writeb(address + (Cy_ClrIntr << index), 0);
@@ -1055,34 +1055,34 @@ static void cyy_intr_chip(struct cyclade
 #endif
 		/* determine the channel & change to that context */
 		spin_lock(&cinfo->card_lock);
-		save_xir = (u_char) cy_readb(base_addr + (CyRIR << index));
+		save_xir = (u_char) readb(base_addr + (CyRIR << index));
 		channel = (u_short) (save_xir & CyIRChannel);
 		i = channel + chip * 4 + cinfo->first_line;
 		info = &cy_port[i];
 		info->last_active = jiffies;
-		save_car = cy_readb(base_addr + (CyCAR << index));
+		save_car = readb(base_addr + (CyCAR << index));
 		cy_writeb(base_addr + (CyCAR << index), save_xir);
 
 		/* if there is nowhere to put the data, discard it */
 		if (info->tty == 0) {
-			j = (cy_readb(base_addr + (CyRIVR << index)) &
+			j = (readb(base_addr + (CyRIVR << index)) &
 				CyIVRMask);
 			if (j == CyIVRRxEx) {	/* exception */
-				data = cy_readb(base_addr + (CyRDSR << index));
+				data = readb(base_addr + (CyRDSR << index));
 			} else {	/* normal character reception */
-				char_count = cy_readb(base_addr +
+				char_count = readb(base_addr +
 						(CyRDCR << index));
 				while (char_count--) {
-					data = cy_readb(base_addr +
+					data = readb(base_addr +
 						(CyRDSR << index));
 				}
 			}
 		} else {	/* there is an open port for this data */
 			tty = info->tty;
-			j = (cy_readb(base_addr + (CyRIVR << index)) &
+			j = (readb(base_addr + (CyRIVR << index)) &
 					CyIVRMask);
 			if (j == CyIVRRxEx) {	/* exception */
-				data = cy_readb(base_addr + (CyRDSR << index));
+				data = readb(base_addr + (CyRDSR << index));
 
 				/* For statistics only */
 				if (data & CyBREAK)
@@ -1103,7 +1103,7 @@ static void cyy_intr_chip(struct cyclade
 						if (data & CyBREAK) {
 							tty_insert_flip_char(
 								tty,
-								cy_readb(
+								readb(
 								base_addr +
 								(CyRDSR <<
 									index)),
@@ -1116,7 +1116,7 @@ static void cyy_intr_chip(struct cyclade
 						} else if (data & CyFRAME) {
 							tty_insert_flip_char(
 								tty,
-								cy_readb(
+								readb(
 								base_addr +
 								(CyRDSR <<
 									index)),
@@ -1128,7 +1128,7 @@ static void cyy_intr_chip(struct cyclade
 							/* Pieces of seven... */
 							tty_insert_flip_char(
 								tty,
-								cy_readb(
+								readb(
 								base_addr +
 								(CyRDSR <<
 									index)),
@@ -1147,7 +1147,7 @@ static void cyy_intr_chip(struct cyclade
 						 */
 							tty_insert_flip_char(
 								tty,
-								cy_readb(
+								readb(
 								base_addr +
 								(CyRDSR <<
 									index)),
@@ -1179,7 +1179,7 @@ static void cyy_intr_chip(struct cyclade
 				}
 			} else {	/* normal character reception */
 				/* load # chars available from the chip */
-				char_count = cy_readb(base_addr +
+				char_count = readb(base_addr +
 						(CyRDCR << index));
 
 #ifdef CY_ENABLE_MONITORING
@@ -1191,7 +1191,7 @@ static void cyy_intr_chip(struct cyclade
 #endif
 				len = tty_buffer_request_room(tty, char_count);
 				while (len--) {
-					data = cy_readb(base_addr +
+					data = readb(base_addr +
 							(CyRDSR << index));
 					tty_insert_flip_char(tty, data,
 							TTY_NORMAL);
@@ -1221,16 +1221,16 @@ static void cyy_intr_chip(struct cyclade
 
 		/* determine the channel & change to that context */
 		spin_lock(&cinfo->card_lock);
-		save_xir = (u_char) cy_readb(base_addr + (CyTIR << index));
+		save_xir = (u_char) readb(base_addr + (CyTIR << index));
 		channel = (u_short) (save_xir & CyIRChannel);
 		i = channel + chip * 4 + cinfo->first_line;
-		save_car = cy_readb(base_addr + (CyCAR << index));
+		save_car = readb(base_addr + (CyCAR << index));
 		cy_writeb(base_addr + (CyCAR << index), save_xir);
 
 		/* validate the port# (as configured and open) */
 		if ((i < 0) || (NR_PORTS <= i)) {
 			cy_writeb(base_addr + (CySRER << index),
-				  cy_readb(base_addr + (CySRER << index)) &
+				  readb(base_addr + (CySRER << index)) &
 				  ~CyTxRdy);
 			goto txend;
 		}
@@ -1238,7 +1238,7 @@ static void cyy_intr_chip(struct cyclade
 		info->last_active = jiffies;
 		if (info->tty == 0) {
 			cy_writeb(base_addr + (CySRER << index),
-				  cy_readb(base_addr + (CySRER << index)) &
+				  readb(base_addr + (CySRER << index)) &
 				  ~CyTxRdy);
 			goto txdone;
 		}
@@ -1271,15 +1271,15 @@ static void cyy_intr_chip(struct cyclade
 
 		while (char_count-- > 0) {
 			if (!info->xmit_cnt) {
-				if (cy_readb(base_addr + (CySRER << index)) &
+				if (readb(base_addr + (CySRER << index)) &
 						CyTxMpty) {
 					cy_writeb(base_addr + (CySRER << index),
-						cy_readb(base_addr +
+						readb(base_addr +
 							(CySRER << index)) &
 						~CyTxMpty);
 				} else {
 					cy_writeb(base_addr + (CySRER << index),
-						(cy_readb(base_addr +
+						(readb(base_addr +
 						  	(CySRER << index)) &
 						~CyTxRdy) | CyTxMpty);
 				}
@@ -1287,13 +1287,13 @@ static void cyy_intr_chip(struct cyclade
 			}
 			if (info->xmit_buf == 0) {
 				cy_writeb(base_addr + (CySRER << index),
-					cy_readb(base_addr + (CySRER << index))&
+					readb(base_addr + (CySRER << index)) &
 					~CyTxRdy);
 				goto txdone;
 			}
 			if (info->tty->stopped || info->tty->hw_stopped) {
 				cy_writeb(base_addr + (CySRER << index),
-					cy_readb(base_addr + (CySRER << index))&
+					readb(base_addr + (CySRER << index)) &
 					~CyTxRdy);
 				goto txdone;
 			}
@@ -1346,15 +1346,15 @@ txend:
 
 		/* determine the channel & change to that context */
 		spin_lock(&cinfo->card_lock);
-		save_xir = (u_char) cy_readb(base_addr + (CyMIR << index));
+		save_xir = (u_char) readb(base_addr + (CyMIR << index));
 		channel = (u_short) (save_xir & CyIRChannel);
 		info = &cy_port[channel + chip * 4 + cinfo->first_line];
 		info->last_active = jiffies;
-		save_car = cy_readb(base_addr + (CyCAR << index));
+		save_car = readb(base_addr + (CyCAR << index));
 		cy_writeb(base_addr + (CyCAR << index), save_xir);
 
-		mdm_change = cy_readb(base_addr + (CyMISR << index));
-		mdm_status = cy_readb(base_addr + (CyMSVR1 << index));
+		mdm_change = readb(base_addr + (CyMISR << index));
+		mdm_status = readb(base_addr + (CyMSVR1 << index));
 
 		if (info->tty == 0) {	/* no place for data, ignore it */
 			;
@@ -1391,7 +1391,7 @@ txend:
 						info->tty->hw_stopped = 0;
 						cy_writeb(base_addr +
 							(CySRER << index),
-							cy_readb(base_addr +
+							readb(base_addr +
 								(CySRER <<
 									index))|
 							CyTxRdy);
@@ -1405,7 +1405,7 @@ txend:
 						info->tty->hw_stopped = 1;
 						cy_writeb(base_addr +
 							(CySRER << index),
-							cy_readb(base_addr +
+							readb(base_addr +
 								(CySRER <<
 								index)) &
 							~CyTxRdy);
@@ -1459,7 +1459,7 @@ static irqreturn_t cyy_interrupt(int irq
 			base_addr = cinfo->base_addr +
 					(cy_chip_offset[chip] << index);
 			too_many = 0;
-			while ((status = cy_readb(base_addr +
+			while ((status = readb(base_addr +
 						(CySVRR << index))) != 0x00) {
 				had_work++;
 			/* The purpose of the following test is to ensure that
@@ -1502,16 +1502,15 @@ cyz_fetch_msg(struct cyclades_card *cinf
 	if (!ISZLOADED(*cinfo)) {
 		return -1;
 	}
-	zfw_ctrl = cinfo->base_addr + (cy_readl(&firm_id->zfwctrl_addr) &
-			0xfffff);
+	zfw_ctrl = cinfo->base_addr + (readl(&firm_id->zfwctrl_addr) & 0xfffff);
 	board_ctrl = &zfw_ctrl->board_ctrl;
 
-	loc_doorbell = cy_readl(&((struct RUNTIME_9060 __iomem *)
+	loc_doorbell = readl(&((struct RUNTIME_9060 __iomem *)
 				  (cinfo->ctl_addr))->loc_doorbell);
 	if (loc_doorbell) {
 		*cmd = (char)(0xff & loc_doorbell);
-		*channel = cy_readl(&board_ctrl->fwcmd_channel);
-		*param = (__u32) cy_readl(&board_ctrl->fwcmd_param);
+		*channel = readl(&board_ctrl->fwcmd_channel);
+		*param = (__u32) readl(&board_ctrl->fwcmd_param);
 		cy_writel(&((struct RUNTIME_9060 __iomem *)(cinfo->ctl_addr))->
 			  loc_doorbell, 0xffffffff);
 		return 1;
@@ -1533,16 +1532,15 @@ cyz_issue_cmd(struct cyclades_card *cinf
 	if (!ISZLOADED(*cinfo)) {
 		return -1;
 	}
-	zfw_ctrl = cinfo->base_addr + (cy_readl(&firm_id->zfwctrl_addr) &
-			0xfffff);
+	zfw_ctrl = cinfo->base_addr + (readl(&firm_id->zfwctrl_addr) & 0xfffff);
 	board_ctrl = &zfw_ctrl->board_ctrl;
 
 	index = 0;
 	pci_doorbell =
 	    &((struct RUNTIME_9060 __iomem *)(cinfo->ctl_addr))->pci_doorbell;
-	while ((cy_readl(pci_doorbell) & 0xff) != 0) {
+	while ((readl(pci_doorbell) & 0xff) != 0) {
 		if (index++ == 1000) {
-			return (int)(cy_readl(pci_doorbell) & 0xff);
+			return (int)(readl(pci_doorbell) & 0xff);
 		}
 		udelay(50L);
 	}
@@ -1569,10 +1567,10 @@ cyz_handle_rx(struct cyclades_port *info
 #endif
 	volatile __u32 rx_put, rx_get, new_rx_get, rx_bufsize, rx_bufaddr;
 
-	rx_get = new_rx_get = cy_readl(&buf_ctrl->rx_get);
-	rx_put = cy_readl(&buf_ctrl->rx_put);
-	rx_bufsize = cy_readl(&buf_ctrl->rx_bufsize);
-	rx_bufaddr = cy_readl(&buf_ctrl->rx_bufaddr);
+	rx_get = new_rx_get = readl(&buf_ctrl->rx_get);
+	rx_put = readl(&buf_ctrl->rx_put);
+	rx_bufsize = readl(&buf_ctrl->rx_bufsize);
+	rx_bufaddr = readl(&buf_ctrl->rx_bufaddr);
 	if (rx_put >= rx_get)
 		char_count = rx_put - rx_get;
 	else
@@ -1622,7 +1620,7 @@ cyz_handle_rx(struct cyclades_port *info
 #else
 			len = tty_buffer_request_room(tty, char_count);
 			while (len--) {
-				data = cy_readb(cinfo->base_addr + rx_bufaddr +
+				data = readb(cinfo->base_addr + rx_bufaddr +
 						new_rx_get);
 				new_rx_get = (new_rx_get + 1)& (rx_bufsize - 1);
 				tty_insert_flip_char(tty, data, TTY_NORMAL);
@@ -1633,13 +1631,12 @@ cyz_handle_rx(struct cyclades_port *info
 #ifdef CONFIG_CYZ_INTR
 		/* Recalculate the number of chars in the RX buffer and issue
 		   a cmd in case it's higher than the RX high water mark */
-			rx_put = cy_readl(&buf_ctrl->rx_put);
+			rx_put = readl(&buf_ctrl->rx_put);
 			if (rx_put >= rx_get)
 				char_count = rx_put - rx_get;
 			else
 				char_count = rx_put - rx_get + rx_bufsize;
-			if (char_count >= (int)cy_readl(&buf_ctrl->
-					rx_threshold)) {
+			if (char_count >= (int)readl(&buf_ctrl->rx_threshold)) {
 				cy_sched_event(info, Cy_EVENT_Z_RX_FULL);
 			}
 #endif
@@ -1668,10 +1665,10 @@ cyz_handle_tx(struct cyclades_port *info
 	if (info->xmit_cnt <= 0)	/* Nothing to transmit */
 		return;
 
-	tx_get = cy_readl(&buf_ctrl->tx_get);
-	tx_put = cy_readl(&buf_ctrl->tx_put);
-	tx_bufsize = cy_readl(&buf_ctrl->tx_bufsize);
-	tx_bufaddr = cy_readl(&buf_ctrl->tx_bufaddr);
+	tx_get = readl(&buf_ctrl->tx_get);
+	tx_put = readl(&buf_ctrl->tx_put);
+	tx_bufsize = readl(&buf_ctrl->tx_bufsize);
+	tx_bufaddr = readl(&buf_ctrl->tx_bufaddr);
 	if (tx_put >= tx_get)
 		char_count = tx_get - tx_put - 1 + tx_bufsize;
 	else
@@ -1756,11 +1753,10 @@ static void cyz_handle_cmd(struct cyclad
 	int delta_count;
 
 	firm_id = cinfo->base_addr + ID_ADDRESS;
-	zfw_ctrl = cinfo->base_addr + (cy_readl(&firm_id->zfwctrl_addr) &
-			0xfffff);
+	zfw_ctrl = cinfo->base_addr + (readl(&firm_id->zfwctrl_addr) & 0xfffff);
 	board_ctrl = &zfw_ctrl->board_ctrl;
-	fw_ver = cy_readl(&board_ctrl->fw_version);
-	hw_ver = cy_readl(&((struct RUNTIME_9060 __iomem *)(cinfo->ctl_addr))->
+	fw_ver = readl(&board_ctrl->fw_version);
+	hw_ver = readl(&((struct RUNTIME_9060 __iomem *)(cinfo->ctl_addr))->
 			mail_box_0);
 
 	while (cyz_fetch_msg(cinfo, &channel, &cmd, &param) == 1) {
@@ -1794,7 +1790,7 @@ static void cyz_handle_cmd(struct cyclad
 			delta_count++;
 			if (info->flags & ASYNC_CHECK_CD) {
 				if ((fw_ver > 241 ? ((u_long) param) :
-						cy_readl(&ch_ctrl->rs_status)) &
+						readl(&ch_ctrl->rs_status)) &
 						C_RS_DCD) {
 					cy_sched_event(info,
 						 	Cy_EVENT_OPEN_WAKEUP);
@@ -1923,12 +1919,12 @@ static void cyz_poll(unsigned long arg)
 
 		firm_id = cinfo->base_addr + ID_ADDRESS;
 		zfw_ctrl = cinfo->base_addr +
-				(cy_readl(&firm_id->zfwctrl_addr) & 0xfffff);
+				(readl(&firm_id->zfwctrl_addr) & 0xfffff);
 		board_ctrl = &(zfw_ctrl->board_ctrl);
 
 	/* Skip first polling cycle to avoid racing conditions with the FW */
 		if (!cinfo->intr_enabled) {
-			cinfo->nports = (int)cy_readl(&board_ctrl->n_channel);
+			cinfo->nports = (int)readl(&board_ctrl->n_channel);
 			cinfo->intr_enabled = 1;
 			continue;
 		}
@@ -2029,12 +2025,12 @@ static int startup(struct cyclades_port 
 #ifdef CY_DEBUG_DTR
 		printk("cyc:startup raising DTR\n");
 		printk("     status: 0x%x, 0x%x\n",
-			cy_readb(base_addr + (CyMSVR1 << index)),
-			cy_readb(base_addr + (CyMSVR2 << index)));
+			readb(base_addr + (CyMSVR1 << index)),
+			readb(base_addr + (CyMSVR2 << index)));
 #endif
 
 		cy_writeb(base_addr + (CySRER << index),
-			cy_readb(base_addr + (CySRER << index)) | CyRxData);
+			readb(base_addr + (CySRER << index)) | CyRxData);
 		info->flags |= ASYNC_INITIALIZED;
 
 		if (info->tty) {
@@ -2064,7 +2060,7 @@ static int startup(struct cyclades_port 
 		}
 
 		zfw_ctrl = cy_card[card].base_addr +
-				(cy_readl(&firm_id->zfwctrl_addr) & 0xfffff);
+				(readl(&firm_id->zfwctrl_addr) & 0xfffff);
 		board_ctrl = &zfw_ctrl->board_ctrl;
 		ch_ctrl = zfw_ctrl->ch_ctrl;
 
@@ -2112,7 +2108,7 @@ static int startup(struct cyclades_port 
 		/* set timeout !!! */
 		/* set RTS and DTR !!! */
 		cy_writel(&ch_ctrl[channel].rs_control,
-			cy_readl(&ch_ctrl[channel].rs_control) | C_RS_RTS |
+			readl(&ch_ctrl[channel].rs_control) | C_RS_RTS |
 			C_RS_DTR);
 		retval = cyz_issue_cmd(&cy_card[info->card], channel,
 				C_CM_IOCTLM, 0L);
@@ -2168,7 +2164,7 @@ static void start_xmit(struct cyclades_p
 		CY_LOCK(info, flags);
 		cy_writeb(base_addr + (CyCAR << index), channel);
 		cy_writeb(base_addr + (CySRER << index),
-			cy_readb(base_addr + (CySRER << index)) | CyTxRdy);
+			readb(base_addr + (CySRER << index)) | CyTxRdy);
 		CY_UNLOCK(info, flags);
 	} else {
 #ifdef CONFIG_CYZ_INTR
@@ -2235,8 +2231,8 @@ static void shutdown(struct cyclades_por
 #ifdef CY_DEBUG_DTR
 			printk("cyc shutdown dropping DTR\n");
 			printk("     status: 0x%x, 0x%x\n",
-				cy_readb(base_addr + (CyMSVR1 << index)),
-				cy_readb(base_addr + (CyMSVR2 << index)));
+				readb(base_addr + (CyMSVR1 << index)),
+				readb(base_addr + (CyMSVR2 << index)));
 #endif
 		}
 		cyy_issue_cmd(base_addr, CyCHAN_CTL | CyDIS_RCVR, index);
@@ -2267,7 +2263,7 @@ static void shutdown(struct cyclades_por
 		}
 
 		zfw_ctrl = cy_card[card].base_addr +
-				(cy_readl(&firm_id->zfwctrl_addr) & 0xfffff);
+				(readl(&firm_id->zfwctrl_addr) & 0xfffff);
 		board_ctrl = &zfw_ctrl->board_ctrl;
 		ch_ctrl = zfw_ctrl->ch_ctrl;
 
@@ -2282,7 +2278,7 @@ static void shutdown(struct cyclades_por
 
 		if (!info->tty || (info->tty->termios->c_cflag & HUPCL)) {
 			cy_writel(&ch_ctrl[channel].rs_control,
-				(__u32)(cy_readl(&ch_ctrl[channel].rs_control)&
+				(__u32)(readl(&ch_ctrl[channel].rs_control) &
 					~(C_RS_RTS | C_RS_DTR)));
 			retval = cyz_issue_cmd(&cy_card[info->card], channel,
 					C_CM_IOCTLM, 0L);
@@ -2390,10 +2386,8 @@ block_til_ready(struct tty_struct *tty, 
 #ifdef CY_DEBUG_DTR
 				printk("cyc:block_til_ready raising DTR\n");
 				printk("     status: 0x%x, 0x%x\n",
-					cy_readb(base_addr +
-						(CyMSVR1 << index)),
-					cy_readb(base_addr +
-						(CyMSVR2 << index)));
+					readb(base_addr + (CyMSVR1 << index)),
+					readb(base_addr + (CyMSVR2 << index)));
 #endif
 			}
 			CY_UNLOCK(info, flags);
@@ -2410,7 +2404,7 @@ block_til_ready(struct tty_struct *tty, 
 			cy_writeb(base_addr + (CyCAR << index),
 				  (u_char) channel);
 			if (!(info->flags & ASYNC_CLOSING) && (C_CLOCAL(tty) ||
-					(cy_readb(base_addr +
+					(readb(base_addr +
 						(CyMSVR1 << index)) & CyDCD))) {
 				CY_UNLOCK(info, flags);
 				break;
@@ -2444,19 +2438,17 @@ block_til_ready(struct tty_struct *tty, 
 			return -EINVAL;
 		}
 
-		zfw_ctrl = base_addr + (cy_readl(&firm_id->zfwctrl_addr) &
-				0xfffff);
+		zfw_ctrl = base_addr + (readl(&firm_id->zfwctrl_addr)& 0xfffff);
 		board_ctrl = &zfw_ctrl->board_ctrl;
 		ch_ctrl = zfw_ctrl->ch_ctrl;
 
 		while (1) {
 			if ((tty->termios->c_cflag & CBAUD)) {
 				cy_writel(&ch_ctrl[channel].rs_control,
-					  cy_readl(&ch_ctrl[channel].
-						   rs_control) | (C_RS_RTS |
-								  C_RS_DTR));
+					readl(&ch_ctrl[channel].rs_control) |
+					C_RS_RTS | C_RS_DTR);
 				retval = cyz_issue_cmd(&cy_card[info->card],
-						channel, C_CM_IOCTLM, 0L);
+					channel, C_CM_IOCTLM, 0L);
 				if (retval != 0) {
 					printk("cyc:block_til_ready retval on "
 						"ttyC%d was %x\n",
@@ -2475,7 +2467,7 @@ block_til_ready(struct tty_struct *tty, 
 				break;
 			}
 			if (!(info->flags & ASYNC_CLOSING) && (C_CLOCAL(tty) ||
-					(cy_readl(&ch_ctrl[channel].rs_status) &
+					(readl(&ch_ctrl[channel].rs_status) &
 						C_RS_DCD))) {
 				break;
 			}
@@ -2540,11 +2532,10 @@ static int cy_open(struct tty_struct *tt
 		struct FIRM_ID __iomem *firm_id = cinfo->base_addr + ID_ADDRESS;
 
 		if (!ISZLOADED(*cinfo)) {
-			if (((ZE_V1 == cy_readl(
-					&((struct RUNTIME_9060 __iomem *)
+			if (((ZE_V1 == readl(&((struct RUNTIME_9060 __iomem *)
 					 (cinfo->ctl_addr))->mail_box_0)) &&
 					Z_FPGA_CHECK(*cinfo)) &&
-					(ZFIRM_HLT == cy_readl(
+					(ZFIRM_HLT == readl(
 						&firm_id->signature))) {
 				printk("cyc:Cyclades-Z Error: you need an "
 					"external power supply for this number "
@@ -2565,15 +2556,14 @@ static int cy_open(struct tty_struct *tt
 				struct BOARD_CTRL __iomem *board_ctrl;
 
 				zfw_ctrl = cinfo->base_addr +
-					(cy_readl(&firm_id->zfwctrl_addr) &
-						0xfffff);
+					(readl(&firm_id->zfwctrl_addr) &
+					 0xfffff);
 
 				board_ctrl = &zfw_ctrl->board_ctrl;
 
 				/* Enable interrupts on the PLX chip */
 				cy_writew(cinfo->ctl_addr + 0x68,
-					  cy_readw(cinfo->ctl_addr +
-						   0x68) | 0x0900);
+					readw(cinfo->ctl_addr + 0x68) | 0x0900);
 				/* Enable interrupts on the FW */
 				retval = cyz_issue_cmd(cinfo, 0,
 						C_CM_IRQ_ENBL, 0L);
@@ -2582,7 +2572,7 @@ static int cy_open(struct tty_struct *tt
 						retval);
 				}
 				cinfo->nports =
-					(int)cy_readl(&board_ctrl->n_channel);
+					(int)readl(&board_ctrl->n_channel);
 				cinfo->intr_enabled = 1;
 			}
 		}
@@ -2701,7 +2691,7 @@ static void cy_wait_until_sent(struct tt
 		index = cy_card[card].bus_index;
 		base_addr =
 		    cy_card[card].base_addr + (cy_chip_offset[chip] << index);
-		while (cy_readb(base_addr + (CySRER << index)) & CyTxRdy) {
+		while (readb(base_addr + (CySRER << index)) & CyTxRdy) {
 #ifdef CY_DEBUG_WAIT_UNTIL_SENT
 			printk("Not clean (jiff=%lu)...", jiffies);
 #endif
@@ -2794,7 +2784,7 @@ static void cy_close(struct tty_struct *
 		channel &= 0x03;
 		cy_writeb(base_addr + (CyCAR << index), (u_char) channel);
 		cy_writeb(base_addr + (CySRER << index),
-			  cy_readb(base_addr + (CySRER << index)) & ~CyRxData);
+			  readb(base_addr + (CySRER << index)) & ~CyRxData);
 		if (info->flags & ASYNC_INITIALIZED) {
 			/* Waiting for on-board buffers to be empty before closing
 			   the port */
@@ -2808,12 +2798,12 @@ static void cy_close(struct tty_struct *
 		void __iomem *base_addr = cy_card[info->card].base_addr;
 		struct FIRM_ID __iomem *firm_id = base_addr + ID_ADDRESS;
 		struct ZFW_CTRL __iomem *zfw_ctrl =
-		    base_addr + (cy_readl(&firm_id->zfwctrl_addr) & 0xfffff);
+		    base_addr + (readl(&firm_id->zfwctrl_addr) & 0xfffff);
 		struct CH_CTRL __iomem *ch_ctrl = zfw_ctrl->ch_ctrl;
 		int channel = info->line - cy_card[info->card].first_line;
 		int retval;
 
-		if (cy_readl(&ch_ctrl[channel].flow_status) != C_FS_TXIDLE) {
+		if (readl(&ch_ctrl[channel].flow_status) != C_FS_TXIDLE) {
 			retval = cyz_issue_cmd(&cy_card[info->card], channel,
 						C_CM_IOCTLW, 0L);
 			if (retval != 0) {
@@ -3023,13 +3013,13 @@ static int cy_chars_in_buffer(struct tty
 
 		firm_id = cy_card[card].base_addr + ID_ADDRESS;
 		zfw_ctrl = cy_card[card].base_addr +
-			(cy_readl(&firm_id->zfwctrl_addr) & 0xfffff);
+			(readl(&firm_id->zfwctrl_addr) & 0xfffff);
 		ch_ctrl = &(zfw_ctrl->ch_ctrl[channel]);
 		buf_ctrl = &(zfw_ctrl->buf_ctrl[channel]);
 
-		tx_get = cy_readl(&buf_ctrl->tx_get);
-		tx_put = cy_readl(&buf_ctrl->tx_put);
-		tx_bufsize = cy_readl(&buf_ctrl->tx_bufsize);
+		tx_get = readl(&buf_ctrl->tx_get);
+		tx_put = readl(&buf_ctrl->tx_put);
+		tx_bufsize = readl(&buf_ctrl->tx_bufsize);
 		if (tx_put >= tx_get)
 			char_count = tx_put - tx_get;
 		else
@@ -3269,8 +3259,7 @@ static void set_line_char(struct cyclade
 		if (C_CLOCAL(info->tty)) {
 			/* without modem intr */
 			cy_writeb(base_addr + (CySRER << index),
-				  cy_readb(base_addr +
-					   (CySRER << index)) | CyMdmCh);
+				readb(base_addr + (CySRER << index)) | CyMdmCh);
 			/* act on 1->0 modem transitions */
 			if ((cflag & CRTSCTS) && info->rflow) {
 				cy_writeb(base_addr + (CyMCOR1 << index),
@@ -3284,7 +3273,7 @@ static void set_line_char(struct cyclade
 		} else {
 			/* without modem intr */
 			cy_writeb(base_addr + (CySRER << index),
-				  cy_readb(base_addr +
+				  readb(base_addr +
 					   (CySRER << index)) | CyMdmCh);
 			/* act on 1->0 modem transitions */
 			if ((cflag & CRTSCTS) && info->rflow) {
@@ -3311,8 +3300,8 @@ static void set_line_char(struct cyclade
 #ifdef CY_DEBUG_DTR
 			printk("cyc:set_line_char dropping DTR\n");
 			printk("     status: 0x%x, 0x%x\n",
-				cy_readb(base_addr + (CyMSVR1 << index)),
-				cy_readb(base_addr + (CyMSVR2 << index)));
+				readb(base_addr + (CyMSVR1 << index)),
+				readb(base_addr + (CyMSVR2 << index)));
 #endif
 		} else {
 			if (info->rtsdtr_inv) {
@@ -3325,8 +3314,8 @@ static void set_line_char(struct cyclade
 #ifdef CY_DEBUG_DTR
 			printk("cyc:set_line_char raising DTR\n");
 			printk("     status: 0x%x, 0x%x\n",
-				cy_readb(base_addr + (CyMSVR1 << index)),
-				cy_readb(base_addr + (CyMSVR2 << index)));
+				readb(base_addr + (CyMSVR1 << index)),
+				readb(base_addr + (CyMSVR2 << index)));
 #endif
 		}
 
@@ -3350,7 +3339,7 @@ static void set_line_char(struct cyclade
 		}
 
 		zfw_ctrl = cy_card[card].base_addr +
-			(cy_readl(&firm_id->zfwctrl_addr) & 0xfffff);
+			(readl(&firm_id->zfwctrl_addr) & 0xfffff);
 		board_ctrl = &zfw_ctrl->board_ctrl;
 		ch_ctrl = &(zfw_ctrl->ch_ctrl[channel]);
 		buf_ctrl = &zfw_ctrl->buf_ctrl[channel];
@@ -3401,10 +3390,10 @@ static void set_line_char(struct cyclade
 		}
 		if (cflag & CSTOPB) {
 			cy_writel(&ch_ctrl->comm_data_l,
-				  cy_readl(&ch_ctrl->comm_data_l) | C_DL_2STOP);
+				  readl(&ch_ctrl->comm_data_l) | C_DL_2STOP);
 		} else {
 			cy_writel(&ch_ctrl->comm_data_l,
-				  cy_readl(&ch_ctrl->comm_data_l) | C_DL_1STOP);
+				  readl(&ch_ctrl->comm_data_l) | C_DL_1STOP);
 		}
 		if (cflag & PARENB) {
 			if (cflag & PARODD) {
@@ -3419,12 +3408,10 @@ static void set_line_char(struct cyclade
 		/* CTS flow control flag */
 		if (cflag & CRTSCTS) {
 			cy_writel(&ch_ctrl->hw_flow,
-				  cy_readl(&ch_ctrl->
-					   hw_flow) | C_RS_CTS | C_RS_RTS);
+				readl(&ch_ctrl->hw_flow) | C_RS_CTS | C_RS_RTS);
 		} else {
-			cy_writel(&ch_ctrl->hw_flow,
-				  cy_readl(&ch_ctrl->
-					   hw_flow) & ~(C_RS_CTS | C_RS_RTS));
+			cy_writel(&ch_ctrl->hw_flow, readl(&ch_ctrl->hw_flow) &
+					~(C_RS_CTS | C_RS_RTS));
 		}
 		/* As the HW flow control is done in firmware, the driver
 		   doesn't need to care about it */
@@ -3454,13 +3441,13 @@ static void set_line_char(struct cyclade
 
 		if (baud == 0) {	/* baud rate is zero, turn off line */
 			cy_writel(&ch_ctrl->rs_control,
-				  cy_readl(&ch_ctrl->rs_control) & ~C_RS_DTR);
+				  readl(&ch_ctrl->rs_control) & ~C_RS_DTR);
 #ifdef CY_DEBUG_DTR
 			printk("cyc:set_line_char dropping Z DTR\n");
 #endif
 		} else {
 			cy_writel(&ch_ctrl->rs_control,
-				  cy_readl(&ch_ctrl->rs_control) | C_RS_DTR);
+				  readl(&ch_ctrl->rs_control) | C_RS_DTR);
 #ifdef CY_DEBUG_DTR
 			printk("cyc:set_line_char raising Z DTR\n");
 #endif
@@ -3575,7 +3562,7 @@ static int get_lsr_info(struct cyclades_
 		    cy_card[card].base_addr + (cy_chip_offset[chip] << index);
 
 		CY_LOCK(info, flags);
-		status = cy_readb(base_addr + (CySRER << index)) &
+		status = readb(base_addr + (CySRER << index)) &
 				(CyTxRdy | CyTxMpty);
 		CY_UNLOCK(info, flags);
 		result = (status ? 0 : TIOCSER_TEMT);
@@ -3614,8 +3601,8 @@ static int cy_tiocmget(struct tty_struct
 
 		CY_LOCK(info, flags);
 		cy_writeb(base_addr + (CyCAR << index), (u_char) channel);
-		status = cy_readb(base_addr + (CyMSVR1 << index));
-		status |= cy_readb(base_addr + (CyMSVR2 << index));
+		status = readb(base_addr + (CyMSVR1 << index));
+		status |= readb(base_addr + (CyMSVR2 << index));
 		CY_UNLOCK(info, flags);
 
 		if (info->rtsdtr_inv) {
@@ -3639,10 +3626,10 @@ static int cy_tiocmget(struct tty_struct
 		firm_id = cy_card[card].base_addr + ID_ADDRESS;
 		if (ISZLOADED(cy_card[card])) {
 			zfw_ctrl = cy_card[card].base_addr +
-				(cy_readl(&firm_id->zfwctrl_addr) & 0xfffff);
+				(readl(&firm_id->zfwctrl_addr) & 0xfffff);
 			board_ctrl = &zfw_ctrl->board_ctrl;
 			ch_ctrl = zfw_ctrl->ch_ctrl;
-			lstatus = cy_readl(&ch_ctrl[channel].rs_status);
+			lstatus = readl(&ch_ctrl[channel].rs_status);
 			result = ((lstatus & C_RS_RTS) ? TIOCM_RTS : 0) |
 				((lstatus & C_RS_DTR) ? TIOCM_DTR : 0) |
 				((lstatus & C_RS_DCD) ? TIOCM_CAR : 0) |
@@ -3724,8 +3711,8 @@ cy_tiocmset(struct tty_struct *tty, stru
 #ifdef CY_DEBUG_DTR
 			printk("cyc:set_modem_info raising DTR\n");
 			printk("     status: 0x%x, 0x%x\n",
-				cy_readb(base_addr + (CyMSVR1 << index)),
-				cy_readb(base_addr + (CyMSVR2 << index)));
+				readb(base_addr + (CyMSVR1 << index)),
+				readb(base_addr + (CyMSVR2 << index)));
 #endif
 			CY_UNLOCK(info, flags);
 		}
@@ -3744,8 +3731,8 @@ cy_tiocmset(struct tty_struct *tty, stru
 #ifdef CY_DEBUG_DTR
 			printk("cyc:set_modem_info dropping DTR\n");
 			printk("     status: 0x%x, 0x%x\n",
-				cy_readb(base_addr + (CyMSVR1 << index)),
-				cy_readb(base_addr + (CyMSVR2 << index)));
+				readb(base_addr + (CyMSVR1 << index)),
+				readb(base_addr + (CyMSVR2 << index)));
 #endif
 			CY_UNLOCK(info, flags);
 		}
@@ -3755,29 +3742,29 @@ cy_tiocmset(struct tty_struct *tty, stru
 		firm_id = cy_card[card].base_addr + ID_ADDRESS;
 		if (ISZLOADED(cy_card[card])) {
 			zfw_ctrl = cy_card[card].base_addr +
-				(cy_readl(&firm_id->zfwctrl_addr) & 0xfffff);
+				(readl(&firm_id->zfwctrl_addr) & 0xfffff);
 			board_ctrl = &zfw_ctrl->board_ctrl;
 			ch_ctrl = zfw_ctrl->ch_ctrl;
 
 			if (set & TIOCM_RTS) {
 				CY_LOCK(info, flags);
 				cy_writel(&ch_ctrl[channel].rs_control,
-					  cy_readl(&ch_ctrl[channel].
-						   rs_control) | C_RS_RTS);
+					readl(&ch_ctrl[channel].rs_control) |
+					C_RS_RTS);
 				CY_UNLOCK(info, flags);
 			}
 			if (clear & TIOCM_RTS) {
 				CY_LOCK(info, flags);
 				cy_writel(&ch_ctrl[channel].rs_control,
-					  cy_readl(&ch_ctrl[channel].
-						   rs_control) & ~C_RS_RTS);
+					readl(&ch_ctrl[channel].rs_control) &
+					~C_RS_RTS);
 				CY_UNLOCK(info, flags);
 			}
 			if (set & TIOCM_DTR) {
 				CY_LOCK(info, flags);
 				cy_writel(&ch_ctrl[channel].rs_control,
-					  cy_readl(&ch_ctrl[channel].
-						   rs_control) | C_RS_DTR);
+					readl(&ch_ctrl[channel].rs_control) |
+					C_RS_DTR);
 #ifdef CY_DEBUG_DTR
 				printk("cyc:set_modem_info raising Z DTR\n");
 #endif
@@ -3786,8 +3773,8 @@ cy_tiocmset(struct tty_struct *tty, stru
 			if (clear & TIOCM_DTR) {
 				CY_LOCK(info, flags);
 				cy_writel(&ch_ctrl[channel].rs_control,
-					  cy_readl(&ch_ctrl[channel].
-						   rs_control) & ~C_RS_DTR);
+					readl(&ch_ctrl[channel].rs_control) &
+					~C_RS_DTR);
 #ifdef CY_DEBUG_DTR
 				printk("cyc:set_modem_info clearing Z DTR\n");
 #endif
@@ -3924,7 +3911,7 @@ get_threshold(struct cyclades_port *info
 		base_addr =
 		    cy_card[card].base_addr + (cy_chip_offset[chip] << index);
 
-		tmp = cy_readb(base_addr + (CyCOR3 << index)) & CyREC_FIFO;
+		tmp = readb(base_addr + (CyCOR3 << index)) & CyREC_FIFO;
 		return put_user(tmp, value);
 	} else {
 		/* Nothing to do! */
@@ -3984,7 +3971,7 @@ static int get_timeout(struct cyclades_p
 		base_addr =
 		    cy_card[card].base_addr + (cy_chip_offset[chip] << index);
 
-		tmp = cy_readb(base_addr + (CyRTPR << index));
+		tmp = readb(base_addr + (CyRTPR << index));
 		return put_user(tmp, value);
 	} else {
 		/* Nothing to do! */
@@ -4410,7 +4397,7 @@ static void cy_stop(struct tty_struct *t
 		cy_writeb(base_addr + (CyCAR << index),
 			(u_char)(channel & 0x0003)); /* index channel */
 		cy_writeb(base_addr + (CySRER << index),
-			  cy_readb(base_addr + (CySRER << index)) & ~CyTxRdy);
+			  readb(base_addr + (CySRER << index)) & ~CyTxRdy);
 		CY_UNLOCK(info, flags);
 	} else {
 		/* Nothing to do! */
@@ -4444,7 +4431,7 @@ static void cy_start(struct tty_struct *
 		CY_LOCK(info, flags);
 		cy_writeb(base_addr + (CyCAR << index), (u_char) (channel & 0x0003));	/* index channel */
 		cy_writeb(base_addr + (CySRER << index),
-			  cy_readb(base_addr + (CySRER << index)) | CyTxRdy);
+			  readb(base_addr + (CySRER << index)) | CyTxRdy);
 		CY_UNLOCK(info, flags);
 	} else {
 		/* Nothing to do! */
@@ -4537,7 +4524,7 @@ cyy_init_card(void __iomem * true_base_a
 		base_addr =
 		    true_base_addr + (cy_chip_offset[chip_number] << index);
 		mdelay(1);
-		if (cy_readb(base_addr + (CyCCR << index)) != 0x00) {
+		if (readb(base_addr + (CyCCR << index)) != 0x00) {
 			/*************
 			printk(" chip #%d at %#6lx is never idle (CCR != 0)\n",
 			chip_number, (unsigned long)base_addr);
@@ -4554,7 +4541,7 @@ cyy_init_card(void __iomem * true_base_a
 		   chip 4 GFRCR register appears at chip 0, there is no chip 4
 		   and this must be a Cyclom-16Y, not a Cyclom-32Ye.
 		 */
-		if (chip_number == 4 && cy_readb(true_base_addr +
+		if (chip_number == 4 && readb(true_base_addr +
 				(cy_chip_offset[0] << index) +
 				(CyGFRCR << index)) == 0) {
 			return chip_number;
@@ -4563,7 +4550,7 @@ cyy_init_card(void __iomem * true_base_a
 		cy_writeb(base_addr + (CyCCR << index), CyCHIP_RESET);
 		mdelay(1);
 
-		if (cy_readb(base_addr + (CyGFRCR << index)) == 0x00) {
+		if (readb(base_addr + (CyGFRCR << index)) == 0x00) {
 			/*
 			   printk(" chip #%d at %#6lx is not responding ",
 			   chip_number, (unsigned long)base_addr);
@@ -4571,7 +4558,7 @@ cyy_init_card(void __iomem * true_base_a
 			 */
 			return chip_number;
 		}
-		if ((0xf0 & (cy_readb(base_addr + (CyGFRCR << index)))) !=
+		if ((0xf0 & (readb(base_addr + (CyGFRCR << index)))) !=
 				0x40) {
 			/*
 			printk(" chip #%d at %#6lx is not valid (GFRCR == "
@@ -4582,7 +4569,7 @@ cyy_init_card(void __iomem * true_base_a
 			return chip_number;
 		}
 		cy_writeb(base_addr + (CyGCR << index), CyCH0_SERIAL);
-		if (cy_readb(base_addr + (CyGFRCR << index)) >= CD1400_REV_J) {
+		if (readb(base_addr + (CyGFRCR << index)) >= CD1400_REV_J) {
 			/* It is a CD1400 rev. J or later */
 			/* Impossible to reach 5ms with this chip.
 			   Changed to 2ms instead (f = 500 Hz). */
@@ -4595,7 +4582,7 @@ cyy_init_card(void __iomem * true_base_a
 		/*
 		   printk(" chip #%d at %#6lx is rev 0x%2x\n",
 		   chip_number, (unsigned long)base_addr,
-		   cy_readb(base_addr+(CyGFRCR<<index)));
+		   readb(base_addr+(CyGFRCR<<index)));
 		 */
 	}
 	return chip_number;
@@ -4717,14 +4704,14 @@ static int __init cy_detect_isa(void)
 static void plx_init(void __iomem * addr, __u32 initctl)
 {
 	/* Reset PLX */
-	cy_writel(addr + initctl, cy_readl(addr + initctl) | 0x40000000);
+	cy_writel(addr + initctl, readl(addr + initctl) | 0x40000000);
 	udelay(100L);
-	cy_writel(addr + initctl, cy_readl(addr + initctl) & ~0x40000000);
+	cy_writel(addr + initctl, readl(addr + initctl) & ~0x40000000);
 
 	/* Reload Config. Registers from EEPROM */
-	cy_writel(addr + initctl, cy_readl(addr + initctl) | 0x20000000);
+	cy_writel(addr + initctl, readl(addr + initctl) | 0x20000000);
 	udelay(100L);
-	cy_writel(addr + initctl, cy_readl(addr + initctl) & ~0x20000000);
+	cy_writel(addr + initctl, readl(addr + initctl) & ~0x20000000);
 }
 
 /*
@@ -4879,7 +4866,7 @@ static int __init cy_detect_pci(void)
 			cy_card[j].pdev = pdev;
 
 			/* enable interrupts in the PCI interface */
-			plx_ver = cy_readb(cy_pci_addr2 + CyPLX_VER) & 0x0f;
+			plx_ver = readb(cy_pci_addr2 + CyPLX_VER) & 0x0f;
 			switch (plx_ver) {
 			case PLX_9050:
 
@@ -4900,8 +4887,7 @@ static int __init cy_detect_pci(void)
 						cy_pci_irq);
 
 				cy_writew(cy_pci_addr0 + 0x68,
-					  cy_readw(cy_pci_addr0 +
-						   0x68) | 0x0900);
+					readw(cy_pci_addr0 + 0x68) | 0x0900);
 				break;
 			}
 
@@ -4940,7 +4926,7 @@ static int __init cy_detect_pci(void)
 
 			/* Disable interrupts on the PLX before resetting it */
 			cy_writew(cy_pci_addr0 + 0x68,
-				cy_readw(cy_pci_addr0 + 0x68) & ~0x0900);
+				readw(cy_pci_addr0 + 0x68) & ~0x0900);
 
 			plx_init(cy_pci_addr0, 0x6c);
 			/* For some yet unknown reason, once the PLX9060 reloads
@@ -4951,9 +4937,8 @@ static int __init cy_detect_pci(void)
 			pci_write_config_byte(pdev, PCI_INTERRUPT_LINE,
 						cy_pci_irq);
 
-			mailbox =
-			    (__u32)cy_readl(&((struct RUNTIME_9060 __iomem *)
-						cy_pci_addr0)->mail_box_0);
+			mailbox = (__u32)readl(&((struct RUNTIME_9060 __iomem *)
+					cy_pci_addr0)->mail_box_0);
 
 			if (pci_resource_flags(pdev, 2) & IORESOURCE_IO) {
 				printk("  Warning: PCI I/O bit incorrectly "
@@ -5005,10 +4990,10 @@ static int __init cy_detect_pci(void)
 					WIN_CREG);
 				printk("Cyclades-8Zo/PCI: FPGA id %lx, ver "
 					"%lx\n", (ulong) (0xff &
-					cy_readl(&((struct CUSTOM_REG *)
+					readl(&((struct CUSTOM_REG *)
 						(cy_pci_addr2))->fpga_id)),
 					(ulong)(0xff &
-					cy_readl(&((struct CUSTOM_REG *)
+					readl(&((struct CUSTOM_REG *)
 						(cy_pci_addr2))->
 							fpga_version)));
 				cy_writel(&((struct RUNTIME_9060 *)
@@ -5113,7 +5098,7 @@ static int __init cy_detect_pci(void)
 			Ze_pdev[j] = Ze_pdev[j + 1];
 		}
 		ZeIndex--;
-		mailbox = (__u32)cy_readl(&((struct RUNTIME_9060 __iomem *)
+		mailbox = (__u32)readl(&((struct RUNTIME_9060 __iomem *)
 						cy_pci_addr0)->mail_box_0);
 #ifdef CY_PCI_DEBUG
 		printk("Cyclades-Z/PCI: relocate winaddr=0x%lx ctladdr=0x%lx\n",
@@ -5382,7 +5367,7 @@ static int __init cy_init(void)
 		cinfo = &cy_card[board];
 		if (cinfo->num_chips == -1) {	/* Cyclades-Z */
 			number_z_boards++;
-			mailbox = cy_readl(&((struct RUNTIME_9060 __iomem *)
+			mailbox = readl(&((struct RUNTIME_9060 __iomem *)
 					     cy_card[board].ctl_addr)->
 					   mail_box_0);
 			nports = (mailbox == ZE_V1) ? ZE_V1_NPORTS : 8;
@@ -5478,7 +5463,7 @@ static int __init cy_init(void)
 				info->icount.overrun = info->icount.brk = 0;
 				chip_number = (port - cinfo->first_line) / 4;
 				if ((info->chip_rev =
-				     cy_readb(cinfo->base_addr +
+				     readb(cinfo->base_addr +
 					      (cy_chip_offset[chip_number] <<
 					       index) + (CyGFRCR << index))) >=
 				    CD1400_REV_J) {
diff -puN include/linux/cyclades.h~char-cyclades-cy_readx-writex-cleanup include/linux/cyclades.h
--- a/include/linux/cyclades.h~char-cyclades-cy_readx-writex-cleanup
+++ a/include/linux/cyclades.h
@@ -539,13 +539,9 @@ struct cyclades_chip {
  * (required to support Alpha systems) *
  ***************************************/
 
-#define cy_writeb(port,val)     {writeb((val),(port)); mb();}
-#define cy_writew(port,val)     {writew((val),(port)); mb();}
-#define cy_writel(port,val)     {writel((val),(port)); mb();}
-
-#define cy_readb(port)  readb(port)
-#define cy_readw(port)  readw(port)
-#define cy_readl(port)  readl(port)
+#define cy_writeb(port,val)     do { writeb((val), (port)); mb(); } while (0)
+#define cy_writew(port,val)     do { writew((val), (port)); mb(); } while (0)
+#define cy_writel(port,val)     do { writel((val), (port)); mb(); } while (0)
 
 /*
  * Statistics counters
_

Patches currently in -mm which might be from jirislaby@gmail.com are

char-rocket-add-module_device_table.patch
char-cs5535_gpio-add-module_device_table.patch
unify-queue_delayed_work-and-queue_delayed_work_on.patch
char-cyclades-remove-pause.patch
char-cyclades-cy_readx-writex-cleanup.patch
char-cyclades-timer-cleanup.patch
char-cyclades-remove-volatiles.patch
char-cyclades-remove-useless-casts.patch
shrink_slab-handle-bad-shrinkers.patch
