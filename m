Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A8D2C433EF
	for <mm-commits@archiver.kernel.org>; Thu,  3 Feb 2022 22:22:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355768AbiBCWV7 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 3 Feb 2022 17:21:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229910AbiBCWV7 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 3 Feb 2022 17:21:59 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F8EFC061714
        for <mm-commits@vger.kernel.org>; Thu,  3 Feb 2022 14:21:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 66CA3B835A3
        for <mm-commits@vger.kernel.org>; Thu,  3 Feb 2022 22:21:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAA01C340E8;
        Thu,  3 Feb 2022 22:21:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1643926916;
        bh=dPkD3U71qbnlYNUMviritDZNBxuW9ib9x77UciTARr8=;
        h=Date:To:From:Subject:From;
        b=OjNn5X8ym9xTBFdRwYQYUiihT9LR0F5C8ozjGQ8DpNdxRu4IOmaXo3+lxDryAuCZS
         p6tccYI/cuCYDb7zpVar0UxmZB3fQ2PBY8ADoX5CYKfNZDxbMbUg1rgJqGeD6T8HJu
         RqRgZZ3bkyJ5h3mRCwAow2NQxLd63JV5FKBxMSmA=
Received: by hp1 (sSMTP sendmail emulation); Thu, 03 Feb 2022 14:21:54 -0800
Date:   Thu, 03 Feb 2022 14:21:54 -0800
To:     mm-commits@vger.kernel.org, peterx@redhat.com,
        kirill.shutemov@linux.intel.com, jgg@ziepe.ca, jgg@nvidia.com,
        jack@suse.cz, hch@lst.de, david@redhat.com,
        alex.williamson@redhat.com, aarcange@redhat.com,
        jhubbard@nvidia.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-gup-clean-up-follow_pfn_pte-slightly.patch removed from -mm tree
Message-Id: <20220203222154.BAA01C340E8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/gup: clean up follow_pfn_pte() slightly
has been removed from the -mm tree.  Its filename was
     mm-gup-clean-up-follow_pfn_pte-slightly.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: John Hubbard <jhubbard@nvidia.com>
Subject: mm/gup: clean up follow_pfn_pte() slightly

Regardless of any FOLL_* flags, get_user_pages() and its variants should
handle PFN-only entries by stopping early, if the caller expected **pages
to be filled in.

This makes for a more reliable API, as compared to the previous approach
of skipping over such entries (and thus leaving them silently unwritten).

Link: https://lkml.kernel.org/r/20220201101108.306062-3-jhubbard@nvidia.com
Signed-off-by: John Hubbard <jhubbard@nvidia.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Alex Williamson <alex.williamson@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/gup.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

--- a/mm/gup.c~mm-gup-clean-up-follow_pfn_pte-slightly
+++ a/mm/gup.c
@@ -439,10 +439,6 @@ static struct page *no_page_table(struct
 static int follow_pfn_pte(struct vm_area_struct *vma, unsigned long address,
 		pte_t *pte, unsigned int flags)
 {
-	/* No page to get reference */
-	if (flags & (FOLL_GET | FOLL_PIN))
-		return -EFAULT;
-
 	if (flags & FOLL_TOUCH) {
 		pte_t entry = *pte;
 
@@ -1180,8 +1176,14 @@ retry:
 		} else if (PTR_ERR(page) == -EEXIST) {
 			/*
 			 * Proper page table entry exists, but no corresponding
-			 * struct page.
+			 * struct page. If the caller expects **pages to be
+			 * filled in, bail out now, because that can't be done
+			 * for this page.
 			 */
+			if (pages) {
+				page = ERR_PTR(-EFAULT);
+				goto out;
+			}
 			goto next_page;
 		} else if (IS_ERR(page)) {
 			ret = PTR_ERR(page);
_

Patches currently in -mm which might be from jhubbard@nvidia.com are

mm-gup-remove-unused-pin_user_pages_locked.patch
mm-gup-remove-get_user_pages_locked.patch

