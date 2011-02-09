From: akpm@linux-foundation.org
Subject: + vmscan-fix-zone-shrinking-exit-when-scan-work-is-done.patch added to -mm tree
Date: Wed, 09 Feb 2011 12:05:57 -0800
Message-ID: <201102092005.p19K5w86019521@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44870 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751075Ab1BIUGj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 Feb 2011 15:06:39 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hannes@cmpxchg.org, aarcange@redhat.com, kent.overstreet@gmail.com, mel@csn.ul.ie, mhocko@suse.cz, riel@redhat.com


The patch titled
     vmscan: fix zone shrinking exit when scan work is done
has been added to the -mm tree.  Its filename is
     vmscan-fix-zone-shrinking-exit-when-scan-work-is-done.patch

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
Subject: vmscan: fix zone shrinking exit when scan work is done
From: Johannes Weiner <hannes@cmpxchg.org>

3e7d344 ("mm: vmscan: reclaim order-0 and use compaction instead of lumpy
reclaim") introduced an indefinite loop in shrink_zone().

It meant to break out of this loop when no pages had been reclaimed and
not a single page was even scanned.  The way it would detect the latter is
by taking a snapshot of sc->nr_scanned at the beginning of the function
and comparing it against the new sc->nr_scanned after the scan loop.  But
it would re-iterate without updating that snapshot, looping forever if
sc->nr_scanned changed at least once since shrink_zone() was invoked.

This is not the sole condition that would exit that loop, but it requires
other processes to change the zone state, as the reclaimer that is stuck
obviously can not anymore.

This is only happening for higher-order allocations, where reclaim is run
back to back with compaction.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Reported-by: Michal Hocko <mhocko@suse.cz>
Tested-by: Kent Overstreet<kent.overstreet@gmail.com>
Reported-by: Kent Overstreet <kent.overstreet@gmail.com>
Acked-by: Mel Gorman <mel@csn.ul.ie>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/vmscan.c~vmscan-fix-zone-shrinking-exit-when-scan-work-is-done mm/vmscan.c
--- a/mm/vmscan.c~vmscan-fix-zone-shrinking-exit-when-scan-work-is-done
+++ a/mm/vmscan.c
@@ -1882,12 +1882,12 @@ static void shrink_zone(int priority, st
 	unsigned long nr[NR_LRU_LISTS];
 	unsigned long nr_to_scan;
 	enum lru_list l;
-	unsigned long nr_reclaimed;
+	unsigned long nr_reclaimed, nr_scanned;
 	unsigned long nr_to_reclaim = sc->nr_to_reclaim;
-	unsigned long nr_scanned = sc->nr_scanned;
 
 restart:
 	nr_reclaimed = 0;
+	nr_scanned = sc->nr_scanned;
 	get_scan_count(zone, sc, nr, priority);
 
 	while (nr[LRU_INACTIVE_ANON] || nr[LRU_ACTIVE_FILE] ||
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

vmscan-fix-zone-shrinking-exit-when-scan-work-is-done.patch
mm-introduce-delete_from_page_cache.patch
mm-hugetlbfs-change-remove_from_page_cache.patch
mm-shmem-change-remove_from_page_cache.patch
mm-truncate-change-remove_from_page_cache.patch
mm-good-bye-remove_from_page_cache.patch
mm-change-__remove_from_page_cache.patch
epoll-fix-compiler-warning-and-optimize-the-non-blocking-path-fix.patch
memcg-res_counter_read_u64-fix-potential-races-on-32-bit-machines.patch
memcg-fix-ugly-initialization-of-return-value-is-in-caller.patch
memcg-soft-limit-reclaim-should-end-at-limit-not-below.patch
memcg-simplify-the-way-memory-limits-are-checked.patch
memcg-remove-unused-page-flag-bitfield-defines.patch
memcg-remove-impossible-conditional-when-committing.patch
memcg-remove-null-check-from-lookup_page_cgroup-result.patch
memcg-add-memcg-sanity-checks-at-allocating-and-freeing-pages.patch
memcg-add-memcg-sanity-checks-at-allocating-and-freeing-pages-update.patch
memcg-no-uncharged-pages-reach-page_cgroup_zoneinfo.patch
memcg-change-page_cgroup_zoneinfo-signature.patch
memcg-fold-__mem_cgroup_move_account-into-caller.patch
memcg-condense-page_cgroup-to-page-lookup-points.patch
memcg-remove-direct-page_cgroup-to-page-pointer.patch
memcg-remove-direct-page_cgroup-to-page-pointer-fix.patch
memcg-remove-direct-page_cgroup-to-page-pointer-fix-fix.patch
crash_dump-export-is_kdump_kernel-to-modules-consolidate-elfcorehdr_addr-setup_elfcorehdr-and-saved_max_pfn.patch
crash_dump-export-is_kdump_kernel-to-modules-consolidate-elfcorehdr_addr-setup_elfcorehdr-and-saved_max_pfn-fix.patch
crash_dump-export-is_kdump_kernel-to-modules-consolidate-elfcorehdr_addr-setup_elfcorehdr-and-saved_max_pfn-fix-fix.patch

