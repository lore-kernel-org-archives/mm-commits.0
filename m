Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C715AC433F5
	for <mm-commits@archiver.kernel.org>; Sun, 19 Sep 2021 23:05:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ADF8B60E52
	for <mm-commits@archiver.kernel.org>; Sun, 19 Sep 2021 23:05:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230143AbhISXGj (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 19 Sep 2021 19:06:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:39616 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229778AbhISXGj (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 19 Sep 2021 19:06:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4B6D361183;
        Sun, 19 Sep 2021 23:05:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1632092713;
        bh=0eFuy6nj7w9bdmYaHHuaRa8xedowgb5LCSYl5zL0aRk=;
        h=Date:From:To:Subject:From;
        b=pOa/9Por+IEAWxUyO4NOyAdrtJpRbAA74ULEGab/vh6p+t/rUj+xk6q5dPJbZXXC1
         rBerDKt4/MDycIk77TIoHRnJZRB+2hG4778TVqZ8wh8Yljpgdqjc7/pgwslUHtfr2y
         a485guQXU665M4zNcUwfW3TSzud9rPdLnH3tjIl0=
Date:   Sun, 19 Sep 2021 16:05:12 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, willy@infradead.org, vbabka@suse.cz,
        hughd@google.com, aarcange@redhat.com, peterx@redhat.com
Subject:  +
 mm-smaps-use-vma-vm_pgoff-directly-when-counting-partial-swap.patch added to
 -mm tree
Message-ID: <20210919230512.qAPO7%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/smaps: use vma->vm_pgoff directly when counting partial swap
has been added to the -mm tree.  Its filename is
     mm-smaps-use-vma-vm_pgoff-directly-when-counting-partial-swap.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-smaps-use-vma-vm_pgoff-directly-when-counting-partial-swap.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-smaps-use-vma-vm_pgoff-directly-when-counting-partial-swap.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Peter Xu <peterx@redhat.com>
Subject: mm/smaps: use vma->vm_pgoff directly when counting partial swap

As it's trying to cover the whole vma anyways, use direct vm_pgoff value
and vma_pages() rather than linear_page_index.

Link: https://lkml.kernel.org/r/20210917164756.8586-3-peterx@redhat.com
Signed-off-by: Peter Xu <peterx@redhat.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
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

mm-smaps-fix-shmem-pte-hole-swap-calculation.patch
mm-smaps-use-vma-vm_pgoff-directly-when-counting-partial-swap.patch
mm-smaps-simplify-shmem-handling-of-pte-holes.patch
mm-shmem-unconditionally-set-pte-dirty-in-mfill_atomic_install_pte.patch
mm-clear-vmf-pte-after-pte_unmap_same-returns.patch
mm-drop-first_index-last_index-in-zap_details.patch
mm-add-zap_skip_check_mapping-helper.patch

