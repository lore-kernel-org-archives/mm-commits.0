From: akpm@linux-foundation.org
Subject: [patch 011/102] mm: remove unnecessary reclaimability
 check from NUMA balancing target
Date: Wed, 03 May 2017 14:52:00 -0700
Message-ID: <20170503215200.ihWlGadI0%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47240 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752003AbdECVwC (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 3 May 2017 17:52:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, hannes@cmpxchg.org, hejianet@gmail.com, hillf.zj@alibaba-inc.com, mgorman@suse.de, mhocko@suse.com, mm-commits@vger.kernel.org, torvalds@linux-foundation.org

From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: remove unnecessary reclaimability check from NUMA balancing target

NUMA balancing already checks the watermarks of the target node to decide
whether it's a suitable balancing target.  Whether the node is reclaimable
or not is irrelevant when we don't intend to reclaim.

Link: http://lkml.kernel.org/r/20170228214007.5621-5-hannes@cmpxchg.org
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Hillf Danton <hillf.zj@alibaba-inc.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Jia He <hejianet@gmail.com>
Cc: Mel Gorman <mgorman@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |    3 ---
 1 file changed, 3 deletions(-)

diff -puN mm/migrate.c~mm-remove-unnecessary-reclaimability-check-from-numa-balancing-target mm/migrate.c
--- a/mm/migrate.c~mm-remove-unnecessary-reclaimability-check-from-numa-balancing-target
+++ a/mm/migrate.c
@@ -1722,9 +1722,6 @@ static bool migrate_balanced_pgdat(struc
 {
 	int z;
 
-	if (!pgdat_reclaimable(pgdat))
-		return false;
