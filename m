Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3B80C07E9E
	for <mm-commits@archiver.kernel.org>; Fri,  9 Jul 2021 23:15:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 990F461380
	for <mm-commits@archiver.kernel.org>; Fri,  9 Jul 2021 23:15:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230354AbhGIXSX (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 9 Jul 2021 19:18:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:56634 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230345AbhGIXSW (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 9 Jul 2021 19:18:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8EDB4613BF;
        Fri,  9 Jul 2021 23:15:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625872537;
        bh=U51RE11hWx5sHLVpVCSzBMkAOuKoOQ3PHSKuCgJsFEs=;
        h=Date:From:To:Subject:From;
        b=rmq30FEKhSsNJEGOlXamk1SgVjxavITFmUHMjFnVAAMu0saP9oGnaUwZmhU0NcjiL
         Z8X0J/m7tJve6MigvvNk4hjsJegQe++qrIEMVi8Bbo+0x96ilFLzxTHtCRrfhKjdNV
         FlFC/CGS7yJQ8ZZgnY1YsrYeCTh/BQBVUht1rcXs=
Date:   Fri, 09 Jul 2021 16:15:37 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, shy828301@gmail.com,
        shakeelb@google.com, rcampbell@nvidia.com,
        kirill.shutemov@linux.intel.com, jgg@nvidia.com, hch@lst.de,
        apopple@nvidia.com, hughd@google.com
Subject:  +
 mm-rmap-fix-new-bug-premature-return-from-page_mlock_one.patch added to -mm
 tree
Message-ID: <20210709231537.9l6O6%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/rmap: fix new bug: premature return from page_mlock_one()
has been added to the -mm tree.  Its filename is
     mm-rmap-fix-new-bug-premature-return-from-page_mlock_one.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-rmap-fix-new-bug-premature-return-from-page_mlock_one.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-rmap-fix-new-bug-premature-return-from-page_mlock_one.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm-rmap-fix-comments-left-over-from-recent-changes.patch
mm-rmap-fix-old-bug-munlocking-thp-missed-other-mlocks.patch
mm-rmap-fix-new-bug-premature-return-from-page_mlock_one.patch
mm-rmap-try_to_migrate-skip-zone_device-device_private.patch
fs-mm-fix-race-in-unlinking-swapfile.patch

