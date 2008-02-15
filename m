From: akpm@linux-foundation.org
Subject: + isdn-hisax-telespci-convert-to-pci-hotplug-api.patch added to -mm tree
Date: Thu, 14 Feb 2008 23:07:29 -0800
Message-ID: <200802150707.m1F77T03025216@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45424 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760687AbYBOHIa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 15 Feb 2008 02:08:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jeff@garzik.org, greg@kroah.com, kkeil@suse.de


The patch titled
     isdn: HiSax telespci: convert to PCI hotplug API
has been added to the -mm tree.  Its filename is
     isdn-hisax-telespci-convert-to-pci-hotplug-api.patch

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
Subject: isdn: HiSax telespci: convert to PCI hotplug API
From: Jeff Garzik <jeff@garzik.org>

Signed-off-by: Jeff Garzik <jeff@garzik.org>
Cc: Greg KH <greg@kroah.com>
Cc: Karsten Keil <kkeil@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/isdn/hisax/Kconfig    |    4 -
 drivers/isdn/hisax/Makefile   |    2 
 drivers/isdn/hisax/config.c   |   21 +------
 drivers/isdn/hisax/telespci.c |   95 +++++++++++++++++++++++++-------
 4 files changed, 81 insertions(+), 41 deletions(-)

diff -puN drivers/isdn/hisax/Kconfig~isdn-hisax-telespci-convert-to-pci-hotplug-api drivers/isdn/hisax/Kconfig
--- a/drivers/isdn/hisax/Kconfig~isdn-hisax-telespci-convert-to-pci-hotplug-api
+++ a/drivers/isdn/hisax/Kconfig
@@ -108,8 +108,8 @@ config HISAX_16_3
 	  non-standard IRQ/port settings.
 
 config HISAX_TELESPCI
-	bool "Teles PCI"
-	depends on PCI && PCI_LEGACY && (BROKEN || !(SPARC || PPC || PARISC || M68K || (MIPS && !CPU_LITTLE_ENDIAN) || FRV))
+	tristate "Teles PCI"
+	depends on PCI && (BROKEN || !(SPARC || PPC || PARISC || M68K || (MIPS && !CPU_LITTLE_ENDIAN) || FRV))
 	help
 	  This enables HiSax support for the Teles PCI.
 	  See <file:Documentation/isdn/README.HiSax> on how to configure it.
diff -puN drivers/isdn/hisax/Makefile~isdn-hisax-telespci-convert-to-pci-hotplug-api drivers/isdn/hisax/Makefile
--- a/drivers/isdn/hisax/Makefile~isdn-hisax-telespci-convert-to-pci-hotplug-api
+++ a/drivers/isdn/hisax/Makefile
@@ -21,6 +21,7 @@ obj-$(CONFIG_HISAX_HFC_PCI)		+= hfc_pci.
 obj-$(CONFIG_HISAX_W6692)		+= w6692.o libhisax.o
 obj-$(CONFIG_HISAX_NETJET)		+= netjet_s.o libhisax.o
 obj-$(CONFIG_HISAX_NETJET_U)		+= netjet_u.o libhisax.o
+obj-$(CONFIG_HISAX_TELESPCI)		+= telespci.o libhisax.o
 
 bkm_a4t_pci-objs			:= bkm_a4t.o jade.o
 enternow-objs				:= enternow_pci.o amd7930_fn.o
@@ -45,7 +46,6 @@ hisax-$(CONFIG_HISAX_1TR6)		+= l3_1tr6.o
 
 hisax-$(CONFIG_HISAX_16_0)		+= teles0.o
 hisax-$(CONFIG_HISAX_16_3)		+= teles3.o
-hisax-$(CONFIG_HISAX_TELESPCI)		+= telespci.o
 hisax-$(CONFIG_HISAX_S0BOX)		+= s0box.o
 hisax-$(CONFIG_HISAX_AVM_A1)		+= avm_a1.o
 hisax-$(CONFIG_HISAX_AVM_A1_PCMCIA)	+= avm_a1p.o
diff -puN drivers/isdn/hisax/config.c~isdn-hisax-telespci-convert-to-pci-hotplug-api drivers/isdn/hisax/config.c
--- a/drivers/isdn/hisax/config.c~isdn-hisax-telespci-convert-to-pci-hotplug-api
+++ a/drivers/isdn/hisax/config.c
@@ -145,13 +145,6 @@ const char *CardType[] = {
 #define DEFAULT_CFG {15,0xd0000,0xd80,0}
 #endif
 
-#ifdef CONFIG_HISAX_TELESPCI
-#undef DEFAULT_CARD
-#undef DEFAULT_CFG
-#define DEFAULT_CARD ISDN_CTYPE_TELESPCI
-#define DEFAULT_CFG {0,0,0,0}
-#endif
-
 #ifdef CONFIG_HISAX_IX1MICROR2
 #undef DEFAULT_CARD
 #undef DEFAULT_CFG
@@ -420,10 +413,6 @@ extern int setup_teles3(struct IsdnCard 
 extern int setup_s0box(struct IsdnCard *card);
 #endif
 
-#if CARD_TELESPCI
-extern int setup_telespci(struct IsdnCard *card);
-#endif
-
 #if CARD_AVM_A1
 extern int setup_avm_a1(struct IsdnCard *card);
 #endif
@@ -794,11 +783,6 @@ static int __devinit hisax_cs_setup_card
 		ret = setup_s0box(card);
 		break;
 #endif
-#if CARD_TELESPCI
-	case ISDN_CTYPE_TELESPCI:
-		ret = setup_telespci(card);
-		break;
-#endif
 #if CARD_AVM_A1
 	case ISDN_CTYPE_A1:
 		ret = setup_avm_a1(card);
@@ -905,6 +889,7 @@ static int __devinit hisax_cs_setup_card
 	case ISDN_CTYPE_W6692:
 	case ISDN_CTYPE_NETJET_S:
 	case ISDN_CTYPE_NETJET_U:
+	case ISDN_CTYPE_TELESPCI:
 		printk(KERN_WARNING "HiSax: Support for %s Card has moved "
 		       "to separate PCI driver module\n",
 		       CardType[card->typ]);
@@ -1365,7 +1350,6 @@ static int __init HiSax_init(void)
 			cards[j].para[2] = mem[i];
 			break;
 		case ISDN_CTYPE_ELSA_PCI:
-		case ISDN_CTYPE_TELESPCI:
 			break;
 
 		/* the following block are excluded from std HiSax init */
@@ -1375,6 +1359,7 @@ static int __init HiSax_init(void)
 		case ISDN_CTYPE_W6692:
 		case ISDN_CTYPE_NETJET_S:
 		case ISDN_CTYPE_NETJET_U:
+		case ISDN_CTYPE_TELESPCI:
 			break;
 
 		case ISDN_CTYPE_SCT_QUADRO:
@@ -1878,7 +1863,7 @@ static struct pci_device_id hisax_pci_tb
 #ifdef CONFIG_HISAX_SEDLBAUER
 	{PCI_VENDOR_ID_TIGERJET, PCI_DEVICE_ID_TIGERJET_100,     PCI_ANY_ID,PCI_ANY_ID},
 #endif
-#if defined(CONFIG_HISAX_TELESPCI) || defined(CONFIG_HISAX_SCT_QUADRO)
+#if defined(CONFIG_HISAX_SCT_QUADRO)
 	{PCI_VENDOR_ID_ZORAN,    PCI_DEVICE_ID_ZORAN_36120,      PCI_ANY_ID,PCI_ANY_ID},
 #endif
 	{ }				/* Terminating entry */
diff -puN drivers/isdn/hisax/telespci.c~isdn-hisax-telespci-convert-to-pci-hotplug-api drivers/isdn/hisax/telespci.c
--- a/drivers/isdn/hisax/telespci.c~isdn-hisax-telespci-convert-to-pci-hotplug-api
+++ a/drivers/isdn/hisax/telespci.c
@@ -14,11 +14,14 @@
 
 #include <linux/init.h>
 #include "hisax.h"
+#include "hisax_proto.h"
 #include "isac.h"
 #include "hscx.h"
 #include "isdnl1.h"
 #include <linux/pci.h>
 
+static int teles_protocol;		/* 0 == use DEFAULT_PROTO */
+
 static const char *telespci_revision = "$Revision: 2.23.2.3 $";
 
 #define ZORAN_PO_RQ_PEN	0x02000000
@@ -283,12 +286,11 @@ TelesPCI_card_msg(struct IsdnCardState *
 	return(0);
 }
 
-static struct pci_dev *dev_tel __devinitdata = NULL;
-
-int __devinit
+static int __devinit
 setup_telespci(struct IsdnCard *card)
 {
 	struct IsdnCardState *cs = card->cs;
+	struct pci_dev *dev_tel = (void *) card->para[0];
 	char tmp[64];
 
 #ifdef __BIG_ENDIAN
@@ -297,26 +299,24 @@ setup_telespci(struct IsdnCard *card)
 
 	strcpy(tmp, telespci_revision);
 	printk(KERN_INFO "HiSax: Teles/PCI driver Rev. %s\n", HiSax_getrev(tmp));
-	if (cs->typ != ISDN_CTYPE_TELESPCI)
-		return (0);
+	WARN_ON(cs->typ != ISDN_CTYPE_TELESPCI);
 
-	if ((dev_tel = pci_find_device (PCI_VENDOR_ID_ZORAN, PCI_DEVICE_ID_ZORAN_36120, dev_tel))) {
-		if (pci_enable_device(dev_tel))
-			return(0);
-		cs->irq = dev_tel->irq;
-		if (!cs->irq) {
-			printk(KERN_WARNING "Teles: No IRQ for PCI card found\n");
-			return(0);
-		}
-		cs->hw.teles0.membase = ioremap(pci_resource_start(dev_tel, 0),
-			PAGE_SIZE);
-		printk(KERN_INFO "Found: Zoran, base-address: 0x%llx, irq: 0x%x\n",
-			(unsigned long long)pci_resource_start(dev_tel, 0),
-			dev_tel->irq);
-	} else {
-		printk(KERN_WARNING "TelesPCI: No PCI card found\n");
+	if (pci_enable_device(dev_tel))
+		return(0);
+	cs->irq = dev_tel->irq;
+	if (!cs->irq) {
+		printk(KERN_WARNING "Teles: No IRQ for PCI card found\n");
 		return(0);
 	}
+	cs->hw.teles0.membase = ioremap(pci_resource_start(dev_tel, 0),
+		PAGE_SIZE);
+	if (!cs->hw.teles0.membase) {
+		printk(KERN_WARNING "Teles: ioremap failed\n");
+		return(0);
+	}
+	printk(KERN_INFO "Found: Zoran, base-address: 0x%llx, irq: 0x%x\n",
+		(unsigned long long)pci_resource_start(dev_tel, 0),
+		dev_tel->irq);
 
 	/* Initialize Zoran PCI controller */
 	writel(0x00000000, cs->hw.teles0.membase + 0x28);
@@ -352,3 +352,58 @@ setup_telespci(struct IsdnCard *card)
 	}
 	return (1);
 }
+
+static int __devinit teles_pci_init_one(struct pci_dev *pdev,
+				      const struct pci_device_id *ent)
+{
+	struct IsdnCard icard = { ISDN_CTYPE_TELESPCI, };
+	int cardnr;
+
+	icard.para[0] = (unsigned long) pdev;
+	icard.para[1] = ent->driver_data;
+	if (!teles_protocol)
+		icard.protocol = DEFAULT_PROTO;
+	else
+		icard.protocol = teles_protocol;
+
+	cardnr = hisax_init_hotplug(&icard, setup_telespci);
+	if (cardnr < 0)
+		return -ENODEV;
+
+	pci_set_drvdata(pdev, (void *)(unsigned long) cardnr);
+	return 0;
+}
+
+static struct pci_device_id teles_pci_table[] = {
+	{ PCI_VENDOR_ID_ZORAN, PCI_DEVICE_ID_ZORAN_36120,
+	  PCI_ANY_ID, PCI_ANY_ID, },
+
+	{ }		/* terminate list */
+};
+
+static struct pci_driver teles_pci_driver = {
+	.name		= "telespci",
+	.id_table	= teles_pci_table,
+	.probe		= teles_pci_init_one,
+	.remove		= hisax_pci_remove_one,
+};
+
+static int __init teles_mod_init(void)
+{
+	return pci_register_driver(&teles_pci_driver);
+}
+
+static void __exit teles_mod_exit(void)
+{
+	pci_unregister_driver(&teles_pci_driver);
+}
+
+module_init(teles_mod_init);
+module_exit(teles_mod_exit);
+
+module_param_named(protocol, teles_protocol, int, 0444);
+MODULE_PARM_DESC(protocol, "Values 0 (default) through 4. See ISDN_PTYPE_xxx in linux/isdnif.h");
+
+MODULE_DEVICE_TABLE(pci, teles_pci_table);
+MODULE_DESCRIPTION("ISDN HiSax Teles PCI driver");
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
