Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38A672135BC
	for <mm-commits@vger.kernel.org>; Wed, 30 Apr 2025 21:15:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746047720; cv=none; b=XOlRxvqPqLIO8XRj6ftzV5Gz59v9It146B2xbVlRQLUecPb4jeaD2dHRs3+jC3Qal3vrgwLNEk22Ad9BuWOlRF9t4dffuy7129bDFffO0NDxvVABLw1uN6cJU8+fyYP3TedkK3ev/y/QplsjowCrAgxplhUz6hSzBQqRvNhcDc4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746047720; c=relaxed/simple;
	bh=5bFP8vGWbSCU2OLqcgHqEisAc1pqZftxBAd45zyIPN8=;
	h=Date:To:From:Subject:Message-Id; b=XDNUJjBvFzvzM03MvtD6dXtYiyyHV5Ih1xVHIQIKN6swKNKfa07wAUeVWAIGcvYc4yzs+bEQ07jSMXCxhsD0UEtFYwUI4tuK1ic6xyzD4dg3Vugql4+WQEvbN33QgFdqjthavLonvy6LHEUF3+YsN0sOenuWcfEd2bH/8jB3lqQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=wG0+ueaQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="wG0+ueaQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B1E4C4CEE7;
	Wed, 30 Apr 2025 21:15:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1746047719;
	bh=5bFP8vGWbSCU2OLqcgHqEisAc1pqZftxBAd45zyIPN8=;
	h=Date:To:From:Subject:From;
	b=wG0+ueaQLrgwNNpUjgMyVEzWWmoJ4p0cAMh0YKdhiQGC0+nIIB2r/qXOl2hsmh0Ei
	 DHN+3KHIYQiGgbRkQg1UD3h6HZWLA728fF+u/sW/FjIQ6jnOUzCZVVhR/XfLPozx+0
	 9A3YL/fUrnEsCDtlj3rh+H9q4xIuSAk93rmNXPVM=
Date: Wed, 30 Apr 2025 14:15:18 -0700
To: mm-commits@vger.kernel.org,vineethr@linux.ibm.com,tj@kernel.org,tim.c.chen@intel.com,shakeel.butt@linux.dev,roman.gushchin@linux.dev,peterz@infradead.org,muchun.song@linux.dev,mkoutny@suse.com,mingo@redhat.com,mhocko@kernel.org,mgorman@suse.de,libo.chen@oracle.com,kprateek.nayak@amd.com,hannes@cmpxchg.org,corbet@lwn.net,aubrey.li@intel.com,yu.c.chen@intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + sched-numa-add-statistics-of-numa-balance-task-migration-v3.patch added to mm-unstable branch
Message-Id: <20250430211519.6B1E4C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: sched-numa-add-statistics-of-numa-balance-task-migration-v3
has been added to the -mm mm-unstable branch.  Its filename is
     sched-numa-add-statistics-of-numa-balance-task-migration-v3.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/sched-numa-add-statistics-of-numa-balance-task-migration-v3.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

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
sched-numa-add-statistics-of-numa-balance-task-migration-v3.patch

