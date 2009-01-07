From: akpm@linux-foundation.org
Subject: - badpage-kern_alert-bug-instead-of-kern_emerg.patch removed from -mm tree
Date: Wed, 07 Jan 2009 14:14:13 -0800
Message-ID: <200901072214.n07MEDam014199@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36597 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761878AbZAGWO5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 Jan 2009 17:14:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hugh@veritas.com, cl@linux-foundation.org, mel@csn.ul.ie, nickpiggin@yahoo.com.au, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     badpage: KERN_ALERT BUG instead of KERN_EMERG
has been removed from the -mm tree.  Its filename was
     badpage-kern_alert-bug-instead-of-kern_emerg.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: badpage: KERN_ALERT BUG instead of KERN_EMERG
From: Hugh Dickins <hugh@veritas.com>

bad_page() and rmap Eeek messages have said KERN_EMERG for a few years,
which I've followed in print_bad_pte().  These are serious system errors,
on a par with BUGs, but they're not quite emergencies, and we do our best
to carry on: say KERN_ALERT "BUG: " like the x86 oops does.

And remove the "Trying to fix it up, but a reboot is needed" line: it's
not untrue, but I hope the KERN_ALERT "BUG: " conveys as much.

Signed-off-by: Hugh Dickins <hugh@veritas.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Christoph Lameter <cl@linux-foundation.org>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c     |   15 ++++++++-------
 mm/page_alloc.c |    9 ++++-----
 2 files changed, 12 insertions(+), 12 deletions(-)

diff -puN mm/memory.c~badpage-kern_alert-bug-instead-of-kern_emerg mm/memory.c
--- a/mm/memory.c~badpage-kern_alert-bug-instead-of-kern_emerg
+++ a/mm/memory.c
@@ -397,8 +397,8 @@ static void print_bad_pte(struct vm_area
 			return;
 		}
 		if (nr_unshown) {
-			printk(KERN_EMERG
-				"Bad page map: %lu messages suppressed\n",
+			printk(KERN_ALERT
+				"BUG: Bad page map: %lu messages suppressed\n",
 				nr_unshown);
 			nr_unshown = 0;
 		}
@@ -410,26 +410,27 @@ static void print_bad_pte(struct vm_area
 	mapping = vma->vm_file ? vma->vm_file->f_mapping : NULL;
 	index = linear_page_index(vma, addr);
 
-	printk(KERN_EMERG "Bad page map in process %s  pte:%08llx pmd:%08llx\n",
+	printk(KERN_ALERT
+		"BUG: Bad page map in process %s  pte:%08llx pmd:%08llx\n",
 		current->comm,
 		(long long)pte_val(pte), (long long)pmd_val(*pmd));
 	if (page) {
-		printk(KERN_EMERG
+		printk(KERN_ALERT
 		"page:%p flags:%p count:%d mapcount:%d mapping:%p index:%lx\n",
 		page, (void *)page->flags, page_count(page),
 		page_mapcount(page), page->mapping, page->index);
 	}
-	printk(KERN_EMERG
+	printk(KERN_ALERT
 		"addr:%p vm_flags:%08lx anon_vma:%p mapping:%p index:%lx\n",
 		(void *)addr, vma->vm_flags, vma->anon_vma, mapping, index);
 	/*
 	 * Choose text because data symbols depend on CONFIG_KALLSYMS_ALL=y
 	 */
 	if (vma->vm_ops)
-		print_symbol(KERN_EMERG "vma->vm_ops->fault: %s\n",
+		print_symbol(KERN_ALERT "vma->vm_ops->fault: %s\n",
 				(unsigned long)vma->vm_ops->fault);
 	if (vma->vm_file && vma->vm_file->f_op)
-		print_symbol(KERN_EMERG "vma->vm_file->f_op->mmap: %s\n",
+		print_symbol(KERN_ALERT "vma->vm_file->f_op->mmap: %s\n",
 				(unsigned long)vma->vm_file->f_op->mmap);
 	dump_stack();
 	add_taint(TAINT_BAD_PAGE);
diff -puN mm/page_alloc.c~badpage-kern_alert-bug-instead-of-kern_emerg mm/page_alloc.c
--- a/mm/page_alloc.c~badpage-kern_alert-bug-instead-of-kern_emerg
+++ a/mm/page_alloc.c
@@ -237,8 +237,8 @@ static void bad_page(struct page *page)
 			goto out;
 		}
 		if (nr_unshown) {
-			printk(KERN_EMERG
-				"Bad page state: %lu messages suppressed\n",
+			printk(KERN_ALERT
+			      "BUG: Bad page state: %lu messages suppressed\n",
 				nr_unshown);
 			nr_unshown = 0;
 		}
@@ -247,13 +247,12 @@ static void bad_page(struct page *page)
 	if (nr_shown++ == 0)
 		resume = jiffies + 60 * HZ;
 
-	printk(KERN_EMERG "Bad page state in process %s  pfn:%05lx\n",
+	printk(KERN_ALERT "BUG: Bad page state in process %s  pfn:%05lx\n",
 		current->comm, page_to_pfn(page));
-	printk(KERN_EMERG
+	printk(KERN_ALERT
 		"page:%p flags:%p count:%d mapcount:%d mapping:%p index:%lx\n",
 		page, (void *)page->flags, page_count(page),
 		page_mapcount(page), page->mapping, page->index);
-	printk(KERN_EMERG "Trying to fix it up, but a reboot is needed\n");
 
 	dump_stack();
 out:
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

