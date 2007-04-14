From: akpm@linux-foundation.org
Subject: + readahead-code-cleanup-fix.patch added to -mm tree
Date: Sat, 14 Apr 2007 01:06:19 -0700
Message-ID: <200704140806.l3E86JPw021477@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:42805 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750808AbXDNIGg (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sat, 14 Apr 2007 04:06:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: wfg@mail.ustc.edu.cn, jack@suse.cz, nickpiggin@yahoo.com.au


The patch titled
     readahead-code-cleanup-fix
has been added to the -mm tree.  Its filename is
     readahead-code-cleanup-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: readahead-code-cleanup-fix
From: Fengguang Wu <wfg@mail.ustc.edu.cn>

Signed-off-by: Fengguang Wu <wfg@mail.ustc.edu.cn>
Cc: Jan Kara <jack@suse.cz>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN mm/filemap.c~readahead-code-cleanup-fix mm/filemap.c
--- a/mm/filemap.c~readahead-code-cleanup-fix
+++ a/mm/filemap.c
@@ -932,6 +932,7 @@ page_ok:
 		 */
 		if (prev_index != index || offset != prev_offset)
 			mark_page_accessed(page);
+		prev_index = index;
 
 		/*
 		 * Ok, we have the page, and it's up-to-date, so
@@ -947,8 +948,8 @@ page_ok:
 		offset += ret;
 		index += offset >> PAGE_CACHE_SHIFT;
 		offset &= ~PAGE_CACHE_MASK;
-		prev_index = index;
-		prev_offset = ra.prev_offset = offset;
+		prev_offset = offset;
+		ra.prev_offset = offset;
 
 		page_cache_release(page);
 		if (ret == nr && desc->count)
_

Patches currently in -mm which might be from wfg@mail.ustc.edu.cn are

readahead-improve-heuristic-detecting-sequential-reads.patch
readahead-code-cleanup.patch
readahead-code-cleanup-fix.patch
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
