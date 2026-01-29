Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AC542F746D
	for <mm-commits@vger.kernel.org>; Thu, 29 Jan 2026 23:31:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769729465; cv=none; b=dHZIl2afzL/fYHs+4H5ea2J8CXWurYABAc5Dki/WsKl7xXcdRXugoQntgY3RG1UvaYspX9JLti2xpscefdrsQr4lV6V8R3ZEQm4jEyf83XIB/04EEv8ZiyiYGFXIjanCT0CPJ21NAF0kMwqIzTtiTwvF/V/FIMdbxmKIGFweEbg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769729465; c=relaxed/simple;
	bh=QBEu6QAugQM3Wq2KdbNdMaVOWAiwwip811obhzS49b4=;
	h=Date:To:From:Subject:Message-Id; b=uCp1KGTgE4ztbh1pw+I32eV7ZweFnc/r2XfsWwYJ8tXhS1YXUoQSJ78+rUUt8/acr5yOaubR8eBsev+U2XFmbThsoC1vgkRJLKihm+XagRKp2hxKfDeEV7tAhqPY8X8ezTYF7LXzje6id5yteRKn14pxUcLrAP+VthU10Pgiz2I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=WtWYGDgr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="WtWYGDgr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FA21C4CEF7;
	Thu, 29 Jan 2026 23:31:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769729464;
	bh=QBEu6QAugQM3Wq2KdbNdMaVOWAiwwip811obhzS49b4=;
	h=Date:To:From:Subject:From;
	b=WtWYGDgraEXA81THUVslQR2PY1rDyRuQT0FMVrO2N2TmchCu4AuO9D4g9ZwYAr5TJ
	 rCsBT+cIHPlP2QS5xwxgKZT+Xc3QfGSmG9OCtP5T7ZChJZ36lvgSC4tn9hG5S+mEoy
	 Pz5EWJgoqeg4tVjkexsHw5CSn9bO890ObNAXAnV0=
Date: Thu, 29 Jan 2026 15:31:03 -0800
To: mm-commits@vger.kernel.org,pmladek@suse.com,mhiramat@kernel.org,lance.yang@linux.dev,joel.granados@kernel.org,gregkh@linuxfoundation.org,atomlin@atomlin.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + hung_task-explicitly-report-i-o-wait-state-in-log-output.patch added to mm-nonmm-unstable branch
Message-Id: <20260129233104.6FA21C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: hung_task: explicitly report I/O wait state in log output
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     hung_task-explicitly-report-i-o-wait-state-in-log-output.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/hung_task-explicitly-report-i-o-wait-state-in-log-output.patch

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
Subject: hung_task: explicitly report I/O wait state in log output
Date: Wed, 28 Jan 2026 15:45:16 -0500

Currently, the hung task reporting mechanism indiscriminately labels all
TASK_UNINTERRUPTIBLE (D) tasks as "blocked", irrespective of whether they
are awaiting I/O completion or kernel locking primitives.  This ambiguity
compels system administrators to manually inspect stack traces to discern
whether the delay stems from an I/O wait (typically indicative of hardware
or filesystem anomalies) or software contention.  Such detailed analysis
is not always immediately accessible to system administrators or support
engineers.

To address this, this patch utilises the existing in_iowait field within
struct task_struct to augment the failure report.  If the task is blocked
due to I/O (e.g., via io_schedule_prepare()), the log message is updated
to explicitly state "blocked in I/O wait".

Examples:
        - Standard Block: "INFO: task bash:123 blocked for more than 120
          seconds".

        - I/O Block: "INFO: task dd:456 blocked in I/O wait for more than
          120 seconds".

Accessing in_iowait is safe in this context.  The detector holds
rcu_read_lock() within check_hung_uninterruptible_tasks(), ensuring the
task structure remains valid in memory.  Furthermore, as the task is
confirmed to be in a persistent TASK_UNINTERRUPTIBLE state, it cannot
modify its own in_iowait flag, rendering the read operation stable and
free from data races.

Link: https://lkml.kernel.org/r/20260128204516.3473709-2-atomlin@atomlin.com
Signed-off-by: Aaron Tomlin <atomlin@atomlin.com>
Acked-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Joel Granados <joel.granados@kernel.org>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Petr Mladek <pmladek@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/hung_task.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/kernel/hung_task.c~hung_task-explicitly-report-i-o-wait-state-in-log-output
+++ a/kernel/hung_task.c
@@ -252,8 +252,9 @@ static void check_hung_task(struct task_
 	if (sysctl_hung_task_warnings || hung_task_call_panic) {
 		if (sysctl_hung_task_warnings > 0)
 			sysctl_hung_task_warnings--;
-		pr_err("INFO: task %s:%d blocked for more than %ld seconds.\n",
-		       t->comm, t->pid, (jiffies - t->last_switch_time) / HZ);
+		pr_err("INFO: task %s:%d blocked %s for more than %ld seconds.\n",
+		       t->comm, t->pid, t->in_iowait ? "in I/O wait" : "",
+		       (jiffies - t->last_switch_time) / HZ);
 		pr_err("      %s %s %.*s\n",
 			print_tainted(), init_utsname()->release,
 			(int)strcspn(init_utsname()->version, " "),
_

Patches currently in -mm which might be from atomlin@atomlin.com are

hung_task-explicitly-report-i-o-wait-state-in-log-output.patch

