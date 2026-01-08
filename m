Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9D2A23D7CE
	for <mm-commits@vger.kernel.org>; Thu,  8 Jan 2026 18:10:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767895839; cv=none; b=ZmOD5FB04ALFg/gom204BCG5nQrBfOrzwQJFrc5X0eGo+NZ8yTdvp7U3BJ72acMjqIvbpphXxkIndYibo+QxwSi/Bc4tEb21EYik2KCledq4xkENpmnC9X/mdJTHuUe9kzT9iSes7rLoTtUz8RVE8GbYgCAP9z4wo0IYPY8irfc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767895839; c=relaxed/simple;
	bh=eHOPHpG+NeKnH5pdIwj/CAqXHYTmbqE3V5WY1f/MIoc=;
	h=Date:To:From:Subject:Message-Id; b=ETq5/cxCxnAtH9hipPPRh5/gfEHB503KZ2sel7iJURNsUoX7BX9HZy9PCrkWLrA7QAxOb8h4hHAPjY7J06oMpibB50RkMN9Lrj7PXSWsnI4xL4uxyLNdlcc9zrqpGRk9ayg64w9ewtCZJFPvIAgFjILsnjLmnYofy88HaqenmSs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Nox1hTRl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Nox1hTRl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0D72C116C6;
	Thu,  8 Jan 2026 18:10:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1767895839;
	bh=eHOPHpG+NeKnH5pdIwj/CAqXHYTmbqE3V5WY1f/MIoc=;
	h=Date:To:From:Subject:From;
	b=Nox1hTRlbd+nqWq+XVFyf4aH+gOCasWJyyZmY/HsK6K9NDZQUuAVMwFTxE2pS5z72
	 gU+mL0O51MnntqzBMFwXgwMnlIdU63NahKro18jZhozO4K/4eAGkJNtuFDJmqPsbi4
	 VGwIdDwMVY75bXlXv468Ml0eCo5wRcZAO8iqKVkM=
Date: Thu, 08 Jan 2026 10:10:39 -0800
To: mm-commits@vger.kernel.org,pmladek@suse.com,mhiramat@kernel.org,lance.yang@linux.dev,joel.granados@kernel.org,gregkh@linuxfoundation.org,feng.tang@linux.alibaba.com,atomlin@atomlin.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] hung_task-enable-runtime-reset-of-hung_task_detect_count.patch removed from -mm tree
Message-Id: <20260108181039.A0D72C116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: hung_task: enable runtime reset of hung_task_detect_count
has been removed from the -mm tree.  Its filename was
     hung_task-enable-runtime-reset-of-hung_task_detect_count.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Aaron Tomlin <atomlin@atomlin.com>
Subject: hung_task: enable runtime reset of hung_task_detect_count
Date: Tue, 30 Dec 2025 19:41:25 -0500

Introduce support for writing to /proc/sys/kernel/hung_task_detect_count.

Writing a value of zero to this file atomically resets the counter of
detected hung tasks.  This grants system administrators the ability to
clear the cumulative diagnostic history after resolving an incident,
simplifying monitoring without requiring a system restart.

Link: https://lkml.kernel.org/r/20251231004125.2380105-3-atomlin@atomlin.com
Signed-off-by: Aaron Tomlin <atomlin@atomlin.com>
Acked-by: Lance Yang <lance.yang@linux.dev>
Cc: Feng Tang <feng.tang@linux.alibaba.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Joel Granados <joel.granados@kernel.org>
Cc: "Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Cc: Petr Mladek <pmladek@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/sysctl/kernel.rst |    3 
 kernel/hung_task.c                          |   82 +++++++++++++++---
 2 files changed, 73 insertions(+), 12 deletions(-)

--- a/Documentation/admin-guide/sysctl/kernel.rst~hung_task-enable-runtime-reset-of-hung_task_detect_count
+++ a/Documentation/admin-guide/sysctl/kernel.rst
@@ -418,7 +418,8 @@ hung_task_detect_count
 ======================
 
 Indicates the total number of tasks that have been detected as hung since
-the system boot.
+the system boot or since the counter was reset. The counter is zeroed when
+a value of 0 is written.
 
 This file shows up if ``CONFIG_DETECT_HUNG_TASK`` is enabled.
 
--- a/kernel/hung_task.c~hung_task-enable-runtime-reset-of-hung_task_detect_count
+++ a/kernel/hung_task.c
@@ -17,6 +17,7 @@
 #include <linux/export.h>
 #include <linux/panic_notifier.h>
 #include <linux/sysctl.h>
+#include <linux/atomic.h>
 #include <linux/suspend.h>
 #include <linux/utsname.h>
 #include <linux/sched/signal.h>
@@ -36,7 +37,7 @@ static int __read_mostly sysctl_hung_tas
 /*
  * Total number of tasks detected as hung since boot:
  */
-static unsigned long __read_mostly sysctl_hung_task_detect_count;
+static atomic_long_t sysctl_hung_task_detect_count = ATOMIC_LONG_INIT(0);
 
 /*
  * Limit number of tasks checked in a batch.
@@ -246,20 +247,26 @@ static inline void hung_task_diagnostics
 }
 
 static void check_hung_task(struct task_struct *t, unsigned long timeout,
-		unsigned long prev_detect_count)
+			    unsigned long prev_detect_count)
 {
-	unsigned long total_hung_task;
+	unsigned long total_hung_task, cur_detect_count;
 
 	if (!task_is_hung(t, timeout))
 		return;
 
 	/*
 	 * This counter tracks the total number of tasks detected as hung
-	 * since boot.
+	 * since boot. If a reset occurred during the scan, we treat the
+	 * current count as the new delta to avoid an underflow error.
+	 * Ensure hang details are globally visible before the counter
+	 * update.
 	 */
-	sysctl_hung_task_detect_count++;
+	cur_detect_count = atomic_long_inc_return_release(&sysctl_hung_task_detect_count);
+	if (cur_detect_count >= prev_detect_count)
+		total_hung_task = cur_detect_count - prev_detect_count;
+	else
+		total_hung_task = cur_detect_count;
 
-	total_hung_task = sysctl_hung_task_detect_count - prev_detect_count;
 	trace_sched_process_hang(t);
 
 	if (sysctl_hung_task_panic && total_hung_task >= sysctl_hung_task_panic) {
@@ -318,10 +325,12 @@ static void check_hung_uninterruptible_t
 	int max_count = sysctl_hung_task_check_count;
 	unsigned long last_break = jiffies;
 	struct task_struct *g, *t;
-	unsigned long prev_detect_count = sysctl_hung_task_detect_count;
+	unsigned long cur_detect_count, prev_detect_count, delta;
 	int need_warning = sysctl_hung_task_warnings;
 	unsigned long si_mask = hung_task_si_mask;
 
+	/* Acquire prevents reordering task checks before this point. */
+	prev_detect_count = atomic_long_read_acquire(&sysctl_hung_task_detect_count);
 	/*
 	 * If the system crashed already then all bets are off,
 	 * do not report extra hung tasks:
@@ -346,7 +355,14 @@ static void check_hung_uninterruptible_t
  unlock:
 	rcu_read_unlock();
 
-	if (!(sysctl_hung_task_detect_count - prev_detect_count))
+	/* Ensures we see all hang details recorded during the scan. */
+	cur_detect_count = atomic_long_read_acquire(&sysctl_hung_task_detect_count);
+	if (cur_detect_count < prev_detect_count)
+		delta = cur_detect_count;
+	else
+		delta = cur_detect_count - prev_detect_count;
+
+	if (!delta)
 		return;
 
 	if (need_warning || hung_task_call_panic) {
@@ -371,6 +387,51 @@ static long hung_timeout_jiffies(unsigne
 }
 
 #ifdef CONFIG_SYSCTL
+
+/**
+ * proc_dohung_task_detect_count - proc handler for hung_task_detect_count
+ * @table: Pointer to the struct ctl_table definition for this proc entry
+ * @dir: Flag indicating the operation
+ * @buffer: User space buffer for data transfer
+ * @lenp: Pointer to the length of the data being transferred
+ * @ppos: Pointer to the current file offset
+ *
+ * This handler is used for reading the current hung task detection count
+ * and for resetting it to zero when a write operation is performed using a
+ * zero value only. Returns 0 on success or a negative error code on
+ * failure.
+ */
+static int proc_dohung_task_detect_count(const struct ctl_table *table, int dir,
+					 void *buffer, size_t *lenp, loff_t *ppos)
+{
+	unsigned long detect_count;
+	struct ctl_table proxy_table;
+	int err;
+
+	proxy_table = *table;
+	proxy_table.data = &detect_count;
+
+	if (SYSCTL_KERN_TO_USER(dir)) {
+		detect_count = atomic_long_read(&sysctl_hung_task_detect_count);
+
+		return proc_doulongvec_minmax(&proxy_table, dir, buffer, lenp, ppos);
+	}
+
+	err = proc_doulongvec_minmax(&proxy_table, dir, buffer, lenp, ppos);
+	if (err < 0)
+		return err;
+
+	if (SYSCTL_USER_TO_KERN(dir)) {
+		/* The only valid value for clearing is zero. */
+		if (detect_count)
+			return -EINVAL;
+		atomic_long_set(&sysctl_hung_task_detect_count, 0);
+	}
+
+	*ppos += *lenp;
+	return err;
+}
+
 /*
  * Process updating of timeout sysctl
  */
@@ -451,10 +512,9 @@ static const struct ctl_table hung_task_
 	},
 	{
 		.procname	= "hung_task_detect_count",
-		.data		= &sysctl_hung_task_detect_count,
 		.maxlen		= sizeof(unsigned long),
-		.mode		= 0444,
-		.proc_handler	= proc_doulongvec_minmax,
+		.mode		= 0644,
+		.proc_handler	= proc_dohung_task_detect_count,
 	},
 	{
 		.procname	= "hung_task_sys_info",
_

Patches currently in -mm which might be from atomlin@atomlin.com are

fs-proc-expose-mm_cpumask-in-proc-status.patch

