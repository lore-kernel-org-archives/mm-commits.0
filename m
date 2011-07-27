From: akpm@linux-foundation.org
Subject: + mm-compaction-make-isolate_lru_page-filter-aware.patch added to -mm tree
Date: Wed, 27 Jul 2011 13:12:22 -0700
Message-ID: <201107272012.p6RKCMxT005390@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51677 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752380Ab1G0UMi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 27 Jul 2011 16:12:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: minchan.kim@gmail.com, aarcange@redhat.com, hannes@cmpxchg.org, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, mgorman@suse.de, mhocko@suse.cz, riel@redhat.com


The patch titled
     mm: compaction: make isolate_lru_page() filter-aware
has been added to the -mm tree.  Its filename is
     mm-compaction-make-isolate_lru_page-filter-aware.patch

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
Subject: mm: compaction: make isolate_lru_page() filter-aware
From: Minchan Kim <minchan.kim@gmail.com>

In async mode, compaction doesn't migrate dirty or writeback pages.  So,
it's meaningless to pick the page and re-add it to lru list.

Of course, when we isolate the page in compaction, the page might be dirty
or writeback but when we try to migrate the page, the page would be not
dirty, writeback.  So it could be migrated.  But it's very unlikely as
isolate and migration cycle is much faster than writeout.

So, this patch helps cpu overhead and prevent unnecessary LRU churning.

Signed-off-by: Minchan Kim <minchan.kim@gmail.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Acked-by: Mel Gorman <mgorman@suse.de>
Acked-by: Rik van Riel <riel@redhat.com>
Reviewed-by: Michal Hocko <mhocko@suse.cz>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |    3 ++-
 mm/compaction.c        |    7 +++++--
 mm/vmscan.c            |    3 +++
 3 files changed, 10 insertions(+), 3 deletions(-)

diff -puN include/linux/mmzone.h~mm-compaction-make-isolate_lru_page-filter-aware include/linux/mmzone.h
--- a/include/linux/mmzone.h~mm-compaction-make-isolate_lru_page-filter-aware
+++ a/include/linux/mmzone.h
@@ -168,7 +168,8 @@ static inline int is_unevictable_lru(enu
 #define ISOLATE_INACTIVE	((__force fmode_t)0x1)
 /* Isolate active pages */
 #define ISOLATE_ACTIVE		((__force fmode_t)0x2)
-
+/* Isolate clean file */
+#define ISOLATE_CLEAN		((__force fmode_t)0x4)
 /* LRU Isolation modes. */
 typedef unsigned __bitwise__ isolate_mode_t;
 
diff -puN mm/compaction.c~mm-compaction-make-isolate_lru_page-filter-aware mm/compaction.c
--- a/mm/compaction.c~mm-compaction-make-isolate_lru_page-filter-aware
+++ a/mm/compaction.c
@@ -261,6 +261,7 @@ static isolate_migrate_t isolate_migrate
 	unsigned long last_pageblock_nr = 0, pageblock_nr;
 	unsigned long nr_scanned = 0, nr_isolated = 0;
 	struct list_head *migratelist = &cc->migratepages;
+	isolate_mode_t mode = ISOLATE_ACTIVE|ISOLATE_INACTIVE;
 
 	/* Do not scan outside zone boundaries */
 	low_pfn = max(cc->migrate_pfn, zone->zone_start_pfn);
@@ -348,9 +349,11 @@ static isolate_migrate_t isolate_migrate
 			continue;
 		}
 
+		if (!cc->sync)
+			mode |= ISOLATE_CLEAN;
+
 		/* Try isolate the page */
-		if (__isolate_lru_page(page,
-				ISOLATE_ACTIVE|ISOLATE_INACTIVE, 0) != 0)
+		if (__isolate_lru_page(page, mode, 0) != 0)
 			continue;
 
 		VM_BUG_ON(PageTransCompound(page));
diff -puN mm/vmscan.c~mm-compaction-make-isolate_lru_page-filter-aware mm/vmscan.c
--- a/mm/vmscan.c~mm-compaction-make-isolate_lru_page-filter-aware
+++ a/mm/vmscan.c
@@ -1046,6 +1046,9 @@ int __isolate_lru_page(struct page *page
 
 	ret = -EBUSY;
 
+	if ((mode & ISOLATE_CLEAN) && (PageDirty(page) || PageWriteback(page)))
+		return ret;
+
 	if (likely(get_page_unless_zero(page))) {
 		/*
 		 * Be careful not to clear PageLRU until after we're
_

Patches currently in -mm which might be from minchan.kim@gmail.com are

origin.patch
mm-compaction-trivial-clean-up-in-acct_isolated.patch
mm-change-isolate-mode-from-define-to-bitwise-type.patch
mm-compaction-make-isolate_lru_page-filter-aware.patch
mm-zone_reclaim-make-isolate_lru_page-filter-aware.patch
mm-migration-clean-up-unmap_and_move.patch

