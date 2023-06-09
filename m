Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78827C7EE25
	for <mm-commits@archiver.kernel.org>; Fri,  9 Jun 2023 20:12:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231244AbjFIUM2 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 9 Jun 2023 16:12:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231302AbjFIUMK (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 9 Jun 2023 16:12:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B5D21FF3
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 13:11:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BCE3765BB2
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 20:11:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 114B2C433EF;
        Fri,  9 Jun 2023 20:11:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1686341514;
        bh=A8fTeSZxDlp+IB6jKBzsxXhZ7qO5OvTdHMR/YeoiR10=;
        h=Date:To:From:Subject:From;
        b=DFlBTiGRhoXDM+83MwNZVfDbYSL4adWoCm+jT+xkQ02Jc84ADqW72eLku68QRV4iP
         x/beO4y5v85Sg4/YIKKKl2RALRKUZs0Iz8O61GG8j3nQ8YzODOxlFMIC4+wnmKtpML
         UO9wkvTmwQuM/1raXoWYD7Vr7/ZeaomO43jIcLVI=
Date:   Fri, 09 Jun 2023 13:11:53 -0700
To:     mm-commits@vger.kernel.org, zhengqi.arch@bytedance.com,
        zackr@vmware.com, yuzhao@google.com, ying.huang@intel.com,
        willy@infradead.org, will@kernel.org,
        thomas.hellstrom@linux.intel.com, surenb@google.com,
        steven.price@arm.com, song@kernel.org, sj@kernel.org,
        shy828301@gmail.com, ryan.roberts@arm.com, rppt@kernel.org,
        rcampbell@nvidia.com, peterz@infradead.org, peterx@redhat.com,
        pasha.tatashin@soleen.com, naoya.horiguchi@nec.com,
        minchan@kernel.org, mike.kravetz@oracle.com,
        mgorman@techsingularity.net, lstoakes@gmail.com,
        linmiaohe@huawei.com, kirill.shutemov@linux.intel.com,
        jgg@ziepe.ca, ira.weiny@intel.com, hch@infradead.org,
        david@redhat.com, christophe.leroy@csgroup.eu,
        axelrasmussen@google.com, apopple@nvidia.com,
        anshuman.khandual@arm.com, hughd@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memory-allow-pte_offset_map-to-fail.patch added to mm-unstable branch
Message-Id: <20230609201154.114B2C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memory: allow pte_offset_map[_lock]() to fail
has been added to the -mm mm-unstable branch.  Its filename is
     mm-memory-allow-pte_offset_map-to-fail.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memory-allow-pte_offset_map-to-fail.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: mm/memory: allow pte_offset_map[_lock]() to fail
Date: Thu, 8 Jun 2023 18:43:38 -0700 (PDT)

copy_pte_range(): use pte_offset_map_nolock(), and allow for it to fail;
but with a comment on some further assumptions that are being made there.

zap_pte_range() and zap_pmd_range(): adjust their interaction so that a
pte_offset_map_lock() failure in zap_pte_range() leads to a retry in
zap_pmd_range(); remove call to pmd_none_or_trans_huge_or_clear_bad().

Allow pte_offset_map_lock() to fail in many functions.  Update comment on
calling pte_alloc() in do_anonymous_page().  Remove redundant calls to
pmd_trans_unstable(), pmd_devmap_trans_unstable(), pmd_none() and
pmd_bad(); but leave pmd_none_or_clear_bad() calls in free_pmd_range() and
copy_pmd_range(), those do simplify the next level down.

Link: https://lkml.kernel.org/r/bb548d50-e99a-f29e-eab1-a43bef2a1287@google.com
Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Ira Weiny <ira.weiny@intel.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Lorenzo Stoakes <lstoakes@gmail.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Mike Rapoport (IBM) <rppt@kernel.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Naoya Horiguchi <naoya.horiguchi@nec.com>
Cc: Pavel Tatashin <pasha.tatashin@soleen.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: Ralph Campbell <rcampbell@nvidia.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: SeongJae Park <sj@kernel.org>
Cc: Song Liu <song@kernel.org>
Cc: Steven Price <steven.price@arm.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Cc: Will Deacon <will@kernel.org>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Yu Zhao <yuzhao@google.com>
Cc: Zack Rusin <zackr@vmware.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |  167 ++++++++++++++++++++++++--------------------------
 1 file changed, 81 insertions(+), 86 deletions(-)

--- a/mm/memory.c~mm-memory-allow-pte_offset_map-to-fail
+++ a/mm/memory.c
@@ -1010,13 +1010,25 @@ again:
 	progress = 0;
 	init_rss_vec(rss);
 
+	/*
+	 * copy_pmd_range()'s prior pmd_none_or_clear_bad(src_pmd), and the
+	 * error handling here, assume that exclusive mmap_lock on dst and src
+	 * protects anon from unexpected THP transitions; with shmem and file
+	 * protected by mmap_lock-less collapse skipping areas with anon_vma
+	 * (whereas vma_needs_copy() skips areas without anon_vma).  A rework
+	 * can remove such assumptions later, but this is good enough for now.
+	 */
 	dst_pte = pte_alloc_map_lock(dst_mm, dst_pmd, addr, &dst_ptl);
 	if (!dst_pte) {
 		ret = -ENOMEM;
 		goto out;
 	}
-	src_pte = pte_offset_map(src_pmd, addr);
-	src_ptl = pte_lockptr(src_mm, src_pmd);
+	src_pte = pte_offset_map_nolock(src_mm, src_pmd, addr, &src_ptl);
+	if (!src_pte) {
+		pte_unmap_unlock(dst_pte, dst_ptl);
+		/* ret == 0 */
+		goto out;
+	}
 	spin_lock_nested(src_ptl, SINGLE_DEPTH_NESTING);
 	orig_src_pte = src_pte;
 	orig_dst_pte = dst_pte;
@@ -1081,8 +1093,7 @@ again:
 	} while (dst_pte++, src_pte++, addr += PAGE_SIZE, addr != end);
 
 	arch_leave_lazy_mmu_mode();
-	spin_unlock(src_ptl);
-	pte_unmap(orig_src_pte);
+	pte_unmap_unlock(orig_src_pte, src_ptl);
 	add_mm_rss_vec(dst_mm, rss);
 	pte_unmap_unlock(orig_dst_pte, dst_ptl);
 	cond_resched();
@@ -1386,10 +1397,11 @@ static unsigned long zap_pte_range(struc
 	swp_entry_t entry;
 
 	tlb_change_page_size(tlb, PAGE_SIZE);
-again:
 	init_rss_vec(rss);
-	start_pte = pte_offset_map_lock(mm, pmd, addr, &ptl);
-	pte = start_pte;
+	start_pte = pte = pte_offset_map_lock(mm, pmd, addr, &ptl);
+	if (!pte)
+		return addr;
+
 	flush_tlb_batched_pending(mm);
 	arch_enter_lazy_mmu_mode();
 	do {
@@ -1505,17 +1517,10 @@ again:
 	 * If we forced a TLB flush (either due to running out of
 	 * batch buffers or because we needed to flush dirty TLB
 	 * entries before releasing the ptl), free the batched
-	 * memory too. Restart if we didn't do everything.
+	 * memory too. Come back again if we didn't do everything.
 	 */
-	if (force_flush) {
-		force_flush = 0;
+	if (force_flush)
 		tlb_flush_mmu(tlb);
-	}
-
-	if (addr != end) {
-		cond_resched();
-		goto again;
-	}
 
 	return addr;
 }
@@ -1534,8 +1539,10 @@ static inline unsigned long zap_pmd_rang
 		if (is_swap_pmd(*pmd) || pmd_trans_huge(*pmd) || pmd_devmap(*pmd)) {
 			if (next - addr != HPAGE_PMD_SIZE)
 				__split_huge_pmd(vma, pmd, addr, false, NULL);
-			else if (zap_huge_pmd(tlb, vma, pmd, addr))
-				goto next;
+			else if (zap_huge_pmd(tlb, vma, pmd, addr)) {
+				addr = next;
+				continue;
+			}
 			/* fall through */
 		} else if (details && details->single_folio &&
 			   folio_test_pmd_mappable(details->single_folio) &&
@@ -1548,20 +1555,14 @@ static inline unsigned long zap_pmd_rang
 			 */
 			spin_unlock(ptl);
 		}
-
-		/*
-		 * Here there can be other concurrent MADV_DONTNEED or
-		 * trans huge page faults running, and if the pmd is
-		 * none or trans huge it can change under us. This is
-		 * because MADV_DONTNEED holds the mmap_lock in read
-		 * mode.
-		 */
-		if (pmd_none_or_trans_huge_or_clear_bad(pmd))
-			goto next;
-		next = zap_pte_range(tlb, vma, pmd, addr, next, details);
-next:
-		cond_resched();
-	} while (pmd++, addr = next, addr != end);
+		if (pmd_none(*pmd)) {
+			addr = next;
+			continue;
+		}
+		addr = zap_pte_range(tlb, vma, pmd, addr, next, details);
+		if (addr != next)
+			pmd--;
+	} while (pmd++, cond_resched(), addr != end);
 
 	return addr;
 }
@@ -1903,6 +1904,10 @@ more:
 		const int batch_size = min_t(int, pages_to_write_in_pmd, 8);
 
 		start_pte = pte_offset_map_lock(mm, pmd, addr, &pte_lock);
+		if (!start_pte) {
+			ret = -EFAULT;
+			goto out;
+		}
 		for (pte = start_pte; pte_idx < batch_size; ++pte, ++pte_idx) {
 			int err = insert_page_in_batch_locked(vma, pte,
 				addr, pages[curr_page_idx], prot);
@@ -2573,10 +2578,10 @@ static int apply_to_pte_range(struct mm_
 		mapped_pte = pte = (mm == &init_mm) ?
 			pte_offset_kernel(pmd, addr) :
 			pte_offset_map_lock(mm, pmd, addr, &ptl);
+		if (!pte)
+			return -EINVAL;
 	}
 
-	BUG_ON(pmd_huge(*pmd));
-
 	arch_enter_lazy_mmu_mode();
 
 	if (fn) {
@@ -2805,7 +2810,6 @@ static inline int __wp_page_copy_user(st
 	int ret;
 	void *kaddr;
 	void __user *uaddr;
-	bool locked = false;
 	struct vm_area_struct *vma = vmf->vma;
 	struct mm_struct *mm = vma->vm_mm;
 	unsigned long addr = vmf->address;
@@ -2831,12 +2835,12 @@ static inline int __wp_page_copy_user(st
 	 * On architectures with software "accessed" bits, we would
 	 * take a double page fault, so mark it accessed here.
 	 */
+	vmf->pte = NULL;
 	if (!arch_has_hw_pte_young() && !pte_young(vmf->orig_pte)) {
 		pte_t entry;
 
 		vmf->pte = pte_offset_map_lock(mm, vmf->pmd, addr, &vmf->ptl);
-		locked = true;
-		if (!likely(pte_same(*vmf->pte, vmf->orig_pte))) {
+		if (unlikely(!vmf->pte || !pte_same(*vmf->pte, vmf->orig_pte))) {
 			/*
 			 * Other thread has already handled the fault
 			 * and update local tlb only
@@ -2858,13 +2862,12 @@ static inline int __wp_page_copy_user(st
 	 * zeroes.
 	 */
 	if (__copy_from_user_inatomic(kaddr, uaddr, PAGE_SIZE)) {
-		if (locked)
+		if (vmf->pte)
 			goto warn;
 
 		/* Re-validate under PTL if the page is still mapped */
 		vmf->pte = pte_offset_map_lock(mm, vmf->pmd, addr, &vmf->ptl);
-		locked = true;
-		if (!likely(pte_same(*vmf->pte, vmf->orig_pte))) {
+		if (unlikely(!vmf->pte || !pte_same(*vmf->pte, vmf->orig_pte))) {
 			/* The PTE changed under us, update local tlb */
 			update_mmu_tlb(vma, addr, vmf->pte);
 			ret = -EAGAIN;
@@ -2889,7 +2892,7 @@ warn:
 	ret = 0;
 
 pte_unlock:
-	if (locked)
+	if (vmf->pte)
 		pte_unmap_unlock(vmf->pte, vmf->ptl);
 	kunmap_atomic(kaddr);
 	flush_dcache_page(dst);
@@ -3111,7 +3114,7 @@ static vm_fault_t wp_page_copy(struct vm
 	 * Re-check the pte - we dropped the lock
 	 */
 	vmf->pte = pte_offset_map_lock(mm, vmf->pmd, vmf->address, &vmf->ptl);
-	if (likely(pte_same(*vmf->pte, vmf->orig_pte))) {
+	if (likely(vmf->pte && pte_same(*vmf->pte, vmf->orig_pte))) {
 		if (old_folio) {
 			if (!folio_test_anon(old_folio)) {
 				dec_mm_counter(mm, mm_counter_file(&old_folio->page));
@@ -3179,19 +3182,20 @@ static vm_fault_t wp_page_copy(struct vm
 		/* Free the old page.. */
 		new_folio = old_folio;
 		page_copied = 1;
-	} else {
+		pte_unmap_unlock(vmf->pte, vmf->ptl);
+	} else if (vmf->pte) {
 		update_mmu_tlb(vma, vmf->address, vmf->pte);
+		pte_unmap_unlock(vmf->pte, vmf->ptl);
 	}
 
-	if (new_folio)
-		folio_put(new_folio);
-
-	pte_unmap_unlock(vmf->pte, vmf->ptl);
 	/*
 	 * No need to double call mmu_notifier->invalidate_range() callback as
 	 * the above ptep_clear_flush_notify() did already call it.
 	 */
 	mmu_notifier_invalidate_range_only_end(&range);
+
+	if (new_folio)
+		folio_put(new_folio);
 	if (old_folio) {
 		if (page_copied)
 			free_swap_cache(&old_folio->page);
@@ -3231,6 +3235,8 @@ vm_fault_t finish_mkwrite_fault(struct v
 	WARN_ON_ONCE(!(vmf->vma->vm_flags & VM_SHARED));
 	vmf->pte = pte_offset_map_lock(vmf->vma->vm_mm, vmf->pmd, vmf->address,
 				       &vmf->ptl);
+	if (!vmf->pte)
+		return VM_FAULT_NOPAGE;
 	/*
 	 * We might have raced with another page fault while we released the
 	 * pte_offset_map_lock.
@@ -3592,10 +3598,11 @@ static vm_fault_t remove_device_exclusiv
 
 	vmf->pte = pte_offset_map_lock(vma->vm_mm, vmf->pmd, vmf->address,
 				&vmf->ptl);
-	if (likely(pte_same(*vmf->pte, vmf->orig_pte)))
+	if (likely(vmf->pte && pte_same(*vmf->pte, vmf->orig_pte)))
 		restore_exclusive_pte(vma, vmf->page, vmf->address, vmf->pte);
 
-	pte_unmap_unlock(vmf->pte, vmf->ptl);
+	if (vmf->pte)
+		pte_unmap_unlock(vmf->pte, vmf->ptl);
 	folio_unlock(folio);
 	folio_put(folio);
 
@@ -3626,6 +3633,8 @@ static vm_fault_t pte_marker_clear(struc
 {
 	vmf->pte = pte_offset_map_lock(vmf->vma->vm_mm, vmf->pmd,
 				       vmf->address, &vmf->ptl);
+	if (!vmf->pte)
+		return 0;
 	/*
 	 * Be careful so that we will only recover a special uffd-wp pte into a
 	 * none pte.  Otherwise it means the pte could have changed, so retry.
@@ -3729,7 +3738,8 @@ vm_fault_t do_swap_page(struct vm_fault
 			vmf->page = pfn_swap_entry_to_page(entry);
 			vmf->pte = pte_offset_map_lock(vma->vm_mm, vmf->pmd,
 					vmf->address, &vmf->ptl);
-			if (unlikely(!pte_same(*vmf->pte, vmf->orig_pte)))
+			if (unlikely(!vmf->pte ||
+				     !pte_same(*vmf->pte, vmf->orig_pte)))
 				goto unlock;
 
 			/*
@@ -3806,7 +3816,7 @@ vm_fault_t do_swap_page(struct vm_fault
 			 */
 			vmf->pte = pte_offset_map_lock(vma->vm_mm, vmf->pmd,
 					vmf->address, &vmf->ptl);
-			if (likely(pte_same(*vmf->pte, vmf->orig_pte)))
+			if (likely(vmf->pte && pte_same(*vmf->pte, vmf->orig_pte)))
 				ret = VM_FAULT_OOM;
 			goto unlock;
 		}
@@ -3876,7 +3886,7 @@ vm_fault_t do_swap_page(struct vm_fault
 	 */
 	vmf->pte = pte_offset_map_lock(vma->vm_mm, vmf->pmd, vmf->address,
 			&vmf->ptl);
-	if (unlikely(!pte_same(*vmf->pte, vmf->orig_pte)))
+	if (unlikely(!vmf->pte || !pte_same(*vmf->pte, vmf->orig_pte)))
 		goto out_nomap;
 
 	if (unlikely(!folio_test_uptodate(folio))) {
@@ -4002,13 +4012,15 @@ vm_fault_t do_swap_page(struct vm_fault
 	/* No need to invalidate - it was non-present before */
 	update_mmu_cache(vma, vmf->address, vmf->pte);
 unlock:
-	pte_unmap_unlock(vmf->pte, vmf->ptl);
+	if (vmf->pte)
+		pte_unmap_unlock(vmf->pte, vmf->ptl);
 out:
 	if (si)
 		put_swap_device(si);
 	return ret;
 out_nomap:
-	pte_unmap_unlock(vmf->pte, vmf->ptl);
+	if (vmf->pte)
+		pte_unmap_unlock(vmf->pte, vmf->ptl);
 out_page:
 	folio_unlock(folio);
 out_release:
@@ -4040,22 +4052,12 @@ static vm_fault_t do_anonymous_page(stru
 		return VM_FAULT_SIGBUS;
 
 	/*
-	 * Use pte_alloc() instead of pte_alloc_map().  We can't run
-	 * pte_offset_map() on pmds where a huge pmd might be created
-	 * from a different thread.
-	 *
-	 * pte_alloc_map() is safe to use under mmap_write_lock(mm) or when
-	 * parallel threads are excluded by other means.
-	 *
-	 * Here we only have mmap_read_lock(mm).
+	 * Use pte_alloc() instead of pte_alloc_map(), so that OOM can
+	 * be distinguished from a transient failure of pte_offset_map().
 	 */
 	if (pte_alloc(vma->vm_mm, vmf->pmd))
 		return VM_FAULT_OOM;
 
-	/* See comment in handle_pte_fault() */
-	if (unlikely(pmd_trans_unstable(vmf->pmd)))
-		return 0;
-
 	/* Use the zero-page for reads */
 	if (!(vmf->flags & FAULT_FLAG_WRITE) &&
 			!mm_forbids_zeropage(vma->vm_mm)) {
@@ -4063,6 +4065,8 @@ static vm_fault_t do_anonymous_page(stru
 						vma->vm_page_prot));
 		vmf->pte = pte_offset_map_lock(vma->vm_mm, vmf->pmd,
 				vmf->address, &vmf->ptl);
+		if (!vmf->pte)
+			goto unlock;
 		if (vmf_pte_changed(vmf)) {
 			update_mmu_tlb(vma, vmf->address, vmf->pte);
 			goto unlock;
@@ -4103,6 +4107,8 @@ static vm_fault_t do_anonymous_page(stru
 
 	vmf->pte = pte_offset_map_lock(vma->vm_mm, vmf->pmd, vmf->address,
 			&vmf->ptl);
+	if (!vmf->pte)
+		goto release;
 	if (vmf_pte_changed(vmf)) {
 		update_mmu_tlb(vma, vmf->address, vmf->pte);
 		goto release;
@@ -4130,7 +4136,8 @@ setpte:
 	/* No need to invalidate - it was non-present before */
 	update_mmu_cache(vma, vmf->address, vmf->pte);
 unlock:
-	pte_unmap_unlock(vmf->pte, vmf->ptl);
+	if (vmf->pte)
+		pte_unmap_unlock(vmf->pte, vmf->ptl);
 	return ret;
 release:
 	folio_put(folio);
@@ -4379,15 +4386,10 @@ vm_fault_t finish_fault(struct vm_fault
 			return VM_FAULT_OOM;
 	}
 
-	/*
-	 * See comment in handle_pte_fault() for how this scenario happens, we
-	 * need to return NOPAGE so that we drop this page.
-	 */
-	if (pmd_devmap_trans_unstable(vmf->pmd))
-		return VM_FAULT_NOPAGE;
-
 	vmf->pte = pte_offset_map_lock(vma->vm_mm, vmf->pmd,
 				      vmf->address, &vmf->ptl);
+	if (!vmf->pte)
+		return VM_FAULT_NOPAGE;
 
 	/* Re-check under ptl */
 	if (likely(!vmf_pte_changed(vmf))) {
@@ -4629,17 +4631,11 @@ static vm_fault_t do_fault(struct vm_fau
 	 * The VMA was not fully populated on mmap() or missing VM_DONTEXPAND
 	 */
 	if (!vma->vm_ops->fault) {
-		/*
-		 * If we find a migration pmd entry or a none pmd entry, which
-		 * should never happen, return SIGBUS
-		 */
-		if (unlikely(!pmd_present(*vmf->pmd)))
+		vmf->pte = pte_offset_map_lock(vmf->vma->vm_mm, vmf->pmd,
+					       vmf->address, &vmf->ptl);
+		if (unlikely(!vmf->pte))
 			ret = VM_FAULT_SIGBUS;
 		else {
-			vmf->pte = pte_offset_map_lock(vmf->vma->vm_mm,
-						       vmf->pmd,
-						       vmf->address,
-						       &vmf->ptl);
 			/*
 			 * Make sure this is not a temporary clearing of pte
 			 * by holding ptl and checking again. A R/M/W update
@@ -5428,10 +5424,9 @@ int follow_pte(struct mm_struct *mm, uns
 	pmd = pmd_offset(pud, address);
 	VM_BUG_ON(pmd_trans_huge(*pmd));
 
-	if (pmd_none(*pmd) || unlikely(pmd_bad(*pmd)))
-		goto out;
-
 	ptep = pte_offset_map_lock(mm, pmd, address, ptlp);
+	if (!ptep)
+		goto out;
 	if (!pte_present(*ptep))
 		goto unlock;
 	*ptepp = ptep;
_

Patches currently in -mm which might be from hughd@google.com are

arm-allow-pte_offset_map-to-fail.patch
arm64-allow-pte_offset_map-to-fail.patch
arm64-hugetlb-pte_alloc_huge-pte_offset_huge.patch
ia64-hugetlb-pte_alloc_huge-pte_offset_huge.patch
m68k-allow-pte_offset_map-to-fail.patch
microblaze-allow-pte_offset_map-to-fail.patch
mips-update_mmu_cache-can-replace-__update_tlb.patch
mips-update_mmu_cache-can-replace-__update_tlb-fix.patch
parisc-add-pte_unmap-to-balance-get_ptep.patch
parisc-unmap_uncached_pte-use-pte_offset_kernel.patch
parisc-hugetlb-pte_alloc_huge-pte_offset_huge.patch
powerpc-kvmppc_unmap_free_pmd-pte_offset_kernel.patch
powerpc-allow-pte_offset_map-to-fail.patch
powerpc-hugetlb-pte_alloc_huge.patch
riscv-hugetlb-pte_alloc_huge-pte_offset_huge.patch
s390-allow-pte_offset_map_lock-to-fail.patch
s390-gmap-use-pte_unmap_unlock-not-spin_unlock.patch
sh-hugetlb-pte_alloc_huge-pte_offset_huge.patch
sparc-hugetlb-pte_alloc_huge-pte_offset_huge.patch
sparc-allow-pte_offset_map-to-fail.patch
sparc-iounit-and-iommu-use-pte_offset_kernel.patch
x86-allow-get_locked_pte-to-fail.patch
x86-sme_populate_pgd-use-pte_offset_kernel.patch
xtensa-add-pte_unmap-to-balance-pte_offset_map.patch
mm-use-pmdp_get_lockless-without-surplus-barrier.patch
mm-migrate-remove-cruft-from-migration_entry_waits.patch
mm-pgtable-kmap_local_page-instead-of-kmap_atomic.patch
mm-pgtable-allow-pte_offset_map-to-fail.patch
mm-filemap-allow-pte_offset_map_lock-to-fail.patch
mm-page_vma_mapped-delete-bogosity-in-page_vma_mapped_walk.patch
mm-page_vma_mapped-reformat-map_pte-with-less-indentation.patch
mm-page_vma_mapped-pte_offset_map_nolock-not-pte_lockptr.patch
mm-pagewalkers-action_again-if-pte_offset_map_lock-fails.patch
mm-pagewalk-walk_pte_range-allow-for-pte_offset_map.patch
mm-vmwgfx-simplify-pmd-pud-mapping-dirty-helpers.patch
mm-vmalloc-vmalloc_to_page-use-pte_offset_kernel.patch
mm-hmm-retry-if-pte_offset_map-fails.patch
mm-userfaultfd-retry-if-pte_offset_map-fails.patch
mm-userfaultfd-allow-pte_offset_map_lock-to-fail.patch
mm-debug_vm_pgtablepage_table_check-warn-pte-map-fails.patch
mm-various-give-up-if-pte_offset_map-fails.patch
mm-mprotect-delete-pmd_none_or_clear_bad_unless_trans_huge.patch
mm-mremap-retry-if-either-pte_offset_map_lock-fails.patch
mm-madvise-clean-up-pte_offset_map_lock-scans.patch
mm-madvise-clean-up-force_shm_swapin_readahead.patch
mm-swapoff-allow-pte_offset_map-to-fail.patch
mm-mglru-allow-pte_offset_map_nolock-to-fail.patch
mm-migrate_device-allow-pte_offset_map_lock-to-fail.patch
mm-gup-remove-foll_split_pmd-use-of-pmd_trans_unstable.patch
mm-huge_memory-split-huge-pmd-under-one-pte_offset_map.patch
mm-khugepaged-allow-pte_offset_map-to-fail.patch
mm-memory-allow-pte_offset_map-to-fail.patch
mm-memory-handle_pte_fault-use-pte_offset_map_nolock.patch
mm-pgtable-delete-pmd_trans_unstable-and-friends.patch
mm-swap-swap_vma_readahead-do-the-pte_offset_map.patch
perf-core-allow-pte_offset_map-to-fail.patch

