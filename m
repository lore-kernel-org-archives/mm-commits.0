Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B5811E5B6B
	for <mm-commits@vger.kernel.org>; Wed,  2 Apr 2025 22:11:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743631860; cv=none; b=dn8+nxvQi5in320fdUxtVxxoBZEL16pjxEIaNPzCniE3FhxUqpUmgOldJEO4UB2T2KlivPHV2WxAnfck4j3SvoI58Cdm0j61nugj3EXL5p02D05ABgxblbCMxCPBWoxtAMz1bSqu35ew1lOK5cf4uFMvmpzo5msj0uKs+t1MlfE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743631860; c=relaxed/simple;
	bh=4uJHj3hPy+bbNVvapsSsV9HG027WuCrvnq0NVN9YB9g=;
	h=Date:To:From:Subject:Message-Id; b=VtQmdwwqWyjtysIVUdxU/IqRFEzCFJHlqAireHZ6P47ckq7Vizr0Qexr8uv+GU+3WyjtdrDjlHy9tJTmwcmEkVNLRBzujumtudV75BT1UgVTC1q9RGkWPnoXR5L1BpVwlf2iuqd6/5IXyIpiJnOLTZsqlNweiqitGQ0tKQMIJG4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=2ThCDQ+J; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="2ThCDQ+J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07B4CC4CEDD;
	Wed,  2 Apr 2025 22:10:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1743631860;
	bh=4uJHj3hPy+bbNVvapsSsV9HG027WuCrvnq0NVN9YB9g=;
	h=Date:To:From:Subject:From;
	b=2ThCDQ+JuIPXnwIi8FeGnScVUVnEREXksmCDky8aQBhQPPUKziStZyOJVnnDbFB5L
	 1FAjmYTebiF27Dqez2o3YvWRg8UM7zMBhYyanA45hlwqvGTeUGO1H2v6/qcWUi6+WI
	 Mn0J2ROyXjgVkwMQQyOYGGTkhmtxyGpbC87rNfdY=
Date: Wed, 02 Apr 2025 15:10:59 -0700
To: mm-commits@vger.kernel.org,rostedt@goodmis.org,oleg@redhat.com,mingo@kernel.org,mhocko@kernel.org,mhiramat@kernel.org,mathieu.desnoyers@efficios.com,glider@google.com,brauner@kernel.org,andrii@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + exit-move-and-extend-sched_process_exit-tracepoint.patch added to mm-nonmm-unstable branch
Message-Id: <20250402221100.07B4CC4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: exit: move and extend sched_process_exit() tracepoint
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     exit-move-and-extend-sched_process_exit-tracepoint.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/exit-move-and-extend-sched_process_exit-tracepoint.patch

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

Link: https://lkml.kernel.org/r/20250402180925.90914-1-andrii@kernel.org
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Acked-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Acked-by: Oleg Nesterov <oleg@redhat.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: "Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Michal Hocko <mhocko@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/trace/events/sched.h |   28 +++++++++++++++++++++++++---
 kernel/exit.c                |    2 +-
 2 files changed, 26 insertions(+), 4 deletions(-)

--- a/include/trace/events/sched.h~exit-move-and-extend-sched_process_exit-tracepoint
+++ a/include/trace/events/sched.h
@@ -328,9 +328,31 @@ DEFINE_EVENT(sched_process_template, sch
 /*
  * Tracepoint for a task exiting:
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
@@ -937,12 +937,12 @@ void __noreturn do_exit(long code)
 
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

exit-move-and-extend-sched_process_exit-tracepoint.patch

