From: akpm@linux-foundation.org
Subject: + vmscan-dont-export-nr_saved_scan-in-proc-zoneinfo.patch added to -mm tree
Date: Mon, 04 May 2009 14:47:27 -0700
Message-ID: <200905042147.n44LlR1M016104@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38807 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751830AbZEDVvP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 4 May 2009 17:51:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: fengguang.wu@intel.com, a.p.zijlstra@chello.nl, cl@linux-foundation.org, kosaki.motohiro@jp.fujitsu.com, npiggin@suse.de, riel@redhat.com


The patch titled
     vmscan: don't export nr_saved_scan in /proc/zoneinfo
has been added to the -mm tree.  Its filename is
     vmscan-dont-export-nr_saved_scan-in-proc-zoneinfo.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: vmscan: don't export nr_saved_scan in /proc/zoneinfo
From: Wu Fengguang <fengguang.wu@intel.com>

The lru->nr_saved_scan's are not meaningful counters for even kernel
developers.  They typically are smaller than 32 and are always 0 for large
lists.  So remove them from /proc/zoneinfo.

Hopefully this interface change won't break too many scripts. 
/proc/zoneinfo is too unstructured to be script friendly, and I wonder the
affected scripts - if there are any - are still bleeding since the not
long ago commit "vmscan: split LRU lists into anon & file sets", which
also touched the "scanned" line :)

If we are to re-export accumulated vmscan counts in the future, they can
go to new lines in /proc/zoneinfo instead of the current form, or to
/sys/devices/system/node/node0/meminfo?

Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>

Acked-by: Rik van Riel <riel@redhat.com>
Cc: Nick Piggin <npiggin@suse.de>
Acked-by: Christoph Lameter <cl@linux-foundation.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmstat.c |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff -puN mm/vmstat.c~vmscan-dont-export-nr_saved_scan-in-proc-zoneinfo mm/vmstat.c
--- a/mm/vmstat.c~vmscan-dont-export-nr_saved_scan-in-proc-zoneinfo
+++ a/mm/vmstat.c
@@ -721,7 +721,7 @@ static void zoneinfo_show_print(struct s
 		   "\n        min      %lu"
 		   "\n        low      %lu"
 		   "\n        high     %lu"
-		   "\n        scanned  %lu (aa: %lu ia: %lu af: %lu if: %lu)"
+		   "\n        scanned  %lu"
 		   "\n        spanned  %lu"
 		   "\n        present  %lu",
 		   zone_page_state(zone, NR_FREE_PAGES),
@@ -729,10 +729,6 @@ static void zoneinfo_show_print(struct s
 		   zone->pages_low,
 		   zone->pages_high,
 		   zone->pages_scanned,
-		   zone->lru[LRU_ACTIVE_ANON].nr_saved_scan,
-		   zone->lru[LRU_INACTIVE_ANON].nr_saved_scan,
-		   zone->lru[LRU_ACTIVE_FILE].nr_saved_scan,
-		   zone->lru[LRU_INACTIVE_FILE].nr_saved_scan,
 		   zone->spanned_pages,
 		   zone->present_pages);
 
_

Patches currently in -mm which might be from fengguang.wu@intel.com are

origin.patch
inotify-use-gfp_nofs-in-kernel_event-to-work-around-a-lockdep-false-positive.patch
inotify-use-gfp_nofs-in-kernel_event-to-work-around-a-lockdep-false-positive-fix.patch
linux-next.patch
readahead-make-mmap_miss-an-unsigned-int.patch
readahead-move-max_sane_readahead-calls-into-force_page_cache_readahead.patch
readahead-apply-max_sane_readahead-limit-in-ondemand_readahead.patch
readahead-remove-one-unnecessary-radix-tree-lookup.patch
readahead-increase-interleaved-readahead-size.patch
readahead-remove-sync-async-readahead-call-dependency.patch
readahead-clean-up-and-simplify-the-code-for-filemap-page-fault-readahead.patch
readahead-sequential-mmap-readahead.patch
readahead-enforce-full-readahead-size-on-async-mmap-readahead.patch
readahead-record-mmap-read-around-states-in-file_ra_state.patch
radix-tree-add-radix_tree_prev_hole.patch
readahead-move-the-random-read-case-to-bottom.patch
readahead-introduce-context-readahead-algorithm.patch
readahead-introduce-context-readahead-algorithm-update.patch
readahead-remove-redundant-test-in-shrink_readahead_size_eio.patch
readahead-enforce-full-sync-mmap-readahead-size.patch
pagemap-document-clarifications.patch
pagemap-documentation-9-more-exported-page-flags.patch
mm-introduce-pagehuge-for-testing-huge-gigantic-pages.patch
proc-kpagecount-kpageflags-code-cleanup.patch
proc-export-more-page-flags-in-proc-kpageflags.patch
vmscan-cleanup-the-scan-batching-code.patch
vmscan-dont-export-nr_saved_scan-in-proc-zoneinfo.patch

