From: akpm@linux-foundation.org
Subject: [merged]
 exitc-call-proc_exit_connector-after-exit_state-is-set.patch removed from
 -mm tree
Date: Tue, 08 Apr 2014 14:15:44 -0700
Message-ID: <53446700.QqphRa/CgSCFwlC1%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56878 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756748AbaDHVPp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Apr 2014 17:15:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, oleg@redhat.com, matt.helsley@gmail.com, davem@davemloft.net, guillaume@morinfr.org

Subject: [merged] exitc-call-proc_exit_connector-after-exit_state-is-set.patch removed from -mm tree
To: guillaume@morinfr.org,davem@davemloft.net,matt.helsley@gmail.com,oleg@redhat.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 08 Apr 2014 14:15:44 -0700


The patch titled
     Subject: kernel/exit.c: call proc_exit_connector() after exit_state is set
has been removed from the -mm tree.  Its filename was
     exitc-call-proc_exit_connector-after-exit_state-is-set.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Guillaume Morin <guillaume@morinfr.org>
Subject: kernel/exit.c: call proc_exit_connector() after exit_state is set

The process events connector delivers a notification when a process exits.
 This is really convenient for a process that spawns and wants to monitor
its children through an epoll-able() interface.

Unfortunately, there is a small window between when the event is delivered
and the child become wait()-able.

This is creates a race if the parent wants to make sure that it knows
about the exit, e.g

pid_t pid = fork();
if (pid > 0) {
	register_interest_for_pid(pid);
	if (waitpid(pid, NULL, WNOHANG) > 0)
	{
	  /* We might have raced with exit() */
	}
	return;
}

/* Child */
execve(...)

register_interest_for_pid() would be telling the the connector socket
reader to pay attention to events related to pid.

Though this is not a bug, I think it would make the connector a bit more
usable if this race was closed by simply moving the call to
proc_exit_connector() from just before exit_notify() to right after.

Oleg said:

: Even with this patch the code above is still "racy" if the child is
: multi-threaded.  Plus it should obviously filter-out subthreads.  And
: afaics there is no way to make it reliable, even if you change the code
: above so that waitpid() is called only after the last thread exits WNOHANG
: still can fail.

Signed-off-by: Guillaume Morin <guillaume@morinfr.org>
Cc: Matt Helsley <matt.helsley@gmail.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: David S. Miller <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/exit.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/exit.c~exitc-call-proc_exit_connector-after-exit_state-is-set kernel/exit.c
--- a/kernel/exit.c~exitc-call-proc_exit_connector-after-exit_state-is-set
+++ a/kernel/exit.c
@@ -802,13 +802,13 @@ void do_exit(long code)
 
 	module_put(task_thread_info(tsk)->exec_domain->module);
 
-	proc_exit_connector(tsk);
 	/*
 	 * FIXME: do that only when needed, using sched_exit tracepoint
 	 */
 	flush_ptrace_hw_breakpoint(tsk);
 
 	exit_notify(tsk, group_dead);
+	proc_exit_connector(tsk);
 #ifdef CONFIG_NUMA
 	task_lock(tsk);
 	mpol_put(tsk->mempolicy);
_

Patches currently in -mm which might be from guillaume@morinfr.org are

origin.patch

