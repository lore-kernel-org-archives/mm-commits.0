Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2519E35972
	for <mm-commits@vger.kernel.org>; Thu,  8 May 2025 00:26:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746663971; cv=none; b=Lb9jJv2AOLIUDcu2+cWbO+GRNUKW4cwZ1AJsHR3GHyF7OaD3cVfkkS4ldZDQPVw5RT2XuuKICA2jlCuO+z9v/u4N6CWRbn9ZX66n/0W/0eLoogieH03uIb0yp0UGgN6O97mtA/ZjePrOUaeB0OvkS9Loum5p/AuJe4vn1tBsEXc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746663971; c=relaxed/simple;
	bh=WU37a7a3ruLaIRqZtgEZnsoG5OFrwV3DLx7VxOciFvs=;
	h=Date:To:From:Subject:Message-Id; b=JpT/lUlvHIFLXli5FBeiC+GJUyDSS8fiQQKtBMfEiH8jELhglPL2K+X/xfGwU71vqgwYQQfmGwPwm8BDwZcBvUhgTYa4nnMaBbKuHSmXDFNr0kIUpurh2iPz7KeQNP7PAHsEwYPsTIYghQHP0V4MIcSa4QmFP/ON7aHEafdxvYs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=miMgaYYQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="miMgaYYQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52AC5C4CEE2;
	Thu,  8 May 2025 00:26:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1746663969;
	bh=WU37a7a3ruLaIRqZtgEZnsoG5OFrwV3DLx7VxOciFvs=;
	h=Date:To:From:Subject:From;
	b=miMgaYYQ4QJtys8jC51lSd2Af9CCdczdX4qlFHSOy2u11EqX6nNy6erCDGLaOr7lO
	 M4dtcu071vPbuoQObMX7J0sNscN+nv5a6BcOHxrAzk9cQ1jilTK88RNL5aCmn0LQJA
	 IX/oD3SY/Pgw43/MHKXldH/+fJusQHoGeMZMA18o=
Date: Wed, 07 May 2025 17:26:08 -0700
To: mm-commits@vger.kernel.org,yu.c.chen@intel.com,vineethr@linux.ibm.com,tj@kernel.org,tim.c.chen@intel.com,shakeel.butt@linux.dev,roman.gushchin@linux.dev,peterz@infradead.org,muchun.song@linux.dev,mkoutny@suse.com,mingo@redhat.com,mhocko@kernel.org,mgorman@suse.de,kprateek.nayak@amd.com,hannes@cmpxchg.org,corbet@lwn.net,Ayush.jain3@amd.com,aubrey.li@intel.com,libo.chen@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + sched-numa-fix-task-swap-by-skipping-kernel-threads.patch added to mm-new branch
Message-Id: <20250508002609.52AC5C4CEE2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: sched/numa: fix task swap by skipping kernel threads
has been added to the -mm mm-new branch.  Its filename is
     sched-numa-fix-task-swap-by-skipping-kernel-threads.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/sched-numa-fix-task-swap-by-skipping-kernel-threads.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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

sched-numa-skip-vma-scanning-on-memory-pinned-to-one-numa-node-via-cpusetmems.patch
sched-numa-add-tracepoint-that-tracks-the-skipping-of-numa-balancing-due-to-cpuset-memory-pinning.patch
sched-numa-fix-task-swap-by-skipping-kernel-threads.patch

