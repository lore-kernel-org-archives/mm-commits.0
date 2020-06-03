From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged]
 mm-memcontrol-charge-swapin-pages-on-instantiation-fix.patch removed from
 -mm tree
Date: Wed, 03 Jun 2020 15:20:28 -0700
Message-ID: <20200603222028.E8UXb8unp%akpm@linux-foundation.org>
References: <20200602130930.8e8f10fa6f19e3766e70921f@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:56166 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726354AbgFCWUa (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 3 Jun 2020 18:20:30 -0400
In-Reply-To: <20200602130930.8e8f10fa6f19e3766e70921f@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alex.shi@linux.alibaba.com, aquini@redhat.com, hannes@cmpxchg.org, hughd@google.com, iamjoonsoo.kim@lge.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/swap: fix livelock in __read_swap_cache_async()
has been removed from the -mm tree.  Its filename was
     mm-memcontrol-charge-swapin-pages-on-instantiation-fix.patch

This patch was dropped because it was folded into mm-memcontrol-charge-swapin-pages-on-instantiation.patch

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: mm/swap: fix livelock in __read_swap_cache_async()

I've only seen this livelock on one machine (repeatably, but not to
order), and not fully analyzed it - two processes seen looping around
getting -EEXIST from swapcache_prepare(), I guess a third (at lower
priority?  but wanting the same cpu as one of the loopers?  preemption or
cond_resched() not enough to let it back in?) set SWAP_HAS_CACHE, then
went off into direct reclaim, scheduled away, and somehow could not get
back to add the page to swap cache and let them all complete.

Restore the page allocation in __read_swap_cache_async() to before the
swapcache_prepare() call: "mm: memcontrol: charge swapin pages on
instantiation" moved it outside the loop, which indeed looks much nicer,
but exposed this weakness.  We used to allocate new_page once and then
keep it across all iterations of the loop: but I think that just optimizes
for a rare case, and complicates the flow, so go with the new simpler
structure, with allocate+free each time around (which is more considerate
use of the memory too).

Fix the comment on the looping case, which has long been inaccurate: it's
not a racing get_swap_page() that's the problem here.

Fix the add_to_swap_cache() and mem_cgroup_charge() error recovery: not
swap_free(), but put_swap_page() to undo SWAP_HAS_CACHE, as was done
before; but delete_from_swap_cache() already includes it.

And one more nit: I don't think it makes any difference in practice, but
remove the "& GFP_KERNEL" mask from the mem_cgroup_charge() call:
add_to_swap_cache() needs that, to convert gfp_mask from user and page
cache allocation (e.g.  highmem) to radix node allocation (lowmem), but we
don't need or usually apply that mask when charging mem_cgroup.

Link: http://lkml.kernel.org/r/alpine.LSU.2.11.2005212246080.8458@eggly.anvils
Signed-off-by: Hugh Dickins <hughd@google.com>
Acked-by: Rafael Aquini <aquini@redhat.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Alex Shi <alex.shi@linux.alibaba.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swap_state.c |   52 +++++++++++++++++++++++++---------------------
 1 file changed, 29 insertions(+), 23 deletions(-)

--- a/mm/swap_state.c~mm-memcontrol-charge-swapin-pages-on-instantiation-fix
+++ a/mm/swap_state.c
@@ -393,56 +393,62 @@ struct page *__read_swap_cache_async(swp
 			return NULL;
 
 		/*
+		 * Get a new page to read into from swap.  Allocate it now,
+		 * before marking swap_map SWAP_HAS_CACHE, when -EEXIST will
+		 * cause any racers to loop around until we add it to cache.
+		 */
+		page = alloc_page_vma(gfp_mask, vma, addr);
+		if (!page)
+			return NULL;
+
+		/*
 		 * Swap entry may have been freed since our caller observed it.
 		 */
 		err = swapcache_prepare(entry);
 		if (!err)
 			break;
 
-		if (err == -EEXIST) {
-			/*
-			 * We might race against get_swap_page() and stumble
-			 * across a SWAP_HAS_CACHE swap_map entry whose page
-			 * has not been brought into the swapcache yet.
-			 */
-			cond_resched();
-			continue;
-		}
+		put_page(page);
+		if (err != -EEXIST)
+			return NULL;
 
-		return NULL;
+		/*
+		 * We might race against __delete_from_swap_cache(), and
+		 * stumble across a swap_map entry whose SWAP_HAS_CACHE
+		 * has not yet been cleared.  Or race against another
+		 * __read_swap_cache_async(), which has set SWAP_HAS_CACHE
+		 * in swap_map, but not yet added its page to swap cache.
+		 */
+		cond_resched();
 	}
 
 	/*
-	 * The swap entry is ours to swap in. Prepare a new page.
+	 * The swap entry is ours to swap in. Prepare the new page.
 	 */
 
-	page = alloc_page_vma(gfp_mask, vma, addr);
-	if (!page)
-		goto fail_free;
-
 	__SetPageLocked(page);
 	__SetPageSwapBacked(page);
 
 	/* May fail (-ENOMEM) if XArray node allocation failed. */
-	if (add_to_swap_cache(page, entry, gfp_mask & GFP_KERNEL))
+	if (add_to_swap_cache(page, entry, gfp_mask & GFP_KERNEL)) {
+		put_swap_page(page, entry);
 		goto fail_unlock;
+	}
 
-	if (mem_cgroup_charge(page, NULL, gfp_mask & GFP_KERNEL, false))
-		goto fail_delete;
+	if (mem_cgroup_charge(page, NULL, gfp_mask, false)) {
+		delete_from_swap_cache(page);
+		goto fail_unlock;
+	}
 
-	/* Initiate read into locked page */
+	/* Caller will initiate read into locked page */
 	SetPageWorkingset(page);
 	lru_cache_add_anon(page);
 	*new_page_allocated = true;
 	return page;
 
-fail_delete:
-	delete_from_swap_cache(page);
 fail_unlock:
 	unlock_page(page);
 	put_page(page);
-fail_free:
-	swap_free(entry);
 	return NULL;
 }
 
_

Patches currently in -mm which might be from hughd@google.com are

mm-memcontrol-charge-swapin-pages-on-instantiation.patch
mm-vmstat-add-events-for-pmd-based-thp-migration-without-split-fix.patch
