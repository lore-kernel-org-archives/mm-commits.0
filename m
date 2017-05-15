From: akpm@linux-foundation.org
Subject: +
 mm-thp-swap-unify-swap-slot-free-functions-to-put_swap_page.patch added to
 -mm tree
Date: Mon, 15 May 2017 13:18:10 -0700
Message-ID: <591a0d02.eAa4sFCiTuHqFs1n%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39640 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965496AbdEOUSL (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 15 May 2017 16:18:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: minchan@kernel.org, aarcange@redhat.com, ebru.akagunduz@gmail.com, hannes@cmpxchg.org, hughd@google.com, kirill.shutemov@linux.intel.com, mhocko@kernel.org, riel@redhat.com, shli@kernel.org, tj@kernel.org, ying.huang@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, THP, swap: unify swap slot free functions to put_swap_page
has been added to the -mm tree.  Its filename is
     mm-thp-swap-unify-swap-slot-free-functions-to-put_swap_page.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-thp-swap-unify-swap-slot-free-functions-to-put_swap_page.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-thp-swap-unify-swap-slot-free-functions-to-put_swap_page.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Minchan Kim <minchan@kernel.org>
Subject: mm, THP, swap: unify swap slot free functions to put_swap_page

Now, get_swap_page takes struct page and allocates swap space according to
page size(ie, normal or THP) so it would be more cleaner to introduce
put_swap_page which is a counter function of get_swap_page.  Then, it
calls right swap slot free function depending on page's size.

[ying.huang@intel.com: minor cleanup and fix]
Link: http://lkml.kernel.org/r/20170515112522.32457-3-ying.huang@intel.com
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Minchan Kim <minchan@kernel.org>
Signed-off-by: "Huang, Ying" <ying.huang@intel.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Ebru Akagunduz <ebru.akagunduz@gmail.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Rik van Riel <riel@redhat.com>
Cc: Shaohua Li <shli@kernel.org>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/swap.h |   12 ++----------
 mm/shmem.c           |    2 +-
 mm/swap_state.c      |   13 +++----------
 mm/swapfile.c        |   16 ++++++++++++++--
 mm/vmscan.c          |    2 +-
 5 files changed, 21 insertions(+), 24 deletions(-)

diff -puN include/linux/swap.h~mm-thp-swap-unify-swap-slot-free-functions-to-put_swap_page include/linux/swap.h
--- a/include/linux/swap.h~mm-thp-swap-unify-swap-slot-free-functions-to-put_swap_page
+++ a/include/linux/swap.h
@@ -387,6 +387,7 @@ static inline long get_nr_swap_pages(voi
 
 extern void si_swapinfo(struct sysinfo *);
 extern swp_entry_t get_swap_page(struct page *page);
+extern void put_swap_page(struct page *page, swp_entry_t entry);
 extern swp_entry_t get_swap_page_of_type(int);
 extern int get_swap_pages(int n, bool cluster, swp_entry_t swp_entries[]);
 extern int add_swap_count_continuation(swp_entry_t, gfp_t);
@@ -394,7 +395,6 @@ extern void swap_shmem_alloc(swp_entry_t
 extern int swap_duplicate(swp_entry_t);
 extern int swapcache_prepare(swp_entry_t);
 extern void swap_free(swp_entry_t);
-extern void swapcache_free(swp_entry_t);
 extern void swapcache_free_entries(swp_entry_t *entries, int n);
 extern int free_swap_and_cache(swp_entry_t);
 extern int swap_type_of(dev_t, sector_t, struct block_device **);
@@ -453,7 +453,7 @@ static inline void swap_free(swp_entry_t
 {
 }
 
-static inline void swapcache_free(swp_entry_t swp)
+static inline void put_swap_page(struct page *page, swp_entry_t swp)
 {
 }
 
@@ -578,13 +578,5 @@ static inline bool mem_cgroup_swap_full(
 }
 #endif
 
-#ifdef CONFIG_THP_SWAP
-extern void swapcache_free_cluster(swp_entry_t entry);
-#else
-static inline void swapcache_free_cluster(swp_entry_t entry)
-{
-}
-#endif
-
 #endif /* __KERNEL__*/
 #endif /* _LINUX_SWAP_H */
diff -puN mm/shmem.c~mm-thp-swap-unify-swap-slot-free-functions-to-put_swap_page mm/shmem.c
--- a/mm/shmem.c~mm-thp-swap-unify-swap-slot-free-functions-to-put_swap_page
+++ a/mm/shmem.c
@@ -1326,7 +1326,7 @@ static int shmem_writepage(struct page *
 
 	mutex_unlock(&shmem_swaplist_mutex);
 free_swap:
-	swapcache_free(swap);
+	put_swap_page(page, swap);
 redirty:
 	set_page_dirty(page);
 	if (wbc->for_reclaim)
diff -puN mm/swap_state.c~mm-thp-swap-unify-swap-slot-free-functions-to-put_swap_page mm/swap_state.c
--- a/mm/swap_state.c~mm-thp-swap-unify-swap-slot-free-functions-to-put_swap_page
+++ a/mm/swap_state.c
@@ -231,10 +231,7 @@ retry:
 	return 1;
 
 fail_free:
-	if (PageTransHuge(page))
-		swapcache_free_cluster(entry);
-	else
-		swapcache_free(entry);
+	put_swap_page(page, entry);
 fail:
 	if (PageTransHuge(page) && !split_huge_page_to_list(page, list))
 		goto retry;
@@ -259,11 +256,7 @@ void delete_from_swap_cache(struct page
 	__delete_from_swap_cache(page);
 	spin_unlock_irq(&address_space->tree_lock);
 
-	if (PageTransHuge(page))
-		swapcache_free_cluster(entry);
-	else
-		swapcache_free(entry);
-
+	put_swap_page(page, entry);
 	page_ref_sub(page, hpage_nr_pages(page));
 }
 
@@ -415,7 +408,7 @@ struct page *__read_swap_cache_async(swp
 		 * add_to_swap_cache() doesn't return -EEXIST, so we can safely
 		 * clear SWAP_HAS_CACHE flag.
 		 */
-		swapcache_free(entry);
+		put_swap_page(new_page, entry);
 	} while (err != -ENOMEM);
 
 	if (new_page)
diff -puN mm/swapfile.c~mm-thp-swap-unify-swap-slot-free-functions-to-put_swap_page mm/swapfile.c
--- a/mm/swapfile.c~mm-thp-swap-unify-swap-slot-free-functions-to-put_swap_page
+++ a/mm/swapfile.c
@@ -1148,7 +1148,7 @@ void swap_free(swp_entry_t entry)
 /*
  * Called after dropping swapcache to decrease refcnt to swap entries.
  */
-void swapcache_free(swp_entry_t entry)
+static void swapcache_free(swp_entry_t entry)
 {
 	struct swap_info_struct *p;
 
@@ -1160,7 +1160,7 @@ void swapcache_free(swp_entry_t entry)
 }
 
 #ifdef CONFIG_THP_SWAP
-void swapcache_free_cluster(swp_entry_t entry)
+static void swapcache_free_cluster(swp_entry_t entry)
 {
 	unsigned long offset = swp_offset(entry);
 	unsigned long idx = offset / SWAPFILE_CLUSTER;
@@ -1184,8 +1184,20 @@ void swapcache_free_cluster(swp_entry_t
 	swap_free_cluster(si, idx);
 	spin_unlock(&si->lock);
 }
+#else
+static inline void swapcache_free_cluster(swp_entry_t entry)
+{
+}
 #endif /* CONFIG_THP_SWAP */
 
+void put_swap_page(struct page *page, swp_entry_t entry)
+{
+	if (!PageTransHuge(page))
+		swapcache_free(entry);
+	else
+		swapcache_free_cluster(entry);
+}
+
 void swapcache_free_entries(swp_entry_t *entries, int n)
 {
 	struct swap_info_struct *p, *prev;
diff -puN mm/vmscan.c~mm-thp-swap-unify-swap-slot-free-functions-to-put_swap_page mm/vmscan.c
--- a/mm/vmscan.c~mm-thp-swap-unify-swap-slot-free-functions-to-put_swap_page
+++ a/mm/vmscan.c
@@ -708,7 +708,7 @@ static int __remove_mapping(struct addre
 		mem_cgroup_swapout(page, swap);
 		__delete_from_swap_cache(page);
 		spin_unlock_irqrestore(&mapping->tree_lock, flags);
-		swapcache_free(swap);
+		put_swap_page(page, swap);
 	} else {
 		void (*freepage)(struct page *);
 		void *shadow = NULL;
_

Patches currently in -mm which might be from minchan@kernel.org are

mm-thp-swap-unify-swap-slot-free-functions-to-put_swap_page.patch
mm-thp-swap-move-anonymous-thp-split-logic-to-vmscan.patch

