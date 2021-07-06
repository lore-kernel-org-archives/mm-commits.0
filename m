Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09ABFC07E9B
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:12:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E70A461206
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:12:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231845AbhGFTOy (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 6 Jul 2021 15:14:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:49176 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231795AbhGFTOy (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 6 Jul 2021 15:14:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6C2AB6117A;
        Tue,  6 Jul 2021 19:12:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625598734;
        bh=0e7+bARF3Gy+b+EyC0bPix8EVNq2+X2NcbLuuSyfxu8=;
        h=Date:From:To:Subject:From;
        b=LkU2uIqIUIV1/On73E7Ag7Cb46KwkhUzLvEO9KUxvcX7BarQ/oUA7Vq8U3+h5OqfD
         AP6CiT0I+j4zMevuqeaGxKNqXxN3XSnK3/2BjUI/qc7ilp+aVlbAICXBeZ1jBok9PJ
         PXo4HHUrW+LzcK7trxSPVLzvKPrgArvBjnHqluDg=
Date:   Tue, 06 Jul 2021 12:12:14 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, david@redhat.com,
        gmjuareztello@gmail.com, mm-commits@vger.kernel.org
Subject:  [merged]
 mm-mmapc-logic-of-find_vma_intersection-repeated-in-__do_munmap.patch
 removed from -mm tree
Message-ID: <20210706191214.jANL4gsN9%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mmap.c: logic of find_vma_intersection repeated in __do_munmap
has been removed from the -mm tree.  Its filename was
     mm-mmapc-logic-of-find_vma_intersection-repeated-in-__do_munmap.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Gonzalo Matias Juarez Tello <gmjuareztello@gmail.com>
Subject: mm/mmap.c: logic of find_vma_intersection repeated in __do_munmap

Logic of find_vma_intersection() is repeated in __do_munmap().

Also, prev is assigned a value before checking vma->vm_start >= end which
might end up on a return statement making that assignment useless.

Calling find_vma_intersection() checks that condition and returns NULL if
no vma is found, hence only the !vma check is needed in __do_munmap().

Link: https://lkml.kernel.org/r/20210409162129.18313-1-gmjuareztello@gmail.com
Signed-off-by: Gonzalo Matias Juarez Tello <gmjuareztello@gmail.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |    9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

--- a/mm/mmap.c~mm-mmapc-logic-of-find_vma_intersection-repeated-in-__do_munmap
+++ a/mm/mmap.c
@@ -2828,16 +2828,11 @@ int __do_munmap(struct mm_struct *mm, un
 	 */
 	arch_unmap(mm, start, end);
 
-	/* Find the first overlapping VMA */
-	vma = find_vma(mm, start);
+	/* Find the first overlapping VMA where start < vma->vm_end */
+	vma = find_vma_intersection(mm, start, end);
 	if (!vma)
 		return 0;
 	prev = vma->vm_prev;
-	/* we have  start < vma->vm_end  */
-
-	/* if it doesn't overlap, we have nothing.. */
-	if (vma->vm_start >= end)
-		return 0;
 
 	/*
 	 * If we need to split any vma, do it now to save pain later.
_

Patches currently in -mm which might be from gmjuareztello@gmail.com are


