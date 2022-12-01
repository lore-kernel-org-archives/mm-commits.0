Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0036BC352A1
	for <mm-commits@archiver.kernel.org>; Thu,  1 Dec 2022 00:06:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230366AbiLAAGA (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Nov 2022 19:06:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230192AbiLAAEI (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 30 Nov 2022 19:04:08 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09C4158BC0
        for <mm-commits@vger.kernel.org>; Wed, 30 Nov 2022 16:01:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B4A3FB81D83
        for <mm-commits@vger.kernel.org>; Thu,  1 Dec 2022 00:01:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57AB2C433D7;
        Thu,  1 Dec 2022 00:01:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1669852911;
        bh=kosg6jdBA1QuvRFh/+9UiWltIgYe5Md1Csy2+iW2FH8=;
        h=Date:To:From:Subject:From;
        b=dZsSbucDNqmUfOU0Njus7abatBZPOWXKQ1sjz+fZBDffXSgR66Z0dRukq+W6p7Q0W
         qDUoQvbWX4VtrsZYdgl4OsYuSRA2sU2q7JfdvrqO33p1ma5NUPWDHFbisCW9EP8LvV
         gfymPb5AX+bVpAozsMDCCnh+swd39lrLowRuqLbk=
Date:   Wed, 30 Nov 2022 16:01:50 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org, vbabka@suse.cz,
        riel@surriel.com, peterx@redhat.com, naoya.horiguchi@linux.dev,
        nadav.amit@gmail.com, harperchen1110@gmail.com, david@redhat.com,
        axelrasmussen@google.com, almasrymina@google.com,
        mike.kravetz@oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] hugetlb-remove-duplicate-mmu-notifications.patch removed from -mm tree
Message-Id: <20221201000151.57AB2C433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: hugetlb: remove duplicate mmu notifications
has been removed from the -mm tree.  Its filename was
     hugetlb-remove-duplicate-mmu-notifications.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
@@ -5076,7 +5076,6 @@ static void __unmap_hugepage_range(struc
 	struct page *page;
 	struct hstate *h = hstate_vma(vma);
 	unsigned long sz = huge_page_size(h);
-	struct mmu_notifier_range range;
 	unsigned long last_addr_mask;
 	bool force_flush = false;
 
@@ -5091,13 +5090,6 @@ static void __unmap_hugepage_range(struc
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
@@ -5182,7 +5174,6 @@ static void __unmap_hugepage_range(struc
 		if (ref_page)
 			break;
 	}
-	mmu_notifier_invalidate_range_end(&range);
 	tlb_end_vma(tlb, vma);
 
 	/*
@@ -5210,6 +5201,7 @@ void __unmap_hugepage_range_final(struct
 	hugetlb_vma_lock_write(vma);
 	i_mmap_lock_write(vma->vm_file->f_mapping);
 
+	/* mmu notification performed in caller */
 	__unmap_hugepage_range(tlb, vma, start, end, ref_page, zap_flags);
 
 	if (zap_flags & ZAP_FLAG_UNMAP) {	/* final unmap */
@@ -5234,10 +5226,18 @@ void unmap_hugepage_range(struct vm_area
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


