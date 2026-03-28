Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC39733557B
	for <mm-commits@vger.kernel.org>; Sat, 28 Mar 2026 04:25:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774671920; cv=none; b=QJtXb7MQlSkmfQMM2In35/LAHbac5M8YFE0x6Ckbqy2uuf1fEsbzOgUgN30n7Qo+y2OKdhNR6EBMUKqTYwO04Cn1lYAeu6oTWsXvGUe+n4G7KXYplRThYrxJoNal7CGz0BGLX8fDUhv5REphva0DcIm1Vo/lAOWpcrtseNWzJs0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774671920; c=relaxed/simple;
	bh=CCh5XNbjjRsYJtPMN65h5DS8nWjb/5G1/5IOJxvDfSo=;
	h=Date:To:From:Subject:Message-Id; b=gj+QkJknOx9tuvyrHRn9H+ZVxCOVbT0P05p7tyTUwOUDajUymFu5DQLtpni2kfHeoKzJ3wNchPJVrnD0n9CzGtkpFW3HlpKuueyyKlg6lXtJF67DDQ5uvBRiYPvxVb3Ugnh4eCO8amwCvl42Lw9Qk1u84v+RFhy5vb7Gvi6o5Y4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=BQb6Sr4G; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="BQb6Sr4G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66CC6C4CEF7;
	Sat, 28 Mar 2026 04:25:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774671920;
	bh=CCh5XNbjjRsYJtPMN65h5DS8nWjb/5G1/5IOJxvDfSo=;
	h=Date:To:From:Subject:From;
	b=BQb6Sr4GjRQnOMgE3ck/edRVtvtQG+nqqKXSOaRIy3eIRo0cSfBNDClb5j/L8xzZB
	 kXKSZiyJZPN+bFhGYNUw/otXIkOk25DQnNIhpPzQmYkhkZC7hcxIeEKHEj32FYNid7
	 edNy7S9/+tnmjNg/GPIW0Jx8JrR5j98LeFk2yBbs=
Date: Fri, 27 Mar 2026 21:25:19 -0700
To: mm-commits@vger.kernel.org,pmladek@suse.com,mhiramat@kernel.org,lance.yang@linux.dev,gregkh@linuxfoundation.org,atomlin@atomlin.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] hung_task-explicitly-report-i-o-wait-state-in-log-output.patch removed from -mm tree
Message-Id: <20260328042520.66CC6C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: hung_task: explicitly report I/O wait state in log output
has been removed from the -mm tree.  Its filename was
     hung_task-explicitly-report-i-o-wait-state-in-log-output.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


