From: akpm@linux-foundation.org
Subject: + mm-compaction-memory-compaction-core-fix-page-buddy-can-go-away-before-reading-page_order-while-isolating-pages-for-migration.patch added to -mm tree
Date: Thu, 08 Apr 2010 12:56:41 -0700
Message-ID: <201004081956.o38JufwK005315@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37399 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933307Ab0DHT5r (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 8 Apr 2010 15:57:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: aarcange@redhat.com, mel@csn.ul.ie


The patch titled
     mm: compaction: page buddy can go away before reading page_order while isolating pages for migration
has been added to the -mm tree.  Its filename is
     mm-compaction-memory-compaction-core-fix-page-buddy-can-go-away-before-reading-page_order-while-isolating-pages-for-migration.patch

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
Subject: mm: compaction: page buddy can go away before reading page_order while isolating pages for migration
From: Andrea Arcangeli <aarcange@redhat.com>

zone->lock isn't held so the optimisation is unsafe.  The page could be
allocated between when PageBuddy is checked and page-order is called.  The
scanner will harmlessly walk the other free pages so let's just skip this
optimization.

[mel@csn.ul.ie: Expanded the changelog]
Signed-off-by: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff -puN mm/compaction.c~mm-compaction-memory-compaction-core-fix-page-buddy-can-go-away-before-reading-page_order-while-isolating-pages-for-migration mm/compaction.c
--- a/mm/compaction.c~mm-compaction-memory-compaction-core-fix-page-buddy-can-go-away-before-reading-page_order-while-isolating-pages-for-migration
+++ a/mm/compaction.c
@@ -258,10 +258,8 @@ static unsigned long isolate_migratepage
 
 		/* Get the page and skip if free */
 		page = pfn_to_page(low_pfn);
-		if (PageBuddy(page)) {
-			low_pfn += (1 << page_order(page)) - 1;
+		if (PageBuddy(page))
 			continue;
-		}
 
 		/* Try isolate the page */
 		if (__isolate_lru_page(page, ISOLATE_BOTH, 0) != 0)
_

Patches currently in -mm which might be from aarcange@redhat.com are

origin.patch
define-madv_hugepage.patch
mincore-cleanups.patch
mincore-break-do_mincore-into-logical-pieces.patch
mincore-pass-ranges-as-startend-address-pairs.patch
mincore-do-nested-page-table-walks.patch
mm-migration-take-a-reference-to-the-anon_vma-before-migrating.patch
mm-migration-do-not-try-to-migrate-unmapped-anonymous-pages.patch
mm-share-the-anon_vma-ref-counts-between-ksm-and-page-migration.patch
mm-allow-config_migration-to-be-set-without-config_numa-or-memory-hot-remove.patch
mm-allow-config_migration-to-be-set-without-config_numa-or-memory-hot-remove-fix.patch
mm-export-unusable-free-space-index-via-proc-unusable_index.patch
mm-export-fragmentation-index-via-proc-extfrag_index.patch
mm-move-definition-for-lru-isolation-modes-to-a-header.patch
mm-compaction-memory-compaction-core.patch
mm-compaction-memory-compaction-core-fix.patch
mm-compaction-memory-compaction-core-fix-page-buddy-can-go-away-before-reading-page_order-while-isolating-pages-for-migration.patch
mm-compaction-add-proc-trigger-for-memory-compaction.patch
mm-compaction-add-proc-trigger-for-memory-compaction-fix.patch
mm-compaction-add-proc-trigger-for-memory-compaction-fix-fix.patch
mm-compaction-add-sys-trigger-for-per-node-memory-compaction.patch
mm-compaction-direct-compact-when-a-high-order-allocation-fails.patch
mm-compaction-direct-compact-when-a-high-order-allocation-fails-reject-fix.patch
mm-compaction-add-a-tunable-that-decides-when-memory-should-be-compacted-and-when-it-should-be-reclaimed.patch
mm-compaction-do-not-compact-within-a-preferred-zone-after-a-compaction-failure.patch
mm-migration-allow-the-migration-of-pageswapcache-pages.patch
mm-migration-allow-the-migration-of-pageswapcache-pages-fix.patch
mm-compaction-do-not-display-compaction-related-stats-when-config_compaction.patch
mm-compaction-do-not-display-compaction-related-stats-when-config_compaction-reject-fix.patch

