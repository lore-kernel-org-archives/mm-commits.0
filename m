Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E77E524B24E
	for <mm-commits@vger.kernel.org>; Fri, 10 Jan 2025 23:29:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736551780; cv=none; b=Vv35iaoJ6Pld2TxAlRv2v/1kKBsVdywXy4Q0ip+B7AskAi7VMLk/89sf9vdlpiBtMnpEYvFFVYPXWnv7m78gLTXXyTTdi1jGL+4fgAO+DtqrZ/e7UGfA417BJV2eDWx6Do204yUO4uWx0xq37zFkbgY+od8kNxntEvBQT7w18mY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736551780; c=relaxed/simple;
	bh=v2zS8R++QKgj6tqpoRwD3pXllStRw69A7sLx9KxVAKk=;
	h=Date:To:From:Subject:Message-Id; b=Bn7ufJQARC8HiPewvMqtdRSd9MGM1X1oByqEsb8RGlIaMWlrWhbeUloByueLwS23H/jBKNzNxleVYlt2AdnUFtBn+14Uk7UEs6483rqjZavyeqkYrpbNx20ZsVx+9PJ26ZcoHgIrQqYUHkkCe34eVke5p8GYYfSu0ye/YcIXEKA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=efLa5q5o; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="efLa5q5o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FFABC4CED6;
	Fri, 10 Jan 2025 23:29:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736551779;
	bh=v2zS8R++QKgj6tqpoRwD3pXllStRw69A7sLx9KxVAKk=;
	h=Date:To:From:Subject:From;
	b=efLa5q5owD2AjYB3Jw/5BOW9Pt3nrT2bBYG7lv6q5Wgj69FFKNIeqTC6DNYRL/I/h
	 hf3x4OX24jhdtNZfVFpN4CbS9wzoDPBabnoq6YMssWtTwaA/tNyeo5e7N3EmAFSk4a
	 Qnv10C1RgzhsX35+E/+YfXtlvEUMIotAybdJtCQ8=
Date: Fri, 10 Jan 2025 15:29:38 -0800
To: mm-commits@vger.kernel.org,vschneid@redhat.com,viro@zeniv.linux.org.uk,vincent.guittot@linaro.org,rostedt@goodmis.org,peterz@infradead.org,mingo@redhat.com,mgorman@suse.de,juri.lelli@redhat.com,jack@suse.cz,dietmar.eggemann@arm.com,bsegall@google.com,brauner@kernel.org,oxana@cloudflare.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + hung_task-add-task-flags-blocked-by-coredump-to-log.patch added to mm-nonmm-unstable branch
Message-Id: <20250110232939.3FFABC4CED6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: hung_task: add task->flags, blocked by coredump to log
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     hung_task-add-task-flags-blocked-by-coredump-to-log.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/hung_task-add-task-flags-blocked-by-coredump-to-log.patch

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
From: Oxana Kharitonova <oxana@cloudflare.com>
Subject: hung_task: add task->flags, blocked by coredump to log
Date: Fri, 10 Jan 2025 16:03:28 +0000

Resending this patch as I haven't received feedback on my initial
submission https://lore.kernel.org/all/20241204182953.10854-1-oxana@cloudflare.com/

For the processes which are terminated abnormally the kernel can provide
a coredump if enabled. When the coredump is performed, the process and
all its threads are put into the D state
(TASK_UNINTERRUPTIBLE | TASK_FREEZABLE).

On the other hand, we have kernel thread khungtaskd which monitors the
processes in the D state. If the task stuck in the D state more than
kernel.hung_task_timeout_secs, the hung_task alert appears in the kernel
log.

The higher memory usage of a process, the longer it takes to create
coredump, the longer tasks are in the D state. We have hung_task alerts
for the processes with memory usage above 10Gb. Although, our
kernel.hung_task_timeout_secs is 10 sec when the default is 120 sec.

Adding additional information to the log that the task is blocked by
coredump will help with monitoring. Another approach might be to
completely filter out alerts for such tasks, but in that case we would
lose transparency about what is putting pressure on some system
resources, e.g. we saw an increase in I/O when coredump occurs due its
writing to disk.

Additionally, it would be helpful to have task_struct->flags in the log
from the function sched_show_task(). Currently it prints
task_struct->thread_info->flags, this seems misleading as the line
starts with "task:xxxx".

Link: https://lkml.kernel.org/r/20250110160328.64947-1-oxana@cloudflare.com
Signed-off-by: Oxana Kharitonova <oxana@cloudflare.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Ben Segall <bsegall@google.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Dietmar Eggemann <dietmar.eggemann@arm.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Juri Lelli <juri.lelli@redhat.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Valentin Schneider <vschneid@redhat.com>
Cc: Vincent Guittot <vincent.guittot@linaro.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/hung_task.c  |    2 ++
 kernel/sched/core.c |    4 ++--
 2 files changed, 4 insertions(+), 2 deletions(-)

--- a/kernel/hung_task.c~hung_task-add-task-flags-blocked-by-coredump-to-log
+++ a/kernel/hung_task.c
@@ -147,6 +147,8 @@ static void check_hung_task(struct task_
 			print_tainted(), init_utsname()->release,
 			(int)strcspn(init_utsname()->version, " "),
 			init_utsname()->version);
+		if (t->flags & PF_POSTCOREDUMP)
+			pr_err("      Blocked by coredump.\n");
 		pr_err("\"echo 0 > /proc/sys/kernel/hung_task_timeout_secs\""
 			" disables this message.\n");
 		sched_show_task(t);
--- a/kernel/sched/core.c~hung_task-add-task-flags-blocked-by-coredump-to-log
+++ a/kernel/sched/core.c
@@ -7701,9 +7701,9 @@ void sched_show_task(struct task_struct
 	if (pid_alive(p))
 		ppid = task_pid_nr(rcu_dereference(p->real_parent));
 	rcu_read_unlock();
-	pr_cont(" stack:%-5lu pid:%-5d tgid:%-5d ppid:%-6d flags:0x%08lx\n",
+	pr_cont(" stack:%-5lu pid:%-5d tgid:%-5d ppid:%-6d task_flags:0x%08lx flags:0x%08lx\n",
 		free, task_pid_nr(p), task_tgid_nr(p),
-		ppid, read_task_thread_flags(p));
+		ppid, p->flags, read_task_thread_flags(p));
 
 	print_worker_info(KERN_INFO, p);
 	print_stop_info(KERN_INFO, p);
_

Patches currently in -mm which might be from oxana@cloudflare.com are

hung_task-add-task-flags-blocked-by-coredump-to-log.patch

