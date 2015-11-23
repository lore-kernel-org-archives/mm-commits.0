From: akpm@linux-foundation.org
Subject: +
 mm-fix-swapped-movable-and-reclaimable-in-proc-pagetypeinfo.patch added to
 -mm tree
Date: Mon, 23 Nov 2015 15:47:37 -0800
Message-ID: <5653a599.wagLwF1GtwAvxmeN%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57126 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750874AbbKWXri (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 23 Nov 2015 18:47:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vbabka@suse.cz, mgorman@techsingularity.net, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: fix swapped Movable and Reclaimable in /proc/pagetypeinfo
has been added to the -mm tree.  Its filename is
     mm-fix-swapped-movable-and-reclaimable-in-proc-pagetypeinfo.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-fix-swapped-movable-and-reclaimable-in-proc-pagetypeinfo.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-fix-swapped-movable-and-reclaimable-in-proc-pagetypeinfo.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Vlastimil Babka <vbabka@suse.cz>
Subject: mm: fix swapped Movable and Reclaimable in /proc/pagetypeinfo

Commit 016c13daa5c9 ("mm, page_alloc: use masks and shifts when converting
GFP flags to migrate types") has swapped MIGRATE_MOVABLE and
MIGRATE_RECLAIMABLE in the enum definition.  However, migratetype_names
wasn't updated to reflect that.  As a result, the file /proc/pagetypeinfo
shows the counts for Movable as Reclaimable and vice versa.

Additionally, commit 0aaa29a56e4f ("mm, page_alloc: reserve pageblocks for
high-order atomic allocations on demand") introduced MIGRATE_HIGHATOMIC,
but did not add a letter to distinguish it into show_migration_types(), so
it doesn't appear in the listing of free areas during page alloc failures
or oom kills.

This patch fixes both problems.  The atomic reserves will show with a
letter 'H' in the free areas listings.

Fixes: 016c13daa5c9 ("mm, page_alloc: use masks and shifts when converting GFP flags to migrate types") 
Fixes: 0aaa29a56e4f ("mm, page_alloc: reserve pageblocks for high-order atomic allocations on demand")
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Mel Gorman <mgorman@techsingularity.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    3 ++-
 mm/vmstat.c     |    2 +-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff -puN mm/page_alloc.c~mm-fix-swapped-movable-and-reclaimable-in-proc-pagetypeinfo mm/page_alloc.c
--- a/mm/page_alloc.c~mm-fix-swapped-movable-and-reclaimable-in-proc-pagetypeinfo
+++ a/mm/page_alloc.c
@@ -3647,8 +3647,9 @@ static void show_migration_types(unsigne
 {
 	static const char types[MIGRATE_TYPES] = {
 		[MIGRATE_UNMOVABLE]	= 'U',
-		[MIGRATE_RECLAIMABLE]	= 'E',
 		[MIGRATE_MOVABLE]	= 'M',
+		[MIGRATE_RECLAIMABLE]	= 'E',
+		[MIGRATE_HIGHATOMIC]	= 'H',
 #ifdef CONFIG_CMA
 		[MIGRATE_CMA]		= 'C',
 #endif
diff -puN mm/vmstat.c~mm-fix-swapped-movable-and-reclaimable-in-proc-pagetypeinfo mm/vmstat.c
--- a/mm/vmstat.c~mm-fix-swapped-movable-and-reclaimable-in-proc-pagetypeinfo
+++ a/mm/vmstat.c
@@ -921,8 +921,8 @@ static void walk_zones_in_node(struct se
 #ifdef CONFIG_PROC_FS
 static char * const migratetype_names[MIGRATE_TYPES] = {
 	"Unmovable",
-	"Reclaimable",
 	"Movable",
+	"Reclaimable",
 	"HighAtomic",
 #ifdef CONFIG_CMA
 	"CMA",
_

Patches currently in -mm which might be from vbabka@suse.cz are

mm-fix-swapped-movable-and-reclaimable-in-proc-pagetypeinfo.patch
mm-documentation-clarify-proc-pid-status-vmswap-limitations-for-shmem.patch
mm-proc-account-for-shmem-swap-in-proc-pid-smaps.patch
mm-proc-reduce-cost-of-proc-pid-smaps-for-shmem-mappings.patch
mm-proc-reduce-cost-of-proc-pid-smaps-for-unpopulated-shmem-mappings.patch

