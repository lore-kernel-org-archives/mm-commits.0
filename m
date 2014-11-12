From: akpm@linux-foundation.org
Subject: +
 exit-reparent-use-ptrace_entry-rather-than-sibling-for-exit_dead-tasks.patch added to -mm tree
Date: Wed, 12 Nov 2014 14:56:26 -0800
Message-ID: <5463e59a.HLGChXhX1pVx5Feh%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49803 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752273AbaKLW41 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 12 Nov 2014 17:56:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@redhat.com, adobriyan@gmail.com, atomlin@redhat.com, ebiederm@xmission.com, peterz@infradead.org, roland@hack.frob.com, stalexan@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: exit: reparent: use ->ptrace_entry rather than ->sibling for EXIT_DEAD tasks
has been added to the -mm tree.  Its filename is
     exit-reparent-use-ptrace_entry-rather-than-sibling-for-exit_dead-tasks.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/exit-reparent-use-ptrace_entry-rather-than-sibling-for-exit_dead-tasks.patch
		echo and later at
		echo  http://ozlabs.org/~akpm/mmotm/broken-out/exit-reparent-use-ptrace_entry-rather-than-sibling-for-exit_dead-tasks.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Oleg Nesterov <oleg@redhat.com>
Subject: exit: reparent: use ->ptrace_entry rather than ->sibling for EXIT_DEAD tasks

reparent_leader() reuses ->sibling as a list node to add an EXIT_DEAD task
into dead_children list we are going to release.  This obviously removes
the dead task from its real_parent->children list and this is even good;
the parent can do nothing with the EXIT_DEAD reparented zombie, it only
makes do_wait() slower.

But, this also means that it can not be reparented once again, so if its
new parent dies too nobody will update ->parent/real_parent, they can
point to the freed memory even before release_task() we are going to call,
this breaks the code which relies on pid_alive() to access
->real_parent/parent.

Fortunately this is mostly theoretical, this can only happen if init or
PR_SET_CHILD_SUBREAPER process ignores SIGCHLD and the new parent
sub-thread exits right after we drop tasklist_lock.

Change this code to use ->ptrace_entry instead, we know that the child is
not traced so nobody can ever use this member.  This also allows to unify
this logic with exit_ptrace(), see the next changes.

Note: we really need to change release_task() to nullify real_parent/
parent/group_leader pointers, but we need to change the current users
first somehow.  And it would be better to reap this zombie immediately but
release_task_locked() we need is complicated by proc_flush_task().

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: Aaron Tomlin <atomlin@redhat.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
Cc: Sterling Alexander <stalexan@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Roland McGrath <roland@hack.frob.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/exit.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN kernel/exit.c~exit-reparent-use-ptrace_entry-rather-than-sibling-for-exit_dead-tasks kernel/exit.c
--- a/kernel/exit.c~exit-reparent-use-ptrace_entry-rather-than-sibling-for-exit_dead-tasks
+++ a/kernel/exit.c
@@ -548,7 +548,7 @@ static void reparent_leader(struct task_
 	    p->exit_state == EXIT_ZOMBIE && thread_group_empty(p)) {
 		if (do_notify_parent(p, p->exit_signal)) {
 			p->exit_state = EXIT_DEAD;
-			list_move_tail(&p->sibling, dead);
+			list_add(&p->ptrace_entry, dead);
 		}
 	}
 
@@ -587,8 +587,8 @@ static void forget_original_parent(struc
 
 	BUG_ON(!list_empty(&father->children));
 
-	list_for_each_entry_safe(p, n, &dead_children, sibling) {
-		list_del_init(&p->sibling);
+	list_for_each_entry_safe(p, n, &dead_children, ptrace_entry) {
+		list_del_init(&p->ptrace_entry);
 		release_task(p);
 	}
 }
_

Patches currently in -mm which might be from oleg@redhat.com are

mmfs-introduce-helpers-around-the-i_mmap_mutex.patch
mm-use-new-helper-functions-around-the-i_mmap_mutex.patch
mm-convert-i_mmap_mutex-to-rwsem.patch
mm-rmap-share-the-i_mmap_rwsem.patch
uprobes-share-the-i_mmap_rwsem.patch
mm-xip-share-the-i_mmap_rwsem.patch
mm-memory-failure-share-the-i_mmap_rwsem.patch
mm-nommu-share-the-i_mmap_rwsem.patch
mm-memoryc-share-the-i_mmap_rwsem.patch
proc-task_state-read-cred-group_info-outside-of-task_lock.patch
proc-task_state-deuglify-the-max_fds-calculation.patch
proc-task_state-move-the-main-seq_printf-outside-of-rcu_read_lock.patch
proc-task_state-ptrace_parent-doesnt-need-pid_alive-check.patch
sched_show_task-fix-unsafe-usage-of-real_parent.patch
exit-reparent-use-ptrace_entry-rather-than-sibling-for-exit_dead-tasks.patch
exit-reparent-cleanup-the-changing-of-parent.patch
exit-reparent-cleanup-the-usage-of-reparent_leader.patch
exit-ptrace-shift-reap-dead-code-from-exit_ptrace-to-forget_original_parent.patch
usermodehelper-dont-use-clone_vfork-for-____call_usermodehelper.patch
usermodehelper-kill-the-kmod_thread_locker-logic.patch
linux-next.patch

