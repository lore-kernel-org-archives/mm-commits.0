Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D638620C038
	for <mm-commits@vger.kernel.org>; Fri, 23 May 2025 22:04:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748037877; cv=none; b=rIT++3Q+CvHYSOMrTCpbNW+U89NXj29DKR4g3BPrvdmkXZBupeJOLpTZB8GX3I0ZUXieab7hlWaFJYKwjH+w6D0F7OJzuJeBoKJXSqzir+sB81MDR4kAuTvZ96JqG/PVcVYtCrkUoadJaXAfE+pP6TpZXp3e25ZHe9VlRprzUrU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748037877; c=relaxed/simple;
	bh=nOy0VMB0NwF3zdK+WyipgBOnRIwx8TqQU3a3vl+9gCg=;
	h=Date:To:From:Subject:Message-Id; b=futNH8gN11jquz/m81VuwN3zux7G3EtqAiKhl5hE9gjaYODq/m7Ira1YcndU+TzRx1thY4sY8dhKocV+3Viosl0umbxfQ06C0G2iwD0rTpLcf1a8ydVfPtq+7gsTAbq+7ZUfwMgde4qTI1qBMdu89/MQWVBR3m22JvvP6SaVm+4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=SK6o5GQC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="SK6o5GQC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CC71C4CEE9;
	Fri, 23 May 2025 22:04:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1748037877;
	bh=nOy0VMB0NwF3zdK+WyipgBOnRIwx8TqQU3a3vl+9gCg=;
	h=Date:To:From:Subject:From;
	b=SK6o5GQCnH0ZyCjVlDw/n3zqapU5p8kPLTJvGlFsuZjxzcz9R4E83k2bBKhOiJRAX
	 Lx+J+RS2qU95//qXTdFdWhHr/0RSP9BXBNWDFbZ50Hd0aBNH2Np7vWdf4WxLTlfSt+
	 YpYGh+xDINF2t9++wMj+hHIFiAa5VRS0vr3q1WNg=
Date: Fri, 23 May 2025 15:04:36 -0700
To: mm-commits@vger.kernel.org,yu.c.chen@intel.com,vineethr@linux.ibm.com,venkat88@linux.ibm.com,tj@kernel.org,tim.c.chen@intel.com,shakeel.butt@linux.dev,roman.gushchin@linux.dev,peterz@infradead.org,muchun.song@linux.dev,mkoutny@suse.com,mingo@redhat.com,mhocko@kernel.org,mgorman@suse.de,kprateek.nayak@amd.com,hannes@cmpxchg.org,corbet@lwn.net,Ayush.jain3@amd.com,aubrey.li@intel.com,libo.chen@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + sched-numa-fix-task-swap-by-skipping-kernel-threads.patch added to mm-new branch
Message-Id: <20250523220437.3CC71C4CEE9@smtp.kernel.org>
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
Date: Fri, 23 May 2025 20:51:01 +0800

Patch series "sched/numa: add statistics of numa balance task migration",
v5.

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
without introducing load imbalance between nodes.  In the current
implementation, B's NUMA node preference is not mandatory.  That is to
say, a kernel thread might be incorrectly chosen as B.  However, kernel
thread and user space thread that does not have mm are not supposed to be
covered by NUMA balancing because NUMA balancing only considers user pages
via VMAs.

According to Peter's suggestion for fixing this issue, we use PF_KTHREAD
to skip the kernel thread.  curr->mm is also checked because it is
possible that user_mode_thread() might create a user thread without an mm.
As per Prateek's analysis, after adding the PF_KTHREAD check, there is no
need to further check the PF_IDLE flag:

: - play_idle_precise() already ensures PF_KTHREAD is set before adding
:   PF_IDLE
: 
: - cpu_startup_entry() is only called from the startup thread which
:   should be marked with PF_KTHREAD (based on my understanding looking at
:   commit cff9b2332ab7 ("kernel/sched: Modify initial boot task idle
:   setup"))

In summary, the check in task_numa_compare() now aligns with
task_tick_numa().

Link: https://lkml.kernel.org/r/cover.1748002400.git.yu.c.chen@intel.com
Link: https://lkml.kernel.org/r/eaacc9c9bd37bac92d43a671867d85b2fdad3b06.1748002400.git.yu.c.chen@intel.com
Signed-off-by: Chen Yu <yu.c.chen@intel.com>
Signed-off-by: Libo Chen <libo.chen@oracle.com>
Suggested-by: Michal Koutný <mkoutny@suse.com>
Tested-by: Ayush Jain <Ayush.jain3@amd.com>
Tested-by: Venkat Rao Bagalkote <venkat88@linux.ibm.com>
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
Cc: Peter Zijlstra <peterz@infradead.org>
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
+	if (cur && ((cur->flags & (PF_EXITING | PF_KTHREAD)) ||
+		    !cur->mm))
 		cur = NULL;
 
 	/*
_

Patches currently in -mm which might be from libo.chen@oracle.com are

sched-numa-fix-task-swap-by-skipping-kernel-threads.patch

