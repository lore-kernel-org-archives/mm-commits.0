From: akpm@linux-foundation.org
Subject: [obsolete] linux-next-git-rejects.patch removed from -mm tree
Date: Wed, 05 Apr 2017 12:58:53 -0700
Message-ID: <58e54c7d.NLyW5w2BuAAH8M4G%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43248 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933371AbdDET6z (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 5 Apr 2017 15:58:55 -0400
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

 drivers/gpu/drm/msm/adreno/adreno_gpu.c |    4 ----
 drivers/gpu/drm/vmwgfx/vmwgfx_fence.c   |   12 ------------
 2 files changed, 16 deletions(-)

diff -puN drivers/gpu/drm/msm/adreno/adreno_gpu.c~linux-next-git-rejects drivers/gpu/drm/msm/adreno/adreno_gpu.c
--- a/drivers/gpu/drm/msm/adreno/adreno_gpu.c~linux-next-git-rejects
+++ a/drivers/gpu/drm/msm/adreno/adreno_gpu.c
@@ -440,10 +440,6 @@ void adreno_gpu_cleanup(struct adreno_gp
 	if (gpu->aspace) {
 		gpu->aspace->mmu->funcs->detach(gpu->aspace->mmu,
 			iommu_ports, ARRAY_SIZE(iommu_ports));
-<<<<<<< HEAD
-		msm_gem_address_space_destroy(gpu->aspace);
-=======
 		msm_gem_address_space_put(gpu->aspace);
->>>>>>> linux-next/akpm-base
 	}
 }
diff -puN drivers/gpu/drm/vmwgfx/vmwgfx_fence.c~linux-next-git-rejects drivers/gpu/drm/vmwgfx/vmwgfx_fence.c
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_fence.c~linux-next-git-rejects
+++ a/drivers/gpu/drm/vmwgfx/vmwgfx_fence.c
@@ -761,18 +761,12 @@ int vmw_fence_obj_wait_ioctl(struct drm_
 		arg->kernel_cookie = jiffies + wait_timeout;
 	}
 
-<<<<<<< HEAD
-	base = vmw_fence_obj_lookup(tfile, arg->handle);
-	if (IS_ERR(base))
-		return PTR_ERR(base);
-=======
 	base = ttm_base_object_lookup(tfile, arg->handle);
 	if (unlikely(base == NULL)) {
 		pr_err("Wait invalid fence object handle 0x%08lx\n",
 		       (unsigned long)arg->handle);
 		return -EINVAL;
 	}
->>>>>>> linux-next/akpm-base
 
 	fence = &(container_of(base, struct vmw_user_fence, base)->fence);
 
@@ -811,18 +805,12 @@ int vmw_fence_obj_signaled_ioctl(struct
 	struct ttm_object_file *tfile = vmw_fpriv(file_priv)->tfile;
 	struct vmw_private *dev_priv = vmw_priv(dev);
 
-<<<<<<< HEAD
-	base = vmw_fence_obj_lookup(tfile, arg->handle);
-	if (IS_ERR(base))
-		return PTR_ERR(base);
-=======
 	base = ttm_base_object_lookup(tfile, arg->handle);
 	if (unlikely(base == NULL)) {
 		pr_err("Fence signaled invalid fence object handle 0x%08lx\n",
 		       (unsigned long)arg->handle);
 		return -EINVAL;
 	}
->>>>>>> linux-next/akpm-base
 
 	fence = &(container_of(base, struct vmw_user_fence, base)->fence);
 	fman = fman_from_fence(fence);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
ptrace-fix-ptrace_listen-race-corrupting-task-state-checkpatch-fixes.patch
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
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

