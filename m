Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45935327C18
	for <mm-commits@vger.kernel.org>; Wed,  7 Oct 2026 02:04:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791338656; cv=none; b=XVu8bdK8jkYwCLcxWxWLbPswNcxt5nRlMD94SybafK65JRCxhrsV6q80nX0SoiOlRWIbD1YX817yRTbVit1QHj/1BZkj7YEXCiu9Y/pcau1dTY0/0z+HKcCle/yU3nYusjNBbaJ/YdYqOOy5uoBe0iFFfqIuKqP2ZIxfvTWZGxw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791338656; c=relaxed/simple;
	bh=hAe/3XhKaxVurdvZDo+NKvcm5CvxQ/fMtqpFGlWTqmA=;
	h=Date:To:From:Subject:Message-Id; b=r23Rf5fOanwG3i8eB2FjhvXU9RKSCvkg94hQDFxj1N79sMALNhRQkbCPw4AnXdeQL9y37qJytf11EMfoT7jGnjVUSBLrUZlp1VmwyFQManwpufvzjsfJWMCNOKUdUhSr7ZMyDhWX0S8UoBDsuEdjA9i2HPFTJVQuKONlWauBfzg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ERT7H1o9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ERT7H1o9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB7E91F0089C;
	Wed,  7 Oct 2026 02:04:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791338654;
	bh=Zq+Lcex+gYy6CjcPMpdkVLNZ49FPY/vQ6DAlsR73I2Y=;
	h=Date:To:From:Subject;
	b=ERT7H1o9f9Nn5HgtD1p2Djxc1of5xK5hgRgWaLC6D7wJDTaUn51dPtcVU7OyN7Bt1
	 2+uspDKMFZCWyoauqMF6WAMsR26UKnNvGduAm1UUuxDzVHfZmDBA1rFZirC5wJJcLa
	 MPcZNAOw6lSFCL1WduHETAOcaCZ/QWv1W80hZKLo=
Date: Tue, 06 Oct 2026 19:04:14 -0700
To: mm-commits@vger.kernel.org,steve@abita.co,sean@ashe.io,pmladek@suse.com,nick.lange@gmail.com,neelx@suse.com,mproche@gmail.com,mhiramat@kernel.org,lance.yang@linux.dev,david.laight.linux@gmail.com,chjohnst@gmail.com,brads@mainlining.org,atomlin@atomlin.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] hung_task-reset-warning-budget-when-problem-gets-resolved.patch removed from -mm tree
Message-Id: <20261007020414.CB7E91F0089C@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: hung_task: reset warning budget when problem gets resolved
has been removed from the -mm tree.  Its filename was
     hung_task-reset-warning-budget-when-problem-gets-resolved.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Aaron Tomlin <atomlin@atomlin.com>
Subject: hung_task: reset warning budget when problem gets resolved
Date: Sun,  4 Oct 2026 12:36:09 -0400

Patch series "hung_task: Improve warning budget handling and task
reporting", v11.

The hung_task watchdog detects tasks stuck in TASK_UNINTERRUPTIBLE (D)
state for longer than CONFIG_DEFAULT_HUNG_TASK_TIMEOUT seconds.  To
prevent log spam during system spikes, sysctl_hung_task_warnings enforces
a budget on the number of logged warnings.

However, the current implementation has two major limitations:

    1. Permanent exhaustion of warning budget

       sysctl_hung_task_warnings is decremented directly when printing
       warnings. Once this budget hits zero, no further warnings are
       reported until an administrator manually updates the sysctl value or
       reboots the system. Consequently, a single temporary hang episode
       permanently blinds the kernel watchdog to any subsequent hung tasks
       after system recovery.

    2. Total log suppression when budget is exhausted

       Once the warning budget reaches zero, hung_task_info() completely
       suppresses all output, including the basic single-line alert. While
       suppressing verbose stack dumps and lock debugging is desirable to
       prevent dmesg flooding, hiding basic task alerts leaves
       administrators entirely unaware that tasks are hanging.

This patch series resolves both limitations by decoupling the configured
warning limit from the active runtime budget, automatically resetting the
budget upon system recovery or sysctl updates, and emitting a single
aggregate summary line when hung tasks are detected under an exhausted
warning budget.

Patch 1 separates the configured sysctl hung_task_warnings from the
runtime budget, making khungtaskd the sole owner of runtime budget
updates.  The budget is reloaded directly when a scan finds zero hung
tasks, or via an atomic reset request published on sysctl write.

Patch 2 prevents dmesg flooding during system-wide hangs by keeping
non-panic per-task stack dumps budgeted, while providing ongoing
visibility by logging a single aggregate summary line at the end of each
scan iteration when the warning budget is exhausted.


This patch (of 2):

The sysctl hung_task_warnings currently holds both the configured warning
limit and the remaining budget. Each detailed report decrements the
sysctl, so once it reaches zero, the configured limit is lost and cannot
be restored automatically.

Keep sysctl_hung_task_warnings as the configured warning limit and make
khungtaskd the sole owner of the remaining budget. A check that finds no
hung tasks reloads the budget directly from the configured limit. A
successful sysctl write publishes an atomic reset request, which
khungtaskd consumes at the start of the next check.

Link: https://lore.kernel.org/20261004163610.413506-1-atomlin@atomlin.com
Link: https://lore.kernel.org/20261004163610.413506-2-atomlin@atomlin.com
Signed-off-by: Aaron Tomlin <atomlin@atomlin.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Suggested-by: Petr Mladek <pmladek@suse.com>
Suggested-by: Lance Yang <lance.yang@linux.dev>
Tested-by: Lance Yang <lance.yang@linux.dev>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Reviewed-by: Bradley Morgan <brads@mainlining.org>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: David Laight <david.laight.linux@gmail.com>
Cc: Daniel Vacek <neelx@suse.com>
Cc: Sean Ashe <sean@ashe.io>
Cc: <chjohnst@gmail.com>
Cc: <steve@abita.co>
Cc: <mproche@gmail.com>
Cc: <nick.lange@gmail.com>
---

 Documentation/admin-guide/sysctl/kernel.rst |    5 +
 kernel/hung_task.c                          |   49 +++++++++++++++---
 2 files changed, 44 insertions(+), 10 deletions(-)

--- a/Documentation/admin-guide/sysctl/kernel.rst~hung_task-reset-warning-budget-when-problem-gets-resolved
+++ a/Documentation/admin-guide/sysctl/kernel.rst
@@ -459,8 +459,9 @@ hung_task_warnings
 ==================
 
 The maximum number of warnings to report. During a check interval
-if a hung task is detected, this value is decreased by 1.
-When this value reaches 0, no more warnings will be reported.
+if a hung task is detected, the internal warning budget is decreased by 1.
+When this budget reaches 0, no more detailed warnings will be reported. The
+warning budget is reset to the configured limit when no hung task is found.
 This file shows up if ``CONFIG_DETECT_HUNG_TASK`` is enabled.
 
 -1: report an infinite number of warnings.
--- a/kernel/hung_task.c~hung_task-reset-warning-budget-when-problem-gets-resolved
+++ a/kernel/hung_task.c
@@ -57,8 +57,20 @@ unsigned long __read_mostly sysctl_hung_
  */
 static unsigned long __read_mostly sysctl_hung_task_check_interval_secs;
 
+/*
+ * Limit the number of printed hung tasks to prevent printing
+ * the same or similar backtraces repeatedly.
+ */
 static int __read_mostly sysctl_hung_task_warnings = 10;
 
+/*
+ * The number of hung tasks which still can be reported.
+ * The budget gets restored to the original limit when
+ * the previous stall is resolved.
+ */
+static int hung_task_warnings_budget = 10;
+static atomic_t reset_hung_task_warnings = ATOMIC_INIT(0);
+
 static int __read_mostly did_panic;
 static bool hung_task_call_panic;
 
@@ -245,11 +257,11 @@ static void hung_task_info(struct task_s
 	/*
 	 * The given task did not get scheduled for more than
 	 * CONFIG_DEFAULT_HUNG_TASK_TIMEOUT. Therefore, complain
-	 * accordingly
+	 * accordingly with full details if the budget is not exhausted.
 	 */
-	if (sysctl_hung_task_warnings || hung_task_call_panic) {
-		if (sysctl_hung_task_warnings > 0)
-			sysctl_hung_task_warnings--;
+	if (hung_task_warnings_budget || hung_task_call_panic) {
+		if (hung_task_warnings_budget > 0)
+			hung_task_warnings_budget--;
 		pr_err("INFO: task %s:%d blocked%s for more than %ld seconds.\n",
 		       t->comm, t->pid, t->in_iowait ? " in I/O wait" : "",
 		       (jiffies - t->last_switch_time) / HZ);
@@ -264,7 +276,7 @@ static void hung_task_info(struct task_s
 		sched_show_task(t);
 		debug_show_blocker(t, timeout);
 
-		if (!sysctl_hung_task_warnings)
+		if (!hung_task_warnings_budget)
 			pr_info("Future hung task reports are suppressed, see sysctl kernel.hung_task_warnings\n");
 	}
 
@@ -304,7 +316,7 @@ static void check_hung_uninterruptible_t
 	unsigned long last_break = jiffies;
 	struct task_struct *g, *t;
 	unsigned long this_round_count;
-	int need_warning = sysctl_hung_task_warnings;
+	int need_warning;
 	unsigned long si_mask = hung_task_si_mask;
 
 	/*
@@ -314,6 +326,11 @@ static void check_hung_uninterruptible_t
 	if (test_taint(TAINT_DIE) || did_panic)
 		return;
 
+	if (atomic_xchg_acquire(&reset_hung_task_warnings, 0))
+		hung_task_warnings_budget =
+			READ_ONCE(sysctl_hung_task_warnings);
+	need_warning = hung_task_warnings_budget;
+
 	this_round_count = 0;
 	rcu_read_lock();
 	for_each_process_thread(g, t) {
@@ -340,8 +357,11 @@ static void check_hung_uninterruptible_t
  unlock:
 	rcu_read_unlock();
 
-	if (!this_round_count)
+	if (!this_round_count) {
+		hung_task_warnings_budget =
+			READ_ONCE(sysctl_hung_task_warnings);
 		return;
+	}
 
 	if (need_warning || hung_task_call_panic) {
 		si_mask |= SYS_INFO_LOCKS;
@@ -425,6 +445,19 @@ static int proc_dohung_task_timeout_secs
 	return ret;
 }
 
+static int proc_dohung_task_warnings(const struct ctl_table *table, int write,
+				     void *buffer,
+				     size_t *lenp, loff_t *ppos)
+{
+	int ret;
+
+	ret = proc_dointvec_minmax(table, write, buffer, lenp, ppos);
+	if (!ret && write)
+		atomic_set_release(&reset_hung_task_warnings, 1);
+
+	return ret;
+}
+
 /*
  * This is needed for proc_doulongvec_minmax of sysctl_hung_task_timeout_secs
  * and hung_task_check_interval_secs
@@ -480,7 +513,7 @@ static const struct ctl_table hung_task_
 		.data		= &sysctl_hung_task_warnings,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec_minmax,
+		.proc_handler	= proc_dohung_task_warnings,
 		.extra1		= SYSCTL_NEG_ONE,
 	},
 	{
_

Patches currently in -mm which might be from atomlin@atomlin.com are


