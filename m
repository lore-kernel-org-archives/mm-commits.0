Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8CA0FC2B9F7
	for <mm-commits@archiver.kernel.org>; Mon, 24 May 2021 22:16:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 65B8E6142F
	for <mm-commits@archiver.kernel.org>; Mon, 24 May 2021 22:16:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233917AbhEXWRn (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 24 May 2021 18:17:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:59488 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233869AbhEXWRn (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 24 May 2021 18:17:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 12F1C6141F;
        Mon, 24 May 2021 22:16:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1621894574;
        bh=ap/jq3h4ReokAhqC9f/sZS/0vdR5+3+WdZNgLW7kTkU=;
        h=Date:From:To:Subject:From;
        b=ctnSWfOVAlKWQTHCvzGV4a5/XGrREhhyF0/Ly8axF/Jxm5WaDtId3HK+cpiJjEu4K
         EYYCpzWcdtX5UQjo/m3MfHF+rBNPKsd3tibR0xQUUBUJURXssTxpbck9s7f4UDLIoB
         g3D1HPRo/IuFa0/AAZHMzI/2Pd6tP2u7AFHIDCRs=
Date:   Mon, 24 May 2021 15:16:13 -0700
From:   akpm@linux-foundation.org
To:     apopple@nvidia.com, bsingharora@gmail.com, bskeggs@redhat.com,
        hch@lst.de, hughd@google.com, jgg@nvidia.com, jglisse@redhat.com,
        jhubbard@nvidia.com, mm-commits@vger.kernel.org, peterx@redhat.com,
        rcampbell@nvidia.com, willy@infradead.org
Subject:  +
 mm-memoryc-allow-different-return-codes-for-copy_nonpresent_pte.patch added
 to -mm tree
Message-ID: <20210524221613.vrQxhcgba%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memory.c: allow different return codes for copy_nonpresent_pte()
has been added to the -mm tree.  Its filename is
     mm-memoryc-allow-different-return-codes-for-copy_nonpresent_pte.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-memoryc-allow-different-return-codes-for-copy_nonpresent_pte.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-memoryc-allow-different-return-codes-for-copy_nonpresent_pte.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Alistair Popple <apopple@nvidia.com>
Subject: mm/memory.c: allow different return codes for copy_nonpresent_pte()

Currently if copy_nonpresent_pte() returns a non-zero value it is assumed
to be a swap entry which requires further processing outside the loop in
copy_pte_range() after dropping locks.  This prevents other values being
returned to signal conditions such as failure which a subsequent change
requires.

Instead make copy_nonpresent_pte() return an error code if further
processing is required and read the value for the swap entry in the main
loop under the ptl.

Link: https://lkml.kernel.org/r/20210524132725.12697-7-apopple@nvidia.com
Signed-off-by: Alistair Popple <apopple@nvidia.com>
Cc: Balbir Singh <bsingharora@gmail.com>
Cc: Ben Skeggs <bskeggs@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Jerome Glisse <jglisse@redhat.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Peter Xu <peterx@redhat.com>
Cc: Ralph Campbell <rcampbell@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

--- a/mm/memory.c~mm-memoryc-allow-different-return-codes-for-copy_nonpresent_pte
+++ a/mm/memory.c
@@ -718,7 +718,7 @@ copy_nonpresent_pte(struct mm_struct *ds
 
 	if (likely(!non_swap_entry(entry))) {
 		if (swap_duplicate(entry) < 0)
-			return entry.val;
+			return -EAGAIN;
 
 		/* make sure dst_mm is on swapoff's mmlist. */
 		if (unlikely(list_empty(&dst_mm->mmlist))) {
@@ -974,11 +974,13 @@ again:
 			continue;
 		}
 		if (unlikely(!pte_present(*src_pte))) {
-			entry.val = copy_nonpresent_pte(dst_mm, src_mm,
-							dst_pte, src_pte,
-							src_vma, addr, rss);
-			if (entry.val)
+			ret = copy_nonpresent_pte(dst_mm, src_mm,
+						dst_pte, src_pte,
+						src_vma, addr, rss);
+			if (ret == -EAGAIN) {
+				entry = pte_to_swp_entry(*src_pte);
 				break;
+			}
 			progress += 8;
 			continue;
 		}
_

Patches currently in -mm which might be from apopple@nvidia.com are

mm-remove-special-swap-entry-functions.patch
mm-swapops-rework-swap-entry-manipulation-code.patch
mm-rmap-split-try_to_munlock-from-try_to_unmap.patch
mm-rmap-split-migration-into-its-own-function.patch
mm-rename-migrate_pgmap_owner.patch
mm-memoryc-allow-different-return-codes-for-copy_nonpresent_pte.patch
mm-device-exclusive-memory-access.patch
mm-selftests-for-exclusive-device-memory.patch
nouveau-svm-refactor-nouveau_range_fault.patch
nouveau-svm-implement-atomic-svm-access.patch

