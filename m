From: akpm@linux-foundation.org
Subject: + mm-oom-rename-zonelist-locking-functions.patch added to -mm
 tree
Date: Thu, 24 Jul 2014 15:23:24 -0700
Message-ID: <53d1875c.Ya6amiYz6oRa1sC6%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f73.google.com ([209.85.213.73]:48253 "EHLO
	mail-yh0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751562AbaGXWX0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 24 Jul 2014 18:23:26 -0400
Received: by mail-yh0-f73.google.com with SMTP id f73so606082yha.4
        for <mm-commits@vger.kernel.org>; Thu, 24 Jul 2014 15:23:25 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rientjes@google.com, hannes@cmpxchg.org, kirill.shutemov@linux.intel.com, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, oom: rename zonelist locking functions
has been added to the -mm tree.  Its filename is
     mm-oom-rename-zonelist-locking-functions.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-oom-rename-zonelist-locking-functions.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-oom-rename-zonelist-locking-functions.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: David Rientjes <rientjes@google.com>
Subject: mm, oom: rename zonelist locking functions

try_set_zonelist_oom() and clear_zonelist_oom() are not named properly to
imply that they require locking semantics to avoid out_of_memory() being
reordered.

zone_scan_lock is required for both functions to ensure that there is
proper locking synchronization.

Rename try_set_zonelist_oom() to oom_zonelist_trylock() and rename
clear_zonelist_oom() to oom_zonelist_unlock() to imply there is proper
locking semantics.

At the same time, convert oom_zonelist_trylock() to return bool instead of
int since only success and failure are tested.

Signed-off-by: David Rientjes <rientjes@google.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/oom.h |    4 ++--
 mm/oom_kill.c       |   30 +++++++++++++-----------------
 mm/page_alloc.c     |    6 +++---
 3 files changed, 18 insertions(+), 22 deletions(-)

diff -puN include/linux/oom.h~mm-oom-rename-zonelist-locking-functions include/linux/oom.h
--- a/include/linux/oom.h~mm-oom-rename-zonelist-locking-functions
+++ a/include/linux/oom.h
@@ -55,8 +55,8 @@ extern void oom_kill_process(struct task
 			     struct mem_cgroup *memcg, nodemask_t *nodemask,
 			     const char *message);
 
-extern int try_set_zonelist_oom(struct zonelist *zonelist, gfp_t gfp_flags);
-extern void clear_zonelist_oom(struct zonelist *zonelist, gfp_t gfp_flags);
+extern bool oom_zonelist_trylock(struct zonelist *zonelist, gfp_t gfp_flags);
+extern void oom_zonelist_unlock(struct zonelist *zonelist, gfp_t gfp_flags);
 
 extern void check_panic_on_oom(enum oom_constraint constraint, gfp_t gfp_mask,
 			       int order, const nodemask_t *nodemask);
diff -puN mm/oom_kill.c~mm-oom-rename-zonelist-locking-functions mm/oom_kill.c
--- a/mm/oom_kill.c~mm-oom-rename-zonelist-locking-functions
+++ a/mm/oom_kill.c
@@ -557,28 +557,25 @@ EXPORT_SYMBOL_GPL(unregister_oom_notifie
  * if a parallel OOM killing is already taking place that includes a zone in
  * the zonelist.  Otherwise, locks all zones in the zonelist and returns 1.
  */
-int try_set_zonelist_oom(struct zonelist *zonelist, gfp_t gfp_mask)
+bool oom_zonelist_trylock(struct zonelist *zonelist, gfp_t gfp_mask)
 {
 	struct zoneref *z;
 	struct zone *zone;
-	int ret = 1;
+	bool ret = true;
 
 	spin_lock(&zone_scan_lock);
-	for_each_zone_zonelist(zone, z, zonelist, gfp_zone(gfp_mask)) {
+	for_each_zone_zonelist(zone, z, zonelist, gfp_zone(gfp_mask))
 		if (zone_is_oom_locked(zone)) {
-			ret = 0;
+			ret = false;
 			goto out;
 		}
-	}
 
-	for_each_zone_zonelist(zone, z, zonelist, gfp_zone(gfp_mask)) {
-		/*
-		 * Lock each zone in the zonelist under zone_scan_lock so a
-		 * parallel invocation of try_set_zonelist_oom() doesn't succeed
-		 * when it shouldn't.
-		 */
+	/*
+	 * Lock each zone in the zonelist under zone_scan_lock so a parallel
+	 * call to oom_zonelist_trylock() doesn't succeed when it shouldn't.
+	 */
+	for_each_zone_zonelist(zone, z, zonelist, gfp_zone(gfp_mask))
 		zone_set_flag(zone, ZONE_OOM_LOCKED);
-	}
 
 out:
 	spin_unlock(&zone_scan_lock);
@@ -590,15 +587,14 @@ out:
  * allocation attempts with zonelists containing them may now recall the OOM
  * killer, if necessary.
  */
-void clear_zonelist_oom(struct zonelist *zonelist, gfp_t gfp_mask)
+void oom_zonelist_unlock(struct zonelist *zonelist, gfp_t gfp_mask)
 {
 	struct zoneref *z;
 	struct zone *zone;
 
 	spin_lock(&zone_scan_lock);
-	for_each_zone_zonelist(zone, z, zonelist, gfp_zone(gfp_mask)) {
+	for_each_zone_zonelist(zone, z, zonelist, gfp_zone(gfp_mask))
 		zone_clear_flag(zone, ZONE_OOM_LOCKED);
-	}
 	spin_unlock(&zone_scan_lock);
 }
 
@@ -693,8 +689,8 @@ void pagefault_out_of_memory(void)
 		return;
 
 	zonelist = node_zonelist(first_memory_node, GFP_KERNEL);
-	if (try_set_zonelist_oom(zonelist, GFP_KERNEL)) {
+	if (oom_zonelist_trylock(zonelist, GFP_KERNEL)) {
 		out_of_memory(zonelist, 0, 0, NULL, false);
-		clear_zonelist_oom(zonelist, GFP_KERNEL);
+		oom_zonelist_unlock(zonelist, GFP_KERNEL);
 	}
 }
diff -puN mm/page_alloc.c~mm-oom-rename-zonelist-locking-functions mm/page_alloc.c
--- a/mm/page_alloc.c~mm-oom-rename-zonelist-locking-functions
+++ a/mm/page_alloc.c
@@ -2246,8 +2246,8 @@ __alloc_pages_may_oom(gfp_t gfp_mask, un
 {
 	struct page *page;
 
-	/* Acquire the OOM killer lock for the zones in zonelist */
-	if (!try_set_zonelist_oom(zonelist, gfp_mask)) {
+	/* Acquire the per-zone oom lock for each zone */
+	if (!oom_zonelist_trylock(zonelist, gfp_mask)) {
 		schedule_timeout_uninterruptible(1);
 		return NULL;
 	}
@@ -2285,7 +2285,7 @@ __alloc_pages_may_oom(gfp_t gfp_mask, un
 	out_of_memory(zonelist, gfp_mask, order, nodemask, false);
 
 out:
-	clear_zonelist_oom(zonelist, gfp_mask);
+	oom_zonelist_unlock(zonelist, gfp_mask);
 	return page;
 }
 
_

Patches currently in -mm which might be from rientjes@google.com are

origin.patch
mm-thp-do-not-allow-thp-faults-to-avoid-cpuset-restrictions.patch
x86-numa-setup_node_data-drop-dead-code-and-rename-function.patch
x86-numa-setup_node_data-drop-dead-code-and-rename-function-v2.patch
score-ptrace-remove-the-macros-which-not-be-used-currently.patch
mm-slabc-add-__init-to-init_lock_keys.patch
slab-common-add-functions-for-kmem_cache_node-access.patch
slab-common-add-functions-for-kmem_cache_node-access-fix.patch
slub-use-new-node-functions.patch
slub-use-new-node-functions-fix.patch
slab-use-get_node-and-kmem_cache_node-functions.patch
slab-use-get_node-and-kmem_cache_node-functions-fix.patch
slab-use-get_node-and-kmem_cache_node-functions-fix-2.patch
mm-slabh-wrap-the-whole-file-with-guarding-macro.patch
mm-slub-mark-resiliency_test-as-init-text.patch
mm-slub-slub_debug=n-use-the-same-alloc-free-hooks-as-for-slub_debug=y.patch
slab-add-unlikely-macro-to-help-compiler.patch
slab-move-up-code-to-get-kmem_cache_node-in-free_block.patch
slab-defer-slab_destroy-in-free_block.patch
slab-defer-slab_destroy-in-free_block-v4.patch
slab-factor-out-initialization-of-arracy-cache.patch
slab-introduce-alien_cache.patch
slab-use-the-lock-on-alien_cache-instead-of-the-lock-on-array_cache.patch
slab-destroy-a-slab-without-holding-any-alien-cache-lock.patch
slab-remove-a-useless-lockdep-annotation.patch
slab-remove-bad_alien_magic.patch
slab-change-int-to-size_t-for-representing-allocation-size.patch
slub-reduce-duplicate-creation-on-the-first-object.patch
mm-move-slab-related-stuff-from-utilc-to-slab_commonc.patch
mm-trivial-comment-cleanup-in-slabc.patch
mm-slub-fix-false-positive-lockdep-warning-in-free_partial.patch
mm-slub-fix-some-indenting-in-cmpxchg_double_slab.patch
slab-fix-the-alias-countvia-sysfs-of-slab-cache.patch
mm-readaheadc-remove-unused-file_ra_state-from-count_history_pages.patch
mm-memory_hotplugc-add-__meminit-to-grow_zone_span-grow_pgdat_span.patch
mm-page_allocc-unexport-alloc_pages_exact_nid.patch
mm-page_alloc-simplify-drain_zone_pages-by-using-min.patch
mm-mem-hotplug-replace-simple_strtoull-with-kstrtoull.patch
mm-vmallocc-add-a-schedule-point-to-vmalloc.patch
mm-vmallocc-add-a-schedule-point-to-vmalloc-fix.patch
mm-vmalloc-constify-allocation-mask.patch
mmhugetlb-make-unmap_ref_private-return-void.patch
mmhugetlb-simplify-error-handling-in-hugetlb_cow.patch
mm-hugetlb-generalize-writes-to-nr_hugepages.patch
mm-hugetlb-generalize-writes-to-nr_hugepages-fix.patch
mm-hugetlb-remove-hugetlb_zero-and-hugetlb_infinity.patch
mm-make-copy_pte_range-static-again.patch
mm-thp-only-collapse-hugepages-to-nodes-with-affinity-for-zone_reclaim_mode.patch
mm-writeback-prevent-race-when-calculating-dirty-limits.patch
slub-remove-kmemcg-id-from-create_unique_id.patch
mm-refactor-page-index-offset-getters.patch
mm-refactor-page-index-offset-getters-fix.patch
mm-oom-ensure-memoryless-node-zonelist-always-includes-zones.patch
mm-oom-remove-unnecessary-check-for-null-zonelist.patch
mm-oom-rename-zonelist-locking-functions.patch
include-kernelh-rewrite-min3-max3-and-clamp-using-min-and-max.patch
lib-add-size-unit-t-p-e-to-memparse.patch
mm-utilc-add-kstrimdup.patch
fs-proc-kcorec-use-page_align-instead-of-alignpage_size.patch
fork-exec-cleanup-mm-initialization.patch
fork-reset-mm-pinned_vm.patch
fork-copy-mms-vm-usage-counters-under-mmap_sem.patch
linux-next.patch

