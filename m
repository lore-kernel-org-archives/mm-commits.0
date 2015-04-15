From: akpm@linux-foundation.org
Subject: [merged] mm-refactor-do_wp_page-extract-the-reuse-case.patch
 removed from -mm tree
Date: Wed, 15 Apr 2015 12:10:27 -0700
Message-ID: <552eb7a3.uhz5bjywhq8tuOgl%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48196 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932117AbbDOTK2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 15 Apr 2015 15:10:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: raindel@mellanox.com, aarcange@redhat.com, ak@linux.intel.com, dave.hansen@intel.com, haggaie@mellanox.com, hannes@cmpxchg.org, kirill.shutemov@linux.intel.com, matthew.r.wilcox@intel.com, mgorman@suse.de, mhocko@suse.cz, n-horiguchi@ah.jp.nec.com, pfeiner@google.com, riel@redhat.com, torvalds@linux-foundation.org, walken@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: refactor do_wp_page, extract the reuse case
has been removed from the -mm tree.  Its filename was
     mm-refactor-do_wp_page-extract-the-reuse-case.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Shachar Raindel <raindel@mellanox.com>
Subject: mm: refactor do_wp_page, extract the reuse case

Currently do_wp_page contains 265 code lines.  It also contains 9 goto
statements, of which 5 are targeting labels which are not cleanup related.
 This makes the function extremely difficult to understand.  The following
patches are an attempt at breaking the function to its basic components,
and making it easier to understand.

The patches are straight forward function extractions from do_wp_page.  As
we extract functions, we remove unneeded parameters and simplify the code
as much as possible.  However, the functionality is supposed to remain
completely unchanged.  The patches also attempt to document the
functionality of each extracted function.  In patch 2, we split the unlock
logic to the contain logic relevant to specific needs of each use case,
instead of having huge number of conditional decisions in a single unlock
flow.



This patch (of 4):

When do_wp_page is ending, in several cases it needs to reuse the existing
page.  This is achieved by making the page table writable, and possibly
updating the page-cache state.

Currently, this logic was "called" by using a goto jump.  This makes
following the control flow of the function harder.  It is also against the
coding style guidelines for using goto.

As the code can easily be refactored into a specialized function, refactor
it out and simplify the code flow in do_wp_page.

Acked-by: Linus Torvalds <torvalds@linux-foundation.org>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Acked-by: Rik van Riel <riel@redhat.com>
Acked-by: Andi Kleen <ak@linux.intel.com>
Acked-by: Haggai Eran <haggaie@mellanox.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Matthew Wilcox <matthew.r.wilcox@intel.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Peter Feiner <pfeiner@google.com>
Cc: Michel Lespinasse <walken@google.com>
Reviewed-by: Michal Hocko <mhocko@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |  117 +++++++++++++++++++++++++++++---------------------
 1 file changed, 68 insertions(+), 49 deletions(-)

diff -puN mm/memory.c~mm-refactor-do_wp_page-extract-the-reuse-case mm/memory.c
--- a/mm/memory.c~mm-refactor-do_wp_page-extract-the-reuse-case
+++ a/mm/memory.c
@@ -1983,6 +1983,65 @@ static int do_page_mkwrite(struct vm_are
 }
 
 /*
+ * Handle write page faults for pages that can be reused in the current vma
+ *
+ * This can happen either due to the mapping being with the VM_SHARED flag,
+ * or due to us being the last reference standing to the page. In either
+ * case, all we need to do here is to mark the page as writable and update
+ * any related book-keeping.
+ */
+static inline int wp_page_reuse(struct mm_struct *mm,
+			struct vm_area_struct *vma, unsigned long address,
+			pte_t *page_table, spinlock_t *ptl, pte_t orig_pte,
+			struct page *page, int page_mkwrite,
+			int dirty_shared)
+	__releases(ptl)
+{
+	pte_t entry;
+	/*
+	 * Clear the pages cpupid information as the existing
+	 * information potentially belongs to a now completely
+	 * unrelated process.
+	 */
+	if (page)
+		page_cpupid_xchg_last(page, (1 << LAST_CPUPID_SHIFT) - 1);
+
+	flush_cache_page(vma, address, pte_pfn(orig_pte));
+	entry = pte_mkyoung(orig_pte);
+	entry = maybe_mkwrite(pte_mkdirty(entry), vma);
+	if (ptep_set_access_flags(vma, address, page_table, entry, 1))
+		update_mmu_cache(vma, address, page_table);
+	pte_unmap_unlock(page_table, ptl);
+
+	if (dirty_shared) {
+		struct address_space *mapping;
+		int dirtied;
+
+		if (!page_mkwrite)
+			lock_page(page);
+
+		dirtied = set_page_dirty(page);
+		VM_BUG_ON_PAGE(PageAnon(page), page);
+		mapping = page->mapping;
+		unlock_page(page);
+		page_cache_release(page);
+
+		if ((dirtied || page_mkwrite) && mapping) {
+			/*
+			 * Some device drivers do not set page.mapping
+			 * but still dirty their pages
+			 */
+			balance_dirty_pages_ratelimited(mapping);
+		}
+
+		if (!page_mkwrite)
+			file_update_time(vma->vm_file);
+	}
+
+	return VM_FAULT_WRITE;
+}
+
+/*
  * This routine handles present pages, when users try to write
  * to a shared page. It is done by copying the page to a new address
  * and decrementing the shared-page counter for the old page.
@@ -2008,8 +2067,6 @@ static int do_wp_page(struct mm_struct *
 	struct page *old_page, *new_page = NULL;
 	pte_t entry;
 	int ret = 0;
-	int page_mkwrite = 0;
-	bool dirty_shared = false;
 	unsigned long mmun_start = 0;	/* For mmu_notifiers */
 	unsigned long mmun_end = 0;	/* For mmu_notifiers */
 	struct mem_cgroup *memcg;
@@ -2026,7 +2083,8 @@ static int do_wp_page(struct mm_struct *
 		 */
 		if ((vma->vm_flags & (VM_WRITE|VM_SHARED)) ==
 				     (VM_WRITE|VM_SHARED))
-			goto reuse;
+			return wp_page_reuse(mm, vma, address, page_table, ptl,
+					     orig_pte, old_page, 0, 0);
 		goto gotten;
 	}
 
@@ -2055,12 +2113,16 @@ static int do_wp_page(struct mm_struct *
 			 */
 			page_move_anon_rmap(old_page, vma, address);
 			unlock_page(old_page);
-			goto reuse;
+			return wp_page_reuse(mm, vma, address, page_table, ptl,
+					     orig_pte, old_page, 0, 0);
 		}
 		unlock_page(old_page);
 	} else if (unlikely((vma->vm_flags & (VM_WRITE|VM_SHARED)) ==
 					(VM_WRITE|VM_SHARED))) {
+		int page_mkwrite = 0;
+
 		page_cache_get(old_page);
+
 		/*
 		 * Only catch write-faults on shared writable pages,
 		 * read-only shared pages can get COWed by
@@ -2091,51 +2153,8 @@ static int do_wp_page(struct mm_struct *
 			page_mkwrite = 1;
 		}
 
-		dirty_shared = true;
-
-reuse:
-		/*
-		 * Clear the pages cpupid information as the existing
-		 * information potentially belongs to a now completely
-		 * unrelated process.
-		 */
-		if (old_page)
-			page_cpupid_xchg_last(old_page, (1 << LAST_CPUPID_SHIFT) - 1);
-
-		flush_cache_page(vma, address, pte_pfn(orig_pte));
-		entry = pte_mkyoung(orig_pte);
-		entry = maybe_mkwrite(pte_mkdirty(entry), vma);
-		if (ptep_set_access_flags(vma, address, page_table, entry,1))
-			update_mmu_cache(vma, address, page_table);
-		pte_unmap_unlock(page_table, ptl);
-		ret |= VM_FAULT_WRITE;
-
-		if (dirty_shared) {
-			struct address_space *mapping;
-			int dirtied;
-
-			if (!page_mkwrite)
-				lock_page(old_page);
-
-			dirtied = set_page_dirty(old_page);
-			VM_BUG_ON_PAGE(PageAnon(old_page), old_page);
-			mapping = old_page->mapping;
-			unlock_page(old_page);
-			page_cache_release(old_page);
-
-			if ((dirtied || page_mkwrite) && mapping) {
-				/*
-				 * Some device drivers do not set page.mapping
-				 * but still dirty their pages
-				 */
-				balance_dirty_pages_ratelimited(mapping);
-			}
-
-			if (!page_mkwrite)
-				file_update_time(vma->vm_file);
-		}
