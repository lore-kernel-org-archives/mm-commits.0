From: akpm@linux-foundation.org
Subject: + exit-reparent-introduce-find_alive_thread.patch added to -mm
 tree
Date: Tue, 18 Nov 2014 13:50:09 -0800
Message-ID: <546bbf11.r4pei2UxQ9fUYcl4%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36877 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753300AbaKRVuK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 18 Nov 2014 16:50:10 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@redhat.com, atomlin@redhat.com, ebiederm@xmission.com, kay@vrfy.org, lennart@poettering.net, stalexan@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: exit: reparent: introduce find_alive_thread()
has been added to the -mm tree.  Its filename is
     exit-reparent-introduce-find_alive_thread.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/exit-reparent-introduce-find_alive_thread.patch
		echo and later at
		echo  http://ozlabs.org/~akpm/mmotm/broken-out/exit-reparent-introduce-find_alive_thread.patch

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
Subject: exit: reparent: introduce find_alive_thread()

Add the new simple helper to factor out the for_each_thread() code in
find_child_reaper() and find_new_reaper().  It can also simplify the
potential PF_EXITING -> exit_state change, plus perhaps we can change this
code to take SIGNAL_GROUP_EXIT into account.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: Aaron Tomlin <atomlin@redhat.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Kay Sievers <kay@vrfy.org>
Cc: Lennart Poettering <lennart@poettering.net>
Cc: Sterling Alexander <stalexan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/exit.c |   32 +++++++++++++++++++-------------
 1 file changed, 19 insertions(+), 13 deletions(-)

diff -puN kernel/exit.c~exit-reparent-introduce-find_alive_thread kernel/exit.c
--- a/kernel/exit.c~exit-reparent-introduce-find_alive_thread
+++ a/kernel/exit.c
@@ -462,6 +462,17 @@ static void exit_mm(struct task_struct *
 	clear_thread_flag(TIF_MEMDIE);
 }
 
+static struct task_struct *find_alive_thread(struct task_struct *p)
+{
+	struct task_struct *t;
+
+	for_each_thread(p, t) {
+		if (!(t->flags & PF_EXITING))
+			return t;
+	}
+	return NULL;
+}
+
 static struct task_struct *find_child_reaper(struct task_struct *father)
 	__releases(&tasklist_lock)
 	__acquires(&tasklist_lock)
@@ -472,9 +483,8 @@ static struct task_struct *find_child_re
 	if (likely(reaper != father))
 		return reaper;
 
-	for_each_thread(father, reaper) {
-		if (reaper->flags & PF_EXITING)
-			continue;
+	reaper = find_alive_thread(father);
+	if (reaper) {
 		pid_ns->child_reaper = reaper;
 		return reaper;
 	}
@@ -500,16 +510,13 @@ static struct task_struct *find_child_re
 static struct task_struct *find_new_reaper(struct task_struct *father,
 					   struct task_struct *child_reaper)
 {
-	struct task_struct *thread;
+	struct task_struct *thread, *reaper;
 
-	for_each_thread(father, thread) {
-		if (thread->flags & PF_EXITING)
-			continue;
+	thread = find_alive_thread(father);
+	if (thread)
 		return thread;
-	}
 
 	if (father->signal->has_child_subreaper) {
-		struct task_struct *reaper;
 		/*
 		 * Find the first ->is_child_subreaper ancestor in our pid_ns.
 		 * We start from father to ensure we can not look into another
@@ -523,10 +530,9 @@ static struct task_struct *find_new_reap
 				break;
 			if (!reaper->signal->is_child_subreaper)
 				continue;
-			for_each_thread(reaper, thread) {
-				if (!(thread->flags & PF_EXITING))
-					return thread;
-			}
+			thread = find_alive_thread(reaper);
+			if (thread)
+				return thread;
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
exit-reparent-fix-the-dead-parent-pr_set_child_subreaper-reparenting.patch
exit-reparent-fix-the-cross-namespace-pr_set_child_subreaper-reparenting.patch
exit-reparent-s-while_each_thread-for_each_thread-in-find_new_reaper.patch
exit-reparent-document-the-has_child_subreaper-checks.patch
exit-reparent-introduce-find_child_reaper.patch
exit-reparent-introduce-find_alive_thread.patch
linux-next.patch

