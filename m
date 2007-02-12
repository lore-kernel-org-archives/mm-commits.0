From: akpm@linux-foundation.org
Subject: - isdn-remove-defunct-test-emulator.patch removed from -mm tree
Date: Mon, 12 Feb 2007 14:46:17 -0800
Message-ID: <200702122246.l1CMkHlg013796@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:45225 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030328AbXBLWqW (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 12 Feb 2007 17:46:22 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rpjday@mindspring.com, kkeil@suse.de, mm-commits@vger.kernel.org


The patch titled
     ISDN: Remove defunct test emulator
has been removed from the -mm tree.  Its filename was
     isdn-remove-defunct-test-emulator.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: ISDN: Remove defunct test emulator
From: "Robert P. J. Day" <rpjday@mindspring.com>

Based on advice from K.  Keil, get rid of remaining traces of defunct test
emulator for HISAX.

Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>
Acked-by: Karsten Keil <kkeil@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/isdn/hisax/Kconfig  |    2 --
 drivers/isdn/hisax/Makefile |    1 -
 drivers/isdn/hisax/config.c |    9 ---------
 drivers/isdn/hisax/hisax.h  |   25 -------------------------
 4 files changed, 37 deletions(-)

diff -puN drivers/isdn/hisax/Kconfig~isdn-remove-defunct-test-emulator drivers/isdn/hisax/Kconfig
--- a/drivers/isdn/hisax/Kconfig~isdn-remove-defunct-test-emulator
+++ a/drivers/isdn/hisax/Kconfig
@@ -340,8 +340,6 @@ config HISAX_HFC_SX
 	  This enables HiSax support for the HFC-S+, HFC-SP and HFC-PCMCIA
 	  cards. This code is not finished yet.
 
-#      bool '  TESTEMULATOR (EXPERIMENTAL)' CONFIG_HISAX_TESTEMU
-
 config HISAX_ENTERNOW_PCI
 	bool "Formula-n enter:now PCI card"
 	depends on HISAX_NETJET && PCI && (BROKEN || !(SPARC || PPC || PARISC || M68K || (MIPS && !CPU_LITTLE_ENDIAN) || FRV))
diff -puN drivers/isdn/hisax/Makefile~isdn-remove-defunct-test-emulator drivers/isdn/hisax/Makefile
--- a/drivers/isdn/hisax/Makefile~isdn-remove-defunct-test-emulator
+++ a/drivers/isdn/hisax/Makefile
@@ -60,5 +60,4 @@ hisax-$(CONFIG_HISAX_SCT_QUADRO)	+= bkm_
 hisax-$(CONFIG_HISAX_GAZEL)		+= gazel.o isac.o arcofi.o hscx.o
 hisax-$(CONFIG_HISAX_W6692)		+= w6692.o
 hisax-$(CONFIG_HISAX_ENTERNOW_PCI)	+= enternow_pci.o amd7930_fn.o
-#hisax-$(CONFIG_HISAX_TESTEMU)		+= testemu.o
 
diff -puN drivers/isdn/hisax/config.c~isdn-remove-defunct-test-emulator drivers/isdn/hisax/config.c
--- a/drivers/isdn/hisax/config.c~isdn-remove-defunct-test-emulator
+++ a/drivers/isdn/hisax/config.c
@@ -549,10 +549,6 @@ extern int setup_isurf(struct IsdnCard *
 extern int setup_saphir(struct IsdnCard *card);
 #endif
 
-#if CARD_TESTEMU
-extern int setup_testemu(struct IsdnCard *card);
-#endif
-
 #if CARD_BKM_A4T
 extern int setup_bkm_a4t(struct IsdnCard *card);
 #endif
@@ -1061,11 +1057,6 @@ static int checkcard(int cardnr, char *i
 		ret = setup_saphir(card);
 		break;
 #endif
-#if CARD_TESTEMU
-	case ISDN_CTYPE_TESTEMU:
-		ret = setup_testemu(card);
-		break;
-#endif
 #if	CARD_BKM_A4T
 	case ISDN_CTYPE_BKM_A4T:
 		ret = setup_bkm_a4t(card);
diff -puN drivers/isdn/hisax/hisax.h~isdn-remove-defunct-test-emulator drivers/isdn/hisax/hisax.h
--- a/drivers/isdn/hisax/hisax.h~isdn-remove-defunct-test-emulator
+++ a/drivers/isdn/hisax/hisax.h
@@ -795,19 +795,6 @@ struct w6692_hw {
 	struct timer_list timer;
 };
 
-#ifdef  CONFIG_HISAX_TESTEMU
-struct te_hw {
-	unsigned char *sfifo;
-	unsigned char *sfifo_w;
-	unsigned char *sfifo_r;
-	unsigned char *sfifo_e;
-	int sfifo_cnt;
-	unsigned int stat;
-	wait_queue_head_t rwaitq;
-	wait_queue_head_t swaitq;
-};
-#endif
-
 struct arcofi_msg {
 	struct arcofi_msg *next;
 	u_char receive;
@@ -916,9 +903,6 @@ struct IsdnCardState {
 		struct ix1_hw niccy;
 		struct isurf_hw isurf;
 		struct saphir_hw saphir;
-#ifdef CONFIG_HISAX_TESTEMU
-		struct te_hw te;
-#endif
 		struct bkm_hw ax;
 		struct gazel_hw gazel;
 		struct w6692_hw w6692;
@@ -1175,15 +1159,6 @@ struct IsdnCardState {
 #define CARD_HSTSAPHIR 0
 #endif
 
-#ifdef	CONFIG_HISAX_TESTEMU
-#define	CARD_TESTEMU 1
-#define ISDN_CTYPE_TESTEMU 99
-#undef ISDN_CTYPE_COUNT
-#define  ISDN_CTYPE_COUNT ISDN_CTYPE_TESTEMU
-#else
-#define CARD_TESTEMU 0
-#endif
-
 #ifdef	CONFIG_HISAX_BKM_A4T
 #define	CARD_BKM_A4T 1
 #ifndef ISDN_CHIP_ISAC
_

Patches currently in -mm which might be from rpjday@mindspring.com are

origin.patch
git-avr32.patch
git-dvb.patch
kbuild-remove-references-to-deprecated-prepare-all-target.patch
git-mips.patch
git-netdev-all.patch
remove-useless-find_first_bit-macro-from-cardbusc.patch
remove-some-unused-scsi-related-kernel-config-variables.patch
scsi-fix-obvious-typo-spin_lock_irqrestore-in-gdthc.patch
fix-misspelled-usbnet_mii-kernel-config-option.patch
fix-apparent-typo-config_usb_cdcether.patch
oss-replace-kmallocmemset-combos-with-kzalloc.patch
