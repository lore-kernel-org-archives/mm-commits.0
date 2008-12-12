From: akpm@linux-foundation.org
Subject: + clocksource-pass-clocksource-to-read-callback.patch added to -mm tree
Date: Thu, 11 Dec 2008 19:08:29 -0800
Message-ID: <200812120308.mBC38TRx026436@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35392 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757013AbYLLDRl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 11 Dec 2008 22:17:41 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: damm@igel.co.jp, johnstul@us.ibm.com, tglx@linutronix.de


The patch titled
     clocksource: pass clocksource to read() callback
has been added to the -mm tree.  Its filename is
     clocksource-pass-clocksource-to-read-callback.patch

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
Subject: clocksource: pass clocksource to read() callback
From: Magnus Damm <damm@igel.co.jp>

Pass clocksource pointer to the read() callback for clocksources.  This
allows us to share the callback between multiple instances.

Signed-off-by: Magnus Damm <damm@igel.co.jp>
Acked-by: John Stultz <johnstul@us.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/mach-at91/at91rm9200_time.c         |    2 +-
 arch/arm/mach-at91/at91sam926x_time.c        |    2 +-
 arch/arm/mach-davinci/time.c                 |    2 +-
 arch/arm/mach-imx/time.c                     |    2 +-
 arch/arm/mach-ixp4xx/common.c                |    2 +-
 arch/arm/mach-msm/timer.c                    |    4 ++--
 arch/arm/mach-netx/time.c                    |    2 +-
 arch/arm/mach-ns9xxx/time-ns9360.c           |    2 +-
 arch/arm/mach-omap1/time.c                   |    2 +-
 arch/arm/mach-omap2/timer-gp.c               |    2 +-
 arch/arm/mach-pxa/time.c                     |    2 +-
 arch/arm/mach-realview/core.c                |    2 +-
 arch/arm/mach-versatile/core.c               |    2 +-
 arch/arm/plat-mxc/time.c                     |    2 +-
 arch/arm/plat-omap/common.c                  |    4 ++--
 arch/arm/plat-orion/time.c                   |    2 +-
 arch/avr32/kernel/time.c                     |    2 +-
 arch/blackfin/kernel/time-ts.c               |   12 ++++++------
 arch/ia64/kernel/cyclone.c                   |    2 +-
 arch/ia64/kernel/time.c                      |    4 ++--
 arch/ia64/sn/kernel/sn2/timer.c              |    2 +-
 arch/m68knommu/platform/68328/timers.c       |    2 +-
 arch/m68knommu/platform/coldfire/dma_timer.c |    2 +-
 arch/m68knommu/platform/coldfire/pit.c       |    2 +-
 arch/m68knommu/platform/coldfire/timers.c    |    2 +-
 arch/mips/kernel/cevt-txx9.c                 |    2 +-
 arch/mips/kernel/csrc-bcm1480.c              |    2 +-
 arch/mips/kernel/csrc-ioasic.c               |    6 +++---
 arch/mips/kernel/csrc-r4k.c                  |    2 +-
 arch/mips/kernel/csrc-sb1250.c               |    2 +-
 arch/mips/kernel/i8253.c                     |    2 +-
 arch/mips/nxp/pnx8550/common/time.c          |    2 +-
 arch/mips/sgi-ip27/ip27-timer.c              |    2 +-
 arch/powerpc/kernel/time.c                   |    4 ++--
 arch/s390/kernel/time.c                      |    2 +-
 arch/sh/include/asm/timer.h                  |    2 +-
 arch/sh/kernel/time_32.c                     |    4 ++--
 arch/sh/kernel/timers/timer-tmu.c            |    2 +-
 arch/sparc/include/asm/timer_64.h            |    3 ++-
 arch/sparc/kernel/time_64.c                  |   14 +++++++-------
 arch/um/kernel/time.c                        |    2 +-
 arch/x86/kernel/hpet.c                       |    6 +++---
 arch/x86/kernel/i8253.c                      |    2 +-
 arch/x86/kernel/kvmclock.c                   |    7 ++++++-
 arch/x86/kernel/tsc.c                        |    2 +-
 arch/x86/kernel/vmiclock_32.c                |    2 +-
 arch/x86/lguest/boot.c                       |    2 +-
 arch/x86/xen/time.c                          |    7 ++++++-
 drivers/char/hpet.c                          |    2 +-
 drivers/clocksource/acpi_pm.c                |   12 ++++++------
 drivers/clocksource/cyclone.c                |    2 +-
 drivers/clocksource/scx200_hrt.c             |    2 +-
 drivers/clocksource/tcb_clksrc.c             |    2 +-
 include/linux/clocksource.h                  |    6 +++---
 kernel/time/jiffies.c                        |    2 +-
 55 files changed, 93 insertions(+), 82 deletions(-)

diff -puN arch/arm/mach-at91/at91rm9200_time.c~clocksource-pass-clocksource-to-read-callback arch/arm/mach-at91/at91rm9200_time.c
--- a/arch/arm/mach-at91/at91rm9200_time.c~clocksource-pass-clocksource-to-read-callback
+++ a/arch/arm/mach-at91/at91rm9200_time.c
@@ -85,7 +85,7 @@ static struct irqaction at91rm9200_timer
 	.handler	= at91rm9200_timer_interrupt
 };
 
-static cycle_t read_clk32k(void)
+static cycle_t read_clk32k(struct clocksource *cs)
 {
 	return read_CRTR();
 }
diff -puN arch/arm/mach-at91/at91sam926x_time.c~clocksource-pass-clocksource-to-read-callback arch/arm/mach-at91/at91sam926x_time.c
--- a/arch/arm/mach-at91/at91sam926x_time.c~clocksource-pass-clocksource-to-read-callback
+++ a/arch/arm/mach-at91/at91sam926x_time.c
@@ -31,7 +31,7 @@ static u32 pit_cnt;		/* access only w/sy
  * Clocksource:  just a monotonic counter of MCK/16 cycles.
  * We don't care whether or not PIT irqs are enabled.
  */
-static cycle_t read_pit_clk(void)
+static cycle_t read_pit_clk(struct clocksource *cs)
 {
 	unsigned long flags;
 	u32 elapsed;
diff -puN arch/arm/mach-davinci/time.c~clocksource-pass-clocksource-to-read-callback arch/arm/mach-davinci/time.c
--- a/arch/arm/mach-davinci/time.c~clocksource-pass-clocksource-to-read-callback
+++ a/arch/arm/mach-davinci/time.c
@@ -238,7 +238,7 @@ static void __init timer_init(void)
 /*
  * clocksource
  */
-static cycle_t read_cycles(void)
+static cycle_t read_cycles(struct clocksource *cs)
 {
 	struct timer_s *t = &timers[TID_CLOCKSOURCE];
 
diff -puN arch/arm/mach-imx/time.c~clocksource-pass-clocksource-to-read-callback arch/arm/mach-imx/time.c
--- a/arch/arm/mach-imx/time.c~clocksource-pass-clocksource-to-read-callback
+++ a/arch/arm/mach-imx/time.c
@@ -73,7 +73,7 @@ static void __init imx_timer_hardware_in
 	IMX_TCTL(TIMER_BASE) = TCTL_FRR | TCTL_CLK_PCLK1 | TCTL_TEN;
 }
 
-cycle_t imx_get_cycles(void)
+cycle_t imx_get_cycles(struct clocksource *cs)
 {
 	return IMX_TCN(TIMER_BASE);
 }
diff -puN arch/arm/mach-ixp4xx/common.c~clocksource-pass-clocksource-to-read-callback arch/arm/mach-ixp4xx/common.c
--- a/arch/arm/mach-ixp4xx/common.c~clocksource-pass-clocksource-to-read-callback
+++ a/arch/arm/mach-ixp4xx/common.c
@@ -401,7 +401,7 @@ void __init ixp4xx_sys_init(void)
 /*
  * clocksource
  */
-cycle_t ixp4xx_get_cycles(void)
+cycle_t ixp4xx_get_cycles(struct clocksource *cs)
 {
 	return *IXP4XX_OSTS;
 }
diff -puN arch/arm/mach-msm/timer.c~clocksource-pass-clocksource-to-read-callback arch/arm/mach-msm/timer.c
--- a/arch/arm/mach-msm/timer.c~clocksource-pass-clocksource-to-read-callback
+++ a/arch/arm/mach-msm/timer.c
@@ -57,12 +57,12 @@ static irqreturn_t msm_timer_interrupt(i
 	return IRQ_HANDLED;
 }
 
-static cycle_t msm_gpt_read(void)
+static cycle_t msm_gpt_read(struct clocksource *cs)
 {
 	return readl(MSM_GPT_BASE + TIMER_COUNT_VAL);
 }
 
-static cycle_t msm_dgt_read(void)
+static cycle_t msm_dgt_read(struct clocksource *cs)
 {
 	return readl(MSM_DGT_BASE + TIMER_COUNT_VAL) >> MSM_DGT_SHIFT;
 }
diff -puN arch/arm/mach-netx/time.c~clocksource-pass-clocksource-to-read-callback arch/arm/mach-netx/time.c
--- a/arch/arm/mach-netx/time.c~clocksource-pass-clocksource-to-read-callback
+++ a/arch/arm/mach-netx/time.c
@@ -47,7 +47,7 @@ static struct irqaction netx_timer_irq =
 	.handler        = netx_timer_interrupt,
 };
 
-cycle_t netx_get_cycles(void)
+cycle_t netx_get_cycles(struct clocksource *cs)
 {
 	return readl(NETX_GPIO_COUNTER_CURRENT(1));
 }
diff -puN arch/arm/mach-ns9xxx/time-ns9360.c~clocksource-pass-clocksource-to-read-callback arch/arm/mach-ns9xxx/time-ns9360.c
--- a/arch/arm/mach-ns9xxx/time-ns9360.c~clocksource-pass-clocksource-to-read-callback
+++ a/arch/arm/mach-ns9xxx/time-ns9360.c
@@ -25,7 +25,7 @@
 #define TIMER_CLOCKEVENT 1
 static u32 latch;
 
-static cycle_t ns9360_clocksource_read(void)
+static cycle_t ns9360_clocksource_read(struct clocksource *cs)
 {
 	return __raw_readl(SYS_TR(TIMER_CLOCKSOURCE));
 }
diff -puN arch/arm/mach-omap1/time.c~clocksource-pass-clocksource-to-read-callback arch/arm/mach-omap1/time.c
--- a/arch/arm/mach-omap1/time.c~clocksource-pass-clocksource-to-read-callback
+++ a/arch/arm/mach-omap1/time.c
@@ -198,7 +198,7 @@ static struct irqaction omap_mpu_timer2_
 	.handler	= omap_mpu_timer2_interrupt,
 };
 
-static cycle_t mpu_read(void)
+static cycle_t mpu_read(struct clocksource *cs)
 {
 	return ~omap_mpu_timer_read(1);
 }
diff -puN arch/arm/mach-omap2/timer-gp.c~clocksource-pass-clocksource-to-read-callback arch/arm/mach-omap2/timer-gp.c
--- a/arch/arm/mach-omap2/timer-gp.c~clocksource-pass-clocksource-to-read-callback
+++ a/arch/arm/mach-omap2/timer-gp.c
@@ -137,7 +137,7 @@ static inline void __init omap2_gp_clock
  * clocksource
  */
 static struct omap_dm_timer *gpt_clocksource;
-static cycle_t clocksource_read_cycles(void)
+static cycle_t clocksource_read_cycles(struct clocksource *cs)
 {
 	return (cycle_t)omap_dm_timer_read_counter(gpt_clocksource);
 }
diff -puN arch/arm/mach-pxa/time.c~clocksource-pass-clocksource-to-read-callback arch/arm/mach-pxa/time.c
--- a/arch/arm/mach-pxa/time.c~clocksource-pass-clocksource-to-read-callback
+++ a/arch/arm/mach-pxa/time.c
@@ -127,7 +127,7 @@ static struct clock_event_device ckevt_p
 	.set_mode	= pxa_osmr0_set_mode,
 };
 
-static cycle_t pxa_read_oscr(void)
+static cycle_t pxa_read_oscr(struct clocksource *cs)
 {
 	return OSCR;
 }
diff -puN arch/arm/mach-realview/core.c~clocksource-pass-clocksource-to-read-callback arch/arm/mach-realview/core.c
--- a/arch/arm/mach-realview/core.c~clocksource-pass-clocksource-to-read-callback
+++ a/arch/arm/mach-realview/core.c
@@ -661,7 +661,7 @@ static struct irqaction realview_timer_i
 	.handler	= realview_timer_interrupt,
 };
 
-static cycle_t realview_get_cycles(void)
+static cycle_t realview_get_cycles(struct clocksource *cs)
 {
 	return ~readl(timer3_va_base + TIMER_VALUE);
 }
diff -puN arch/arm/mach-versatile/core.c~clocksource-pass-clocksource-to-read-callback arch/arm/mach-versatile/core.c
--- a/arch/arm/mach-versatile/core.c~clocksource-pass-clocksource-to-read-callback
+++ a/arch/arm/mach-versatile/core.c
@@ -934,7 +934,7 @@ static struct irqaction versatile_timer_
 	.handler	= versatile_timer_interrupt,
 };
 
-static cycle_t versatile_get_cycles(void)
+static cycle_t versatile_get_cycles(struct clocksource *cs)
 {
 	return ~readl(TIMER3_VA_BASE + TIMER_VALUE);
 }
diff -puN arch/arm/plat-mxc/time.c~clocksource-pass-clocksource-to-read-callback arch/arm/plat-mxc/time.c
--- a/arch/arm/plat-mxc/time.c~clocksource-pass-clocksource-to-read-callback
+++ a/arch/arm/plat-mxc/time.c
@@ -39,7 +39,7 @@ static struct clk *timer_clk;
 
 /* clock source */
 
-static cycle_t mxc_get_cycles(void)
+static cycle_t mxc_get_cycles(struct clocksource *cs)
 {
 	return __raw_readl(TIMER_BASE + MXC_TCN);
 }
diff -puN arch/arm/plat-omap/common.c~clocksource-pass-clocksource-to-read-callback arch/arm/plat-omap/common.c
--- a/arch/arm/plat-omap/common.c~clocksource-pass-clocksource-to-read-callback
+++ a/arch/arm/plat-omap/common.c
@@ -185,7 +185,7 @@ console_initcall(omap_add_serial_console
 
 #include <linux/clocksource.h>
 
-static cycle_t omap_32k_read(void)
+static cycle_t omap_32k_read(struct clocksource *cs)
 {
 	return omap_readl(TIMER_32K_SYNCHRONIZED);
 }
@@ -213,7 +213,7 @@ unsigned long long omap_32k_ticks_to_nse
  */
 unsigned long long sched_clock(void)
 {
-	return omap_32k_ticks_to_nsecs(omap_32k_read());
+	return omap_32k_ticks_to_nsecs(omap_32k_read(&clocksource_32k));
 }
 
 static int __init omap_init_clocksource_32k(void)
diff -puN arch/arm/plat-orion/time.c~clocksource-pass-clocksource-to-read-callback arch/arm/plat-orion/time.c
--- a/arch/arm/plat-orion/time.c~clocksource-pass-clocksource-to-read-callback
+++ a/arch/arm/plat-orion/time.c
@@ -41,7 +41,7 @@ static u32 ticks_per_jiffy;
 /*
  * Clocksource handling.
  */
-static cycle_t orion_clksrc_read(void)
+static cycle_t orion_clksrc_read(struct clocksource *cs)
 {
 	return 0xffffffff - readl(TIMER0_VAL);
 }
diff -puN arch/avr32/kernel/time.c~clocksource-pass-clocksource-to-read-callback arch/avr32/kernel/time.c
--- a/arch/avr32/kernel/time.c~clocksource-pass-clocksource-to-read-callback
+++ a/arch/avr32/kernel/time.c
@@ -18,7 +18,7 @@
 #include <mach/pm.h>
 
 
-static cycle_t read_cycle_count(void)
+static cycle_t read_cycle_count(struct clocksource *cs)
 {
 	return (cycle_t)sysreg_read(COUNT);
 }
diff -puN arch/blackfin/kernel/time-ts.c~clocksource-pass-clocksource-to-read-callback arch/blackfin/kernel/time-ts.c
--- a/arch/blackfin/kernel/time-ts.c~clocksource-pass-clocksource-to-read-callback
+++ a/arch/blackfin/kernel/time-ts.c
@@ -58,16 +58,11 @@ static inline unsigned long long cycles_
 	return (cyc * cyc2ns_scale) >> CYC2NS_SCALE_FACTOR;
 }
 
-static cycle_t read_cycles(void)
+static cycle_t read_cycles(struct clocksource *cs)
 {
 	return __bfin_cycles_off + (get_cycles() << __bfin_cycles_mod);
 }
 
-unsigned long long sched_clock(void)
-{
-	return cycles_2_ns(read_cycles());
-}
-
 static struct clocksource clocksource_bfin = {
 	.name		= "bfin_cycles",
 	.rating		= 350,
@@ -77,6 +72,11 @@ static struct clocksource clocksource_bf
 	.flags		= CLOCK_SOURCE_IS_CONTINUOUS,
 };
 
+unsigned long long sched_clock(void)
+{
+	return cycles_2_ns(read_cycles(&clocksource_bfin));
+}
+
 static int __init bfin_clocksource_init(void)
 {
 	set_cyc2ns_scale(get_cclk() / 1000);
diff -puN arch/ia64/kernel/cyclone.c~clocksource-pass-clocksource-to-read-callback arch/ia64/kernel/cyclone.c
--- a/arch/ia64/kernel/cyclone.c~clocksource-pass-clocksource-to-read-callback
+++ a/arch/ia64/kernel/cyclone.c
@@ -21,7 +21,7 @@ void __init cyclone_setup(void)
 
 static void __iomem *cyclone_mc;
 
-static cycle_t read_cyclone(void)
+static cycle_t read_cyclone(struct clocksource *cs)
 {
 	return (cycle_t)readq((void __iomem *)cyclone_mc);
 }
diff -puN arch/ia64/kernel/time.c~clocksource-pass-clocksource-to-read-callback arch/ia64/kernel/time.c
--- a/arch/ia64/kernel/time.c~clocksource-pass-clocksource-to-read-callback
+++ a/arch/ia64/kernel/time.c
@@ -32,7 +32,7 @@
 
 #include "fsyscall_gtod_data.h"
 
-static cycle_t itc_get_cycles(void);
+static cycle_t itc_get_cycles(struct clocksource *cs);
 
 struct fsyscall_gtod_data_t fsyscall_gtod_data = {
 	.lock = SEQLOCK_UNLOCKED,
@@ -373,7 +373,7 @@ ia64_init_itm (void)
 	}
 }
 
-static cycle_t itc_get_cycles(void)
+static cycle_t itc_get_cycles(struct clocksource *cs)
 {
 	u64 lcycle, now, ret;
 
diff -puN arch/ia64/sn/kernel/sn2/timer.c~clocksource-pass-clocksource-to-read-callback arch/ia64/sn/kernel/sn2/timer.c
--- a/arch/ia64/sn/kernel/sn2/timer.c~clocksource-pass-clocksource-to-read-callback
+++ a/arch/ia64/sn/kernel/sn2/timer.c
@@ -23,7 +23,7 @@
 
 extern unsigned long sn_rtc_cycles_per_second;
 
-static cycle_t read_sn2(void)
+static cycle_t read_sn2(struct clocksource *cs)
 {
 	return (cycle_t)readq(RTC_COUNTER_ADDR);
 }
diff -puN arch/m68knommu/platform/68328/timers.c~clocksource-pass-clocksource-to-read-callback arch/m68knommu/platform/68328/timers.c
--- a/arch/m68knommu/platform/68328/timers.c~clocksource-pass-clocksource-to-read-callback
+++ a/arch/m68knommu/platform/68328/timers.c
@@ -75,7 +75,7 @@ static struct irqaction m68328_timer_irq
 
 /***************************************************************************/
 
-static cycle_t m68328_read_clk(void)
+static cycle_t m68328_read_clk(struct clocksource *cs)
 {
 	unsigned long flags;
 	u32 cycles;
diff -puN arch/m68knommu/platform/coldfire/dma_timer.c~clocksource-pass-clocksource-to-read-callback arch/m68knommu/platform/coldfire/dma_timer.c
--- a/arch/m68knommu/platform/coldfire/dma_timer.c~clocksource-pass-clocksource-to-read-callback
+++ a/arch/m68knommu/platform/coldfire/dma_timer.c
@@ -34,7 +34,7 @@
 #define DMA_DTMR_CLK_DIV_16	(2 << 1)
 #define DMA_DTMR_ENABLE		(1 << 0)
 
-static cycle_t cf_dt_get_cycles(void)
+static cycle_t cf_dt_get_cycles(struct clocksource *cs)
 {
 	return __raw_readl(DTCN0);
 }
diff -puN arch/m68knommu/platform/coldfire/pit.c~clocksource-pass-clocksource-to-read-callback arch/m68knommu/platform/coldfire/pit.c
--- a/arch/m68knommu/platform/coldfire/pit.c~clocksource-pass-clocksource-to-read-callback
+++ a/arch/m68knommu/platform/coldfire/pit.c
@@ -125,7 +125,7 @@ static struct irqaction pit_irq = {
 
 /***************************************************************************/
 
-static cycle_t pit_read_clk(void)
+static cycle_t pit_read_clk(struct clocksource *cs)
 {
 	unsigned long flags;
 	u32 cycles;
diff -puN arch/m68knommu/platform/coldfire/timers.c~clocksource-pass-clocksource-to-read-callback arch/m68knommu/platform/coldfire/timers.c
--- a/arch/m68knommu/platform/coldfire/timers.c~clocksource-pass-clocksource-to-read-callback
+++ a/arch/m68knommu/platform/coldfire/timers.c
@@ -78,7 +78,7 @@ static struct irqaction mcftmr_timer_irq
 
 /***************************************************************************/
 
-static cycle_t mcftmr_read_clk(void)
+static cycle_t mcftmr_read_clk(struct clocksource *cs)
 {
 	unsigned long flags;
 	u32 cycles;
diff -puN arch/mips/kernel/cevt-txx9.c~clocksource-pass-clocksource-to-read-callback arch/mips/kernel/cevt-txx9.c
--- a/arch/mips/kernel/cevt-txx9.c~clocksource-pass-clocksource-to-read-callback
+++ a/arch/mips/kernel/cevt-txx9.c
@@ -22,7 +22,7 @@
 
 static struct txx9_tmr_reg __iomem *txx9_cs_tmrptr;
 
-static cycle_t txx9_cs_read(void)
+static cycle_t txx9_cs_read(struct clocksource *cs)
 {
 	return __raw_readl(&txx9_cs_tmrptr->trr);
 }
diff -puN arch/mips/kernel/csrc-bcm1480.c~clocksource-pass-clocksource-to-read-callback arch/mips/kernel/csrc-bcm1480.c
--- a/arch/mips/kernel/csrc-bcm1480.c~clocksource-pass-clocksource-to-read-callback
+++ a/arch/mips/kernel/csrc-bcm1480.c
@@ -28,7 +28,7 @@
 
 #include <asm/sibyte/sb1250.h>
 
-static cycle_t bcm1480_hpt_read(void)
+static cycle_t bcm1480_hpt_read(struct clocksource *cs)
 {
 	return (cycle_t) __raw_readq(IOADDR(A_SCD_ZBBUS_CYCLE_COUNT));
 }
diff -puN arch/mips/kernel/csrc-ioasic.c~clocksource-pass-clocksource-to-read-callback arch/mips/kernel/csrc-ioasic.c
--- a/arch/mips/kernel/csrc-ioasic.c~clocksource-pass-clocksource-to-read-callback
+++ a/arch/mips/kernel/csrc-ioasic.c
@@ -25,7 +25,7 @@
 #include <asm/dec/ioasic.h>
 #include <asm/dec/ioasic_addrs.h>
 
-static cycle_t dec_ioasic_hpt_read(void)
+static cycle_t dec_ioasic_hpt_read(struct clocksource *cs)
 {
 	return ioasic_read(IO_REG_FCTR);
 }
@@ -47,13 +47,13 @@ void __init dec_ioasic_clocksource_init(
 	while (!ds1287_timer_state())
 		;
 
-	start = dec_ioasic_hpt_read();
+	start = dec_ioasic_hpt_read(&clocksource_dec);
 
 	while (i--)
 		while (!ds1287_timer_state())
 			;
 
-	end = dec_ioasic_hpt_read();
+	end = dec_ioasic_hpt_read(&clocksource_dec);
 
 	freq = (end - start) * 10;
 	printk(KERN_INFO "I/O ASIC clock frequency %dHz\n", freq);
diff -puN arch/mips/kernel/csrc-r4k.c~clocksource-pass-clocksource-to-read-callback arch/mips/kernel/csrc-r4k.c
--- a/arch/mips/kernel/csrc-r4k.c~clocksource-pass-clocksource-to-read-callback
+++ a/arch/mips/kernel/csrc-r4k.c
@@ -10,7 +10,7 @@
 
 #include <asm/time.h>
 
-static cycle_t c0_hpt_read(void)
+static cycle_t c0_hpt_read(struct clocksource *cs)
 {
 	return read_c0_count();
 }
diff -puN arch/mips/kernel/csrc-sb1250.c~clocksource-pass-clocksource-to-read-callback arch/mips/kernel/csrc-sb1250.c
--- a/arch/mips/kernel/csrc-sb1250.c~clocksource-pass-clocksource-to-read-callback
+++ a/arch/mips/kernel/csrc-sb1250.c
@@ -33,7 +33,7 @@
  * The HPT is free running from SB1250_HPT_VALUE down to 0 then starts over
  * again.
  */
-static cycle_t sb1250_hpt_read(void)
+static cycle_t sb1250_hpt_read(struct clocksource *cs)
 {
 	unsigned int count;
 
diff -puN arch/mips/kernel/i8253.c~clocksource-pass-clocksource-to-read-callback arch/mips/kernel/i8253.c
--- a/arch/mips/kernel/i8253.c~clocksource-pass-clocksource-to-read-callback
+++ a/arch/mips/kernel/i8253.c
@@ -130,7 +130,7 @@ void __init setup_pit_timer(void)
  * to just read by itself. So use jiffies to emulate a free
  * running counter:
  */
-static cycle_t pit_read(void)
+static cycle_t pit_read(struct clocksource *cs)
 {
 	unsigned long flags;
 	int count;
diff -puN arch/mips/nxp/pnx8550/common/time.c~clocksource-pass-clocksource-to-read-callback arch/mips/nxp/pnx8550/common/time.c
--- a/arch/mips/nxp/pnx8550/common/time.c~clocksource-pass-clocksource-to-read-callback
+++ a/arch/mips/nxp/pnx8550/common/time.c
@@ -35,7 +35,7 @@
 
 static unsigned long cpj;
 
-static cycle_t hpt_read(void)
+static cycle_t hpt_read(struct clocksource *cs)
 {
 	return read_c0_count2();
 }
diff -puN arch/mips/sgi-ip27/ip27-timer.c~clocksource-pass-clocksource-to-read-callback arch/mips/sgi-ip27/ip27-timer.c
--- a/arch/mips/sgi-ip27/ip27-timer.c~clocksource-pass-clocksource-to-read-callback
+++ a/arch/mips/sgi-ip27/ip27-timer.c
@@ -159,7 +159,7 @@ static void __init hub_rt_clock_event_gl
 	setup_irq(irq, &hub_rt_irqaction);
 }
 
-static cycle_t hub_rt_read(void)
+static cycle_t hub_rt_read(struct clocksource *cs)
 {
 	return REMOTE_HUB_L(cputonasid(0), PI_RT_COUNT);
 }
diff -puN arch/powerpc/kernel/time.c~clocksource-pass-clocksource-to-read-callback arch/powerpc/kernel/time.c
--- a/arch/powerpc/kernel/time.c~clocksource-pass-clocksource-to-read-callback
+++ a/arch/powerpc/kernel/time.c
@@ -766,12 +766,12 @@ unsigned long read_persistent_clock(void
 }
 
 /* clocksource code */
-static cycle_t rtc_read(void)
+static cycle_t rtc_read(struct clocksource *cs)
 {
 	return (cycle_t)get_rtc();
 }
 
-static cycle_t timebase_read(void)
+static cycle_t timebase_read(struct clocksource *cs)
 {
 	return (cycle_t)get_tb();
 }
diff -puN arch/s390/kernel/time.c~clocksource-pass-clocksource-to-read-callback arch/s390/kernel/time.c
--- a/arch/s390/kernel/time.c~clocksource-pass-clocksource-to-read-callback
+++ a/arch/s390/kernel/time.c
@@ -213,7 +213,7 @@ static u64 __init reset_tod_clock(void)
 	return TOD_UNIX_EPOCH;
 }
 
-static cycle_t read_tod_clock(void)
+static cycle_t read_tod_clock(struct clocksource *cs)
 {
 	return get_clock();
 }
diff -puN arch/sh/include/asm/timer.h~clocksource-pass-clocksource-to-read-callback arch/sh/include/asm/timer.h
--- a/arch/sh/include/asm/timer.h~clocksource-pass-clocksource-to-read-callback
+++ a/arch/sh/include/asm/timer.h
@@ -9,7 +9,7 @@ struct sys_timer_ops {
 	int (*init)(void);
 	int (*start)(void);
 	int (*stop)(void);
-	cycle_t (*read)(void);
+	cycle_t (*read)(struct clocksource *cs);
 #ifndef CONFIG_GENERIC_TIME
 	unsigned long (*get_offset)(void);
 #endif
diff -puN arch/sh/kernel/time_32.c~clocksource-pass-clocksource-to-read-callback arch/sh/kernel/time_32.c
--- a/arch/sh/kernel/time_32.c~clocksource-pass-clocksource-to-read-callback
+++ a/arch/sh/kernel/time_32.c
@@ -44,7 +44,7 @@ static int null_rtc_set_time(const time_
 /*
  * Null high precision timer functions for systems lacking one.
  */
-static cycle_t null_hpt_read(void)
+static cycle_t null_hpt_read(struct clocksource *cs)
 {
 	return 0;
 }
@@ -239,7 +239,7 @@ static void __init init_sh_clocksource(v
 #ifdef CONFIG_GENERIC_TIME
 unsigned long long sched_clock(void)
 {
-	unsigned long long ticks = clocksource_sh.read();
+	unsigned long long ticks = clocksource_sh.read(&clocksource_sh);
 	return (ticks * timer_ticks_per_nsec_quotient) >> NSEC_PER_CYC_SHIFT;
 }
 #endif
diff -puN arch/sh/kernel/timers/timer-tmu.c~clocksource-pass-clocksource-to-read-callback arch/sh/kernel/timers/timer-tmu.c
--- a/arch/sh/kernel/timers/timer-tmu.c~clocksource-pass-clocksource-to-read-callback
+++ a/arch/sh/kernel/timers/timer-tmu.c
@@ -81,7 +81,7 @@ static int tmu_timer_stop(void)
  */
 static int tmus_are_scaled;
 
-static cycle_t tmu_timer_read(void)
+static cycle_t tmu_timer_read(struct clocksource *cs)
 {
 	return ((cycle_t)(~_tmu_read(TMU1)))<<tmus_are_scaled;
 }
diff -puN arch/sparc/include/asm/timer_64.h~clocksource-pass-clocksource-to-read-callback arch/sparc/include/asm/timer_64.h
--- a/arch/sparc/include/asm/timer_64.h~clocksource-pass-clocksource-to-read-callback
+++ a/arch/sparc/include/asm/timer_64.h
@@ -8,9 +8,10 @@
 
 #include <linux/types.h>
 #include <linux/init.h>
+#include <linux/clocksource.h>
 
 struct sparc64_tick_ops {
-	unsigned long (*get_tick)(void);
+	unsigned long (*get_tick)(struct clocksource *cs);
 	int (*add_compare)(unsigned long);
 	unsigned long softint_mask;
 	void (*disable_irq)(void);
diff -puN arch/sparc/kernel/time_64.c~clocksource-pass-clocksource-to-read-callback arch/sparc/kernel/time_64.c
--- a/arch/sparc/kernel/time_64.c~clocksource-pass-clocksource-to-read-callback
+++ a/arch/sparc/kernel/time_64.c
@@ -106,7 +106,7 @@ static void tick_init_tick(void)
 	tick_disable_irq();
 }
 
-static unsigned long tick_get_tick(void)
+static unsigned long tick_get_tick(struct clocksource *cs)
 {
 	unsigned long ret;
 
@@ -208,7 +208,7 @@ static void stick_init_tick(void)
 	stick_disable_irq();
 }
 
-static unsigned long stick_get_tick(void)
+static unsigned long stick_get_tick(struct clocksource *cs)
 {
 	unsigned long ret;
 
@@ -352,7 +352,7 @@ static void hbtick_init_tick(void)
 	hbtick_disable_irq();
 }
 
-static unsigned long hbtick_get_tick(void)
+static unsigned long hbtick_get_tick(struct clocksource *cs)
 {
 	return __hbird_read_stick() & ~TICK_PRIV_BIT;
 }
@@ -799,9 +799,9 @@ void __delay(unsigned long loops)
 {
 	unsigned long bclock, now;
 
-	bclock = tick_ops->get_tick();
+	bclock = tick_ops->get_tick(&clocksource_tick);
 	do {
-		now = tick_ops->get_tick();
+		now = tick_ops->get_tick(&clocksource_tick);
 	} while ((now-bclock) < loops);
 }
 EXPORT_SYMBOL(__delay);
@@ -849,7 +849,7 @@ void __init time_init(void)
 
 unsigned long long sched_clock(void)
 {
-	unsigned long ticks = tick_ops->get_tick();
+	unsigned long ticks = tick_ops->get_tick(&clocksource_tick);
 
 	return (ticks * timer_ticks_per_nsec_quotient)
 		>> SPARC64_NSEC_PER_CYC_SHIFT;
@@ -857,6 +857,6 @@ unsigned long long sched_clock(void)
 
 int __devinit read_current_timer(unsigned long *timer_val)
 {
-	*timer_val = tick_ops->get_tick();
+	*timer_val = tick_ops->get_tick(&clocksource_tick);
 	return 0;
 }
diff -puN arch/um/kernel/time.c~clocksource-pass-clocksource-to-read-callback arch/um/kernel/time.c
--- a/arch/um/kernel/time.c~clocksource-pass-clocksource-to-read-callback
+++ a/arch/um/kernel/time.c
@@ -65,7 +65,7 @@ static irqreturn_t um_timer(int irq, voi
 	return IRQ_HANDLED;
 }
 
-static cycle_t itimer_read(void)
+static cycle_t itimer_read(struct clocksource *cs)
 {
 	return os_nsecs() / 1000;
 }
diff -puN arch/x86/kernel/hpet.c~clocksource-pass-clocksource-to-read-callback arch/x86/kernel/hpet.c
--- a/arch/x86/kernel/hpet.c~clocksource-pass-clocksource-to-read-callback
+++ a/arch/x86/kernel/hpet.c
@@ -673,7 +673,7 @@ static int hpet_cpuhp_notify(struct noti
 /*
  * Clock source related code
  */
-static cycle_t read_hpet(void)
+static cycle_t read_hpet(struct clocksource *cs)
 {
 	return (cycle_t)hpet_readl(HPET_COUNTER);
 }
@@ -707,7 +707,7 @@ static int hpet_clocksource_register(voi
 	hpet_start_counter();
 
 	/* Verify whether hpet counter works */
-	t1 = read_hpet();
+	t1 = hpet_readl(HPET_COUNTER);
 	rdtscll(start);
 
 	/*
@@ -721,7 +721,7 @@ static int hpet_clocksource_register(voi
 		rdtscll(now);
 	} while ((now - start) < 200000UL);
 
-	if (t1 == read_hpet()) {
+	if (t1 == hpet_readl(HPET_COUNTER)) {
 		printk(KERN_WARNING
 		       "HPET counter not counting. HPET disabled\n");
 		return -ENODEV;
diff -puN arch/x86/kernel/i8253.c~clocksource-pass-clocksource-to-read-callback arch/x86/kernel/i8253.c
--- a/arch/x86/kernel/i8253.c~clocksource-pass-clocksource-to-read-callback
+++ a/arch/x86/kernel/i8253.c
@@ -131,7 +131,7 @@ void __init setup_pit_timer(void)
  * to just read by itself. So use jiffies to emulate a free
  * running counter:
  */
-static cycle_t pit_read(void)
+static cycle_t pit_read(struct clocksource *cs)
 {
 	unsigned long flags;
 	int count;
diff -puN arch/x86/kernel/kvmclock.c~clocksource-pass-clocksource-to-read-callback arch/x86/kernel/kvmclock.c
--- a/arch/x86/kernel/kvmclock.c~clocksource-pass-clocksource-to-read-callback
+++ a/arch/x86/kernel/kvmclock.c
@@ -78,6 +78,11 @@ static cycle_t kvm_clock_read(void)
 	return ret;
 }
 
+static cycle_t kvm_clock_get_cycles(struct clocksource *cs)
+{
+	return kvm_clock_read();
+}
+
 /*
  * If we don't do that, there is the possibility that the guest
  * will calibrate under heavy load - thus, getting a lower lpj -
@@ -108,7 +113,7 @@ static void kvm_get_preset_lpj(void)
 
 static struct clocksource kvm_clock = {
 	.name = "kvm-clock",
-	.read = kvm_clock_read,
+	.read = kvm_clock_get_cycles,
 	.rating = 400,
 	.mask = CLOCKSOURCE_MASK(64),
 	.mult = 1 << KVM_SCALE,
diff -puN arch/x86/kernel/tsc.c~clocksource-pass-clocksource-to-read-callback arch/x86/kernel/tsc.c
--- a/arch/x86/kernel/tsc.c~clocksource-pass-clocksource-to-read-callback
+++ a/arch/x86/kernel/tsc.c
@@ -681,7 +681,7 @@ static struct clocksource clocksource_ts
  * code, which is necessary to support wrapping clocksources like pm
  * timer.
  */
-static cycle_t read_tsc(void)
+static cycle_t read_tsc(struct clocksource *cs)
 {
 	cycle_t ret = (cycle_t)get_cycles();
 
diff -puN arch/x86/kernel/vmiclock_32.c~clocksource-pass-clocksource-to-read-callback arch/x86/kernel/vmiclock_32.c
--- a/arch/x86/kernel/vmiclock_32.c~clocksource-pass-clocksource-to-read-callback
+++ a/arch/x86/kernel/vmiclock_32.c
@@ -284,7 +284,7 @@ void __devinit vmi_time_ap_init(void)
 
 /** vmi clocksource */
 
-static cycle_t read_real_cycles(void)
+static cycle_t read_real_cycles(struct clocksource *cs)
 {
 	return vmi_timer_ops.get_cycle_counter(VMI_CYCLES_REAL);
 }
diff -puN arch/x86/lguest/boot.c~clocksource-pass-clocksource-to-read-callback arch/x86/lguest/boot.c
--- a/arch/x86/lguest/boot.c~clocksource-pass-clocksource-to-read-callback
+++ a/arch/x86/lguest/boot.c
@@ -624,7 +624,7 @@ static unsigned long lguest_tsc_khz(void
 
 /* If we can't use the TSC, the kernel falls back to our lower-priority
  * "lguest_clock", where we read the time value given to us by the Host. */
-static cycle_t lguest_clock_read(void)
+static cycle_t lguest_clock_read(struct clocksource *cs)
 {
 	unsigned long sec, nsec;
 
diff -puN arch/x86/xen/time.c~clocksource-pass-clocksource-to-read-callback arch/x86/xen/time.c
--- a/arch/x86/xen/time.c~clocksource-pass-clocksource-to-read-callback
+++ a/arch/x86/xen/time.c
@@ -213,6 +213,11 @@ cycle_t xen_clocksource_read(void)
 	return ret;
 }
 
+static cycle_t xen_clocksource_get_cycles(struct clocksource *cs)
+{
+	return xen_clocksource_read();
+}
+
 static void xen_read_wallclock(struct timespec *ts)
 {
 	struct shared_info *s = HYPERVISOR_shared_info;
@@ -241,7 +246,7 @@ int xen_set_wallclock(unsigned long now)
 static struct clocksource xen_clocksource __read_mostly = {
 	.name = "xen",
 	.rating = 400,
-	.read = xen_clocksource_read,
+	.read = xen_clocksource_get_cycles,
 	.mask = ~0,
 	.mult = 1<<XEN_SHIFT,		/* time directly in nanoseconds */
 	.shift = XEN_SHIFT,
diff -puN drivers/char/hpet.c~clocksource-pass-clocksource-to-read-callback drivers/char/hpet.c
--- a/drivers/char/hpet.c~clocksource-pass-clocksource-to-read-callback
+++ a/drivers/char/hpet.c
@@ -72,7 +72,7 @@ static u32 hpet_nhpet, hpet_max_freq = H
 #ifdef CONFIG_IA64
 static void __iomem *hpet_mctr;
 
-static cycle_t read_hpet(void)
+static cycle_t read_hpet(struct clocksource *cs)
 {
 	return (cycle_t)read_counter((void __iomem *)hpet_mctr);
 }
diff -puN drivers/clocksource/acpi_pm.c~clocksource-pass-clocksource-to-read-callback drivers/clocksource/acpi_pm.c
--- a/drivers/clocksource/acpi_pm.c~clocksource-pass-clocksource-to-read-callback
+++ a/drivers/clocksource/acpi_pm.c
@@ -57,12 +57,12 @@ u32 acpi_pm_read_verified(void)
 	return v2;
 }
 
-static cycle_t acpi_pm_read_slow(void)
+static cycle_t acpi_pm_read_slow(struct clocksource *cs)
 {
 	return (cycle_t)acpi_pm_read_verified();
 }
 
-static cycle_t acpi_pm_read(void)
+static cycle_t acpi_pm_read(struct clocksource *cs)
 {
 	return (cycle_t)read_pmtmr();
 }
@@ -156,9 +156,9 @@ static int verify_pmtmr_rate(void)
 	unsigned long count, delta;
 
 	mach_prepare_counter();
-	value1 = clocksource_acpi_pm.read();
+	value1 = clocksource_acpi_pm.read(&clocksource_acpi_pm);
 	mach_countup(&count);
-	value2 = clocksource_acpi_pm.read();
+	value2 = clocksource_acpi_pm.read(&clocksource_acpi_pm);
 	delta = (value2 - value1) & ACPI_PM_MASK;
 
 	/* Check that the PMTMR delta is within 5% of what we expect */
@@ -195,9 +195,9 @@ static int __init init_acpi_pm_clocksour
 	/* "verify" this timing source: */
 	for (j = 0; j < ACPI_PM_MONOTONICITY_CHECKS; j++) {
 		udelay(100 * j);
-		value1 = clocksource_acpi_pm.read();
+		value1 = clocksource_acpi_pm.read(&clocksource_acpi_pm);
 		for (i = 0; i < ACPI_PM_READ_CHECKS; i++) {
-			value2 = clocksource_acpi_pm.read();
+			value2 = clocksource_acpi_pm.read(&clocksource_acpi_pm);
 			if (value2 == value1)
 				continue;
 			if (value2 > value1)
diff -puN drivers/clocksource/cyclone.c~clocksource-pass-clocksource-to-read-callback drivers/clocksource/cyclone.c
--- a/drivers/clocksource/cyclone.c~clocksource-pass-clocksource-to-read-callback
+++ a/drivers/clocksource/cyclone.c
@@ -19,7 +19,7 @@
 int use_cyclone = 0;
 static void __iomem *cyclone_ptr;
 
-static cycle_t read_cyclone(void)
+static cycle_t read_cyclone(struct clocksource *cs)
 {
 	return (cycle_t)readl(cyclone_ptr);
 }
diff -puN drivers/clocksource/scx200_hrt.c~clocksource-pass-clocksource-to-read-callback drivers/clocksource/scx200_hrt.c
--- a/drivers/clocksource/scx200_hrt.c~clocksource-pass-clocksource-to-read-callback
+++ a/drivers/clocksource/scx200_hrt.c
@@ -43,7 +43,7 @@ MODULE_PARM_DESC(ppm, "+-adjust to actua
 /* The base timer frequency, * 27 if selected */
 #define HRT_FREQ   1000000
 
-static cycle_t read_hrt(void)
+static cycle_t read_hrt(struct clocksource *cs)
 {
 	/* Read the timer value */
 	return (cycle_t) inl(scx200_cb_base + SCx200_TIMER_OFFSET);
diff -puN drivers/clocksource/tcb_clksrc.c~clocksource-pass-clocksource-to-read-callback drivers/clocksource/tcb_clksrc.c
--- a/drivers/clocksource/tcb_clksrc.c~clocksource-pass-clocksource-to-read-callback
+++ a/drivers/clocksource/tcb_clksrc.c
@@ -39,7 +39,7 @@
 
 static void __iomem *tcaddr;
 
-static cycle_t tc_get_cycles(void)
+static cycle_t tc_get_cycles(struct clocksource *cs)
 {
 	unsigned long	flags;
 	u32		lower, upper;
diff -puN include/linux/clocksource.h~clocksource-pass-clocksource-to-read-callback include/linux/clocksource.h
--- a/include/linux/clocksource.h~clocksource-pass-clocksource-to-read-callback
+++ a/include/linux/clocksource.h
@@ -42,7 +42,7 @@ struct clocksource;
  *			400-499: Perfect
  *				The ideal clocksource. A must-use where
  *				available.
- * @read:		returns a cycle value
+ * @read:		returns a cycle value, passes clocksource as argument
  * @mask:		bitmask for two's complement
  *			subtraction of non 64 bit counters
  * @mult:		cycle to nanosecond multiplier (adjusted by NTP)
@@ -61,7 +61,7 @@ struct clocksource {
 	char *name;
 	struct list_head list;
 	int rating;
-	cycle_t (*read)(void);
+	cycle_t (*read)(struct clocksource *cs);
 	cycle_t mask;
 	u32 mult;
 	u32 mult_orig;
@@ -170,7 +170,7 @@ static inline u32 clocksource_hz2mult(u3
  */
 static inline cycle_t clocksource_read(struct clocksource *cs)
 {
-	return cs->read();
+	return cs->read(cs);
 }
 
 /**
diff -puN kernel/time/jiffies.c~clocksource-pass-clocksource-to-read-callback kernel/time/jiffies.c
--- a/kernel/time/jiffies.c~clocksource-pass-clocksource-to-read-callback
+++ a/kernel/time/jiffies.c
@@ -50,7 +50,7 @@
  */
 #define JIFFIES_SHIFT	8
 
-static cycle_t jiffies_read(void)
+static cycle_t jiffies_read(struct clocksource *cs)
 {
 	return (cycle_t) jiffies;
 }
_

Patches currently in -mm which might be from damm@igel.co.jp are

linux-next.patch
clocksource-pass-clocksource-to-read-callback.patch
clocksource-add-enable-and-disable-callbacks.patch
irq-free-setup_irq-interrupt-using-free_irq.patch
spi_gpio-driver.patch
spi_gpio-driver-cleanups.patch
vmcore-remove-saved_max_pfn-check.patch

