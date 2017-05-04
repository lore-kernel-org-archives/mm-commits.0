From: akpm@linux-foundation.org
Subject: [merged]
 =?US-ASCII?Q?mm-remove-seemingly-spurious-reclaimability-check-from-lapt?=
 =?US-ASCII?Q?op=5Fmode-gating.patch?= removed from -mm tree
Date: Thu, 04 May 2017 12:09:05 -0700
Message-ID: <20170504190905.tK8sIcGFB%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50814 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756330AbdEDTJH (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 4 May 2017 15:09:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, hejianet@gmail.com, hillf.zj@alibaba-inc.com, mgorman@techsingularity.net, mhocko@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: remove seemingly spurious reclaimability check from laptop_mode gating
has been removed from the -mm tree.  Its filename was
     mm-remove-seemingly-spurious-reclaimability-check-from-laptop_mode-gating.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
Acked-by: Hillf Danton <hillf.zj@alibaba-inc.com>
Acked-by: Mel Gorman <mgorman@techsingularity.net>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Jia He <hejianet@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/vmscan.c~mm-remove-seemingly-spurious-reclaimability-check-from-laptop_mode-gating mm/vmscan.c
--- a/mm/vmscan.c~mm-remove-seemingly-spurious-reclaimability-check-from-laptop_mode-gating
+++ a/mm/vmscan.c
@@ -3285,7 +3285,7 @@ static int balance_pgdat(pg_data_t *pgda
 		 * If we're getting trouble reclaiming, start doing writepage
 		 * even in laptop mode.
 		 */
-		if (sc.priority < DEF_PRIORITY - 2 || !pgdat_reclaimable(pgdat))
+		if (sc.priority < DEF_PRIORITY - 2)
 			sc.may_writepage = 1;
 
 		/* Call soft limit reclaim before calling shrink_node. */
_

Patches currently in -mm which might be from hannes@cmpxchg.org are


