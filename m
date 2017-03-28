From: akpm@linux-foundation.org
Subject: + mm-thp-swap-add-get_huge_swap_page.patch added to -mm tree
Date: Tue, 28 Mar 2017 15:14:15 -0700
Message-ID: <58dae037.Vaqxbn8CHXr+S1sI%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44162 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752679AbdC1WPR (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 28 Mar 2017 18:15:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ying.huang@intel.com, aarcange@redhat.com, ebru.akagunduz@gmail.com, hannes@cmpxchg.org, hughd@google.com, kirill.shutemov@linux.intel.com, mhocko@kernel.org, minchan@kernel.org, riel@redhat.com, shli@kernel.org, tj@kernel.org, vdavydov@virtuozzo.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, THP, swap: add get_huge_swap_page()
has been added to the -mm tree.  Its filename is
     mm-thp-swap-add-get_huge_swap_page.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-thp-swap-add-get_huge_swap_page.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-thp-swap-add-get_huge_swap_page.patch

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
Subject: mm, THP, swap: add get_huge_swap_page()

A variation of get_swap_page(), get_huge_swap_page(), is added to allocate
a swap cluster (HPAGE_PMD_NR swap slots) based on the swap cluster
allocation function.  A fair simple algorithm is used, that is, only the
first swap device in priority list will be tried to allocate the swap
cluster.  The function will fail if the trying is not successful, and the
caller will fallback to allocate a single swap slot instead.  This works
good enough for normal cases.

This will be used for the THP (Transparent Huge Page) swap support.  Where
get_huge_swap_page() will be used to allocate one swap cluster for each
THP swapped out.

Because of the algorithm adopted, if the difference of the number of the
free swap clusters among multiple swap devices is significant, it is
possible that some THPs are split earlier than necessary.  For example,
this could be caused by big size difference among multiple swap devices.

Link: http://lkml.kernel.org/r/20170328053209.25876-5-ying.huang@intel.com
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
Cc: Vladimir Davydov <vdavydov@virtuozzo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/swap.h |   19 ++++++++++++++++++-
 mm/swap_slots.c      |    5 +++--
 mm/swapfile.c        |   18 +++++++++++-------
 3 files changed, 32 insertions(+), 10 deletions(-)

diff -puN include/linux/swap.h~mm-thp-swap-add-get_huge_swap_page include/linux/swap.h
--- a/include/linux/swap.h~mm-thp-swap-add-get_huge_swap_page
+++ a/include/linux/swap.h
@@ -388,7 +388,7 @@ static inline long get_nr_swap_pages(voi
 extern void si_swapinfo(struct sysinfo *);
 extern swp_entry_t get_swap_page(void);
 extern swp_entry_t get_swap_page_of_type(int);
-extern int get_swap_pages(int n, swp_entry_t swp_entries[]);
+extern int get_swap_pages(int n, swp_entry_t swp_entries[], bool huge);
 extern int add_swap_count_continuation(swp_entry_t, gfp_t);
 extern void swap_shmem_alloc(swp_entry_t);
 extern int swap_duplicate(swp_entry_t);
@@ -527,6 +527,23 @@ static inline swp_entry_t get_swap_page(
 
 #endif /* CONFIG_SWAP */
 
+#ifdef CONFIG_THP_SWAP_CLUSTER
+static inline swp_entry_t get_huge_swap_page(void)
+{
+	swp_entry_t entry;
+
+	if (get_swap_pages(1, &entry, true))
+		return entry;
+	else
+		return (swp_entry_t) {0};
+}
+#else
+static inline swp_entry_t get_huge_swap_page(void)
+{
+	return (swp_entry_t) {0};
+}
+#endif
+
 #ifdef CONFIG_MEMCG
 static inline int mem_cgroup_swappiness(struct mem_cgroup *memcg)
 {
diff -puN mm/swap_slots.c~mm-thp-swap-add-get_huge_swap_page mm/swap_slots.c
--- a/mm/swap_slots.c~mm-thp-swap-add-get_huge_swap_page
+++ a/mm/swap_slots.c
@@ -258,7 +258,8 @@ static int refill_swap_slots_cache(struc
 
 	cache->cur = 0;
 	if (swap_slot_cache_active)
-		cache->nr = get_swap_pages(SWAP_SLOTS_CACHE_SIZE, cache->slots);
+		cache->nr = get_swap_pages(SWAP_SLOTS_CACHE_SIZE, cache->slots,
+					   false);
 
 	return cache->nr;
 }
@@ -332,7 +333,7 @@ repeat:
 			return entry;
 	}
 
-	get_swap_pages(1, &entry);
+	get_swap_pages(1, &entry, false);
 
 	return entry;
 }
diff -puN mm/swapfile.c~mm-thp-swap-add-get_huge_swap_page mm/swapfile.c
--- a/mm/swapfile.c~mm-thp-swap-add-get_huge_swap_page
+++ a/mm/swapfile.c
@@ -904,13 +904,14 @@ static unsigned long scan_swap_map(struc
 
 }
 
-int get_swap_pages(int n_goal, swp_entry_t swp_entries[])
+int get_swap_pages(int n_goal, swp_entry_t swp_entries[], bool huge)
 {
 	struct swap_info_struct *si, *next;
 	long avail_pgs;
 	int n_ret = 0;
+	int nr_pages = huge_cluster_nr_entries(huge);
 
-	avail_pgs = atomic_long_read(&nr_swap_pages);
+	avail_pgs = atomic_long_read(&nr_swap_pages) / nr_pages;
 	if (avail_pgs <= 0)
 		goto noswap;
 
@@ -920,7 +921,7 @@ int get_swap_pages(int n_goal, swp_entry
 	if (n_goal > avail_pgs)
 		n_goal = avail_pgs;
 
-	atomic_long_sub(n_goal, &nr_swap_pages);
+	atomic_long_sub(n_goal * nr_pages, &nr_swap_pages);
 
 	spin_lock(&swap_avail_lock);
 
@@ -946,10 +947,13 @@ start_over:
 			spin_unlock(&si->lock);
 			goto nextsi;
 		}
-		n_ret = scan_swap_map_slots(si, SWAP_HAS_CACHE,
-					    n_goal, swp_entries);
+		if (likely(!huge))
+			n_ret = scan_swap_map_slots(si, SWAP_HAS_CACHE,
+						    n_goal, swp_entries);
+		else
+			n_ret = swap_alloc_huge_cluster(si, swp_entries);
 		spin_unlock(&si->lock);
-		if (n_ret)
+		if (n_ret || unlikely(huge))
 			goto check_out;
 		pr_debug("scan_swap_map of si %d failed to find offset\n",
 			si->type);
@@ -975,7 +979,7 @@ nextsi:
 
 check_out:
 	if (n_ret < n_goal)
-		atomic_long_add((long) (n_goal-n_ret), &nr_swap_pages);
+		atomic_long_add((long)(n_goal-n_ret) * nr_pages, &nr_swap_pages);
 noswap:
 	return n_ret;
 }
_

Patches currently in -mm which might be from ying.huang@intel.com are

mm-swap-fix-a-race-in-free_swap_and_cache.patch
mm-swap-fix-comment-in-__read_swap_cache_async.patch
mm-swap-improve-readability-via-make-spin_lock-unlock-balanced.patch
mm-swap-avoid-lock-swap_avail_lock-when-held-cluster-lock.patch
mm-swap-make-swap-cluster-size-same-of-thp-size-on-x86_64.patch
mm-memcg-support-to-charge-uncharge-multiple-swap-entries.patch
mm-thp-swap-add-swap-cluster-allocate-free-functions.patch
mm-thp-swap-add-get_huge_swap_page.patch
mm-thp-swap-support-to-clear-swap_has_cache-for-huge-page.patch
mm-thp-swap-support-to-add-delete-thp-to-from-swap-cache.patch
mm-thp-add-can_split_huge_page.patch
mm-thp-swap-support-to-split-thp-in-swap-cache.patch
mm-thp-swap-delay-splitting-thp-during-swap-out.patch

