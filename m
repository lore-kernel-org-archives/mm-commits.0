Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 081D71EF0B0
	for <mm-commits@vger.kernel.org>; Tue, 13 May 2025 06:54:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747119294; cv=none; b=ezETJ9erwy9JbsWb8mTy74Fg2enlRAbAQf7xH3NmB2ECl9oL3whvkCC8WBvZmzL/PL1307FLSOYLRJllD5yM3uT80j9h+N35iZ3tdsHe3AZQb0G3YpfWAn7CCm/jhdM0xNsgAJ7HdCdH5+kX9QAEw5OfXYZXs8BvG26ocPfxHtQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747119294; c=relaxed/simple;
	bh=+J0JyyPSlCQ62a16Y5Tk+9DqKd4TJmO3ZDL8z1taYLg=;
	h=Date:To:From:Subject:Message-Id; b=qwEyzf40CyM4HRkJpkblp8ZuQ+GmNb9oY+ECJBL0G9YzcO7cYhNzYgT8TBMv01mRUxUYOksWnf4vdz05tNvTKhxwQ745taHVod1gfzVwcf4nNGoUB0mxMvsOUYcNF2qWTDp1ZXux62/tKuPFgzeqvU+3twFjkPapI3NmY2/RFFk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=0i23Vx4T; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="0i23Vx4T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1FF8C4CEE4;
	Tue, 13 May 2025 06:54:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747119293;
	bh=+J0JyyPSlCQ62a16Y5Tk+9DqKd4TJmO3ZDL8z1taYLg=;
	h=Date:To:From:Subject:From;
	b=0i23Vx4T0VgE6FU7XiwDFaaYePDPZnlK4FbQJG18IWL6nplPCK8fTzE/CNYAm2Mxo
	 ZjGTtWnX3enJrhauh5mqWAuFPkI8oYGmn3EUBPvCUC9C4waHmN8lLQwhT3DOqrr8m1
	 mz3+lboKf1mWYjln7cnmugleEHNv1v30JWCvWiV0=
Date: Mon, 12 May 2025 23:54:53 -0700
To: mm-commits@vger.kernel.org,yu.c.chen@intel.com,vineethr@linux.ibm.com,vincent.guittot@linaro.org,venkat88@linux.ibm.com,tj@kernel.org,tim.c.chen@intel.com,sraithal@amd.com,rostedt@goodmis.org,raghavendra.kt@amd.com,peterz@infradead.org,mkoutny@suse.com,mingo@redhat.com,mgorman@suse.de,lorenzo.stoakes@oracle.com,kprateek.nayak@amd.com,juri.lelli@redhat.com,daniel.m.jordan@oracle.com,chris.hyser@oracle.com,libo.chen@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] sched-numa-skip-vma-scanning-on-memory-pinned-to-one-numa-node-via-cpusetmems.patch removed from -mm tree
Message-Id: <20250513065453.D1FF8C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: sched/numa: skip VMA scanning on memory pinned to one NUMA node via cpuset.mems
has been removed from the -mm tree.  Its filename was
     sched-numa-skip-vma-scanning-on-memory-pinned-to-one-numa-node-via-cpusetmems.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

sched-numa-fix-task-swap-by-skipping-kernel-threads.patch

