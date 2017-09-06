From: akpm@linux-foundation.org
Subject: [patch 072/119] mm, THP, swap: support splitting THP for
 THP swap out
Date: Wed, 06 Sep 2017 16:22:34 -0700
Message-ID: <20170906232234.EBXVHdkAH%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50290 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754199AbdIFXWg (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 6 Sep 2017 19:22:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, akpm@linux-foundation.org, axboe@kernel.dk, dan.j.williams@intel.com, hannes@cmpxchg.org, hughd@google.com, kirill.shutemov@linux.intel.com, mhocko@kernel.org, minchan@kernel.org, mm-commits@vger.kernel.org, riel@redhat.com, ross.zwisler@intel.com, shli@kernel.org, torvalds@linux-foundation.org, vishal.l.verma@intel.com, ying.huang@intel.com

From: Huang Ying <ying.huang@intel.com>
Subject: mm, THP, swap: support splitting THP for THP swap out

After adding swapping out support for THP (Transparent Huge Page), it is
possible that a THP in swap cache (partly swapped out) need to be split. 
To split such a THP, the swap cluster backing the THP need to be split
too, that is, the CLUSTER_FLAG_HUGE flag need to be cleared for the swap
cluster.  The patch implemented this.

And because the THP swap writing needs the THP keeps as huge page during
writing.  The PageWriteback flag is checked before splitting.

Link: http://lkml.kernel.org/r/20170724051840.2309-8-ying.huang@intel.com
Signed-off-by: "Huang, Ying" <ying.huang@intel.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Shaohua Li <shli@kernel.org>
Cc: Rik van Riel <riel@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Ross Zwisler <ross.zwisler@intel.com> [for brd.c, zram_drv.c, pmem.c]
Cc: Vishal L Verma <vishal.l.verma@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/swap.h |    9 +++++++++
 mm/huge_memory.c     |   10 +++++++++-
 mm/swapfile.c        |   15 +++++++++++++++
 3 files changed, 33 insertions(+), 1 deletion(-)

diff -puN include/linux/swap.h~mm-thp-swap-support-to-split-thp-for-thp-swapped-out include/linux/swap.h
--- a/include/linux/swap.h~mm-thp-swap-support-to-split-thp-for-thp-swapped-out
+++ a/include/linux/swap.h
@@ -527,6 +527,15 @@ static inline swp_entry_t get_swap_page(
 
 #endif /* CONFIG_SWAP */
 
+#ifdef CONFIG_THP_SWAP
+extern int split_swap_cluster(swp_entry_t entry);
+#else
+static inline int split_swap_cluster(swp_entry_t entry)
+{
+	return 0;
+}
+#endif
+
 #ifdef CONFIG_MEMCG
 static inline int mem_cgroup_swappiness(struct mem_cgroup *memcg)
 {
diff -puN mm/huge_memory.c~mm-thp-swap-support-to-split-thp-for-thp-swapped-out mm/huge_memory.c
--- a/mm/huge_memory.c~mm-thp-swap-support-to-split-thp-for-thp-swapped-out
+++ a/mm/huge_memory.c
@@ -2481,6 +2481,9 @@ int split_huge_page_to_list(struct page
 	VM_BUG_ON_PAGE(!PageLocked(page), page);
 	VM_BUG_ON_PAGE(!PageCompound(page), page);
 
+	if (PageWriteback(page))
+		return -EBUSY;
+
 	if (PageAnon(head)) {
 		/*
 		 * The caller does not necessarily hold an mmap_sem that would
@@ -2558,7 +2561,12 @@ int split_huge_page_to_list(struct page
 			__dec_node_page_state(page, NR_SHMEM_THPS);
 		spin_unlock(&pgdata->split_queue_lock);
 		__split_huge_page(page, list, flags);
-		ret = 0;
+		if (PageSwapCache(head)) {
+			swp_entry_t entry = { .val = page_private(head) };
+
+			ret = split_swap_cluster(entry);
+		} else
+			ret = 0;
 	} else {
 		if (IS_ENABLED(CONFIG_DEBUG_VM) && mapcount) {
 			pr_alert("total_mapcount: %u, page_count(): %u\n",
diff -puN mm/swapfile.c~mm-thp-swap-support-to-split-thp-for-thp-swapped-out mm/swapfile.c
--- a/mm/swapfile.c~mm-thp-swap-support-to-split-thp-for-thp-swapped-out
+++ a/mm/swapfile.c
@@ -1216,6 +1216,21 @@ static void swapcache_free_cluster(swp_e
 		}
 	}
 }
+
+int split_swap_cluster(swp_entry_t entry)
+{
+	struct swap_info_struct *si;
+	struct swap_cluster_info *ci;
+	unsigned long offset = swp_offset(entry);
+
+	si = _swap_info_get(entry);
+	if (!si)
+		return -EBUSY;
+	ci = lock_cluster(si, offset);
+	cluster_clear_huge(ci);
+	unlock_cluster(ci);
+	return 0;
+}
 #else
 static inline void swapcache_free_cluster(swp_entry_t entry)
 {
_
