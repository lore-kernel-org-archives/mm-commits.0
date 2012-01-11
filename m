From: akpm@linux-foundation.org
Subject: [merged] mm-compaction-push-isolate-search-base-of-compact-control-one-pfn-ahead.patch removed from -mm tree
Date: Wed, 11 Jan 2012 13:27:40 -0800
Message-ID: <20120111212741.18F1920004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:54553 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933994Ab2AKV1n (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 11 Jan 2012 16:27:43 -0500
Received: by eekd41 with SMTP id d41so44236eek.1
        for <mm-commits@vger.kernel.org>; Wed, 11 Jan 2012 13:27:42 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dhillf@gmail.com, aarcange@redhat.com, mgorman@suse.de, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: compaction: push isolate search base of compact control one pfn ahead
has been removed from the -mm tree.  Its filename was
     mm-compaction-push-isolate-search-base-of-compact-control-one-pfn-ahead.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Hillf Danton <dhillf@gmail.com>
Subject: mm: compaction: push isolate search base of compact control one pfn ahead

After isolated the current pfn will no longer be scanned and isolated if
the next round is necessary, so push the isolate_migratepages search base
of the given compact_control one step ahead.

Signed-off-by: Hillf Danton <dhillf@gmail.com>
Reviewed-by: Andrea Arcangeli <aarcange@redhat.com>
Cc: Mel Gorman <mgorman@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN mm/compaction.c~mm-compaction-push-isolate-search-base-of-compact-control-one-pfn-ahead mm/compaction.c
--- a/mm/compaction.c~mm-compaction-push-isolate-search-base-of-compact-control-one-pfn-ahead
+++ a/mm/compaction.c
@@ -365,8 +365,10 @@ static isolate_migrate_t isolate_migrate
 		nr_isolated++;
 
 		/* Avoid isolating too much */
-		if (cc->nr_migratepages == COMPACT_CLUSTER_MAX)
+		if (cc->nr_migratepages == COMPACT_CLUSTER_MAX) {
+			++low_pfn;
 			break;
+		}
 	}
 
 	acct_isolated(zone, cc);
_

Patches currently in -mm which might be from dhillf@gmail.com are

origin.patch
linux-next.patch
mm-hugetlb-undo-change-to-page-mapcount-in-fault-handler.patch

