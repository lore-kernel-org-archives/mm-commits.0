From: akpm@linux-foundation.org
Subject: [merged] convert-sparc-to-arch_gettimeoffset.patch removed from -mm tree
Date: Tue, 26 Jan 2010 13:30:38 -0800
Message-ID: <201001262130.o0QLUc0e021409@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34130 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753619Ab0AZVbM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 26 Jan 2010 16:31:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: johnstul@us.ibm.com, davem@davemloft.net, mm-commits@vger.kernel.org


The patch titled
     sparc: convert to arch_gettimeoffset()
has been removed from the -mm tree.  Its filename was
     convert-sparc-to-arch_gettimeoffset.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sparc: convert to arch_gettimeoffset()
From: john stultz <johnstul@us.ibm.com>

Convert sparc (specifically sparc32) to use GENERIC_TIME via the
arch_getoffset() infrastructure, reducing the amount of arch specific code
we need to maintain.

The sparc architecture is one of the last 3 arches that need to be
converted.

Signed-off-by: John Stultz <johnstul@us.ibm.com>
Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sparc/Kconfig          |    5 +
 arch/sparc/kernel/pcic.c    |  104 +++++-------------------------
 arch/sparc/kernel/time_32.c |  115 +++++++---------------------------
 3 files changed, 45 insertions(+), 179 deletions(-)

diff -puN arch/sparc/Kconfig~convert-sparc-to-arch_gettimeoffset arch/sparc/Kconfig
--- a/arch/sparc/Kconfig~convert-sparc-to-arch_gettimeoffset
+++ a/arch/sparc/Kconfig
@@ -64,8 +64,11 @@ config BITS
 	default 64 if SPARC64
 
 config GENERIC_TIME
+	def_bool y
+
+config ARCH_USES_GETTIMEOFFSET
 	bool
-	default y if SPARC64
+	default y if SPARC32
 
 config GENERIC_CMOS_UPDATE
 	bool
diff -puN arch/sparc/kernel/pcic.c~convert-sparc-to-arch_gettimeoffset arch/sparc/kernel/pcic.c
--- a/arch/sparc/kernel/pcic.c~convert-sparc-to-arch_gettimeoffset
+++ a/arch/sparc/kernel/pcic.c
@@ -163,8 +163,6 @@ void __iomem *pcic_regs;
 volatile int pcic_speculative;
 volatile int pcic_trapped;
 
-static void pci_do_gettimeofday(struct timeval *tv);
-static int pci_do_settimeofday(struct timespec *tv);
 
 #define CONFIG_CMD(bus, device_fn, where) (0x80000000 | (((unsigned int)bus) << 16) | (((unsigned int)device_fn) << 8) | (where & ~3))
 
@@ -716,19 +714,29 @@ static irqreturn_t pcic_timer_handler (i
 #define USECS_PER_JIFFY  10000  /* We have 100HZ "standard" timer for sparc */
 #define TICK_TIMER_LIMIT ((100*1000000/4)/100)
 
+extern u32 (*do_arch_gettimeoffset)(void);
+
+u32 pci_gettimeoffset(void)
+{
+	/*
+	 * We divide all by 100
+	 * to have microsecond resolution and to avoid overflow
+	 */
+	unsigned long count =
+	    readl(pcic0.pcic_regs+PCI_SYS_COUNTER) & ~PCI_SYS_COUNTER_OVERFLOW;
+	count = ((count/100)*USECS_PER_JIFFY) / (TICK_TIMER_LIMIT/100);
+	return count * 1000;
+}
+
+
 void __init pci_time_init(void)
 {
 	struct linux_pcic *pcic = &pcic0;
 	unsigned long v;
 	int timer_irq, irq;
 
-	/* A hack until do_gettimeofday prototype is moved to arch specific headers
-	   and btfixupped. Patch do_gettimeofday with ba pci_do_gettimeofday; nop */
-	((unsigned int *)do_gettimeofday)[0] = 
-	    0x10800000 | ((((unsigned long)pci_do_gettimeofday -
-	     (unsigned long)do_gettimeofday) >> 2) & 0x003fffff);
-	((unsigned int *)do_gettimeofday)[1] = 0x01000000;
-	BTFIXUPSET_CALL(bus_do_settimeofday, pci_do_settimeofday, BTFIXUPCALL_NORM);
+	do_arch_gettimeoffset = pci_gettimeoffset;
+
 	btfixup();
 
 	writel (TICK_TIMER_LIMIT, pcic->pcic_regs+PCI_SYS_LIMIT);
@@ -746,84 +754,6 @@ void __init pci_time_init(void)
 	local_irq_enable();
 }
 
-static inline unsigned long do_gettimeoffset(void)
-{
-	/*
-	 * We divide all by 100
-	 * to have microsecond resolution and to avoid overflow
-	 */
-	unsigned long count =
-	    readl(pcic0.pcic_regs+PCI_SYS_COUNTER) & ~PCI_SYS_COUNTER_OVERFLOW;
-	count = ((count/100)*USECS_PER_JIFFY) / (TICK_TIMER_LIMIT/100);
-	return count;
-}
-
-static void pci_do_gettimeofday(struct timeval *tv)
-{
-	unsigned long flags;
-	unsigned long seq;
-	unsigned long usec, sec;
-	unsigned long max_ntp_tick = tick_usec - tickadj;
-
-	do {
-		seq = read_seqbegin_irqsave(&xtime_lock, flags);
-		usec = do_gettimeoffset();
-
-		/*
-		 * If time_adjust is negative then NTP is slowing the clock
-		 * so make sure not to go into next possible interval.
-		 * Better to lose some accuracy than have time go backwards..
-		 */
-		if (unlikely(time_adjust < 0))
-			usec = min(usec, max_ntp_tick);
-
-		sec = xtime.tv_sec;
-		usec += (xtime.tv_nsec / 1000);
-	} while (read_seqretry_irqrestore(&xtime_lock, seq, flags));
-
-	while (usec >= 1000000) {
-		usec -= 1000000;
-		sec++;
-	}
-
-	tv->tv_sec = sec;
-	tv->tv_usec = usec;
-}
-
-static int pci_do_settimeofday(struct timespec *tv)
-{
-	if ((unsigned long)tv->tv_nsec >= NSEC_PER_SEC)
-		return -EINVAL;
-
-	/*
-	 * This is revolting. We need to set "xtime" correctly. However, the
-	 * value in this location is the value at the most recent update of
-	 * wall time.  Discover what correction gettimeofday() would have
-	 * made, and then undo it!
-	 */
-	tv->tv_nsec -= 1000 * do_gettimeoffset();
-	while (tv->tv_nsec < 0) {
-		tv->tv_nsec += NSEC_PER_SEC;
-		tv->tv_sec--;
-	}
-
-	wall_to_monotonic.tv_sec += xtime.tv_sec - tv->tv_sec;
-	wall_to_monotonic.tv_nsec += xtime.tv_nsec - tv->tv_nsec;
-
-	if (wall_to_monotonic.tv_nsec > NSEC_PER_SEC) {
-		wall_to_monotonic.tv_nsec -= NSEC_PER_SEC;
-		wall_to_monotonic.tv_sec++;
-	}
-	if (wall_to_monotonic.tv_nsec < 0) {
-		wall_to_monotonic.tv_nsec += NSEC_PER_SEC;
-		wall_to_monotonic.tv_sec--;
-	}
-
-	xtime.tv_sec = tv->tv_sec;
-	xtime.tv_nsec = tv->tv_nsec;
-	ntp_clear();
-	return 0;
-}
 
 #if 0
 static void watchdog_reset() {
diff -puN arch/sparc/kernel/time_32.c~convert-sparc-to-arch_gettimeoffset arch/sparc/kernel/time_32.c
--- a/arch/sparc/kernel/time_32.c~convert-sparc-to-arch_gettimeoffset
+++ a/arch/sparc/kernel/time_32.c
@@ -51,7 +51,6 @@ DEFINE_SPINLOCK(rtc_lock);
 EXPORT_SYMBOL(rtc_lock);
 
 static int set_rtc_mmss(unsigned long);
-static int sbus_do_settimeofday(struct timespec *tv);
 
 unsigned long profile_pc(struct pt_regs *regs)
 {
@@ -76,6 +75,8 @@ EXPORT_SYMBOL(profile_pc);
 
 __volatile__ unsigned int *master_l10_counter;
 
+u32 (*do_arch_gettimeoffset)(void);
+
 /*
  * timer_interrupt() needs to keep up the real-time clock,
  * as well as call the "do_timer()" routine every clocktick
@@ -196,35 +197,14 @@ static int __init clock_init(void)
 {
 	return of_register_driver(&clock_driver, &of_platform_bus_type);
 }
-
 /* Must be after subsys_initcall() so that busses are probed.  Must
  * be before device_initcall() because things like the RTC driver
  * need to see the clock registers.
  */
 fs_initcall(clock_init);
 
-static void __init sbus_time_init(void)
-{
-
-	BTFIXUPSET_CALL(bus_do_settimeofday, sbus_do_settimeofday, BTFIXUPCALL_NORM);
-	btfixup();
-
-	sparc_init_timers(timer_interrupt);
-}
-
-void __init time_init(void)
-{
-#ifdef CONFIG_PCI
-	extern void pci_time_init(void);
-	if (pcic_present()) {
-		pci_time_init();
-		return;
-	}
-#endif
-	sbus_time_init();
-}
 
-static inline unsigned long do_gettimeoffset(void)
+u32 sbus_do_gettimeoffset(void)
 {
 	unsigned long val = *master_l10_counter;
 	unsigned long usec = (val >> 10) & 0x1fffff;
@@ -233,86 +213,39 @@ static inline unsigned long do_gettimeof
 	if (val & 0x80000000)
 		usec += 1000000 / HZ;
 
-	return usec;
+	return usec * 1000;
 }
 
-/* Ok, my cute asm atomicity trick doesn't work anymore.
- * There are just too many variables that need to be protected
- * now (both members of xtime, et al.)
- */
-void do_gettimeofday(struct timeval *tv)
-{
-	unsigned long flags;
-	unsigned long seq;
-	unsigned long usec, sec;
-	unsigned long max_ntp_tick = tick_usec - tickadj;
-
-	do {
-		seq = read_seqbegin_irqsave(&xtime_lock, flags);
-		usec = do_gettimeoffset();
-
-		/*
-		 * If time_adjust is negative then NTP is slowing the clock
-		 * so make sure not to go into next possible interval.
-		 * Better to lose some accuracy than have time go backwards..
-		 */
-		if (unlikely(time_adjust < 0))
-			usec = min(usec, max_ntp_tick);
-
-		sec = xtime.tv_sec;
-		usec += (xtime.tv_nsec / 1000);
-	} while (read_seqretry_irqrestore(&xtime_lock, seq, flags));
-
-	while (usec >= 1000000) {
-		usec -= 1000000;
-		sec++;
-	}
 
-	tv->tv_sec = sec;
-	tv->tv_usec = usec;
-}
-
-EXPORT_SYMBOL(do_gettimeofday);
-
-int do_settimeofday(struct timespec *tv)
+u32 arch_gettimeoffset(void)
 {
-	int ret;
-
-	write_seqlock_irq(&xtime_lock);
-	ret = bus_do_settimeofday(tv);
-	write_sequnlock_irq(&xtime_lock);
-	clock_was_set();
-	return ret;
+	if (unlikely(!do_arch_gettimeoffset))
+		return 0;
+	return do_arch_gettimeoffset();
 }
 
-EXPORT_SYMBOL(do_settimeofday);
-
-static int sbus_do_settimeofday(struct timespec *tv)
+static void __init sbus_time_init(void)
 {
-	time_t wtm_sec, sec = tv->tv_sec;
-	long wtm_nsec, nsec = tv->tv_nsec;
+	do_arch_gettimeoffset = sbus_do_gettimeoffset;
 
-	if ((unsigned long)tv->tv_nsec >= NSEC_PER_SEC)
-		return -EINVAL;
-
-	/*
-	 * This is revolting. We need to set "xtime" correctly. However, the
-	 * value in this location is the value at the most recent update of
-	 * wall time.  Discover what correction gettimeofday() would have
-	 * made, and then undo it!
-	 */
-	nsec -= 1000 * do_gettimeoffset();
-
-	wtm_sec  = wall_to_monotonic.tv_sec + (xtime.tv_sec - sec);
-	wtm_nsec = wall_to_monotonic.tv_nsec + (xtime.tv_nsec - nsec);
+	btfixup();
 
-	set_normalized_timespec(&xtime, sec, nsec);
-	set_normalized_timespec(&wall_to_monotonic, wtm_sec, wtm_nsec);
+	sparc_init_timers(timer_interrupt);
+}
 
-	ntp_clear();
-	return 0;
+void __init time_init(void)
+{
+#ifdef CONFIG_PCI
+	extern void pci_time_init(void);
+	if (pcic_present()) {
+		pci_time_init();
+		return;
+	}
+#endif
+	sbus_time_init();
 }
 
+
 static int set_rtc_mmss(unsigned long secs)
 {
 	struct rtc_device *rtc = rtc_class_open("rtc0");
_

Patches currently in -mm which might be from johnstul@us.ibm.com are

origin.patch
arm-convert-to-arch_gettimeoffset.patch
clocksource-add-argument-to-resume-callback.patch
clocksource-start-cmt-at-clocksource-resume.patch
clocksource-add-suspend-callback.patch
genirq-warn-about-irqf_sharedirqf_disabled-at-the-right-place.patch
cris-convert-to-use-arch_gettimeoffset.patch

