Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC3A7C433B4
	for <mm-commits@archiver.kernel.org>; Wed,  5 May 2021 01:38:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 901EC61428
	for <mm-commits@archiver.kernel.org>; Wed,  5 May 2021 01:38:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232033AbhEEBjl (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 4 May 2021 21:39:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:42886 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231440AbhEEBjk (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 4 May 2021 21:39:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B19F1610A1;
        Wed,  5 May 2021 01:38:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620178723;
        bh=49hbTOzL9Hd6mB4cRIxZJM2ydCd9FAJqMdKKM6aYOH8=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=bfhMYd4YAEI4YvYYj8JakuOrglS2aNfIPQzMP+henhrQ/tmR83oLIwt8dssQIvjUp
         /Ueh9zsWKSihPKS2Jqpbe8WjMXnxJJX6Dc2RBCHJeZEZ/1PsWysG02RozskUEGIKfm
         4A9mWhbzZW9j3mzr7NBCZL/BYmRpv2kNNHUuEBm8=
Date:   Tue, 04 May 2021 18:38:42 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, dan.j.williams@intel.com,
        david@redhat.com, iamjoonsoo.kim@lge.com, ira.weiny@intel.com,
        jgg@nvidia.com, jgg@ziepe.ca, jhubbard@nvidia.com,
        jmorris@namei.org, linux-mm@kvack.org, mgorman@suse.de,
        mhocko@kernel.org, mhocko@suse.com, mike.kravetz@oracle.com,
        mingo@redhat.com, mm-commits@vger.kernel.org, osalvador@suse.de,
        pasha.tatashin@soleen.com, peterz@infradead.org,
        rientjes@google.com, rostedt@goodmis.org, sashal@kernel.org,
        torvalds@linux-foundation.org, tyhicks@linux.microsoft.com,
        vbabka@suse.cz, willy@infradead.org
Subject:  [patch 111/143] mm/gup: check every subpage of a compound
 page during isolation
Message-ID: <20210505013842.bA5AgeZ-Y%akpm@linux-foundation.org>
In-Reply-To: <20210504183219.a3cc46aee4013d77402276c5@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Pavel Tatashin <pasha.tatashin@soleen.com>
Subject: mm/gup: check every subpage of a compound page during isolation

When pages are isolated in check_and_migrate_movable_pages() we skip
compound number of pages at a time.  However, as Jason noted, it is not
necessary correct that pages[i] corresponds to the pages that we skipped. 
This is because it is possible that the addresses in this range had
split_huge_pmd()/split_huge_pud(), and these functions do not update the
compound page metadata.

The problem can be reproduced if something like this occurs:

1. User faulted huge pages.
2. split_huge_pmd() was called for some reason
3. User has unmapped some sub-pages in the range
4. User tries to longterm pin the addresses.

The resulting pages[i] might end-up having pages which are not compound
size page aligned.

Link: https://lkml.kernel.org/r/20210215161349.246722-3-pasha.tatashin@soleen.com
Fixes: aa712399c1e8 ("mm/gup: speed up check_and_migrate_cma_pages() on huge page")
Signed-off-by: Pavel Tatashin <pasha.tatashin@soleen.com>
Reported-by: Jason Gunthorpe <jgg@nvidia.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Ira Weiny <ira.weiny@intel.com>
Cc: James Morris <jmorris@namei.org>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Sasha Levin <sashal@kernel.org>
Cc: Steven Rostedt (VMware) <rostedt@goodmis.org>
Cc: Tyler Hicks <tyhicks@linux.microsoft.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/gup.c |   19 +++++++------------
 1 file changed, 7 insertions(+), 12 deletions(-)

--- a/mm/gup.c~mm-gup-check-every-subpage-of-a-compound-page-during-isolation
+++ a/mm/gup.c
@@ -1609,26 +1609,23 @@ static long check_and_migrate_cma_pages(
 					unsigned int gup_flags)
 {
 	unsigned long i;
-	unsigned long step;
 	bool drain_allow = true;
 	bool migrate_allow = true;
 	LIST_HEAD(cma_page_list);
 	long ret = nr_pages;
+	struct page *prev_head, *head;
 	struct migration_target_control mtc = {
 		.nid = NUMA_NO_NODE,
 		.gfp_mask = GFP_USER | __GFP_NOWARN,
 	};
 
 check_again:
-	for (i = 0; i < nr_pages;) {
-
-		struct page *head = compound_head(pages[i]);
-
-		/*
-		 * gup may start from a tail page. Advance step by the left
-		 * part.
-		 */
-		step = compound_nr(head) - (pages[i] - head);
+	prev_head = NULL;
+	for (i = 0; i < nr_pages; i++) {
+		head = compound_head(pages[i]);
+		if (head == prev_head)
+			continue;
+		prev_head = head;
 		/*
 		 * If we get a page from the CMA zone, since we are going to
 		 * be pinning these entries, we might as well move them out
@@ -1652,8 +1649,6 @@ check_again:
 				}
 			}
 		}
-
-		i += step;
 	}
 
 	if (!list_empty(&cma_page_list)) {
_
