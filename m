From: akpm@linux-foundation.org
Subject: +
 mm-fix-100%-cpu-kswapd-busyloop-on-unreclaimable-nodes-fix.patch added to
 -mm tree
Date: Tue, 07 Mar 2017 14:46:21 -0800
Message-ID: <58bf383d.9irN0XCTkYXpRhSL%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42962 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756000AbdCGW4O (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 7 Mar 2017 17:56:14 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, hejianet@gmail.com, hillf.zj@alibaba-inc.com, mhocko@suse.com, minchan@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: fix 100% CPU kswapd busyloop on unreclaimable nodes fix
has been added to the -mm tree.  Its filename is
     mm-fix-100%-cpu-kswapd-busyloop-on-unreclaimable-nodes-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-fix-100%25-cpu-kswapd-busyloop-on-unreclaimable-nodes-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-fix-100%25-cpu-kswapd-busyloop-on-unreclaimable-nodes-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: fix 100% CPU kswapd busyloop on unreclaimable nodes fix

Check kswapd failure against the cumulative nr_reclaimed count, not
against the count from the lowest priority iteration.

Link: http://lkml.kernel.org/r/20170306162410.GB2090@cmpxchg.org
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Suggested-by: Minchan Kim <minchan@kernel.org>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Jia He <hejianet@gmail.com>
Cc: Hillf Danton <hillf.zj@alibaba-inc.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN mm/vmscan.c~mm-fix-100%-cpu-kswapd-busyloop-on-unreclaimable-nodes-fix mm/vmscan.c
--- a/mm/vmscan.c~mm-fix-100%-cpu-kswapd-busyloop-on-unreclaimable-nodes-fix
+++ a/mm/vmscan.c
@@ -3223,9 +3223,9 @@ static int balance_pgdat(pg_data_t *pgda
 	count_vm_event(PAGEOUTRUN);
 
 	do {
+		unsigned long nr_reclaimed = sc.nr_reclaimed;
 		bool raise_priority = true;
 
-		sc.nr_reclaimed = 0;
 		sc.reclaim_idx = classzone_idx;
 
 		/*
@@ -3315,7 +3315,8 @@ static int balance_pgdat(pg_data_t *pgda
 		 * Raise priority if scanning rate is too low or there was no
 		 * progress in reclaiming pages
 		 */
-		if (raise_priority || !sc.nr_reclaimed)
+		nr_reclaimed = sc.nr_reclaimed - nr_reclaimed;
+		if (raise_priority || !nr_reclaimed)
 			sc.priority--;
 	} while (sc.priority >= 1);
 
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

mm-fix-100%-cpu-kswapd-busyloop-on-unreclaimable-nodes.patch
mm-fix-100%-cpu-kswapd-busyloop-on-unreclaimable-nodes-fix.patch
mm-fix-check-for-reclaimable-pages-in-pf_memalloc-reclaim-throttling.patch
mm-remove-seemingly-spurious-reclaimability-check-from-laptop_mode-gating.patch
mm-remove-unnecessary-reclaimability-check-from-numa-balancing-target.patch
mm-dont-avoid-high-priority-reclaim-on-unreclaimable-nodes.patch
mm-dont-avoid-high-priority-reclaim-on-memcg-limit-reclaim.patch
mm-delete-nr_pages_scanned-and-pgdat_reclaimable.patch
revert-mm-vmscan-account-for-skipped-pages-as-a-partial-scan.patch
mm-remove-unnecessary-back-off-function-when-retrying-page-reclaim.patch
mm-memcontrol-provide-shmem-statistics.patch

