From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 133/155] mm/compaction.c: clean code by removing
 unnecessary assignment
Date: Wed, 01 Apr 2020 21:10:45 -0700
Message-ID: <20200402041045.NWQxIBY6p%akpm@linux-foundation.org>
References: <20200401210155.09e3b9742e1c6e732f5a7250@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:36718 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726136AbgDBEKq (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 2 Apr 2020 00:10:46 -0400
In-Reply-To: <20200401210155.09e3b9742e1c6e732f5a7250@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, linux-mm@kvack.org, mateusznosek0@gmail.com, mgorman@techsingularity.net, mm-commits@vger.kernel.org, torvalds@linux-foundation.org, vbabka@suse.cz

From: Mateusz Nosek <mateusznosek0@gmail.com>
Subject: mm/compaction.c: clean code by removing unnecessary assignment

Previously 0 was assigned to variable 'last_migrated_pfn'.  But the
variable is not read after that, so the assignment can be removed.

Link: http://lkml.kernel.org/r/20200318174509.15021-1-mateusznosek0@gmail.com
Signed-off-by: Mateusz Nosek <mateusznosek0@gmail.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Mel Gorman <mgorman@techsingularity.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |    1 -
 1 file changed, 1 deletion(-)

--- a/mm/compaction.c~mm-compactionc-clean-code-by-removing-unnecessary-assignment
+++ a/mm/compaction.c
@@ -2182,7 +2182,6 @@ compact_zone(struct compact_control *cc,
 			ret = COMPACT_CONTENDED;
 			putback_movable_pages(&cc->migratepages);
 			cc->nr_migratepages = 0;
-			last_migrated_pfn = 0;
 			goto out;
 		case ISOLATE_NONE:
 			if (update_cached) {
_
