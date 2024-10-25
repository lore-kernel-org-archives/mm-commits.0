Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AAC91865FC;
	Fri, 25 Oct 2024 19:33:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729884827; cv=none; b=jkcmpzYKUw1NtNXZhdJYr+ACP5QTCyLEBiWpu6FFCwYNTz+qQihGQ2dkVh1Oxl+LiL3zJfPNG1cRdtimpaQW9GgPVbDv8/MNdBoWKo1c/VVNQZjBkE1mxFS2EC8B81w/kk8fghsPkUbn6ZsQWYXUTr1Axrcy2V5yyqp2qJvBJ80=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729884827; c=relaxed/simple;
	bh=YKrbBNMkXZ2E88SvLf2QE22XdN82lOWanAy2mBfTQmo=;
	h=Date:To:From:Subject:Message-Id; b=O9nN2yQuBrZ9XH319ClSVtxshmSCRyb2Tb0x90YRIIHUA/mxoMIHEDjcpTwxpedoHcc6o+UdGIOwI29w7cEIP0Br81dn99TjVMMbAcoSXbW8AcMMmC0A+7BBYHF55/o2JVSlMqSJ8B1+CeaXPb3R1jIB0hC11vqBNiZNuITbSfo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=EYIkH/Gl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="EYIkH/Gl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E87EC4CEC3;
	Fri, 25 Oct 2024 19:33:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1729884827;
	bh=YKrbBNMkXZ2E88SvLf2QE22XdN82lOWanAy2mBfTQmo=;
	h=Date:To:From:Subject:From;
	b=EYIkH/Gl1XE123caDeCGmQlQWrevE29gtZYTWc55v6iHk8J+BfH2oSPpNLGequwup
	 lLFwDmv1gf5KayoYa7WEUfmuD+c3LKr19C8AeGIfsUdFj0EU8Y4WfRZaYxIpDYD1Zn
	 7N84WfBLyBSJFnLPIewK6PpCA7E2wzhSvXFLastM=
Date: Fri, 25 Oct 2024 12:33:46 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,nifan@outlook.com,mhocko@suse.com,dave@stgolabs.net,dan.j.williams@intel.com,a.manzanares@samsung.com,dongjoo.linux.dev@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-page_alloc-fix-numa-stats-update-for-cpu-less-nodes.patch removed from -mm tree
Message-Id: <20241025193347.1E87EC4CEC3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/page_alloc: fix NUMA stats update for cpu-less nodes
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-fix-numa-stats-update-for-cpu-less-nodes.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Dongjoo Seo <dongjoo.linux.dev@gmail.com>
Subject: mm/page_alloc: fix NUMA stats update for cpu-less nodes
Date: Wed, 23 Oct 2024 10:50:37 -0700

In the case of memoryless node, when a process prefers a node with no
memory(e.g., because it is running on a CPU local to that node), the
kernel treats a nearby node with memory as the preferred node.  As a
result, such allocations do not increment the numa_foreign counter on the
memoryless node, leading to skewed NUMA_HIT, NUMA_MISS, and NUMA_FOREIGN
stats for the nearest node.

This patch corrects this issue by:
1. Checking if the zone or preferred zone is CPU-less before updating
   the NUMA stats.
2. Ensuring NUMA_HIT is only updated if the zone is not CPU-less.
3. Ensuring NUMA_FOREIGN is only updated if the preferred zone is not
   CPU-less.

Example Before and After Patch:
- Before Patch:
 node0                   node1           node2
 numa_hit                86333181       114338269            5108
 numa_miss                5199455               0        56844591
 numa_foreign            32281033        29763013               0
 interleave_hit                91              91               0
 local_node              86326417       114288458               0
 other_node               5206219           49768        56849702

- After Patch:
                            node0           node1           node2
 numa_hit                 2523058         9225528               0
 numa_miss                 150213           10226        21495942
 numa_foreign            17144215         4501270               0
 interleave_hit                91              94               0
 local_node               2493918         9208226               0
 other_node                179351           27528        21495942

Similarly, in the context of cpuless nodes, this patch ensures that NUMA
statistics are accurately updated by adding checks to prevent the
miscounting of memory allocations when the involved nodes have no CPUs. 
This ensures more precise tracking of memory access patterns across all
nodes, regardless of whether they have CPUs or not, improving the overall
reliability of NUMA stat.  The reason is that page allocation from
dev_dax, cpuset, memcg ..  comes with preferred allocating zone in cpuless
node and it's hard to track the zone info for miss information.

Link: https://lkml.kernel.org/r/20241023175037.9125-1-dongjoo.linux.dev@gmail.com
Signed-off-by: Dongjoo Seo <dongjoo.linux.dev@gmail.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: Fan Ni <nifan@outlook.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Adam Manzanares <a.manzanares@samsung.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-fix-numa-stats-update-for-cpu-less-nodes
+++ a/mm/page_alloc.c
@@ -2858,19 +2858,21 @@ static inline void zone_statistics(struc
 {
 #ifdef CONFIG_NUMA
 	enum numa_stat_item local_stat = NUMA_LOCAL;
+	bool z_is_cpuless = !node_state(zone_to_nid(z), N_CPU);
+	bool pref_is_cpuless = !node_state(zone_to_nid(preferred_zone), N_CPU);
 
-	/* skip numa counters update if numa stats is disabled */
 	if (!static_branch_likely(&vm_numa_stat_key))
 		return;
 
-	if (zone_to_nid(z) != numa_node_id())
+	if (zone_to_nid(z) != numa_node_id() || z_is_cpuless)
 		local_stat = NUMA_OTHER;
 
-	if (zone_to_nid(z) == zone_to_nid(preferred_zone))
+	if (zone_to_nid(z) == zone_to_nid(preferred_zone) && !z_is_cpuless)
 		__count_numa_events(z, NUMA_HIT, nr_account);
 	else {
 		__count_numa_events(z, NUMA_MISS, nr_account);
-		__count_numa_events(preferred_zone, NUMA_FOREIGN, nr_account);
+		if (!pref_is_cpuless)
+			__count_numa_events(preferred_zone, NUMA_FOREIGN, nr_account);
 	}
 	__count_numa_events(z, local_stat, nr_account);
 #endif
_

Patches currently in -mm which might be from dongjoo.linux.dev@gmail.com are


