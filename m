From: akpm@linux-foundation.org
Subject: + readahead-remove-noaction-shrink-events.patch added to -mm tree
Date: Sat, 17 Mar 2007 23:50:07 -0800
Message-ID: <200703180750.l2I7o7ZR018380@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:58801 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753160AbXCRHxT (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 18 Mar 2007 03:53:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: wfg@mail.ustc.edu.cn


The patch titled
     readahead: remove noaction/shrink events
has been added to the -mm tree.  Its filename is
     readahead-remove-noaction-shrink-events.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: readahead: remove noaction/shrink events
From: Fengguang Wu <wfg@mail.ustc.edu.cn>

Tear down the following ra_account(NULL, ...) calls:

	ra_account(RA_EVENT_LOOKAHEAD_NOACTION)
	ra_account(RA_EVENT_READAHEAD_SHRINK)

The two events are not as useful and do not have clear meanings.

Signed-off-by: Fengguang Wu <wfg@mail.ustc.edu.cn>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/readahead.c |   20 +++-----------------
 1 file changed, 3 insertions(+), 17 deletions(-)

diff -puN mm/readahead.c~readahead-remove-noaction-shrink-events mm/readahead.c
--- a/mm/readahead.c~readahead-remove-noaction-shrink-events
+++ a/mm/readahead.c
@@ -87,10 +87,8 @@ enum ra_event {
 	RA_EVENT_READAHEAD_HIT,		/* read-ahead page hit */
 	RA_EVENT_LOOKAHEAD,		/* look-ahead issued */
 	RA_EVENT_LOOKAHEAD_HIT,		/* look-ahead mark hit */
-	RA_EVENT_LOOKAHEAD_NOACTION,	/* look-ahead mark ignored */
 	RA_EVENT_READAHEAD_MMAP,	/* read-ahead for mmap access */
 	RA_EVENT_READAHEAD_EOF,		/* read-ahead reaches EOF */
-	RA_EVENT_READAHEAD_SHRINK,	/* ra_size falls under previous la_size */
 	RA_EVENT_READAHEAD_THRASHING,	/* read-ahead thrashing happened */
 	RA_EVENT_READAHEAD_MUTILATE,	/* read-ahead mutilated by imbalanced aging */
 	RA_EVENT_READAHEAD_RESCUE,	/* read-ahead rescued */
@@ -452,8 +450,6 @@ int force_page_cache_readahead(struct ad
 		nr_to_read -= this_chunk;
 	}
 
-	ra_account(NULL, RA_EVENT_READAHEAD, ret);
-
 	return ret;
 }
 
@@ -496,8 +492,6 @@ int do_page_cache_readahead(struct addre
 
 	ret = __do_page_cache_readahead(mapping, filp, offset, nr_to_read, 0);
 
-	ra_account(NULL, RA_EVENT_READAHEAD, ret);
-
 	return ret;
 }
 
@@ -520,7 +514,6 @@ blockable_page_cache_readahead(struct ad
 
 	actual = __do_page_cache_readahead(mapping, filp, offset, nr_to_read, 0);
 
-	ra_account(NULL, RA_EVENT_READAHEAD, actual);
 	dprintk("blockable-readahead(ino=%lu, ra=%lu+%lu) = %d\n",
 			mapping->host->i_ino, offset, nr_to_read, actual);
 
@@ -1007,7 +1000,6 @@ static int adjust_rala(unsigned long *ra
 	 * if there is a major upsurge of load, or fall of this stream's speed.
 	 */
 	if (*ra_size <= *la_size * 2) {
-		ra_account(NULL, RA_EVENT_READAHEAD_SHRINK, *ra_size);
 		return 0;
 	}
 
@@ -1710,8 +1702,6 @@ page_cache_readahead_adaptive(struct add
 
 	/* No action on look-ahead time? */
 	if (page) {
-		ra_account(ra, RA_EVENT_LOOKAHEAD_NOACTION,
-						ra->readahead_index - offset);
 		return 0;
 	}
 
@@ -1807,10 +1797,8 @@ static const char * const ra_event_name[
 	"readahead_hit",
 	"lookahead",
 	"lookahead_hit",
-	"lookahead_ignore",
 	"readahead_mmap",
 	"readahead_eof",
-	"readahead_shrink",
 	"readahead_thrash",
 	"readahead_mutilt",
 	"readahead_rescue"
@@ -1825,13 +1813,11 @@ static void ra_account(struct file_ra_st
 	if (!readahead_debug_level)
 		return;
 
-	if (e == RA_EVENT_READAHEAD_HIT && pages < 0) {
-		c = ra_class_old(ra);
+	if (pages < 0) {
 		pages = -pages;
-	} else if (ra)
+		c = ra_class_old(ra);
+	} else
 		c = ra_class_new(ra);
-	else
-		c = RA_CLASS_NONE;
 
 	if (!c)
 		c = RA_CLASS_NONE;
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
