From: akpm@linux-foundation.org
Subject: + ptrace-fix-fork-event-messages-across-pid-namespaces.patch
 added to -mm tree
Date: Wed, 30 Apr 2014 13:17:17 -0700
Message-ID: <53615a4d.nmqimPJtgWbu9dPw%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50092 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759387AbaD3URT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 30 Apr 2014 16:17:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, oleg@redhat.com, mcgrathr@chromium.org, keescook@chromium.org, jln@chromium.org, jan.kratochvil@redhat.com, mdempsky@chromium.org

Subject: + ptrace-fix-fork-event-messages-across-pid-namespaces.patch added to -mm tree
To: mdempsky@chromium.org,jan.kratochvil@redhat.com,jln@chromium.org,keescook@chromium.org,mcgrathr@chromium.org,oleg@redhat.com
From: akpm@linux-foundation.org
Date: Wed, 30 Apr 2014 13:17:17 -0700


The patch titled
     Subject: ptrace: fix fork event messages across pid namespaces
has been added to the -mm tree.  Its filename is
     ptrace-fix-fork-event-messages-across-pid-namespaces.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ptrace-fix-fork-event-messages-across-pid-namespaces.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ptrace-fix-fork-event-messages-across-pid-namespaces.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Matthew Dempsky <mdempsky@chromium.org>
Subject: ptrace: fix fork event messages across pid namespaces

When tracing a process in another pid namespace, it's important for fork
event messages to contain the child's pid as seen from the tracer's pid
namespace, not the parent's.  Otherwise, the tracer won't be able to
correlate the fork event with later SIGTRAP signals it receives from the
child.

We still risk a race condition if a ptracer from a different pid namespace
attaches after we compute the pid_t value.  However, sending a bogus fork
event message in this unlikely scenario is still a vast improvement over
the status quo where we always send bogus fork event messages to debuggers
in a different pid namespace than the forking process.

Signed-off-by: Matthew Dempsky <mdempsky@chromium.org>
Acked-by: Oleg Nesterov <oleg@redhat.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Julien Tinnes <jln@chromium.org>
Cc: Roland McGrath <mcgrathr@chromium.org>
Cc: Jan Kratochvil <jan.kratochvil@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/ptrace.h |   32 ++++++++++++++++++++++++++++++++
 kernel/fork.c          |   10 +++++++---
 2 files changed, 39 insertions(+), 3 deletions(-)

diff -puN include/linux/ptrace.h~ptrace-fix-fork-event-messages-across-pid-namespaces include/linux/ptrace.h
--- a/include/linux/ptrace.h~ptrace-fix-fork-event-messages-across-pid-namespaces
+++ a/include/linux/ptrace.h
@@ -5,6 +5,7 @@
 #include <linux/sched.h>		/* For struct task_struct.  */
 #include <linux/err.h>			/* for IS_ERR_VALUE */
 #include <linux/bug.h>			/* For BUG_ON.  */
+#include <linux/pid_namespace.h>	/* For task_active_pid_ns.  */
 #include <uapi/linux/ptrace.h>
 
 /*
@@ -129,6 +130,37 @@ static inline void ptrace_event(int even
 }
 
 /**
+ * ptrace_event_pid - possibly stop for a ptrace event notification
+ * @event:	%PTRACE_EVENT_* value to report
+ * @pid:	process identifier for %PTRACE_GETEVENTMSG to return
+ *
+ * Check whether @event is enabled and, if so, report @event and @pid
+ * to the ptrace parent.  @pid is reported as the pid_t seen from the
+ * the ptrace parent's pid namespace.
+ *
+ * Called without locks.
+ */
+static inline void ptrace_event_pid(int event, struct pid *pid)
+{
+	/*
+	 * FIXME: There's a potential race if a ptracer in a different pid
+	 * namespace than parent attaches between computing message below and
+	 * when we acquire tasklist_lock in ptrace_stop().  If this happens,
+	 * the ptracer will get a bogus pid from PTRACE_GETEVENTMSG.
+	 */
+	unsigned long message = 0;
+	struct pid_namespace *ns;
+
+	rcu_read_lock();
+	ns = task_active_pid_ns(rcu_dereference(current->parent));
+	if (ns)
+		message = pid_nr_ns(pid, ns);
+	rcu_read_unlock();
+
+	ptrace_event(event, message);
+}
+
+/**
  * ptrace_init_task - initialize ptrace state for a new child
  * @child:		new child task
  * @ptrace:		true if child should be ptrace'd by parent's tracer
diff -puN kernel/fork.c~ptrace-fix-fork-event-messages-across-pid-namespaces kernel/fork.c
--- a/kernel/fork.c~ptrace-fix-fork-event-messages-across-pid-namespaces
+++ a/kernel/fork.c
@@ -1606,10 +1606,12 @@ long do_fork(unsigned long clone_flags,
 	 */
 	if (!IS_ERR(p)) {
 		struct completion vfork;
+		struct pid *pid;
 
 		trace_sched_process_fork(current, p);
 
-		nr = task_pid_vnr(p);
+		pid = get_task_pid(p, PIDTYPE_PID);
+		nr = pid_vnr(pid);
 
 		if (clone_flags & CLONE_PARENT_SETTID)
 			put_user(nr, parent_tidptr);
@@ -1624,12 +1626,14 @@ long do_fork(unsigned long clone_flags,
 
 		/* forking complete and child started to run, tell ptracer */
 		if (unlikely(trace))
-			ptrace_event(trace, nr);
+			ptrace_event_pid(trace, pid);
 
 		if (clone_flags & CLONE_VFORK) {
 			if (!wait_for_vfork_done(p, &vfork))
-				ptrace_event(PTRACE_EVENT_VFORK_DONE, nr);
+				ptrace_event_pid(PTRACE_EVENT_VFORK_DONE, pid);
 		}
+
+		put_pid(pid);
 	} else {
 		nr = PTR_ERR(p);
 	}
_

Patches currently in -mm which might be from mdempsky@chromium.org are

ptrace-fix-fork-event-messages-across-pid-namespaces.patch

