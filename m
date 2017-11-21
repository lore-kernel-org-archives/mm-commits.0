From: akpm@linux-foundation.org
Subject: + forkc-check-error-and-return-early.patch added to -mm tree
Date: Mon, 20 Nov 2017 16:18:43 -0800
Message-ID: <5a1370e3.OKRp+KdDbiOvwzKT%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53476 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751195AbdKUASo (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 20 Nov 2017 19:18:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: marcos.souza.org@gmail.com, mhocko@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kernel/fork.c: check error and return early
has been added to the -mm tree.  Its filename is
     forkc-check-error-and-return-early.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/forkc-check-error-and-return-early.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/forkc-check-error-and-return-early.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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
@@ -2045,6 +2045,8 @@ long _do_fork(unsigned long clone_flags,
 	      int __user *child_tidptr,
 	      unsigned long tls)
 {
+	struct completion vfork;
+	struct pid *pid;
 	struct task_struct *p;
 	int trace = 0;
 	long nr;
@@ -2070,43 +2072,40 @@ long _do_fork(unsigned long clone_flags,
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

Patches currently in -mm which might be from marcos.souza.org@gmail.com are

forkc-check-error-and-return-early.patch

