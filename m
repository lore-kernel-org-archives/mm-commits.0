From: akpm@linux-foundation.org
Subject: + linux-next-git-rejects.patch added to -mm tree
Date: Tue, 15 Mar 2016 10:50:05 -0700
Message-ID: <56e84b4d./TVXOFhxUqRuDLQo%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47397 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751684AbcCORuH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 15 Mar 2016 13:50:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: linux-next-git-rejects
has been added to the -mm tree.  Its filename is
     linux-next-git-rejects.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/linux-next-git-rejects.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/linux-next-git-rejects.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next-git-rejects

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/kernel-parameters.txt   |    3 ---
 arch/arm/mach-lpc32xx/phy3250.c       |   20 --------------------
 drivers/gpu/drm/omapdrm/omap_gem.c    |   16 ----------------
 kernel/memremap.c                     |    5 -----
 kernel/rcu/tree.c                     |   12 ------------
 kernel/resource.c                     |    6 ------
 kernel/sched/fair.c                   |   11 -----------
 tools/power/x86/turbostat/turbostat.c |   12 ------------
 8 files changed, 85 deletions(-)

diff -puN Documentation/kernel-parameters.txt~linux-next-git-rejects Documentation/kernel-parameters.txt
--- a/Documentation/kernel-parameters.txt~linux-next-git-rejects
+++ a/Documentation/kernel-parameters.txt
@@ -3537,15 +3537,12 @@ bytes respectively. Such letter suffixes
 
 	ro		[KNL] Mount root device read-only on boot
 
-<<<<<<< HEAD
-=======
 	rockchip.usb_uart
 			Enable the uart passthrough on the designated usb port
 			on Rockchip SoCs. When active, the signals of the
 			debug-uart get routed to the D+ and D- pins of the usb
 			port and the regular usb controller gets disabled.
 
->>>>>>> linux-next/akpm-base
 	rodata=		[KNL]
 		on	Mark read-only kernel memory as read-only (default).
 		off	Leave read-only kernel memory writable for debugging.
diff -puN arch/arm/mach-lpc32xx/phy3250.c~linux-next-git-rejects arch/arm/mach-lpc32xx/phy3250.c
--- a/arch/arm/mach-lpc32xx/phy3250.c~linux-next-git-rejects
+++ a/arch/arm/mach-lpc32xx/phy3250.c
@@ -102,26 +102,6 @@ static void lpc32xx_clcd_remove(struct c
 {
 	dma_free_wc(&fb->dev->dev, fb->fb.fix.smem_len, fb->fb.screen_base,
 		    fb->fb.fix.smem_start);
-<<<<<<< HEAD
-}
-
-/*
- * On some early LCD modules (1307.0), the backlight logic is inverted.
- * For those board variants, swap the disable and enable states for
- * BKL_POWER_GPIO.
-*/
-static void clcd_disable(struct clcd_fb *fb)
-{
-	gpio_set_value(BKL_POWER_GPIO, 0);
-	gpio_set_value(LCD_POWER_GPIO, 0);
-}
-
-static void clcd_enable(struct clcd_fb *fb)
-{
-	gpio_set_value(BKL_POWER_GPIO, 1);
-	gpio_set_value(LCD_POWER_GPIO, 1);
-=======
->>>>>>> linux-next/akpm-base
 }
 
 static struct clcd_board lpc32xx_clcd_data = {
diff -puN drivers/gpu/drm/omapdrm/omap_gem.c~linux-next-git-rejects drivers/gpu/drm/omapdrm/omap_gem.c
--- a/drivers/gpu/drm/omapdrm/omap_gem.c~linux-next-git-rejects
+++ a/drivers/gpu/drm/omapdrm/omap_gem.c
@@ -1312,14 +1312,6 @@ void omap_gem_free_object(struct drm_gem
 			omap_gem_detach_pages(obj);
 	}
 
-<<<<<<< HEAD
-		if (!is_shmem(obj)) {
-			dma_free_wc(dev->dev, obj->size, omap_obj->vaddr,
-				    omap_obj->paddr);
-		} else if (omap_obj->vaddr) {
-			vunmap(omap_obj->vaddr);
-		}
-=======
 	if (omap_obj->flags & OMAP_BO_MEM_DMA_API) {
 		dma_free_wc(dev->dev, obj->size,
 				omap_obj->vaddr, omap_obj->paddr);
@@ -1327,7 +1319,6 @@ void omap_gem_free_object(struct drm_gem
 		vunmap(omap_obj->vaddr);
 	} else if (obj->import_attach) {
 		drm_prime_gem_destroy(obj, omap_obj->sgt);
->>>>>>> linux-next/akpm-base
 	}
 
 	kfree(omap_obj->sync);
@@ -1395,15 +1386,8 @@ struct drm_gem_object *omap_gem_new(stru
 		 * For tiled buffers align dimensions to slot boundaries and
 		 * calculate size based on aligned dimensions.
 		 */
-<<<<<<< HEAD
-		omap_obj->vaddr =  dma_alloc_wc(dev->dev, size,
-						&omap_obj->paddr, GFP_KERNEL);
-		if (!omap_obj->vaddr) {
-			kfree(omap_obj);
-=======
 		tiler_align(gem2fmt(flags), &gsize.tiled.width,
 			    &gsize.tiled.height);
->>>>>>> linux-next/akpm-base
 
 		size = tiler_size(gem2fmt(flags), gsize.tiled.width,
 				  gsize.tiled.height);
diff -puN kernel/memremap.c~linux-next-git-rejects kernel/memremap.c
--- a/kernel/memremap.c~linux-next-git-rejects
+++ a/kernel/memremap.c
@@ -280,12 +280,7 @@ void *devm_memremap_pages(struct device
 	align_start = res->start & ~(SECTION_SIZE - 1);
 	align_size = ALIGN(res->start + resource_size(res), SECTION_SIZE)
 		- align_start;
-<<<<<<< HEAD
-	is_ram = region_intersects(align_start, align_size,
-		IORESOURCE_SYSTEM_RAM, IORES_DESC_NONE);
-=======
 	is_ram = region_intersects(align_start, align_size, IORESOURCE_SYSTEM_RAM, IORES_DESC_NONE);
->>>>>>> linux-next/akpm-base
 
 	if (is_ram == REGION_MIXED) {
 		WARN_ONCE(1, "%s attempted on mixed region %pr\n",
diff -puN kernel/rcu/tree.c~linux-next-git-rejects kernel/rcu/tree.c
--- a/kernel/rcu/tree.c~linux-next-git-rejects
+++ a/kernel/rcu/tree.c
@@ -2046,11 +2046,7 @@ static void rcu_gp_cleanup(struct rcu_st
 		/* smp_mb() provided by prior unlock-lock pair. */
 		nocb += rcu_future_gp_cleanup(rsp, rnp);
 		sq = rcu_nocb_gp_get(rnp);
-<<<<<<< HEAD
-		raw_spin_unlock_irq(&rnp->lock);
-=======
 		raw_spin_unlock_irq_rcu_node(rnp);
->>>>>>> linux-next/akpm-base
 		rcu_nocb_gp_cleanup(sq);
 		cond_resched_rcu_qs();
 		WRITE_ONCE(rsp->gp_activity, jiffies);
@@ -2252,11 +2248,7 @@ static void rcu_report_qs_rsp(struct rcu
 {
 	WARN_ON_ONCE(!rcu_gp_in_progress(rsp));
 	WRITE_ONCE(rsp->gp_flags, READ_ONCE(rsp->gp_flags) | RCU_GP_FLAG_FQS);
-<<<<<<< HEAD
-	raw_spin_unlock_irqrestore(&rcu_get_root(rsp)->lock, flags);
-=======
 	raw_spin_unlock_irqrestore_rcu_node(rcu_get_root(rsp), flags);
->>>>>>> linux-next/akpm-base
 	swake_up(&rsp->gp_wq);  /* Memory barrier implied by swake_up() path. */
 }
 
@@ -2884,11 +2876,7 @@ static void force_quiescent_state(struct
 		return;  /* Someone beat us to it. */
 	}
 	WRITE_ONCE(rsp->gp_flags, READ_ONCE(rsp->gp_flags) | RCU_GP_FLAG_FQS);
-<<<<<<< HEAD
-	raw_spin_unlock_irqrestore(&rnp_old->lock, flags);
-=======
 	raw_spin_unlock_irqrestore_rcu_node(rnp_old, flags);
->>>>>>> linux-next/akpm-base
 	swake_up(&rsp->gp_wq); /* Memory barrier implied by swake_up() path. */
 }
 
diff -puN kernel/resource.c~linux-next-git-rejects kernel/resource.c
--- a/kernel/resource.c~linux-next-git-rejects
+++ a/kernel/resource.c
@@ -1128,12 +1128,6 @@ struct resource * __request_region(struc
 	res->name = name;
 	res->start = start;
 	res->end = start + n - 1;
-<<<<<<< HEAD
-	res->flags = resource_type(parent) | resource_ext_type(parent);
-	res->flags |= IORESOURCE_BUSY | flags;
-	res->desc = IORES_DESC_NONE;
-=======
->>>>>>> linux-next/akpm-base
 
 	write_lock(&resource_lock);
 
diff -puN kernel/sched/fair.c~linux-next-git-rejects kernel/sched/fair.c
--- a/kernel/sched/fair.c~linux-next-git-rejects
+++ a/kernel/sched/fair.c
@@ -819,7 +819,6 @@ update_stats_dequeue(struct cfs_rq *cfs_
 static inline void
 update_stats_wait_start(struct cfs_rq *cfs_rq, struct sched_entity *se)
 {
-<<<<<<< HEAD
 }
 
 static inline void
@@ -828,16 +827,6 @@ update_stats_wait_end(struct cfs_rq *cfs
 }
 
 static inline void
-=======
-}
-
-static inline void
-update_stats_wait_end(struct cfs_rq *cfs_rq, struct sched_entity *se)
-{
-}
-
-static inline void
->>>>>>> linux-next/akpm-base
 update_stats_enqueue(struct cfs_rq *cfs_rq, struct sched_entity *se)
 {
 }
diff -puN tools/power/x86/turbostat/turbostat.c~linux-next-git-rejects tools/power/x86/turbostat/turbostat.c
--- a/tools/power/x86/turbostat/turbostat.c~linux-next-git-rejects
+++ a/tools/power/x86/turbostat/turbostat.c
@@ -2257,11 +2257,7 @@ int has_config_tdp(unsigned int family,
 }
 
 static void
-<<<<<<< HEAD
-dump_cstate_pstate_config_info(unsigned int family, unsigned int model)
-=======
 dump_cstate_pstate_config_info(int family, int model)
->>>>>>> linux-next/akpm-base
 {
 	if (!do_nhm_platform_info)
 		return;
@@ -2524,11 +2520,7 @@ int print_perf_limit(struct thread_data
 #define	RAPL_POWER_GRANULARITY	0x7FFF	/* 15 bit power granularity */
 #define	RAPL_TIME_GRANULARITY	0x3F /* 6 bit time granularity */
 
-<<<<<<< HEAD
-double get_tdp(unsigned int model)
-=======
 double get_tdp(int model)
->>>>>>> linux-next/akpm-base
 {
 	unsigned long long msr;
 
@@ -2642,11 +2634,7 @@ void rapl_probe(unsigned int family, uns
 	return;
 }
 
-<<<<<<< HEAD
-void perf_limit_reasons_probe(unsigned int family, unsigned int model)
-=======
 void perf_limit_reasons_probe(int family, int model)
->>>>>>> linux-next/akpm-base
 {
 	if (!genuine_intel)
 		return;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-gpu-drm-i915-intel_spritec-fix-build.patch
drivers-gpu-drm-i915-intel_tvc-fix-build.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
ocfs2-code-clean-up-for-direct-io-fix.patch
ocfs2-fix-ip_unaligned_aio-deadlock-with-dio-work-queue-fix.patch
ocfs2-dlm-move-lock-to-the-tail-of-grant-queue-while-doing-in-place-convert-fix.patch
mm.patch
mm-slab-clean-up-debug_pagealloc-processing-code-fix.patch
mm-slab-put-the-freelist-at-the-end-of-slab-page-fix.patch
slub-drop-lock-at-the-end-of-free_debug_processing-fix.patch
fs-mpagec-mpage_readpages-use-lru_to_page-helper.patch
mm-page_allocc-introduce-kernelcore=mirror-option-fix.patch
mm-page_allocc-rework-code-layout-in-memmap_init_zone.patch
mm-madvise-update-comment-on-sys_madvise-fix.patch
mm-migrate-do-not-touch-page-mem_cgroup-of-live-pages-fix.patch
mm-simplify-lock_page_memcg-fix.patch
sched-add-schedule_timeout_idle.patch
mm-oom_reaper-report-success-failure-fix.patch
mm-compaction-speed-up-pageblock_pfn_to_page-when-zone-is-contiguous-fix.patch
proc-kpageflags-return-kpf_buddy-for-tail-buddy-pages-fix-fix.patch
mm-vmalloc-query-dynamic-debug_pagealloc-setting-fix.patch
mm-slub-query-dynamic-debug_pagealloc-setting-fix.patch
sound-query-dynamic-debug_pagealloc-setting-fix.patch
mm-page_ref-add-tracepoint-to-track-down-page-reference-manipulation-fix-3-fix.patch
ksm-introduce-ksm_max_page_sharing-per-page-deduplication-limit-fix-2.patch
mm-kasan-stackdepot-implementation-enable-stackdepot-for-slab-fix.patch
zram-export-the-number-of-available-comp-streams-fix.patch
mm-oom-rework-oom-detection-checkpatch-fixes.patch
mm-use-watermak-checks-for-__gfp_repeat-high-order-allocations-checkpatch-fixes.patch
mn10300-c6x-config_generic_bug-must-depend-on-config_bug.patch
arch-mn10300-kernel-fpu-nofpuc-needs-asm-elfh.patch
btrfs-use-radix_tree_iter_retry-fix.patch
sscanf-implement-basic-character-sets-fix.patch
sparc-compat-provide-an-accurate-in_compat_syscall-implementation-fix.patch
sparc-compat-provide-an-accurate-in_compat_syscall-implementation-fix-fix.patch
rapidio-add-mport-char-device-driver-fix.patch
kernel-add-kcov-code-coverage-fix.patch
kernel-add-kcov-code-coverage-fix-2.patch
kernel-add-kcov-code-coverage-makefile-tweaks.patch
linux-next-rejects.patch
linux-next-git-rejects.patch
drivers-net-wireless-intel-iwlwifi-dvm-calibc-fix-min-warning.patch
dma-rename-dma__writecombine-to-dma__wc-checkpatch-fixes.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

