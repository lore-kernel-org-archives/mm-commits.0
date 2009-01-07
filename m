From: akpm@linux-foundation.org
Subject: - badpage-ratelimit-print_bad_pte-and-bad_page.patch removed from -mm tree
Date: Wed, 07 Jan 2009 14:14:11 -0800
Message-ID: <200901072214.n07MEBrc014163@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36712 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759927AbZAGWOe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 Jan 2009 17:14:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hugh@veritas.com, cl@linux-foundation.org, mel@csn.ul.ie, nickpiggin@yahoo.com.au, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     badpage: ratelimit print_bad_pte and bad_page
has been removed from the -mm tree.  Its filename was
     badpage-ratelimit-print_bad_pte-and-bad_page.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: badpage: ratelimit print_bad_pte and bad_page
From: Hugh Dickins <hugh@veritas.com>

print_bad_pte() and bad_page() might each need ratelimiting - especially
for their dump_stacks, almost never of interest, yet not quite
dispensible.  Correlating corruption across neighbouring entries can be
very helpful, so allow a burst of 60 reports before keeping quiet for the
remainder of that minute (or allow a steady drip of one report per
second).

Signed-off-by: Hugh Dickins <hugh@veritas.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Christoph Lameter <cl@linux-foundation.org>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c     |   23 +++++++++++++++++++++++
 mm/page_alloc.c |   26 +++++++++++++++++++++++++-
 2 files changed, 48 insertions(+), 1 deletion(-)

diff -puN mm/memory.c~badpage-ratelimit-print_bad_pte-and-bad_page mm/memory.c
--- a/mm/memory.c~badpage-ratelimit-print_bad_pte-and-bad_page
+++ a/mm/memory.c
@@ -383,6 +383,29 @@ static void print_bad_pte(struct vm_area
 	pmd_t *pmd = pmd_offset(pud, addr);
 	struct address_space *mapping;
 	pgoff_t index;
+	static unsigned long resume;
+	static unsigned long nr_shown;
+	static unsigned long nr_unshown;
+
+	/*
+	 * Allow a burst of 60 reports, then keep quiet for that minute;
+	 * or allow a steady drip of one report per second.
+	 */
+	if (nr_shown == 60) {
+		if (time_before(jiffies, resume)) {
+			nr_unshown++;
+			return;
+		}
+		if (nr_unshown) {
+			printk(KERN_EMERG
+				"Bad page map: %lu messages suppressed\n",
+				nr_unshown);
+			nr_unshown = 0;
+		}
+		nr_shown = 0;
+	}
+	if (nr_shown++ == 0)
+		resume = jiffies + 60 * HZ;
 
 	mapping = vma->vm_file ? vma->vm_file->f_mapping : NULL;
 	index = linear_page_index(vma, addr);
diff -puN mm/page_alloc.c~badpage-ratelimit-print_bad_pte-and-bad_page mm/page_alloc.c
--- a/mm/page_alloc.c~badpage-ratelimit-print_bad_pte-and-bad_page
+++ a/mm/page_alloc.c
@@ -223,6 +223,30 @@ static inline int bad_range(struct zone 
 
 static void bad_page(struct page *page)
 {
+	static unsigned long resume;
+	static unsigned long nr_shown;
+	static unsigned long nr_unshown;
+
+	/*
+	 * Allow a burst of 60 reports, then keep quiet for that minute;
+	 * or allow a steady drip of one report per second.
+	 */
+	if (nr_shown == 60) {
+		if (time_before(jiffies, resume)) {
+			nr_unshown++;
+			goto out;
+		}
+		if (nr_unshown) {
+			printk(KERN_EMERG
+				"Bad page state: %lu messages suppressed\n",
+				nr_unshown);
+			nr_unshown = 0;
+		}
+		nr_shown = 0;
+	}
+	if (nr_shown++ == 0)
+		resume = jiffies + 60 * HZ;
+
 	printk(KERN_EMERG "Bad page state in process %s  pfn:%05lx\n",
 		current->comm, page_to_pfn(page));
 	printk(KERN_EMERG
@@ -232,7 +256,7 @@ static void bad_page(struct page *page)
 	printk(KERN_EMERG "Trying to fix it up, but a reboot is needed\n");
 
 	dump_stack();
-
+out:
 	/* Leave bad fields for debug, except PageBuddy could make trouble */
 	__ClearPageBuddy(page);
 	add_taint(TAINT_BAD_PAGE);
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

