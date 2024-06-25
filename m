Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F8FF1428FA
	for <mm-commits@vger.kernel.org>; Tue, 25 Jun 2024 05:00:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719291617; cv=none; b=sdGsUxc+Gn1fwZhqvIm6BY1tdVGLR05iOGNcgbrWBpV/GECdjZFs20fsYsCIIFOHO9v8iPW0oooJKGZQE6nL8NdKiA8w1vxuLIi5gGLSVGHOQzL7AudWVD8/CLsjsyiqag7Im99Bj7leJRBJ3VlKWmnLbsW0POlP/T0ctrKWa/4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719291617; c=relaxed/simple;
	bh=kpjsGhuQ2HNLDZUAJ1BVhZcMzeXdTrZRswIkL/yRdaE=;
	h=Date:To:From:Subject:Message-Id; b=aQqx4ydoFfs+pBLowj2S/D+anWwm9ye6iT8xzIeRFnb5fJoPv172eij3UX3wx3K6F4LvnLyBr+kv+ou8Sy3/vCILDDcHfv5igI7r9+1zZMIsageAZIPbdOWNrujVV/sPKqs9j7SN6oRml4bXPsIrEazKd9KFt/9ZYbOtTlXuT/g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=C4Qm3nej; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="C4Qm3nej"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9083C32782;
	Tue, 25 Jun 2024 05:00:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719291616;
	bh=kpjsGhuQ2HNLDZUAJ1BVhZcMzeXdTrZRswIkL/yRdaE=;
	h=Date:To:From:Subject:From;
	b=C4Qm3nejz2XCO9jzLR/iZqxC2pAhSbMk3j+ryHDFaOZ0uoFexsrG8mDNjJYO1dGuX
	 qFjxinTxO8bkjqL8JIzeWKFhwx0N+ealTI4fPBNE+szxRSOh2r0iHBj4LqXrV7tosF
	 Yod4hbf6x6EQ9XJIIOpCJ01t9lLE0dLK/7X5ydVY=
Date: Mon, 24 Jun 2024 22:00:16 -0700
To: mm-commits@vger.kernel.org,yosryahmed@google.com,ying.huang@intel.com,roman.gushchin@linux.dev,oliver.sang@intel.com,muchun.song@linux.dev,mhocko@kernel.org,hannes@cmpxchg.org,fengwei.yin@intel.com,feng.tang@intel.com,shakeel.butt@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] memcg-rearrange-fields-of-mem_cgroup_per_node.patch removed from -mm tree
Message-Id: <20240625050016.D9083C32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: memcg: rearrange fields of mem_cgroup_per_node
has been removed from the -mm tree.  Its filename was
     memcg-rearrange-fields-of-mem_cgroup_per_node.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Shakeel Butt <shakeel.butt@linux.dev>
Subject: memcg: rearrange fields of mem_cgroup_per_node
Date: Tue, 28 May 2024 09:40:50 -0700

Kernel test robot reported [1] performance regression for will-it-scale
test suite's page_fault2 test case for the commit 70a64b7919cb ("memcg:
dynamically allocate lruvec_stats").  After inspection it seems like the
commit has unintentionally introduced false cache sharing.

After the commit the fields of mem_cgroup_per_node which get read on the
performance critical path share the cacheline with the fields which get
updated often on LRU page allocations or deallocations.  This has caused
contention on that cacheline and the workloads which manipulates a lot of
LRU pages are regressed as reported by the test report.

The solution is to rearrange the fields of mem_cgroup_per_node such that
the false sharing is eliminated.  Let's move all the read only pointers at
the start of the struct, followed by memcg-v1 only fields and at the end
fields which get updated often.

Experiment setup: Ran fallocate1, fallocate2, page_fault1, page_fault2 and
page_fault3 from the will-it-scale test suite inside a three level memcg
with /tmp mounted as tmpfs on two different machines, one a single numa
node and the other one, two node machine.

 $ ./[testcase]_processes -t $NR_CPUS -s 50

Results for single node, 52 CPU machine:

Testcase        base        with-patch

fallocate1      1031081     1431291  (38.80 %)
fallocate2      1029993     1421421  (38.00 %)
page_fault1     2269440     3405788  (50.07 %)
page_fault2     2375799     3572868  (50.30 %)
page_fault3     28641143    28673950 ( 0.11 %)

Results for dual node, 80 CPU machine:

Testcase        base        with-patch

fallocate1      2976288     3641185  (22.33 %)
fallocate2      2979366     3638181  (22.11 %)
page_fault1     6221790     7748245  (24.53 %)
page_fault2     6482854     7847698  (21.05 %)
page_fault3     28804324    28991870 ( 0.65 %)

Link: https://lkml.kernel.org/r/20240528164050.2625718-1-shakeel.butt@linux.dev
Fixes: 70a64b7919cb ("memcg: dynamically allocate lruvec_stats")
Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
Reported-by: kernel test robot <oliver.sang@intel.com>
Reviewed-by: Yosry Ahmed <yosryahmed@google.com>
Reviewed-by: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Feng Tang <feng.tang@intel.com>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Yin Fengwei <fengwei.yin@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |   22 ++++++++++++++--------
 1 file changed, 14 insertions(+), 8 deletions(-)

--- a/include/linux/memcontrol.h~memcg-rearrange-fields-of-mem_cgroup_per_node
+++ a/include/linux/memcontrol.h
@@ -96,23 +96,29 @@ struct mem_cgroup_reclaim_iter {
  * per-node information in memory controller.
  */
 struct mem_cgroup_per_node {
-	struct lruvec		lruvec;
+	/* Keep the read-only fields at the start */
+	struct mem_cgroup	*memcg;		/* Back pointer, we cannot */
+						/* use container_of	   */
 
 	struct lruvec_stats_percpu __percpu	*lruvec_stats_percpu;
 	struct lruvec_stats			*lruvec_stats;
-
-	unsigned long		lru_zone_size[MAX_NR_ZONES][NR_LRU_LISTS];
-
-	struct mem_cgroup_reclaim_iter	iter;
-
 	struct shrinker_info __rcu	*shrinker_info;
 
+	/*
+	 * Memcg-v1 only stuff in middle as buffer between read mostly fields
+	 * and update often fields to avoid false sharing. Once v1 stuff is
+	 * moved in a separate struct, an explicit padding is needed.
+	 */
+
 	struct rb_node		tree_node;	/* RB tree node */
 	unsigned long		usage_in_excess;/* Set to the value by which */
 						/* the soft limit is exceeded*/
 	bool			on_tree;
-	struct mem_cgroup	*memcg;		/* Back pointer, we cannot */
-						/* use container_of	   */
+
+	/* Fields which get updated often at the end. */
+	struct lruvec		lruvec;
+	unsigned long		lru_zone_size[MAX_NR_ZONES][NR_LRU_LISTS];
+	struct mem_cgroup_reclaim_iter	iter;
 };
 
 struct mem_cgroup_threshold {
_

Patches currently in -mm which might be from shakeel.butt@linux.dev are


