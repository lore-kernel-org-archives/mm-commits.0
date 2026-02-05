Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D51833C535
	for <mm-commits@vger.kernel.org>; Thu,  5 Feb 2026 23:29:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770334175; cv=none; b=jeukWwuP+eRY/+xM2wWpiAE/EmxNVn+nizfB8c/v8yDW+2T0Khiwm8xeYAyBLqYP/x+oHp1NN15+i6IX7+daoE7q/Q9YTgjOcJ1QHdwQQ6U3+uxbQB1e0aiJ05eflYgPU5lK2n9/1Ls7ozI7Sn6/lIC0yancE2MnSfkVl8ElwqM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770334175; c=relaxed/simple;
	bh=7db9PIagFzV+hlDJM9QuzbtQJ/HB1PSVah/n3Uu7HYU=;
	h=Date:To:From:Subject:Message-Id; b=IUXT5s59H4em77pfDmtp6d4/P3xWmwP3CsfpW95nKZFniWr7yXNI8s8Bw0PybJvcwX9XqB4p2h1vUhaNJnWiy/hqWyAXA/egGhoTyoZedEG+/8buIpy29wOwWNj9U6iul6yDi45DCwdI2SA9adggsjb51tV49WDJ+JjT0YcD+Ms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=nk+l+gQo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="nk+l+gQo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1899EC4CEF7;
	Thu,  5 Feb 2026 23:29:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1770334175;
	bh=7db9PIagFzV+hlDJM9QuzbtQJ/HB1PSVah/n3Uu7HYU=;
	h=Date:To:From:Subject:From;
	b=nk+l+gQo3rorWe5wuf9NY3i+QH+8i5wPcaKmP7dhBVS/yGg9wuTTYVjh0KLjA2E2W
	 lAcUVBj+yLPtW0xm/G/e4FVfV9mxelgMmWHH40dmkqLCBORWoKH4txKNwj+8uofIba
	 RK19RJTF7nJeqB5Eft5E9sQrbjtvHD1aIKERVhlA=
Date: Thu, 05 Feb 2026 15:29:34 -0800
To: mm-commits@vger.kernel.org,pmladek@suse.com,mhiramat@kernel.org,lance.yang@linux.dev,joel.granados@kernel.org,gregkh@linuxfoundation.org,atomlin@atomlin.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] hung_task-explicitly-report-i-o-wait-state-in-log-output.patch removed from -mm tree
Message-Id: <20260205232935.1899EC4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: hung_task: explicitly report I/O wait state in log output
has been removed from the -mm tree.  Its filename was
     hung_task-explicitly-report-i-o-wait-state-in-log-output.patch

This patch was dropped because an updated version will be issued

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


