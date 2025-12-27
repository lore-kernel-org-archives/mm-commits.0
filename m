Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDE4D1C84AB
	for <mm-commits@vger.kernel.org>; Thu,  1 Jan 2026 02:48:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767235713; cv=none; b=ZZ98PAlo//9cBr92Wk1RfEg9ANBsYylENg9XZzoP+AIOt8RpYLlPeKgNiuV82y0jxrnK38WcfRjiWxlDCYR6CRcvlXwApC3XSsEfHlKx0xNUktA08heCPnCSo2QXQOuvfFB587yVXEA9dbcwH8SB4cyzRmVEJR93lFV1P969ZJA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767235713; c=relaxed/simple;
	bh=y4AaWjLvfA+pKiWJ2xMU+1Ggn01e7HqjvghsPMr0bAM=;
	h=Date:To:From:Subject:Message-Id; b=ogQBE3tpv4BoDgXeoJc+CuLh7EBHtJpxjfloc5liT/ty0QiG8gGrJYcrY7GdOSUExTDS/T9T92ium3HVwMFd9Eq9ad7gvkslmq6wrqRQep6YtgXj6Gx+KluHqEEaBNBiPnbWIXwSnLUBWR+ebB/ZrmWus7/0+G5OJAPpm5aM+YM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=kvIs2Umn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="kvIs2Umn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 232C0C113D0;
	Thu,  1 Jan 2026 02:48:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1767235713;
	bh=y4AaWjLvfA+pKiWJ2xMU+1Ggn01e7HqjvghsPMr0bAM=;
	h=Date:To:From:Subject:From;
	b=kvIs2Umn2SzAbp7pZlzPr2LqKuVtbFjH/GDNz4BH/jEdCKXl5LPqaUNe3Pvpj/FdS
	 vXa73Uhd+kBFtBtk8XoyMaUPYcTEmkehG7zHRZG4jWYpTPh/AU6O+d+M9E6uDbwL/O
	 pbOkp2XxY9B/QIYZolR13ggB381EdKnTyqaeGYeg=
Date: Wed, 31 Dec 2025 18:48:32 +9900
To: mm-commits@vger.kernel.org,pmladek@suse.com,mhiramat@kernel.org,lance.yang@linux.dev,joel.granados@kernel.org,gregkh@linuxfoundation.org,feng.tang@linux.alibaba.com,atomlin@atomlin.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + hung_task-introduce-helper-for-hung-task-warning.patch added to mm-nonmm-unstable branch
Message-Id: <20260101024833.232C0C113D0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: hung_task: introduce helper for hung task warning
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     hung_task-introduce-helper-for-hung-task-warning.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/hung_task-introduce-helper-for-hung-task-warning.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
hung_task-introduce-helper-for-hung-task-warning.patch
hung_task-enable-runtime-reset-of-hung_task_detect_count.patch
hung_task-provide-runtime-reset-interface-for-hung-task-detector.patch

