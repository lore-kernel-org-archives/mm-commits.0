Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 527F5C433F5
	for <mm-commits@archiver.kernel.org>; Tue,  1 Feb 2022 20:58:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230499AbiBAU6W (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 1 Feb 2022 15:58:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242666AbiBAU6U (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 1 Feb 2022 15:58:20 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29634C061714
        for <mm-commits@vger.kernel.org>; Tue,  1 Feb 2022 12:58:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BC0B961768
        for <mm-commits@vger.kernel.org>; Tue,  1 Feb 2022 20:58:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFCA4C340EC;
        Tue,  1 Feb 2022 20:58:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1643749099;
        bh=M3df6U3NTk8D5cu1hkDxUhDLIXVTjEk1MSw6UEIDO5k=;
        h=Date:To:From:Subject:From;
        b=GTsaN2y/jo/gBC/2cE2+lzUf2rUimTaEmKN/6pUAFJXe62Liwvnix+cwQusKMx9a3
         L/WCv7No/Ac3eiJ8Nj3LXubznRqWc51HKDHjzSWRARJR1XHSGqqDbaMKExJr5O52Ka
         WFDby4CqF++TTT7CHSgiiyVhL5VVEHWKvAqqxG+U=
Received: by hp1 (sSMTP sendmail emulation); Tue, 01 Feb 2022 12:58:17 -0800
Date:   Tue, 01 Feb 2022 12:58:17 -0800
To:     mm-commits@vger.kernel.org, peterx@redhat.com,
        kirill.shutemov@linux.intel.com, jgg@ziepe.ca, jgg@nvidia.com,
        jack@suse.cz, david@redhat.com, alex.williamson@redhat.com,
        aarcange@redhat.com, jhubbard@nvidia.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-gup-clean-up-follow_pfn_pte-slightly.patch added to -mm tree
Message-Id: <20220201205817.CFCA4C340EC@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/gup: clean up follow_pfn_pte() slightly
has been added to the -mm tree.  Its filename is
     mm-gup-clean-up-follow_pfn_pte-slightly.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-gup-clean-up-follow_pfn_pte-slightly.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-gup-clean-up-follow_pfn_pte-slightly.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm-gup-clean-up-follow_pfn_pte-slightly.patch
mm-gup-remove-unused-pin_user_pages_locked.patch
mm-gup-remove-get_user_pages_locked.patch

