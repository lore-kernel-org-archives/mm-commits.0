From: akpm@linux-foundation.org
Subject: +
 mm-memcontrol-do-not-kill-uncharge-batching-in-free_pages_and_swap_cache.patch added to -mm tree
Date: Wed, 24 Sep 2014 14:16:14 -0700
Message-ID: <5423349e.5YoBP1bLtNZKSRAE%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49934 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751600AbaIXVQP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 24 Sep 2014 17:16:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.cz, dave@sr71.net, gthelen@google.com, hannes@cmpxchg.org, vdavydov@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcontrol: do not kill uncharge batching in free_pages_and_swap_cache
has been added to the -mm tree.  Its filename is
     mm-memcontrol-do-not-kill-uncharge-batching-in-free_pages_and_swap_cache.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memcontrol-do-not-kill-uncharge-batching-in-free_pages_and_swap_cache.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memcontrol-do-not-kill-uncharge-batching-in-free_pages_and_swap_cache.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Michal Hocko <mhocko@suse.cz>
Subject: mm: memcontrol: do not kill uncharge batching in free_pages_and_swap_cache

free_pages_and_swap_cache limits release_pages to PAGEVEC_SIZE chunks. 
This is not a big deal for the normal release path but it completely kills
memcg uncharge batching which reduces res_counter spin_lock contention. 
Dave has noticed this with his page fault scalability test case on a large
machine when the lock was basically dominating on all CPUs:

    80.18%    80.18%  [kernel]               [k] _raw_spin_lock
                  |
                  --- _raw_spin_lock
                     |
                     |--66.59%-- res_counter_uncharge_until
                     |          res_counter_uncharge
                     |          uncharge_batch
                     |          uncharge_list
                     |          mem_cgroup_uncharge_list
                     |          release_pages
                     |          free_pages_and_swap_cache
                     |          tlb_flush_mmu_free
                     |          |
                     |          |--90.12%-- unmap_single_vma
                     |          |          unmap_vmas
                     |          |          unmap_region
                     |          |          do_munmap
                     |          |          vm_munmap
                     |          |          sys_munmap
                     |          |          system_call_fastpath
                     |          |          __GI___munmap
                     |          |
                     |           --9.88%-- tlb_flush_mmu
                     |                     tlb_finish_mmu
                     |                     unmap_region
                     |                     do_munmap
                     |                     vm_munmap
                     |                     sys_munmap
                     |                     system_call_fastpath
                     |                     __GI___munmap

In his case the load was running in the root memcg and that part has been
handled by reverting 05b843012335 ("mm: memcontrol: use root_mem_cgroup
res_counter") because this is a clear regression, but the problem remains
inside dedicated memcgs.

There is no reason to limit release_pages to PAGEVEC_SIZE batches other
than lru_lock held times.  This logic, however, can be moved inside the
function.  mem_cgroup_uncharge_list and free_hot_cold_page_list do not
hold any lock for the whole pages_to_free list so it is safe to call them
in a single run.

The release_pages() code was previously breaking the lru_lock each
PAGEVEC_SIZE pages (ie, 14 pages).  However this code has no usage of
pagevecs so switch to breaking the lock at least every SWAP_CLUSTER_MAX
(32) pages.  This means that the lock acquisition frequency is
approximately halved and the max hold times are approximately doubled.

The now unneeded batching is removed from free_pages_and_swap_cache().


Also update the grossly out-of-date release_pages documentation.

Signed-off-by: Michal Hocko <mhocko@suse.cz>
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Reported-by: Dave Hansen <dave@sr71.net>
Cc: Vladimir Davydov <vdavydov@parallels.com>
Cc: Greg Thelen <gthelen@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swap.c       |   31 ++++++++++++++++++++-----------
 mm/swap_state.c |   14 ++++----------
 2 files changed, 24 insertions(+), 21 deletions(-)

diff -puN mm/swap.c~mm-memcontrol-do-not-kill-uncharge-batching-in-free_pages_and_swap_cache mm/swap.c
--- a/mm/swap.c~mm-memcontrol-do-not-kill-uncharge-batching-in-free_pages_and_swap_cache
+++ a/mm/swap.c
@@ -887,18 +887,14 @@ void lru_add_drain_all(void)
 	mutex_unlock(&lock);
 }
 
-/*
- * Batched page_cache_release().  Decrement the reference count on all the
- * passed pages.  If it fell to zero then remove the page from the LRU and
- * free it.
+/**
+ * release_pages - batched page_cache_release()
+ * @pages: array of pages to release
+ * @nr: number of pages
+ * @cold: whether the pages are cache cold
  *
- * Avoid taking zone->lru_lock if possible, but if it is taken, retain it
- * for the remainder of the operation.
- *
- * The locking in this function is against shrink_inactive_list(): we recheck
- * the page count inside the lock to see whether shrink_inactive_list()
- * grabbed the page via the LRU.  If it did, give up: shrink_inactive_list()
- * will free it.
+ * Decrement the reference count on all the pages in @pages.  If it
+ * fell to zero, remove the page from the LRU and free it.
  */
 void release_pages(struct page **pages, int nr, bool cold)
 {
@@ -907,6 +903,7 @@ void release_pages(struct page **pages,
 	struct zone *zone = NULL;
 	struct lruvec *lruvec;
 	unsigned long uninitialized_var(flags);
+	unsigned int uninitialized_var(lock_batch);
 
 	for (i = 0; i < nr; i++) {
 		struct page *page = pages[i];
@@ -914,6 +911,7 @@ void release_pages(struct page **pages,
 		if (unlikely(PageCompound(page))) {
 			if (zone) {
 				spin_unlock_irqrestore(&zone->lru_lock, flags);
+				lock_batch = 0;
 				zone = NULL;
 			}
 			put_compound_page(page);
@@ -930,6 +928,7 @@ void release_pages(struct page **pages,
 				if (zone)
 					spin_unlock_irqrestore(&zone->lru_lock,
 									flags);
+				lock_batch = 0;
 				zone = pagezone;
 				spin_lock_irqsave(&zone->lru_lock, flags);
 			}
@@ -938,6 +937,16 @@ void release_pages(struct page **pages,
 			VM_BUG_ON_PAGE(!PageLRU(page), page);
 			__ClearPageLRU(page);
 			del_page_from_lru_list(page, lruvec, page_off_lru(page));
+
+			/*
+			 * Make sure the IRQ-safe lock-holding time
+			 * does not get excessive with a continuous
+			 * string of pages from the same zone.
+			 */
+			if (++lock_batch == SWAP_CLUSTER_MAX) {
+				spin_unlock_irqrestore(&zone->lru_lock, flags);
+				zone = NULL;
+			}
 		}
 
 		/* Clear Active bit in case of parallel mark_page_accessed */
diff -puN mm/swap_state.c~mm-memcontrol-do-not-kill-uncharge-batching-in-free_pages_and_swap_cache mm/swap_state.c
--- a/mm/swap_state.c~mm-memcontrol-do-not-kill-uncharge-batching-in-free_pages_and_swap_cache
+++ a/mm/swap_state.c
@@ -265,18 +265,12 @@ void free_page_and_swap_cache(struct pag
 void free_pages_and_swap_cache(struct page **pages, int nr)
 {
 	struct page **pagep = pages;
+	int i;
 
 	lru_add_drain();
-	while (nr) {
-		int todo = min(nr, PAGEVEC_SIZE);
-		int i;
-
-		for (i = 0; i < todo; i++)
-			free_swap_cache(pagep[i]);
-		release_pages(pagep, todo, false);
-		pagep += todo;
-		nr -= todo;
-	}
+	for (i = 0; i < nr; i++)
+		free_swap_cache(pagep[i]);
+	release_pages(pagep, nr, false);
 }
 
 /*
_

Patches currently in -mm which might be from mhocko@suse.cz are

introduce-dump_vma.patch
introduce-dump_vma-fix.patch
introduce-vm_bug_on_vma.patch
convert-a-few-vm_bug_on-callers-to-vm_bug_on_vma.patch
mm-debug-mm-introduce-vm_bug_on_mm-fixpatch.patch
mm-debug-mm-introduce-vm_bug_on_mm-fix-fixpatch.patch
mm-debug-mm-introduce-vm_bug_on_mm-fix-fixpatch-fix.patch
memcg-move-memcg_allocfree_cache_params-to-slab_commonc.patch
memcg-dont-call-memcg_update_all_caches-if-new-cache-id-fits.patch
memcg-move-memcg_update_cache_size-to-slab_commonc.patch
mm-memcontrol-do-not-kill-uncharge-batching-in-free_pages_and_swap_cache.patch
mm-memcontrol-simplify-detecting-when-the-memoryswap-limit-is-hit.patch
mm-memcontrol-fix-transparent-huge-page-allocations-under-pressure.patch
memcg-zap-memcg_can_account_kmem.patch
linux-next.patch

