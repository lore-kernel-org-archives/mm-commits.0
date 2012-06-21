From: akpm@linux-foundation.org
Subject: [merged] pidns-find_new_reaper-can-no-longer-switch-to-init_pid_nschild_reaper.patch removed from -mm tree
Date: Thu, 21 Jun 2012 12:25:43 -0700
Message-ID: <20120621192543.C0064A00B0@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-we0-f202.google.com ([74.125.82.202]:46556 "EHLO
	mail-we0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760120Ab2FUTZp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 21 Jun 2012 15:25:45 -0400
Received: by mail-we0-f202.google.com with SMTP id u7so63402wey.1
        for <mm-commits@vger.kernel.org>; Thu, 21 Jun 2012 12:25:44 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@redhat.com, avagin@gmail.com, ebiederm@xmission.com, efault@gmx.de, louis.rilling@kerlabs.com, xemul@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: pidns: find_new_reaper() can no longer switch to init_pid_ns.child_reaper
has been removed from the -mm tree.  Its filename was
     pidns-find_new_reaper-can-no-longer-switch-to-init_pid_nschild_reaper.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Oleg Nesterov <oleg@redhat.com>
Subject: pidns: find_new_reaper() can no longer switch to init_pid_ns.child_reaper

find_new_reaper() changes pid_ns->child_reaper, see add0d4df ("pid_ns:
zap_pid_ns_processes: fix the ->child_reaper changing").

The original reason has gone away after the previous patch, ->children
list must be empty after zap_pid_ns_processes().

However now we can not switch to init_pid_ns.child_reaper. 
__unhash_process() relies on the "->child_reaper == parent" check, but
this check does not work if the last exiting task is also the child
reaper.

As Eric sugested, we can change __unhash_process() to use the parent's
pid_ns and remove this code.

Also, with this change we can move detach_pid(PIDTYPE_PID) back, where it
was before the previous fix.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Louis Rilling <louis.rilling@kerlabs.com>
Cc: Mike Galbraith <efault@gmx.de>
Acked-by: Pavel Emelyanov <xemul@parallels.com>
Tested-by: Andrew Wagin <avagin@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/exit.c |   10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff -puN kernel/exit.c~pidns-find_new_reaper-can-no-longer-switch-to-init_pid_nschild_reaper kernel/exit.c
--- a/kernel/exit.c~pidns-find_new_reaper-can-no-longer-switch-to-init_pid_nschild_reaper
+++ a/kernel/exit.c
@@ -64,6 +64,7 @@ static void exit_mm(struct task_struct *
 static void __unhash_process(struct task_struct *p, bool group_dead)
 {
 	nr_threads--;
+	detach_pid(p, PIDTYPE_PID);
 	if (group_dead) {
 		detach_pid(p, PIDTYPE_PGID);
 		detach_pid(p, PIDTYPE_SID);
@@ -78,13 +79,12 @@ static void __unhash_process(struct task
 		if (IS_ENABLED(CONFIG_PID_NS)) {
 			struct task_struct *parent = p->real_parent;
 
-			if ((task_active_pid_ns(p)->child_reaper == parent) &&
+			if ((task_active_pid_ns(parent)->child_reaper == parent) &&
 			    list_empty(&parent->children) &&
 			    (parent->flags & PF_EXITING))
 				wake_up_process(parent);
 		}
 	}
-	detach_pid(p, PIDTYPE_PID);
 	list_del_rcu(&p->thread_group);
 }
 
@@ -732,12 +732,6 @@ static struct task_struct *find_new_reap
 
 		zap_pid_ns_processes(pid_ns);
 		write_lock_irq(&tasklist_lock);
-		/*
-		 * We can not clear ->child_reaper or leave it alone.
-		 * There may by stealth EXIT_DEAD tasks on ->children,
-		 * forget_original_parent() must move them somewhere.
-		 */
-		pid_ns->child_reaper = init_pid_ns.child_reaper;
 	} else if (father->signal->has_child_subreaper) {
 		struct task_struct *reaper;
 
_

Patches currently in -mm which might be from oleg@redhat.com are

origin.patch
linux-next.patch
c-r-prctl-less-paranoid-prctl_set_mm_exe_file.patch
mm-oom-do-not-schedule-if-current-has-been-killed.patch
kmod-avoid-deadlock-from-recursive-kmod-call.patch
c-r-fcntl-add-f_getowner_uids-option.patch

