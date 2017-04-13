From: akpm@linux-foundation.org
Subject: + linux-next-git-rejects.patch added to -mm tree
Date: Thu, 13 Apr 2017 12:20:57 -0700
Message-ID: <58efcf99.4/r4qA8RQgn3W8IU%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57384 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752839AbdDMTU7 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 13 Apr 2017 15:20:59 -0400
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

 drivers/gpu/drm/i915/gvt/vgpu.c                   |    7 --
 drivers/gpu/drm/i915/i915_gem_shrinker.c          |   31 ------------
 drivers/gpu/drm/i915/intel_lrc.c                  |    3 -
 drivers/gpu/drm/i915/intel_ringbuffer.h           |   13 -----
 drivers/gpu/drm/nouveau/nvkm/engine/device/base.c |    3 -
 drivers/pinctrl/samsung/pinctrl-exynos.c          |    3 -
 6 files changed, 60 deletions(-)

diff -puN drivers/gpu/drm/i915/gvt/vgpu.c~linux-next-git-rejects drivers/gpu/drm/i915/gvt/vgpu.c
--- a/drivers/gpu/drm/i915/gvt/vgpu.c~linux-next-git-rejects
+++ a/drivers/gpu/drm/i915/gvt/vgpu.c
@@ -82,17 +82,10 @@ static struct {
 	char *name;
 } vgpu_types[] = {
 /* Fixed vGPU type table */
-<<<<<<< HEAD
-	{ MB_TO_BYTES(64), MB_TO_BYTES(384), 4, GVT_EDID_1024_768, "8" },
-	{ MB_TO_BYTES(128), MB_TO_BYTES(512), 4, GVT_EDID_1920_1200, "4" },
-	{ MB_TO_BYTES(256), MB_TO_BYTES(1024), 4, GVT_EDID_1920_1200, "2" },
-	{ MB_TO_BYTES(512), MB_TO_BYTES(2048), 4, GVT_EDID_1920_1200, "1" },
-=======
 	{ MB_TO_BYTES(64), MB_TO_BYTES(384), 4, VGPU_WEIGHT(8), GVT_EDID_1024_768, "8" },
 	{ MB_TO_BYTES(128), MB_TO_BYTES(512), 4, VGPU_WEIGHT(4), GVT_EDID_1920_1200, "4" },
 	{ MB_TO_BYTES(256), MB_TO_BYTES(1024), 4, VGPU_WEIGHT(2), GVT_EDID_1920_1200, "2" },
 	{ MB_TO_BYTES(512), MB_TO_BYTES(2048), 4, VGPU_WEIGHT(1), GVT_EDID_1920_1200, "1" },
->>>>>>> linux-next/akpm-base
 };
 
 /**
diff -puN drivers/gpu/drm/i915/i915_gem_shrinker.c~linux-next-git-rejects drivers/gpu/drm/i915/i915_gem_shrinker.c
--- a/drivers/gpu/drm/i915/i915_gem_shrinker.c~linux-next-git-rejects
+++ a/drivers/gpu/drm/i915/i915_gem_shrinker.c
@@ -53,20 +53,12 @@ static bool shrinker_lock(struct drm_i91
 	BUG();
 }
 
-<<<<<<< HEAD
-static void i915_gem_shrinker_unlock(struct drm_device *dev, bool unlock)
-=======
 static void shrinker_unlock(struct drm_i915_private *dev_priv, bool unlock)
->>>>>>> linux-next/akpm-base
 {
 	if (!unlock)
 		return;
 
-<<<<<<< HEAD
-	mutex_unlock(&dev->struct_mutex);
-=======
 	mutex_unlock(&dev_priv->drm.struct_mutex);
->>>>>>> linux-next/akpm-base
 
 	/* expedite the RCU grace period to free some request slabs */
 	synchronize_rcu_expedited();
@@ -252,11 +244,7 @@ i915_gem_shrink(struct drm_i915_private
 
 	i915_gem_retire_requests(dev_priv);
 
-<<<<<<< HEAD
-	i915_gem_shrinker_unlock(&dev_priv->drm, unlock);
-=======
 	shrinker_unlock(dev_priv, unlock);
->>>>>>> linux-next/akpm-base
 
 	return count;
 }
@@ -315,11 +303,7 @@ i915_gem_shrinker_count(struct shrinker
 			count += obj->base.size >> PAGE_SHIFT;
 	}
 
-<<<<<<< HEAD
-	i915_gem_shrinker_unlock(dev, unlock);
-=======
 	shrinker_unlock(dev_priv, unlock);
->>>>>>> linux-next/akpm-base
 
 	return count;
 }
@@ -346,11 +330,7 @@ i915_gem_shrinker_scan(struct shrinker *
 					 I915_SHRINK_BOUND |
 					 I915_SHRINK_UNBOUND);
 
-<<<<<<< HEAD
-	i915_gem_shrinker_unlock(dev, unlock);
-=======
 	shrinker_unlock(dev_priv, unlock);
->>>>>>> linux-next/akpm-base
 
 	return freed;
 }
@@ -379,17 +359,6 @@ shrinker_lock_uninterruptible(struct drm
 	return true;
 }
 
-<<<<<<< HEAD
-static void
-i915_gem_shrinker_unlock_uninterruptible(struct drm_i915_private *dev_priv,
-					 struct shrinker_lock_uninterruptible *slu)
-{
-	dev_priv->mm.interruptible = slu->was_interruptible;
-	i915_gem_shrinker_unlock(&dev_priv->drm, slu->unlock);
-}
-
-=======
->>>>>>> linux-next/akpm-base
 static int
 i915_gem_shrinker_oom(struct notifier_block *nb, unsigned long event, void *ptr)
 {
diff -puN drivers/gpu/drm/i915/intel_lrc.c~linux-next-git-rejects drivers/gpu/drm/i915/intel_lrc.c
--- a/drivers/gpu/drm/i915/intel_lrc.c~linux-next-git-rejects
+++ a/drivers/gpu/drm/i915/intel_lrc.c
@@ -1273,10 +1273,7 @@ static void reset_common_ring(struct int
 	request->tail =
 		intel_ring_wrap(request->ring,
 				request->wa_tail - WA_TAIL_DWORDS*sizeof(u32));
-<<<<<<< HEAD
-=======
 	assert_ring_tail_valid(request->ring, request->tail);
->>>>>>> linux-next/akpm-base
 }
 
 static int intel_logical_ring_emit_pdps(struct drm_i915_gem_request *req)
diff -puN drivers/gpu/drm/i915/intel_ringbuffer.h~linux-next-git-rejects drivers/gpu/drm/i915/intel_ringbuffer.h
--- a/drivers/gpu/drm/i915/intel_ringbuffer.h~linux-next-git-rejects
+++ a/drivers/gpu/drm/i915/intel_ringbuffer.h
@@ -527,18 +527,6 @@ intel_ring_wrap(const struct intel_ring
 }
 
 static inline u32
-<<<<<<< HEAD
-intel_ring_wrap(const struct intel_ring *ring, u32 pos)
-{
-	return pos & (ring->size - 1);
-}
-
-static inline u32 intel_ring_offset(struct intel_ring *ring, void *addr)
-{
-	/* Don't write ring->size (equivalent to 0) as that hangs some GPUs. */
-	u32 offset = addr - ring->vaddr;
-	return intel_ring_wrap(ring, offset);
-=======
 intel_ring_offset(const struct drm_i915_gem_request *req, void *addr)
 {
 	/* Don't write ring->size (equivalent to 0) as that hangs some GPUs. */
@@ -556,7 +544,6 @@ assert_ring_tail_valid(const struct inte
 	 */
 	GEM_BUG_ON(!IS_ALIGNED(tail, 8));
 	GEM_BUG_ON(tail >= ring->size);
->>>>>>> linux-next/akpm-base
 }
 
 void intel_ring_update_space(struct intel_ring *ring);
diff -puN drivers/gpu/drm/nouveau/nvkm/engine/device/base.c~linux-next-git-rejects drivers/gpu/drm/nouveau/nvkm/engine/device/base.c
--- a/drivers/gpu/drm/nouveau/nvkm/engine/device/base.c~linux-next-git-rejects
+++ a/drivers/gpu/drm/nouveau/nvkm/engine/device/base.c
@@ -2811,10 +2811,7 @@ nvkm_device_ctor(const struct nvkm_devic
 		case 0x134: device->chip = &nv134_chipset; break;
 		case 0x136: device->chip = &nv136_chipset; break;
 		case 0x137: device->chip = &nv137_chipset; break;
-<<<<<<< HEAD
-=======
 		case 0x13b: device->chip = &nv13b_chipset; break;
->>>>>>> linux-next/akpm-base
 		default:
 			nvdev_error(device, "unknown chipset (%08x)\n", boot0);
 			goto done;
diff -puN drivers/pinctrl/samsung/pinctrl-exynos.c~linux-next-git-rejects drivers/pinctrl/samsung/pinctrl-exynos.c
--- a/drivers/pinctrl/samsung/pinctrl-exynos.c~linux-next-git-rejects
+++ a/drivers/pinctrl/samsung/pinctrl-exynos.c
@@ -1549,8 +1549,6 @@ static const struct samsung_pin_bank_dat
 /* pin banks of exynos5433 pin-controller - TOUCH */
 static const struct samsung_pin_bank_data exynos5433_pin_banks9[] __initconst = {
 	EXYNOS5433_PIN_BANK_EINTG(3, 0x000, "gpj1", 0x00),
-<<<<<<< HEAD
-=======
 };
 
 /* PMU pin retention groups registers for Exynos5433 (without audio & fsys) */
@@ -1599,7 +1597,6 @@ static const struct samsung_retention_da
 	.nr_regs = ARRAY_SIZE(exynos5433_fsys_retention_regs),
 	.value	 = EXYNOS_WAKEUP_FROM_LOWPWR,
 	.init	 = exynos_retention_init,
->>>>>>> linux-next/akpm-base
 };
 
 /*
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
mm-page_alloc-re-enable-softirq-use-of-per-cpu-page-allocator-checkpatch-fixes.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
ocfs2-old-mle-put-and-release-after-the-function-dlm_add_migration_mle-called-fix.patch
ocfs2-dlm-optimization-of-code-while-free-dead-node-locks-checkpatch-fixes.patch
mm.patch
mm-move-madv_free-pages-into-lru_inactive_file-list-checkpatch-fixes.patch
mm-use-is_migrate_highatomic-to-simplify-the-code-fix.patch
mm-introduce-memalloc_nofs_saverestore-api-fix.patch
jbd2-mark-the-transaction-context-with-the-scope-gfp_nofs-context-fix.patch
jbd2-make-the-whole-kjournald2-kthread-nofs-safe-checkpatch-fixes.patch
mm-page_alloc-count-movable-pages-when-stealing-from-pageblock-fix.patch
swap-add-warning-if-swap-slots-cache-failed-to-initialize-fix.patch
checkpatch-add-ability-to-find-bad-uses-of-vsprintf-%pfoo-extensions-fix.patch
checkpatch-add-ability-to-find-bad-uses-of-vsprintf-%pfoo-extensions-fix-fix.patch
taskstats-add-e-u-stime-for-tgid-command-fix.patch
taskstats-add-e-u-stime-for-tgid-command-fix-fix.patch
kernel-reboot-add-devm_register_reboot_notifier-fix.patch
fault-inject-support-systematic-fault-injection-fix.patch
linux-next-rejects.patch
drm-use-set_memoryh-header-fix.patch
drivers-staging-media-atomisp-pci-atomisp2-use-set_memoryh.patch
docs-vm-transhuge-fix-few-trivial-typos-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch
linux-next-git-rejects.patch

