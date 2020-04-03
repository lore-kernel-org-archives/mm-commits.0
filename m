From: akpm@linux-foundation.org
Subject: [merged]
 mm-compactionc-clean-code-by-removing-unnecessary-assignment.patch removed
 from -mm tree
Date: Fri, 03 Apr 2020 13:40:13 -0700
Message-ID: <20200403204013.rBAV-h_1w%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:36072 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726368AbgDCUkO (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 3 Apr 2020 16:40:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mateusznosek0@gmail.com, mgorman@techsingularity.net, mm-commits@vger.kernel.org, vbabka@suse.cz


The patch titled
     Subject: mm/compaction.c: clean code by removing unnecessary assignment
has been removed from the -mm tree.  Its filename was
     mm-compactionc-clean-code-by-removing-unnecessary-assignment.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from mateusznosek0@gmail.com are

mm-shmemc-clean-code-by-removing-unnecessary-assignment.patch
mm-mm_initc-clean-code-use-build_bug_on-when-comparing-compile-time-constant.patch
mm-dmapoolc-micro-optimisation-remove-unnecessary-branch.patch
