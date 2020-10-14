Return-Path: <SRS0=lrFz=DV=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ABAA8C433E7
	for <mm-commits@archiver.kernel.org>; Wed, 14 Oct 2020 21:07:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 332CB206B2
	for <mm-commits@archiver.kernel.org>; Wed, 14 Oct 2020 21:07:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602709641;
	bh=birVLMY9tXJ9BrGKVPiEvjvHrkgMgvXD+dtuVHrEWXk=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=YYPLlKiv6a9t9i1EXi6i9pAh48eHuHacGnKtHmE84crkuIfl+VwfniMbcisYd5rd7
	 LUyuBLyy2JZN9arbVOLZSjePUhikLMksXzDDM5YUYmApwPndpNHTNtACce3dmGAG+n
	 xoqkuGSGLZNkxQknWQZWFWw7OsfY8E/kuyz6SGjU=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727704AbgJNVHU (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 14 Oct 2020 17:07:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:57180 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727242AbgJNVHU (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 14 Oct 2020 17:07:20 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 901A52068E;
        Wed, 14 Oct 2020 21:01:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602709274;
        bh=birVLMY9tXJ9BrGKVPiEvjvHrkgMgvXD+dtuVHrEWXk=;
        h=Date:From:To:Subject:From;
        b=MFd95qhRAEF6gzYUh3RQR+Eyl5Rg1/DyeJBLSjJr1TytIwM2kGR1D+1neVZ5xMBZd
         y1tZf50YSHJoWY0gg4Oq2JB96+9yOF+gI71tcAcA/GmFmVyezZLKRnUygtAtYRzE35
         a28JYTk57JhREhLFqfSujsdQaSEGGVyKRKjymiOw=
Date:   Wed, 14 Oct 2020 14:01:14 -0700
From:   akpm@linux-foundation.org
To:     mike.kravetz@oracle.com, mm-commits@vger.kernel.org,
        richard.weiyang@linux.alibaba.com, vbabka@suse.cz
Subject:  [merged]
 =?US-ASCII?Q?mm-mmap-leave-adjust=5Fnext-as-virtual-address-instead-of?=
 =?US-ASCII?Q?-page-frame-number.patch?= removed from -mm tree
Message-ID: <20201014210114.mCY_Xqpvs%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mmap: leave adjust_next as virtual address instead of page frame number
has been removed from the -mm tree.  Its filename was
     mm-mmap-leave-adjust_next-as-virtual-address-instead-of-page-frame-number.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Wei Yang <richard.weiyang@linux.alibaba.com>
Subject: mm/mmap: leave adjust_next as virtual address instead of page frame number

Instead of converting adjust_next between bytes and pages number, let's
just store the virtual address into adjust_next.

Also, this patch fixes one typo in the comment of vma_adjust_trans_huge().

[vbabka@suse.cz: changelog tweak]
Link: http://lkml.kernel.org/r/20200828081031.11306-1-richard.weiyang@linux.alibaba.com
Signed-off-by: Wei Yang <richard.weiyang@linux.alibaba.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    4 ++--
 mm/mmap.c        |    8 ++++----
 2 files changed, 6 insertions(+), 6 deletions(-)

--- a/mm/huge_memory.c~mm-mmap-leave-adjust_next-as-virtual-address-instead-of-page-frame-number
+++ a/mm/huge_memory.c
@@ -2306,13 +2306,13 @@ void vma_adjust_trans_huge(struct vm_are
 
 	/*
 	 * If we're also updating the vma->vm_next->vm_start, if the new
-	 * vm_next->vm_start isn't page aligned and it could previously
+	 * vm_next->vm_start isn't hpage aligned and it could previously
 	 * contain an hugepage: check if we need to split an huge pmd.
 	 */
 	if (adjust_next > 0) {
 		struct vm_area_struct *next = vma->vm_next;
 		unsigned long nstart = next->vm_start;
-		nstart += adjust_next << PAGE_SHIFT;
+		nstart += adjust_next;
 		if (nstart & ~HPAGE_PMD_MASK &&
 		    (nstart & HPAGE_PMD_MASK) >= next->vm_start &&
 		    (nstart & HPAGE_PMD_MASK) + HPAGE_PMD_SIZE <= next->vm_end)
--- a/mm/mmap.c~mm-mmap-leave-adjust_next-as-virtual-address-instead-of-page-frame-number
+++ a/mm/mmap.c
@@ -758,7 +758,7 @@ int __vma_adjust(struct vm_area_struct *
 			 * vma expands, overlapping part of the next:
 			 * mprotect case 5 shifting the boundary up.
 			 */
-			adjust_next = (end - next->vm_start) >> PAGE_SHIFT;
+			adjust_next = (end - next->vm_start);
 			exporter = next;
 			importer = vma;
 			VM_WARN_ON(expand != importer);
@@ -768,7 +768,7 @@ int __vma_adjust(struct vm_area_struct *
 			 * split_vma inserting another: so it must be
 			 * mprotect case 4 shifting the boundary down.
 			 */
-			adjust_next = -((vma->vm_end - end) >> PAGE_SHIFT);
+			adjust_next = -(vma->vm_end - end);
 			exporter = vma;
 			importer = next;
 			VM_WARN_ON(expand != importer);
@@ -840,8 +840,8 @@ again:
 	}
 	vma->vm_pgoff = pgoff;
 	if (adjust_next) {
-		next->vm_start += adjust_next << PAGE_SHIFT;
-		next->vm_pgoff += adjust_next;
+		next->vm_start += adjust_next;
+		next->vm_pgoff += adjust_next >> PAGE_SHIFT;
 	}
 
 	if (root) {
_

Patches currently in -mm which might be from richard.weiyang@linux.alibaba.com are

mm-page_reporting-drop-stale-list-head-check-in-page_reporting_cycle.patch
bitops-simplify-get_count_order_long.patch
bitops-use-the-same-mechanism-for-get_count_order.patch

