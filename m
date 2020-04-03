From: akpm@linux-foundation.org
Subject: [merged]
 mm-page-writebackc-write_cache_pages-deduplicate-identical-checks.patch
 removed from -mm tree
Date: Fri, 03 Apr 2020 13:36:08 -0700
Message-ID: <20200403203608.I5jncWOPe%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:58938 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726368AbgDCUgK (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 3 Apr 2020 16:36:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, ira.weiny@intel.com, jack@suse.cz, mfo@canonical.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page-writeback.c: write_cache_pages(): deduplicate identical checks
has been removed from the -mm tree.  Its filename was
     mm-page-writebackc-write_cache_pages-deduplicate-identical-checks.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mauricio Faria de Oliveira <mfo@canonical.com>
Subject: mm/page-writeback.c: write_cache_pages(): deduplicate identical checks

There used to be a 'retry' label in between the two (identical) checks
when first introduced in commit f446daaea9d4 ("mm: implement writeback
livelock avoidance using page tagging"), and later modified/updated in
commit 6e6938b6d313 ("writeback: introduce .tagged_writepages for the
WB_SYNC_NONE sync stage").

The label has been removed in commit 64081362e8ff ("mm/page-writeback.c:
fix range_cyclic writeback vs writepages deadlock"), and the (identical)
checks are now present / performed immediately one after another.

So, remove/deduplicate the latter check, moving tag_pages_for_writeback()
into the former check before the 'tag' variable assignment, so it's clear
that it's not used in this (similarly-named) function call but only later
in pagevec_lookup_range_tag().

Link: http://lkml.kernel.org/r/20200218221716.1648-1-mfo@canonical.com
Signed-off-by: Mauricio Faria de Oliveira <mfo@canonical.com>
Reviewed-by: Ira Weiny <ira.weiny@intel.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Jan Kara <jack@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page-writeback.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/mm/page-writeback.c~mm-page-writebackc-write_cache_pages-deduplicate-identical-checks
+++ a/mm/page-writeback.c
@@ -2182,12 +2182,12 @@ int write_cache_pages(struct address_spa
 		if (wbc->range_start == 0 && wbc->range_end == LLONG_MAX)
 			range_whole = 1;
 	}
-	if (wbc->sync_mode == WB_SYNC_ALL || wbc->tagged_writepages)
+	if (wbc->sync_mode == WB_SYNC_ALL || wbc->tagged_writepages) {
+		tag_pages_for_writeback(mapping, index, end);
 		tag = PAGECACHE_TAG_TOWRITE;
-	else
+	} else {
 		tag = PAGECACHE_TAG_DIRTY;
-	if (wbc->sync_mode == WB_SYNC_ALL || wbc->tagged_writepages)
-		tag_pages_for_writeback(mapping, index, end);
+	}
 	done_index = index;
 	while (!done && (index <= end)) {
 		int i;
_

Patches currently in -mm which might be from mfo@canonical.com are
