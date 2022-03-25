Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86A8EC433F5
	for <mm-commits@archiver.kernel.org>; Fri, 25 Mar 2022 01:30:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242867AbiCYBb5 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Mar 2022 21:31:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357333AbiCYBbt (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 24 Mar 2022 21:31:49 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8817B36146
        for <mm-commits@vger.kernel.org>; Thu, 24 Mar 2022 18:30:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 33AD9B82726
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 01:30:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0E65C340ED;
        Fri, 25 Mar 2022 01:30:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648171801;
        bh=VSqjt7tMQ3t+wYnFN7MChNKLv/eXW9xiUhE0csVxQik=;
        h=Date:To:From:Subject:From;
        b=xbVLKNWF3qidGePLVj1yO5a8J5raFoTZs2rX8wtqhRuf6ByZnEF+aI9k5mq0wCboX
         /L1IyakNpQ9FWLBll0LKuH5P6S0NuoyBQGj00d/KdB0w/QCAtUwg7IfKclbQhiJ4wA
         t0/x+4yOCM3lXE0+Cv9S4JfhrZSkG45PqmyVsPIA=
Date:   Thu, 24 Mar 2022 18:30:01 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, peterx@redhat.com,
        lukas.bulwahn@gmail.com, kirill.shutemov@linux.intel.com,
        jgg@ziepe.ca, jgg@nvidia.com, jack@suse.cz, imbrenda@linux.ibm.com,
        hch@lst.de, david@redhat.com, alex.williamson@redhat.com,
        aarcange@redhat.com, jhubbard@nvidia.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] mm-gup-follow_pfn_pte-eexist-cleanup.patch removed from -mm tree
Message-Id: <20220325013001.C0E65C340ED@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/gup: follow_pfn_pte(): -EEXIST cleanup
has been removed from the -mm tree.  Its filename was
     mm-gup-follow_pfn_pte-eexist-cleanup.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: John Hubbard <jhubbard@nvidia.com>
Subject: mm/gup: follow_pfn_pte(): -EEXIST cleanup

Remove a quirky special case from follow_pfn_pte(), and adjust its callers
to match.  Caller changes include:

__get_user_pages(): Regardless of any FOLL_* flags, get_user_pages() and
its variants should handle PFN-only entries by stopping early, if the
caller expected **pages to be filled in.  This makes for a more reliable
API, as compared to the previous approach of skipping over such entries
(and thus leaving them silently unwritten).

move_pages(): squash the -EEXIST error return from follow_page() into
-EFAULT, because -EFAULT is listed in the man page, whereas -EEXIST is
not.

Link: https://lkml.kernel.org/r/20220204020010.68930-3-jhubbard@nvidia.com
Signed-off-by: John Hubbard <jhubbard@nvidia.com>
Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Jan Kara <jack@suse.cz>
Cc: Peter Xu <peterx@redhat.com>
Cc: Lukas Bulwahn <lukas.bulwahn@gmail.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: Alex Williamson <alex.williamson@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/gup.c     |   13 ++++++++-----
 mm/migrate.c |    7 +++++++
 2 files changed, 15 insertions(+), 5 deletions(-)

--- a/mm/gup.c~mm-gup-follow_pfn_pte-eexist-cleanup
+++ a/mm/gup.c
@@ -464,10 +464,6 @@ static struct page *no_page_table(struct
 static int follow_pfn_pte(struct vm_area_struct *vma, unsigned long address,
 		pte_t *pte, unsigned int flags)
 {
-	/* No page to get reference */
-	if (flags & (FOLL_GET | FOLL_PIN))
-		return -EFAULT;
-
 	if (flags & FOLL_TOUCH) {
 		pte_t entry = *pte;
 
@@ -1205,8 +1201,15 @@ retry:
 		} else if (PTR_ERR(page) == -EEXIST) {
 			/*
 			 * Proper page table entry exists, but no corresponding
-			 * struct page.
+			 * struct page. If the caller expects **pages to be
+			 * filled in, bail out now, because that can't be done
+			 * for this page.
 			 */
+			if (pages) {
+				ret = PTR_ERR(page);
+				goto out;
+			}
+
 			goto next_page;
 		} else if (IS_ERR(page)) {
 			ret = PTR_ERR(page);
--- a/mm/migrate.c~mm-gup-follow_pfn_pte-eexist-cleanup
+++ a/mm/migrate.c
@@ -1762,6 +1762,13 @@ static int do_pages_move(struct mm_struc
 		}
 
 		/*
+		 * The move_pages() man page does not have an -EEXIST choice, so
+		 * use -EFAULT instead.
+		 */
+		if (err == -EEXIST)
+			err = -EFAULT;
+
+		/*
 		 * If the page is already on the target node (!err), store the
 		 * node, otherwise, store the err.
 		 */
_

Patches currently in -mm which might be from jhubbard@nvidia.com are


