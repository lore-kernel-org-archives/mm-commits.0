From: akpm@linux-foundation.org
Subject: [obsolete] linux-next-git-rejects.patch removed from -mm
 tree
Date: Thu, 02 Nov 2017 12:42:44 -0700
Message-ID: <20171102194244.xuWaJWpBn%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42956 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934065AbdKBTmq (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 2 Nov 2017 15:42:46 -0400
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

 Documentation/process/index.rst               |    3 ---
 drivers/gpu/drm/amd/scheduler/gpu_scheduler.c |    4 ----
 drivers/gpu/drm/i915/i915_gem_evict.c         |   13 -------------
 3 files changed, 20 deletions(-)

diff -puN Documentation/process/index.rst~linux-next-git-rejects Documentation/process/index.rst
--- a/Documentation/process/index.rst~linux-next-git-rejects
+++ a/Documentation/process/index.rst
@@ -25,11 +25,8 @@ Below are the essential guides that ever
    submitting-patches
    coding-style
    email-clients
-<<<<<<< HEAD
    kernel-enforcement-statement
-=======
    kernel-driver-statement
->>>>>>> linux-next/akpm-base
 
 Other guides to the community that are of interest to most developers are: 
 
diff -puN drivers/gpu/drm/amd/scheduler/gpu_scheduler.c~linux-next-git-rejects drivers/gpu/drm/amd/scheduler/gpu_scheduler.c
--- a/drivers/gpu/drm/amd/scheduler/gpu_scheduler.c~linux-next-git-rejects
+++ a/drivers/gpu/drm/amd/scheduler/gpu_scheduler.c
@@ -215,9 +215,6 @@ void amd_sched_entity_fini(struct amd_gp
 	*/
 	wait_event(sched->job_scheduled, amd_sched_entity_is_idle(entity));
 
-<<<<<<< HEAD
-	amd_sched_rq_remove_entity(rq, entity);
-=======
 		/* Park the kernel for a moment to make sure it isn't processing
 		 * our enity.
 		 */
@@ -233,7 +230,6 @@ void amd_sched_entity_fini(struct amd_gp
 		}
 
 	}
->>>>>>> linux-next/akpm-base
 	kfifo_free(&entity->job_queue);
 }
 
diff -puN drivers/gpu/drm/i915/i915_gem_evict.c~linux-next-git-rejects drivers/gpu/drm/i915/i915_gem_evict.c
--- a/drivers/gpu/drm/i915/i915_gem_evict.c~linux-next-git-rejects
+++ a/drivers/gpu/drm/i915/i915_gem_evict.c
@@ -33,13 +33,10 @@
 #include "intel_drv.h"
 #include "i915_trace.h"
 
-<<<<<<< HEAD
-=======
 I915_SELFTEST_DECLARE(static struct igt_evict_ctl {
 	bool fail_if_busy:1;
 } igt_evict_ctl;)
 
->>>>>>> linux-next/akpm-base
 static bool ggtt_is_idle(struct drm_i915_private *i915)
 {
        struct intel_engine_cs *engine;
@@ -212,15 +209,6 @@ search_again:
 	 * the kernel's there is no more we can evict.
 	 */
 	if (!ggtt_is_idle(dev_priv)) {
-<<<<<<< HEAD
-		ret = ggtt_flush(dev_priv);
-		if (ret)
-			return ret;
-
-		goto search_again;
-	}
-
-=======
 		if (I915_SELFTEST_ONLY(igt_evict_ctl.fail_if_busy))
 			return -EBUSY;
 
@@ -231,7 +219,6 @@ search_again:
 		goto search_again;
 	}
 
->>>>>>> linux-next/akpm-base
 	/*
 	 * If we still have pending pageflip completions, drop
 	 * back to userspace to give our workqueues time to
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
ocfs2-old-mle-put-and-release-after-the-function-dlm_add_migration_mle-called-fix.patch
mm.patch
include-linux-sched-mmh-uninline-mmdrop_async-etc.patch
mm-swap-skip-swapcache-only-if-swapped-page-has-no-other-reference-checkpatch-fixes.patch
mm-drop-migrate-type-checks-from-has_unmovable_pages-fix.patch
mm-swap-fix-race-conditions-in-swap_slots-cache-init-fix.patch
mm-swap-fix-race-conditions-in-swap_slots-cache-init-fix-fix.patch
f2fs-simplify-page-iteration-loops-fix.patch
mm-deferred_init_memmap-improvements-fix.patch
mm-stop-zeroing-memory-during-allocation-in-vmemmap-fix.patch
mm-batch-radix-tree-operations-when-truncating-pages-fix-fix.patch
support-resetting-warn_once-checkpatch-fixes.patch
support-resetting-warn_once-for-all-architectures-v2-fix.patch
kernel-reboot-add-devm_register_reboot_notifier-fix.patch
watchdog-core-make-use-of-devm_register_reboot_notifier-fix.patch
sysvipc-unteach-ids-next_id-for-checkpoint_restore-checkpatch-fixes.patch
sysvipc-make-get_maxid-o1-again-checkpatch-fixes.patch
linux-next-rejects.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

