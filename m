From: akpm@linux-foundation.org
Subject: + mm-page_alloc-refactor-out-__alloc_contig_migrate_alloc.patch added to -mm tree
Date: Wed, 12 Sep 2012 14:32:48 -0700
Message-ID: <20120912213249.9C8E05C0060@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ey0-f202.google.com ([209.85.215.202]:48287 "EHLO
	mail-ey0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754516Ab2ILVcw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 12 Sep 2012 17:32:52 -0400
Received: by eaac1 with SMTP id c1so146764eaa.1
        for <mm-commits@vger.kernel.org>; Wed, 12 Sep 2012 14:32:51 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: minchan@kernel.org, isimatu.yasuaki@jp.fujitsu.com, kamezawa.hiroyu@jp.fujitsu.com, m.szyprowski@samsung.com, mina86@mina86.com, wency@cn.fujitsu.com


The patch titled
     Subject: mm/page_alloc: refactor out __alloc_contig_migrate_alloc()
has been added to the -mm tree.  Its filename is
     mm-page_alloc-refactor-out-__alloc_contig_migrate_alloc.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Minchan Kim <minchan@kernel.org>
Subject: mm/page_alloc: refactor out __alloc_contig_migrate_alloc()

__alloc_contig_migrate_alloc() can be used by memory-hotplug so refactor
it out (move + rename as a common name) into page_isolation.c.

Signed-off-by: Minchan Kim <minchan@kernel.org>
Cc: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Acked-by: Michal Nazarewicz <mina86@mina86.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Wen Congyang <wency@cn.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page-isolation.h |    3 ++-
 mm/page_alloc.c                |   14 +-------------
 mm/page_isolation.c            |   11 +++++++++++
 3 files changed, 14 insertions(+), 14 deletions(-)

diff -puN include/linux/page-isolation.h~mm-page_alloc-refactor-out-__alloc_contig_migrate_alloc include/linux/page-isolation.h
--- a/include/linux/page-isolation.h~mm-page_alloc-refactor-out-__alloc_contig_migrate_alloc
+++ a/include/linux/page-isolation.h
@@ -41,6 +41,7 @@ int test_pages_isolated(unsigned long st
  */
 int set_migratetype_isolate(struct page *page);
 void unset_migratetype_isolate(struct page *page, unsigned migratetype);
-
+struct page *alloc_migrate_target(struct page *page, unsigned long private,
+				int **resultp);
 
 #endif
diff -puN mm/page_alloc.c~mm-page_alloc-refactor-out-__alloc_contig_migrate_alloc mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page_alloc-refactor-out-__alloc_contig_migrate_alloc
+++ a/mm/page_alloc.c
@@ -5653,18 +5653,6 @@ static unsigned long pfn_max_align_up(un
 				pageblock_nr_pages));
 }
 
-static struct page *
-__alloc_contig_migrate_alloc(struct page *page, unsigned long private,
-			     int **resultp)
-{
-	gfp_t gfp_mask = GFP_USER | __GFP_MOVABLE;
-
-	if (PageHighMem(page))
-		gfp_mask |= __GFP_HIGHMEM;
-
-	return alloc_page(gfp_mask);
-}
-
 /* [start, end) must belong to a single zone. */
 static int __alloc_contig_migrate_range(unsigned long start, unsigned long end)
 {
@@ -5707,7 +5695,7 @@ static int __alloc_contig_migrate_range(
 		reclaim_clean_pages_from_list(cc.zone, &cc.migratepages);
 
 		ret = migrate_pages(&cc.migratepages,
-				    __alloc_contig_migrate_alloc,
+				    alloc_migrate_target,
 				    0, false, MIGRATE_SYNC);
 	}
 
diff -puN mm/page_isolation.c~mm-page_alloc-refactor-out-__alloc_contig_migrate_alloc mm/page_isolation.c
--- a/mm/page_isolation.c~mm-page_alloc-refactor-out-__alloc_contig_migrate_alloc
+++ a/mm/page_isolation.c
@@ -248,3 +248,14 @@ int test_pages_isolated(unsigned long st
 	spin_unlock_irqrestore(&zone->lock, flags);
 	return ret ? 0 : -EBUSY;
 }
+
+struct page *alloc_migrate_target(struct page *page, unsigned long private,
+                             int **resultp)
+{
+        gfp_t gfp_mask = GFP_USER | __GFP_MOVABLE;
+
+        if (PageHighMem(page))
+                gfp_mask |= __GFP_HIGHMEM;
+
+        return alloc_page(gfp_mask);
+}
_

Patches currently in -mm which might be from minchan@kernel.org are

memory-hotplug-reset-pgdat-kswapd-to-null-if-creating-kernel-thread-fails.patch
linux-next.patch
mm-remove-__gfp_no_kswapd.patch
mm-fix-nonuniform-page-status-when-writing-new-file-with-small-buffer.patch
mm-fix-nonuniform-page-status-when-writing-new-file-with-small-buffer-fix.patch
mm-fix-nonuniform-page-status-when-writing-new-file-with-small-buffer-fix-fix.patch
mm-compaction-update-comment-in-try_to_compact_pages.patch
mm-vmscan-scale-number-of-pages-reclaimed-by-reclaim-compaction-based-on-failures.patch
mm-vmscan-scale-number-of-pages-reclaimed-by-reclaim-compaction-based-on-failures-fix.patch
mm-compaction-capture-a-suitable-high-order-page-immediately-when-it-is-made-available.patch
mm-cma-discard-clean-pages-during-contiguous-allocation-instead-of-migration.patch
mm-move-all-mmu-notifier-invocations-to-be-done-outside-the-pt-lock-fix-fix.patch
mm-page_alloc-use-get_freepage_migratetype-instead-of-page_private.patch
mm-remain-migratetype-in-freed-page.patch
memory-hotplug-bug-fix-race-between-isolation-and-allocation.patch
memory-hotplug-fix-pages-missed-by-race-rather-than-failing.patch
memory-hotplug-fix-pages-missed-by-race-rather-than-failng-fix.patch
swap-add-a-simple-detector-for-inappropriate-swapin-readahead.patch
swap-add-a-simple-detector-for-inappropriate-swapin-readahead-fix.patch
mm-memblock-reduce-overhead-in-binary-search.patch
mm-memblock-use-existing-interface-to-set-nid.patch
mm-memblock-cleanup-early_node_map-related-comments.patch
mm-compaction-abort-compaction-loop-if-lock-is-contended-or-run-too-long.patch
mm-compaction-abort-compaction-loop-if-lock-is-contended-or-run-too-long-fix.patch
mm-compaction-check-lock-contention-first-before-taking-lock.patch
mm-page_alloc-refactor-out-__alloc_contig_migrate_alloc.patch
memory-hotplug-dont-replace-lowmem-pages-with-highmem.patch

