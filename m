Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F3DBC38159
	for <mm-commits@archiver.kernel.org>; Thu, 19 Jan 2023 01:20:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229973AbjASBUn (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 18 Jan 2023 20:20:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229918AbjASBTH (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 18 Jan 2023 20:19:07 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADA3869B29
        for <mm-commits@vger.kernel.org>; Wed, 18 Jan 2023 17:16:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 62DA8B81FB9
        for <mm-commits@vger.kernel.org>; Thu, 19 Jan 2023 01:16:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FE28C433EF;
        Thu, 19 Jan 2023 01:16:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1674090977;
        bh=IYP9utWOyPM8ba4I8zPLn15pNJT0kvitvFyWOekhSyc=;
        h=Date:To:From:Subject:From;
        b=zixIbGNdmUDzTXh7zyB6e3jQVpuB7Nb9Pjrzb+/2tU1mdaaq0XiBdwrI1YgjzBIU2
         jJQI8VIZgfSy/2U3KfzKt6kfq2zpnphetz2Wv3hmF+/UwhX5gitVGzjKe/VC9twcPl
         j37UigLw2TXLb9z8NRhvsxJiiwTdumVc/pfDbn/A=
Date:   Wed, 18 Jan 2023 17:16:16 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org, will@kernel.org,
        vbabka@suse.cz, riel@surriel.com, peterx@redhat.com,
        palmer@dabbelt.com, nadav.amit@gmail.com, mpe@ellerman.id.au,
        mhocko@suse.com, hch@lst.de, hca@linux.ibm.com,
        edumazet@google.com, david@redhat.com, dave.hansen@linux.intel.com,
        brauner@kernel.org, borntraeger@linux.ibm.com,
        mike.kravetz@oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-remove-zap_page_range-and-create-zap_vma_pages.patch removed from -mm tree
Message-Id: <20230119011617.0FE28C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: remove zap_page_range and create zap_vma_pages
has been removed from the -mm tree.  Its filename was
     mm-remove-zap_page_range-and-create-zap_vma_pages.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Mike Kravetz <mike.kravetz@oracle.com>
Subject: mm: remove zap_page_range and create zap_vma_pages
Date: Tue, 3 Jan 2023 16:27:32 -0800

zap_page_range was originally designed to unmap pages within an address
range that could span multiple vmas.  While working on [1], it was
discovered that all callers of zap_page_range pass a range entirely within
a single vma.  In addition, the mmu notification call within zap_page
range does not correctly handle ranges that span multiple vmas.  When
crossing a vma boundary, a new mmu_notifier_range_init/end call pair with
the new vma should be made.

Instead of fixing zap_page_range, do the following:
- Create a new routine zap_vma_pages() that will remove all pages within
  the passed vma.  Most users of zap_page_range pass the entire vma and
  can use this new routine.
- For callers of zap_page_range not passing the entire vma, instead call
  zap_page_range_single().
- Remove zap_page_range.

[1] https://lore.kernel.org/linux-mm/20221114235507.294320-2-mike.kravetz@oracle.com/
Link: https://lkml.kernel.org/r/20230104002732.232573-1-mike.kravetz@oracle.com
Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>
Suggested-by: Peter Xu <peterx@redhat.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: Peter Xu <peterx@redhat.com>
Acked-by: Heiko Carstens <hca@linux.ibm.com>	[s390]
Reviewed-by: Christoph Hellwig <hch@lst.de>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Nadav Amit <nadav.amit@gmail.com>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/kernel/vdso.c                |    6 +---
 arch/powerpc/kernel/vdso.c              |    4 --
 arch/powerpc/platforms/book3s/vas-api.c |    2 -
 arch/powerpc/platforms/pseries/vas.c    |    3 --
 arch/riscv/kernel/vdso.c                |    6 +---
 arch/s390/kernel/vdso.c                 |    4 --
 arch/s390/mm/gmap.c                     |    2 -
 arch/x86/entry/vdso/vma.c               |    4 --
 drivers/android/binder_alloc.c          |    2 -
 include/linux/mm.h                      |    7 +++--
 mm/memory.c                             |   30 ----------------------
 mm/page-writeback.c                     |    2 -
 net/ipv4/tcp.c                          |    7 ++---
 13 files changed, 21 insertions(+), 58 deletions(-)

--- a/arch/arm64/kernel/vdso.c~mm-remove-zap_page_range-and-create-zap_vma_pages
+++ a/arch/arm64/kernel/vdso.c
@@ -138,13 +138,11 @@ int vdso_join_timens(struct task_struct
 	mmap_read_lock(mm);
 
 	for_each_vma(vmi, vma) {
-		unsigned long size = vma->vm_end - vma->vm_start;
-
 		if (vma_is_special_mapping(vma, vdso_info[VDSO_ABI_AA64].dm))
-			zap_page_range(vma, vma->vm_start, size);
+			zap_vma_pages(vma);
 #ifdef CONFIG_COMPAT_VDSO
 		if (vma_is_special_mapping(vma, vdso_info[VDSO_ABI_AA32].dm))
-			zap_page_range(vma, vma->vm_start, size);
+			zap_vma_pages(vma);
 #endif
 	}
 
--- a/arch/powerpc/kernel/vdso.c~mm-remove-zap_page_range-and-create-zap_vma_pages
+++ a/arch/powerpc/kernel/vdso.c
@@ -120,10 +120,8 @@ int vdso_join_timens(struct task_struct
 
 	mmap_read_lock(mm);
 	for_each_vma(vmi, vma) {
-		unsigned long size = vma->vm_end - vma->vm_start;
-
 		if (vma_is_special_mapping(vma, &vvar_spec))
-			zap_page_range(vma, vma->vm_start, size);
+			zap_vma_pages(vma);
 	}
 	mmap_read_unlock(mm);
 
--- a/arch/powerpc/platforms/book3s/vas-api.c~mm-remove-zap_page_range-and-create-zap_vma_pages
+++ a/arch/powerpc/platforms/book3s/vas-api.c
@@ -414,7 +414,7 @@ static vm_fault_t vas_mmap_fault(struct
 	/*
 	 * When the LPAR lost credits due to core removal or during
 	 * migration, invalidate the existing mapping for the current
-	 * paste addresses and set windows in-active (zap_page_range in
+	 * paste addresses and set windows in-active (zap_vma_pages in
 	 * reconfig_close_windows()).
 	 * New mapping will be done later after migration or new credits
 	 * available. So continue to receive faults if the user space
--- a/arch/powerpc/platforms/pseries/vas.c~mm-remove-zap_page_range-and-create-zap_vma_pages
+++ a/arch/powerpc/platforms/pseries/vas.c
@@ -760,8 +760,7 @@ static int reconfig_close_windows(struct
 		 * is done before the original mmap() and after the ioctl.
 		 */
 		if (vma)
-			zap_page_range(vma, vma->vm_start,
-					vma->vm_end - vma->vm_start);
+			zap_vma_pages(vma);
 
 		mmap_write_unlock(task_ref->mm);
 		mutex_unlock(&task_ref->mmap_mutex);
--- a/arch/riscv/kernel/vdso.c~mm-remove-zap_page_range-and-create-zap_vma_pages
+++ a/arch/riscv/kernel/vdso.c
@@ -124,13 +124,11 @@ int vdso_join_timens(struct task_struct
 	mmap_read_lock(mm);
 
 	for_each_vma(vmi, vma) {
-		unsigned long size = vma->vm_end - vma->vm_start;
-
 		if (vma_is_special_mapping(vma, vdso_info.dm))
-			zap_page_range(vma, vma->vm_start, size);
+			zap_vma_pages(vma);
 #ifdef CONFIG_COMPAT
 		if (vma_is_special_mapping(vma, compat_vdso_info.dm))
-			zap_page_range(vma, vma->vm_start, size);
+			zap_vma_pages(vma);
 #endif
 	}
 
--- a/arch/s390/kernel/vdso.c~mm-remove-zap_page_range-and-create-zap_vma_pages
+++ a/arch/s390/kernel/vdso.c
@@ -59,11 +59,9 @@ int vdso_join_timens(struct task_struct
 
 	mmap_read_lock(mm);
 	for_each_vma(vmi, vma) {
-		unsigned long size = vma->vm_end - vma->vm_start;
-
 		if (!vma_is_special_mapping(vma, &vvar_mapping))
 			continue;
-		zap_page_range(vma, vma->vm_start, size);
+		zap_vma_pages(vma);
 		break;
 	}
 	mmap_read_unlock(mm);
--- a/arch/s390/mm/gmap.c~mm-remove-zap_page_range-and-create-zap_vma_pages
+++ a/arch/s390/mm/gmap.c
@@ -722,7 +722,7 @@ void gmap_discard(struct gmap *gmap, uns
 		if (is_vm_hugetlb_page(vma))
 			continue;
 		size = min(to - gaddr, PMD_SIZE - (gaddr & ~PMD_MASK));
-		zap_page_range(vma, vmaddr, size);
+		zap_page_range_single(vma, vmaddr, size, NULL);
 	}
 	mmap_read_unlock(gmap->mm);
 }
--- a/arch/x86/entry/vdso/vma.c~mm-remove-zap_page_range-and-create-zap_vma_pages
+++ a/arch/x86/entry/vdso/vma.c
@@ -113,10 +113,8 @@ int vdso_join_timens(struct task_struct
 
 	mmap_read_lock(mm);
 	for_each_vma(vmi, vma) {
-		unsigned long size = vma->vm_end - vma->vm_start;
-
 		if (vma_is_special_mapping(vma, &vvar_mapping))
-			zap_page_range(vma, vma->vm_start, size);
+			zap_vma_pages(vma);
 	}
 	mmap_read_unlock(mm);
 
--- a/drivers/android/binder_alloc.c~mm-remove-zap_page_range-and-create-zap_vma_pages
+++ a/drivers/android/binder_alloc.c
@@ -1019,7 +1019,7 @@ enum lru_status binder_alloc_free_page(s
 	if (vma) {
 		trace_binder_unmap_user_start(alloc, index);
 
-		zap_page_range(vma, page_addr, PAGE_SIZE);
+		zap_page_range_single(vma, page_addr, PAGE_SIZE, NULL);
 
 		trace_binder_unmap_user_end(alloc, index);
 	}
--- a/include/linux/mm.h~mm-remove-zap_page_range-and-create-zap_vma_pages
+++ a/include/linux/mm.h
@@ -1977,10 +1977,13 @@ struct page *vm_normal_page_pmd(struct v
 
 void zap_vma_ptes(struct vm_area_struct *vma, unsigned long address,
 		  unsigned long size);
-void zap_page_range(struct vm_area_struct *vma, unsigned long address,
-		    unsigned long size);
 void zap_page_range_single(struct vm_area_struct *vma, unsigned long address,
 			   unsigned long size, struct zap_details *details);
+static inline void zap_vma_pages(struct vm_area_struct *vma)
+{
+	zap_page_range_single(vma, vma->vm_start,
+			      vma->vm_end - vma->vm_start, NULL);
+}
 void unmap_vmas(struct mmu_gather *tlb, struct maple_tree *mt,
 		struct vm_area_struct *start_vma, unsigned long start,
 		unsigned long end);
--- a/mm/memory.c~mm-remove-zap_page_range-and-create-zap_vma_pages
+++ a/mm/memory.c
@@ -1694,36 +1694,6 @@ void unmap_vmas(struct mmu_gather *tlb,
 }
 
 /**
- * zap_page_range - remove user pages in a given range
- * @vma: vm_area_struct holding the applicable pages
- * @start: starting address of pages to zap
- * @size: number of bytes to zap
- *
- * Caller must protect the VMA list
- */
-void zap_page_range(struct vm_area_struct *vma, unsigned long start,
-		unsigned long size)
-{
-	struct maple_tree *mt = &vma->vm_mm->mm_mt;
-	unsigned long end = start + size;
-	struct mmu_notifier_range range;
-	struct mmu_gather tlb;
-	MA_STATE(mas, mt, vma->vm_end, vma->vm_end);
-
-	lru_add_drain();
-	mmu_notifier_range_init(&range, MMU_NOTIFY_CLEAR, 0, vma, vma->vm_mm,
-				start, start + size);
-	tlb_gather_mmu(&tlb, vma->vm_mm);
-	update_hiwater_rss(vma->vm_mm);
-	mmu_notifier_invalidate_range_start(&range);
-	do {
-		unmap_single_vma(&tlb, vma, start, range.end, NULL);
-	} while ((vma = mas_find(&mas, end - 1)) != NULL);
-	mmu_notifier_invalidate_range_end(&range);
-	tlb_finish_mmu(&tlb);
-}
-
-/**
  * zap_page_range_single - remove user pages in a given range
  * @vma: vm_area_struct holding the applicable pages
  * @address: starting address of pages to zap
--- a/mm/page-writeback.c~mm-remove-zap_page_range-and-create-zap_vma_pages
+++ a/mm/page-writeback.c
@@ -2690,7 +2690,7 @@ void folio_account_cleaned(struct folio
  *
  * The caller must hold lock_page_memcg().  Most callers have the folio
  * locked.  A few have the folio blocked from truncation through other
- * means (eg zap_page_range() has it mapped and is holding the page table
+ * means (eg zap_vma_pages() has it mapped and is holding the page table
  * lock).  This can also be called from mark_buffer_dirty(), which I
  * cannot prove is always protected against truncate.
  */
--- a/net/ipv4/tcp.c~mm-remove-zap_page_range-and-create-zap_vma_pages
+++ a/net/ipv4/tcp.c
@@ -2092,7 +2092,7 @@ static int tcp_zerocopy_vm_insert_batch_
 		maybe_zap_len = total_bytes_to_map -  /* All bytes to map */
 				*length + /* Mapped or pending */
 				(pages_remaining * PAGE_SIZE); /* Failed map. */
-		zap_page_range(vma, *address, maybe_zap_len);
+		zap_page_range_single(vma, *address, maybe_zap_len, NULL);
 		err = 0;
 	}
 
@@ -2100,7 +2100,7 @@ static int tcp_zerocopy_vm_insert_batch_
 		unsigned long leftover_pages = pages_remaining;
 		int bytes_mapped;
 
-		/* We called zap_page_range, try to reinsert. */
+		/* We called zap_page_range_single, try to reinsert. */
 		err = vm_insert_pages(vma, *address,
 				      pending_pages,
 				      &pages_remaining);
@@ -2234,7 +2234,8 @@ static int tcp_zerocopy_receive(struct s
 	total_bytes_to_map = avail_len & ~(PAGE_SIZE - 1);
 	if (total_bytes_to_map) {
 		if (!(zc->flags & TCP_RECEIVE_ZEROCOPY_FLAG_TLB_CLEAN_HINT))
-			zap_page_range(vma, address, total_bytes_to_map);
+			zap_page_range_single(vma, address, total_bytes_to_map,
+					      NULL);
 		zc->length = total_bytes_to_map;
 		zc->recv_skip_hint = 0;
 	} else {
_

Patches currently in -mm which might be from mike.kravetz@oracle.com are


