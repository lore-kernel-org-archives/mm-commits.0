From: akpm@linux-foundation.org
Subject: + mm-page_alloc-fix-incorrect-zone_statistics-data.patch added to -mm tree
Date: Mon, 19 Dec 2016 13:58:27 -0800
Message-ID: <58585803.7KGeurOudtoqwVG9%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42650 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752786AbcLSV52 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 19 Dec 2016 16:57:28 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hejianet@gmail.com, hannes@cmpxchg.org, iamjoonsoo.kim@lge.com, izumi.taku@jp.fujitsu.com, mgorman@techsingularity.net, mhocko@suse.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, page_alloc: fix incorrect zone_statistics data
has been added to the -mm tree.  Its filename is
     mm-page_alloc-fix-incorrect-zone_statistics-data.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-page_alloc-fix-incorrect-zone_statistics-data.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-page_alloc-fix-incorrect-zone_statistics-data.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm-page_alloc-fix-incorrect-zone_statistics-data.patch

