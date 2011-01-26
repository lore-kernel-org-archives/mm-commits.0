From: akpm@linux-foundation.org
Subject: + mm-compaction-check-migrate_pagess-return-value-instead-of-list_empty.patch added to -mm tree
Date: Wed, 26 Jan 2011 15:10:37 -0800
Message-ID: <201101262310.p0QNAbHg010234@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45511 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753537Ab1AZXLl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 26 Jan 2011 18:11:41 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: minchan.kim@gmail.com, aarcange@redhat.com, cl@linux.com, mel@csn.ul.ie


The patch titled
     mm/compaction: check migrate_pages's return value instead of list_empty
has been added to the -mm tree.  Its filename is
     mm-compaction-check-migrate_pagess-return-value-instead-of-list_empty.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm/compaction: check migrate_pages's return value instead of list_empty
From: Minchan Kim <minchan.kim@gmail.com>

Many migrate_page's caller check return value instead of list_empy by
cf608ac19c ("mm: compaction: fix COMPACTPAGEFAILED counting").  This patch
makes compaction's migrate_pages consistent with others.  This patch
should not change old behavior.

Signed-off-by: Minchan Kim <minchan.kim@gmail.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Christoph Lameter <cl@linux.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN mm/compaction.c~mm-compaction-check-migrate_pagess-return-value-instead-of-list_empty mm/compaction.c
--- a/mm/compaction.c~mm-compaction-check-migrate_pagess-return-value-instead-of-list_empty
+++ a/mm/compaction.c
@@ -508,12 +508,13 @@ static int compact_zone(struct zone *zon
 
 	while ((ret = compact_finished(zone, cc)) == COMPACT_CONTINUE) {
 		unsigned long nr_migrate, nr_remaining;
+		int err;
 
 		if (!isolate_migratepages(zone, cc))
 			continue;
 
 		nr_migrate = cc->nr_migratepages;
-		migrate_pages(&cc->migratepages, compaction_alloc,
+		err = migrate_pages(&cc->migratepages, compaction_alloc,
 				(unsigned long)cc, false,
 				cc->sync);
 		update_nr_listpages(cc);
@@ -527,7 +528,7 @@ static int compact_zone(struct zone *zon
 						nr_remaining);
 
 		/* Release LRU pages not migrated */
-		if (!list_empty(&cc->migratepages)) {
+		if (err) {
 			putback_lru_pages(&cc->migratepages);
 			cc->nr_migratepages = 0;
 		}
_

Patches currently in -mm which might be from minchan.kim@gmail.com are

origin.patch
linux-next.patch
mm-when-migrate_pages-returns-0-all-pages-must-have-been-released.patch
mm-migration-fix-page-corruption-during-hugepage-migration.patch
mm-compaction-check-migrate_pagess-return-value-instead-of-list_empty.patch
mm-vmap-area-cache.patch

