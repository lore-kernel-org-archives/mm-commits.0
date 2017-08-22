From: akpm@linux-foundation.org
Subject: [obsolete] linux-next-git-rejects.patch removed from -mm
 tree
Date: Tue, 22 Aug 2017 13:54:07 -0700
Message-ID: <20170822205407.uPP3bgrHf%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36268 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751170AbdHVUyI (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 22 Aug 2017 16:54:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: linux-next-git-rejects
has been removed from the -mm tree.  Its filename was
     linux-next-git-rejects.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next-git-rejects

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/head64.c             |    6 ------
 arch/x86/mm/mmap.c                   |    5 -----
 drivers/gpu/drm/i915/intel_display.c |    9 ---------
 3 files changed, 20 deletions(-)

diff -puN arch/x86/kernel/head64.c~linux-next-git-rejects arch/x86/kernel/head64.c
--- a/arch/x86/kernel/head64.c~linux-next-git-rejects
+++ a/arch/x86/kernel/head64.c
@@ -100,16 +100,10 @@ unsigned long __head __startup_64(unsign
 	 * creates a bunch of nonsense entries but that is fine --
 	 * it avoids problems around wraparound.
 	 */
-<<<<<<< HEAD
-	next_pgt_ptr = fixup_pointer(&next_early_pgt, physaddr);
-	pud = fixup_pointer(early_dynamic_pgts[(*next_pgt_ptr)++], physaddr);
-	pmd = fixup_pointer(early_dynamic_pgts[(*next_pgt_ptr)++], physaddr);
-=======
 
 	pud = fixup_pointer(early_dynamic_pgts[next_early_pgt++], physaddr);
 	pmd = fixup_pointer(early_dynamic_pgts[next_early_pgt++], physaddr);
 	pgtable_flags = _KERNPG_TABLE_NOENC + sme_get_me_mask();
->>>>>>> linux-next/akpm-base
 
 	if (IS_ENABLED(CONFIG_X86_5LEVEL)) {
 		p4d = fixup_pointer(early_dynamic_pgts[next_early_pgt++], physaddr);
diff -puN arch/x86/mm/mmap.c~linux-next-git-rejects arch/x86/mm/mmap.c
--- a/arch/x86/mm/mmap.c~linux-next-git-rejects
+++ a/arch/x86/mm/mmap.c
@@ -50,14 +50,9 @@ unsigned long task_size_64bit(int full_a
 static unsigned long stack_maxrandom_size(unsigned long task_size)
 {
 	unsigned long max = 0;
-<<<<<<< HEAD
-	if (current->flags & PF_RANDOMIZE) {
-		max = (-1UL) & __STACK_RND_MASK(task_size == tasksize_32bit());
-=======
 	if ((current->flags & PF_RANDOMIZE) &&
 		!(current->personality & ADDR_NO_RANDOMIZE)) {
 		max = (-1UL) & __STACK_RND_MASK(task_size == task_size_32bit());
->>>>>>> linux-next/akpm-base
 		max <<= PAGE_SHIFT;
 	}
 
diff -puN drivers/gpu/drm/i915/intel_display.c~linux-next-git-rejects drivers/gpu/drm/i915/intel_display.c
--- a/drivers/gpu/drm/i915/intel_display.c~linux-next-git-rejects
+++ a/drivers/gpu/drm/i915/intel_display.c
@@ -3685,14 +3685,6 @@ void intel_prepare_reset(struct drm_i915
 	    !gpu_reset_clobbers_display(dev_priv))
 		return;
 
-<<<<<<< HEAD
-	/* We have a modeset vs reset deadlock, defensively unbreak it.
-	 *
-	 * FIXME: We can do a _lot_ better, this is just a first iteration.
-	 */
-	i915_gem_set_wedged(dev_priv);
-	DRM_DEBUG_DRIVER("Wedging GPU to avoid deadlocks with pending modeset updates\n");
-=======
 	/* We have a modeset vs reset deadlock, defensively unbreak it. */
 	set_bit(I915_RESET_MODESET, &dev_priv->gpu_error.flags);
 	wake_up_all(&dev_priv->gpu_error.wait_queue);
@@ -3701,7 +3693,6 @@ void intel_prepare_reset(struct drm_i915
 		DRM_DEBUG_KMS("Modeset potentially stuck, unbreaking through wedging\n");
 		i915_gem_set_wedged(dev_priv);
 	}
->>>>>>> linux-next/akpm-base
 
 	/*
 	 * Need mode_config.mutex so that we don't
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
ocfs2-old-mle-put-and-release-after-the-function-dlm_add_migration_mle-called-fix.patch
ocfs2-dlm-optimization-of-code-while-free-dead-node-locks-checkpatch-fixes.patch
mm.patch
mm-memory_hotplug-just-build-zonelist-for-new-added-node-fix.patch
mm-memory_hotplug-just-build-zonelist-for-new-added-node-fix-fix.patch
mm-thp-enable-thp-migration-in-generic-path-fix-fix.patch
zsmalloc-zs_page_migrate-skip-unnecessary-loops-but-not-return-ebusy-if-zspage-is-not-inuse-fix.patch
userfaultfd-selftest-exercise-uffdio_copy-zeropage-eexist-fix.patch
mm-swap-add-swap-readahead-hit-statistics-fix.patch
swap-choose-swap-device-according-to-numa-node-v2-fix.patch
add-testcases-for-memset16-32-64-fix.patch
lib-add-test-for-bitmap_parselist-fix.patch
bitmap-introduce-bitmap_from_u64-checkpatch-fixes.patch
bitmap-introduce-bitmap_from_u64-checkpatch-fixes-fix.patch
kernel-reboot-add-devm_register_reboot_notifier-fix.patch
linux-next-rejects.patch
treewide-remove-gfp_temporary-allocation-flag-fix.patch
treewide-remove-gfp_temporary-allocation-flag-checkpatch-fixes.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

