Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83F6CEB64DA
	for <mm-commits@archiver.kernel.org>; Sun,  2 Jul 2023 19:58:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230464AbjGBT6h (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 2 Jul 2023 15:58:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233234AbjGBT55 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 2 Jul 2023 15:57:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E070E6D
        for <mm-commits@vger.kernel.org>; Sun,  2 Jul 2023 12:55:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C780B60C8F
        for <mm-commits@vger.kernel.org>; Sun,  2 Jul 2023 19:54:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28B8CC433C8;
        Sun,  2 Jul 2023 19:54:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1688327696;
        bh=3f08YeWY880M+ad+w6znBriiKg6s4WYsPMpZWPyV1Eo=;
        h=Date:To:From:Subject:From;
        b=bak5NorG5FU2rnqXqlDKL+zUKsn/orhUECLrfXTkY85CI+xQP4gvKfohUCSDYjaJm
         CvWis8xnjKZKPrP4kG7sqru0m5/1D12ejGDedjwtsUn7G2tg8ZRxnA83ofgIGI0jqW
         F/u8pPcD3NAjXMG3iIL7XmGLYq7m1tFeGNvhHOtU=
Date:   Sun, 02 Jul 2023 12:54:55 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, vbabka@suse.cz,
        shy828301@gmail.com, rppt@kernel.org, mike.kravetz@oracle.com,
        lstoakes@gmail.com, kirill@shutemov.name, jthoughton@google.com,
        jhubbard@nvidia.com, jgg@nvidia.com, hughd@google.com,
        david@redhat.com, aarcange@redhat.com, peterx@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-gup-cleanup-next_page-handling.patch added to mm-unstable branch
Message-Id: <20230702195456.28B8CC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/gup: cleanup next_page handling
has been added to the -mm mm-unstable branch.  Its filename is
     mm-gup-cleanup-next_page-handling.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-gup-cleanup-next_page-handling.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Peter Xu <peterx@redhat.com>
Subject: mm/gup: cleanup next_page handling
Date: Wed, 28 Jun 2023 17:53:06 -0400

The only path that doesn't use generic "**pages" handling is the gate vma.
Make it use the same path, meanwhile tune the next_page label upper to
cover "**pages" handling.  This prepares for THP handling for "**pages".

Link: https://lkml.kernel.org/r/20230628215310.73782-5-peterx@redhat.com
Signed-off-by: Peter Xu <peterx@redhat.com>
Reviewed-by: Lorenzo Stoakes <lstoakes@gmail.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: James Houghton <jthoughton@google.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Kirill A . Shutemov <kirill@shutemov.name>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Mike Rapoport (IBM) <rppt@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Yang Shi <shy828301@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/gup.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- a/mm/gup.c~mm-gup-cleanup-next_page-handling
+++ a/mm/gup.c
@@ -1172,7 +1172,7 @@ static long __get_user_pages(struct mm_s
 			if (!vma && in_gate_area(mm, start)) {
 				ret = get_gate_page(mm, start & PAGE_MASK,
 						gup_flags, &vma,
-						pages ? &pages[i] : NULL);
+						pages ? &page : NULL);
 				if (ret)
 					goto out;
 				ctx.page_mask = 0;
@@ -1242,19 +1242,18 @@ retry:
 				ret = PTR_ERR(page);
 				goto out;
 			}
-
-			goto next_page;
 		} else if (IS_ERR(page)) {
 			ret = PTR_ERR(page);
 			goto out;
 		}
+next_page:
 		if (pages) {
 			pages[i] = page;
 			flush_anon_page(vma, page, start);
 			flush_dcache_page(page);
 			ctx.page_mask = 0;
 		}
-next_page:
+
 		page_increm = 1 + (~(start >> PAGE_SHIFT) & ctx.page_mask);
 		if (page_increm > nr_pages)
 			page_increm = nr_pages;
_

Patches currently in -mm which might be from peterx@redhat.com are

mm-hugetlb-handle-foll_dump-well-in-follow_page_mask.patch
mm-hugetlb-prepare-hugetlb_follow_page_mask-for-foll_pin.patch
mm-hugetlb-add-page_mask-for-hugetlb_follow_page_mask.patch
mm-gup-cleanup-next_page-handling.patch
mm-gup-accelerate-thp-gup-even-for-pages-=-null.patch
mm-gup-retire-follow_hugetlb_page.patch
selftests-mm-add-a-to-run_vmtestssh.patch
selftests-mm-add-gup-test-matrix-in-run_vmtestssh.patch

