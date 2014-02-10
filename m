From: akpm@linux-foundation.org
Subject: + mm-consolidate-code-to-setup-pte.patch added to -mm tree
Date: Mon, 10 Feb 2014 14:54:12 -0800
Message-ID: <52f95894.S6lhLzAOvHv6D+Ck%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59381 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752659AbaBJWyN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 10 Feb 2014 17:54:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, riel@redhat.com, n-horiguchi@ah.jp.nec.com, mgorman@suse.de, matthew.r.wilcox@intel.com, dave.hansen@linux.intel.com, ak@linux.intel.com, kirill.shutemov@linux.intel.com

Subject: + mm-consolidate-code-to-setup-pte.patch added to -mm tree
To: kirill.shutemov@linux.intel.com,ak@linux.intel.com,dave.hansen@linux.intel.com,matthew.r.wilcox@intel.com,mgorman@suse.de,n-horiguchi@ah.jp.nec.com,riel@redhat.com
From: akpm@linux-foundation.org
Date: Mon, 10 Feb 2014 14:54:12 -0800


The patch titled
     Subject: mm: consolidate code to setup pte
has been added to the -mm tree.  Its filename is
     mm-consolidate-code-to-setup-pte.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-consolidate-code-to-setup-pte.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-consolidate-code-to-setup-pte.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: mm: consolidate code to setup pte

Extract and consolidate code to setup pte from do_read_fault(),
do_cow_fault() and do_shared_fault().

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Rik van Riel <riel@redhat.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Matthew Wilcox <matthew.r.wilcox@intel.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |   66 ++++++++++++++++++++++----------------------------
 1 file changed, 30 insertions(+), 36 deletions(-)

diff -puN mm/memory.c~mm-consolidate-code-to-setup-pte mm/memory.c
--- a/mm/memory.c~mm-consolidate-code-to-setup-pte
+++ a/mm/memory.c
@@ -3317,13 +3317,37 @@ static int __do_fault(struct vm_area_str
 	return ret;
 }
 
+static void do_set_pte(struct vm_area_struct *vma, unsigned long address,
+		struct page *page, pte_t *pte, bool write, bool anon)
+{
+	pte_t entry;
+
+	flush_icache_page(vma, page);
+	entry = mk_pte(page, vma->vm_page_prot);
+	if (write)
+		entry = maybe_mkwrite(pte_mkdirty(entry), vma);
+	else if (pte_file(*pte) && pte_file_soft_dirty(*pte))
+		pte_mksoft_dirty(entry);
+	if (anon) {
+		inc_mm_counter_fast(vma->vm_mm, MM_ANONPAGES);
+		page_add_new_anon_rmap(page, vma, address);
+	} else {
+		inc_mm_counter_fast(vma->vm_mm, MM_FILEPAGES);
+		page_add_file_rmap(page);
+	}
+	set_pte_at(vma->vm_mm, address, pte, entry);
+
+	/* no need to invalidate: a not-present page won't be cached */
+	update_mmu_cache(vma, address, pte);
+}
+
 static int do_read_fault(struct mm_struct *mm, struct vm_area_struct *vma,
 		unsigned long address, pmd_t *pmd,
 		pgoff_t pgoff, unsigned int flags, pte_t orig_pte)
 {
 	struct page *fault_page;
 	spinlock_t *ptl;
-	pte_t entry, *pte;
+	pte_t *pte;
 	int ret;
 
 	ret = __do_fault(vma, address, pgoff, flags, &fault_page);
@@ -3337,20 +3361,9 @@ static int do_read_fault(struct mm_struc
 		page_cache_release(fault_page);
 		return ret;
 	}
-
-	flush_icache_page(vma, fault_page);
-	entry = mk_pte(fault_page, vma->vm_page_prot);
-	if (pte_file(orig_pte) && pte_file_soft_dirty(orig_pte))
-		pte_mksoft_dirty(entry);
-	inc_mm_counter_fast(mm, MM_FILEPAGES);
-	page_add_file_rmap(fault_page);
-	set_pte_at(mm, address, pte, entry);
-
-	/* no need to invalidate: a not-present page won't be cached */
-	update_mmu_cache(vma, address, pte);
+	do_set_pte(vma, address, fault_page, pte, false, false);
 	pte_unmap_unlock(pte, ptl);
 	unlock_page(fault_page);
-
 	return ret;
 }
 
@@ -3360,7 +3373,7 @@ static int do_cow_fault(struct mm_struct
 {
 	struct page *fault_page, *new_page;
 	spinlock_t *ptl;
-	pte_t entry, *pte;
+	pte_t *pte;
 	int ret;
 
 	if (unlikely(anon_vma_prepare(vma)))
@@ -3389,17 +3402,7 @@ static int do_cow_fault(struct mm_struct
 		page_cache_release(fault_page);
 		goto uncharge_out;
 	}
-
-	flush_icache_page(vma, new_page);
-	entry = mk_pte(new_page, vma->vm_page_prot);
-	entry = maybe_mkwrite(pte_mkdirty(entry), vma);
-	inc_mm_counter_fast(mm, MM_ANONPAGES);
-	page_add_new_anon_rmap(new_page, vma, address);
-	set_pte_at(mm, address, pte, entry);
-
-	/* no need to invalidate: a not-present page won't be cached */
-	update_mmu_cache(vma, address, pte);
-
+	do_set_pte(vma, address, new_page, pte, true, true);
 	pte_unmap_unlock(pte, ptl);
 	unlock_page(fault_page);
 	page_cache_release(fault_page);
@@ -3416,7 +3419,7 @@ static int do_shared_fault(struct mm_str
 {
 	struct page *fault_page;
 	spinlock_t *ptl;
-	pte_t entry, *pte;
+	pte_t *pte;
 	int dirtied = 0;
 	int ret, tmp;
 
@@ -3445,16 +3448,7 @@ static int do_shared_fault(struct mm_str
 		page_cache_release(fault_page);
 		return ret;
 	}
-
-	flush_icache_page(vma, fault_page);
-	entry = mk_pte(fault_page, vma->vm_page_prot);
-	entry = maybe_mkwrite(pte_mkdirty(entry), vma);
-	inc_mm_counter_fast(mm, MM_FILEPAGES);
-	page_add_file_rmap(fault_page);
-	set_pte_at(mm, address, pte, entry);
-
-	/* no need to invalidate: a not-present page won't be cached */
-	update_mmu_cache(vma, address, pte);
+	do_set_pte(vma, address, fault_page, pte, true, false);
 	pte_unmap_unlock(pte, ptl);
 
 	if (set_page_dirty(fault_page))
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are

pagewalk-update-page-table-walker-core.patch
pagewalk-add-walk_page_vma.patch
smaps-redefine-callback-functions-for-page-table-walker.patch
clear_refs-redefine-callback-functions-for-page-table-walker.patch
pagemap-redefine-callback-functions-for-page-table-walker.patch
numa_maps-redefine-callback-functions-for-page-table-walker.patch
memcg-redefine-callback-functions-for-page-table-walker.patch
madvise-redefine-callback-functions-for-page-table-walker.patch
arch-powerpc-mm-subpage-protc-use-walk_page_vma-instead-of-walk_page_range.patch
pagewalk-remove-argument-hmask-from-hugetlb_entry.patch
mempolicy-apply-page-table-walker-on-queue_pages_range.patch
mm-hwpoison-release-page-on-pagehwpoison-in-__do_fault.patch
mm-rename-__do_fault-do_fault.patch
mm-do_fault-extract-to-call-vm_ops-do_fault-to-separate-function.patch
mm-introduce-do_read_fault.patch
mm-introduce-do_cow_fault.patch
mm-introduce-do_shared_fault-and-drop-do_fault.patch
mm-consolidate-code-to-call-vm_ops-page_mkwrite.patch
mm-consolidate-code-to-setup-pte.patch

