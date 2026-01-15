Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 097BB17DE36
	for <mm-commits@vger.kernel.org>; Thu, 15 Jan 2026 22:00:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768514441; cv=none; b=XU7GZ2y4lnXrb2aVd+DwEeCQ444z5SQPRwr5+MvSJLiL868H5AdPjs9pr7yqyp4kkUYb9slEcdzLR+krpZakT5ehNScagYcAUTkCgFvb/0g0ved6Hl3p+5a4U6snV2Klz2GpnyngJEcc5fQ6F46xS1UR7QizCW7maCnL/mIAPWA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768514441; c=relaxed/simple;
	bh=veZQaKSniFXtUS70BQ7/i0Ou3Yj24oar9NS6XsjY+MA=;
	h=Date:To:From:Subject:Message-Id; b=nVJl31d5PwLFw0VSczB2WH35OZM+pAg8LoiuRo5fpaufuDcJOIZCOlqYjGP7cXBo4Se/dGr2Og8f8TIlRmJv7p194GD/SPydIy7eaSyuCSZCkvqYFd/2pgUTipF4YzQ4pzovxkq/4btCqpyidYGQ6T0I4Kg7eG3qS4IE1OUXT1Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=LndVZlpf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="LndVZlpf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 768EBC116D0;
	Thu, 15 Jan 2026 22:00:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768514440;
	bh=veZQaKSniFXtUS70BQ7/i0Ou3Yj24oar9NS6XsjY+MA=;
	h=Date:To:From:Subject:From;
	b=LndVZlpfL5AP5l7fpikjj5JEi7jza3Th9IJPPifa7bd7tilnRCtLGaXhPN9y6iuNN
	 bDM9LpstiIbMsZP9VRQMJpXUgDTGVOYZkI8qmE6sFERlIBqRv3BPm+evT3bF+KLBQl
	 qVxOHep4vLQnJs7di0+4qvkozKpkRkrHStyVuQuI=
Date: Thu, 15 Jan 2026 14:00:39 -0800
To: mm-commits@vger.kernel.org,oleg@redhat.com,mingo@kernel.org,gregkh@linuxfoundation.org,david@kernel.org,brauner@kernel.org,adobriyan@gmail.com,atomlin@atomlin.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [nacked] fs-proc-expose-mm_cpumask-in-proc-status.patch removed from -mm tree
Message-Id: <20260115220040.768EBC116D0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: fs/proc: expose mm_cpumask in /proc/[pid]/status
has been removed from the -mm tree.  Its filename was
     fs-proc-expose-mm_cpumask-in-proc-status.patch

This patch was dropped because it was nacked

------------------------------------------------------
From: Aaron Tomlin <atomlin@atomlin.com>
Subject: fs/proc: expose mm_cpumask in /proc/[pid]/status
Date: Fri, 26 Dec 2025 16:14:07 -0500

This patch introduces two new fields to /proc/[pid]/status to display the
set of CPUs, representing the CPU affinity of the process's active memory
context, in both mask and list format: "Cpus_active_mm" and
"Cpus_active_mm_list".  The mm_cpumask is primarily used for TLB and cache
synchronisation.

Exposing this information allows userspace to easily describe the
relationship between CPUs where a memory descriptor is "active" and the
CPUs where the thread is allowed to execute.  The primary intent is to
provide visibility into the "memory footprint" across CPUs, which is
invaluable for debugging performance issues related to IPI storms and TLB
shootdowns in large-scale NUMA systems.  The CPU-affinity sets the
boundary; the mm_cpumask records the arrival; they complement each other.

Frequent mm_cpumask changes may indicate instability in placement policies
or excessive task migration overhead.

Link: https://lkml.kernel.org/r/20251226211407.2252573-2-atomlin@atomlin.com
Signed-off-by: Aaron Tomlin <atomlin@atomlin.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: David Hildenbrand (Red Hat) <david@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/proc.rst |    3 +++
 fs/proc/array.c                    |   22 +++++++++++++++++++++-
 2 files changed, 24 insertions(+), 1 deletion(-)

--- a/Documentation/filesystems/proc.rst~fs-proc-expose-mm_cpumask-in-proc-status
+++ a/Documentation/filesystems/proc.rst
@@ -291,6 +291,9 @@ It's slow but very precise.
  SpeculationIndirectBranch   indirect branch speculation mode
  Cpus_allowed                mask of CPUs on which this process may run
  Cpus_allowed_list           Same as previous, but in "list format"
+ Cpus_active_mm              mask of CPUs on which this process has an active
+                             memory context
+ Cpus_active_mm_list         Same as previous, but in "list format"
  Mems_allowed                mask of memory nodes allowed to this process
  Mems_allowed_list           Same as previous, but in "list format"
  voluntary_ctxt_switches     number of voluntary context switches
--- a/fs/proc/array.c~fs-proc-expose-mm_cpumask-in-proc-status
+++ a/fs/proc/array.c
@@ -409,6 +409,23 @@ static void task_cpus_allowed(struct seq
 		   cpumask_pr_args(&task->cpus_mask));
 }
 
+/**
+ * task_cpus_active_mm - Show the mm_cpumask for a process
+ * @m: The seq_file structure for the /proc/PID/status output
+ * @mm: The memory descriptor of the process
+ *
+ * Prints the set of CPUs, representing the CPU affinity of the process's
+ * active memory context, in both mask and list format. This mask is
+ * primarily used for TLB and cache synchronisation.
+ */
+static void task_cpus_active_mm(struct seq_file *m, struct mm_struct *mm)
+{
+	seq_printf(m, "Cpus_active_mm:\t%*pb\n",
+		   cpumask_pr_args(mm_cpumask(mm)));
+	seq_printf(m, "Cpus_active_mm_list:\t%*pbl\n",
+		   cpumask_pr_args(mm_cpumask(mm)));
+}
+
 static inline void task_core_dumping(struct seq_file *m, struct task_struct *task)
 {
 	seq_put_decimal_ull(m, "CoreDumping:\t", !!task->signal->core_state);
@@ -450,12 +467,15 @@ int proc_pid_status(struct seq_file *m,
 		task_core_dumping(m, task);
 		task_thp_status(m, mm);
 		task_untag_mask(m, mm);
-		mmput(mm);
 	}
 	task_sig(m, task);
 	task_cap(m, task);
 	task_seccomp(m, task);
 	task_cpus_allowed(m, task);
+	if (mm) {
+		task_cpus_active_mm(m, mm);
+		mmput(mm);
+	}
 	cpuset_task_status_allowed(m, task);
 	task_context_switch_counts(m, task);
 	arch_proc_pid_thread_features(m, task);
_

Patches currently in -mm which might be from atomlin@atomlin.com are


