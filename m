From: Andrew Morton <akpm@linux-foundation.org>
Subject: +
 mm-compactionc-clean-code-by-removing-unnecessary-assignment.patch added to
 -mm tree
Date: Wed, 18 Mar 2020 13:21:59 -0700
Message-ID: <20200318202159.W16DXQ48K%akpm@linux-foundation.org>
References: <20200305222751.6d781a3f2802d79510941e4e@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:60196 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726638AbgCRUWA (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 18 Mar 2020 16:22:00 -0400
In-Reply-To: <20200305222751.6d781a3f2802d79510941e4e@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mateusznosek0@gmail.com, mgorman@techsingularity.net, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/compaction.c: clean code by removing unnecessary assignment
has been added to the -mm tree.  Its filename is
     mm-compactionc-clean-code-by-removing-unnecessary-assignment.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-compactionc-clean-code-by-removing-unnecessary-assignment.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-compactionc-clean-code-by-removing-unnecessary-assignment.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Mateusz Nosek <mateusznosek0@gmail.com>
Subject: mm/compaction.c: clean code by removing unnecessary assignment

Previously 0 was assigned to variable 'last_migrated_pfn'.  But the
variable is not read after that, so the assignment can be removed.

Link: http://lkml.kernel.org/r/20200318174509.15021-1-mateusznosek0@gmail.com
Signed-off-by: Mateusz Nosek <mateusznosek0@gmail.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
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

mm-micro-optimisation-save-two-branches-on-hot-page-allocation-path.patch
mm-page_allocc-micro-optimisation-remove-unnecessary-branch.patch
mm-vmscanc-clean-code-by-removing-unnecessary-assignment.patch
mm-compactionc-clean-code-by-removing-unnecessary-assignment.patch
mm-hugetlbc-clean-code-by-removing-unnecessary-initialization.patch
mm-shmemc-clean-code-by-removing-unnecessary-assignment.patch
mm-mm_initc-clean-code-use-build_bug_on-when-comparing-compile-time-constant.patch
