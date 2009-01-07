From: akpm@linux-foundation.org
Subject: - badpage-replace-page_remove_rmap-eeek-and-bug.patch removed from -mm tree
Date: Wed, 07 Jan 2009 14:14:00 -0800
Message-ID: <200901072214.n07ME0Gv013979@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58871 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761116AbZAGWOw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 Jan 2009 17:14:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hugh@veritas.com, cl@linux-foundation.org, mel@csn.ul.ie, nickpiggin@yahoo.com.au, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     badpage: replace page_remove_rmap Eeek and BUG
has been removed from the -mm tree.  Its filename was
     badpage-replace-page_remove_rmap-eeek-and-bug.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: badpage: replace page_remove_rmap Eeek and BUG
From: Hugh Dickins <hugh@veritas.com>

Now that bad pages are kept out of circulation, there is no need for the
infamous page_remove_rmap() BUG() - once that page is freed, its negative
mapcount will issue a "Bad page state" message and the page won't be
freed.  Removing the BUG() allows more info, on subsequent pages, to be
gathered.

We do have more info about the page at this point than bad_page() can know
- notably, what the pmd is, which might pinpoint something like low 64kB
corruption - but page_remove_rmap() isn't given the address to find that.

In practice, there is only one call to page_remove_rmap() which has ever
reported anything, that from zap_pte_range() (usually on exit, sometimes
on munmap).  It has all the info, so remove page_remove_rmap()'s "Eeek"
message and leave it all to zap_pte_range().

mm/memory.c already has a hardly used print_bad_pte() function, showing
some of the appropriate info: extend it to show what we want for the rmap
case: pte info, page info (when there is a page) and vma info to compare. 
zap_pte_range() already knows the pmd, but print_bad_pte() is easier to
use if it works that out for itself.

Some of this info is also shown in bad_page()'s "Bad page state" message. 
Keep them separate, but adjust them to match each other as far as
possible.  Say "Bad page map" in print_bad_pte(), and add a TAINT_BAD_PAGE
there too.

print_bad_pte() show current->comm unconditionally (though it should get
repeated in the usually irrelevant stack trace): sorry, I misled Nick
Piggin to make it conditional on vm_mm == current->mm, but current->mm is
already NULL in the exit case.  Usually current->comm is good, though
exceptionally it may not be that of the mm (when "swapoff" for example).

Signed-off-by: Hugh Dickins <hugh@veritas.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Christoph Lameter <cl@linux-foundation.org>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c     |   50 +++++++++++++++++++++++++++++++++++-----------
 mm/page_alloc.c |   14 ++++++------
 mm/rmap.c       |   16 --------------
 3 files changed, 46 insertions(+), 34 deletions(-)

diff -puN mm/memory.c~badpage-replace-page_remove_rmap-eeek-and-bug mm/memory.c
--- a/mm/memory.c~badpage-replace-page_remove_rmap-eeek-and-bug
+++ a/mm/memory.c
@@ -52,6 +52,9 @@
 #include <linux/writeback.h>
 #include <linux/memcontrol.h>
 #include <linux/mmu_notifier.h>
+#include <linux/kallsyms.h>
+#include <linux/swapops.h>
+#include <linux/elf.h>
 
 #include <asm/pgalloc.h>
 #include <asm/uaccess.h>
@@ -59,9 +62,6 @@
 #include <asm/tlbflush.h>
 #include <asm/pgtable.h>
 
-#include <linux/swapops.h>
-#include <linux/elf.h>
-
 #include "internal.h"
 
 #ifndef CONFIG_NEED_MULTIPLE_NODES
@@ -375,15 +375,41 @@ static inline void add_mm_rss(struct mm_
  *
  * The calling function must still handle the error.
  */
-static void print_bad_pte(struct vm_area_struct *vma, pte_t pte,
-			  unsigned long vaddr)
+static void print_bad_pte(struct vm_area_struct *vma, unsigned long addr,
+			  pte_t pte, struct page *page)
 {
-	printk(KERN_ERR "Bad pte = %08llx, process = %s, "
-			"vm_flags = %lx, vaddr = %lx\n",
-		(long long)pte_val(pte),
-		(vma->vm_mm == current->mm ? current->comm : "???"),
-		vma->vm_flags, vaddr);
+	pgd_t *pgd = pgd_offset(vma->vm_mm, addr);
+	pud_t *pud = pud_offset(pgd, addr);
+	pmd_t *pmd = pmd_offset(pud, addr);
+	struct address_space *mapping;
+	pgoff_t index;
+
+	mapping = vma->vm_file ? vma->vm_file->f_mapping : NULL;
+	index = linear_page_index(vma, addr);
+
+	printk(KERN_EMERG "Bad page map in process %s  pte:%08llx pmd:%08llx\n",
+		current->comm,
+		(long long)pte_val(pte), (long long)pmd_val(*pmd));
+	if (page) {
+		printk(KERN_EMERG
+		"page:%p flags:%p count:%d mapcount:%d mapping:%p index:%lx\n",
+		page, (void *)page->flags, page_count(page),
+		page_mapcount(page), page->mapping, page->index);
+	}
+	printk(KERN_EMERG
+		"addr:%p vm_flags:%08lx anon_vma:%p mapping:%p index:%lx\n",
+		(void *)addr, vma->vm_flags, vma->anon_vma, mapping, index);
+	/*
+	 * Choose text because data symbols depend on CONFIG_KALLSYMS_ALL=y
+	 */
+	if (vma->vm_ops)
+		print_symbol(KERN_EMERG "vma->vm_ops->fault: %s\n",
+				(unsigned long)vma->vm_ops->fault);
+	if (vma->vm_file && vma->vm_file->f_op)
+		print_symbol(KERN_EMERG "vma->vm_file->f_op->mmap: %s\n",
+				(unsigned long)vma->vm_file->f_op->mmap);
 	dump_stack();
+	add_taint(TAINT_BAD_PAGE);
 }
 
 static inline int is_cow_mapping(unsigned int flags)
@@ -773,6 +799,8 @@ static unsigned long zap_pte_range(struc
 				file_rss--;
 			}
 			page_remove_rmap(page, vma);
+			if (unlikely(page_mapcount(page) < 0))
+				print_bad_pte(vma, addr, ptent, page);
 			tlb_remove_page(tlb, page);
 			continue;
 		}
@@ -2684,7 +2712,7 @@ static int do_nonlinear_fault(struct mm_
 		/*
 		 * Page table corrupted: show pte and kill process.
 		 */
-		print_bad_pte(vma, orig_pte, address);
+		print_bad_pte(vma, address, orig_pte, NULL);
 		return VM_FAULT_OOM;
 	}
 
diff -puN mm/page_alloc.c~badpage-replace-page_remove_rmap-eeek-and-bug mm/page_alloc.c
--- a/mm/page_alloc.c~badpage-replace-page_remove_rmap-eeek-and-bug
+++ a/mm/page_alloc.c
@@ -222,14 +222,14 @@ static inline int bad_range(struct zone 
 
 static void bad_page(struct page *page)
 {
-	printk(KERN_EMERG "Bad page state in process '%s'\n" KERN_EMERG
-		"page:%p flags:0x%0*lx mapping:%p mapcount:%d count:%d\n",
-		current->comm, page, (int)(2*sizeof(unsigned long)),
-		(unsigned long)page->flags, page->mapping,
-		page_mapcount(page), page_count(page));
+	printk(KERN_EMERG "Bad page state in process %s  pfn:%05lx\n",
+		current->comm, page_to_pfn(page));
+	printk(KERN_EMERG
+		"page:%p flags:%p count:%d mapcount:%d mapping:%p index:%lx\n",
+		page, (void *)page->flags, page_count(page),
+		page_mapcount(page), page->mapping, page->index);
+	printk(KERN_EMERG "Trying to fix it up, but a reboot is needed\n");
 
-	printk(KERN_EMERG "Trying to fix it up, but a reboot is needed\n"
-		KERN_EMERG "Backtrace:\n");
 	dump_stack();
 
 	/* Leave bad fields for debug, except PageBuddy could make trouble */
diff -puN mm/rmap.c~badpage-replace-page_remove_rmap-eeek-and-bug mm/rmap.c
--- a/mm/rmap.c~badpage-replace-page_remove_rmap-eeek-and-bug
+++ a/mm/rmap.c
@@ -47,7 +47,6 @@
 #include <linux/rmap.h>
 #include <linux/rcupdate.h>
 #include <linux/module.h>
-#include <linux/kallsyms.h>
 #include <linux/memcontrol.h>
 #include <linux/mmu_notifier.h>
 #include <linux/migrate.h>
@@ -725,21 +724,6 @@ void page_dup_rmap(struct page *page, st
 void page_remove_rmap(struct page *page, struct vm_area_struct *vma)
 {
 	if (atomic_add_negative(-1, &page->_mapcount)) {
-		if (unlikely(page_mapcount(page) < 0)) {
-			printk (KERN_EMERG "Eeek! page_mapcount(page) went negative! (%d)\n", page_mapcount(page));
-			printk (KERN_EMERG "  page pfn = %lx\n", page_to_pfn(page));
-			printk (KERN_EMERG "  page->flags = %lx\n", page->flags);
-			printk (KERN_EMERG "  page->count = %x\n", page_count(page));
-			printk (KERN_EMERG "  page->mapping = %p\n", page->mapping);
-			print_symbol (KERN_EMERG "  vma->vm_ops = %s\n", (unsigned long)vma->vm_ops);
-			if (vma->vm_ops) {
-				print_symbol (KERN_EMERG "  vma->vm_ops->fault = %s\n", (unsigned long)vma->vm_ops->fault);
-			}
-			if (vma->vm_file && vma->vm_file->f_op)
-				print_symbol (KERN_EMERG "  vma->vm_file->f_op->mmap = %s\n", (unsigned long)vma->vm_file->f_op->mmap);
-			BUG();
-		}
-
 		/*
 		 * Now that the last pte has gone, s390 must transfer dirty
 		 * flag from storage key to struct page.  We can usually skip
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

