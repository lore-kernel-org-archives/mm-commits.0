From: akpm@linux-foundation.org
Subject: [merged] thp-setup-huge-zero-page-on-non-write-page-fault.patch removed from -mm tree
Date: Fri, 14 Dec 2012 15:27:29 -0800
Message-ID: <20121214232730.1A48182004A@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:44580 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932418Ab2LNX1b (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 14 Dec 2012 18:27:31 -0500
Received: by mail-qa0-f74.google.com with SMTP id r4so145555qaq.1
        for <mm-commits@vger.kernel.org>; Fri, 14 Dec 2012 15:27:30 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill.shutemov@linux.intel.com, aarcange@redhat.com, ak@linux.intel.com, hpa@linux.intel.com, mel@csn.ul.ie, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: thp: setup huge zero page on non-write page fault
has been removed from the -mm tree.  Its filename was
     thp-setup-huge-zero-page-on-non-write-page-fault.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: thp: setup huge zero page on non-write page fault

All code paths seems covered. Now we can map huge zero page on read page
fault.

We setup it in do_huge_pmd_anonymous_page() if area around fault address
is suitable for THP and we've got read page fault.

If we fail to setup huge zero page (ENOMEM) we fallback to
handle_pte_fault() as we normally do in THP.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: "H. Peter Anvin" <hpa@linux.intel.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff -puN mm/huge_memory.c~thp-setup-huge-zero-page-on-non-write-page-fault mm/huge_memory.c
--- a/mm/huge_memory.c~thp-setup-huge-zero-page-on-non-write-page-fault
+++ a/mm/huge_memory.c
@@ -733,6 +733,16 @@ int do_huge_pmd_anonymous_page(struct mm
 			return VM_FAULT_OOM;
 		if (unlikely(khugepaged_enter(vma)))
 			return VM_FAULT_OOM;
+		if (!(flags & FAULT_FLAG_WRITE)) {
+			pgtable_t pgtable;
+			pgtable = pte_alloc_one(mm, haddr);
+			if (unlikely(!pgtable))
+				return VM_FAULT_OOM;
+			spin_lock(&mm->page_table_lock);
+			set_huge_zero_page(pgtable, mm, vma, haddr, pmd);
+			spin_unlock(&mm->page_table_lock);
+			return 0;
+		}
 		page = alloc_hugepage_vma(transparent_hugepage_defrag(vma),
 					  vma, haddr, numa_node_id(), 0);
 		if (unlikely(!page)) {
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are

origin.patch
linux-next.patch
x86-convert-update_mmu_cache-and-update_mmu_cache_pmd-to-functions.patch

