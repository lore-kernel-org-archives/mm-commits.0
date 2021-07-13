Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A04EEC07E95
	for <mm-commits@archiver.kernel.org>; Tue, 13 Jul 2021 22:41:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8577C61289
	for <mm-commits@archiver.kernel.org>; Tue, 13 Jul 2021 22:41:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236693AbhGMWoc (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 13 Jul 2021 18:44:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:50656 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235536AbhGMWoc (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 13 Jul 2021 18:44:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9BFB261288;
        Tue, 13 Jul 2021 22:41:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1626216100;
        bh=KMzl0paWE+un7B8KiAea8uYtxIdjDHYCLru/qUxq/gw=;
        h=Date:From:To:Subject:From;
        b=MMZ4xPzX9P/jNkdQehAxNd+iEsQ9yw7W4bYMA4zNz0aSdzhRMuwkqz1fdgwsPNk2y
         55Gmq/MoVj2VFSVcrBigiVkbp8kvqjDPHychdIr4qzUNGgBnus+ANAzCt0t/jwaz74
         j24r3dfbaVZVa+BEMTHygX6CZzqhIExu14ml/OhY=
Date:   Tue, 13 Jul 2021 15:41:40 -0700
From:   akpm@linux-foundation.org
To:     apopple@nvidia.com, hch@lst.de, hughd@google.com, jgg@nvidia.com,
        kirill.shutemov@linux.intel.com, mm-commits@vger.kernel.org,
        rcampbell@nvidia.com, shakeelb@google.com, shy828301@gmail.com
Subject:  [merged]
 mm-rmap-fix-new-bug-premature-return-from-page_mlock_one.patch removed from
 -mm tree
Message-ID: <20210713224140.QXgZZ77dQ%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/rmap: fix new bug: premature return from page_mlock_one()
has been removed from the -mm tree.  Its filename was
     mm-rmap-fix-new-bug-premature-return-from-page_mlock_one.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: mm/rmap: fix new bug: premature return from page_mlock_one()

In the unlikely race case that page_mlock_one() finds VM_LOCKED has been
cleared by the time it got page table lock, page_vma_mapped_walk_done()
must be called before returning, either explicitly, or by a final call to
page_vma_mapped_walk() - otherwise the page table remains locked.

Link: https://lkml.kernel.org/r/f71f8523-cba7-3342-40a7-114abc5d1f51@google.com
Fixes: cd62734ca60d ("mm/rmap: split try_to_munlock from try_to_unmap")
Signed-off-by: Hugh Dickins <hughd@google.com>
Reviewed-by: Shakeel Butt <shakeelb@google.com>
Reviewed-by: Alistair Popple <apopple@nvidia.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Ralph Campbell <rcampbell@nvidia.com>
Cc: Yang Shi <shy828301@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/rmap.c |   11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

--- a/mm/rmap.c~mm-rmap-fix-new-bug-premature-return-from-page_mlock_one
+++ a/mm/rmap.c
@@ -1991,14 +1991,13 @@ static bool page_mlock_one(struct page *
 			 * after DoubleMap was cleared).
 			 */
 			mlock_vma_page(page);
+			/*
+			 * No need to scan further once the page is marked
+			 * as mlocked.
+			 */
 			page_vma_mapped_walk_done(&pvmw);
+			return false;
 		}
-
-		/*
-		 * no need to continue scanning other vma's if the page has
-		 * been locked.
-		 */
-		return false;
 	}
 
 	return true;
_

Patches currently in -mm which might be from hughd@google.com are

fs-mm-fix-race-in-unlinking-swapfile.patch

