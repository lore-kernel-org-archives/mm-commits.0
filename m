Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07CA9748F
	for <mm-commits@vger.kernel.org>; Fri, 25 Apr 2025 00:45:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745541902; cv=none; b=S7BhKhMZtENxetSuQPLLfqpxI706o/eo5r0z/dlL47L7qu+mzkm7qMqyBmTceUZny5HPgwfrJey6IA2nIQm1T7B+rc+GZyTK77CJC8nPMXTBwaeXGHqmsoiflIh4KI7L9fBYPM5Ff6yvqJlrcayW6CMQxQjPquMZO1d1mh2FH1c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745541902; c=relaxed/simple;
	bh=GdyGAFM2HbCrXZ9uwtL0XVeG4WCsofV6OxGF1dvyUYs=;
	h=Date:To:From:Subject:Message-Id; b=URHKVFki9n3tvrjw1vc7Mwptff43XHlWxq1Aa9KklOPp/HUVPq1R575vRBowRx7RqQ2oTrR6XrTONrhvy4Nmg7N2ZWUBFK56giYcby408VaGmyrqN7ZcEcrWzxHhC/hAUzto/wceA9OFxqCOKlj5fPE4MHRs4keYHq+Uu5B/n/4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=O1jtqfn4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="O1jtqfn4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D763C4CEE3;
	Fri, 25 Apr 2025 00:45:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1745541900;
	bh=GdyGAFM2HbCrXZ9uwtL0XVeG4WCsofV6OxGF1dvyUYs=;
	h=Date:To:From:Subject:From;
	b=O1jtqfn4OXmaZsseSfrdOD/SZ44BSe6sruWTY01UYmnYGNCdSqjuXlhKCMUGKcgZd
	 oR9F2qDfrxxD8DM6xEUUGn3+XngDozD0yIC9p85a0OQva1/Jw5vIuhbY+CTcYdtx5N
	 bLZAxJ/X2LwGWTw/F+IaVve1+D4JuGKvfkG7Ei2Y=
Date: Thu, 24 Apr 2025 17:44:59 -0700
To: mm-commits@vger.kernel.org,yu.c.chen@intel.com,vineethr@linux.ibm.com,vincent.guittot@linaro.org,venkat88@linux.ibm.com,tj@kernel.org,tim.c.chen@intel.com,sraithal@amd.com,rostedt@goodmis.org,raghavendra.kt@amd.com,peterz@infradead.org,mkoutny@suse.com,mingo@redhat.com,mgorman@suse.de,lorenzo.stoakes@oracle.com,kprateek.nayak@amd.com,juri.lelli@redhat.com,daniel.m.jordan@oracle.com,chris.hyser@oracle.com,libo.chen@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + sched-numa-skip-vma-scanning-on-memory-pinned-to-one-numa-node-via-cpusetmems.patch added to mm-new branch
Message-Id: <20250425004500.1D763C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: sched/numa: skip VMA scanning on memory pinned to one NUMA node via cpuset.mems
has been added to the -mm mm-new branch.  Its filename is
     sched-numa-skip-vma-scanning-on-memory-pinned-to-one-numa-node-via-cpusetmems.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/sched-numa-skip-vma-scanning-on-memory-pinned-to-one-numa-node-via-cpusetmems.patch

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
Subject: sched/numa: skip VMA scanning on memory pinned to one NUMA node via cpuset.mems
Date: Wed, 23 Apr 2025 19:45:22 -0700

Patch series "sched/numa: Skip VMA scanning on memory pinned to one NUMA
node via cpuset.mems", v5.


This patch (of 2):

When the memory of the current task is pinned to one NUMA node by cgroup,
there is no point in continuing the rest of VMA scanning and hinting page
faults as they will just be overhead.  With this change, there will be no
more unnecessary PTE updates or page faults in this scenario.

We have seen up to a 6x improvement on a typical java workload running on
VMs with memory and CPU pinned to one NUMA node via cpuset in a two-socket
AARCH64 system.  With the same pinning, on a 18-cores-per-socket Intel
platform, we have seen 20% improvment in a microbench that creates a
30-vCPU selftest KVM guest with 4GB memory, where each vCPU reads 4KB
pages in a fixed number of loops.

Link: https://lkml.kernel.org/r/20250424024523.2298272-1-libo.chen@oracle.com
Link: https://lkml.kernel.org/r/20250424024523.2298272-2-libo.chen@oracle.com
Signed-off-by: Libo Chen <libo.chen@oracle.com>
Tested-by: Chen Yu <yu.c.chen@intel.com>
Tested-by: Srikanth Aithal <sraithal@amd.com>
Tested-by: Venkat Rao Bagalkote <venkat88@linux.ibm.com>
Cc: "Chen, Tim C" <tim.c.chen@intel.com>
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

 kernel/sched/fair.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/kernel/sched/fair.c~sched-numa-skip-vma-scanning-on-memory-pinned-to-one-numa-node-via-cpusetmems
+++ a/kernel/sched/fair.c
@@ -3329,6 +3329,13 @@ static void task_numa_work(struct callba
 	if (p->flags & PF_EXITING)
 		return;
 
+	/*
+	 * Memory is pinned to only one NUMA node via cpuset.mems, naturally
+	 * no page can be migrated.
+	 */
+	if (cpusets_enabled() && nodes_weight(cpuset_current_mems_allowed) == 1)
+		return;
+
 	if (!mm->numa_next_scan) {
 		mm->numa_next_scan = now +
 			msecs_to_jiffies(sysctl_numa_balancing_scan_delay);
_

Patches currently in -mm which might be from libo.chen@oracle.com are

sched-numa-skip-vma-scanning-on-memory-pinned-to-one-numa-node-via-cpusetmems.patch
sched-numa-add-tracepoint-that-tracks-the-skipping-of-numa-balancing-due-to-cpuset-memory-pinning.patch

