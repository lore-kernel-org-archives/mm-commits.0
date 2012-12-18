From: akpm@linux-foundation.org
Subject: [folded-dropped] memcg-skip-memcg-kmem-allocations-in-specified-code-regions-remove-test-for-current-mm-in-memcg_stop-resume_kmem_account.patch removed from -mm tree
Date: Tue, 18 Dec 2012 14:14:24 -0800
Message-ID: <20121218221425.7DE4620004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-la0-f74.google.com ([209.85.215.74]:53924 "EHLO
	mail-la0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932103Ab2LRWO2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 18 Dec 2012 17:14:28 -0500
Received: by mail-la0-f74.google.com with SMTP id v3so67917lag.3
        for <mm-commits@vger.kernel.org>; Tue, 18 Dec 2012 14:14:27 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: glommer@parallels.com, hannes@cmpxchg.org, kamezawa.hiroyu@jp.fujitsu.com, mhocko@suse.cz, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: memcg: remove test for current->mm in memcg_stop/resume_kmem_account
has been removed from the -mm tree.  Its filename was
     memcg-skip-memcg-kmem-allocations-in-specified-code-regions-remove-test-for-current-mm-in-memcg_stop-resume_kmem_account.patch

This patch was dropped because it was folded into memcg-skip-memcg-kmem-allocations-in-specified-code-regions.patch

------------------------------------------------------
From: Glauber Costa <glommer@parallels.com>
Subject: memcg: remove test for current->mm in memcg_stop/resume_kmem_account

The original reason for the existence of this test, was that
memcg_kmem_cache_create could be called from either softirq context (where
memcg_stop/resume_account is not needed), or process context, (where
memcg_stop/resume_account is needed).  Just skipping it in-function was
the cleanest way to merge both behaviors.  The reason for that is that we
would try to create caches right away through memcg_kmem_cache_create if
the context would allow us to.

However, the final version of the code that merged did not have this
behavior and we always queue up new cache creation.  Thus, instead of a
comment explaining why current->mm test is needed, my proposal in this
patch is to remove memcg_stop/resume_account from the worker thread and
make sure all callers have a valid mm context.

Signed-off-by: Glauber Costa <glommer@parallels.com>
Cc: Michal Hocko <mhocko@suse.cz>
Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   12 ++----------
 1 file changed, 2 insertions(+), 10 deletions(-)

diff -puN mm/memcontrol.c~memcg-skip-memcg-kmem-allocations-in-specified-code-regions-remove-test-for-current-mm-in-memcg_stop-resume_kmem_account mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-skip-memcg-kmem-allocations-in-specified-code-regions-remove-test-for-current-mm-in-memcg_stop-resume_kmem_account
+++ a/mm/memcontrol.c
@@ -3046,17 +3046,13 @@ out:
  */
 static inline void memcg_stop_kmem_account(void)
 {
-	if (!current->mm)
-		return;
-
+	VM_BUG_ON(!current->mm);
 	current->memcg_kmem_skip_account++;
 }
 
 static inline void memcg_resume_kmem_account(void)
 {
-	if (!current->mm)
-		return;
-
+	VM_BUG_ON(!current->mm);
 	current->memcg_kmem_skip_account--;
 }
 
@@ -3118,11 +3114,7 @@ static struct kmem_cache *memcg_create_k
 	if (new_cachep)
 		goto out;
 
-	/* Don't block progress to enqueue caches for internal infrastructure */
-	memcg_stop_kmem_account();
 	new_cachep = kmem_cache_dup(memcg, cachep);
-	memcg_resume_kmem_account();
-
 	if (new_cachep == NULL) {
 		new_cachep = cachep;
 		goto out;
_

Patches currently in -mm which might be from glommer@parallels.com are

origin.patch
memcg-make-it-possible-to-use-the-stock-for-more-than-one-page.patch
memcg-reclaim-when-more-than-one-page-needed.patch
memcg-change-defines-to-an-enum.patch
memcg-kmem-accounting-basic-infrastructure.patch
mm-add-a-__gfp_kmemcg-flag.patch
memcg-kmem-controller-infrastructure.patch
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
memcg-infrastructure-to-match-an-allocation-to-the-right-cache.patch
memcg-skip-memcg-kmem-allocations-in-specified-code-regions.patch
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

