From: akpm@linux-foundation.org
Subject: +
 mm-remove-seemingly-spurious-reclaimability-check-from-laptop_mode-gating.patch added to -mm tree
Date: Tue, 28 Feb 2017 15:53:26 -0800
Message-ID: <58b60d76.1uYN4sGkkiZCZclF%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38098 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751570AbdB1XzF (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 28 Feb 2017 18:55:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, hejianet@gmail.com, mgorman@suse.de, mhocko@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: remove seemingly spurious reclaimability check from laptop_mode gating
has been added to the -mm tree.  Its filename is
     mm-remove-seemingly-spurious-reclaimability-check-from-laptop_mode-gating.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-remove-seemingly-spurious-reclaimability-check-from-laptop_mode-gating.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-remove-seemingly-spurious-reclaimability-check-from-laptop_mode-gating.patch

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
Subject: mm: remove seemingly spurious reclaimability check from laptop_mode gating

1d82de618ddd ("mm, vmscan: make kswapd reclaim in terms of nodes") allowed
laptop_mode=1 to start writing not just when the priority drops to
DEF_PRIORITY - 2 but also when the node is unreclaimable.  That appears to
be a spurious change in this patch as I doubt the series was tested with
laptop_mode, and neither is that particular change mentioned in the
changelog.  Remove it, it's still recent.

Link: http://lkml.kernel.org/r/20170228214007.5621-4-hannes@cmpxchg.org
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Jia He <hejianet@gmail.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Mel Gorman <mgorman@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/vmscan.c~mm-remove-seemingly-spurious-reclaimability-check-from-laptop_mode-gating mm/vmscan.c
--- a/mm/vmscan.c~mm-remove-seemingly-spurious-reclaimability-check-from-laptop_mode-gating
+++ a/mm/vmscan.c
@@ -3281,7 +3281,7 @@ static int balance_pgdat(pg_data_t *pgda
 		 * If we're getting trouble reclaiming, start doing writepage
 		 * even in laptop mode.
 		 */
-		if (sc.priority < DEF_PRIORITY - 2 || !pgdat_reclaimable(pgdat))
+		if (sc.priority < DEF_PRIORITY - 2)
 			sc.may_writepage = 1;
 
 		/* Call soft limit reclaim before calling shrink_node. */
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

mm-fix-100%-cpu-kswapd-busyloop-on-unreclaimable-nodes.patch
mm-fix-check-for-reclaimable-pages-in-pf_memalloc-reclaim-throttling.patch
mm-remove-seemingly-spurious-reclaimability-check-from-laptop_mode-gating.patch
mm-remove-unnecessary-reclaimability-check-from-numa-balancing-target.patch
mm-dont-avoid-high-priority-reclaim-on-unreclaimable-nodes.patch
mm-dont-avoid-high-priority-reclaim-on-memcg-limit-reclaim.patch
mm-delete-nr_pages_scanned-and-pgdat_reclaimable.patch
revert-mm-vmscan-account-for-skipped-pages-as-a-partial-scan.patch
mm-remove-unnecessary-back-off-function-when-retrying-page-reclaim.patch

