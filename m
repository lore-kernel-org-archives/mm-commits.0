Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91FC230F522
	for <mm-commits@vger.kernel.org>; Mon, 17 Nov 2025 17:52:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763401971; cv=none; b=tGjtcXcNCB07o12FN1EfxHDjYIkMnekeqARY/aabjT1bENeYr5p5XcvX+6saNLUfPTkmGTJzNHXtrZ7OgGWF4+rAdy/5Zk/+IvjlpRM70AdQ+hj5LXbCwmzhzK53YPl360bbp0KjzckUACpe3NRJeoIvM8vRd50G6Wfui4GHw0A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763401971; c=relaxed/simple;
	bh=M0l0pkIqeqIFoSnuJumHydQtRDayqHepxxVqiDQkPN8=;
	h=Date:To:From:Subject:Message-Id; b=ugbGc8znndoRMOCWQc5KujQwMbWimDb4nJyd8Gi+88vpxRHcK9/vb1pZEqLicsyvSruJ5Vxy38/z6TT3WFHFDp9ZYdcOlfHZx7xSRLwZjq2ohTkZkjYjmT1g29KvjAqWTxocP39SHiTlHE5AWTuDSyNvBBINVnEqnsTUiJat2h4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=wUrikv6+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="wUrikv6+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00562C2BCB8;
	Mon, 17 Nov 2025 17:52:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763401971;
	bh=M0l0pkIqeqIFoSnuJumHydQtRDayqHepxxVqiDQkPN8=;
	h=Date:To:From:Subject:From;
	b=wUrikv6+BJ0cBg7hR9pu36M19SnqRFYwy/aOSFWoPxp6kXbrA4Nbq83fP6B/9IACW
	 79Bdc6uhan8rg2wfH8uFAHsrQCkFoCdyBx3BvY7BCf5lEQcnFLWMAR4IeuDBS14VWZ
	 HGKDB5OXdzNYAf6xtPi4R8NCAtB1IdNDg0Z1nP9o=
Date: Mon, 17 Nov 2025 09:52:49 -0800
To: mm-commits@vger.kernel.org,rostedt@goodmis.org,pmladek@suse.com,paulmck@kernel.org,ioworker0@gmail.com,corbet@lwn.net,feng.tang@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + hung_task-add-hung_task_sys_info-sysctl-to-dump-sys-info-on-task-hung-fix.patch added to mm-nonmm-unstable branch
Message-Id: <20251117175251.00562C2BCB8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: hung_task-add-hung_task_sys_info-sysctl-to-dump-sys-info-on-task-hung-fix
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     hung_task-add-hung_task_sys_info-sysctl-to-dump-sys-info-on-task-hung-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/hung_task-add-hung_task_sys_info-sysctl-to-dump-sys-info-on-task-hung-fix.patch

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
From: Feng Tang <feng.tang@linux.alibaba.com>
Subject: hung_task-add-hung_task_sys_info-sysctl-to-dump-sys-info-on-task-hung-fix
Date: Wed, 5 Nov 2025 19:30:36 +0800

maintain consistecy established behavior, per Lance and Petr

Link: https://lkml.kernel.org/r/aRncJo1mA5Zk77Hr@U-2FWC9VHC-2323.local
Suggested-by: Petr Mladek <pmladek@suse.com>
Signed-off-by: Feng Tang <feng.tang@linux.alibaba.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Lance Yang <ioworker0@gmail.com>
Cc: "Paul E . McKenney" <paulmck@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/hung_task.c |   24 +++++++++++++-----------
 1 file changed, 13 insertions(+), 11 deletions(-)

--- a/kernel/hung_task.c~hung_task-add-hung_task_sys_info-sysctl-to-dump-sys-info-on-task-hung-fix
+++ a/kernel/hung_task.c
@@ -223,8 +223,11 @@ static inline void debug_show_blocker(st
 }
 #endif
 
-static void check_hung_task(struct task_struct *t, unsigned long timeout)
+static void check_hung_task(struct task_struct *t, unsigned long timeout,
+		unsigned long prev_detect_count)
 {
+	unsigned long total_hung_task;
+
 	if (!task_is_hung(t, timeout))
 		return;
 
@@ -234,13 +237,19 @@ static void check_hung_task(struct task_
 	 */
 	sysctl_hung_task_detect_count++;
 
+	total_hung_task = sysctl_hung_task_detect_count - prev_detect_count;
 	trace_sched_process_hang(t);
 
+	if (sysctl_hung_task_panic && total_hung_task >= sysctl_hung_task_panic) {
+		console_verbose();
+		hung_task_call_panic = true;
+	}
+
 	/*
 	 * Ok, the task did not get scheduled for more than 2 minutes,
 	 * complain:
 	 */
-	if (sysctl_hung_task_warnings) {
+	if (sysctl_hung_task_warnings || hung_task_call_panic) {
 		if (sysctl_hung_task_warnings > 0)
 			sysctl_hung_task_warnings--;
 		pr_err("INFO: task %s:%d blocked for more than %ld seconds.\n",
@@ -295,7 +304,6 @@ static void check_hung_uninterruptible_t
 {
 	int max_count = sysctl_hung_task_check_count;
 	unsigned long last_break = jiffies;
-	unsigned long total_hung_task;
 	struct task_struct *g, *t;
 	unsigned long prev_detect_count = sysctl_hung_task_detect_count;
 	int need_warning = sysctl_hung_task_warnings;
@@ -320,20 +328,14 @@ static void check_hung_uninterruptible_t
 			last_break = jiffies;
 		}
 
-		check_hung_task(t, timeout);
+		check_hung_task(t, timeout, prev_detect_count);
 	}
  unlock:
 	rcu_read_unlock();
 
-	total_hung_task = sysctl_hung_task_detect_count - prev_detect_count;
-	if (!total_hung_task)
+	if (!(sysctl_hung_task_detect_count - prev_detect_count))
 		return;
 
-	if (sysctl_hung_task_panic && total_hung_task >= sysctl_hung_task_panic) {
-		console_verbose();
-		hung_task_call_panic = true;
-	}
-
 	if (need_warning || hung_task_call_panic) {
 		si_mask |= SYS_INFO_LOCKS;
 
_

Patches currently in -mm which might be from feng.tang@linux.alibaba.com are

docs-panic-correct-some-sys_ifo-names-in-sysctl-doc.patch
hung_task-add-hung_task_sys_info-sysctl-to-dump-sys-info-on-task-hung.patch
hung_task-add-hung_task_sys_info-sysctl-to-dump-sys-info-on-task-hung-fix.patch
watchdog-add-sys_info-sysctls-to-dump-sys-info-on-system-lockup.patch
sys_info-add-a-default-kernel-sys_info-mask.patch

