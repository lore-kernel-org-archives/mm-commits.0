Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 929EDC07E96
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:15:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 766E961057
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:15:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231774AbhGFTR6 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 6 Jul 2021 15:17:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:52000 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231755AbhGFTR6 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 6 Jul 2021 15:17:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 93C0560C3D;
        Tue,  6 Jul 2021 19:15:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625598919;
        bh=e/tTcwqTO3j65Pxj7YcLkjKHAqL9BJsi/fyhf1hJ3ng=;
        h=Date:From:To:Subject:From;
        b=mcEOCXosw8z+d15XdhF7s3oTv6nClTlUYfvlv7Zsev8YcNMR3ajW02ax2+pZHlQVO
         huzsNghxcRxArWR2nIx7ckGAdd3CmAmsZjDcnuK1575OJ+04Q1AbymYfSWedH2z3ce
         mPFjLzBe221xyeIP1JB56mI6SFqBhscResXYRpY8=
Date:   Tue, 06 Jul 2021 12:15:19 -0700
From:   akpm@linux-foundation.org
To:     brouer@redhat.com, dave.hansen@linux.intel.com,
        mgorman@techsingularity.net, mhocko@kernel.org,
        mm-commits@vger.kernel.org, vbabka@suse.cz
Subject:  [merged] mm-page_alloc-move-free_the_page.patch removed
 from -mm tree
Message-ID: <20210706191519.NO7PYIlb3%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_alloc: move free_the_page
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-move-free_the_page.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mel Gorman <mgorman@techsingularity.net>
Subject: mm/page_alloc: move free_the_page

Patch series "Allow high order pages to be stored on PCP", v2.

The per-cpu page allocator (PCP) only handles order-0 pages.  With the
series "Use local_lock for pcp protection and reduce stat overhead" and
"Calculate pcp->high based on zone sizes and active CPUs", it's now
feasible to store high-order pages on PCP lists.

This small series allows PCP to store "cheap" orders where cheap is
determined by PAGE_ALLOC_COSTLY_ORDER and THP-sized allocations.


This patch (of 2):

In the next page, free_compount_page is going to use the common helper
free_the_page.  This patch moves the definition to ease review.  No
functional change.

Link: https://lkml.kernel.org/r/20210603142220.10851-1-mgorman@techsingularity.net
Link: https://lkml.kernel.org/r/20210603142220.10851-2-mgorman@techsingularity.net
Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Jesper Dangaard Brouer <brouer@redhat.com>
Cc: Michal Hocko <mhocko@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-move-free_the_page
+++ a/mm/page_alloc.c
@@ -687,6 +687,14 @@ out:
 	add_taint(TAINT_BAD_PAGE, LOCKDEP_NOW_UNRELIABLE);
 }
 
+static inline void free_the_page(struct page *page, unsigned int order)
+{
+	if (order == 0)		/* Via pcp? */
+		free_unref_page(page);
+	else
+		__free_pages_ok(page, order, FPI_NONE);
+}
+
 /*
  * Higher-order pages are called "compound pages".  They are structured thusly:
  *
@@ -5349,14 +5357,6 @@ unsigned long get_zeroed_page(gfp_t gfp_
 }
 EXPORT_SYMBOL(get_zeroed_page);
 
-static inline void free_the_page(struct page *page, unsigned int order)
-{
-	if (order == 0)		/* Via pcp? */
-		free_unref_page(page);
-	else
-		__free_pages_ok(page, order, FPI_NONE);
-}
-
 /**
  * __free_pages - Free pages allocated with alloc_pages().
  * @page: The page pointer returned from alloc_pages().
_

Patches currently in -mm which might be from mgorman@techsingularity.net are


