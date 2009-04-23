From: akpm@linux-foundation.org
Subject: + char-cyclades-fix-nports-handling.patch added to -mm tree
Date: Thu, 23 Apr 2009 14:32:28 -0700
Message-ID: <200904232132.n3NLWSb4025629@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51424 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757644AbZDWVfJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 23 Apr 2009 17:35:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jirislaby@gmail.com, alan@lxorguk.ukuu.org.uk, khc@pm.waw.pl


The patch titled
     char: cyclades, fix nports handling
has been added to the -mm tree.  Its filename is
     char-cyclades-fix-nports-handling.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: char: cyclades, fix nports handling
From: Jiri Slaby <jirislaby@gmail.com>

Set up ports right after FW load so that we won't allocate maximal (64)
ports when we use few.

Also remove reading of nports in irq context, since we know it from
initialisation now.

This also fixes a tty ports unregistration on some fail paths and for Ze
which registered 64 and unregistered real port count.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Krzysztof Halasa <khc@pm.waw.pl>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/cyclades.c |   58 +++++++++++---------------------------
 1 file changed, 17 insertions(+), 41 deletions(-)

diff -puN drivers/char/cyclades.c~char-cyclades-fix-nports-handling drivers/char/cyclades.c
--- a/drivers/char/cyclades.c~char-cyclades-fix-nports-handling
+++ a/drivers/char/cyclades.c
@@ -604,7 +604,6 @@
 
 #define NR_PORTS	256
 
-#define ZE_V1_NPORTS	64
 #define ZO_V1	0
 #define ZO_V2	1
 #define ZE_V1	2
@@ -1777,7 +1776,6 @@ static void cyz_poll(unsigned long arg)
 	struct tty_struct *tty;
 	struct FIRM_ID __iomem *firm_id;
 	struct ZFW_CTRL __iomem *zfw_ctrl;
-	struct BOARD_CTRL __iomem *board_ctrl;
 	struct BUF_CTRL __iomem *buf_ctrl;
 	unsigned long expires = jiffies + HZ;
 	unsigned int port, card;
@@ -1793,11 +1791,9 @@ static void cyz_poll(unsigned long arg)
 		firm_id = cinfo->base_addr + ID_ADDRESS;
 		zfw_ctrl = cinfo->base_addr +
 				(readl(&firm_id->zfwctrl_addr) & 0xfffff);
-		board_ctrl = &(zfw_ctrl->board_ctrl);
 
 	/* Skip first polling cycle to avoid racing conditions with the FW */
 		if (!cinfo->intr_enabled) {
-			cinfo->nports = (int)readl(&board_ctrl->n_channel);
 			cinfo->intr_enabled = 1;
 			continue;
 		}
@@ -2413,16 +2409,8 @@ static int cy_open(struct tty_struct *tt
 		   interrupts should be enabled as soon as the first open
 		   happens to one of its ports. */
 			if (!cinfo->intr_enabled) {
-				struct ZFW_CTRL __iomem *zfw_ctrl;
-				struct BOARD_CTRL __iomem *board_ctrl;
 				u16 intr;
 
-				zfw_ctrl = cinfo->base_addr +
-					(readl(&firm_id->zfwctrl_addr) &
-					 0xfffff);
-
-				board_ctrl = &zfw_ctrl->board_ctrl;
-
 				/* Enable interrupts on the PLX chip */
 				intr = readw(&cinfo->ctl_addr.p9060->
 						intr_ctrl_stat) | 0x0900;
@@ -2435,8 +2423,6 @@ static int cy_open(struct tty_struct *tt
 					printk(KERN_ERR "cyc:IRQ enable retval "
 						"was %x\n", retval);
 				}
-				cinfo->nports =
-					(int)readl(&board_ctrl->n_channel);
 				cinfo->intr_enabled = 1;
 			}
 		}
@@ -4340,30 +4326,20 @@ static void cy_hangup(struct tty_struct 
 static int __devinit cy_init_card(struct cyclades_card *cinfo)
 {
 	struct cyclades_port *info;
-	unsigned int nports, port;
+	unsigned int port;
 	unsigned short chip_number;
-	int uninitialized_var(index);
 
 	spin_lock_init(&cinfo->card_lock);
+	cinfo->intr_enabled = 0;
 
-	if (cy_is_Z(cinfo)) {	/* Cyclades-Z */
-		nports = (cinfo->hw_ver == ZE_V1) ? ZE_V1_NPORTS : 8;
-		cinfo->intr_enabled = 0;
-		cinfo->nports = 0;	/* Will be correctly set later, after
-					   Z FW is loaded */
-	} else {
-		index = cinfo->bus_index;
-		nports = cinfo->nports = CyPORTS_PER_CHIP * cinfo->num_chips;
-	}
-
-	cinfo->ports = kzalloc(sizeof(*cinfo->ports) * nports, GFP_KERNEL);
+	cinfo->ports = kcalloc(cinfo->nports, sizeof(*cinfo->ports),
+			GFP_KERNEL);
 	if (cinfo->ports == NULL) {
 		printk(KERN_ERR "Cyclades: cannot allocate ports\n");
-		cinfo->nports = 0;
 		return -ENOMEM;
 	}
 
-	for (port = cinfo->first_line; port < cinfo->first_line + nports;
+	for (port = cinfo->first_line; port < cinfo->first_line + cinfo->nports;
 			port++) {
 		info = &cinfo->ports[port - cinfo->first_line];
 		tty_port_init(&info->port);
@@ -4388,6 +4364,7 @@ static int __devinit cy_init_card(struct
 				cyz_rx_restart, (unsigned long)info);
 #endif
 		} else {
+			int index = cinfo->bus_index;
 			info->type = PORT_CIRRUS;
 			info->xmit_fifo_size = CyMAX_CHAR_FIFO;
 			info->cor1 = CyPARITY_NONE | Cy_1_STOP | Cy_8_BITS;
@@ -4615,7 +4592,8 @@ static int __init cy_detect_isa(void)
 		cy_card[j].irq = (int)cy_isa_irq;
 		cy_card[j].bus_index = 0;
 		cy_card[j].first_line = cy_next_channel;
-		cy_card[j].num_chips = cy_isa_nchan / 4;
+		cy_card[j].num_chips = cy_isa_nchan / CyPORTS_PER_CHIP;
+		cy_card[j].nports = cy_isa_nchan;
 		if (cy_init_card(&cy_card[j])) {
 			cy_card[j].base_addr = NULL;
 			free_irq(cy_isa_irq, &cy_card[j]);
@@ -4771,7 +4749,7 @@ static int __devinit cyz_load_fw(struct 
 	struct CUSTOM_REG __iomem *cust = base_addr;
 	struct ZFW_CTRL __iomem *pt_zfwctrl;
 	void __iomem *tmp;
-	u32 mailbox, status;
+	u32 mailbox, status, nchan;
 	unsigned int i;
 	int retval;
 
@@ -4892,11 +4870,11 @@ static int __devinit cyz_load_fw(struct 
 			base_addr + ID_ADDRESS, readl(&fid->zfwctrl_addr),
 			base_addr + readl(&fid->zfwctrl_addr));
 
+	nchan = readl(&pt_zfwctrl->board_ctrl.n_channel);
 	dev_info(&pdev->dev, "Cyclades-Z FW loaded: version = %x, ports = %u\n",
-		readl(&pt_zfwctrl->board_ctrl.fw_version),
-		readl(&pt_zfwctrl->board_ctrl.n_channel));
+		readl(&pt_zfwctrl->board_ctrl.fw_version), nchan);
 
-	if (readl(&pt_zfwctrl->board_ctrl.n_channel) == 0) {
+	if (nchan == 0) {
 		dev_warn(&pdev->dev, "no Cyclades-Z ports were found. Please "
 			"check the connection between the Z host card and the "
 			"serial expanders.\n");
@@ -4922,7 +4900,7 @@ static int __devinit cyz_load_fw(struct 
 	cy_writel(&ctl_addr->intr_ctrl_stat, readl(&ctl_addr->intr_ctrl_stat) |
 			0x00030800UL);
 
-	return 0;
+	return nchan;
 err_rel:
 	release_firmware(fw);
 err:
@@ -5027,12 +5005,8 @@ static int __devinit cy_pci_probe(struct
 
 		if (mailbox == ZE_V1) {
 			card_name = "Cyclades-Ze";
-
-			nchan = ZE_V1_NPORTS;
 		} else {
 			card_name = "Cyclades-8Zo";
-			nchan = 8;
-
 #ifdef CY_PCI_DEBUG
 			if (mailbox == ZO_V1) {
 				cy_writel(&ctl_addr->loc_addr_base, WIN_CREG);
@@ -5057,8 +5031,9 @@ static int __devinit cy_pci_probe(struct
 		}
 
 		retval = cyz_load_fw(pdev, addr2, addr0, irq);
-		if (retval)
+		if (retval <= 0)
 			goto err_unmap;
+		nchan = retval;
 	}
 
 	if ((cy_next_channel + nchan) > NR_PORTS) {
@@ -5088,7 +5063,7 @@ static int __devinit cy_pci_probe(struct
 			dev_err(&pdev->dev, "could not allocate IRQ\n");
 			goto err_unmap;
 		}
-		cy_card[card_no].num_chips = nchan / 4;
+		cy_card[card_no].num_chips = nchan / CyPORTS_PER_CHIP;
 	} else {
 		cy_card[card_no].hw_ver = mailbox;
 		cy_card[card_no].num_chips = (unsigned int)-1;
@@ -5112,6 +5087,7 @@ static int __devinit cy_pci_probe(struct
 	cy_card[card_no].irq = irq;
 	cy_card[card_no].bus_index = 1;
 	cy_card[card_no].first_line = cy_next_channel;
+	cy_card[card_no].nports = nchan;
 	retval = cy_init_card(&cy_card[card_no]);
 	if (retval)
 		goto err_null;
_

Patches currently in -mm which might be from jirislaby@gmail.com are

linux-next.patch
icom-converting-space-to-tabs.patch
char-isicom-fix-build-warning.patch
char-cyclades-plx9060-casts-cleanup.patch
char-cyclades-cache-hw-version.patch
char-cyclades-convert-macros-to-inlines.patch
char-cyclades-remove-typedefs.patch
char-cyclades-fix-nports-handling.patch
char-cyclades-remove-unused-variables.patch
reiser4.patch
shrink_slab-handle-bad-shrinkers.patch

