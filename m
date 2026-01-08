Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E3DC23D7CE
	for <mm-commits@vger.kernel.org>; Thu,  8 Jan 2026 18:10:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767895838; cv=none; b=F5AofwQjTZyXg/oEol5sDLgwxoe3Mt2EzpHYivmFSALFfPfS3oniFDQpup0+4FmO2Se1/K4d2IaOJ2hXRqFQHVJJX41VHDwdZ920q7weFpu/rZlSus09tHJZg2bHvb+vie/Y3XZNNdbMkdd/NzDYPT0r3RN+2Mcx3jUueJvG0E4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767895838; c=relaxed/simple;
	bh=JGzu4oue9a8MH76lPGTPX24revDbeFN7d/sKJg889AE=;
	h=Date:To:From:Subject:Message-Id; b=ewXZB2Y/5igdMW4EuoK+J6QNwykndSqY6vlb0BcRZKXgXu3rhF22i5lrPFMsSQhjJrK3IDAE0boSTAyhueJhwYKX/OU6QUbHXClMXv8hXn28zpyp61VHk6em2PeU8ms/q21n3FI8PFvkny1zead+7QyOrsfjt+51owDRuJguscg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=kp5sGoTo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="kp5sGoTo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23B13C116C6;
	Thu,  8 Jan 2026 18:10:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1767895838;
	bh=JGzu4oue9a8MH76lPGTPX24revDbeFN7d/sKJg889AE=;
	h=Date:To:From:Subject:From;
	b=kp5sGoTo1Gwf17sGXQaNsi6qO0wcFD0ctoIDzRXP4GyO20RY3/wY9cueRc7QGuu7q
	 IHHXXoZv4HeiOBGnzOAY0RNhchmTvgQkA6+XQ5Prw3qQBspS9lWR1QH8Lu2QizrS8y
	 8wdhqpnmKFXy/CF9duJN654ZI/4Vuxa3eb/BHpAk=
Date: Thu, 08 Jan 2026 10:10:37 -0800
To: mm-commits@vger.kernel.org,pmladek@suse.com,mhiramat@kernel.org,lance.yang@linux.dev,joel.granados@kernel.org,gregkh@linuxfoundation.org,feng.tang@linux.alibaba.com,atomlin@atomlin.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] hung_task-introduce-helper-for-hung-task-warning.patch removed from -mm tree
Message-Id: <20260108181038.23B13C116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: hung_task: introduce helper for hung task warning
has been removed from the -mm tree.  Its filename was
     hung_task-introduce-helper-for-hung-task-warning.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Aaron Tomlin <atomlin@atomlin.com>
Subject: hung_task: introduce helper for hung task warning
Date: Tue, 30 Dec 2025 19:41:24 -0500

Patch series "hung_task: Provide runtime reset interface for hung task
detector", v5.

This series introduces the ability to reset
/proc/sys/kernel/hung_task_detect_count.

Writing a zero value to this file atomically resets the counter of
detected hung tasks.  This functionality provides system administrators
with the means to clear the cumulative diagnostic history following
incident resolution, thereby simplifying subsequent monitoring without
necessitating a system restart.

The implementation uses atomic acquire/release semantics to ensure that
diagnostic metadata published by one CPU is correctly observed by the
monitoring thread on another CPU.


This patch (of 2):

Consolidate the multi-line console output block for reporting a hung task
into a new helper function, hung_task_diagnostics().  This improves
readability in the main check_hung_task() loop and makes the diagnostic
output structure easier to maintain and update in the future.

Link: https://lkml.kernel.org/r/20251231004125.2380105-1-atomlin@atomlin.com
Link: https://lkml.kernel.org/r/20251231004125.2380105-2-atomlin@atomlin.com
Signed-off-by: Aaron Tomlin <atomlin@atomlin.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Joel Granados <joel.granados@kernel.org>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: "Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Cc: Petr Mladek <pmladek@suse.com>
Cc: Feng Tang <feng.tang@linux.alibaba.com>
Cc: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/hung_task.c |   33 +++++++++++++++++++++++----------
 1 file changed, 23 insertions(+), 10 deletions(-)

--- a/kernel/hung_task.c~hung_task-introduce-helper-for-hung-task-warning
+++ a/kernel/hung_task.c
@@ -223,6 +223,28 @@ static inline void debug_show_blocker(st
 }
 #endif
 
+/**
+ * hung_task_diagnostics - Print structured diagnostic info for a hung task.
+ * @t: Pointer to the detected hung task.
+ *
+ * This function consolidates the printing of core diagnostic information
+ * for a task found to be blocked.
+ */
+static inline void hung_task_diagnostics(struct task_struct *t)
+{
+	unsigned long blocked_secs = (jiffies - t->last_switch_time) / HZ;
+
+	pr_err("INFO: task %s:%d blocked for more than %ld seconds.\n",
+	       t->comm, t->pid, blocked_secs);
+	pr_err("      %s %s %.*s\n",
+	       print_tainted(), init_utsname()->release,
+	       (int)strcspn(init_utsname()->version, " "),
+	       init_utsname()->version);
+	if (t->flags & PF_POSTCOREDUMP)
+		pr_err("      Blocked by coredump.\n");
+	pr_err("\"echo 0 > /proc/sys/kernel/hung_task_timeout_secs\" disables this message.\n");
+}
+
 static void check_hung_task(struct task_struct *t, unsigned long timeout,
 		unsigned long prev_detect_count)
 {
@@ -252,16 +274,7 @@ static void check_hung_task(struct task_
 	if (sysctl_hung_task_warnings || hung_task_call_panic) {
 		if (sysctl_hung_task_warnings > 0)
 			sysctl_hung_task_warnings--;
-		pr_err("INFO: task %s:%d blocked for more than %ld seconds.\n",
-		       t->comm, t->pid, (jiffies - t->last_switch_time) / HZ);
-		pr_err("      %s %s %.*s\n",
-			print_tainted(), init_utsname()->release,
-			(int)strcspn(init_utsname()->version, " "),
-			init_utsname()->version);
-		if (t->flags & PF_POSTCOREDUMP)
-			pr_err("      Blocked by coredump.\n");
-		pr_err("\"echo 0 > /proc/sys/kernel/hung_task_timeout_secs\""
-			" disables this message.\n");
+		hung_task_diagnostics(t);
 		sched_show_task(t);
 		debug_show_blocker(t, timeout);
 
_

Patches currently in -mm which might be from atomlin@atomlin.com are

fs-proc-expose-mm_cpumask-in-proc-status.patch
hung_task-enable-runtime-reset-of-hung_task_detect_count.patch

