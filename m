Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAFB8274B37
	for <mm-commits@vger.kernel.org>; Tue, 13 Jan 2026 21:47:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768340836; cv=none; b=ou98DLuaWf4EdBzydZ5gjBVeAyd14lsNRwIAYx9tCQYC8QYHWT/jP30MVMg2242BlzDISwNLgB2RrXSH6ICKGTqlbmWp9cWOY80W0uhFJ/KVzbWZFPn3RtI7827Agjggtjnu11iwi+eXDPpLrX7B0X3e713AFs77YIZlm1jsnsE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768340836; c=relaxed/simple;
	bh=M6QRM+zTD802QsK3fMVKuFdYpm03ZqwXSLZlDtWg7zU=;
	h=Date:To:From:Subject:Message-Id; b=ADDV2FOE4WIJlI9wsizYgLdZpcXJNq3J1bPdU10gai7h89DVIWtdLEBm0/xr8YJ2EcynsKpuQIbfIojLnolbonVCjidMBBKZBFvu/MkHJNHT/j5Q/eTX/8uelG2prigJIS4FPusu4nU4r4xAR+fCENNb7aQJDTZ69LrbiySXUdQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=STn5CMM+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="STn5CMM+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F769C116C6;
	Tue, 13 Jan 2026 21:47:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768340835;
	bh=M6QRM+zTD802QsK3fMVKuFdYpm03ZqwXSLZlDtWg7zU=;
	h=Date:To:From:Subject:From;
	b=STn5CMM+zUMcibsIUvkPh7o9ikDxq3BQPoR/p+I0v0LEUDLKaT0ygVj3ltevHTmCa
	 0hlmC/SQxwashQEKhPtupdryRDQFbzpesKOq4o4TuwyiPu23x5GyvWttulYhICCPtF
	 Y1AH/xaB9je7FrI6W2NFXrjwFQGv2yyYshmFACYo=
Date: Tue, 13 Jan 2026 13:47:14 -0800
To: mm-commits@vger.kernel.org,yuzhao@google.com,willy@infradead.org,viro@zeniv.linux.org.uk,vbabka@suse.cz,tj@kernel.org,sweettea-kernel@dorminy.me,surenb@google.com,sj@kernel.org,shakeel.butt@linux.dev,rppt@kernel.org,rostedt@goodmis.org,roman.gushchin@linux.dev,rientjes@google.com,richard.weiyang@gmail.com,paulmck@kernel.org,mjguzik@gmail.com,mhocko@suse.com,mhiramat@kernel.org,lorenzo.stoakes@oracle.com,liumartin@google.com,linmiaohe@huawei.com,liam.howlett@oracle.com,hannes@cmpxchg.org,dennis@kernel.org,david@redhat.com,cl@linux.com,brauner@kernel.org,baolin.wang@linux.alibaba.com,aboorvad@linux.ibm.com,mathieu.desnoyers@efficios.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-fix-oom-killer-and-proc-stats-inaccuracy-on-large-many-core-systems.patch added to mm-new branch
Message-Id: <20260113214715.7F769C116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: fix OOM killer and proc stats inaccuracy on large many-core systems
has been added to the -mm mm-new branch.  Its filename is
     mm-fix-oom-killer-and-proc-stats-inaccuracy-on-large-many-core-systems.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-fix-oom-killer-and-proc-stats-inaccuracy-on-large-many-core-systems.patch

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
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: mm: fix OOM killer and proc stats inaccuracy on large many-core systems
Date: Tue, 13 Jan 2026 14:47:34 -0500

This patch modifies the OOM killer and all proc RSS stats to use the
precise for-each-possible-cpu sum to fix the inaccuracy issues.  This
approach was suggested by Michal Hocko as a straightforward fix for the
inaccuracy issue by using more precise (but slower) RSS stats sum.

Use the precise, albeit slower, precise RSS counter sums for the OOM
killer task selection and proc statistics.  The approximated value is too
imprecise on large many-core systems.

The following rss tracking issues were noted by Sweet Tea Dorminy [1],
which lead to picking wrong tasks as OOM kill target:

  Recently, several internal services had an RSS usage regression as part of a
  kernel upgrade. Previously, they were on a pre-6.2 kernel and were able to
  read RSS statistics in a backup watchdog process to monitor and decide if
  they'd overrun their memory budget. Now, however, a representative service
  with five threads, expected to use about a hundred MB of memory, on a 250-cpu
  machine had memory usage tens of megabytes different from the expected amount
  -- this constituted a significant percentage of inaccuracy, causing the
  watchdog to act.

  This was a result of commit f1a7941243c1 ("mm: convert mm's rss stats
  into percpu_counter") [1].  Previously, the memory error was bounded by
  64*nr_threads pages, a very livable megabyte. Now, however, as a result of
  scheduler decisions moving the threads around the CPUs, the memory error could
  be as large as a gigabyte.

  This is a really tremendous inaccuracy for any few-threaded program on a
  large machine and impedes monitoring significantly. These stat counters are
  also used to make OOM killing decisions, so this additional inaccuracy could
  make a big difference in OOM situations -- either resulting in the wrong
  process being killed, or in less memory being returned from an OOM-kill than
  expected.

Here is a (possibly incomplete) list of the prior approaches that were
used or proposed, along with their downside:

1) Per-thread rss tracking: large error on many-thread processes.

2) Per-CPU counters: up to 12% slower for short-lived processes and 9%
   increased system time in make test workloads [1]. Moreover, the
   inaccuracy increases with O(n^2) with the number of CPUs.

3) Per-NUMA-node counters: requires atomics on fast-path (overhead),
   error is high with systems that have lots of NUMA nodes (32 times
   the number of NUMA nodes).

The simple fix proposed here is to do the precise per-cpu counters sum
every time a counter value needs to be read.  This applies to the OOM
killer task selection, to the /proc statistics, and to the oom mark_victim
trace event.

Note that commit 82241a83cd15 ("mm: fix the inaccurate memory statistics
issue for users") introduced get_mm_counter_sum() for precise proc memory
status queries for _some_ proc files.  This change renames
get_mm_counter_sum() to get_mm_counter(), thus moving the rest of the proc
files to the precise sum.

This change effectively increases the latency introduced when the OOM
killer executes in favor of doing a more precise OOM target task
selection.  Effectively, the OOM killer iterates on all tasks, for all
relevant page types, for which the precise sum iterates on all possible
CPUs.

As a reference, here is the execution time of the OOM killer before/after
the change:

AMD EPYC 9654 96-Core (2 sockets)
Within a KVM, configured with 256 logical cpus.

                                  |  before  |  after   |
----------------------------------|----------|----------|
nr_processes=40                   |  0.3 ms  |   0.5 ms |
nr_processes=10000                |  3.0 ms  |  80.0 ms |

Link: https://lkml.kernel.org/r/20260113194734.28983-2-mathieu.desnoyers@efficios.com
Fixes: f1a7941243c1 ("mm: convert mm's rss stats into percpu_counter")
Link: https://lore.kernel.org/lkml/20250331223516.7810-2-sweettea-kernel@dorminy.me/ # [1]
Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Suggested-by: Michal Hocko <mhocko@suse.com>
Cc: "Paul E. McKenney" <paulmck@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Dennis Zhou <dennis@kernel.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Christoph Lameter <cl@linux.com>
Cc: Martin Liu <liumartin@google.com>
Cc: David Rientjes <rientjes@google.com>
Cc: christian.koenig@amd.com
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: SeongJae Park <sj@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: "Liam R . Howlett" <liam.howlett@oracle.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Wei Yang <richard.weiyang@gmail.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Yu Zhao <yuzhao@google.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Mateusz Guzik <mjguzik@gmail.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Aboorva Devarajan <aboorvad@linux.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_mmu.c |   14 +++++++-------
 include/linux/mm.h |    5 -----
 2 files changed, 7 insertions(+), 12 deletions(-)

--- a/fs/proc/task_mmu.c~mm-fix-oom-killer-and-proc-stats-inaccuracy-on-large-many-core-systems
+++ a/fs/proc/task_mmu.c
@@ -39,9 +39,9 @@ void task_mem(struct seq_file *m, struct
 	unsigned long text, lib, swap, anon, file, shmem;
 	unsigned long hiwater_vm, total_vm, hiwater_rss, total_rss;
 
-	anon = get_mm_counter_sum(mm, MM_ANONPAGES);
-	file = get_mm_counter_sum(mm, MM_FILEPAGES);
-	shmem = get_mm_counter_sum(mm, MM_SHMEMPAGES);
+	anon = get_mm_counter(mm, MM_ANONPAGES);
+	file = get_mm_counter(mm, MM_FILEPAGES);
+	shmem = get_mm_counter(mm, MM_SHMEMPAGES);
 
 	/*
 	 * Note: to minimize their overhead, mm maintains hiwater_vm and
@@ -62,7 +62,7 @@ void task_mem(struct seq_file *m, struct
 	text = min(text, mm->exec_vm << PAGE_SHIFT);
 	lib = (mm->exec_vm << PAGE_SHIFT) - text;
 
-	swap = get_mm_counter_sum(mm, MM_SWAPENTS);
+	swap = get_mm_counter(mm, MM_SWAPENTS);
 	SEQ_PUT_DEC("VmPeak:\t", hiwater_vm);
 	SEQ_PUT_DEC(" kB\nVmSize:\t", total_vm);
 	SEQ_PUT_DEC(" kB\nVmLck:\t", mm->locked_vm);
@@ -95,12 +95,12 @@ unsigned long task_statm(struct mm_struc
 			 unsigned long *shared, unsigned long *text,
 			 unsigned long *data, unsigned long *resident)
 {
-	*shared = get_mm_counter_sum(mm, MM_FILEPAGES) +
-			get_mm_counter_sum(mm, MM_SHMEMPAGES);
+	*shared = get_mm_counter(mm, MM_FILEPAGES) +
+			get_mm_counter(mm, MM_SHMEMPAGES);
 	*text = (PAGE_ALIGN(mm->end_code) - (mm->start_code & PAGE_MASK))
 								>> PAGE_SHIFT;
 	*data = mm->data_vm + mm->stack_vm;
-	*resident = *shared + get_mm_counter_sum(mm, MM_ANONPAGES);
+	*resident = *shared + get_mm_counter(mm, MM_ANONPAGES);
 	return mm->total_vm;
 }
 
--- a/include/linux/mm.h~mm-fix-oom-killer-and-proc-stats-inaccuracy-on-large-many-core-systems
+++ a/include/linux/mm.h
@@ -2849,11 +2849,6 @@ static inline bool get_user_page_fast_on
  */
 static inline unsigned long get_mm_counter(struct mm_struct *mm, int member)
 {
-	return percpu_counter_read_positive(&mm->rss_stat[member]);
-}
-
-static inline unsigned long get_mm_counter_sum(struct mm_struct *mm, int member)
-{
 	return percpu_counter_sum_positive(&mm->rss_stat[member]);
 }
 
_

Patches currently in -mm which might be from mathieu.desnoyers@efficios.com are

mm-add-missing-static-initializer-for-init_mm-mm_cidlock.patch
mm-rename-cpu_bitmap-field-to-flexible_array.patch
mm-take-into-account-mm_cid-size-for-mm_struct-static-definitions.patch
tsacct-skip-all-kernel-threads.patch
mm-fix-oom-killer-and-proc-stats-inaccuracy-on-large-many-core-systems.patch

