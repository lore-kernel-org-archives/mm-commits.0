From: akpm@linux-foundation.org
Subject: - readahead-min-max-sizes-remove-get_readahead_bounds.patch removed from -mm tree
Date: Mon, 05 Mar 2007 17:45:19 -0800
Message-ID: <200703060145.l261jKse008238@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:45959 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932953AbXCFBpg (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 5 Mar 2007 20:45:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: wfg@mail.ustc.edu.cn, mm-commits@vger.kernel.org


The patch titled
     readahead: min/max sizes: remove get_readahead_bounds()
has been removed from the -mm tree.  Its filename was
     readahead-min-max-sizes-remove-get_readahead_bounds.patch

This patch was dropped because it was folded into readahead-min-max-sizes.patch

------------------------------------------------------
Subject: readahead: min/max sizes: remove get_readahead_bounds()
From: Fengguang Wu <wfg@mail.ustc.edu.cn>

Remove get_readahead_bounds():
- ra_max: we already have get_max_readahead() for it
- ra_min: is only used by context based readahead, and will be moved there
          and set to a more reasonable value

Signed-off-by: Fengguang Wu <wfg@mail.ustc.edu.cn>

Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 mm/readahead.c |   24 ------------------------
 1 files changed, 24 deletions(-)

diff -puN mm/readahead.c~readahead-min-max-sizes-remove-get_readahead_bounds mm/readahead.c
--- a/mm/readahead.c~readahead-min-max-sizes-remove-get_readahead_bounds
+++ a/mm/readahead.c
@@ -776,30 +776,6 @@ out:
 	return nr_pages;
 }
 
-/*
- * ra_min is mainly determined by the size of cache memory. Reasonable?
- *
- * Table of concrete numbers for 4KB page size:
- *   inactive + free (MB):    4   8   16   32   64  128  256  512 1024
- *            ra_min (KB):   16  16   16   16   20   24   32   48   64
- */
-static inline void get_readahead_bounds(struct file_ra_state *ra,
-					unsigned long *ra_min,
-					unsigned long *ra_max)
-{
-	unsigned long active;
-	unsigned long inactive;
-	unsigned long free;
-
-	__get_zone_counts(&active, &inactive, &free, NODE_DATA(numa_node_id()));
-
-	free += inactive;
-	*ra_max = min(min(ra->ra_pages, 0xFFFFUL), free / 2);
-	*ra_min = min(min(MIN_RA_PAGES + (free >> 14),
-			  DIV_ROUND_UP(64*1024, PAGE_CACHE_SIZE)),
-			  *ra_max / 8);
-}
-
 #endif /* CONFIG_ADAPTIVE_READAHEAD */
 
 /*
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
readahead-min-max-sizes-remove-get_readahead_bounds.patch
readahead-min-max-sizes-increase-vm_min_readahead-to-32kb.patch
readahead-state-based-method-aging-accounting.patch
readahead-state-based-method-routines.patch
readahead-state-based-method.patch
readahead-state-based-method-prevent-tiny-size.patch
readahead-state-based-method-move-readahead_ratio-out-of-compute_thrashing_threshold.patch
readahead-context-based-method.patch
readahead-context-based-method-locking-fix.patch
readahead-context-based-method-locking-fix-2.patch
readahead-context-based-method-update-ra_min.patch
readahead-context-based-method-remove-readahead_ratio.patch
readahead-initial-method-guiding-sizes.patch
readahead-initial-method-thrashing-guard-size.patch
readahead-initial-method-user-recommended-size.patch
readahead-initial-method-user-recommended-size-rename-to-read_ahead_initial_kb.patch
readahead-initial-method.patch
readahead-backward-prefetching-method.patch
readahead-thrashing-recovery-method.patch
readahead-thrashing-recovery-method-fix.patch
readahead-call-scheme.patch
readahead-call-scheme-ifdef-fix.patch
readahead-call-scheme-build-fix.patch
readahead-call-scheme-remove-get_readahead_bounds.patch
readahead-call-scheme-fix-thrashed-unaligned-read.patch
readahead-laptop-mode.patch
readahead-laptop-mode-fix.patch
readahead-loop-case.patch
readahead-nfsd-case.patch
readahead-nfsd-case-fix.patch
readahead-nfsd-case-fix-uninitialized-ra_min-ra_max.patch
readahead-nfsd-case-remove-ra_min.patch
readahead-turn-on-by-default.patch
readahead-remove-size-limit-on-read_ahead_kb.patch
readahead-remove-size-limit-of-max_sectors_kb-on-read_ahead_kb.patch
readahead-partial-sendfile-fix.patch
