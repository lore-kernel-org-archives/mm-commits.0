From: akpm@linux-foundation.org
Subject: + drm-i915-wire-up-shrinkctl-nr_scanned.patch added to -mm tree
Date: Tue, 22 Aug 2017 15:45:59 -0700
Message-ID: <599cb427.AqA3UTlqi5XgCvAF%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56440 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751643AbdHVWqA (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 22 Aug 2017 18:46:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: chris@chris-wilson.co.uk, cl@linux.com, hannes@cmpxchg.org, hillf.zj@alibaba-inc.com, iamjoonsoo.kim@lge.com, joonas.lahtinen@linux.intel.com, mgorman@techsingularity.net, mhocko@suse.com, minchan@kernel.org, penberg@kernel.org, rientjes@google.com, shli@fb.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: drm/i915: wire up shrinkctl->nr_scanned
has been added to the -mm tree.  Its filename is
     drm-i915-wire-up-shrinkctl-nr_scanned.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/drm-i915-wire-up-shrinkctl-nr_scanned.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/drm-i915-wire-up-shrinkctl-nr_scanned.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Chris Wilson <chris@chris-wilson.co.uk>
Subject: drm/i915: wire up shrinkctl->nr_scanned

shrink_slab() allows us to report back the number of objects we
successfully scanned (out of the target shrinkctl->nr_to_scan).  As report
the number of pages owned by each GEM object as a separate item to the
shrinker, we cannot precisely control the number of shrinker objects we
scan on each pass; and indeed may free more than requested.  If we fail to
tell the shrinker about the number of objects we process, it will continue
to hold a grudge against us as any objects left unscanned are added to the
next reclaim -- and so we will keep on "unfairly" shrinking our own slab
in comparison to other slabs.

Link: http://lkml.kernel.org/r/20170822135325.9191-2-chris@chris-wilson.co.uk
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Hillf Danton <hillf.zj@alibaba-inc.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Shaohua Li <shli@fb.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Pekka Enberg <penberg@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpu/drm/i915/i915_debugfs.c      |    4 +--
 drivers/gpu/drm/i915/i915_drv.h          |    1 
 drivers/gpu/drm/i915/i915_gem.c          |    4 +--
 drivers/gpu/drm/i915/i915_gem_gtt.c      |    2 -
 drivers/gpu/drm/i915/i915_gem_shrinker.c |   24 +++++++++++++++------
 5 files changed, 24 insertions(+), 11 deletions(-)

diff -puN drivers/gpu/drm/i915/i915_debugfs.c~drm-i915-wire-up-shrinkctl-nr_scanned drivers/gpu/drm/i915/i915_debugfs.c
--- a/drivers/gpu/drm/i915/i915_debugfs.c~drm-i915-wire-up-shrinkctl-nr_scanned
+++ a/drivers/gpu/drm/i915/i915_debugfs.c
@@ -4333,10 +4333,10 @@ i915_drop_caches_set(void *data, u64 val
 
 	lockdep_set_current_reclaim_state(GFP_KERNEL);
 	if (val & DROP_BOUND)
-		i915_gem_shrink(dev_priv, LONG_MAX, I915_SHRINK_BOUND);
+		i915_gem_shrink(dev_priv, LONG_MAX, NULL, I915_SHRINK_BOUND);
 
 	if (val & DROP_UNBOUND)
-		i915_gem_shrink(dev_priv, LONG_MAX, I915_SHRINK_UNBOUND);
+		i915_gem_shrink(dev_priv, LONG_MAX, NULL, I915_SHRINK_UNBOUND);
 
 	if (val & DROP_SHRINK_ALL)
 		i915_gem_shrink_all(dev_priv);
diff -puN drivers/gpu/drm/i915/i915_drv.h~drm-i915-wire-up-shrinkctl-nr_scanned drivers/gpu/drm/i915/i915_drv.h
--- a/drivers/gpu/drm/i915/i915_drv.h~drm-i915-wire-up-shrinkctl-nr_scanned
+++ a/drivers/gpu/drm/i915/i915_drv.h
@@ -3628,6 +3628,7 @@ i915_gem_object_create_internal(struct d
 /* i915_gem_shrinker.c */
 unsigned long i915_gem_shrink(struct drm_i915_private *dev_priv,
 			      unsigned long target,
+			      unsigned long *nr_scanned,
 			      unsigned flags);
 #define I915_SHRINK_PURGEABLE 0x1
 #define I915_SHRINK_UNBOUND 0x2
diff -puN drivers/gpu/drm/i915/i915_gem.c~drm-i915-wire-up-shrinkctl-nr_scanned drivers/gpu/drm/i915/i915_gem.c
--- a/drivers/gpu/drm/i915/i915_gem.c~drm-i915-wire-up-shrinkctl-nr_scanned
+++ a/drivers/gpu/drm/i915/i915_gem.c
@@ -2408,7 +2408,7 @@ rebuild_st:
 				goto err_sg;
 			}
 
-			i915_gem_shrink(dev_priv, 2 * page_count, *s++);
+			i915_gem_shrink(dev_priv, 2 * page_count, NULL, *s++);
 			cond_resched();
 
 			/* We've tried hard to allocate the memory by reaping
@@ -5012,7 +5012,7 @@ int i915_gem_freeze_late(struct drm_i915
 	 * the objects as well, see i915_gem_freeze()
 	 */
 
-	i915_gem_shrink(dev_priv, -1UL, I915_SHRINK_UNBOUND);
+	i915_gem_shrink(dev_priv, -1UL, NULL, I915_SHRINK_UNBOUND);
 	i915_gem_drain_freed_objects(dev_priv);
 
 	mutex_lock(&dev_priv->drm.struct_mutex);
diff -puN drivers/gpu/drm/i915/i915_gem_gtt.c~drm-i915-wire-up-shrinkctl-nr_scanned drivers/gpu/drm/i915/i915_gem_gtt.c
--- a/drivers/gpu/drm/i915/i915_gem_gtt.c~drm-i915-wire-up-shrinkctl-nr_scanned
+++ a/drivers/gpu/drm/i915/i915_gem_gtt.c
@@ -2061,7 +2061,7 @@ int i915_gem_gtt_prepare_pages(struct dr
 		 */
 		GEM_BUG_ON(obj->mm.pages == pages);
 	} while (i915_gem_shrink(to_i915(obj->base.dev),
-				 obj->base.size >> PAGE_SHIFT,
+				 obj->base.size >> PAGE_SHIFT, NULL,
 				 I915_SHRINK_BOUND |
 				 I915_SHRINK_UNBOUND |
 				 I915_SHRINK_ACTIVE));
diff -puN drivers/gpu/drm/i915/i915_gem_shrinker.c~drm-i915-wire-up-shrinkctl-nr_scanned drivers/gpu/drm/i915/i915_gem_shrinker.c
--- a/drivers/gpu/drm/i915/i915_gem_shrinker.c~drm-i915-wire-up-shrinkctl-nr_scanned
+++ a/drivers/gpu/drm/i915/i915_gem_shrinker.c
@@ -136,6 +136,7 @@ static bool unsafe_drop_pages(struct drm
  * i915_gem_shrink - Shrink buffer object caches
  * @dev_priv: i915 device
  * @target: amount of memory to make available, in pages
+ * @nr_scanned: optional output for number of pages scanned (incremental)
  * @flags: control flags for selecting cache types
  *
  * This function is the main interface to the shrinker. It will try to release
@@ -158,7 +159,9 @@ static bool unsafe_drop_pages(struct drm
  */
 unsigned long
 i915_gem_shrink(struct drm_i915_private *dev_priv,
-		unsigned long target, unsigned flags)
+		unsigned long target,
+		unsigned long *nr_scanned,
+		unsigned flags)
 {
 	const struct {
 		struct list_head *list;
@@ -169,6 +172,7 @@ i915_gem_shrink(struct drm_i915_private
 		{ NULL, 0 },
 	}, *phase;
 	unsigned long count = 0;
+	unsigned long scanned = 0;
 	bool unlock;
 
 	if (!shrinker_lock(dev_priv, &unlock))
@@ -249,6 +253,7 @@ i915_gem_shrink(struct drm_i915_private
 					count += obj->base.size >> PAGE_SHIFT;
 				}
 				mutex_unlock(&obj->mm.lock);
+				scanned += obj->base.size >> PAGE_SHIFT;
 			}
 		}
 		list_splice_tail(&still_in_list, phase->list);
@@ -261,6 +266,8 @@ i915_gem_shrink(struct drm_i915_private
 
 	shrinker_unlock(dev_priv, unlock);
 
+	if (nr_scanned)
+		*nr_scanned += scanned;
 	return count;
 }
 
@@ -283,7 +290,7 @@ unsigned long i915_gem_shrink_all(struct
 	unsigned long freed;
 
 	intel_runtime_pm_get(dev_priv);
-	freed = i915_gem_shrink(dev_priv, -1UL,
+	freed = i915_gem_shrink(dev_priv, -1UL, NULL,
 				I915_SHRINK_BOUND |
 				I915_SHRINK_UNBOUND |
 				I915_SHRINK_ACTIVE);
@@ -329,23 +336,28 @@ i915_gem_shrinker_scan(struct shrinker *
 	unsigned long freed;
 	bool unlock;
 
+	sc->nr_scanned = 0;
+
 	if (!shrinker_lock(dev_priv, &unlock))
 		return SHRINK_STOP;
 
 	freed = i915_gem_shrink(dev_priv,
 				sc->nr_to_scan,
+				&sc->nr_scanned,
 				I915_SHRINK_BOUND |
 				I915_SHRINK_UNBOUND |
 				I915_SHRINK_PURGEABLE);
 	if (freed < sc->nr_to_scan)
 		freed += i915_gem_shrink(dev_priv,
-					 sc->nr_to_scan - freed,
+					 sc->nr_to_scan - sc->nr_scanned,
+					 &sc->nr_scanned,
 					 I915_SHRINK_BOUND |
 					 I915_SHRINK_UNBOUND);
 	if (freed < sc->nr_to_scan && current_is_kswapd()) {
 		intel_runtime_pm_get(dev_priv);
 		freed += i915_gem_shrink(dev_priv,
-					 sc->nr_to_scan - freed,
+					 sc->nr_to_scan - sc->nr_scanned,
+					 &sc->nr_scanned,
 					 I915_SHRINK_ACTIVE |
 					 I915_SHRINK_BOUND |
 					 I915_SHRINK_UNBOUND);
@@ -354,7 +366,7 @@ i915_gem_shrinker_scan(struct shrinker *
 
 	shrinker_unlock(dev_priv, unlock);
 
-	return freed;
+	return sc->nr_scanned ? freed : SHRINK_STOP;
 }
 
 static bool
@@ -453,7 +465,7 @@ i915_gem_shrinker_vmap(struct notifier_b
 		goto out;
 
 	intel_runtime_pm_get(dev_priv);
-	freed_pages += i915_gem_shrink(dev_priv, -1UL,
+	freed_pages += i915_gem_shrink(dev_priv, -1UL, NULL,
 				       I915_SHRINK_BOUND |
 				       I915_SHRINK_UNBOUND |
 				       I915_SHRINK_ACTIVE |
_

Patches currently in -mm which might be from chris@chris-wilson.co.uk are

mm-track-actual-nr_scanned-during-shrink_slab.patch
drm-i915-wire-up-shrinkctl-nr_scanned.patch

