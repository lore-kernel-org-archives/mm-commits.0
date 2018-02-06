From: akpm@linux-foundation.org
Subject: [patch 060/114] kernel/fork.c: check error and return
 early
Date: Tue, 06 Feb 2018 15:39:30 -0800
Message-ID: <20180206233930.NFD_c_Hbg%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55158 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932067AbeBFXjc (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 6 Feb 2018 18:39:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, marcos.souza.org@gmail.com, mhocko@suse.com, mm-commits@vger.kernel.org, torvalds@linux-foundation.org

From: Marcos Paulo de Souza <marcos.souza.org@gmail.com>
Subject: kernel/fork.c: check error and return early

Thus reducing one indentation level while maintaining the same rationale.

Link: http://lkml.kernel.org/r/20171117002929.5155-1-marcos.souza.org@gmail.com
Signed-off-by: Marcos Paulo de Souza <marcos.souza.org@gmail.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/fork.c |   63 +++++++++++++++++++++++-------------------------
 1 file changed, 31 insertions(+), 32 deletions(-)

diff -puN kernel/fork.c~forkc-check-error-and-return-early kernel/fork.c
--- a/kernel/fork.c~forkc-check-error-and-return-early
+++ a/kernel/fork.c
@@ -2062,6 +2062,8 @@ long _do_fork(unsigned long clone_flags,
 	      int __user *child_tidptr,
 	      unsigned long tls)
 {
+	struct completion vfork;
+	struct pid *pid;
 	struct task_struct *p;
 	int trace = 0;
 	long nr;
@@ -2087,43 +2089,40 @@ long _do_fork(unsigned long clone_flags,
 	p = copy_process(clone_flags, stack_start, stack_size,
 			 child_tidptr, NULL, trace, tls, NUMA_NO_NODE);
 	add_latent_entropy();
+
+	if (IS_ERR(p))
+		return PTR_ERR(p);
+
 	/*
 	 * Do this prior waking up the new thread - the thread pointer
 	 * might get invalid after that point, if the thread exits quickly.
 	 */
-	if (!IS_ERR(p)) {
-		struct completion vfork;
-		struct pid *pid;
-
-		trace_sched_process_fork(current, p);
-
-		pid = get_task_pid(p, PIDTYPE_PID);
-		nr = pid_vnr(pid);
-
-		if (clone_flags & CLONE_PARENT_SETTID)
-			put_user(nr, parent_tidptr);
-
-		if (clone_flags & CLONE_VFORK) {
-			p->vfork_done = &vfork;
-			init_completion(&vfork);
-			get_task_struct(p);
-		}
-
-		wake_up_new_task(p);
-
-		/* forking complete and child started to run, tell ptracer */
-		if (unlikely(trace))
-			ptrace_event_pid(trace, pid);
-
-		if (clone_flags & CLONE_VFORK) {
-			if (!wait_for_vfork_done(p, &vfork))
-				ptrace_event_pid(PTRACE_EVENT_VFORK_DONE, pid);
-		}
-
-		put_pid(pid);
-	} else {
-		nr = PTR_ERR(p);
+	trace_sched_process_fork(current, p);
+
+	pid = get_task_pid(p, PIDTYPE_PID);
+	nr = pid_vnr(pid);
+
+	if (clone_flags & CLONE_PARENT_SETTID)
+		put_user(nr, parent_tidptr);
+
+	if (clone_flags & CLONE_VFORK) {
+		p->vfork_done = &vfork;
+		init_completion(&vfork);
+		get_task_struct(p);
 	}
+
+	wake_up_new_task(p);
+
+	/* forking complete and child started to run, tell ptracer */
+	if (unlikely(trace))
+		ptrace_event_pid(trace, pid);
+
+	if (clone_flags & CLONE_VFORK) {
+		if (!wait_for_vfork_done(p, &vfork))
+			ptrace_event_pid(PTRACE_EVENT_VFORK_DONE, pid);
+	}
+
+	put_pid(pid);
 	return nr;
 }
 
_
