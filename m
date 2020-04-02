From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 128/155] mm,compaction,cma: add alloc_contig flag
 to compact_control
Date: Wed, 01 Apr 2020 21:10:28 -0700
Message-ID: <20200402041028.KuUPt4-SW%akpm@linux-foundation.org>
References: <20200401210155.09e3b9742e1c6e732f5a7250@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:36008 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726136AbgDBEK3 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 2 Apr 2020 00:10:29 -0400
In-Reply-To: <20200401210155.09e3b9742e1c6e732f5a7250@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, akpm@linux-foundation.org, js1304@gmail.com, linux-mm@kvack.org, mgorman@techsingularity.net, mhocko@kernel.org, mm-commits@vger.kernel.org, riel@surriel.com, rientjes@google.com, torvalds@linux-foundation.org, vbabka@suse.cz, ziy@nvidia.com

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
Cc: Joonsoo Kim <js1304@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/internal.h   |    1 +
 mm/page_alloc.c |    1 +
 2 files changed, 2 insertions(+)

--- a/mm/internal.h~mmcompactioncma-add-alloc_contig-flag-to-compact_control
+++ a/mm/internal.h
@@ -229,6 +229,7 @@ struct compact_control {
 	bool whole_zone;		/* Whole zone should/has been scanned */
 	bool contended;			/* Signal lock or sched contention */
 	bool rescan;			/* Rescanning the same pageblock */
+	bool alloc_contig;		/* alloc_contig_range allocation */
 };
 
 /*
--- a/mm/page_alloc.c~mmcompactioncma-add-alloc_contig-flag-to-compact_control
+++ a/mm/page_alloc.c
@@ -8400,6 +8400,7 @@ int alloc_contig_range(unsigned long sta
 		.ignore_skip_hint = true,
 		.no_set_skip_hint = true,
 		.gfp_mask = current_gfp_context(gfp_mask),
+		.alloc_contig = true,
 	};
 	INIT_LIST_HEAD(&cc.migratepages);
 
_
