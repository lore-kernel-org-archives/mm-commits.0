From: akpm@linux-foundation.org
Subject: + mm-hugetlb-fix-coding-style-issues.patch added to -mm tree
Date: Tue, 21 Jun 2011 15:53:10 -0700
Message-ID: <201106212253.p5LMrAKk029556@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40840 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757320Ab1FUWxQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 21 Jun 2011 18:53:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: chrisf@ijw.co.nz, emunson@mgebm.net


The patch titled
     mm: hugetlb: fix coding style issues
has been added to the -mm tree.  Its filename is
     mm-hugetlb-fix-coding-style-issues.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: hugetlb: fix coding style issues
From: Chris Forbes <chrisf@ijw.co.nz>

Fix coding style issues flagged by checkpatch.pl

Signed-off-by: Chris Forbes <chrisf@ijw.co.nz>
Acked-by: Eric B Munson <emunson@mgebm.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   31 +++++++++++++++----------------
 1 file changed, 15 insertions(+), 16 deletions(-)

diff -puN mm/hugetlb.c~mm-hugetlb-fix-coding-style-issues mm/hugetlb.c
--- a/mm/hugetlb.c~mm-hugetlb-fix-coding-style-issues
+++ a/mm/hugetlb.c
@@ -24,7 +24,7 @@
 
 #include <asm/page.h>
 #include <asm/pgtable.h>
-#include <asm/io.h>
+#include <linux/io.h>
 
 #include <linux/hugetlb.h>
 #include <linux/node.h>
@@ -62,10 +62,10 @@ static DEFINE_SPINLOCK(hugetlb_lock);
  * must either hold the mmap_sem for write, or the mmap_sem for read and
  * the hugetlb_instantiation mutex:
  *
- * 	down_write(&mm->mmap_sem);
+ *	down_write(&mm->mmap_sem);
  * or
- * 	down_read(&mm->mmap_sem);
- * 	mutex_lock(&hugetlb_instantiation_mutex);
+ *	down_read(&mm->mmap_sem);
+ *	mutex_lock(&hugetlb_instantiation_mutex);
  */
 struct file_region {
 	struct list_head link;
@@ -503,9 +503,10 @@ static void update_and_free_page(struct 
 	h->nr_huge_pages--;
 	h->nr_huge_pages_node[page_to_nid(page)]--;
 	for (i = 0; i < pages_per_huge_page(h); i++) {
-		page[i].flags &= ~(1 << PG_locked | 1 << PG_error | 1 << PG_referenced |
-				1 << PG_dirty | 1 << PG_active | 1 << PG_reserved |
-				1 << PG_private | 1<< PG_writeback);
+		page[i].flags &= ~(1 << PG_locked | 1 << PG_error |
+				1 << PG_referenced | 1 << PG_dirty |
+				1 << PG_active | 1 << PG_reserved |
+				1 << PG_private | 1 << PG_writeback);
 	}
 	set_compound_page_dtor(page, NULL);
 	set_page_refcounted(page);
@@ -591,7 +592,6 @@ int PageHuge(struct page *page)
 
 	return dtor == free_huge_page;
 }
-
 EXPORT_SYMBOL_GPL(PageHuge);
 
 static struct page *alloc_fresh_huge_page_node(struct hstate *h, int nid)
@@ -2124,9 +2124,8 @@ static void set_huge_ptep_writable(struc
 	pte_t entry;
 
 	entry = pte_mkwrite(pte_mkdirty(huge_ptep_get(ptep)));
-	if (huge_ptep_set_access_flags(vma, address, ptep, entry, 1)) {
+	if (huge_ptep_set_access_flags(vma, address, ptep, entry, 1))
 		update_mmu_cache(vma, address, ptep);
-	}
 }
 
 
@@ -2181,9 +2180,9 @@ static int is_hugetlb_entry_migration(pt
 	if (huge_pte_none(pte) || pte_present(pte))
 		return 0;
 	swp = pte_to_swp_entry(pte);
-	if (non_swap_entry(swp) && is_migration_entry(swp)) {
+	if (non_swap_entry(swp) && is_migration_entry(swp))
 		return 1;
-	} else
+	else
 		return 0;
 }
 
@@ -2194,9 +2193,9 @@ static int is_hugetlb_entry_hwpoisoned(p
 	if (huge_pte_none(pte) || pte_present(pte))
 		return 0;
 	swp = pte_to_swp_entry(pte);
-	if (non_swap_entry(swp) && is_hwpoison_entry(swp)) {
+	if (non_swap_entry(swp) && is_hwpoison_entry(swp))
 		return 1;
-	} else
+	else
 		return 0;
 }
 
@@ -2559,7 +2558,7 @@ retry:
 		 * So we need to block hugepage fault by PG_hwpoison bit check.
 		 */
 		if (unlikely(PageHWPoison(page))) {
-			ret = VM_FAULT_HWPOISON | 
+			ret = VM_FAULT_HWPOISON |
 			      VM_FAULT_SET_HINDEX(h - hstates);
 			goto backout_unlocked;
 		}
@@ -2627,7 +2626,7 @@ int hugetlb_fault(struct mm_struct *mm, 
 			migration_entry_wait(mm, (pmd_t *)ptep, address);
 			return 0;
 		} else if (unlikely(is_hugetlb_entry_hwpoisoned(entry)))
-			return VM_FAULT_HWPOISON_LARGE | 
+			return VM_FAULT_HWPOISON_LARGE |
 			       VM_FAULT_SET_HINDEX(h - hstates);
 	}
 
_

Patches currently in -mm which might be from chrisf@ijw.co.nz are

mm-hugetlb-fix-coding-style-issues.patch

