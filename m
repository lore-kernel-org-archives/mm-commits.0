From: akpm@osdl.org
Subject: - i4l-remove-the-broken-hisax_amd7930-option.patch removed from -mm tree
Date: Fri, 08 Dec 2006 12:10:53 -0800
Message-ID: <200612082010.kB8KArwV002859@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:59131 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946610AbWLHULr (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 15:11:47 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@stusta.de, kkeil@suse.de, mm-commits@vger.kernel.org


The patch titled
     i4l: remove the broken HISAX_AMD7930 option
has been removed from the -mm tree.  Its filename was
     i4l-remove-the-broken-hisax_amd7930-option.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: i4l: remove the broken HISAX_AMD7930 option
From: Adrian Bunk <bunk@stusta.de>

HISAX_AMD7930 was never anywhere near to being working, and this doesn't
seem to change in the forseeable future.

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Acked-by: Karsten Keil <kkeil@suse.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/isdn/hisax/Kconfig  |    7 -------
 drivers/isdn/hisax/config.c |   18 ------------------
 drivers/isdn/hisax/hisax.h  |    6 ------
 3 files changed, 31 deletions(-)

diff -puN drivers/isdn/hisax/Kconfig~i4l-remove-the-broken-hisax_amd7930-option drivers/isdn/hisax/Kconfig
--- a/drivers/isdn/hisax/Kconfig~i4l-remove-the-broken-hisax_amd7930-option
+++ a/drivers/isdn/hisax/Kconfig
@@ -349,13 +349,6 @@ config HISAX_ENTERNOW_PCI
 	  This enables HiSax support for the Formula-n enter:now PCI
 	  ISDN card.
 
-config HISAX_AMD7930
-	bool "Am7930 (EXPERIMENTAL)"
-	depends on EXPERIMENTAL && SPARC && BROKEN
-	help
-	  This enables HiSax support for the AMD7930 chips on some SPARCs.
-	  This code is not finished yet.
-
 endif
 
 if ISDN_DRV_HISAX
diff -puN drivers/isdn/hisax/config.c~i4l-remove-the-broken-hisax_amd7930-option drivers/isdn/hisax/config.c
--- a/drivers/isdn/hisax/config.c~i4l-remove-the-broken-hisax_amd7930-option
+++ a/drivers/isdn/hisax/config.c
@@ -227,14 +227,6 @@ const char *CardType[] = {
 #define DEFAULT_CFG {5,0x2E0,0,0}
 #endif
 
-
-#ifdef CONFIG_HISAX_AMD7930
-#undef DEFAULT_CARD
-#undef DEFAULT_CFG
-#define DEFAULT_CARD ISDN_CTYPE_AMD7930
-#define DEFAULT_CFG {12,0x3e0,0,0}
-#endif
-
 #ifdef CONFIG_HISAX_NICCY
 #undef DEFAULT_CARD
 #undef DEFAULT_CFG
@@ -545,10 +537,6 @@ extern int setup_hfcpci(struct IsdnCard 
 extern int setup_hfcsx(struct IsdnCard *card);
 #endif
 
-#if CARD_AMD7930
-extern int setup_amd7930(struct IsdnCard *card);
-#endif
-
 #if CARD_NICCY
 extern int setup_niccy(struct IsdnCard *card);
 #endif
@@ -1063,11 +1051,6 @@ static int checkcard(int cardnr, char *i
 		ret = setup_niccy(card);
 		break;
 #endif
-#if CARD_AMD7930
-	case ISDN_CTYPE_AMD7930:
-		ret = setup_amd7930(card);
-		break;
-#endif
 #if CARD_ISURF
 	case ISDN_CTYPE_ISURF:
 		ret = setup_isurf(card);
@@ -1436,7 +1419,6 @@ static int __init HiSax_init(void)
 			break;
 		case ISDN_CTYPE_ELSA_PCI:
 		case ISDN_CTYPE_NETJET_S:
-		case ISDN_CTYPE_AMD7930:
 		case ISDN_CTYPE_TELESPCI:
 		case ISDN_CTYPE_W6692:
 		case ISDN_CTYPE_NETJET_U:
diff -puN drivers/isdn/hisax/hisax.h~i4l-remove-the-broken-hisax_amd7930-option drivers/isdn/hisax/hisax.h
--- a/drivers/isdn/hisax/hisax.h~i4l-remove-the-broken-hisax_amd7930-option
+++ a/drivers/isdn/hisax/hisax.h
@@ -1139,12 +1139,6 @@ struct IsdnCardState {
 #define  CARD_HFC_SX 0
 #endif
 
-#ifdef  CONFIG_HISAX_AMD7930
-#define CARD_AMD7930 1
-#else
-#define CARD_AMD7930 0
-#endif
-
 #ifdef	CONFIG_HISAX_NICCY
 #define	CARD_NICCY 1
 #ifndef ISDN_CHIP_ISAC
_

Patches currently in -mm which might be from bunk@stusta.de are

origin.patch
i4l-remove-the-broken-hisax_amd7930-option.patch
make-drivers-md-dm-snapcksnapd-static.patch
make-drivers-acpi-eccec_ecdt-static.patch
drivers-acpi-oslc-fix-a-null-check.patch
git-alsa.patch
git-dvb.patch
fs-dlm-lowcomms-tcpc-remove-2-functions.patch
git-mtd.patch
remove-mtd-jffs2-userh.patch
git-net.patch
net-uninline-skb_put-fix.patch
dont-export-device-ids-to-userspace.patch
drivers-scsi-small-cleanups.patch
drivers-scsi-aic7xxx-aic79xx_corec-make-ahd_match_scb-static.patch
drivers-scsi-advansysc-cleanups.patch
megaraid-fix-warnings-when-config_proc_fs=n.patch
drivers-scsi-dpt_i2oc-remove-dead-code.patch
drivers-scsi-aic7xxx-make-functions-static.patch
make-qla2x00_reg_remote_port-static.patch
drivers-scsi-wd33c93c-cleanups.patch
usb_rtl8150-must-select-mii.patch
drivers-edac-make-code-static.patch
remove-drivers-pci-searchcpci_find_device_reverse.patch
make-ext2_get_blocks-static.patch
readahead-events-accounting-make-readahead_debug_level-static.patch
reiser4-export-remove_from_page_cache-fix.patch
fs-reiser4-possible-cleanups.patch
reiser4-possible-cleanups-2.patch
fs-reiser4-possible-cleanups-2.patch
fs-reiser4-more-possible-cleanups.patch
gtod-persistent-clock-support-core-remove-kernel-timercwall_jiffies.patch
gtod-persistent-clock-support-i386-i386-unexport-read_persistent_clock.patch
dynticks-extend-next_timer_interrupt-to-use-a-reference-jiffie-make-kernel-timerc__next_timer_interrupt-static.patch
updated-i386-convert-to-clock-event-devices-arch-i386-kernel-apicc-make-a-function-static.patch
updated-i386-convert-to-clock-event-devices-remove-arch-i386-kernel-time_hpetchpet_reenable.patch
slim-main-patch-security-slim-slm_mainc-make-2-functions-static.patch
slab-cache-shrinker-statistics.patch
debug-shared-irqs-kconfig-fix.patch
i386-enable-4k-stacks-by-default.patch
mutex-subsystem-synchro-test-module.patch

