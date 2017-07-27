From: akpm@linux-foundation.org
Subject: +
 mm-thp-swap-support-to-reclaim-swap-space-for-thp-swapped-out.patch added
 to -mm tree
Date: Thu, 27 Jul 2017 16:37:06 -0700
Message-ID: <597a7922.HhO12NsffoBCa0VP%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37634 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751113AbdG0XhH (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 27 Jul 2017 19:37:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ying.huang@intel.com, aarcange@redhat.com, axboe@kernel.dk, dan.j.williams@intel.com, hannes@cmpxchg.org, hughd@google.com, kirill.shutemov@linux.intel.com, mhocko@kernel.org, minchan@kernel.org, riel@redhat.com, ross.zwisler@intel.com, shli@kernel.org, vishal.l.verma@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, THP, swap: support to reclaim swap space for THP swapped out
has been added to the -mm tree.  Its filename is
     mm-thp-swap-support-to-reclaim-swap-space-for-thp-swapped-out.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-thp-swap-support-to-reclaim-swap-space-for-thp-swapped-out.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-thp-swap-support-to-reclaim-swap-space-for-thp-swapped-out.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Huang Ying <ying.huang@intel.com>
Subject: mm, THP, swap: support to reclaim swap space for THP swapped out

The normal swap slot reclaiming can be done when the swap count reaches
SWAP_HAS_CACHE.  But for the swap slot which is backing a THP, all swap
slots backing one THP must be reclaimed together, because the swap slot
may be used again when the THP is swapped out again later.  So the swap
slots backing one THP can be reclaimed together when the swap count for
all swap slots for the THP reached SWAP_HAS_CACHE.  In the patch, the
functions to check whether the swap count for all swap slots backing one
THP reached SWAP_HAS_CACHE are implemented and used when checking whether
a swap slot can be reclaimed.

To make it easier to determine whether a swap slot is backing a THP, a new
swap cluster flag named CLUSTER_FLAG_HUGE is added to mark a swap cluster
which is backing a THP (Transparent Huge Page).  Because THP swap in as a
whole isn't supported now.  After deleting the THP from the swap cache
(for example, swapping out finished), the CLUSTER_FLAG_HUGE flag will be
cleared.  So that, the normal pages inside THP can be swapped in
individually.

Link: http://lkml.kernel.org/r/20170724051840.2309-3-ying.huang@intel.com
Signed-off-by: "Huang, Ying" <ying.huang@intel.com>
Acked-by: Rik van Riel <riel@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Shaohua Li <shli@kernel.org>
Cc: "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Ross Zwisler <ross.zwisler@intel.com> [for brd.c, zram_drv.c, pmem.c]
Cc: Vishal L Verma <vishal.l.verma@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/swap.h |    1 
 mm/swapfile.c        |   78 +++++++++++++++++++++++++++++++++++++----
 2 files changed, 72 insertions(+), 7 deletions(-)

diff -puN include/linux/swap.h~mm-thp-swap-support-to-reclaim-swap-space-for-thp-swapped-out include/linux/swap.h
--- a/include/linux/swap.h~mm-thp-swap-support-to-reclaim-swap-space-for-thp-swapped-out
+++ a/include/linux/swap.h
@@ -188,6 +188,7 @@ struct swap_cluster_info {
 };
 #define CLUSTER_FLAG_FREE 1 /* This cluster is free */
 #define CLUSTER_FLAG_NEXT_NULL 2 /* This cluster has no next cluster */
+#define CLUSTER_FLAG_HUGE 4 /* This cluster is backing a transparent huge page */
 
 /*
  * We assign a cluster to each CPU, so each CPU can allocate swap entry from
diff -puN mm/swapfile.c~mm-thp-swap-support-to-reclaim-swap-space-for-thp-swapped-out mm/swapfile.c
--- a/mm/swapfile.c~mm-thp-swap-support-to-reclaim-swap-space-for-thp-swapped-out
+++ a/mm/swapfile.c
@@ -265,6 +265,16 @@ static inline void cluster_set_null(stru
 	info->data = 0;
 }
 
+static inline bool cluster_is_huge(struct swap_cluster_info *info)
+{
+	return info->flags & CLUSTER_FLAG_HUGE;
+}
+
+static inline void cluster_clear_huge(struct swap_cluster_info *info)
+{
+	info->flags &= ~CLUSTER_FLAG_HUGE;
+}
+
 static inline struct swap_cluster_info *lock_cluster(struct swap_info_struct *si,
 						     unsigned long offset)
 {
@@ -846,7 +856,7 @@ static int swap_alloc_cluster(struct swa
 	offset = idx * SWAPFILE_CLUSTER;
 	ci = lock_cluster(si, offset);
 	alloc_cluster(si, idx);
-	cluster_set_count_flag(ci, SWAPFILE_CLUSTER, 0);
+	cluster_set_count_flag(ci, SWAPFILE_CLUSTER, CLUSTER_FLAG_HUGE);
 
 	map = si->swap_map + offset;
 	for (i = 0; i < SWAPFILE_CLUSTER; i++)
@@ -1176,6 +1186,7 @@ static void swapcache_free_cluster(swp_e
 		return;
 
 	ci = lock_cluster(si, offset);
+	VM_BUG_ON(!cluster_is_huge(ci));
 	map = si->swap_map + offset;
 	for (i = 0; i < SWAPFILE_CLUSTER; i++) {
 		val = map[i];
@@ -1187,6 +1198,7 @@ static void swapcache_free_cluster(swp_e
 		for (i = 0; i < SWAPFILE_CLUSTER; i++)
 			map[i] &= ~SWAP_HAS_CACHE;
 	}
+	cluster_clear_huge(ci);
 	unlock_cluster(ci);
 	if (free_entries == SWAPFILE_CLUSTER) {
 		spin_lock(&si->lock);
@@ -1350,6 +1362,54 @@ out:
 	return count;
 }
 
+#ifdef CONFIG_THP_SWAP
+static bool swap_page_trans_huge_swapped(struct swap_info_struct *si,
+					 swp_entry_t entry)
+{
+	struct swap_cluster_info *ci;
+	unsigned char *map = si->swap_map;
+	unsigned long roffset = swp_offset(entry);
+	unsigned long offset = round_down(roffset, SWAPFILE_CLUSTER);
+	int i;
+	bool ret = false;
+
+	ci = lock_cluster_or_swap_info(si, offset);
+	if (!cluster_is_huge(ci)) {
+		if (map[roffset] != SWAP_HAS_CACHE)
+			ret = true;
+		goto unlock_out;
+	}
+	for (i = 0; i < SWAPFILE_CLUSTER; i++) {
+		if (map[offset + i] != SWAP_HAS_CACHE) {
+			ret = true;
+			break;
+		}
+	}
+unlock_out:
+	unlock_cluster_or_swap_info(si, ci);
+	return ret;
+}
+
+static bool page_swapped(struct page *page)
+{
+	swp_entry_t entry;
+	struct swap_info_struct *si;
+
+	if (likely(!PageTransCompound(page)))
+		return page_swapcount(page) != 0;
+
+	page = compound_head(page);
+	entry.val = page_private(page);
+	si = _swap_info_get(entry);
+	if (si)
+		return swap_page_trans_huge_swapped(si, entry);
+	return false;
+}
+#else
+#define swap_page_trans_huge_swapped(si, entry)	swap_swapcount(si, entry)
+#define page_swapped(page)			(page_swapcount(page) != 0)
+#endif
+
 /*
  * We can write to an anon page without COW if there are no other references
  * to it.  And as a side-effect, free up its swap: because the old content
@@ -1404,7 +1464,7 @@ int try_to_free_swap(struct page *page)
 		return 0;
 	if (PageWriteback(page))
 		return 0;
-	if (page_swapcount(page))
+	if (page_swapped(page))
 		return 0;
 
 	/*
@@ -1425,6 +1485,7 @@ int try_to_free_swap(struct page *page)
 	if (pm_suspended_storage())
 		return 0;
 
+	page = compound_head(page);
 	delete_from_swap_cache(page);
 	SetPageDirty(page);
 	return 1;
@@ -1446,7 +1507,8 @@ int free_swap_and_cache(swp_entry_t entr
 	p = _swap_info_get(entry);
 	if (p) {
 		count = __swap_entry_free(p, entry, 1);
-		if (count == SWAP_HAS_CACHE) {
+		if (count == SWAP_HAS_CACHE &&
+		    !swap_page_trans_huge_swapped(p, entry)) {
 			page = find_get_page(swap_address_space(entry),
 					     swp_offset(entry));
 			if (page && !trylock_page(page)) {
@@ -1463,7 +1525,8 @@ int free_swap_and_cache(swp_entry_t entr
 		 */
 		if (PageSwapCache(page) && !PageWriteback(page) &&
 		    (!page_mapped(page) || mem_cgroup_swap_full(page)) &&
-		    !swap_swapcount(p, entry)) {
+		    !swap_page_trans_huge_swapped(p, entry)) {
+			page = compound_head(page);
 			delete_from_swap_cache(page);
 			SetPageDirty(page);
 		}
@@ -2017,7 +2080,7 @@ int try_to_unuse(unsigned int type, bool
 				.sync_mode = WB_SYNC_NONE,
 			};
 
-			swap_writepage(page, &wbc);
+			swap_writepage(compound_head(page), &wbc);
 			lock_page(page);
 			wait_on_page_writeback(page);
 		}
@@ -2030,8 +2093,9 @@ int try_to_unuse(unsigned int type, bool
 		 * delete, since it may not have been written out to swap yet.
 		 */
 		if (PageSwapCache(page) &&
-		    likely(page_private(page) == entry.val))
-			delete_from_swap_cache(page);
+		    likely(page_private(page) == entry.val) &&
+		    !page_swapped(page))
+			delete_from_swap_cache(compound_head(page));
 
 		/*
 		 * So we could skip searching mms once swap count went
_

Patches currently in -mm which might be from ying.huang@intel.com are

mm-thp-swap-support-to-clear-swap-cache-flag-for-thp-swapped-out.patch
mm-thp-swap-support-to-reclaim-swap-space-for-thp-swapped-out.patch
mm-thp-swap-make-reuse_swap_page-works-for-thp-swapped-out.patch
mm-thp-swap-dont-allocate-huge-cluster-for-file-backed-swap-device.patch
block-thp-make-block_device_operationsrw_page-support-thp.patch
test-code-to-write-thp-to-swap-device-as-a-whole.patch
mm-thp-swap-support-to-split-thp-for-thp-swapped-out.patch
memcg-thp-swap-support-move-mem-cgroup-charge-for-thp-swapped-out.patch
memcg-thp-swap-avoid-to-duplicated-charge-thp-in-swap-cache.patch
memcg-thp-swap-make-mem_cgroup_swapout-support-thp.patch
mm-thp-swap-delay-splitting-thp-after-swapped-out.patch
mm-thp-swap-add-thp-swapping-out-fallback-counting.patch

