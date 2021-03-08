Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E766AC43332
	for <mm-commits@archiver.kernel.org>; Mon,  8 Mar 2021 21:31:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A4DEF65173
	for <mm-commits@archiver.kernel.org>; Mon,  8 Mar 2021 21:31:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231301AbhCHVa4 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 8 Mar 2021 16:30:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:47082 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230385AbhCHVac (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 8 Mar 2021 16:30:32 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1748D65171;
        Mon,  8 Mar 2021 21:30:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1615239032;
        bh=0reK4EPVuP/6RG2PSInRg5KghrHVqbCV+jTZd1Go/4c=;
        h=Date:From:To:Subject:From;
        b=MnR/WyM/Nnk4ZEfBl+BULIRKlnCIPsJrrFBkbdNMPYCJIDJq9dk45fLMPan3I4pFK
         8nXs0SY+dN7IMaZacmwXKlTImKfv6pmrwLT3k39zpSNCCnEuWi3kbXFpZfY0+GNVdQ
         FY/u9UHP+xac3SbF1ZFNPoVaKlgqob0fBNC12GWc=
Date:   Mon, 08 Mar 2021 13:30:30 -0800
From:   akpm@linux-foundation.org
To:     dan.j.williams@intel.com, david@redhat.com, iamjoonsoo.kim@lge.com,
        ira.weiny@intel.com, jgg@nvidia.com, jgg@ziepe.ca,
        jhubbard@nvidia.com, jmorris@namei.org, mgorman@suse.de,
        mhocko@kernel.org, mhocko@suse.com, mike.kravetz@oracle.com,
        mingo@redhat.com, mm-commits@vger.kernel.org, osalvador@suse.de,
        pasha.tatashin@soleen.com, peterz@infradead.org,
        rientjes@google.com, rostedt@goodmis.org, sashal@kernel.org,
        tyhicks@linux.microsoft.com, vbabka@suse.cz, willy@infradead.org
Subject:  + mm-apply-per-task-gfp-constraints-in-fast-path.patch
 added to -mm tree
Message-ID: <20210308213030.8yyWiv5IW%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: apply per-task gfp constraints in fast path
has been added to the -mm tree.  Its filename is
     mm-apply-per-task-gfp-constraints-in-fast-path.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-apply-per-task-gfp-constraints-in-fast-path.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-apply-per-task-gfp-constraints-in-fast-path.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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

__alloc_pages_nodemask()
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
@@ -5009,6 +5009,13 @@ struct page *__alloc_pages(gfp_t gfp, un
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
@@ -5025,13 +5032,7 @@ struct page *__alloc_pages(gfp_t gfp, un
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

Patches currently in -mm which might be from pasha.tatashin@soleen.com are

mm-gup-dont-pin-migrated-cma-pages-in-movable-zone.patch
mm-gup-check-every-subpage-of-a-compound-page-during-isolation.patch
mm-gup-return-an-error-on-migration-failure.patch
mm-gup-check-for-isolation-errors.patch
mm-cma-rename-pf_memalloc_nocma-to-pf_memalloc_pin.patch
mm-apply-per-task-gfp-constraints-in-fast-path.patch
mm-honor-pf_memalloc_pin-for-all-movable-pages.patch
mm-gup-do-not-migrate-zero-page.patch
mm-gup-migrate-pinned-pages-out-of-movable-zone.patch
memory-hotplugrst-add-a-note-about-zone_movable-and-page-pinning.patch
mm-gup-change-index-type-to-long-as-it-counts-pages.patch
mm-gup-longterm-pin-migration-cleanup.patch
selftests-vm-gup_test-fix-test-flag.patch
selftests-vm-gup_test-test-faulting-in-kernel-and-verify-pinnable-pages.patch

