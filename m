Received: from mail.mainlining.org (mail.mainlining.org [5.75.144.95])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5947B343D63
	for <mm-commits@vger.kernel.org>; Sat, 29 Aug 2026 22:48:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=5.75.144.95
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788043722; cv=none; b=IdcIMIr4FneGHH9F+RTPt0yvaYUMS+dljkOnKQhzheRY3a0GsUK+Ah32GSx1i2I+7bMbfut8vMLWoj+CyzfRo4uWJypPKyiPrmcImcefzzkI6WgsjqIWjtIHHtsub9en5f3EP8xTerMaE18dviQCSlJp8OQ38295TFcHtKp+8ms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788043722; c=relaxed/simple;
	bh=4nQLvb3n+jJIkSTA8YhLkdfL9Oun3moJWjYVlTyrzrM=;
	h=Date:From:To:Subject:In-Reply-To:References:Message-ID:
	 MIME-Version:Content-Type; b=uMMQoLHzqkeMEJ03PAktLS+Dfljmb0fTrgkzR2PWKHZDw8VF+8Vti/AIsZdaoj3LKkvsYVI0iQyqSFQJQorWhzMHlwRXZkb+IEEWCQkCVF0hasoufm4fdQ1K967TQRvqkKaFs5EBmXK1Yt8jpvkNIxumjOXFo6MV3yCIKi9oOGo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=mainlining.org; spf=pass smtp.mailfrom=mainlining.org; dkim=pass (2048-bit key) header.d=mainlining.org header.i=@mainlining.org header.b=q2FRd+wf; dkim=permerror (0-bit key) header.d=mainlining.org header.i=@mainlining.org header.b=skxVlZnu; arc=none smtp.client-ip=5.75.144.95
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=mainlining.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mainlining.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mainlining.org header.i=@mainlining.org header.b="q2FRd+wf";
	dkim=permerror (0-bit key) header.d=mainlining.org header.i=@mainlining.org header.b="skxVlZnu"
DKIM-Signature: v=1; a=rsa-sha256; s=202507r; d=mainlining.org; c=relaxed/relaxed;
	h=Message-ID:Subject:To:From:Date; t=1788043717; bh=cUDdhozAFy80lvcXZr/aP9T
	MF6NbcDu4wZeThp6dyFE=; b=q2FRd+wfZOOGh7RIKoVKiQ8JkVe7k9aQq67RIDcGcEXTBF2P5q
	MdfElr4ECsAEVTdHhXhlqQLReETGbywWsWAxQHw8eiDsXq9M4qDacpW9fCQrXbOQm1X9TGZW4Gv
	ov/5gbykuKSa3kgQMnsDL4bUq4CLPZISX5RsJtIeuVzs1s5hU7aR9cmngl8AOkEMF4uQ5ycLKNU
	Q/VabBbJ/U4mmJYM7IzQEP9ItTizRvjvlJ8cPfP0J4iBq8quzjJJGwxxJWvlWnHgnxhDaJbCNRS
	D6W94hVUGxfQwLHu4KzX7BdBnA595HxrWH3cQ0n4EWD6W3cL4KjV6sTCECpAv0VseGw==;
DKIM-Signature: v=1; a=ed25519-sha256; s=202507e; d=mainlining.org; c=relaxed/relaxed;
	h=Message-ID:Subject:To:From:Date; t=1788043717; bh=cUDdhozAFy80lvcXZr/aP9T
	MF6NbcDu4wZeThp6dyFE=; b=skxVlZnuOgOuuOMflWqXPiZzmpI9+4ks4uWgpGXDY7lq9AEULC
	zyGc5Te3sqBnjKUxsiMEQlJfiDqXwe56uhBA==;
Date: Sat, 29 Aug 2026 23:48:39 +0100
From: Bradley Morgan <brads@mainlining.org>
To: Andrew Morton <akpm@linux-foundation.org>, mm-commits@vger.kernel.org,
 pmladek@suse.com, mhiramat@kernel.org, lance.yang@linux.dev,
 david.laight.linux@gmail.com, atomlin@atomlin.com, akpm@linux-foundation.org
Subject: =?US-ASCII?Q?Re=3A_+_hung=5Ftask-reset-warning-budget-when-problem-g?=
 =?US-ASCII?Q?ets-resolved=2Epatch_added_to_mm-nonmm-unstable_branch?=
In-Reply-To: <20260829224704.C3D0B1F000E9@smtp.kernel.org>
References: <20260829224704.C3D0B1F000E9@smtp.kernel.org>
Message-ID: <1C7F9139-85AC-44C5-A1D2-6C7429C84661@mainlining.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 8bit

On 29 August 2026 23:47:04 BST, Andrew Morton <akpm@linux-foundation.org>
wrote:
>
>The patch titled
>     Subject: hung_task: reset warning budget when problem gets resolved
>has been added to the -mm mm-nonmm-unstable branch.  Its filename is
>     hung_task-reset-warning-budget-when-problem-gets-resolved.patch
>
>This patch will shortly appear at
>     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/hung_task-reset-warning-budget-when-problem-gets-resolved.patch
>
>This patch will later appear in the mm-nonmm-unstable branch at
>    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
>
>Before you just go and hit "reply", please:
>   a) Consider who else should be cc'ed
>   b) Prefer to cc a suitable mailing list as well
>   c) Ideally: find the original patch on the mailing list and do a
>      reply-to-all to that, adding suitable additional cc's
>
>*** Remember to use Documentation/process/submit-checklist.rst when
>testing your code ***
>
>The -mm tree is included into linux-next via various
>branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
>and is updated there most days
>
>------------------------------------------------------
>From: Aaron Tomlin <atomlin@atomlin.com>
>Subject: hung_task: reset warning budget when problem gets resolved
>Date: Sat, 29 Aug 2026 10:53:20 -0400
>
>Patch series "hung_task: Improve warning budget handling and task
>reporting", v10.
>
>The hung_task watchdog detects tasks stuck in TASK_UNINTERRUPTIBLE (D)
>state for longer than CONFIG_DEFAULT_HUNG_TASK_TIMEOUT seconds.  To
>prevent log spam during system spikes, sysctl_hung_task_warnings enforces
>a budget on the number of logged warnings.
>
>However, the current implementation has two major limitations:
>
>    1. Permanent exhaustion of warning budget
>
>       sysctl_hung_task_warnings is decremented directly when
>       printing warnings.  Once this budget hits zero, no further warnings
>       are reported until an administrator manually updates the sysctl
>       value or reboots the system.  Consequently, a single temporary hang
>       episode permanently blinds the kernel watchdog to any subsequent
>       hung tasks after system recovery.
>
>    2. Total log suppression when budget is exhausted
>
>       Once the warning budget reaches zero, hung_task_info()
>       completely suppresses all output, including the basic single-line
>       alert.  While suppressing verbose stack dumps and lock debugging is
>       desirable to prevent dmesg flooding, hiding basic task alerts
>       leaves administrators entirely unaware that tasks are hanging.
>
>This patch series resolves both limitations by decoupling the configured
>warning limit from the active runtime budget, automatically resetting the
>budget upon system recovery or sysctl updates, and emitting a single
>aggregate summary line when hung tasks are detected under an exhausted
>warning budget.
>
>Patch 1 separates the configured sysctl hung_task_warnings from the
>runtime budget, making khungtaskd the sole owner of runtime budget
>updates.  The budget is reloaded directly when a scan finds zero hung
>tasks, or via an atomic reset request published on sysctl write.
>
>Patch 2 prevents dmesg flooding during system-wide hangs by keeping
>non-panic per-task stack dumps budgeted, while providing ongoing
>visibility by logging a single aggregate summary line at the end of each
>scan iteration when the warning budget is exhausted.
>
>
>This patch (of 2):
>
>The sysctl hung_task_warnings currently holds both the configured warning
>limit and the remaining budget.  Each detailed report decrements the
>sysctl, so once it reaches zero, the configured limit is lost and cannot
>be restored automatically.
>
>Keep sysctl_hung_task_warnings as the configured warning limit and make
>khungtaskd the sole owner of the remaining budget.  A check that finds no
>hung tasks reloads the budget directly from the configured limit.  A
>successful sysctl write publishes an atomic reset request, which
>khungtaskd consumes at the start of the next check.
>
>Link: https://lore.kernel.org/20260829145321.18423-1-atomlin@atomlin.com
>Link: https://lore.kernel.org/20260829145321.18423-2-atomlin@atomlin.com
>Signed-off-by: Aaron Tomlin <atomlin@atomlin.com>
>Suggested-by: Petr Mladek <pmladek@suse.com>
>Suggested-by: Lance Yang <lance.yang@linux.dev>
>Tested-by: Lance Yang <lance.yang@linux.dev>
>Reviewed-by: Lance Yang <lance.yang@linux.dev>
>Cc: Bradley Morgan <brads@mainlining.org>



Andrewwwwww, your gonna killlll meeee but can u plssss add my taggggg.....
My client had issues.

>Cc: David Laight <david.laight.linux@gmail.com>
>Cc: "Masami Hiramatsu (Google)" <mhiramat@kernel.org>
>Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
>---
>
> Documentation/admin-guide/sysctl/kernel.rst |    5 +
> kernel/hung_task.c                          |   49 +++++++++++++++---
> 2 files changed, 44 insertions(+), 10 deletions(-)
>
>--- a/Documentation/admin-guide/sysctl/kernel.rst~hung_task-reset-warning-budget-when-problem-gets-resolved
>+++ a/Documentation/admin-guide/sysctl/kernel.rst
>@@ -459,8 +459,9 @@ hung_task_warnings
> ==================
> 
> The maximum number of warnings to report. During a check interval
>-if a hung task is detected, this value is decreased by 1.
>-When this value reaches 0, no more warnings will be reported.
>+if a hung task is detected, the internal warning budget is decreased by 1.
>+When this budget reaches 0, no more detailed warnings will be reported. The
>+warning budget is reset to the configured limit when no hung task is found.
> This file shows up if ``CONFIG_DETECT_HUNG_TASK`` is enabled.
> 
> -1: report an infinite number of warnings.
>--- a/kernel/hung_task.c~hung_task-reset-warning-budget-when-problem-gets-resolved
>+++ a/kernel/hung_task.c
>@@ -57,8 +57,20 @@ unsigned long __read_mostly sysctl_hung_
>  */
> static unsigned long __read_mostly sysctl_hung_task_check_interval_secs;
> 
>+/*
>+ * Limit the number of printed hung tasks to prevent printing
>+ * the same or similar backtraces repeatedly.
>+ */
> static int __read_mostly sysctl_hung_task_warnings = 10;
> 
>+/*
>+ * The number of hung tasks which still can be reported.
>+ * The budget gets restored to the original limit when
>+ * the previous stall is resolved.
>+ */
>+static int hung_task_warnings_budget = 10;
>+static atomic_t reset_hung_task_warnings = ATOMIC_INIT(0);
>+
> static int __read_mostly did_panic;
> static bool hung_task_call_panic;
> 
>@@ -245,11 +257,11 @@ static void hung_task_info(struct task_s
> 	/*
> 	 * The given task did not get scheduled for more than
> 	 * CONFIG_DEFAULT_HUNG_TASK_TIMEOUT. Therefore, complain
>-	 * accordingly
>+	 * accordingly with full details if the budget is not exhausted.
> 	 */
>-	if (sysctl_hung_task_warnings || hung_task_call_panic) {
>-		if (sysctl_hung_task_warnings > 0)
>-			sysctl_hung_task_warnings--;
>+	if (hung_task_warnings_budget || hung_task_call_panic) {
>+		if (hung_task_warnings_budget > 0)
>+			hung_task_warnings_budget--;
> 		pr_err("INFO: task %s:%d blocked%s for more than %ld seconds.\n",
> 		       t->comm, t->pid, t->in_iowait ? " in I/O wait" : "",
> 		       (jiffies - t->last_switch_time) / HZ);
>@@ -264,7 +276,7 @@ static void hung_task_info(struct task_s
> 		sched_show_task(t);
> 		debug_show_blocker(t, timeout);
> 
>-		if (!sysctl_hung_task_warnings)
>+		if (!hung_task_warnings_budget)
> 			pr_info("Future hung task reports are suppressed, see sysctl kernel.hung_task_warnings\n");
> 	}
> 
>@@ -304,7 +316,7 @@ static void check_hung_uninterruptible_t
> 	unsigned long last_break = jiffies;
> 	struct task_struct *g, *t;
> 	unsigned long this_round_count;
>-	int need_warning = sysctl_hung_task_warnings;
>+	int need_warning;
> 	unsigned long si_mask = hung_task_si_mask;
> 
> 	/*
>@@ -314,6 +326,11 @@ static void check_hung_uninterruptible_t
> 	if (test_taint(TAINT_DIE) || did_panic)
> 		return;
> 
>+	if (atomic_xchg_acquire(&reset_hung_task_warnings, 0))
>+		hung_task_warnings_budget =
>+			READ_ONCE(sysctl_hung_task_warnings);
>+	need_warning = hung_task_warnings_budget;
>+
> 	this_round_count = 0;
> 	rcu_read_lock();
> 	for_each_process_thread(g, t) {
>@@ -340,8 +357,11 @@ static void check_hung_uninterruptible_t
>  unlock:
> 	rcu_read_unlock();
> 
>-	if (!this_round_count)
>+	if (!this_round_count) {
>+		hung_task_warnings_budget =
>+			READ_ONCE(sysctl_hung_task_warnings);
> 		return;
>+	}
> 
> 	if (need_warning || hung_task_call_panic) {
> 		si_mask |= SYS_INFO_LOCKS;
>@@ -425,6 +445,19 @@ static int proc_dohung_task_timeout_secs
> 	return ret;
> }
> 
>+static int proc_dohung_task_warnings(const struct ctl_table *table, int write,
>+				     void *buffer,
>+				     size_t *lenp, loff_t *ppos)
>+{
>+	int ret;
>+
>+	ret = proc_dointvec_minmax(table, write, buffer, lenp, ppos);
>+	if (!ret && write)
>+		atomic_set_release(&reset_hung_task_warnings, 1);
>+
>+	return ret;
>+}
>+
> /*
>  * This is needed for proc_doulongvec_minmax of sysctl_hung_task_timeout_secs
>  * and hung_task_check_interval_secs
>@@ -480,7 +513,7 @@ static const struct ctl_table hung_task_
> 		.data		= &sysctl_hung_task_warnings,
> 		.maxlen		= sizeof(int),
> 		.mode		= 0644,
>-		.proc_handler	= proc_dointvec_minmax,
>+		.proc_handler	= proc_dohung_task_warnings,
> 		.extra1		= SYSCTL_NEG_ONE,
> 	},
> 	{
>_
>
>Patches currently in -mm which might be from atomlin@atomlin.com are
>
>hung_task-reset-warning-budget-when-problem-gets-resolved.patch
>hung_task-log-summary-line-when-warning-budget-is-exhausted.patch
>

--- Thanks!
https://lore.kernel.org/all/EE579805-42F2-4C58-B752-F28779EEB717@grrlz.net/
