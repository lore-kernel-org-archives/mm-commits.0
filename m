From: akpm@linux-foundation.org
Subject: +
 mmcompactioncma-add-alloc_contig-flag-to-compact_control.patch added to -mm
 tree
Date: Thu, 27 Feb 2020 15:06:47 -0800
Message-ID: <20200227230647.gyIpz6bu4%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:59134 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729704AbgB0XGu (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 27 Feb 2020 18:06:50 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, mgorman@techsingularity.net, mhocko@kernel.org, mm-commits@vger.kernel.org, riel@surriel.com, rientjes@google.com, vbabka@suse.cz, ziy@nvidia.com


The patch titled
     Subject: mm,compaction,cma: add alloc_contig flag to compact_control
has been added to the -mm tree.  Its filename is
     mmcompactioncma-add-alloc_contig-flag-to-compact_control.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mmcompactioncma-add-alloc_contig-flag-to-compact_control.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mmcompactioncma-add-alloc_contig-flag-to-compact_control.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Rik van Riel <riel@surriel.com>
Subject: mm,compaction,cma: add alloc_contig flag to compact_control

Patch series "fix THP migration for CMA allocations", v2.

Transparent huge pages are allocated with __GFP_MOVABLE, and can end up in
CMA memory blocks.  Transparent huge pages also have most of the
infrastructure in place to allow migration.

However, a few pieces were missing, causing THP migration to fail when
attempting to use CMA to allocate 1GB hugepages.

With these patches in place, THP migration from CMA blocks seems to work,
both for anonymous THPs and for tmpfs/shmem THPs.


This patch (of 2):

Add information to struct compact_control to indicate that the allocator
would really like to clear out this specific part of memory, used by for
example CMA.

Link: http://lkml.kernel.org/r/20200227213238.1298752-1-riel@surriel.com
Signed-off-by: Rik van Riel <riel@surriel.com>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/internal.h   |    1 +
 mm/page_alloc.c |    1 +
 2 files changed, 2 insertions(+)

--- a/mm/internal.h~mmcompactioncma-add-alloc_contig-flag-to-compact_control
+++ a/mm/internal.h
@@ -206,6 +206,7 @@ struct compact_control {
 	bool whole_zone;		/* Whole zone should/has been scanned */
 	bool contended;			/* Signal lock or sched contention */
 	bool rescan;			/* Rescanning the same pageblock */
+	bool alloc_contig;		/* alloc_contig_range allocation */
 };
 
 /*
--- a/mm/page_alloc.c~mmcompactioncma-add-alloc_contig-flag-to-compact_control
+++ a/mm/page_alloc.c
@@ -8404,6 +8404,7 @@ int alloc_contig_range(unsigned long sta
 		.ignore_skip_hint = true,
 		.no_set_skip_hint = true,
 		.gfp_mask = current_gfp_context(gfp_mask),
+		.alloc_contig = true,
 	};
 	INIT_LIST_HEAD(&cc.migratepages);
 
_

Patches currently in -mm which might be from riel@surriel.com are

mmcompactioncma-add-alloc_contig-flag-to-compact_control.patch
mmthpcompactioncma-allow-thp-migration-for-cma-allocations.patch
