From: akpm@osdl.org
Subject: + isdn-remove-defunct-test-emulator.patch added to -mm tree
Date: Sun, 28 Jan 2007 15:58:09 -0800
Message-ID: <200701282358.l0SNw9Ul006457@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:42607 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932991AbXA1X6P (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 28 Jan 2007 18:58:15 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rpjday@mindspring.com, kkeil@suse.de


The patch titled
     ISDN: Remove defunct test emulator
has been added to the -mm tree.  Its filename is
     isdn-remove-defunct-test-emulator.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: ISDN: Remove defunct test emulator
From: "Robert P. J. Day" <rpjday@mindspring.com>

Based on advice from K.  Keil, get rid of remaining traces of defunct test
emulator for HISAX.

Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>
Cc: Karsten Keil <kkeil@suse.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
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
fix-config_x86_64_-typo-in-drivers-kvm-svmc.patch
acpi-correct-apparent-typo-config_acpi_debug_output.patch
git-alsa.patch
remove-useless-reference-to-obsolete-kerneld.patch
ppc-use-syslog-macro-for-the-printk-log-level.patch
fix-apparent-typo-config_serial_cpm_smc.patch
remove-the-unused-kernel-config-option-video_videobuf.patch
change-incorrect-config_input_atixl-to-config_mouse_atixl.patch
remove-unused-kernel-config-option-dlci_count.patch
remove-useless-find_first_bit-macro-from-cardbusc.patch
remove-some-unused-scsi-related-kernel-config-variables.patch
fix-misspelled-usbnet_mii-kernel-config-option.patch
fix-apparent-typo-config_usb_cdcether.patch
remove-unused-kernel-config-option-x86_xadd.patch
uml-fix-apparent-config_64_bit-typo.patch
rewrite-unnecessary-duplicated-code-to-use-field_sizeof.patch
transform-kmem_cache_allocmemset0-kmem_cache_zalloc.patch
get-rid-of-double-zeroing-of-allocated-pages.patch
remove-unnecessary-memset0-calls-after-kzalloc-calls.patch
discuss-a-couple-common-errors-in-kernel-doc-usage.patch
numerous-fixes-to-kernel-doc-info-in-source-files.patch
remove-a-couple-final-references-to-obsolete-verify_area.patch
remove-the-last-reference-to-rwlock_is_locked-macro.patch
extend-the-set-of-__attribute__-shortcut-macros.patch
remove-final-reference-to-superfluous-smp_commence.patch
replace-regular-code-with-appropriate-calls-to-container_of.patch
remove-dead-kernel-config-option-aedsp16_mpu401.patch
remove-references-to-obsolete-kernel-config-option-debug_rwsems.patch
remove-unused-kernel-config-option-zisofs_fs.patch
remove-unused-kernel-config-option-lcd_device.patch
remove-unused-kernel-config-option-paride_parport.patch
fix-apparent-typo-config_lockdep_debug.patch
isdn-fix-typo-config_hisax_quadro-config_hisax_sct_quadro.patch
isdn-rename-some-debugging-macros-to-not-resemble-config.patch
isdn-rename-debug-option-config_serial_nopause_io.patch
isdn-remove-defunct-test-emulator.patch
isdn-rename-special-macro-config_hisax_hfc4s8s_pcimem.patch
correct-apparent-typo-config_aty_ct-in-aty-video.patch
oss-replace-kmallocmemset-combos-with-kzalloc.patch
