From: akpm@linux-foundation.org
Subject: [merged]
 mm-cma-prevent-nr_isolated_-counters-from-going-negative.patch removed from -mm tree
Date: Fri, 06 May 2016 14:17:26 -0700
Message-ID: <572d09e6.fvJvAhFgnrs1MK//%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54407 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758514AbcEFVR1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 6 May 2016 17:17:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hughd@google.com, iamjoonsoo.kim@lge.com, mhocko@kernel.org, stable@vger.kernel.org, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, cma: prevent nr_isolated_* counters from going negative
has been removed from the -mm tree.  Its filename was
     mm-cma-prevent-nr_isolated_-counters-from-going-negative.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: mm, cma: prevent nr_isolated_* counters from going negative

/proc/sys/vm/stat_refresh warns nr_isolated_anon and nr_isolated_file go
increasingly negative under compaction: which would add delay when should
be none, or no delay when should delay.  The bug in compaction was due to
a recent mmotm patch, but much older instance of the bug was also noticed
in isolate_migratepages_range() which is used for CMA and gigantic
hugepage allocations.

The bug is caused by putback_movable_pages() in an error path decrementing
the isolated counters without them being previously incremented by
acct_isolated().  Fix isolate_migratepages_range() by removing the
error-path putback, thus reaching acct_isolated() with migratepages still
isolated, and leaving putback to caller like most other places do.

Fixes: edc2ca612496 ("mm, compaction: move pageblock checks up from isolate_migratepages_range()")
[vbabka@suse.cz: expanded the changelog]
Signed-off-by: Hugh Dickins <hughd@google.com>
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |   10 +---------
 1 file changed, 1 insertion(+), 9 deletions(-)

diff -puN mm/compaction.c~mm-cma-prevent-nr_isolated_-counters-from-going-negative mm/compaction.c
--- a/mm/compaction.c~mm-cma-prevent-nr_isolated_-counters-from-going-negative
+++ a/mm/compaction.c
@@ -852,16 +852,8 @@ isolate_migratepages_range(struct compac
 		pfn = isolate_migratepages_block(cc, pfn, block_end_pfn,
 							ISOLATE_UNEVICTABLE);
 
-		/*
-		 * In case of fatal failure, release everything that might
-		 * have been isolated in the previous iteration, and signal
-		 * the failure back to caller.
-		 */
-		if (!pfn) {
-			putback_movable_pages(&cc->migratepages);
-			cc->nr_migratepages = 0;
+		if (!pfn)
 			break;
-		}
 
 		if (cc->nr_migratepages == COMPACT_CLUSTER_MAX)
 			break;
_

Patches currently in -mm which might be from hughd@google.com are

mm-compaction-skip-blocks-where-isolation-fails-in-async-direct-compaction-fix.patch
mm-update_lru_size-warn-and-reset-bad-lru_size.patch
mm-update_lru_size-do-the-__mod_zone_page_state.patch
mm-use-__setpageswapbacked-and-dont-clearpageswapbacked.patch
tmpfs-preliminary-minor-tidyups.patch
mm-proc-sys-vm-stat_refresh-to-force-vmstat-update.patch
huge-mm-move_huge_pmd-does-not-need-new_vma.patch
huge-pagecache-extend-mremap-pmd-rmap-lockout-to-files.patch
arch-fix-has_transparent_hugepage.patch
radix-tree-rewrite-radix_tree_locate_item-fix.patch

