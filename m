From: akpm@linux-foundation.org
Subject: + mm-allow-config_migration-to-be-set-without-config_numa-or-memory-hot-remove-fix.patch added to -mm tree
Date: Wed, 07 Apr 2010 13:05:24 -0700
Message-ID: <201004072005.o37K5PKB004591@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42663 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750717Ab0DGUGL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 Apr 2010 16:06:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mel@csn.ul.ie, aarcange@redhat.com, cl@linux-foundation.org, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, minchan.kim@gmail.com, riel@redhat.com


The patch titled
     mm: compaction: have CONFIG_COMPACTION depend on HUGETLB_PAGE instead of HUGETLBFS
has been added to the -mm tree.  Its filename is
     mm-allow-config_migration-to-be-set-without-config_numa-or-memory-hot-remove-fix.patch

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
Subject: mm: compaction: have CONFIG_COMPACTION depend on HUGETLB_PAGE instead of HUGETLBFS
From: Mel Gorman <mel@csn.ul.ie>

There is a strong coupling between HUGETLB_PAGE and HUGETLBFS but in theory
there can be alternative interfaces to huge pages than HUGETLB_PAGE. This
patch makes CONFIG_COMPACTION depend on the right thing.

This is a fix to the patch "Allow CONFIG_MIGRATION to be set without
CONFIG_NUMA or memory hot-remove" and should be merged together.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
Cc: Christoph Lameter <cl@linux-foundation.org>
Cc: Rik van Riel <riel@redhat.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Minchan Kim <minchan.kim@gmail.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/Kconfig~mm-allow-config_migration-to-be-set-without-config_numa-or-memory-hot-remove-fix mm/Kconfig
--- a/mm/Kconfig~mm-allow-config_migration-to-be-set-without-config_numa-or-memory-hot-remove-fix
+++ a/mm/Kconfig
@@ -177,7 +177,7 @@ config COMPACTION
 	bool "Allow for memory compaction"
 	def_bool y
 	select MIGRATION
-	depends on EXPERIMENTAL && HUGETLBFS && MMU
+	depends on EXPERIMENTAL && HUGETLB_PAGE && MMU
 	help
 	  Allows the compaction of memory for the allocation of huge pages.
 
_

Patches currently in -mm which might be from mel@csn.ul.ie are

page-allocator-reduce-fragmentation-in-buddy-allocator-by-adding-buddies-that-are-merging-to-the-tail-of-the-free-lists.patch
mempolicy-remove-redundant-code.patch
mm-default-to-node-zonelist-ordering-when-nodes-have-only-lowmem.patch
mm-migration-take-a-reference-to-the-anon_vma-before-migrating.patch
mm-migration-do-not-try-to-migrate-unmapped-anonymous-pages.patch
mm-share-the-anon_vma-ref-counts-between-ksm-and-page-migration.patch
mm-allow-config_migration-to-be-set-without-config_numa-or-memory-hot-remove.patch
mm-allow-config_migration-to-be-set-without-config_numa-or-memory-hot-remove-fix.patch
mm-export-unusable-free-space-index-via-proc-unusable_index.patch
mm-export-fragmentation-index-via-proc-extfrag_index.patch
mm-move-definition-for-lru-isolation-modes-to-a-header.patch
mm-compaction-memory-compaction-core.patch
mm-compaction-add-proc-trigger-for-memory-compaction.patch
mm-compaction-add-sys-trigger-for-per-node-memory-compaction.patch
mm-compaction-direct-compact-when-a-high-order-allocation-fails.patch
mm-compaction-add-a-tunable-that-decides-when-memory-should-be-compacted-and-when-it-should-be-reclaimed.patch
mm-compaction-do-not-compact-within-a-preferred-zone-after-a-compaction-failure.patch
mm-migration-allow-the-migration-of-pageswapcache-pages.patch
delay-accounting-re-implement-c-for-getdelaysc-to-report-information-on-a-target-command.patch
delay-accounting-re-implement-c-for-getdelaysc-to-report-information-on-a-target-command-checkpatch-fixes.patch
add-debugging-aid-for-memory-initialisation-problems.patch

