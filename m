Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D754C001DD
	for <mm-commits@archiver.kernel.org>; Mon, 19 Jun 2023 23:22:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229931AbjFSXWY (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 19 Jun 2023 19:22:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229462AbjFSXVc (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 19 Jun 2023 19:21:32 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25CA6E63
        for <mm-commits@vger.kernel.org>; Mon, 19 Jun 2023 16:21:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B36A960F66
        for <mm-commits@vger.kernel.org>; Mon, 19 Jun 2023 23:21:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16D66C433C0;
        Mon, 19 Jun 2023 23:21:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1687216881;
        bh=QGOynUj/HCD0w0PoxE4SvvuKNbwBBT2Rnx1XzL3qvpQ=;
        h=Date:To:From:Subject:From;
        b=I3yKHpOfgKId6VS1HP0v7cdywyCsZXPLuP7RvUFByaSsUB7Goqv66xVHeCzuz2vNu
         She2lQzNu2nNgvfIpXkFsEw/VegWcVcw3tmEOmP3EP0eSag+MZLvTYjop/OuHYokBV
         qg/Ch3UxeK0dmvqvKRDj0KyOAFOEx1MaUS4gKhao=
Date:   Mon, 19 Jun 2023 16:21:20 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        sidhartha.kumar@oracle.com, muchun.song@linux.dev,
        mike.kravetz@oracle.com, gerald.schaefer@linux.ibm.com,
        aneesh.kumar@linux.ibm.com, tsahu@linux.ibm.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-folio-avoid-special-handling-for-order-value-0-in-folio_set_order.patch removed from -mm tree
Message-Id: <20230619232121.16D66C433C0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/folio: avoid special handling for order value 0 in folio_set_order
has been removed from the -mm tree.  Its filename was
     mm-folio-avoid-special-handling-for-order-value-0-in-folio_set_order.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Tarun Sahu <tsahu@linux.ibm.com>
Subject: mm/folio: avoid special handling for order value 0 in folio_set_order
Date: Fri, 9 Jun 2023 21:59:07 +0530

folio_set_order(folio, 0) is used in kernel at two places
__destroy_compound_gigantic_folio and __prep_compound_gigantic_folio.
Currently, It is called to clear out the folio->_folio_nr_pages and
folio->_folio_order.

For __destroy_compound_gigantic_folio:
In past, folio_set_order(folio, 0) was needed because page->mapping used
to overlap with _folio_nr_pages and _folio_order. So if these fields were
left uncleared during freeing gigantic hugepages, they were causing
"BUG: bad page state" due to non-zero page->mapping. Now, After
Commit a01f43901cfb ("hugetlb: be sure to free demoted CMA pages to
CMA") page->mapping has explicitly been cleared out for tail pages. Also,
_folio_order and _folio_nr_pages no longer overlaps with page->mapping.

So, folio_set_order(folio, 0) can be removed from freeing gigantic
folio path (__destroy_compound_gigantic_folio).

Another place, folio_set_order(folio, 0) is called inside
__prep_compound_gigantic_folio during error path. Here,
folio_set_order(folio, 0) can also be removed if we move
folio_set_order(folio, order) after for loop.

The patch also moves _folio_set_head call in __prep_compound_gigantic_folio()
such that we avoid clearing them in the error path.

Also, as Mike pointed out:
"It would actually be better to move the calls _folio_set_head and
folio_set_order in __prep_compound_gigantic_folio() as suggested here. Why?
In the current code, the ref count on the 'head page' is still 1 (or more)
while those calls are made. So, someone could take a speculative ref on the
page BEFORE the tail pages are set up."

This way, folio_set_order(folio, 0) is no more needed. And it will also
helps removing the confusion of folio order being set to 0 (as _folio_order
field is part of first tail page).

Testing: I have run LTP tests, which all passes. and also I have written
the test in LTP which tests the bug caused by compound_nr and page->mapping
overlapping.

https://github.com/linux-test-project/ltp/blob/master/testcases/kernel/mem/hugetlb/hugemmap/hugemmap32.c

Running on older kernel ( < 5.10-rc7) with the above bug this fails while
on newer kernel and, also with this patch it passes.

Link: https://lkml.kernel.org/r/20230609162907.111756-1-tsahu@linux.ibm.com
Signed-off-by: Tarun Sahu <tsahu@linux.ibm.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c  |    9 +++------
 mm/internal.h |    8 ++------
 2 files changed, 5 insertions(+), 12 deletions(-)

--- a/mm/hugetlb.c~mm-folio-avoid-special-handling-for-order-value-0-in-folio_set_order
+++ a/mm/hugetlb.c
@@ -1489,7 +1489,6 @@ static void __destroy_compound_gigantic_
 			set_page_refcounted(p);
 	}
 
-	folio_set_order(folio, 0);
 	__folio_clear_head(folio);
 }
 
@@ -1951,9 +1950,6 @@ static bool __prep_compound_gigantic_fol
 	struct page *p;
 
 	__folio_clear_reserved(folio);
-	__folio_set_head(folio);
-	/* we rely on prep_new_hugetlb_folio to set the destructor */
-	folio_set_order(folio, order);
 	for (i = 0; i < nr_pages; i++) {
 		p = folio_page(folio, i);
 
@@ -1999,6 +1995,9 @@ static bool __prep_compound_gigantic_fol
 		if (i != 0)
 			set_compound_head(p, &folio->page);
 	}
+	__folio_set_head(folio);
+	/* we rely on prep_new_hugetlb_folio to set the destructor */
+	folio_set_order(folio, order);
 	atomic_set(&folio->_entire_mapcount, -1);
 	atomic_set(&folio->_nr_pages_mapped, 0);
 	atomic_set(&folio->_pincount, 0);
@@ -2017,8 +2016,6 @@ out_error:
 		p = folio_page(folio, j);
 		__ClearPageReserved(p);
 	}
-	folio_set_order(folio, 0);
-	__folio_clear_head(folio);
 	return false;
 }
 
--- a/mm/internal.h~mm-folio-avoid-special-handling-for-order-value-0-in-folio_set_order
+++ a/mm/internal.h
@@ -438,16 +438,12 @@ int split_free_page(struct page *free_pa
  */
 static inline void folio_set_order(struct folio *folio, unsigned int order)
 {
-	if (WARN_ON_ONCE(!folio_test_large(folio)))
+	if (WARN_ON_ONCE(!order || !folio_test_large(folio)))
 		return;
 
 	folio->_folio_order = order;
 #ifdef CONFIG_64BIT
-	/*
-	 * When hugetlb dissolves a folio, we need to clear the tail
-	 * page, rather than setting nr_pages to 1.
-	 */
-	folio->_folio_nr_pages = order ? 1U << order : 0;
+	folio->_folio_nr_pages = 1U << order;
 #endif
 }
 
_

Patches currently in -mm which might be from tsahu@linux.ibm.com are


