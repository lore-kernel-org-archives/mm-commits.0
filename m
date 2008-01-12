From: akpm@linux-foundation.org
Subject: + gpiolib-add-drivers-gpio-directory.patch added to -mm tree
Date: Fri, 11 Jan 2008 18:22:42 -0800
Message-ID: <200801120222.m0C2MgTn009677@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47173 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753242AbYALCbP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 11 Jan 2008 21:31:15 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dbrownell@users.sourceforge.net, bgardner@wabtec.com, eric.miao@marvell.com, hskinnemoen@atmel.com, khali@linux-fr.org, philipp.zabel@gmail.com, rmk@arm.linux.org.uk, sam@ravnborg.org


The patch titled
     gpiolib: add drivers/gpio directory
has been added to the -mm tree.  Its filename is
     gpiolib-add-drivers-gpio-directory.patch

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
Subject: gpiolib: add drivers/gpio directory
From: David Brownell <dbrownell@users.sourceforge.net>

Add an empty drivers/gpio directory for gpiolib infrastructure and GPIO
expanders.  It will be populated by later patches.

This won't be the only place to hold such gpio_chip code.  Many external chips
add a few GPIOs as secondary functionality (such as MFD drivers) and platform
code frequently needs to closely integrate GPIO and IRQ support.

This is placed *early* in the build/link sequence since it's common for other
drivers to depend on GPIOs to do their work, so they must be initialized early
in the device_initcall() sequence.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Acked-by: Jean Delvare <khali@linux-fr.org>
Cc: Eric Miao <eric.miao@marvell.com>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Haavard Skinnemoen <hskinnemoen@atmel.com>
Cc: Philipp Zabel <philipp.zabel@gmail.com>
Cc: Russell King <rmk@arm.linux.org.uk>
Cc: Ben Gardner <bgardner@wabtec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/Kconfig      |    2 ++
 drivers/Kconfig       |    2 ++
 drivers/Makefile      |    1 +
 drivers/gpio/Kconfig  |   32 ++++++++++++++++++++++++++++++++
 drivers/gpio/Makefile |    4 ++++
 5 files changed, 41 insertions(+)

diff -puN arch/arm/Kconfig~gpiolib-add-drivers-gpio-directory arch/arm/Kconfig
--- a/arch/arm/Kconfig~gpiolib-add-drivers-gpio-directory
+++ a/arch/arm/Kconfig
@@ -1079,6 +1079,8 @@ source "drivers/i2c/Kconfig"
 
 source "drivers/spi/Kconfig"
 
+source "drivers/gpio/Kconfig"
+
 source "drivers/w1/Kconfig"
 
 source "drivers/power/Kconfig"
diff -puN drivers/Kconfig~gpiolib-add-drivers-gpio-directory drivers/Kconfig
--- a/drivers/Kconfig~gpiolib-add-drivers-gpio-directory
+++ a/drivers/Kconfig
@@ -52,6 +52,8 @@ source "drivers/i2c/Kconfig"
 
 source "drivers/spi/Kconfig"
 
+source "drivers/gpio/Kconfig"
+
 source "drivers/w1/Kconfig"
 
 source "drivers/power/Kconfig"
diff -puN drivers/Makefile~gpiolib-add-drivers-gpio-directory drivers/Makefile
--- a/drivers/Makefile~gpiolib-add-drivers-gpio-directory
+++ a/drivers/Makefile
@@ -5,6 +5,7 @@
 # Rewritten to use lists instead of if-statements.
 #
 
+obj-$(CONFIG_HAVE_GPIO_LIB)	+= gpio/
 obj-$(CONFIG_PCI)		+= pci/
 obj-$(CONFIG_PARISC)		+= parisc/
 obj-$(CONFIG_RAPIDIO)		+= rapidio/
diff -puN /dev/null drivers/gpio/Kconfig
--- /dev/null
+++ a/drivers/gpio/Kconfig
@@ -0,0 +1,32 @@
+#
+# GPIO infrastructure and expanders
+#
+
+config HAVE_GPIO_LIB
+	bool
+	help
+	  Platforms select gpiolib if they use this infrastructure
+	  for all their GPIOs, usually starting with ones integrated
+	  into SOC processors.
+
+menu "GPIO Support"
+	depends on HAVE_GPIO_LIB
+
+config DEBUG_GPIO
+	bool "Debug GPIO calls"
+	depends on DEBUG_KERNEL
+	help
+	  Say Y here to add some extra checks and diagnostics to GPIO calls.
+	  The checks help ensure that GPIOs have been properly initialized
+	  before they are used and that sleeping calls aren not made from
+	  nonsleeping contexts.  They can make bitbanged serial protocols
+	  slower.  The diagnostics help catch the type of setup errors
+	  that are most common when setting up new platforms or boards.
+
+# put expanders in the right section, in alphabetical order
+
+comment "I2C GPIO expanders:"
+
+comment "SPI GPIO expanders:"
+
+endmenu
diff -puN /dev/null drivers/gpio/Makefile
--- /dev/null
+++ a/drivers/gpio/Makefile
@@ -0,0 +1,4 @@
+# gpio support: dedicated expander chips, etc
+
+ccflags-$(CONFIG_DEBUG_GPIO)	+= -DDEBUG
+
_

Patches currently in -mm which might be from dbrownell@users.sourceforge.net are

spi_bitbang-always-grab-lock-with-irqs-blocked.patch
git-arm.patch
git-input.patch
backlight-omap1-backlight-driver.patch
pcmcia-stop-updating-dev-powerpower_state.patch
at91_cf-use-generic-gpio-calls.patch
remove-obsolete-sys-devices-power-state-docs.patch
spi-core-stop-updating-dev-powerpower_state.patch
atmel_spi-throughput-improvement.patch
atmel_spi-chain-dma-transfers.patch
atmel_spi-chain-dma-transfers-update.patch
atmel_spi-fix-dmachain-oops-with-debug-enabled.patch
rtc-cmos-exports-nvram-in-sysfs.patch
rtc-cmos-alarm-acts-as-oneshot.patch
gpiolib-add-drivers-gpio-directory.patch
gpiolib-add-gpio-provider-infrastructure.patch
gpiolib-update-documentation-gpiotxt.patch
gpiolib-avr32-at32ap-platform-support.patch
gpiolib-pxa-platform-support.patch
gpiolib-pcf857x-i2c-gpio-expander-support.patch
gpiolib-mcp23s08-spi-gpio-expander-support.patch
gpiolib-pca9539-i2c-gpio-expander-support.patch
gpiolib-deprecate-obsolete-pca9539-driver.patch
usb-net2280-cant-have-a-function-called-show_registers.patch
