Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44C44C433F5
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:40:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2591F610F7
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:40:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233937AbhKKCnZ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 10 Nov 2021 21:43:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:48918 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233906AbhKKCnZ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 10 Nov 2021 21:43:25 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 99AC661284;
        Thu, 11 Nov 2021 02:40:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636598436;
        bh=IWXf5C4+A7tI0V+NGYsmtPEE4wAPp5k1H08p24aTrN8=;
        h=Date:From:To:Subject:From;
        b=UBZRx5XHpOLsZs/QslD/IO2jV7XUVyllRXWjnm+iyjtXZ0liTwH5ORQWqYXQqxRIL
         XkxZl3Kfek7Zzj9/Y6If/l08zpU9EXNLS0UFwsC59Sbu3M6gYsyP6PkE0lIzFtbCTU
         bUZZNtGWX+AhTRM2Zz7yopaoWPyD3ygSiQFD2QvY=
Date:   Wed, 10 Nov 2021 18:40:36 -0800
From:   akpm@linux-foundation.org
To:     aarcange@redhat.com, hughd@google.com, mm-commits@vger.kernel.org,
        peterx@redhat.com, vbabka@suse.cz, willy@infradead.org
Subject:  [merged]
 mm-smaps-use-vma-vm_pgoff-directly-when-counting-partial-swap.patch removed
 from -mm tree
Message-ID: <20211111024036.7to_4ds5m%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/smaps: use vma->vm_pgoff directly when counting partial swap
has been removed from the -mm tree.  Its filename was
     mm-smaps-use-vma-vm_pgoff-directly-when-counting-partial-swap.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Peter Xu <peterx@redhat.com>
Subject: mm/smaps: use vma->vm_pgoff directly when counting partial swap

As it's trying to cover the whole vma anyways, use direct vm_pgoff value
and vma_pages() rather than linear_page_index.

Link: https://lkml.kernel.org/r/20210917164756.8586-3-peterx@redhat.com
Signed-off-by: Peter Xu <peterx@redhat.com>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Hugh Dickins <hughd@google.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/mm/shmem.c~mm-smaps-use-vma-vm_pgoff-directly-when-counting-partial-swap
+++ a/mm/shmem.c
@@ -856,9 +856,8 @@ unsigned long shmem_swap_usage(struct vm
 		return swapped << PAGE_SHIFT;
 
 	/* Here comes the more involved part */
-	return shmem_partial_swap_usage(mapping,
-			linear_page_index(vma, vma->vm_start),
-			linear_page_index(vma, vma->vm_end));
+	return shmem_partial_swap_usage(mapping, vma->vm_pgoff,
+					vma->vm_pgoff + vma_pages(vma));
 }
 
 /*
_

Patches currently in -mm which might be from peterx@redhat.com are


