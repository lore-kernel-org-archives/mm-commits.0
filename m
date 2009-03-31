From: akpm@linux-foundation.org
Subject: + xtensa-s6000-variant.patch added to -mm tree
Date: Mon, 30 Mar 2009 17:00:37 -0700
Message-ID: <200903310000.n2V00boq031506@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45583 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761649AbZCaAEl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 30 Mar 2009 20:04:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jw@emlix.com, chris@zankel.net, dg@emlix.com, os@emlix.com


The patch titled
     xtensa: s6000 variant
has been added to the -mm tree.  Its filename is
     xtensa-s6000-variant.patch

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
Subject: xtensa: s6000 variant
From: Johannes Weiner <jw@emlix.com>

Support for the Xtensa S6000 core variant.

Signed-off-by: Johannes Weiner <jw@emlix.com>
Signed-off-by: Oskar Schirmer <os@emlix.com>
Cc: Oskar Schirmer <os@emlix.com>
Cc: Daniel Glockner <dg@emlix.com>
Cc: Christian Zankel <chris@zankel.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/xtensa/Kconfig                                   |    4 
 arch/xtensa/Makefile                                  |    1 
 arch/xtensa/variants/s6000/Makefile                   |    3 
 arch/xtensa/variants/s6000/include/variant/hardware.h |  259 ++++++++++
 arch/xtensa/variants/s6000/include/variant/irq.h      |    9 
 arch/xtensa/variants/s6000/irq.c                      |   74 ++
 6 files changed, 350 insertions(+)

diff -puN arch/xtensa/Kconfig~xtensa-s6000-variant arch/xtensa/Kconfig
--- a/arch/xtensa/Kconfig~xtensa-s6000-variant
+++ a/arch/xtensa/Kconfig
@@ -73,6 +73,10 @@ config XTENSA_VARIANT_DC232B
 	bool "dc232b - Diamond 232L Standard Core Rev.B (LE)"
 	help
 	This variant refers to Tensilica's Diamond 232L Standard core Rev.B (LE).
+
+config XTENSA_VARIANT_S6000
+	bool "s6000 - Stretch software configurable processor"
+	select VARIANT_IRQ_SWITCH
 endchoice
 
 config MMU
diff -puN arch/xtensa/Makefile~xtensa-s6000-variant arch/xtensa/Makefile
--- a/arch/xtensa/Makefile~xtensa-s6000-variant
+++ a/arch/xtensa/Makefile
@@ -15,6 +15,7 @@
 
 variant-$(CONFIG_XTENSA_VARIANT_FSF)		:= fsf
 variant-$(CONFIG_XTENSA_VARIANT_DC232B)		:= dc232b
+variant-$(CONFIG_XTENSA_VARIANT_S6000)		:= s6000
 variant-$(CONFIG_XTENSA_VARIANT_LINUX_CUSTOM)	:= custom
 
 VARIANT = $(variant-y)
diff -puN /dev/null arch/xtensa/variants/s6000/Makefile
--- /dev/null
+++ a/arch/xtensa/variants/s6000/Makefile
@@ -0,0 +1,3 @@
+# s6000 Makefile
+
+obj-y		+= irq.o
diff -puN /dev/null arch/xtensa/variants/s6000/include/variant/hardware.h
--- /dev/null
+++ a/arch/xtensa/variants/s6000/include/variant/hardware.h
@@ -0,0 +1,259 @@
+#ifndef __XTENSA_S6000_HARDWARE_H
+#define __XTENSA_S6000_HARDWARE_H
+
+#define S6_SCLK			1843200
+
+#define S6_MEM_REG              0x20000000
+#define S6_MEM_EFI              0x33F00000
+#define S6_MEM_PCIE_DATARAM1    0x34000000
+#define S6_MEM_XLMI             0x37F80000
+#define S6_MEM_PIF_DATARAM1     0x37FFC000
+#define S6_MEM_GMAC             0x38000000
+#define S6_MEM_I2S              0x3A000000
+#define S6_MEM_EGIB             0x3C000000
+#define S6_MEM_PCIE_CFG         0x3E000000
+#define S6_MEM_PIF_DATARAM      0x3FFE0000
+#define S6_MEM_XLMI_DATARAM     0x3FFF0000
+#define S6_MEM_DDR              0x40000000
+#define S6_MEM_PCIE_APER        0xC0000000
+#define S6_MEM_AUX              0xF0000000
+
+/* Device addresses */
+
+#define S6_REG_SCB              S6_MEM_REG
+#define S6_REG_NB               (S6_REG_SCB + 0x10000)
+#define S6_REG_LMSDMA           (S6_REG_SCB + 0x20000)
+#define S6_REG_NI               (S6_REG_SCB + 0x30000)
+#define S6_REG_NIDMA            (S6_REG_SCB + 0x40000)
+#define S6_REG_NS               (S6_REG_SCB + 0x50000)
+#define S6_REG_DDR              (S6_REG_SCB + 0x60000)
+#define S6_REG_GREG1            (S6_REG_SCB + 0x70000)
+#define S6_REG_DP               (S6_REG_SCB + 0x80000)
+#define S6_REG_DPDMA            (S6_REG_SCB + 0x90000)
+#define S6_REG_EGIB             (S6_REG_SCB + 0xA0000)
+#define S6_REG_PCIE             (S6_REG_SCB + 0xB0000)
+#define S6_REG_I2S              (S6_REG_SCB + 0xC0000)
+#define S6_REG_GMAC             (S6_REG_SCB + 0xD0000)
+#define S6_REG_HIFDMA           (S6_REG_SCB + 0xE0000)
+#define S6_REG_GREG2            (S6_REG_SCB + 0xF0000)
+
+#define S6_REG_APB              S6_REG_SCB
+#define S6_REG_UART             (S6_REG_APB + 0x0000)
+#define S6_REG_INTC             (S6_REG_APB + 0x2000)
+#define S6_REG_SPI              (S6_REG_APB + 0x3000)
+#define S6_REG_I2C              (S6_REG_APB + 0x4000)
+#define S6_REG_GPIO             (S6_REG_APB + 0x8000)
+
+/* Global register block */
+
+#define S6_GREG1_PLL_LOCKCLEAR	0x000
+#define S6_GREG1_PLL_LOCK_SYS		0
+#define S6_GREG1_PLL_LOCK_IO		1
+#define S6_GREG1_PLL_LOCK_AIM		2
+#define S6_GREG1_PLL_LOCK_DP0		3
+#define S6_GREG1_PLL_LOCK_DP2		4
+#define S6_GREG1_PLL_LOCK_DDR		5
+#define S6_GREG1_PLL_LOCKSTAT	0x004
+#define S6_GREG1_PLL_LOCKSTAT_CURLOCK	0
+#define S6_GREG1_PLL_LOCKSTAT_EVERUNLCK	8
+#define S6_GREG1_PLLSEL		0x010
+#define S6_GREG1_PLLSEL_AIM		0
+#define S6_GREG1_PLLSEL_AIM_DDR2		0
+#define S6_GREG1_PLLSEL_AIM_300MHZ		1
+#define S6_GREG1_PLLSEL_AIM_240MHZ		2
+#define S6_GREG1_PLLSEL_AIM_200MHZ		3
+#define S6_GREG1_PLLSEL_AIM_150MHZ		4
+#define S6_GREG1_PLLSEL_AIM_120MHZ		5
+#define S6_GREG1_PLLSEL_AIM_40MHZ		6
+#define S6_GREG1_PLLSEL_AIM_PLLAIMREF		7
+#define S6_GREG1_PLLSEL_AIM_MASK		7
+#define S6_GREG1_PLLSEL_DDR		8
+#define S6_GREG1_PLLSEL_DDR_HS			0
+#define S6_GREG1_PLLSEL_DDR_333MHZ		1
+#define S6_GREG1_PLLSEL_DDR_250MHZ		2
+#define S6_GREG1_PLLSEL_DDR_200MHZ		3
+#define S6_GREG1_PLLSEL_DDR_167MHZ		4
+#define S6_GREG1_PLLSEL_DDR_100MHZ		5
+#define S6_GREG1_PLLSEL_DDR_33MHZ		6
+#define S6_GREG1_PLLSEL_DDR_PLLIOREF		7
+#define S6_GREG1_PLLSEL_DDR_MASK		7
+#define S6_GREG1_PLLSEL_GMAC		16
+#define S6_GREG1_PLLSEL_GMAC_125MHZ		0
+#define S6_GREG1_PLLSEL_GMAC_25MHZ		1
+#define S6_GREG1_PLLSEL_GMAC_2500KHZ		2
+#define S6_GREG1_PLLSEL_GMAC_EXTERN		3
+#define S6_GREG1_PLLSEL_GMAC_MASK		3
+#define S6_GREG1_PLLSEL_GMII		18
+#define S6_GREG1_PLLSEL_GMII_111MHZ		0
+#define S6_GREG1_PLLSEL_GMII_IOREF		1
+#define S6_GREG1_PLLSEL_GMII_NONE		2
+#define S6_GREG1_PLLSEL_GMII_125MHZ		3
+#define S6_GREG1_PLLSEL_GMII_MASK		3
+#define S6_GREG1_SYSUNLOCKCNT	0x020
+#define S6_GREG1_IOUNLOCKCNT	0x024
+#define S6_GREG1_AIMUNLOCKCNT	0x028
+#define S6_GREG1_DP0UNLOCKCNT	0x02C
+#define S6_GREG1_DP2UNLOCKCNT	0x030
+#define S6_GREG1_DDRUNLOCKCNT	0x034
+#define S6_GREG1_CLKBAL0	0x040
+#define S6_GREG1_CLKBAL0_LSGB		0
+#define S6_GREG1_CLKBAL0_LSPX		8
+#define S6_GREG1_CLKBAL0_MEMDO		16
+#define S6_GREG1_CLKBAL0_HSXT1		24
+#define S6_GREG1_CLKBAL1	0x044
+#define S6_GREG1_CLKBAL1_HSISEF		0
+#define S6_GREG1_CLKBAL1_HSNI		8
+#define S6_GREG1_CLKBAL1_HSNS		16
+#define S6_GREG1_CLKBAL1_HSISEFCFG	24
+#define S6_GREG1_CLKBAL2	0x048
+#define S6_GREG1_CLKBAL2_LSNB		0
+#define S6_GREG1_CLKBAL2_LSSB		8
+#define S6_GREG1_CLKBAL2_LSREST		24
+#define S6_GREG1_CLKBAL3	0x04C
+#define S6_GREG1_CLKBAL3_ISEFXAD	0
+#define S6_GREG1_CLKBAL3_ISEFLMS	8
+#define S6_GREG1_CLKBAL3_ISEFISEF	16
+#define S6_GREG1_CLKBAL3_DDRDD		24
+#define S6_GREG1_CLKBAL4	0x050
+#define S6_GREG1_CLKBAL4_DDRDP		0
+#define S6_GREG1_CLKBAL4_DDRDO		8
+#define S6_GREG1_CLKBAL4_DDRNB		16
+#define S6_GREG1_CLKBAL4_DDRLMS		24
+#define S6_GREG1_BLOCKENA	0x100
+#define S6_GREG1_BLOCK_DDR		0
+#define S6_GREG1_BLOCK_DP		1
+#define S6_GREG1_BLOCK_NSNI		2
+#define S6_GREG1_BLOCK_PCIE		3
+#define S6_GREG1_BLOCK_GMAC		4
+#define S6_GREG1_BLOCK_I2S		5
+#define S6_GREG1_BLOCK_EGIB		6
+#define S6_GREG1_BLOCK_SB		7
+#define S6_GREG1_BLOCK_XT1		8
+#define S6_GREG1_CLKGATE	0x104
+#define S6_GREG1_BGATE_AIMNORTH		9
+#define S6_GREG1_BGATE_AIMEAST		10
+#define S6_GREG1_BGATE_AIMWEST		11
+#define S6_GREG1_BGATE_AIMSOUTH		12
+#define S6_GREG1_CHIPRES	0x108
+#define S6_GREG1_CHIPRES_SOFTRES	0
+#define S6_GREG1_CHIPRES_LOSTLOCK	1
+#define S6_GREG1_RESETCAUSE	0x10C
+#define S6_GREG1_RESETCAUSE_RESETN	0
+#define S6_GREG1_RESETCAUSE_GLOBAL	1
+#define S6_GREG1_RESETCAUSE_WDOGTIMER	2
+#define S6_GREG1_RESETCAUSE_SWCHIP	3
+#define S6_GREG1_RESETCAUSE_PLLSYSLOSS	4
+#define S6_GREG1_RESETCAUSE_PCIE	5
+#define S6_GREG1_RESETCAUSE_CREATEDGLOB	6
+#define S6_GREG1_REFCLOCKCNT	0x110
+#define S6_GREG1_RESETTIMER	0x114
+#define S6_GREG1_NMITIMER	0x118
+#define S6_GREG1_GLOBAL_TIMER	0x11C
+#define S6_GREG1_TIMER0		0x180
+#define S6_GREG1_TIMER1		0x184
+#define S6_GREG1_UARTCLOCKSEL	0x204
+#define S6_GREG1_CHIPVERSPACKG	0x208
+#define S6_GREG1_CHIPVERSPACKG_CHIPVID	0
+#define S6_GREG1_CHIPVERSPACKG_PACKSEL	8
+#define S6_GREG1_ONDIETERMCTRL	0x20C
+#define S6_GREG1_ONDIETERMCTRL_WEST	0
+#define S6_GREG1_ONDIETERMCTRL_NORTH	2
+#define S6_GREG1_ONDIETERMCTRL_EAST	4
+#define S6_GREG1_ONDIETERMCTRL_SOUTH	6
+#define S6_GREG1_ONDIETERMCTRL_NONE		0
+#define S6_GREG1_ONDIETERMCTRL_75OHM		2
+#define S6_GREG1_ONDIETERMCTRL_MASK		3
+#define S6_GREG1_BOOT_CFG0	0x210
+#define S6_GREG1_BOOT_CFG0_AIMSTRONG	1
+#define S6_GREG1_BOOT_CFG0_MINIBOOTDL	2
+#define S6_GREG1_BOOT_CFG0_OCDGPIO8SET	5
+#define S6_GREG1_BOOT_CFG0_OCDGPIOENA	6
+#define S6_GREG1_BOOT_CFG0_DOWNSTREAM	7
+#define S6_GREG1_BOOT_CFG0_PLLSYSDIV	8
+#define S6_GREG1_BOOT_CFG0_PLLSYSDIV_300MHZ	1
+#define S6_GREG1_BOOT_CFG0_PLLSYSDIV_240MHZ	2
+#define S6_GREG1_BOOT_CFG0_PLLSYSDIV_200MHZ	3
+#define S6_GREG1_BOOT_CFG0_PLLSYSDIV_150MHZ	4
+#define S6_GREG1_BOOT_CFG0_PLLSYSDIV_120MHZ	5
+#define S6_GREG1_BOOT_CFG0_PLLSYSDIV_40MHZ	6
+#define S6_GREG1_BOOT_CFG0_PLLSYSDIV_MASK	7
+#define S6_GREG1_BOOT_CFG0_BALHSLMS	12
+#define S6_GREG1_BOOT_CFG0_BALHSNB	18
+#define S6_GREG1_BOOT_CFG0_BALHSXAD	24
+#define S6_GREG1_BOOT_CFG1	0x214
+#define S6_GREG1_BOOT_CFG1_PCIE1LANE	1
+#define S6_GREG1_BOOT_CFG1_MPLLPRESCALE	2
+#define S6_GREG1_BOOT_CFG1_MPLLNCY	4
+#define S6_GREG1_BOOT_CFG1_MPLLNCY5	9
+#define S6_GREG1_BOOT_CFG1_BALHSREST	14
+#define S6_GREG1_BOOT_CFG1_BALHSPSMEMS	20
+#define S6_GREG1_BOOT_CFG1_BALLSGI	26
+#define S6_GREG1_BOOT_CFG2	0x218
+#define S6_GREG1_BOOT_CFG2_PEID		0
+#define S6_GREG1_BOOT_CFG3	0x21C
+#define S6_GREG1_DRAMBUSYHOLDOF	0x220
+#define S6_GREG1_DRAMBUSYHOLDOF_XT0	0
+#define S6_GREG1_DRAMBUSYHOLDOF_XT1	4
+#define S6_GREG1_DRAMBUSYHOLDOF_XT_MASK		7
+#define S6_GREG1_PCIEBAR1SIZE	0x224
+#define S6_GREG1_PCIEBAR2SIZE	0x228
+#define S6_GREG1_PCIEVENDOR	0x22C
+#define S6_GREG1_PCIEDEVICE	0x230
+#define S6_GREG1_PCIEREV	0x234
+#define S6_GREG1_PCIECLASS	0x238
+#define S6_GREG1_XT1DCACHEMISS	0x240
+#define S6_GREG1_XT1ICACHEMISS	0x244
+#define S6_GREG1_HWSEMAPHORE(n)	(0x400 + 4 * (n))
+#define S6_GREG1_HWSEMAPHORE_NB		16
+
+/* peripheral interrupt numbers */
+
+#define S6_INTC_GPIO(n)			(n)		/* 0..3 */
+#define S6_INTC_I2C			4
+#define S6_INTC_SPI			5
+#define S6_INTC_NB_ERR			6
+#define S6_INTC_DMA_LMSERR		7
+#define S6_INTC_DMA_LMSLOWWMRK(n)	(8 + (n))	/* 0..11 */
+#define S6_INTC_DMA_LMSPENDCNT(n)	(20 + (n))	/* 0..11 */
+#define S6_INTC_DMA HOSTLOWWMRK(n)	(32 + (n))	/* 0..6 */
+#define S6_INTC_DMA_HOSTPENDCNT(n)	(39 + (n))	/* 0..6 */
+#define S6_INTC_DMA_HOSTERR		46
+#define S6_INTC_UART(n)			(47 + (n))	/* 0..1 */
+#define S6_INTC_XAD			49
+#define S6_INTC_NI_ERR			50
+#define S6_INTC_NI_INFIFOFULL		51
+#define S6_INTC_DMA_NIERR		52
+#define S6_INTC_DMA_NILOWWMRK(n)	(53 + (n))	/* 0..3 */
+#define S6_INTC_DMA_NIPENDCNT(n)	(57 + (n))	/* 0..3 */
+#define S6_INTC_DDR			61
+#define S6_INTC_NS_ERR			62
+#define S6_INTC_EFI_CFGERR		63
+#define S6_INTC_EFI_ISEFTEST		64
+#define S6_INTC_EFI_WRITEERR		65
+#define S6_INTC_NMI_TIMER		66
+#define S6_INTC_PLLLOCK_SYS		67
+#define S6_INTC_PLLLOCK_IO		68
+#define S6_INTC_PLLLOCK_AIM		69
+#define S6_INTC_PLLLOCK_DP0		70
+#define S6_INTC_PLLLOCK_DP2		71
+#define S6_INTC_I2S_ERR			72
+#define S6_INTC_GMAC_STAT		73
+#define S6_INTC_GMAC_ERR		74
+#define S6_INTC_GIB_ERR			75
+#define S6_INTC_PCIE_ERR		76
+#define S6_INTC_PCIE_MSI(n)		(77 + (n))	/* 0..3 */
+#define S6_INTC_PCIE_INTA		81
+#define S6_INTC_PCIE_INTB		82
+#define S6_INTC_PCIE_INTC		83
+#define S6_INTC_PCIE_INTD		84
+#define S6_INTC_SW(n)			(85 + (n))	/* 0..9 */
+#define S6_INTC_SW_ENABLE(n)		(85 + 256 + (n))
+#define S6_INTC_DMA_DP_ERR		95
+#define S6_INTC_DMA_DPLOWWMRK(n)	(96 + (n))	/* 0..3 */
+#define S6_INTC_DMA_DPPENDCNT(n)	(100 + (n))	/* 0..3 */
+#define S6_INTC_DMA_DPTERMCNT(n)	(104 + (n))	/* 0..3 */
+#define S6_INTC_TIMER0			108
+#define S6_INTC_TIMER1			109
+#define S6_INTC_DMA_HOSTTERMCNT(n)	(110 + (n))	/* 0..6 */
+
+#endif /* __XTENSA_S6000_HARDWARE_H */
diff -puN /dev/null arch/xtensa/variants/s6000/include/variant/irq.h
--- /dev/null
+++ a/arch/xtensa/variants/s6000/include/variant/irq.h
@@ -0,0 +1,9 @@
+#ifndef __XTENSA_S6000_IRQ_H
+#define __XTENSA_S6000_IRQ_H
+
+#define NO_IRQ		(-1)
+
+extern void variant_irq_enable(unsigned int irq);
+extern void variant_irq_disable(unsigned int irq);
+
+#endif /* __XTENSA_S6000_IRQ_H */
diff -puN /dev/null arch/xtensa/variants/s6000/irq.c
--- /dev/null
+++ a/arch/xtensa/variants/s6000/irq.c
@@ -0,0 +1,74 @@
+/*
+ * s6000 irq crossbar
+ *
+ * Copyright (c) 2009 emlix GmbH
+ * Authors:	Johannes Weiner <jw@emlix.com>
+ *		Oskar Schirmer <os@emlix.com>
+ */
+#include <linux/io.h>
+#include <asm/irq.h>
+#include <variant/hardware.h>
+
+/* S6_REG_INTC */
+#define INTC_STATUS	0x000
+#define INTC_RAW	0x010
+#define INTC_STATUS_AG	0x100
+#define INTC_CFG(n)	(0x200 + 4 * (n))
+
+/*
+ * The s6000 has a crossbar that multiplexes interrupt output lines
+ * from the peripherals to input lines on the xtensa core.
+ *
+ * We leave the mapping decisions to the platform as it depends on the
+ * actually connected peripherals which distribution makes sense.
+ */
+extern const signed char *platform_irq_mappings[NR_IRQS];
+
+static unsigned long scp_to_intc_enable[] = {
+#define	TO_INTC_ENABLE(n)	(((n) << 1) + 1)
+	TO_INTC_ENABLE(0),
+	TO_INTC_ENABLE(1),
+	TO_INTC_ENABLE(2),
+	TO_INTC_ENABLE(3),
+	TO_INTC_ENABLE(4),
+	TO_INTC_ENABLE(5),
+	TO_INTC_ENABLE(6),
+	TO_INTC_ENABLE(7),
+	TO_INTC_ENABLE(8),
+	TO_INTC_ENABLE(9),
+	TO_INTC_ENABLE(10),
+	TO_INTC_ENABLE(11),
+	TO_INTC_ENABLE(12),
+	-1,
+	-1,
+	TO_INTC_ENABLE(13),
+	-1,
+	TO_INTC_ENABLE(14),
+	-1,
+	TO_INTC_ENABLE(15),
+#undef	TO_INTC_ENABLE
+};
+
+static void irq_set(unsigned int irq, int enable)
+{
+	unsigned long en;
+	const signed char *m = platform_irq_mappings[irq];
+
+	if (!m)
+		return;
+	en = enable ? scp_to_intc_enable[irq] : 0;
+	while (*m >= 0) {
+		writel(en, S6_REG_INTC + INTC_CFG(*m));
+		m++;
+	}
+}
+
+void variant_irq_enable(unsigned int irq)
+{
+	irq_set(irq, 1);
+}
+
+void variant_irq_disable(unsigned int irq)
+{
+	irq_set(irq, 0);
+}
_

Patches currently in -mm which might be from jw@emlix.com are

xtensa-enforce-slab-alignment-to-maximum-register-width.patch
xtensa-add-flat-support.patch
xtensa-add-flat-support-checkpatch-fixes.patch
xtensa-nommu-support.patch
xtensa-variant-specific-code.patch
xtensa-variant-irq-set-callbacks.patch
xtensa-s6000-variant-core-definitions.patch
xtensa-s6000-variant.patch
xtensa-s6000-gpio-driver.patch
xtensa-let-platform-override-kerneloffset.patch
xtensa-platform-stretch-s6105-eval-board.patch
xtensa-cache-inquiry-and-unaligned-cache-handling-functions.patch
xtensa-allow-platform-and-variant-to-initialize-own-irq-chips.patch
xtensa-support-s6000-gpio-irqs-and-alternate-function-selection.patch
s6gmac-xtensa-s6000-on-chip-ethernet-driver.patch
xtensa-s6105-specific-configuration-for-s6gmac.patch
xtensa-enable-s6gmac-in-s6105_defconfig.patch
flat-fix-data-sections-alignment.patch
flat-fix-data-sections-alignment-update.patch

