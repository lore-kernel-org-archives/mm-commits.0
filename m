From: akpm@linux-foundation.org
Subject: [merged] mm-introduce-do_cow_fault.patch removed from -mm tree
Date: Fri, 04 Apr 2014 12:31:58 -0700
Message-ID: <533f08ae.eaZVCFc0gh/6Xz0I%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43096 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753984AbaDDTb7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 Apr 2014 15:31:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, riel@redhat.com, n-horiguchi@ah.jp.nec.com, mgorman@suse.de, matthew.r.wilcox@intel.com, dave.hansen@linux.intel.com, ak@linux.intel.com, kirill.shutemov@linux.intel.com

Subject: [merged] mm-introduce-do_cow_fault.patch removed from -mm tree
To: kirill.shutemov@linux.intel.com,ak@linux.intel.com,dave.hansen@linux.intel.com,matthew.r.wilcox@intel.com,mgorman@suse.de,n-horiguchi@ah.jp.nec.com,riel@redhat.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 04 Apr 2014 12:31:58 -0700


The patch titled
     Subject: mm: introduce do_cow_fault()
has been removed from the -mm tree.  Its filename was
     mm-introduce-do_cow_fault.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: mm: introduce do_cow_fault()

Introduce do_cow_fault().  The function does what do_fault() does for
write page faults to private mappings.

Unlike do_fault(), do_read_fault() is relatively clean and
straight-forward.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Rik van Riel <riel@redhat.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Matthew Wilcox <matthew.r.wilcox@intel.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |   62 ++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 62 insertions(+)

diff -puN mm/memory.c~mm-introduce-do_cow_fault mm/memory.c
--- a/mm/memory.c~mm-introduce-do_cow_fault
+++ a/mm/memory.c
@@ -3354,6 +3354,62 @@ static int do_read_fault(struct mm_struc
 	return ret;
 }
 
+static int do_cow_fault(struct mm_struct *mm, struct vm_area_struct *vma,
+		unsigned long address, pmd_t *pmd,
+		pgoff_t pgoff, unsigned int flags, pte_t orig_pte)
+{
+	struct page *fault_page, *new_page;
+	spinlock_t *ptl;
+	pte_t entry, *pte;
+	int ret;
+
+	if (unlikely(anon_vma_prepare(vma)))
+		return VM_FAULT_OOM;
+
+	new_page = alloc_page_vma(GFP_HIGHUSER_MOVABLE, vma, address);
+	if (!new_page)
+		return VM_FAULT_OOM;
+
+	if (mem_cgroup_newpage_charge(new_page, mm, GFP_KERNEL)) {
+		page_cache_release(new_page);
+		return VM_FAULT_OOM;
+	}
+
+	ret = __do_fault(vma, address, pgoff, flags, &fault_page);
+	if (unlikely(ret & (VM_FAULT_ERROR | VM_FAULT_NOPAGE | VM_FAULT_RETRY)))
+		goto uncharge_out;
+
+	copy_user_highpage(new_page, fault_page, address, vma);
+	__SetPageUptodate(new_page);
+
+	pte = pte_offset_map_lock(mm, pmd, address, &ptl);
+	if (unlikely(!pte_same(*pte, orig_pte))) {
+		pte_unmap_unlock(pte, ptl);
+		unlock_page(fault_page);
+		page_cache_release(fault_page);
+		goto uncharge_out;
+	}
+
+	flush_icache_page(vma, new_page);
+	entry = mk_pte(new_page, vma->vm_page_prot);
+	entry = maybe_mkwrite(pte_mkdirty(entry), vma);
+	inc_mm_counter_fast(mm, MM_ANONPAGES);
+	page_add_new_anon_rmap(new_page, vma, address);
+	set_pte_at(mm, address, pte, entry);
+
+	/* no need to invalidate: a not-present page won't be cached */
+	update_mmu_cache(vma, address, pte);
+
+	pte_unmap_unlock(pte, ptl);
+	unlock_page(fault_page);
+	page_cache_release(fault_page);
+	return ret;
+uncharge_out:
+	mem_cgroup_uncharge_page(new_page);
+	page_cache_release(new_page);
+	return ret;
+}
+
 /*
  * do_fault() tries to create a new page mapping. It aggressively
  * tries to share with existing pages, but makes a separate copy if
@@ -3550,6 +3606,9 @@ static int do_linear_fault(struct mm_str
 	if (!(flags & FAULT_FLAG_WRITE))
 		return do_read_fault(mm, vma, address, pmd, pgoff, flags,
 				orig_pte);
+	if (!(vma->vm_flags & VM_SHARED))
+		return do_cow_fault(mm, vma, address, pmd, pgoff, flags,
+				orig_pte);
 	return do_fault(mm, vma, address, pmd, pgoff, flags, orig_pte);
 }
 
@@ -3585,6 +3644,9 @@ static int do_nonlinear_fault(struct mm_
 	if (!(flags & FAULT_FLAG_WRITE))
 		return do_read_fault(mm, vma, address, pmd, pgoff, flags,
 				orig_pte);
+	if (!(vma->vm_flags & VM_SHARED))
+		return do_cow_fault(mm, vma, address, pmd, pgoff, flags,
+				orig_pte);
 	return do_fault(mm, vma, address, pmd, pgoff, flags, orig_pte);
 }
 
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are

origin.patch
pagewalk-update-page-table-walker-core.patch
pagewalk-add-walk_page_vma.patch
smaps-redefine-callback-functions-for-page-table-walker.patch
clear_refs-redefine-callback-functions-for-page-table-walker.patch
pagemap-redefine-callback-functions-for-page-table-walker.patch
numa_maps-redefine-callback-functions-for-page-table-walker.patch
memcg-redefine-callback-functions-for-page-table-walker.patch
arch-powerpc-mm-subpage-protc-use-walk_page_vma-instead-of-walk_page_range.patch
pagewalk-remove-argument-hmask-from-hugetlb_entry.patch
mempolicy-apply-page-table-walker-on-queue_pages_range.patch
mm-introduce-do_shared_fault-and-drop-do_fault-fix-fix.patch
mm-revert-thp-make-madv_hugepage-check-for-mm-def_flags.patch
mm-revert-thp-make-madv_hugepage-check-for-mm-def_flags-ignore-madv_hugepage-on-s390-to-prevent-sigsegv-in-qemu.patch
mm-thp-add-vm_init_def_mask-and-prctl_thp_disable.patch
exec-kill-the-unnecessary-mm-def_flags-setting-in-load_elf_binary.patch
mm-disable-split-page-table-lock-for-mmu.patch
drivers-lguest-page_tablesc-rename-do_set_pte.patch
mm-introduce-vm_ops-map_pages.patch
mm-introduce-vm_ops-map_pages-fix.patch
mm-implement-map_pages-for-page-cache.patch
mm-implement-map_pages-for-page-cache-fix.patch
mm-cleanup-size-checks-in-filemap_fault-and-filemap_map_pages.patch
mm-add-debugfs-tunable-for-fault_around_order.patch
mm-add-debugfs-tunable-for-fault_around_order-checkpatch-fixes.patch
mm-use-const-char-insted-of-char-for-reason-in-dump_page.patch
do_shared_fault-check-that-mmap_sem-is-held.patch

