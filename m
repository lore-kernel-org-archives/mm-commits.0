From: akpm@linux-foundation.org
Subject: + isdn-hisax-avm_pci-convert-to-modern-pci-isa-pnp-probing.patch added to -mm tree
Date: Thu, 14 Feb 2008 23:07:31 -0800
Message-ID: <200802150707.m1F77V2P025219@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45825 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762387AbYBOHJX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 15 Feb 2008 02:09:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jeff@garzik.org, greg@kroah.com, jgarzik@redhat.com, kkeil@suse.de


The patch titled
     isdn: HiSax avm_pci: convert to modern PCI/ISA/PNP probing
has been added to the -mm tree.  Its filename is
     isdn-hisax-avm_pci-convert-to-modern-pci-isa-pnp-probing.patch

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
Subject: isdn: HiSax avm_pci: convert to modern PCI/ISA/PNP probing
From: Jeff Garzik <jeff@garzik.org>

Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
Cc: Greg KH <greg@kroah.com>
Cc: Karsten Keil <kkeil@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/isdn/hisax/Kconfig   |    4 
 drivers/isdn/hisax/Makefile  |    2 
 drivers/isdn/hisax/avm_pci.c |  324 +++++++++++++++++++++++----------
 drivers/isdn/hisax/config.c  |   22 --
 4 files changed, 236 insertions(+), 116 deletions(-)

diff -puN drivers/isdn/hisax/Kconfig~isdn-hisax-avm_pci-convert-to-modern-pci-isa-pnp-probing drivers/isdn/hisax/Kconfig
--- a/drivers/isdn/hisax/Kconfig~isdn-hisax-avm_pci-convert-to-modern-pci-isa-pnp-probing
+++ a/drivers/isdn/hisax/Kconfig
@@ -132,8 +132,8 @@ config HISAX_AVM_A1
 	  non-standard IRQ/port settings.
 
 config HISAX_FRITZPCI
-	bool "AVM PnP/PCI (Fritz!PnP/PCI)"
-	depends on BROKEN || !PPC64
+	tristate "AVM PnP/PCI (Fritz!PnP/PCI)"
+	depends on (ISA || PNP || PCI) && (BROKEN || !PPC64)
 	help
 	  This enables HiSax support for the AVM "Fritz!PnP" and "Fritz!PCI".
 	  See <file:Documentation/isdn/README.HiSax> on how to configure it.
diff -puN drivers/isdn/hisax/Makefile~isdn-hisax-avm_pci-convert-to-modern-pci-isa-pnp-probing drivers/isdn/hisax/Makefile
--- a/drivers/isdn/hisax/Makefile~isdn-hisax-avm_pci-convert-to-modern-pci-isa-pnp-probing
+++ a/drivers/isdn/hisax/Makefile
@@ -22,6 +22,7 @@ obj-$(CONFIG_HISAX_W6692)		+= w6692.o li
 obj-$(CONFIG_HISAX_NETJET)		+= netjet_s.o libhisax.o
 obj-$(CONFIG_HISAX_NETJET_U)		+= netjet_u.o libhisax.o
 obj-$(CONFIG_HISAX_TELESPCI)		+= telespci.o libhisax.o
+obj-$(CONFIG_HISAX_FRITZPCI)		+= avm_pci.o libhisax.o
 
 bkm_a4t_pci-objs			:= bkm_a4t.o jade.o
 enternow-objs				:= enternow_pci.o amd7930_fn.o
@@ -49,7 +50,6 @@ hisax-$(CONFIG_HISAX_16_3)		+= teles3.o
 hisax-$(CONFIG_HISAX_S0BOX)		+= s0box.o
 hisax-$(CONFIG_HISAX_AVM_A1)		+= avm_a1.o
 hisax-$(CONFIG_HISAX_AVM_A1_PCMCIA)	+= avm_a1p.o
-hisax-$(CONFIG_HISAX_FRITZPCI)		+= avm_pci.o
 hisax-$(CONFIG_HISAX_ELSA)		+= elsa.o
 hisax-$(CONFIG_HISAX_IX1MICROR2)	+= ix1_micro.o
 hisax-$(CONFIG_HISAX_DIEHLDIVA)		+= diva.o ipacx.o
diff -puN drivers/isdn/hisax/avm_pci.c~isdn-hisax-avm_pci-convert-to-modern-pci-isa-pnp-probing drivers/isdn/hisax/avm_pci.c
--- a/drivers/isdn/hisax/avm_pci.c~isdn-hisax-avm_pci-convert-to-modern-pci-isa-pnp-probing
+++ a/drivers/isdn/hisax/avm_pci.c
@@ -14,13 +14,20 @@
 
 #include <linux/init.h>
 #include "hisax.h"
+#include "hisax_proto.h"
 #include "isac.h"
 #include "isdnl1.h"
 #include <linux/pci.h>
+#include <linux/isa.h>
 #include <linux/isapnp.h>
 #include <linux/interrupt.h>
 
-static const char *avm_pci_rev = "$Revision: 1.29.2.4 $";
+static int avm_protocol;		/* 0 == use DEFAULT_PROTO */
+
+#ifdef CONFIG_ISA
+static int avm_irq;			/* 0 == disable ISA probing */
+static int avm_io_base;			/* 0 == disable ISA probing */
+#endif
 
 #define  AVM_FRITZ_PCI		1
 #define  AVM_FRITZ_PNP		2
@@ -767,136 +774,267 @@ static int __devinit avm_setup_rest(stru
 	return (1);
 }
 
-#ifndef __ISAPNP__
+#ifdef CONFIG_ISA
 
-static int __devinit avm_pnp_setup(struct IsdnCardState *cs)
+static int __devinit avm_isa_setup(struct IsdnCard *card)
 {
-	return(1);	/* no-op: success */
+	struct IsdnCardState *cs = card->cs;
+
+	/* old manual method */
+	cs->hw.avm.cfg_reg = avm_io_base;
+	cs->irq = avm_irq;
+	cs->subtyp = AVM_FRITZ_PNP;
+
+	return avm_setup_rest(cs);
 }
 
-#else
+static int __devinit avm_isa_init_one(struct device *dev, unsigned int id)
+{
+	struct IsdnCard icard = { ISDN_CTYPE_FRITZPCI, };
+	int cardnr;
+
+	icard.para[0] = (unsigned long) dev;
+	if (!avm_protocol)
+		icard.protocol = DEFAULT_PROTO;
+	else
+		icard.protocol = avm_protocol;
 
-static struct pnp_card *pnp_avm_c __devinitdata = NULL;
+	cardnr = hisax_init_hotplug(&icard, avm_isa_setup);
+	if (cardnr < 0)
+		return -ENODEV;
+
+	dev_set_drvdata(dev, (void *)(unsigned long) cardnr);
+	return 0;
+}
 
-static int __devinit avm_pnp_setup(struct IsdnCardState *cs)
+static int __devexit avm_isa_remove_one(struct device *dev, unsigned int id)
 {
-	struct pnp_dev *pnp_avm_d = NULL;
+	int cardnr = (unsigned long) dev_get_drvdata(dev);
 
-	if (!isapnp_present())
-		return(1);	/* no-op: success */
+	HiSax_closecard(cardnr);
+	return 0;
+}
 
-	if ((pnp_avm_c = pnp_find_card(
-		ISAPNP_VENDOR('A', 'V', 'M'),
-		ISAPNP_FUNCTION(0x0900), pnp_avm_c))) {
-		if ((pnp_avm_d = pnp_find_dev(pnp_avm_c,
-			ISAPNP_VENDOR('A', 'V', 'M'),
-			ISAPNP_FUNCTION(0x0900), pnp_avm_d))) {
-			int err;
-
-			pnp_disable_dev(pnp_avm_d);
-			err = pnp_activate_dev(pnp_avm_d);
-			if (err<0) {
-				printk(KERN_WARNING "%s: pnp_activate_dev ret(%d)\n",
-					__FUNCTION__, err);
-				return(0);
-			}
-			cs->hw.avm.cfg_reg =
-				pnp_port_start(pnp_avm_d, 0);
-			cs->irq = pnp_irq(pnp_avm_d, 0);
-			if (!cs->irq) {
-				printk(KERN_ERR "FritzPnP:No IRQ\n");
-				return(0);
-			}
-			if (!cs->hw.avm.cfg_reg) {
-				printk(KERN_ERR "FritzPnP:No IO address\n");
-				return(0);
-			}
-			cs->subtyp = AVM_FRITZ_PNP;
+static struct isa_driver avm_isa_driver = {
+	.probe		= avm_isa_init_one,
+	.remove		= __devexit_p(avm_isa_remove_one),
+	.driver = {
+		.owner	= THIS_MODULE,
+		.name	= "avm_pci",
+	},
+};
 
-			return (2);	/* goto 'ready' label */
-		}
+#ifdef CONFIG_PNP
+static int __devinit avm_pnp_setup(struct IsdnCard *card)
+{
+	struct IsdnCardState *cs = card->cs;
+	struct pnp_dev *pnp_avm_d = (void *) card->para[0];
+	int err;
+
+	pnp_disable_dev(pnp_avm_d);
+
+	err = pnp_activate_dev(pnp_avm_d);
+	if (err<0) {
+		printk(KERN_WARNING "%s: pnp_activate_dev ret(%d)\n",
+			__FUNCTION__, err);
+		return(0);
 	}
 
-	return (1);
+	cs->irq = pnp_irq(pnp_avm_d, 0);
+	if (!cs->irq) {
+		printk(KERN_ERR "FritzPnP:No IRQ\n");
+		return(0);
+	}
+
+	cs->hw.avm.cfg_reg = pnp_port_start(pnp_avm_d, 0);
+	if (!cs->hw.avm.cfg_reg) {
+		printk(KERN_ERR "FritzPnP:No IO address\n");
+		return(0);
+	}
+	cs->subtyp = AVM_FRITZ_PNP;
+
+	return avm_setup_rest(cs);
 }
 
-#endif /* __ISAPNP__ */
+static int __devinit avm_pnp_init_one(struct pnp_dev *pdev,
+				       const struct pnp_device_id *dev_id)
+{
+	struct IsdnCard icard = { ISDN_CTYPE_FRITZPCI, };
+	int cardnr;
+
+	icard.para[0] = (unsigned long) pdev;
+	if (!avm_protocol)
+		icard.protocol = DEFAULT_PROTO;
+	else
+		icard.protocol = avm_protocol;
+
+	cardnr = hisax_init_hotplug(&icard, avm_pnp_setup);
+	if (cardnr < 0)
+		return -ENODEV;
 
-#ifndef CONFIG_PCI_LEGACY
+	pnp_set_drvdata(pdev, (void *)(unsigned long) cardnr);
+	return 0;
+}
 
-static int __devinit avm_pci_setup(struct IsdnCardState *cs)
+static void __devexit avm_pnp_remove_one(struct pnp_dev *pdev)
 {
-	return(1);	/* no-op: success */
+	int cardnr = (unsigned long) pnp_get_drvdata(pdev);
+
+	HiSax_closecard(cardnr);
 }
 
-#else
+static struct pnp_device_id avm_pnp_table[] = {
+	{ .id = "AVM0900", },
 
-static struct pci_dev *dev_avm __devinitdata = NULL;
+	{ .id = "" }		/* terminate list */
+};
 
-static int __devinit avm_pci_setup(struct IsdnCardState *cs)
-{
-	if ((dev_avm = pci_find_device(PCI_VENDOR_ID_AVM,
-		PCI_DEVICE_ID_AVM_A1, dev_avm))) {
+static struct pnp_driver avm_pnp_driver = {
+	.name		= "avm_pci",
+	.id_table	= avm_pnp_table,
+	.probe		= avm_pnp_init_one,
+	.remove		= __devexit_p(avm_pnp_remove_one),
+};
+#endif /* CONFIG_PNP */
+#endif /* CONFIG_ISA */
 
-		if (pci_enable_device(dev_avm))
-			return(0);
+#ifdef CONFIG_PCI
 
-		cs->irq = dev_avm->irq;
-		if (!cs->irq) {
-			printk(KERN_ERR "FritzPCI: No IRQ for PCI card found\n");
-			return(0);
-		}
+static int __devinit avm_pci_setup(struct IsdnCard *card)
+{
+	struct IsdnCardState *cs = card->cs;
+	struct pci_dev *dev_avm = (void *) card->para[0];
 
-		cs->hw.avm.cfg_reg = pci_resource_start(dev_avm, 1);
-		if (!cs->hw.avm.cfg_reg) {
-			printk(KERN_ERR "FritzPCI: No IO-Adr for PCI card found\n");
-			return(0);
-		}
+	if (pci_enable_device(dev_avm))
+		return(0);
 
-		cs->subtyp = AVM_FRITZ_PCI;
-	} else {
-		printk(KERN_WARNING "FritzPCI: No PCI card found\n");
+	cs->irq = dev_avm->irq;
+	if (!cs->irq) {
+		printk(KERN_ERR "FritzPCI: No IRQ for PCI card found\n");
 		return(0);
 	}
 
+	cs->hw.avm.cfg_reg = pci_resource_start(dev_avm, 1);
+	if (!cs->hw.avm.cfg_reg) {
+		printk(KERN_ERR "FritzPCI: No IO-Adr for PCI card found\n");
+		return(0);
+	}
+
+	cs->subtyp = AVM_FRITZ_PCI;
+
 	cs->irq_flags |= IRQF_SHARED;
 
-	return (1);
+	return avm_setup_rest(cs);
 }
 
-#endif /* CONFIG_PCI_LEGACY */
-
-int __devinit
-setup_avm_pcipnp(struct IsdnCard *card)
+static int __devinit avm_pci_init_one(struct pci_dev *pdev,
+				      const struct pci_device_id *ent)
 {
-	struct IsdnCardState *cs = card->cs;
-	char tmp[64];
-	int rc;
+	struct IsdnCard icard = { ISDN_CTYPE_FRITZPCI, };
+	int cardnr;
 
-	strcpy(tmp, avm_pci_rev);
-	printk(KERN_INFO "HiSax: AVM PCI driver Rev. %s\n", HiSax_getrev(tmp));
+	icard.para[0] = (unsigned long) pdev;
+	if (!avm_protocol)
+		icard.protocol = DEFAULT_PROTO;
+	else
+		icard.protocol = avm_protocol;
 
-	if (cs->typ != ISDN_CTYPE_FRITZPCI)
-		return (0);
+	cardnr = hisax_init_hotplug(&icard, avm_pci_setup);
+	if (cardnr < 0)
+		return -ENODEV;
+
+	pci_set_drvdata(pdev, (void *)(unsigned long) cardnr);
+	return 0;
+}
+
+static struct pci_device_id avm_pci_table[] = {
+	{ PCI_VDEVICE(AVM, PCI_DEVICE_ID_AVM_A1) },
+
+	{ }		/* terminate list */
+};
+
+static struct pci_driver avm_pci_driver = {
+	.name		= "avm_pci",
+	.id_table	= avm_pci_table,
+	.probe		= avm_pci_init_one,
+	.remove		= hisax_pci_remove_one,
+};
 
-	if (card->para[1]) {
-		/* old manual method */
-		cs->hw.avm.cfg_reg = card->para[1];
-		cs->irq = card->para[0];
-		cs->subtyp = AVM_FRITZ_PNP;
-		goto ready;
+#endif /* CONFIG_PCI */
+
+static int __init avm_mod_init(void)
+{
+	int rc = 0;
+
+#ifdef CONFIG_ISA
+	if (avm_irq && avm_io_base) {
+		rc = isa_register_driver(&avm_isa_driver, 1);
+		if (rc)
+			return rc;
 	}
+#ifdef CONFIG_PNP
+	else {
+		rc = pnp_register_driver(&avm_pnp_driver);
+		if (rc)
+			return rc;
+	}
+#endif
+#endif /* CONFIG_ISA */
 
-	rc = avm_pnp_setup(cs);
-	if (rc < 1)
-		return (0);
-	if (rc == 2)
-		goto ready;
+#ifdef CONFIG_PCI
+	rc = pci_register_driver(&avm_pci_driver);
+	if (rc)
+		goto err_out_isa;
+#endif /* CONFIG_PCI */
 
-	rc = avm_pci_setup(cs);
-	if (rc < 1)
-		return (0);
+	return 0;
 
-ready:
-	return avm_setup_rest(cs);
+#ifdef CONFIG_PCI
+err_out_isa:
+
+#ifdef CONFIG_ISA
+	if (avm_irq && avm_io_base)
+		isa_unregister_driver(&avm_isa_driver);
+#ifdef CONFIG_PNP
+	else
+		pnp_unregister_driver(&avm_pnp_driver);
+#endif /* CONFIG_PNP */
+#endif /* CONFIG_ISA */
+
+	return rc;
+#endif /* CONFIG_PCI */
 }
+
+static void __exit avm_mod_exit(void)
+{
+#ifdef CONFIG_PCI
+	pci_unregister_driver(&avm_pci_driver);
+#endif /* CONFIG_PCI */
+
+#ifdef CONFIG_ISA
+	if (avm_irq && avm_io_base)
+		isa_unregister_driver(&avm_isa_driver);
+#ifdef CONFIG_PNP
+	else
+		pnp_unregister_driver(&avm_pnp_driver);
+#endif /* CONFIG_PNP */
+#endif /* CONFIG_ISA */
+}
+
+module_init(avm_mod_init);
+module_exit(avm_mod_exit);
+
+#ifdef CONFIG_ISA
+module_param_named(irq, avm_irq, int, 0444);
+MODULE_PARM_DESC(irq, "ISA IRQ.  Zero disables ISA support (default).");
+
+module_param_named(io, avm_io_base, int, 0444);
+MODULE_PARM_DESC(io, "ISA I/O base.  Zero disables ISA support (default).");
+#endif /* CONFIG_ISA */
+
+module_param_named(protocol, avm_protocol, int, 0444);
+MODULE_PARM_DESC(protocol, "Values 0 (default) through 4. See ISDN_PTYPE_xxx in linux/isdnif.h");
+
+MODULE_DEVICE_TABLE(pci, avm_pci_table);
+MODULE_DESCRIPTION("ISDN HiSax Fritz!PCI/PNP driver");
+MODULE_LICENSE("GPL");
diff -puN drivers/isdn/hisax/config.c~isdn-hisax-avm_pci-convert-to-modern-pci-isa-pnp-probing drivers/isdn/hisax/config.c
--- a/drivers/isdn/hisax/config.c~isdn-hisax-avm_pci-convert-to-modern-pci-isa-pnp-probing
+++ a/drivers/isdn/hisax/config.c
@@ -117,13 +117,6 @@ const char *CardType[] = {
 #define DEFAULT_CFG {11,0x170,0,0}
 #endif
 
-#ifdef CONFIG_HISAX_FRITZPCI
-#undef DEFAULT_CARD
-#undef DEFAULT_CFG
-#define DEFAULT_CARD ISDN_CTYPE_FRITZPCI
-#define DEFAULT_CFG {0,0,0,0}
-#endif
-
 #ifdef CONFIG_HISAX_16_3
 #undef DEFAULT_CARD
 #undef DEFAULT_CFG
@@ -421,10 +414,6 @@ extern int setup_avm_a1(struct IsdnCard 
 extern int setup_avm_a1_pcmcia(struct IsdnCard *card);
 #endif
 
-#if CARD_FRITZPCI
-extern int setup_avm_pcipnp(struct IsdnCard *card);
-#endif
-
 #if CARD_ELSA
 extern int setup_elsa(struct IsdnCard *card);
 #endif
@@ -793,11 +782,6 @@ static int __devinit hisax_cs_setup_card
 		ret = setup_avm_a1_pcmcia(card);
 		break;
 #endif
-#if CARD_FRITZPCI
-	case ISDN_CTYPE_FRITZPCI:
-		ret = setup_avm_pcipnp(card);
-		break;
-#endif
 #if CARD_ELSA
 	case ISDN_CTYPE_ELSA:
 	case ISDN_CTYPE_ELSA_PNP:
@@ -890,6 +874,7 @@ static int __devinit hisax_cs_setup_card
 	case ISDN_CTYPE_NETJET_S:
 	case ISDN_CTYPE_NETJET_U:
 	case ISDN_CTYPE_TELESPCI:
+	case ISDN_CTYPE_FRITZPCI:
 		printk(KERN_WARNING "HiSax: Support for %s Card has moved "
 		       "to separate PCI driver module\n",
 		       CardType[card->typ]);
@@ -1336,7 +1321,6 @@ static int __init HiSax_init(void)
 		case ISDN_CTYPE_TELES3C:
 		case ISDN_CTYPE_ACERP10:
 		case ISDN_CTYPE_S0BOX:
-		case ISDN_CTYPE_FRITZPCI:
 		case ISDN_CTYPE_HSTSAPHIR:
 		case ISDN_CTYPE_GAZEL:
 		case ISDN_CTYPE_HFC_SX:
@@ -1360,6 +1344,7 @@ static int __init HiSax_init(void)
 		case ISDN_CTYPE_NETJET_S:
 		case ISDN_CTYPE_NETJET_U:
 		case ISDN_CTYPE_TELESPCI:
+		case ISDN_CTYPE_FRITZPCI:
 			break;
 
 		case ISDN_CTYPE_SCT_QUADRO:
@@ -1833,9 +1818,6 @@ static void EChannel_proc_rcv(struct his
 #include <linux/pci.h>
 
 static struct pci_device_id hisax_pci_tbl[] __devinitdata = {
-#ifdef CONFIG_HISAX_FRITZPCI
-	{PCI_VENDOR_ID_AVM,      PCI_DEVICE_ID_AVM_A1,           PCI_ANY_ID, PCI_ANY_ID},
-#endif
 #ifdef CONFIG_HISAX_DIEHLDIVA
 	{PCI_VENDOR_ID_EICON,    PCI_DEVICE_ID_EICON_DIVA20,     PCI_ANY_ID, PCI_ANY_ID},
 	{PCI_VENDOR_ID_EICON,    PCI_DEVICE_ID_EICON_DIVA20_U,   PCI_ANY_ID, PCI_ANY_ID},
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
