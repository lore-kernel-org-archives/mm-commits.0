From: akpm@linux-foundation.org
Subject: + readahead-rename-state_based_readahead-to-clock_based_readahead.patch added to -mm tree
Date: Sat, 17 Mar 2007 23:50:01 -0800
Message-ID: <200703180750.l2I7o1Hp018365@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:58698 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753146AbXCRHuM (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 18 Mar 2007 03:50:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: wfg@mail.ustc.edu.cn


The patch titled
     readahead: rename state_based_readahead() to clock_based_readahead()
has been added to the -mm tree.  Its filename is
     readahead-rename-state_based_readahead-to-clock_based_readahead.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: readahead: rename state_based_readahead() to clock_based_readahead()
From: Fengguang Wu <wfg@mail.ustc.edu.cn>

Rename state_based_readahead() to clock_based_readahead().  It better reflects
the property of that readahead method.

Signed-off-by: Fengguang Wu <wfg@mail.ustc.edu.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/readahead.c |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff -puN mm/readahead.c~readahead-rename-state_based_readahead-to-clock_based_readahead mm/readahead.c
--- a/mm/readahead.c~readahead-rename-state_based_readahead-to-clock_based_readahead
+++ a/mm/readahead.c
@@ -66,7 +66,7 @@ int readahead_hit_rate = 1;
 enum ra_class {
 	RA_CLASS_ALL,
 	RA_CLASS_INITIAL,
-	RA_CLASS_STATE,
+	RA_CLASS_CLOCK,
 	RA_CLASS_CONTEXT,
 	RA_CLASS_CONTEXT_AGGRESSIVE,
 	RA_CLASS_BACKWARD,
@@ -101,7 +101,7 @@ enum ra_event {
 
 #ifdef CONFIG_DEBUG_READAHEAD
 static u32 readahead_debug_level = 1;
-static u32 disable_stateful_method;
+static u32 disable_clock_readahead;
 static const char * const ra_class_name[];
 static void ra_account(struct file_ra_state *ra, enum ra_event e, int pages);
 #  define debug_inc(var)		do { var++; } while (0)
@@ -1115,7 +1115,7 @@ static unsigned long compute_thrashing_t
  * Main function for file_ra_state based read-ahead.
  */
 static unsigned long
-state_based_readahead(struct address_space *mapping, struct file *filp,
+clock_based_readahead(struct address_space *mapping, struct file *filp,
 			struct file_ra_state *ra,
 			struct page *page, pgoff_t offset,
 			unsigned long req_size, unsigned long ra_max)
@@ -1157,7 +1157,7 @@ state_based_readahead(struct address_spa
 	if (page && ra_old + ra_old / 8 >= ra_size)
 		update_ra_thrash_bytes(mapping->backing_dev_info, ra_size);
 
-	ra_set_class(ra, RA_CLASS_STATE);
+	ra_set_class(ra, RA_CLASS_CLOCK);
 	ra_set_index(ra, offset, ra->readahead_index);
 	ra_set_size(ra, ra_size, la_size);
 
@@ -1687,8 +1687,8 @@ page_cache_readahead_adaptive(struct add
 	 */
 	if (offset == ra->prev_page + 1 &&
 	    offset == ra->lookahead_index &&
-					!debug_option(disable_stateful_method))
-		return state_based_readahead(mapping, filp, ra, page,
+					!debug_option(disable_clock_readahead))
+		return clock_based_readahead(mapping, filp, ra, page,
 						offset, req_size, ra_max);
 
 	/*
@@ -1788,7 +1788,7 @@ void readahead_cache_hit(struct file_ra_
 static const char * const ra_class_name[] = {
 	"total",
 	"initial",
-	"state",
+	"clock",
 	"context",
 	"contexta",
 	"backward",
@@ -1970,8 +1970,8 @@ static int __init readahead_init(void)
 	debugfs_create_file("events", 0644, root, NULL, &ra_events_fops);
 
 	debugfs_create_u32("debug_level", 0644, root, &readahead_debug_level);
-	debugfs_create_bool("disable_stateful_method", 0644, root,
-			    &disable_stateful_method);
+	debugfs_create_bool("disable_clock_readahead", 0644, root,
+			    &disable_clock_readahead);
 
 	return 0;
 }
_

Patches currently in -mm which might be from wfg@mail.ustc.edu.cn are

readahead-kconfig-options.patch
radixtree-introduce-scan-hole-data-functions.patch
mm-introduce-probe_page.patch
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
