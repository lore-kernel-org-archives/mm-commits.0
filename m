From: akpm@linux-foundation.org
Subject: + arm-spinlock-initializer-cleanup.patch added to -mm tree
Date: Thu, 03 May 2007 23:36:07 -0700
Message-ID: <200705040636.l446a7gb030707@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:34606 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1161865AbXEDGgS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 May 2007 02:36:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tglx@linutronix.de, rmk@arm.linux.org.uk


The patch titled
     ARM: Spinlock initializer cleanup
has been added to the -mm tree.  Its filename is
     arm-spinlock-initializer-cleanup.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: ARM: Spinlock initializer cleanup
From: Thomas Gleixner <tglx@linutronix.de>

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Russell King <rmk@arm.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/kernel/time.c      |    2 +-
 arch/arm/mach-omap2/gpmc.c  |    2 +-
 arch/arm/mach-pnx4008/dma.c |    4 ++--
 3 files changed, 4 insertions(+), 4 deletions(-)

diff -puN arch/arm/kernel/time.c~arm-spinlock-initializer-cleanup arch/arm/kernel/time.c
--- a/arch/arm/kernel/time.c~arm-spinlock-initializer-cleanup
+++ a/arch/arm/kernel/time.c
@@ -512,7 +512,7 @@ void __init time_init(void)
 
 #ifdef CONFIG_NO_IDLE_HZ
 	if (system_timer->dyn_tick)
-		system_timer->dyn_tick->lock = SPIN_LOCK_UNLOCKED;
+		spin_lock_init(&system_timer->dyn_tick->lock);
 #endif
 }
 
diff -puN arch/arm/mach-omap2/gpmc.c~arm-spinlock-initializer-cleanup arch/arm/mach-omap2/gpmc.c
--- a/arch/arm/mach-omap2/gpmc.c~arm-spinlock-initializer-cleanup
+++ a/arch/arm/mach-omap2/gpmc.c
@@ -54,7 +54,7 @@
 
 static struct resource	gpmc_mem_root;
 static struct resource	gpmc_cs_mem[GPMC_CS_NUM];
-static spinlock_t	gpmc_mem_lock = SPIN_LOCK_UNLOCKED;
+static DEFINE_SPINLOCK(gpmc_mem_lock);
 static unsigned		gpmc_cs_map;
 
 static void __iomem *gpmc_base =
diff -puN arch/arm/mach-pnx4008/dma.c~arm-spinlock-initializer-cleanup arch/arm/mach-pnx4008/dma.c
--- a/arch/arm/mach-pnx4008/dma.c~arm-spinlock-initializer-cleanup
+++ a/arch/arm/mach-pnx4008/dma.c
@@ -47,7 +47,7 @@ static struct ll_pool {
 	int count;
 } ll_pool;
 
-static spinlock_t ll_lock = SPIN_LOCK_UNLOCKED;
+static DEFINE_SPINLOCK(ll_lock);
 
 struct pnx4008_dma_ll *pnx4008_alloc_ll_entry(dma_addr_t * ll_dma)
 {
@@ -135,7 +135,7 @@ static inline void dma_decrement_usage(v
 	}
 }
 
-static spinlock_t dma_lock = SPIN_LOCK_UNLOCKED;
+static DEFINE_SPINLOCK(dma_lock);
 
 static inline void pnx4008_dma_lock(void)
 {
_

Patches currently in -mm which might be from tglx@linutronix.de are

origin.patch
h8300-generic-irq.patch
git-arm.patch
git-avr32.patch
git-dvb.patch
git-ieee1394.patch
git-input.patch
git-mtd.patch
optimize-timespec_trunc.patch
kernel-irq-procc-unprotected-iteration-over-the-irq-action-list-in-name_unique.patch
add-support-for-deferrable-timers-respun.patch
irq-check-for-percpu-flag-only-when-adding-first-irqaction.patch
move-timekeeping-code-to-timekeepingc.patch
ignore-stolen-time-in-the-softlockup-watchdog.patch
replace-deprecated-sa_xxx-interrupt-flags.patch
deprecate-sa_xxx-interrupt-flags-v2.patch
pad-irq_desc-to-internode-cacheline-size.patch
highres-dyntick-prevent-xtime-lock-contention.patch
introduce-a-handy-list_first_entry-macro-v2.patch
the-scheduled-einval-for-invalid-timevals-in-setitimer.patch
clockchipsh-kernel-doc-fix.patch
export-hrtimer_forward.patch
sched-fix-idle-load-balancing-in-softirqd-context.patch
sched-dynticks-idle-load-balancing-v3.patch
declare-struct-ktime.patch
add-irqf_irqpoll-flag-common-code.patch
add-irqf_irqpoll-flag-on-x86_64.patch
add-irqf_irqpoll-flag-on-i386.patch
add-irqf_irqpoll-flag-on-ia64.patch
add-irqf_irqpoll-flag-on-sh.patch
add-irqf_irqpoll-flag-on-arm.patch
clocksource-fix-resume-logic.patch
acpi-keep-tsc-stable-when-lapic_timer_c2_ok-is-set.patch
acpi-keep-tsc-stable-when-lapic_timer_c2_ok-is-set-vs-x86_64-mm-log-reason-why-tsc-was-marked-unstable.patch
clockevents-fix-resume-logic.patch
timer_stats-slimmed-down-using-statistics-infrastucture.patch
arm-spinlock-initializer-cleanup.patch
drm-spinlock-initializer-cleanup.patch
isdn-spinlock-initializer-cleanup.patch
s390-spinlock-initializer-cleanup.patch
