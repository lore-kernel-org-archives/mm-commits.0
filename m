From: akpm@linux-foundation.org
Subject: [patch 18/20] mm: thp: refix false positive BUG in
 page_move_anon_rmap()
Date: Thu, 14 Jul 2016 12:07:38 -0700
Message-ID: <5787e2fa.pPqoOs1kcCeqwTzP%akpm__26014.0519858853$1468523283$gmane$org@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41024 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751161AbcGNTHj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 14 Jul 2016 15:07:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, hughd@google.com, aarcange@redhat.com, dvyukov@google.com, kirill.shutemov@linux.intel.com, mika.westerberg@linux.intel.com, riel@redhat.com, stable@vger.kernel.org

From: Hugh Dickins <hughd@google.com>
Subject: mm: thp: refix false positive BUG in page_move_anon_rmap()

The VM_BUG_ON_PAGE in page_move_anon_rmap() is more trouble than it's
worth: the syzkaller fuzzer hit it again.  It's still wrong for some THP
cases, because linear_page_index() was never intended to apply to
addresses before the start of a vma.

That's easily fixed with a signed long cast inside linear_page_index();
and Dmitry has tested such a patch, to verify the false positive.  But why
extend linear_page_index() just for this case?  when the avoidance in
page_move_anon_rmap() has already grown ugly, and there's no reason for
the check at all (nothing else there is using address or index).

Remove address arg from page_move_anon_rmap(), remove VM_BUG_ON_PAGE,
remove CONFIG_DEBUG_VM PageTransHuge adjustment.

And one more thing: should the compound_head(page) be done inside or
outside page_move_anon_rmap()?  It's usually pushed down to the lowest
level nowadays (and mm/memory.c shows no other explicit use of it), so I
think it's better done in page_move_anon_rmap() than by caller.

Fixes: 0798d3c022dc ("mm: thp: avoid false positive VM_BUG_ON_PAGE in page_move_anon_rmap()")
Link: http://lkml.kernel.org/r/alpine.LSU.2.11.1607120444540.12528@eggly.anvils
Signed-off-by: Hugh Dickins <hughd@google.com>
Reported-by: Dmitry Vyukov <dvyukov@google.com>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: <stable@vger.kernel.org>	[4.5+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/rmap.h |    2 +-
 mm/hugetlb.c         |    2 +-
 mm/memory.c          |    3 +--
 mm/rmap.c            |    9 +++------
 4 files changed, 6 insertions(+), 10 deletions(-)

diff -puN include/linux/rmap.h~mm-thp-refix-false-positive-bug-in-page_move_anon_rmap include/linux/rmap.h
--- a/include/linux/rmap.h~mm-thp-refix-false-positive-bug-in-page_move_anon_rmap
+++ a/include/linux/rmap.h
@@ -158,7 +158,7 @@ struct anon_vma *page_get_anon_vma(struc
 /*
  * rmap interfaces called when adding or removing pte of page
  */
-void page_move_anon_rmap(struct page *, struct vm_area_struct *, unsigned long);
+void page_move_anon_rmap(struct page *, struct vm_area_struct *);
 void page_add_anon_rmap(struct page *, struct vm_area_struct *,
 		unsigned long, bool);
 void do_page_add_anon_rmap(struct page *, struct vm_area_struct *,
diff -puN mm/hugetlb.c~mm-thp-refix-false-positive-bug-in-page_move_anon_rmap mm/hugetlb.c
--- a/mm/hugetlb.c~mm-thp-refix-false-positive-bug-in-page_move_anon_rmap
+++ a/mm/hugetlb.c
@@ -3383,7 +3383,7 @@ retry_avoidcopy:
 	/* If no-one else is actually using this page, avoid the copy
 	 * and just make the page writable */
 	if (page_mapcount(old_page) == 1 && PageAnon(old_page)) {
-		page_move_anon_rmap(old_page, vma, address);
+		page_move_anon_rmap(old_page, vma);
 		set_huge_ptep_writable(vma, address, ptep);
 		return 0;
 	}
diff -puN mm/memory.c~mm-thp-refix-false-positive-bug-in-page_move_anon_rmap mm/memory.c
--- a/mm/memory.c~mm-thp-refix-false-positive-bug-in-page_move_anon_rmap
+++ a/mm/memory.c
@@ -2399,8 +2399,7 @@ static int do_wp_page(struct mm_struct *
 				 * Protected against the rmap code by
 				 * the page lock.
 				 */
-				page_move_anon_rmap(compound_head(old_page),
-						    vma, address);
+				page_move_anon_rmap(old_page, vma);
 			}
 			unlock_page(old_page);
 			return wp_page_reuse(mm, vma, address, page_table, ptl,
diff -puN mm/rmap.c~mm-thp-refix-false-positive-bug-in-page_move_anon_rmap mm/rmap.c
--- a/mm/rmap.c~mm-thp-refix-false-positive-bug-in-page_move_anon_rmap
+++ a/mm/rmap.c
@@ -1084,23 +1084,20 @@ EXPORT_SYMBOL_GPL(page_mkclean);
  * page_move_anon_rmap - move a page to our anon_vma
  * @page:	the page to move to our anon_vma
  * @vma:	the vma the page belongs to
- * @address:	the user virtual address mapped
  *
  * When a page belongs exclusively to one process after a COW event,
  * that page can be moved into the anon_vma that belongs to just that
  * process, so the rmap code will not search the parent or sibling
  * processes.
  */
-void page_move_anon_rmap(struct page *page,
-	struct vm_area_struct *vma, unsigned long address)
+void page_move_anon_rmap(struct page *page, struct vm_area_struct *vma)
 {
 	struct anon_vma *anon_vma = vma->anon_vma;
 
+	page = compound_head(page);
+
 	VM_BUG_ON_PAGE(!PageLocked(page), page);
 	VM_BUG_ON_VMA(!anon_vma, vma);
-	if (IS_ENABLED(CONFIG_DEBUG_VM) && PageTransHuge(page))
-		address &= HPAGE_PMD_MASK;
-	VM_BUG_ON_PAGE(page->index != linear_page_index(vma, address), page);
 
 	anon_vma = (void *) anon_vma + PAGE_MAPPING_ANON;
 	/*
_
