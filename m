Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4AEFC001B1
	for <mm-commits@archiver.kernel.org>; Sun,  2 Jul 2023 19:58:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233159AbjGBT6h (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 2 Jul 2023 15:58:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233237AbjGBT56 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 2 Jul 2023 15:57:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84FC91FD2
        for <mm-commits@vger.kernel.org>; Sun,  2 Jul 2023 12:55:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 24EA060C91
        for <mm-commits@vger.kernel.org>; Sun,  2 Jul 2023 19:55:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 797A5C433C7;
        Sun,  2 Jul 2023 19:54:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1688327699;
        bh=KWynRaQr0MMROFdiSJn/dficxbtsTn+PZxHKL1Rf0nI=;
        h=Date:To:From:Subject:From;
        b=MF86G0lJLOVphwVRv8tycjs9aZiJYctzpCtVaV9842dMn7w+A8euPIjqzbGbATfur
         s0vEHkHCnK+kyWUpyeQesjCO911WUraJH1HGhv4ZEBOBEAecS4cQg6VtGEhxX6oujL
         o5WqCA4dYTzkynk4YXJepT96oikwcN/dFSDbS8Ig=
Date:   Sun, 02 Jul 2023 12:54:58 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, vbabka@suse.cz,
        shy828301@gmail.com, rppt@kernel.org, mike.kravetz@oracle.com,
        lstoakes@gmail.com, kirill@shutemov.name, jthoughton@google.com,
        jhubbard@nvidia.com, jgg@nvidia.com, hughd@google.com,
        david@redhat.com, aarcange@redhat.com, peterx@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-gup-accelerate-thp-gup-even-for-pages-=-null.patch added to mm-unstable branch
Message-Id: <20230702195459.797A5C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/gup: accelerate thp gup even for "pages != NULL"
has been added to the -mm mm-unstable branch.  Its filename is
     mm-gup-accelerate-thp-gup-even-for-pages-=-null.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-gup-accelerate-thp-gup-even-for-pages-=-null.patch

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
Subject: mm/gup: accelerate thp gup even for "pages != NULL"
Date: Wed, 28 Jun 2023 17:53:07 -0400

The acceleration of THP was done with ctx.page_mask, however it'll be
ignored if **pages is non-NULL.

The old optimization was introduced in 2013 in 240aadeedc4a ("mm:
accelerate mm_populate() treatment of THP pages").  It didn't explain why
we can't optimize the **pages non-NULL case.  It's possible that at that
time the major goal was for mm_populate() which should be enough back
then.

Optimize thp for all cases, by properly looping over each subpage, doing
cache flushes, and boost refcounts / pincounts where needed in one go.

This can be verified using gup_test below:

  # chrt -f 1 ./gup_test -m 512 -t -L -n 1024 -r 10

Before:    13992.50 ( +-8.75%)
After:       378.50 (+-69.62%)

Link: https://lkml.kernel.org/r/20230628215310.73782-6-peterx@redhat.com
Signed-off-by: Peter Xu <peterx@redhat.com>
Reviewed-by: Lorenzo Stoakes <lstoakes@gmail.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: David Hildenbrand <david@redhat.com>
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

 mm/gup.c |   51 ++++++++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 44 insertions(+), 7 deletions(-)

--- a/mm/gup.c~mm-gup-accelerate-thp-gup-even-for-pages-=-null
+++ a/mm/gup.c
@@ -1247,16 +1247,53 @@ retry:
 			goto out;
 		}
 next_page:
-		if (pages) {
-			pages[i] = page;
-			flush_anon_page(vma, page, start);
-			flush_dcache_page(page);
-			ctx.page_mask = 0;
-		}
-
 		page_increm = 1 + (~(start >> PAGE_SHIFT) & ctx.page_mask);
 		if (page_increm > nr_pages)
 			page_increm = nr_pages;
+
+		if (pages) {
+			struct page *subpage;
+			unsigned int j;
+
+			/*
+			 * This must be a large folio (and doesn't need to
+			 * be the whole folio; it can be part of it), do
+			 * the refcount work for all the subpages too.
+			 *
+			 * NOTE: here the page may not be the head page
+			 * e.g. when start addr is not thp-size aligned.
+			 * try_grab_folio() should have taken care of tail
+			 * pages.
+			 */
+			if (page_increm > 1) {
+				struct folio *folio;
+
+				/*
+				 * Since we already hold refcount on the
+				 * large folio, this should never fail.
+				 */
+				folio = try_grab_folio(page, page_increm - 1,
+						       foll_flags);
+				if (WARN_ON_ONCE(!folio)) {
+					/*
+					 * Release the 1st page ref if the
+					 * folio is problematic, fail hard.
+					 */
+					gup_put_folio(page_folio(page), 1,
+						      foll_flags);
+					ret = -EFAULT;
+					goto out;
+				}
+			}
+
+			for (j = 0; j < page_increm; j++) {
+				subpage = nth_page(page, j);
+				pages[i + j] = subpage;
+				flush_anon_page(vma, subpage, start + j * PAGE_SIZE);
+				flush_dcache_page(subpage);
+			}
+		}
+
 		i += page_increm;
 		start += page_increm * PAGE_SIZE;
 		nr_pages -= page_increm;
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

