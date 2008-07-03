From: akpm@linux-foundation.org
Subject: + gpiolib-allow-user-selection.patch added to -mm tree
Date: Thu, 03 Jul 2008 15:37:44 -0700
Message-ID: <200807032237.m63Mbi7T030932@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35773 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754791AbYGCWjh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 3 Jul 2008 18:39:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mb@bu3sch.de, benh@kernel.crashing.org, bunk@stusta.de, david-b@pacbell.net, galak@gate.crashing.org, hskinnemoen@atmel.com, jesper.nilsson@axis.com, khali@linux-fr.org, mingo@elte.hu, paulus@samba.org, ralf@linux-mips.org, rmk@arm.linux.org.uk, sam@ravnborg.org, sameo@openedhand.com, sfr@canb.auug.org.au, tglx@linutronix.de


The patch titled
     gpiolib: allow user-selection
has been added to the -mm tree.  Its filename is
     gpiolib-allow-user-selection.patch

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
Subject: gpiolib: allow user-selection
From: Michael Buesch <mb@bu3sch.de>

This patch adds functionality to the gpio-lib subsystem to make it
possible to enable the gpio-lib code even if the architecture code didn't
request to get it built in.

The archtitecture code does still need to implement the gpiolib accessor
functions in its asm/gpio.h file.  This patch adds the implementations for
x86 and PPC.

With these changes it is possible to run generic GPIO expansion cards on
every architecture that implements the trivial wrapper functions.  Support
for more architectures can easily be added.

Signed-off-by: Michael Buesch <mb@bu3sch.de>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: David Brownell <david-b@pacbell.net>
Cc: Russell King <rmk@arm.linux.org.uk>
Cc: Haavard Skinnemoen <hskinnemoen@atmel.com>
Cc: Jesper Nilsson <jesper.nilsson@axis.com>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Jean Delvare <khali@linux-fr.org>
Cc: Samuel Ortiz <sameo@openedhand.com>
Cc: Kumar Gala <galak@gate.crashing.org>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Adrian Bunk <bunk@stusta.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/gpio.txt                          |   12 ++-
 arch/arm/Kconfig                                |    8 +-
 arch/arm/configs/am200epdkit_defconfig          |    2 
 arch/arm/configs/xm_x270_defconfig              |    2 
 arch/avr32/Kconfig                              |    2 
 arch/avr32/configs/atngw100_defconfig           |    2 
 arch/avr32/configs/atstk1002_defconfig          |    2 
 arch/avr32/configs/atstk1003_defconfig          |    2 
 arch/avr32/configs/atstk1004_defconfig          |    2 
 arch/mips/Kconfig                               |    2 
 arch/powerpc/Kconfig                            |    1 
 arch/powerpc/configs/83xx/mpc836x_rdk_defconfig |    2 
 arch/powerpc/platforms/52xx/Kconfig             |    2 
 arch/powerpc/sysdev/qe_lib/Kconfig              |    2 
 arch/x86/Kconfig                                |    1 
 drivers/Makefile                                |    2 
 drivers/gpio/Kconfig                            |   33 +++++++-
 drivers/gpio/Makefile                           |    2 
 drivers/i2c/chips/Kconfig                       |    2 
 drivers/mfd/Kconfig                             |    4 -
 drivers/of/Kconfig                              |    2 
 include/asm-generic/gpio.h                      |    2 
 include/asm-mips/mach-generic/gpio.h            |    2 
 include/asm-powerpc/gpio.h                      |    4 -
 include/asm-x86/gpio.h                          |   56 ++++++++++++++
 25 files changed, 123 insertions(+), 30 deletions(-)

diff -puN Documentation/gpio.txt~gpiolib-allow-user-selection Documentation/gpio.txt
--- a/Documentation/gpio.txt~gpiolib-allow-user-selection
+++ a/Documentation/gpio.txt
@@ -389,11 +389,21 @@ either NULL or the label associated with
 
 Platform Support
 ----------------
-To support this framework, a platform's Kconfig will "select HAVE_GPIO_LIB"
+To support this framework, a platform's Kconfig will "select" either
+ARCH_REQUIRE_GPIOLIB or ARCH_WANT_OPTIONAL_GPIOLIB
 and arrange that its <asm/gpio.h> includes <asm-generic/gpio.h> and defines
 three functions: gpio_get_value(), gpio_set_value(), and gpio_cansleep().
 They may also want to provide a custom value for ARCH_NR_GPIOS.
 
+ARCH_REQUIRE_GPIOLIB means that the gpio-lib code will always get compiled
+into the kernel on that architecture.
+
+ARCH_WANT_OPTIONAL_GPIOLIB means the gpio-lib code defaults to off and the user
+can enable it and build it into the kernel optionally.
+
+If neither of these options are selected, the platform does not support
+GPIOs through GPIO-lib and the code cannot be enabled by the user.
+
 Trivial implementations of those functions can directly use framework
 code, which always dispatches through the gpio_chip:
 
diff -puN arch/arm/Kconfig~gpiolib-allow-user-selection arch/arm/Kconfig
--- a/arch/arm/Kconfig~gpiolib-allow-user-selection
+++ a/arch/arm/Kconfig
@@ -268,7 +268,7 @@ config ARCH_EP93XX
 	select GENERIC_GPIO
 	select HAVE_CLK
 	select HAVE_CLK
-	select HAVE_GPIO_LIB
+	select ARCH_REQUIRE_GPIOLIB
 	help
 	  This enables support for the Cirrus EP93xx series of CPUs.
 
@@ -439,7 +439,7 @@ config ARCH_PXA
 	select ARCH_MTD_XIP
 	select GENERIC_GPIO
 	select HAVE_CLK
-	select HAVE_GPIO_LIB
+	select ARCH_REQUIRE_GPIOLIB
 	select GENERIC_TIME
 	select GENERIC_CLOCKEVENTS
 	select TICK_ONESHOT
@@ -470,7 +470,7 @@ config ARCH_SA1100
 	select GENERIC_CLOCKEVENTS
 	select HAVE_CLK
 	select TICK_ONESHOT
-	select HAVE_GPIO_LIB
+	select ARCH_REQUIRE_GPIOLIB
 	help
 	  Support for StrongARM 11x0 based boards.
 
@@ -513,7 +513,7 @@ config ARCH_OMAP
 	bool "TI OMAP"
 	select GENERIC_GPIO
 	select HAVE_CLK
-	select HAVE_GPIO_LIB
+	select ARCH_REQUIRE_GPIOLIB
 	select GENERIC_TIME
 	select GENERIC_CLOCKEVENTS
 	help
diff -puN arch/arm/configs/am200epdkit_defconfig~gpiolib-allow-user-selection arch/arm/configs/am200epdkit_defconfig
--- a/arch/arm/configs/am200epdkit_defconfig~gpiolib-allow-user-selection
+++ a/arch/arm/configs/am200epdkit_defconfig
@@ -668,7 +668,7 @@ CONFIG_UNIX98_PTYS=y
 #
 # CONFIG_SPI is not set
 # CONFIG_SPI_MASTER is not set
-CONFIG_HAVE_GPIO_LIB=y
+CONFIG_ARCH_REQUIRE_GPIOLIB=y
 
 #
 # GPIO Support
diff -puN arch/arm/configs/xm_x270_defconfig~gpiolib-allow-user-selection arch/arm/configs/xm_x270_defconfig
--- a/arch/arm/configs/xm_x270_defconfig~gpiolib-allow-user-selection
+++ a/arch/arm/configs/xm_x270_defconfig
@@ -970,7 +970,7 @@ CONFIG_I2C_PXA=y
 # CONFIG_I2C_DEBUG_BUS is not set
 # CONFIG_I2C_DEBUG_CHIP is not set
 # CONFIG_SPI is not set
-CONFIG_HAVE_GPIO_LIB=y
+CONFIG_ARCH_REQUIRE_GPIOLIB=y
 
 #
 # GPIO Support
diff -puN arch/avr32/Kconfig~gpiolib-allow-user-selection arch/avr32/Kconfig
--- a/arch/avr32/Kconfig~gpiolib-allow-user-selection
+++ a/arch/avr32/Kconfig
@@ -88,7 +88,7 @@ config PLATFORM_AT32AP
 	select SUBARCH_AVR32B
 	select MMU
 	select PERFORMANCE_COUNTERS
-	select HAVE_GPIO_LIB
+	select ARCH_REQUIRE_GPIOLIB
 
 #
 # CPU types
diff -puN arch/avr32/configs/atngw100_defconfig~gpiolib-allow-user-selection arch/avr32/configs/atngw100_defconfig
--- a/arch/avr32/configs/atngw100_defconfig~gpiolib-allow-user-selection
+++ a/arch/avr32/configs/atngw100_defconfig
@@ -646,7 +646,7 @@ CONFIG_SPI_ATMEL=y
 # CONFIG_SPI_AT25 is not set
 CONFIG_SPI_SPIDEV=m
 # CONFIG_SPI_TLE62X0 is not set
-CONFIG_HAVE_GPIO_LIB=y
+CONFIG_ARCH_REQUIRE_GPIOLIB=y
 
 #
 # GPIO Support
diff -puN arch/avr32/configs/atstk1002_defconfig~gpiolib-allow-user-selection arch/avr32/configs/atstk1002_defconfig
--- a/arch/avr32/configs/atstk1002_defconfig~gpiolib-allow-user-selection
+++ a/arch/avr32/configs/atstk1002_defconfig
@@ -664,7 +664,7 @@ CONFIG_SPI_ATMEL=y
 # CONFIG_SPI_AT25 is not set
 CONFIG_SPI_SPIDEV=m
 # CONFIG_SPI_TLE62X0 is not set
-CONFIG_HAVE_GPIO_LIB=y
+CONFIG_ARCH_REQUIRE_GPIOLIB=y
 
 #
 # GPIO Support
diff -puN arch/avr32/configs/atstk1003_defconfig~gpiolib-allow-user-selection arch/avr32/configs/atstk1003_defconfig
--- a/arch/avr32/configs/atstk1003_defconfig~gpiolib-allow-user-selection
+++ a/arch/avr32/configs/atstk1003_defconfig
@@ -614,7 +614,7 @@ CONFIG_SPI_ATMEL=y
 # CONFIG_SPI_AT25 is not set
 CONFIG_SPI_SPIDEV=m
 # CONFIG_SPI_TLE62X0 is not set
-CONFIG_HAVE_GPIO_LIB=y
+CONFIG_ARCH_REQUIRE_GPIOLIB=y
 
 #
 # GPIO Support
diff -puN arch/avr32/configs/atstk1004_defconfig~gpiolib-allow-user-selection arch/avr32/configs/atstk1004_defconfig
--- a/arch/avr32/configs/atstk1004_defconfig~gpiolib-allow-user-selection
+++ a/arch/avr32/configs/atstk1004_defconfig
@@ -390,7 +390,7 @@ CONFIG_SPI_ATMEL=y
 # CONFIG_SPI_AT25 is not set
 # CONFIG_SPI_SPIDEV is not set
 # CONFIG_SPI_TLE62X0 is not set
-CONFIG_HAVE_GPIO_LIB=y
+CONFIG_ARCH_REQUIRE_GPIOLIB=y
 
 #
 # GPIO Support
diff -puN arch/mips/Kconfig~gpiolib-allow-user-selection arch/mips/Kconfig
--- a/arch/mips/Kconfig~gpiolib-allow-user-selection
+++ a/arch/mips/Kconfig
@@ -800,7 +800,7 @@ config CSRC_SB1250
 
 config GPIO_TXX9
 	select GENERIC_GPIO
-	select HAVE_GPIO_LIB
+	select ARCH_REQUIRE_GPIOLIB
 	bool
 
 config CFE
diff -puN arch/powerpc/Kconfig~gpiolib-allow-user-selection arch/powerpc/Kconfig
--- a/arch/powerpc/Kconfig~gpiolib-allow-user-selection
+++ a/arch/powerpc/Kconfig
@@ -114,6 +114,7 @@ config PPC
 	select HAVE_KRETPROBES
 	select HAVE_LMB
 	select HAVE_OPROFILE
+	select ARCH_WANT_OPTIONAL_GPIOLIB
 
 config EARLY_PRINTK
 	bool
diff -puN arch/powerpc/configs/83xx/mpc836x_rdk_defconfig~gpiolib-allow-user-selection arch/powerpc/configs/83xx/mpc836x_rdk_defconfig
--- a/arch/powerpc/configs/83xx/mpc836x_rdk_defconfig~gpiolib-allow-user-selection
+++ a/arch/powerpc/configs/83xx/mpc836x_rdk_defconfig
@@ -703,7 +703,7 @@ CONFIG_SPI_MPC83xx=y
 # CONFIG_SPI_AT25 is not set
 CONFIG_SPI_SPIDEV=y
 # CONFIG_SPI_TLE62X0 is not set
-CONFIG_HAVE_GPIO_LIB=y
+CONFIG_ARCH_REQUIRE_GPIOLIB=y
 
 #
 # GPIO Support
diff -puN arch/powerpc/platforms/52xx/Kconfig~gpiolib-allow-user-selection arch/powerpc/platforms/52xx/Kconfig
--- a/arch/powerpc/platforms/52xx/Kconfig~gpiolib-allow-user-selection
+++ a/arch/powerpc/platforms/52xx/Kconfig
@@ -47,6 +47,6 @@ config PPC_MPC5200_BUGFIX
 config PPC_MPC5200_GPIO
 	bool "MPC5200 GPIO support"
 	depends on PPC_MPC52xx
-	select HAVE_GPIO_LIB
+	select ARCH_REQUIRE_GPIOLIB
 	help
 	  Enable gpiolib support for mpc5200 based boards
diff -puN arch/powerpc/sysdev/qe_lib/Kconfig~gpiolib-allow-user-selection arch/powerpc/sysdev/qe_lib/Kconfig
--- a/arch/powerpc/sysdev/qe_lib/Kconfig~gpiolib-allow-user-selection
+++ a/arch/powerpc/sysdev/qe_lib/Kconfig
@@ -29,7 +29,7 @@ config QE_GPIO
 	bool "QE GPIO support"
 	depends on QUICC_ENGINE
 	select GENERIC_GPIO
-	select HAVE_GPIO_LIB
+	select ARCH_REQUIRE_GPIOLIB
 	help
 	  Say Y here if you're going to use hardware that connects to the
 	  QE GPIOs.
diff -puN arch/x86/Kconfig~gpiolib-allow-user-selection arch/x86/Kconfig
--- a/arch/x86/Kconfig~gpiolib-allow-user-selection
+++ a/arch/x86/Kconfig
@@ -21,6 +21,7 @@ config X86
 	select HAVE_UNSTABLE_SCHED_CLOCK
 	select HAVE_IDE
 	select HAVE_OPROFILE
+	select ARCH_WANT_OPTIONAL_GPIOLIB if !X86_RDC321X
 	select HAVE_IOREMAP_PROT
 	select HAVE_KPROBES
 	select HAVE_KRETPROBES
diff -puN drivers/Makefile~gpiolib-allow-user-selection drivers/Makefile
--- a/drivers/Makefile~gpiolib-allow-user-selection
+++ a/drivers/Makefile
@@ -5,7 +5,7 @@
 # Rewritten to use lists instead of if-statements.
 #
 
-obj-$(CONFIG_HAVE_GPIO_LIB)	+= gpio/
+obj-y				+= gpio/
 obj-$(CONFIG_PCI)		+= pci/
 obj-$(CONFIG_PARISC)		+= parisc/
 obj-$(CONFIG_RAPIDIO)		+= rapidio/
diff -puN drivers/gpio/Kconfig~gpiolib-allow-user-selection drivers/gpio/Kconfig
--- a/drivers/gpio/Kconfig~gpiolib-allow-user-selection
+++ a/drivers/gpio/Kconfig
@@ -2,15 +2,40 @@
 # GPIO infrastructure and expanders
 #
 
-config HAVE_GPIO_LIB
+config ARCH_WANT_OPTIONAL_GPIOLIB
 	bool
 	help
+	  Select this config option from the architecture Kconfig, if
+	  it is possible to use gpiolib on the architecture, but let the
+	  user decide whether to actually build it or not.
+	  Select this instead of ARCH_REQUIRE_GPIOLIB, if your architecture does
+	  not depend on GPIOs being available, but rather let the user
+	  decide whether he needs it or not.
+
+config ARCH_REQUIRE_GPIOLIB
+	bool
+	select GPIOLIB
+	help
 	  Platforms select gpiolib if they use this infrastructure
 	  for all their GPIOs, usually starting with ones integrated
 	  into SOC processors.
+	  Selecting this from the architecture code will cause the gpiolib
+	  code to always get built in.
+
+
+
+menuconfig GPIOLIB
+	bool "GPIO Support"
+	depends on ARCH_WANT_OPTIONAL_GPIOLIB || ARCH_REQUIRE_GPIOLIB
+	select GENERIC_GPIO
+	help
+	  This enables GPIO support through the generic GPIO library.
+	  You only need to enable this, if you also want to enable
+	  one or more of the GPIO expansion card drivers below.
+
+	  If unsure, say N.
 
-menu "GPIO Support"
-	depends on HAVE_GPIO_LIB
+if GPIOLIB
 
 config DEBUG_GPIO
 	bool "Debug GPIO calls"
@@ -115,4 +140,4 @@ config GPIO_MCP23S08
 	  SPI driver for Microchip MCP23S08 I/O expander.  This provides
 	  a GPIO interface supporting inputs and outputs.
 
-endmenu
+endif
diff -puN drivers/gpio/Makefile~gpiolib-allow-user-selection drivers/gpio/Makefile
--- a/drivers/gpio/Makefile~gpiolib-allow-user-selection
+++ a/drivers/gpio/Makefile
@@ -2,7 +2,7 @@
 
 ccflags-$(CONFIG_DEBUG_GPIO)	+= -DDEBUG
 
-obj-$(CONFIG_HAVE_GPIO_LIB)	+= gpiolib.o
+obj-$(CONFIG_GPIOLIB)		+= gpiolib.o
 
 obj-$(CONFIG_GPIO_MAX7301)	+= max7301.o
 obj-$(CONFIG_GPIO_MCP23S08)	+= mcp23s08.o
diff -puN drivers/i2c/chips/Kconfig~gpiolib-allow-user-selection drivers/i2c/chips/Kconfig
--- a/drivers/i2c/chips/Kconfig~gpiolib-allow-user-selection
+++ a/drivers/i2c/chips/Kconfig
@@ -100,7 +100,7 @@ config ISP1301_OMAP
 
 config TPS65010
 	tristate "TPS6501x Power Management chips"
-	depends on HAVE_GPIO_LIB
+	depends on GPIOLIB
 	default y if MACH_OMAP_H2 || MACH_OMAP_H3 || MACH_OMAP_OSK
 	help
 	  If you say yes here you get support for the TPS6501x series of
diff -puN drivers/mfd/Kconfig~gpiolib-allow-user-selection drivers/mfd/Kconfig
--- a/drivers/mfd/Kconfig~gpiolib-allow-user-selection
+++ a/drivers/mfd/Kconfig
@@ -36,7 +36,7 @@ config MFD_ASIC3
 
 config HTC_EGPIO
 	bool "HTC EGPIO support"
-	depends on GENERIC_HARDIRQS && HAVE_GPIO_LIB && ARM
+	depends on GENERIC_HARDIRQS && GPIOLIB && ARM
 	help
 	    This driver supports the CPLD egpio chip present on
 	    several HTC phones.  It provides basic support for input
@@ -52,7 +52,7 @@ config HTC_PASIC3
 
 config MFD_TC6393XB
 	bool "Support Toshiba TC6393XB"
-	depends on HAVE_GPIO_LIB
+	depends on GPIOLIB
 	select MFD_CORE
 	help
 	  Support for Toshiba Mobile IO Controller TC6393XB
diff -puN drivers/of/Kconfig~gpiolib-allow-user-selection drivers/of/Kconfig
--- a/drivers/of/Kconfig~gpiolib-allow-user-selection
+++ a/drivers/of/Kconfig
@@ -4,7 +4,7 @@ config OF_DEVICE
 
 config OF_GPIO
 	def_bool y
-	depends on OF && PPC_OF && HAVE_GPIO_LIB
+	depends on OF && PPC_OF && GPIOLIB
 	help
 	  OpenFirmware GPIO accessors
 
diff -puN include/asm-generic/gpio.h~gpiolib-allow-user-selection include/asm-generic/gpio.h
--- a/include/asm-generic/gpio.h~gpiolib-allow-user-selection
+++ a/include/asm-generic/gpio.h
@@ -3,7 +3,7 @@
 
 #include <linux/types.h>
 
-#ifdef CONFIG_HAVE_GPIO_LIB
+#ifdef CONFIG_GPIOLIB
 
 #include <linux/compiler.h>
 
diff -puN include/asm-mips/mach-generic/gpio.h~gpiolib-allow-user-selection include/asm-mips/mach-generic/gpio.h
--- a/include/asm-mips/mach-generic/gpio.h~gpiolib-allow-user-selection
+++ a/include/asm-mips/mach-generic/gpio.h
@@ -1,7 +1,7 @@
 #ifndef __ASM_MACH_GENERIC_GPIO_H
 #define __ASM_MACH_GENERIC_GPIO_H
 
-#ifdef CONFIG_HAVE_GPIO_LIB
+#ifdef CONFIG_GPIOLIB
 #define gpio_get_value	__gpio_get_value
 #define gpio_set_value	__gpio_set_value
 #define gpio_cansleep	__gpio_cansleep
diff -puN include/asm-powerpc/gpio.h~gpiolib-allow-user-selection include/asm-powerpc/gpio.h
--- a/include/asm-powerpc/gpio.h~gpiolib-allow-user-selection
+++ a/include/asm-powerpc/gpio.h
@@ -17,7 +17,7 @@
 #include <linux/errno.h>
 #include <asm-generic/gpio.h>
 
-#ifdef CONFIG_HAVE_GPIO_LIB
+#ifdef CONFIG_GPIOLIB
 
 /*
  * We don't (yet) implement inlined/rapid versions for on-chip gpios.
@@ -51,6 +51,6 @@ static inline int irq_to_gpio(unsigned i
 	return -EINVAL;
 }
 
-#endif /* CONFIG_HAVE_GPIO_LIB */
+#endif /* CONFIG_GPIOLIB */
 
 #endif /* __ASM_POWERPC_GPIO_H */
diff -puN include/asm-x86/gpio.h~gpiolib-allow-user-selection include/asm-x86/gpio.h
--- a/include/asm-x86/gpio.h~gpiolib-allow-user-selection
+++ a/include/asm-x86/gpio.h
@@ -1,6 +1,62 @@
+/*
+ * Generic GPIO API implementation for x86.
+ *
+ * Derived from the generic GPIO API for powerpc:
+ *
+ * Copyright (c) 2007-2008  MontaVista Software, Inc.
+ *
+ * Author: Anton Vorontsov <avorontsov@ru.mvista.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
 #ifndef _ASM_I386_GPIO_H
 #define _ASM_I386_GPIO_H
 
+#ifdef CONFIG_X86_RDC321X
 #include <gpio.h>
+#else /* CONFIG_X86_RDC321X */
+
+#include <asm-generic/gpio.h>
+
+#ifdef CONFIG_GPIOLIB
+
+/*
+ * Just call gpiolib.
+ */
+static inline int gpio_get_value(unsigned int gpio)
+{
+	return __gpio_get_value(gpio);
+}
+
+static inline void gpio_set_value(unsigned int gpio, int value)
+{
+	__gpio_set_value(gpio, value);
+}
+
+static inline int gpio_cansleep(unsigned int gpio)
+{
+	return __gpio_cansleep(gpio);
+}
+
+/*
+ * Not implemented, yet.
+ */
+static inline int gpio_to_irq(unsigned int gpio)
+{
+	return -ENOSYS;
+}
+
+static inline int irq_to_gpio(unsigned int irq)
+{
+	return -EINVAL;
+}
+
+#endif /* CONFIG_GPIOLIB */
+
+#endif /* CONFIG_X86_RDC321X */
 
 #endif /* _ASM_I386_GPIO_H */
_

Patches currently in -mm which might be from mb@bu3sch.de are

linux-next.patch
drivers-net-wireless-b43legacy-dmac-remove-the-switch-in-b43legacy_dma_init.patch
gpio-add-bt8xxgpio-driver.patch
gpio-add-bt8xxgpio-driver-checkpatch-fixes.patch
gpio-add-bt8xxgpio-driver-checkpatch-fixes-fix.patch
gpio-add-bt8xxgpio-driver-checkpatch-fixes-cleanup.patch
gpiolib-allow-user-selection.patch

