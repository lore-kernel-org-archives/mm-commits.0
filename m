From: akpm@linux-foundation.org
Subject: [merged] vmscan-report-vm_flags-in-page_referenced.patch removed from -mm tree
Date: Wed, 17 Jun 2009 11:36:18 -0700
Message-ID: <200906171836.n5HIaI8x002254@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44215 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754889AbZFQShh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 17 Jun 2009 14:37:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fengguang.wu@intel.com, hannes@cmpxchg.org, minchan.kim@gmail.com, peterz@infradead.org, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     vmscan: report vm_flags in page_referenced()
has been removed from the -mm tree.  Its filename was
     vmscan-report-vm_flags-in-page_referenced.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: vmscan: report vm_flags in page_referenced()
From: Wu Fengguang <fengguang.wu@intel.com>

Collect vma->vm_flags of the VMAs that actually referenced the page.

This is preparing for more informed reclaim heuristics, eg.  to protect
executable file pages more aggressively.  For now only the VM_EXEC bit
will be used by the caller.

Thanks to Johannes, Peter and Minchan for all the good tips.

Acked-by: Peter Zijlstra <peterz@infradead.org>
Reviewed-by: Rik van Riel <riel@redhat.com>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>
Reviewed-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/rmap.h |    5 +++--
 mm/rmap.c            |   37 ++++++++++++++++++++++++++-----------
 mm/vmscan.c          |    7 +++++--
 3 files changed, 34 insertions(+), 15 deletions(-)

diff -puN include/linux/rmap.h~vmscan-report-vm_flags-in-page_referenced include/linux/rmap.h
--- a/include/linux/rmap.h~vmscan-report-vm_flags-in-page_referenced
+++ a/include/linux/rmap.h
@@ -83,7 +83,8 @@ static inline void page_dup_rmap(struct 
 /*
  * Called from mm/vmscan.c to handle paging out
  */
-int page_referenced(struct page *, int is_locked, struct mem_cgroup *cnt);
+int page_referenced(struct page *, int is_locked,
+			struct mem_cgroup *cnt, unsigned long *vm_flags);
 int try_to_unmap(struct page *, int ignore_refs);
 
 /*
@@ -117,7 +118,7 @@ int try_to_munlock(struct page *);
 #define anon_vma_prepare(vma)	(0)
 #define anon_vma_link(vma)	do {} while (0)
 
-#define page_referenced(page,l,cnt) TestClearPageReferenced(page)
+#define page_referenced(page, locked, cnt, flags) TestClearPageReferenced(page)
 #define try_to_unmap(page, refs) SWAP_FAIL
 
 static inline int page_mkclean(struct page *page)
diff -puN mm/rmap.c~vmscan-report-vm_flags-in-page_referenced mm/rmap.c
--- a/mm/rmap.c~vmscan-report-vm_flags-in-page_referenced
+++ a/mm/rmap.c
@@ -333,7 +333,9 @@ static int page_mapped_in_vma(struct pag
  * repeatedly from either page_referenced_anon or page_referenced_file.
  */
 static int page_referenced_one(struct page *page,
-	struct vm_area_struct *vma, unsigned int *mapcount)
+			       struct vm_area_struct *vma,
+			       unsigned int *mapcount,
+			       unsigned long *vm_flags)
 {
 	struct mm_struct *mm = vma->vm_mm;
 	unsigned long address;
@@ -381,11 +383,14 @@ out_unmap:
 	(*mapcount)--;
 	pte_unmap_unlock(pte, ptl);
 out:
+	if (referenced)
+		*vm_flags |= vma->vm_flags;
 	return referenced;
 }
 
 static int page_referenced_anon(struct page *page,
-				struct mem_cgroup *mem_cont)
+				struct mem_cgroup *mem_cont,
+				unsigned long *vm_flags)
 {
 	unsigned int mapcount;
 	struct anon_vma *anon_vma;
@@ -405,7 +410,8 @@ static int page_referenced_anon(struct p
 		 */
 		if (mem_cont && !mm_match_cgroup(vma->vm_mm, mem_cont))
 			continue;
-		referenced += page_referenced_one(page, vma, &mapcount);
+		referenced += page_referenced_one(page, vma,
+						  &mapcount, vm_flags);
 		if (!mapcount)
 			break;
 	}
@@ -418,6 +424,7 @@ static int page_referenced_anon(struct p
  * page_referenced_file - referenced check for object-based rmap
  * @page: the page we're checking references on.
  * @mem_cont: target memory controller
+ * @vm_flags: collect encountered vma->vm_flags who actually referenced the page
  *
  * For an object-based mapped page, find all the places it is mapped and
  * check/clear the referenced flag.  This is done by following the page->mapping
@@ -427,7 +434,8 @@ static int page_referenced_anon(struct p
  * This function is only called from page_referenced for object-based pages.
  */
 static int page_referenced_file(struct page *page,
-				struct mem_cgroup *mem_cont)
+				struct mem_cgroup *mem_cont,
+				unsigned long *vm_flags)
 {
 	unsigned int mapcount;
 	struct address_space *mapping = page->mapping;
@@ -467,7 +475,8 @@ static int page_referenced_file(struct p
 		 */
 		if (mem_cont && !mm_match_cgroup(vma->vm_mm, mem_cont))
 			continue;
-		referenced += page_referenced_one(page, vma, &mapcount);
+		referenced += page_referenced_one(page, vma,
+						  &mapcount, vm_flags);
 		if (!mapcount)
 			break;
 	}
@@ -481,29 +490,35 @@ static int page_referenced_file(struct p
  * @page: the page to test
  * @is_locked: caller holds lock on the page
  * @mem_cont: target memory controller
+ * @vm_flags: collect encountered vma->vm_flags who actually referenced the page
  *
  * Quick test_and_clear_referenced for all mappings to a page,
  * returns the number of ptes which referenced the page.
  */
-int page_referenced(struct page *page, int is_locked,
-			struct mem_cgroup *mem_cont)
+int page_referenced(struct page *page,
+		    int is_locked,
+		    struct mem_cgroup *mem_cont,
+		    unsigned long *vm_flags)
 {
 	int referenced = 0;
 
 	if (TestClearPageReferenced(page))
 		referenced++;
 
+	*vm_flags = 0;
 	if (page_mapped(page) && page->mapping) {
 		if (PageAnon(page))
-			referenced += page_referenced_anon(page, mem_cont);
+			referenced += page_referenced_anon(page, mem_cont,
+								vm_flags);
 		else if (is_locked)
-			referenced += page_referenced_file(page, mem_cont);
+			referenced += page_referenced_file(page, mem_cont,
+								vm_flags);
 		else if (!trylock_page(page))
 			referenced++;
 		else {
 			if (page->mapping)
-				referenced +=
-					page_referenced_file(page, mem_cont);
+				referenced += page_referenced_file(page,
+							mem_cont, vm_flags);
 			unlock_page(page);
 		}
 	}
diff -puN mm/vmscan.c~vmscan-report-vm_flags-in-page_referenced mm/vmscan.c
--- a/mm/vmscan.c~vmscan-report-vm_flags-in-page_referenced
+++ a/mm/vmscan.c
@@ -577,6 +577,7 @@ static unsigned long shrink_page_list(st
 	struct pagevec freed_pvec;
 	int pgactivate = 0;
 	unsigned long nr_reclaimed = 0;
+	unsigned long vm_flags;
 
 	cond_resched();
 
@@ -627,7 +628,8 @@ static unsigned long shrink_page_list(st
 				goto keep_locked;
 		}
 
-		referenced = page_referenced(page, 1, sc->mem_cgroup);
+		referenced = page_referenced(page, 1,
+						sc->mem_cgroup, &vm_flags);
 		/* In active use or really unfreeable?  Activate it. */
 		if (sc->order <= PAGE_ALLOC_COSTLY_ORDER &&
 					referenced && page_mapping_inuse(page))
@@ -1208,6 +1210,7 @@ static void shrink_active_list(unsigned 
 {
 	unsigned long pgmoved;
 	unsigned long pgscanned;
+	unsigned long vm_flags;
 	LIST_HEAD(l_hold);	/* The pages which were snipped off */
 	LIST_HEAD(l_inactive);
 	struct page *page;
@@ -1248,7 +1251,7 @@ static void shrink_active_list(unsigned 
 
 		/* page_referenced clears PageReferenced */
 		if (page_mapping_inuse(page) &&
-		    page_referenced(page, 0, sc->mem_cgroup))
+		    page_referenced(page, 0, sc->mem_cgroup, &vm_flags))
 			pgmoved++;
 
 		list_add(&page->lru, &l_inactive);
_

Patches currently in -mm which might be from fengguang.wu@intel.com are

origin.patch
documentation-vm-makefile-dont-try-to-build-slqbinfo.patch
linux-next.patch
readahead-add-blk_run_backing_dev.patch
readahead-add-blk_run_backing_dev-fix.patch
readahead-add-blk_run_backing_dev-fix-fix-2.patch

