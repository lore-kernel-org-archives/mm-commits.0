From: akpm@linux-foundation.org
Subject: [merged] memcg-remove-mem_cgroup_reclaim_imbalance-remnants.patch removed from -mm tree
Date: Mon, 06 Apr 2009 12:34:43 -0700
Message-ID: <200904061934.n36JYhCx011711@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35498 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756624AbZDFTh0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 6 Apr 2009 15:37:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kosaki.motohiro@jp.fujitsu.com, balbir@linux.vnet.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     memcg: remove mem_cgroup_reclaim_imbalance() remnants
has been removed from the -mm tree.  Its filename was
     memcg-remove-mem_cgroup_reclaim_imbalance-remnants.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memcg: remove mem_cgroup_reclaim_imbalance() remnants
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

commit 4f98a2fee8acdb4ac84545df98cccecfd130f8db (vmscan: split LRU lists
into anon & file sets) removed mem_cgroup_reclaim_imbalance(), but there
are some leftovers in memcontrol.h.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |    7 -------
 1 file changed, 7 deletions(-)

diff -puN include/linux/memcontrol.h~memcg-remove-mem_cgroup_reclaim_imbalance-remnants include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~memcg-remove-mem_cgroup_reclaim_imbalance-remnants
+++ a/include/linux/memcontrol.h
@@ -88,8 +88,6 @@ extern void mem_cgroup_end_migration(str
 /*
  * For memory reclaim.
  */
-extern long mem_cgroup_reclaim_imbalance(struct mem_cgroup *mem);
-
 extern int mem_cgroup_get_reclaim_priority(struct mem_cgroup *mem);
 extern void mem_cgroup_note_reclaim_priority(struct mem_cgroup *mem,
 							int priority);
@@ -210,11 +208,6 @@ static inline void mem_cgroup_end_migrat
 {
 }
 
-static inline int mem_cgroup_reclaim_imbalance(struct mem_cgroup *mem)
-{
-	return 0;
-}
