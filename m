From: akpm@linux-foundation.org
Subject: [nacked]
 exit-pidns-alloc_pid-leaks-pid_namespace-if-child_reaper-is-exiting.patch
 removed from -mm tree
Date: Mon, 24 Nov 2014 14:21:46 -0800
Message-ID: <5473af7a.ND4IL4llrPhBwky7%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56391 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751346AbaKXWVX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 24 Nov 2014 17:21:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@redhat.com, atomlin@redhat.com, ebiederm@xmission.com, serge.hallyn@ubuntu.com, stalexan@redhat.com, xemul@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: exit: pidns: alloc_pid() leaks pid_namespace if child_reaper is exiting
has been removed from the -mm tree.  Its filename was
     exit-pidns-alloc_pid-leaks-pid_namespace-if-child_reaper-is-exiting.patch

This patch was dropped because it was nacked

------------------------------------------------------
From: Oleg Nesterov <oleg@redhat.com>
Subject: exit: pidns: alloc_pid() leaks pid_namespace if child_reaper is exiting

alloc_pid() does get_pid_ns() beforehand but forgets to put_pid_ns() if it
fails because disable_pid_allocation() was called by the exiting
child_reaper.  We can move get_pid_ns() down to successful return.

While at it, simplify/cleanup the "goto out" mess, no need to confuse the
success/error return paths.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: Aaron Tomlin <atomlin@redhat.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Pavel Emelyanov <xemul@parallels.com>
Cc: Serge Hallyn <serge.hallyn@ubuntu.com>
Cc: Sterling Alexander <stalexan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/pid.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff -puN kernel/pid.c~exit-pidns-alloc_pid-leaks-pid_namespace-if-child_reaper-is-exiting kernel/pid.c
--- a/kernel/pid.c~exit-pidns-alloc_pid-leaks-pid_namespace-if-child_reaper-is-exiting
+++ a/kernel/pid.c
@@ -320,7 +320,6 @@ struct pid *alloc_pid(struct pid_namespa
 			goto out_free;
 	}
 
-	get_pid_ns(ns);
 	atomic_set(&pid->count, 1);
 	for (type = 0; type < PIDTYPE_MAX; ++type)
 		INIT_HLIST_HEAD(&pid->tasks[type]);
@@ -336,7 +335,7 @@ struct pid *alloc_pid(struct pid_namespa
 	}
 	spin_unlock_irq(&pidmap_lock);
 
-out:
+	get_pid_ns(ns);
 	return pid;
 
 out_unlock:
@@ -346,8 +345,8 @@ out_free:
 		free_pidmap(pid->numbers + i);
 
 	kmem_cache_free(ns->pid_cachep, pid);
-	pid = NULL;
-	goto out;
+out:
+	return NULL;
 }
 
 void disable_pid_allocation(struct pid_namespace *ns)
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
remove-unnecessary-is_valid_nodemask.patch
proc-task_state-read-cred-group_info-outside-of-task_lock.patch
proc-task_state-deuglify-the-max_fds-calculation.patch
proc-task_state-move-the-main-seq_printf-outside-of-rcu_read_lock.patch
proc-task_state-ptrace_parent-doesnt-need-pid_alive-check.patch
sched_show_task-fix-unsafe-usage-of-real_parent.patch
exit-reparent-use-ptrace_entry-rather-than-sibling-for-exit_dead-tasks.patch
exit-reparent-cleanup-the-changing-of-parent.patch
exit-reparent-cleanup-the-changing-of-parent-fix.patch
exit-reparent-cleanup-the-usage-of-reparent_leader.patch
exit-ptrace-shift-reap-dead-code-from-exit_ptrace-to-forget_original_parent.patch
usermodehelper-dont-use-clone_vfork-for-____call_usermodehelper.patch
usermodehelper-kill-the-kmod_thread_locker-logic.patch
exit-wait-cleanup-the-ptrace_reparented-checks.patch
exit-wait-cleanup-the-ptrace_reparented-checks-fix.patch
exit-wait-dont-use-zombie-real_parent.patch
exit-wait-drop-tasklist_lock-before-psig-c-accounting.patch
exit-release_task-fix-the-comment-about-group-leader-accounting.patch
exit-proc-dont-try-to-flush-proc-tgid-task-tgid.patch
exit-reparent-fix-the-dead-parent-pr_set_child_subreaper-reparenting.patch
exit-reparent-fix-the-cross-namespace-pr_set_child_subreaper-reparenting.patch
exit-reparent-s-while_each_thread-for_each_thread-in-find_new_reaper.patch
exit-reparent-document-the-has_child_subreaper-checks.patch
exit-reparent-introduce-find_child_reaper.patch
exit-reparent-introduce-find_alive_thread.patch
exit-reparent-avoid-find_new_reaper-if-no-children.patch
exit-reparent-call-forget_original_parent-under-tasklist_lock.patch
exit-exit_notify-re-use-dead-list-to-autoreap-current.patch
linux-next.patch

