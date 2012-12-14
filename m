From: akpm@linux-foundation.org
Subject: [merged] mm-oom-cleanup-pagefault-oom-handler.patch removed from -mm tree
Date: Fri, 14 Dec 2012 15:29:21 -0800
Message-ID: <20121214232921.AD6E6100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f202.google.com ([209.85.161.202]:36366 "EHLO
	mail-gg0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932668Ab2LNX3W (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 14 Dec 2012 18:29:22 -0500
Received: by mail-gg0-f202.google.com with SMTP id k1so408587ggn.1
        for <mm-commits@vger.kernel.org>; Fri, 14 Dec 2012 15:29:22 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rientjes@google.com, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, mhocko@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, oom: cleanup pagefault oom handler
has been removed from the -mm tree.  Its filename was
     mm-oom-cleanup-pagefault-oom-handler.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: David Rientjes <rientjes@google.com>
Subject: mm, oom: cleanup pagefault oom handler

To lock the entire system from parallel oom killing, it's possible to pass
in a zonelist with all zones rather than using for_each_populated_zone()
for the iteration.  This obsoletes try_set_system_oom() and
clear_system_oom() so that they can be removed.

Signed-off-by: David Rientjes <rientjes@google.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Reviewed-by: Michal Hocko <mhocko@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/oom_kill.c |   49 ++++++------------------------------------------
 1 file changed, 7 insertions(+), 42 deletions(-)

diff -puN mm/oom_kill.c~mm-oom-cleanup-pagefault-oom-handler mm/oom_kill.c
--- a/mm/oom_kill.c~mm-oom-cleanup-pagefault-oom-handler
+++ a/mm/oom_kill.c
@@ -591,43 +591,6 @@ void clear_zonelist_oom(struct zonelist 
 	spin_unlock(&zone_scan_lock);
 }
 
-/*
- * Try to acquire the oom killer lock for all system zones.  Returns zero if a
- * parallel oom killing is taking place, otherwise locks all zones and returns
- * non-zero.
- */
-static int try_set_system_oom(void)
-{
-	struct zone *zone;
-	int ret = 1;
-
-	spin_lock(&zone_scan_lock);
-	for_each_populated_zone(zone)
-		if (zone_is_oom_locked(zone)) {
-			ret = 0;
-			goto out;
-		}
-	for_each_populated_zone(zone)
-		zone_set_flag(zone, ZONE_OOM_LOCKED);
-out:
-	spin_unlock(&zone_scan_lock);
-	return ret;
-}
-
-/*
- * Clears ZONE_OOM_LOCKED for all system zones so that failed allocation
- * attempts or page faults may now recall the oom killer, if necessary.
- */
-static void clear_system_oom(void)
-{
-	struct zone *zone;
-
-	spin_lock(&zone_scan_lock);
-	for_each_populated_zone(zone)
-		zone_clear_flag(zone, ZONE_OOM_LOCKED);
-	spin_unlock(&zone_scan_lock);
-}
-
 /**
  * out_of_memory - kill the "best" process when we run out of memory
  * @zonelist: zonelist pointer
@@ -708,15 +671,17 @@ out:
 
 /*
  * The pagefault handler calls here because it is out of memory, so kill a
- * memory-hogging task.  If a populated zone has ZONE_OOM_LOCKED set, a parallel
- * oom killing is already in progress so do nothing.  If a task is found with
- * TIF_MEMDIE set, it has been killed so do nothing and allow it to exit.
+ * memory-hogging task.  If any populated zone has ZONE_OOM_LOCKED set, a
+ * parallel oom killing is already in progress so do nothing.
  */
 void pagefault_out_of_memory(void)
 {
-	if (try_set_system_oom()) {
+	struct zonelist *zonelist = node_zonelist(first_online_node,
+						  GFP_KERNEL);
+
+	if (try_set_zonelist_oom(zonelist, GFP_KERNEL)) {
 		out_of_memory(NULL, 0, 0, NULL, false);
-		clear_system_oom();
+		clear_zonelist_oom(zonelist, GFP_KERNEL);
 	}
 	schedule_timeout_killable(1);
 }
_

Patches currently in -mm which might be from rientjes@google.com are

origin.patch
linux-next.patch
x86-convert-update_mmu_cache-and-update_mmu_cache_pmd-to-functions.patch
x86-fix-the-argument-passed-to-sync_global_pgds.patch
irq-tsk-comm-is-an-array.patch
mm-mempolicy-introduce-spinlock-to-read-shared-policy-tree.patch
memcg-make-it-possible-to-use-the-stock-for-more-than-one-page.patch
memcg-reclaim-when-more-than-one-page-needed.patch
memcg-change-defines-to-an-enum.patch
memcg-kmem-accounting-basic-infrastructure.patch
memcg-kmem-accounting-basic-infrastructure-fix.patch
mm-add-a-__gfp_kmemcg-flag.patch
memcg-kmem-controller-infrastructure.patch
memcg-kmem-controller-infrastructure-replace-__always_inline-with-plain-inline.patch
mm-allocate-kernel-pages-to-the-right-memcg.patch
res_counter-return-amount-of-charges-after-res_counter_uncharge.patch
memcg-kmem-accounting-lifecycle-management.patch
memcg-use-static-branches-when-code-not-in-use.patch
memcg-allow-a-memcg-with-kmem-charges-to-be-destructed.patch
memcg-execute-the-whole-memcg-freeing-in-free_worker.patch
fork-protect-architectures-where-thread_size-=-page_size-against-fork-bombs.patch
memcg-add-documentation-about-the-kmem-controller.patch
slab-slub-struct-memcg_params.patch
slab-annotate-on-slab-caches-nodelist-locks.patch
slab-slub-consider-a-memcg-parameter-in-kmem_create_cache.patch
memcg-allocate-memory-for-memcg-caches-whenever-a-new-memcg-appears.patch
memcg-allocate-memory-for-memcg-caches-whenever-a-new-memcg-appears-simplify-ida-initialization.patch
memcg-infrastructure-to-match-an-allocation-to-the-right-cache.patch
memcg-skip-memcg-kmem-allocations-in-specified-code-regions.patch
memcg-skip-memcg-kmem-allocations-in-specified-code-regions-remove-test-for-current-mm-in-memcg_stop-resume_kmem_account.patch
slb-always-get-the-cache-from-its-page-in-kmem_cache_free.patch
slb-allocate-objects-from-memcg-cache.patch
memcg-destroy-memcg-caches.patch
memcg-destroy-memcg-caches-move-include-of-workqueueh-to-top-of-slabh-file.patch
memcg-slb-track-all-the-memcg-children-of-a-kmem_cache.patch
memcg-slb-shrink-dead-caches.patch
memcg-slb-shrink-dead-caches-get-rid-of-once-per-second-cache-shrinking-for-dead-memcgs.patch
memcg-aggregate-memcg-cache-values-in-slabinfo.patch
slab-propagate-tunable-values.patch
slub-slub-specific-propagation-changes.patch
slub-slub-specific-propagation-changes-fix.patch
kmem-add-slab-specific-documentation-about-the-kmem-controller.patch
memcg-add-comments-clarifying-aspects-of-cache-attribute-propagation.patch
slub-drop-mutex-before-deleting-sysfs-entry.patch
ksm-numa-awareness-sysfs-knob.patch
mm-dmapoolc-fix-null-dev-in-dma_pool_create.patch

