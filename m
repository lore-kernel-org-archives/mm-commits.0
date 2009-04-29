From: akpm@linux-foundation.org
Subject: [merged] char-cyclades-plx9060-casts-cleanup.patch removed from -mm tree
Date: Wed, 29 Apr 2009 12:18:02 -0700
Message-ID: <200904291918.n3TJI25j030872@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59844 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752798AbZD2TUQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 29 Apr 2009 15:20:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jirislaby@gmail.com, alan@lxorguk.ukuu.org.uk, khc@pm.waw.pl, mm-commits@vger.kernel.org


The patch titled
     char: cyclades, plx9060 casts cleanup
has been removed from the -mm tree.  Its filename was
     char-cyclades-plx9060-casts-cleanup.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: char: cyclades, plx9060 casts cleanup
From: Jiri Slaby <jirislaby@gmail.com>

Remove ugly all-over-the-code casts of ctl_addr to 9060 space.  Add an
union to the cyclades_card structure, which contains a pointer to both
9050 and 9060 spaces.

The 9050 space layout is unknown, so let it still as a void __iomem
pointer.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Krzysztof Halasa <khc@pm.waw.pl>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/cyclades.c  |   65 ++++++++++++++++++-------------------
 include/linux/cyclades.h |   23 +++++++------
 2 files changed, 46 insertions(+), 42 deletions(-)

diff -puN drivers/char/cyclades.c~char-cyclades-plx9060-casts-cleanup drivers/char/cyclades.c
--- a/drivers/char/cyclades.c~char-cyclades-plx9060-casts-cleanup
+++ a/drivers/char/cyclades.c
@@ -666,12 +666,10 @@ static void cy_send_xchar(struct tty_str
 #define IS_CYC_Z(card) ((card).num_chips == (unsigned int)-1)
 
 #define Z_FPGA_CHECK(card) \
-	((readl(&((struct RUNTIME_9060 __iomem *) \
-		((card).ctl_addr))->init_ctrl) & (1<<17)) != 0)
+	((readl(&(card).ctl_addr.p9060->init_ctrl) & (1<<17)) != 0)
 
-#define ISZLOADED(card)	(((ZO_V1 == readl(&((struct RUNTIME_9060 __iomem *) \
-			((card).ctl_addr))->mail_box_0)) || \
-			Z_FPGA_CHECK(card)) && \
+#define ISZLOADED(card)	(((ZO_V1 == readl(&(card).ctl_addr.p9060->mail_box_0)) \
+			|| Z_FPGA_CHECK(card)) && \
 			(ZFIRM_ID == readl(&((struct FIRM_ID __iomem *) \
 			((card).base_addr+ID_ADDRESS))->signature)))
 
@@ -1400,14 +1398,12 @@ cyz_fetch_msg(struct cyclades_card *cinf
 	zfw_ctrl = cinfo->base_addr + (readl(&firm_id->zfwctrl_addr) & 0xfffff);
 	board_ctrl = &zfw_ctrl->board_ctrl;
 
-	loc_doorbell = readl(&((struct RUNTIME_9060 __iomem *)
-				  (cinfo->ctl_addr))->loc_doorbell);
+	loc_doorbell = readl(&cinfo->ctl_addr.p9060->loc_doorbell);
 	if (loc_doorbell) {
 		*cmd = (char)(0xff & loc_doorbell);
 		*channel = readl(&board_ctrl->fwcmd_channel);
 		*param = (__u32) readl(&board_ctrl->fwcmd_param);
-		cy_writel(&((struct RUNTIME_9060 __iomem *)(cinfo->ctl_addr))->
-			  loc_doorbell, 0xffffffff);
+		cy_writel(&cinfo->ctl_addr.p9060->loc_doorbell, 0xffffffff);
 		return 1;
 	}
 	return 0;
@@ -1431,8 +1427,7 @@ cyz_issue_cmd(struct cyclades_card *cinf
 	board_ctrl = &zfw_ctrl->board_ctrl;
 
 	index = 0;
-	pci_doorbell =
-	    &((struct RUNTIME_9060 __iomem *)(cinfo->ctl_addr))->pci_doorbell;
+	pci_doorbell = &cinfo->ctl_addr.p9060->pci_doorbell;
 	while ((readl(pci_doorbell) & 0xff) != 0) {
 		if (index++ == 1000)
 			return (int)(readl(pci_doorbell) & 0xff);
@@ -1635,8 +1630,7 @@ static void cyz_handle_cmd(struct cyclad
 	zfw_ctrl = cinfo->base_addr + (readl(&firm_id->zfwctrl_addr) & 0xfffff);
 	board_ctrl = &zfw_ctrl->board_ctrl;
 	fw_ver = readl(&board_ctrl->fw_version);
-	hw_ver = readl(&((struct RUNTIME_9060 __iomem *)(cinfo->ctl_addr))->
-			mail_box_0);
+	hw_ver = readl(&cinfo->ctl_addr.p9060->mail_box_0);
 
 	while (cyz_fetch_msg(cinfo, &channel, &cmd, &param) == 1) {
 		special_count = 0;
@@ -2394,8 +2388,8 @@ static int cy_open(struct tty_struct *tt
 		struct FIRM_ID __iomem *firm_id = cinfo->base_addr + ID_ADDRESS;
 
 		if (!ISZLOADED(*cinfo)) {
-			if (((ZE_V1 == readl(&((struct RUNTIME_9060 __iomem *)
-					 (cinfo->ctl_addr))->mail_box_0)) &&
+			if (((ZE_V1 == readl(&cinfo->ctl_addr.p9060->
+							mail_box_0)) &&
 					Z_FPGA_CHECK(*cinfo)) &&
 					(ZFIRM_HLT == readl(
 						&firm_id->signature))) {
@@ -2417,6 +2411,7 @@ static int cy_open(struct tty_struct *tt
 			if (!cinfo->intr_enabled) {
 				struct ZFW_CTRL __iomem *zfw_ctrl;
 				struct BOARD_CTRL __iomem *board_ctrl;
+				u16 intr;
 
 				zfw_ctrl = cinfo->base_addr +
 					(readl(&firm_id->zfwctrl_addr) &
@@ -2425,8 +2420,10 @@ static int cy_open(struct tty_struct *tt
 				board_ctrl = &zfw_ctrl->board_ctrl;
 
 				/* Enable interrupts on the PLX chip */
-				cy_writew(cinfo->ctl_addr + 0x68,
-					readw(cinfo->ctl_addr + 0x68) | 0x0900);
+				intr = readw(&cinfo->ctl_addr.p9060->
+						intr_ctrl_stat) | 0x0900;
+				cy_writew(&cinfo->ctl_addr.p9060->
+						intr_ctrl_stat, intr);
 				/* Enable interrupts on the FW */
 				retval = cyz_issue_cmd(cinfo, 0,
 						C_CM_IRQ_ENBL, 0L);
@@ -4347,8 +4344,7 @@ static int __devinit cy_init_card(struct
 	spin_lock_init(&cinfo->card_lock);
 
 	if (IS_CYC_Z(*cinfo)) {	/* Cyclades-Z */
-		mailbox = readl(&((struct RUNTIME_9060 __iomem *)
-				     cinfo->ctl_addr)->mail_box_0);
+		mailbox = readl(&cinfo->ctl_addr.p9060->mail_box_0);
 		nports = (mailbox == ZE_V1) ? ZE_V1_NPORTS : 8;
 		cinfo->intr_enabled = 0;
 		cinfo->nports = 0;	/* Will be correctly set later, after
@@ -4613,7 +4609,7 @@ static int __init cy_detect_isa(void)
 
 		/* set cy_card */
 		cy_card[j].base_addr = cy_isa_address;
-		cy_card[j].ctl_addr = NULL;
+		cy_card[j].ctl_addr.p9050 = NULL;
 		cy_card[j].irq = (int)cy_isa_irq;
 		cy_card[j].bus_index = 0;
 		cy_card[j].first_line = cy_next_channel;
@@ -5013,7 +5009,8 @@ static int __devinit cy_pci_probe(struct
 		}
 
 		/* Disable interrupts on the PLX before resetting it */
-		cy_writew(addr0 + 0x68, readw(addr0 + 0x68) & ~0x0900);
+		cy_writew(&ctl_addr->intr_ctrl_stat,
+				readw(&ctl_addr->intr_ctrl_stat) & ~0x0900);
 
 		plx_init(pdev, irq, addr0);
 
@@ -5109,7 +5106,7 @@ static int __devinit cy_pci_probe(struct
 
 	/* set cy_card */
 	cy_card[card_no].base_addr = addr2;
-	cy_card[card_no].ctl_addr = addr0;
+	cy_card[card_no].ctl_addr.p9050 = addr0;
 	cy_card[card_no].irq = irq;
 	cy_card[card_no].bus_index = 1;
 	cy_card[card_no].first_line = cy_next_channel;
@@ -5125,17 +5122,20 @@ static int __devinit cy_pci_probe(struct
 		plx_ver = readb(addr2 + CyPLX_VER) & 0x0f;
 		switch (plx_ver) {
 		case PLX_9050:
-
 			cy_writeb(addr0 + 0x4c, 0x43);
 			break;
 
 		case PLX_9060:
 		case PLX_9080:
 		default:	/* Old boards, use PLX_9060 */
-			plx_init(pdev, irq, addr0);
-			cy_writew(addr0 + 0x68, readw(addr0 + 0x68) | 0x0900);
+		{
+			struct RUNTIME_9060 __iomem *ctl_addr = addr0;
+			plx_init(pdev, irq, ctl_addr);
+			cy_writew(&ctl_addr->intr_ctrl_stat,
+				readw(&ctl_addr->intr_ctrl_stat) | 0x0900);
 			break;
 		}
+		}
 	}
 
 	dev_info(&pdev->dev, "%s/PCI #%d found: %d channels starting from "
@@ -5168,17 +5168,18 @@ static void __devexit cy_pci_remove(stru
 	/* non-Z with old PLX */
 	if (!IS_CYC_Z(*cinfo) && (readb(cinfo->base_addr + CyPLX_VER) & 0x0f) ==
 			PLX_9050)
-		cy_writeb(cinfo->ctl_addr + 0x4c, 0);
+		cy_writeb(cinfo->ctl_addr.p9050 + 0x4c, 0);
 	else
 #ifndef CONFIG_CYZ_INTR
 		if (!IS_CYC_Z(*cinfo))
 #endif
-		cy_writew(cinfo->ctl_addr + 0x68,
-				readw(cinfo->ctl_addr + 0x68) & ~0x0900);
+		cy_writew(&cinfo->ctl_addr.p9060->intr_ctrl_stat,
+			readw(&cinfo->ctl_addr.p9060->intr_ctrl_stat) &
+			~0x0900);
 
 	iounmap(cinfo->base_addr);
-	if (cinfo->ctl_addr)
-		iounmap(cinfo->ctl_addr);
+	if (cinfo->ctl_addr.p9050)
+		iounmap(cinfo->ctl_addr.p9050);
 	if (cinfo->irq
 #ifndef CONFIG_CYZ_INTR
 		&& !IS_CYC_Z(*cinfo)
@@ -5373,8 +5374,8 @@ static void __exit cy_cleanup_module(voi
 			/* clear interrupt */
 			cy_writeb(card->base_addr + Cy_ClrIntr, 0);
 			iounmap(card->base_addr);
-			if (card->ctl_addr)
-				iounmap(card->ctl_addr);
+			if (card->ctl_addr.p9050)
+				iounmap(card->ctl_addr.p9050);
 			if (card->irq
 #ifndef CONFIG_CYZ_INTR
 				&& !IS_CYC_Z(*card)
diff -puN include/linux/cyclades.h~char-cyclades-plx9060-casts-cleanup include/linux/cyclades.h
--- a/include/linux/cyclades.h~char-cyclades-plx9060-casts-cleanup
+++ a/include/linux/cyclades.h
@@ -507,16 +507,19 @@ struct ZFW_CTRL {
 
 /* Per card data structure */
 struct cyclades_card {
-    void __iomem *base_addr;
-    void __iomem *ctl_addr;
-    int irq;
-    unsigned int num_chips;	/* 0 if card absent, -1 if Z/PCI, else Y */
-    unsigned int first_line;	/* minor number of first channel on card */
-    unsigned int nports;	/* Number of ports in the card */
-    int bus_index;		/* address shift - 0 for ISA, 1 for PCI */
-    int intr_enabled;		/* FW Interrupt flag - 0 disabled, 1 enabled */
-    spinlock_t card_lock;
-    struct cyclades_port *ports;
+	void __iomem *base_addr;
+	union {
+		void __iomem *p9050;
+		struct RUNTIME_9060 __iomem *p9060;
+	} ctl_addr;
+	int irq;
+	unsigned int num_chips;	/* 0 if card absent, -1 if Z/PCI, else Y */
+	unsigned int first_line;	/* minor number of first channel on card */
+	unsigned int nports;	/* Number of ports in the card */
+	int bus_index;		/* address shift - 0 for ISA, 1 for PCI */
+	int intr_enabled;		/* FW Interrupt flag - 0 disabled, 1 enabled */
+	spinlock_t card_lock;
+	struct cyclades_port *ports;
 };
 
 /***************************************
_

Patches currently in -mm which might be from jirislaby@gmail.com are

linux-next.patch
icom-converting-space-to-tabs.patch
char-isicom-fix-build-warning.patch
reiser4.patch
shrink_slab-handle-bad-shrinkers.patch

