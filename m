Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E22D2C2C9
	for <mm-commits@vger.kernel.org>; Fri, 25 Apr 2025 00:45:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745541903; cv=none; b=TE3sTrhmKggjjCLk3mLoDRqJ9BSnmbqWhC9HRkBLkHyyPfpNTvZMzPW3NsYbuvsDjOu6u2z5tK34gK2dJfMWfYLYdw7N+9P6iXgbUux/zDbfT/kqXUn1wEWe8yZH56L/SD5mbBXSNw/DTKcLY0P2GYaSsQEvJEmKVR+z8gXn+h8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745541903; c=relaxed/simple;
	bh=fSip6EXk2gyUOO34dTCLjiIDqKEo5dhrmDbE8kc74MI=;
	h=Date:To:From:Subject:Message-Id; b=TVgdG+QY9dapXkMQ+sNpnxLHKAUoTCQSRD9L7TeMg4UW/pKQayvfGrvhNgWRu1ezG/TdEmnSsutDsMlBef5O6kaTY4FHIjpQzE2qSnPl9Q+SO1kGk2LRkfeuTVW+jr2o9xD/nPUEQHo3Zg0bzI4SQr6L2R3cmwT4ErecgbELfNU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=LxqWvkBS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="LxqWvkBS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42CB1C4CEE3;
	Fri, 25 Apr 2025 00:45:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1745541902;
	bh=fSip6EXk2gyUOO34dTCLjiIDqKEo5dhrmDbE8kc74MI=;
	h=Date:To:From:Subject:From;
	b=LxqWvkBSWHT20MByrxIUbf6t0utvqxemEik7ZNcqLO/ki+1z2BT71/d4O9cIzD7HD
	 m8OHWnljI0nfiDrl4Oqt4Kj09GA2Hhatny9G7VRxafPrJPwBlUhLdUE3/0gMqI7D6+
	 W0VoUSiF1+HYlaA1H9/H8cwpaIsVNiUcvj/ONII4=
Date: Thu, 24 Apr 2025 17:45:01 -0700
To: mm-commits@vger.kernel.org,yu.c.chen@intel.com,vineethr@linux.ibm.com,vincent.guittot@linaro.org,venkat88@linux.ibm.com,tj@kernel.org,tim.c.chen@intel.com,sraithal@amd.com,rostedt@goodmis.org,raghavendra.kt@amd.com,peterz@infradead.org,mkoutny@suse.com,mingo@redhat.com,mgorman@suse.de,lorenzo.stoakes@oracle.com,kprateek.nayak@amd.com,juri.lelli@redhat.com,daniel.m.jordan@oracle.com,chris.hyser@oracle.com,libo.chen@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + sched-numa-add-tracepoint-that-tracks-the-skipping-of-numa-balancing-due-to-cpuset-memory-pinning.patch added to mm-new branch
Message-Id: <20250425004502.42CB1C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: sched/numa: add tracepoint that tracks the skipping of numa balancing due to cpuset memory pinning
has been added to the -mm mm-new branch.  Its filename is
     sched-numa-add-tracepoint-that-tracks-the-skipping-of-numa-balancing-due-to-cpuset-memory-pinning.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/sched-numa-add-tracepoint-that-tracks-the-skipping-of-numa-balancing-due-to-cpuset-memory-pinning.patch

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
Subject: sched/numa: add tracepoint that tracks the skipping of numa balancing due to cpuset memory pinning
Date: Wed, 23 Apr 2025 19:45:23 -0700

Unlike sched_skip_vma_numa tracepoint which tracks skipped VMAs, this
tracks the task subjected to cpuset.mems pinning and prints out its
allowed memory node mask.

Link: https://lkml.kernel.org/r/20250424024523.2298272-3-libo.chen@oracle.com
Signed-off-by: Libo Chen <libo.chen@oracle.com>
Cc: "Chen, Tim C" <tim.c.chen@intel.com>
Cc: Chen Yu <yu.c.chen@intel.com>
Cc: Chris Hyser <chris.hyser@oracle.com>
Cc: Daniel Jordan <daniel.m.jordan@oracle.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Juri Lelli <juri.lelli@redhat.com>
Cc: K Prateek Nayak <kprateek.nayak@amd.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Madadi Vineeth Reddy <vineethr@linux.ibm.com>
Cc: Mel Gorman <mgorman <mgorman@suse.de>
Cc: Michal Koutný <mkoutny@suse.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Raghavendra K T <raghavendra.kt@amd.com>
Cc: Srikanth Aithal <sraithal@amd.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Venkat Rao Bagalkote <venkat88@linux.ibm.com>
Cc: Vincent Guittot <vincent.guittot@linaro.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/trace/events/sched.h |   33 +++++++++++++++++++++++++++++++++
 kernel/sched/fair.c          |    4 +++-
 2 files changed, 36 insertions(+), 1 deletion(-)

--- a/include/trace/events/sched.h~sched-numa-add-tracepoint-that-tracks-the-skipping-of-numa-balancing-due-to-cpuset-memory-pinning
+++ a/include/trace/events/sched.h
@@ -745,6 +745,39 @@ TRACE_EVENT(sched_skip_vma_numa,
 		  __entry->vm_end,
 		  __print_symbolic(__entry->reason, NUMAB_SKIP_REASON))
 );
+
+TRACE_EVENT(sched_skip_cpuset_numa,
+
+	TP_PROTO(struct task_struct *tsk, nodemask_t *mem_allowed_ptr),
+
+	TP_ARGS(tsk, mem_allowed_ptr),
+
+	TP_STRUCT__entry(
+		__array( char,		comm,		TASK_COMM_LEN		)
+		__field( pid_t,		pid					)
+		__field( pid_t,		tgid					)
+		__field( pid_t,		ngid					)
+		__array( unsigned long, mem_allowed, BITS_TO_LONGS(MAX_NUMNODES))
+	),
+
+	TP_fast_assign(
+		memcpy(__entry->comm, tsk->comm, TASK_COMM_LEN);
+		__entry->pid		 = task_pid_nr(tsk);
+		__entry->tgid		 = task_tgid_nr(tsk);
+		__entry->ngid		 = task_numa_group_id(tsk);
+		BUILD_BUG_ON(sizeof(nodemask_t) != \
+			     BITS_TO_LONGS(MAX_NUMNODES) * sizeof(long));
+		memcpy(__entry->mem_allowed, mem_allowed_ptr->bits,
+		       sizeof(__entry->mem_allowed));
+	),
+
+	TP_printk("comm=%s pid=%d tgid=%d ngid=%d mem_nodes_allowed=%*pbl",
+		  __entry->comm,
+		  __entry->pid,
+		  __entry->tgid,
+		  __entry->ngid,
+		  MAX_NUMNODES, __entry->mem_allowed)
+);
 #endif /* CONFIG_NUMA_BALANCING */
 
 /*
--- a/kernel/sched/fair.c~sched-numa-add-tracepoint-that-tracks-the-skipping-of-numa-balancing-due-to-cpuset-memory-pinning
+++ a/kernel/sched/fair.c
@@ -3333,8 +3333,10 @@ static void task_numa_work(struct callba
 	 * Memory is pinned to only one NUMA node via cpuset.mems, naturally
 	 * no page can be migrated.
 	 */
-	if (cpusets_enabled() && nodes_weight(cpuset_current_mems_allowed) == 1)
+	if (cpusets_enabled() && nodes_weight(cpuset_current_mems_allowed) == 1) {
+		trace_sched_skip_cpuset_numa(current, &cpuset_current_mems_allowed);
 		return;
+	}
 
 	if (!mm->numa_next_scan) {
 		mm->numa_next_scan = now +
_

Patches currently in -mm which might be from libo.chen@oracle.com are

sched-numa-skip-vma-scanning-on-memory-pinned-to-one-numa-node-via-cpusetmems.patch
sched-numa-add-tracepoint-that-tracks-the-skipping-of-numa-balancing-due-to-cpuset-memory-pinning.patch

