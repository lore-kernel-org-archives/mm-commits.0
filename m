From: Andrew Morton <akpm@linux-foundation.org>
Subject: +
 mm-memcontrol-drop-unused-try-commit-cancel-charge-api.patch added to -mm
 tree
Date: Fri, 08 May 2020 16:20:04 -0700
Message-ID: <20200508232004.Su9nOp5sZ%akpm@linux-foundation.org>
References: <20200507183509.c5ef146c5aaeb118a25a39a8@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:41614 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727110AbgEHXUI (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 8 May 2020 19:20:08 -0400
In-Reply-To: <20200507183509.c5ef146c5aaeb118a25a39a8@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alex.shi@linux.alibaba.com, guro@fb.com, hannes@cmpxchg.org, hughd@google.com, iamjoonsoo.kim@lge.com, kirill@shutemov.name, mhocko@suse.com, mm-commits@vger.kernel.org, shakeelb@google.com


The patch titled
     Subject: mm: memcontrol: drop unused try/commit/cancel charge API
has been added to the -mm tree.  Its filename is
     mm-memcontrol-drop-unused-try-commit-cancel-charge-api.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memcontrol-drop-unused-try-commit-cancel-charge-api.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memcontrol-drop-unused-try-commit-cancel-charge-api.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: memcontrol: drop unused try/commit/cancel charge API

There are no more users. RIP in peace.

Link: http://lkml.kernel.org/r/20200508183105.225460-14-hannes@cmpxchg.org
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Alex Shi <alex.shi@linux.alibaba.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Roman Gushchin <guro@fb.com>
Cc: Shakeel Butt <shakeelb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |   36 ----------
 mm/memcontrol.c            |  126 ++++-------------------------------
 2 files changed, 15 insertions(+), 147 deletions(-)

--- a/include/linux/memcontrol.h~mm-memcontrol-drop-unused-try-commit-cancel-charge-api
+++ a/include/linux/memcontrol.h
@@ -406,14 +406,6 @@ static inline bool mem_cgroup_below_min(
 		page_counter_read(&memcg->memory);
 }
 
-int mem_cgroup_try_charge(struct page *page, struct mm_struct *mm,
-			  gfp_t gfp_mask, struct mem_cgroup **memcgp);
-int mem_cgroup_try_charge_delay(struct page *page, struct mm_struct *mm,
-			  gfp_t gfp_mask, struct mem_cgroup **memcgp);
-void mem_cgroup_commit_charge(struct page *page, struct mem_cgroup *memcg,
-			      bool lrucare);
-void mem_cgroup_cancel_charge(struct page *page, struct mem_cgroup *memcg);
-
 int mem_cgroup_charge(struct page *page, struct mm_struct *mm, gfp_t gfp_mask,
 		      bool lrucare);
 
@@ -907,34 +899,6 @@ static inline bool mem_cgroup_below_min(
 	return false;
 }
 
-static inline int mem_cgroup_try_charge(struct page *page, struct mm_struct *mm,
-					gfp_t gfp_mask,
-					struct mem_cgroup **memcgp)
-{
-	*memcgp = NULL;
-	return 0;
-}
-
-static inline int mem_cgroup_try_charge_delay(struct page *page,
-					      struct mm_struct *mm,
-					      gfp_t gfp_mask,
-					      struct mem_cgroup **memcgp)
-{
-	*memcgp = NULL;
-	return 0;
-}
-
-static inline void mem_cgroup_commit_charge(struct page *page,
-					    struct mem_cgroup *memcg,
-					    bool lrucare)
-{
-}
-
-static inline void mem_cgroup_cancel_charge(struct page *page,
-					    struct mem_cgroup *memcg)
-{
-}
-
 static inline int mem_cgroup_charge(struct page *page, struct mm_struct *mm,
 				    gfp_t gfp_mask, bool lrucare)
 {
--- a/mm/memcontrol.c~mm-memcontrol-drop-unused-try-commit-cancel-charge-api
+++ a/mm/memcontrol.c
@@ -6431,29 +6431,26 @@ void mem_cgroup_calculate_protection(str
 }
 
 /**
- * mem_cgroup_try_charge - try charging a page
+ * mem_cgroup_charge - charge a newly allocated page to a cgroup
  * @page: page to charge
  * @mm: mm context of the victim
  * @gfp_mask: reclaim mode
- * @memcgp: charged memcg return
+ * @lrucare: page might be on the LRU already
  *
  * Try to charge @page to the memcg that @mm belongs to, reclaiming
  * pages according to @gfp_mask if necessary.
  *
- * Returns 0 on success, with *@memcgp pointing to the charged memcg.
- * Otherwise, an error code is returned.
- *
- * After page->mapping has been set up, the caller must finalize the
- * charge with mem_cgroup_commit_charge().  Or abort the transaction
- * with mem_cgroup_cancel_charge() in case page instantiation fails.
+ * Returns 0 on success. Otherwise, an error code is returned.
  */
-int mem_cgroup_try_charge(struct page *page, struct mm_struct *mm,
-			  gfp_t gfp_mask, struct mem_cgroup **memcgp)
+int mem_cgroup_charge(struct page *page, struct mm_struct *mm, gfp_t gfp_mask,
+		      bool lrucare)
 {
 	unsigned int nr_pages = hpage_nr_pages(page);
 	struct mem_cgroup *memcg = NULL;
 	int ret = 0;
 
+	VM_BUG_ON_PAGE(PageLRU(page) && !lrucare, page);
+
 	if (mem_cgroup_disabled())
 		goto out;
 
@@ -6485,56 +6482,8 @@ int mem_cgroup_try_charge(struct page *p
 		memcg = get_mem_cgroup_from_mm(mm);
 
 	ret = try_charge(memcg, gfp_mask, nr_pages);
-
-	css_put(&memcg->css);
-out:
-	*memcgp = memcg;
-	return ret;
-}
-
-int mem_cgroup_try_charge_delay(struct page *page, struct mm_struct *mm,
-			  gfp_t gfp_mask, struct mem_cgroup **memcgp)
-{
-	int ret;
-
-	ret = mem_cgroup_try_charge(page, mm, gfp_mask, memcgp);
-	if (*memcgp)
-		cgroup_throttle_swaprate(page, gfp_mask);
-	return ret;
-}
-
-/**
- * mem_cgroup_commit_charge - commit a page charge
- * @page: page to charge
- * @memcg: memcg to charge the page to
- * @lrucare: page might be on LRU already
- *
- * Finalize a charge transaction started by mem_cgroup_try_charge(),
- * after page->mapping has been set up.  This must happen atomically
- * as part of the page instantiation, i.e. under the page table lock
- * for anonymous pages, under the page lock for page and swap cache.
- *
- * In addition, the page must not be on the LRU during the commit, to
- * prevent racing with task migration.  If it might be, use @lrucare.
- *
- * Use mem_cgroup_cancel_charge() to cancel the transaction instead.
- */
-void mem_cgroup_commit_charge(struct page *page, struct mem_cgroup *memcg,
-			      bool lrucare)
-{
-	unsigned int nr_pages = hpage_nr_pages(page);
-
-	VM_BUG_ON_PAGE(PageLRU(page) && !lrucare, page);
-
-	if (mem_cgroup_disabled())
-		return;
-	/*
-	 * Swap faults will attempt to charge the same page multiple
-	 * times.  But reuse_swap_page() might have removed the page
-	 * from swapcache already, so we can't check PageSwapCache().
-	 */
-	if (!memcg)
-		return;
+	if (ret)
+		goto out_put;
 
 	commit_charge(page, memcg, lrucare);
 
@@ -6552,55 +6501,11 @@ void mem_cgroup_commit_charge(struct pag
 		 */
 		mem_cgroup_uncharge_swap(entry, nr_pages);
 	}
-}
 
-/**
- * mem_cgroup_cancel_charge - cancel a page charge
- * @page: page to charge
- * @memcg: memcg to charge the page to
- *
- * Cancel a charge transaction started by mem_cgroup_try_charge().
- */
-void mem_cgroup_cancel_charge(struct page *page, struct mem_cgroup *memcg)
-{
-	unsigned int nr_pages = hpage_nr_pages(page);
-
-	if (mem_cgroup_disabled())
-		return;
-	/*
-	 * Swap faults will attempt to charge the same page multiple
-	 * times.  But reuse_swap_page() might have removed the page
-	 * from swapcache already, so we can't check PageSwapCache().
-	 */
-	if (!memcg)
-		return;
-
-	cancel_charge(memcg, nr_pages);
-}
-
-/**
- * mem_cgroup_charge - charge a newly allocated page to a cgroup
- * @page: page to charge
- * @mm: mm context of the victim
- * @gfp_mask: reclaim mode
- * @lrucare: page might be on the LRU already
- *
- * Try to charge @page to the memcg that @mm belongs to, reclaiming
- * pages according to @gfp_mask if necessary.
- *
- * Returns 0 on success. Otherwise, an error code is returned.
- */
-int mem_cgroup_charge(struct page *page, struct mm_struct *mm, gfp_t gfp_mask,
-		      bool lrucare)
-{
-	struct mem_cgroup *memcg;
-	int ret;
-
-	ret = mem_cgroup_try_charge(page, mm, gfp_mask, &memcg);
-	if (ret)
-		return ret;
-	mem_cgroup_commit_charge(page, memcg, lrucare);
-	return 0;
+out_put:
+	css_put(&memcg->css);
+out:
+	return ret;
 }
 
 struct uncharge_gather {
@@ -6705,8 +6610,7 @@ static void uncharge_list(struct list_he
  * mem_cgroup_uncharge - uncharge a page
  * @page: page to uncharge
  *
- * Uncharge a page previously charged with mem_cgroup_try_charge() and
- * mem_cgroup_commit_charge().
+ * Uncharge a page previously charged with mem_cgroup_charge().
  */
 void mem_cgroup_uncharge(struct page *page)
 {
@@ -6729,7 +6633,7 @@ void mem_cgroup_uncharge(struct page *pa
  * @page_list: list of pages to uncharge
  *
  * Uncharge a list of pages previously charged with
- * mem_cgroup_try_charge() and mem_cgroup_commit_charge().
+ * mem_cgroup_charge().
  */
 void mem_cgroup_uncharge_list(struct list_head *page_list)
 {
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

mm-fix-numa-node-file-count-error-in-replace_page_cache.patch
mm-memcontrol-fix-stat-corrupting-race-in-charge-moving.patch
mm-memcontrol-drop-compound-parameter-from-memcg-charging-api.patch
mm-memcontrol-move-out-cgroup-swaprate-throttling.patch
mm-memcontrol-convert-page-cache-to-a-new-mem_cgroup_charge-api.patch
mm-memcontrol-prepare-uncharging-for-removal-of-private-page-type-counters.patch
mm-memcontrol-prepare-move_account-for-removal-of-private-page-type-counters.patch
mm-memcontrol-prepare-cgroup-vmstat-infrastructure-for-native-anon-counters.patch
mm-memcontrol-switch-to-native-nr_file_pages-and-nr_shmem-counters.patch
mm-memcontrol-switch-to-native-nr_anon_mapped-counter.patch
mm-memcontrol-switch-to-native-nr_anon_thps-counter.patch
mm-memcontrol-convert-anon-and-file-thp-to-new-mem_cgroup_charge-api.patch
mm-memcontrol-drop-unused-try-commit-cancel-charge-api.patch
mm-memcontrol-prepare-swap-controller-setup-for-integration.patch
mm-memcontrol-make-swap-tracking-an-integral-part-of-memory-control.patch
mm-memcontrol-charge-swapin-pages-on-instantiation.patch
mm-memcontrol-delete-unused-lrucare-handling.patch
mm-memcontrol-update-page-mem_cgroup-stability-rules.patch
