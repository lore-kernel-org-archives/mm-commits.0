Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B94BC433ED
	for <mm-commits@archiver.kernel.org>; Wed,  5 May 2021 01:39:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6C21B61423
	for <mm-commits@archiver.kernel.org>; Wed,  5 May 2021 01:39:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232101AbhEEBjz (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 4 May 2021 21:39:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:43204 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231440AbhEEBjy (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 4 May 2021 21:39:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 95B9E61425;
        Wed,  5 May 2021 01:38:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620178738;
        bh=5OKUzhkWeN8b6z9f8byfDhLrRhkKl/rXXrSn47O/W0A=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=nzMxHkQns/2JCoW6bCT0Bsj5q5AqGhorCl3Nrmxnuo8A9XmQWdwjyb8uM93xZi6Hc
         JRBWrqldN2dN5BQJaDIf1RAP/1ckrd5/uxYZRPo5SIdggAE4+TJaAgM3+MTF2LVLbg
         DcbKMqWl2vCgBnYlJRcXJ8yrbs5ikQGdo/hJJHgs=
Date:   Tue, 04 May 2021 18:38:57 -0700
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
Subject:  [patch 115/143] mm: apply per-task gfp constraints in
 fast path
Message-ID: <20210505013857.Np7RTnGXA%akpm@linux-foundation.org>
In-Reply-To: <20210504183219.a3cc46aee4013d77402276c5@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Pavel Tatashin <pasha.tatashin@soleen.com>
Subject: mm: apply per-task gfp constraints in fast path

Function current_gfp_context() is called after fast path.  However, soon
we will add more constraints which will also limit zones based on context.
Move this call into fast path, and apply the correct constraints for all
allocations.

Also update .reclaim_idx based on value returned by current_gfp_context()
because it soon will modify the allowed zones.

Note:
With this patch we will do one extra current->flags load during fast path,
but we already load current->flags in fast-path:

__alloc_pages()
 prepare_alloc_pages()
  current_alloc_flags(gfp_mask, *alloc_flags);

Later, when we add the zone constrain logic to current_gfp_context() we
will be able to remove current->flags load from current_alloc_flags, and
therefore return fast-path to the current performance level.

Link: https://lkml.kernel.org/r/20210215161349.246722-7-pasha.tatashin@soleen.com
Signed-off-by: Pavel Tatashin <pasha.tatashin@soleen.com>
Suggested-by: Michal Hocko <mhocko@kernel.org>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Ira Weiny <ira.weiny@intel.com>
Cc: James Morris <jmorris@namei.org>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Sasha Levin <sashal@kernel.org>
Cc: Steven Rostedt (VMware) <rostedt@goodmis.org>
Cc: Tyler Hicks <tyhicks@linux.microsoft.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

--- a/mm/page_alloc.c~mm-apply-per-task-gfp-constraints-in-fast-path
+++ a/mm/page_alloc.c
@@ -5180,6 +5180,13 @@ struct page *__alloc_pages(gfp_t gfp, un
 	}
 
 	gfp &= gfp_allowed_mask;
+	/*
+	 * Apply scoped allocation constraints. This is mainly about GFP_NOFS
+	 * resp. GFP_NOIO which has to be inherited for all allocation requests
+	 * from a particular context which has been marked by
+	 * memalloc_no{fs,io}_{save,restore}.
+	 */
+	gfp = current_gfp_context(gfp);
 	alloc_gfp = gfp;
 	if (!prepare_alloc_pages(gfp, order, preferred_nid, nodemask, &ac,
 			&alloc_gfp, &alloc_flags))
@@ -5196,13 +5203,7 @@ struct page *__alloc_pages(gfp_t gfp, un
 	if (likely(page))
 		goto out;
 
-	/*
-	 * Apply scoped allocation constraints. This is mainly about GFP_NOFS
-	 * resp. GFP_NOIO which has to be inherited for all allocation requests
-	 * from a particular context which has been marked by
-	 * memalloc_no{fs,io}_{save,restore}.
-	 */
-	alloc_gfp = current_gfp_context(gfp);
+	alloc_gfp = gfp;
 	ac.spread_dirty_pages = false;
 
 	/*
_
