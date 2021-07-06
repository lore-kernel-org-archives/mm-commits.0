Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27D68C07E96
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:12:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0EF1D6128D
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:12:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231696AbhGFTO7 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 6 Jul 2021 15:14:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:49222 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231700AbhGFTO6 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 6 Jul 2021 15:14:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7EBC060FEE;
        Tue,  6 Jul 2021 19:12:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625598738;
        bh=wGruj1Yxrlge/Ap6irQEls4fLtvGCRL0XM/1nla+wRQ=;
        h=Date:From:To:Subject:From;
        b=vMm6DViJbTnJ11XI/0oeE0viwALaorc72raDtPvJ6ch5n+N3ThNfT8xlD+mEjvESI
         Ay//27Uc0euuTnqDLA1xFPd5J7QZyyjW8f6bs//0DTzBu1iOmKFwKnQnSLUC99cH8P
         S8UEBo85QtULiZFwKBsfezBufNBZFXU3KSs2plKQ=
Date:   Tue, 06 Jul 2021 12:12:18 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, Liam.Howlett@Oracle.com,
        mm-commits@vger.kernel.org
Subject:  [merged]
 mm-mmap-use-find_vma_intersection-in-do_mmap-for-overlap.patch removed from
 -mm tree
Message-ID: <20210706191218.UDpki6lZw%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mmap: use find_vma_intersection() in do_mmap() for overlap
has been removed from the -mm tree.  Its filename was
     mm-mmap-use-find_vma_intersection-in-do_mmap-for-overlap.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Liam Howlett <liam.howlett@oracle.com>
Subject: mm/mmap: use find_vma_intersection() in do_mmap() for overlap

Using find_vma_intersection() avoids the need for a temporary variable and
makes the code cleaner.

Link: https://lkml.kernel.org/r/20210511014328.2902782-1-Liam.Howlett@Oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@Oracle.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/mm/mmap.c~mm-mmap-use-find_vma_intersection-in-do_mmap-for-overlap
+++ a/mm/mmap.c
@@ -1457,9 +1457,7 @@ unsigned long do_mmap(struct file *file,
 		return addr;
 
 	if (flags & MAP_FIXED_NOREPLACE) {
-		struct vm_area_struct *vma = find_vma(mm, addr);
-
-		if (vma && vma->vm_start < addr + len)
+		if (find_vma_intersection(mm, addr, addr + len))
 			return -EEXIST;
 	}
 
_

Patches currently in -mm which might be from liam.howlett@oracle.com are


