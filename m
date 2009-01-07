From: akpm@linux-foundation.org
Subject: - mm-replace-some-bug_ons-by-vm_bug_ons.patch removed from -mm tree
Date: Wed, 07 Jan 2009 14:12:17 -0800
Message-ID: <200901072212.n07MCH8q012481@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46961 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755505AbZAGWMZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 Jan 2009 17:12:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hugh@veritas.com, cl@linux-foundation.org, mel@csn.ul.ie, nickpiggin@yahoo.com.au, mm-commits@vger.kernel.org


The patch titled
     mm: replace some BUG_ONs by VM_BUG_ONs
has been removed from the -mm tree.  Its filename was
     mm-replace-some-bug_ons-by-vm_bug_ons.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: replace some BUG_ONs by VM_BUG_ONs
From: Hugh Dickins <hugh@veritas.com>

The swap code is over-provisioned with BUG_ONs on assorted page flags,
mostly dating back to 2.3.  They're good documentation, and guard against
developer error, but a waste of space on most systems: change them to
VM_BUG_ONs, conditional on CONFIG_DEBUG_VM.  Just delete the PagePrivate
ones: they're later, from 2.5.69, but even less interesting now.

Signed-off-by: Hugh Dickins <hugh@veritas.com>
Reviewed-by: Christoph Lameter <cl@linux-foundation.org>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_io.c    |    4 ++--
 mm/swap_state.c |   19 +++++++++----------
 mm/swapfile.c   |    8 +++-----
 3 files changed, 14 insertions(+), 17 deletions(-)

diff -puN mm/page_io.c~mm-replace-some-bug_ons-by-vm_bug_ons mm/page_io.c
--- a/mm/page_io.c~mm-replace-some-bug_ons-by-vm_bug_ons
+++ a/mm/page_io.c
@@ -125,8 +125,8 @@ int swap_readpage(struct file *file, str
 	struct bio *bio;
 	int ret = 0;
 
-	BUG_ON(!PageLocked(page));
-	BUG_ON(PageUptodate(page));
+	VM_BUG_ON(!PageLocked(page));
+	VM_BUG_ON(PageUptodate(page));
 	bio = get_swap_bio(GFP_KERNEL, page_private(page), page,
 				end_swap_bio_read);
 	if (bio == NULL) {
diff -puN mm/swap_state.c~mm-replace-some-bug_ons-by-vm_bug_ons mm/swap_state.c
--- a/mm/swap_state.c~mm-replace-some-bug_ons-by-vm_bug_ons
+++ a/mm/swap_state.c
@@ -72,10 +72,10 @@ int add_to_swap_cache(struct page *page,
 {
 	int error;
 
-	BUG_ON(!PageLocked(page));
-	BUG_ON(PageSwapCache(page));
-	BUG_ON(PagePrivate(page));
-	BUG_ON(!PageSwapBacked(page));
+	VM_BUG_ON(!PageLocked(page));
+	VM_BUG_ON(PageSwapCache(page));
+	VM_BUG_ON(!PageSwapBacked(page));
+
 	error = radix_tree_preload(gfp_mask);
 	if (!error) {
 		page_cache_get(page);
@@ -108,10 +108,9 @@ int add_to_swap_cache(struct page *page,
  */
 void __delete_from_swap_cache(struct page *page)
 {
-	BUG_ON(!PageLocked(page));
-	BUG_ON(!PageSwapCache(page));
-	BUG_ON(PageWriteback(page));
-	BUG_ON(PagePrivate(page));
+	VM_BUG_ON(!PageLocked(page));
+	VM_BUG_ON(!PageSwapCache(page));
+	VM_BUG_ON(PageWriteback(page));
 
 	radix_tree_delete(&swapper_space.page_tree, page_private(page));
 	set_page_private(page, 0);
@@ -134,8 +133,8 @@ int add_to_swap(struct page * page, gfp_
 	swp_entry_t entry;
 	int err;
 
-	BUG_ON(!PageLocked(page));
-	BUG_ON(!PageUptodate(page));
+	VM_BUG_ON(!PageLocked(page));
+	VM_BUG_ON(!PageUptodate(page));
 
 	for (;;) {
 		entry = get_swap_page();
diff -puN mm/swapfile.c~mm-replace-some-bug_ons-by-vm_bug_ons mm/swapfile.c
--- a/mm/swapfile.c~mm-replace-some-bug_ons-by-vm_bug_ons
+++ a/mm/swapfile.c
@@ -333,7 +333,7 @@ int can_share_swap_page(struct page *pag
 {
 	int count;
 
-	BUG_ON(!PageLocked(page));
+	VM_BUG_ON(!PageLocked(page));
 	count = page_mapcount(page);
 	if (count <= 1 && PageSwapCache(page))
 		count += page_swapcount(page);
@@ -350,8 +350,7 @@ static int remove_exclusive_swap_page_co
 	struct swap_info_struct * p;
 	swp_entry_t entry;
 
-	BUG_ON(PagePrivate(page));
-	BUG_ON(!PageLocked(page));
+	VM_BUG_ON(!PageLocked(page));
 
 	if (!PageSwapCache(page))
 		return 0;
@@ -432,7 +431,6 @@ void free_swap_and_cache(swp_entry_t ent
 	if (page) {
 		int one_user;
 
-		BUG_ON(PagePrivate(page));
 		one_user = (page_count(page) == 2);
 		/* Only cache user (+us), or swap space full? Free it! */
 		/* Also recheck PageSwapCache after page is locked (above) */
@@ -1209,7 +1207,7 @@ int page_queue_congested(struct page *pa
 {
 	struct backing_dev_info *bdi;
 
-	BUG_ON(!PageLocked(page));	/* It pins the swap_info_struct */
+	VM_BUG_ON(!PageLocked(page));	/* It pins the swap_info_struct */
 
 	if (PageSwapCache(page)) {
 		swp_entry_t entry = { .val = page_private(page) };
_

Patches currently in -mm which might be from hugh@veritas.com are

origin.patch
linux-next.patch
mark-complex-bitopsh-inlines-as-__always_inline.patch
clocksource-pass-clocksource-to-read-callback.patch
clocksource-pass-clocksource-to-read-callback-sparc-cleanup.patch
bio-zero-inlined-bio_vec.patch
page_fault-retry-with-nopage_retry.patch
page_fault-retry-with-nopage_retry-fix.patch
page_fault-retry-with-nopage_retry-fix-fix.patch
mm-shmemc-fix-division-by-zero.patch
getrusage-fill-ru_maxrss-value.patch
memcg-handle-swap-caches.patch
memcg-handle-swap-caches-build-fix.patch
memcg-swap-cgroup-for-remembering-usage.patch
memcg-memswap-controller-core.patch
memcg-memswap-controller-core-make-resize-limit-hold-mutex.patch
memcg-memswap-controller-core-swapcache-fixes.patch
memcg-revert-gfp-mask-fix.patch
memcg-check-group-leader-fix.patch
memcg-memoryswap-controller-fix-limit-check.patch
memcg-swapout-refcnt-fix.patch
memcg-hierarchy-avoid-unnecessary-reclaim.patch
inactive_anon_is_low-move-to-vmscan.patch
mm-introduce-zone_reclaim-struct.patch
mm-add-zone-nr_pages-helper-function.patch
mm-make-get_scan_ratio-safe-for-memcg.patch
memcg-add-null-check-to-page_cgroup_zoneinfo.patch
memcg-add-inactive_anon_is_low.patch
memcg-add-mem_cgroup_zone_nr_pages.patch
memcg-add-zone_reclaim_stat.patch
memcg-add-zone_reclaim_stat-reclaim-stat-trivial-fixes-fix.patch
memcg-remove-mem_cgroup_cal_reclaim.patch
memcg-show-reclaim-stat.patch
memcg-rename-scan-global-lru.patch
memcg-protect-prev_priority.patch
memcg-swappiness.patch
memcg-explain-details-and-test-document.patch
memcg-fix-swap-accounting-leak-v3.patch
memcg-fix-swap-accounting-leak-doc-fix.patch
memcg-fix-shmems-swap-accounting.patch
prio_tree-debugging-patch.patch

