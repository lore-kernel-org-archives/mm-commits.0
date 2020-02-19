From: akpm@linux-foundation.org
Subject: +
 mm-page-writebackc-write_cache_pages-deduplicate-identical-checks.patch added
 to -mm tree
Date: Wed, 19 Feb 2020 12:18:48 -0800
Message-ID: <20200219201848.pUGx7%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:49150 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726645AbgBSUSt (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 19 Feb 2020 15:18:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, jack@suse.cz, ira.weiny@intel.com, akpm@linux-foundation.org, mfo@canonical.com


The patch titled
     Subject: mm/page-writeback.c: write_cache_pages(): deduplicate identical checks
has been added to the -mm tree.  Its filename is
     mm-page-writebackc-write_cache_pages-deduplicate-identical-checks.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-page-writebackc-write_cache_pages-deduplicate-identical-checks.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-page-writebackc-write_cache_pages-deduplicate-identical-checks.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm-page-writebackc-write_cache_pages-deduplicate-identical-checks.patch
