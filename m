From: akpm@linux-foundation.org
Subject: + rtc-fix-build-warnings-in-defconfigs.patch added to -mm tree
Date: Thu, 09 Jun 2011 14:43:46 -0700
Message-ID: <201106092143.p59LhldE001719@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55139 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754886Ab1FIVok (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 Jun 2011 17:44:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: wanlong.gao@gmail.com, benh@kernel.crashing.org, gxt@mprc.pku.edu.cn, hans-christian.egtvedt@atmel.com, vapier@gentoo.org, w.sang@pengutronix.de


The patch titled
     rtc: fix build warnings in defconfigs
has been added to the -mm tree.  Its filename is
     rtc-fix-build-warnings-in-defconfigs.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: rtc: fix build warnings in defconfigs
From: Wanlong Gao <wanlong.gao@gmail.com>

RTC_CLASS is changed to bool, so 'm' is invalid.

Signed-off-by: Wanlong Gao <wanlong.gao@gmail.com>
Acked-by: Mike Frysinger <vapier@gentoo.org>
Acked-by: Wolfram Sang <w.sang@pengutronix.de>
Acked-by: Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>
Acked-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Guan Xuetao <gxt@mprc.pku.edu.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/configs/davinci_all_defconfig     |    2 +-
 arch/arm/configs/mxs_defconfig             |    2 +-
 arch/arm/configs/netx_defconfig            |    2 +-
 arch/arm/configs/viper_defconfig           |    2 +-
 arch/arm/configs/xcep_defconfig            |    2 +-
 arch/arm/configs/zeus_defconfig            |    2 +-
 arch/avr32/configs/atngw100_mrmt_defconfig |    2 +-
 arch/blackfin/configs/CM-BF548_defconfig   |    2 +-
 arch/mips/configs/mtx1_defconfig           |    2 +-
 arch/powerpc/configs/52xx/pcm030_defconfig |    2 +-
 arch/powerpc/configs/ps3_defconfig         |    2 +-
 arch/sh/configs/titan_defconfig            |    2 +-
 arch/unicore32/configs/debug_defconfig     |    2 +-
 13 files changed, 13 insertions(+), 13 deletions(-)

diff -puN arch/arm/configs/davinci_all_defconfig~rtc-fix-build-warnings-in-defconfigs arch/arm/configs/davinci_all_defconfig
--- a/arch/arm/configs/davinci_all_defconfig~rtc-fix-build-warnings-in-defconfigs
+++ a/arch/arm/configs/davinci_all_defconfig
@@ -157,7 +157,7 @@ CONFIG_LEDS_GPIO=m
 CONFIG_LEDS_TRIGGERS=y
 CONFIG_LEDS_TRIGGER_TIMER=m
 CONFIG_LEDS_TRIGGER_HEARTBEAT=m
-CONFIG_RTC_CLASS=m
+CONFIG_RTC_CLASS=y
 CONFIG_EXT2_FS=y
 CONFIG_EXT3_FS=y
 CONFIG_XFS_FS=m
diff -puN arch/arm/configs/mxs_defconfig~rtc-fix-build-warnings-in-defconfigs arch/arm/configs/mxs_defconfig
--- a/arch/arm/configs/mxs_defconfig~rtc-fix-build-warnings-in-defconfigs
+++ a/arch/arm/configs/mxs_defconfig
@@ -89,7 +89,7 @@ CONFIG_DISPLAY_SUPPORT=m
 # CONFIG_USB_SUPPORT is not set
 CONFIG_MMC=y
 CONFIG_MMC_MXS=y
-CONFIG_RTC_CLASS=m
+CONFIG_RTC_CLASS=y
 CONFIG_RTC_DRV_DS1307=m
 CONFIG_DMADEVICES=y
 CONFIG_MXS_DMA=y
diff -puN arch/arm/configs/netx_defconfig~rtc-fix-build-warnings-in-defconfigs arch/arm/configs/netx_defconfig
--- a/arch/arm/configs/netx_defconfig~rtc-fix-build-warnings-in-defconfigs
+++ a/arch/arm/configs/netx_defconfig
@@ -60,7 +60,7 @@ CONFIG_FB_ARMCLCD=y
 # CONFIG_VGA_CONSOLE is not set
 CONFIG_FRAMEBUFFER_CONSOLE=y
 CONFIG_LOGO=y
-CONFIG_RTC_CLASS=m
+CONFIG_RTC_CLASS=y
 CONFIG_INOTIFY=y
 CONFIG_TMPFS=y
 CONFIG_JFFS2_FS=y
diff -puN arch/arm/configs/viper_defconfig~rtc-fix-build-warnings-in-defconfigs arch/arm/configs/viper_defconfig
--- a/arch/arm/configs/viper_defconfig~rtc-fix-build-warnings-in-defconfigs
+++ a/arch/arm/configs/viper_defconfig
@@ -142,7 +142,7 @@ CONFIG_USB_GADGETFS=m
 CONFIG_USB_FILE_STORAGE=m
 CONFIG_USB_G_SERIAL=m
 CONFIG_USB_G_PRINTER=m
-CONFIG_RTC_CLASS=m
+CONFIG_RTC_CLASS=y
 CONFIG_RTC_DRV_DS1307=m
 CONFIG_RTC_DRV_SA1100=m
 CONFIG_EXT2_FS=m
diff -puN arch/arm/configs/xcep_defconfig~rtc-fix-build-warnings-in-defconfigs arch/arm/configs/xcep_defconfig
--- a/arch/arm/configs/xcep_defconfig~rtc-fix-build-warnings-in-defconfigs
+++ a/arch/arm/configs/xcep_defconfig
@@ -73,7 +73,7 @@ CONFIG_SENSORS_MAX6650=m
 # CONFIG_VGA_CONSOLE is not set
 # CONFIG_HID_SUPPORT is not set
 # CONFIG_USB_SUPPORT is not set
-CONFIG_RTC_CLASS=m
+CONFIG_RTC_CLASS=y
 CONFIG_RTC_DRV_SA1100=m
 CONFIG_DMADEVICES=y
 # CONFIG_DNOTIFY is not set
diff -puN arch/arm/configs/zeus_defconfig~rtc-fix-build-warnings-in-defconfigs arch/arm/configs/zeus_defconfig
--- a/arch/arm/configs/zeus_defconfig~rtc-fix-build-warnings-in-defconfigs
+++ a/arch/arm/configs/zeus_defconfig
@@ -158,7 +158,7 @@ CONFIG_LEDS_TRIGGER_HEARTBEAT=m
 CONFIG_LEDS_TRIGGER_BACKLIGHT=m
 CONFIG_LEDS_TRIGGER_GPIO=m
 CONFIG_LEDS_TRIGGER_DEFAULT_ON=m
-CONFIG_RTC_CLASS=m
+CONFIG_RTC_CLASS=y
 CONFIG_RTC_DRV_ISL1208=m
 CONFIG_RTC_DRV_PXA=m
 CONFIG_EXT2_FS=y
diff -puN arch/avr32/configs/atngw100_mrmt_defconfig~rtc-fix-build-warnings-in-defconfigs arch/avr32/configs/atngw100_mrmt_defconfig
--- a/arch/avr32/configs/atngw100_mrmt_defconfig~rtc-fix-build-warnings-in-defconfigs
+++ a/arch/avr32/configs/atngw100_mrmt_defconfig
@@ -109,7 +109,7 @@ CONFIG_LEDS_GPIO=y
 CONFIG_LEDS_TRIGGERS=y
 CONFIG_LEDS_TRIGGER_TIMER=y
 CONFIG_LEDS_TRIGGER_HEARTBEAT=y
-CONFIG_RTC_CLASS=m
+CONFIG_RTC_CLASS=y
 CONFIG_RTC_DRV_S35390A=m
 CONFIG_RTC_DRV_AT32AP700X=m
 CONFIG_DMADEVICES=y
diff -puN arch/blackfin/configs/CM-BF548_defconfig~rtc-fix-build-warnings-in-defconfigs arch/blackfin/configs/CM-BF548_defconfig
--- a/arch/blackfin/configs/CM-BF548_defconfig~rtc-fix-build-warnings-in-defconfigs
+++ a/arch/blackfin/configs/CM-BF548_defconfig
@@ -112,7 +112,7 @@ CONFIG_USB_G_SERIAL=m
 CONFIG_USB_G_PRINTER=m
 CONFIG_MMC=m
 CONFIG_SDH_BFIN=m
-CONFIG_RTC_CLASS=m
+CONFIG_RTC_CLASS=y
 CONFIG_RTC_DRV_BFIN=m
 CONFIG_EXT2_FS=m
 # CONFIG_DNOTIFY is not set
diff -puN arch/mips/configs/mtx1_defconfig~rtc-fix-build-warnings-in-defconfigs arch/mips/configs/mtx1_defconfig
--- a/arch/mips/configs/mtx1_defconfig~rtc-fix-build-warnings-in-defconfigs
+++ a/arch/mips/configs/mtx1_defconfig
@@ -678,7 +678,7 @@ CONFIG_LEDS_TRIGGERS=y
 CONFIG_LEDS_TRIGGER_TIMER=y
 CONFIG_LEDS_TRIGGER_HEARTBEAT=y
 CONFIG_LEDS_TRIGGER_DEFAULT_ON=y
-CONFIG_RTC_CLASS=m
+CONFIG_RTC_CLASS=y
 CONFIG_RTC_INTF_DEV_UIE_EMUL=y
 CONFIG_RTC_DRV_TEST=m
 CONFIG_RTC_DRV_DS1307=m
diff -puN arch/powerpc/configs/52xx/pcm030_defconfig~rtc-fix-build-warnings-in-defconfigs arch/powerpc/configs/52xx/pcm030_defconfig
--- a/arch/powerpc/configs/52xx/pcm030_defconfig~rtc-fix-build-warnings-in-defconfigs
+++ a/arch/powerpc/configs/52xx/pcm030_defconfig
@@ -85,7 +85,7 @@ CONFIG_USB_OHCI_HCD=m
 CONFIG_USB_OHCI_HCD_PPC_OF_BE=y
 # CONFIG_USB_OHCI_HCD_PCI is not set
 CONFIG_USB_STORAGE=m
-CONFIG_RTC_CLASS=m
+CONFIG_RTC_CLASS=y
 CONFIG_RTC_DRV_PCF8563=m
 CONFIG_EXT2_FS=m
 CONFIG_EXT3_FS=m
diff -puN arch/powerpc/configs/ps3_defconfig~rtc-fix-build-warnings-in-defconfigs arch/powerpc/configs/ps3_defconfig
--- a/arch/powerpc/configs/ps3_defconfig~rtc-fix-build-warnings-in-defconfigs
+++ a/arch/powerpc/configs/ps3_defconfig
@@ -141,7 +141,7 @@ CONFIG_USB_EHCI_TT_NEWSCHED=y
 # CONFIG_USB_EHCI_HCD_PPC_OF is not set
 CONFIG_USB_OHCI_HCD=m
 CONFIG_USB_STORAGE=m
-CONFIG_RTC_CLASS=m
+CONFIG_RTC_CLASS=y
 CONFIG_RTC_DRV_PS3=m
 CONFIG_EXT2_FS=m
 CONFIG_EXT3_FS=m
diff -puN arch/sh/configs/titan_defconfig~rtc-fix-build-warnings-in-defconfigs arch/sh/configs/titan_defconfig
--- a/arch/sh/configs/titan_defconfig~rtc-fix-build-warnings-in-defconfigs
+++ a/arch/sh/configs/titan_defconfig
@@ -227,7 +227,7 @@ CONFIG_USB_SERIAL=m
 CONFIG_USB_SERIAL_GENERIC=y
 CONFIG_USB_SERIAL_ARK3116=m
 CONFIG_USB_SERIAL_PL2303=m
-CONFIG_RTC_CLASS=m
+CONFIG_RTC_CLASS=y
 CONFIG_RTC_DRV_SH=m
 CONFIG_EXT2_FS=y
 CONFIG_EXT3_FS=y
diff -puN arch/unicore32/configs/debug_defconfig~rtc-fix-build-warnings-in-defconfigs arch/unicore32/configs/debug_defconfig
--- a/arch/unicore32/configs/debug_defconfig~rtc-fix-build-warnings-in-defconfigs
+++ a/arch/unicore32/configs/debug_defconfig
@@ -168,7 +168,7 @@ CONFIG_LEDS_TRIGGER_HEARTBEAT=y
 
 #	Real Time Clock
 CONFIG_RTC_LIB=m
-CONFIG_RTC_CLASS=m
+CONFIG_RTC_CLASS=y
 
 ### File systems
 CONFIG_EXT2_FS=m
_

Patches currently in -mm which might be from wanlong.gao@gmail.com are

rtc-fix-build-warnings-in-defconfigs.patch
fix-build-warning-of-the-defconfigs-fix.patch
linux-next.patch

