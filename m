From: akpm@linux-foundation.org
Subject: [merged]
 exit-reparent-fix-the-cross-namespace-pr_set_child_subreaper-reparenting.patch removed from -mm tree
Date: Thu, 11 Dec 2014 11:08:25 -0800
Message-ID: <5489eba9./OsZOXv/gvb1MfzI%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46085 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758460AbaLKTI0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 11 Dec 2014 14:08:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@redhat.com, atomlin@redhat.com, ebiederm@xmission.com, kay@vrfy.org, lennart@poettering.net, stalexan@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: exit: reparent: fix the cross-namespace PR_SET_CHILD_SUBREAPER reparenting
has been removed from the -mm tree.  Its filename was
     exit-reparent-fix-the-cross-namespace-pr_set_child_subreaper-reparenting.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Oleg Nesterov <oleg@redhat.com>
Subject: exit: reparent: fix the cross-namespace PR_SET_CHILD_SUBREAPER reparenting

find_new_reaper() assumes that "has_child_subreaper" logic is safe as
long as we are not the exiting ->child_reaper and this is doubly wrong:

1. In fact it is safe if "pid_ns->child_reaper == father"; there must
   be no children after zap_pid_ns_processes() returns, so it doesn't
   matter what we return in this case and even pid_ns->child_reaper is
   wrong otherwise: we can't reparent to ->child_reaper == current.

   This is not a bug, but this is confusing.

2. It is not safe if we are not pid_ns->child_reaper but from the same
   thread group. We drop tasklist_lock before zap_pid_ns_processes(),
   so another thread can lock it and choose the new reaper from the
   upper namespace if has_child_subreaper == T, and this is obviously
   wrong.

   This is not that bad, zap_pid_ns_processes() won't return until the
   the new reaper reaps all zombies, but this should be fixed anyway.

We could change for_each_thread() loop to use ->exit_state instead of
PF_EXITING which we had to use until 8aac62706ada, or we could change
copy_signal() to check CLONE_NEWPID before setting has_child_subreaper,
but lets change this code so that it is clear we can't look outside of
our namespace, otherwise same_thread_group(reaper, child_reaper) check
will look wrong and confusing anyway.

We can simply start from "father" and fix the problem. We can't wrongly
return a thread from the same thread group if ->is_child_subreaper == T,
we know that all threads have PF_EXITING set.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: Aaron Tomlin <atomlin@redhat.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Kay Sievers <kay@vrfy.org>
Cc: Lennart Poettering <lennart@poettering.net>
Cc: Sterling Alexander <stalexan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/exit.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN kernel/exit.c~exit-reparent-fix-the-cross-namespace-pr_set_child_subreaper-reparenting kernel/exit.c
--- a/kernel/exit.c~exit-reparent-fix-the-cross-namespace-pr_set_child_subreaper-reparenting
+++ a/kernel/exit.c
@@ -492,7 +492,9 @@ static struct task_struct *find_new_reap
 
 		zap_pid_ns_processes(pid_ns);
 		write_lock_irq(&tasklist_lock);
-	} else if (father->signal->has_child_subreaper) {
+	}
+
+	if (father->signal->has_child_subreaper) {
 		struct task_struct *reaper;
 
 		/*
@@ -502,7 +504,7 @@ static struct task_struct *find_new_reap
 		 * PID namespace. However we still need the check above, see
 		 * http://marc.info/?l=linux-kernel&m=131385460420380
 		 */
-		for (reaper = father->real_parent;
+		for (reaper = father;
 		     reaper != &init_task;
 		     reaper = reaper->real_parent) {
 			if (same_thread_group(reaper, pid_ns->child_reaper))
_

Patches currently in -mm which might be from oleg@redhat.com are

origin.patch
mmfs-introduce-helpers-around-the-i_mmap_mutex.patch
mm-use-new-helper-functions-around-the-i_mmap_mutex.patch
mm-convert-i_mmap_mutex-to-rwsem.patch
mm-rmap-share-the-i_mmap_rwsem.patch
uprobes-share-the-i_mmap_rwsem.patch
mm-xip-share-the-i_mmap_rwsem.patch
mm-memory-failure-share-the-i_mmap_rwsem.patch
mm-nommu-share-the-i_mmap_rwsem.patch
mm-memoryc-share-the-i_mmap_rwsem.patch
remove-unnecessary-is_valid_nodemask.patch
oom-dont-assume-that-a-coredumping-thread-will-exit-soon.patch
oom-dont-assume-that-a-coredumping-thread-will-exit-soon-v2.patch
oom-dont-assume-that-a-coredumping-thread-will-exit-soon-v2-fix.patch
oom-kill-the-insufficient-and-no-longer-needed-pt_trace_exit-check.patch
linux-next.patch
all-arches-signal-move-restart_block-to-struct-task_struct.patch

