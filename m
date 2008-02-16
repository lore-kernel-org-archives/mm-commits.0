From: akpm@linux-foundation.org
Subject: - isdn-hisax-nj_s-nj_u-convert-to-pci-hotplug-api.patch removed from -mm tree
Date: Fri, 15 Feb 2008 17:00:30 -0800
Message-ID: <200802160109.m1G19WUB001649@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55755 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758163AbYBPBKG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 15 Feb 2008 20:10:06 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jeff@garzik.org, greg@kroah.com, kkeil@suse.de, mm-commits@vger.kernel.org


The patch titled
     isdn: HiSax nj_s, nj_u: convert to PCI hotplug API
has been removed from the -mm tree.  Its filename was
     isdn-hisax-nj_s-nj_u-convert-to-pci-hotplug-api.patch

This patch was dropped because it had testing failures

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: isdn: HiSax nj_s, nj_u: convert to PCI hotplug API
From: Jeff Garzik <jeff@garzik.org>

Signed-off-by: Jeff Garzik <jeff@garzik.org>
Cc: Greg KH <greg@kroah.com>
Cc: Karsten Keil <kkeil@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/isdn/hisax/Kconfig  |    8 +-
 drivers/isdn/hisax/Makefile |    6 +-
 drivers/isdn/hisax/config.c |   41 +------------
 drivers/isdn/hisax/nj_s.c   |  100 ++++++++++++++++++++++++----------
 drivers/isdn/hisax/nj_u.c   |   99 ++++++++++++++++++++++++---------
 5 files changed, 158 insertions(+), 96 deletions(-)

diff -puN drivers/isdn/hisax/Kconfig~isdn-hisax-nj_s-nj_u-convert-to-pci-hotplug-api drivers/isdn/hisax/Kconfig
--- a/drivers/isdn/hisax/Kconfig~isdn-hisax-nj_s-nj_u-convert-to-pci-hotplug-api
+++ a/drivers/isdn/hisax/Kconfig
@@ -236,8 +236,8 @@ config HISAX_MIC
 	  settings.
 
 config HISAX_NETJET
-	bool "NETjet card"
-	depends on PCI && PCI_LEGACY && (BROKEN || !(SPARC || PPC || PARISC || M68K || (MIPS && !CPU_LITTLE_ENDIAN) || FRV))
+	tristate "NETjet card"
+	depends on PCI && (BROKEN || !(SPARC || PPC || PARISC || M68K || (MIPS && !CPU_LITTLE_ENDIAN) || FRV))
 	help
 	  This enables HiSax support for the NetJet from Traverse
 	  Technologies.
@@ -247,8 +247,8 @@ config HISAX_NETJET
 	  settings.
 
 config HISAX_NETJET_U
-	bool "NETspider U card"
-	depends on PCI && PCI_LEGACY && (BROKEN || !(SPARC || PPC || PARISC || M68K || (MIPS && !CPU_LITTLE_ENDIAN) || FRV))
+	tristate "NETspider U card"
+	depends on PCI && (BROKEN || !(SPARC || PPC || PARISC || M68K || (MIPS && !CPU_LITTLE_ENDIAN) || FRV))
 	help
 	  This enables HiSax support for the Netspider U interface ISDN card
 	  from Traverse Technologies.
diff -puN drivers/isdn/hisax/Makefile~isdn-hisax-nj_s-nj_u-convert-to-pci-hotplug-api drivers/isdn/hisax/Makefile
--- a/drivers/isdn/hisax/Makefile~isdn-hisax-nj_s-nj_u-convert-to-pci-hotplug-api
+++ a/drivers/isdn/hisax/Makefile
@@ -19,9 +19,13 @@ obj-$(CONFIG_HISAX_BKM_A4T)		+= bkm_a4t_
 obj-$(CONFIG_HISAX_ENTERNOW_PCI)	+= enternow.o libhisax.o
 obj-$(CONFIG_HISAX_HFC_PCI)		+= hfc_pci.o libhisax.o
 obj-$(CONFIG_HISAX_W6692)		+= w6692.o libhisax.o
+obj-$(CONFIG_HISAX_NETJET)		+= netjet_s.o libhisax.o
+obj-$(CONFIG_HISAX_NETJET_U)		+= netjet_u.o libhisax.o
 
 bkm_a4t_pci-objs			:= bkm_a4t.o jade.o
 enternow-objs				:= enternow_pci.o amd7930_fn.o
+netjet_s-objs				:= nj_s.o
+netjet_u-objs				:= nj_u.o icc.o
 libhisax-objs				:= netjet.o isac.o arcofi.o hscx.o
 
 ifdef CONFIG_HISAX_HDLC
@@ -54,8 +58,6 @@ hisax-$(CONFIG_HISAX_TELEINT)		+= telein
 hisax-$(CONFIG_HISAX_SEDLBAUER)		+= sedlbauer.o isar.o
 hisax-$(CONFIG_HISAX_SPORTSTER)		+= sportster.o
 hisax-$(CONFIG_HISAX_MIC)		+= mic.o
-hisax-$(CONFIG_HISAX_NETJET)		+= nj_s.o
-hisax-$(CONFIG_HISAX_NETJET_U)		+= nj_u.o icc.o
 hisax-$(CONFIG_HISAX_HFCS)		+= hfcscard.o hfc_2bds0.o
 hisax-$(CONFIG_HISAX_HFC_SX)		+= hfc_sx.o
 hisax-$(CONFIG_HISAX_NICCY)		+= niccy.o
diff -puN drivers/isdn/hisax/config.c~isdn-hisax-nj_s-nj_u-convert-to-pci-hotplug-api drivers/isdn/hisax/config.c
--- a/drivers/isdn/hisax/config.c~isdn-hisax-nj_s-nj_u-convert-to-pci-hotplug-api
+++ a/drivers/isdn/hisax/config.c
@@ -201,13 +201,6 @@ const char *CardType[] = {
 #define DEFAULT_CFG {12,0x3e0,0,0}
 #endif
 
-#ifdef CONFIG_HISAX_NETJET
-#undef DEFAULT_CARD
-#undef DEFAULT_CFG
-#define DEFAULT_CARD ISDN_CTYPE_NETJET_S
-#define DEFAULT_CFG {0,0,0,0}
-#endif
-
 #ifdef CONFIG_HISAX_HFCS
 #undef DEFAULT_CARD
 #undef DEFAULT_CFG
@@ -257,13 +250,6 @@ const char *CardType[] = {
 #define DEFAULT_CFG {15,0x180,0,0}
 #endif
 
-#ifdef CONFIG_HISAX_NETJET_U
-#undef DEFAULT_CARD
-#undef DEFAULT_CFG
-#define DEFAULT_CARD ISDN_CTYPE_NETJET_U
-#define DEFAULT_CFG {0,0,0,0}
-#endif
-
 #ifndef DEFAULT_CARD
 #define DEFAULT_CARD 0
 #define DEFAULT_CFG {0,0,0,0}
@@ -482,10 +468,6 @@ extern int setup_sportster(struct IsdnCa
 extern int setup_mic(struct IsdnCard *card);
 #endif
 
-#if CARD_NETJET_S
-extern int setup_netjet_s(struct IsdnCard *card);
-#endif
-
 #if CARD_HFCS
 extern int setup_hfcs(struct IsdnCard *card);
 #endif
@@ -514,10 +496,6 @@ extern int setup_sct_quadro(struct IsdnC
 extern int setup_gazel(struct IsdnCard *card);
 #endif
 
-#if CARD_NETJET_U
-extern int setup_netjet_u(struct IsdnCard *card);
-#endif
-
 /*
  * Find card with given driverId
  */
@@ -881,11 +859,6 @@ static int __devinit hisax_cs_setup_card
 		ret = setup_mic(card);
 		break;
 #endif
-#if CARD_NETJET_S
-	case ISDN_CTYPE_NETJET_S:
-		ret = setup_netjet_s(card);
-		break;
-#endif
 #if CARD_HFCS
 	case ISDN_CTYPE_TELES3C:
 	case ISDN_CTYPE_ACERP10:
@@ -922,11 +895,6 @@ static int __devinit hisax_cs_setup_card
 		ret = setup_gazel(card);
 		break;
 #endif
-#if CARD_NETJET_U
-	case ISDN_CTYPE_NETJET_U:
-		ret = setup_netjet_u(card);
-		break;
-#endif
 	case ISDN_CTYPE_DYNAMIC:
 		ret = 2;
 		break;
@@ -935,6 +903,8 @@ static int __devinit hisax_cs_setup_card
 	case ISDN_CTYPE_ENTERNOW:
 	case ISDN_CTYPE_HFC_PCI:
 	case ISDN_CTYPE_W6692:
+	case ISDN_CTYPE_NETJET_S:
+	case ISDN_CTYPE_NETJET_U:
 		printk(KERN_WARNING "HiSax: Support for %s Card has moved "
 		       "to separate PCI driver module\n",
 		       CardType[card->typ]);
@@ -1395,9 +1365,7 @@ static int __init HiSax_init(void)
 			cards[j].para[2] = mem[i];
 			break;
 		case ISDN_CTYPE_ELSA_PCI:
-		case ISDN_CTYPE_NETJET_S:
 		case ISDN_CTYPE_TELESPCI:
-		case ISDN_CTYPE_NETJET_U:
 			break;
 
 		/* the following block are excluded from std HiSax init */
@@ -1405,6 +1373,8 @@ static int __init HiSax_init(void)
 		case ISDN_CTYPE_ENTERNOW:
 		case ISDN_CTYPE_HFC_PCI:
 		case ISDN_CTYPE_W6692:
+		case ISDN_CTYPE_NETJET_S:
+		case ISDN_CTYPE_NETJET_U:
 			break;
 
 		case ISDN_CTYPE_SCT_QUADRO:
@@ -1908,9 +1878,6 @@ static struct pci_device_id hisax_pci_tb
 #ifdef CONFIG_HISAX_SEDLBAUER
 	{PCI_VENDOR_ID_TIGERJET, PCI_DEVICE_ID_TIGERJET_100,     PCI_ANY_ID,PCI_ANY_ID},
 #endif
-#if defined(CONFIG_HISAX_NETJET) || defined(CONFIG_HISAX_NETJET_U)
-	{PCI_VENDOR_ID_TIGERJET, PCI_DEVICE_ID_TIGERJET_300,     PCI_ANY_ID,PCI_ANY_ID},
-#endif
 #if defined(CONFIG_HISAX_TELESPCI) || defined(CONFIG_HISAX_SCT_QUADRO)
 	{PCI_VENDOR_ID_ZORAN,    PCI_DEVICE_ID_ZORAN_36120,      PCI_ANY_ID,PCI_ANY_ID},
 #endif
diff -puN drivers/isdn/hisax/nj_s.c~isdn-hisax-nj_s-nj_u-convert-to-pci-hotplug-api drivers/isdn/hisax/nj_s.c
--- a/drivers/isdn/hisax/nj_s.c~isdn-hisax-nj_s-nj_u-convert-to-pci-hotplug-api
+++ a/drivers/isdn/hisax/nj_s.c
@@ -7,6 +7,7 @@
 
 #include <linux/init.h>
 #include "hisax.h"
+#include "hisax_proto.h"
 #include "isac.h"
 #include "isdnl1.h"
 #include <linux/pci.h>
@@ -14,6 +15,8 @@
 #include <linux/ppp_defs.h>
 #include "netjet.h"
 
+static int njs_protocol = 0;		/* 0 == use DEFAULT_PROTO */
+
 static const char *NETjet_S_revision = "$Revision: 2.13.2.4 $";
 
 static u_char dummyrr(struct IsdnCardState *cs, int chan, u_char off)
@@ -156,6 +159,8 @@ static int __devinit njs_pci_probe(struc
 	if (pci_enable_device(dev_netjet))
 		return(0);
 	pci_set_master(dev_netjet);
+
+	cs->hw.njet.dev = dev_netjet;
 	cs->irq = dev_netjet->irq;
 	if (!cs->irq) {
 		printk(KERN_WARNING "NETjet-S: No IRQ for PCI card found\n");
@@ -212,17 +217,17 @@ static int __devinit njs_cs_init(struct 
 	switch ( ( ( NETjet_ReadIC( cs, ISAC_RBCH ) >> 5 ) & 3 ) )
 	{
 		case 0 :
-			return 1;	/* end loop */
+			return 1;	/* found card */
 
 		case 3 :
 			printk( KERN_WARNING "NETjet-S: NETspider-U PCI card found\n" );
-			return -1;	/* continue looping */
+			return 0;	/* no NETjet-S found */
 
 		default :
 			printk( KERN_WARNING "NETjet-S: No PCI card found\n" );
-			return 0;	/* end loop & function */
+			return 0;	/* no NETjet-S found */
 	}
-	return 1;			/* end loop */
+	return 1;			/* found card */
 }
 
 static int __devinit njs_cs_init_rest(struct IsdnCard *card,
@@ -256,43 +261,84 @@ static int __devinit njs_cs_init_rest(st
 	return (1);
 }
 
-static struct pci_dev *dev_netjet __devinitdata = NULL;
-
-int __devinit
+static int __devinit
 setup_netjet_s(struct IsdnCard *card)
 {
 	int ret;
 	struct IsdnCardState *cs = card->cs;
 	char tmp[64];
+	struct pci_dev *dev_netjet = (void *) card->para[0];
 
 #ifdef __BIG_ENDIAN
 #error "not running on big endian machines now"
 #endif
 	strcpy(tmp, NETjet_S_revision);
 	printk(KERN_INFO "HiSax: Traverse Tech. NETjet-S driver Rev. %s\n", HiSax_getrev(tmp));
-	if (cs->typ != ISDN_CTYPE_NETJET_S)
-		return(0);
+
+	WARN_ON(cs->typ != ISDN_CTYPE_NETJET_S);
+
 	test_and_clear_bit(FLG_LOCK_ATOMIC, &cs->HW_Flags);
 
-	for ( ;; )
-	{
-		if ((dev_netjet = pci_find_device(PCI_VENDOR_ID_TIGERJET,
-			PCI_DEVICE_ID_TIGERJET_300,  dev_netjet))) {
-			ret = njs_pci_probe(dev_netjet, cs);
-			if (!ret)
-				return(0);
-		} else {
-			printk(KERN_WARNING "NETjet-S: No PCI card found\n");
-			return(0);
-		}
+	ret = njs_pci_probe(dev_netjet, cs);
+	if (!ret)
+		return(0);
 
-		ret = njs_cs_init(card, cs);
-		if (!ret)
-			return(0);
-		if (ret > 0)
-			break;
-		/* otherwise, ret < 0, continue looping */
-	}
+	ret = njs_cs_init(card, cs);
+	if (ret <= 0)
+		return(0);
 
 	return njs_cs_init_rest(card, cs);
 }
+
+static int __devinit njs_pci_init_one(struct pci_dev *pdev,
+				      const struct pci_device_id *ent)
+{
+	struct IsdnCard icard = { ISDN_CTYPE_NETJET_S, };
+	int cardnr;
+
+	icard.para[0] = (unsigned long) pdev;
+	if (!njs_protocol)
+		icard.protocol = DEFAULT_PROTO;
+	else
+		icard.protocol = njs_protocol;
+
+	cardnr = hisax_init_hotplug(&icard, setup_netjet_s);
+	if (cardnr < 0)
+		return -ENODEV;
+
+	pci_set_drvdata(pdev, (void *)(unsigned long) cardnr);
+	return 0;
+}
+
+static struct pci_device_id njs_pci_table[] = {
+	{ PCI_VDEVICE(TIGERJET, PCI_DEVICE_ID_TIGERJET_300) },
+
+	{ }		/* terminate list */
+};
+
+static struct pci_driver njs_pci_driver = {
+	.name		= "nj_s",
+	.id_table	= njs_pci_table,
+	.probe		= njs_pci_init_one,
+	.remove		= hisax_pci_remove_one,
+};
+
+static int __init njs_mod_init(void)
+{
+	return pci_register_driver(&njs_pci_driver);
+}
+
+static void __exit njs_mod_exit(void)
+{
+	pci_unregister_driver(&njs_pci_driver);
+}
+
+module_init(njs_mod_init);
+module_exit(njs_mod_exit);
+
+module_param_named(protocol, njs_protocol, int, 0444);
+MODULE_PARM_DESC(protocol, "Values 0 (default) through 4. See ISDN_PTYPE_xxx in linux/isdnif.h");
+
+MODULE_DEVICE_TABLE(pci, njs_pci_table);
+MODULE_DESCRIPTION("ISDN HiSax NETjet-S PCI driver");
+MODULE_LICENSE("GPL");
diff -puN drivers/isdn/hisax/nj_u.c~isdn-hisax-nj_s-nj_u-convert-to-pci-hotplug-api drivers/isdn/hisax/nj_u.c
--- a/drivers/isdn/hisax/nj_u.c~isdn-hisax-nj_s-nj_u-convert-to-pci-hotplug-api
+++ a/drivers/isdn/hisax/nj_u.c
@@ -7,6 +7,7 @@
 
 #include <linux/init.h>
 #include "hisax.h"
+#include "hisax_proto.h"
 #include "icc.h"
 #include "isdnl1.h"
 #include <linux/pci.h>
@@ -14,6 +15,8 @@
 #include <linux/ppp_defs.h>
 #include "netjet.h"
 
+static int nju_protocol;	/* 0 == use DEFAULT_PROTO */
+
 static const char *NETjet_U_revision = "$Revision: 2.14.2.3 $";
 
 static u_char dummyrr(struct IsdnCardState *cs, int chan, u_char off)
@@ -133,7 +136,10 @@ static int __devinit nju_pci_probe(struc
 {
 	if (pci_enable_device(dev_netjet))
 		return(0);
+
 	pci_set_master(dev_netjet);
+
+	cs->hw.njet.dev = dev_netjet;
 	cs->irq = dev_netjet->irq;
 	if (!cs->irq) {
 		printk(KERN_WARNING "NETspider-U: No IRQ for PCI card found\n");
@@ -174,17 +180,17 @@ static int __devinit nju_cs_init(struct 
 	switch ( ( ( NETjet_ReadIC( cs, ICC_RBCH ) >> 5 ) & 3 ) )
 	{
 		case 3 :
-			return 1;	/* end loop */
+			return 1;	/* found card */
 
 		case 0 :
 			printk( KERN_WARNING "NETspider-U: NETjet-S PCI card found\n" );
-			return -1;	/* continue looping */
+			return 0;	/* no NETjet-U found */
 
 		default :
 			printk( KERN_WARNING "NETspider-U: No PCI card found\n" );
-			return 0;	/* end loop & function */
+			return 0;	/* no NETjet-U found */
 	}
-	return 1;			/* end loop */
+	return 1;			/* found card */
 }
 
 static int __devinit nju_cs_init_rest(struct IsdnCard *card,
@@ -219,14 +225,14 @@ static int __devinit nju_cs_init_rest(st
 	return (1);
 }
 
-static struct pci_dev *dev_netjet __devinitdata = NULL;
 
-int __devinit
+static int __devinit
 setup_netjet_u(struct IsdnCard *card)
 {
 	int ret;
 	struct IsdnCardState *cs = card->cs;
 	char tmp[64];
+	struct pci_dev *dev_netjet = (void *) card->para[0];
 
 #ifdef __BIG_ENDIAN
 #error "not running on big endian machines now"
@@ -234,29 +240,70 @@ setup_netjet_u(struct IsdnCard *card)
 
 	strcpy(tmp, NETjet_U_revision);
 	printk(KERN_INFO "HiSax: Traverse Tech. NETspider-U driver Rev. %s\n", HiSax_getrev(tmp));
-	if (cs->typ != ISDN_CTYPE_NETJET_U)
-		return(0);
+
+	WARN_ON(cs->typ != ISDN_CTYPE_NETJET_U);
+
 	test_and_clear_bit(FLG_LOCK_ATOMIC, &cs->HW_Flags);
 
-	for ( ;; )
-	{
-		if ((dev_netjet = pci_find_device(PCI_VENDOR_ID_TIGERJET,
-			PCI_DEVICE_ID_TIGERJET_300,  dev_netjet))) {
-			ret = nju_pci_probe(dev_netjet, cs);
-			if (!ret)
-				return(0);
-		} else {
-			printk(KERN_WARNING "NETspider-U: No PCI card found\n");
-			return(0);
-		}
+	ret = nju_pci_probe(dev_netjet, cs);
+	if (!ret)
 
-		ret = nju_cs_init(card, cs);
-		if (!ret)
-			return (0);
-		if (ret > 0)
-			break;
-		/* ret < 0 == continue looping */
-	}
+	ret = nju_cs_init(card, cs);
+	if (!ret)
+		return (0);
 
 	return nju_cs_init_rest(card, cs);
 }
+
+static int __devinit nju_pci_init_one(struct pci_dev *pdev,
+				      const struct pci_device_id *ent)
+{
+	struct IsdnCard icard = { ISDN_CTYPE_NETJET_U, };
+	int cardnr;
+
+	icard.para[0] = (unsigned long) pdev;
+	if (!nju_protocol)
+		icard.protocol = DEFAULT_PROTO;
+	else
+		icard.protocol = nju_protocol;
+
+	cardnr = hisax_init_hotplug(&icard, setup_netjet_u);
+	if (cardnr < 0)
+		return -ENODEV;
+
+	pci_set_drvdata(pdev, (void *)(unsigned long) cardnr);
+	return 0;
+}
+
+static struct pci_device_id nju_pci_table[] = {
+	{ PCI_VDEVICE(TIGERJET, PCI_DEVICE_ID_TIGERJET_300) },
+
+	{ }		/* terminate list */
+};
+
+static struct pci_driver nju_pci_driver = {
+	.name		= "nj_u",
+	.id_table	= nju_pci_table,
+	.probe		= nju_pci_init_one,
+	.remove		= hisax_pci_remove_one,
+};
+
+static int __init nju_mod_init(void)
+{
+	return pci_register_driver(&nju_pci_driver);
+}
+
+static void __exit nju_mod_exit(void)
+{
+	pci_unregister_driver(&nju_pci_driver);
+}
+
+module_init(nju_mod_init);
+module_exit(nju_mod_exit);
+
+module_param_named(protocol, nju_protocol, int, 0444);
+MODULE_PARM_DESC(protocol, "Values 0 (default) through 4. See ISDN_PTYPE_xxx in linux/isdnif.h");
+
+MODULE_DEVICE_TABLE(pci, nju_pci_table);
+MODULE_DESCRIPTION("ISDN HiSax NETjet-U PCI driver");
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
isdn-hisax-nj_s-nj_u-convert-to-pci-hotplug-api.patch
isdn-hisax-telespci-convert-to-pci-hotplug-api.patch
isdn-hisax-avm_pci-convert-to-modern-pci-isa-pnp-probing.patch
isdn-hisax-gazel-convert-to-modern-isa-pci-probing.patch
isdn-hisax-niccy-convert-to-modern-isa-pnp-pci-probing.patch
isdn-hisax-diva-convert-to-modern-isa-pnp-pci-probing.patch
isdn-hisax-bkm_a8-convert-to-pci-hotplug-api.patch
