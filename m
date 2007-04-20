From: akpm@linux-foundation.org
Subject: + char-cyclades-create-cy_pci_probe.patch added to -mm tree
Date: Thu, 19 Apr 2007 21:53:59 -0700
Message-ID: <200704200453.l3K4rx7r007147@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:33537 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1422651AbXDTEyE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 20 Apr 2007 00:54:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jirislaby@gmail.com


The patch titled
     Char: cyclades, create cy_pci_probe
has been added to the -mm tree.  Its filename is
     char-cyclades-create-cy_pci_probe.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Char: cyclades, create cy_pci_probe
From: Jiri Slaby <jirislaby@gmail.com>

Move probing code to separate function for easy pci probing conversion.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/cyclades.c |  623 +++++++++++++++++++-------------------
 1 file changed, 318 insertions(+), 305 deletions(-)

diff -puN drivers/char/cyclades.c~char-cyclades-create-cy_pci_probe drivers/char/cyclades.c
--- a/drivers/char/cyclades.c~char-cyclades-create-cy_pci_probe
+++ a/drivers/char/cyclades.c
@@ -4698,7 +4698,8 @@ static int __init cy_detect_isa(void)
 #endif				/* CONFIG_ISA */
 }				/* cy_detect_isa */
 
-static void plx_init(void __iomem * addr, __u32 initctl)
+#ifdef CONFIG_PCI
+static void __devinit plx_init(void __iomem * addr, __u32 initctl)
 {
 	/* Reset PLX */
 	cy_writel(addr + initctl, readl(addr + initctl) | 0x40000000);
@@ -4800,355 +4801,367 @@ static int __devinit cy_init_Ze(unsigned
 	return 0;
 }
 
-/*
- * ---------------------------------------------------------------------
- * cy_detect_pci() - Test PCI bus presence and Cyclom-Ye/PCI.
- * sets global variables and return the number of PCI boards found.
- * ---------------------------------------------------------------------
- */
-static int __init cy_detect_pci(void)
+static int __devinit cy_pci_probe(struct pci_dev *pdev,
+		const struct pci_device_id *ent)
 {
-#ifdef CONFIG_PCI
-
-	struct pci_dev *pdev = NULL;
 	unsigned char cyy_rev_id;
-	unsigned char cy_pci_irq = 0;
-	__u32 cy_pci_phys0, cy_pci_phys2;
+	unsigned char cy_pci_irq;
+	__u32 cy_pci_phys0, cy_pci_phys2, mailbox;
 	void __iomem *cy_pci_addr0, *cy_pci_addr2;
-	unsigned short i, j, cy_pci_nchan, plx_ver;
-	unsigned short device_id, dev_index = 0;
-	__u32 mailbox;
+	unsigned int device_id;
+	unsigned short j, cy_pci_nchan, plx_ver;
 	int retval;
 
-	for (i = 0; i < NR_CARDS; i++) {
-		/* look for a Cyclades card by vendor and device id */
-		while ((device_id = cy_pci_dev_id[dev_index].device) != 0) {
-			if ((pdev = pci_get_device(PCI_VENDOR_ID_CYCLADES,
-						   device_id, pdev)) == NULL) {
-				dev_index++;	/* try next device id */
-			} else {
-				break;	/* found a board */
-			}
-		}
-
-		if (device_id == 0)
-			break;
+	retval = pci_enable_device(pdev);
+	if (retval) {
+		dev_err(&pdev->dev, "cannot enable device\n");
+		return retval;
+	}
+
+	/* read PCI configuration area */
+	cy_pci_irq = pdev->irq;
+	cy_pci_phys0 = pci_resource_start(pdev, 0);
+	cy_pci_phys2 = pci_resource_start(pdev, 2);
+	pci_read_config_byte(pdev, PCI_REVISION_ID, &cyy_rev_id);
 
-		if (pci_enable_device(pdev))
-			continue;
+	device_id = pdev->device & ~PCI_DEVICE_ID_MASK;
 
-		/* read PCI configuration area */
-		cy_pci_irq = pdev->irq;
-		cy_pci_phys0 = pci_resource_start(pdev, 0);
-		cy_pci_phys2 = pci_resource_start(pdev, 2);
-		pci_read_config_byte(pdev, PCI_REVISION_ID, &cyy_rev_id);
+	if (device_id == PCI_DEVICE_ID_CYCLOM_Y_Lo ||
+			device_id == PCI_DEVICE_ID_CYCLOM_Y_Hi) {
+#ifdef CY_PCI_DEBUG
+		printk("Cyclom-Y/PCI (bus=0x0%x, pci_id=0x%x, ",
+			pdev->bus->number, pdev->devfn);
+		printk("rev_id=%d) IRQ%d\n",
+			cyy_rev_id, (int)cy_pci_irq);
+		printk("Cyclom-Y/PCI:found  winaddr=0x%lx "
+			"ctladdr=0x%lx\n",
+			(ulong)cy_pci_phys2, (ulong)cy_pci_phys0);
+#endif
 
-		device_id &= ~PCI_DEVICE_ID_MASK;
+		if (pci_resource_flags(pdev, 2) & IORESOURCE_IO) {
+			printk("  Warning: PCI I/O bit incorrectly "
+				"set. Ignoring it...\n");
+			pdev->resource[2].flags &= ~IORESOURCE_IO;
+		}
 
-		if (device_id == PCI_DEVICE_ID_CYCLOM_Y_Lo ||
-				device_id == PCI_DEVICE_ID_CYCLOM_Y_Hi) {
-#ifdef CY_PCI_DEBUG
+		/* Although we don't use this I/O region, we should
+		   request it from the kernel anyway, to avoid problems
+		   with other drivers accessing it. */
+		retval = pci_request_regions(pdev, "Cyclom-Y");
+		if (retval) {
+			printk(KERN_ERR "cyclades: failed to reserve "
+					"PCI resources\n");
+			return retval;
+		}
+#if defined(__alpha__)
+		if (device_id == PCI_DEVICE_ID_CYCLOM_Y_Lo) {	/* below 1M? */
 			printk("Cyclom-Y/PCI (bus=0x0%x, pci_id=0x%x, ",
 				pdev->bus->number, pdev->devfn);
 			printk("rev_id=%d) IRQ%d\n",
 				cyy_rev_id, (int)cy_pci_irq);
 			printk("Cyclom-Y/PCI:found  winaddr=0x%lx "
 				"ctladdr=0x%lx\n",
-				(ulong)cy_pci_phys2, (ulong)cy_pci_phys0);
-#endif
-
-			if (pci_resource_flags(pdev, 2) & IORESOURCE_IO) {
-				printk("  Warning: PCI I/O bit incorrectly "
-					"set. Ignoring it...\n");
-				pdev->resource[2].flags &= ~IORESOURCE_IO;
-			}
-
-			/* Although we don't use this I/O region, we should
-			   request it from the kernel anyway, to avoid problems
-			   with other drivers accessing it. */
-			if (pci_request_regions(pdev, "Cyclom-Y") != 0) {
-				printk(KERN_ERR "cyclades: failed to reserve "
-						"PCI resources\n");
-				continue;
-			}
-#if defined(__alpha__)
-			if (device_id == PCI_DEVICE_ID_CYCLOM_Y_Lo) {	/* below 1M? */
-				printk("Cyclom-Y/PCI (bus=0x0%x, pci_id=0x%x, ",
-					pdev->bus->number, pdev->devfn);
-				printk("rev_id=%d) IRQ%d\n",
-					cyy_rev_id, (int)cy_pci_irq);
-				printk("Cyclom-Y/PCI:found  winaddr=0x%lx "
-					"ctladdr=0x%lx\n",
-					(ulong)cy_pci_phys2,
-					(ulong)cy_pci_phys0);
-				printk("Cyclom-Y/PCI not supported for low "
-					"addresses in Alpha systems.\n");
-				i--;
-				continue;
-			}
+				(ulong)cy_pci_phys2,
+				(ulong)cy_pci_phys0);
+			printk("Cyclom-Y/PCI not supported for low "
+				"addresses in Alpha systems.\n");
+			return -EIO;
+		}
 #endif
-			cy_pci_addr0 = pci_iomap(pdev, 0, CyPCI_Yctl);
-			cy_pci_addr2 = pci_iomap(pdev, 2, CyPCI_Ywin);
+		cy_pci_addr0 = pci_iomap(pdev, 0, CyPCI_Yctl);
+		cy_pci_addr2 = pci_iomap(pdev, 2, CyPCI_Ywin);
 
 #ifdef CY_PCI_DEBUG
-			printk("Cyclom-Y/PCI: relocate winaddr=0x%lx "
-				"ctladdr=0x%lx\n",
-				(u_long)cy_pci_addr2, (u_long)cy_pci_addr0);
+		printk("Cyclom-Y/PCI: relocate winaddr=0x%lx "
+			"ctladdr=0x%lx\n",
+			(u_long)cy_pci_addr2, (u_long)cy_pci_addr0);
 #endif
-			cy_pci_nchan = (unsigned short)(CyPORTS_PER_CHIP *
-					cyy_init_card(cy_pci_addr2, 1));
-			if (cy_pci_nchan == 0) {
-				printk("Cyclom-Y PCI host card with ");
-				printk("no Serial-Modules at 0x%lx.\n",
-					(ulong) cy_pci_phys2);
-				i--;
-				continue;
-			}
-			if ((cy_next_channel + cy_pci_nchan) > NR_PORTS) {
-				printk("Cyclom-Y/PCI found at 0x%lx ",
-					(ulong) cy_pci_phys2);
-				printk("but no channels are available.\n");
-				printk("Change NR_PORTS in cyclades.c and "
-						"recompile kernel.\n");
-				return i;
-			}
-			/* fill the next cy_card structure available */
-			for (j = 0; j < NR_CARDS; j++) {
-				if (cy_card[j].base_addr == 0)
-					break;
-			}
-			if (j == NR_CARDS) {	/* no more cy_cards available */
-				printk("Cyclom-Y/PCI found at 0x%lx ",
-					(ulong) cy_pci_phys2);
-				printk("but no more cards can be used.\n");
-				printk("Change NR_CARDS in cyclades.c and "
-						"recompile kernel.\n");
-				return i;
-			}
-
-			/* allocate IRQ */
-			if (request_irq(cy_pci_irq, cyy_interrupt,
-					IRQF_SHARED, "Cyclom-Y", &cy_card[j])) {
-				printk("Cyclom-Y/PCI found at 0x%lx ",
-					(ulong) cy_pci_phys2);
-				printk("but could not allocate IRQ%d.\n",
-					cy_pci_irq);
-				return i;
-			}
+		cy_pci_nchan = (unsigned short)(CyPORTS_PER_CHIP *
+				cyy_init_card(cy_pci_addr2, 1));
+		if (cy_pci_nchan == 0) {
+			printk("Cyclom-Y PCI host card with ");
+			printk("no Serial-Modules at 0x%lx.\n",
+				(ulong) cy_pci_phys2);
+			return -EIO;
+		}
+		if ((cy_next_channel + cy_pci_nchan) > NR_PORTS) {
+			printk("Cyclom-Y/PCI found at 0x%lx ",
+				(ulong) cy_pci_phys2);
+			printk("but no channels are available.\n");
+			printk("Change NR_PORTS in cyclades.c and "
+					"recompile kernel.\n");
+			return -EIO;
+		}
+		/* fill the next cy_card structure available */
+		for (j = 0; j < NR_CARDS; j++) {
+			if (cy_card[j].base_addr == 0)
+				break;
+		}
+		if (j == NR_CARDS) {	/* no more cy_cards available */
+			printk("Cyclom-Y/PCI found at 0x%lx ",
+				(ulong) cy_pci_phys2);
+			printk("but no more cards can be used.\n");
+			printk("Change NR_CARDS in cyclades.c and "
+					"recompile kernel.\n");
+			return -EIO;
+		}
 
-			/* set cy_card */
-			cy_card[j].base_phys = (ulong) cy_pci_phys2;
-			cy_card[j].ctl_phys = (ulong) cy_pci_phys0;
-			cy_card[j].base_addr = cy_pci_addr2;
-			cy_card[j].ctl_addr = cy_pci_addr0;
-			cy_card[j].irq = (int)cy_pci_irq;
-			cy_card[j].bus_index = 1;
-			cy_card[j].first_line = cy_next_channel;
-			cy_card[j].num_chips = cy_pci_nchan / 4;
-			cy_card[j].pdev = pdev;
-			pci_set_drvdata(pdev, &cy_card[j]);
-
-			/* enable interrupts in the PCI interface */
-			plx_ver = readb(cy_pci_addr2 + CyPLX_VER) & 0x0f;
-			switch (plx_ver) {
-			case PLX_9050:
+		/* allocate IRQ */
+		retval = request_irq(cy_pci_irq, cyy_interrupt,
+				IRQF_SHARED, "Cyclom-Y", &cy_card[j]);
+		if (retval) {
+			printk("Cyclom-Y/PCI found at 0x%lx ",
+				(ulong) cy_pci_phys2);
+			printk("but could not allocate IRQ%d.\n",
+				cy_pci_irq);
+			return retval;
+		}
 
-				cy_writeb(cy_pci_addr0 + 0x4c, 0x43);
-				break;
+		/* set cy_card */
+		cy_card[j].base_phys = (ulong) cy_pci_phys2;
+		cy_card[j].ctl_phys = (ulong) cy_pci_phys0;
+		cy_card[j].base_addr = cy_pci_addr2;
+		cy_card[j].ctl_addr = cy_pci_addr0;
+		cy_card[j].irq = (int)cy_pci_irq;
+		cy_card[j].bus_index = 1;
+		cy_card[j].first_line = cy_next_channel;
+		cy_card[j].num_chips = cy_pci_nchan / 4;
+		cy_card[j].pdev = pdev;
+		pci_set_drvdata(pdev, &cy_card[j]);
+
+		/* enable interrupts in the PCI interface */
+		plx_ver = readb(cy_pci_addr2 + CyPLX_VER) & 0x0f;
+		switch (plx_ver) {
+		case PLX_9050:
 
-			case PLX_9060:
-			case PLX_9080:
-			default:	/* Old boards, use PLX_9060 */
-
-				plx_init(cy_pci_addr0, 0x6c);
-			/* For some yet unknown reason, once the PLX9060 reloads
-			   the EEPROM, the IRQ is lost and, thus, we have to
-			   re-write it to the PCI config. registers.
-			   This will remain here until we find a permanent
-			   fix. */
-				pci_write_config_byte(pdev, PCI_INTERRUPT_LINE,
-						cy_pci_irq);
+			cy_writeb(cy_pci_addr0 + 0x4c, 0x43);
+			break;
 
-				cy_writew(cy_pci_addr0 + 0x68,
-					readw(cy_pci_addr0 + 0x68) | 0x0900);
-				break;
-			}
+		case PLX_9060:
+		case PLX_9080:
+		default:	/* Old boards, use PLX_9060 */
 
-			/* print message */
-			printk("Cyclom-Y/PCI #%d: 0x%lx-0x%lx, IRQ%d, ",
-				j + 1, (ulong)cy_pci_phys2,
-				(ulong) (cy_pci_phys2 + CyPCI_Ywin - 1),
-				(int)cy_pci_irq);
-			printk("%d channels starting from port %d.\n",
-				cy_pci_nchan, cy_next_channel);
+			plx_init(cy_pci_addr0, 0x6c);
+		/* For some yet unknown reason, once the PLX9060 reloads
+		   the EEPROM, the IRQ is lost and, thus, we have to
+		   re-write it to the PCI config. registers.
+		   This will remain here until we find a permanent
+		   fix. */
+			pci_write_config_byte(pdev, PCI_INTERRUPT_LINE,
+					cy_pci_irq);
 
-			cy_next_channel += cy_pci_nchan;
-		} else if (device_id == PCI_DEVICE_ID_CYCLOM_Z_Lo) {
-			/* print message */
-			printk("Cyclades-Z/PCI (bus=0x0%x, pci_id=0x%x, ",
-				pdev->bus->number, pdev->devfn);
-			printk("rev_id=%d) IRQ%d\n",
-				cyy_rev_id, (int)cy_pci_irq);
-			printk("Cyclades-Z/PCI: found winaddr=0x%lx "
-				"ctladdr=0x%lx\n",
-				(ulong)cy_pci_phys2, (ulong)cy_pci_phys0);
-			printk("Cyclades-Z/PCI not supported for low "
-				"addresses\n");
+			cy_writew(cy_pci_addr0 + 0x68,
+				readw(cy_pci_addr0 + 0x68) | 0x0900);
 			break;
-		} else if (device_id == PCI_DEVICE_ID_CYCLOM_Z_Hi) {
+		}
+
+		/* print message */
+		printk("Cyclom-Y/PCI #%d: 0x%lx-0x%lx, IRQ%d, ",
+			j + 1, (ulong)cy_pci_phys2,
+			(ulong) (cy_pci_phys2 + CyPCI_Ywin - 1),
+			(int)cy_pci_irq);
+		printk("%d channels starting from port %d.\n",
+			cy_pci_nchan, cy_next_channel);
+
+		cy_next_channel += cy_pci_nchan;
+	} else if (device_id == PCI_DEVICE_ID_CYCLOM_Z_Lo) {
+		/* print message */
+		printk("Cyclades-Z/PCI (bus=0x0%x, pci_id=0x%x, ",
+			pdev->bus->number, pdev->devfn);
+		printk("rev_id=%d) IRQ%d\n",
+			cyy_rev_id, (int)cy_pci_irq);
+		printk("Cyclades-Z/PCI: found winaddr=0x%lx "
+			"ctladdr=0x%lx\n",
+			(ulong)cy_pci_phys2, (ulong)cy_pci_phys0);
+		printk("Cyclades-Z/PCI not supported for low "
+			"addresses\n");
+		return -EIO;
+	} else if (device_id == PCI_DEVICE_ID_CYCLOM_Z_Hi) {
 #ifdef CY_PCI_DEBUG
-			printk("Cyclades-Z/PCI (bus=0x0%x, pci_id=0x%x, ",
-				pdev->bus->number, pdev->devfn);
-			printk("rev_id=%d) IRQ%d\n",
-				cyy_rev_id, (int)cy_pci_irq);
-			printk("Cyclades-Z/PCI: found winaddr=0x%lx "
-				"ctladdr=0x%lx\n",
-				(ulong) cy_pci_phys2, (ulong) cy_pci_phys0);
+		printk("Cyclades-Z/PCI (bus=0x0%x, pci_id=0x%x, ",
+			pdev->bus->number, pdev->devfn);
+		printk("rev_id=%d) IRQ%d\n",
+			cyy_rev_id, (int)cy_pci_irq);
+		printk("Cyclades-Z/PCI: found winaddr=0x%lx "
+			"ctladdr=0x%lx\n",
+			(ulong) cy_pci_phys2, (ulong) cy_pci_phys0);
 #endif
-			cy_pci_addr0 = pci_iomap(pdev, 0, CyPCI_Zctl);
+		cy_pci_addr0 = pci_iomap(pdev, 0, CyPCI_Zctl);
 
-			/* Disable interrupts on the PLX before resetting it */
-			cy_writew(cy_pci_addr0 + 0x68,
-				readw(cy_pci_addr0 + 0x68) & ~0x0900);
-
-			plx_init(cy_pci_addr0, 0x6c);
-			/* For some yet unknown reason, once the PLX9060 reloads
-			   the EEPROM, the IRQ is lost and, thus, we have to
-			   re-write it to the PCI config. registers.
-			   This will remain here until we find a permanent
-			   fix. */
-			pci_write_config_byte(pdev, PCI_INTERRUPT_LINE,
-						cy_pci_irq);
+		/* Disable interrupts on the PLX before resetting it */
+		cy_writew(cy_pci_addr0 + 0x68,
+			readw(cy_pci_addr0 + 0x68) & ~0x0900);
+
+		plx_init(cy_pci_addr0, 0x6c);
+		/* For some yet unknown reason, once the PLX9060 reloads
+		   the EEPROM, the IRQ is lost and, thus, we have to
+		   re-write it to the PCI config. registers.
+		   This will remain here until we find a permanent
+		   fix. */
+		pci_write_config_byte(pdev, PCI_INTERRUPT_LINE,
+					cy_pci_irq);
 
-			mailbox = (__u32)readl(&((struct RUNTIME_9060 __iomem *)
-					cy_pci_addr0)->mail_box_0);
+		mailbox = (__u32)readl(&((struct RUNTIME_9060 __iomem *)
+				cy_pci_addr0)->mail_box_0);
 
-			if (pci_resource_flags(pdev, 2) & IORESOURCE_IO) {
-				printk("  Warning: PCI I/O bit incorrectly "
-					"set. Ignoring it...\n");
-				pdev->resource[2].flags &= ~IORESOURCE_IO;
-			}
+		if (pci_resource_flags(pdev, 2) & IORESOURCE_IO) {
+			printk("  Warning: PCI I/O bit incorrectly "
+				"set. Ignoring it...\n");
+			pdev->resource[2].flags &= ~IORESOURCE_IO;
+		}
 
-			/* Although we don't use this I/O region, we should
-			   request it from the kernel anyway, to avoid problems
-			   with other drivers accessing it. */
-			if (pci_request_regions(pdev, "Cyclades-Z") != 0) {
-				printk(KERN_ERR "cyclades: failed to reserve "
-					"PCI resources\n");
-				continue;
-			}
+		/* Although we don't use this I/O region, we should
+		   request it from the kernel anyway, to avoid problems
+		   with other drivers accessing it. */
+		retval = pci_request_regions(pdev, "Cyclades-Z");
+		if (retval) {
+			printk(KERN_ERR "cyclades: failed to reserve "
+				"PCI resources\n");
+			return retval;
+		}
 
-			if (mailbox == ZE_V1) {
-				retval = cy_init_Ze(cy_pci_phys0, cy_pci_phys2,
-						cy_pci_addr0, cy_pci_irq, pdev);
-				if (retval < 0)
-					i--;
-				continue;
-			} else {
-				cy_pci_addr2 = pci_iomap(pdev, 2, CyPCI_Zwin);
-			}
+		if (mailbox == ZE_V1) {
+			retval = cy_init_Ze(cy_pci_phys0, cy_pci_phys2,
+					cy_pci_addr0, cy_pci_irq, pdev);
+			return retval;
+		} else {
+			cy_pci_addr2 = pci_iomap(pdev, 2, CyPCI_Zwin);
+		}
 
 #ifdef CY_PCI_DEBUG
-			printk("Cyclades-Z/PCI: relocate winaddr=0x%lx "
-				"ctladdr=0x%lx\n",
-				(ulong) cy_pci_addr2, (ulong) cy_pci_addr0);
-			if (mailbox == ZO_V1) {
-				cy_writel(&((struct RUNTIME_9060 *)
-					(cy_pci_addr0))->loc_addr_base,
-					WIN_CREG);
-				printk("Cyclades-8Zo/PCI: FPGA id %lx, ver "
-					"%lx\n", (ulong) (0xff &
-					readl(&((struct CUSTOM_REG *)
-						(cy_pci_addr2))->fpga_id)),
-					(ulong)(0xff &
-					readl(&((struct CUSTOM_REG *)
-						(cy_pci_addr2))->
-							fpga_version)));
-				cy_writel(&((struct RUNTIME_9060 *)
-					(cy_pci_addr0))->loc_addr_base,
-					WIN_RAM);
-			} else {
-				printk("Cyclades-Z/PCI: New Cyclades-Z board.  "
-						"FPGA not loaded\n");
-			}
+		printk("Cyclades-Z/PCI: relocate winaddr=0x%lx "
+			"ctladdr=0x%lx\n",
+			(ulong) cy_pci_addr2, (ulong) cy_pci_addr0);
+		if (mailbox == ZO_V1) {
+			cy_writel(&((struct RUNTIME_9060 *)
+				(cy_pci_addr0))->loc_addr_base,
+				WIN_CREG);
+			printk("Cyclades-8Zo/PCI: FPGA id %lx, ver "
+				"%lx\n", (ulong) (0xff &
+				readl(&((struct CUSTOM_REG *)
+					(cy_pci_addr2))->fpga_id)),
+				(ulong)(0xff &
+				readl(&((struct CUSTOM_REG *)
+					(cy_pci_addr2))->
+						fpga_version)));
+			cy_writel(&((struct RUNTIME_9060 *)
+				(cy_pci_addr0))->loc_addr_base,
+				WIN_RAM);
+		} else {
+			printk("Cyclades-Z/PCI: New Cyclades-Z board.  "
+					"FPGA not loaded\n");
+		}
 #endif
-			/* The following clears the firmware id word.  This
-			   ensures that the driver will not attempt to talk to
-			   the board until it has been properly initialized.
-			 */
-			if ((mailbox == ZO_V1) || (mailbox == ZO_V2))
-				cy_writel(cy_pci_addr2 + ID_ADDRESS, 0L);
-
-			/* This must be a Cyclades-8Zo/PCI.  The extendable
-			   version will have a different device_id and will
-			   be allocated its maximum number of ports. */
-			cy_pci_nchan = 8;
-
-			if ((cy_next_channel + cy_pci_nchan) > NR_PORTS) {
-				printk("Cyclades-8Zo/PCI found at 0x%lx but"
-					"no channels are available.\nChange "
-					"NR_PORTS in cyclades.c and recompile "
-					"kernel.\n", (ulong)cy_pci_phys2);
-				return i;
-			}
+		/* The following clears the firmware id word.  This
+		   ensures that the driver will not attempt to talk to
+		   the board until it has been properly initialized.
+		 */
+		if ((mailbox == ZO_V1) || (mailbox == ZO_V2))
+			cy_writel(cy_pci_addr2 + ID_ADDRESS, 0L);
+
+		/* This must be a Cyclades-8Zo/PCI.  The extendable
+		   version will have a different device_id and will
+		   be allocated its maximum number of ports. */
+		cy_pci_nchan = 8;
+
+		if ((cy_next_channel + cy_pci_nchan) > NR_PORTS) {
+			printk("Cyclades-8Zo/PCI found at 0x%lx but"
+				"no channels are available.\nChange "
+				"NR_PORTS in cyclades.c and recompile "
+				"kernel.\n", (ulong)cy_pci_phys2);
+			return -EIO;
+		}
 
-			/* fill the next cy_card structure available */
-			for (j = 0; j < NR_CARDS; j++) {
-				if (cy_card[j].base_addr == 0)
-					break;
-			}
-			if (j == NR_CARDS) {	/* no more cy_cards available */
-				printk("Cyclades-8Zo/PCI found at 0x%lx but"
-					"no more cards can be used.\nChange "
-					"NR_CARDS in cyclades.c and recompile "
-					"kernel.\n", (ulong)cy_pci_phys2);
-				return i;
-			}
+		/* fill the next cy_card structure available */
+		for (j = 0; j < NR_CARDS; j++) {
+			if (cy_card[j].base_addr == 0)
+				break;
+		}
+		if (j == NR_CARDS) {	/* no more cy_cards available */
+			printk("Cyclades-8Zo/PCI found at 0x%lx but"
+				"no more cards can be used.\nChange "
+				"NR_CARDS in cyclades.c and recompile "
+				"kernel.\n", (ulong)cy_pci_phys2);
+			return -EIO;
+		}
 #ifdef CONFIG_CYZ_INTR
-			/* allocate IRQ only if board has an IRQ */
-			if ((cy_pci_irq != 0) && (cy_pci_irq != 255)) {
-				if (request_irq(cy_pci_irq, cyz_interrupt,
-						IRQF_SHARED, "Cyclades-Z",
-						&cy_card[j])) {
-					printk("Cyclom-8Zo/PCI found at 0x%lx "
-						"but could not allocate "
-						"IRQ%d.\n", (ulong)cy_pci_phys2,
-						cy_pci_irq);
-					return i;
-				}
+		/* allocate IRQ only if board has an IRQ */
+		if ((cy_pci_irq != 0) && (cy_pci_irq != 255)) {
+			retval = request_irq(cy_pci_irq, cyz_interrupt,
+					IRQF_SHARED, "Cyclades-Z",
+					&cy_card[j]);
+			if (retval) {
+				printk("Cyclom-8Zo/PCI found at 0x%lx "
+					"but could not allocate "
+					"IRQ%d.\n", (ulong)cy_pci_phys2,
+					cy_pci_irq);
+				return retval;
 			}
+		}
 #endif				/* CONFIG_CYZ_INTR */
 
-			/* set cy_card */
-			cy_card[j].base_phys = cy_pci_phys2;
-			cy_card[j].ctl_phys = cy_pci_phys0;
-			cy_card[j].base_addr = cy_pci_addr2;
-			cy_card[j].ctl_addr = cy_pci_addr0;
-			cy_card[j].irq = (int)cy_pci_irq;
-			cy_card[j].bus_index = 1;
-			cy_card[j].first_line = cy_next_channel;
-			cy_card[j].num_chips = -1;
-			cy_card[j].pdev = pdev;
-			pci_set_drvdata(pdev, &cy_card[j]);
+		/* set cy_card */
+		cy_card[j].base_phys = cy_pci_phys2;
+		cy_card[j].ctl_phys = cy_pci_phys0;
+		cy_card[j].base_addr = cy_pci_addr2;
+		cy_card[j].ctl_addr = cy_pci_addr0;
+		cy_card[j].irq = (int)cy_pci_irq;
+		cy_card[j].bus_index = 1;
+		cy_card[j].first_line = cy_next_channel;
+		cy_card[j].num_chips = -1;
+		cy_card[j].pdev = pdev;
+		pci_set_drvdata(pdev, &cy_card[j]);
 
-			/* print message */
+		/* print message */
 #ifdef CONFIG_CYZ_INTR
-			/* don't report IRQ if board is no IRQ */
-			if ((cy_pci_irq != 0) && (cy_pci_irq != 255))
-				printk("Cyclades-8Zo/PCI #%d: 0x%lx-0x%lx, "
-					"IRQ%d, ", j + 1, (ulong)cy_pci_phys2,
-					(ulong) (cy_pci_phys2 + CyPCI_Zwin - 1),
-					(int)cy_pci_irq);
-			else
+		/* don't report IRQ if board is no IRQ */
+		if ((cy_pci_irq != 0) && (cy_pci_irq != 255))
+			printk("Cyclades-8Zo/PCI #%d: 0x%lx-0x%lx, "
+				"IRQ%d, ", j + 1, (ulong)cy_pci_phys2,
+				(ulong) (cy_pci_phys2 + CyPCI_Zwin - 1),
+				(int)cy_pci_irq);
+		else
 #endif				/* CONFIG_CYZ_INTR */
-				printk("Cyclades-8Zo/PCI #%d: 0x%lx-0x%lx, ",
-					j + 1, (ulong)cy_pci_phys2,
-					(ulong)(cy_pci_phys2 + CyPCI_Zwin - 1));
-
-			printk("%d channels starting from port %d.\n",
-					cy_pci_nchan, cy_next_channel);
-			cy_next_channel += cy_pci_nchan;
+			printk("Cyclades-8Zo/PCI #%d: 0x%lx-0x%lx, ",
+				j + 1, (ulong)cy_pci_phys2,
+				(ulong)(cy_pci_phys2 + CyPCI_Zwin - 1));
+
+		printk("%d channels starting from port %d.\n",
+				cy_pci_nchan, cy_next_channel);
+		cy_next_channel += cy_pci_nchan;
+	}
+
+	return 0;
+}
+#endif
+
+/*
+ * ---------------------------------------------------------------------
+ * cy_detect_pci() - Test PCI bus presence and Cyclom-Ye/PCI.
+ * sets global variables and return the number of PCI boards found.
+ * ---------------------------------------------------------------------
+ */
+static int __init cy_detect_pci(void)
+{
+#ifdef CONFIG_PCI
+	struct pci_dev *pdev = NULL;
+	unsigned int i, device_id, dev_index = 0;
+
+	for (i = 0; i < NR_CARDS; i++) {
+		/* look for a Cyclades card by vendor and device id */
+		while ((device_id = cy_pci_dev_id[dev_index].device) != 0) {
+			if ((pdev = pci_get_device(PCI_VENDOR_ID_CYCLADES,
+						   device_id, pdev)) == NULL) {
+				dev_index++;	/* try next device id */
+			} else {
+				break;	/* found a board */
+			}
 		}
+
+		if (device_id == 0)
+			break;
+
+		i -= !!cy_pci_probe(pdev, &cy_pci_dev_id[dev_index]);
 	}
 
 	return i;
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
