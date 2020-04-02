From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 030/155] mm/page-writeback.c: write_cache_pages():
 deduplicate identical checks
Date: Wed, 01 Apr 2020 21:04:43 -0700
Message-ID: <20200402040443.RZ8EXB9WY%akpm@linux-foundation.org>
References: <20200401210155.09e3b9742e1c6e732f5a7250@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:50750 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726136AbgDBEEp (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 2 Apr 2020 00:04:45 -0400
In-Reply-To: <20200401210155.09e3b9742e1c6e732f5a7250@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, ira.weiny@intel.com, jack@suse.cz, linux-mm@kvack.org, mfo@canonical.com, mm-commits@vger.kernel.org, torvalds@linux-foundation.org

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
