From: akpm@linux-foundation.org
Subject: + time-kill-off-config_generic_time.patch added to -mm tree
Date: Wed, 03 Mar 2010 15:02:20 -0800
Message-ID: <201003032302.o23N2Kci003992@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58347 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750804Ab0CCXCe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Mar 2010 18:02:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: johnstul@us.ibm.com, tglx@linutronix.de


The patch titled
     time: kill off CONFIG_GENERIC_TIME
has been added to the -mm tree.  Its filename is
     time-kill-off-config_generic_time.patch

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
Subject: time: kill off CONFIG_GENERIC_TIME
From: john stultz <johnstul@us.ibm.com>

Now that all arches have been converted over to use generic time via
clocksources or arch_gettimeoffset(), we can remove the GENERIC_TIME
config option and simplify the generic code.

Signed-off-by: John Stultz <johnstul@us.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/kernel-parameters.txt |    3 -
 arch/alpha/Kconfig                  |    4 -
 arch/arm/Kconfig                    |    4 -
 arch/avr32/Kconfig                  |    3 -
 arch/blackfin/Kconfig               |    3 -
 arch/cris/Kconfig                   |    3 -
 arch/frv/Kconfig                    |    4 -
 arch/h8300/Kconfig                  |    4 -
 arch/ia64/Kconfig                   |    4 -
 arch/m32r/Kconfig                   |    3 -
 arch/m68k/Kconfig                   |    3 -
 arch/m68knommu/Kconfig              |    4 -
 arch/microblaze/Kconfig             |    3 -
 arch/mips/Kconfig                   |    4 -
 arch/mn10300/Kconfig                |    3 -
 arch/parisc/Kconfig                 |    4 -
 arch/powerpc/Kconfig                |    3 -
 arch/s390/Kconfig                   |    3 -
 arch/sh/Kconfig                     |    3 -
 arch/sparc/Kconfig                  |    3 -
 arch/um/Kconfig.common              |    4 -
 arch/x86/Kconfig                    |    5 --
 arch/xtensa/Kconfig                 |    3 -
 drivers/Makefile                    |    4 +
 drivers/acpi/acpi_pad.c             |    2 
 drivers/acpi/processor_idle.c       |    2 
 drivers/misc/Kconfig                |    4 -
 kernel/time.c                       |   16 -------
 kernel/time/Kconfig                 |    4 -
 kernel/time/clocksource.c           |    4 -
 kernel/time/timekeeping.c           |   55 +-------------------------
 kernel/trace/Kconfig                |    4 -
 32 files changed, 19 insertions(+), 156 deletions(-)

diff -puN Documentation/kernel-parameters.txt~time-kill-off-config_generic_time Documentation/kernel-parameters.txt
--- a/Documentation/kernel-parameters.txt~time-kill-off-config_generic_time
+++ a/Documentation/kernel-parameters.txt
@@ -73,7 +73,6 @@ parameter is applicable:
 	MTD	MTD (Memory Technology Device) support is enabled.
 	NET	Appropriate network support is enabled.
 	NUMA	NUMA support is enabled.
-	GENERIC_TIME The generic timeofday code is enabled.
 	NFS	Appropriate NFS support is enabled.
 	OSS	OSS sound support is enabled.
 	PV_OPS	A paravirtualized kernel is enabled.
@@ -477,7 +476,7 @@ and is between 256 and 4096 characters. 
 			clocksource is not available, it defaults to PIT.
 			Format: { pit | tsc | cyclone | pmtmr }
 
-	clocksource=	[GENERIC_TIME] Override the default clocksource
+	clocksource=	Override the default clocksource
 			Format: <string>
 			Override the default clocksource and use the clocksource
 			with the name specified.
diff -puN arch/alpha/Kconfig~time-kill-off-config_generic_time arch/alpha/Kconfig
--- a/arch/alpha/Kconfig~time-kill-off-config_generic_time
+++ a/arch/alpha/Kconfig
@@ -47,10 +47,6 @@ config GENERIC_CALIBRATE_DELAY
 	bool
 	default y
 
-config GENERIC_TIME
-	bool
-	default y
-
 config ARCH_USES_GETTIMEOFFSET
 	bool
 	default y
diff -puN arch/arm/Kconfig~time-kill-off-config_generic_time arch/arm/Kconfig
--- a/arch/arm/Kconfig~time-kill-off-config_generic_time
+++ a/arch/arm/Kconfig
@@ -40,10 +40,6 @@ config SYS_SUPPORTS_APM_EMULATION
 config GENERIC_GPIO
 	bool
 
-config GENERIC_TIME
-	bool
-	default y
-
 config ARCH_USES_GETTIMEOFFSET
 	bool
 	default n
diff -puN arch/avr32/Kconfig~time-kill-off-config_generic_time arch/avr32/Kconfig
--- a/arch/avr32/Kconfig~time-kill-off-config_generic_time
+++ a/arch/avr32/Kconfig
@@ -45,9 +45,6 @@ config GENERIC_IRQ_PROBE
 config RWSEM_GENERIC_SPINLOCK
 	def_bool y
 
-config GENERIC_TIME
-	def_bool y
-
 config GENERIC_CLOCKEVENTS
 	def_bool y
 
diff -puN arch/blackfin/Kconfig~time-kill-off-config_generic_time arch/blackfin/Kconfig
--- a/arch/blackfin/Kconfig~time-kill-off-config_generic_time
+++ a/arch/blackfin/Kconfig
@@ -602,9 +602,6 @@ comment "Kernel Timer/Scheduler"
 
 source kernel/Kconfig.hz
 
-config GENERIC_TIME
-	def_bool y
-
 config GENERIC_CLOCKEVENTS
 	bool "Generic clock events"
 	default y
diff -puN arch/cris/Kconfig~time-kill-off-config_generic_time arch/cris/Kconfig
--- a/arch/cris/Kconfig~time-kill-off-config_generic_time
+++ a/arch/cris/Kconfig
@@ -20,9 +20,6 @@ config RWSEM_GENERIC_SPINLOCK
 config RWSEM_XCHGADD_ALGORITHM
 	bool
 
-config GENERIC_TIME
-	def_bool y
-
 config ARCH_USES_GETTIMEOFFSET
 	def_bool y
 
diff -puN arch/frv/Kconfig~time-kill-off-config_generic_time arch/frv/Kconfig
--- a/arch/frv/Kconfig~time-kill-off-config_generic_time
+++ a/arch/frv/Kconfig
@@ -40,10 +40,6 @@ config GENERIC_HARDIRQS_NO__DO_IRQ
 	bool
 	default y
 
-config GENERIC_TIME
-	bool
-	default y
-
 config TIME_LOW_RES
 	bool
 	default y
diff -puN arch/h8300/Kconfig~time-kill-off-config_generic_time arch/h8300/Kconfig
--- a/arch/h8300/Kconfig~time-kill-off-config_generic_time
+++ a/arch/h8300/Kconfig
@@ -62,10 +62,6 @@ config GENERIC_CALIBRATE_DELAY
 	bool
 	default y
 
-config GENERIC_TIME
-	bool
-	default y
-
 config GENERIC_BUG
         bool
         depends on BUG
diff -puN arch/ia64/Kconfig~time-kill-off-config_generic_time arch/ia64/Kconfig
--- a/arch/ia64/Kconfig~time-kill-off-config_generic_time
+++ a/arch/ia64/Kconfig
@@ -82,10 +82,6 @@ config GENERIC_CALIBRATE_DELAY
 	bool
 	default y
 
-config GENERIC_TIME
-	bool
-	default y
-
 config GENERIC_TIME_VSYSCALL
 	bool
 	default y
diff -puN arch/m32r/Kconfig~time-kill-off-config_generic_time arch/m32r/Kconfig
--- a/arch/m32r/Kconfig~time-kill-off-config_generic_time
+++ a/arch/m32r/Kconfig
@@ -44,9 +44,6 @@ config HZ
 	int
 	default 100
 
-config GENERIC_TIME
-	def_bool y
-
 config ARCH_USES_GETTIMEOFFSET
 	def_bool y
 
diff -puN arch/m68k/Kconfig~time-kill-off-config_generic_time arch/m68k/Kconfig
--- a/arch/m68k/Kconfig~time-kill-off-config_generic_time
+++ a/arch/m68k/Kconfig
@@ -58,9 +58,6 @@ config HZ
 	int
 	default 100
 
-config GENERIC_TIME
-	def_bool y
-
 config ARCH_USES_GETTIMEOFFSET
 	def_bool y
 
diff -puN arch/m68knommu/Kconfig~time-kill-off-config_generic_time arch/m68knommu/Kconfig
--- a/arch/m68knommu/Kconfig~time-kill-off-config_generic_time
+++ a/arch/m68knommu/Kconfig
@@ -67,10 +67,6 @@ config GENERIC_CALIBRATE_DELAY
 	bool
 	default y
 
-config GENERIC_TIME
-	bool
-	default y
-
 config GENERIC_CMOS_UPDATE
 	bool
 	default y
diff -puN arch/microblaze/Kconfig~time-kill-off-config_generic_time arch/microblaze/Kconfig
--- a/arch/microblaze/Kconfig~time-kill-off-config_generic_time
+++ a/arch/microblaze/Kconfig
@@ -48,9 +48,6 @@ config GENERIC_IRQ_PROBE
 config GENERIC_CALIBRATE_DELAY
 	def_bool y
 
-config GENERIC_TIME
-	def_bool y
-
 config GENERIC_TIME_VSYSCALL
 	def_bool n
 
diff -puN arch/mips/Kconfig~time-kill-off-config_generic_time arch/mips/Kconfig
--- a/arch/mips/Kconfig~time-kill-off-config_generic_time
+++ a/arch/mips/Kconfig
@@ -731,10 +731,6 @@ config GENERIC_CLOCKEVENTS
 	bool
 	default y
 
-config GENERIC_TIME
-	bool
-	default y
-
 config GENERIC_CMOS_UPDATE
 	bool
 	default y
diff -puN arch/mn10300/Kconfig~time-kill-off-config_generic_time arch/mn10300/Kconfig
--- a/arch/mn10300/Kconfig~time-kill-off-config_generic_time
+++ a/arch/mn10300/Kconfig
@@ -43,9 +43,6 @@ config GENERIC_FIND_NEXT_BIT
 config GENERIC_HWEIGHT
 	def_bool y
 
-config GENERIC_TIME
-	def_bool y
-
 config GENERIC_BUG
 	def_bool y
 
diff -puN arch/parisc/Kconfig~time-kill-off-config_generic_time arch/parisc/Kconfig
--- a/arch/parisc/Kconfig~time-kill-off-config_generic_time
+++ a/arch/parisc/Kconfig
@@ -66,10 +66,6 @@ config GENERIC_CALIBRATE_DELAY
 	bool
 	default y
 
-config GENERIC_TIME
-	bool
-	default y
-
 config TIME_LOW_RES
 	bool
 	depends on SMP
diff -puN arch/powerpc/Kconfig~time-kill-off-config_generic_time arch/powerpc/Kconfig
--- a/arch/powerpc/Kconfig~time-kill-off-config_generic_time
+++ a/arch/powerpc/Kconfig
@@ -29,9 +29,6 @@ config MMU
 config GENERIC_CMOS_UPDATE
 	def_bool y
 
-config GENERIC_TIME
-	def_bool y
-
 config GENERIC_TIME_VSYSCALL
 	def_bool y
 
diff -puN arch/s390/Kconfig~time-kill-off-config_generic_time arch/s390/Kconfig
--- a/arch/s390/Kconfig~time-kill-off-config_generic_time
+++ a/arch/s390/Kconfig
@@ -40,9 +40,6 @@ config ARCH_HAS_ILOG2_U64
 config GENERIC_HWEIGHT
 	def_bool y
 
-config GENERIC_TIME
-	def_bool y
-
 config GENERIC_TIME_VSYSCALL
 	def_bool y
 
diff -puN arch/sh/Kconfig~time-kill-off-config_generic_time arch/sh/Kconfig
--- a/arch/sh/Kconfig~time-kill-off-config_generic_time
+++ a/arch/sh/Kconfig
@@ -97,9 +97,6 @@ config GENERIC_CALIBRATE_DELAY
 config GENERIC_IOMAP
 	bool
 
-config GENERIC_TIME
-	def_bool y
-
 config GENERIC_CLOCKEVENTS
 	def_bool y
 
diff -puN arch/sparc/Kconfig~time-kill-off-config_generic_time arch/sparc/Kconfig
--- a/arch/sparc/Kconfig~time-kill-off-config_generic_time
+++ a/arch/sparc/Kconfig
@@ -63,9 +63,6 @@ config BITS
 	default 32 if SPARC32
 	default 64 if SPARC64
 
-config GENERIC_TIME
-	def_bool y
-
 config ARCH_USES_GETTIMEOFFSET
 	bool
 	default y if SPARC32
diff -puN arch/um/Kconfig.common~time-kill-off-config_generic_time arch/um/Kconfig.common
--- a/arch/um/Kconfig.common~time-kill-off-config_generic_time
+++ a/arch/um/Kconfig.common
@@ -55,10 +55,6 @@ config GENERIC_BUG
 	default y
 	depends on BUG
 
-config GENERIC_TIME
-	bool
-	default y
-
 config GENERIC_CLOCKEVENTS
 	bool
 	default y
diff -puN arch/x86/Kconfig~time-kill-off-config_generic_time arch/x86/Kconfig
--- a/arch/x86/Kconfig~time-kill-off-config_generic_time
+++ a/arch/x86/Kconfig
@@ -69,9 +69,6 @@ config ARCH_DEFCONFIG
 	default "arch/x86/configs/i386_defconfig" if X86_32
 	default "arch/x86/configs/x86_64_defconfig" if X86_64
 
-config GENERIC_TIME
-	def_bool y
-
 config GENERIC_CMOS_UPDATE
 	def_bool y
 
@@ -2026,7 +2023,7 @@ config SCx200
 
 config SCx200HR_TIMER
 	tristate "NatSemi SCx200 27MHz High-Resolution Timer Support"
-	depends on SCx200 && GENERIC_TIME
+	depends on SCx200
 	default y
 	---help---
 	  This driver provides a clocksource built upon the on-chip
diff -puN arch/xtensa/Kconfig~time-kill-off-config_generic_time arch/xtensa/Kconfig
--- a/arch/xtensa/Kconfig~time-kill-off-config_generic_time
+++ a/arch/xtensa/Kconfig
@@ -48,9 +48,6 @@ config HZ
 	int
 	default 100
 
-config GENERIC_TIME
-	def_bool y
-
 source "init/Kconfig"
 source "kernel/Kconfig.freezer"
 
diff -puN drivers/Makefile~time-kill-off-config_generic_time drivers/Makefile
--- a/drivers/Makefile~time-kill-off-config_generic_time
+++ a/drivers/Makefile
@@ -101,7 +101,9 @@ obj-y				+= firmware/
 obj-$(CONFIG_CRYPTO)		+= crypto/
 obj-$(CONFIG_SUPERH)		+= sh/
 obj-$(CONFIG_ARCH_SHMOBILE)	+= sh/
-obj-$(CONFIG_GENERIC_TIME)	+= clocksource/
+ifndef CONFIG_ARCH_USES_GETTIMEOFFSET
+obj-y				+= clocksource/
+endif
 obj-$(CONFIG_DMA_ENGINE)	+= dma/
 obj-$(CONFIG_DCA)		+= dca/
 obj-$(CONFIG_HID)		+= hid/
diff -puN drivers/acpi/acpi_pad.c~time-kill-off-config_generic_time drivers/acpi/acpi_pad.c
--- a/drivers/acpi/acpi_pad.c~time-kill-off-config_generic_time
+++ a/drivers/acpi/acpi_pad.c
@@ -73,7 +73,7 @@ static void power_saving_mwait_init(void
 	for_each_online_cpu(i)
 		clockevents_notify(CLOCK_EVT_NOTIFY_BROADCAST_ON, &i);
 
-#if defined(CONFIG_GENERIC_TIME) && defined(CONFIG_X86)
+#if defined(CONFIG_X86)
 	switch (boot_cpu_data.x86_vendor) {
 	case X86_VENDOR_AMD:
 	case X86_VENDOR_INTEL:
diff -puN drivers/acpi/processor_idle.c~time-kill-off-config_generic_time drivers/acpi/processor_idle.c
--- a/drivers/acpi/processor_idle.c~time-kill-off-config_generic_time
+++ a/drivers/acpi/processor_idle.c
@@ -258,7 +258,7 @@ int acpi_processor_resume(struct acpi_de
 	return 0;
 }
 
-#if defined (CONFIG_GENERIC_TIME) && defined (CONFIG_X86)
+#if defined(CONFIG_X86)
 static void tsc_check_state(int state)
 {
 	switch (boot_cpu_data.x86_vendor) {
diff -puN drivers/misc/Kconfig~time-kill-off-config_generic_time drivers/misc/Kconfig
--- a/drivers/misc/Kconfig~time-kill-off-config_generic_time
+++ a/drivers/misc/Kconfig
@@ -46,7 +46,7 @@ config ATMEL_TCLIB
 
 config ATMEL_TCB_CLKSRC
 	bool "TC Block Clocksource"
-	depends on ATMEL_TCLIB && GENERIC_TIME
+	depends on ATMEL_TCLIB
 	default y
 	help
 	  Select this to get a high precision clocksource based on a
@@ -242,7 +242,7 @@ config CS5535_MFGPT_DEFAULT_IRQ
 
 config CS5535_CLOCK_EVENT_SRC
 	tristate "CS5535/CS5536 high-res timer (MFGPT) events"
-	depends on GENERIC_TIME && GENERIC_CLOCKEVENTS && CS5535_MFGPT
+	depends on GENERIC_CLOCKEVENTS && CS5535_MFGPT
 	help
 	  This driver provides a clock event source based on the MFGPT
 	  timer(s) in the CS5535 and CS5536 companion chips.
diff -puN kernel/time.c~time-kill-off-config_generic_time kernel/time.c
--- a/kernel/time.c~time-kill-off-config_generic_time
+++ a/kernel/time.c
@@ -302,22 +302,6 @@ struct timespec timespec_trunc(struct ti
 }
 EXPORT_SYMBOL(timespec_trunc);
 
-#ifndef CONFIG_GENERIC_TIME
-/*
- * Simulate gettimeofday using do_gettimeofday which only allows a timeval
- * and therefore only yields usec accuracy
- */
-void getnstimeofday(struct timespec *tv)
-{
-	struct timeval x;
-
-	do_gettimeofday(&x);
-	tv->tv_sec = x.tv_sec;
-	tv->tv_nsec = x.tv_usec * NSEC_PER_USEC;
-}
-EXPORT_SYMBOL_GPL(getnstimeofday);
-#endif
-
 /* Converts Gregorian date to seconds since 1970-01-01 00:00:00.
  * Assumes input in normal date format, i.e. 1980-12-31 23:59:59
  * => year=1980, mon=12, day=31, hour=23, min=59, sec=59.
diff -puN kernel/time/Kconfig~time-kill-off-config_generic_time kernel/time/Kconfig
--- a/kernel/time/Kconfig~time-kill-off-config_generic_time
+++ a/kernel/time/Kconfig
@@ -6,7 +6,7 @@ config TICK_ONESHOT
 
 config NO_HZ
 	bool "Tickless System (Dynamic Ticks)"
-	depends on GENERIC_TIME && GENERIC_CLOCKEVENTS
+	depends on !ARCH_USES_GETTIMEOFFSET && GENERIC_CLOCKEVENTS
 	select TICK_ONESHOT
 	help
 	  This option enables a tickless system: timer interrupts will
@@ -15,7 +15,7 @@ config NO_HZ
 
 config HIGH_RES_TIMERS
 	bool "High Resolution Timer Support"
-	depends on GENERIC_TIME && GENERIC_CLOCKEVENTS
+	depends on !ARCH_USES_GETTIMEOFFSET && GENERIC_CLOCKEVENTS
 	select TICK_ONESHOT
 	help
 	  This option enables high resolution timer support. If your
diff -puN kernel/time/clocksource.c~time-kill-off-config_generic_time kernel/time/clocksource.c
--- a/kernel/time/clocksource.c~time-kill-off-config_generic_time
+++ a/kernel/time/clocksource.c
@@ -531,7 +531,7 @@ static u64 clocksource_max_deferment(str
 	return max_nsecs - (max_nsecs >> 5);
 }
 
-#ifdef CONFIG_GENERIC_TIME
+#ifndef CONFIG_ARCH_USES_GETTIMEOFFSET
 
 /**
  * clocksource_select - Select the best clocksource available
@@ -577,7 +577,7 @@ static void clocksource_select(void)
 	}
 }
 
-#else /* CONFIG_GENERIC_TIME */
+#else /* !CONFIG_ARCH_USES_GETTIMEOFFSET */
 
 static inline void clocksource_select(void) { }
 
diff -puN kernel/time/timekeeping.c~time-kill-off-config_generic_time kernel/time/timekeeping.c
--- a/kernel/time/timekeeping.c~time-kill-off-config_generic_time
+++ a/kernel/time/timekeeping.c
@@ -180,8 +180,6 @@ void timekeeping_leap_insert(int leapsec
 	update_vsyscall(&xtime, timekeeper.clock, timekeeper.mult);
 }
 
-#ifdef CONFIG_GENERIC_TIME
-
 /**
  * timekeeping_forward_now - update clock to the current time
  *
@@ -385,52 +383,6 @@ void timekeeping_notify(struct clocksour
 	tick_clock_notify();
 }
 
-#else /* GENERIC_TIME */
-
-static inline void timekeeping_forward_now(void) { }
-
-/**
- * ktime_get - get the monotonic time in ktime_t format
- *
- * returns the time in ktime_t format
- */
-ktime_t ktime_get(void)
-{
-	struct timespec now;
-
-	ktime_get_ts(&now);
-
-	return timespec_to_ktime(now);
-}
-EXPORT_SYMBOL_GPL(ktime_get);
-
-/**
- * ktime_get_ts - get the monotonic clock in timespec format
- * @ts:		pointer to timespec variable
- *
- * The function calculates the monotonic clock from the realtime
- * clock and the wall_to_monotonic offset and stores the result
- * in normalized timespec format in the variable pointed to by @ts.
- */
-void ktime_get_ts(struct timespec *ts)
-{
-	struct timespec tomono;
-	unsigned long seq;
-
-	do {
-		seq = read_seqbegin(&xtime_lock);
-		getnstimeofday(ts);
-		tomono = wall_to_monotonic;
-
-	} while (read_seqretry(&xtime_lock, seq));
-
-	set_normalized_timespec(ts, ts->tv_sec + tomono.tv_sec,
-				ts->tv_nsec + tomono.tv_nsec);
-}
-EXPORT_SYMBOL_GPL(ktime_get_ts);
-
-#endif /* !GENERIC_TIME */
-
 /**
  * ktime_get_real - get the real (wall-) time in ktime_t format
  *
@@ -796,10 +748,11 @@ void update_wall_time(void)
 		return;
 
 	clock = timekeeper.clock;
-#ifdef CONFIG_GENERIC_TIME
-	offset = (clock->read(clock) - clock->cycle_last) & clock->mask;
-#else
+
+#ifdef CONFIG_ARCH_USES_GETTIMEOFFSET
 	offset = timekeeper.cycle_interval;
+#else
+	offset = (clock->read(clock) - clock->cycle_last) & clock->mask;
 #endif
 	timekeeper.xtime_nsec = (s64)xtime.tv_nsec << timekeeper.shift;
 
diff -puN kernel/trace/Kconfig~time-kill-off-config_generic_time kernel/trace/Kconfig
--- a/kernel/trace/Kconfig~time-kill-off-config_generic_time
+++ a/kernel/trace/Kconfig
@@ -156,7 +156,7 @@ config IRQSOFF_TRACER
 	bool "Interrupts-off Latency Tracer"
 	default n
 	depends on TRACE_IRQFLAGS_SUPPORT
-	depends on GENERIC_TIME
+	depends on !ARCH_USES_GETTIMEOFFSET
 	select TRACE_IRQFLAGS
 	select GENERIC_TRACER
 	select TRACER_MAX_TRACE
@@ -178,7 +178,7 @@ config IRQSOFF_TRACER
 config PREEMPT_TRACER
 	bool "Preemption-off Latency Tracer"
 	default n
-	depends on GENERIC_TIME
+	depends on !ARCH_USES_GETTIMEOFFSET
 	depends on PREEMPT
 	select GENERIC_TRACER
 	select TRACER_MAX_TRACE
_

Patches currently in -mm which might be from johnstul@us.ibm.com are

origin.patch
linux-next.patch
arm-convert-arm-to-arch_gettimeoffset.patch
cs5535-clockevt-free-timer-in-irq-setup-error-path.patch
genirq-warn-about-irqf_sharedirqf_disabled-at-the-right-place.patch
cris-convert-to-use-arch_gettimeoffset.patch
posix-cpu-timers-cleanup-rlimits-usage.patch
kernel-core-use-helpers-for-rlimits.patch
time-kill-off-config_generic_time.patch

