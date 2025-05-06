Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5A90484A3F
	for <mm-commits@vger.kernel.org>; Tue,  6 May 2025 00:43:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746492225; cv=none; b=F5xFzjOrU4VvKpgYcpuCtv3aIAlgEX3i/lLIRePbaHtzit0HG5Ke6XBc2Bq7KxqcPGZ9LRj7A4c+Plgw7rTNBzUajG1QgreJQ+hTk0lVtb1fnzXbkrLmBg1BoYN3hYplgLX5D6pQC2V2XjUG+QlSUOccrICVJBMuK6Fr2tGC+zQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746492225; c=relaxed/simple;
	bh=P9KC+DWKccaOR9nU7a+bd40RlKFk1cS5upgxL2aVY3s=;
	h=Date:To:From:Subject:Message-Id; b=DztDWUUxD2X71yCq6sn25+mHlkesgXjFh5BHlL7WfB5tElSGkajEhDCpjXsFdmaJYDkAxVZt1pxAED8nXOTqVbBGHD/rWWlcEKGJr/qOK1No5IP2EerOcojSDnHBTMv6x3LDVoenyvWB0FHNaA15lUj4vWlpwaIjXrMo6x/cNyE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=T8elv93Q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="T8elv93Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D536C4CEE4;
	Tue,  6 May 2025 00:43:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1746492223;
	bh=P9KC+DWKccaOR9nU7a+bd40RlKFk1cS5upgxL2aVY3s=;
	h=Date:To:From:Subject:From;
	b=T8elv93Q0retGfwFBDBBoTqGDq4GoumHuFjCUj2xtv/FOWTe60g2+K4blGte/o8mW
	 i3oS6Wa23Sj9pmRvVzrJhGkmolDy4HGx83GBfrra303DGiYVE4Jd0jiUyftmC7t6Yz
	 4upMTT0NtP3wRW1u8aNfU02yJmgcl+Uj6wE+b8r0=
Date: Mon, 05 May 2025 17:43:42 -0700
To: mm-commits@vger.kernel.org,vineethr@linux.ibm.com,tj@kernel.org,tim.c.chen@intel.com,shakeel.butt@linux.dev,roman.gushchin@linux.dev,peterz@infradead.org,muchun.song@linux.dev,mkoutny@suse.com,mingo@redhat.com,mhocko@kernel.org,mgorman@suse.de,libo.chen@oracle.com,kprateek.nayak@amd.com,hannes@cmpxchg.org,corbet@lwn.net,aubrey.li@intel.com,yu.c.chen@intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] sched-numa-add-statistics-of-numa-balance-task-migration-v3.patch removed from -mm tree
Message-Id: <20250506004343.2D536C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: sched-numa-add-statistics-of-numa-balance-task-migration-v3
has been removed from the -mm tree.  Its filename was
     sched-numa-add-statistics-of-numa-balance-task-migration-v3.patch

This patch was dropped because it was folded into sched-numa-add-statistics-of-numa-balance-task-migration-and-swap.patch

------------------------------------------------------
From: Chen Yu <yu.c.chen@intel.com>
Subject: sched-numa-add-statistics-of-numa-balance-task-migration-v3
Date: Wed, 30 Apr 2025 18:36:23 +0800

Remove unnecessary p->mm check because kernel threads are not supported by
Numa Balancing.  (Libo Chen)

Link: https://lkml.kernel.org/r/20250430103623.3349842-1-yu.c.chen@intel.com
Tested-by: K Prateek Nayak <kprateek.nayak@amd.com>
Tested-by: Madadi Vineeth Reddy <vineethr@linux.ibm.com>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Chen Yu <yu.c.chen@intel.com>
Cc: Aubrey Li <aubrey.li@intel.com>
Cc: "Chen, Tim C" <tim.c.chen@intel.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Mel Gorman <mgorman <mgorman@suse.de>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Michal Koutný <mkoutny@suse.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Tejun Heo <tj@kernel.org>
Cc: Libo Chen <libo.chen@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sched/core.c |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

--- a/kernel/sched/core.c~sched-numa-add-statistics-of-numa-balance-task-migration-v3
+++ a/kernel/sched/core.c
@@ -3353,9 +3353,7 @@ void set_task_cpu(struct task_struct *p,
 static void __migrate_swap_task(struct task_struct *p, int cpu)
 {
 	__schedstat_inc(p->stats.numa_task_swapped);
-
-	if (p->mm)
-		count_memcg_events_mm(p->mm, NUMA_TASK_SWAP, 1);
+	count_memcg_events_mm(p->mm, NUMA_TASK_SWAP, 1);
 
 	if (task_on_rq_queued(p)) {
 		struct rq *src_rq, *dst_rq;
@@ -7959,8 +7957,7 @@ int migrate_task_to(struct task_struct *
 		return -EINVAL;
 
 	__schedstat_inc(p->stats.numa_task_migrated);
-	if (p->mm)
-		count_memcg_events_mm(p->mm, NUMA_TASK_MIGRATE, 1);
+	count_memcg_events_mm(p->mm, NUMA_TASK_MIGRATE, 1);
 	trace_sched_move_numa(p, curr_cpu, target_cpu);
 	return stop_one_cpu(curr_cpu, migration_cpu_stop, &arg);
 }
_

Patches currently in -mm which might be from yu.c.chen@intel.com are

sched-numa-add-statistics-of-numa-balance-task-migration-and-swap.patch

