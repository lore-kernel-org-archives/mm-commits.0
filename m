Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6391C433FE
	for <mm-commits@archiver.kernel.org>; Tue, 15 Nov 2022 01:09:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231583AbiKOBJQ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 14 Nov 2022 20:09:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231254AbiKOBJP (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 14 Nov 2022 20:09:15 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4AB0F599
        for <mm-commits@vger.kernel.org>; Mon, 14 Nov 2022 17:09:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8521AB81259
        for <mm-commits@vger.kernel.org>; Tue, 15 Nov 2022 01:09:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27427C433C1;
        Tue, 15 Nov 2022 01:09:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1668474552;
        bh=h7l8ph/GHXyBVaXMSR8VPAr5szCYf101FQWjgAL1S6M=;
        h=Date:To:From:Subject:From;
        b=WrJ+NXHKIPWkpo9hZ4Pb68XNy+l5TU9+VFp8mE4sm2/SGOUsmNscaa4a1BUXiA0Ub
         xclaZlTF0OUA10Cjz1JNcpVDGQ3M3ME55deiCvMpMch0basCKJ7JIx47UnwogHaLSS
         hdfAxSAFLTUSgnjJT9BEMT0Zo9kSIuOM2GovdO6k=
Date:   Mon, 14 Nov 2022 17:09:11 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org, vbabka@suse.cz,
        riel@surriel.com, peterx@redhat.com, naoya.horiguchi@linux.dev,
        nadav.amit@gmail.com, harperchen1110@gmail.com, david@redhat.com,
        axelrasmussen@google.com, almasrymina@google.com,
        mike.kravetz@oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + hugetlb-remove-duplicate-mmu-notifications.patch added to mm-unstable branch
Message-Id: <20221115010912.27427C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: hugetlb: remove duplicate mmu notifications
has been added to the -mm mm-unstable branch.  Its filename is
     hugetlb-remove-duplicate-mmu-notifications.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/hugetlb-remove-duplicate-mmu-notifications.patch

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
From: Mike Kravetz <mike.kravetz@oracle.com>
Subject: hugetlb: remove duplicate mmu notifications
Date: Mon, 14 Nov 2022 15:55:07 -0800

The common hugetlb unmap routine __unmap_hugepage_range performs mmu
notification calls.  However, in the case where __unmap_hugepage_range is
called via __unmap_hugepage_range_final, mmu notification calls are
performed earlier in other calling routines.

Remove mmu notification calls from __unmap_hugepage_range.  Add
notification calls to the only other caller: unmap_hugepage_range. 
unmap_hugepage_range is called for truncation and hole punch, so change
notification type from UNMAP to CLEAR as this is more appropriate.

Link: https://lkml.kernel.org/r/20221114235507.294320-4-mike.kravetz@oracle.com
Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>
Suggested-by: Peter Xu <peterx@redhat.com>
Cc: Wei Chen <harperchen1110@gmail.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Mina Almasry <almasrymina@google.com>
Cc: Nadav Amit <nadav.amit@gmail.com>
Cc: Naoya Horiguchi <naoya.horiguchi@linux.dev>
Cc: Rik van Riel <riel@surriel.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

--- a/mm/hugetlb.c~hugetlb-remove-duplicate-mmu-notifications
+++ a/mm/hugetlb.c
@@ -5074,7 +5074,6 @@ static void __unmap_hugepage_range(struc
 	struct page *page;
 	struct hstate *h = hstate_vma(vma);
 	unsigned long sz = huge_page_size(h);
-	struct mmu_notifier_range range;
 	unsigned long last_addr_mask;
 	bool force_flush = false;
 
@@ -5089,13 +5088,6 @@ static void __unmap_hugepage_range(struc
 	tlb_change_page_size(tlb, sz);
 	tlb_start_vma(tlb, vma);
 
-	/*
-	 * If sharing possible, alert mmu notifiers of worst case.
-	 */
-	mmu_notifier_range_init(&range, MMU_NOTIFY_UNMAP, 0, vma, mm, start,
-				end);
-	adjust_range_if_pmd_sharing_possible(vma, &range.start, &range.end);
-	mmu_notifier_invalidate_range_start(&range);
 	last_addr_mask = hugetlb_mask_last_page(h);
 	address = start;
 	for (; address < end; address += sz) {
@@ -5180,7 +5172,6 @@ static void __unmap_hugepage_range(struc
 		if (ref_page)
 			break;
 	}
-	mmu_notifier_invalidate_range_end(&range);
 	tlb_end_vma(tlb, vma);
 
 	/*
@@ -5208,6 +5199,7 @@ void __unmap_hugepage_range_final(struct
 	hugetlb_vma_lock_write(vma);
 	i_mmap_lock_write(vma->vm_file->f_mapping);
 
+	/* mmu notification performed in caller */
 	__unmap_hugepage_range(tlb, vma, start, end, ref_page, zap_flags);
 
 	if (zap_flags & ZAP_FLAG_UNMAP) {	/* final unmap */
@@ -5232,10 +5224,18 @@ void unmap_hugepage_range(struct vm_area
 			  unsigned long end, struct page *ref_page,
 			  zap_flags_t zap_flags)
 {
+	struct mmu_notifier_range range;
 	struct mmu_gather tlb;
 
+	mmu_notifier_range_init(&range, MMU_NOTIFY_CLEAR, 0, vma, vma->vm_mm,
+				start, end);
+	adjust_range_if_pmd_sharing_possible(vma, &range.start, &range.end);
+	mmu_notifier_invalidate_range_start(&range);
 	tlb_gather_mmu(&tlb, vma->vm_mm);
+
 	__unmap_hugepage_range(&tlb, vma, start, end, ref_page, zap_flags);
+
+	mmu_notifier_invalidate_range_end(&range);
 	tlb_finish_mmu(&tlb);
 }
 
_

Patches currently in -mm which might be from mike.kravetz@oracle.com are

ipc-shm-call-underlying-open-close-vm_ops.patch
madvise-use-zap_page_range_single-for-madvise-dontneed.patch
hugetlb-dont-delete-vma_lock-in-hugetlb-madv_dontneed-processing.patch
selftests-vm-update-hugetlb-madvise.patch
hugetlb-remove-duplicate-mmu-notifications.patch

