From: akpm@linux-foundation.org
Subject: + mm-thp-swap-support-to-split-thp-for-thp-swapped-out.patch
 added to -mm tree
Date: Thu, 27 Jul 2017 16:37:20 -0700
Message-ID: <597a7930.A55ojTdS+KwWC570%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37712 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751693AbdG0XhV (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 27 Jul 2017 19:37:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ying.huang@intel.com, aarcange@redhat.com, axboe@kernel.dk, dan.j.williams@intel.com, hannes@cmpxchg.org, hughd@google.com, kirill.shutemov@linux.intel.com, mhocko@kernel.org, minchan@kernel.org, riel@redhat.com, ross.zwisler@intel.com, shli@kernel.org, vishal.l.verma@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, THP, swap: support splitting THP for THP swap out
has been added to the -mm tree.  Its filename is
     mm-thp-swap-support-to-split-thp-for-thp-swapped-out.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-thp-swap-support-to-split-thp-for-thp-swapped-out.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-thp-swap-support-to-split-thp-for-thp-swapped-out.patch

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
@@ -2537,6 +2537,9 @@ int split_huge_page_to_list(struct page
 	VM_BUG_ON_PAGE(!PageLocked(page), page);
 	VM_BUG_ON_PAGE(!PageCompound(page), page);
 
+	if (PageWriteback(page))
+		return -EBUSY;
+
 	if (PageAnon(head)) {
 		/*
 		 * The caller does not necessarily hold an mmap_sem that would
@@ -2614,7 +2617,12 @@ int split_huge_page_to_list(struct page
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

