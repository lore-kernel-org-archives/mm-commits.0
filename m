From: akpm@linux-foundation.org
Subject: +
 mm-compaction-skip-blocks-where-isolation-fails-in-async-direct-compaction-fix.patch added to -mm tree
Date: Mon, 25 Apr 2016 13:10:02 -0700
Message-ID: <571e799a.ZTGsHC+KQQRTn+Lm%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55222 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964785AbcDYUKI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 25 Apr 2016 16:10:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hughd@google.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, compaction: prevent nr_isolated_* from going negative
has been added to the -mm tree.  Its filename is
     mm-compaction-skip-blocks-where-isolation-fails-in-async-direct-compaction-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-compaction-skip-blocks-where-isolation-fails-in-async-direct-compaction-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-compaction-skip-blocks-where-isolation-fails-in-async-direct-compaction-fix.patch

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
Subject: mm, compaction: prevent nr_isolated_* from going negative

/proc/sys/vm/stat_refresh warns nr_isolated_anon and nr_isolated_file go
increasingly negative under compaction: which would add delay when should
be none, or no delay when should delay.  putback_movable_pages()
decrements the NR_ISOLATED counts which acct_isolated() increments, so
isolate_migratepages_block() needs to acct before putback in that special
case.  It's also useful to reset cc->nr_migratepages after putback so we
don't needlessly return too early on the COMPACT_CLUSTER_MAX check.

Also it's easier to track the life of cc->migratepages if we don't assign
it to a migratelist variable.

Fixes: mmotm mm-compaction-skip-blocks-where-isolation-fails-in-async-direct-compaction.patch
Signed-off-by: Hugh Dickins <hughd@google.com>
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff -puN mm/compaction.c~mm-compaction-skip-blocks-where-isolation-fails-in-async-direct-compaction-fix mm/compaction.c
--- a/mm/compaction.c~mm-compaction-skip-blocks-where-isolation-fails-in-async-direct-compaction-fix
+++ a/mm/compaction.c
@@ -638,7 +638,6 @@ isolate_migratepages_block(struct compac
 {
 	struct zone *zone = cc->zone;
 	unsigned long nr_scanned = 0, nr_isolated = 0;
-	struct list_head *migratelist = &cc->migratepages;
 	struct lruvec *lruvec;
 	unsigned long flags = 0;
 	bool locked = false;
@@ -812,7 +811,7 @@ isolate_migratepages_block(struct compac
 		del_page_from_lru_list(page, lruvec, page_lru(page));
 
 isolate_success:
-		list_add(&page->lru, migratelist);
+		list_add(&page->lru, &cc->migratepages);
 		cc->nr_migratepages++;
 		nr_isolated++;
 
@@ -846,9 +845,11 @@ isolate_fail:
 				spin_unlock_irqrestore(&zone->lru_lock,	flags);
 				locked = false;
 			}
-			putback_movable_pages(migratelist);
-			nr_isolated = 0;
+			acct_isolated(zone, cc);
+			putback_movable_pages(&cc->migratepages);
+			cc->nr_migratepages = 0;
 			cc->last_migrated_pfn = 0;
+			nr_isolated = 0;
 		}
 
 		if (low_pfn < next_skip_pfn) {
_

Patches currently in -mm which might be from hughd@google.com are

huge-pagecache-mmap_sem-is-unlocked-when-truncation-splits-pmd.patch
mm-cma-prevent-nr_isolated_-counters-from-going-negative.patch
mm-compaction-skip-blocks-where-isolation-fails-in-async-direct-compaction-fix.patch
mm-update_lru_size-warn-and-reset-bad-lru_size.patch
mm-update_lru_size-do-the-__mod_zone_page_state.patch
mm-use-__setpageswapbacked-and-dont-clearpageswapbacked.patch
tmpfs-preliminary-minor-tidyups.patch
mm-proc-sys-vm-stat_refresh-to-force-vmstat-update.patch
huge-mm-move_huge_pmd-does-not-need-new_vma.patch
huge-pagecache-extend-mremap-pmd-rmap-lockout-to-files.patch
arch-fix-has_transparent_hugepage.patch

