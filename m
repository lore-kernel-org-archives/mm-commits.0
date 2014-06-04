From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-compaction-embed-migration-mode-in-compact_control-fix-fix.patch removed from -mm tree
Date: Wed, 04 Jun 2014 15:29:19 -0700
Message-ID: <538f9dbf.D0dRTLwvS1WIulJR%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39135 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752333AbaFDW3U (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 4 Jun 2014 18:29:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rientjes@google.com, minchan@kernel.org, iamjoonsoo.kim@lge.com

Subject: [folded-merged] mm-compaction-embed-migration-mode-in-compact_control-fix-fix.patch removed from -mm tree
To: iamjoonsoo.kim@lge.com,minchan@kernel.org,rientjes@google.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 04 Jun 2014 15:29:19 -0700


The patch titled
     Subject: CMA: use MIGRATE_SYNC in alloc_contig_range()
has been removed from the -mm tree.  Its filename was
     mm-compaction-embed-migration-mode-in-compact_control-fix-fix.patch

This patch was dropped because it was folded into mm-compaction-embed-migration-mode-in-compact_control.patch

------------------------------------------------------
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: CMA: use MIGRATE_SYNC in alloc_contig_range()

Before commit 'mm, compaction: embed migration mode in compact_control'
from David is merged, alloc_contig_range() used sync migration,
instead of sync_light migration. This doesn't break anything currently
because page isolation doesn't have any difference with sync and
sync_light, but it could in the future, so change back as it was.

And pass cc->mode to migrate_pages(), instead of passing MIGRATE_SYNC
to migrate_pages().

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Acked-by: Minchan Kim <minchan@kernel.org>
Acked-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/page_alloc.c~mm-compaction-embed-migration-mode-in-compact_control-fix-fix mm/page_alloc.c
--- a/mm/page_alloc.c~mm-compaction-embed-migration-mode-in-compact_control-fix-fix
+++ a/mm/page_alloc.c
@@ -6213,7 +6213,7 @@ static int __alloc_contig_migrate_range(
 		cc->nr_migratepages -= nr_reclaimed;
 
 		ret = migrate_pages(&cc->migratepages, alloc_migrate_target,
-				    NULL, 0, MIGRATE_SYNC, MR_CMA);
+				    NULL, 0, cc->mode, MR_CMA);
 	}
 	if (ret < 0) {
 		putback_movable_pages(&cc->migratepages);
@@ -6252,7 +6252,7 @@ int alloc_contig_range(unsigned long sta
 		.nr_migratepages = 0,
 		.order = -1,
 		.zone = page_zone(pfn_to_page(start)),
-		.mode = MIGRATE_SYNC_LIGHT,
+		.mode = MIGRATE_SYNC,
 		.ignore_skip_hint = true,
 	};
 	INIT_LIST_HEAD(&cc.migratepages);
_

Patches currently in -mm which might be from iamjoonsoo.kim@lge.com are

origin.patch
mm-page_alloc-prevent-migrate_reserve-pages-from-being-misplaced.patch
mm-compaction-clean-up-unused-code-lines.patch
mm-compaction-cleanup-isolate_freepages.patch
mm-swapc-clean-up-lru_cache_add-functions.patch
mm-compaction-embed-migration-mode-in-compact_control.patch
mm-compaction-do-not-count-migratepages-when-unnecessary.patch
mm-compaction-avoid-rescanning-pageblocks-in-isolate_freepages.patch
mm-page_alloc-use-word-based-accesses-for-get-set-pageblock-bitmaps.patch
mm-compaction-properly-signal-and-act-upon-lock-and-need_sched-contention.patch
zram-correct-offset-usage-in-zram_bio_discard.patch

