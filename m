Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B758C49EA6
	for <mm-commits@archiver.kernel.org>; Fri, 25 Jun 2021 01:31:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3A279613B9
	for <mm-commits@archiver.kernel.org>; Fri, 25 Jun 2021 01:31:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232873AbhFYBdV (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Jun 2021 21:33:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:56474 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229712AbhFYBdV (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 24 Jun 2021 21:33:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1B44A613B7;
        Fri, 25 Jun 2021 01:31:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1624584660;
        bh=IjKRqZn1ZNl7rz+ryXU2hlRL8Yyor4lmA41D5NbNmmw=;
        h=Date:From:To:Subject:From;
        b=WJLEQpwsgdFJfgCCGJCU+2b/5g5CbsW9SS893zjfxFRbDyF6u8N/vX5Fn96u51p4o
         xgzyB0rAKOHy0gezNnFB2UEOEuPfa5ImJITjao63X7cnvYxYX0NiArUCOQ2FeT3Yu2
         gPNI9PIpgqKjFrF012Ti6Bvab5AQHzQBVYmm1Kok=
Date:   Thu, 24 Jun 2021 18:30:59 -0700
From:   akpm@linux-foundation.org
To:     hughd@google.com, mm-commits@vger.kernel.org
Subject:  [folded-merged]
 mm-page_vma_mapped_walk-add-a-level-of-indentation-fix.patch removed from
 -mm tree
Message-ID: <20210625013059.UzTCx275R%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: page_vma_mapped_walk(): add a level of indentation fix
has been removed from the -mm tree.  Its filename was
     mm-page_vma_mapped_walk-add-a-level-of-indentation-fix.patch

This patch was dropped because it was folded into mm-page_vma_mapped_walk-add-a-level-of-indentation.patch

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: mm: page_vma_mapped_walk(): add a level of indentation fix

add a tab to the READ_ONCE line in the indentation patch.

Link: https://lkml.kernel.org/r/7f817555-3ce1-c785-e438-87d8efdcaf26@google.com
Signed-off-by: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_vma_mapped.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/page_vma_mapped.c~mm-page_vma_mapped_walk-add-a-level-of-indentation-fix
+++ a/mm/page_vma_mapped.c
@@ -190,7 +190,7 @@ restart:
 		 * compiler and used as a stale value after we've observed a
 		 * subsequent update.
 		 */
-	pmde = READ_ONCE(*pvmw->pmd);
+		pmde = READ_ONCE(*pvmw->pmd);
 
 		if (pmd_trans_huge(pmde) || is_pmd_migration_entry(pmde)) {
 			pvmw->ptl = pmd_lock(mm, pvmw->pmd);
_

Patches currently in -mm which might be from hughd@google.com are

mm-page_vma_mapped_walk-use-page-for-pvmw-page.patch
mm-page_vma_mapped_walk-settle-pagehuge-on-entry.patch
mm-page_vma_mapped_walk-use-pmde-for-pvmw-pmd.patch
mm-page_vma_mapped_walk-prettify-pvmw_migration-block.patch
mm-page_vma_mapped_walk-crossing-page-table-boundary.patch
mm-page_vma_mapped_walk-add-a-level-of-indentation.patch
mm-page_vma_mapped_walk-use-goto-instead-of-while-1.patch
mm-page_vma_mapped_walk-get-vma_address_end-earlier.patch
mm-thp-fix-page_vma_mapped_walk-if-thp-mapped-by-ptes.patch
mm-thp-another-pvmw_sync-fix-in-page_vma_mapped_walk.patch
mm-futex-fix-shared-futex-pgoff-on-shmem-huge-page.patch
mm-thp-remap_page-is-only-needed-on-anonymous-thp.patch
mm-hwpoison_user_mappings-try_to_unmap-with-ttu_sync.patch

