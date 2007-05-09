From: akpm@linux-foundation.org
Subject: - char-cyclades-probe-cleanup.patch removed from -mm tree
Date: Tue, 08 May 2007 19:58:58 -0700
Message-ID: <200705090258.l492wwrd010336@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:57780 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S968450AbXEIC7E (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 22:59:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jirislaby@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Char: cyclades, probe cleanup
has been removed from the -mm tree.  Its filename was
     char-cyclades-probe-cleanup.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Char: cyclades, probe cleanup
From: Jiri Slaby <jirislaby@gmail.com>

- add fail paths
- merge 3 similar initializations into one (Z, Ze, Y)

[akpm@linux-foundation.org: build fix]
Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/cyclades.c |  468 ++++++++++++++++----------------------
 1 file changed, 198 insertions(+), 270 deletions(-)

diff -puN drivers/char/cyclades.c~char-cyclades-probe-cleanup drivers/char/cyclades.c
--- a/drivers/char/cyclades.c~char-cyclades-probe-cleanup
+++ a/drivers/char/cyclades.c
@@ -4455,6 +4455,7 @@ static int __devinit cy_init_card(struct
 	cinfo->ports = kzalloc(sizeof(*cinfo->ports) * nports, GFP_KERNEL);
 	if (cinfo->ports == NULL) {
 		printk(KERN_ERR "Cyclades: cannot allocate ports\n");
+		cinfo->nports = 0;
 		return -ENOMEM;
 	}
 
@@ -4647,9 +4648,15 @@ static int __init cy_detect_isa(void)
 
 		/* probe for CD1400... */
 		cy_isa_address = ioremap(isa_address, CyISA_Ywin);
+		if (cy_isa_address == NULL) {
+			printk(KERN_ERR "Cyclom-Y/ISA: can't remap base "
+					"address\n");
+			continue;
+		}
 		cy_isa_nchan = CyPORTS_PER_CHIP *
 			cyy_init_card(cy_isa_address, 0);
 		if (cy_isa_nchan == 0) {
+			iounmap(cy_isa_address);
 			continue;
 		}
 #ifdef MODULE
@@ -4663,6 +4670,7 @@ static int __init cy_detect_isa(void)
 			printk(KERN_ERR "Cyclom-Y/ISA found at 0x%lx, but the "
 				"IRQ could not be detected.\n",
 				(unsigned long)cy_isa_address);
+			iounmap(cy_isa_address);
 			continue;
 		}
 
@@ -4671,6 +4679,7 @@ static int __init cy_detect_isa(void)
 				"more channels are available. Change NR_PORTS "
 				"in cyclades.c and recompile kernel.\n",
 				(unsigned long)cy_isa_address);
+			iounmap(cy_isa_address);
 			return nboard;
 		}
 		/* fill the next cy_card structure available */
@@ -4683,6 +4692,7 @@ static int __init cy_detect_isa(void)
 				"more cards can be used. Change NR_CARDS in "
 				"cyclades.c and recompile kernel.\n",
 				(unsigned long)cy_isa_address);
+			iounmap(cy_isa_address);
 			return nboard;
 		}
 
@@ -4692,6 +4702,7 @@ static int __init cy_detect_isa(void)
 			printk(KERN_ERR "Cyclom-Y/ISA found at 0x%lx, but "
 				"could not allocate IRQ#%d.\n",
 				(unsigned long)cy_isa_address, cy_isa_irq);
+			iounmap(cy_isa_address);
 			return nboard;
 		}
 
@@ -4702,7 +4713,12 @@ static int __init cy_detect_isa(void)
 		cy_card[j].bus_index = 0;
 		cy_card[j].first_line = cy_next_channel;
 		cy_card[j].num_chips = cy_isa_nchan / 4;
-		cy_init_card(&cy_card[j]);
+		if (cy_init_card(&cy_card[j])) {
+			cy_card[j].base_addr = NULL;
+			free_irq(cy_isa_irq, &cy_card[j]);
+			iounmap(cy_isa_address);
+			continue;
+		}
 		nboard++;
 
 		printk(KERN_INFO "Cyclom-Y/ISA #%d: 0x%lx-0x%lx, IRQ%d found: "
@@ -4736,333 +4752,245 @@ static void __devinit plx_init(void __io
 	cy_writel(addr + initctl, readl(addr + initctl) & ~0x20000000);
 }
 
-static int __devinit cy_init_Ze(struct RUNTIME_9060 __iomem *cy_pci_addr0,
-		int cy_pci_irq, struct pci_dev *pdev)
-{
-	void __iomem *cy_pci_addr2;
-	unsigned int j;
-	unsigned short cy_pci_nchan;
-
-	cy_pci_addr2 = pci_iomap(pdev, 2, CyPCI_Ze_win);
-
-	readl(&cy_pci_addr0->mail_box_0);
-	dev_dbg(&pdev->dev, "new Cyclades-Z board.  FPGA not loaded\n");
-
-	/* This must be the new Cyclades-Ze/PCI. */
-	cy_pci_nchan = ZE_V1_NPORTS;
-
-	if ((cy_next_channel + cy_pci_nchan) > NR_PORTS) {
-		dev_err(&pdev->dev, "Cyclades-Ze/PCI found, but no channels "
-			"are available.\nChange NR_PORTS in cyclades.c "
-			"and recompile kernel.\n");
-		return -EIO;
-	}
-
-	/* fill the next cy_card structure available */
-	for (j = 0; j < NR_CARDS; j++) {
-		if (cy_card[j].base_addr == NULL)
-			break;
-	}
-	if (j == NR_CARDS) {	/* no more cy_cards available */
-		dev_err(&pdev->dev, "Cyclades-Ze/PCI found, but no more "
-			"cards can be used.\nChange NR_CARDS in "
-			"cyclades.c and recompile kernel.\n");
-		return -EIO;
-	}
-#ifdef CONFIG_CYZ_INTR
-	/* allocate IRQ only if board has an IRQ */
-	if ((cy_pci_irq != 0) && (cy_pci_irq != 255)) {
-		if (request_irq(cy_pci_irq, cyz_interrupt,
-				IRQF_SHARED, "Cyclades-Z",
-				&cy_card[j])) {
-			dev_err(&pdev->dev, "could not allocate IRQ.\n");
-			return -EIO;
-		}
-	}
-#endif				/* CONFIG_CYZ_INTR */
-
-	/* set cy_card */
-	cy_card[j].base_addr = cy_pci_addr2;
-	cy_card[j].ctl_addr = cy_pci_addr0;
-	cy_card[j].irq = cy_pci_irq;
-	cy_card[j].bus_index = 1;
-	cy_card[j].first_line = cy_next_channel;
-	cy_card[j].num_chips = -1;
-	cy_init_card(&cy_card[j]);
-	pci_set_drvdata(pdev, &cy_card[j]);
-
-	dev_info(&pdev->dev, "Cyclades-Ze/PCI #%d found: %d channels starting "
-		"from port %d.\n", j + 1, cy_pci_nchan, cy_next_channel);
-
-	for (j = cy_next_channel; j < cy_next_channel + cy_pci_nchan; j++)
-		tty_register_device(cy_serial_driver, j, &pdev->dev);
-	cy_next_channel += cy_pci_nchan;
-
-	return 0;
-}
-
 static int __devinit cy_pci_probe(struct pci_dev *pdev,
 		const struct pci_device_id *ent)
 {
-	unsigned char cyy_rev_id;
-	int cy_pci_irq;
-	__u32 mailbox;
-	void __iomem *cy_pci_addr0, *cy_pci_addr2;
-	unsigned int device_id;
-	unsigned short j, cy_pci_nchan, plx_ver;
-	int retval;
+	void __iomem *addr0 = NULL, *addr2 = NULL;
+	char *card_name = NULL;
+	u32 mailbox;
+	unsigned int device_id, nchan = 0, card_no, i;
+	unsigned char plx_ver;
+	int retval, irq;
 
 	retval = pci_enable_device(pdev);
 	if (retval) {
 		dev_err(&pdev->dev, "cannot enable device\n");
-		return retval;
+		goto err;
 	}
 
 	/* read PCI configuration area */
-	cy_pci_irq = pdev->irq;
-	pci_read_config_byte(pdev, PCI_REVISION_ID, &cyy_rev_id);
-
+	irq = pdev->irq;
 	device_id = pdev->device & ~PCI_DEVICE_ID_MASK;
 
+#if defined(__alpha__)
+	if (device_id == PCI_DEVICE_ID_CYCLOM_Y_Lo) {	/* below 1M? */
+		dev_err(&pdev->dev, "Cyclom-Y/PCI not supported for low "
+			"addresses on Alpha systems.\n");
+		retval = -EIO;
+		goto err_dis;
+	}
+#endif
+	if (device_id == PCI_DEVICE_ID_CYCLOM_Z_Lo) {
+		dev_err(&pdev->dev, "Cyclades-Z/PCI not supported for low "
+			"addresses\n");
+		retval = -EIO;
+		goto err_dis;
+	}
+
+	if (pci_resource_flags(pdev, 2) & IORESOURCE_IO) {
+		dev_warn(&pdev->dev, "PCI I/O bit incorrectly set. Ignoring "
+				"it...\n");
+		pdev->resource[2].flags &= ~IORESOURCE_IO;
+	}
+
+	retval = pci_request_regions(pdev, "cyclades");
+	if (retval) {
+		dev_err(&pdev->dev, "failed to reserve resources\n");
+		goto err_dis;
+	}
+
+	retval = -EIO;
 	if (device_id == PCI_DEVICE_ID_CYCLOM_Y_Lo ||
 			device_id == PCI_DEVICE_ID_CYCLOM_Y_Hi) {
-		dev_dbg(&pdev->dev, "Cyclom-Y/PCI found\n");
-
-		if (pci_resource_flags(pdev, 2) & IORESOURCE_IO) {
-			dev_warn(&pdev->dev, "PCI I/O bit incorrectly "
-				"set. Ignoring it...\n");
-			pdev->resource[2].flags &= ~IORESOURCE_IO;
-		}
+		card_name = "Cyclom-Y";
 
-		/* Although we don't use this I/O region, we should
-		   request it from the kernel anyway, to avoid problems
-		   with other drivers accessing it. */
-		retval = pci_request_regions(pdev, "Cyclom-Y");
-		if (retval) {
-			dev_err(&pdev->dev, "failed to reserve resources\n");
-			return retval;
+		addr0 = pci_iomap(pdev, 0, CyPCI_Yctl);
+		if (addr0 == NULL) {
+			dev_err(&pdev->dev, "can't remap ctl region\n");
+			goto err_reg;
 		}
-#if defined(__alpha__)
-		if (device_id == PCI_DEVICE_ID_CYCLOM_Y_Lo) {	/* below 1M? */
-			dev_err(&pdev->dev, "Cyclom-Y/PCI not supported for "
-				"low addresses on Alpha systems.\n");
-			return -EIO;
+		addr2 = pci_iomap(pdev, 2, CyPCI_Ywin);
+		if (addr2 == NULL) {
+			dev_err(&pdev->dev, "can't remap base region\n");
+			goto err_unmap;
 		}
-#endif
-		cy_pci_addr0 = pci_iomap(pdev, 0, CyPCI_Yctl);
-		cy_pci_addr2 = pci_iomap(pdev, 2, CyPCI_Ywin);
-
-		dev_dbg(&pdev->dev, "Cyclom-Y/PCI: relocate winaddr=0x%p "
-			"ctladdr=0x%p\n", cy_pci_addr2, cy_pci_addr0);
 
-		cy_pci_nchan = (unsigned short)(CyPORTS_PER_CHIP *
-				cyy_init_card(cy_pci_addr2, 1));
-		if (cy_pci_nchan == 0) {
+		nchan = CyPORTS_PER_CHIP * cyy_init_card(addr2, 1);
+		if (nchan == 0) {
 			dev_err(&pdev->dev, "Cyclom-Y PCI host card with no "
 					"Serial-Modules\n");
 			return -EIO;
 		}
-		if ((cy_next_channel + cy_pci_nchan) > NR_PORTS) {
-			dev_err(&pdev->dev, "Cyclom-Y/PCI found, but no "
-				"channels are available. Change NR_PORTS in "
-				"cyclades.c and recompile kernel.\n");
-			return -EIO;
-		}
-		/* fill the next cy_card structure available */
-		for (j = 0; j < NR_CARDS; j++) {
-			if (cy_card[j].base_addr == NULL)
-				break;
-		}
-		if (j == NR_CARDS) {	/* no more cy_cards available */
-			dev_err(&pdev->dev, "Cyclom-Y/PCI found, but no more "
-				"cards can be used. Change NR_CARDS in "
-				"cyclades.c and recompile kernel.\n");
-			return -EIO;
-		}
-
-		/* allocate IRQ */
-		retval = request_irq(cy_pci_irq, cyy_interrupt,
-				IRQF_SHARED, "Cyclom-Y", &cy_card[j]);
-		if (retval) {
-			dev_err(&pdev->dev, "could not allocate IRQ\n");
-			return retval;
-		}
-
-		/* set cy_card */
-		cy_card[j].base_addr = cy_pci_addr2;
-		cy_card[j].ctl_addr = cy_pci_addr0;
-		cy_card[j].irq = cy_pci_irq;
-		cy_card[j].bus_index = 1;
-		cy_card[j].first_line = cy_next_channel;
-		cy_card[j].num_chips = cy_pci_nchan / 4;
-		cy_init_card(&cy_card[j]);
-		pci_set_drvdata(pdev, &cy_card[j]);
-
-		/* enable interrupts in the PCI interface */
-		plx_ver = readb(cy_pci_addr2 + CyPLX_VER) & 0x0f;
-		switch (plx_ver) {
-		case PLX_9050:
-
-			cy_writeb(cy_pci_addr0 + 0x4c, 0x43);
-			break;
-
-		case PLX_9060:
-		case PLX_9080:
-		default:	/* Old boards, use PLX_9060 */
-
-			plx_init(cy_pci_addr0, 0x6c);
-		/* For some yet unknown reason, once the PLX9060 reloads
-		   the EEPROM, the IRQ is lost and, thus, we have to
-		   re-write it to the PCI config. registers.
-		   This will remain here until we find a permanent
-		   fix. */
-			pci_write_config_byte(pdev, PCI_INTERRUPT_LINE,
-					cy_pci_irq);
-
-			cy_writew(cy_pci_addr0 + 0x68,
-				readw(cy_pci_addr0 + 0x68) | 0x0900);
-			break;
-		}
-
-		dev_info(&pdev->dev, "Cyclom-Y/PCI #%d found: %d channels "
-			"starting from port %d.\n", j + 1, cy_pci_nchan,
-			cy_next_channel);
-
-		for (j = cy_next_channel;
-				j < cy_next_channel + cy_pci_nchan; j++)
-			tty_register_device(cy_serial_driver, j, &pdev->dev);
-
-		cy_next_channel += cy_pci_nchan;
-	} else if (device_id == PCI_DEVICE_ID_CYCLOM_Z_Lo) {
-		dev_err(&pdev->dev, "Cyclades-Z/PCI not supported for "
-			"low addresses\n");
-		return -EIO;
 	} else if (device_id == PCI_DEVICE_ID_CYCLOM_Z_Hi) {
-		dev_dbg(&pdev->dev, "Cyclades-Z/PCI found\n");
+		struct RUNTIME_9060 __iomem *ctl_addr;
 
-		cy_pci_addr0 = pci_iomap(pdev, 0, CyPCI_Zctl);
+		ctl_addr = addr0 = pci_iomap(pdev, 0, CyPCI_Zctl);
+		if (addr0 == NULL) {
+			dev_err(&pdev->dev, "can't remap ctl region\n");
+			goto err_reg;
+		}
 
 		/* Disable interrupts on the PLX before resetting it */
-		cy_writew(cy_pci_addr0 + 0x68,
-			readw(cy_pci_addr0 + 0x68) & ~0x0900);
+		cy_writew(addr0 + 0x68,
+			readw(addr0 + 0x68) & ~0x0900);
 
-		plx_init(cy_pci_addr0, 0x6c);
+		plx_init(addr0, 0x6c);
 		/* For some yet unknown reason, once the PLX9060 reloads
 		   the EEPROM, the IRQ is lost and, thus, we have to
 		   re-write it to the PCI config. registers.
 		   This will remain here until we find a permanent
 		   fix. */
-		pci_write_config_byte(pdev, PCI_INTERRUPT_LINE, cy_pci_irq);
+		pci_write_config_byte(pdev, PCI_INTERRUPT_LINE, irq);
 
-		mailbox = (__u32)readl(&((struct RUNTIME_9060 __iomem *)
-				cy_pci_addr0)->mail_box_0);
+		mailbox = (u32)readl(&ctl_addr->mail_box_0);
 
-		if (pci_resource_flags(pdev, 2) & IORESOURCE_IO) {
-			dev_warn(&pdev->dev, "PCI I/O bit incorrectly "
-				"set. Ignoring it...\n");
-			pdev->resource[2].flags &= ~IORESOURCE_IO;
-		}
-
-		/* Although we don't use this I/O region, we should
-		   request it from the kernel anyway, to avoid problems
-		   with other drivers accessing it. */
-		retval = pci_request_regions(pdev, "Cyclades-Z");
-		if (retval) {
-			dev_err(&pdev->dev, "failed to reserve resources\n");
-			return retval;
+		addr2 = pci_iomap(pdev, 2, mailbox == ZE_V1 ?
+				CyPCI_Ze_win : CyPCI_Zwin);
+		if (addr2 == NULL) {
+			dev_err(&pdev->dev, "can't remap base region\n");
+			goto err_unmap;
 		}
 
 		if (mailbox == ZE_V1) {
-			retval = cy_init_Ze(cy_pci_addr0, cy_pci_irq, pdev);
-			return retval;
+			card_name = "Cyclades-Ze";
+
+			readl(&ctl_addr->mail_box_0);
+			nchan = ZE_V1_NPORTS;
 		} else {
-			cy_pci_addr2 = pci_iomap(pdev, 2, CyPCI_Zwin);
-		}
+			card_name = "Cyclades-8Zo";
 
-		dev_dbg(&pdev->dev, "Cyclades-Z/PCI: relocate winaddr=0x%p "
-			"ctladdr=0x%p\n", cy_pci_addr2, cy_pci_addr0);
 #ifdef CY_PCI_DEBUG
-		if (mailbox == ZO_V1) {
-			cy_writel(&((struct RUNTIME_9060 *)
-				(cy_pci_addr0))->loc_addr_base,
-				WIN_CREG);
-			dev_info(&pdev->dev, "Cyclades-8Zo/PCI: FPGA id %lx, "
-				"ver %lx\n", (ulong)(0xff &
-				readl(&((struct CUSTOM_REG *)
-					cy_pci_addr2)->fpga_id)),
-				(ulong)(0xff & readl(&((struct CUSTOM_REG *)
-					cy_pci_addr2)->fpga_version)));
-			cy_writel(&((struct RUNTIME_9060 *)
-				cy_pci_addr0)->loc_addr_base, WIN_RAM);
-		} else {
-			dev_info(&pdev->dev, "Cyclades-Z/PCI: New Cyclades-Z "
-				"board.  FPGA not loaded\n");
-		}
+			if (mailbox == ZO_V1) {
+				cy_writel(&ctl_addr->loc_addr_base, WIN_CREG);
+				dev_info(&pdev->dev, "Cyclades-8Zo/PCI: FPGA "
+					"id %lx, ver %lx\n", (ulong)(0xff &
+					readl(&((struct CUSTOM_REG *)addr2)->
+						fpga_id)), (ulong)(0xff &
+					readl(&((struct CUSTOM_REG *)addr2)->
+						fpga_version)));
+				cy_writel(&ctl_addr->loc_addr_base, WIN_RAM);
+			} else {
+				dev_info(&pdev->dev, "Cyclades-Z/PCI: New "
+					"Cyclades-Z board.  FPGA not loaded\n");
+			}
 #endif
-		/* The following clears the firmware id word.  This
-		   ensures that the driver will not attempt to talk to
-		   the board until it has been properly initialized.
-		 */
-		if ((mailbox == ZO_V1) || (mailbox == ZO_V2))
-			cy_writel(cy_pci_addr2 + ID_ADDRESS, 0L);
+			/* The following clears the firmware id word.  This
+			   ensures that the driver will not attempt to talk to
+			   the board until it has been properly initialized.
+			 */
+			if ((mailbox == ZO_V1) || (mailbox == ZO_V2))
+				cy_writel(addr2 + ID_ADDRESS, 0L);
 
-		/* This must be a Cyclades-8Zo/PCI.  The extendable
-		   version will have a different device_id and will
-		   be allocated its maximum number of ports. */
-		cy_pci_nchan = 8;
-
-		if ((cy_next_channel + cy_pci_nchan) > NR_PORTS) {
-			dev_err(&pdev->dev, "Cyclades-8Zo/PCI found, but no "
-				"channels are available. Change NR_PORTS in "
-				"cyclades.c and recompile kernel.\n");
-			return -EIO;
+			/* This must be a Cyclades-8Zo/PCI.  The extendable
+			   version will have a different device_id and will
+			   be allocated its maximum number of ports. */
+			nchan = 8;
 		}
+	}
 
-		/* fill the next cy_card structure available */
-		for (j = 0; j < NR_CARDS; j++) {
-			if (cy_card[j].base_addr == NULL)
-				break;
-		}
-		if (j == NR_CARDS) {	/* no more cy_cards available */
-			dev_err(&pdev->dev, "Cyclades-8Zo/PCI found, but no "
-				"more cards can be used. Change NR_CARDS in "
-				"cyclades.c and recompile kernel.\n");
-			return -EIO;
+	if ((cy_next_channel + nchan) > NR_PORTS) {
+		dev_err(&pdev->dev, "Cyclades-8Zo/PCI found, but no "
+			"channels are available. Change NR_PORTS in "
+			"cyclades.c and recompile kernel.\n");
+		goto err_unmap;
+	}
+	/* fill the next cy_card structure available */
+	for (card_no = 0; card_no < NR_CARDS; card_no++) {
+		if (cy_card[card_no].base_addr == NULL)
+			break;
+	}
+	if (card_no == NR_CARDS) {	/* no more cy_cards available */
+		dev_err(&pdev->dev, "Cyclades-8Zo/PCI found, but no "
+			"more cards can be used. Change NR_CARDS in "
+			"cyclades.c and recompile kernel.\n");
+		goto err_unmap;
+	}
+
+	if (device_id == PCI_DEVICE_ID_CYCLOM_Y_Lo ||
+			device_id == PCI_DEVICE_ID_CYCLOM_Y_Hi) {
+		/* allocate IRQ */
+		retval = request_irq(irq, cyy_interrupt,
+				IRQF_SHARED, "Cyclom-Y", &cy_card[card_no]);
+		if (retval) {
+			dev_err(&pdev->dev, "could not allocate IRQ\n");
+			goto err_unmap;
 		}
+		cy_card[card_no].num_chips = nchan / 4;
+	} else {
 #ifdef CONFIG_CYZ_INTR
 		/* allocate IRQ only if board has an IRQ */
-		if ((cy_pci_irq != 0) && (cy_pci_irq != 255)) {
-			retval = request_irq(cy_pci_irq, cyz_interrupt,
+		if (irq != 0 && irq != 255) {
+			retval = request_irq(irq, cyz_interrupt,
 					IRQF_SHARED, "Cyclades-Z",
-					&cy_card[j]);
+					&cy_card[card_no]);
 			if (retval) {
 				dev_err(&pdev->dev, "could not allocate IRQ\n");
-				return retval;
+				goto err_unmap;
 			}
 		}
 #endif				/* CONFIG_CYZ_INTR */
+		cy_card[card_no].num_chips = -1;
+	}
 
-		/* set cy_card */
-		cy_card[j].base_addr = cy_pci_addr2;
-		cy_card[j].ctl_addr = cy_pci_addr0;
-		cy_card[j].irq = cy_pci_irq;
-		cy_card[j].bus_index = 1;
-		cy_card[j].first_line = cy_next_channel;
-		cy_card[j].num_chips = -1;
-		cy_init_card(&cy_card[j]);
-		pci_set_drvdata(pdev, &cy_card[j]);
-
-		dev_info(&pdev->dev, "Cyclades-8Zo/PCI #%d found: %d channels "
-			"starting from port %d.\n", j + 1, cy_pci_nchan,
-			cy_next_channel);
+	/* set cy_card */
+	cy_card[card_no].base_addr = addr2;
+	cy_card[card_no].ctl_addr = addr0;
+	cy_card[card_no].irq = irq;
+	cy_card[card_no].bus_index = 1;
+	cy_card[card_no].first_line = cy_next_channel;
+	retval = cy_init_card(&cy_card[card_no]);
+	if (retval)
+		goto err_null;
 
-		for (j = cy_next_channel;
-				j < cy_next_channel + cy_pci_nchan; j++)
-			tty_register_device(cy_serial_driver, j, &pdev->dev);
-		cy_next_channel += cy_pci_nchan;
+	pci_set_drvdata(pdev, &cy_card[card_no]);
+
+	if (device_id == PCI_DEVICE_ID_CYCLOM_Y_Lo ||
+			device_id == PCI_DEVICE_ID_CYCLOM_Y_Hi) {
+		/* enable interrupts in the PCI interface */
+		plx_ver = readb(addr2 + CyPLX_VER) & 0x0f;
+		switch (plx_ver) {
+		case PLX_9050:
+
+			cy_writeb(addr0 + 0x4c, 0x43);
+			break;
+
+		case PLX_9060:
+		case PLX_9080:
+		default:	/* Old boards, use PLX_9060 */
+
+			plx_init(addr0, 0x6c);
+		/* For some yet unknown reason, once the PLX9060 reloads
+		   the EEPROM, the IRQ is lost and, thus, we have to
+		   re-write it to the PCI config. registers.
+		   This will remain here until we find a permanent
+		   fix. */
+			pci_write_config_byte(pdev, PCI_INTERRUPT_LINE, irq);
+
+			cy_writew(addr0 + 0x68, readw(addr0 + 0x68) | 0x0900);
+			break;
+		}
 	}
 
+	dev_info(&pdev->dev, "%s/PCI #%d found: %d channels starting from "
+		"port %d.\n", card_name, card_no + 1, nchan, cy_next_channel);
+	for (i = cy_next_channel; i < cy_next_channel + nchan; i++)
+		tty_register_device(cy_serial_driver, i, &pdev->dev);
+	cy_next_channel += nchan;
+
 	return 0;
+err_null:
+	cy_card[card_no].base_addr = NULL;
+	free_irq(irq, &cy_card[card_no]);
+err_unmap:
+	pci_iounmap(pdev, addr0);
+	if (addr2)
+		pci_iounmap(pdev, addr2);
+err_reg:
+	pci_release_regions(pdev);
+err_dis:
+	pci_disable_device(pdev);
+err:
+	return retval;
 }
 
 static void __devexit cy_pci_remove(struct pci_dev *pdev)
_

Patches currently in -mm which might be from jirislaby@gmail.com are

origin.patch
git-dvb.patch
cinergyt2-fix-file-release-handler.patch
auerswald-fix-file-release-handler.patch
unify-queue_delayed_work-and-queue_delayed_work_on.patch
vmstat-use-our-own-timer-events-fix.patch
shrink_slab-handle-bad-shrinkers.patch
