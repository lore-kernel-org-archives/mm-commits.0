Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFD2122D4E9
	for <mm-commits@vger.kernel.org>; Wed, 21 May 2025 16:56:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747846615; cv=none; b=EDWXwtVabAJ6XAXYeMiVVk0fdARGqAQOAtThMkwAazf5Wi+JjlinY09wfBodldbbD9sZaXejDFeMal1QbTSEmUMmr4050aavJoG7DZtJaQhVW8pUcqcdWj8P5LkL9fFgSplJEiHyR3/BTsC0JaYmsEHFPADkSq1O3dFQUcrSH4U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747846615; c=relaxed/simple;
	bh=ql1VJ+v7KdtJYxLzBmBcM0nwjjcrCLYUtLWJqcYTQ94=;
	h=Date:To:From:Subject:Message-Id; b=cumrUSsAj0sYOx/gVu8SoG6XPyK9Cwjb1IqB/4le93GkFqEmYaKtKf5guquZCVQruOhxABbbizcg6C/Kdj6ID6nRlCWk4xGzxlEOgkhrMSdFxnMZajtkYYbdAZ02K+TnZl3kVuPSUI6sH5eqzGIuABmWMX2ZZ5vHXxb946skSwU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=AzbFCM2q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="AzbFCM2q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CFACC4CEE4;
	Wed, 21 May 2025 16:56:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747846613;
	bh=ql1VJ+v7KdtJYxLzBmBcM0nwjjcrCLYUtLWJqcYTQ94=;
	h=Date:To:From:Subject:From;
	b=AzbFCM2qjoDsWWnfGWEGuY+2K30D7y4itmUgK9lrE+SpET4ZIj17F+efpKp4cmWQn
	 7py8/BpG12iQUpWUWacMk4jkTR/eOGB4POFGK7FZQuw8fVj2dO2chr/ZkfR7aFT+ES
	 SNzUMU6DcFiTS5cgkTGJufjCI8PBKZuFaSFzDljk=
Date: Wed, 21 May 2025 09:56:52 -0700
To: mm-commits@vger.kernel.org,yu.c.chen@intel.com,vineethr@linux.ibm.com,venkat88@linux.ibm.com,tj@kernel.org,tim.c.chen@intel.com,shakeel.butt@linux.dev,roman.gushchin@linux.dev,peterz@infradead.org,muchun.song@linux.dev,mkoutny@suse.com,mingo@redhat.com,mhocko@kernel.org,mgorman@suse.de,kprateek.nayak@amd.com,hannes@cmpxchg.org,corbet@lwn.net,Ayush.jain3@amd.com,aubrey.li@intel.com,libo.chen@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] sched-numa-fix-task-swap-by-skipping-kernel-threads.patch removed from -mm tree
Message-Id: <20250521165653.4CFACC4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: sched/numa: fix task swap by skipping kernel threads
has been removed from the -mm tree.  Its filename was
     sched-numa-fix-task-swap-by-skipping-kernel-threads.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Libo Chen <libo.chen@oracle.com>
Subject: sched/numa: fix task swap by skipping kernel threads
Date: Wed, 7 May 2025 19:17:15 +0800

Patch series "sched/numa: add statistics of numa balance task migration",
v4.

Introduce task migration and swap statistics in the following places:

/sys/fs/cgroup/{GROUP}/memory.stat
/proc/{PID}/sched
/proc/vmstat

These statistics facilitate a rapid evaluation of the performance and
resource utilization of the target workload.


This patch (of 2):

Task swapping is triggered when there are no idle CPUs in task A's
preferred node.  In this case, the NUMA load balancer chooses a task B on
A's preferred node and swaps B with A.  This helps improve NUMA locality
without introducing load imbalance between nodes.

In the current implementation, B's NUMA node preference is not mandatory,
and it aims not to increase load imbalance.  That is to say, a kernel
thread might be chosen as B.  However, kernel threads are not supposed to
be covered by NUMA balancing because NUMA balancing only considers user
pages via VMAs.

Fix this by not considering kernel threads as swap targets in
task_numa_compare().  This can be extended beyond kernel threads in the
future by checking if a swap candidate has a valid NUMA preference through
checking the candidate's numa_preferred_nid and numa_faults.  For now,
keep the code simple.

Link: https://lkml.kernel.org/r/cover.1746611892.git.yu.c.chen@intel.com
Link: https://lkml.kernel.org/r/a541cdf9b97f523f6b8067271847a986db5ba768.1746611892.git.yu.c.chen@intel.com
Signed-off-by: Libo Chen <libo.chen@oracle.com>
Signed-off-by: Chen Yu <yu.c.chen@intel.com>
Suggested-by: Michal Koutny <mkoutny@suse.com>
Tested-by: Ayush Jain <Ayush.jain3@amd.com>
Cc: Aubrey Li <aubrey.li@intel.com>
Cc: "Chen, Tim C" <tim.c.chen@intel.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: K Prateek Nayak <kprateek.nayak@amd.com>
Cc: Madadi Vineeth Reddy <vineethr@linux.ibm.com>
Cc: Mel Gorman <mgorman <mgorman@suse.de>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Tejun Heo <tj@kernel.org>
Cc: Venkat Rao Bagalkote <venkat88@linux.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sched/fair.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/kernel/sched/fair.c~sched-numa-fix-task-swap-by-skipping-kernel-threads
+++ a/kernel/sched/fair.c
@@ -2273,7 +2273,8 @@ static bool task_numa_compare(struct tas
 
 	rcu_read_lock();
 	cur = rcu_dereference(dst_rq->curr);
-	if (cur && ((cur->flags & PF_EXITING) || is_idle_task(cur)))
+	if (cur && ((cur->flags & PF_EXITING) || is_idle_task(cur) ||
+		    !cur->mm))
 		cur = NULL;
 
 	/*
_

Patches currently in -mm which might be from libo.chen@oracle.com are


