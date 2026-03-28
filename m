Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E05333557B
	for <mm-commits@vger.kernel.org>; Sat, 28 Mar 2026 04:25:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774671916; cv=none; b=FmOXKDoHXCXRwKUGpvv8if0phhjaI7PbvBxO4XkuWjaZkYm5UVcKBxiA3Sh4+uO80LwA/Y7XsTvyhDevhqOG4QdPF4RtKFIS1P7XjLJiwHzr4T2pwwx0DN5mln13Hl5dNR28Zn7SboRbzBOAyVWB1yaDnCiEf0Qj8uYfbS+M0Bg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774671916; c=relaxed/simple;
	bh=yN1n7uEZ8BbP1Or0MZ5Ao3DnkPZyTzzF+wRxmIZLqA4=;
	h=Date:To:From:Subject:Message-Id; b=dOMgzM7LsqcuH2aN92ScrnYL4p7DmJJN42a8CAYemRDzVDAnHSWsaFYnHOd+rxywnp06Ie3/zolMdRHRWVtUFnuJnZ4oMWAV1ksJbPskkc58LUtfi5WQ8JT3hg7aJKBP5aitpBcpe8X2HnaNEKmY0O6lj+d86z5kOcSwi6OtvwE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=uSwZlCQf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="uSwZlCQf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36AF1C4CEF7;
	Sat, 28 Mar 2026 04:25:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774671916;
	bh=yN1n7uEZ8BbP1Or0MZ5Ao3DnkPZyTzzF+wRxmIZLqA4=;
	h=Date:To:From:Subject:From;
	b=uSwZlCQfZMFN7tVSq/22mfc5wuEWyWDgr3ANOJ4GIwijfiy46/8nbyQ2D3F0q7LW9
	 3/dWYjmOxeLsfujFwtmCVet6t4UXs8vk2BHF+XPz8wV+fE/v4jS7In8z3SK6RAxn6w
	 w0jCdbH/8DuvAzEFBuNlam/851qybxVaHXSoyZZ0=
Date: Fri, 27 Mar 2026 21:25:15 -0700
To: mm-commits@vger.kernel.org,pmladek@suse.com,mhiramat@kernel.org,lance.yang@linux.dev,joel.granados@kernel.org,gregkh@linuxfoundation.org,atomlin@atomlin.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] hung_task-refactor-detection-logic-and-atomicise-detection-count.patch removed from -mm tree
Message-Id: <20260328042516.36AF1C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: hung_task: refactor detection logic and atomicise detection count
has been removed from the -mm tree.  Its filename was
     hung_task-refactor-detection-logic-and-atomicise-detection-count.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Aaron Tomlin <atomlin@atomlin.com>
Subject: hung_task: refactor detection logic and atomicise detection count
Date: Tue, 3 Mar 2026 15:30:29 -0500

Patch series "hung_task: Provide runtime reset interface for hung task
detector", v9.

This series introduces the ability to reset
/proc/sys/kernel/hung_task_detect_count.

Writing a "0" value to this file atomically resets the counter of detected
hung tasks.  This functionality provides system administrators with the
means to clear the cumulative diagnostic history following incident
resolution, thereby simplifying subsequent monitoring without
necessitating a system restart.


This patch (of 3):

The check_hung_task() function currently conflates two distinct
responsibilities: validating whether a task is hung and handling the
subsequent reporting (printing warnings, triggering panics, or
tracepoints).

This patch refactors the logic by introducing hung_task_info(), a function
dedicated solely to reporting.  The actual detection check,
task_is_hung(), is hoisted into the primary loop within
check_hung_uninterruptible_tasks().  This separation clearly decouples the
mechanism of detection from the policy of reporting.

Furthermore, to facilitate future support for concurrent hung task
detection, the global sysctl_hung_task_detect_count variable is converted
from unsigned long to atomic_long_t.  Consequently, the counting logic is
updated to accumulate the number of hung tasks locally (this_round_count)
during the iteration.  The global counter is then updated atomically via
atomic_long_cmpxchg_relaxed() once the loop concludes, rather than
incrementally during the scan.

These changes are strictly preparatory and introduce no functional change
to the system's runtime behaviour.

Link: https://lkml.kernel.org/r/20260303203031.4097316-1-atomlin@atomlin.com
Link: https://lkml.kernel.org/r/20260303203031.4097316-2-atomlin@atomlin.com
Signed-off-by: Aaron Tomlin <atomlin@atomlin.com>
Reviewed-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Reviewed-by: Petr Mladek <pmladek@suse.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Joel Granados <joel.granados@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/hung_task.c |   58 ++++++++++++++++++++++++-------------------
 1 file changed, 33 insertions(+), 25 deletions(-)

--- a/kernel/hung_task.c~hung_task-refactor-detection-logic-and-atomicise-detection-count
+++ a/kernel/hung_task.c
@@ -36,7 +36,7 @@ static int __read_mostly sysctl_hung_tas
 /*
  * Total number of tasks detected as hung since boot:
  */
-static unsigned long __read_mostly sysctl_hung_task_detect_count;
+static atomic_long_t sysctl_hung_task_detect_count = ATOMIC_LONG_INIT(0);
 
 /*
  * Limit number of tasks checked in a batch.
@@ -223,31 +223,29 @@ static inline void debug_show_blocker(st
 }
 #endif
 
-static void check_hung_task(struct task_struct *t, unsigned long timeout,
-		unsigned long prev_detect_count)
+/**
+ * hung_task_info - Print diagnostic details for a hung task
+ * @t: Pointer to the detected hung task.
+ * @timeout: Timeout threshold for detecting hung tasks
+ * @this_round_count: Count of hung tasks detected in the current iteration
+ *
+ * Print structured information about the specified hung task, if warnings
+ * are enabled or if the panic batch threshold is exceeded.
+ */
+static void hung_task_info(struct task_struct *t, unsigned long timeout,
+			   unsigned long this_round_count)
 {
-	unsigned long total_hung_task;
-
-	if (!task_is_hung(t, timeout))
-		return;
-
-	/*
-	 * This counter tracks the total number of tasks detected as hung
-	 * since boot.
-	 */
-	sysctl_hung_task_detect_count++;
-
-	total_hung_task = sysctl_hung_task_detect_count - prev_detect_count;
 	trace_sched_process_hang(t);
 
-	if (sysctl_hung_task_panic && total_hung_task >= sysctl_hung_task_panic) {
+	if (sysctl_hung_task_panic && this_round_count >= sysctl_hung_task_panic) {
 		console_verbose();
 		hung_task_call_panic = true;
 	}
 
 	/*
-	 * Ok, the task did not get scheduled for more than 2 minutes,
-	 * complain:
+	 * The given task did not get scheduled for more than
+	 * CONFIG_DEFAULT_HUNG_TASK_TIMEOUT. Therefore, complain
+	 * accordingly
 	 */
 	if (sysctl_hung_task_warnings || hung_task_call_panic) {
 		if (sysctl_hung_task_warnings > 0)
@@ -297,18 +295,18 @@ static bool rcu_lock_break(struct task_s
 
 /*
  * Check whether a TASK_UNINTERRUPTIBLE does not get woken up for
- * a really long time (120 seconds). If that happens, print out
- * a warning.
+ * a really long time. If that happens, print out a warning.
  */
 static void check_hung_uninterruptible_tasks(unsigned long timeout)
 {
 	int max_count = sysctl_hung_task_check_count;
 	unsigned long last_break = jiffies;
 	struct task_struct *g, *t;
-	unsigned long prev_detect_count = sysctl_hung_task_detect_count;
+	unsigned long total_count, this_round_count;
 	int need_warning = sysctl_hung_task_warnings;
 	unsigned long si_mask = hung_task_si_mask;
 
+	total_count = atomic_long_read(&sysctl_hung_task_detect_count);
 	/*
 	 * If the system crashed already then all bets are off,
 	 * do not report extra hung tasks:
@@ -316,10 +314,9 @@ static void check_hung_uninterruptible_t
 	if (test_taint(TAINT_DIE) || did_panic)
 		return;
 
-
+	this_round_count = 0;
 	rcu_read_lock();
 	for_each_process_thread(g, t) {
-
 		if (!max_count--)
 			goto unlock;
 		if (time_after(jiffies, last_break + HUNG_TASK_LOCK_BREAK)) {
@@ -328,14 +325,25 @@ static void check_hung_uninterruptible_t
 			last_break = jiffies;
 		}
 
-		check_hung_task(t, timeout, prev_detect_count);
+		if (task_is_hung(t, timeout)) {
+			this_round_count++;
+			hung_task_info(t, timeout, this_round_count);
+		}
 	}
  unlock:
 	rcu_read_unlock();
 
-	if (!(sysctl_hung_task_detect_count - prev_detect_count))
+	if (!this_round_count)
 		return;
 
+	/*
+	 * This counter tracks the total number of tasks detected as hung
+	 * since boot.
+	 */
+	atomic_long_cmpxchg_relaxed(&sysctl_hung_task_detect_count,
+				    total_count, total_count +
+				    this_round_count);
+
 	if (need_warning || hung_task_call_panic) {
 		si_mask |= SYS_INFO_LOCKS;
 
_

Patches currently in -mm which might be from atomlin@atomlin.com are


