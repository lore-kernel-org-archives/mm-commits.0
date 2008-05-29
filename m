From: akpm@linux-foundation.org
Subject: + add-have_clk-to-kconfig-for-driver-dependencies.patch added to -mm tree
Date: Thu, 29 May 2008 12:59:38 -0700
Message-ID: <200805291959.m4TJxcNS019449@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55045 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751349AbYE2UAl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 29 May 2008 16:00:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dbrownell@users.sourceforge.net, benh@kernel.crashing.org, hskinnemoen@atmel.com, lethal@linux-sh.org, paulus@samba.org, rmk@arm.linux.org.uk


The patch titled
     add HAVE_CLK to Kconfig, for driver dependencies
has been added to the -mm tree.  Its filename is
     add-have_clk-to-kconfig-for-driver-dependencies.patch

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
Subject: add HAVE_CLK to Kconfig, for driver dependencies
From: David Brownell <dbrownell@users.sourceforge.net>

Flag platforms as HAVE_CLK (or not) in Kconfig, so that otherwise portable
drivers which need those calls can list that dependency.

Something like this is a prerequisite for merging the musb_hdrc driver,
currently used on platforms including Davinci, OMAP2430, OMAP3xx ...  and
the discrete TUSB6010 chip, which doesn't have a natural platform
dependency.  (Used with OMAP 2420 in current Nokia N8x0 tablets.)

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Cc: Russell King <rmk@arm.linux.org.uk>
Cc: Haavard Skinnemoen <hskinnemoen@atmel.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Paul Mundt <lethal@linux-sh.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/Kconfig         |    7 +++++++
 arch/arm/Kconfig     |   13 +++++++++++++
 arch/avr32/Kconfig   |    1 +
 arch/powerpc/Kconfig |    1 +
 arch/sh/Kconfig      |    1 +
 5 files changed, 23 insertions(+)

diff -puN arch/Kconfig~add-have_clk-to-kconfig-for-driver-dependencies arch/Kconfig
--- a/arch/Kconfig~add-have_clk-to-kconfig-for-driver-dependencies
+++ a/arch/Kconfig
@@ -39,3 +39,10 @@ config HAVE_KRETPROBES
 
 config HAVE_DMA_ATTRS
 	def_bool n
+
+config HAVE_CLK
+	def_bool n
+	help
+	  The <linux/clk.h> calls support software clock gating and
+	  thus are a key power management tool on many systems.
+
diff -puN arch/arm/Kconfig~add-have_clk-to-kconfig-for-driver-dependencies arch/arm/Kconfig
--- a/arch/arm/Kconfig~add-have_clk-to-kconfig-for-driver-dependencies
+++ a/arch/arm/Kconfig
@@ -186,12 +186,14 @@ choice
 config ARCH_AAEC2000
 	bool "Agilent AAEC-2000 based"
 	select ARM_AMBA
+	select HAVE_CLK
 	help
 	  This enables support for systems based on the Agilent AAEC-2000
 
 config ARCH_INTEGRATOR
 	bool "ARM Ltd. Integrator family"
 	select ARM_AMBA
+	select HAVE_CLK
 	select ICST525
 	help
 	  Support for ARM's Integrator platform.
@@ -199,6 +201,7 @@ config ARCH_INTEGRATOR
 config ARCH_REALVIEW
 	bool "ARM Ltd. RealView family"
 	select ARM_AMBA
+	select HAVE_CLK
 	select ICST307
 	select GENERIC_TIME
 	select GENERIC_CLOCKEVENTS
@@ -209,6 +212,7 @@ config ARCH_VERSATILE
 	bool "ARM Ltd. Versatile family"
 	select ARM_AMBA
 	select ARM_VIC
+	select HAVE_CLK
 	select ICST307
 	select GENERIC_TIME
 	select GENERIC_CLOCKEVENTS
@@ -250,6 +254,8 @@ config ARCH_EP93XX
 	select ARM_AMBA
 	select ARM_VIC
 	select GENERIC_GPIO
+	select HAVE_CLK
+	select HAVE_CLK
 	select HAVE_GPIO_LIB
 	help
 	  This enables support for the Cirrus EP93xx series of CPUs.
@@ -355,6 +361,7 @@ config ARCH_NS9XXX
 	select GENERIC_GPIO
 	select GENERIC_TIME
 	select GENERIC_CLOCKEVENTS
+	select HAVE_CLK
 	help
 	  Say Y here if you intend to run this kernel on a NetSilicon NS9xxx
 	  System.
@@ -381,6 +388,7 @@ config ARCH_ORION5X
 
 config ARCH_PNX4008
 	bool "Philips Nexperia PNX4008 Mobile"
+	select HAVE_CLK
 	help
 	  This enables support for Philips PNX4008 mobile platform.
 
@@ -389,6 +397,7 @@ config ARCH_PXA
 	depends on MMU
 	select ARCH_MTD_XIP
 	select GENERIC_GPIO
+	select HAVE_CLK
 	select HAVE_GPIO_LIB
 	select GENERIC_TIME
 	select GENERIC_CLOCKEVENTS
@@ -418,6 +427,7 @@ config ARCH_SA1100
 	select GENERIC_GPIO
 	select GENERIC_TIME
 	select GENERIC_CLOCKEVENTS
+	select HAVE_CLK
 	select TICK_ONESHOT
 	select HAVE_GPIO_LIB
 	help
@@ -426,6 +436,7 @@ config ARCH_SA1100
 config ARCH_S3C2410
 	bool "Samsung S3C2410, S3C2412, S3C2413, S3C2440, S3C2442, S3C2443"
 	select GENERIC_GPIO
+	select HAVE_CLK
 	help
 	  Samsung S3C2410X CPU based systems, such as the Simtec Electronics
 	  BAST (<http://www.simtec.co.uk/products/EB110ITX/>), the IPAQ 1940 or
@@ -453,12 +464,14 @@ config ARCH_DAVINCI
 	select GENERIC_TIME
 	select GENERIC_CLOCKEVENTS
 	select GENERIC_GPIO
+	select HAVE_CLK
 	help
 	  Support for TI's DaVinci platform.
 
 config ARCH_OMAP
 	bool "TI OMAP"
 	select GENERIC_GPIO
+	select HAVE_CLK
 	select HAVE_GPIO_LIB
 	select GENERIC_TIME
 	select GENERIC_CLOCKEVENTS
diff -puN arch/avr32/Kconfig~add-have_clk-to-kconfig-for-driver-dependencies arch/avr32/Kconfig
--- a/arch/avr32/Kconfig~add-have_clk-to-kconfig-for-driver-dependencies
+++ a/arch/avr32/Kconfig
@@ -10,6 +10,7 @@ config AVR32
 	# With EMBEDDED=n, we get lots of stuff automatically selected
 	# that we usually don't need on AVR32.
 	select EMBEDDED
+	select HAVE_CLK
 	select HAVE_OPROFILE
 	select HAVE_KPROBES
 	help
diff -puN arch/powerpc/Kconfig~add-have_clk-to-kconfig-for-driver-dependencies arch/powerpc/Kconfig
--- a/arch/powerpc/Kconfig~add-have_clk-to-kconfig-for-driver-dependencies
+++ a/arch/powerpc/Kconfig
@@ -812,6 +812,7 @@ source "crypto/Kconfig"
 config PPC_CLOCK
 	bool
 	default n
+	select HAVE_CLK
 
 config PPC_LIB_RHEAP
 	bool
diff -puN arch/sh/Kconfig~add-have_clk-to-kconfig-for-driver-dependencies arch/sh/Kconfig
--- a/arch/sh/Kconfig~add-have_clk-to-kconfig-for-driver-dependencies
+++ a/arch/sh/Kconfig
@@ -8,6 +8,7 @@ mainmenu "Linux/SuperH Kernel Configurat
 config SUPERH
 	def_bool y
 	select EMBEDDED
+	select HAVE_CLK
 	select HAVE_IDE
 	select HAVE_OPROFILE
 	help
_

Patches currently in -mm which might be from dbrownell@users.sourceforge.net are

spi-fix-refcount-related-spidev-oops-on-rmmod.patch
mmc_spih-should-include-linux-interruptsh.patch
linux-next.patch
add-have_clk-to-kconfig-for-driver-dependencies.patch
acpi_pm_device_sleep_state-cleanup.patch
git-orion.patch
xilinx_spi-test-below-0-on-unsigned-irq-in-xilinx_spi_probe.patch
spi-kconfig-simplifications.patch
spi-make-spi_board_infomodalias-a-char-array.patch
spidev-bkl-removal.patch
gpio-sysfs-interface.patch

