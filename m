From: akpm@linux-foundation.org
Subject: [merged]
 mm-memcontrolc-mem_cgroup_select_victim_node-clarify-comment.patch removed
 from -mm tree
Date: Fri, 20 May 2016 14:04:33 -0700
Message-ID: <573f7be1.WIo3PHwwSWBAinJt%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47002 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751086AbcETVEe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 20 May 2016 17:04:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@kernel.org, hannes@cmpxchg.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memcontrol.c:mem_cgroup_select_victim_node(): clarify comment
has been removed from the -mm tree.  Its filename was
     mm-memcontrolc-mem_cgroup_select_victim_node-clarify-comment.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Michal Hocko <mhocko@kernel.org>
Subject: mm/memcontrol.c:mem_cgroup_select_victim_node(): clarify comment

> The comment seems to have not much to do with the code?

I guess the comment tries to say that the code path is triggered when we
charge the page which happens _before_ it is added to the LRU list and
so last_scanned_node might contain the stale data.

Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff -puN mm/memcontrol.c~mm-memcontrolc-mem_cgroup_select_victim_node-clarify-comment mm/memcontrol.c
--- a/mm/memcontrol.c~mm-memcontrolc-mem_cgroup_select_victim_node-clarify-comment
+++ a/mm/memcontrol.c
@@ -1391,10 +1391,9 @@ int mem_cgroup_select_victim_node(struct
 
 	node = next_node_in(node, memcg->scan_nodes);
 	/*
-	 * We call this when we hit limit, not when pages are added to LRU.
-	 * No LRU may hold pages because all pages are UNEVICTABLE or
-	 * memcg is too small and all pages are not on LRU. In that case,
-	 * we use curret node.
+	 * mem_cgroup_may_update_nodemask might have seen no reclaimmable pages
+	 * last time it really checked all the LRUs due to rate limiting.
+	 * Fallback to the current node in that case for simplicity.
 	 */
 	if (unlikely(node == MAX_NUMNODES))
 		node = numa_node_id();
_

Patches currently in -mm which might be from mhocko@kernel.org are


