From: akpm@linux-foundation.org
Subject: - update-isdn-tree-to-use-pci_get_device.patch removed from -mm tree
Date: Sun, 15 Jul 2007 23:22:26 -0700
Message-ID: <200707160622.l6G6MQ25013253@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58987 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752071AbXGPGWi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 16 Jul 2007 02:22:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kkeil@suse.de, surya.prabhakar@wipro.com, mm-commits@vger.kernel.org


The patch titled
     Update isdn tree to use pci_get_device
has been removed from the -mm tree.  Its filename was
     update-isdn-tree-to-use-pci_get_device.patch

This patch was dropped because it was withdrawn

------------------------------------------------------
Subject: Update isdn tree to use pci_get_device
From: Karsten Keil <kkeil@suse.de>

Replacing pci_find_device with pci_get_device in the drivers/isdn subtree.

Signed-off-by: Karsten Keil <kkeil@suse.de>
Signed-off-by: Surya Prabhakar <surya.prabhakar@wipro.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/isdn/hisax/avm_pci.c      |   19 ++++---
 drivers/isdn/hisax/bkm_a4t.c      |   15 ++++--
 drivers/isdn/hisax/bkm_a8.c       |   28 ++++++-----
 drivers/isdn/hisax/diva.c         |   69 ++++++++++++++--------------
 drivers/isdn/hisax/elsa.c         |   54 +++++++++++----------
 drivers/isdn/hisax/enternow_pci.c |   20 ++++----
 drivers/isdn/hisax/gazel.c        |   13 +++--
 drivers/isdn/hisax/hfc_pci.c      |   14 ++++-
 drivers/isdn/hisax/niccy.c        |   22 +++++---
 drivers/isdn/hisax/nj_s.c         |   17 ++++--
 drivers/isdn/hisax/nj_u.c         |   18 ++++---
 drivers/isdn/hisax/sedlbauer.c    |   27 ++++++----
 drivers/isdn/hisax/telespci.c     |   14 ++++-
 drivers/isdn/hisax/w6692.c        |   14 ++++-
 drivers/isdn/hysdn/hysdn_init.c   |    4 +
 15 files changed, 211 insertions(+), 137 deletions(-)

diff -puN drivers/isdn/hisax/avm_pci.c~update-isdn-tree-to-use-pci_get_device drivers/isdn/hisax/avm_pci.c
--- a/drivers/isdn/hisax/avm_pci.c~update-isdn-tree-to-use-pci_get_device
+++ a/drivers/isdn/hisax/avm_pci.c
@@ -789,19 +789,19 @@ setup_avm_pcipnp(struct IsdnCard *card)
 	}
 #endif
 #ifdef CONFIG_PCI
-	if ((dev_avm = pci_find_device(PCI_VENDOR_ID_AVM,
+	if ((dev_avm = pci_get_device(PCI_VENDOR_ID_AVM,
 		PCI_DEVICE_ID_AVM_A1,  dev_avm))) {
 		if (pci_enable_device(dev_avm))
-			return(0);
+			goto dev_avm_cleanup;
 		cs->irq = dev_avm->irq;
 		if (!cs->irq) {
 			printk(KERN_ERR "FritzPCI: No IRQ for PCI card found\n");
-			return(0);
+			goto dev_avm_cleanup;
 		}
 		cs->hw.avm.cfg_reg = pci_resource_start(dev_avm, 1);
 		if (!cs->hw.avm.cfg_reg) {
 			printk(KERN_ERR "FritzPCI: No IO-Adr for PCI card found\n");
-			return(0);
+			goto dev_avm_cleanup;
 		}
 		cs->subtyp = AVM_FRITZ_PCI;
 	} else {
@@ -822,7 +822,7 @@ ready:
 		       CardType[card->typ],
 		       cs->hw.avm.cfg_reg,
 		       cs->hw.avm.cfg_reg + 31);
-		return (0);
+		goto dev_avm_cleanup;
 	}
 	switch (cs->subtyp) {
 	  case AVM_FRITZ_PCI:
@@ -841,8 +841,8 @@ ready:
 		cs->BC_Write_Reg = &WriteHDLCPnP;
 		break;
 	  default:
-	  	printk(KERN_WARNING "AVM unknown subtype %d\n", cs->subtyp);
-	  	return(0);
+		printk(KERN_WARNING "AVM unknown subtype %d\n", cs->subtyp);
+		goto dev_avm_cleanup;
 	}
 	printk(KERN_INFO "HiSax: %s config irq:%d base:0x%X\n",
 		(cs->subtyp == AVM_FRITZ_PCI) ? "AVM Fritz!PCI" : "AVM Fritz!PnP",
@@ -858,5 +858,10 @@ ready:
 	cs->irq_func = &avm_pcipnp_interrupt;
 	cs->writeisac(cs, ISAC_MASK, 0xFF);
 	ISACVersion(cs, (cs->subtyp == AVM_FRITZ_PCI) ? "AVM PCI:" : "AVM PnP:");
+	pci_dev_put(dev_avm);
 	return (1);
+
+dev_avm_cleanup:
+	pci_dev_put(dev_avm);
+	return 0;
 }
diff -puN drivers/isdn/hisax/bkm_a4t.c~update-isdn-tree-to-use-pci_get_device drivers/isdn/hisax/bkm_a4t.c
--- a/drivers/isdn/hisax/bkm_a4t.c~update-isdn-tree-to-use-pci_get_device
+++ a/drivers/isdn/hisax/bkm_a4t.c
@@ -275,7 +275,7 @@ setup_bkm_a4t(struct IsdnCard *card)
 		return (0);
 
 #ifdef CONFIG_PCI
-	while ((dev_a4t = pci_find_device(PCI_VENDOR_ID_ZORAN,
+	while ((dev_a4t = pci_get_device(PCI_VENDOR_ID_ZORAN,
 		PCI_DEVICE_ID_ZORAN_36120, dev_a4t))) {
 		u16 sub_sys;
 		u16 sub_vendor;
@@ -284,7 +284,7 @@ setup_bkm_a4t(struct IsdnCard *card)
 		sub_sys = dev_a4t->subsystem_device;
 		if ((sub_sys == PCI_DEVICE_ID_BERKOM_A4T) && (sub_vendor == PCI_VENDOR_ID_BERKOM)) {
 			if (pci_enable_device(dev_a4t))
-				return(0);
+				goto dev_a4t_cleanup;
 			found = 1;
 			pci_memaddr = pci_resource_start(dev_a4t, 0);
 			cs->irq = dev_a4t->irq;
@@ -297,11 +297,11 @@ setup_bkm_a4t(struct IsdnCard *card)
 	}
 	if (!cs->irq) {		/* IRQ range check ?? */
 		printk(KERN_WARNING "HiSax: %s: No IRQ\n", CardType[card->typ]);
-		return (0);
+		goto dev_a4t_cleanup;
 	}
 	if (!pci_memaddr) {
 		printk(KERN_WARNING "HiSax: %s: No Memory base address\n", CardType[card->typ]);
-		return (0);
+		goto dev_a4t_cleanup;
 	}
 	cs->hw.ax.base = (long) ioremap(pci_memaddr, 4096);
 	/* Check suspecious address */
@@ -311,7 +311,7 @@ setup_bkm_a4t(struct IsdnCard *card)
 		       CardType[card->typ], cs->hw.ax.base, cs->hw.ax.base + 4096);
 		iounmap((void *) cs->hw.ax.base);
 		cs->hw.ax.base = 0;
-		return (0);
+		goto dev_a4t_cleanup;
 	}
 	cs->hw.ax.isac_adr = cs->hw.ax.base + PO_OFFSET;
 	cs->hw.ax.jade_adr = cs->hw.ax.base + PO_OFFSET;
@@ -339,5 +339,10 @@ setup_bkm_a4t(struct IsdnCard *card)
 	ISACVersion(cs, "Telekom A4T:");
 	/* Jade version */
 	JadeVersion(cs, "Telekom A4T:");
+	pci_dev_put(dev_a4t);
 	return (1);
+
+dev_a4t_cleanup:
+	pci_dev_put(dev_a4t);
+	return 0;
 }
diff -puN drivers/isdn/hisax/bkm_a8.c~update-isdn-tree-to-use-pci_get_device drivers/isdn/hisax/bkm_a8.c
--- a/drivers/isdn/hisax/bkm_a8.c~update-isdn-tree-to-use-pci_get_device
+++ a/drivers/isdn/hisax/bkm_a8.c
@@ -310,15 +310,14 @@ setup_sct_quadro(struct IsdnCard *card)
 		(sub_vendor_id != PCI_VENDOR_ID_BERKOM)))
 		return (0);
 	if (cs->subtyp == SCT_1) {
-		while ((dev_a8 = pci_find_device(PCI_VENDOR_ID_PLX,
+		while ((dev_a8 = pci_get_device(PCI_VENDOR_ID_PLX,
 			PCI_DEVICE_ID_PLX_9050, dev_a8))) {
-			
 			sub_vendor_id = dev_a8->subsystem_vendor;
 			sub_sys_id = dev_a8->subsystem_device;
 			if ((sub_sys_id == PCI_DEVICE_ID_BERKOM_SCITEL_QUADRO) &&
 				(sub_vendor_id == PCI_VENDOR_ID_BERKOM)) {
 				if (pci_enable_device(dev_a8))
-					return(0);
+					goto dev_a8_cleanup;
 				pci_ioaddr1 = pci_resource_start(dev_a8, 1);
 				pci_irq = dev_a8->irq;
 				pci_bus = dev_a8->bus->number;
@@ -354,7 +353,7 @@ setup_sct_quadro(struct IsdnCard *card)
 		printk(KERN_WARNING "HiSax: %s (%s): No IRQ\n",
 		       CardType[card->typ],
 		       sct_quadro_subtypes[cs->subtyp]);
-		return (0);
+		goto dev_a8_cleanup;
 	}
 	pci_read_config_dword(dev_a8, PCI_BASE_ADDRESS_1, &pci_ioaddr1);
 	pci_read_config_dword(dev_a8, PCI_BASE_ADDRESS_2, &pci_ioaddr2);
@@ -365,7 +364,7 @@ setup_sct_quadro(struct IsdnCard *card)
 		printk(KERN_WARNING "HiSax: %s (%s): No IO base address(es)\n",
 		       CardType[card->typ],
 		       sct_quadro_subtypes[cs->subtyp]);
-		return (0);
+		goto dev_a8_cleanup;
 	}
 	pci_ioaddr1 &= PCI_BASE_ADDRESS_IO_MASK;
 	pci_ioaddr2 &= PCI_BASE_ADDRESS_IO_MASK;
@@ -386,9 +385,9 @@ setup_sct_quadro(struct IsdnCard *card)
 		case 1:
 			cs->hw.ax.base = pci_ioaddr5 + 0x00;
 			if (sct_alloc_io(pci_ioaddr1, 128))
-				return(0);
+				goto dev_a8_cleanup;
 			if (sct_alloc_io(pci_ioaddr5, 64))
-				return(0);
+				goto dev_a8_cleanup;
 			/* disable all IPAC */
 			writereg(pci_ioaddr5, pci_ioaddr5 + 4,
 				IPAC_MASK, 0xFF);
@@ -402,19 +401,19 @@ setup_sct_quadro(struct IsdnCard *card)
 		case 2:
 			cs->hw.ax.base = pci_ioaddr4 + 0x08;
 			if (sct_alloc_io(pci_ioaddr4, 64))
-				return(0);
+				goto dev_a8_cleanup;
 			break;
 		case 3:
 			cs->hw.ax.base = pci_ioaddr3 + 0x10;
 			if (sct_alloc_io(pci_ioaddr3, 64))
-				return(0);
+				goto dev_a8_cleanup;
 			break;
 		case 4:
 			cs->hw.ax.base = pci_ioaddr2 + 0x20;
 			if (sct_alloc_io(pci_ioaddr2, 64))
-				return(0);
+				goto dev_a8_cleanup;
 			break;
-	}	
+	}
 	/* For isac and hscx data path */
 	cs->hw.ax.data_adr = cs->hw.ax.base + 4;
 
@@ -443,8 +442,15 @@ setup_sct_quadro(struct IsdnCard *card)
 		CardType[card->typ],
 		sct_quadro_subtypes[cs->subtyp],
 		readreg(cs->hw.ax.base, cs->hw.ax.data_adr, IPAC_ID));
+
+	pci_dev_put(dev_a8);
 	return (1);
 #else
 	printk(KERN_ERR "HiSax: bkm_a8 only supported on PCI Systems\n");
+	return (1);
 #endif /* CONFIG_PCI */
+
+dev_a8_cleanup:
+	pci_dev_put(dev_a8);
+	return 0;
 }
diff -puN drivers/isdn/hisax/diva.c~update-isdn-tree-to-use-pci_get_device drivers/isdn/hisax/diva.c
--- a/drivers/isdn/hisax/diva.c~update-isdn-tree-to-use-pci_get_device
+++ a/drivers/isdn/hisax/diva.c
@@ -907,9 +907,6 @@ Diva_card_msg(struct IsdnCardState *cs, 
 }
 
 static struct pci_dev *dev_diva __devinitdata = NULL;
-static struct pci_dev *dev_diva_u __devinitdata = NULL;
-static struct pci_dev *dev_diva201 __devinitdata = NULL;
-static struct pci_dev *dev_diva202 __devinitdata = NULL;
 
 #ifdef __ISAPNP__
 static struct isapnp_device_id diva_ids[] __devinitdata = {
@@ -1047,40 +1044,40 @@ setup_diva(struct IsdnCard *card)
 #endif
 #ifdef CONFIG_PCI
 		cs->subtyp = 0;
-		if ((dev_diva = pci_find_device(PCI_VENDOR_ID_EICON,
+		if ((dev_diva = pci_get_device(PCI_VENDOR_ID_EICON,
 			PCI_DEVICE_ID_EICON_DIVA20, dev_diva))) {
 			if (pci_enable_device(dev_diva))
-				return(0);
+				goto dev_diva_cleanup;
 			cs->subtyp = DIVA_PCI;
 			cs->irq = dev_diva->irq;
 			cs->hw.diva.cfg_reg = pci_resource_start(dev_diva, 2);
-		} else if ((dev_diva_u = pci_find_device(PCI_VENDOR_ID_EICON,
-			PCI_DEVICE_ID_EICON_DIVA20_U, dev_diva_u))) {
-			if (pci_enable_device(dev_diva_u))
-				return(0);
+		} else if ((dev_diva = pci_get_device(PCI_VENDOR_ID_EICON,
+			PCI_DEVICE_ID_EICON_DIVA20_U, dev_diva))) {
+			if (pci_enable_device(dev_diva))
+				goto dev_diva_cleanup;
 			cs->subtyp = DIVA_PCI;
-			cs->irq = dev_diva_u->irq;
-			cs->hw.diva.cfg_reg = pci_resource_start(dev_diva_u, 2);
-		} else if ((dev_diva201 = pci_find_device(PCI_VENDOR_ID_EICON,
-			PCI_DEVICE_ID_EICON_DIVA201, dev_diva201))) {
-			if (pci_enable_device(dev_diva201))
-				return(0);
+			cs->irq = dev_diva->irq;
+			cs->hw.diva.cfg_reg = pci_resource_start(dev_diva, 2);
+		} else if ((dev_diva = pci_get_device(PCI_VENDOR_ID_EICON,
+			PCI_DEVICE_ID_EICON_DIVA201, dev_diva))) {
+			if (pci_enable_device(dev_diva))
+				goto dev_diva_cleanup;
 			cs->subtyp = DIVA_IPAC_PCI;
-			cs->irq = dev_diva201->irq;
+			cs->irq = dev_diva->irq;
 			cs->hw.diva.pci_cfg =
-				(ulong) ioremap(pci_resource_start(dev_diva201, 0), 4096);
+				(ulong) ioremap(pci_resource_start(dev_diva, 0), 4096);
 			cs->hw.diva.cfg_reg =
-				(ulong) ioremap(pci_resource_start(dev_diva201, 1), 4096);
-		} else if ((dev_diva202 = pci_find_device(PCI_VENDOR_ID_EICON,
-			PCI_DEVICE_ID_EICON_DIVA202, dev_diva202))) {
-			if (pci_enable_device(dev_diva202))
-				return(0);
+				(ulong) ioremap(pci_resource_start(dev_diva, 1), 4096);
+		} else if ((dev_diva = pci_get_device(PCI_VENDOR_ID_EICON,
+			PCI_DEVICE_ID_EICON_DIVA202, dev_diva))) {
+			if (pci_enable_device(dev_diva))
+				goto dev_diva_cleanup;
 			cs->subtyp = DIVA_IPACX_PCI;
-			cs->irq = dev_diva202->irq;
+			cs->irq = dev_diva->irq;
 			cs->hw.diva.pci_cfg =
-				(ulong) ioremap(pci_resource_start(dev_diva202, 0), 4096);
+				(ulong) ioremap(pci_resource_start(dev_diva, 0), 4096);
 			cs->hw.diva.cfg_reg =
-				(ulong) ioremap(pci_resource_start(dev_diva202, 1), 4096);
+				(ulong) ioremap(pci_resource_start(dev_diva, 1), 4096);
 		} else {
 			printk(KERN_WARNING "Diva: No PCI card found\n");
 			return(0);
@@ -1089,13 +1086,13 @@ setup_diva(struct IsdnCard *card)
 		if (!cs->irq) {
 			printk(KERN_WARNING "Diva: No IRQ for PCI card found\n");
 			iounmap_diva(cs);
-			return(0);
+			goto dev_diva_cleanup;
 		}
 
 		if (!cs->hw.diva.cfg_reg) {
 			printk(KERN_WARNING "Diva: No IO-Adr for PCI card found\n");
 			iounmap_diva(cs);
-			return(0);
+			goto dev_diva_cleanup;
 		}
 		cs->irq_flags |= IRQF_SHARED;
 #else
@@ -1129,12 +1126,12 @@ ready:
 	printk(KERN_INFO
 		"Diva: %s card configured at %#lx IRQ %d\n",
 		(cs->subtyp == DIVA_PCI) ? "PCI" :
-		(cs->subtyp == DIVA_ISA) ? "ISA" : 
+		(cs->subtyp == DIVA_ISA) ? "ISA" :
 		(cs->subtyp == DIVA_IPAC_ISA) ? "IPAC ISA" :
 		(cs->subtyp == DIVA_IPAC_PCI) ? "IPAC PCI" : "IPACX PCI",
 		cs->hw.diva.cfg_reg, cs->irq);
-	if ((cs->subtyp == DIVA_IPAC_PCI)  || 
-	    (cs->subtyp == DIVA_IPACX_PCI) || 
+	if ((cs->subtyp == DIVA_IPAC_PCI)  ||
+	    (cs->subtyp == DIVA_IPACX_PCI) ||
 	    (cs->subtyp == DIVA_PCI)         )
 		printk(KERN_INFO "Diva: %s space at %#lx\n",
 			(cs->subtyp == DIVA_PCI) ? "PCI" :
@@ -1149,7 +1146,7 @@ ready:
 			       cs->hw.diva.cfg_reg,
 			       cs->hw.diva.cfg_reg + bytecnt);
 			iounmap_diva(cs);
-			return (0);
+			goto dev_diva_cleanup;
 		}
 	}
 	cs->BC_Read_Reg  = &ReadHSCX;
@@ -1185,7 +1182,7 @@ ready:
 		cs->BC_Write_Reg = &MemWriteHSCX_IPACX;
 		cs->BC_Send_Data = NULL; // function located in ipacx module
 		cs->irq_func = &diva_irq_ipacx_pci;
-		printk(KERN_INFO "Diva: IPACX Design Id: %x\n", 
+		printk(KERN_INFO "Diva: IPACX Design Id: %x\n",
 			MemReadISAC_IPACX(cs, IPACX_ID) &0x3F);
 	} else { /* DIVA 2.0 */
 		cs->hw.diva.tl.function = (void *) diva_led_handler;
@@ -1201,8 +1198,14 @@ ready:
 			printk(KERN_WARNING
 		       "Diva: wrong HSCX versions check IO address\n");
 			release_io_diva(cs);
-			return (0);
+			goto dev_diva_cleanup;
 		}
 	}
+
+	pci_dev_put(dev_diva);
 	return (1);
+
+dev_diva_cleanup:
+	pci_dev_put(dev_diva);
+	return 0;
 }
diff -puN drivers/isdn/hisax/elsa.c~update-isdn-tree-to-use-pci_get_device drivers/isdn/hisax/elsa.c
--- a/drivers/isdn/hisax/elsa.c~update-isdn-tree-to-use-pci_get_device
+++ a/drivers/isdn/hisax/elsa.c
@@ -832,8 +832,7 @@ probe_elsa(struct IsdnCardState *cs)
 	return (CARD_portlist[i]);
 }
 
-static 	struct pci_dev *dev_qs1000 __devinitdata = NULL;
-static 	struct pci_dev *dev_qs3000 __devinitdata = NULL;
+static 	struct pci_dev *dev_qsx __devinitdata = NULL;
 
 #ifdef __ISAPNP__
 static struct isapnp_device_id elsa_ids[] __devinitdata = {
@@ -1021,34 +1020,34 @@ setup_elsa(struct IsdnCard *card)
 	} else if (cs->typ == ISDN_CTYPE_ELSA_PCI) {
 #ifdef CONFIG_PCI
 		cs->subtyp = 0;
-		if ((dev_qs1000 = pci_find_device(PCI_VENDOR_ID_ELSA,
-			PCI_DEVICE_ID_ELSA_MICROLINK, dev_qs1000))) {
-			if (pci_enable_device(dev_qs1000))
-				return(0);
-			cs->subtyp = ELSA_QS1000PCI;
-			cs->irq = dev_qs1000->irq;
-			cs->hw.elsa.cfg = pci_resource_start(dev_qs1000, 1);
-			cs->hw.elsa.base = pci_resource_start(dev_qs1000, 3);
-		} else if ((dev_qs3000 = pci_find_device(PCI_VENDOR_ID_ELSA,
-			PCI_DEVICE_ID_ELSA_QS3000, dev_qs3000))) {
-			if (pci_enable_device(dev_qs3000))
-				return(0);
+		if ((dev_qsx = pci_get_device(PCI_VENDOR_ID_ELSA,
+			PCI_DEVICE_ID_ELSA_MICROLINK, dev_qsx))) {
+				if (pci_enable_device(dev_qsx))
+					goto dev_qsx_cleanup;
+				cs->subtyp = ELSA_QS1000PCI;
+			cs->irq = dev_qsx->irq;
+			cs->hw.elsa.cfg = pci_resource_start(dev_qsx, 1);
+			cs->hw.elsa.base = pci_resource_start(dev_qsx, 3);
+		} else if ((dev_qsx = pci_get_device(PCI_VENDOR_ID_ELSA,
+			PCI_DEVICE_ID_ELSA_QS3000, dev_qsx))) {
+				if (pci_enable_device(dev_qsx))
+					goto dev_qsx_cleanup;
 			cs->subtyp = ELSA_QS3000PCI;
-			cs->irq = dev_qs3000->irq;
-			cs->hw.elsa.cfg = pci_resource_start(dev_qs3000, 1);
-			cs->hw.elsa.base = pci_resource_start(dev_qs3000, 3);
+			cs->irq = dev_qsx->irq;
+			cs->hw.elsa.cfg = pci_resource_start(dev_qsx, 1);
+			cs->hw.elsa.base = pci_resource_start(dev_qsx, 3);
 		} else {
 			printk(KERN_WARNING "Elsa: No PCI card found\n");
 			return(0);
 		}
 		if (!cs->irq) {
 			printk(KERN_WARNING "Elsa: No IRQ for PCI card found\n");
-			return(0);
+			goto dev_qsx_cleanup;
 		}
 
 		if (!(cs->hw.elsa.base && cs->hw.elsa.cfg)) {
 			printk(KERN_WARNING "Elsa: No IO-Adr for PCI card found\n");
-			return(0);
+			goto dev_qsx_cleanup;
 		}
 		if ((cs->hw.elsa.cfg & 0xff) || (cs->hw.elsa.base & 0xf)) {
 			printk(KERN_WARNING "Elsa: You may have a wrong PCI bios\n");
@@ -1097,7 +1096,7 @@ setup_elsa(struct IsdnCard *card)
 		default:
 			printk(KERN_WARNING
 			       "Unknown ELSA subtype %d\n", cs->subtyp);
-			return (0);
+			goto dev_qsx_cleanup;
 	}
 	/* In case of the elsa pcmcia card, this region is in use,
 	   reserved for us by the card manager. So we do not check it
@@ -1108,7 +1107,7 @@ setup_elsa(struct IsdnCard *card)
 		       CardType[card->typ],
 		       cs->hw.elsa.base,
 		       cs->hw.elsa.base + bytecnt);
-		return (0);
+			goto dev_qsx_cleanup;
 	}
 	if ((cs->subtyp == ELSA_QS1000PCI) || (cs->subtyp == ELSA_QS3000PCI)) {
 		if (!request_region(cs->hw.elsa.cfg, 0x80, "elsa isdn pci")) {
@@ -1118,7 +1117,7 @@ setup_elsa(struct IsdnCard *card)
 				cs->hw.elsa.cfg,
 				cs->hw.elsa.cfg + 0x80);
 			release_region(cs->hw.elsa.base, bytecnt);
-			return (0);
+			goto dev_qsx_cleanup;
 		}
 	}
 #if ARCOFI_USE
@@ -1138,14 +1137,14 @@ setup_elsa(struct IsdnCard *card)
 				printk(KERN_WARNING
 				       "Elsa: timer do not start\n");
 				release_io_elsa(cs);
-				return (0);
+				goto dev_qsx_cleanup;
 			}
 		}
 		HZDELAY((HZ/100) + 1);	/* wait >=10 ms */
 		if (TimerRun(cs)) {
 			printk(KERN_WARNING "Elsa: timer do not run down\n");
 			release_io_elsa(cs);
-			return (0);
+			goto dev_qsx_cleanup;
 		}
 		printk(KERN_INFO "Elsa: timer OK; resetting card\n");
 	}
@@ -1172,7 +1171,7 @@ setup_elsa(struct IsdnCard *card)
 			printk(KERN_WARNING
 				"Elsa: wrong HSCX versions check IO address\n");
 			release_io_elsa(cs);
-			return (0);
+			goto dev_qsx_cleanup;
 		}
 	}
 	if (cs->subtyp == ELSA_PC) {
@@ -1184,5 +1183,10 @@ setup_elsa(struct IsdnCard *card)
 		writeitac(cs, ITAC_SCIE, 0);
 		writeitac(cs, ITAC_STIE, 0);
 	}
+	pci_dev_put(dev_qsx);
 	return (1);
+
+dev_qsx_cleanup:
+		pci_dev_put(dev_qsx);
+		return (0);
 }
diff -puN drivers/isdn/hisax/enternow_pci.c~update-isdn-tree-to-use-pci_get_device drivers/isdn/hisax/enternow_pci.c
--- a/drivers/isdn/hisax/enternow_pci.c~update-isdn-tree-to-use-pci_get_device
+++ a/drivers/isdn/hisax/enternow_pci.c
@@ -323,26 +323,26 @@ setup_enternow_pci(struct IsdnCard *card
 
 	for ( ;; )
 	{
-		if ((dev_netjet = pci_find_device(PCI_VENDOR_ID_TIGERJET,
+		if ((dev_netjet = pci_get_device(PCI_VENDOR_ID_TIGERJET,
 			PCI_DEVICE_ID_TIGERJET_300,  dev_netjet))) {
-			if (pci_enable_device(dev_netjet))
-				return(0);
+				if (pci_enable_device(dev_netjet))
+					goto dev_netjet_cleanup;
 			cs->irq = dev_netjet->irq;
 			if (!cs->irq) {
 				printk(KERN_WARNING "enter:now PCI: No IRQ for PCI card found\n");
-				return(0);
+				goto dev_netjet_cleanup;
 			}
 			cs->hw.njet.base = pci_resource_start(dev_netjet, 0);
 			if (!cs->hw.njet.base) {
 				printk(KERN_WARNING "enter:now PCI: No IO-Adr for PCI card found\n");
-				return(0);
+				goto dev_netjet_cleanup;
 			}
                         /* checks Sub-Vendor ID because system crashes with Traverse-Card */
 			if ((dev_netjet->subsystem_vendor != 0x55) ||
 				(dev_netjet->subsystem_device != 0x02)) {
 				printk(KERN_WARNING "enter:now: You tried to load this driver with an incompatible TigerJet-card\n");
                                 printk(KERN_WARNING "Use type=20 for Traverse NetJet PCI Card.\n");
-                                return(0);
+				goto dev_netjet_cleanup;
                         }
 		} else {
                         printk(KERN_WARNING "enter:now PCI: No PCI card found\n");
@@ -390,7 +390,7 @@ setup_enternow_pci(struct IsdnCard *card
 			   CardType[card->typ],
 			   cs->hw.njet.base,
 			   cs->hw.njet.base + bytecnt);
-		return (0);
+		goto dev_netjet_cleanup;
 	}
 	setup_Amd7930(cs);
 	cs->hw.njet.last_is0 = 0;
@@ -406,6 +406,10 @@ setup_enternow_pci(struct IsdnCard *card
 	cs->cardmsg = &enpci_card_msg;
 	cs->irq_func = &enpci_interrupt;
 	cs->irq_flags |= IRQF_SHARED;
-
+	pci_dev_put(dev_netjet);
         return (1);
+
+dev_netjet_cleanup:
+		pci_dev_put(dev_netjet);
+		return (0);
 }
diff -puN drivers/isdn/hisax/gazel.c~update-isdn-tree-to-use-pci_get_device drivers/isdn/hisax/gazel.c
--- a/drivers/isdn/hisax/gazel.c~update-isdn-tree-to-use-pci_get_device
+++ a/drivers/isdn/hisax/gazel.c
@@ -546,10 +546,10 @@ setup_gazelpci(struct IsdnCardState *cs)
 	found = 0;
 	seekcard = PCI_DEVICE_ID_PLX_R685;
 	for (nbseek = 0; nbseek < 4; nbseek++) {
-		if ((dev_tel = pci_find_device(PCI_VENDOR_ID_PLX,
+		if ((dev_tel = pci_get_device(PCI_VENDOR_ID_PLX,
 					seekcard, dev_tel))) {
-			if (pci_enable_device(dev_tel))
-				return 1;
+				if (pci_enable_device(dev_tel))
+					goto dev_tel_cleanup;
 			pci_irq = dev_tel->irq;
 			pci_ioaddr0 = pci_resource_start(dev_tel, 1);
 			pci_ioaddr1 = pci_resource_start(dev_tel, 2);
@@ -577,7 +577,7 @@ setup_gazelpci(struct IsdnCardState *cs)
 	}
 	if (!pci_irq) {
 		printk(KERN_WARNING "Gazel: No IRQ for PCI card found\n");
-		return 1;
+		goto dev_tel_cleanup;
 	}
 	cs->hw.gazel.pciaddr[0] = pci_ioaddr0;
 	cs->hw.gazel.pciaddr[1] = pci_ioaddr1;
@@ -618,7 +618,12 @@ setup_gazelpci(struct IsdnCardState *cs)
 			break;
 	}
 
+	pci_dev_put(dev_tel);
 	return (0);
+
+dev_tel_cleanup:
+	pci_dev_put(dev_tel);
+	return 1;
 }
 
 int __devinit
diff -puN drivers/isdn/hisax/hfc_pci.c~update-isdn-tree-to-use-pci_get_device drivers/isdn/hisax/hfc_pci.c
--- a/drivers/isdn/hisax/hfc_pci.c~update-isdn-tree-to-use-pci_get_device
+++ a/drivers/isdn/hisax/hfc_pci.c
@@ -1665,7 +1665,7 @@ setup_hfcpci(struct IsdnCard *card)
 	if (cs->typ == ISDN_CTYPE_HFC_PCI) {
 		i = 0;
 		while (id_list[i].vendor_id) {
-			tmp_hfcpci = pci_find_device(id_list[i].vendor_id,
+			tmp_hfcpci = pci_get_device(id_list[i].vendor_id,
 						     id_list[i].device_id,
 						     dev_hfcpci);
 			i++;
@@ -1687,7 +1687,7 @@ setup_hfcpci(struct IsdnCard *card)
 			cs->irq = dev_hfcpci->irq;
 			if (!cs->irq) {
 				printk(KERN_WARNING "HFC-PCI: No IRQ for PCI card found\n");
-				return (0);
+				goto tmp_hfcpci_cleanup;
 			}
 			cs->hw.hfcpci.pci_io = (char *)(unsigned long)dev_hfcpci->resource[1].start;
 			printk(KERN_INFO "HiSax: HFC-PCI card manufacturer: %s card name: %s\n", id_list[i].vendor_name, id_list[i].card_name);
@@ -1697,14 +1697,14 @@ setup_hfcpci(struct IsdnCard *card)
 		}
 		if (!cs->hw.hfcpci.pci_io) {
 			printk(KERN_WARNING "HFC-PCI: No IO-Mem for PCI card found\n");
-			return (0);
+			goto tmp_hfcpci_cleanup;
 		}
 		/* Allocate memory for FIFOS */
 		/* Because the HFC-PCI needs a 32K physical alignment, we */
 		/* need to allocate the double mem and align the address */
 		if (!(cs->hw.hfcpci.share_start = kmalloc(65536, GFP_KERNEL))) {
 			printk(KERN_WARNING "HFC-PCI: Error allocating memory for FIFO!\n");
-			return 0;
+			goto tmp_hfcpci_cleanup;
 		}
 		cs->hw.hfcpci.fifos = (void *)
 		    (((ulong) cs->hw.hfcpci.share_start) & ~0x7FFF) + 0x8000;
@@ -1741,9 +1741,15 @@ setup_hfcpci(struct IsdnCard *card)
 		cs->cardmsg = &hfcpci_card_msg;
 		cs->auxcmd = &hfcpci_auxcmd;
 		spin_unlock_irqrestore(&cs->lock, flags);
+
+		pci_dev_put(tmp_hfcpci);
 		return (1);
 	} else
 		return (0);	/* no valid card type */
+
+tmp_hfcpci_cleanup:
+		pci_dev_put(tmp_hfcpci);
+		return 0;
 #else
 	printk(KERN_WARNING "HFC-PCI: NO_PCI_BIOS\n");
 	return (0);
diff -puN drivers/isdn/hisax/niccy.c~update-isdn-tree-to-use-pci_get_device drivers/isdn/hisax/niccy.c
--- a/drivers/isdn/hisax/niccy.c~update-isdn-tree-to-use-pci_get_device
+++ a/drivers/isdn/hisax/niccy.c
@@ -302,29 +302,29 @@ int __devinit setup_niccy(struct IsdnCar
 #ifdef CONFIG_PCI
 		u_int pci_ioaddr;
 		cs->subtyp = 0;
-		if ((niccy_dev = pci_find_device(PCI_VENDOR_ID_SATSAGEM,
+		if ((niccy_dev = pci_get_device(PCI_VENDOR_ID_SATSAGEM,
 						 PCI_DEVICE_ID_SATSAGEM_NICCY,
 						 niccy_dev))) {
 			if (pci_enable_device(niccy_dev))
-				return 0;
+				goto niccy_dev_cleanup;
 			/* get IRQ */
 			if (!niccy_dev->irq) {
 				printk(KERN_WARNING
 				       "Niccy: No IRQ for PCI card found\n");
-				return 0;
+				goto niccy_dev_cleanup;
 			}
 			cs->irq = niccy_dev->irq;
 			cs->hw.niccy.cfg_reg = pci_resource_start(niccy_dev, 0);
 			if (!cs->hw.niccy.cfg_reg) {
 				printk(KERN_WARNING
 				       "Niccy: No IO-Adr for PCI cfg found\n");
-				return 0;
+				goto niccy_dev_cleanup;
 			}
 			pci_ioaddr = pci_resource_start(niccy_dev, 1);
 			if (!pci_ioaddr) {
 				printk(KERN_WARNING
 				       "Niccy: No IO-Adr for PCI card found\n");
-				return 0;
+				goto niccy_dev_cleanup;
 			}
 			cs->subtyp = NICCY_PCI;
 		} else {
@@ -341,7 +341,7 @@ int __devinit setup_niccy(struct IsdnCar
 			       "HiSax: %s data port %x-%x already in use\n",
 			       CardType[card->typ],
 			       cs->hw.niccy.isac, cs->hw.niccy.isac + 4);
-			return 0;
+			goto niccy_dev_cleanup;
 		}
 		if (!request_region(cs->hw.niccy.cfg_reg, 0x40, "niccy pci")) {
 			printk(KERN_WARNING
@@ -350,7 +350,7 @@ int __devinit setup_niccy(struct IsdnCar
 			       cs->hw.niccy.cfg_reg,
 			       cs->hw.niccy.cfg_reg + 0x40);
 			release_region(cs->hw.niccy.isac, 4);
-			return 0;
+			goto niccy_dev_cleanup;
 		}
 #else
 		printk(KERN_WARNING "Niccy: io0 0 and NO_PCI_BIOS\n");
@@ -376,7 +376,13 @@ int __devinit setup_niccy(struct IsdnCar
 		printk(KERN_WARNING "Niccy: wrong HSCX versions check IO "
 			"address\n");
 		release_io_niccy(cs);
-		return 0;
+		goto niccy_dev_cleanup;
 	}
+
+	pci_dev_put(niccy_dev);
 	return 1;
+
+niccy_dev_cleanup:
+		pci_dev_put(niccy_dev);
+		return (0);
 }
diff -puN drivers/isdn/hisax/nj_s.c~update-isdn-tree-to-use-pci_get_device drivers/isdn/hisax/nj_s.c
--- a/drivers/isdn/hisax/nj_s.c~update-isdn-tree-to-use-pci_get_device
+++ a/drivers/isdn/hisax/nj_s.c
@@ -170,20 +170,20 @@ setup_netjet_s(struct IsdnCard *card)
 
 	for ( ;; )
 	{
-		if ((dev_netjet = pci_find_device(PCI_VENDOR_ID_TIGERJET,
+		if ((dev_netjet = pci_get_device(PCI_VENDOR_ID_TIGERJET,
 			PCI_DEVICE_ID_TIGERJET_300,  dev_netjet))) {
 			if (pci_enable_device(dev_netjet))
-				return(0);
+				goto dev_netjet_cleanup;
 			pci_set_master(dev_netjet);
 			cs->irq = dev_netjet->irq;
 			if (!cs->irq) {
 				printk(KERN_WARNING "NETjet-S: No IRQ for PCI card found\n");
-				return(0);
+				goto dev_netjet_cleanup;
 			}
 			cs->hw.njet.base = pci_resource_start(dev_netjet, 0);
 			if (!cs->hw.njet.base) {
 				printk(KERN_WARNING "NETjet-S: No IO-Adr for PCI card found\n");
-				return(0);
+				goto dev_netjet_cleanup;
 			}
 			/* the TJ300 and TJ320 must be detected, the IRQ handling is different
 			 * unfortunatly the chips use the same device ID, but the TJ320 has
@@ -199,7 +199,7 @@ setup_netjet_s(struct IsdnCard *card)
 				(dev_netjet->subsystem_device == 0x02)) {
 				printk(KERN_WARNING "Netjet: You tried to load this driver with an incompatible TigerJet-card\n");
 				printk(KERN_WARNING "Use type=41 for Formula-n enter:now ISDN PCI and compatible\n");
-				return(0);
+				goto dev_netjet_cleanup;
 			}
 			/* end new code */
 		} else {
@@ -259,7 +259,7 @@ setup_netjet_s(struct IsdnCard *card)
 		       CardType[card->typ],
 		       cs->hw.njet.base,
 		       cs->hw.njet.base + bytecnt);
-		return (0);
+		goto dev_netjet_cleanup;
 	}
 	cs->readisac  = &NETjet_ReadIC;
 	cs->writeisac = &NETjet_WriteIC;
@@ -273,5 +273,10 @@ setup_netjet_s(struct IsdnCard *card)
 	cs->irq_func = &netjet_s_interrupt;
 	cs->irq_flags |= IRQF_SHARED;
 	ISACVersion(cs, "NETjet-S:");
+	pci_dev_put(dev_netjet);
 	return (1);
+
+dev_netjet_cleanup:
+		pci_dev_put(dev_netjet);
+	return (0);
 }
diff -puN drivers/isdn/hisax/nj_u.c~update-isdn-tree-to-use-pci_get_device drivers/isdn/hisax/nj_u.c
--- a/drivers/isdn/hisax/nj_u.c~update-isdn-tree-to-use-pci_get_device
+++ a/drivers/isdn/hisax/nj_u.c
@@ -151,20 +151,20 @@ setup_netjet_u(struct IsdnCard *card)
 
 	for ( ;; )
 	{
-		if ((dev_netjet = pci_find_device(PCI_VENDOR_ID_TIGERJET,
+		if ((dev_netjet = pci_get_device(PCI_VENDOR_ID_TIGERJET,
 			PCI_DEVICE_ID_TIGERJET_300,  dev_netjet))) {
 			if (pci_enable_device(dev_netjet))
-				return(0);
+				goto dev_netjet_cleanup;
 			pci_set_master(dev_netjet);
 			cs->irq = dev_netjet->irq;
 			if (!cs->irq) {
 				printk(KERN_WARNING "NETspider-U: No IRQ for PCI card found\n");
-				return(0);
+				goto dev_netjet_cleanup;
 			}
 			cs->hw.njet.base = pci_resource_start(dev_netjet, 0);
 			if (!cs->hw.njet.base) {
 				printk(KERN_WARNING "NETspider-U: No IO-Adr for PCI card found\n");
-				return(0);
+				goto dev_netjet_cleanup;
 			}
 		} else {
 			printk(KERN_WARNING "NETspider-U: No PCI card found\n");
@@ -202,7 +202,7 @@ setup_netjet_u(struct IsdnCard *card)
 
 			default :
 				printk( KERN_WARNING "NETspider-U: No PCI card found\n" );
-				return 0;
+				goto dev_netjet_cleanup;
                 }
                 break;
 	}
@@ -225,7 +225,7 @@ setup_netjet_u(struct IsdnCard *card)
 		       CardType[card->typ],
 		       cs->hw.njet.base,
 		       cs->hw.njet.base + bytecnt);
-		return (0);
+		goto dev_netjet_cleanup;
 	}
 	setup_icc(cs);
 	cs->readisac  = &NETjet_ReadIC;
@@ -239,5 +239,11 @@ setup_netjet_u(struct IsdnCard *card)
 	cs->irq_func = &netjet_u_interrupt;
 	cs->irq_flags |= IRQF_SHARED;
 	ICCVersion(cs, "NETspider-U:");
+
+	pci_dev_put(dev_netjet);
 	return (1);
+
+dev_netjet_cleanup:
+		pci_dev_put(dev_netjet);
+		return (0);
 }
diff -puN drivers/isdn/hisax/sedlbauer.c~update-isdn-tree-to-use-pci_get_device drivers/isdn/hisax/sedlbauer.c
--- a/drivers/isdn/hisax/sedlbauer.c~update-isdn-tree-to-use-pci_get_device
+++ a/drivers/isdn/hisax/sedlbauer.c
@@ -618,14 +618,14 @@ setup_sedlbauer(struct IsdnCard *card)
 #endif
 /* Probe for Sedlbauer speed pci */
 #ifdef CONFIG_PCI
-		if ((dev_sedl = pci_find_device(PCI_VENDOR_ID_TIGERJET,
+		if ((dev_sedl = pci_get_device(PCI_VENDOR_ID_TIGERJET,
 				PCI_DEVICE_ID_TIGERJET_100, dev_sedl))) {
 			if (pci_enable_device(dev_sedl))
-				return(0);
+				goto dev_sedl_cleanup;
 			cs->irq = dev_sedl->irq;
 			if (!cs->irq) {
 				printk(KERN_WARNING "Sedlbauer: No IRQ for PCI card found\n");
-				return(0);
+				goto dev_sedl_cleanup;
 			}
 			cs->hw.sedl.cfg_reg = pci_resource_start(dev_sedl, 0);
 		} else {
@@ -642,7 +642,7 @@ setup_sedlbauer(struct IsdnCard *card)
 			cs->hw.sedl.cfg_reg);
 		if (sub_id != PCI_SUB_ID_SEDLBAUER) {
 			printk(KERN_ERR "Sedlbauer: unknown sub id %#x\n", sub_id);
-			return(0);
+			goto dev_sedl_cleanup;
 		}
 		if (sub_vendor_id == PCI_SUBVENDOR_SPEEDFAX_PYRAMID) {
 			cs->hw.sedl.chip = SEDL_CHIP_ISAC_ISAR;
@@ -659,7 +659,7 @@ setup_sedlbauer(struct IsdnCard *card)
 		} else {
 			printk(KERN_ERR "Sedlbauer: unknown sub vendor id %#x\n",
 				sub_vendor_id);
-			return(0);
+			goto dev_sedl_cleanup;
 		}
 		bytecnt = 256;
 		cs->hw.sedl.reset_on = SEDL_ISAR_PCI_ISAR_RESET_ON;
@@ -676,10 +676,10 @@ setup_sedlbauer(struct IsdnCard *card)
 		printk(KERN_WARNING "Sedlbauer: NO_PCI_BIOS\n");
 		return (0);
 #endif /* CONFIG_PCI */
-	}	
+	}
 
 #ifdef __ISAPNP__
-ready:	
+ready:
 #endif
 
 	/* In case of the sedlbauer pcmcia card, this region is in use,
@@ -693,7 +693,7 @@ ready:	
 			CardType[card->typ],
 			cs->hw.sedl.cfg_reg,
 			cs->hw.sedl.cfg_reg + bytecnt);
-			return (0);
+			goto dev_sedl_cleanup;
 	}
 
 	printk(KERN_INFO
@@ -804,7 +804,7 @@ ready:	
 			}
 			if (!bytecnt) {
 				release_io_sedlbauer(cs);
-				return (0);
+				goto dev_sedl_cleanup;
 			}
 		} else {
 			if (cs->hw.sedl.bus == SEDL_BUS_PCMCIA) {
@@ -823,14 +823,19 @@ ready:	
 			}
 			cs->irq_func = &sedlbauer_interrupt;
 			ISACVersion(cs, "Sedlbauer:");
-		
+
 			if (HscxVersion(cs, "Sedlbauer:")) {
 				printk(KERN_WARNING
 					"Sedlbauer: wrong HSCX versions check IO address\n");
 				release_io_sedlbauer(cs);
-				return (0);
+				goto dev_sedl_cleanup;
 			}
 		}
 	}
+	pci_dev_put(dev_sedl);
 	return (1);
+
+dev_sedl_cleanup:
+	pci_dev_put(dev_sedl);
+	return 0;
 }
diff -puN drivers/isdn/hisax/telespci.c~update-isdn-tree-to-use-pci_get_device drivers/isdn/hisax/telespci.c
--- a/drivers/isdn/hisax/telespci.c~update-isdn-tree-to-use-pci_get_device
+++ a/drivers/isdn/hisax/telespci.c
@@ -300,13 +300,13 @@ setup_telespci(struct IsdnCard *card)
 	if (cs->typ != ISDN_CTYPE_TELESPCI)
 		return (0);
 #ifdef CONFIG_PCI
-	if ((dev_tel = pci_find_device (PCI_VENDOR_ID_ZORAN, PCI_DEVICE_ID_ZORAN_36120, dev_tel))) {
+	if ((dev_tel = pci_get_device (PCI_VENDOR_ID_ZORAN, PCI_DEVICE_ID_ZORAN_36120, dev_tel))) {
 		if (pci_enable_device(dev_tel))
-			return(0);
+			goto dev_tel_cleanup;
 		cs->irq = dev_tel->irq;
 		if (!cs->irq) {
 			printk(KERN_WARNING "Teles: No IRQ for PCI card found\n");
-			return(0);
+			goto dev_tel_cleanup;
 		}
 		cs->hw.teles0.membase = ioremap(pci_resource_start(dev_tel, 0),
 			PAGE_SIZE);
@@ -353,7 +353,13 @@ setup_telespci(struct IsdnCard *card)
 		printk(KERN_WARNING
 		 "TelesPCI: wrong HSCX versions check IO/MEM addresses\n");
 		release_io_telespci(cs);
-		return (0);
+		goto dev_tel_cleanup;
 	}
+
+	pci_dev_put(dev_tel);
 	return (1);
+
+dev_tel_cleanup:
+	pci_dev_put(dev_tel);
+	return 0;
 }
diff -puN drivers/isdn/hisax/w6692.c~update-isdn-tree-to-use-pci_get_device drivers/isdn/hisax/w6692.c
--- a/drivers/isdn/hisax/w6692.c~update-isdn-tree-to-use-pci_get_device
+++ a/drivers/isdn/hisax/w6692.c
@@ -1011,7 +1011,7 @@ setup_w6692(struct IsdnCard *card)
 		return (0);
 #ifdef CONFIG_PCI
 	while (id_list[id_idx].vendor_id) {
-		dev_w6692 = pci_find_device(id_list[id_idx].vendor_id,
+		dev_w6692 = pci_get_device(id_list[id_idx].vendor_id,
 					    id_list[id_idx].device_id,
 					    dev_w6692);
 		if (dev_w6692) {
@@ -1043,11 +1043,11 @@ setup_w6692(struct IsdnCard *card)
 	cs->irq = pci_irq;
 	if (!cs->irq) {
 		printk(KERN_WARNING "W6692: No IRQ for PCI card found\n");
-		return (0);
+		goto dev_w6692_cleanup;
 	}
 	if (!pci_ioaddr) {
 		printk(KERN_WARNING "W6692: NO I/O Base Address found\n");
-		return (0);
+		goto dev_w6692_cleanup;
 	}
 	cs->hw.w6692.iobase = pci_ioaddr;
 	printk(KERN_INFO "Found: %s %s, I/O base: 0x%x, irq: %d\n",
@@ -1059,7 +1059,7 @@ setup_w6692(struct IsdnCard *card)
 		       id_list[cs->subtyp].card_name,
 		       cs->hw.w6692.iobase,
 		       cs->hw.w6692.iobase + 255);
-		return (0);
+		goto dev_w6692_cleanup;
 	}
 #else
 	printk(KERN_WARNING "HiSax: W6692 and NO_PCI_BIOS\n");
@@ -1089,5 +1089,11 @@ setup_w6692(struct IsdnCard *card)
 	printk(KERN_INFO "W6692 D_EXIR=0x%X\n", ReadW6692(cs, W_D_EXIR));
 	printk(KERN_INFO "W6692 D_EXIM=0x%X\n", ReadW6692(cs, W_D_EXIM));
 	printk(KERN_INFO "W6692 D_RSTA=0x%X\n", ReadW6692(cs, W_D_RSTA));
+
+	pci_dev_put(dev_w6692);
 	return (1);
+
+dev_w6692_cleanup:
+		pci_dev_put(dev_w6692);
+	return (0);
 }
diff -puN drivers/isdn/hysdn/hysdn_init.c~update-isdn-tree-to-use-pci_get_device drivers/isdn/hysdn/hysdn_init.c
--- a/drivers/isdn/hysdn/hysdn_init.c~update-isdn-tree-to-use-pci_get_device
+++ a/drivers/isdn/hysdn/hysdn_init.c
@@ -76,13 +76,14 @@ search_cards(void)
 
 	card_root = NULL;
 	card_last = NULL;
-	while ((akt_pcidev = pci_find_device(PCI_VENDOR_ID_HYPERCOPE, PCI_DEVICE_ID_HYPERCOPE_PLX,
+	while ((akt_pcidev = pci_get_device(PCI_VENDOR_ID_HYPERCOPE, PCI_DEVICE_ID_HYPERCOPE_PLX,
 					     akt_pcidev)) != NULL) {
 		if (pci_enable_device(akt_pcidev))
 			continue;
 
 		if (!(card = kzalloc(sizeof(hysdn_card), GFP_KERNEL))) {
 			printk(KERN_ERR "HYSDN: unable to alloc device mem \n");
+			pci_dev_put(akt_pcidev);
 			return;
 		}
 		card->myid = cardmax;	/* set own id */
@@ -121,6 +122,7 @@ search_cards(void)
 			card_root = card;
 		card_last = card;	/* new chain end */
 	}			/* device found */
+	pci_dev_put(akt_pcidev);
 }				/* search_cards */
 
 /************************************************************************************/
_

Patches currently in -mm which might be from kkeil@suse.de are
