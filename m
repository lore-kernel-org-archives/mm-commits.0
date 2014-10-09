From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-memcontrol-do-not-kill-uncharge-batching-in-free_pages_and_swap_cache-fix.patch removed from -mm tree
Date: Thu, 09 Oct 2014 13:44:28 -0700
Message-ID: <5436f3ac.jWrNjyyRkCl64noN%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35666 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750815AbaJIUo2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 Oct 2014 16:44:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.cz, dave@sr71.net, gthelen@google.com, hannes@cmpxchg.org, vdavydov@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-memcontrol-do-not-kill-uncharge-batching-in-free_pages_and_swap_cache-fix
has been removed from the -mm tree.  Its filename was
     mm-memcontrol-do-not-kill-uncharge-batching-in-free_pages_and_swap_cache-fix.patch

This patch was dropped because it was folded into mm-memcontrol-do-not-kill-uncharge-batching-in-free_pages_and_swap_cache.patch

------------------------------------------------------
From: Michal Hocko <mhocko@suse.cz>
Subject: mm-memcontrol-do-not-kill-uncharge-batching-in-free_pages_and_swap_cache-fix

count all pages because many pages might be off LRU already.

Signed-off-by: Michal Hocko <mhocko@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Dave Hansen <dave@sr71.net>
Cc: Vladimir Davydov <vdavydov@parallels.com>
Cc: Greg Thelen <gthelen@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swap.c |   21 ++++++++++-----------
 1 file changed, 10 insertions(+), 11 deletions(-)

diff -puN mm/swap.c~mm-memcontrol-do-not-kill-uncharge-batching-in-free_pages_and_swap_cache-fix mm/swap.c
--- a/mm/swap.c~mm-memcontrol-do-not-kill-uncharge-batching-in-free_pages_and_swap_cache-fix
+++ a/mm/swap.c
@@ -911,13 +911,22 @@ void release_pages(struct page **pages,
 		if (unlikely(PageCompound(page))) {
 			if (zone) {
 				spin_unlock_irqrestore(&zone->lru_lock, flags);
-				lock_batch = 0;
 				zone = NULL;
 			}
 			put_compound_page(page);
 			continue;
 		}
 
+		/*
+		 * Make sure the IRQ-safe lock-holding time does not get
+		 * excessive with a continuous string of pages from the
+		 * same zone. The lock is held only if zone != NULL.
+		 */
+		if (zone && ++lock_batch == SWAP_CLUSTER_MAX) {
+			spin_unlock_irqrestore(&zone->lru_lock, flags);
+			zone = NULL;
+		}
+
 		if (!put_page_testzero(page))
 			continue;
 
@@ -937,16 +946,6 @@ void release_pages(struct page **pages,
 			VM_BUG_ON_PAGE(!PageLRU(page), page);
 			__ClearPageLRU(page);
 			del_page_from_lru_list(page, lruvec, page_off_lru(page));
-
-			/*
-			 * Make sure the IRQ-safe lock-holding time
-			 * does not get excessive with a continuous
-			 * string of pages from the same zone.
-			 */
-			if (++lock_batch == SWAP_CLUSTER_MAX) {
-				spin_unlock_irqrestore(&zone->lru_lock, flags);
-				zone = NULL;
-			}
 		}
 
 		/* Clear Active bit in case of parallel mark_page_accessed */
_

Patches currently in -mm which might be from mhocko@suse.cz are

introduce-dump_vma.patch
introduce-vm_bug_on_vma.patch
convert-a-few-vm_bug_on-callers-to-vm_bug_on_vma.patch
mm-introduce-vm_bug_on_mm.patch
memcg-move-memcg_allocfree_cache_params-to-slab_commonc.patch
memcg-dont-call-memcg_update_all_caches-if-new-cache-id-fits.patch
memcg-move-memcg_update_cache_size-to-slab_commonc.patch
mm-memcontrol-do-not-kill-uncharge-batching-in-free_pages_and_swap_cache.patch
mm-memcontrol-simplify-detecting-when-the-memoryswap-limit-is-hit.patch
mm-memcontrol-fix-transparent-huge-page-allocations-under-pressure.patch
memcg-zap-memcg_can_account_kmem.patch

