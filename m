Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC0B32512C8
	for <mm-commits@vger.kernel.org>; Wed,  4 Mar 2026 02:10:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772590234; cv=none; b=BspaDqbk8HAmv1Fl0Ctu1yMrs3NnLjexFq1txStCC9YSiK4aA56gDm7bFdam+5k6gx9QsOFJ8cCzC5zLjOgZptKgkvjPvKbVkjV0/1Zt1nJMzrlRlKE1YlXZd5Ij74STnWnnyJ5Neuqd8EZBW9I7nAy+Tmj57+5Xctj3ITsZMH8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772590234; c=relaxed/simple;
	bh=CuoRni4ua0kJF5SakzLwn3ZFXLpih9ssMQfD6M03WZA=;
	h=Date:To:From:Subject:Message-Id; b=Mg+vpJ/hbUyzgSY1YZMQLUqxAj0ahspAKwUZOicEc3iiWpi8PBjSbrWtqsPBqOVYymBOaPusgX+IIzjlAM43et1wnApvB+TzOL0Y16EXbAsFKOTgsN6Xqo0dHy9jU1NIYQ7iNSIevAbxzrlwq7/mZkUePVKQduji7kRGIgUqqpA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=yR9g9zaW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="yR9g9zaW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51BB1C116C6;
	Wed,  4 Mar 2026 02:10:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1772590234;
	bh=CuoRni4ua0kJF5SakzLwn3ZFXLpih9ssMQfD6M03WZA=;
	h=Date:To:From:Subject:From;
	b=yR9g9zaW2C4mtnE8PSj8tKFAFhJk5FFJKvfIrYSAk2TEBhm4zGcCSUeCSyFcRJqID
	 JjCMZi8aGY9RuKr2BwRt5YcKlaolZBsiSTto005FocJN5AwxNjV2HPumLRSPrVg+OT
	 /A0JgLJnuSlUfaxxNV95TEO6FtVcZnD2mSzFwGRY=
Date: Tue, 03 Mar 2026 18:10:33 -0800
To: mm-commits@vger.kernel.org,pmladek@suse.com,mhiramat@kernel.org,lance.yang@linux.dev,gregkh@linuxfoundation.org,atomlin@atomlin.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + hung_task-explicitly-report-i-o-wait-state-in-log-output.patch added to mm-nonmm-unstable branch
Message-Id: <20260304021034.51BB1C116C6@smtp.kernel.org>
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
Date: Tue, 3 Mar 2026 17:13:24 -0500

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

Theoretically, concurrent executions of io_schedule_finish() could result
in a race condition where the read flag does not precisely correlate with
the subsequently printed backtrace.  However, this limitation is deemed
acceptable in practice.  The entire reporting mechanism is inherently racy
by design; nevertheless, it remains highly reliable in the vast majority
of cases, particularly because it primarily captures protracted stalls. 
Consequently, introducing additional synchronisation to mitigate this
minor inaccuracy would be entirely disproportionate to the situation.

Link: https://lkml.kernel.org/r/20260303221324.4106917-1-atomlin@atomlin.com
Signed-off-by: Aaron Tomlin <atomlin@atomlin.com>
Acked-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Reviewed-by: Petr Mladek <pmladek@suse.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Lance Yang <lance.yang@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/hung_task.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/kernel/hung_task.c~hung_task-explicitly-report-i-o-wait-state-in-log-output
+++ a/kernel/hung_task.c
@@ -250,8 +250,9 @@ static void hung_task_info(struct task_s
 	if (sysctl_hung_task_warnings || hung_task_call_panic) {
 		if (sysctl_hung_task_warnings > 0)
 			sysctl_hung_task_warnings--;
-		pr_err("INFO: task %s:%d blocked for more than %ld seconds.\n",
-		       t->comm, t->pid, (jiffies - t->last_switch_time) / HZ);
+		pr_err("INFO: task %s:%d blocked%s for more than %ld seconds.\n",
+		       t->comm, t->pid, t->in_iowait ? " in I/O wait" : "",
+		       (jiffies - t->last_switch_time) / HZ);
 		pr_err("      %s %s %.*s\n",
 			print_tainted(), init_utsname()->release,
 			(int)strcspn(init_utsname()->version, " "),
_

Patches currently in -mm which might be from atomlin@atomlin.com are

hung_task-refactor-detection-logic-and-atomicise-detection-count.patch
hung_task-enable-runtime-reset-of-hung_task_detect_count.patch
hung_task-explicitly-report-i-o-wait-state-in-log-output.patch

