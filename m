From: akpm@linux-foundation.org
Subject: + mm-cma-discard-clean-pages-during-contiguous-allocation-instead-of-migration-fix.patch added to -mm tree
Date: Thu, 13 Sep 2012 11:53:00 -0700
Message-ID: <20120913185301.371D55C0065@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lpp01m010-f74.google.com ([209.85.215.74]:60536 "EHLO
	mail-lpp01m010-f74.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752037Ab2IMSxG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 13 Sep 2012 14:53:06 -0400
Received: by lagw12 with SMTP id w12so211732lag.1
        for <mm-commits@vger.kernel.org>; Thu, 13 Sep 2012 11:53:02 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: minchan@kernel.org, kyungmin.park@samsung.com, m.szyprowski@samsung.com, mgorman@suse.de, mina86@mina86.com, riel@redhat.com


The patch titled
     Subject: mm-cma-discard-clean-pages-during-contiguous-allocation-instead-of-migration-fix
has been added to the -mm tree.  Its filename is
     mm-cma-discard-clean-pages-during-contiguous-allocation-instead-of-migration-fix.patch

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
Subject: mm-cma-discard-clean-pages-during-contiguous-allocation-instead-of-migration-fix

It is possible for pages to be dirty after the check
in reclaim_clean_pages_from_list so that it ends up
paging out the pages, which is never what we want for speed up.

This patch fixes it.

Signed-off-by: Minchan Kim <minchan@kernel.org>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Michal Nazarewicz <mina86@mina86.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/vmscan.c~mm-cma-discard-clean-pages-during-contiguous-allocation-instead-of-migration-fix mm/vmscan.c
--- a/mm/vmscan.c~mm-cma-discard-clean-pages-during-contiguous-allocation-instead-of-migration-fix
+++ a/mm/vmscan.c
@@ -694,7 +694,7 @@ static unsigned long shrink_page_list(st
 		struct address_space *mapping;
 		struct page *page;
 		int may_enter_fs;
-		enum page_references references = PAGEREF_RECLAIM;
+		enum page_references references = PAGEREF_RECLAIM_CLEAN;
 
 		cond_resched();
 
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
mm-cma-discard-clean-pages-during-contiguous-allocation-instead-of-migration-fix.patch
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
mm-page_alloc-refactor-out-__alloc_contig_migrate_alloc-checkpatch-fixes.patch
memory-hotplug-dont-replace-lowmem-pages-with-highmem.patch
mm-compaction-move-fatal-signal-check-out-of-compact_checklock_irqsave.patch

