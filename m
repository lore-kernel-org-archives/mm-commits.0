From: akpm@linux-foundation.org
Subject: - arm-spinlock-initializer-cleanup.patch removed from -mm tree
Date: Fri, 11 May 2007 22:36:04 -0700
Message-ID: <200705120536.l4C5a3xF002346@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:44994 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757378AbXELFgP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 12 May 2007 01:36:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tglx@linutronix.de, rmk@arm.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     ARM: Spinlock initializer cleanup
has been removed from the -mm tree.  Its filename was
     arm-spinlock-initializer-cleanup.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
git-arm.patch
git-avr32.patch
drm-spinlock-initializer-cleanup.patch
git-dvb.patch
s390-spinlock-initializer-cleanup.patch
i386-hpet-check-if-the-counter-works.patch
clockevents-fix-resume-logic-updated-version.patch
timer_stats-slimmed-down-using-statistics-infrastucture.patch
