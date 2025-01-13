Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 582F417D355
	for <mm-commits@vger.kernel.org>; Mon, 13 Jan 2025 04:24:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736742271; cv=none; b=PrtIn5yAjbxxoibwaPHJDallBx7Ta8Qd13fIj2SNX3TA8eboiYyg/+33c4pLS0Z9Btf61PyHyvCwxXI8veiCw8+kJ2j/OMvrZN1VfT0YIdKeCgamBp4OnXK61pkD5r8JaCRZ58SMnkKIjytelLWg7M1ctmsgDnnd6EN1zlJ81CM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736742271; c=relaxed/simple;
	bh=tC82HpsqOYPQLQJIUg0smai2hpmkDyZ53axunT8eEaU=;
	h=Date:To:From:Subject:Message-Id; b=H0US+2xPnt0oNFeHQ2I4i9ZeucrgQSH9sdliSorxtT/xbhosMOkXrJzUsJk7s2ipoEqSlV2TrzKb8b0Gic8J1AbaJt9SWz1gpb2hJjJ0ru/U8ZRXL2HxmruV72OYd5ibseLnZgxe9gC8kpSpmiqotNBmE/WOyIIt1BzSZfa9NME=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=muV7q6mH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="muV7q6mH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24067C4CED6;
	Mon, 13 Jan 2025 04:24:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736742271;
	bh=tC82HpsqOYPQLQJIUg0smai2hpmkDyZ53axunT8eEaU=;
	h=Date:To:From:Subject:From;
	b=muV7q6mHOOjcWMsaIURrDk705faSNYGLD6gbgQVc0oz4fCL7+wtTl+QefrEKYyyvJ
	 7vD6qJ/6NkhsQTjz9UHzS/f4sUdeHEuw9r5naNK5jDV1czjetTeppFI9Sa0YU0B/tO
	 pTLO0N4O2lZHAK26rsORzukCRu38arfrzCeCj9Jw=
Date: Sun, 12 Jan 2025 20:24:30 -0800
To: mm-commits@vger.kernel.org,vschneid@redhat.com,viro@zeniv.linux.org.uk,vincent.guittot@linaro.org,rostedt@goodmis.org,peterz@infradead.org,mingo@redhat.com,mgorman@suse.de,juri.lelli@redhat.com,jack@suse.cz,dietmar.eggemann@arm.com,bsegall@google.com,brauner@kernel.org,oxana@cloudflare.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] hung_task-add-task-flags-blocked-by-coredump-to-log.patch removed from -mm tree
Message-Id: <20250113042431.24067C4CED6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: hung_task: add task->flags, blocked by coredump to log
has been removed from the -mm tree.  Its filename was
     hung_task-add-task-flags-blocked-by-coredump-to-log.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

[akpm@linux-foundation.org: fix printk control string]
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
+	pr_cont(" stack:%-5lu pid:%-5d tgid:%-5d ppid:%-6d task_flags:0x%04x flags:0x%08lx\n",
 		free, task_pid_nr(p), task_tgid_nr(p),
-		ppid, read_task_thread_flags(p));
+		ppid, p->flags, read_task_thread_flags(p));
 
 	print_worker_info(KERN_INFO, p);
 	print_stop_info(KERN_INFO, p);
_

Patches currently in -mm which might be from oxana@cloudflare.com are


