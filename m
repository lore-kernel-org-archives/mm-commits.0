From: akpm@linux-foundation.org
Subject: + exit-reparent-cleanup-the-usage-of-reparent_leader.patch added
 to -mm tree
Date: Wed, 12 Nov 2014 14:56:30 -0800
Message-ID: <5463e59e.zoo7sbeZQWlx3eo4%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49810 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752352AbaKLW4c (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 12 Nov 2014 17:56:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@redhat.com, adobriyan@gmail.com, atomlin@redhat.com, ebiederm@xmission.com, peterz@infradead.org, roland@hack.frob.com, stalexan@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: exit: reparent: cleanup the usage of reparent_leader()
has been added to the -mm tree.  Its filename is
     exit-reparent-cleanup-the-usage-of-reparent_leader.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/exit-reparent-cleanup-the-usage-of-reparent_leader.patch
		echo and later at
		echo  http://ozlabs.org/~akpm/mmotm/broken-out/exit-reparent-cleanup-the-usage-of-reparent_leader.patch

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
Subject: exit: reparent: cleanup the usage of reparent_leader()

1. Now that reparent_leader() doesn't abuse ->sibling we can shift
   list_move_tail() from reparent_leader() to forget_original_parent()
   and turn it into a single list_splice_tail_init(). This also makes
   BUG_ON(!list_empty()) and list_for_each_entry_safe() unnecessary.

2. This also allows to shift the same_thread_group() check, it looks
   a bit more clear in the caller.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: Aaron Tomlin <atomlin@redhat.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
Cc: Sterling Alexander <stalexan@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Roland McGrath <roland@hack.frob.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/exit.c |   22 +++++++++-------------
 1 file changed, 9 insertions(+), 13 deletions(-)

diff -puN kernel/exit.c~exit-reparent-cleanup-the-usage-of-reparent_leader kernel/exit.c
--- a/kernel/exit.c~exit-reparent-cleanup-the-usage-of-reparent_leader
+++ a/kernel/exit.c
@@ -529,15 +529,7 @@ static struct task_struct *find_new_reap
 static void reparent_leader(struct task_struct *father, struct task_struct *p,
 				struct list_head *dead)
 {
-	list_move_tail(&p->sibling, &p->real_parent->children);
-
-	if (p->exit_state == EXIT_DEAD)
-		return;
-	/*
-	 * If this is a threaded reparent there is no need to
-	 * notify anyone anything has happened.
-	 */
-	if (same_thread_group(p->real_parent, father))
+	if (unlikely(p->exit_state == EXIT_DEAD))
 		return;
 
 	/* We don't want people slaying init. */
@@ -568,7 +560,7 @@ static void forget_original_parent(struc
 	exit_ptrace(father);
 	reaper = find_new_reaper(father);
 
-	list_for_each_entry_safe(p, n, &father->children, sibling) {
+	list_for_each_entry(p, &father->children, sibling) {
 		for_each_thread(p, t) {
 			t->real_parent = reaper;
 			BUG_ON(!t->ptrace != (t->parent == father));
@@ -578,12 +570,16 @@ static void forget_original_parent(struc
 				group_send_sig_info(t->pdeath_signal,
 						    SEND_SIG_NOINFO, t);
 		}
-		reparent_leader(father, p, &dead_children);
+		/*
+		 * If this is a threaded reparent there is no need to
+		 * notify anyone anything has happened.
+		 */
+		if (!same_thread_group(reaper, father))
+			reparent_leader(father, p, &dead_children);
 	}
+	list_splice_tail_init(&father->children, &reaper->children);
 	write_unlock_irq(&tasklist_lock);
 
-	BUG_ON(!list_empty(&father->children));
-
 	list_for_each_entry_safe(p, n, &dead_children, ptrace_entry) {
 		list_del_init(&p->ptrace_entry);
 		release_task(p);
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

