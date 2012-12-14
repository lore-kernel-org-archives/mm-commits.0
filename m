From: akpm@linux-foundation.org
Subject: [merged] thp-copy_huge_pmd-copy-huge-zero-page.patch removed from -mm tree
Date: Fri, 14 Dec 2012 15:27:07 -0800
Message-ID: <20121214232708.79A6F200061@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wi0-f202.google.com ([209.85.212.202]:38103 "EHLO
	mail-wi0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932418Ab2LNX1M (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 14 Dec 2012 18:27:12 -0500
Received: by mail-wi0-f202.google.com with SMTP id hn17so70124wib.1
        for <mm-commits@vger.kernel.org>; Fri, 14 Dec 2012 15:27:10 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill.shutemov@linux.intel.com, aarcange@redhat.com, ak@linux.intel.com, hpa@linux.intel.com, mel@csn.ul.ie, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: thp: copy_huge_pmd(): copy huge zero page
has been removed from the -mm tree.  Its filename was
     thp-copy_huge_pmd-copy-huge-zero-page.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: thp: copy_huge_pmd(): copy huge zero page

It's easy to copy huge zero page. Just set destination pmd to huge zero
page.

It's safe to copy huge zero page since we have none yet :-p

[rientjes@google.com: fix comment]
Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: "H. Peter Anvin" <hpa@linux.intel.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |   22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff -puN mm/huge_memory.c~thp-copy_huge_pmd-copy-huge-zero-page mm/huge_memory.c
--- a/mm/huge_memory.c~thp-copy_huge_pmd-copy-huge-zero-page
+++ a/mm/huge_memory.c
@@ -708,6 +708,18 @@ static inline struct page *alloc_hugepag
 }
 #endif
 
+static void set_huge_zero_page(pgtable_t pgtable, struct mm_struct *mm,
+		struct vm_area_struct *vma, unsigned long haddr, pmd_t *pmd)
+{
+	pmd_t entry;
+	entry = pfn_pmd(huge_zero_pfn, vma->vm_page_prot);
+	entry = pmd_wrprotect(entry);
+	entry = pmd_mkhuge(entry);
+	set_pmd_at(mm, haddr, pmd, entry);
+	pgtable_trans_huge_deposit(mm, pgtable);
+	mm->nr_ptes++;
+}
+
 int do_huge_pmd_anonymous_page(struct mm_struct *mm, struct vm_area_struct *vma,
 			       unsigned long address, pmd_t *pmd,
 			       unsigned int flags)
@@ -785,6 +797,16 @@ int copy_huge_pmd(struct mm_struct *dst_
 		pte_free(dst_mm, pgtable);
 		goto out_unlock;
 	}
+	/*
+	 * mm->page_table_lock is enough to be sure that huge zero pmd is not
+	 * under splitting since we don't split the page itself, only pmd to
+	 * a page table.
+	 */
+	if (is_huge_zero_pmd(pmd)) {
+		set_huge_zero_page(pgtable, dst_mm, vma, addr, dst_pmd);
+		ret = 0;
+		goto out_unlock;
+	}
 	if (unlikely(pmd_trans_splitting(pmd))) {
 		/* split huge page running from under us */
 		spin_unlock(&src_mm->page_table_lock);
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are

origin.patch
linux-next.patch
x86-convert-update_mmu_cache-and-update_mmu_cache_pmd-to-functions.patch

