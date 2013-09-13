From: akpm@linux-foundation.org
Subject: [merged] thp-do_huge_pmd_anonymous_page-cleanup.patch removed
 from -mm tree
Date: Fri, 13 Sep 2013 13:03:00 -0700
Message-ID: <52336f74.RJ4L9wK9Md9E3NA4%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38070 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755241Ab3IMUDB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 13 Sep 2013 16:03:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, willy@linux.intel.com, viro@zeniv.linux.org.uk, mgorman@suse.de, jack@suse.cz, hughd@google.com, fengguang.wu@intel.com, dhillf@gmail.com, dave.hansen@linux.intel.com, ak@linux.intel.com, aarcange@redhat.com, kirill.shutemov@linux.intel.com

Subject: [merged] thp-do_huge_pmd_anonymous_page-cleanup.patch removed from -mm tree
To: kirill.shutemov@linux.intel.com,aarcange@redhat.com,ak@linux.intel.com,dave.hansen@linux.intel.com,dhillf@gmail.com,fengguang.wu@intel.com,hughd@google.com,jack@suse.cz,mgorman@suse.de,viro@zeniv.linux.org.uk,willy@linux.intel.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 13 Sep 2013 13:03:00 -0700


The patch titled
     Subject: thp: do_huge_pmd_anonymous_page() cleanup
has been removed from the -mm tree.  Its filename was
     thp-do_huge_pmd_anonymous_page-cleanup.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: thp: do_huge_pmd_anonymous_page() cleanup

Minor cleanup: unindent most code of the fucntion by inverting one
condition.  It's preparation for the next patch.

No functional changes.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Acked-by: Hillf Danton <dhillf@gmail.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Hugh Dickins <hughd@google.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Matthew Wilcox <willy@linux.intel.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |   83 ++++++++++++++++++++++-----------------------
 1 file changed, 41 insertions(+), 42 deletions(-)

diff -puN mm/huge_memory.c~thp-do_huge_pmd_anonymous_page-cleanup mm/huge_memory.c
--- a/mm/huge_memory.c~thp-do_huge_pmd_anonymous_page-cleanup
+++ a/mm/huge_memory.c
@@ -785,55 +785,54 @@ int do_huge_pmd_anonymous_page(struct mm
 	unsigned long haddr = address & HPAGE_PMD_MASK;
 	pte_t *pte;
 
-	if (haddr >= vma->vm_start && haddr + HPAGE_PMD_SIZE <= vma->vm_end) {
-		if (unlikely(anon_vma_prepare(vma)))
+	if (haddr < vma->vm_start || haddr + HPAGE_PMD_SIZE > vma->vm_end)
+		goto out;
+	if (unlikely(anon_vma_prepare(vma)))
+		return VM_FAULT_OOM;
+	if (unlikely(khugepaged_enter(vma)))
+		return VM_FAULT_OOM;
+	if (!(flags & FAULT_FLAG_WRITE) &&
+			transparent_hugepage_use_zero_page()) {
+		pgtable_t pgtable;
+		struct page *zero_page;
+		bool set;
+		pgtable = pte_alloc_one(mm, haddr);
+		if (unlikely(!pgtable))
 			return VM_FAULT_OOM;
-		if (unlikely(khugepaged_enter(vma)))
-			return VM_FAULT_OOM;
-		if (!(flags & FAULT_FLAG_WRITE) &&
-				transparent_hugepage_use_zero_page()) {
-			pgtable_t pgtable;
-			struct page *zero_page;
-			bool set;
-			pgtable = pte_alloc_one(mm, haddr);
-			if (unlikely(!pgtable))
-				return VM_FAULT_OOM;
-			zero_page = get_huge_zero_page();
-			if (unlikely(!zero_page)) {
-				pte_free(mm, pgtable);
-				count_vm_event(THP_FAULT_FALLBACK);
-				goto out;
-			}
-			spin_lock(&mm->page_table_lock);
-			set = set_huge_zero_page(pgtable, mm, vma, haddr, pmd,
-					zero_page);
-			spin_unlock(&mm->page_table_lock);
-			if (!set) {
-				pte_free(mm, pgtable);
-				put_huge_zero_page();
-			}
-			return 0;
-		}
-		page = alloc_hugepage_vma(transparent_hugepage_defrag(vma),
-					  vma, haddr, numa_node_id(), 0);
-		if (unlikely(!page)) {
+		zero_page = get_huge_zero_page();
+		if (unlikely(!zero_page)) {
+			pte_free(mm, pgtable);
 			count_vm_event(THP_FAULT_FALLBACK);
 			goto out;
 		}
-		count_vm_event(THP_FAULT_ALLOC);
-		if (unlikely(mem_cgroup_newpage_charge(page, mm, GFP_KERNEL))) {
-			put_page(page);
-			goto out;
-		}
-		if (unlikely(__do_huge_pmd_anonymous_page(mm, vma, haddr, pmd,
-							  page))) {
-			mem_cgroup_uncharge_page(page);
-			put_page(page);
-			goto out;
+		spin_lock(&mm->page_table_lock);
+		set = set_huge_zero_page(pgtable, mm, vma, haddr, pmd,
+				zero_page);
+		spin_unlock(&mm->page_table_lock);
+		if (!set) {
+			pte_free(mm, pgtable);
+			put_huge_zero_page();
 		}
-
 		return 0;
 	}
+	page = alloc_hugepage_vma(transparent_hugepage_defrag(vma),
+			vma, haddr, numa_node_id(), 0);
+	if (unlikely(!page)) {
+		count_vm_event(THP_FAULT_FALLBACK);
+		goto out;
+	}
+	count_vm_event(THP_FAULT_ALLOC);
+	if (unlikely(mem_cgroup_newpage_charge(page, mm, GFP_KERNEL))) {
+		put_page(page);
+		goto out;
+	}
+	if (unlikely(__do_huge_pmd_anonymous_page(mm, vma, haddr, pmd, page))) {
+		mem_cgroup_uncharge_page(page);
+		put_page(page);
+		goto out;
+	}
+
+	return 0;
 out:
 	/*
 	 * Use __pte_alloc instead of pte_alloc_map, because we can't
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are

origin.patch
thp-mm-locking-tail-page-is-a-bug.patch
thp-mm-locking-tail-page-is-a-bug-fix.patch
mm-drop-actor-argument-of-do_generic_file_read.patch
mm-drop-actor-argument-of-do_generic_file_read-fix.patch

