From: akpm@linux-foundation.org
Subject: - readahead-insert-cond_resched-calls.patch removed from -mm tree
Date: Tue, 08 May 2007 01:13:36 -0700
Message-ID: <200705080813.l488DaFv018924@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:49676 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934568AbXEHIOU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 04:14:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: wfg@mail.ustc.edu.cn, mm-commits@vger.kernel.org


The patch titled
     readahead: insert cond_resched() calls
has been removed from the -mm tree.  Its filename was
     readahead-insert-cond_resched-calls.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: readahead: insert cond_resched() calls
From: Wu Fengguang <wfg@mail.ustc.edu.cn>

Since the VM_MAX_READAHEAD is greatly enlarged and the algorithm more
complex, it becomes necessary to insert some cond_resched() calls in
the read-ahead path.

If desktop users still feel audio jitters with the new read-ahead code,
please try one of the following ways to get rid of it:

1) compile kernel with CONFIG_PREEMPT_VOLUNTARY/CONFIG_PREEMPT
2) reduce the read-ahead request size by running
	blockdev --setra 256 /dev/hda # or whatever device you are using

Signed-off-by: Wu Fengguang <wfg@mail.ustc.edu.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/mpage.c     |    4 +++-
 mm/readahead.c |    9 +++++++--
 2 files changed, 10 insertions(+), 3 deletions(-)

diff -puN fs/mpage.c~readahead-insert-cond_resched-calls fs/mpage.c
--- a/fs/mpage.c~readahead-insert-cond_resched-calls
+++ a/fs/mpage.c
@@ -405,8 +405,10 @@ mpage_readpages(struct address_space *ma
 					&last_block_in_bio, &map_bh,
 					&first_logical_block,
 					get_block);
-			if (!pagevec_add(&lru_pvec, page))
+			if (!pagevec_add(&lru_pvec, page)) {
+				cond_resched();
 				__pagevec_lru_add(&lru_pvec);
+			}
 		} else {
 			page_cache_release(page);
 		}
diff -puN mm/readahead.c~readahead-insert-cond_resched-calls mm/readahead.c
--- a/mm/readahead.c~readahead-insert-cond_resched-calls
+++ a/mm/readahead.c
@@ -148,8 +148,10 @@ int read_cache_pages(struct address_spac
 			continue;
 		}
 		ret = filler(data, page);
-		if (!pagevec_add(&lru_pvec, page))
+		if (!pagevec_add(&lru_pvec, page)) {
+			cond_resched();
 			__pagevec_lru_add(&lru_pvec);
+		}
 		if (ret) {
 			put_pages_list(pages);
 			break;
@@ -183,8 +185,10 @@ static int read_pages(struct address_spa
 		if (!add_to_page_cache(page, mapping,
 					page->index, GFP_KERNEL)) {
 			mapping->a_ops->readpage(filp, page);
-			if (!pagevec_add(&lru_pvec, page))
+			if (!pagevec_add(&lru_pvec, page)) {
+				cond_resched();
 				__pagevec_lru_add(&lru_pvec);
+			}
 		} else
 			page_cache_release(page);
 	}
@@ -299,6 +303,7 @@ __do_page_cache_readahead(struct address
 
 		read_unlock_irq(&mapping->tree_lock);
 		page = page_cache_alloc_cold(mapping);
+		cond_resched();
 		read_lock_irq(&mapping->tree_lock);
 		if (!page)
 			break;
_

Patches currently in -mm which might be from wfg@mail.ustc.edu.cn are

origin.patch
readahead-insert-cond_resched-calls.patch
readahead-minmax_ra_pages.patch
readahead-events-accounting.patch
readahead-rescue_pages.patch
readahead-sysctl-parameters.patch
readahead-min-max-sizes.patch
readahead-state-based-method-aging-accounting.patch
readahead-state-based-method-routines.patch
readahead-state-based-method.patch
readahead-state-based-method-check-node-id.patch
readahead-state-based-method-decouple-readahead_ratio-from-growth_limit.patch
readahead-state-based-method-cancel-lookahead-gracefully.patch
readahead-context-based-method.patch
readahead-initial-method-guiding-sizes.patch
readahead-initial-method-thrashing-guard-size.patch
readahead-initial-method-user-recommended-size.patch
readahead-initial-method.patch
readahead-backward-prefetching-method.patch
readahead-thrashing-recovery-method.patch
readahead-thrashing-recovery-method-check-unbalanced-aging.patch
readahead-thrashing-recovery-method-refill-holes.patch
readahead-call-scheme.patch
readahead-call-scheme-cleanup.patch
readahead-call-scheme-catch-thrashing-on-lookahead-time.patch
readahead-call-scheme-doc-fixes-for-readahead.patch
readahead-laptop-mode.patch
readahead-loop-case.patch
readahead-nfsd-case.patch
readahead-remove-parameter-ra_max-from-thrashing_recovery_readahead.patch
readahead-remove-parameter-ra_max-from-adjust_rala.patch
readahead-state-based-method-protect-against-tiny-size.patch
readahead-rename-state_based_readahead-to-clock_based_readahead.patch
readahead-account-i-o-block-times-for-stock-readahead.patch
readahead-rescue_pages-updates.patch
readahead-remove-noaction-shrink-events.patch
readahead-remove-size-limit-on-read_ahead_kb.patch
readahead-remove-size-limit-of-max_sectors_kb-on-read_ahead_kb.patch
readahead-partial-sendfile-fix.patch
readahead-turn-on-by-default.patch
