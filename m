Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB09926ED40
	for <mm-commits@vger.kernel.org>; Sun, 28 Dec 2025 19:24:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766949843; cv=none; b=Jz03R+5OjX3n5ZmImIoM/sGUcKDjJ1DOQdGgrlIH3lJiCxqo2RCi359lNIhY6iSGzfAKxtqq/gqJDwUWjaxjuySXK0+ZrfjJsApK9Q8uXD1MpfjIXSA+vvoTRb33u2ob37m10topqhxhSGU96C5eHHHAfCFn5NIuxg7f5xA7NHk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766949843; c=relaxed/simple;
	bh=54WjhaWqELFJy/XIiCuYfeWKUrxYlJ3rAxjMH8gYMAg=;
	h=Date:To:From:Subject:Message-Id; b=sdzx85pL5NyizK4afBAKDG99dnbv99+L73MrPW+Wp0pngAIRburVp4EgAt6gEz9Iq9Q0DkB56FEM1j9fHFTP4W5IEa2yQnlyKRPin1tNnkXb0l60nSdAcL/7aBmWUIyblhvgkYKe8vPOTTssAmCXyjx6PhcQIZ5lL65L0eTmfmA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=v5asvpAd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="v5asvpAd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10773C4CEFB;
	Sun, 28 Dec 2025 19:24:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1766949843;
	bh=54WjhaWqELFJy/XIiCuYfeWKUrxYlJ3rAxjMH8gYMAg=;
	h=Date:To:From:Subject:From;
	b=v5asvpAdBFtjNhW8QhcETYSfozC9fhOGhyRVUNGsGiH7fMF0ebs8GkGum0J+A9c9c
	 q3oTydSH2ZUlhyN+hASV7olqlTUklzSPZyuwfQeo+6KTDwKU62Wf825sKKWO5sa1NI
	 4DSQdyRyDCKht4DpezFURtRtKuKJ9bTylfQaJIx4=
Date: Sun, 28 Dec 2025 11:24:02 -0800
To: mm-commits@vger.kernel.org,oleg@redhat.com,mingo@kernel.org,gregkh@linuxfoundation.org,david@kernel.org,brauner@kernel.org,adobriyan@gmail.com,atomlin@atomlin.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + fs-proc-expose-mm_cpumask-in-proc-status.patch added to mm-new branch
Message-Id: <20251228192403.10773C4CEFB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: fs/proc: expose mm_cpumask in /proc/[pid]/status
has been added to the -mm mm-new branch.  Its filename is
     fs-proc-expose-mm_cpumask-in-proc-status.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/fs-proc-expose-mm_cpumask-in-proc-status.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

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

fs-proc-expose-mm_cpumask-in-proc-status.patch

