From: akpm@linux-foundation.org
Subject: [merged]
 memcg-do-not-use-vmalloc-for-mem_cgroup-allocations.patch removed from -mm
 tree
Date: Fri, 24 Jan 2014 10:58:29 -0800
Message-ID: <52e2b7d5.7mWHWF00KGtrpCMy%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43153 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752484AbaAXS6a (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 24 Jan 2014 13:58:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mhocko@suse.cz, kamezawa.hiroyu@jp.fujitsu.com, hannes@cmpxchg.org, glommer@openvz.org, bsingharora@gmail.com, vdavydov@parallels.com

Subject: [merged] memcg-do-not-use-vmalloc-for-mem_cgroup-allocations.patch removed from -mm tree
To: vdavydov@parallels.com,bsingharora@gmail.com,glommer@openvz.org,hannes@cmpxchg.org,kamezawa.hiroyu@jp.fujitsu.com,mhocko@suse.cz,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 24 Jan 2014 10:58:29 -0800


The patch titled
     Subject: memcg: do not use vmalloc for mem_cgroup allocations
has been removed from the -mm tree.  Its filename was
     memcg-do-not-use-vmalloc-for-mem_cgroup-allocations.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Vladimir Davydov <vdavydov@parallels.com>
Subject: memcg: do not use vmalloc for mem_cgroup allocations

The vmalloc was introduced by 333279 ("memcgroup: use vmalloc for
mem_cgroup allocation"), because at that time MAX_NUMNODES was used for
defining the per-node array in the mem_cgroup structure so that the
structure could be huge even if the system had the only NUMA node.

The situation was significantly improved by patch 45cf7e ("memcg: reduce
the size of struct memcg 244-fold"), which made the size of the mem_cgroup
structure calculated dynamically depending on the real number of NUMA
nodes installed on the system (nr_node_ids), so now there is no point in
using vmalloc here: the structure is allocated rarely and on most systems
its size is about 1K.

Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
Acked-by: Michal Hocko <mhocko@suse.cz>
Cc: Glauber Costa <glommer@openvz.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Balbir Singh <bsingharora@gmail.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   28 ++++++----------------------
 1 file changed, 6 insertions(+), 22 deletions(-)

diff -puN mm/memcontrol.c~memcg-do-not-use-vmalloc-for-mem_cgroup-allocations mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-do-not-use-vmalloc-for-mem_cgroup-allocations
+++ a/mm/memcontrol.c
@@ -49,7 +49,6 @@
 #include <linux/sort.h>
 #include <linux/fs.h>
 #include <linux/seq_file.h>
-#include <linux/vmalloc.h>
 #include <linux/vmpressure.h>
 #include <linux/mm_inline.h>
 #include <linux/page_cgroup.h>
@@ -381,12 +380,6 @@ struct mem_cgroup {
 	/* WARNING: nodeinfo must be the last member here */
 };
 
-static size_t memcg_size(void)
-{
-	return sizeof(struct mem_cgroup) +
-		nr_node_ids * sizeof(struct mem_cgroup_per_node *);
-}
-
 /* internal only representation about the status of kmem accounting. */
 enum {
 	KMEM_ACCOUNTED_ACTIVE = 0, /* accounted by this cgroup itself */
@@ -6405,14 +6398,12 @@ static void free_mem_cgroup_per_zone_inf
 static struct mem_cgroup *mem_cgroup_alloc(void)
 {
 	struct mem_cgroup *memcg;
-	size_t size = memcg_size();
+	size_t size;
 
-	/* Can be very big if nr_node_ids is very big */
-	if (size < PAGE_SIZE)
-		memcg = kzalloc(size, GFP_KERNEL);
-	else
-		memcg = vzalloc(size);
+	size = sizeof(struct mem_cgroup);
+	size += nr_node_ids * sizeof(struct mem_cgroup_per_node *);
 
+	memcg = kzalloc(size, GFP_KERNEL);
 	if (!memcg)
 		return NULL;
 
@@ -6423,10 +6414,7 @@ static struct mem_cgroup *mem_cgroup_all
 	return memcg;
 
 out_free:
-	if (size < PAGE_SIZE)
-		kfree(memcg);
-	else
-		vfree(memcg);
+	kfree(memcg);
 	return NULL;
 }
 
@@ -6444,7 +6432,6 @@ out_free:
 static void __mem_cgroup_free(struct mem_cgroup *memcg)
 {
 	int node;
-	size_t size = memcg_size();
 
 	mem_cgroup_remove_from_trees(memcg);
 
@@ -6465,10 +6452,7 @@ static void __mem_cgroup_free(struct mem
 	 * the cgroup_lock.
 	 */
 	disarm_static_keys(memcg);
-	if (size < PAGE_SIZE)
-		kfree(memcg);
-	else
-		vfree(memcg);
+	kfree(memcg);
 }
 
 /*
_

Patches currently in -mm which might be from vdavydov@parallels.com are

origin.patch
mm-vmscan-respect-numa-policy-mask-when-shrinking-slab-on-direct-reclaim.patch
mm-vmscan-move-call-to-shrink_slab-to-shrink_zones.patch
mm-vmscan-remove-shrink_control-arg-from-do_try_to_free_pages.patch

