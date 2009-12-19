From: akpm@linux-foundation.org
Subject: + convert-arm-to-arch_gettimeoffset.patch added to -mm tree
Date: Fri, 18 Dec 2009 16:19:20 -0800
Message-ID: <200912190019.nBJ0JKZ3027094@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40187 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750822AbZLSATr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 18 Dec 2009 19:19:47 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: johnstul@us.ibm.com, rmk@arm.linux.org.uk


The patch titled
     arm: convert to arch_gettimeoffset()
has been added to the -mm tree.  Its filename is
     convert-arm-to-arch_gettimeoffset.patch

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
Subject: arm: convert to arch_gettimeoffset()
From: john stultz <johnstul@us.ibm.com>

Convert arm to use GENERIC_TIME via the arch_getoffset() infrastructure,
reducing the amount of arch specific code we need to maintain.

The arm architecture is one of the last 3 arches that need to be
converted.

Signed-off-by: John Stultz <johnstul@us.ibm.com>
Cc: Russell King <rmk@arm.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/Kconfig                 |   51 +++++++++++---------
 arch/arm/include/asm/mach/time.h |    2 
 arch/arm/kernel/time.c           |   71 ++---------------------------
 arch/arm/mach-at91/Kconfig       |   10 ----
 4 files changed, 35 insertions(+), 99 deletions(-)

diff -puN arch/arm/Kconfig~convert-arm-to-arch_gettimeoffset arch/arm/Kconfig
--- a/arch/arm/Kconfig~convert-arm-to-arch_gettimeoffset
+++ a/arch/arm/Kconfig
@@ -37,6 +37,11 @@ config GENERIC_GPIO
 
 config GENERIC_TIME
 	bool
+	default y
+
+config ARCH_USES_GETTIMEOFFSET
+	bool
+	default n
 
 config GENERIC_CLOCKEVENTS
 	bool
@@ -211,6 +216,7 @@ config ARCH_AAEC2000
 	select CPU_ARM920T
 	select ARM_AMBA
 	select HAVE_CLK
+	select ARCH_USES_GETTIMEOFFSET
 	help
 	  This enables support for systems based on the Agilent AAEC-2000
 
@@ -221,6 +227,7 @@ config ARCH_INTEGRATOR
 	select HAVE_CLK
 	select COMMON_CLKDEV
 	select ICST525
+	select ARCH_USES_GETTIMEOFFSET
 	help
 	  Support for ARM's Integrator platform.
 
@@ -230,7 +237,6 @@ config ARCH_REALVIEW
 	select HAVE_CLK
 	select COMMON_CLKDEV
 	select ICST307
-	select GENERIC_TIME
 	select GENERIC_CLOCKEVENTS
 	select ARCH_WANT_OPTIONAL_GPIOLIB
 	help
@@ -243,7 +249,6 @@ config ARCH_VERSATILE
 	select HAVE_CLK
 	select COMMON_CLKDEV
 	select ICST307
-	select GENERIC_TIME
 	select GENERIC_CLOCKEVENTS
 	select ARCH_WANT_OPTIONAL_GPIOLIB
 	help
@@ -254,6 +259,7 @@ config ARCH_AT91
 	select GENERIC_GPIO
 	select ARCH_REQUIRE_GPIOLIB
 	select HAVE_CLK
+	select ARCH_USES_GETTIMEOFFSET
 	help
 	  This enables support for systems based on the Atmel AT91RM9200,
 	  AT91SAM9 and AT91CAP9 processors.
@@ -261,6 +267,7 @@ config ARCH_AT91
 config ARCH_CLPS711X
 	bool "Cirrus Logic CLPS711x/EP721x-based"
 	select CPU_ARM720T
+	select ARCH_USES_GETTIMEOFFSET
 	help
 	  Support for Cirrus Logic 711x/721x based boards.
 
@@ -269,6 +276,7 @@ config ARCH_GEMINI
 	select CPU_FA526
 	select GENERIC_GPIO
 	select ARCH_REQUIRE_GPIOLIB
+	select ARCH_USES_GETTIMEOFFSET
 	help
 	  Support for the Cortina Systems Gemini family SoCs
 
@@ -277,6 +285,7 @@ config ARCH_EBSA110
 	select CPU_SA110
 	select ISA
 	select NO_IOPORT
+	select ARCH_USES_GETTIMEOFFSET
 	help
 	  This is an evaluation board for the StrongARM processor available
 	  from Digital. It has limited hardware on-board, including an
@@ -293,6 +302,7 @@ config ARCH_EP93XX
 	select COMMON_CLKDEV
 	select ARCH_REQUIRE_GPIOLIB
 	select ARCH_HAS_HOLES_MEMORYMODEL
+	select ARCH_USES_GETTIMEOFFSET
 	help
 	  This enables support for the Cirrus EP93xx series of CPUs.
 
@@ -300,13 +310,13 @@ config ARCH_FOOTBRIDGE
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
 	select ARCH_MTD_XIP
 	select GENERIC_GPIO
@@ -321,7 +331,6 @@ config ARCH_STMP3XXX
 	select HAVE_CLK
 	select COMMON_CLKDEV
 	select ARCH_REQUIRE_GPIOLIB
-	select GENERIC_TIME
 	select GENERIC_CLOCKEVENTS
 	select GENERIC_GPIO
 	select USB_ARCH_HAS_EHCI
@@ -333,7 +342,6 @@ config ARCH_NETX
 	select CPU_ARM926T
 	select ARM_VIC
 	select GENERIC_CLOCKEVENTS
-	select GENERIC_TIME
 	help
 	  This enables support for systems based on the Hilscher NetX Soc
 
@@ -341,6 +349,7 @@ config ARCH_H720X
 	bool "Hynix HMS720x-based"
 	select CPU_ARM720T
 	select ISA_DMA_API
+	select ARCH_USES_GETTIMEOFFSET
 	help
 	  This enables support for systems based on the Hynix HMS720x
 
@@ -351,7 +360,6 @@ config ARCH_NOMADIK
 	select CPU_ARM926T
 	select HAVE_CLK
 	select COMMON_CLKDEV
-	select GENERIC_TIME
 	select GENERIC_CLOCKEVENTS
 	select GENERIC_GPIO
 	select ARCH_REQUIRE_GPIOLIB
@@ -366,6 +374,7 @@ config ARCH_IOP13XX
 	select PCI
 	select ARCH_SUPPORTS_MSI
 	select VMSPLIT_1G
+	select ARCH_USES_GETTIMEOFFSET
 	help
 	  Support for Intel's IOP13XX (XScale) family of processors.
 
@@ -377,6 +386,7 @@ config ARCH_IOP32X
 	select PCI
 	select GENERIC_GPIO
 	select ARCH_REQUIRE_GPIOLIB
+	select ARCH_USES_GETTIMEOFFSET
 	help
 	  Support for Intel's 80219 and IOP32X (XScale) family of
 	  processors.
@@ -389,6 +399,7 @@ config ARCH_IOP33X
 	select PCI
 	select GENERIC_GPIO
 	select ARCH_REQUIRE_GPIOLIB
+	select ARCH_USES_GETTIMEOFFSET
 	help
 	  Support for Intel's IOP33X (XScale) family of processors.
 
@@ -397,6 +408,7 @@ config ARCH_IXP23XX
 	depends on MMU
 	select CPU_XSC3
  	select PCI
+	select ARCH_USES_GETTIMEOFFSET
 	help
 	  Support for Intel's IXP23xx (XScale) family of processors.
 
@@ -405,6 +417,7 @@ config ARCH_IXP2000
 	depends on MMU
 	select CPU_XSCALE
 	select PCI
+	select ARCH_USES_GETTIMEOFFSET
 	help
 	  Support for Intel's IXP2400/2800 (XScale) family of processors.
 
@@ -413,7 +426,6 @@ config ARCH_IXP4XX
 	depends on MMU
 	select CPU_XSCALE
 	select GENERIC_GPIO
-	select GENERIC_TIME
 	select GENERIC_CLOCKEVENTS
 	select DMABOUNCE if PCI
 	help
@@ -423,6 +435,7 @@ config ARCH_L7200
 	bool "LinkUp-L7200"
 	select CPU_ARM720T
 	select FIQ
+	select ARCH_USES_GETTIMEOFFSET
 	help
 	  Say Y here if you intend to run this kernel on a LinkUp Systems
 	  L7200 Software Development Board which uses an ARM720T processor.
@@ -438,7 +451,6 @@ config ARCH_DOVE
 	select PCI
 	select GENERIC_GPIO
 	select ARCH_REQUIRE_GPIOLIB
-	select GENERIC_TIME
 	select GENERIC_CLOCKEVENTS
 	select PLAT_ORION
 	help
@@ -450,7 +462,6 @@ config ARCH_KIRKWOOD
 	select PCI
 	select GENERIC_GPIO
 	select ARCH_REQUIRE_GPIOLIB
-	select GENERIC_TIME
 	select GENERIC_CLOCKEVENTS
 	select PLAT_ORION
 	help
@@ -460,7 +471,6 @@ config ARCH_KIRKWOOD
 config ARCH_LOKI
 	bool "Marvell Loki (88RC8480)"
 	select CPU_FEROCEON
-	select GENERIC_TIME
 	select GENERIC_CLOCKEVENTS
 	select PLAT_ORION
 	help
@@ -472,7 +482,6 @@ config ARCH_MV78XX0
 	select PCI
 	select GENERIC_GPIO
 	select ARCH_REQUIRE_GPIOLIB
-	select GENERIC_TIME
 	select GENERIC_CLOCKEVENTS
 	select PLAT_ORION
 	help
@@ -486,7 +495,6 @@ config ARCH_ORION5X
 	select PCI
 	select GENERIC_GPIO
 	select ARCH_REQUIRE_GPIOLIB
-	select GENERIC_TIME
 	select GENERIC_CLOCKEVENTS
 	select PLAT_ORION
 	help
@@ -501,7 +509,6 @@ config ARCH_MMP
 	select ARCH_REQUIRE_GPIOLIB
 	select HAVE_CLK
 	select COMMON_CLKDEV
-	select GENERIC_TIME
 	select GENERIC_CLOCKEVENTS
 	select TICK_ONESHOT
 	select PLAT_PXA
@@ -513,6 +520,7 @@ config ARCH_KS8695
 	select CPU_ARM922T
 	select GENERIC_GPIO
         select ARCH_REQUIRE_GPIOLIB
+	select ARCH_USES_GETTIMEOFFSET
 	help
 	  Support for Micrel/Kendin KS8695 "Centaur" (ARM922T) based
 	  System-on-Chip devices.
@@ -521,7 +529,6 @@ config ARCH_NS9XXX
 	bool "NetSilicon NS9xxx"
 	select CPU_ARM926T
 	select GENERIC_GPIO
-	select GENERIC_TIME
 	select GENERIC_CLOCKEVENTS
 	select HAVE_CLK
 	help
@@ -537,7 +544,6 @@ config ARCH_W90X900
 	select GENERIC_GPIO
 	select HAVE_CLK
 	select COMMON_CLKDEV
-	select GENERIC_TIME
 	select GENERIC_CLOCKEVENTS
 	help
 	  Support for Nuvoton (Winbond logic dept.) ARM9 processor,
@@ -552,6 +558,7 @@ config ARCH_PNX4008
 	bool "Philips Nexperia PNX4008 Mobile"
 	select CPU_ARM926T
 	select HAVE_CLK
+	select ARCH_USES_GETTIMEOFFSET
 	help
 	  This enables support for Philips PNX4008 mobile platform.
 
@@ -564,7 +571,6 @@ config ARCH_PXA
 	select HAVE_CLK
 	select COMMON_CLKDEV
 	select ARCH_REQUIRE_GPIOLIB
-	select GENERIC_TIME
 	select GENERIC_CLOCKEVENTS
 	select TICK_ONESHOT
 	select PLAT_PXA
@@ -574,7 +580,6 @@ config ARCH_PXA
 config ARCH_MSM
 	bool "Qualcomm MSM"
 	select CPU_V6
-	select GENERIC_TIME
 	select GENERIC_CLOCKEVENTS
 	help
 	  Support for Qualcomm MSM7K based systems.  This runs on the ARM11
@@ -592,6 +597,7 @@ config ARCH_RPC
 	select ISA_DMA_API
 	select NO_IOPORT
 	select ARCH_SPARSEMEM_ENABLE
+	select ARCH_USES_GETTIMEOFFSET
 	help
 	  On the Acorn Risc-PC, Linux can support the internal IDE disk and
 	  CD-ROM interface, serial and parallel port, and the floppy drive.
@@ -605,7 +611,6 @@ config ARCH_SA1100
 	select ARCH_HAS_CPUFREQ
 	select CPU_FREQ
 	select GENERIC_GPIO
-	select GENERIC_TIME
 	select GENERIC_CLOCKEVENTS
 	select HAVE_CLK
 	select TICK_ONESHOT
@@ -618,6 +623,7 @@ config ARCH_S3C2410
 	select GENERIC_GPIO
 	select ARCH_HAS_CPUFREQ
 	select HAVE_CLK
+	select ARCH_USES_GETTIMEOFFSET
 	help
 	  Samsung S3C2410X CPU based systems, such as the Simtec Electronics
 	  BAST (<http://www.simtec.co.uk/products/EB110ITX/>), the IPAQ 1940 or
@@ -627,6 +633,7 @@ config ARCH_S3C64XX
 	bool "Samsung S3C64XX"
 	select GENERIC_GPIO
 	select HAVE_CLK
+	select ARCH_USES_GETTIMEOFFSET
 	select ARCH_HAS_CPUFREQ
 	help
 	  Samsung S3C64XX series based systems
@@ -646,6 +653,7 @@ config ARCH_SHARK
 	select ISA_DMA
 	select ZONE_DMA
 	select PCI
+	select ARCH_USES_GETTIMEOFFSET
 	help
 	  Support for the StrongARM based Digital DNARD machine, also known
 	  as "Shark" (<http://www.shark-linux.de/shark.html>).
@@ -655,6 +663,7 @@ config ARCH_LH7A40X
 	select CPU_ARM922T
 	select ARCH_DISCONTIGMEM_ENABLE if !LH7A40X_CONTIGMEM
 	select ARCH_SPARSEMEM_ENABLE if !LH7A40X_CONTIGMEM
+	select ARCH_USES_GETTIMEOFFSET
 	help
 	  Say Y here for systems based on one of the Sharp LH7A40X
 	  System on a Chip processors.  These CPUs include an ARM922T
@@ -668,7 +677,6 @@ config ARCH_U300
 	select HAVE_TCM
 	select ARM_AMBA
 	select ARM_VIC
-	select GENERIC_TIME
 	select GENERIC_CLOCKEVENTS
 	select HAVE_CLK
 	select COMMON_CLKDEV
@@ -679,7 +687,6 @@ config ARCH_U300
 config ARCH_DAVINCI
 	bool "TI DaVinci"
 	select CPU_ARM926T
-	select GENERIC_TIME
 	select GENERIC_CLOCKEVENTS
 	select GENERIC_GPIO
 	select ARCH_REQUIRE_GPIOLIB
@@ -697,7 +704,6 @@ config ARCH_OMAP
 	select HAVE_CLK
 	select ARCH_REQUIRE_GPIOLIB
 	select ARCH_HAS_CPUFREQ
-	select GENERIC_TIME
 	select GENERIC_CLOCKEVENTS
 	help
 	  Support for TI's OMAP platform (OMAP1 and OMAP2).
@@ -708,7 +714,6 @@ config ARCH_BCMRING
 	select CPU_V6
 	select ARM_AMBA
 	select COMMON_CLKDEV
-	select GENERIC_TIME
 	select GENERIC_CLOCKEVENTS
 	select ARCH_WANT_OPTIONAL_GPIOLIB
 	help
@@ -718,7 +723,6 @@ config ARCH_U8500
 	bool "ST-Ericsson U8500 Series"
 	select CPU_V7
 	select ARM_AMBA
-	select GENERIC_TIME
 	select GENERIC_CLOCKEVENTS
 	select COMMON_CLKDEV
 	help
@@ -839,7 +843,6 @@ config ARCH_ACORN
 config PLAT_IOP
 	bool
 	select GENERIC_CLOCKEVENTS
-	select GENERIC_TIME
 
 config PLAT_ORION
 	bool
diff -puN arch/arm/include/asm/mach/time.h~convert-arm-to-arch_gettimeoffset arch/arm/include/asm/mach/time.h
--- a/arch/arm/include/asm/mach/time.h~convert-arm-to-arch_gettimeoffset
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
diff -puN arch/arm/kernel/time.c~convert-arm-to-arch_gettimeoffset arch/arm/kernel/time.c
--- a/arch/arm/kernel/time.c~convert-arm-to-arch_gettimeoffset
+++ a/arch/arm/kernel/time.c
@@ -82,12 +82,15 @@ EXPORT_SYMBOL(profile_pc);
  */
 int (*set_rtc)(void);
 
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
 
 static unsigned long next_rtc_update;
 
@@ -237,64 +240,6 @@ static inline void do_leds(void)
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
-
 /**
  * save_time_delta - Save the offset between system time and RTC time
  * @delta: pointer to timespec to store delta
@@ -392,10 +337,6 @@ device_initcall(timer_init_sysfs);
 
 void __init time_init(void)
 {
-#ifndef CONFIG_GENERIC_TIME
-	if (system_timer->offset == NULL)
-		system_timer->offset = dummy_gettimeoffset;
-#endif
 	system_timer->init();
 }
 
diff -puN arch/arm/mach-at91/Kconfig~convert-arm-to-arch_gettimeoffset arch/arm/mach-at91/Kconfig
--- a/arch/arm/mach-at91/Kconfig~convert-arm-to-arch_gettimeoffset
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
@@ -85,12 +77,12 @@ config ARCH_AT91SAM9G45
 config ARCH_AT91CAP9
 	bool "AT91CAP9"
 	select CPU_ARM926T
-	select GENERIC_TIME
 	select GENERIC_CLOCKEVENTS
 	select HAVE_FB_ATMEL
 
 config ARCH_AT91X40
 	bool "AT91x40"
+	select ARCH_USES_GETTIMEOFFSET
 
 endchoice
 
_

Patches currently in -mm which might be from johnstul@us.ibm.com are

convert-arm-to-arch_gettimeoffset.patch
clocksource-add-argument-to-resume-callback.patch
clocksource-start-cmt-at-clocksource-resume.patch
clocksource-start-cmt-at-clocksource-resume-v2.patch
clocksource-add-suspend-callback.patch
convert-sparc-to-arch_gettimeoffset.patch
cris-convert-to-use-arch_gettimeoffset.patch
convert-cris-to-arch_gettimeoffset.patch

