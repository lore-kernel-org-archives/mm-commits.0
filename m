From: akpm@linux-foundation.org
Subject: [merged] memcg-clean-up-memcg-nodeinfo.patch removed from -mm
 tree
Date: Tue, 09 Jul 2013 16:19:24 -0700
Message-ID: <51dc9a7c.7ebT8UYskNrqefjo%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38797 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752509Ab3GIXTZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Jul 2013 19:19:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rientjes@google.com, mhocko@suse.cz, kamezawa.hiroyu@jp.fujitsu.com, glommer@openvz.org, hannes@cmpxchg.org

Subject: [merged] memcg-clean-up-memcg-nodeinfo.patch removed from -mm tree
To: hannes@cmpxchg.org,glommer@openvz.org,kamezawa.hiroyu@jp.fujitsu.com,mhocko@suse.cz,rientjes@google.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 09 Jul 2013 16:19:24 -0700


The patch titled
     Subject: memcg: clean up memcg->nodeinfo
has been removed from the -mm tree.  Its filename was
     memcg-clean-up-memcg-nodeinfo.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: memcg: clean up memcg->nodeinfo

Remove struct mem_cgroup_lru_info and fold its single member, the variably
sized nodeinfo[0], directly into struct mem_cgroup.  This should make it
more obvious why it has to be the last member there.

Also move the comment that's above that special last member below it, so
it is more visible to somebody that considers appending to the struct
mem_cgroup.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: David Rientjes <rientjes@google.com>
Acked-by: Michal Hocko <mhocko@suse.cz>
Cc: Glauber Costa <glommer@openvz.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   20 +++++---------------
 1 file changed, 5 insertions(+), 15 deletions(-)

diff -puN mm/memcontrol.c~memcg-clean-up-memcg-nodeinfo mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-clean-up-memcg-nodeinfo
+++ a/mm/memcontrol.c
@@ -187,10 +187,6 @@ struct mem_cgroup_per_node {
 	struct mem_cgroup_per_zone zoneinfo[MAX_NR_ZONES];
 };
 
-struct mem_cgroup_lru_info {
-	struct mem_cgroup_per_node *nodeinfo[0];
-};
-
 /*
  * Cgroups above their limits are maintained in a RB-Tree, independent of
  * their hierarchy representation
@@ -366,14 +362,8 @@ struct mem_cgroup {
 	atomic_t	numainfo_updating;
 #endif
 
-	/*
-	 * Per cgroup active and inactive list, similar to the
-	 * per zone LRU lists.
-	 *
-	 * WARNING: This has to be the last element of the struct. Don't
-	 * add new fields after this point.
-	 */
-	struct mem_cgroup_lru_info info;
+	struct mem_cgroup_per_node *nodeinfo[0];
+	/* WARNING: nodeinfo must be the last member here */
 };
 
 static size_t memcg_size(void)
@@ -683,7 +673,7 @@ static struct mem_cgroup_per_zone *
 mem_cgroup_zoneinfo(struct mem_cgroup *memcg, int nid, int zid)
 {
 	VM_BUG_ON((unsigned)nid >= nr_node_ids);
-	return &memcg->info.nodeinfo[nid]->zoneinfo[zid];
+	return &memcg->nodeinfo[nid]->zoneinfo[zid];
 }
 
 struct cgroup_subsys_state *mem_cgroup_css(struct mem_cgroup *memcg)
@@ -6087,13 +6077,13 @@ static int alloc_mem_cgroup_per_zone_inf
 		mz->on_tree = false;
 		mz->memcg = memcg;
 	}
-	memcg->info.nodeinfo[node] = pn;
+	memcg->nodeinfo[node] = pn;
 	return 0;
 }
 
 static void free_mem_cgroup_per_zone_info(struct mem_cgroup *memcg, int node)
 {
-	kfree(memcg->info.nodeinfo[node]);
+	kfree(memcg->nodeinfo[node]);
 }
 
 static struct mem_cgroup *mem_cgroup_alloc(void)
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

origin.patch
swap-add-a-simple-detector-for-inappropriate-swapin-readahead-fix.patch
mm-memmap_init_zone-performance-improvement.patch
debugging-keep-track-of-page-owners-fix-2-fix-fix-fix.patch

