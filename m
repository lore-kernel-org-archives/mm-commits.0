Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D8872C08A8
	for <mm-commits@vger.kernel.org>; Tue, 16 Dec 2025 03:38:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765856288; cv=none; b=RlEU19FgMH+GRbJRZoCygPR6H6vroERPllRAtOsbcgygNTOB8uU/fKZ0PjUkMeUqeIms0dW7mxr5HhGFUU/bAwYrXourcPOZdOH9Xwkg+B8Zh9bvNd6mWKD8VgRgha94wecfKqEwy7GCFspOvFfJGLh3u+wlhBqq5FdVe7pEGUs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765856288; c=relaxed/simple;
	bh=PWTFs92ibA9is/ygU08inNQtcE1wkGJBPWeuWBMlWpk=;
	h=Date:To:From:Subject:Message-Id; b=GbPyAGYumpda6AfVyqjIc5tH7FSKzwUMdNO2ARjfQVv1+cBSyQJY4cxWnUMZFneCADYwDtgxHEWy4sIlVmsxuKv0/o+1CUlh1NQoAEs+LF/qBqSWmBi71N/XvOqvXULHgtaYPLKd6BWYwMjUm2Fv9vy8i54QDqwZy+NZOuCBo8s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=hpHtGIPO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="hpHtGIPO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79C28C4CEF5;
	Tue, 16 Dec 2025 03:38:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1765856287;
	bh=PWTFs92ibA9is/ygU08inNQtcE1wkGJBPWeuWBMlWpk=;
	h=Date:To:From:Subject:From;
	b=hpHtGIPOLAYgCwqFLpZYNvDmCO/kmOzrH8LACK8hk0VQWHspafmDVNMh9u8XKdZGr
	 eBSS70WCD7S9+4iyKIKi4hnsBd1IbXjQSxFBVoXqqwJ1zcrV22I/VLG7BGMTgY/tLC
	 Yn98xuX7MVre0/AUOOROv5mdDZGNJ09mkboXsi9w=
Date: Mon, 15 Dec 2025 19:38:06 -0800
To: mm-commits@vger.kernel.org,pmladek@suse.com,mhiramat@kernel.org,lance.yang@linux.dev,gregkh@linuxfoundation.org,atomlin@atomlin.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + hung_task-introduce-helper-for-hung-task-warning.patch added to mm-nonmm-unstable branch
Message-Id: <20251216033807.79C28C4CEF5@smtp.kernel.org>
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

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Aaron Tomlin <atomlin@atomlin.com>
Subject: hung_task: introduce helper for hung task warning
Date: Mon, 15 Dec 2025 22:00:35 -0500

Patch series "hung_task: Provide runtime reset interface for hung task
detector", v3.

This series introduces the ability to reset
/proc/sys/kernel/hung_task_detect_count.

Writing any value to this file atomically resets the counter of detected
hung tasks to zero.  This functionality provides system administrators
with the means to clear the cumulative diagnostic history following
incident resolution, thereby simplifying subsequent monitoring without
necessitating a system restart.


This patch (of 2):

Consolidate the multi-line console output block for reporting a hung task
into a new helper function, hung_task_diagnostics().  This improves
readability in the main check_hung_task() loop and makes the diagnostic
output structure easier to maintain and update in the future.

Link: https://lkml.kernel.org/r/20251216030036.1822217-1-atomlin@atomlin.com
Link: https://lkml.kernel.org/r/20251216030036.1822217-2-atomlin@atomlin.com
Signed-off-by: Aaron Tomlin <atomlin@atomlin.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: "Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Cc: Petr Mladek <pmladek@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/hung_task.c |   37 +++++++++++++++++++++++++++----------
 1 file changed, 27 insertions(+), 10 deletions(-)

--- a/kernel/hung_task.c~hung_task-introduce-helper-for-hung-task-warning
+++ a/kernel/hung_task.c
@@ -223,6 +223,32 @@ static inline void debug_show_blocker(st
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
+	const char *coredump_msg = "      Blocked by coredump.";
+	const char *disable_msg =
+		"\"echo 0 > /proc/sys/kernel/hung_task_timeout_secs\""
+		" disables this message.";
+
+	pr_err("INFO: task %s:%d blocked for more than %ld seconds.\n",
+	       t->comm, t->pid, blocked_secs);
+	pr_err("      %s %s %.*s\n",
+	       print_tainted(), init_utsname()->release,
+	       (int)strcspn(init_utsname()->version, " "),
+	       init_utsname()->version);
+	if (t->flags & PF_POSTCOREDUMP)
+		pr_err("%s\n", coredump_msg);
+	pr_err("%s\n", disable_msg);
+}
+
 static void check_hung_task(struct task_struct *t, unsigned long timeout,
 		unsigned long prev_detect_count)
 {
@@ -252,16 +278,7 @@ static void check_hung_task(struct task_
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

hung_task-introduce-helper-for-hung-task-warning.patch
hung_task-enable-runtime-reset-of-hung_task_detect_count.patch

