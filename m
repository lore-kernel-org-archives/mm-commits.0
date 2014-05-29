From: akpm@linux-foundation.org
Subject: +
 mm-compaction-embed-migration-mode-in-compact_control-fix-fix.patch added
 to -mm tree
Date: Thu, 29 May 2014 13:12:42 -0700
Message-ID: <538794ba.3yFjvD92rWshwT6i%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44361 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755215AbaE2UMn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 29 May 2014 16:12:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rientjes@google.com, minchan@kernel.org, iamjoonsoo.kim@lge.com

Subject: + mm-compaction-embed-migration-mode-in-compact_control-fix-fix.patch added to -mm tree
To: iamjoonsoo.kim@lge.com,minchan@kernel.org,rientjes@google.com
From: akpm@linux-foundation.org
Date: Thu, 29 May 2014 13:12:42 -0700


The patch titled
     Subject: CMA: use MIGRATE_SYNC in alloc_contig_range()
has been added to the -mm tree.  Its filename is
     mm-compaction-embed-migration-mode-in-compact_control-fix-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-compaction-embed-migration-mode-in-compact_control-fix-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-compaction-embed-migration-mode-in-compact_control-fix-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm-compactionc-isolate_freepages_block-small-tuneup.patch
mm-page_alloc-prevent-migrate_reserve-pages-from-being-misplaced.patch
mm-compaction-clean-up-unused-code-lines.patch
mm-compaction-cleanup-isolate_freepages.patch
mm-compaction-cleanup-isolate_freepages-fix.patch
mm-compaction-cleanup-isolate_freepages-fix-2.patch
mm-compaction-cleanup-isolate_freepages-fix3.patch
mm-swapc-clean-up-lru_cache_add-functions.patch
mm-compaction-embed-migration-mode-in-compact_control-fix-fix.patch
mm-compaction-do-not-count-migratepages-when-unnecessary.patch
mm-compaction-avoid-rescanning-pageblocks-in-isolate_freepages.patch
mm-page_alloc-use-word-based-accesses-for-get-set-pageblock-bitmaps.patch
mm-compaction-properly-signal-and-act-upon-lock-and-need_sched-contention.patch
zram-correct-offset-usage-in-zram_bio_discard.patch
linux-next.patch
page-owners-correct-page-order-when-to-free-page.patch

