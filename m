From: akpm@linux-foundation.org
Subject: - use-boot-based-time-for-process-start-time-and-boot-time.patch removed from -mm tree
Date: Mon, 16 Jul 2007 13:53:03 -0700
Message-ID: <200707162053.l6GKr38l001595@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43074 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751086AbXGPVhF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 16 Jul 2007 17:37:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tjanouse@redhat.com, johnstul@us.ibm.com, mingo@elte.hu, tglx@linutronix.de, tsmetana@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Use boot based time for process start time and boot time 	in /proc
has been removed from the -mm tree.  Its filename was
     use-boot-based-time-for-process-start-time-and-boot-time.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Use boot based time for process start time and boot time 	in /proc
From: Tomas Janousek <tjanouse@redhat.com>

Commit 411187fb05cd11676b0979d9fbf3291db69dbce2 caused boot time to move and
process start times to become invalid after suspend.  Using boot based time
for those restores the old behaviour and fixes the issue.

[akpm@linux-foundation.org: little cleanup]
Signed-off-by: Tomas Janousek <tjanouse@redhat.com>
Cc: Tomas Smetana <tsmetana@redhat.com>
Acked-by: John Stultz <johnstul@us.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/array.c       |    5 +++--
 fs/proc/proc_misc.c   |    6 +++---
 include/linux/sched.h |    3 ++-
 kernel/fork.c         |    2 ++
 4 files changed, 10 insertions(+), 6 deletions(-)

diff -puN fs/proc/array.c~use-boot-based-time-for-process-start-time-and-boot-time fs/proc/array.c
--- a/fs/proc/array.c~use-boot-based-time-for-process-start-time-and-boot-time
+++ a/fs/proc/array.c
@@ -440,8 +440,9 @@ static int do_task_stat(struct task_stru
 
 	/* Temporary variable needed for gcc-2.96 */
 	/* convert timespec -> nsec*/
-	start_time = (unsigned long long)task->start_time.tv_sec * NSEC_PER_SEC
-				+ task->start_time.tv_nsec;
+	start_time =
+		(unsigned long long)task->real_start_time.tv_sec * NSEC_PER_SEC
+				+ task->real_start_time.tv_nsec;
 	/* convert nsec -> ticks */
 	start_time = nsec_to_clock_t(start_time);
 
diff -puN fs/proc/proc_misc.c~use-boot-based-time-for-process-start-time-and-boot-time fs/proc/proc_misc.c
--- a/fs/proc/proc_misc.c~use-boot-based-time-for-process-start-time-and-boot-time
+++ a/fs/proc/proc_misc.c
@@ -443,12 +443,12 @@ static int show_stat(struct seq_file *p,
 	unsigned long jif;
 	cputime64_t user, nice, system, idle, iowait, irq, softirq, steal;
 	u64 sum = 0;
+	struct timespec boottime;
 
 	user = nice = system = idle = iowait =
 		irq = softirq = steal = cputime64_zero;
-	jif = - wall_to_monotonic.tv_sec;
-	if (wall_to_monotonic.tv_nsec)
-		--jif;
+	getboottime(&boottime);
+	jif = boottime.tv_sec;
 
 	for_each_possible_cpu(i) {
 		int j;
diff -puN include/linux/sched.h~use-boot-based-time-for-process-start-time-and-boot-time include/linux/sched.h
--- a/include/linux/sched.h~use-boot-based-time-for-process-start-time-and-boot-time
+++ a/include/linux/sched.h
@@ -972,7 +972,8 @@ struct task_struct {
 	unsigned int rt_priority;
 	cputime_t utime, stime;
 	unsigned long nvcsw, nivcsw; /* context switch counts */
-	struct timespec start_time;
+	struct timespec start_time; 		/* monotonic time */
+	struct timespec real_start_time;	/* boot based time */
 /* mm fault and swap info: this can arguably be seen as either mm-specific or thread-specific */
 	unsigned long min_flt, maj_flt;
 
diff -puN kernel/fork.c~use-boot-based-time-for-process-start-time-and-boot-time kernel/fork.c
--- a/kernel/fork.c~use-boot-based-time-for-process-start-time-and-boot-time
+++ a/kernel/fork.c
@@ -1059,6 +1059,8 @@ static struct task_struct *copy_process(
 
 	p->lock_depth = -1;		/* -1 = no lock */
 	do_posix_clock_monotonic_gettime(&p->start_time);
+	p->real_start_time = p->start_time;
+	monotonic_to_bootbased(&p->real_start_time);
 	p->security = NULL;
 	p->io_context = NULL;
 	p->io_wait = NULL;
_

Patches currently in -mm which might be from tjanouse@redhat.com are

origin.patch
