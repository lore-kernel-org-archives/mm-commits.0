From: akpm@linux-foundation.org
Subject: + exit-reparent-document-the-has_child_subreaper-checks.patch
 added to -mm tree
Date: Tue, 18 Nov 2014 13:50:05 -0800
Message-ID: <546bbf0d.Sflp5xHSz6udIYMt%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36867 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753300AbaKRVuH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 18 Nov 2014 16:50:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@redhat.com, atomlin@redhat.com, ebiederm@xmission.com, kay@vrfy.org, lennart@poettering.net, stalexan@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: exit: reparent: document the ->has_child_subreaper checks
has been added to the -mm tree.  Its filename is
     exit-reparent-document-the-has_child_subreaper-checks.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/exit-reparent-document-the-has_child_subreaper-checks.patch
		echo and later at
		echo  http://ozlabs.org/~akpm/mmotm/broken-out/exit-reparent-document-the-has_child_subreaper-checks.patch

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
Subject: exit: reparent: document the ->has_child_subreaper checks

Swap the "init_task" and same_thread_group() checks.  This way it is more
simple to document these checks and we can remove the link to the previous
discussion on lkml.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: Aaron Tomlin <atomlin@redhat.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Kay Sievers <kay@vrfy.org>
Cc: Lennart Poettering <lennart@poettering.net>
Cc: Sterling Alexander <stalexan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/exit.c |   14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff -puN kernel/exit.c~exit-reparent-document-the-has_child_subreaper-checks kernel/exit.c
--- a/kernel/exit.c~exit-reparent-document-the-has_child_subreaper-checks
+++ a/kernel/exit.c
@@ -498,18 +498,16 @@ static struct task_struct *find_new_reap
 
 	if (father->signal->has_child_subreaper) {
 		struct task_struct *reaper;
-
 		/*
-		 * Find the first ancestor marked as child_subreaper.
-		 * Note that the code below checks same_thread_group(reaper,
-		 * pid_ns->child_reaper).  This is what we need to DTRT in a
-		 * PID namespace. However we still need the check above, see
-		 * http://marc.info/?l=linux-kernel&m=131385460420380
+		 * Find the first ->is_child_subreaper ancestor in our pid_ns.
+		 * We start from father to ensure we can not look into another
+		 * namespace, this is safe because all its threads are dead.
 		 */
 		for (reaper = father;
-		     reaper != &init_task;
+		     !same_thread_group(reaper, pid_ns->child_reaper);
 		     reaper = reaper->real_parent) {
-			if (same_thread_group(reaper, pid_ns->child_reaper))
+			/* call_usermodehelper() descendants need this check */
+			if (reaper == &init_task)
 				break;
 			if (!reaper->signal->is_child_subreaper)
 				continue;
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

