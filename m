From: akpm@linux-foundation.org
Subject: [to-be-updated]
 mm-thp-swap-support-to-clear-swap_has_cache-for-huge-page.patch removed
 from -mm tree
Date: Wed, 29 Mar 2017 13:59:31 -0700
Message-ID: <58dc2033.O2hJBZK6tD11HhGS%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56472 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932737AbdC2U7d (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 29 Mar 2017 16:59:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ying.huang@intel.com, aarcange@redhat.com, ebru.akagunduz@gmail.com, hannes@cmpxchg.org, hughd@google.com, kirill.shutemov@linux.intel.com, mhocko@kernel.org, minchan@kernel.org, riel@redhat.com, shli@kernel.org, tj@kernel.org, vdavydov@tarantool.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, THP, swap: support to clear SWAP_HAS_CACHE for huge page
has been removed from the -mm tree.  Its filename was
     mm-thp-swap-support-to-clear-swap_has_cache-for-huge-page.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Huang Ying <ying.huang@intel.com>
Subject: mm, THP, swap: support to clear SWAP_HAS_CACHE for huge page

__swapcache_free() is added to support to clear the SWAP_HAS_CACHE flag
for the huge page.  This will free the specified swap cluster now. 
Because now this function will be called only in the error path to free
the swap cluster just allocated.  So the corresponding swap_map[i] ==
SWAP_HAS_CACHE, that is, the swap count is 0.  This makes the
implementation simpler than that of the ordinary swap entry.

This will be used for delaying splitting THP (Transparent Huge Page)
during swapping out.  Where for one THP to swap out, we will allocate a
swap cluster, add the THP into the swap cache, then split the THP.  If
anything fails after allocating the swap cluster and before splitting the
THP successfully, the swapcache_free_trans_huge() will be used to free the
swap space allocated.

Link: http://lkml.kernel.org/r/20170328053209.25876-6-ying.huang@intel.com
Signed-off-by: "Huang, Ying" <ying.huang@intel.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Shaohua Li <shli@kernel.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Rik van Riel <riel@redhat.com>
Cc: Ebru Akagunduz <ebru.akagunduz@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Vladimir Davydov <vdavydov@tarantool.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/swap.h |    9 +++++++--
 mm/swapfile.c        |   34 ++++++++++++++++++++++++++++++++--
 2 files changed, 39 insertions(+), 4 deletions(-)

diff -puN include/linux/swap.h~mm-thp-swap-support-to-clear-swap_has_cache-for-huge-page include/linux/swap.h
--- a/include/linux/swap.h~mm-thp-swap-support-to-clear-swap_has_cache-for-huge-page
+++ a/include/linux/swap.h
@@ -394,7 +394,7 @@ extern void swap_shmem_alloc(swp_entry_t
 extern int swap_duplicate(swp_entry_t);
 extern int swapcache_prepare(swp_entry_t);
 extern void swap_free(swp_entry_t);
-extern void swapcache_free(swp_entry_t);
+extern void __swapcache_free(swp_entry_t entry, bool huge);
 extern void swapcache_free_entries(swp_entry_t *entries, int n);
 extern int free_swap_and_cache(swp_entry_t);
 extern int swap_type_of(dev_t, sector_t, struct block_device **);
@@ -456,7 +456,7 @@ static inline void swap_free(swp_entry_t
 {
 }
 
-static inline void swapcache_free(swp_entry_t swp)
+static inline void __swapcache_free(swp_entry_t swp, bool huge)
 {
 }
 
@@ -544,6 +544,11 @@ static inline swp_entry_t get_huge_swap_
 }
 #endif
 
+static inline void swapcache_free(swp_entry_t entry)
+{
+	__swapcache_free(entry, false);
+}
+
 #ifdef CONFIG_MEMCG
 static inline int mem_cgroup_swappiness(struct mem_cgroup *memcg)
 {
diff -puN mm/swapfile.c~mm-thp-swap-support-to-clear-swap_has_cache-for-huge-page mm/swapfile.c
--- a/mm/swapfile.c~mm-thp-swap-support-to-clear-swap_has_cache-for-huge-page
+++ a/mm/swapfile.c
@@ -855,6 +855,29 @@ static void swap_free_huge_cluster(struc
 	_swap_entry_free(si, offset, true);
 }
 
+static void swapcache_free_trans_huge(struct swap_info_struct *si,
+				      swp_entry_t entry)
+{
+	unsigned long offset = swp_offset(entry);
+	unsigned long idx = offset / SWAPFILE_CLUSTER;
+	struct swap_cluster_info *ci;
+	unsigned char *map;
+	unsigned int i;
+
+	spin_lock(&si->lock);
+	ci = lock_cluster(si, offset);
+	map = si->swap_map + offset;
+	for (i = 0; i < SWAPFILE_CLUSTER; i++) {
+		VM_BUG_ON(map[i] != SWAP_HAS_CACHE);
+		map[i] = 0;
+	}
+	unlock_cluster(ci);
+	/* Cluster size is same as huge pmd size */
+	mem_cgroup_uncharge_swap(entry, HPAGE_PMD_NR);
+	swap_free_huge_cluster(si, idx);
+	spin_unlock(&si->lock);
+}
+
 static int swap_alloc_huge_cluster(struct swap_info_struct *si,
 				   swp_entry_t *slot)
 {
@@ -887,6 +910,11 @@ static inline int swap_alloc_huge_cluste
 {
 	return 0;
 }
+
+static inline void swapcache_free_trans_huge(struct swap_info_struct *si,
+					     swp_entry_t entry)
+{
+}
 #endif
 
 static unsigned long scan_swap_map(struct swap_info_struct *si,
@@ -1157,13 +1185,15 @@ void swap_free(swp_entry_t entry)
 /*
  * Called after dropping swapcache to decrease refcnt to swap entries.
  */
-void swapcache_free(swp_entry_t entry)
+void __swapcache_free(swp_entry_t entry, bool huge)
 {
 	struct swap_info_struct *p;
 
 	p = _swap_info_get(entry);
 	if (p) {
-		if (!__swap_entry_free(p, entry, SWAP_HAS_CACHE))
+		if (unlikely(huge))
+			swapcache_free_trans_huge(p, entry);
+		else if (!__swap_entry_free(p, entry, SWAP_HAS_CACHE))
 			free_swap_slot(entry);
 	}
 }
_

Patches currently in -mm which might be from ying.huang@intel.com are

mm-swap-fix-a-race-in-free_swap_and_cache.patch
mm-swap-fix-comment-in-__read_swap_cache_async.patch
mm-swap-improve-readability-via-make-spin_lock-unlock-balanced.patch
mm-swap-avoid-lock-swap_avail_lock-when-held-cluster-lock.patch
mm-thp-swap-support-to-add-delete-thp-to-from-swap-cache.patch
mm-thp-add-can_split_huge_page.patch
mm-thp-swap-support-to-split-thp-in-swap-cache.patch
mm-thp-swap-delay-splitting-thp-during-swap-out.patch

