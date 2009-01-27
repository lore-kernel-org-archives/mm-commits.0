From: akpm@linux-foundation.org
Subject: + mtd-txx9-add-ndfmc-support.patch added to -mm tree
Date: Tue, 27 Jan 2009 13:19:45 -0800
Message-ID: <200901272119.n0RLJjff003045@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40736 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751756AbZA0VUb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 27 Jan 2009 16:20:31 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: anemo@mba.ocn.ne.jp, dwmw2@infradead.org, ralf@linux-mips.org


The patch titled
     mtd: TXx9: add NDFMC support
has been added to the -mm tree.  Its filename is
     mtd-txx9-add-ndfmc-support.patch

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
Subject: mtd: TXx9: add NDFMC support
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>

Add platform support for NAND Flash Memory Controller of TXx9 SoCs.

Signed-off-by: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mips/include/asm/txx9/ndfmc.h    |   30 ++++++++++++++++++++++++
 arch/mips/include/asm/txx9/tx4938.h   |    1 
 arch/mips/include/asm/txx9/tx4939.h   |    2 +
 arch/mips/txx9/generic/setup.c        |   21 ++++++++++++++++
 arch/mips/txx9/generic/setup_tx4938.c |   21 ++++++++++++++++
 arch/mips/txx9/generic/setup_tx4939.c |   17 +++++++++++++
 arch/mips/txx9/rbtx4938/setup.c       |    2 +
 arch/mips/txx9/rbtx4939/setup.c       |    4 +++
 8 files changed, 98 insertions(+)

diff -puN /dev/null arch/mips/include/asm/txx9/ndfmc.h
--- /dev/null
+++ a/arch/mips/include/asm/txx9/ndfmc.h
@@ -0,0 +1,30 @@
+/*
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * (C) Copyright TOSHIBA CORPORATION 2007
+ */
+#ifndef __ASM_TXX9_NDFMC_H
+#define __ASM_TXX9_NDFMC_H
+
+#define NDFMC_PLAT_FLAG_USE_BSPRT	0x01
+#define NDFMC_PLAT_FLAG_NO_RSTR		0x02
+#define NDFMC_PLAT_FLAG_HOLDADD		0x04
+#define NDFMC_PLAT_FLAG_DUMMYWRITE	0x08
+
+struct txx9ndfmc_platform_data {
+	unsigned int shift;
+	unsigned int gbus_clock;
+	unsigned int hold;		/* hold time in nanosecond */
+	unsigned int spw;		/* strobe pulse width in nanosecond */
+	unsigned int flags;
+	unsigned char ch_mask;		/* available channel bitmask */
+	unsigned char wp_mask;		/* write-protect bitmask */
+	unsigned char wide_mask;	/* 16bit-nand bitmask */
+};
+
+void txx9_ndfmc_init(unsigned long baseaddr,
+		     const struct txx9ndfmc_platform_data *plat_data);
+
+#endif /* __ASM_TXX9_NDFMC_H */
diff -puN arch/mips/include/asm/txx9/tx4938.h~mtd-txx9-add-ndfmc-support arch/mips/include/asm/txx9/tx4938.h
--- a/arch/mips/include/asm/txx9/tx4938.h~mtd-txx9-add-ndfmc-support
+++ a/arch/mips/include/asm/txx9/tx4938.h
@@ -291,6 +291,7 @@ int tx4938_pcic1_map_irq(const struct pc
 void tx4938_setup_pcierr_irq(void);
 void tx4938_irq_init(void);
 void tx4938_mtd_init(int ch);
+void tx4938_ndfmc_init(unsigned int hold, unsigned int spw);
 
 struct tx4938ide_platform_info {
 	/*
diff -puN arch/mips/include/asm/txx9/tx4939.h~mtd-txx9-add-ndfmc-support arch/mips/include/asm/txx9/tx4939.h
--- a/arch/mips/include/asm/txx9/tx4939.h~mtd-txx9-add-ndfmc-support
+++ a/arch/mips/include/asm/txx9/tx4939.h
@@ -541,5 +541,7 @@ void tx4939_irq_init(void);
 int tx4939_irq(void);
 void tx4939_mtd_init(int ch);
 void tx4939_ata_init(void);
+void tx4939_ndfmc_init(unsigned int hold, unsigned int spw,
+		       unsigned char ch_mask, unsigned char wide_mask);
 
 #endif /* __ASM_TXX9_TX4939_H */
diff -puN arch/mips/txx9/generic/setup.c~mtd-txx9-add-ndfmc-support arch/mips/txx9/generic/setup.c
--- a/arch/mips/txx9/generic/setup.c~mtd-txx9-add-ndfmc-support
+++ a/arch/mips/txx9/generic/setup.c
@@ -32,6 +32,7 @@
 #include <asm/txx9/generic.h>
 #include <asm/txx9/pci.h>
 #include <asm/txx9tmr.h>
+#include <asm/txx9/ndfmc.h>
 #ifdef CONFIG_CPU_TX49XX
 #include <asm/txx9/tx4938.h>
 #endif
@@ -691,6 +692,26 @@ void __init txx9_physmap_flash_init(int 
 #endif
 }
 
+void __init txx9_ndfmc_init(unsigned long baseaddr,
+			    const struct txx9ndfmc_platform_data *pdata)
+{
+#if defined(CONFIG_MTD_NAND_TXX9NDFMC) || \
+	defined(CONFIG_MTD_NAND_TXX9NDFMC_MODULE)
+	struct resource res = {
+		.start = baseaddr,
+		.end = baseaddr + 0x1000 - 1,
+		.flags = IORESOURCE_MEM,
+	};
+	struct platform_device *pdev = platform_device_alloc("txx9ndfmc", -1);
+
+	if (!pdev ||
+	    platform_device_add_resources(pdev, &res, 1) ||
+	    platform_device_add_data(pdev, pdata, sizeof(*pdata)) ||
+	    platform_device_add(pdev))
+		platform_device_put(pdev);
+#endif
+}
+
 #if defined(CONFIG_LEDS_GPIO) || defined(CONFIG_LEDS_GPIO_MODULE)
 static DEFINE_SPINLOCK(txx9_iocled_lock);
 
diff -puN arch/mips/txx9/generic/setup_tx4938.c~mtd-txx9-add-ndfmc-support arch/mips/txx9/generic/setup_tx4938.c
--- a/arch/mips/txx9/generic/setup_tx4938.c~mtd-txx9-add-ndfmc-support
+++ a/arch/mips/txx9/generic/setup_tx4938.c
@@ -23,6 +23,7 @@
 #include <asm/txx9tmr.h>
 #include <asm/txx9pio.h>
 #include <asm/txx9/generic.h>
+#include <asm/txx9/ndfmc.h>
 #include <asm/txx9/tx4938.h>
 
 static void __init tx4938_wdr_init(void)
@@ -382,6 +383,26 @@ void __init tx4938_ata_init(unsigned int
 		platform_device_put(pdev);
 }
 
+void __init tx4938_ndfmc_init(unsigned int hold, unsigned int spw)
+{
+	struct txx9ndfmc_platform_data plat_data = {
+		.shift = 1,
+		.gbus_clock = txx9_gbus_clock,
+		.hold = hold,
+		.spw = spw,
+		.ch_mask = 1,
+	};
+	unsigned long baseaddr = TX4938_NDFMC_REG & 0xfffffffffULL;
+
+#ifdef __BIG_ENDIAN
+	baseaddr += 4;
+#endif
+	if ((__raw_readq(&tx4938_ccfgptr->pcfg) &
+	     (TX4938_PCFG_ATA_SEL|TX4938_PCFG_ISA_SEL|TX4938_PCFG_NDF_SEL)) ==
+	    TX4938_PCFG_NDF_SEL)
+		txx9_ndfmc_init(baseaddr, &plat_data);
+}
+
 static void __init tx4938_stop_unused_modules(void)
 {
 	__u64 pcfg, rst = 0, ckd = 0;
diff -puN arch/mips/txx9/generic/setup_tx4939.c~mtd-txx9-add-ndfmc-support arch/mips/txx9/generic/setup_tx4939.c
--- a/arch/mips/txx9/generic/setup_tx4939.c~mtd-txx9-add-ndfmc-support
+++ a/arch/mips/txx9/generic/setup_tx4939.c
@@ -27,6 +27,7 @@
 #include <asm/txx9irq.h>
 #include <asm/txx9tmr.h>
 #include <asm/txx9/generic.h>
+#include <asm/txx9/ndfmc.h>
 #include <asm/txx9/tx4939.h>
 
 static void __init tx4939_wdr_init(void)
@@ -435,6 +436,22 @@ void __init tx4939_ata_init(void)
 		platform_device_register(&ata1_dev);
 }
 
+void __init tx4939_ndfmc_init(unsigned int hold, unsigned int spw,
+			      unsigned char ch_mask, unsigned char wide_mask)
+{
+	struct txx9ndfmc_platform_data plat_data = {
+		.shift = 1,
+		.gbus_clock = txx9_gbus_clock,
+		.hold = hold,
+		.spw = spw,
+		.flags = NDFMC_PLAT_FLAG_NO_RSTR | NDFMC_PLAT_FLAG_HOLDADD |
+			 NDFMC_PLAT_FLAG_DUMMYWRITE,
+		.ch_mask = ch_mask,
+		.wide_mask = wide_mask,
+	};
+	txx9_ndfmc_init(TX4939_NDFMC_REG & 0xfffffffffULL, &plat_data);
+}
+
 static void __init tx4939_stop_unused_modules(void)
 {
 	__u64 pcfg, rst = 0, ckd = 0;
diff -puN arch/mips/txx9/rbtx4938/setup.c~mtd-txx9-add-ndfmc-support arch/mips/txx9/rbtx4938/setup.c
--- a/arch/mips/txx9/rbtx4938/setup.c~mtd-txx9-add-ndfmc-support
+++ a/arch/mips/txx9/rbtx4938/setup.c
@@ -352,6 +352,8 @@ static void __init rbtx4938_device_init(
 	rbtx4938_ne_init();
 	tx4938_wdt_init();
 	rbtx4938_mtd_init();
+	/* TC58DVM82A1FT: tDH=10ns, tWP=tRP=tREADID=35ns */
+	tx4938_ndfmc_init(10, 35);
 	tx4938_ata_init(RBTX4938_IRQ_IOC_ATA, 0, 1);
 	txx9_iocled_init(RBTX4938_LED_ADDR - IO_BASE, -1, 8, 1, "green", NULL);
 }
diff -puN arch/mips/txx9/rbtx4939/setup.c~mtd-txx9-add-ndfmc-support arch/mips/txx9/rbtx4939/setup.c
--- a/arch/mips/txx9/rbtx4939/setup.c~mtd-txx9-add-ndfmc-support
+++ a/arch/mips/txx9/rbtx4939/setup.c
@@ -333,6 +333,10 @@ static void __init rbtx4939_device_init(
 	    platform_device_add_data(pdev, &smc_pdata, sizeof(smc_pdata)) ||
 	    platform_device_add(pdev))
 		platform_device_put(pdev);
+	/* TC58DVM82A1FT: tDH=10ns, tWP=tRP=tREADID=35ns */
+	tx4939_ndfmc_init(10, 35,
+			  (1 << 1) | (1 << 2),
+			  (1 << 2)); /* ch1:8bit, ch2:16bit */
 	rbtx4939_led_setup();
 	tx4939_wdt_init();
 	tx4939_ata_init();
_

Patches currently in -mm which might be from anemo@mba.ocn.ne.jp are

origin.patch
linux-next.patch
mtd-txx9-add-ndfmc-support.patch
mtd-rbtx4939-add-mtd-support.patch
mtd-rbtx4939-add-mtd-support-fix.patch
mtd-txx9-soc-nand-flash-memory-controller-driver.patch
mtd-rbtx4939-map-driver.patch
atmel_serial-might-lose-modem-status-change.patch

