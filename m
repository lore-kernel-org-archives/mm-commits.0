From: akpm@linux-foundation.org
Subject: + linux-next-git-rejects.patch added to -mm tree
Date: Fri, 16 Feb 2018 12:23:01 -0800
Message-ID: <20180216202301.10EGlQBrr%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43858 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750713AbeBPUXD (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 16 Feb 2018 15:23:03 -0500
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

 drivers/gpu/drm/i915/i915_pmu.c          |    3 --
 drivers/gpu/drm/i915/i915_pmu.h          |    3 --
 drivers/gpu/drm/i915/intel_breadcrumbs.c |   24 ---------------------
 3 files changed, 30 deletions(-)

diff -puN drivers/gpu/drm/i915/i915_pmu.c~linux-next-git-rejects drivers/gpu/drm/i915/i915_pmu.c
--- a/drivers/gpu/drm/i915/i915_pmu.c~linux-next-git-rejects
+++ a/drivers/gpu/drm/i915/i915_pmu.c
@@ -320,8 +320,6 @@ engine_event_status(struct intel_engine_
 		break;
 	case I915_SAMPLE_SEMA:
 		if (INTEL_GEN(engine->i915) < 6)
-<<<<<<< HEAD
-=======
 			return -ENODEV;
 		break;
 	default:
@@ -342,7 +340,6 @@ config_status(struct drm_i915_private *i
 		/* Fall-through. */
 	case I915_PMU_REQUESTED_FREQUENCY:
 		if (INTEL_GEN(i915) < 6)
->>>>>>> linux-next/akpm-base
 			return -ENODEV;
 		break;
 	case I915_PMU_INTERRUPTS:
diff -puN drivers/gpu/drm/i915/i915_pmu.h~linux-next-git-rejects drivers/gpu/drm/i915/i915_pmu.h
--- a/drivers/gpu/drm/i915/i915_pmu.h~linux-next-git-rejects
+++ a/drivers/gpu/drm/i915/i915_pmu.h
@@ -100,8 +100,6 @@ struct i915_pmu {
 	 * @suspended_jiffies_last: Cached suspend time from PM core.
 	 */
 	unsigned long suspended_jiffies_last;
-<<<<<<< HEAD
-=======
 	/**
 	 * @i915_attr: Memory block holding device attributes.
 	 */
@@ -110,7 +108,6 @@ struct i915_pmu {
 	 * @pmu_attr: Memory block holding device attributes.
 	 */
 	void *pmu_attr;
->>>>>>> linux-next/akpm-base
 };
 
 #ifdef CONFIG_PERF_EVENTS
diff -puN drivers/gpu/drm/i915/intel_breadcrumbs.c~linux-next-git-rejects drivers/gpu/drm/i915/intel_breadcrumbs.c
--- a/drivers/gpu/drm/i915/intel_breadcrumbs.c~linux-next-git-rejects
+++ a/drivers/gpu/drm/i915/intel_breadcrumbs.c
@@ -701,30 +701,6 @@ static int intel_breadcrumbs_signaler(vo
 				dma_fence_signal(&request->fence);
 				GEM_BUG_ON(!i915_gem_request_completed(request));
 				local_bh_enable(); /* kick start the tasklets */
-<<<<<<< HEAD
-			}
-
-			spin_lock_irq(&b->rb_lock);
-
-			/* Wake up all other completed waiters and select the
-			 * next bottom-half for the next user interrupt.
-			 */
-			__intel_engine_remove_wait(engine,
-						   &request->signaling.wait);
-
-			/* Find the next oldest signal. Note that as we have
-			 * not been holding the lock, another client may
-			 * have installed an even older signal than the one
-			 * we just completed - so double check we are still
-			 * the oldest before picking the next one.
-			 */
-			if (request == rcu_access_pointer(b->first_signal)) {
-				struct rb_node *rb =
-					rb_next(&request->signaling.node);
-				rcu_assign_pointer(b->first_signal,
-						   rb ? to_signaler(rb) : NULL);
-=======
->>>>>>> linux-next/akpm-base
 			}
 
 			if (READ_ONCE(request->signaling.wait.seqno)) {
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
include-linux-sched-mmh-re-inline-mmdrop.patch
mm-zpool-zpool_evictable-fix-mismatch-in-parameter-name-and-kernel-doc-fix.patch
vmalloc-fix-__gfp_highmem-usage-for-vmalloc_32-on-32b-systems-checkpatch-fixes.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
mm.patch
list_lru-prefetch-neighboring-list-entries-before-acquiring-lock-fix.patch
mm-oom-cgroup-aware-oom-killer-fix.patch
mm-oom-docs-describe-the-cgroup-aware-oom-killer-fix-2-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch
linux-next-git-rejects.patch

