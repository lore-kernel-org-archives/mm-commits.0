From: akpm@linux-foundation.org
Subject: - add-config_generic_gpio.patch removed from -mm tree
Date: Mon, 05 Mar 2007 15:54:46 -0800
Message-ID: <200703052354.l25Nskbt005133@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:43585 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752694AbXCFA4V (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 5 Mar 2007 19:56:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: david-b@pacbell.net, arnaud.patard@rtp-net.org, dbrownell@users.sourceforge.net, dtor@mail.ru, hskinnemoen@atmel.com, msvoboda@ra.rockwell.com, philipp.zabel@gmail.com, raph@8d.com, rmk@arm.linux.org.uk, rpurdie@rpsys.net, mm-commits@vger.kernel.org


The patch titled
     add CONFIG_GENERIC_GPIO
has been removed from the -mm tree.  Its filename was
     add-config_generic_gpio.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: add CONFIG_GENERIC_GPIO
From: David Brownell <david-b@pacbell.net>

Most drivers using GPIOs already know they are running on a system that
supports the generic GPIO calls, because of other platform dependencies. 
But the generic GPIO-based LED and input button drivers can't know that.

So this patch adds a Kconfig hook, GENERIC_GPIO, to mark the platforms
where <asm/gpio.h> will do the right thing.  Currently that's a bunch of
ARMs, and AVR32; more are on the way.

It also fixes a dependency bug for the gpio button input driver; it was
wrong to start with, now it covers all platforms with GENERIC_GPIO.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Acked-by: Richard Purdie <rpurdie@rpsys.net>
Cc: Arnaud Patard <arnaud.patard@rtp-net.org>
Cc: <raph@8d.com>
Cc: <msvoboda@ra.rockwell.com>
Cc: pHilipp Zabel <philipp.zabel@gmail.com>
Cc: Haavard Skinnemoen <hskinnemoen@atmel.com>
Cc: Dmitry Torokhov <dtor@mail.ru>
Cc: Russell King <rmk@arm.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/Kconfig               |    9 +++++++++
 arch/avr32/Kconfig             |    4 ++++
 drivers/input/keyboard/Kconfig |   10 ++++++----
 3 files changed, 19 insertions(+), 4 deletions(-)

diff -puN arch/arm/Kconfig~add-config_generic_gpio arch/arm/Kconfig
--- a/arch/arm/Kconfig~add-config_generic_gpio
+++ a/arch/arm/Kconfig
@@ -21,6 +21,10 @@ config ARM
 config SYS_SUPPORTS_APM_EMULATION
 	bool
 
+config GENERIC_GPIO
+	bool
+	default n
+
 config GENERIC_TIME
 	bool
 	default n
@@ -163,6 +167,7 @@ config ARCH_VERSATILE
 
 config ARCH_AT91
 	bool "Atmel AT91"
+	select GENERIC_GPIO
 	help
 	  This enables support for systems based on the Atmel AT91RM9200
 	  and AT91SAM9xxx processors.
@@ -304,6 +309,7 @@ config ARCH_PXA
 	bool "PXA2xx-based"
 	depends on MMU
 	select ARCH_MTD_XIP
+	select GENERIC_GPIO
 	select GENERIC_TIME
 	help
 	  Support for Intel's PXA2XX processor line.
@@ -325,11 +331,13 @@ config ARCH_SA1100
 	select ISA
 	select ARCH_DISCONTIGMEM_ENABLE
 	select ARCH_MTD_XIP
+	select GENERIC_GPIO
 	help
 	  Support for StrongARM 11x0 based boards.
 
 config ARCH_S3C2410
 	bool "Samsung S3C2410, S3C2412, S3C2413, S3C2440, S3C2442, S3C2443"
+	select GENERIC_GPIO
 	help
 	  Samsung S3C2410X CPU based systems, such as the Simtec Electronics
 	  BAST (<http://www.simtec.co.uk/products/EB110ITX/>), the IPAQ 1940 or
@@ -354,6 +362,7 @@ config ARCH_LH7A40X
 
 config ARCH_OMAP
 	bool "TI OMAP"
+	select GENERIC_GPIO
 	help
 	  Support for TI's OMAP platform (OMAP1 and OMAP2).
 
diff -puN arch/avr32/Kconfig~add-config_generic_gpio arch/avr32/Kconfig
--- a/arch/avr32/Kconfig~add-config_generic_gpio
+++ a/arch/avr32/Kconfig
@@ -22,6 +22,10 @@ config AVR32
 config UID16
 	bool
 
+config GENERIC_GPIO
+	bool
+	default y
+
 config GENERIC_HARDIRQS
 	bool
 	default y
diff -puN drivers/input/keyboard/Kconfig~add-config_generic_gpio drivers/input/keyboard/Kconfig
--- a/drivers/input/keyboard/Kconfig~add-config_generic_gpio
+++ a/drivers/input/keyboard/Kconfig
@@ -215,14 +215,16 @@ config KEYBOARD_AAED2000
 	  module will be called aaed2000_kbd.
 
 config KEYBOARD_GPIO
-	tristate "Buttons on CPU GPIOs (PXA)"
-	depends on (ARCH_SA1100 || ARCH_PXA || ARCH_S3C2410)
+	tristate "GPIO Buttons"
+	depends on GENERIC_GPIO
 	help
 	  This driver implements support for buttons connected
-	  directly to GPIO pins of SA1100, PXA or S3C24xx CPUs.
+	  to GPIO pins of various CPUs (and some other chips).
 
 	  Say Y here if your device has buttons connected
-	  directly to GPIO pins of the CPU.
+	  directly to such GPIO pins.  Your board-specific
+	  setup logic must also provide a platform device,
+	  with configuration data saying which GPIOs are used.
 
 	  To compile this driver as a module, choose M here: the
 	  module will be called gpio-keys.
_

Patches currently in -mm which might be from david-b@pacbell.net are

origin.patch
git-avr32.patch
git-input.patch
git-md-accel.patch
8250-make-probing-for-txen-bug-a-config-option.patch
blackfin-on-chip-rtc-controller-driver.patch
documentation-ask-driver-writers-to-provide-pm-support.patch
init-dma-masks-in-pnp_dev.patch
rtc-remove-sys-class-rtc-dev.patch
rtc-rtc-interfaces-dont-use-class_device.patch
rtc-simplified-rtc-sysfs-attribute-handling.patch
rtc-simplified-proc-driver-rtc-handling.patch
rtc-remove-rest-of-class_device.patch
rtc-suspend-resume-restores-system-clock.patch
rtc-simplified-rtc-sysfs-attribute-handling-tidy.patch
