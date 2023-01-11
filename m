Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4114C54EBC
	for <mm-commits@archiver.kernel.org>; Wed, 11 Jan 2023 00:13:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234554AbjAKANX (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 10 Jan 2023 19:13:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233693AbjAKANX (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 10 Jan 2023 19:13:23 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C667D5B157
        for <mm-commits@vger.kernel.org>; Tue, 10 Jan 2023 16:13:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 69315B81A52
        for <mm-commits@vger.kernel.org>; Wed, 11 Jan 2023 00:13:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2BD7C433EF;
        Wed, 11 Jan 2023 00:13:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1673395999;
        bh=91X8o1x2MElJyd0q+t4C8FL6pS89TLz3XlfnDj6XBjM=;
        h=Date:To:From:Subject:From;
        b=OGZqDE+2pppP57SP+x0bU9zumSqNa9sBQPFLQkgM7UCpWOtPKxfdRDGHURnFJNDXm
         bU7eWkQdLFJIN7UyaFnYi+nCWN55jygCasPzoKhM8Is9F2u1B+dWdU0uOal5gqmxjR
         YPUlS3oUPkOBfRswIj/zUlZUd2FNMOba5klgZw8Q=
Date:   Tue, 10 Jan 2023 16:13:17 -0800
To:     mm-commits@vger.kernel.org, rppt@kernel.org, rcampbell@nvidia.com,
        mike.kravetz@oracle.com, jhubbard@nvidia.com, jglisse@redhat.com,
        jgg@nvidia.com, ira.weiny@intel.com, hch@lst.de,
        apopple@nvidia.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mmu_notifier-remove-unused-mmu_notifier_range_update_to_read_only-export.patch added to mm-unstable branch
Message-Id: <20230111001318.F2BD7C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mmu_notifier: remove unused mmu_notifier_range_update_to_read_only export
has been added to the -mm mm-unstable branch.  Its filename is
     mm-mmu_notifier-remove-unused-mmu_notifier_range_update_to_read_only-export.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mmu_notifier-remove-unused-mmu_notifier_range_update_to_read_only-export.patch

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
From: Alistair Popple <apopple@nvidia.com>
Subject: mm/mmu_notifier: remove unused mmu_notifier_range_update_to_read_only export
Date: Tue, 10 Jan 2023 13:57:22 +1100

mmu_notifier_range_update_to_read_only() was originally introduced in
commit c6d23413f81b ("mm/mmu_notifier:
mmu_notifier_range_update_to_read_only() helper") as an optimisation for
device drivers that know a range has only been mapped read-only.  However
there are no users of this feature so remove it.  As it is the only user
of the struct mmu_notifier_range.vma field remove that also.

Link: https://lkml.kernel.org/r/20230110025722.600912-1-apopple@nvidia.com
Signed-off-by: Alistair Popple <apopple@nvidia.com>
Acked-by: Mike Rapoport (IBM) <rppt@kernel.org>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Ira Weiny <ira.weiny@intel.com>
Cc: Jerome Glisse <jglisse@redhat.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Ralph Campbell <rcampbell@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_mmu.c           |    2 +-
 include/linux/mmu_notifier.h |   13 +++++--------
 kernel/events/uprobes.c      |    2 +-
 mm/huge_memory.c             |    4 ++--
 mm/hugetlb.c                 |   12 ++++++------
 mm/khugepaged.c              |    6 +++---
 mm/ksm.c                     |    5 ++---
 mm/madvise.c                 |    2 +-
 mm/mapping_dirty_helpers.c   |    2 +-
 mm/memory.c                  |   10 +++++-----
 mm/migrate_device.c          |    4 ++--
 mm/mmu_notifier.c            |   10 ----------
 mm/mprotect.c                |    2 +-
 mm/mremap.c                  |    2 +-
 mm/oom_kill.c                |    2 +-
 mm/rmap.c                    |   11 +++++------
 16 files changed, 37 insertions(+), 52 deletions(-)

--- a/fs/proc/task_mmu.c~mm-mmu_notifier-remove-unused-mmu_notifier_range_update_to_read_only-export
+++ a/fs/proc/task_mmu.c
@@ -1308,7 +1308,7 @@ static ssize_t clear_refs_write(struct f
 
 			inc_tlb_flush_pending(mm);
 			mmu_notifier_range_init(&range, MMU_NOTIFY_SOFT_DIRTY,
-						0, NULL, mm, 0, -1UL);
+						0, mm, 0, -1UL);
 			mmu_notifier_invalidate_range_start(&range);
 		}
 		walk_page_range(mm, 0, -1, &clear_refs_walk_ops, &cp);
--- a/include/linux/mmu_notifier.h~mm-mmu_notifier-remove-unused-mmu_notifier_range_update_to_read_only-export
+++ a/include/linux/mmu_notifier.h
@@ -269,7 +269,6 @@ extern struct lockdep_map __mmu_notifier
 #endif
 
 struct mmu_notifier_range {
-	struct vm_area_struct *vma;
 	struct mm_struct *mm;
 	unsigned long start;
 	unsigned long end;
@@ -514,12 +513,10 @@ static inline void mmu_notifier_subscrip
 static inline void mmu_notifier_range_init(struct mmu_notifier_range *range,
 					   enum mmu_notifier_event event,
 					   unsigned flags,
-					   struct vm_area_struct *vma,
 					   struct mm_struct *mm,
 					   unsigned long start,
 					   unsigned long end)
 {
-	range->vma = vma;
 	range->event = event;
 	range->mm = mm;
 	range->start = start;
@@ -530,10 +527,10 @@ static inline void mmu_notifier_range_in
 static inline void mmu_notifier_range_init_owner(
 			struct mmu_notifier_range *range,
 			enum mmu_notifier_event event, unsigned int flags,
-			struct vm_area_struct *vma, struct mm_struct *mm,
-			unsigned long start, unsigned long end, void *owner)
+			struct mm_struct *mm, unsigned long start,
+			unsigned long end, void *owner)
 {
-	mmu_notifier_range_init(range, event, flags, vma, mm, start, end);
+	mmu_notifier_range_init(range, event, flags, mm, start, end);
 	range->owner = owner;
 }
 
@@ -659,9 +656,9 @@ static inline void _mmu_notifier_range_i
 	range->end = end;
 }
 
-#define mmu_notifier_range_init(range,event,flags,vma,mm,start,end)  \
+#define mmu_notifier_range_init(range,event,flags,mm,start,end)  \
 	_mmu_notifier_range_init(range, start, end)
-#define mmu_notifier_range_init_owner(range, event, flags, vma, mm, start, \
+#define mmu_notifier_range_init_owner(range, event, flags, mm, start, \
 					end, owner) \
 	_mmu_notifier_range_init(range, start, end)
 
--- a/kernel/events/uprobes.c~mm-mmu_notifier-remove-unused-mmu_notifier_range_update_to_read_only-export
+++ a/kernel/events/uprobes.c
@@ -161,7 +161,7 @@ static int __replace_page(struct vm_area
 	int err;
 	struct mmu_notifier_range range;
 
-	mmu_notifier_range_init(&range, MMU_NOTIFY_CLEAR, 0, vma, mm, addr,
+	mmu_notifier_range_init(&range, MMU_NOTIFY_CLEAR, 0, mm, addr,
 				addr + PAGE_SIZE);
 
 	if (new_page) {
--- a/mm/huge_memory.c~mm-mmu_notifier-remove-unused-mmu_notifier_range_update_to_read_only-export
+++ a/mm/huge_memory.c
@@ -2020,7 +2020,7 @@ void __split_huge_pud(struct vm_area_str
 	spinlock_t *ptl;
 	struct mmu_notifier_range range;
 
-	mmu_notifier_range_init(&range, MMU_NOTIFY_CLEAR, 0, vma, vma->vm_mm,
+	mmu_notifier_range_init(&range, MMU_NOTIFY_CLEAR, 0, vma->vm_mm,
 				address & HPAGE_PUD_MASK,
 				(address & HPAGE_PUD_MASK) + HPAGE_PUD_SIZE);
 	mmu_notifier_invalidate_range_start(&range);
@@ -2282,7 +2282,7 @@ void __split_huge_pmd(struct vm_area_str
 	spinlock_t *ptl;
 	struct mmu_notifier_range range;
 
-	mmu_notifier_range_init(&range, MMU_NOTIFY_CLEAR, 0, vma, vma->vm_mm,
+	mmu_notifier_range_init(&range, MMU_NOTIFY_CLEAR, 0, vma->vm_mm,
 				address & HPAGE_PMD_MASK,
 				(address & HPAGE_PMD_MASK) + HPAGE_PMD_SIZE);
 	mmu_notifier_invalidate_range_start(&range);
--- a/mm/hugetlb.c~mm-mmu_notifier-remove-unused-mmu_notifier_range_update_to_read_only-export
+++ a/mm/hugetlb.c
@@ -4966,7 +4966,7 @@ int copy_hugetlb_page_range(struct mm_st
 	int ret = 0;
 
 	if (cow) {
-		mmu_notifier_range_init(&range, MMU_NOTIFY_CLEAR, 0, src_vma, src,
+		mmu_notifier_range_init(&range, MMU_NOTIFY_CLEAR, 0, src,
 					src_vma->vm_start,
 					src_vma->vm_end);
 		mmu_notifier_invalidate_range_start(&range);
@@ -5177,7 +5177,7 @@ int move_hugetlb_page_tables(struct vm_a
 	struct mmu_notifier_range range;
 	bool shared_pmd = false;
 
-	mmu_notifier_range_init(&range, MMU_NOTIFY_CLEAR, 0, vma, mm, old_addr,
+	mmu_notifier_range_init(&range, MMU_NOTIFY_CLEAR, 0, mm, old_addr,
 				old_end);
 	adjust_range_if_pmd_sharing_possible(vma, &range.start, &range.end);
 	/*
@@ -5391,7 +5391,7 @@ void unmap_hugepage_range(struct vm_area
 	struct mmu_notifier_range range;
 	struct mmu_gather tlb;
 
-	mmu_notifier_range_init(&range, MMU_NOTIFY_CLEAR, 0, vma, vma->vm_mm,
+	mmu_notifier_range_init(&range, MMU_NOTIFY_CLEAR, 0, vma->vm_mm,
 				start, end);
 	adjust_range_if_pmd_sharing_possible(vma, &range.start, &range.end);
 	mmu_notifier_invalidate_range_start(&range);
@@ -5597,7 +5597,7 @@ retry_avoidcopy:
 			    pages_per_huge_page(h));
 	__SetPageUptodate(new_page);
 
-	mmu_notifier_range_init(&range, MMU_NOTIFY_CLEAR, 0, vma, mm, haddr,
+	mmu_notifier_range_init(&range, MMU_NOTIFY_CLEAR, 0, mm, haddr,
 				haddr + huge_page_size(h));
 	mmu_notifier_invalidate_range_start(&range);
 
@@ -6637,7 +6637,7 @@ long hugetlb_change_protection(struct vm
 	 * range if PMD sharing is possible.
 	 */
 	mmu_notifier_range_init(&range, MMU_NOTIFY_PROTECTION_VMA,
-				0, vma, mm, start, end);
+				0, mm, start, end);
 	adjust_range_if_pmd_sharing_possible(vma, &range.start, &range.end);
 
 	BUG_ON(address >= end);
@@ -7368,7 +7368,7 @@ static void hugetlb_unshare_pmds(struct
 	 * No need to call adjust_range_if_pmd_sharing_possible(), because
 	 * we have already done the PUD_SIZE alignment.
 	 */
-	mmu_notifier_range_init(&range, MMU_NOTIFY_CLEAR, 0, vma, mm,
+	mmu_notifier_range_init(&range, MMU_NOTIFY_CLEAR, 0, mm,
 				start, end);
 	mmu_notifier_invalidate_range_start(&range);
 	hugetlb_vma_lock_write(vma);
--- a/mm/khugepaged.c~mm-mmu_notifier-remove-unused-mmu_notifier_range_update_to_read_only-export
+++ a/mm/khugepaged.c
@@ -1123,8 +1123,8 @@ static int collapse_huge_page(struct mm_
 
 	anon_vma_lock_write(vma->anon_vma);
 
-	mmu_notifier_range_init(&range, MMU_NOTIFY_CLEAR, 0, NULL, mm,
-				address, address + HPAGE_PMD_SIZE);
+	mmu_notifier_range_init(&range, MMU_NOTIFY_CLEAR, 0, mm, address,
+				address + HPAGE_PMD_SIZE);
 	mmu_notifier_invalidate_range_start(&range);
 
 	pte = pte_offset_map(pmd, address);
@@ -1499,7 +1499,7 @@ static void collapse_and_free_pmd(struct
 	if (vma->anon_vma)
 		lockdep_assert_held_write(&vma->anon_vma->root->rwsem);
 
-	mmu_notifier_range_init(&range, MMU_NOTIFY_CLEAR, 0, NULL, mm, addr,
+	mmu_notifier_range_init(&range, MMU_NOTIFY_CLEAR, 0, mm, addr,
 				addr + HPAGE_PMD_SIZE);
 	mmu_notifier_invalidate_range_start(&range);
 	pmd = pmdp_collapse_flush(vma, addr, pmdp);
--- a/mm/ksm.c~mm-mmu_notifier-remove-unused-mmu_notifier_range_update_to_read_only-export
+++ a/mm/ksm.c
@@ -1107,8 +1107,7 @@ static int write_protect_page(struct vm_
 
 	BUG_ON(PageTransCompound(page));
 
-	mmu_notifier_range_init(&range, MMU_NOTIFY_CLEAR, 0, vma, mm,
-				pvmw.address,
+	mmu_notifier_range_init(&range, MMU_NOTIFY_CLEAR, 0, mm, pvmw.address,
 				pvmw.address + PAGE_SIZE);
 	mmu_notifier_invalidate_range_start(&range);
 
@@ -1214,7 +1213,7 @@ static int replace_page(struct vm_area_s
 	if (!pmd_present(pmde) || pmd_trans_huge(pmde))
 		goto out;
 
-	mmu_notifier_range_init(&range, MMU_NOTIFY_CLEAR, 0, vma, mm, addr,
+	mmu_notifier_range_init(&range, MMU_NOTIFY_CLEAR, 0, mm, addr,
 				addr + PAGE_SIZE);
 	mmu_notifier_invalidate_range_start(&range);
 
--- a/mm/madvise.c~mm-mmu_notifier-remove-unused-mmu_notifier_range_update_to_read_only-export
+++ a/mm/madvise.c
@@ -765,7 +765,7 @@ static int madvise_free_single_vma(struc
 	range.end = min(vma->vm_end, end_addr);
 	if (range.end <= vma->vm_start)
 		return -EINVAL;
-	mmu_notifier_range_init(&range, MMU_NOTIFY_CLEAR, 0, vma, mm,
+	mmu_notifier_range_init(&range, MMU_NOTIFY_CLEAR, 0, mm,
 				range.start, range.end);
 
 	lru_add_drain();
--- a/mm/mapping_dirty_helpers.c~mm-mmu_notifier-remove-unused-mmu_notifier_range_update_to_read_only-export
+++ a/mm/mapping_dirty_helpers.c
@@ -191,7 +191,7 @@ static int wp_clean_pre_vma(unsigned lon
 	wpwalk->tlbflush_end = start;
 
 	mmu_notifier_range_init(&wpwalk->range, MMU_NOTIFY_PROTECTION_PAGE, 0,
-				walk->vma, walk->mm, start, end);
+				walk->mm, start, end);
 	mmu_notifier_invalidate_range_start(&wpwalk->range);
 	flush_cache_range(walk->vma, start, end);
 
--- a/mm/memory.c~mm-mmu_notifier-remove-unused-mmu_notifier_range_update_to_read_only-export
+++ a/mm/memory.c
@@ -1266,7 +1266,7 @@ copy_page_range(struct vm_area_struct *d
 
 	if (is_cow) {
 		mmu_notifier_range_init(&range, MMU_NOTIFY_PROTECTION_PAGE,
-					0, src_vma, src_mm, addr, end);
+					0, src_mm, addr, end);
 		mmu_notifier_invalidate_range_start(&range);
 		/*
 		 * Disabling preemption is not needed for the write side, as
@@ -1683,7 +1683,7 @@ void unmap_vmas(struct mmu_gather *tlb,
 	};
 	MA_STATE(mas, mt, vma->vm_end, vma->vm_end);
 
-	mmu_notifier_range_init(&range, MMU_NOTIFY_UNMAP, 0, vma, vma->vm_mm,
+	mmu_notifier_range_init(&range, MMU_NOTIFY_UNMAP, 0, vma->vm_mm,
 				start_addr, end_addr);
 	mmu_notifier_invalidate_range_start(&range);
 	do {
@@ -1709,7 +1709,7 @@ void zap_page_range_single(struct vm_are
 	struct mmu_gather tlb;
 
 	lru_add_drain();
-	mmu_notifier_range_init(&range, MMU_NOTIFY_CLEAR, 0, vma, vma->vm_mm,
+	mmu_notifier_range_init(&range, MMU_NOTIFY_CLEAR, 0, vma->vm_mm,
 				address, end);
 	if (is_vm_hugetlb_page(vma))
 		adjust_range_if_pmd_sharing_possible(vma, &range.start,
@@ -3091,7 +3091,7 @@ static vm_fault_t wp_page_copy(struct vm
 
 	__SetPageUptodate(new_page);
 
-	mmu_notifier_range_init(&range, MMU_NOTIFY_CLEAR, 0, vma, mm,
+	mmu_notifier_range_init(&range, MMU_NOTIFY_CLEAR, 0, mm,
 				vmf->address & PAGE_MASK,
 				(vmf->address & PAGE_MASK) + PAGE_SIZE);
 	mmu_notifier_invalidate_range_start(&range);
@@ -3561,7 +3561,7 @@ static vm_fault_t remove_device_exclusiv
 
 	if (!folio_lock_or_retry(folio, vma->vm_mm, vmf->flags))
 		return VM_FAULT_RETRY;
-	mmu_notifier_range_init_owner(&range, MMU_NOTIFY_EXCLUSIVE, 0, vma,
+	mmu_notifier_range_init_owner(&range, MMU_NOTIFY_EXCLUSIVE, 0,
 				vma->vm_mm, vmf->address & PAGE_MASK,
 				(vmf->address & PAGE_MASK) + PAGE_SIZE, NULL);
 	mmu_notifier_invalidate_range_start(&range);
--- a/mm/migrate_device.c~mm-mmu_notifier-remove-unused-mmu_notifier_range_update_to_read_only-export
+++ a/mm/migrate_device.c
@@ -306,7 +306,7 @@ static void migrate_vma_collect(struct m
 	 * private page mappings that won't be migrated.
 	 */
 	mmu_notifier_range_init_owner(&range, MMU_NOTIFY_MIGRATE, 0,
-		migrate->vma, migrate->vma->vm_mm, migrate->start, migrate->end,
+		migrate->vma->vm_mm, migrate->start, migrate->end,
 		migrate->pgmap_owner);
 	mmu_notifier_invalidate_range_start(&range);
 
@@ -733,7 +733,7 @@ static void __migrate_device_pages(unsig
 				notified = true;
 
 				mmu_notifier_range_init_owner(&range,
-					MMU_NOTIFY_MIGRATE, 0, migrate->vma,
+					MMU_NOTIFY_MIGRATE, 0,
 					migrate->vma->vm_mm, addr, migrate->end,
 					migrate->pgmap_owner);
 				mmu_notifier_invalidate_range_start(&range);
--- a/mm/mmu_notifier.c~mm-mmu_notifier-remove-unused-mmu_notifier_range_update_to_read_only-export
+++ a/mm/mmu_notifier.c
@@ -1120,13 +1120,3 @@ void mmu_notifier_synchronize(void)
 	synchronize_srcu(&srcu);
 }
 EXPORT_SYMBOL_GPL(mmu_notifier_synchronize);
-
-bool
-mmu_notifier_range_update_to_read_only(const struct mmu_notifier_range *range)
-{
-	if (!range->vma || range->event != MMU_NOTIFY_PROTECTION_VMA)
-		return false;
-	/* Return true if the vma still have the read flag set. */
-	return range->vma->vm_flags & VM_READ;
-}
-EXPORT_SYMBOL_GPL(mmu_notifier_range_update_to_read_only);
--- a/mm/mprotect.c~mm-mmu_notifier-remove-unused-mmu_notifier_range_update_to_read_only-export
+++ a/mm/mprotect.c
@@ -398,7 +398,7 @@ static inline long change_pmd_range(stru
 		if (!range.start) {
 			mmu_notifier_range_init(&range,
 				MMU_NOTIFY_PROTECTION_VMA, 0,
-				vma, vma->vm_mm, addr, end);
+				vma->vm_mm, addr, end);
 			mmu_notifier_invalidate_range_start(&range);
 		}
 
--- a/mm/mremap.c~mm-mmu_notifier-remove-unused-mmu_notifier_range_update_to_read_only-export
+++ a/mm/mremap.c
@@ -498,7 +498,7 @@ unsigned long move_page_tables(struct vm
 						new_addr, len);
 
 	flush_cache_range(vma, old_addr, old_end);
-	mmu_notifier_range_init(&range, MMU_NOTIFY_UNMAP, 0, vma, vma->vm_mm,
+	mmu_notifier_range_init(&range, MMU_NOTIFY_UNMAP, 0, vma->vm_mm,
 				old_addr, old_end);
 	mmu_notifier_invalidate_range_start(&range);
 
--- a/mm/oom_kill.c~mm-mmu_notifier-remove-unused-mmu_notifier_range_update_to_read_only-export
+++ a/mm/oom_kill.c
@@ -542,7 +542,7 @@ static bool __oom_reap_task_mm(struct mm
 			struct mmu_gather tlb;
 
 			mmu_notifier_range_init(&range, MMU_NOTIFY_UNMAP, 0,
-						vma, mm, vma->vm_start,
+						mm, vma->vm_start,
 						vma->vm_end);
 			tlb_gather_mmu(&tlb, mm);
 			if (mmu_notifier_invalidate_range_start_nonblock(&range)) {
--- a/mm/rmap.c~mm-mmu_notifier-remove-unused-mmu_notifier_range_update_to_read_only-export
+++ a/mm/rmap.c
@@ -944,9 +944,8 @@ static int page_vma_mkclean_one(struct p
 	 * We have to assume the worse case ie pmd for invalidation. Note that
 	 * the folio can not be freed from this function.
 	 */
-	mmu_notifier_range_init(&range, MMU_NOTIFY_PROTECTION_PAGE,
-				0, vma, vma->vm_mm, address,
-				vma_address_end(pvmw));
+	mmu_notifier_range_init(&range, MMU_NOTIFY_PROTECTION_PAGE, 0,
+				vma->vm_mm, address, vma_address_end(pvmw));
 	mmu_notifier_invalidate_range_start(&range);
 
 	while (page_vma_mapped_walk(pvmw)) {
@@ -1475,7 +1474,7 @@ static bool try_to_unmap_one(struct foli
 	 * try_to_unmap() must hold a reference on the folio.
 	 */
 	range.end = vma_address_end(&pvmw);
-	mmu_notifier_range_init(&range, MMU_NOTIFY_CLEAR, 0, vma, vma->vm_mm,
+	mmu_notifier_range_init(&range, MMU_NOTIFY_CLEAR, 0, vma->vm_mm,
 				address, range.end);
 	if (folio_test_hugetlb(folio)) {
 		/*
@@ -1850,7 +1849,7 @@ static bool try_to_migrate_one(struct fo
 	 * try_to_unmap() must hold a reference on the page.
 	 */
 	range.end = vma_address_end(&pvmw);
-	mmu_notifier_range_init(&range, MMU_NOTIFY_CLEAR, 0, vma, vma->vm_mm,
+	mmu_notifier_range_init(&range, MMU_NOTIFY_CLEAR, 0, vma->vm_mm,
 				address, range.end);
 	if (folio_test_hugetlb(folio)) {
 		/*
@@ -2194,7 +2193,7 @@ static bool page_make_device_exclusive_o
 	swp_entry_t entry;
 	pte_t swp_pte;
 
-	mmu_notifier_range_init_owner(&range, MMU_NOTIFY_EXCLUSIVE, 0, vma,
+	mmu_notifier_range_init_owner(&range, MMU_NOTIFY_EXCLUSIVE, 0,
 				      vma->vm_mm, address, min(vma->vm_end,
 				      address + folio_size(folio)),
 				      args->owner);
_

Patches currently in -mm which might be from apopple@nvidia.com are

mm-mmu_notifier-remove-unused-mmu_notifier_range_update_to_read_only-export.patch

