From: akpm@linux-foundation.org
Subject: + thp-change-split_huge_page_pmd-interface-v6.patch added to -mm tree
Date: Thu, 15 Nov 2012 12:49:34 -0800
Message-ID: <20121115204935.457FE100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ye0-f202.google.com ([209.85.213.202]:64652 "EHLO
	mail-ye0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751007Ab2KOVoy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 15 Nov 2012 16:44:54 -0500
Received: by mail-ye0-f202.google.com with SMTP id r11so229751yen.1
        for <mm-commits@vger.kernel.org>; Thu, 15 Nov 2012 13:44:54 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kirill.shutemov@linux.intel.com, aarcange@redhat.com, ak@linux.intel.com, hpa@linux.intel.com, mel@csn.ul.ie, rientjes@google.com


The patch titled
     Subject: thp-change-split_huge_page_pmd-interface-v6
has been added to the -mm tree.  Its filename is
     thp-change-split_huge_page_pmd-interface-v6.patch

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
Subject: thp-change-split_huge_page_pmd-interface-v6

Pass vma instead of mm and add address parameter.

In most cases we already have vma on the stack. We provides
split_huge_page_pmd_mm() for few cases when we have mm, but not vma.

This change is preparation to huge zero pmd splitting implementation.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: "H. Peter Anvin" <hpa@linux.intel.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/vm/transhuge.txt |    4 ++--
 mm/huge_memory.c               |    7 ++++---
 2 files changed, 6 insertions(+), 5 deletions(-)

diff -puN Documentation/vm/transhuge.txt~thp-change-split_huge_page_pmd-interface-v6 Documentation/vm/transhuge.txt
--- a/Documentation/vm/transhuge.txt~thp-change-split_huge_page_pmd-interface-v6
+++ a/Documentation/vm/transhuge.txt
@@ -276,7 +276,7 @@ unaffected. libhugetlbfs will also work 
 == Graceful fallback ==
 
 Code walking pagetables but unware about huge pmds can simply call
-split_huge_page_pmd(vma, pmd, addr) where the pmd is the one returned by
+split_huge_page_pmd(vma, addr, pmd) where the pmd is the one returned by
 pmd_offset. It's trivial to make the code transparent hugepage aware
 by just grepping for "pmd_offset" and adding split_huge_page_pmd where
 missing after pmd_offset returns the pmd. Thanks to the graceful
@@ -299,7 +299,7 @@ diff --git a/mm/mremap.c b/mm/mremap.c
 		return NULL;
 
 	pmd = pmd_offset(pud, addr);
-+	split_huge_page_pmd(vma, pmd, addr);
++	split_huge_page_pmd(vma, addr, pmd);
 	if (pmd_none_or_clear_bad(pmd))
 		return NULL;
 
diff -puN mm/huge_memory.c~thp-change-split_huge_page_pmd-interface-v6 mm/huge_memory.c
--- a/mm/huge_memory.c~thp-change-split_huge_page_pmd-interface-v6
+++ a/mm/huge_memory.c
@@ -2626,18 +2626,19 @@ void __split_huge_page_pmd(struct vm_are
 {
 	struct page *page;
 	unsigned long haddr = address & HPAGE_PMD_MASK;
+	struct mm_struct *mm = vma->vm_mm;
 
 	BUG_ON(vma->vm_start > haddr || vma->vm_end < haddr + HPAGE_PMD_SIZE);
 
-	spin_lock(&vma->vm_mm->page_table_lock);
+	spin_lock(&mm->page_table_lock);
 	if (unlikely(!pmd_trans_huge(*pmd))) {
-		spin_unlock(&vma->vm_mm->page_table_lock);
+		spin_unlock(&mm->page_table_lock);
 		return;
 	}
 	page = pmd_page(*pmd);
 	VM_BUG_ON(!page_count(page));
 	get_page(page);
-	spin_unlock(&vma->vm_mm->page_table_lock);
+	spin_unlock(&mm->page_table_lock);
 
 	split_huge_page(page);
 
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are

linux-next.patch
mm-use-is_enabledconfig_numa-instead-of-numa_build.patch
mm-use-is_enabledconfig_compaction-instead-of-compaction_build.patch
thp-huge-zero-page-basic-preparation.patch
thp-huge-zero-page-basic-preparation-v6.patch
thp-zap_huge_pmd-zap-huge-zero-pmd.patch
thp-copy_huge_pmd-copy-huge-zero-page.patch
thp-copy_huge_pmd-copy-huge-zero-page-v6.patch
thp-do_huge_pmd_wp_page-handle-huge-zero-page.patch
thp-do_huge_pmd_wp_page-handle-huge-zero-page-v6.patch
thp-change_huge_pmd-keep-huge-zero-page-write-protected.patch
thp-change-split_huge_page_pmd-interface.patch
thp-change-split_huge_page_pmd-interface-v6.patch
thp-implement-splitting-pmd-for-huge-zero-page.patch
thp-implement-splitting-pmd-for-huge-zero-page-v6.patch
thp-setup-huge-zero-page-on-non-write-page-fault.patch
thp-lazy-huge-zero-page-allocation.patch
thp-implement-refcounting-for-huge-zero-page.patch
thp-vmstat-implement-hzp_alloc-and-hzp_alloc_failed-events.patch
thp-vmstat-implement-hzp_alloc-and-hzp_alloc_failed-events-v6.patch
thp-introduce-sysfs-knob-to-disable-huge-zero-page.patch

