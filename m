From: akpm@linux-foundation.org
Subject: + isdn-hisax-niccy-convert-to-modern-isa-pnp-pci-probing.patch added to -mm tree
Date: Thu, 14 Feb 2008 23:07:35 -0800
Message-ID: <200802150707.m1F77Z5H025230@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34172 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761411AbYBOHIr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 15 Feb 2008 02:08:47 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jeff@garzik.org, greg@kroah.com, kkeil@suse.de


The patch titled
     isdn: HiSax niccy: convert to modern ISA/PNP/PCI probing
has been added to the -mm tree.  Its filename is
     isdn-hisax-niccy-convert-to-modern-isa-pnp-pci-probing.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: isdn: HiSax niccy: convert to modern ISA/PNP/PCI probing
From: Jeff Garzik <jeff@garzik.org>

Signed-off-by: Jeff Garzik <jeff@garzik.org>
Cc: Greg KH <greg@kroah.com>
Cc: Karsten Keil <kkeil@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/isdn/hisax/Kconfig  |    3 
 drivers/isdn/hisax/Makefile |    2 
 drivers/isdn/hisax/config.c |   26 -
 drivers/isdn/hisax/niccy.c  |  458 ++++++++++++++++++++++++----------
 4 files changed, 333 insertions(+), 156 deletions(-)

diff -puN drivers/isdn/hisax/Kconfig~isdn-hisax-niccy-convert-to-modern-isa-pnp-pci-probing drivers/isdn/hisax/Kconfig
--- a/drivers/isdn/hisax/Kconfig~isdn-hisax-niccy-convert-to-modern-isa-pnp-pci-probing
+++ a/drivers/isdn/hisax/Kconfig
@@ -257,7 +257,8 @@ config HISAX_NETJET_U
 	  settings.
 
 config HISAX_NICCY
-	bool "Niccy PnP/PCI card"
+	tristate "Niccy PnP/PCI card"
+	depends on (ISA || PCI)
 	help
 	  This enables HiSax support for the Dr. Neuhaus Niccy PnP or PCI.
 
diff -puN drivers/isdn/hisax/Makefile~isdn-hisax-niccy-convert-to-modern-isa-pnp-pci-probing drivers/isdn/hisax/Makefile
--- a/drivers/isdn/hisax/Makefile~isdn-hisax-niccy-convert-to-modern-isa-pnp-pci-probing
+++ a/drivers/isdn/hisax/Makefile
@@ -24,6 +24,7 @@ obj-$(CONFIG_HISAX_NETJET_U)		+= netjet_
 obj-$(CONFIG_HISAX_TELESPCI)		+= telespci.o libhisax.o
 obj-$(CONFIG_HISAX_FRITZPCI)		+= avm_pci.o libhisax.o
 obj-$(CONFIG_HISAX_GAZEL)		+= gazel.o libhisax.o
+obj-$(CONFIG_HISAX_NICCY)		+= niccy.o libhisax.o
 
 bkm_a4t_pci-objs			:= bkm_a4t.o jade.o
 enternow-objs				:= enternow_pci.o amd7930_fn.o
@@ -61,7 +62,6 @@ hisax-$(CONFIG_HISAX_SPORTSTER)		+= spor
 hisax-$(CONFIG_HISAX_MIC)		+= mic.o
 hisax-$(CONFIG_HISAX_HFCS)		+= hfcscard.o hfc_2bds0.o
 hisax-$(CONFIG_HISAX_HFC_SX)		+= hfc_sx.o
-hisax-$(CONFIG_HISAX_NICCY)		+= niccy.o
 hisax-$(CONFIG_HISAX_ISURF)		+= isurf.o isar.o
 hisax-$(CONFIG_HISAX_HSTSAPHIR)		+= saphir.o
 hisax-$(CONFIG_HISAX_SCT_QUADRO)	+= bkm_a8.o
diff -puN drivers/isdn/hisax/config.c~isdn-hisax-niccy-convert-to-modern-isa-pnp-pci-probing drivers/isdn/hisax/config.c
--- a/drivers/isdn/hisax/config.c~isdn-hisax-niccy-convert-to-modern-isa-pnp-pci-probing
+++ a/drivers/isdn/hisax/config.c
@@ -201,13 +201,6 @@ const char *CardType[] = {
 #define DEFAULT_CFG {5,0x2E0,0,0}
 #endif
 
-#ifdef CONFIG_HISAX_NICCY
-#undef DEFAULT_CARD
-#undef DEFAULT_CFG
-#define DEFAULT_CARD ISDN_CTYPE_NICCY
-#define DEFAULT_CFG {0,0x0,0,0}
-#endif
-
 #ifdef CONFIG_HISAX_ISURF
 #undef DEFAULT_CARD
 #undef DEFAULT_CFG
@@ -258,10 +251,6 @@ static int io[HISAX_MAX_CARDS] = { 0, };
 #ifdef CONFIG_HISAX_16_3
 #define IO0_IO1
 #endif
-#ifdef CONFIG_HISAX_NICCY
-#undef IO0_IO1
-#define IO0_IO1
-#endif
 #ifdef IO0_IO1
 static int io0[HISAX_MAX_CARDS] __devinitdata = { 0, };
 static int io1[HISAX_MAX_CARDS] __devinitdata = { 0, };
@@ -447,10 +436,6 @@ extern int setup_hfcs(struct IsdnCard *c
 extern int setup_hfcsx(struct IsdnCard *card);
 #endif
 
-#if CARD_NICCY
-extern int setup_niccy(struct IsdnCard *card);
-#endif
-
 #if CARD_ISURF
 extern int setup_isurf(struct IsdnCard *card);
 #endif
@@ -827,11 +812,6 @@ static int __devinit hisax_cs_setup_card
 		ret = setup_hfcsx(card);
 		break;
 #endif
-#if CARD_NICCY
-	case ISDN_CTYPE_NICCY:
-		ret = setup_niccy(card);
-		break;
-#endif
 #if CARD_ISURF
 	case ISDN_CTYPE_ISURF:
 		ret = setup_isurf(card);
@@ -860,6 +840,7 @@ static int __devinit hisax_cs_setup_card
 	case ISDN_CTYPE_TELESPCI:
 	case ISDN_CTYPE_FRITZPCI:
 	case ISDN_CTYPE_GAZEL:
+	case ISDN_CTYPE_NICCY:
 		printk(KERN_WARNING "HiSax: Support for %s Card has moved "
 		       "to separate PCI driver module\n",
 		       CardType[card->typ]);
@@ -1273,7 +1254,6 @@ static int __init HiSax_init(void)
 
 #ifdef IO0_IO1
 		case ISDN_CTYPE_PNP:
-		case ISDN_CTYPE_NICCY:
 			cards[j].para[0] = irq[i];
 			cards[j].para[1] = io0[i];
 			cards[j].para[2] = io1[i];
@@ -1330,6 +1310,7 @@ static int __init HiSax_init(void)
 		case ISDN_CTYPE_TELESPCI:
 		case ISDN_CTYPE_FRITZPCI:
 		case ISDN_CTYPE_GAZEL:
+		case ISDN_CTYPE_NICCY:
 			break;
 
 		case ISDN_CTYPE_SCT_QUADRO:
@@ -1818,9 +1799,6 @@ static struct pci_device_id hisax_pci_tb
 #ifdef CONFIG_HISAX_SCT_QUADRO
 	{PCI_VENDOR_ID_PLX,      PCI_DEVICE_ID_PLX_9050,         PCI_ANY_ID, PCI_ANY_ID},
 #endif
-#ifdef CONFIG_HISAX_NICCY
-	{PCI_VENDOR_ID_SATSAGEM, PCI_DEVICE_ID_SATSAGEM_NICCY,   PCI_ANY_ID,PCI_ANY_ID},
-#endif
 #ifdef CONFIG_HISAX_SEDLBAUER
 	{PCI_VENDOR_ID_TIGERJET, PCI_DEVICE_ID_TIGERJET_100,     PCI_ANY_ID,PCI_ANY_ID},
 #endif
diff -puN drivers/isdn/hisax/niccy.c~isdn-hisax-niccy-convert-to-modern-isa-pnp-pci-probing drivers/isdn/hisax/niccy.c
--- a/drivers/isdn/hisax/niccy.c~isdn-hisax-niccy-convert-to-modern-isa-pnp-pci-probing
+++ a/drivers/isdn/hisax/niccy.c
@@ -15,11 +15,21 @@
 
 #include <linux/init.h>
 #include "hisax.h"
+#include "hisax_proto.h"
 #include "isac.h"
 #include "hscx.h"
 #include "isdnl1.h"
 #include <linux/pci.h>
-#include <linux/isapnp.h>
+#include <linux/pnp.h>
+#include <linux/isa.h>
+
+static int niccy_protocol;		/* 0 == use DEFAULT_PROTO */
+
+#ifdef CONFIG_ISA
+static int niccy_base0;
+static int niccy_base1;
+static int niccy_irq;
+#endif /* CONFIG_ISA */
 
 static const char *niccy_revision = "$Revision: 1.21.2.4 $";
 
@@ -222,142 +232,18 @@ static int niccy_card_msg(struct IsdnCar
 	return 0;
 }
 
-#ifdef __ISAPNP__
-static struct pnp_card *pnp_c __devinitdata = NULL;
-#endif
-
-int __devinit setup_niccy(struct IsdnCard *card)
+static int __devinit setup_niccy(struct IsdnCard *card)
 {
 	struct IsdnCardState *cs = card->cs;
 	char tmp[64];
 
 	strcpy(tmp, niccy_revision);
 	printk(KERN_INFO "HiSax: Niccy driver Rev. %s\n", HiSax_getrev(tmp));
-	if (cs->typ != ISDN_CTYPE_NICCY)
-		return 0;
-#ifdef __ISAPNP__
-	if (!card->para[1] && isapnp_present()) {
-		struct pnp_dev *pnp_d = NULL;
-		int err;
-
-		pnp_c = pnp_find_card(ISAPNP_VENDOR('S', 'D', 'A'),
-				ISAPNP_FUNCTION(0x0150), pnp_c);
-		if (pnp_c) {
-			pnp_d = pnp_find_dev(pnp_c,
-					ISAPNP_VENDOR('S', 'D', 'A'),
-					ISAPNP_FUNCTION(0x0150), pnp_d);
-			if (!pnp_d) {
-				printk(KERN_ERR "NiccyPnP: PnP error card "
-					"found, no device\n");
-				return 0;
-			}
-			pnp_disable_dev(pnp_d);
-			err = pnp_activate_dev(pnp_d);
-			if (err < 0) {
-				printk(KERN_WARNING "%s: pnp_activate_dev "
-					"ret(%d)\n", __FUNCTION__, err);
-				return 0;
-			}
-			card->para[1] = pnp_port_start(pnp_d, 0);
-			card->para[2] = pnp_port_start(pnp_d, 1);
-			card->para[0] = pnp_irq(pnp_d, 0);
-			if (!card->para[0] || !card->para[1] ||
-					!card->para[2]) {
-				printk(KERN_ERR "NiccyPnP:some resources are "
-					"missing %ld/%lx/%lx\n",
-					card->para[0], card->para[1],
-					card->para[2]);
-				pnp_disable_dev(pnp_d);
-				return 0;
-			}
-		} else
-			printk(KERN_INFO "NiccyPnP: no ISAPnP card found\n");
-	}
-#endif
-	if (card->para[1]) {
-		cs->hw.niccy.isac = card->para[1] + ISAC_PNP;
-		cs->hw.niccy.hscx = card->para[1] + HSCX_PNP;
-		cs->hw.niccy.isac_ale = card->para[2] + ISAC_PNP;
-		cs->hw.niccy.hscx_ale = card->para[2] + HSCX_PNP;
-		cs->hw.niccy.cfg_reg = 0;
-		cs->subtyp = NICCY_PNP;
-		cs->irq = card->para[0];
-		if (!request_region(cs->hw.niccy.isac, 2, "niccy data")) {
-			printk(KERN_WARNING "HiSax: NICCY data port %x-%x "
-				"already in use\n",
-				cs->hw.niccy.isac, cs->hw.niccy.isac + 1);
-			return 0;
-		}
-		if (!request_region(cs->hw.niccy.isac_ale, 2, "niccy addr")) {
-			printk(KERN_WARNING "HiSax: NICCY address port %x-%x "
-				"already in use\n",
-				cs->hw.niccy.isac_ale,
-				cs->hw.niccy.isac_ale + 1);
-			release_region(cs->hw.niccy.isac, 2);
-			return 0;
-		}
-	} else {
-#ifdef CONFIG_PCI_LEGACY
-		static struct pci_dev *niccy_dev __devinitdata;
 
-		u_int pci_ioaddr;
-		cs->subtyp = 0;
-		if ((niccy_dev = pci_find_device(PCI_VENDOR_ID_SATSAGEM,
-						 PCI_DEVICE_ID_SATSAGEM_NICCY,
-						 niccy_dev))) {
-			if (pci_enable_device(niccy_dev))
-				return 0;
-			/* get IRQ */
-			if (!niccy_dev->irq) {
-				printk(KERN_WARNING
-				       "Niccy: No IRQ for PCI card found\n");
-				return 0;
-			}
-			cs->irq = niccy_dev->irq;
-			cs->hw.niccy.cfg_reg = pci_resource_start(niccy_dev, 0);
-			if (!cs->hw.niccy.cfg_reg) {
-				printk(KERN_WARNING
-				       "Niccy: No IO-Adr for PCI cfg found\n");
-				return 0;
-			}
-			pci_ioaddr = pci_resource_start(niccy_dev, 1);
-			if (!pci_ioaddr) {
-				printk(KERN_WARNING
-				       "Niccy: No IO-Adr for PCI card found\n");
-				return 0;
-			}
-			cs->subtyp = NICCY_PCI;
-		} else {
-			printk(KERN_WARNING "Niccy: No PCI card found\n");
-			return 0;
-		}
-		cs->irq_flags |= IRQF_SHARED;
-		cs->hw.niccy.isac = pci_ioaddr + ISAC_PCI_DATA;
-		cs->hw.niccy.isac_ale = pci_ioaddr + ISAC_PCI_ADDR;
-		cs->hw.niccy.hscx = pci_ioaddr + HSCX_PCI_DATA;
-		cs->hw.niccy.hscx_ale = pci_ioaddr + HSCX_PCI_ADDR;
-		if (!request_region(cs->hw.niccy.isac, 4, "niccy")) {
-			printk(KERN_WARNING
-			       "HiSax: NICCY data port %x-%x already in use\n",
-			       cs->hw.niccy.isac, cs->hw.niccy.isac + 4);
-			return 0;
-		}
-		if (!request_region(cs->hw.niccy.cfg_reg, 0x40, "niccy pci")) {
-			printk(KERN_WARNING
-			       "HiSax: NICCY pci port %x-%x already in use\n",
-			       cs->hw.niccy.cfg_reg,
-			       cs->hw.niccy.cfg_reg + 0x40);
-			release_region(cs->hw.niccy.isac, 4);
-			return 0;
-		}
-#else
-		printk(KERN_WARNING "Niccy: io0 0 and NO_PCI_BIOS\n");
-		printk(KERN_WARNING "Niccy: unable to config NICCY PCI\n");
-		return 0;
-#endif				/* CONFIG_PCI_LEGACY */
-	}
-	printk(KERN_INFO "HiSax: NICCY %s config irq:%d data:0x%X ale:0x%X\n",
-		(cs->subtyp == 1) ? "PnP" : "PCI",
+	WARN_ON(cs->typ != ISDN_CTYPE_NICCY);
+
+	printk(KERN_INFO "HiSax: %s %s config irq:%d data:0x%X ale:0x%X\n",
+		"niccy", (cs->subtyp == 1) ? "PnP" : "PCI",
 		cs->irq, cs->hw.niccy.isac, cs->hw.niccy.isac_ale);
 	setup_isac(cs);
 	cs->readisac = &ReadISAC;
@@ -378,3 +264,315 @@ int __devinit setup_niccy(struct IsdnCar
 	}
 	return 1;
 }
+
+#ifdef CONFIG_ISA
+
+static int __devinit niccy_isa_setup(struct IsdnCard *card)
+{
+	struct IsdnCardState *cs = card->cs;
+
+	cs->hw.niccy.isac = card->para[1] + ISAC_PNP;
+	cs->hw.niccy.hscx = card->para[1] + HSCX_PNP;
+	cs->hw.niccy.isac_ale = card->para[2] + ISAC_PNP;
+	cs->hw.niccy.hscx_ale = card->para[2] + HSCX_PNP;
+	cs->hw.niccy.cfg_reg = 0;
+	cs->subtyp = NICCY_PNP;
+	cs->irq = card->para[0];
+	if (!request_region(cs->hw.niccy.isac, 2, "niccy data")) {
+		printk(KERN_WARNING "HiSax: %s data port %x-%x "
+			"already in use\n", "niccy",
+			cs->hw.niccy.isac, cs->hw.niccy.isac + 1);
+		return 0;
+	}
+	if (!request_region(cs->hw.niccy.isac_ale, 2, "niccy addr")) {
+		printk(KERN_WARNING "HiSax: %s address port %x-%x "
+			"already in use\n", "niccy",
+			cs->hw.niccy.isac_ale,
+			cs->hw.niccy.isac_ale + 1);
+		release_region(cs->hw.niccy.isac, 2);
+		return 0;
+	}
+
+	return setup_niccy(card);
+}
+
+static int __devinit niccy_isa_init_one(struct device *dev, unsigned int id)
+{
+	struct IsdnCard icard = { ISDN_CTYPE_NICCY, };
+	int cardnr;
+
+	icard.para[0] = niccy_irq;
+	icard.para[1] = niccy_base0;
+	icard.para[2] = niccy_base1;
+	if (!niccy_protocol)
+		icard.protocol = DEFAULT_PROTO;
+	else
+		icard.protocol = niccy_protocol;
+
+	cardnr = hisax_init_hotplug(&icard, niccy_isa_setup);
+	if (cardnr < 0)
+		return -ENODEV;
+
+	dev_set_drvdata(dev, (void *)(unsigned long) cardnr);
+	return 0;
+}
+
+static int __devexit niccy_isa_remove_one(struct device *dev, unsigned int id)
+{
+	int cardnr = (unsigned long) dev_get_drvdata(dev);
+
+	HiSax_closecard(cardnr);
+	return 0;
+}
+
+static struct isa_driver niccy_isa_driver = {
+	.probe		= niccy_isa_init_one,
+	.remove		= __devexit_p(niccy_isa_remove_one),
+	.driver = {
+		.owner	= THIS_MODULE,
+		.name	= "niccy_pci",
+	},
+};
+
+#ifdef CONFIG_PNP
+
+static int __devinit niccy_pnp_setup(struct IsdnCard *card)
+{
+	struct pnp_dev *pnp_d = (void *) card->para[0];
+	int err;
+
+	pnp_disable_dev(pnp_d);
+	err = pnp_activate_dev(pnp_d);
+	if (err < 0) {
+		printk(KERN_WARNING "%s: pnp_activate_dev "
+			"ret(%d)\n", __FUNCTION__, err);
+		return 0;
+	}
+	card->para[1] = pnp_port_start(pnp_d, 0);
+	card->para[2] = pnp_port_start(pnp_d, 1);
+	card->para[0] = pnp_irq(pnp_d, 0);
+	if (!card->para[0] || !card->para[1] ||
+			!card->para[2]) {
+		printk(KERN_ERR "NiccyPnP:some resources are "
+			"missing %ld/%lx/%lx\n",
+			card->para[0], card->para[1],
+			card->para[2]);
+		pnp_disable_dev(pnp_d);
+		return 0;
+	}
+
+	return niccy_isa_setup(card);
+}
+
+static int __devinit niccy_pnp_init_one(struct pnp_dev *pdev,
+				       const struct pnp_device_id *dev_id)
+{
+	struct IsdnCard icard = { ISDN_CTYPE_NICCY, };
+	int cardnr;
+
+	icard.para[0] = (unsigned long) pdev;
+	if (!niccy_protocol)
+		icard.protocol = DEFAULT_PROTO;
+	else
+		icard.protocol = niccy_protocol;
+
+	cardnr = hisax_init_hotplug(&icard, niccy_pnp_setup);
+	if (cardnr < 0)
+		return -ENODEV;
+
+	pnp_set_drvdata(pdev, (void *)(unsigned long) cardnr);
+	return 0;
+}
+
+static void __devexit niccy_pnp_remove_one(struct pnp_dev *pdev)
+{
+	int cardnr = (unsigned long) pnp_get_drvdata(pdev);
+
+	HiSax_closecard(cardnr);
+}
+
+static struct pnp_device_id niccy_pnp_table[] = {
+	{ .id = "SDA0150", },
+
+	{ .id = "" }		/* terminate list */
+};
+
+static struct pnp_driver niccy_pnp_driver = {
+	.name		= "niccy",
+	.id_table	= niccy_pnp_table,
+	.probe		= niccy_pnp_init_one,
+	.remove		= __devexit_p(niccy_pnp_remove_one),
+};
+#endif /* CONFIG_PNP */
+#endif /* CONFIG_ISA */
+
+#ifdef CONFIG_PCI
+
+static int __devinit niccy_pci_setup(struct IsdnCard *card)
+{
+	u_int pci_ioaddr;
+	struct pci_dev *niccy_dev = (void *) card->para[0];
+	struct IsdnCardState *cs = card->cs;
+
+	cs->subtyp = 0;
+	if (pci_enable_device(niccy_dev))
+		return 0;
+	/* get IRQ */
+	if (!niccy_dev->irq) {
+		printk(KERN_WARNING
+		       "Niccy: No IRQ for PCI card found\n");
+		return 0;
+	}
+	cs->irq = niccy_dev->irq;
+	cs->hw.niccy.cfg_reg = pci_resource_start(niccy_dev, 0);
+	if (!cs->hw.niccy.cfg_reg) {
+		printk(KERN_WARNING
+		       "Niccy: No IO-Adr for PCI cfg found\n");
+		return 0;
+	}
+	pci_ioaddr = pci_resource_start(niccy_dev, 1);
+	if (!pci_ioaddr) {
+		printk(KERN_WARNING
+		       "Niccy: No IO-Adr for PCI card found\n");
+		return 0;
+	}
+	cs->subtyp = NICCY_PCI;
+	cs->irq_flags |= IRQF_SHARED;
+	cs->hw.niccy.isac = pci_ioaddr + ISAC_PCI_DATA;
+	cs->hw.niccy.isac_ale = pci_ioaddr + ISAC_PCI_ADDR;
+	cs->hw.niccy.hscx = pci_ioaddr + HSCX_PCI_DATA;
+	cs->hw.niccy.hscx_ale = pci_ioaddr + HSCX_PCI_ADDR;
+	if (!request_region(cs->hw.niccy.isac, 4, "niccy")) {
+		printk(KERN_WARNING
+		       "HiSax: %s data port %x-%x already in use\n",
+		       "niccy",
+		       cs->hw.niccy.isac, cs->hw.niccy.isac + 4);
+		return 0;
+	}
+	if (!request_region(cs->hw.niccy.cfg_reg, 0x40, "niccy pci")) {
+		printk(KERN_WARNING
+		       "HiSax: %s pci port %x-%x already in use\n",
+		       "niccy",
+		       cs->hw.niccy.cfg_reg,
+		       cs->hw.niccy.cfg_reg + 0x40);
+		release_region(cs->hw.niccy.isac, 4);
+		return 0;
+	}
+
+	return setup_niccy(card);
+}
+
+static int __devinit niccy_pci_init_one(struct pci_dev *pdev,
+				      const struct pci_device_id *ent)
+{
+	struct IsdnCard icard = { ISDN_CTYPE_NICCY, };
+	int cardnr;
+
+	icard.para[0] = (unsigned long) pdev;
+	if (!niccy_protocol)
+		icard.protocol = DEFAULT_PROTO;
+	else
+		icard.protocol = niccy_protocol;
+
+	cardnr = hisax_init_hotplug(&icard, niccy_pci_setup);
+	if (cardnr < 0)
+		return -ENODEV;
+
+	pci_set_drvdata(pdev, (void *)(unsigned long) cardnr);
+	return 0;
+}
+
+static struct pci_device_id niccy_pci_table[] = {
+	{ PCI_VDEVICE(SATSAGEM, PCI_DEVICE_ID_SATSAGEM_NICCY) },
+
+	{ }		/* terminate list */
+};
+
+static struct pci_driver niccy_pci_driver = {
+	.name		= "niccy",
+	.id_table	= niccy_pci_table,
+	.probe		= niccy_pci_init_one,
+	.remove		= hisax_pci_remove_one,
+};
+
+#endif /* CONFIG_PCI */
+
+static int __init niccy_mod_init(void)
+{
+	int rc = 0;
+
+#ifdef CONFIG_ISA
+	if (niccy_irq && niccy_base0 && niccy_base1) {
+		rc = isa_register_driver(&niccy_isa_driver, 1);
+		if (rc)
+			return rc;
+	}
+#ifdef CONFIG_PNP
+	else {
+		rc = pnp_register_driver(&niccy_pnp_driver);
+		if (rc)
+			return rc;
+	}
+#endif
+#endif /* CONFIG_ISA */
+
+#ifdef CONFIG_PCI
+	rc = pci_register_driver(&niccy_pci_driver);
+	if (rc)
+		goto err_out_isa;
+#endif /* CONFIG_PCI */
+
+	return 0;
+
+#ifdef CONFIG_PCI
+err_out_isa:
+
+#ifdef CONFIG_ISA
+	if (niccy_irq && niccy_base0 && niccy_base1)
+		isa_unregister_driver(&niccy_isa_driver);
+#ifdef CONFIG_PNP
+	else
+		pnp_unregister_driver(&niccy_pnp_driver);
+#endif /* CONFIG_PNP */
+#endif /* CONFIG_ISA */
+
+	return rc;
+#endif /* CONFIG_PCI */
+}
+
+static void __exit niccy_mod_exit(void)
+{
+#ifdef CONFIG_PCI
+	pci_unregister_driver(&niccy_pci_driver);
+#endif /* CONFIG_PCI */
+
+#ifdef CONFIG_ISA
+	if (niccy_irq && niccy_base0 && niccy_base1)
+		isa_unregister_driver(&niccy_isa_driver);
+#ifdef CONFIG_PNP
+	else
+		pnp_unregister_driver(&niccy_pnp_driver);
+#endif /* CONFIG_PNP */
+#endif /* CONFIG_ISA */
+}
+
+module_init(niccy_mod_init);
+module_exit(niccy_mod_exit);
+
+#ifdef CONFIG_ISA
+module_param_named(irq, niccy_irq, int, 0444);
+MODULE_PARM_DESC(irq, "ISA IRQ.  Zero disables ISA support (default).");
+
+module_param_named(base0, niccy_base0, int, 0444);
+MODULE_PARM_DESC(base0, "ISA I/O base #0.  Zero disables ISA support (default).");
+
+module_param_named(base1, niccy_base1, int, 0444);
+MODULE_PARM_DESC(base1, "ISA I/O base #1.  Zero disables ISA support (default).");
+#endif /* CONFIG_ISA */
+
+module_param_named(protocol, niccy_protocol, int, 0444);
+MODULE_PARM_DESC(protocol, "Values 0 (default) through 4. See ISDN_PTYPE_xxx in linux/isdnif.h");
+
+MODULE_DEVICE_TABLE(pci, niccy_pci_table);
+MODULE_DESCRIPTION("ISDN HiSax Niccy PCI/PNP driver");
+MODULE_LICENSE("GPL");
_

Patches currently in -mm which might be from jeff@garzik.org are

origin.patch
git-libata-all.patch
git-net.patch
3c509-convert-to-isa_driver-and-pnp_driver-v4.patch
3c509-convert-to-isa_driver-and-pnp_driver-v4-cleanup.patch
usb-net-asix-does-not-really-need-10-100mbit.patch
forcedeth-power-down-phy-when-interface-is-down.patch
forcedeth-fix-mac-address-detection-on-network-card-regression-in-2623.patch
8390-split-8390-support-into-a-pausing-and-a-non-pausing-driver-core.patch
e1000e-make-e1000e-default-to-the-same-kconfig-setting-as-e1000.patch
update-smc91x-driver-with-arm-versatile-board-info.patch
libsas-convert-ata-bridge-to-use-new-eh.patch
isdn-pci-add-missing-file.patch
isdn-hisax-modularize-card-setup.patch
isdn-hisax-eliminate-many-unnecessary-references-to-cardtype.patch
isdn-ready-hisax-driver-for-modularization.patch
isdn-hisax-bkm_a4t-convert-to-pci-hotplug-api.patch
isdn-hisax-enternow-convert-to-pci-hotplug-api.patch
isdn-hisax-hfc_pci-w6692-convert-to-pci-hotplug-api.patch
isdn-hisax-nj_s-nj_u-convert-to-pci-hotplug-api.patch
isdn-hisax-telespci-convert-to-pci-hotplug-api.patch
isdn-hisax-avm_pci-convert-to-modern-pci-isa-pnp-probing.patch
isdn-hisax-gazel-convert-to-modern-isa-pci-probing.patch
isdn-hisax-niccy-convert-to-modern-isa-pnp-pci-probing.patch
isdn-hisax-diva-convert-to-modern-isa-pnp-pci-probing.patch
isdn-hisax-bkm_a8-convert-to-pci-hotplug-api.patch
