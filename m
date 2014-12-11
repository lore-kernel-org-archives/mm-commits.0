From: akpm@linux-foundation.org
Subject: [merged] exit-reparent-cleanup-the-usage-of-reparent_leader.patch removed from -mm tree
Date: Thu, 11 Dec 2014 10:58:23 -0800
Message-ID: <5489e94f.PtgsxUoANFe1/eRG%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45510 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758427AbaLKS6Y (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 11 Dec 2014 13:58:24 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@redhat.com, adobriyan@gmail.com, atomlin@redhat.com, ebiederm@xmission.com, peterz@infradead.org, roland@hack.frob.com, stalexan@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: exit: reparent: cleanup the usage of reparent_leader()
has been removed from the -mm tree.  Its filename was
     exit-reparent-cleanup-the-usage-of-reparent_leader.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
 			BUG_ON((!t->ptrace) != (t->parent == father));
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

