From: akpm@linux-foundation.org
Subject: + mm-compaction-handle-incorrect-migrate_unmovable-type-pageblocks-fix-2.patch added to -mm tree
Date: Mon, 11 Jun 2012 14:05:22 -0700
Message-ID: <20120611210522.C6E0FA026A@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:64413 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751659Ab2FKVFY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 11 Jun 2012 17:05:24 -0400
Received: by qcsp5 with SMTP id p5so124454qcs.1
        for <mm-commits@vger.kernel.org>; Mon, 11 Jun 2012 14:05:23 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: b.zolnierkie@samsung.com, amwang@redhat.com, davej@redhat.com, hughd@google.com, kosaki.motohiro@gmail.com, kyungmin.park@samsung.com, m.szyprowski@samsung.com, markus@trippelsdorf.de, mgorman@suse.de, minchan@kernel.org, riel@redhat.com


The patch titled
     Subject: mm-compaction-handle-incorrect-migrate_unmovable-type-pageblocks-fix-2
has been added to the -mm tree.  Its filename is
     mm-compaction-handle-incorrect-migrate_unmovable-type-pageblocks-fix-2.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Subject: mm-compaction-handle-incorrect-migrate_unmovable-type-pageblocks-fix-2

Fix can_rescue_unmovable_pageblock() comment and __count_immobile_pages()
documentation.

Cc: Hugh Dickins <hughd@google.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Cc: Dave Jones <davej@redhat.com>
Cc: Cong Wang <amwang@redhat.com>
Cc: Markus Trippelsdorf <markus@trippelsdorf.de>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Rik van Riel <riel@redhat.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |    9 +++++----
 mm/page_alloc.c |   16 +++++++++++-----
 2 files changed, 16 insertions(+), 9 deletions(-)

diff -puN mm/compaction.c~mm-compaction-handle-incorrect-migrate_unmovable-type-pageblocks-fix-2 mm/compaction.c
--- a/mm/compaction.c~mm-compaction-handle-incorrect-migrate_unmovable-type-pageblocks-fix-2
+++ a/mm/compaction.c
@@ -377,10 +377,11 @@ static bool can_rescue_unmovable_pageblo
 	start_page = pfn_to_page(start_pfn);
 
 	/*
-	 * Race with page allocator/reclaimer can happen so that it can
-	 * deceive unmovable block to migratable type on this pageblock.
-	 * It could regress on anti-fragmentation but it's rare and not
-	 * critical.
+	 * Race with page allocator/reclaimer can happen so it is possible
+	 * that MIGRATE_UNMOVABLE type page will end up in MIGRATE_MOVABLE
+	 * type pageblock.  However such situation is rare and not critical
+	 * (because page allocator fallback mechanism can also allocate
+	 * MIGRATE_UNMOVABLE type pages in MIGRATE_MOVABLE type pageblock).
 	 */
 	return __count_immobile_pages(zone, start_page, 0);
 }
diff -puN mm/page_alloc.c~mm-compaction-handle-incorrect-migrate_unmovable-type-pageblocks-fix-2 mm/page_alloc.c
--- a/mm/page_alloc.c~mm-compaction-handle-incorrect-migrate_unmovable-type-pageblocks-fix-2
+++ a/mm/page_alloc.c
@@ -5465,12 +5465,18 @@ void set_pageblock_flags_group(struct pa
 			__clear_bit(bitidx + start_bitidx, bitmap);
 }
 
-/*
- * This is designed as sub function...plz see page_isolation.c also.
- * set/clear page block's type to be ISOLATE.
- * page allocater never alloc memory from ISOLATE block.
+/**
+ * __count_immobile_pages - Check pageblock for MIGRATE_UNMOVABLE type pages.
+ * @zone: Zone pages are in.
+ * @page: The first page in the pageblock.
+ * @count: The count of allowed MIGRATE_UNMOVABLE type pages.
+ *
+ * Count the number of MIGRATE_UNMOVABLE type pages in the pageblock
+ * starting with @page.  Returns true If the @zone is of ZONE_MOVABLE
+ * type or the pageblock is of MIGRATE_MOVABLE or MIGRATE_CMA type.
+ * If the number of MIGRATE_UNMOVABLE type pages inside the pageblock
+ * is higher than given by @count returns false, true otherwise.
  */
