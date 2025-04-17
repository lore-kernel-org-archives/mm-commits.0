Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54E6D207A3D
	for <mm-commits@vger.kernel.org>; Thu, 17 Apr 2025 20:12:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744920774; cv=none; b=SW7ZOvFEb0sbjodYc2yYM2coHpLgnBCe/vNL2u0qVG/eFxoOPiSElRzSbGq92LTs9LQLQgXCoyNSrPRxa/zETpHfgUBKJ7x/F4VWno11bybJHG/Qp6FDNq79oJkUp1qKCtikoYLbg1UTqTT5Hwemw2Dd1QqQNp7fGvGFPadTFgM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744920774; c=relaxed/simple;
	bh=Zu2x3gCNIO4x6OWCC00HE1vC0zBATQ0wunAJHd0q3qI=;
	h=Date:To:From:Subject:Message-Id; b=BuH/rv1eFQJG015oAZ4Ojiqtp349bNpwOJZg2cFrizeMOayP0TccHgNsuCF4IZKE8tAA5vM3mly9SrTDD35xh6FkZy2oqAXdb4JjxsI4i4vQwni0EqV5NDio5KdAPLSwu9ijDSRGW1wcFRkNYN2dfjLZJpIjUEcMz8H+ctUuO9o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=JCQQeu21; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="JCQQeu21"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE0AFC4CEEA;
	Thu, 17 Apr 2025 20:12:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1744920773;
	bh=Zu2x3gCNIO4x6OWCC00HE1vC0zBATQ0wunAJHd0q3qI=;
	h=Date:To:From:Subject:From;
	b=JCQQeu21mkWe0W952uoIHXdQaUPkIC8St15eO5hiyjKuPDFVUayAtHMDL/DFyp3dn
	 IBixmGWZ5RgsbuyuyeYZDdHFU74U0GLCs8iStkTR8ixzjiOMRPnScRr+Bursx65Lzq
	 biqlvYlWJ/CSF/a/A4wY7JaFfeY4ZA/YehHaIKmU=
Date: Thu, 17 Apr 2025 13:12:53 -0700
To: mm-commits@vger.kernel.org,yu.c.chen@intel.com,vineethr@linux.ibm.com,vincent.guittot@linaro.org,tj@kernel.org,tim.c.chen@intel.com,rostedt@goodmis.org,raghavendra.kt@amd.com,peterz@infradead.org,mkoutny@suse.com,mingo@redhat.com,mgorman@suse.de,lorenzo.stoakes@oracle.com,kprateek.nayak@amd.com,juri.lelli@redhat.com,daniel.m.jordan@oracle.com,chris.hyser@oracle.com,libo.chen@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + sched-numa-add-tracepoint-that-tracks-the-skipping-of-numa-balancing-due-to-cpuset-memory-pinning.patch added to mm-new branch
Message-Id: <20250417201253.AE0AFC4CEEA@smtp.kernel.org>
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
Date: Thu, 17 Apr 2025 12:15:43 -0700

Unlike sched_skip_vma_numa tracepoint which tracks skipped VMAs, this
tracks the task subjected to cpuset.mems pinning and prints out its
allowed memory node mask.

Link: https://lkml.kernel.org/r/20250417191543.1781862-3-libo.chen@oracle.com
Signed-off-by: Libo Chen <libo.chen@oracle.com>
Cc: "Chen, Tim C" <tim.c.chen@intel.com>
Cc: Chen, Yu C <yu.c.chen@intel.com>
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
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Vincent Guittot <vincent.guittot@linaro.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/trace/events/sched.h |   30 ++++++++++++++++++++++++++++++
 kernel/sched/fair.c          |    4 +++-
 2 files changed, 33 insertions(+), 1 deletion(-)

--- a/include/trace/events/sched.h~sched-numa-add-tracepoint-that-tracks-the-skipping-of-numa-balancing-due-to-cpuset-memory-pinning
+++ a/include/trace/events/sched.h
@@ -745,6 +745,36 @@ TRACE_EVENT(sched_skip_vma_numa,
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
+		__array( char,		comm,		TASK_COMM_LEN	)
+		__field( pid_t,		pid				)
+		__field( pid_t,		tgid				)
+		__field( pid_t,		ngid				)
+		__field( nodemask_t *,	mem_allowed_ptr			)
+	),
+
+	TP_fast_assign(
+		memcpy(__entry->comm, tsk->comm, TASK_COMM_LEN);
+		__entry->pid		 = task_pid_nr(tsk);
+		__entry->tgid		 = task_tgid_nr(tsk);
+		__entry->ngid		 = task_numa_group_id(tsk);
+		__entry->mem_allowed_ptr = mem_allowed_ptr;
+	),
+
+	TP_printk("comm=%s pid=%d tgid=%d ngid=%d mem_nodes_allowed=%*pbl",
+		  __entry->comm,
+		  __entry->pid,
+		  __entry->tgid,
+		  __entry->ngid,
+		  nodemask_pr_args(__entry->mem_allowed_ptr))
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

