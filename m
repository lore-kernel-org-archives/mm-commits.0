From: akpm@linux-foundation.org
Subject: [merged]
 mm-vmscan-call-numa-unaware-shrinkers-irrespective-of-nodemask.patch
 removed from -mm tree
Date: Fri, 24 Jan 2014 10:59:19 -0800
Message-ID: <52e2b807.kH0mKpp+ELz2ux/Z%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43312 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752748AbaAXS7U (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 24 Jan 2014 13:59:20 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, riel@redhat.com, mhocko@suse.cz, mgorman@suse.de, hannes@cmpxchg.org, glommer@gmail.com, dchinner@redhat.com, vdavydov@parallels.com

Subject: [merged] mm-vmscan-call-numa-unaware-shrinkers-irrespective-of-nodemask.patch removed from -mm tree
To: vdavydov@parallels.com,dchinner@redhat.com,glommer@gmail.com,hannes@cmpxchg.org,mgorman@suse.de,mhocko@suse.cz,riel@redhat.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 24 Jan 2014 10:59:19 -0800


The patch titled
     Subject: mm: vmscan: call NUMA-unaware shrinkers irrespective of nodemask
has been removed from the -mm tree.  Its filename was
     mm-vmscan-call-numa-unaware-shrinkers-irrespective-of-nodemask.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Vladimir Davydov <vdavydov@parallels.com>
Subject: mm: vmscan: call NUMA-unaware shrinkers irrespective of nodemask

If a shrinker is not NUMA-aware, shrink_slab() should call it exactly once
with nid=0, but currently it is not true: if node 0 is not set in the
nodemask or if it is not online, we will not call such shrinkers at all. 
As a result some slabs will be left untouched under some circumstances. 
Let us fix it.

Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
Reported-by: Dave Chinner <dchinner@redhat.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Rik van Riel <riel@redhat.com>
Cc: Glauber Costa <glommer@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

diff -puN mm/vmscan.c~mm-vmscan-call-numa-unaware-shrinkers-irrespective-of-nodemask mm/vmscan.c
--- a/mm/vmscan.c~mm-vmscan-call-numa-unaware-shrinkers-irrespective-of-nodemask
+++ a/mm/vmscan.c
@@ -369,16 +369,17 @@ unsigned long shrink_slab(struct shrink_
 	}
 
 	list_for_each_entry(shrinker, &shrinker_list, list) {
-		for_each_node_mask(shrinkctl->nid, shrinkctl->nodes_to_scan) {
-			if (!node_online(shrinkctl->nid))
-				continue;
-
-			if (!(shrinker->flags & SHRINKER_NUMA_AWARE) &&
-			    (shrinkctl->nid != 0))
-				break;
