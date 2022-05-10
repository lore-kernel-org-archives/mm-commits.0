Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5FCE4C433FE
	for <mm-commits@archiver.kernel.org>; Tue, 10 May 2022 04:17:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236323AbiEJEUz (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 10 May 2022 00:20:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236157AbiEJET6 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 10 May 2022 00:19:58 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2C8E23885A
        for <mm-commits@vger.kernel.org>; Mon,  9 May 2022 21:14:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D9BDFB817CC
        for <mm-commits@vger.kernel.org>; Tue, 10 May 2022 04:14:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A82AC385A6;
        Tue, 10 May 2022 04:14:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652156072;
        bh=2RUVW7leOnNNyh2hBLQM0ONp2DLvqxFIajRWlC9Fvvs=;
        h=Date:To:From:Subject:From;
        b=GCOlbn6xeAPgh2L1j5Csv/ZTBBAT/3l4XOVfE7yXX9UK8iUwPaXbY48T1teWOC/w+
         Z9GGetWfuk3CFMVftMDxyPg+t+ihpaGhqyUxQiX+HMSSVH89fb4ECUATnIPg6TU47F
         SmHkke6fsMG0a47ogv+4FMbK6bA0iHbNa4eSsRCM=
Date:   Mon, 09 May 2022 21:14:32 -0700
To:     mm-commits@vger.kernel.org, zhangliang5@huawei.com,
        willy@infradead.org, vbabka@suse.cz, shy828301@gmail.com,
        shakeelb@google.com, rppt@linux.ibm.com, rientjes@google.com,
        riel@surriel.com, peterx@redhat.com, pedrodemargomes@gmail.com,
        oleg@redhat.com, oded.gabbay@gmail.com, namit@vmware.com,
        mike.kravetz@oracle.com, mhocko@kernel.org,
        kirill.shutemov@linux.intel.com, khalid.aziz@oracle.com,
        jhubbard@nvidia.com, jgg@nvidia.com, jannh@google.com,
        jack@suse.cz, hughd@google.com, hch@lst.de, guro@fb.com,
        ddutile@redhat.com, aarcange@redhat.com, david@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-hugetlb-take-src_mm-write_protect_seq-in-copy_hugetlb_page_range.patch removed from -mm tree
Message-Id: <20220510041432.8A82AC385A6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/hugetlb: take src_mm->write_protect_seq in copy_hugetlb_page_range()
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-take-src_mm-write_protect_seq-in-copy_hugetlb_page_range.patch

This patch was dropped because it was merged into mm-stable

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: mm/hugetlb: take src_mm->write_protect_seq in copy_hugetlb_page_range()

Let's do it just like copy_page_range(), taking the seqlock and making
sure the mmap_lock is held in write mode.

This allows for add a VM_BUG_ON to page_needs_cow_for_dma() and properly
synchronizes concurrent fork() with GUP-fast of hugetlb pages, which will
be relevant for further changes.

Link: https://lkml.kernel.org/r/20220428083441.37290-3-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: David Rientjes <rientjes@google.com>
Cc: Don Dutile <ddutile@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Jann Horn <jannh@google.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Khalid Aziz <khalid.aziz@oracle.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Liang Zhang <zhangliang5@huawei.com>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Mike Rapoport <rppt@linux.ibm.com>
Cc: Nadav Amit <namit@vmware.com>
Cc: Oded Gabbay <oded.gabbay@gmail.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Pedro Demarchi Gomes <pedrodemargomes@gmail.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Roman Gushchin <guro@fb.com>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Yang Shi <shy828301@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    4 ++++
 mm/hugetlb.c       |    8 ++++++--
 2 files changed, 10 insertions(+), 2 deletions(-)

--- a/include/linux/mm.h~mm-hugetlb-take-src_mm-write_protect_seq-in-copy_hugetlb_page_range
+++ a/include/linux/mm.h
@@ -1576,6 +1576,8 @@ static inline bool page_maybe_dma_pinned
 /*
  * This should most likely only be called during fork() to see whether we
  * should break the cow immediately for a page on the src mm.
+ *
+ * The caller has to hold the PT lock and the vma->vm_mm->->write_protect_seq.
  */
 static inline bool page_needs_cow_for_dma(struct vm_area_struct *vma,
 					  struct page *page)
@@ -1583,6 +1585,8 @@ static inline bool page_needs_cow_for_dm
 	if (!is_cow_mapping(vma->vm_flags))
 		return false;
 
+	VM_BUG_ON(!(raw_read_seqcount(&vma->vm_mm->write_protect_seq) & 1));
+
 	if (!test_bit(MMF_HAS_PINNED, &vma->vm_mm->flags))
 		return false;
 
--- a/mm/hugetlb.c~mm-hugetlb-take-src_mm-write_protect_seq-in-copy_hugetlb_page_range
+++ a/mm/hugetlb.c
@@ -4735,6 +4735,8 @@ int copy_hugetlb_page_range(struct mm_st
 					vma->vm_start,
 					vma->vm_end);
 		mmu_notifier_invalidate_range_start(&range);
+		mmap_assert_write_locked(src);
+		raw_write_seqcount_begin(&src->write_protect_seq);
 	} else {
 		/*
 		 * For shared mappings i_mmap_rwsem must be held to call
@@ -4867,10 +4869,12 @@ again:
 		spin_unlock(dst_ptl);
 	}
 
-	if (cow)
+	if (cow) {
+		raw_write_seqcount_end(&src->write_protect_seq);
 		mmu_notifier_invalidate_range_end(&range);
-	else
+	} else {
 		i_mmap_unlock_read(mapping);
+	}
 
 	return ret;
 }
_

Patches currently in -mm which might be from david@redhat.com are


