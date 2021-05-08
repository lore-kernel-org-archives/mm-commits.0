Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C543C433ED
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:40:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F10A961415
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:40:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229647AbhEHWlt (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 8 May 2021 18:41:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:45664 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229609AbhEHWls (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 8 May 2021 18:41:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 91947613EA;
        Sat,  8 May 2021 22:40:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620513645;
        bh=XyvJ2KZXc/yls/u+bznwHS2PCiHT9O3DqEgzh8W3iP0=;
        h=Date:From:To:Subject:From;
        b=i0fBO2iSU55bg/CiLgBVyLjBL/V3KIeLkOKCpRTv8Hikvp9D+8TjJNalkfB3GZZG5
         EfaO2gb+xhzH7GRbZ2kIjadMnBFAu0u8nFyIwvDEl0kJ+6jwbAMW+hKaR2om8OLCRI
         OJv9gN5BFaO0HcMKIrdUAxVySQLSGFTr5FGtMMv8=
Date:   Sat, 08 May 2021 15:40:45 -0700
From:   akpm@linux-foundation.org
To:     dledford@redhat.com, hch@infradead.org, jgg@nvidia.com,
        jhubbard@nvidia.com, joao.m.martins@oracle.com,
        mm-commits@vger.kernel.org, willy@infradead.org
Subject:  [merged]
 mm-gup-decrement-head-page-once-for-group-of-subpages.patch removed from
 -mm tree
Message-ID: <20210508224045.LSfqFwUSN%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/gup: decrement head page once for group of subpages
has been removed from the -mm tree.  Its filename was
     mm-gup-decrement-head-page-once-for-group-of-subpages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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


