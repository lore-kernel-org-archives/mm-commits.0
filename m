Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89C31C11F64
	for <mm-commits@archiver.kernel.org>; Tue, 29 Jun 2021 02:42:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6BC2C611AE
	for <mm-commits@archiver.kernel.org>; Tue, 29 Jun 2021 02:42:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230152AbhF2CpF (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 28 Jun 2021 22:45:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:37278 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231706AbhF2CpE (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 28 Jun 2021 22:45:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1DAC961D0C;
        Tue, 29 Jun 2021 02:42:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1624934557;
        bh=18a4BLFguU+tS7RkhvrOP+oVL/KyVMITOs3sJ/F84lk=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=LbEPWPQPWh2iiKq8FPJ/za4P19yMVFuYp/NauGtTpctetUIiUfihfvo6umbIss1kP
         I1xoEf+RsZhFpSUb0qRIshPuCOEqcSy8muGmsz7W/4sTTy9N/w/nJiLP2HuQdBwNoU
         e41xxc82t//IchhSYLJWJUYgyfJSHNeqzF0JmPDA=
Date:   Mon, 28 Jun 2021 19:42:36 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, brouer@redhat.com,
        dave.hansen@linux.intel.com, linux-mm@kvack.org,
        mgorman@techsingularity.net, mhocko@kernel.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        vbabka@suse.cz
Subject:  [patch 179/192] mm/page_alloc: move free_the_page
Message-ID: <20210629024236.ZW4Zz5SuW%akpm@linux-foundation.org>
In-Reply-To: <20210628193256.008961950a714730751c1423@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
