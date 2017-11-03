From: akpm@linux-foundation.org
Subject: [merged]
 mm-swap-fix-race-between-swap-count-continuation-operations.patch removed
 from -mm tree
Date: Fri, 03 Nov 2017 11:54:11 -0700
Message-ID: <20171103185411.UM-9TH4LZ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54456 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932258AbdKCSyN (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 3 Nov 2017 14:54:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aaron.lu@intel.com, ak@linux.intel.com, dave.hansen@intel.com, hannes@cmpxchg.org, hughd@google.com, mhocko@suse.com, minchan@kernel.org, mm-commits@vger.kernel.org, shli@kernel.org, stable@vger.kernel.org, tim.c.chen@intel.com, ying.huang@intel.com


The patch titled
     Subject: mm, swap: fix race between swap count continuation operations
has been removed from the -mm tree.  Its filename was
     mm-swap-fix-race-between-swap-count-continuation-operations.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Huang Ying <ying.huang@intel.com>
Subject: mm, swap: fix race between swap count continuation operations

One page may store a set of entries of the sis->swap_map
(swap_info_struct->swap_map) in multiple swap clusters.  If some of the
entries has sis->swap_map[offset] > SWAP_MAP_MAX, multiple pages will be
used to store the set of entries of the sis->swap_map.  And the pages are
linked with page->lru.  This is called swap count continuation.  To access
the pages which store the set of entries of the sis->swap_map
simultaneously, previously, sis->lock is used.  But to improve the
scalability of __swap_duplicate(), swap cluster lock may be used in
swap_count_continued() now.  This may race with
add_swap_count_continuation() which operates on a nearby swap cluster, in
which the sis->swap_map entries are stored in the same page.

The race can cause wrong swap count in practice, thus cause unfreeable
swap entries or software lockup, etc.

To fix the race, a new spin lock called cont_lock is added to struct
swap_info_struct to protect the swap count continuation page list.  This
is a lock at the swap device level, so the scalability isn't very well. 
But it is still much better than the original sis->lock, because it is
only acquired/released when swap count continuation is used.  Which is
considered rare in practice.  If it turns out that the scalability becomes
an issue for some workloads, we can split the lock into some more fine
grained locks.

Link: http://lkml.kernel.org/r/20171017081320.28133-1-ying.huang@intel.com
Fixes: 235b62176712 ("mm/swap: add cluster lock")
Signed-off-by: "Huang, Ying" <ying.huang@intel.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Shaohua Li <shli@kernel.org>
Cc: Tim Chen <tim.c.chen@intel.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Aaron Lu <aaron.lu@intel.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: <stable@vger.kernel.org>	[4.11+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/swap.h |    4 ++++
 mm/swapfile.c        |   23 +++++++++++++++++------
 2 files changed, 21 insertions(+), 6 deletions(-)

diff -puN include/linux/swap.h~mm-swap-fix-race-between-swap-count-continuation-operations include/linux/swap.h
--- a/include/linux/swap.h~mm-swap-fix-race-between-swap-count-continuation-operations
+++ a/include/linux/swap.h
@@ -266,6 +266,10 @@ struct swap_info_struct {
 					 * both locks need hold, hold swap_lock
 					 * first.
 					 */
+	spinlock_t cont_lock;		/*
+					 * protect swap count continuation page
+					 * list.
+					 */
 	struct work_struct discard_work; /* discard worker */
 	struct swap_cluster_list discard_clusters; /* discard clusters list */
 };
diff -puN mm/swapfile.c~mm-swap-fix-race-between-swap-count-continuation-operations mm/swapfile.c
--- a/mm/swapfile.c~mm-swap-fix-race-between-swap-count-continuation-operations
+++ a/mm/swapfile.c
@@ -2869,6 +2869,7 @@ static struct swap_info_struct *alloc_sw
 	p->flags = SWP_USED;
 	spin_unlock(&swap_lock);
 	spin_lock_init(&p->lock);
+	spin_lock_init(&p->cont_lock);
 
 	return p;
 }
@@ -3545,6 +3546,7 @@ int add_swap_count_continuation(swp_entr
 	head = vmalloc_to_page(si->swap_map + offset);
 	offset &= ~PAGE_MASK;
 
+	spin_lock(&si->cont_lock);
 	/*
 	 * Page allocation does not initialize the page's lru field,
 	 * but it does always reset its private field.
@@ -3564,7 +3566,7 @@ int add_swap_count_continuation(swp_entr
 		 * a continuation page, free our allocation and use this one.
 		 */
 		if (!(count & COUNT_CONTINUED))
-			goto out;
+			goto out_unlock_cont;
 
 		map = kmap_atomic(list_page) + offset;
 		count = *map;
@@ -3575,11 +3577,13 @@ int add_swap_count_continuation(swp_entr
 		 * free our allocation and use this one.
 		 */
 		if ((count & ~COUNT_CONTINUED) != SWAP_CONT_MAX)
-			goto out;
+			goto out_unlock_cont;
 	}
 
 	list_add_tail(&page->lru, &head->lru);
 	page = NULL;			/* now it's attached, don't free it */
+out_unlock_cont:
+	spin_unlock(&si->cont_lock);
 out:
 	unlock_cluster(ci);
 	spin_unlock(&si->lock);
@@ -3604,6 +3608,7 @@ static bool swap_count_continued(struct
 	struct page *head;
 	struct page *page;
 	unsigned char *map;
+	bool ret;
 
 	head = vmalloc_to_page(si->swap_map + offset);
 	if (page_private(head) != SWP_CONTINUED) {
@@ -3611,6 +3616,7 @@ static bool swap_count_continued(struct
 		return false;		/* need to add count continuation */
 	}
 
+	spin_lock(&si->cont_lock);
 	offset &= ~PAGE_MASK;
 	page = list_entry(head->lru.next, struct page, lru);
 	map = kmap_atomic(page) + offset;
@@ -3631,8 +3637,10 @@ static bool swap_count_continued(struct
 		if (*map == SWAP_CONT_MAX) {
 			kunmap_atomic(map);
 			page = list_entry(page->lru.next, struct page, lru);
-			if (page == head)
-				return false;	/* add count continuation */
+			if (page == head) {
+				ret = false;	/* add count continuation */
+				goto out;
+			}
 			map = kmap_atomic(page) + offset;
 init_map:		*map = 0;		/* we didn't zero the page */
 		}
@@ -3645,7 +3653,7 @@ init_map:		*map = 0;		/* we didn't zero
 			kunmap_atomic(map);
 			page = list_entry(page->lru.prev, struct page, lru);
 		}
-		return true;			/* incremented */
+		ret = true;			/* incremented */
 
 	} else {				/* decrementing */
 		/*
@@ -3671,8 +3679,11 @@ init_map:		*map = 0;		/* we didn't zero
 			kunmap_atomic(map);
 			page = list_entry(page->lru.prev, struct page, lru);
 		}
-		return count == COUNT_CONTINUED;
+		ret = count == COUNT_CONTINUED;
 	}
+out:
+	spin_unlock(&si->cont_lock);
+	return ret;
 }
 
 /*
_

Patches currently in -mm which might be from ying.huang@intel.com are


