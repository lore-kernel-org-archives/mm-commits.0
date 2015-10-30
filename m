From: akpm@linux-foundation.org
Subject: + linux-next-git-rejects.patch added to -mm tree
Date: Fri, 30 Oct 2015 12:44:12 -0700
Message-ID: <5633c88c.sfmp0JTLHiBNE1wP%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42004 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758403AbbJ3ToN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 30 Oct 2015 15:44:13 -0400
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

 arch/x86/boot/compressed/eboot.c     |    8 -------
 drivers/gpu/drm/i915/intel_display.c |    8 -------
 drivers/iommu/amd_iommu_types.h      |    6 -----
 sound/soc/codecs/rt298.c             |    4 ---
 virt/kvm/arm/arch_timer.c            |   26 -------------------------
 virt/kvm/arm/vgic.c                  |    5 ----
 6 files changed, 57 deletions(-)

diff -puN arch/x86/boot/compressed/eboot.c~linux-next-git-rejects arch/x86/boot/compressed/eboot.c
--- a/arch/x86/boot/compressed/eboot.c~linux-next-git-rejects
+++ a/arch/x86/boot/compressed/eboot.c
@@ -668,11 +668,7 @@ setup_gop32(struct screen_info *si, efi_
 		bool conout_found = false;
 		void *dummy = NULL;
 		u32 h = handles[i];
-<<<<<<< HEAD
-		u32 current_fb_base;
-=======
 		u64 current_fb_base;
->>>>>>> linux-next/akpm-base
 
 		status = efi_call_early(handle_protocol, h,
 					proto, (void **)&gop32);
@@ -785,11 +781,7 @@ setup_gop64(struct screen_info *si, efi_
 		bool conout_found = false;
 		void *dummy = NULL;
 		u64 h = handles[i];
-<<<<<<< HEAD
-		u32 current_fb_base;
-=======
 		u64 current_fb_base;
->>>>>>> linux-next/akpm-base
 
 		status = efi_call_early(handle_protocol, h,
 					proto, (void **)&gop64);
diff -puN drivers/gpu/drm/i915/intel_display.c~linux-next-git-rejects drivers/gpu/drm/i915/intel_display.c
--- a/drivers/gpu/drm/i915/intel_display.c~linux-next-git-rejects
+++ a/drivers/gpu/drm/i915/intel_display.c
@@ -14953,11 +14953,6 @@ static void intel_sanitize_crtc(struct i
 	if (crtc->active) {
 		struct intel_plane *plane;
 
-<<<<<<< HEAD
-		drm_calc_timestamping_constants(&crtc->base, &crtc->base.hwmode);
-		update_scanline_offset(crtc);
-=======
->>>>>>> linux-next/akpm-base
 		drm_crtc_vblank_on(&crtc->base);
 
 		/* Disable everything but the primary plane */
@@ -15257,12 +15252,9 @@ static void intel_modeset_readout_hw_sta
 			 * recalculation.
 			 */
 			crtc->base.state->mode.private_flags = I915_MODE_FLAG_INHERITED;
-<<<<<<< HEAD
-=======
 
 			drm_calc_timestamping_constants(&crtc->base, &crtc->base.hwmode);
 			update_scanline_offset(crtc);
->>>>>>> linux-next/akpm-base
 		}
 	}
 }
diff -puN drivers/iommu/amd_iommu_types.h~linux-next-git-rejects drivers/iommu/amd_iommu_types.h
--- a/drivers/iommu/amd_iommu_types.h~linux-next-git-rejects
+++ a/drivers/iommu/amd_iommu_types.h
@@ -295,15 +295,9 @@
 #define IOMMU_PTE_IR (1ULL << 61)
 #define IOMMU_PTE_IW (1ULL << 62)
 
-<<<<<<< HEAD
-#define DTE_FLAG_MASK	(0x3ffULL << 32)
-#define DTE_FLAG_IOTLB	(0x01UL << 32)
-#define DTE_FLAG_GV	(0x01ULL << 55)
-=======
 #define DTE_FLAG_IOTLB	(1ULL << 32)
 #define DTE_FLAG_GV	(1ULL << 55)
 #define DTE_FLAG_MASK	(0x3ffULL << 32)
->>>>>>> linux-next/akpm-base
 #define DTE_GLX_SHIFT	(56)
 #define DTE_GLX_MASK	(3)
 
diff -puN sound/soc/codecs/rt298.c~linux-next-git-rejects sound/soc/codecs/rt298.c
--- a/sound/soc/codecs/rt298.c~linux-next-git-rejects
+++ a/sound/soc/codecs/rt298.c
@@ -48,11 +48,7 @@ struct rt298_priv {
 	int is_hp_in;
 };
 
-<<<<<<< HEAD
-static struct reg_default rt298_index_def[] = {
-=======
 static const struct reg_default rt298_index_def[] = {
->>>>>>> linux-next/akpm-base
 	{ 0x01, 0xa5a8 },
 	{ 0x02, 0x8e95 },
 	{ 0x03, 0x0002 },
diff -puN virt/kvm/arm/arch_timer.c~linux-next-git-rejects virt/kvm/arm/arch_timer.c
--- a/virt/kvm/arm/arch_timer.c~linux-next-git-rejects
+++ a/virt/kvm/arm/arch_timer.c
@@ -154,34 +154,8 @@ static void kvm_timer_update_state(struc
 	if (!vgic_initialized(vcpu->kvm))
 	    return;
 
-<<<<<<< HEAD
-	/*
-	 * If the timer expired while we were not scheduled, now is the time
-	 * to inject it.
-	 */
-	if (kvm_timer_should_fire(vcpu))
-		kvm_timer_inject_irq(vcpu);
-
-	/*
-	 * We keep track of whether the edge-triggered interrupt has been
-	 * signalled to the vgic/guest, and if so, we mask the interrupt and
-	 * the physical distributor to prevent the timer from raising a
-	 * physical interrupt whenever we run a guest, preventing forward
-	 * VCPU progress.
-	 */
-	if (kvm_vgic_get_phys_irq_active(timer->map))
-		phys_active = true;
-	else
-		phys_active = false;
-
-	ret = irq_set_irqchip_state(timer->map->irq,
-				    IRQCHIP_STATE_ACTIVE,
-				    phys_active);
-	WARN_ON(ret);
-=======
 	if (kvm_timer_should_fire(vcpu) != timer->irq.level)
 		kvm_timer_update_irq(vcpu, !timer->irq.level);
->>>>>>> linux-next/akpm-base
 }
 
 /*
diff -puN virt/kvm/arm/vgic.c~linux-next-git-rejects virt/kvm/arm/vgic.c
--- a/virt/kvm/arm/vgic.c~linux-next-git-rejects
+++ a/virt/kvm/arm/vgic.c
@@ -1471,10 +1471,6 @@ static bool vgic_sync_hwirq(struct kvm_v
 
 	WARN_ON(ret);
 
-<<<<<<< HEAD
-	if (map->active)
-		return 0;
-=======
 	if (phys_active) {
 		/*
 		 * Interrupt still marked as active on the physical
@@ -1488,7 +1484,6 @@ static bool vgic_sync_hwirq(struct kvm_v
 		WARN_ON(ret);
 		return false;
 	}
->>>>>>> linux-next/akpm-base
 
 	spin_lock(&dist->lock);
 	level_pending = process_queued_irq(vcpu, lr, vlr);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-gpu-drm-i915-intel_spritec-fix-build.patch
drivers-gpu-drm-i915-intel_tvc-fix-build.patch
mm.patch
slub-optimize-bulk-slowpath-free-by-detached-freelist-fix.patch
uaccess-reimplement-probe_kernel_address-using-probe_kernel_read.patch
uaccess-reimplement-probe_kernel_address-using-probe_kernel_read-fix.patch
uaccess-reimplement-probe_kernel_address-using-probe_kernel_read-fix-fix.patch
mm-page_alloc-rename-__gfp_wait-to-__gfp_reclaim-fix.patch
mm-page_alloc-rename-__gfp_wait-to-__gfp_reclaim-checkpatch-fixes.patch
mm-page_alloc-only-enforce-watermarks-for-order-0-allocations-fix-fix.patch
mm-fix-declarations-of-nr-delta-and-nr_pagecache_reclaimable-fix.patch
mm-oom_kill-fix-the-wrong-task-mm-==-mm-checks-in-oom_kill_process-fix.patch
include-linux-mmzoneh-reflow-comment.patch
mm-fs-introduce-mapping_gfp_constraint-checkpatch-fixes.patch
mm-vmstatc-uninline-node_page_state.patch
mm-vmstatc-uninline-node_page_state-fix.patch
mm-cmac-suppress-warning.patch
kasan-various-fixes-in-documentation-checkpatch-fixes.patch
mm-slub-kasan-enable-user-tracking-by-default-with-kasan=y-fix.patch
zsmalloc-add-comments-for-inuse-to-zspage-v2-fix.patch
page-flags-define-pg_locked-behavior-on-compound-pages-fix.patch
mm-increase-swap_cluster_max-to-batch-tlb-flushes-fix-fix.patch
x86-add-pmd_-for-thp-fix.patch
sparc-add-pmd_-for-thp-fix.patch
mm-support-madvisemadv_free-fix-2.patch
mm-support-madvisemadv_free-vs-thp-rename-split_huge_page_pmd-to-split_huge_pmd.patch
mm-dont-split-thp-page-when-syscall-is-called-fix-3.patch
mm-dont-split-thp-page-when-syscall-is-called-fix-6-fix.patch
mm-dont-split-thp-page-when-syscall-is-called-fix-6-fix-2.patch
mm-move-lazy-free-pages-to-inactive-list-fix-fix.patch
include-linux-compiler-gcch-improve-__visible-documentation.patch
fs-jffs2-wbufc-remove-stray-semicolon.patch
lib-documentation-synchronize-%p-formatting-documentation-fix-fix.patch
rbtree-clarify-documentation-of-rbtree_postorder_for_each_entry_safe-fix.patch
dma-mapping-tidy-up-dma_parms-default-handling-fix.patch
panic-release-stale-console-lock-to-always-get-the-logbuf-printed-out-fix.patch
linux-next-rejects.patch
mm-page_alloc-rename-__gfp_wait-to-__gfp_reclaim-nvem-fix.patch
mm-page_alloc-rename-__gfp_wait-to-__gfp_reclaim-arm-fix.patch
mm-page_alloc-rename-__gfp_wait-to-__gfp_reclaim-arm-fix-fix.patch
net-ipv4-routec-prevent-oops.patch
remove-abs64.patch
remove-abs64-fix.patch
remove-abs64-fix-fix.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch
linux-next-git-rejects.patch

