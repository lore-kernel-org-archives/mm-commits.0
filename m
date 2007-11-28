From: akpm@linux-foundation.org
Subject: - txx9-watchdog-support-for-rbhma3100rbhma4200rbhma4500.patch removed from -mm tree
Date: Wed, 28 Nov 2007 15:12:48 -0800
Message-ID: <200711282312.lASNCm8x023879@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50693 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754357AbXK1XNJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 28 Nov 2007 18:13:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: anemo@mba.ocn.ne.jp, ralf@linux-mips.org, wim@iguana.be, mm-commits@vger.kernel.org


The patch titled
     TXx9 watchdog support for rbhma3100,rbhma4200,rbhma4500
has been removed from the -mm tree.  Its filename was
     txx9-watchdog-support-for-rbhma3100rbhma4200rbhma4500.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: TXx9 watchdog support for rbhma3100,rbhma4200,rbhma4500
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>

Add support for txx9wdt driver to rbhma3100, rbhma4200 and rbhma4500
platform.

Signed-off-by: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Wim Van Sebroeck <wim@iguana.be>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mips/configs/jmr3927_defconfig                        |   15 ++
 arch/mips/configs/rbhma4200_defconfig                      |   15 ++
 arch/mips/configs/rbhma4500_defconfig                      |   15 ++
 arch/mips/jmr3927/rbhma3100/setup.c                        |   55 ++++++++++
 arch/mips/tx4927/toshiba_rbtx4927/toshiba_rbtx4927_setup.c |   55 ++++++++++
 arch/mips/tx4938/toshiba_rbtx4938/setup.c                  |   25 ++++
 include/asm-mips/tx4927/tx4927_pci.h                       |    1 
 7 files changed, 178 insertions(+), 3 deletions(-)

diff -puN arch/mips/configs/jmr3927_defconfig~txx9-watchdog-support-for-rbhma3100rbhma4200rbhma4500 arch/mips/configs/jmr3927_defconfig
--- a/arch/mips/configs/jmr3927_defconfig~txx9-watchdog-support-for-rbhma3100rbhma4200rbhma4500
+++ a/arch/mips/configs/jmr3927_defconfig
@@ -464,7 +464,6 @@ CONFIG_SERIAL_TXX9_STDSERIAL=y
 CONFIG_LEGACY_PTYS=y
 CONFIG_LEGACY_PTY_COUNT=256
 # CONFIG_IPMI_HANDLER is not set
-# CONFIG_WATCHDOG is not set
 # CONFIG_HW_RANDOM is not set
 # CONFIG_RTC is not set
 # CONFIG_R3964 is not set
@@ -482,6 +481,20 @@ CONFIG_DEVPORT=y
 # CONFIG_W1 is not set
 # CONFIG_POWER_SUPPLY is not set
 # CONFIG_HWMON is not set
+CONFIG_WATCHDOG=y
+# CONFIG_WATCHDOG_NOWAYOUT is not set
+
+#
+# Watchdog Device Drivers
+#
+# CONFIG_SOFT_WATCHDOG is not set
+CONFIG_TXX9_WDT=y
+
+#
+# PCI-based Watchdog Cards
+#
+# CONFIG_PCIPCWATCHDOG is not set
+# CONFIG_WDTPCI is not set
 
 #
 # Multifunction device drivers
diff -puN arch/mips/configs/rbhma4200_defconfig~txx9-watchdog-support-for-rbhma3100rbhma4200rbhma4500 arch/mips/configs/rbhma4200_defconfig
--- a/arch/mips/configs/rbhma4200_defconfig~txx9-watchdog-support-for-rbhma3100rbhma4200rbhma4500
+++ a/arch/mips/configs/rbhma4200_defconfig
@@ -431,7 +431,6 @@ CONFIG_UNIX98_PTYS=y
 CONFIG_LEGACY_PTYS=y
 CONFIG_LEGACY_PTY_COUNT=256
 # CONFIG_IPMI_HANDLER is not set
-# CONFIG_WATCHDOG is not set
 # CONFIG_HW_RANDOM is not set
 # CONFIG_RTC is not set
 # CONFIG_R3964 is not set
@@ -449,6 +448,20 @@ CONFIG_DEVPORT=y
 # CONFIG_W1 is not set
 # CONFIG_POWER_SUPPLY is not set
 # CONFIG_HWMON is not set
+CONFIG_WATCHDOG=y
+# CONFIG_WATCHDOG_NOWAYOUT is not set
+
+#
+# Watchdog Device Drivers
+#
+# CONFIG_SOFT_WATCHDOG is not set
+CONFIG_TXX9_WDT=m
+
+#
+# PCI-based Watchdog Cards
+#
+# CONFIG_PCIPCWATCHDOG is not set
+# CONFIG_WDTPCI is not set
 
 #
 # Multifunction device drivers
diff -puN arch/mips/configs/rbhma4500_defconfig~txx9-watchdog-support-for-rbhma3100rbhma4200rbhma4500 arch/mips/configs/rbhma4500_defconfig
--- a/arch/mips/configs/rbhma4500_defconfig~txx9-watchdog-support-for-rbhma3100rbhma4200rbhma4500
+++ a/arch/mips/configs/rbhma4500_defconfig
@@ -450,7 +450,6 @@ CONFIG_UNIX98_PTYS=y
 CONFIG_LEGACY_PTYS=y
 CONFIG_LEGACY_PTY_COUNT=256
 # CONFIG_IPMI_HANDLER is not set
-# CONFIG_WATCHDOG is not set
 # CONFIG_HW_RANDOM is not set
 # CONFIG_RTC is not set
 # CONFIG_R3964 is not set
@@ -479,6 +478,20 @@ CONFIG_SPI_AT25=y
 # CONFIG_W1 is not set
 # CONFIG_POWER_SUPPLY is not set
 # CONFIG_HWMON is not set
+CONFIG_WATCHDOG=y
+# CONFIG_WATCHDOG_NOWAYOUT is not set
+
+#
+# Watchdog Device Drivers
+#
+# CONFIG_SOFT_WATCHDOG is not set
+CONFIG_TXX9_WDT=m
+
+#
+# PCI-based Watchdog Cards
+#
+# CONFIG_PCIPCWATCHDOG is not set
+# CONFIG_WDTPCI is not set
 
 #
 # Multifunction device drivers
diff -puN arch/mips/jmr3927/rbhma3100/setup.c~txx9-watchdog-support-for-rbhma3100rbhma4200rbhma4500 arch/mips/jmr3927/rbhma3100/setup.c
--- a/arch/mips/jmr3927/rbhma3100/setup.c~txx9-watchdog-support-for-rbhma3100rbhma4200rbhma4500
+++ a/arch/mips/jmr3927/rbhma3100/setup.c
@@ -35,6 +35,7 @@
 #include <linux/delay.h>
 #include <linux/pm.h>
 #include <linux/platform_device.h>
+#include <linux/clk.h>
 #ifdef CONFIG_SERIAL_TXX9
 #include <linux/serial_core.h>
 #endif
@@ -233,6 +234,8 @@ static void __init tx3927_setup(void)
 	tx3927_ccfgptr->ccfg &= ~TX3927_CCFG_BEOW;
 	/* Disable PCI snoop */
 	tx3927_ccfgptr->ccfg &= ~TX3927_CCFG_PSNP;
+	/* do reset on watchdog */
+	tx3927_ccfgptr->ccfg |= TX3927_CCFG_WR;
 
 #ifdef DO_WRITE_THROUGH
 	/* Enable PCI SNOOP - with write through only */
@@ -383,3 +386,55 @@ static int __init jmr3927_rtc_init(void)
 	return IS_ERR(dev) ? PTR_ERR(dev) : 0;
 }
 device_initcall(jmr3927_rtc_init);
+
+/* Watchdog support */
+
+static int __init txx9_wdt_init(unsigned long base)
+{
+	struct resource res = {
+		.start	= base,
+		.end	= base + 0x100 - 1,
+		.flags	= IORESOURCE_MEM,
+	};
+	struct platform_device *dev =
+		platform_device_register_simple("txx9wdt", -1, &res, 1);
+	return IS_ERR(dev) ? PTR_ERR(dev) : 0;
+}
+
+static int __init jmr3927_wdt_init(void)
+{
+	return txx9_wdt_init(TX3927_TMR_REG(2));
+}
+device_initcall(jmr3927_wdt_init);
+
+/* Minimum CLK support */
+
+struct clk *clk_get(struct device *dev, const char *id)
+{
+	if (!strcmp(id, "imbus_clk"))
+		return (struct clk *)JMR3927_IMCLK;
+	return ERR_PTR(-ENOENT);
+}
+EXPORT_SYMBOL(clk_get);
+
+int clk_enable(struct clk *clk)
+{
+	return 0;
+}
+EXPORT_SYMBOL(clk_enable);
+
+void clk_disable(struct clk *clk)
+{
+}
+EXPORT_SYMBOL(clk_disable);
+
+unsigned long clk_get_rate(struct clk *clk)
+{
+	return (unsigned long)clk;
+}
+EXPORT_SYMBOL(clk_get_rate);
+
+void clk_put(struct clk *clk)
+{
+}
+EXPORT_SYMBOL(clk_put);
diff -puN arch/mips/tx4927/toshiba_rbtx4927/toshiba_rbtx4927_setup.c~txx9-watchdog-support-for-rbhma3100rbhma4200rbhma4500 arch/mips/tx4927/toshiba_rbtx4927/toshiba_rbtx4927_setup.c
--- a/arch/mips/tx4927/toshiba_rbtx4927/toshiba_rbtx4927_setup.c~txx9-watchdog-support-for-rbhma3100rbhma4200rbhma4500
+++ a/arch/mips/tx4927/toshiba_rbtx4927/toshiba_rbtx4927_setup.c
@@ -50,6 +50,7 @@
 #include <linux/pci.h>
 #include <linux/pm.h>
 #include <linux/platform_device.h>
+#include <linux/clk.h>
 
 #include <asm/bootinfo.h>
 #include <asm/io.h>
@@ -803,6 +804,8 @@ void __init plat_mem_setup(void)
 		}
 
 	/* CCFG */
+	/* do reset on watchdog */
+	tx4927_ccfgptr->ccfg |= TX4927_CCFG_WR;
 	/* enable Timeout BusError */
 	if (tx4927_ccfg_toeon)
 		tx4927_ccfgptr->ccfg |= TX4927_CCFG_TOE;
@@ -944,3 +947,55 @@ static int __init rbtx4927_ne_init(void)
 	return IS_ERR(dev) ? PTR_ERR(dev) : 0;
 }
 device_initcall(rbtx4927_ne_init);
+
+/* Watchdog support */
+
+static int __init txx9_wdt_init(unsigned long base)
+{
+	struct resource res = {
+		.start	= base,
+		.end	= base + 0x100 - 1,
+		.flags	= IORESOURCE_MEM,
+	};
+	struct platform_device *dev =
+		platform_device_register_simple("txx9wdt", -1, &res, 1);
+	return IS_ERR(dev) ? PTR_ERR(dev) : 0;
+}
+
+static int __init rbtx4927_wdt_init(void)
+{
+	return txx9_wdt_init(TX4927_TMR_REG(2) & 0xfffffffffULL);
+}
+device_initcall(rbtx4927_wdt_init);
+
+/* Minimum CLK support */
+
+struct clk *clk_get(struct device *dev, const char *id)
+{
+	if (!strcmp(id, "imbus_clk"))
+		return (struct clk *)50000000;
+	return ERR_PTR(-ENOENT);
+}
+EXPORT_SYMBOL(clk_get);
+
+int clk_enable(struct clk *clk)
+{
+	return 0;
+}
+EXPORT_SYMBOL(clk_enable);
+
+void clk_disable(struct clk *clk)
+{
+}
+EXPORT_SYMBOL(clk_disable);
+
+unsigned long clk_get_rate(struct clk *clk)
+{
+	return (unsigned long)clk;
+}
+EXPORT_SYMBOL(clk_get_rate);
+
+void clk_put(struct clk *clk)
+{
+}
+EXPORT_SYMBOL(clk_put);
diff -puN arch/mips/tx4938/toshiba_rbtx4938/setup.c~txx9-watchdog-support-for-rbhma3100rbhma4200rbhma4500 arch/mips/tx4938/toshiba_rbtx4938/setup.c
--- a/arch/mips/tx4938/toshiba_rbtx4938/setup.c~txx9-watchdog-support-for-rbhma3100rbhma4200rbhma4500
+++ a/arch/mips/tx4938/toshiba_rbtx4938/setup.c
@@ -724,6 +724,8 @@ void __init tx4938_board_setup(void)
 	/* CCFG */
 	/* clear WatchDogReset,BusErrorOnWrite flag (W1C) */
 	tx4938_ccfgptr->ccfg |= TX4938_CCFG_WDRST | TX4938_CCFG_BEOW;
+	/* do reset on watchdog */
+	tx4938_ccfgptr->ccfg |= TX4938_CCFG_WR;
 	/* clear PCIC1 reset */
 	if (tx4938_ccfgptr->clkctr & TX4938_CLKCTR_PCIC1RST)
 		tx4938_ccfgptr->clkctr &= ~TX4938_CLKCTR_PCIC1RST;
@@ -1121,12 +1123,35 @@ static int __init rbtx4938_spi_init(void
 }
 arch_initcall(rbtx4938_spi_init);
 
+/* Watchdog support */
+
+static int __init txx9_wdt_init(unsigned long base)
+{
+	struct resource res = {
+		.start	= base,
+		.end	= base + 0x100 - 1,
+		.flags	= IORESOURCE_MEM,
+		.parent	= &tx4938_reg_resource,
+	};
+	struct platform_device *dev =
+		platform_device_register_simple("txx9wdt", -1, &res, 1);
+	return IS_ERR(dev) ? PTR_ERR(dev) : 0;
+}
+
+static int __init rbtx4938_wdt_init(void)
+{
+	return txx9_wdt_init(TX4938_TMR_REG(2) & 0xfffffffffULL);
+}
+device_initcall(rbtx4938_wdt_init);
+
 /* Minimum CLK support */
 
 struct clk *clk_get(struct device *dev, const char *id)
 {
 	if (!strcmp(id, "spi-baseclk"))
 		return (struct clk *)(txx9_gbus_clock / 2 / 4);
+	if (!strcmp(id, "imbus_clk"))
+		return (struct clk *)(txx9_gbus_clock / 2);
 	return ERR_PTR(-ENOENT);
 }
 EXPORT_SYMBOL(clk_get);
diff -puN include/asm-mips/tx4927/tx4927_pci.h~txx9-watchdog-support-for-rbhma3100rbhma4200rbhma4500 include/asm-mips/tx4927/tx4927_pci.h
--- a/include/asm-mips/tx4927/tx4927_pci.h~txx9-watchdog-support-for-rbhma3100rbhma4200rbhma4500
+++ a/include/asm-mips/tx4927/tx4927_pci.h
@@ -9,6 +9,7 @@
 #define __ASM_TX4927_TX4927_PCI_H
 
 #define TX4927_CCFG_TOE 0x00004000
+#define TX4927_CCFG_WR	0x00008000
 #define TX4927_CCFG_TINTDIS	0x01000000
 
 #define TX4927_PCIMEM      0x08000000
_

Patches currently in -mm which might be from anemo@mba.ocn.ne.jp are

clocksource-make-clocksource_mask-bullet-proof.patch
git-mips.patch
txx9-watchdog-driver.patch
