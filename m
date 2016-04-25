From: akpm@linux-foundation.org
Subject: + mm-cma-prevent-nr_isolated_-counters-from-going-negative.patch
 added to -mm tree
Date: Mon, 25 Apr 2016 13:08:28 -0700
Message-ID: <571e793c.I732xyEcbiaHykOg%akpm__25915.5609099709$1461615001$gmane$org@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55210 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933532AbcDYUI3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 25 Apr 2016 16:08:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hughd@google.com, iamjoonsoo.kim@lge.com, mhocko@kernel.org, stable@vger.kernel.org, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, cma: prevent nr_isolated_* counters from going negative
has been added to the -mm tree.  Its filename is
     mm-cma-prevent-nr_isolated_-counters-from-going-negative.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-cma-prevent-nr_isolated_-counters-from-going-negative.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-cma-prevent-nr_isolated_-counters-from-going-negative.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
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

huge-pagecache-mmap_sem-is-unlocked-when-truncation-splits-pmd.patch
mm-cma-prevent-nr_isolated_-counters-from-going-negative.patch
mm-update_lru_size-warn-and-reset-bad-lru_size.patch
mm-update_lru_size-do-the-__mod_zone_page_state.patch
mm-use-__setpageswapbacked-and-dont-clearpageswapbacked.patch
tmpfs-preliminary-minor-tidyups.patch
mm-proc-sys-vm-stat_refresh-to-force-vmstat-update.patch
huge-mm-move_huge_pmd-does-not-need-new_vma.patch
huge-pagecache-extend-mremap-pmd-rmap-lockout-to-files.patch
arch-fix-has_transparent_hugepage.patch

