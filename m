Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E13222E7BDC
	for <mm-commits@vger.kernel.org>; Mon, 12 Jan 2026 19:55:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768247741; cv=none; b=BcGH+x9gMEji84ov6YLJ3iCEIjo3eiG17QOIijM2DubXNTtAh9yTM5kV4BlpiNTul9Gl+KvDLavIHSJ3VXqAx15SFsWKMCVrw8AWmOcu7nhpow8l6OEeKnBHhoBARVMPU72/oe2y+NFQxWnDUMpqQ3zP2Rx8cpvRhnpry58ZIXw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768247741; c=relaxed/simple;
	bh=CNIU/vDTMkffCOIuuOOXUt1ysDrS7z6tFMDgQ+3fyvM=;
	h=Date:To:From:Subject:Message-Id; b=qsL9/SrkbsiPHP8FVRiOGqBEq/F4UIjeEaonJ6EuRTFYmOUXUwj0XI9XAIqfvZ9l1+nXovPn0GhURABD8ApK+jMoOjlQBsebx39jkN/+JacTVCdMdV9JPUAg7njVUfRPKMRSIGlrPvAPDgk2iUVcqbJIXyOg7pq8PXLS0vPbghU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Gr/9WPEt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Gr/9WPEt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C1ACC16AAE;
	Mon, 12 Jan 2026 19:55:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768247738;
	bh=CNIU/vDTMkffCOIuuOOXUt1ysDrS7z6tFMDgQ+3fyvM=;
	h=Date:To:From:Subject:From;
	b=Gr/9WPEtjEBnlK37inCPj9+gb5Tw+PBH+8/ZpGmyRBgAjPH6gojEnDzpszGLxC4H8
	 g7LyFywa8/g3hA4x8j/EwiFw+ZbaM4Y9jQN2u06oeDvayI+MnOe315le3jG1c4XH9E
	 uWsH4bL4BpJWwBorvolknoMv5beupCOkJYVn13BM=
Date: Mon, 12 Jan 2026 11:55:37 -0800
To: mm-commits@vger.kernel.org,yuzhao@google.com,willy@infradead.org,viro@zeniv.linux.org.uk,vbabka@suse.cz,tj@kernel.org,tglx@linutronix.de,sweettea-kernel@dorminy.me,surenb@google.com,sj@kernel.org,shakeel.butt@linux.dev,rppt@kernel.org,rostedt@goodmis.org,roman.gushchin@linux.dev,rientjes@google.com,richard.weiyang@gmail.com,paulmck@kernel.org,mjguzik@gmail.com,mhocko@suse.com,mhiramat@kernel.org,lorenzo.stoakes@oracle.com,liumartin@google.com,linmiaohe@huawei.com,liam.howlett@oracle.com,hannes@cmpxchg.org,dennis@kernel.org,david@redhat.com,cl@linux.com,christian.koenig@amd.com,broonie@kernel.org,brauner@kernel.org,baolin.wang@linux.alibaba.com,aboorvad@linux.ibm.com,mathieu.desnoyers@efficios.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-implement-precise-oom-killer-task-selection.patch removed from -mm tree
Message-Id: <20260112195538.6C1ACC16AAE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: implement precise OOM killer task selection
has been removed from the -mm tree.  Its filename was
     mm-implement-precise-oom-killer-task-selection.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: mm: implement precise OOM killer task selection
Date: Wed, 24 Dec 2025 12:46:38 -0500

Use the hierarchical tree counter approximation to implement the OOM
killer task selection with a 2-pass algorithm.  The first pass selects the
process that has the highest badness points approximation, and the second
pass compares each process using the current max badness points
approximation.

The second pass uses an approximate comparison to eliminate all processes
which are below the current max badness points approximation accuracy
range.

Summing the per-CPU counters to calculate the precise badness of tasks is
only required for tasks with an approximate badness within the accuracy
range of the current max points value.

Limit to 16 the maximum number of badness sums allowed for an OOM killer
task selection before falling back to the approximated comparison.  This
ensures bounded execution time for scenarios where many tasks have badness
within the accuracy of the maximum badness approximation.

Tested with the following script:

  #!/bin/sh

  for a in $(seq 1 10); do (tail /dev/zero &); done
  sleep 5
  for a in $(seq 1 10); do (tail /dev/zero &); done
  sleep 2
  for a in $(seq 1 10); do (tail /dev/zero &); done
  echo "Waiting for tasks to finish"
  wait

Results: OOM kill order on a 128GB memory system
================================================

* systemd and sd-pam are chosen first due to their oom_score_ajd:100:

Out of memory: Killed process 3502 (systemd) total-vm:20096kB, anon-rss:0kB, file-rss:0kB, shmem-rss:0kB, UID:1000 pgtables:72kB oom_score_adj:100
Out of memory: Killed process 3503 ((sd-pam)) total-vm:21432kB, anon-rss:0kB, file-rss:0kB, shmem-rss:0kB, UID:1000 pgtables:76kB oom_score_adj:100

* The first batch of 10 processes are gradually killed, consecutively
  picking the one that uses the most memory. The fact that we are
  freeing memory from the previous processes increases the threshold
  at which the remaining processes of that group are killed. Processes
  from the second and third batches of 10 processes have time to start
  before we complete killing the first 10 processes:

Out of memory: Killed process 3703 (tail) total-vm:6591280kB, anon-rss:6578176kB, file-rss:0kB, shmem-rss:0kB, UID:1000 pgtables:12936kB oom_score_adj:0
Out of memory: Killed process 3705 (tail) total-vm:6731716kB, anon-rss:6709248kB, file-rss:0kB, shmem-rss:0kB, UID:1000 pgtables:13212kB oom_score_adj:0
Out of memory: Killed process 3707 (tail) total-vm:6977216kB, anon-rss:6946816kB, file-rss:0kB, shmem-rss:0kB, UID:1000 pgtables:13692kB oom_score_adj:0
Out of memory: Killed process 3699 (tail) total-vm:7205640kB, anon-rss:7184384kB, file-rss:0kB, shmem-rss:0kB, UID:1000 pgtables:14136kB oom_score_adj:0
Out of memory: Killed process 3713 (tail) total-vm:7463204kB, anon-rss:7438336kB, file-rss:0kB, shmem-rss:0kB, UID:1000 pgtables:14644kB oom_score_adj:0
Out of memory: Killed process 3701 (tail) total-vm:7739204kB, anon-rss:7716864kB, file-rss:0kB, shmem-rss:0kB, UID:1000 pgtables:15180kB oom_score_adj:0
Out of memory: Killed process 3709 (tail) total-vm:8050176kB, anon-rss:8028160kB, file-rss:0kB, shmem-rss:0kB, UID:1000 pgtables:15792kB oom_score_adj:0
Out of memory: Killed process 3711 (tail) total-vm:8362236kB, anon-rss:8339456kB, file-rss:0kB, shmem-rss:0kB, UID:1000 pgtables:16404kB oom_score_adj:0
Out of memory: Killed process 3715 (tail) total-vm:8649360kB, anon-rss:8634368kB, file-rss:0kB, shmem-rss:0kB, UID:1000 pgtables:16972kB oom_score_adj:0
Out of memory: Killed process 3697 (tail) total-vm:8951788kB, anon-rss:8929280kB, file-rss:0kB, shmem-rss:0kB, UID:1000 pgtables:17560kB oom_score_adj:0

* Even though there is a 2 seconds delay between the 2nd and 3rd batches
  those appear to execute in mixed order. Therefore, let's consider them
  as a single batch of 20 processes. We are hitting oom at a lower
  memory threshold because at this point the 20 remaining proceses are
  running rather than the previous 10. The process with highest memory
  usage is selected for oom, thus making room for the remaining
  processes so they can use more memory before they fill the available
  memory, thus explaining why the memory use for selected processes
  gradually increases, until all system memory is used by the last one:

Out of memory: Killed process 3731 (tail) total-vm:7089868kB, anon-rss:7077888kB, file-rss:0kB, shmem-rss:0kB, UID:1000 pgtables:13912kB oom_score_adj:0
Out of memory: Killed process 3721 (tail) total-vm:7417248kB, anon-rss:7405568kB, file-rss:0kB, shmem-rss:0kB, UID:1000 pgtables:14556kB oom_score_adj:0
Out of memory: Killed process 3729 (tail) total-vm:7795864kB, anon-rss:7766016kB, file-rss:0kB, shmem-rss:0kB, UID:1000 pgtables:15300kB oom_score_adj:0
Out of memory: Killed process 3723 (tail) total-vm:8259620kB, anon-rss:8224768kB, file-rss:0kB, shmem-rss:0kB, UID:1000 pgtables:16208kB oom_score_adj:0
Out of memory: Killed process 3737 (tail) total-vm:8695984kB, anon-rss:8667136kB, file-rss:0kB, shmem-rss:0kB, UID:1000 pgtables:17060kB oom_score_adj:0
Out of memory: Killed process 3735 (tail) total-vm:9295980kB, anon-rss:9265152kB, file-rss:0kB, shmem-rss:0kB, UID:1000 pgtables:18240kB oom_score_adj:0
Out of memory: Killed process 3727 (tail) total-vm:9907900kB, anon-rss:9895936kB, file-rss:0kB, shmem-rss:0kB, UID:1000 pgtables:19428kB oom_score_adj:0
Out of memory: Killed process 3719 (tail) total-vm:10631248kB, anon-rss:10600448kB, file-rss:0kB, shmem-rss:0kB, UID:1000 pgtables:20844kB oom_score_adj:0
Out of memory: Killed process 3733 (tail) total-vm:11341720kB, anon-rss:11321344kB, file-rss:0kB, shmem-rss:0kB, UID:1000 pgtables:22232kB oom_score_adj:0
Out of memory: Killed process 3725 (tail) total-vm:12348124kB, anon-rss:12320768kB, file-rss:0kB, shmem-rss:0kB, UID:1000 pgtables:24204kB oom_score_adj:0
Out of memory: Killed process 3759 (tail) total-vm:12978888kB, anon-rss:12967936kB, file-rss:0kB, shmem-rss:0kB, UID:1000 pgtables:25440kB oom_score_adj:0
Out of memory: Killed process 3751 (tail) total-vm:14386412kB, anon-rss:14352384kB, file-rss:0kB, shmem-rss:0kB, UID:1000 pgtables:28196kB oom_score_adj:0
Out of memory: Killed process 3741 (tail) total-vm:16153168kB, anon-rss:16130048kB, file-rss:0kB, shmem-rss:0kB, UID:1000 pgtables:31652kB oom_score_adj:0
Out of memory: Killed process 3753 (tail) total-vm:18414856kB, anon-rss:18391040kB, file-rss:0kB, shmem-rss:0kB, UID:1000 pgtables:36076kB oom_score_adj:0
Out of memory: Killed process 3745 (tail) total-vm:21389456kB, anon-rss:21356544kB, file-rss:0kB, shmem-rss:0kB, UID:1000 pgtables:41904kB oom_score_adj:0
Out of memory: Killed process 3747 (tail) total-vm:25659348kB, anon-rss:25632768kB, file-rss:0kB, shmem-rss:0kB, UID:1000 pgtables:50260kB oom_score_adj:0
Out of memory: Killed process 3755 (tail) total-vm:32030820kB, anon-rss:32006144kB, file-rss:0kB, shmem-rss:0kB, UID:1000 pgtables:62720kB oom_score_adj:0
Out of memory: Killed process 3743 (tail) total-vm:42648456kB, anon-rss:42614784kB, file-rss:0kB, shmem-rss:0kB, UID:1000 pgtables:83504kB oom_score_adj:0
Out of memory: Killed process 3757 (tail) total-vm:63971028kB, anon-rss:63938560kB, file-rss:0kB, shmem-rss:0kB, UID:1000 pgtables:125228kB oom_score_adj:0
Out of memory: Killed process 3749 (tail) total-vm:127799660kB, anon-rss:127778816kB, file-rss:0kB, shmem-rss:0kB, UID:1000 pgtables:250140kB oom_score_adj:0

Link: https://lkml.kernel.org/r/20251224174638.650551-4-mathieu.desnoyers@efficios.com
Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Aboorva Devarajan <aboorvad@linux.ibm.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Christan König <christian.koenig@amd.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Christoph Lameter <cl@linux.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Dennis Zhou <dennis@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: "Liam R . Howlett" <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Mark Brown <broonie@kernel.org>
Cc: Martin Liu <liumartin@google.com>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Mateusz Guzik <mjguzik@gmail.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: "Paul E. McKenney" <paulmck@kernel.org>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: SeongJae Park <sj@kernel.org>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Cc: Tejun Heo <tj@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Wei Yang <richard.weiyang@gmail.com>
Cc: Yu Zhao <yuzhao@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/base.c      |    2 -
 include/linux/mm.h  |   34 ++++++++++++++++---
 include/linux/oom.h |   12 ++++++-
 mm/oom_kill.c       |   72 +++++++++++++++++++++++++++++++++++-------
 4 files changed, 101 insertions(+), 19 deletions(-)

--- a/fs/proc/base.c~mm-implement-precise-oom-killer-task-selection
+++ a/fs/proc/base.c
@@ -589,7 +589,7 @@ static int proc_oom_score(struct seq_fil
 	unsigned long points = 0;
 	long badness;
 
-	badness = oom_badness(task, totalpages);
+	badness = oom_badness(task, totalpages, false, NULL, NULL);
 	/*
 	 * Special case OOM_SCORE_ADJ_MIN for all others scale the
 	 * badness value into [0, 2000] range which we have been
--- a/include/linux/mm.h~mm-implement-precise-oom-killer-task-selection
+++ a/include/linux/mm.h
@@ -2865,14 +2865,32 @@ static inline struct percpu_counter_tree
 /*
  * per-process(per-mm_struct) statistics.
  */
+static inline unsigned long __get_mm_counter(struct mm_struct *mm, int member, bool approximate,
+					     unsigned int *accuracy_under, unsigned int *accuracy_over)
+{
+	if (approximate) {
+		if (accuracy_under && accuracy_over) {
+			unsigned int under, over;
+
+			percpu_counter_tree_approximate_accuracy_range(&mm->rss_stat[member], &under, &over);
+			*accuracy_under += under;
+			*accuracy_over += over;
+		}
+		return percpu_counter_tree_approximate_sum_positive(&mm->rss_stat[member]);
+	} else {
+		return percpu_counter_tree_precise_sum_positive(&mm->rss_stat[member]);
+	}
+}
+
 static inline unsigned long get_mm_counter(struct mm_struct *mm, int member)
 {
-	return percpu_counter_tree_approximate_sum_positive(&mm->rss_stat[member]);
+	return __get_mm_counter(mm, member, true, NULL, NULL);
 }
 
+
 static inline unsigned long get_mm_counter_sum(struct mm_struct *mm, int member)
 {
-	return percpu_counter_tree_precise_sum_positive(&mm->rss_stat[member]);
+	return get_mm_counter(mm, member);
 }
 
 void mm_trace_rss_stat(struct mm_struct *mm, int member);
@@ -2913,11 +2931,17 @@ static inline int mm_counter(struct foli
 	return mm_counter_file(folio);
 }
 
+static inline unsigned long __get_mm_rss(struct mm_struct *mm, bool approximate,
+					 unsigned int *accuracy_under, unsigned int *accuracy_over)
+{
+	return __get_mm_counter(mm, MM_FILEPAGES, approximate, accuracy_under, accuracy_over) +
+		__get_mm_counter(mm, MM_ANONPAGES, approximate, accuracy_under, accuracy_over) +
+		__get_mm_counter(mm, MM_SHMEMPAGES, approximate, accuracy_under, accuracy_over);
+}
+
 static inline unsigned long get_mm_rss(struct mm_struct *mm)
 {
-	return get_mm_counter(mm, MM_FILEPAGES) +
-		get_mm_counter(mm, MM_ANONPAGES) +
-		get_mm_counter(mm, MM_SHMEMPAGES);
+	return __get_mm_rss(mm, true, NULL, NULL);
 }
 
 static inline unsigned long get_mm_hiwater_rss(struct mm_struct *mm)
--- a/include/linux/oom.h~mm-implement-precise-oom-killer-task-selection
+++ a/include/linux/oom.h
@@ -48,6 +48,13 @@ struct oom_control {
 	unsigned long totalpages;
 	struct task_struct *chosen;
 	long chosen_points;
+	bool approximate;
+	/*
+	 * Number of precise badness points sums performed by this task
+	 * selection.
+	 */
+	int nr_precise;
+	unsigned long accuracy_under;
 
 	/* Used to print the constraint info. */
 	enum oom_constraint constraint;
@@ -97,7 +104,10 @@ static inline vm_fault_t check_stable_ad
 }
 
 long oom_badness(struct task_struct *p,
-		unsigned long totalpages);
+		unsigned long totalpages,
+		bool approximate,
+		unsigned int *accuracy_under,
+		unsigned int *accuracy_over);
 
 extern bool out_of_memory(struct oom_control *oc);
 
--- a/mm/oom_kill.c~mm-implement-precise-oom-killer-task-selection
+++ a/mm/oom_kill.c
@@ -53,6 +53,14 @@
 #define CREATE_TRACE_POINTS
 #include <trace/events/oom.h>
 
+/*
+ * Maximum number of badness sums allowed before using an approximated
+ * comparison. This ensures bounded execution time for scenarios where
+ * many tasks have badness within the accuracy of the maximum badness
+ * approximation.
+ */
+static int max_precise_badness_sums = 16;
+
 static int sysctl_panic_on_oom;
 static int sysctl_oom_kill_allocating_task;
 static int sysctl_oom_dump_tasks = 1;
@@ -194,12 +202,16 @@ static bool should_dump_unreclaim_slab(v
  * oom_badness - heuristic function to determine which candidate task to kill
  * @p: task struct of which task we should calculate
  * @totalpages: total present RAM allowed for page allocation
+ * @approximate: whether the value can be approximated
+ * @accuracy_under: accuracy of the badness value approximation (under value)
+ * @accuracy_over: accuracy of the badness value approximation (over value)
  *
  * The heuristic for determining which task to kill is made to be as simple and
  * predictable as possible.  The goal is to return the highest value for the
  * task consuming the most memory to avoid subsequent oom failures.
  */
-long oom_badness(struct task_struct *p, unsigned long totalpages)
+long oom_badness(struct task_struct *p, unsigned long totalpages, bool approximate,
+		 unsigned int *accuracy_under, unsigned int *accuracy_over)
 {
 	long points;
 	long adj;
@@ -228,7 +240,8 @@ long oom_badness(struct task_struct *p,
 	 * The baseline for the badness score is the proportion of RAM that each
 	 * task's rss, pagetable and swap space use.
 	 */
-	points = get_mm_rss(p->mm) + get_mm_counter(p->mm, MM_SWAPENTS) +
+	points = __get_mm_rss(p->mm, approximate, accuracy_under, accuracy_over) +
+		__get_mm_counter(p->mm, MM_SWAPENTS, approximate, accuracy_under, accuracy_over) +
 		mm_pgtables_bytes(p->mm) / PAGE_SIZE;
 	task_unlock(p);
 
@@ -309,6 +322,7 @@ static enum oom_constraint constrained_a
 static int oom_evaluate_task(struct task_struct *task, void *arg)
 {
 	struct oom_control *oc = arg;
+	unsigned int accuracy_under = 0, accuracy_over = 0;
 	long points;
 
 	if (oom_unkillable_task(task))
@@ -339,9 +353,28 @@ static int oom_evaluate_task(struct task
 		goto select;
 	}
 
-	points = oom_badness(task, oc->totalpages);
-	if (points == LONG_MIN || points < oc->chosen_points)
-		goto next;
+	points = oom_badness(task, oc->totalpages, true, &accuracy_under, &accuracy_over);
+	if (oc->approximate) {
+		if (points == LONG_MIN || points < oc->chosen_points)
+			goto next;
+	} else {
+		/*
+		 * Eliminate processes which are below the chosen
+		 * points accuracy range with an approximation.
+		 */
+		if (points == LONG_MIN || (long)(points + accuracy_over + oc->accuracy_under - oc->chosen_points) < 0)
+			goto next;
+
+		if (oc->nr_precise < max_precise_badness_sums) {
+			accuracy_under = 0;
+			accuracy_over = 0;
+			oc->nr_precise++;
+			/* Precise evaluation. */
+			points = oom_badness(task, oc->totalpages, false, NULL, NULL);
+			if (points == LONG_MIN || (long)(points + oc->accuracy_under - oc->chosen_points) < 0)
+				goto next;
+		}
+	}
 
 select:
 	if (oc->chosen)
@@ -349,6 +382,7 @@ select:
 	get_task_struct(task);
 	oc->chosen = task;
 	oc->chosen_points = points;
+	oc->accuracy_under = accuracy_under;
 next:
 	return 0;
 abort:
@@ -358,14 +392,8 @@ abort:
 	return 1;
 }
 
-/*
- * Simple selection loop. We choose the process with the highest number of
- * 'points'. In case scan was aborted, oc->chosen is set to -1.
- */
-static void select_bad_process(struct oom_control *oc)
+static void select_bad_process_iter(struct oom_control *oc)
 {
-	oc->chosen_points = LONG_MIN;
-
 	if (is_memcg_oom(oc))
 		mem_cgroup_scan_tasks(oc->memcg, oom_evaluate_task, oc);
 	else {
@@ -379,6 +407,26 @@ static void select_bad_process(struct oo
 	}
 }
 
+/*
+ * Simple selection loop. We choose the process with the highest number of
+ * 'points'. In case scan was aborted, oc->chosen is set to -1.
+ */
+static void select_bad_process(struct oom_control *oc)
+{
+	oc->chosen_points = LONG_MIN;
+	oc->accuracy_under = 0;
+	oc->nr_precise = 0;
+
+	/* Approximate scan. */
+	oc->approximate = true;
+	select_bad_process_iter(oc);
+	if (oc->chosen == (void *)-1UL)
+		return;
+	/* Precise scan. */
+	oc->approximate = false;
+	select_bad_process_iter(oc);
+}
+
 static int dump_task(struct task_struct *p, void *arg)
 {
 	struct oom_control *oc = arg;
_

Patches currently in -mm which might be from mathieu.desnoyers@efficios.com are

mm-add-missing-static-initializer-for-init_mm-mm_cidlock.patch
mm-rename-cpu_bitmap-field-to-flexible_array.patch
mm-take-into-account-mm_cid-size-for-mm_struct-static-definitions.patch

