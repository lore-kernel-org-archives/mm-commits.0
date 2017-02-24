From: akpm@linux-foundation.org
Subject: [patch 051/124] mm, uprobes: convert __replace_page() to use
 page_vma_mapped_walk()
Date: Fri, 24 Feb 2017 14:58:07 -0800
Message-ID: <58b0ba7f.niIn/EBqTOutEWu9%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38326 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751486AbdBXW6J (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 24 Feb 2017 17:58:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, kirill.shutemov@linux.intel.com, aarcange@redhat.com, hannes@cmpxchg.org, hillf.zj@alibaba-inc.com, hughd@google.com, oleg@redhat.com, peterz@infradead.org, riel@redhat.com, srikar@linux.vnet.ibm.com, vdavydov.dev@gmail.com

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
