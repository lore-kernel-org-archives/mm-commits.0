From: akpm@linux-foundation.org
Subject: - isdn-hisax-enternow-convert-to-pci-hotplug-api.patch removed from -mm tree
Date: Fri, 15 Feb 2008 17:00:26 -0800
Message-ID: <200802160109.m1G19S3Q001639@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52122 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763747AbYBPBJl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 15 Feb 2008 20:09:41 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jeff@garzik.org, greg@kroah.com, kkeil@suse.de, mm-commits@vger.kernel.org


The patch titled
     isdn: HiSax enternow: convert to PCI hotplug API
has been removed from the -mm tree.  Its filename was
     isdn-hisax-enternow-convert-to-pci-hotplug-api.patch

This patch was dropped because it had testing failures

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: isdn: HiSax enternow: convert to PCI hotplug API
From: Jeff Garzik <jeff@garzik.org>

Signed-off-by: Jeff Garzik <jeff@garzik.org>
Cc: Greg KH <greg@kroah.com>
Cc: Karsten Keil <kkeil@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/isdn/hisax/Kconfig        |    4 -
 drivers/isdn/hisax/Makefile       |    3 
 drivers/isdn/hisax/config.c       |   11 ---
 drivers/isdn/hisax/enternow_pci.c |   93 +++++++++++++++++++---------
 4 files changed, 72 insertions(+), 39 deletions(-)

diff -puN drivers/isdn/hisax/Kconfig~isdn-hisax-enternow-convert-to-pci-hotplug-api drivers/isdn/hisax/Kconfig
--- a/drivers/isdn/hisax/Kconfig~isdn-hisax-enternow-convert-to-pci-hotplug-api
+++ a/drivers/isdn/hisax/Kconfig
@@ -340,8 +340,8 @@ config HISAX_HFC_SX
 	  cards. This code is not finished yet.
 
 config HISAX_ENTERNOW_PCI
-	bool "Formula-n enter:now PCI card"
-	depends on HISAX_NETJET && PCI && PCI_LEGACY && (BROKEN || !(SPARC || PPC || PARISC || M68K || (MIPS && !CPU_LITTLE_ENDIAN) || FRV))
+	tristate "Formula-n enter:now PCI card"
+	depends on HISAX_NETJET && PCI && (BROKEN || !(SPARC || PPC || PARISC || M68K || (MIPS && !CPU_LITTLE_ENDIAN) || FRV))
 	help
 	  This enables HiSax support for the Formula-n enter:now PCI
 	  ISDN card.
diff -puN drivers/isdn/hisax/Makefile~isdn-hisax-enternow-convert-to-pci-hotplug-api drivers/isdn/hisax/Makefile
--- a/drivers/isdn/hisax/Makefile~isdn-hisax-enternow-convert-to-pci-hotplug-api
+++ a/drivers/isdn/hisax/Makefile
@@ -16,8 +16,10 @@ obj-$(CONFIG_HISAX_HFCUSB)		+= hfc_usb.o
 obj-$(CONFIG_HISAX_HFC4S8S)		+= hfc4s8s_l1.o
 obj-$(CONFIG_HISAX_FRITZ_PCIPNP)        += hisax_isac.o hisax_fcpcipnp.o
 obj-$(CONFIG_HISAX_BKM_A4T)		+= bkm_a4t_pci.o libhisax.o
+obj-$(CONFIG_HISAX_ENTERNOW_PCI)	+= enternow.o libhisax.o
 
 bkm_a4t_pci-objs			:= bkm_a4t.o jade.o
+enternow-objs				:= enternow_pci.o amd7930_fn.o
 libhisax-objs				:= netjet.o isac.o arcofi.o hscx.o
 
 ifdef CONFIG_HISAX_HDLC
@@ -61,5 +63,4 @@ hisax-$(CONFIG_HISAX_HSTSAPHIR)		+= saph
 hisax-$(CONFIG_HISAX_SCT_QUADRO)	+= bkm_a8.o
 hisax-$(CONFIG_HISAX_GAZEL)		+= gazel.o
 hisax-$(CONFIG_HISAX_W6692)		+= w6692.o
-hisax-$(CONFIG_HISAX_ENTERNOW_PCI)	+= enternow_pci.o amd7930_fn.o
 
diff -puN drivers/isdn/hisax/config.c~isdn-hisax-enternow-convert-to-pci-hotplug-api drivers/isdn/hisax/config.c
--- a/drivers/isdn/hisax/config.c~isdn-hisax-enternow-convert-to-pci-hotplug-api
+++ a/drivers/isdn/hisax/config.c
@@ -540,10 +540,6 @@ extern int setup_w6692(struct IsdnCard *
 extern int setup_netjet_u(struct IsdnCard *card);
 #endif
 
-#if CARD_FN_ENTERNOW_PCI
-extern int setup_enternow_pci(struct IsdnCard *card);
-#endif
-
 /*
  * Find card with given driverId
  */
@@ -963,16 +959,12 @@ static int __devinit hisax_cs_setup_card
 		ret = setup_netjet_u(card);
 		break;
 #endif
-#if CARD_FN_ENTERNOW_PCI
-	case ISDN_CTYPE_ENTERNOW:
-		ret = setup_enternow_pci(card);
-		break;
-#endif
 	case ISDN_CTYPE_DYNAMIC:
 		ret = 2;
 		break;
 
 	case ISDN_CTYPE_BKM_A4T:
+	case ISDN_CTYPE_ENTERNOW:
 		printk(KERN_WARNING "HiSax: Support for %s Card has moved "
 		       "to separate PCI driver module\n",
 		       CardType[card->typ]);
@@ -1442,6 +1434,7 @@ static int __init HiSax_init(void)
 
 		/* the following block are excluded from std HiSax init */
 		case ISDN_CTYPE_BKM_A4T:
+		case ISDN_CTYPE_ENTERNOW:
 			break;
 
 		case ISDN_CTYPE_SCT_QUADRO:
diff -puN drivers/isdn/hisax/enternow_pci.c~isdn-hisax-enternow-convert-to-pci-hotplug-api drivers/isdn/hisax/enternow_pci.c
--- a/drivers/isdn/hisax/enternow_pci.c~isdn-hisax-enternow-convert-to-pci-hotplug-api
+++ a/drivers/isdn/hisax/enternow_pci.c
@@ -61,6 +61,7 @@
 
 
 #include "hisax.h"
+#include "hisax_proto.h"
 #include "isac.h"
 #include "isdnl1.h"
 #include "amd7930_fn.h"
@@ -70,7 +71,7 @@
 #include <linux/init.h>
 #include "netjet.h"
 
-
+static int en_protocol;		/* 0 == use DEFAULT_PROTO */
 
 static const char *enternow_pci_rev = "$Revision: 1.1.4.5 $";
 
@@ -305,6 +306,8 @@ static int __devinit en_pci_probe(struct
 {
 	if (pci_enable_device(dev_netjet))
 		return(0);
+
+	cs->hw.njet.dev = dev_netjet;
 	cs->irq = dev_netjet->irq;
 	if (!cs->irq) {
 		printk(KERN_WARNING "enter:now PCI: No IRQ for PCI card found\n");
@@ -315,13 +318,6 @@ static int __devinit en_pci_probe(struct
 		printk(KERN_WARNING "enter:now PCI: No IO-Adr for PCI card found\n");
 		return(0);
 	}
-	/* checks Sub-Vendor ID because system crashes with Traverse-Card */
-	if ((dev_netjet->subsystem_vendor != 0x55) ||
-	    (dev_netjet->subsystem_device != 0x02)) {
-		printk(KERN_WARNING "enter:now: You tried to load this driver with an incompatible TigerJet-card\n");
-		printk(KERN_WARNING "Use type=20 for Traverse NetJet PCI Card.\n");
-		return(0);
-	}
 
 	return(1);
 }
@@ -384,15 +380,14 @@ static int __devinit en_cs_init_rest(str
 	return (1);
 }
 
-static struct pci_dev *dev_netjet __devinitdata = NULL;
-
 /* called by config.c */
-int __devinit
+static int __devinit
 setup_enternow_pci(struct IsdnCard *card)
 {
 	int ret;
 	struct IsdnCardState *cs = card->cs;
 	char tmp[64];
+	struct pci_dev *dev_netjet = (void *) card->para[0];
 
 #ifdef __BIG_ENDIAN
 #error "not running on big endian machines now"
@@ -400,25 +395,69 @@ setup_enternow_pci(struct IsdnCard *card
 
         strcpy(tmp, enternow_pci_rev);
 	printk(KERN_INFO "HiSax: Formula-n Europe AG enter:now ISDN PCI driver Rev. %s\n", HiSax_getrev(tmp));
-	if (cs->typ != ISDN_CTYPE_ENTERNOW)
-		return(0);
+
+	WARN_ON(cs->typ != ISDN_CTYPE_ENTERNOW);
+
 	test_and_clear_bit(FLG_LOCK_ATOMIC, &cs->HW_Flags);
 
-	for ( ;; )
-	{
-		if ((dev_netjet = pci_find_device(PCI_VENDOR_ID_TIGERJET,
-			PCI_DEVICE_ID_TIGERJET_300,  dev_netjet))) {
-			ret = en_pci_probe(dev_netjet, cs);
-			if (!ret)
-				return(0);
-		} else {
-                        printk(KERN_WARNING "enter:now PCI: No PCI card found\n");
-			return(0);
-		}
+	ret = en_pci_probe(dev_netjet, cs);
+	if (!ret)
+		return(0);
 
-		en_cs_init(card, cs);
-		break;
-	}
+	en_cs_init(card, cs);
 
         return en_cs_init_rest(card, cs);
 }
+
+static int __devinit en_pci_init_one(struct pci_dev *pdev,
+				      const struct pci_device_id *ent)
+{
+	struct IsdnCard icard = { ISDN_CTYPE_ENTERNOW, };
+	int cardnr;
+
+	icard.para[0] = (unsigned long) pdev;
+	if (!en_protocol)
+		icard.protocol = DEFAULT_PROTO;
+	else
+		icard.protocol = en_protocol;
+
+	cardnr = hisax_init_hotplug(&icard, setup_enternow_pci);
+	if (cardnr < 0)
+		return -ENODEV;
+
+	pci_set_drvdata(pdev, (void *)(unsigned long) cardnr);
+	return 0;
+}
+
+static struct pci_device_id en_pci_table[] = {
+	{ PCI_VENDOR_ID_TIGERJET, PCI_DEVICE_ID_TIGERJET_300, 0x55, 0x02, },
+
+	{ }		/* terminate list */
+};
+
+static struct pci_driver en_pci_driver = {
+	.name		= "enternow_pci",
+	.id_table	= en_pci_table,
+	.probe		= en_pci_init_one,
+	.remove		= hisax_pci_remove_one,
+};
+
+static int __init en_mod_init(void)
+{
+	return pci_register_driver(&en_pci_driver);
+}
+
+static void __exit en_mod_exit(void)
+{
+	pci_unregister_driver(&en_pci_driver);
+}
+
+module_init(en_mod_init);
+module_exit(en_mod_exit);
+
+module_param_named(protocol, en_protocol, int, 0444);
+MODULE_PARM_DESC(protocol, "Values 0 (default) through 4. See ISDN_PTYPE_xxx in linux/isdnif.h");
+
+MODULE_DEVICE_TABLE(pci, en_pci_table);
+MODULE_DESCRIPTION("ISDN HiSax enter:now PCI driver");
+MODULE_LICENSE("GPL");
_

Patches currently in -mm which might be from jeff@garzik.org are

git-libata-all.patch
3c509-convert-to-isa_driver-and-pnp_driver-v4.patch
3c509-convert-to-isa_driver-and-pnp_driver-v4-cleanup.patch
usb-net-asix-does-not-really-need-10-100mbit.patch
forcedeth-power-down-phy-when-interface-is-down.patch
forcedeth-fix-mac-address-detection-on-network-card-regression-in-2623.patch
8390-split-8390-support-into-a-pausing-and-a-non-pausing-driver-core.patch
e1000e-make-e1000e-default-to-the-same-kconfig-setting-as-e1000.patch
update-smc91x-driver-with-arm-versatile-board-info.patch
libsas-convert-ata-bridge-to-use-new-eh.patch
isdn-hisax-enternow-convert-to-pci-hotplug-api.patch
isdn-hisax-hfc_pci-w6692-convert-to-pci-hotplug-api.patch
isdn-hisax-nj_s-nj_u-convert-to-pci-hotplug-api.patch
isdn-hisax-telespci-convert-to-pci-hotplug-api.patch
isdn-hisax-avm_pci-convert-to-modern-pci-isa-pnp-probing.patch
isdn-hisax-gazel-convert-to-modern-isa-pci-probing.patch
isdn-hisax-niccy-convert-to-modern-isa-pnp-pci-probing.patch
isdn-hisax-diva-convert-to-modern-isa-pnp-pci-probing.patch
isdn-hisax-bkm_a8-convert-to-pci-hotplug-api.patch
