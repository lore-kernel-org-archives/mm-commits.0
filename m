From: akpm@linux-foundation.org
Subject: [to-be-updated]
 mm-page_alloc-fix-incorrect-zone_statistics-data.patch removed from -mm
 tree
Date: Wed, 04 Jan 2017 17:02:49 -0800
Message-ID: <586d9b39.TTCdla1/8b9WFAKS%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38078 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965979AbdAEBBd (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 4 Jan 2017 20:01:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hejianet@gmail.com, hannes@cmpxchg.org, iamjoonsoo.kim@lge.com, izumi.taku@jp.fujitsu.com, mgorman@techsingularity.net, mhocko@suse.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, page_alloc: fix incorrect zone_statistics data
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-fix-incorrect-zone_statistics-data.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Jia He <hejianet@gmail.com>
Subject: mm, page_alloc: fix incorrect zone_statistics data

In commit b9f00e147f27 ("mm, page_alloc: reduce branches in
zone_statistics"), it reconstructed codes to reduce the branch miss rate.
Compared with the original logic, it assumed if !(flag & __GFP_OTHER_NODE)
 z->node would not be equal to preferred_zone->node. That seems to be
incorrect.

Fixes: commit b9f00e147f27 ("mm, page_alloc: reduce branches in
zone_statistics")

Link: http://lkml.kernel.org/r/1481522347-20393-2-git-send-email-hejianet@gmail.com
Signed-off-by: Jia He <hejianet@gmail.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Taku Izumi <izumi.taku@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN mm/page_alloc.c~mm-page_alloc-fix-incorrect-zone_statistics-data mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page_alloc-fix-incorrect-zone_statistics-data
+++ a/mm/page_alloc.c
@@ -2603,6 +2603,9 @@ static inline void zone_statistics(struc
 	if (z->node == local_nid) {
 		__inc_zone_state(z, NUMA_HIT);
 		__inc_zone_state(z, local_stat);
+	} else if (z->node == preferred_zone->node) {
+		__inc_zone_state(z, NUMA_HIT);
+		__inc_zone_state(z, NUMA_OTHER);
 	} else {
 		__inc_zone_state(z, NUMA_MISS);
 		__inc_zone_state(preferred_zone, NUMA_FOREIGN);
_

Patches currently in -mm which might be from hejianet@gmail.com are


