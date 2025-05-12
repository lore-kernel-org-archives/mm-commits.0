Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26C9D2EB10
	for <mm-commits@vger.kernel.org>; Mon, 12 May 2025 00:55:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747011339; cv=none; b=XFmF3Att+wruJSLUj2puIeZcliqPX4N7Unvc0QoQ0ClxcsWyV2G8oPwn8iCXF8ak3bENMeOB0PFULizxClaDeccQQGGr8NiuBFGlB239uL3ZcyXG06KHQBpvGZpZ8j73/U2qJl/JyKqWs4dX1wyadozG4ekFLVFt/YNUgFpBdxk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747011339; c=relaxed/simple;
	bh=mRy5KyM2JxPRw8PUtzBOpezz7rM4DCh8KLY+CfUKumA=;
	h=Date:To:From:Subject:Message-Id; b=JRtxh/HCjp06X3OQLzYd288O8JAZEYH4Jjw8cb53AFuRtaGIKFJUlWZ1HVeFJ6hyqHj/la7lj7Jz7ENNMXhKLaClb/sV2WT+FdMk8FHIuGPH+3DhTy/wHjquiQ68D0v1RTTr08IN93eL8csLOVa3azYAYWxZzLpSAXQqiD02L+A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=gvawpXhk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="gvawpXhk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74B9EC4CEE4;
	Mon, 12 May 2025 00:55:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747011338;
	bh=mRy5KyM2JxPRw8PUtzBOpezz7rM4DCh8KLY+CfUKumA=;
	h=Date:To:From:Subject:From;
	b=gvawpXhksCaHBAtF+v+pO4A4CmNaSJxXFbLuJKKfcw1nFD6YRe6w6pjfObHH269G7
	 mLHd01CvcjUKCLIc5AweH7e1AUpWUXDE/YP7u/x/sdePJHVthUJLk7KnjOrJgdmzDs
	 it1lTdr/qQ4YRiIvNQRd11GclVMDqJSqpTYJm0bs=
Date: Sun, 11 May 2025 17:55:37 -0700
To: mm-commits@vger.kernel.org,rostedt@goodmis.org,oleg@redhat.com,mingo@kernel.org,mhocko@kernel.org,mhiramat@kernel.org,mathieu.desnoyers@efficios.com,glider@google.com,brauner@kernel.org,andrii@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] exit-move-and-extend-sched_process_exit-tracepoint.patch removed from -mm tree
Message-Id: <20250512005538.74B9EC4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: exit: move and extend sched_process_exit() tracepoint
has been removed from the -mm tree.  Its filename was
     exit-move-and-extend-sched_process_exit-tracepoint.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Andrii Nakryiko <andrii@kernel.org>
Subject: exit: move and extend sched_process_exit() tracepoint
Date: Wed, 2 Apr 2025 11:09:25 -0700

It is useful to be able to access current->mm at task exit to, say, record
a bunch of VMA information right before the task exits (e.g., for stack
symbolization reasons when dealing with short-lived processes that exit in
the middle of profiling session).  Currently, trace_sched_process_exit()
is triggered after exit_mm() which resets current->mm to NULL making this
tracepoint unsuitable for inspecting and recording task's
mm_struct-related data when tracing process lifetimes.

There is a particularly suitable place, though, right after
taskstats_exit() is called, but before we do exit_mm() and other exit_*()
resource teardowns.  taskstats performs a similar kind of accounting that
some applications do with BPF, and so co-locating them seems like a good
fit.  So that's where trace_sched_process_exit() is moved with this patch.

Also, existing trace_sched_process_exit() tracepoint is notoriously
missing `group_dead` flag that is certainly useful in practice and some of
our production applications have to work around this.  So plumb
`group_dead` through while at it, to have a richer and more complete
tracepoint.

Note that we can't use sched_process_template anymore, and so we use
TRACE_EVENT()-based tracepoint definition.  But all the field names and
order, as well as assign and output logic remain intact.  We just add one
extra field at the end in backwards-compatible way.

[andrii@kernel.org: document sched_process_exit and sched_process_template relation]
  Link: https://lkml.kernel.org/r/20250403174120.4087794-1-andrii@kernel.org
Link: https://lkml.kernel.org/r/20250402180925.90914-1-andrii@kernel.org
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Acked-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Acked-by: Oleg Nesterov <oleg@redhat.com>
Suggested-by: Ingo Molnar <mingo@kernel.org>
Cc: Alexander Potapenko <glider@google.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: "Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Michal Hocko <mhocko@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/trace/events/sched.h |   34 +++++++++++++++++++++++++++++----
 kernel/exit.c                |    2 -
 2 files changed, 31 insertions(+), 5 deletions(-)

--- a/include/trace/events/sched.h~exit-move-and-extend-sched_process_exit-tracepoint
+++ a/include/trace/events/sched.h
@@ -326,11 +326,37 @@ DEFINE_EVENT(sched_process_template, sch
 	     TP_ARGS(p));
 
 /*
- * Tracepoint for a task exiting:
+ * Tracepoint for a task exiting.
+ * Note, it's a superset of sched_process_template and should be kept
+ * compatible as much as possible. sched_process_exits has an extra
+ * `group_dead` argument, so sched_process_template can't be used,
+ * unfortunately, just like sched_migrate_task above.
  */
-DEFINE_EVENT(sched_process_template, sched_process_exit,
-	     TP_PROTO(struct task_struct *p),
-	     TP_ARGS(p));
+TRACE_EVENT(sched_process_exit,
+
+	TP_PROTO(struct task_struct *p, bool group_dead),
+
+	TP_ARGS(p, group_dead),
+
+	TP_STRUCT__entry(
+		__array(	char,	comm,	TASK_COMM_LEN	)
+		__field(	pid_t,	pid			)
+		__field(	int,	prio			)
+		__field(	bool,	group_dead		)
+	),
+
+	TP_fast_assign(
+		memcpy(__entry->comm, p->comm, TASK_COMM_LEN);
+		__entry->pid		= p->pid;
+		__entry->prio		= p->prio; /* XXX SCHED_DEADLINE */
+		__entry->group_dead	= group_dead;
+	),
+
+	TP_printk("comm=%s pid=%d prio=%d group_dead=%s",
+		  __entry->comm, __entry->pid, __entry->prio,
+		  __entry->group_dead ? "true" : "false"
+	)
+);
 
 /*
  * Tracepoint for waiting on task to unschedule:
--- a/kernel/exit.c~exit-move-and-extend-sched_process_exit-tracepoint
+++ a/kernel/exit.c
@@ -936,12 +936,12 @@ void __noreturn do_exit(long code)
 
 	tsk->exit_code = code;
 	taskstats_exit(tsk, group_dead);
+	trace_sched_process_exit(tsk, group_dead);
 
 	exit_mm();
 
 	if (group_dead)
 		acct_process();
-	trace_sched_process_exit(tsk);
 
 	exit_sem(tsk);
 	exit_shm(tsk);
_

Patches currently in -mm which might be from andrii@kernel.org are


