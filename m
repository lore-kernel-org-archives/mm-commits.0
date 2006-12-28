From: akpm@osdl.org
Subject: - revert-gregkh-usb-usb-implement-support-for-ehci-with-big-endian-mmio.patch removed from -mm tree
Date: Thu, 28 Dec 2006 15:10:31 -0800
Message-ID: <200612282310.kBSNAV7H015725@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:40446 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965064AbWL1XKn (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 28 Dec 2006 18:10:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@osdl.org, benh@kernel.crashing.org, greg@kroah.com, mm-commits@vger.kernel.org


The patch titled
     revert gregkh-usb-usb-implement-support-for-ehci-with-big-endian-mmio
has been removed from the -mm tree.  Its filename was
     revert-gregkh-usb-usb-implement-support-for-ehci-with-big-endian-mmio.patch

This patch was dropped because it is obsolete

------------------------------------------------------
Subject: revert gregkh-usb-usb-implement-support-for-ehci-with-big-endian-mmio
From: Andrew Morton <akpm@osdl.org>

drivers/usb/host/Kconfig:126:warning: 'select' used by config symbol 'USB_OHCI_HCD_PPC_OF_BE' refer to undefined symbol 'USB_OHCI_BIG_ENDIAN_DESC'
drivers/usb/host/Kconfig:127:warning: 'select' used by config symbol 'USB_OHCI_HCD_PPC_OF_BE' refer to undefined symbol 'USB_OHCI_BIG_ENDIAN_MMIO'
In file included from drivers/usb/host/ehci-hcd.c:138:
drivers/usb/host/ehci.h: In function 'ehci_readl':
drivers/usb/host/ehci.h:675: warning: implicit declaration of function 'readl_be'
drivers/usb/host/ehci.h: In function 'ehci_writel':
drivers/usb/host/ehci.h:683: warning: implicit declaration of function 'writel_be'

Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/usb/host/Kconfig      |    5 -
 drivers/usb/host/ehci-dbg.c   |   24 +++---
 drivers/usb/host/ehci-fsl.c   |    8 +-
 drivers/usb/host/ehci-hcd.c   |   92 +++++++++++-------------
 drivers/usb/host/ehci-hub.c   |  118 ++++++++++++++------------------
 drivers/usb/host/ehci-pci.c   |   38 ++--------
 drivers/usb/host/ehci-q.c     |   16 +---
 drivers/usb/host/ehci-sched.c |   22 ++---
 drivers/usb/host/ehci.h       |   32 --------
 9 files changed, 142 insertions(+), 213 deletions(-)

diff -puN drivers/usb/host/Kconfig~revert-gregkh-usb-usb-implement-support-for-ehci-with-big-endian-mmio drivers/usb/host/Kconfig
--- a/drivers/usb/host/Kconfig~revert-gregkh-usb-usb-implement-support-for-ehci-with-big-endian-mmio
+++ a/drivers/usb/host/Kconfig
@@ -67,11 +67,6 @@ config USB_EHCI_TT_NEWSCHED
 
 	  If unsure, say N.
 
-config USB_EHCI_BIG_ENDIAN_MMIO
-	bool
-	depends on USB_EHCI_HCD
-	default n
-
 config USB_ISP116X_HCD
 	tristate "ISP116X HCD support"
 	depends on USB
diff -puN drivers/usb/host/ehci-dbg.c~revert-gregkh-usb-usb-implement-support-for-ehci-with-big-endian-mmio drivers/usb/host/ehci-dbg.c
--- a/drivers/usb/host/ehci-dbg.c~revert-gregkh-usb-usb-implement-support-for-ehci-with-big-endian-mmio
+++ a/drivers/usb/host/ehci-dbg.c
@@ -43,7 +43,7 @@
  */
 static void dbg_hcs_params (struct ehci_hcd *ehci, char *label)
 {
-	u32	params = ehci_readl(ehci, &ehci->caps->hcs_params);
+	u32	params = readl (&ehci->caps->hcs_params);
 
 	ehci_dbg (ehci,
 		"%s hcs_params 0x%x dbg=%d%s cc=%d pcc=%d%s%s ports=%d\n",
@@ -87,7 +87,7 @@ static inline void dbg_hcs_params (struc
  * */
 static void dbg_hcc_params (struct ehci_hcd *ehci, char *label)
 {
-	u32	params = ehci_readl(ehci, &ehci->caps->hcc_params);
+	u32	params = readl (&ehci->caps->hcc_params);
 
 	if (HCC_ISOC_CACHE (params)) {
 		ehci_dbg (ehci,
@@ -653,7 +653,7 @@ show_registers (struct class_device *cla
 	}
 
 	/* Capability Registers */
-	i = HC_VERSION(ehci_readl(ehci, &ehci->caps->hc_capbase));
+	i = HC_VERSION(readl (&ehci->caps->hc_capbase));
 	temp = scnprintf (next, size,
 		"bus %s, device %s (driver " DRIVER_VERSION ")\n"
 		"%s\n"
@@ -673,7 +673,7 @@ show_registers (struct class_device *cla
 		unsigned	count = 256/4;
 
 		pdev = to_pci_dev(ehci_to_hcd(ehci)->self.controller);
-		offset = HCC_EXT_CAPS (ehci_readl(ehci, &ehci->caps->hcc_params));
+		offset = HCC_EXT_CAPS (readl (&ehci->caps->hcc_params));
 		while (offset && count--) {
 			pci_read_config_dword (pdev, offset, &cap);
 			switch (cap & 0xff) {
@@ -704,50 +704,50 @@ show_registers (struct class_device *cla
 #endif
 
 	// FIXME interpret both types of params
-	i = ehci_readl(ehci, &ehci->caps->hcs_params);
+	i = readl (&ehci->caps->hcs_params);
 	temp = scnprintf (next, size, "structural params 0x%08x\n", i);
 	size -= temp;
 	next += temp;
 
-	i = ehci_readl(ehci, &ehci->caps->hcc_params);
+	i = readl (&ehci->caps->hcc_params);
 	temp = scnprintf (next, size, "capability params 0x%08x\n", i);
 	size -= temp;
 	next += temp;
 
 	/* Operational Registers */
 	temp = dbg_status_buf (scratch, sizeof scratch, label,
-			ehci_readl(ehci, &ehci->regs->status));
+			readl (&ehci->regs->status));
 	temp = scnprintf (next, size, fmt, temp, scratch);
 	size -= temp;
 	next += temp;
 
 	temp = dbg_command_buf (scratch, sizeof scratch, label,
-			ehci_readl(ehci, &ehci->regs->command));
+			readl (&ehci->regs->command));
 	temp = scnprintf (next, size, fmt, temp, scratch);
 	size -= temp;
 	next += temp;
 
 	temp = dbg_intr_buf (scratch, sizeof scratch, label,
-			ehci_readl(ehci, &ehci->regs->intr_enable));
+			readl (&ehci->regs->intr_enable));
 	temp = scnprintf (next, size, fmt, temp, scratch);
 	size -= temp;
 	next += temp;
 
 	temp = scnprintf (next, size, "uframe %04x\n",
-			ehci_readl(ehci, &ehci->regs->frame_index));
+			readl (&ehci->regs->frame_index));
 	size -= temp;
 	next += temp;
 
 	for (i = 1; i <= HCS_N_PORTS (ehci->hcs_params); i++) {
 		temp = dbg_port_buf (scratch, sizeof scratch, label, i,
-				ehci_readl(ehci, &ehci->regs->port_status [i - 1]));
+				readl (&ehci->regs->port_status [i - 1]));
 		temp = scnprintf (next, size, fmt, temp, scratch);
 		size -= temp;
 		next += temp;
 		if (i == HCS_DEBUG_PORT(ehci->hcs_params) && ehci->debug) {
 			temp = scnprintf (next, size,
 					"    debug control %08x\n",
-					ehci_readl(ehci, &ehci->debug->control));
+					readl (&ehci->debug->control));
 			size -= temp;
 			next += temp;
 		}
diff -puN drivers/usb/host/ehci-fsl.c~revert-gregkh-usb-usb-implement-support-for-ehci-with-big-endian-mmio drivers/usb/host/ehci-fsl.c
--- a/drivers/usb/host/ehci-fsl.c~revert-gregkh-usb-usb-implement-support-for-ehci-with-big-endian-mmio
+++ a/drivers/usb/host/ehci-fsl.c
@@ -177,7 +177,7 @@ static void mpc83xx_setup_phy(struct ehc
 	case FSL_USB2_PHY_NONE:
 		break;
 	}
-	ehci_writel(ehci, portsc, &ehci->regs->port_status[port_offset]);
+	writel(portsc, &ehci->regs->port_status[port_offset]);
 }
 
 static void mpc83xx_usb_setup(struct usb_hcd *hcd)
@@ -214,7 +214,7 @@ static void mpc83xx_usb_setup(struct usb
 	}
 
 	/* put controller in host mode. */
-	ehci_writel(ehci, 0x00000003, non_ehci + FSL_SOC_USB_USBMODE);
+	writel(0x00000003, non_ehci + FSL_SOC_USB_USBMODE);
 	out_be32(non_ehci + FSL_SOC_USB_PRICTRL, 0x0000000c);
 	out_be32(non_ehci + FSL_SOC_USB_AGECNTTHRSH, 0x00000040);
 	out_be32(non_ehci + FSL_SOC_USB_SICTRL, 0x00000001);
@@ -238,12 +238,12 @@ static int ehci_fsl_setup(struct usb_hcd
 	/* EHCI registers start at offset 0x100 */
 	ehci->caps = hcd->regs + 0x100;
 	ehci->regs = hcd->regs + 0x100 +
-	    HC_LENGTH(ehci_readl(ehci, &ehci->caps->hc_capbase));
+	    HC_LENGTH(readl(&ehci->caps->hc_capbase));
 	dbg_hcs_params(ehci, "reset");
 	dbg_hcc_params(ehci, "reset");
 
 	/* cache this readonly data; minimize chip reads */
-	ehci->hcs_params = ehci_readl(ehci, &ehci->caps->hcs_params);
+	ehci->hcs_params = readl(&ehci->caps->hcs_params);
 
 	retval = ehci_halt(ehci);
 	if (retval)
diff -puN drivers/usb/host/ehci-hcd.c~revert-gregkh-usb-usb-implement-support-for-ehci-with-big-endian-mmio drivers/usb/host/ehci-hcd.c
--- a/drivers/usb/host/ehci-hcd.c~revert-gregkh-usb-usb-implement-support-for-ehci-with-big-endian-mmio
+++ a/drivers/usb/host/ehci-hcd.c
@@ -157,13 +157,12 @@ MODULE_PARM_DESC (ignore_oc, "ignore bog
  * before driver shutdown. But it also seems to be caused by bugs in cardbus
  * bridge shutdown:  shutting down the bridge before the devices using it.
  */
-static int handshake (struct ehci_hcd *ehci, void __iomem *ptr,
-		      u32 mask, u32 done, int usec)
+static int handshake (void __iomem *ptr, u32 mask, u32 done, int usec)
 {
 	u32	result;
 
 	do {
-		result = ehci_readl(ehci, ptr);
+		result = readl (ptr);
 		if (result == ~(u32)0)		/* card removed */
 			return -ENODEV;
 		result &= mask;
@@ -178,19 +177,18 @@ static int handshake (struct ehci_hcd *e
 /* force HC to halt state from unknown (EHCI spec section 2.3) */
 static int ehci_halt (struct ehci_hcd *ehci)
 {
-	u32	temp = ehci_readl(ehci, &ehci->regs->status);
+	u32	temp = readl (&ehci->regs->status);
 
 	/* disable any irqs left enabled by previous code */
-	ehci_writel(ehci, 0, &ehci->regs->intr_enable);
+	writel (0, &ehci->regs->intr_enable);
 
 	if ((temp & STS_HALT) != 0)
 		return 0;
 
-	temp = ehci_readl(ehci, &ehci->regs->command);
+	temp = readl (&ehci->regs->command);
 	temp &= ~CMD_RUN;
-	ehci_writel(ehci, temp, &ehci->regs->command);
-	return handshake (ehci, &ehci->regs->status,
-			  STS_HALT, STS_HALT, 16 * 125);
+	writel (temp, &ehci->regs->command);
+	return handshake (&ehci->regs->status, STS_HALT, STS_HALT, 16 * 125);
 }
 
 /* put TDI/ARC silicon into EHCI mode */
@@ -200,24 +198,23 @@ static void tdi_reset (struct ehci_hcd *
 	u32		tmp;
 
 	reg_ptr = (u32 __iomem *)(((u8 __iomem *)ehci->regs) + 0x68);
-	tmp = ehci_readl(ehci, reg_ptr);
+	tmp = readl (reg_ptr);
 	tmp |= 0x3;
-	ehci_writel(ehci, tmp, reg_ptr);
+	writel (tmp, reg_ptr);
 }
 
 /* reset a non-running (STS_HALT == 1) controller */
 static int ehci_reset (struct ehci_hcd *ehci)
 {
 	int	retval;
-	u32	command = ehci_readl(ehci, &ehci->regs->command);
+	u32	command = readl (&ehci->regs->command);
 
 	command |= CMD_RESET;
 	dbg_cmd (ehci, "reset", command);
-	ehci_writel(ehci, command, &ehci->regs->command);
+	writel (command, &ehci->regs->command);
 	ehci_to_hcd(ehci)->state = HC_STATE_HALT;
 	ehci->next_statechange = jiffies;
-	retval = handshake (ehci, &ehci->regs->command,
-			    CMD_RESET, 0, 250 * 1000);
+	retval = handshake (&ehci->regs->command, CMD_RESET, 0, 250 * 1000);
 
 	if (retval)
 		return retval;
@@ -239,21 +236,21 @@ static void ehci_quiesce (struct ehci_hc
 #endif
 
 	/* wait for any schedule enables/disables to take effect */
-	temp = ehci_readl(ehci, &ehci->regs->command) << 10;
+	temp = readl (&ehci->regs->command) << 10;
 	temp &= STS_ASS | STS_PSS;
-	if (handshake (ehci, &ehci->regs->status, STS_ASS | STS_PSS,
+	if (handshake (&ehci->regs->status, STS_ASS | STS_PSS,
 				temp, 16 * 125) != 0) {
 		ehci_to_hcd(ehci)->state = HC_STATE_HALT;
 		return;
 	}
 
 	/* then disable anything that's still active */
-	temp = ehci_readl(ehci, &ehci->regs->command);
+	temp = readl (&ehci->regs->command);
 	temp &= ~(CMD_ASE | CMD_IAAD | CMD_PSE);
-	ehci_writel(ehci, temp, &ehci->regs->command);
+	writel (temp, &ehci->regs->command);
 
 	/* hardware can take 16 microframes to turn off ... */
-	if (handshake (ehci, &ehci->regs->status, STS_ASS | STS_PSS,
+	if (handshake (&ehci->regs->status, STS_ASS | STS_PSS,
 				0, 16 * 125) != 0) {
 		ehci_to_hcd(ehci)->state = HC_STATE_HALT;
 		return;
@@ -280,11 +277,11 @@ static void ehci_watchdog (unsigned long
 
 	/* lost IAA irqs wedge things badly; seen with a vt8235 */
 	if (ehci->reclaim) {
-		u32		status = ehci_readl(ehci, &ehci->regs->status);
+		u32		status = readl (&ehci->regs->status);
 		if (status & STS_IAA) {
 			ehci_vdbg (ehci, "lost IAA\n");
 			COUNT (ehci->stats.lost_iaa);
-			ehci_writel(ehci, STS_IAA, &ehci->regs->status);
+			writel (STS_IAA, &ehci->regs->status);
 			ehci->reclaim_ready = 1;
 		}
 	}
@@ -312,7 +309,7 @@ ehci_shutdown (struct usb_hcd *hcd)
 	(void) ehci_halt (ehci);
 
 	/* make BIOS/etc use companion controller during reboot */
-	ehci_writel(ehci, 0, &ehci->regs->configured_flag);
+	writel (0, &ehci->regs->configured_flag);
 }
 
 static void ehci_port_power (struct ehci_hcd *ehci, int is_on)
@@ -382,11 +379,11 @@ static void ehci_stop (struct usb_hcd *h
 		ehci_quiesce (ehci);
 
 	ehci_reset (ehci);
-	ehci_writel(ehci, 0, &ehci->regs->intr_enable);
+	writel (0, &ehci->regs->intr_enable);
 	spin_unlock_irq(&ehci->lock);
 
 	/* let companion controllers work when we aren't */
-	ehci_writel(ehci, 0, &ehci->regs->configured_flag);
+	writel (0, &ehci->regs->configured_flag);
 
 	remove_debug_files (ehci);
 
@@ -405,8 +402,7 @@ static void ehci_stop (struct usb_hcd *h
 		ehci->stats.complete, ehci->stats.unlink);
 #endif
 
-	dbg_status (ehci, "ehci_stop completed",
-		    ehci_readl(ehci, &ehci->regs->status));
+	dbg_status (ehci, "ehci_stop completed", readl (&ehci->regs->status));
 }
 
 /* one-time init, only for memory state */
@@ -432,7 +428,7 @@ static int ehci_init(struct usb_hcd *hcd
 		return retval;
 
 	/* controllers may cache some of the periodic schedule ... */
-	hcc_params = ehci_readl(ehci, &ehci->caps->hcc_params);
+	hcc_params = readl(&ehci->caps->hcc_params);
 	if (HCC_ISOC_CACHE(hcc_params))		// full frame cache
 		ehci->i_thresh = 8;
 	else					// N microframes cached
@@ -505,8 +501,8 @@ static int ehci_run (struct usb_hcd *hcd
 		ehci_mem_cleanup(ehci);
 		return retval;
 	}
-	ehci_writel(ehci, ehci->periodic_dma, &ehci->regs->frame_list);
-	ehci_writel(ehci, (u32)ehci->async->qh_dma, &ehci->regs->async_next);
+	writel(ehci->periodic_dma, &ehci->regs->frame_list);
+	writel((u32)ehci->async->qh_dma, &ehci->regs->async_next);
 
 	/*
 	 * hcc_params controls whether ehci->regs->segment must (!!!)
@@ -520,9 +516,9 @@ static int ehci_run (struct usb_hcd *hcd
 	 * Scsi_Host.highmem_io, and so forth.  It's readonly to all
 	 * host side drivers though.
 	 */
-	hcc_params = ehci_readl(ehci, &ehci->caps->hcc_params);
+	hcc_params = readl(&ehci->caps->hcc_params);
 	if (HCC_64BIT_ADDR(hcc_params)) {
-		ehci_writel(ehci, 0, &ehci->regs->segment);
+		writel(0, &ehci->regs->segment);
 #if 0
 // this is deeply broken on almost all architectures
 		if (!dma_set_mask(hcd->self.controller, DMA_64BIT_MASK))
@@ -535,7 +531,7 @@ static int ehci_run (struct usb_hcd *hcd
 	// root hub will detect new devices (why?); NEC doesn't
 	ehci->command &= ~(CMD_LRESET|CMD_IAAD|CMD_PSE|CMD_ASE|CMD_RESET);
 	ehci->command |= CMD_RUN;
-	ehci_writel(ehci, ehci->command, &ehci->regs->command);
+	writel (ehci->command, &ehci->regs->command);
 	dbg_cmd (ehci, "init", ehci->command);
 
 	/*
@@ -545,18 +541,17 @@ static int ehci_run (struct usb_hcd *hcd
 	 * and there's no companion controller unless maybe for USB OTG.)
 	 */
 	hcd->state = HC_STATE_RUNNING;
-	ehci_writel(ehci, FLAG_CF, &ehci->regs->configured_flag);
-	ehci_readl(ehci, &ehci->regs->command);	/* unblock posted writes */
+	writel (FLAG_CF, &ehci->regs->configured_flag);
+	readl (&ehci->regs->command);	/* unblock posted writes */
 
-	temp = HC_VERSION(ehci_readl(ehci, &ehci->caps->hc_capbase));
+	temp = HC_VERSION(readl (&ehci->caps->hc_capbase));
 	ehci_info (ehci,
 		"USB %x.%x started, EHCI %x.%02x, driver %s%s\n",
 		((ehci->sbrn & 0xf0)>>4), (ehci->sbrn & 0x0f),
 		temp >> 8, temp & 0xff, DRIVER_VERSION,
 		ignore_oc ? ", overcurrent ignored" : "");
 
-	ehci_writel(ehci, INTR_MASK,
-		    &ehci->regs->intr_enable); /* Turn On Interrupts */
+	writel (INTR_MASK, &ehci->regs->intr_enable); /* Turn On Interrupts */
 
 	/* GRR this is run-once init(), being done every time the HC starts.
 	 * So long as they're part of class devices, we can't do it init()
@@ -577,7 +572,7 @@ static irqreturn_t ehci_irq (struct usb_
 
 	spin_lock (&ehci->lock);
 
-	status = ehci_readl(ehci, &ehci->regs->status);
+	status = readl (&ehci->regs->status);
 
 	/* e.g. cardbus physical eject */
 	if (status == ~(u32) 0) {
@@ -592,8 +587,8 @@ static irqreturn_t ehci_irq (struct usb_
 	}
 
 	/* clear (just) interrupts */
-	ehci_writel(ehci, status, &ehci->regs->status);
-	ehci_readl(ehci, &ehci->regs->command);	/* unblock posted write */
+	writel (status, &ehci->regs->status);
+	readl (&ehci->regs->command);	/* unblock posted write */
 	bh = 0;
 
 #ifdef	EHCI_VERBOSE_DEBUG
@@ -624,12 +619,11 @@ static irqreturn_t ehci_irq (struct usb_
 		unsigned	i = HCS_N_PORTS (ehci->hcs_params);
 
 		/* resume root hub? */
-		if (!(ehci_readl(ehci, &ehci->regs->command) & CMD_RUN))
+		if (!(readl(&ehci->regs->command) & CMD_RUN))
 			usb_hcd_resume_root_hub(hcd);
 
 		while (i--) {
-			int pstatus = ehci_readl(ehci,
-						 &ehci->regs->port_status [i]);
+			int pstatus = readl (&ehci->regs->port_status [i]);
 
 			if (pstatus & PORT_OWNER)
 				continue;
@@ -649,15 +643,14 @@ static irqreturn_t ehci_irq (struct usb_
 	/* PCI errors [4.15.2.4] */
 	if (unlikely ((status & STS_FATAL) != 0)) {
 		/* bogus "fatal" IRQs appear on some chips... why?  */
-		status = ehci_readl(ehci, &ehci->regs->status);
-		dbg_cmd (ehci, "fatal", ehci_readl(ehci,
-						   &ehci->regs->command));
+		status = readl (&ehci->regs->status);
+		dbg_cmd (ehci, "fatal", readl (&ehci->regs->command));
 		dbg_status (ehci, "fatal", status);
 		if (status & STS_HALT) {
 			ehci_err (ehci, "fatal error\n");
 dead:
 			ehci_reset (ehci);
-			ehci_writel(ehci, 0, &ehci->regs->configured_flag);
+			writel (0, &ehci->regs->configured_flag);
 			/* generic layer kills/unlinks all urbs, then
 			 * uses ehci_stop to clean up the rest
 			 */
@@ -880,8 +873,7 @@ done:
 static int ehci_get_frame (struct usb_hcd *hcd)
 {
 	struct ehci_hcd		*ehci = hcd_to_ehci (hcd);
-	return (ehci_readl(ehci, &ehci->regs->frame_index) >> 3) %
-		ehci->periodic_size;
+	return (readl (&ehci->regs->frame_index) >> 3) % ehci->periodic_size;
 }
 
 /*-------------------------------------------------------------------------*/
diff -puN drivers/usb/host/ehci-hub.c~revert-gregkh-usb-usb-implement-support-for-ehci-with-big-endian-mmio drivers/usb/host/ehci-hub.c
--- a/drivers/usb/host/ehci-hub.c~revert-gregkh-usb-usb-implement-support-for-ehci-with-big-endian-mmio
+++ a/drivers/usb/host/ehci-hub.c
@@ -47,7 +47,7 @@ static int ehci_bus_suspend (struct usb_
 		ehci_quiesce (ehci);
 		hcd->state = HC_STATE_QUIESCING;
 	}
-	ehci->command = ehci_readl(ehci, &ehci->regs->command);
+	ehci->command = readl (&ehci->regs->command);
 	if (ehci->reclaim)
 		ehci->reclaim_ready = 1;
 	ehci_work(ehci);
@@ -60,7 +60,7 @@ static int ehci_bus_suspend (struct usb_
 	ehci->bus_suspended = 0;
 	while (port--) {
 		u32 __iomem	*reg = &ehci->regs->port_status [port];
-		u32		t1 = ehci_readl(ehci, reg) & ~PORT_RWC_BITS;
+		u32		t1 = readl (reg) & ~PORT_RWC_BITS;
 		u32		t2 = t1;
 
 		/* keep track of which ports we suspend */
@@ -79,7 +79,7 @@ static int ehci_bus_suspend (struct usb_
 		if (t1 != t2) {
 			ehci_vdbg (ehci, "port %d, %08x -> %08x\n",
 				port + 1, t1, t2);
-			ehci_writel(ehci, t2, reg);
+			writel (t2, reg);
 		}
 	}
 
@@ -92,8 +92,8 @@ static int ehci_bus_suspend (struct usb_
 	mask = INTR_MASK;
 	if (!device_may_wakeup(&hcd->self.root_hub->dev))
 		mask &= ~STS_PCD;
-	ehci_writel(ehci, mask, &ehci->regs->intr_enable);
-	ehci_readl(ehci, &ehci->regs->intr_enable);
+	writel(mask, &ehci->regs->intr_enable);
+	readl(&ehci->regs->intr_enable);
 
 	ehci->next_statechange = jiffies + msecs_to_jiffies(10);
 	spin_unlock_irq (&ehci->lock);
@@ -118,26 +118,26 @@ static int ehci_bus_resume (struct usb_h
 	 * the last user of the controller, not reset/pm hardware keeping
 	 * state we gave to it.
 	 */
-	temp = ehci_readl(ehci, &ehci->regs->intr_enable);
+	temp = readl(&ehci->regs->intr_enable);
 	ehci_dbg(ehci, "resume root hub%s\n", temp ? "" : " after power loss");
 
 	/* at least some APM implementations will try to deliver
 	 * IRQs right away, so delay them until we're ready.
 	 */
-	ehci_writel(ehci, 0, &ehci->regs->intr_enable);
+	writel(0, &ehci->regs->intr_enable);
 
 	/* re-init operational registers */
-	ehci_writel(ehci, 0, &ehci->regs->segment);
-	ehci_writel(ehci, ehci->periodic_dma, &ehci->regs->frame_list);
-	ehci_writel(ehci, (u32) ehci->async->qh_dma, &ehci->regs->async_next);
+	writel(0, &ehci->regs->segment);
+	writel(ehci->periodic_dma, &ehci->regs->frame_list);
+	writel((u32) ehci->async->qh_dma, &ehci->regs->async_next);
 
 	/* restore CMD_RUN, framelist size, and irq threshold */
-	ehci_writel(ehci, ehci->command, &ehci->regs->command);
+	writel (ehci->command, &ehci->regs->command);
 
 	/* manually resume the ports we suspended during bus_suspend() */
 	i = HCS_N_PORTS (ehci->hcs_params);
 	while (i--) {
-		temp = ehci_readl(ehci, &ehci->regs->port_status [i]);
+		temp = readl (&ehci->regs->port_status [i]);
 		temp &= ~(PORT_RWC_BITS
 			| PORT_WKOC_E | PORT_WKDISC_E | PORT_WKCONN_E);
 		if (test_bit(i, &ehci->bus_suspended) &&
@@ -145,20 +145,20 @@ static int ehci_bus_resume (struct usb_h
 			ehci->reset_done [i] = jiffies + msecs_to_jiffies (20);
 			temp |= PORT_RESUME;
 		}
-		ehci_writel(ehci, temp, &ehci->regs->port_status [i]);
+		writel (temp, &ehci->regs->port_status [i]);
 	}
 	i = HCS_N_PORTS (ehci->hcs_params);
 	mdelay (20);
 	while (i--) {
-		temp = ehci_readl(ehci, &ehci->regs->port_status [i]);
+		temp = readl (&ehci->regs->port_status [i]);
 		if (test_bit(i, &ehci->bus_suspended) &&
 				(temp & PORT_SUSPEND)) {
 			temp &= ~(PORT_RWC_BITS | PORT_RESUME);
-			ehci_writel(ehci, temp, &ehci->regs->port_status [i]);
+			writel (temp, &ehci->regs->port_status [i]);
 			ehci_vdbg (ehci, "resumed port %d\n", i + 1);
 		}
 	}
-	(void) ehci_readl(ehci, &ehci->regs->command);
+	(void) readl (&ehci->regs->command);
 
 	/* maybe re-activate the schedule(s) */
 	temp = 0;
@@ -168,14 +168,14 @@ static int ehci_bus_resume (struct usb_h
 		temp |= CMD_PSE;
 	if (temp) {
 		ehci->command |= temp;
-		ehci_writel(ehci, ehci->command, &ehci->regs->command);
+		writel (ehci->command, &ehci->regs->command);
 	}
 
 	ehci->next_statechange = jiffies + msecs_to_jiffies(5);
 	hcd->state = HC_STATE_RUNNING;
 
 	/* Now we can safely re-enable irqs */
-	ehci_writel(ehci, INTR_MASK, &ehci->regs->intr_enable);
+	writel(INTR_MASK, &ehci->regs->intr_enable);
 
 	spin_unlock_irq (&ehci->lock);
 	return 0;
@@ -217,8 +217,7 @@ static int check_reset_complete (
 		// what happens if HCS_N_CC(params) == 0 ?
 		port_status |= PORT_OWNER;
 		port_status &= ~PORT_RWC_BITS;
-		ehci_writel(ehci, port_status,
-			    &ehci->regs->port_status [index]);
+		writel (port_status, &ehci->regs->port_status [index]);
 
 	} else
 		ehci_dbg (ehci, "port %d high speed\n", index + 1);
@@ -269,14 +268,13 @@ ehci_hub_status_data (struct usb_hcd *hc
 	/* port N changes (bit N)? */
 	spin_lock_irqsave (&ehci->lock, flags);
 	for (i = 0; i < ports; i++) {
-		temp = ehci_readl(ehci, &ehci->regs->port_status [i]);
+		temp = readl (&ehci->regs->port_status [i]);
 		if (temp & PORT_OWNER) {
 			/* don't report this in GetPortStatus */
 			if (temp & PORT_CSC) {
 				temp &= ~PORT_RWC_BITS;
 				temp |= PORT_CSC;
-				ehci_writel(ehci, temp,
-					    &ehci->regs->port_status [i]);
+				writel (temp, &ehci->regs->port_status [i]);
 			}
 			continue;
 		}
@@ -375,18 +373,18 @@ static int ehci_hub_control (
 		if (!wIndex || wIndex > ports)
 			goto error;
 		wIndex--;
-		temp = ehci_readl(ehci, &ehci->regs->port_status [wIndex]);
+		temp = readl (&ehci->regs->port_status [wIndex]);
 		if (temp & PORT_OWNER)
 			break;
 
 		switch (wValue) {
 		case USB_PORT_FEAT_ENABLE:
-			ehci_writel(ehci, temp & ~PORT_PE,
-				    &ehci->regs->port_status [wIndex]);
+			writel (temp & ~PORT_PE,
+				&ehci->regs->port_status [wIndex]);
 			break;
 		case USB_PORT_FEAT_C_ENABLE:
-			ehci_writel(ehci, (temp & ~PORT_RWC_BITS) | PORT_PEC,
-				    &ehci->regs->port_status [wIndex]);
+			writel((temp & ~PORT_RWC_BITS) | PORT_PEC,
+				&ehci->regs->port_status [wIndex]);
 			break;
 		case USB_PORT_FEAT_SUSPEND:
 			if (temp & PORT_RESET)
@@ -398,8 +396,8 @@ static int ehci_hub_control (
 					goto error;
 				/* resume signaling for 20 msec */
 				temp &= ~(PORT_RWC_BITS | PORT_WAKE_BITS);
-				ehci_writel(ehci, temp | PORT_RESUME,
-					    &ehci->regs->port_status [wIndex]);
+				writel (temp | PORT_RESUME,
+					&ehci->regs->port_status [wIndex]);
 				ehci->reset_done [wIndex] = jiffies
 						+ msecs_to_jiffies (20);
 			}
@@ -409,17 +407,16 @@ static int ehci_hub_control (
 			break;
 		case USB_PORT_FEAT_POWER:
 			if (HCS_PPC (ehci->hcs_params))
-				ehci_writel(ehci,
-					  temp & ~(PORT_RWC_BITS | PORT_POWER),
-					  &ehci->regs->port_status [wIndex]);
+				writel (temp & ~(PORT_RWC_BITS | PORT_POWER),
+					&ehci->regs->port_status [wIndex]);
 			break;
 		case USB_PORT_FEAT_C_CONNECTION:
-			ehci_writel(ehci, (temp & ~PORT_RWC_BITS) | PORT_CSC,
-				    &ehci->regs->port_status [wIndex]);
+			writel((temp & ~PORT_RWC_BITS) | PORT_CSC,
+				&ehci->regs->port_status [wIndex]);
 			break;
 		case USB_PORT_FEAT_C_OVER_CURRENT:
-			ehci_writel(ehci, (temp & ~PORT_RWC_BITS) | PORT_OCC,
-				    &ehci->regs->port_status [wIndex]);
+			writel((temp & ~PORT_RWC_BITS) | PORT_OCC,
+				&ehci->regs->port_status [wIndex]);
 			break;
 		case USB_PORT_FEAT_C_RESET:
 			/* GetPortStatus clears reset */
@@ -427,7 +424,7 @@ static int ehci_hub_control (
 		default:
 			goto error;
 		}
-		ehci_readl(ehci, &ehci->regs->command);	/* unblock posted write */
+		readl (&ehci->regs->command);	/* unblock posted write */
 		break;
 	case GetHubDescriptor:
 		ehci_hub_descriptor (ehci, (struct usb_hub_descriptor *)
@@ -443,7 +440,7 @@ static int ehci_hub_control (
 			goto error;
 		wIndex--;
 		status = 0;
-		temp = ehci_readl(ehci, &ehci->regs->port_status [wIndex]);
+		temp = readl (&ehci->regs->port_status [wIndex]);
 
 		// wPortChange bits
 		if (temp & PORT_CSC)
@@ -461,14 +458,12 @@ static int ehci_hub_control (
 			ehci->reset_done [wIndex] = 0;
 
 			/* stop resume signaling */
-			temp = ehci_readl(ehci,
-					  &ehci->regs->port_status [wIndex]);
-			ehci_writel(ehci,
-				    temp & ~(PORT_RWC_BITS | PORT_RESUME),
-				    &ehci->regs->port_status [wIndex]);
-			retval = handshake(ehci,
-					   &ehci->regs->port_status [wIndex],
-					   PORT_RESUME, 0, 2000 /* 2msec */);
+			temp = readl (&ehci->regs->port_status [wIndex]);
+			writel (temp & ~(PORT_RWC_BITS | PORT_RESUME),
+				&ehci->regs->port_status [wIndex]);
+			retval = handshake (
+					&ehci->regs->port_status [wIndex],
+					PORT_RESUME, 0, 2000 /* 2msec */);
 			if (retval != 0) {
 				ehci_err (ehci, "port %d resume error %d\n",
 					wIndex + 1, retval);
@@ -485,13 +480,13 @@ static int ehci_hub_control (
 			ehci->reset_done [wIndex] = 0;
 
 			/* force reset to complete */
-			ehci_writel(ehci, temp & ~(PORT_RWC_BITS | PORT_RESET),
-				    &ehci->regs->port_status [wIndex]);
+			writel (temp & ~(PORT_RWC_BITS | PORT_RESET),
+					&ehci->regs->port_status [wIndex]);
 			/* REVISIT:  some hardware needs 550+ usec to clear
 			 * this bit; seems too long to spin routinely...
 			 */
-			retval = handshake(ehci,
-					   &ehci->regs->port_status [wIndex],
+			retval = handshake (
+					&ehci->regs->port_status [wIndex],
 					PORT_RESET, 0, 750);
 			if (retval != 0) {
 				ehci_err (ehci, "port %d reset error %d\n",
@@ -501,8 +496,7 @@ static int ehci_hub_control (
 
 			/* see what we found out */
 			temp = check_reset_complete (ehci, wIndex,
-				ehci_readl(ehci,
-					   &ehci->regs->port_status [wIndex]));
+				readl (&ehci->regs->port_status [wIndex]));
 		}
 
 		// don't show wPortStatus if it's owned by a companion hc
@@ -547,7 +541,7 @@ static int ehci_hub_control (
 		if (!wIndex || wIndex > ports)
 			goto error;
 		wIndex--;
-		temp = ehci_readl(ehci, &ehci->regs->port_status [wIndex]);
+		temp = readl (&ehci->regs->port_status [wIndex]);
 		if (temp & PORT_OWNER)
 			break;
 
@@ -561,13 +555,13 @@ static int ehci_hub_control (
 				goto error;
 			if (device_may_wakeup(&hcd->self.root_hub->dev))
 				temp |= PORT_WAKE_BITS;
-			ehci_writel(ehci, temp | PORT_SUSPEND,
-				    &ehci->regs->port_status [wIndex]);
+			writel (temp | PORT_SUSPEND,
+				&ehci->regs->port_status [wIndex]);
 			break;
 		case USB_PORT_FEAT_POWER:
 			if (HCS_PPC (ehci->hcs_params))
-				ehci_writel(ehci, temp | PORT_POWER,
-					    &ehci->regs->port_status [wIndex]);
+				writel (temp | PORT_POWER,
+					&ehci->regs->port_status [wIndex]);
 			break;
 		case USB_PORT_FEAT_RESET:
 			if (temp & PORT_RESUME)
@@ -595,8 +589,7 @@ static int ehci_hub_control (
 				ehci->reset_done [wIndex] = jiffies
 						+ msecs_to_jiffies (50);
 			}
-			ehci_writel(ehci, temp,
-				    &ehci->regs->port_status [wIndex]);
+			writel (temp, &ehci->regs->port_status [wIndex]);
 			break;
 
 		/* For downstream facing ports (these):  one hub port is put
@@ -611,14 +604,13 @@ static int ehci_hub_control (
 			ehci_quiesce(ehci);
 			ehci_halt(ehci);
 			temp |= selector << 16;
-			ehci_writel(ehci, temp,
-				    &ehci->regs->port_status [wIndex]);
+			writel (temp, &ehci->regs->port_status [wIndex]);
 			break;
 
 		default:
 			goto error;
 		}
-		ehci_readl(ehci, &ehci->regs->command);	/* unblock posted writes */
+		readl (&ehci->regs->command);	/* unblock posted writes */
 		break;
 
 	default:
diff -puN drivers/usb/host/ehci-pci.c~revert-gregkh-usb-usb-implement-support-for-ehci-with-big-endian-mmio drivers/usb/host/ehci-pci.c
--- a/drivers/usb/host/ehci-pci.c~revert-gregkh-usb-usb-implement-support-for-ehci-with-big-endian-mmio
+++ a/drivers/usb/host/ehci-pci.c
@@ -38,7 +38,7 @@ static int ehci_pci_reinit(struct ehci_h
 		if ((temp & (3 << 13)) == (1 << 13)) {
 			temp &= 0x1fff;
 			ehci->debug = ehci_to_hcd(ehci)->regs + temp;
-			temp = ehci_readl(ehci, &ehci->debug->control);
+			temp = readl(&ehci->debug->control);
 			ehci_info(ehci, "debug port %d%s\n",
 				HCS_DEBUG_PORT(ehci->hcs_params),
 				(temp & DBGP_ENABLED)
@@ -71,24 +71,8 @@ static int ehci_pci_setup(struct usb_hcd
 	u32			temp;
 	int			retval;
 
-	switch (pdev->vendor) {
-	case PCI_VENDOR_ID_TOSHIBA_2:
-		/* celleb's companion chip */
-		if (pdev->device == 0x01b5) {
-#ifdef CONFIG_USB_EHCI_BIG_ENDIAN_MMIO
-			ehci->big_endian_mmio = 1;
-#else
-			ehci_warn(ehci,
-				  "unsupported big endian Toshiba quirk\n");
-#endif
-		}
-		break;
-	}
-
 	ehci->caps = hcd->regs;
-	ehci->regs = hcd->regs +
-		HC_LENGTH(ehci_readl(ehci, &ehci->caps->hc_capbase));
-
+	ehci->regs = hcd->regs + HC_LENGTH(readl(&ehci->caps->hc_capbase));
 	dbg_hcs_params(ehci, "reset");
 	dbg_hcc_params(ehci, "reset");
 
@@ -117,7 +101,7 @@ static int ehci_pci_setup(struct usb_hcd
 	}
 
 	/* cache this readonly data; minimize chip reads */
-	ehci->hcs_params = ehci_readl(ehci, &ehci->caps->hcs_params);
+	ehci->hcs_params = readl(&ehci->caps->hcs_params);
 
 	retval = ehci_halt(ehci);
 	if (retval)
@@ -251,8 +235,8 @@ static int ehci_pci_suspend(struct usb_h
 		rc = -EINVAL;
 		goto bail;
 	}
-	ehci_writel(ehci, 0, &ehci->regs->intr_enable);
-	(void)ehci_readl(ehci, &ehci->regs->intr_enable);
+	writel (0, &ehci->regs->intr_enable);
+	(void)readl(&ehci->regs->intr_enable);
 
 	/* make sure snapshot being resumed re-enumerates everything */
 	if (message.event == PM_EVENT_PRETHAW) {
@@ -286,13 +270,13 @@ static int ehci_pci_resume(struct usb_hc
 	/* If CF is still set, we maintained PCI Vaux power.
 	 * Just undo the effect of ehci_pci_suspend().
 	 */
-	if (ehci_readl(ehci, &ehci->regs->configured_flag) == FLAG_CF) {
+	if (readl(&ehci->regs->configured_flag) == FLAG_CF) {
 		int	mask = INTR_MASK;
 
 		if (!device_may_wakeup(&hcd->self.root_hub->dev))
 			mask &= ~STS_PCD;
-		ehci_writel(ehci, mask, &ehci->regs->intr_enable);
-		ehci_readl(ehci, &ehci->regs->intr_enable);
+		writel(mask, &ehci->regs->intr_enable);
+		readl(&ehci->regs->intr_enable);
 		return 0;
 	}
 
@@ -316,9 +300,9 @@ static int ehci_pci_resume(struct usb_hc
 	/* here we "know" root ports should always stay powered */
 	ehci_port_power(ehci, 1);
 
-	ehci_writel(ehci, ehci->command, &ehci->regs->command);
-	ehci_writel(ehci, FLAG_CF, &ehci->regs->configured_flag);
-	ehci_readl(ehci, &ehci->regs->command);	/* unblock posted writes */
+	writel(ehci->command, &ehci->regs->command);
+	writel(FLAG_CF, &ehci->regs->configured_flag);
+	readl(&ehci->regs->command);	/* unblock posted writes */
 
 	hcd->state = HC_STATE_SUSPENDED;
 	return 0;
diff -puN drivers/usb/host/ehci-q.c~revert-gregkh-usb-usb-implement-support-for-ehci-with-big-endian-mmio drivers/usb/host/ehci-q.c
--- a/drivers/usb/host/ehci-q.c~revert-gregkh-usb-usb-implement-support-for-ehci-with-big-endian-mmio
+++ a/drivers/usb/host/ehci-q.c
@@ -789,14 +789,13 @@ static void qh_link_async (struct ehci_h
 	head = ehci->async;
 	timer_action_done (ehci, TIMER_ASYNC_OFF);
 	if (!head->qh_next.qh) {
-		u32	cmd = ehci_readl(ehci, &ehci->regs->command);
+		u32	cmd = readl (&ehci->regs->command);
 
 		if (!(cmd & CMD_ASE)) {
 			/* in case a clear of CMD_ASE didn't take yet */
-			(void)handshake(ehci, &ehci->regs->status,
-					STS_ASS, 0, 150);
+			(void) handshake (&ehci->regs->status, STS_ASS, 0, 150);
 			cmd |= CMD_ASE | CMD_RUN;
-			ehci_writel(ehci, cmd, &ehci->regs->command);
+			writel (cmd, &ehci->regs->command);
 			ehci_to_hcd(ehci)->state = HC_STATE_RUNNING;
 			/* posted write need not be known to HC yet ... */
 		}
@@ -1008,7 +1007,7 @@ static void end_unlink_async (struct ehc
 
 static void start_unlink_async (struct ehci_hcd *ehci, struct ehci_qh *qh)
 {
-	int		cmd = ehci_readl(ehci, &ehci->regs->command);
+	int		cmd = readl (&ehci->regs->command);
 	struct ehci_qh	*prev;
 
 #ifdef DEBUG
@@ -1026,8 +1025,7 @@ static void start_unlink_async (struct e
 		if (ehci_to_hcd(ehci)->state != HC_STATE_HALT
 				&& !ehci->reclaim) {
 			/* ... and CMD_IAAD clear */
-			ehci_writel(ehci, cmd & ~CMD_ASE,
-				    &ehci->regs->command);
+			writel (cmd & ~CMD_ASE, &ehci->regs->command);
 			wmb ();
 			// handshake later, if we need to
 			timer_action_done (ehci, TIMER_ASYNC_OFF);
@@ -1056,8 +1054,8 @@ static void start_unlink_async (struct e
 
 	ehci->reclaim_ready = 0;
 	cmd |= CMD_IAAD;
-	ehci_writel(ehci, cmd, &ehci->regs->command);
-	(void)ehci_readl(ehci, &ehci->regs->command);
+	writel (cmd, &ehci->regs->command);
+	(void) readl (&ehci->regs->command);
 	timer_action (ehci, TIMER_IAA_WATCHDOG);
 }
 
diff -puN drivers/usb/host/ehci-sched.c~revert-gregkh-usb-usb-implement-support-for-ehci-with-big-endian-mmio drivers/usb/host/ehci-sched.c
--- a/drivers/usb/host/ehci-sched.c~revert-gregkh-usb-usb-implement-support-for-ehci-with-big-endian-mmio
+++ a/drivers/usb/host/ehci-sched.c
@@ -433,20 +433,20 @@ static int enable_periodic (struct ehci_
 	/* did clearing PSE did take effect yet?
 	 * takes effect only at frame boundaries...
 	 */
-	status = handshake(ehci, &ehci->regs->status, STS_PSS, 0, 9 * 125);
+	status = handshake (&ehci->regs->status, STS_PSS, 0, 9 * 125);
 	if (status != 0) {
 		ehci_to_hcd(ehci)->state = HC_STATE_HALT;
 		return status;
 	}
 
-	cmd = ehci_readl(ehci, &ehci->regs->command) | CMD_PSE;
-	ehci_writel(ehci, cmd, &ehci->regs->command);
+	cmd = readl (&ehci->regs->command) | CMD_PSE;
+	writel (cmd, &ehci->regs->command);
 	/* posted write ... PSS happens later */
 	ehci_to_hcd(ehci)->state = HC_STATE_RUNNING;
 
 	/* make sure ehci_work scans these */
-	ehci->next_uframe = ehci_readl(ehci, &ehci->regs->frame_index)
-		% (ehci->periodic_size << 3);
+	ehci->next_uframe = readl (&ehci->regs->frame_index)
+				% (ehci->periodic_size << 3);
 	return 0;
 }
 
@@ -458,14 +458,14 @@ static int disable_periodic (struct ehci
 	/* did setting PSE not take effect yet?
 	 * takes effect only at frame boundaries...
 	 */
-	status = handshake(ehci, &ehci->regs->status, STS_PSS, STS_PSS, 9 * 125);
+	status = handshake (&ehci->regs->status, STS_PSS, STS_PSS, 9 * 125);
 	if (status != 0) {
 		ehci_to_hcd(ehci)->state = HC_STATE_HALT;
 		return status;
 	}
 
-	cmd = ehci_readl(ehci, &ehci->regs->command) & ~CMD_PSE;
-	ehci_writel(ehci, cmd, &ehci->regs->command);
+	cmd = readl (&ehci->regs->command) & ~CMD_PSE;
+	writel (cmd, &ehci->regs->command);
 	/* posted write ... */
 
 	ehci->next_uframe = -1;
@@ -1336,7 +1336,7 @@ iso_stream_schedule (
 		goto fail;
 	}
 
-	now = ehci_readl(ehci, &ehci->regs->frame_index) % mod;
+	now = readl (&ehci->regs->frame_index) % mod;
 
 	/* when's the last uframe this urb could start? */
 	max = now + mod;
@@ -2088,7 +2088,7 @@ scan_periodic (struct ehci_hcd *ehci)
 	 */
 	now_uframe = ehci->next_uframe;
 	if (HC_IS_RUNNING (ehci_to_hcd(ehci)->state))
-		clock = ehci_readl(ehci, &ehci->regs->frame_index);
+		clock = readl (&ehci->regs->frame_index);
 	else
 		clock = now_uframe + mod - 1;
 	clock %= mod;
@@ -2213,7 +2213,7 @@ restart:
 			if (!HC_IS_RUNNING (ehci_to_hcd(ehci)->state))
 				break;
 			ehci->next_uframe = now_uframe;
-			now = ehci_readl(ehci, &ehci->regs->frame_index) % mod;
+			now = readl (&ehci->regs->frame_index) % mod;
 			if (now_uframe == now)
 				break;
 
diff -puN drivers/usb/host/ehci.h~revert-gregkh-usb-usb-implement-support-for-ehci-with-big-endian-mmio drivers/usb/host/ehci.h
--- a/drivers/usb/host/ehci.h~revert-gregkh-usb-usb-implement-support-for-ehci-with-big-endian-mmio
+++ a/drivers/usb/host/ehci.h
@@ -92,7 +92,6 @@ struct ehci_hcd {			/* one per controlle
 	unsigned		is_tdi_rh_tt:1;	/* TDI roothub with TT */
 	unsigned		no_selective_suspend:1;
 	unsigned		has_fsl_port_bug:1; /* FreeScale */
-	unsigned		big_endian_mmio:1;
 
 	u8			sbrn;		/* packed release number */
 
@@ -652,37 +651,6 @@ ehci_port_speed(struct ehci_hcd *ehci, u
 #define	ehci_has_fsl_portno_bug(e)		(0)
 #endif
 
-/*
- * While most USB host controllers implement their registers in
- * little-endian format, a minority (celleb companion chip) implement
- * them in big endian format.
- *
- * This attempts to support either format at compile time without a
- * runtime penalty, or both formats with the additional overhead
- * of checking a flag bit.
- */
-
-#ifdef CONFIG_USB_EHCI_BIG_ENDIAN_MMIO
-#define ehci_big_endian_mmio(e)		((e)->big_endian_mmio)
-#else
-#define ehci_big_endian_mmio(e)		0
-#endif
-
-static inline unsigned int ehci_readl (const struct ehci_hcd *ehci,
-				       __u32 __iomem * regs)
-{
-	return ehci_big_endian_mmio(ehci) ?
-		readl_be((__force u32 *)regs) :
-		readl((__force u32 *)regs);
-}
-
-static inline void ehci_writel (const struct ehci_hcd *ehci,
-				const unsigned int val, __u32 __iomem *regs)
-{
-	ehci_big_endian_mmio(ehci) ?
-		writel_be(val, (__force u32 *)regs) :
-		writel(val, (__force u32 *)regs);
-}
 
 /*-------------------------------------------------------------------------*/
 
_

Patches currently in -mm which might be from akpm@osdl.org are

cpuset-procfs-warning-fix.patch
lockdep-printk-warning-fix.patch
down_write-preserve-local-irqs.patch
shrink_all_memory-fix-lru_pages-handling.patch
macintosh-mangle-caps-lock-events-on-adb-keyboards.patch
git-acpi.patch
sony_apci-resume.patch
sony_apci-resume-fix.patch
video-sysfs-support-take-2-add-dev-argument-for-backlight_device_register-sony_acpi-fix.patch
git-alsa.patch
git-agpgart.patch
cifs-sprintf-fix.patch
git-cpufreq.patch
fix-gregkh-driver-driver-core-fix-race-in-sysfs-between-sysfs_remove_file-and-read-write.patch
git-dvb.patch
git-gfs2-nmw.patch
ia64-enable-config_debug_spinlock_sleep.patch
git-iee1394-printk-warning-fix.patch
git-ieee1394-build-fix.patch
git-ieee1394-build-fix-2.patch
git-ieee1394-build-fix-3.patch
git-input.patch
git-libata-all.patch
git-libata-all-fixup.patch
git-lxdialog-fixup.patch
git-mmc.patch
git-mtd.patch
git-ubi.patch
git-ubi-build-fix.patch
git-ubi-mtd_read-arg-fix.patch
ubi-missing-include.patch
git-netdev-all.patch
update-smc91x-driver-with-arm-versatile-board-info.patch
drivers-net-ns83820c-add-paramter-to-disable-auto.patch
net-use-bitrev8.patch
net-uninline-skb_put.patch
ioat-warning-fix.patch
drivers-scsi-mca_53c9xc-save_flags-cli-removal.patch
scsi-cover-up-bugs-fix-up-compiler-warnings-in-megaraid-driver.patch
git-qla3xxx-fixup.patch
revert-gregkh-usb-usb-implement-support-for-ehci-with-big-endian-mmio.patch
revert-gregkh-usb-ohci-add-support-for-ohci-controller-on-the-of_platform-bus.patch
nokia-e70-is-an-unusual-device.patch
revert-i386-fix-the-verify_quirk_intel_irqbalance.patch
revert-x86_64-mm-add-genapic_force.patch
revert-x86_64-mm-fix-the-irqbalance-quirk-for-e7320-e7520-e7525.patch
revert-x86_64-mm-copy-user-nocache.patch
add-memcpy_uncached_read.patch
add-i386-idle-notifier-take-3-fix.patch
touchkit-ps-2-touchscreen-driver.patch
lumpy-reclaim-v2-page_to_pfn-fix.patch
lumpy-reclaim-v2-tidy.patch
avoid-excessive-sorting-of-early_node_map-tidy.patch
proc-zoneinfo-fix-vm-stats-display.patch
bluetooth-blacklist-lenovo-r60e.patch
swsusp-change-code-ordering-in-userc-sanity.patch
deprecate-smbfs-in-favour-of-cifs.patch
drivers-add-lcd-support-3-Kconfig-fix.patch
drivers-add-lcd-support-workqueue-fixups.patch
ecryptfs-public-key-packet-management-slab-fix.patch
add-retain_initrd-boot-option-tweak.patch
count_vm_events-warning-fix.patch
toshiba-tc86c001-ide-driver-take-2-fix-2.patch
procfs-fix-race-between-proc_readdir-and-remove_proc_entry-fix.patch
schedule_on_each_cpu-use-preempt_disable.patch
consolidate-line-discipline-number-definitions-v2-sparc-fix.patch
consolidate-line-discipline-number-definitions-v2-fix-2.patch
spi-controller-driver-for-omap-microwire-tidy.patch
vmi-versus-hrtimers.patch
gtod-persistent-clock-support-i386.patch
hrtimers-clean-up-locking.patch
hrtimers-add-state-tracking.patch
clockevents-i386-drivers.patch
debugging-feature-proc-timer_list-warning-fix.patch
generic-vsyscall-gtod-support-for-generic_time-tidy.patch
time-x86_64-split-x86_64-kernel-timec-up-tidy.patch
time-x86_64-split-x86_64-kernel-timec-up-fix.patch
time-x86_64-convert-x86_64-to-use-generic_time-fix.patch
time-x86_64-convert-x86_64-to-use-generic_time-tidy.patch
time-x86_64-re-enable-vsyscall-support-for-x86_64-tidy.patch
workqueue-dont-hold-workqueue_mutex-in-flush_scheduled_work.patch
move-page-writeback-acounting-out-of-macros.patch
per-backing_dev-dirty-and-writeback-page-accounting.patch
ext2-reservations.patch
edac-new-opteron-athlon64-memory-controller-driver.patch
omap-gpio-wrappers-tidy.patch
at91-gpio-wrappers-tidy.patch
fsaio-filesystem-aio-read-tidy.patch
aio-is-unlikely.patch
sched2-sched-domain-sysctl-use-ctl_unnumbered.patch
mm-implement-swap-prefetching-use-ctl_unnumbered.patch
swap_prefetch-vs-zoned-counters.patch
add-include-linux-freezerh-and-move-definitions-from-prefetch.patch
readahead-kconfig-options-fix.patch
readahead-minmax_ra_pages.patch
readahead-sysctl-parameters.patch
readahead-sysctl-parameters-use-ctl_unnumbered.patch
readahead-context-based-method-locking-fix.patch
readahead-context-based-method-locking-fix-2.patch
readahead-call-scheme-ifdef-fix.patch
readahead-call-scheme-build-fix.patch
readahead-nfsd-case-fix.patch
make-copy_from_user_inatomic-not-zero-the-tail-on-i386-vs-reiser4.patch
resier4-add-include-linux-freezerh-and-move-definitions-from.patch
make-kmem_cache_destroy-return-void-reiser4.patch
reiser4-hardirq-include-fix.patch
reiser4-run-truncate_inode_pages-in-reiser4_delete_inode.patch
reiser4-get_sb_dev-fix.patch
reiser4-vs-zoned-allocator.patch
reiser4-temp-fix.patch
reiser4-kmem_cache_t-removal.patch
reiser4-test_clear_page_dirty.patch
hpt3xx-rework-rate-filtering-tidy.patch
jmicron-warning-fix.patch
statistics-infrastructure-fix-buffer-overflow-in-histogram-with-linear-tidy.patch
extend-notifier_call_chain-to-count-nr_calls-made.patch
extend-notifier_call_chain-to-count-nr_calls-made-fixes-2.patch
define-and-use-new-eventscpu_lock_acquire-and-cpu_lock_release-fix.patch
eliminate-lock_cpu_hotplug-in-kernel-schedc-fix.patch
slim-main-include-fix.patch
nr_blockdev_pages-in_interrupt-warning.patch
device-suspend-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
vdso-print-fatal-signals-use-ctl_unnumbered.patch
restore-rogue-readahead-printk.patch
put_bh-debug.patch
e1000-printk-warning-fixes.patch
acpi_format_exception-debug.patch
add-debugging-aid-for-memory-initialisation-problems-fix.patch
kmap_atomic-debugging.patch
shrink_slab-handle-bad-shrinkers.patch
squash-ipc-warnings.patch
squash-udf-warnings.patch

