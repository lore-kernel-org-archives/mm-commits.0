From: akpm@linux-foundation.org
Subject: + mm-compaction-add-proc-trigger-for-memory-compaction-fix.patch added to -mm tree
Date: Wed, 07 Apr 2010 13:09:01 -0700
Message-ID: <201004072009.o37K91wj004786@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45955 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750763Ab0DGUKM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 Apr 2010 16:10:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mel@csn.ul.ie, aarcange@redhat.com, cl@linux-foundation.org, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, minchan.kim@gmail.com, riel@redhat.com


The patch titled
     mm: compaction: tighten up the allowed values for compact_memory and initialisation
has been added to the -mm tree.  Its filename is
     mm-compaction-add-proc-trigger-for-memory-compaction-fix.patch

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
Subject: mm: compaction: tighten up the allowed values for compact_memory and initialisation
From: Mel Gorman <mel@csn.ul.ie>

Update the documentation on compact_memory to only define 1 as an allowed
value in case it needs to be expanded later.  It also changes how a
compact_control structure is initialised to avoid potential trouble in the
future.

This is a fix to the patch "Add /proc trigger for memory compaction".

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
Cc: Rik van Riel <riel@redhat.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Minchan Kim <minchan.kim@gmail.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Christoph Lameter <cl@linux-foundation.org>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/sysctl/vm.txt |    9 ++++-----
 mm/compaction.c             |    9 +++++----
 2 files changed, 9 insertions(+), 9 deletions(-)

diff -puN Documentation/sysctl/vm.txt~mm-compaction-add-proc-trigger-for-memory-compaction-fix Documentation/sysctl/vm.txt
--- a/Documentation/sysctl/vm.txt~mm-compaction-add-proc-trigger-for-memory-compaction-fix
+++ a/Documentation/sysctl/vm.txt
@@ -67,11 +67,10 @@ information on block I/O debugging is in
 
 compact_memory
 
-Available only when CONFIG_COMPACTION is set. When an arbitrary value
-is written to the file, all zones are compacted such that free memory
-is available in contiguous blocks where possible. This can be important
-for example in the allocation of huge pages although processes will also
-directly compact memory as required.
+Available only when CONFIG_COMPACTION is set. When 1 is written to the file,
+all zones are compacted such that free memory is available in contiguous
+blocks where possible. This can be important for example in the allocation of
+huge pages although processes will also directly compact memory as required.
 
 ==============================================================
 
diff -puN mm/compaction.c~mm-compaction-add-proc-trigger-for-memory-compaction-fix mm/compaction.c
--- a/mm/compaction.c~mm-compaction-add-proc-trigger-for-memory-compaction-fix
+++ a/mm/compaction.c
@@ -404,15 +404,16 @@ static int compact_node(int nid)
 	lru_add_drain_all();
 
 	for (zoneid = 0; zoneid < MAX_NR_ZONES; zoneid++) {
-		struct compact_control cc;
+		struct compact_control cc = {
+			.nr_freepages = 0,
+			.nr_migratepages = 0,
+			.zone = zone,
+		};
 
 		zone = &pgdat->node_zones[zoneid];
 		if (!populated_zone(zone))
 			continue;
 
-		cc.nr_freepages = 0;
-		cc.nr_migratepages = 0;
-		cc.zone = zone;
 		INIT_LIST_HEAD(&cc.freepages);
 		INIT_LIST_HEAD(&cc.migratepages);
 
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
mm-compaction-memory-compaction-core-fix.patch
mm-compaction-add-proc-trigger-for-memory-compaction.patch
mm-compaction-add-proc-trigger-for-memory-compaction-fix.patch
mm-compaction-add-sys-trigger-for-per-node-memory-compaction.patch
mm-compaction-direct-compact-when-a-high-order-allocation-fails.patch
mm-compaction-add-a-tunable-that-decides-when-memory-should-be-compacted-and-when-it-should-be-reclaimed.patch
mm-compaction-do-not-compact-within-a-preferred-zone-after-a-compaction-failure.patch
mm-migration-allow-the-migration-of-pageswapcache-pages.patch
delay-accounting-re-implement-c-for-getdelaysc-to-report-information-on-a-target-command.patch
delay-accounting-re-implement-c-for-getdelaysc-to-report-information-on-a-target-command-checkpatch-fixes.patch
add-debugging-aid-for-memory-initialisation-problems.patch

