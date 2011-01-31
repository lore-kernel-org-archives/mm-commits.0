From: akpm@linux-foundation.org
Subject: [obsolete] linux-next-git-rejects.patch removed from -mm tree
Date: Mon, 31 Jan 2011 11:13:02 -0800
Message-ID: <201101311913.p0VJD20P027664@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36053 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753429Ab1AaTNi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 31 Jan 2011 14:13:38 -0500
Received: from imap1.linux-foundation.org (imap1.linux-foundation.org [140.211.169.55])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id p0VJD34r004604
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <mm-commits@vger.kernel.org>; Mon, 31 Jan 2011 11:13:03 -0800
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     linux-next-git-rejects
has been removed from the -mm tree.  Its filename was
     linux-next-git-rejects.patch

This patch was dropped because it is obsolete

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: linux-next-git-rejects
From: Andrew Morton <akpm@linux-foundation.org>
DESC
memblock-add-input-size-checking-to-memblock_find_region-fix-git-rejects
EDESC

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/mach-realview/Kconfig   |    5 -----
 arch/arm/mach-realview/platsmp.c |   23 -----------------------
 arch/arm/mach-vexpress/platsmp.c |   23 -----------------------
 arch/arm/mach-vexpress/v2m.c     |   10 ----------
 arch/x86/xen/p2m.c               |   12 ------------
 5 files changed, 73 deletions(-)

diff -puN arch/x86/xen/p2m.c~linux-next-git-rejects arch/x86/xen/p2m.c
--- a/arch/x86/xen/p2m.c~linux-next-git-rejects
+++ a/arch/x86/xen/p2m.c
@@ -241,17 +241,6 @@ void __init xen_build_dynamic_phys_to_ma
 		 * As long as the mfn_list has enough entries to completely
 		 * fill a p2m page, pointing into the array is ok. But if
 		 * not the entries beyond the last pfn will be undefined.
-<<<<<<< HEAD
-		 */
-		if (unlikely(pfn + P2M_PER_PAGE > max_pfn)) {
-			unsigned long p2midx;
-
-			p2midx = max_pfn % P2M_PER_PAGE;
-			for ( ; p2midx < P2M_PER_PAGE; p2midx++)
-				mfn_list[pfn + p2midx] = INVALID_P2M_ENTRY;
-		}
-		p2m_top[topidx][mididx] = &mfn_list[pfn];
-=======
 		 * And guessing that the 'what-ever-there-is' does not take it
 		 * too kindly when changing it to invalid markers, a new page
 		 * is allocated, initialized and filled with the valid part.
@@ -267,7 +256,6 @@ void __init xen_build_dynamic_phys_to_ma
 			p2m_top[topidx][mididx] = p2m;
 		} else
 			p2m_top[topidx][mididx] = &mfn_list[pfn];
->>>>>>> FETCH_HEAD
 	}
 
 	m2p_override_init();
diff -puN arch/arm/mach-realview/Kconfig~linux-next-git-rejects arch/arm/mach-realview/Kconfig
--- a/arch/arm/mach-realview/Kconfig~linux-next-git-rejects
+++ a/arch/arm/mach-realview/Kconfig
@@ -35,13 +35,8 @@ config REALVIEW_EB_ARM11MP_REVB
 	  not compatible with other revisions of the ARM11MPCore tile.
 
 config MACH_REALVIEW_PB11MP
-<<<<<<< HEAD
-	bool "Support RealView(R) Platform Baseboard for ARM11MPCore"
-	select CPU_V6
-=======
 	bool "Support RealView/PB11MPCore platform"
 	select CPU_V6K
->>>>>>> FETCH_HEAD
 	select ARM_GIC
 	select HAVE_PATA_PLATFORM
 	select ARCH_HAS_BARRIERS if SMP
diff -puN arch/arm/mach-realview/platsmp.c~linux-next-git-rejects arch/arm/mach-realview/platsmp.c
--- a/arch/arm/mach-realview/platsmp.c~linux-next-git-rejects
+++ a/arch/arm/mach-realview/platsmp.c
@@ -24,30 +24,7 @@
 
 #include "core.h"
 
-<<<<<<< HEAD
-extern void realview_secondary_startup(void);
-
-/*
- * control for which core is the next to come out of the secondary
- * boot "holding pen"
- */
-volatile int __cpuinitdata pen_release = -1;
-
-/*
- * Write pen_release in a way that is guaranteed to be visible to all
- * observers, irrespective of whether they're taking part in coherency
- * or not.  This is necessary for the hotplug code to work reliably.
- */
-static void __cpuinit write_pen_release(int val)
-{
-	pen_release = val;
-	smp_wmb();
-	__cpuc_flush_dcache_area((void *)&pen_release, sizeof(pen_release));
-	outer_clean_range(__pa(&pen_release), __pa(&pen_release + 1));
-}
-=======
 extern void versatile_secondary_startup(void);
->>>>>>> FETCH_HEAD
 
 static void __iomem *scu_base_addr(void)
 {
diff -puN arch/arm/mach-vexpress/platsmp.c~linux-next-git-rejects arch/arm/mach-vexpress/platsmp.c
--- a/arch/arm/mach-vexpress/platsmp.c~linux-next-git-rejects
+++ a/arch/arm/mach-vexpress/platsmp.c
@@ -22,30 +22,7 @@
 
 #include "core.h"
 
-<<<<<<< HEAD
-extern void vexpress_secondary_startup(void);
-
-/*
- * control for which core is the next to come out of the secondary
- * boot "holding pen"
- */
-volatile int __cpuinitdata pen_release = -1;
-
-/*
- * Write pen_release in a way that is guaranteed to be visible to all
- * observers, irrespective of whether they're taking part in coherency
- * or not.  This is necessary for the hotplug code to work reliably.
- */
-static void __cpuinit write_pen_release(int val)
-{
-	pen_release = val;
-	smp_wmb();
-	__cpuc_flush_dcache_area((void *)&pen_release, sizeof(pen_release));
-	outer_clean_range(__pa(&pen_release), __pa(&pen_release + 1));
-}
-=======
 extern void versatile_secondary_startup(void);
->>>>>>> FETCH_HEAD
 
 static void __iomem *scu_base_addr(void)
 {
diff -puN arch/arm/mach-vexpress/v2m.c~linux-next-git-rejects arch/arm/mach-vexpress/v2m.c
--- a/arch/arm/mach-vexpress/v2m.c~linux-next-git-rejects
+++ a/arch/arm/mach-vexpress/v2m.c
@@ -56,18 +56,8 @@ void __init v2m_init_early(void)
 	versatile_sched_clock_init(MMIO_P2V(V2M_SYS_24MHZ), 24000000);
 }
 
-
-<<<<<<< HEAD
-	/* Select 1MHz TIMCLK as the reference clock for SP804 timers */
-	scctrl = readl(MMIO_P2V(V2M_SYSCTL + SCCTRL));
-	scctrl |= SCCTRL_TIMEREN0SEL_TIMCLK;
-	scctrl |= SCCTRL_TIMEREN1SEL_TIMCLK;
-	writel(scctrl, MMIO_P2V(V2M_SYSCTL + SCCTRL));
-
-=======
 static void __init v2m_timer_init(void)
 {
->>>>>>> FETCH_HEAD
 	writel(0, MMIO_P2V(V2M_TIMER0) + TIMER_CTRL);
 	writel(0, MMIO_P2V(V2M_TIMER1) + TIMER_CTRL);
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
next-remove-localversion.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
epoll-epoll_wait-should-not-use-timespec_add_ns-fix.patch
maintainers-fixup-simtec-support-email-entries-fix.patch
mm-vmap-area-cache.patch
drivers-gpu-drm-radeon-atomc-fix-warning.patch
leds-convert-bd2802-driver-to-dev_pm_ops-fix.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
backlight-add-backlight-type-fix.patch
backlight-add-backlight-type-fix-fix.patch
fs-ocfs2-dlm-dlmdomainc-avoid-a-gfp_atomic-allocation.patch
drivers-message-fusion-mptsasc-fix-warning.patch
drbd-fix-warning.patch
mm.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
hpet-factor-timer-allocate-from-open.patch
arch-alpha-include-asm-ioh-s-extern-inline-static-inline.patch
epoll-fix-compiler-warning-and-optimize-the-non-blocking-path.patch
lib-hexdumpc-make-hex2bin-return-the-updated-src-address.patch
fs-binfmt_miscc-use-kernels-hex_to_bin-method-fix.patch
fs-binfmt_miscc-use-kernels-hex_to_bin-method-fix-fix.patch
exec_domain-establish-a-linux32-domain-on-config_compat-systems.patch
scatterlist-new-helper-functions.patch
crash_dump-export-is_kdump_kernel-to-modules-consolidate-elfcorehdr_addr-setup_elfcorehdr-and-saved_max_pfn-fix.patch
crash_dump-export-is_kdump_kernel-to-modules-consolidate-elfcorehdr_addr-setup_elfcorehdr-and-saved_max_pfn-fix-fix.patch
journal_add_journal_head-debug.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
memblock-add-input-size-checking-to-memblock_find_region.patch
memblock-add-input-size-checking-to-memblock_find_region-fix.patch

