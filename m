From: akpm@linux-foundation.org
Subject: - mm-introduce-pg_readahead.patch removed from -mm tree
Date: Tue, 08 May 2007 01:13:29 -0700
Message-ID: <200705080813.l488DTGU018918@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:47777 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934546AbXEHIOI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 04:14:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: wfg@mail.ustc.edu.cn, mm-commits@vger.kernel.org


The patch titled
     mm: introduce PG_readahead
has been removed from the -mm tree.  Its filename was
     mm-introduce-pg_readahead.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: mm: introduce PG_readahead
From: Wu Fengguang <wfg@mail.ustc.edu.cn>

Introduce a new page flag: PG_readahead.

It acts as a look-ahead mark, which tells the page reader:
	Hey, it's time to invoke the adaptive read-ahead logic!
	For the sake of I/O pipelining, don't wait until it runs out of
	cached pages.  ;-)

Signed-off-by: Wu Fengguang <wfg@mail.ustc.edu.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page-flags.h |    6 ++++++
 mm/page_alloc.c            |    2 +-
 2 files changed, 7 insertions(+), 1 deletion(-)

diff -puN include/linux/page-flags.h~mm-introduce-pg_readahead include/linux/page-flags.h
--- a/include/linux/page-flags.h~mm-introduce-pg_readahead
+++ a/include/linux/page-flags.h
@@ -93,6 +93,8 @@
 
 #define PG_lazyfree		20	/* MADV_FREE potential throwaway */
 
+#define PG_readahead		21	/* Reminder to do read-ahead */
+
 /* PG_owner_priv_1 users should have descriptive aliases */
 #define PG_checked		PG_owner_priv_1 /* Used by some filesystems */
 
@@ -260,6 +262,10 @@ static inline void __ClearPageTail(struc
 #define SetPageUncached(page)	set_bit(PG_uncached, &(page)->flags)
 #define ClearPageUncached(page)	clear_bit(PG_uncached, &(page)->flags)
 
+#define PageReadahead(page)	test_bit(PG_readahead, &(page)->flags)
+#define SetPageReadahead(page)	set_bit(PG_readahead, &(page)->flags)
+#define ClearPageReadahead(page) clear_bit(PG_readahead, &(page)->flags)
+
 struct page;	/* forward declaration */
 
 extern void cancel_dirty_page(struct page *page, unsigned int account_size);
diff -puN mm/page_alloc.c~mm-introduce-pg_readahead mm/page_alloc.c
--- a/mm/page_alloc.c~mm-introduce-pg_readahead
+++ a/mm/page_alloc.c
@@ -644,7 +644,7 @@ static int prep_new_page(struct page *pa
 	if (PageReserved(page))
 		return 1;
 
-	page->flags &= ~(1 << PG_uptodate | 1 << PG_error |
+	page->flags &= ~(1 << PG_uptodate | 1 << PG_error | 1 << PG_readahead |
 			1 << PG_referenced | 1 << PG_arch_1 |
 			1 << PG_owner_priv_1 | 1 << PG_mappedtodisk);
 	set_page_private(page, 0);
_

Patches currently in -mm which might be from wfg@mail.ustc.edu.cn are

origin.patch
mm-introduce-pg_readahead.patch
readahead-add-look-ahead-support-to-__do_page_cache_readahead.patch
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
