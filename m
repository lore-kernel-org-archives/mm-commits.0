Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08F371EF0AA
	for <mm-commits@vger.kernel.org>; Tue, 13 May 2025 06:54:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747119296; cv=none; b=oCcDriwgnFbXT0iJ3cMspGFTp5K920A2H+/HIXwHst2kbtiUWg5k7dGB77IB5kGmeflFeLrsn5nHYKG6alxx+YK5dhiFC0epq6TAPB2W3do+wKHGt9IEPBRuWcPApCOn1obvChcesg+DuM2+7sHDUKl0OR2HapZkEYMR6PfeNzI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747119296; c=relaxed/simple;
	bh=MwPZVzYCz/bDxcPGz67ujrE7SJn81qYAb4ZdYWrDhNg=;
	h=Date:To:From:Subject:Message-Id; b=d18hRVZ+qKtCI45trDEQ69U1xc4dSQHUoTp6N3zgM9dkdnzeU4YEA9oTQxh/AqGz3GDAILfqBmh70J6CKPYdkAjaalbneXbfiVZ87aftAK0seDiHSj42Q7cSYH87J63HkbKyMRIXXUn8QbiyRt7TFiVbGp05hiIB6evZzabBK94=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=X2ZZRL2L; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="X2ZZRL2L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F9DFC4CEE4;
	Tue, 13 May 2025 06:54:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747119295;
	bh=MwPZVzYCz/bDxcPGz67ujrE7SJn81qYAb4ZdYWrDhNg=;
	h=Date:To:From:Subject:From;
	b=X2ZZRL2LHUU1G1SQiHITPs5zsdl+/uYP8ZxSqlvAyQ7TN0NWqLQQXv2AJhh9ueuwh
	 XnIGwOaNq7FA/mKF9ndbY42Ji/RYK3aBWpyRFtp+8pN/1Lx8DGuL1R8OYDs7fRf4G1
	 UzptjdRlrSlRq8xV3luxfUd1NHBiT0GbrB75bNtA=
Date: Mon, 12 May 2025 23:54:54 -0700
To: mm-commits@vger.kernel.org,yu.c.chen@intel.com,vineethr@linux.ibm.com,vincent.guittot@linaro.org,venkat88@linux.ibm.com,tj@kernel.org,tim.c.chen@intel.com,sraithal@amd.com,rostedt@goodmis.org,raghavendra.kt@amd.com,peterz@infradead.org,mkoutny@suse.com,mingo@redhat.com,mgorman@suse.de,lorenzo.stoakes@oracle.com,kprateek.nayak@amd.com,juri.lelli@redhat.com,daniel.m.jordan@oracle.com,chris.hyser@oracle.com,libo.chen@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] sched-numa-add-tracepoint-that-tracks-the-skipping-of-numa-balancing-due-to-cpuset-memory-pinning.patch removed from -mm tree
Message-Id: <20250513065455.6F9DFC4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: sched/numa: add tracepoint that tracks the skipping of numa balancing due to cpuset memory pinning
has been removed from the -mm tree.  Its filename was
     sched-numa-add-tracepoint-that-tracks-the-skipping-of-numa-balancing-due-to-cpuset-memory-pinning.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

sched-numa-fix-task-swap-by-skipping-kernel-threads.patch

