From: akpm@linux-foundation.org
Subject: + exit-reparent-cleanup-the-changing-of-parent.patch added to -mm tree
Date: Wed, 12 Nov 2014 14:56:28 -0800
Message-ID: <5463e59c.y1TlW0zFlMWD7eTM%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49804 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752273AbaKLW43 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 12 Nov 2014 17:56:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@redhat.com, adobriyan@gmail.com, atomlin@redhat.com, ebiederm@xmission.com, peterz@infradead.org, roland@hack.frob.com, stalexan@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: exit: reparent: cleanup the changing of ->parent
has been added to the -mm tree.  Its filename is
     exit-reparent-cleanup-the-changing-of-parent.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/exit-reparent-cleanup-the-changing-of-parent.patch
		echo and later at
		echo  http://ozlabs.org/~akpm/mmotm/broken-out/exit-reparent-cleanup-the-changing-of-parent.patch

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
Subject: exit: reparent: cleanup the changing of ->parent

1. Cosmetic, but "if (t->parent == father)" looks a bit confusing.
   We need to change t->parent if and only if t is not traced.

2. If we actually want this BUG_ON() to ensure that parent/ptrace
   match each other, then we should also take ptrace_reparented()
   case into account too.

3. Change this code to use for_each_thread() instead of deprecated
   while_each_thread().

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: Aaron Tomlin <atomlin@redhat.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
Cc: Sterling Alexander <stalexan@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Roland McGrath <roland@hack.frob.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/exit.c |   13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

diff -puN kernel/exit.c~exit-reparent-cleanup-the-changing-of-parent kernel/exit.c
--- a/kernel/exit.c~exit-reparent-cleanup-the-changing-of-parent
+++ a/kernel/exit.c
@@ -557,7 +557,7 @@ static void reparent_leader(struct task_
 
 static void forget_original_parent(struct task_struct *father)
 {
-	struct task_struct *p, *n, *reaper;
+	struct task_struct *p, *t, *n, *reaper;
 	LIST_HEAD(dead_children);
 
 	write_lock_irq(&tasklist_lock);
@@ -569,18 +569,15 @@ static void forget_original_parent(struc
 	reaper = find_new_reaper(father);
 
 	list_for_each_entry_safe(p, n, &father->children, sibling) {
-		struct task_struct *t = p;
-
-		do {
+		for_each_thread(p, t) {
 			t->real_parent = reaper;
-			if (t->parent == father) {
-				BUG_ON(t->ptrace);
+			BUG_ON(!t->ptrace != (t->parent == father));
+			if (likely(!t->ptrace))
 				t->parent = t->real_parent;
-			}
 			if (t->pdeath_signal)
 				group_send_sig_info(t->pdeath_signal,
 						    SEND_SIG_NOINFO, t);
-		} while_each_thread(p, t);
+		}
 		reparent_leader(father, p, &dead_children);
 	}
 	write_unlock_irq(&tasklist_lock);
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

