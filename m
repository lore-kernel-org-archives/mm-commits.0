Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1D87C433DB
	for <mm-commits@archiver.kernel.org>; Wed, 17 Mar 2021 23:55:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7D3BF64F33
	for <mm-commits@archiver.kernel.org>; Wed, 17 Mar 2021 23:55:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229562AbhCQXym (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 17 Mar 2021 19:54:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:39342 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230050AbhCQXyj (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 17 Mar 2021 19:54:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E854364F21;
        Wed, 17 Mar 2021 23:54:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1616025279;
        bh=04MaLoqts7qV5vPNs/KP1SD9nXHwW1kherMtGRtKU60=;
        h=Date:From:To:Subject:From;
        b=ID5006IhkHCI+JzItClBaAcugZjySj0/oCGzYAm7UFQUJW5kK/bMb9duS2kP7xf70
         AZPdYmTuCR87HmQsdQ2pxnUuLbTjUd0QPsOqngyzSepodnknszBntHvPzyr/30qU5G
         ZVHWB5XgoQBMlO4hYPn1tuSjzNkt7hEFT9k46pLw=
Date:   Wed, 17 Mar 2021 16:54:38 -0700
From:   akpm@linux-foundation.org
To:     dledford@redhat.com, hch@infradead.org, jgg@nvidia.com,
        jhubbard@nvidia.com, joao.m.martins@oracle.com,
        mm-commits@vger.kernel.org, willy@infradead.org
Subject:  +
 mm-gup-decrement-head-page-once-for-group-of-subpages.patch added to -mm
 tree
Message-ID: <20210317235438.cJJ-70hRK%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/gup: decrement head page once for group of subpages
has been added to the -mm tree.  Its filename is
     mm-gup-decrement-head-page-once-for-group-of-subpages.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-gup-decrement-head-page-once-for-group-of-subpages.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-gup-decrement-head-page-once-for-group-of-subpages.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Joao Martins <joao.m.martins@oracle.com>
Subject: mm/gup: decrement head page once for group of subpages

Rather than decrementing the head page refcount one by one, we walk the
page array and checking which belong to the same compound_head.  Later on
we decrement the calculated amount of references in a single write to the
head page.  To that end switch to for_each_compound_head() does most of
the work.

set_page_dirty() needs no adjustment as it's a nop for non-dirty head
pages and it doesn't operate on tail pages.

This considerably improves unpinning of pages with THP and hugetlbfs:

- THP
gup_test -t -m 16384 -r 10 [-L|-a] -S -n 512 -w
PIN_LONGTERM_BENCHMARK (put values): ~87.6k us -> ~23.2k us

- 16G with 1G huge page size
gup_test -f /mnt/huge/file -m 16384 -r 10 [-L|-a] -S -n 512 -w
PIN_LONGTERM_BENCHMARK: (put values): ~87.6k us -> ~27.5k us

Link: https://lkml.kernel.org/r/20210212130843.13865-3-joao.m.martins@oracle.com
Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
Reviewed-by: John Hubbard <jhubbard@nvidia.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Doug Ledford <dledford@redhat.com>
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/gup.c |   29 +++++++++++------------------
 1 file changed, 11 insertions(+), 18 deletions(-)

--- a/mm/gup.c~mm-gup-decrement-head-page-once-for-group-of-subpages
+++ a/mm/gup.c
@@ -265,20 +265,15 @@ void unpin_user_pages_dirty_lock(struct
 				 bool make_dirty)
 {
 	unsigned long index;
-
-	/*
-	 * TODO: this can be optimized for huge pages: if a series of pages is
-	 * physically contiguous and part of the same compound page, then a
-	 * single operation to the head page should suffice.
-	 */
+	struct page *head;
+	unsigned int ntails;
 
 	if (!make_dirty) {
 		unpin_user_pages(pages, npages);
 		return;
 	}
 
-	for (index = 0; index < npages; index++) {
-		struct page *page = compound_head(pages[index]);
+	for_each_compound_head(index, pages, npages, head, ntails) {
 		/*
 		 * Checking PageDirty at this point may race with
 		 * clear_page_dirty_for_io(), but that's OK. Two key
@@ -299,9 +294,9 @@ void unpin_user_pages_dirty_lock(struct
 		 * written back, so it gets written back again in the
 		 * next writeback cycle. This is harmless.
 		 */
-		if (!PageDirty(page))
-			set_page_dirty_lock(page);
-		unpin_user_page(page);
+		if (!PageDirty(head))
+			set_page_dirty_lock(head);
+		put_compound_head(head, ntails, FOLL_PIN);
 	}
 }
 EXPORT_SYMBOL(unpin_user_pages_dirty_lock);
@@ -318,6 +313,8 @@ EXPORT_SYMBOL(unpin_user_pages_dirty_loc
 void unpin_user_pages(struct page **pages, unsigned long npages)
 {
 	unsigned long index;
+	struct page *head;
+	unsigned int ntails;
 
 	/*
 	 * If this WARN_ON() fires, then the system *might* be leaking pages (by
@@ -326,13 +323,9 @@ void unpin_user_pages(struct page **page
 	 */
 	if (WARN_ON(IS_ERR_VALUE(npages)))
 		return;
-	/*
-	 * TODO: this can be optimized for huge pages: if a series of pages is
-	 * physically contiguous and part of the same compound page, then a
-	 * single operation to the head page should suffice.
-	 */
-	for (index = 0; index < npages; index++)
-		unpin_user_page(pages[index]);
+
+	for_each_compound_head(index, pages, npages, head, ntails)
+		put_compound_head(head, ntails, FOLL_PIN);
 }
 EXPORT_SYMBOL(unpin_user_pages);
 
_

Patches currently in -mm which might be from joao.m.martins@oracle.com are

mm-gup-add-compound-page-list-iterator.patch
mm-gup-decrement-head-page-once-for-group-of-subpages.patch
mm-gup-add-a-range-variant-of-unpin_user_pages_dirty_lock.patch
rdma-umem-batch-page-unpin-in-__ib_umem_release.patch

