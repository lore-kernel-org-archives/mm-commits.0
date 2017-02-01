From: akpm@linux-foundation.org
Subject: +
 mm-uprobes-convert-__replace_page-to-use-page_vma_mapped_walk.patch added
 to -mm tree
Date: Tue, 31 Jan 2017 16:10:22 -0800
Message-ID: <5891276e.S9IXvh7wp/y2lFNM%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36208 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751061AbdBAAKh (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 31 Jan 2017 19:10:37 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill.shutemov@linux.intel.com, aarcange@redhat.com, hannes@cmpxchg.org, hillf.zj@alibaba-inc.com, hughd@google.com, oleg@redhat.com, peterz@infradead.org, riel@redhat.com, srikar@linux.vnet.ibm.com, vdavydov.dev@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, uprobes: convert __replace_page() to use page_vma_mapped_walk()
has been added to the -mm tree.  Its filename is
     mm-uprobes-convert-__replace_page-to-use-page_vma_mapped_walk.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-uprobes-convert-__replace_page-to-use-page_vma_mapped_walk.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-uprobes-convert-__replace_page-to-use-page_vma_mapped_walk.patch

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
Subject: mm, uprobes: convert __replace_page() to use page_vma_mapped_walk()

For consistency, it worth converting all page_check_address() to
page_vma_mapped_walk(), so we could drop the former.

Link: http://lkml.kernel.org/r/20170129173858.45174-10-kirill.shutemov@linux.intel.com
Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Reviewed-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Hillf Danton <hillf.zj@alibaba-inc.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Rik van Riel <riel@redhat.com>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/events/uprobes.c |   22 ++++++++++++++--------
 1 file changed, 14 insertions(+), 8 deletions(-)

diff -puN kernel/events/uprobes.c~mm-uprobes-convert-__replace_page-to-use-page_vma_mapped_walk kernel/events/uprobes.c
--- a/kernel/events/uprobes.c~mm-uprobes-convert-__replace_page-to-use-page_vma_mapped_walk
+++ a/kernel/events/uprobes.c
@@ -153,14 +153,19 @@ static int __replace_page(struct vm_area
 				struct page *old_page, struct page *new_page)
 {
 	struct mm_struct *mm = vma->vm_mm;
-	spinlock_t *ptl;
-	pte_t *ptep;
+	struct page_vma_mapped_walk pvmw = {
+		.page = old_page,
+		.vma = vma,
+		.address = addr,
+	};
 	int err;
 	/* For mmu_notifiers */
 	const unsigned long mmun_start = addr;
 	const unsigned long mmun_end   = addr + PAGE_SIZE;
 	struct mem_cgroup *memcg;
 
+	VM_BUG_ON_PAGE(PageTransHuge(old_page), old_page);
+
 	err = mem_cgroup_try_charge(new_page, vma->vm_mm, GFP_KERNEL, &memcg,
 			false);
 	if (err)
@@ -171,11 +176,11 @@ static int __replace_page(struct vm_area
 
 	mmu_notifier_invalidate_range_start(mm, mmun_start, mmun_end);
 	err = -EAGAIN;
-	ptep = page_check_address(old_page, mm, addr, &ptl, 0);
-	if (!ptep) {
+	if (!page_vma_mapped_walk(&pvmw)) {
 		mem_cgroup_cancel_charge(new_page, memcg, false);
 		goto unlock;
 	}
+	VM_BUG_ON_PAGE(addr != pvmw.address, old_page);
 
 	get_page(new_page);
 	page_add_new_anon_rmap(new_page, vma, addr, false);
@@ -187,14 +192,15 @@ static int __replace_page(struct vm_area
 		inc_mm_counter(mm, MM_ANONPAGES);
 	}
 
-	flush_cache_page(vma, addr, pte_pfn(*ptep));
-	ptep_clear_flush_notify(vma, addr, ptep);
-	set_pte_at_notify(mm, addr, ptep, mk_pte(new_page, vma->vm_page_prot));
+	flush_cache_page(vma, addr, pte_pfn(*pvmw.pte));
+	ptep_clear_flush_notify(vma, addr, pvmw.pte);
+	set_pte_at_notify(mm, addr, pvmw.pte,
+			mk_pte(new_page, vma->vm_page_prot));
 
 	page_remove_rmap(old_page, false);
 	if (!page_mapped(old_page))
 		try_to_free_swap(old_page);
-	pte_unmap_unlock(ptep, ptl);
+	page_vma_mapped_walk_done(&pvmw);
 
 	if (vma->vm_flags & VM_LOCKED)
 		munlock_vma_page(old_page);
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are

mm-sleeping-function-called-from-invalid-context-shmem_undo_range.patch
mm-drop-zap_details-ignore_dirty.patch
mm-drop-zap_details-check_swap_entries.patch
mm-drop-unused-argument-of-zap_page_range.patch
oom-reaper-use-madvise_dontneed-logic-to-decide-if-unmap-the-vma.patch
uprobes-split-thps-before-trying-replace-them.patch
mm-introduce-page_vma_mapped_walk.patch
mm-fix-handling-pte-mapped-thps-in-page_referenced.patch
mm-fix-handling-pte-mapped-thps-in-page_idle_clear_pte_refs.patch
mm-rmap-check-all-vmas-that-pte-mapped-thp-can-be-part-of.patch
mm-convert-page_mkclean_one-to-use-page_vma_mapped_walk.patch
mm-convert-try_to_unmap_one-to-use-page_vma_mapped_walk.patch
mm-ksm-convert-write_protect_page-to-use-page_vma_mapped_walk.patch
mm-uprobes-convert-__replace_page-to-use-page_vma_mapped_walk.patch
mm-convert-page_mapped_in_vma-to-use-page_vma_mapped_walk.patch
mm-drop-page_check_address_transhuge.patch
mm-convert-remove_migration_pte-to-use-page_vma_mapped_walk.patch

