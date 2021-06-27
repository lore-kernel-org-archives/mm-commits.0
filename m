Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB144C48BC2
	for <mm-commits@archiver.kernel.org>; Sun, 27 Jun 2021 21:53:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 95A1E61C31
	for <mm-commits@archiver.kernel.org>; Sun, 27 Jun 2021 21:53:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231792AbhF0V4A (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 27 Jun 2021 17:56:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:54622 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231694AbhF0V4A (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 27 Jun 2021 17:56:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9A47761C32;
        Sun, 27 Jun 2021 21:53:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1624830815;
        bh=sj4vd0fVKLcozEJ0UqHt9MZyEkIwrnf2pHwsqAbhO8w=;
        h=Date:From:To:Subject:From;
        b=eQCN4LTIj6YKBD7kdd9h3xTyn3cPzjVLZafQ0QwaL7PdsLywQyFlTQENL7blHHH4z
         Nrgsi0tT1/HEw/RmGPdz2+tEkT/gyqZIk5/suXlrg+U4Hlm7lFoFZ3HRqvyDtcPg4T
         PlOHFR2wW3/Zqs7828xZFGeWi7xyJPwUP0OC1OGY=
Date:   Sun, 27 Jun 2021 14:53:34 -0700
From:   akpm@linux-foundation.org
To:     apopple@nvidia.com, hughd@google.com,
        kirill.shutemov@linux.intel.com, mm-commits@vger.kernel.org,
        peterx@redhat.com, rcampbell@nvidia.com, shy828301@gmail.com,
        stable@vger.kernel.org, wangyugui@e16-tech.com, will@kernel.org,
        willy@infradead.org, ziy@nvidia.com
Subject:  [merged]
 mm-page_vma_mapped_walk-crossing-page-table-boundary.patch removed from -mm
 tree
Message-ID: <20210627215334.CXLfCSd_m%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: page_vma_mapped_walk(): crossing page table boundary
has been removed from the -mm tree.  Its filename was
     mm-page_vma_mapped_walk-crossing-page-table-boundary.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: mm: page_vma_mapped_walk(): crossing page table boundary

page_vma_mapped_walk() cleanup: adjust the test for crossing page table
boundary - I believe pvmw->address is always page-aligned, but nothing
else here assumed that; and remember to reset pvmw->pte to NULL after
unmapping the page table, though I never saw any bug from that.

Link: https://lkml.kernel.org/r/799b3f9c-2a9e-dfef-5d89-26e9f76fd97@google.com
Signed-off-by: Hugh Dickins <hughd@google.com>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Peter Xu <peterx@redhat.com>
Cc: Ralph Campbell <rcampbell@nvidia.com>
Cc: Wang Yugui <wangyugui@e16-tech.com>
Cc: Will Deacon <will@kernel.org>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_vma_mapped.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/mm/page_vma_mapped.c~mm-page_vma_mapped_walk-crossing-page-table-boundary
+++ a/mm/page_vma_mapped.c
@@ -244,16 +244,16 @@ next_pte:
 			if (pvmw->address >= end)
 				return not_found(pvmw);
 			/* Did we cross page table boundary? */
-			if (pvmw->address % PMD_SIZE == 0) {
-				pte_unmap(pvmw->pte);
+			if ((pvmw->address & (PMD_SIZE - PAGE_SIZE)) == 0) {
 				if (pvmw->ptl) {
 					spin_unlock(pvmw->ptl);
 					pvmw->ptl = NULL;
 				}
+				pte_unmap(pvmw->pte);
+				pvmw->pte = NULL;
 				goto restart;
-			} else {
-				pvmw->pte++;
 			}
+			pvmw->pte++;
 		} while (pte_none(*pvmw->pte));
 
 		if (!pvmw->ptl) {
_

Patches currently in -mm which might be from hughd@google.com are

mm-thp-remap_page-is-only-needed-on-anonymous-thp.patch
mm-hwpoison_user_mappings-try_to_unmap-with-ttu_sync.patch

