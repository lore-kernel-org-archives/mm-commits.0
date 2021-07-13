Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4531C07E95
	for <mm-commits@archiver.kernel.org>; Tue, 13 Jul 2021 22:41:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CAD1361288
	for <mm-commits@archiver.kernel.org>; Tue, 13 Jul 2021 22:41:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236687AbhGMWo2 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 13 Jul 2021 18:44:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:50628 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235536AbhGMWo2 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 13 Jul 2021 18:44:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A1D2961279;
        Tue, 13 Jul 2021 22:41:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1626216098;
        bh=H2Ur56qMUEIVS9LjOQyuYF8oMlNiUPxkvomy/Pih9W4=;
        h=Date:From:To:Subject:From;
        b=xt2NEDmvlBfjN9IkGrbP5PHTkO4EWAKavtaFE5kjET88AC3MU1/YtcQjK/Q6ldLDq
         MzagntXGn5lgjhQ0mWW0Usp0q+pXdiT02bj8piiNAhZzuAUpZCjV62X8QZgJuuOl0y
         2UndLP+7i7k5HOwhu+9x6RpiiDGzPAbKF/RnUI+o=
Date:   Tue, 13 Jul 2021 15:41:37 -0700
From:   akpm@linux-foundation.org
To:     apopple@nvidia.com, hch@lst.de, hughd@google.com, jgg@nvidia.com,
        kirill.shutemov@linux.intel.com, mm-commits@vger.kernel.org,
        rcampbell@nvidia.com, shakeelb@google.com, shy828301@gmail.com
Subject:  [merged]
 mm-rmap-fix-old-bug-munlocking-thp-missed-other-mlocks.patch removed from
 -mm tree
Message-ID: <20210713224137.8mmlbQecl%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/rmap: fix old bug: munlocking THP missed other mlocks
has been removed from the -mm tree.  Its filename was
     mm-rmap-fix-old-bug-munlocking-thp-missed-other-mlocks.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: mm/rmap: fix old bug: munlocking THP missed other mlocks

The kernel recovers in due course from missing Mlocked pages: but there
was no point in calling page_mlock() (formerly known as try_to_munlock())
on a THP, because nothing got done even when it was found to be mapped in
another VM_LOCKED vma.

It's true that we need to be careful: Mlocked accounting of pte-mapped
THPs is too difficult (so consistently avoided); but Mlocked accounting of
only-pmd-mapped file THPs is supposed to work, even when multiple mappings
are mlocked and munlocked or munmapped.  Refine the tests.

Many thanks to Kirill for reminding that PageDoubleMap cannot be relied on
to warn of pte mappings in the Anon THP case; and a scan of subpages does
not seem appropriate here.  Note how follow_trans_huge_pmd() does not even
mark an Anon THP as mlocked when compound_mapcount != 1: multiple mlocking
of Anon THP is avoided, so simply return from page_mlock() in this case.

I said the kernel recovers: but would page reclaim be likely to split THP
before rediscovering that it's VM_LOCKED?  Apparently so.  I have worked
on a fix for that, but it's a different issue, and not something to rush. 
Whereas page_mlock_one() could not be reviewed without fixing this first.

Link: https://lkml.kernel.org/r/6c4d46aa-4d73-76a7-bcce-a09024768f63@google.com
Fixes: 9a73f61bdb8a ("thp, mlock: do not mlock PTE-mapped file huge pages")
Signed-off-by: Hugh Dickins <hughd@google.com>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Ralph Campbell <rcampbell@nvidia.com>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Yang Shi <shy828301@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/rmap.c |   42 +++++++++++++++++++++++++-----------------
 1 file changed, 25 insertions(+), 17 deletions(-)

--- a/mm/rmap.c~mm-rmap-fix-old-bug-munlocking-thp-missed-other-mlocks
+++ a/mm/rmap.c
@@ -1440,20 +1440,20 @@ static bool try_to_unmap_one(struct page
 		/*
 		 * If the page is mlock()d, we cannot swap it out.
 		 */
-		if (!(flags & TTU_IGNORE_MLOCK)) {
-			if (vma->vm_flags & VM_LOCKED) {
-				/* PTE-mapped THP are never mlocked */
-				if (!PageTransCompound(page)) {
-					/*
-					 * Holding pte lock, we do *not* need
-					 * mmap_lock here
-					 */
-					mlock_vma_page(page);
-				}
-				ret = false;
-				page_vma_mapped_walk_done(&pvmw);
-				break;
-			}
+		if (!(flags & TTU_IGNORE_MLOCK) &&
+		    (vma->vm_flags & VM_LOCKED)) {
+			/*
+			 * PTE-mapped THP are never marked as mlocked: so do
+			 * not set it on a DoubleMap THP, nor on an Anon THP
+			 * (which may still be PTE-mapped after DoubleMap was
+			 * cleared).  But stop unmapping even in those cases.
+			 */
+			if (!PageTransCompound(page) || (PageHead(page) &&
+			     !PageDoubleMap(page) && !PageAnon(page)))
+				mlock_vma_page(page);
+			page_vma_mapped_walk_done(&pvmw);
+			ret = false;
+			break;
 		}
 
 		/* Unexpected PMD-mapped THP? */
@@ -1984,9 +1984,13 @@ static bool page_mlock_one(struct page *
 		 * munlock_vma_pages_range().
 		 */
 		if (vma->vm_flags & VM_LOCKED) {
-			/* PTE-mapped THP are never mlocked */
-			if (!PageTransCompound(page))
-				mlock_vma_page(page);
+			/*
+			 * PTE-mapped THP are never marked as mlocked; but
+			 * this function is never called on a DoubleMap THP,
+			 * nor on an Anon THP (which may still be PTE-mapped
+			 * after DoubleMap was cleared).
+			 */
+			mlock_vma_page(page);
 			page_vma_mapped_walk_done(&pvmw);
 		}
 
@@ -2020,6 +2024,10 @@ void page_mlock(struct page *page)
 	VM_BUG_ON_PAGE(!PageLocked(page) || PageLRU(page), page);
 	VM_BUG_ON_PAGE(PageCompound(page) && PageDoubleMap(page), page);
 
+	/* Anon THP are only marked as mlocked when singly mapped */
+	if (PageTransCompound(page) && PageAnon(page))
+		return;
+
 	rmap_walk(page, &rwc);
 }
 
_

Patches currently in -mm which might be from hughd@google.com are

fs-mm-fix-race-in-unlinking-swapfile.patch

