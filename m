From: akpm@linux-foundation.org
Subject: [merged] thp-allocate-memory-in-khugepaged-outside-of-mmap_sem-write-mode.patch removed from -mm tree
Date: Fri, 14 Jan 2011 14:48:07 -0800
Message-ID: <201101142250.p0EMovhl005454@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41666 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752915Ab1ANWvF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 14 Jan 2011 17:51:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, mm-commits@vger.kernel.org


The patch titled
     thp: allocate memory in khugepaged outside of mmap_sem write mode
has been removed from the -mm tree.  Its filename was
     thp-allocate-memory-in-khugepaged-outside-of-mmap_sem-write-mode.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: thp: allocate memory in khugepaged outside of mmap_sem write mode
From: Andrea Arcangeli <aarcange@redhat.com>

This tries to be more friendly to filesystem in userland, with userland
backends that allocate memory in the I/O paths and that could deadlock if
khugepaged holds the mmap_sem write mode of the userland backend while
allocating memory.  Memory allocation may wait for writeback I/O
completion from the daemon that may be blocked in the mmap_sem read mode
if a page fault happens and the daemon wasn't using mlock for the memory
required for the I/O submission and completion.

Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |   56 +++++++++++++++++++++++++++------------------
 1 file changed, 34 insertions(+), 22 deletions(-)

diff -puN mm/huge_memory.c~thp-allocate-memory-in-khugepaged-outside-of-mmap_sem-write-mode mm/huge_memory.c
--- a/mm/huge_memory.c~thp-allocate-memory-in-khugepaged-outside-of-mmap_sem-write-mode
+++ a/mm/huge_memory.c
@@ -1664,9 +1664,9 @@ static void __collapse_huge_page_copy(pt
 
 static void collapse_huge_page(struct mm_struct *mm,
 			       unsigned long address,
-			       struct page **hpage)
+			       struct page **hpage,
+			       struct vm_area_struct *vma)
 {
-	struct vm_area_struct *vma;
 	pgd_t *pgd;
 	pud_t *pud;
 	pmd_t *pmd, _pmd;
@@ -1680,9 +1680,34 @@ static void collapse_huge_page(struct mm
 	VM_BUG_ON(address & ~HPAGE_PMD_MASK);
 #ifndef CONFIG_NUMA
 	VM_BUG_ON(!*hpage);
+	new_page = *hpage;
 #else
 	VM_BUG_ON(*hpage);
+	/*
+	 * Allocate the page while the vma is still valid and under
+	 * the mmap_sem read mode so there is no memory allocation
+	 * later when we take the mmap_sem in write mode. This is more
+	 * friendly behavior (OTOH it may actually hide bugs) to
+	 * filesystems in userland with daemons allocating memory in
+	 * the userland I/O paths.  Allocating memory with the
+	 * mmap_sem in read mode is good idea also to allow greater
+	 * scalability.
+	 */
+	new_page = alloc_hugepage_vma(khugepaged_defrag(), vma, address);
+	if (unlikely(!new_page)) {
+		up_read(&mm->mmap_sem);
+		*hpage = ERR_PTR(-ENOMEM);
+		return;
+	}
 #endif
+	if (unlikely(mem_cgroup_newpage_charge(new_page, mm, GFP_KERNEL))) {
+		up_read(&mm->mmap_sem);
+		put_page(new_page);
+		return;
+	}
+
+	/* after allocating the hugepage upgrade to mmap_sem write mode */
+	up_read(&mm->mmap_sem);
 
 	/*
 	 * Prevent all access to pagetables with the exception of
@@ -1720,18 +1745,6 @@ static void collapse_huge_page(struct mm
 	if (!pmd_present(*pmd) || pmd_trans_huge(*pmd))
 		goto out;
 
-#ifndef CONFIG_NUMA
-	new_page = *hpage;
-#else
-	new_page = alloc_hugepage_vma(khugepaged_defrag(), vma, address);
-	if (unlikely(!new_page)) {
-		*hpage = ERR_PTR(-ENOMEM);
-		goto out;
-	}
-#endif
-	if (unlikely(mem_cgroup_newpage_charge(new_page, mm, GFP_KERNEL)))
-		goto out_put_page;
-
 	anon_vma_lock(vma->anon_vma);
 
 	pte = pte_offset_map(pmd, address);
@@ -1759,7 +1772,7 @@ static void collapse_huge_page(struct mm
 		spin_unlock(&mm->page_table_lock);
 		anon_vma_unlock(vma->anon_vma);
 		mem_cgroup_uncharge_page(new_page);
-		goto out_put_page;
+		goto out;
 	}
 
 	/*
@@ -1798,15 +1811,15 @@ static void collapse_huge_page(struct mm
 	*hpage = NULL;
 #endif
 	khugepaged_pages_collapsed++;
-out:
+out_up_write:
 	up_write(&mm->mmap_sem);
 	return;
 
-out_put_page:
+out:
 #ifdef CONFIG_NUMA
 	put_page(new_page);
 #endif
-	goto out;
+	goto out_up_write;
 }
 
 static int khugepaged_scan_pmd(struct mm_struct *mm,
@@ -1865,10 +1878,9 @@ static int khugepaged_scan_pmd(struct mm
 		ret = 1;
 out_unmap:
 	pte_unmap_unlock(pte, ptl);
-	if (ret) {
-		up_read(&mm->mmap_sem);
-		collapse_huge_page(mm, address, hpage);
-	}
+	if (ret)
+		/* collapse_huge_page will return with the mmap_sem released */
+		collapse_huge_page(mm, address, hpage, vma);
 out:
 	return ret;
 }
_

Patches currently in -mm which might be from aarcange@redhat.com are

origin.patch
thp-add-pagetranscompound.patch

