From: akpm@linux-foundation.org
Subject: [wrecked] arm-convert-arm-to-arch_gettimeoffset.patch removed from -mm tree
Date: Thu, 18 Mar 2010 11:02:59 -0400
Message-ID: <201003181803.o2II3evH007326@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60682 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751313Ab0CRSEf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Mar 2010 14:04:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: johnstul@us.ibm.com, rmk@arm.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     arm: convert arm to arch_gettimeoffset()
has been removed from the -mm tree.  Its filename was
     arm-convert-arm-to-arch_gettimeoffset.patch

This patch was dropped because other changes were merged, which wrecked this patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: arm: convert arm to arch_gettimeoffset()
From: john stultz <johnstul@us.ibm.com>

Convert arm to use GENERIC_TIME via the arch_getoffset() infrastructure,
reducing the amount of arch specific code we need to maintain.

The arm architecture is one of the last 2 arches that need to be
converted.

Signed-off-by: John Stultz <johnstul@us.ibm.com>
Cc: Russell King <rmk@arm.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/Kconfig                 |   52 ++++++++++-----------
 arch/arm/include/asm/mach/time.h |    2 
 arch/arm/kernel/time.c           |   70 ++---------------------------
 arch/arm/mach-at91/Kconfig       |   11 ----
 4 files changed, 34 insertions(+), 101 deletions(-)

diff -puN arch/arm/Kconfig~arm-convert-arm-to-arch_gettimeoffset arch/arm/Kconfig
--- a/arch/arm/Kconfig~arm-convert-arm-to-arch_gettimeoffset
+++ a/arch/arm/Kconfig
@@ -42,6 +42,11 @@ config GENERIC_GPIO
 
 config GENERIC_TIME
 	bool
+	default y
+
+config ARCH_USES_GETTIMEOFFSET
+	bool
+	default n
 
 config GENERIC_CLOCKEVENTS
 	bool
@@ -227,6 +232,7 @@ config ARCH_AAEC2000
 	select CPU_ARM920T
 	select ARM_AMBA
 	select HAVE_CLK
+	select ARCH_USES_GETTIMEOFFSET
 	help
 	  This enables support for systems based on the Agilent AAEC-2000
 
@@ -237,7 +243,6 @@ config ARCH_INTEGRATOR
 	select HAVE_CLK
 	select COMMON_CLKDEV
 	select ICST
-	select GENERIC_TIME
 	select GENERIC_CLOCKEVENTS
 	select PLAT_VERSATILE
 	help
@@ -249,7 +254,6 @@ config ARCH_REALVIEW
 	select HAVE_CLK
 	select COMMON_CLKDEV
 	select ICST
-	select GENERIC_TIME
 	select GENERIC_CLOCKEVENTS
 	select ARCH_WANT_OPTIONAL_GPIOLIB
 	select PLAT_VERSATILE
@@ -264,7 +268,6 @@ config ARCH_VERSATILE
 	select HAVE_CLK
 	select COMMON_CLKDEV
 	select ICST
-	select GENERIC_TIME
 	select GENERIC_CLOCKEVENTS
 	select ARCH_WANT_OPTIONAL_GPIOLIB
 	select PLAT_VERSATILE
@@ -279,7 +282,6 @@ config ARCH_VEXPRESS
 	select ARM_TIMER_SP804
 	select COMMON_CLKDEV
 	select GENERIC_CLOCKEVENTS
-	select GENERIC_TIME
 	select HAVE_CLK
 	select ICST
 	select PLAT_VERSATILE
@@ -291,6 +293,7 @@ config ARCH_AT91
 	select GENERIC_GPIO
 	select ARCH_REQUIRE_GPIOLIB
 	select HAVE_CLK
+	select ARCH_USES_GETTIMEOFFSET
 	help
 	  This enables support for systems based on the Atmel AT91RM9200,
 	  AT91SAM9 and AT91CAP9 processors.
@@ -298,6 +301,7 @@ config ARCH_AT91
 config ARCH_CLPS711X
 	bool "Cirrus Logic CLPS711x/EP721x-based"
 	select CPU_ARM720T
+	select ARCH_USES_GETTIMEOFFSET
 	help
 	  Support for Cirrus Logic 711x/721x based boards.
 
@@ -306,6 +310,7 @@ config ARCH_GEMINI
 	select CPU_FA526
 	select GENERIC_GPIO
 	select ARCH_REQUIRE_GPIOLIB
+	select ARCH_USES_GETTIMEOFFSET
 	help
 	  Support for the Cortina Systems Gemini family SoCs
 
@@ -314,6 +319,7 @@ config ARCH_EBSA110
 	select CPU_SA110
 	select ISA
 	select NO_IOPORT
+	select ARCH_USES_GETTIMEOFFSET
 	help
 	  This is an evaluation board for the StrongARM processor available
 	  from Digital. It has limited hardware on-board, including an
@@ -330,6 +336,7 @@ config ARCH_EP93XX
 	select COMMON_CLKDEV
 	select ARCH_REQUIRE_GPIOLIB
 	select ARCH_HAS_HOLES_MEMORYMODEL
+	select ARCH_USES_GETTIMEOFFSET
 	help
 	  This enables support for the Cirrus EP93xx series of CPUs.
 
@@ -337,13 +344,13 @@ config ARCH_FOOTBRIDGE
 	bool "FootBridge"
 	select CPU_SA110
 	select FOOTBRIDGE
+	select ARCH_USES_GETTIMEOFFSET
 	help
 	  Support for systems based on the DC21285 companion chip
 	  ("FootBridge"), such as the Simtec CATS and the Rebel NetWinder.
 
 config ARCH_MXC
 	bool "Freescale MXC/iMX-based"
-	select GENERIC_TIME
 	select GENERIC_CLOCKEVENTS
 	select ARCH_REQUIRE_GPIOLIB
 	select HAVE_CLK
@@ -357,7 +364,6 @@ config ARCH_STMP3XXX
 	select HAVE_CLK
 	select COMMON_CLKDEV
 	select ARCH_REQUIRE_GPIOLIB
-	select GENERIC_TIME
 	select GENERIC_CLOCKEVENTS
 	select GENERIC_GPIO
 	select USB_ARCH_HAS_EHCI
@@ -369,7 +375,6 @@ config ARCH_NETX
 	select CPU_ARM926T
 	select ARM_VIC
 	select GENERIC_CLOCKEVENTS
-	select GENERIC_TIME
 	help
 	  This enables support for systems based on the Hilscher NetX Soc
 
@@ -377,6 +382,7 @@ config ARCH_H720X
 	bool "Hynix HMS720x-based"
 	select CPU_ARM720T
 	select ISA_DMA_API
+	select ARCH_USES_GETTIMEOFFSET
 	help
 	  This enables support for systems based on the Hynix HMS720x
 
@@ -387,7 +393,6 @@ config ARCH_NOMADIK
 	select CPU_ARM926T
 	select HAVE_CLK
 	select COMMON_CLKDEV
-	select GENERIC_TIME
 	select GENERIC_CLOCKEVENTS
 	select GENERIC_GPIO
 	select ARCH_REQUIRE_GPIOLIB
@@ -402,6 +407,7 @@ config ARCH_IOP13XX
 	select PCI
 	select ARCH_SUPPORTS_MSI
 	select VMSPLIT_1G
+	select ARCH_USES_GETTIMEOFFSET
 	help
 	  Support for Intel's IOP13XX (XScale) family of processors.
 
@@ -413,6 +419,7 @@ config ARCH_IOP32X
 	select PCI
 	select GENERIC_GPIO
 	select ARCH_REQUIRE_GPIOLIB
+	select ARCH_USES_GETTIMEOFFSET
 	help
 	  Support for Intel's 80219 and IOP32X (XScale) family of
 	  processors.
@@ -425,6 +432,7 @@ config ARCH_IOP33X
 	select PCI
 	select GENERIC_GPIO
 	select ARCH_REQUIRE_GPIOLIB
+	select ARCH_USES_GETTIMEOFFSET
 	help
 	  Support for Intel's IOP33X (XScale) family of processors.
 
@@ -433,6 +441,7 @@ config ARCH_IXP23XX
 	depends on MMU
 	select CPU_XSC3
  	select PCI
+	select ARCH_USES_GETTIMEOFFSET
 	help
 	  Support for Intel's IXP23xx (XScale) family of processors.
 
@@ -441,6 +450,7 @@ config ARCH_IXP2000
 	depends on MMU
 	select CPU_XSCALE
 	select PCI
+	select ARCH_USES_GETTIMEOFFSET
 	help
 	  Support for Intel's IXP2400/2800 (XScale) family of processors.
 
@@ -449,7 +459,6 @@ config ARCH_IXP4XX
 	depends on MMU
 	select CPU_XSCALE
 	select GENERIC_GPIO
-	select GENERIC_TIME
 	select GENERIC_CLOCKEVENTS
 	select DMABOUNCE if PCI
 	help
@@ -459,6 +468,7 @@ config ARCH_L7200
 	bool "LinkUp-L7200"
 	select CPU_ARM720T
 	select FIQ
+	select ARCH_USES_GETTIMEOFFSET
 	help
 	  Say Y here if you intend to run this kernel on a LinkUp Systems
 	  L7200 Software Development Board which uses an ARM720T processor.
@@ -474,7 +484,6 @@ config ARCH_DOVE
 	select PCI
 	select GENERIC_GPIO
 	select ARCH_REQUIRE_GPIOLIB
-	select GENERIC_TIME
 	select GENERIC_CLOCKEVENTS
 	select PLAT_ORION
 	help
@@ -486,7 +495,6 @@ config ARCH_KIRKWOOD
 	select PCI
 	select GENERIC_GPIO
 	select ARCH_REQUIRE_GPIOLIB
-	select GENERIC_TIME
 	select GENERIC_CLOCKEVENTS
 	select PLAT_ORION
 	help
@@ -496,7 +504,6 @@ config ARCH_KIRKWOOD
 config ARCH_LOKI
 	bool "Marvell Loki (88RC8480)"
 	select CPU_FEROCEON
-	select GENERIC_TIME
 	select GENERIC_CLOCKEVENTS
 	select PLAT_ORION
 	help
@@ -508,7 +515,6 @@ config ARCH_MV78XX0
 	select PCI
 	select GENERIC_GPIO
 	select ARCH_REQUIRE_GPIOLIB
-	select GENERIC_TIME
 	select GENERIC_CLOCKEVENTS
 	select PLAT_ORION
 	help
@@ -522,7 +528,6 @@ config ARCH_ORION5X
 	select PCI
 	select GENERIC_GPIO
 	select ARCH_REQUIRE_GPIOLIB
-	select GENERIC_TIME
 	select GENERIC_CLOCKEVENTS
 	select PLAT_ORION
 	help
@@ -537,7 +542,6 @@ config ARCH_MMP
 	select ARCH_REQUIRE_GPIOLIB
 	select HAVE_CLK
 	select COMMON_CLKDEV
-	select GENERIC_TIME
 	select GENERIC_CLOCKEVENTS
 	select TICK_ONESHOT
 	select PLAT_PXA
@@ -549,6 +553,7 @@ config ARCH_KS8695
 	select CPU_ARM922T
 	select GENERIC_GPIO
         select ARCH_REQUIRE_GPIOLIB
+	select ARCH_USES_GETTIMEOFFSET
 	help
 	  Support for Micrel/Kendin KS8695 "Centaur" (ARM922T) based
 	  System-on-Chip devices.
@@ -557,7 +562,6 @@ config ARCH_NS9XXX
 	bool "NetSilicon NS9xxx"
 	select CPU_ARM926T
 	select GENERIC_GPIO
-	select GENERIC_TIME
 	select GENERIC_CLOCKEVENTS
 	select HAVE_CLK
 	help
@@ -573,7 +577,6 @@ config ARCH_W90X900
 	select GENERIC_GPIO
 	select HAVE_CLK
 	select COMMON_CLKDEV
-	select GENERIC_TIME
 	select GENERIC_CLOCKEVENTS
 	help
 	  Support for Nuvoton (Winbond logic dept.) ARM9 processor,
@@ -598,6 +601,7 @@ config ARCH_PNX4008
 	select CPU_ARM926T
 	select HAVE_CLK
 	select COMMON_CLKDEV
+	select ARCH_USES_GETTIMEOFFSET
 	help
 	  This enables support for Philips PNX4008 mobile platform.
 
@@ -610,7 +614,6 @@ config ARCH_PXA
 	select HAVE_CLK
 	select COMMON_CLKDEV
 	select ARCH_REQUIRE_GPIOLIB
-	select GENERIC_TIME
 	select GENERIC_CLOCKEVENTS
 	select TICK_ONESHOT
 	select PLAT_PXA
@@ -620,7 +623,6 @@ config ARCH_PXA
 config ARCH_MSM
 	bool "Qualcomm MSM"
 	select CPU_V6
-	select GENERIC_TIME
 	select GENERIC_CLOCKEVENTS
 	help
 	  Support for Qualcomm MSM7K based systems.  This runs on the ARM11
@@ -643,6 +645,7 @@ config ARCH_RPC
 	select ISA_DMA_API
 	select NO_IOPORT
 	select ARCH_SPARSEMEM_ENABLE
+	select ARCH_USES_GETTIMEOFFSET
 	help
 	  On the Acorn Risc-PC, Linux can support the internal IDE disk and
 	  CD-ROM interface, serial and parallel port, and the floppy drive.
@@ -656,7 +659,6 @@ config ARCH_SA1100
 	select ARCH_HAS_CPUFREQ
 	select CPU_FREQ
 	select GENERIC_GPIO
-	select GENERIC_TIME
 	select GENERIC_CLOCKEVENTS
 	select HAVE_CLK
 	select TICK_ONESHOT
@@ -669,6 +671,7 @@ config ARCH_S3C2410
 	select GENERIC_GPIO
 	select ARCH_HAS_CPUFREQ
 	select HAVE_CLK
+	select ARCH_USES_GETTIMEOFFSET
 	help
 	  Samsung S3C2410X CPU based systems, such as the Simtec Electronics
 	  BAST (<http://www.simtec.co.uk/products/EB110ITX/>), the IPAQ 1940 or
@@ -681,6 +684,7 @@ config ARCH_S3C64XX
 	select GENERIC_GPIO
 	select ARM_VIC
 	select HAVE_CLK
+	select ARCH_USES_GETTIMEOFFSET
 	select NO_IOPORT
 	select ARCH_HAS_CPUFREQ
 	select ARCH_REQUIRE_GPIOLIB
@@ -738,6 +742,7 @@ config ARCH_SHARK
 	select ISA_DMA
 	select ZONE_DMA
 	select PCI
+	select ARCH_USES_GETTIMEOFFSET
 	help
 	  Support for the StrongARM based Digital DNARD machine, also known
 	  as "Shark" (<http://www.shark-linux.de/shark.html>).
@@ -747,6 +752,7 @@ config ARCH_LH7A40X
 	select CPU_ARM922T
 	select ARCH_DISCONTIGMEM_ENABLE if !LH7A40X_CONTIGMEM
 	select ARCH_SPARSEMEM_ENABLE if !LH7A40X_CONTIGMEM
+	select ARCH_USES_GETTIMEOFFSET
 	help
 	  Say Y here for systems based on one of the Sharp LH7A40X
 	  System on a Chip processors.  These CPUs include an ARM922T
@@ -760,7 +766,6 @@ config ARCH_U300
 	select HAVE_TCM
 	select ARM_AMBA
 	select ARM_VIC
-	select GENERIC_TIME
 	select GENERIC_CLOCKEVENTS
 	select HAVE_CLK
 	select COMMON_CLKDEV
@@ -771,7 +776,6 @@ config ARCH_U300
 config ARCH_DAVINCI
 	bool "TI DaVinci"
 	select CPU_ARM926T
-	select GENERIC_TIME
 	select GENERIC_CLOCKEVENTS
 	select GENERIC_GPIO
 	select ARCH_REQUIRE_GPIOLIB
@@ -790,7 +794,6 @@ config ARCH_OMAP
 	select HAVE_CLK
 	select ARCH_REQUIRE_GPIOLIB
 	select ARCH_HAS_CPUFREQ
-	select GENERIC_TIME
 	select GENERIC_CLOCKEVENTS
 	select ARCH_HAS_HOLES_MEMORYMODEL
 	help
@@ -802,7 +805,6 @@ config ARCH_BCMRING
 	select CPU_V6
 	select ARM_AMBA
 	select COMMON_CLKDEV
-	select GENERIC_TIME
 	select GENERIC_CLOCKEVENTS
 	select ARCH_WANT_OPTIONAL_GPIOLIB
 	help
@@ -812,7 +814,6 @@ config ARCH_U8500
 	bool "ST-Ericsson U8500 Series"
 	select CPU_V7
 	select ARM_AMBA
-	select GENERIC_TIME
 	select GENERIC_CLOCKEVENTS
 	select COMMON_CLKDEV
 	help
@@ -942,7 +943,6 @@ config ARCH_ACORN
 config PLAT_IOP
 	bool
 	select GENERIC_CLOCKEVENTS
-	select GENERIC_TIME
 
 config PLAT_ORION
 	bool
diff -puN arch/arm/include/asm/mach/time.h~arm-convert-arm-to-arch_gettimeoffset arch/arm/include/asm/mach/time.h
--- a/arch/arm/include/asm/mach/time.h~arm-convert-arm-to-arch_gettimeoffset
+++ a/arch/arm/include/asm/mach/time.h
@@ -38,7 +38,7 @@ struct sys_timer {
 	void			(*init)(void);
 	void			(*suspend)(void);
 	void			(*resume)(void);
-#ifndef CONFIG_GENERIC_TIME
+#ifdef CONFIG_ARCH_USES_GETTIMEOFFSET
 	unsigned long		(*offset)(void);
 #endif
 };
diff -puN arch/arm/kernel/time.c~arm-convert-arm-to-arch_gettimeoffset arch/arm/kernel/time.c
--- a/arch/arm/kernel/time.c~arm-convert-arm-to-arch_gettimeoffset
+++ a/arch/arm/kernel/time.c
@@ -72,12 +72,15 @@ unsigned long profile_pc(struct pt_regs 
 EXPORT_SYMBOL(profile_pc);
 #endif
 
-#ifndef CONFIG_GENERIC_TIME
-static unsigned long dummy_gettimeoffset(void)
+#ifdef CONFIG_ARCH_USES_GETTIMEOFFSET
+u32 arch_gettimeoffset(void)
 {
+	if (system_timer->offset != NULL)
+		return system_timer->offset() * 1000;
+
 	return 0;
 }
-#endif
+#endif /* CONFIG_ARCH_USES_GETTIMEOFFSET */
 
 #ifdef CONFIG_LEDS_TIMER
 static inline void do_leds(void)
@@ -93,63 +96,6 @@ static inline void do_leds(void)
 #define	do_leds()
 #endif
 
-#ifndef CONFIG_GENERIC_TIME
-void do_gettimeofday(struct timeval *tv)
-{
-	unsigned long flags;
-	unsigned long seq;
-	unsigned long usec, sec;
-
-	do {
-		seq = read_seqbegin_irqsave(&xtime_lock, flags);
-		usec = system_timer->offset();
-		sec = xtime.tv_sec;
-		usec += xtime.tv_nsec / 1000;
-	} while (read_seqretry_irqrestore(&xtime_lock, seq, flags));
-
-	/* usec may have gone up a lot: be safe */
-	while (usec >= 1000000) {
-		usec -= 1000000;
-		sec++;
-	}
-
-	tv->tv_sec = sec;
-	tv->tv_usec = usec;
-}
-
-EXPORT_SYMBOL(do_gettimeofday);
-
-int do_settimeofday(struct timespec *tv)
-{
-	time_t wtm_sec, sec = tv->tv_sec;
-	long wtm_nsec, nsec = tv->tv_nsec;
-
-	if ((unsigned long)tv->tv_nsec >= NSEC_PER_SEC)
-		return -EINVAL;
-
-	write_seqlock_irq(&xtime_lock);
-	/*
-	 * This is revolting. We need to set "xtime" correctly. However, the
-	 * value in this location is the value at the most recent update of
-	 * wall time.  Discover what correction gettimeofday() would have
-	 * done, and then undo it!
-	 */
-	nsec -= system_timer->offset() * NSEC_PER_USEC;
-
-	wtm_sec  = wall_to_monotonic.tv_sec + (xtime.tv_sec - sec);
-	wtm_nsec = wall_to_monotonic.tv_nsec + (xtime.tv_nsec - nsec);
-
-	set_normalized_timespec(&xtime, sec, nsec);
-	set_normalized_timespec(&wall_to_monotonic, wtm_sec, wtm_nsec);
-
-	ntp_clear();
-	write_sequnlock_irq(&xtime_lock);
-	clock_was_set();
-	return 0;
-}
-
-EXPORT_SYMBOL(do_settimeofday);
-#endif /* !CONFIG_GENERIC_TIME */
 
 #ifndef CONFIG_GENERIC_CLOCKEVENTS
 /*
@@ -214,10 +160,6 @@ device_initcall(timer_init_sysfs);
 
 void __init time_init(void)
 {
-#ifndef CONFIG_GENERIC_TIME
-	if (system_timer->offset == NULL)
-		system_timer->offset = dummy_gettimeoffset;
-#endif
 	system_timer->init();
 }
 
diff -puN arch/arm/mach-at91/Kconfig~arm-convert-arm-to-arch_gettimeoffset arch/arm/mach-at91/Kconfig
--- a/arch/arm/mach-at91/Kconfig~arm-convert-arm-to-arch_gettimeoffset
+++ a/arch/arm/mach-at91/Kconfig
@@ -23,14 +23,12 @@ choice
 config ARCH_AT91RM9200
 	bool "AT91RM9200"
 	select CPU_ARM920T
-	select GENERIC_TIME
 	select GENERIC_CLOCKEVENTS
 	select HAVE_AT91_USART3
 
 config ARCH_AT91SAM9260
 	bool "AT91SAM9260 or AT91SAM9XE"
 	select CPU_ARM926T
-	select GENERIC_TIME
 	select GENERIC_CLOCKEVENTS
 	select HAVE_AT91_USART3
 	select HAVE_AT91_USART4
@@ -39,28 +37,24 @@ config ARCH_AT91SAM9260
 config ARCH_AT91SAM9261
 	bool "AT91SAM9261"
 	select CPU_ARM926T
-	select GENERIC_TIME
 	select GENERIC_CLOCKEVENTS
 	select HAVE_FB_ATMEL
 
 config ARCH_AT91SAM9G10
 	bool "AT91SAM9G10"
 	select CPU_ARM926T
-	select GENERIC_TIME
 	select GENERIC_CLOCKEVENTS
 	select HAVE_FB_ATMEL
 
 config ARCH_AT91SAM9263
 	bool "AT91SAM9263"
 	select CPU_ARM926T
-	select GENERIC_TIME
 	select GENERIC_CLOCKEVENTS
 	select HAVE_FB_ATMEL
 
 config ARCH_AT91SAM9RL
 	bool "AT91SAM9RL"
 	select CPU_ARM926T
-	select GENERIC_TIME
 	select GENERIC_CLOCKEVENTS
 	select HAVE_AT91_USART3
 	select HAVE_FB_ATMEL
@@ -68,7 +62,6 @@ config ARCH_AT91SAM9RL
 config ARCH_AT91SAM9G20
 	bool "AT91SAM9G20"
 	select CPU_ARM926T
-	select GENERIC_TIME
 	select GENERIC_CLOCKEVENTS
 	select HAVE_AT91_USART3
 	select HAVE_AT91_USART4
@@ -77,7 +70,6 @@ config ARCH_AT91SAM9G20
 config ARCH_AT91SAM9G45
 	bool "AT91SAM9G45"
 	select CPU_ARM926T
-	select GENERIC_TIME
 	select GENERIC_CLOCKEVENTS
 	select HAVE_AT91_USART3
 	select HAVE_FB_ATMEL
@@ -85,18 +77,17 @@ config ARCH_AT91SAM9G45
 config ARCH_AT91CAP9
 	bool "AT91CAP9"
 	select CPU_ARM926T
-	select GENERIC_TIME
 	select GENERIC_CLOCKEVENTS
 	select HAVE_FB_ATMEL
 
 config ARCH_AT572D940HF
 	bool "AT572D940HF"
 	select CPU_ARM926T
-	select GENERIC_TIME
 	select GENERIC_CLOCKEVENTS
 
 config ARCH_AT91X40
 	bool "AT91x40"
+	select ARCH_USES_GETTIMEOFFSET
 
 endchoice
 
_

Patches currently in -mm which might be from johnstul@us.ibm.com are

origin.patch
arm-convert-arm-to-arch_gettimeoffset.patch
cs5535-clockevt-free-timer-in-irq-setup-error-path.patch
time-clean-up-warp_clock.patch
time-clean-up-direct-xtime-usage-in-xen.patch
xtensa-fix-unnecessary-setting-of-xtime.patch
time-kill-off-config_generic_time.patch

