From: akpm@linux-foundation.org
Subject: - coredump-elf_core_dump-use-core_state-dumper-list.patch removed from -mm tree
Date: Fri, 25 Jul 2008 16:00:02 -0700
Message-ID: <200807252300.m6PN02ie003545@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41729 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752573AbYGYXAv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 25 Jul 2008 19:00:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@tv-sign.ru, roland@redhat.com, mm-commits@vger.kernel.org


The patch titled
     coredump: elf_core_dump: use core_state->dumper list
has been removed from the -mm tree.  Its filename was
     coredump-elf_core_dump-use-core_state-dumper-list.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: coredump: elf_core_dump: use core_state->dumper list
From: Oleg Nesterov <oleg@tv-sign.ru>

Kill the nasty rcu_read_lock() + do_each_thread() loop, use the list
encoded in mm->core_state instead, s/GFP_ATOMIC/GFP_KERNEL/.

This patch allows futher cleanups in binfmt_elf.c, in particular we can
kill the parallel info->threads list.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Acked-by: Roland McGrath <roland@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/binfmt_elf.c |   77 +++++++++++++++++++---------------------------
 1 file changed, 32 insertions(+), 45 deletions(-)

diff -puN fs/binfmt_elf.c~coredump-elf_core_dump-use-core_state-dumper-list fs/binfmt_elf.c
--- a/fs/binfmt_elf.c~coredump-elf_core_dump-use-core_state-dumper-list
+++ a/fs/binfmt_elf.c
@@ -1478,7 +1478,7 @@ static int fill_note_info(struct elfhdr 
 	const struct user_regset_view *view = task_user_regset_view(dump_task);
 	struct elf_thread_core_info *t;
 	struct elf_prpsinfo *psinfo;
-	struct task_struct *g, *p;
+	struct core_thread *ct;
 	unsigned int i;
 
 	info->size = 0;
@@ -1517,34 +1517,26 @@ static int fill_note_info(struct elfhdr 
 	/*
 	 * Allocate a structure for each thread.
 	 */
-	rcu_read_lock();
-	do_each_thread(g, p)
-		if (p->mm == dump_task->mm) {
-			if (p->flags & PF_KTHREAD)
-				continue;
-
-			t = kzalloc(offsetof(struct elf_thread_core_info,
-					     notes[info->thread_notes]),
-				    GFP_ATOMIC);
-			if (unlikely(!t)) {
-				rcu_read_unlock();
-				return 0;
-			}
-			t->task = p;
-			if (p == dump_task || !info->thread) {
-				t->next = info->thread;
-				info->thread = t;
-			} else {
-				/*
-				 * Make sure to keep the original task at
-				 * the head of the list.
-				 */
-				t->next = info->thread->next;
-				info->thread->next = t;
-			}
+	for (ct = &dump_task->mm->core_state->dumper; ct; ct = ct->next) {
+		t = kzalloc(offsetof(struct elf_thread_core_info,
+				     notes[info->thread_notes]),
+			    GFP_KERNEL);
+		if (unlikely(!t))
+			return 0;
+
+		t->task = ct->task;
+		if (ct->task == dump_task || !info->thread) {
+			t->next = info->thread;
+			info->thread = t;
+		} else {
+			/*
+			 * Make sure to keep the original task at
+			 * the head of the list.
+			 */
+			t->next = info->thread->next;
+			info->thread->next = t;
 		}
-	while_each_thread(g, p);
-	rcu_read_unlock();
+	}
 
 	/*
 	 * Now fill in each thread's information.
@@ -1691,7 +1683,6 @@ static int fill_note_info(struct elfhdr 
 {
 #define	NUM_NOTES	6
 	struct list_head *t;
-	struct task_struct *g, *p;
 
 	info->notes = NULL;
 	info->prstatus = NULL;
@@ -1723,23 +1714,19 @@ static int fill_note_info(struct elfhdr 
 
 	info->thread_status_size = 0;
 	if (signr) {
+		struct core_thread *ct;
 		struct elf_thread_status *ets;
-		rcu_read_lock();
-		do_each_thread(g, p)
-			if (current->mm == p->mm && current != p) {
-				if (p->flags & PF_KTHREAD)
-					continue;
-
-				ets = kzalloc(sizeof(*ets), GFP_ATOMIC);
-				if (!ets) {
-					rcu_read_unlock();
-					return 0;
-				}
-				ets->thread = p;
-				list_add(&ets->list, &info->thread_list);
-			}
-		while_each_thread(g, p);
-		rcu_read_unlock();
+
+		for (ct = current->mm->core_state->dumper.next;
+						ct; ct = ct->next) {
+			ets = kzalloc(sizeof(*ets), GFP_KERNEL);
+			if (!ets)
+				return 0;
+
+			ets->thread = ct->task;
+			list_add(&ets->list, &info->thread_list);
+		}
+
 		list_for_each(t, &info->thread_list) {
 			int sz;
 
_

Patches currently in -mm which might be from oleg@tv-sign.ru are

origin.patch
linux-next.patch
migrate_timers-add-comment-use-spinlock_irq.patch
tracehook-add-linux-tracehookh.patch
tracehook-exec.patch
tracehook-unexport-ptrace_notify.patch
tracehook-exit.patch
tracehook-clone.patch
tracehook-vfork-done.patch
tracehook-release_task.patch
tracehook-tracehook_tracer_task.patch
tracehook-tracehook_expect_breakpoints.patch
tracehook-tracehook_signal_handler.patch
tracehook-tracehook_consider_ignored_signal.patch
tracehook-tracehook_consider_fatal_signal.patch
tracehook-syscall.patch
tracehook-get_signal_to_deliver.patch
tracehook-job-control.patch
tracehook-death.patch
tracehook-force-signal_pending.patch
tracehook-tif_notify_resume.patch
tracehook-asm-syscallh.patch
tracehook-config_have_arch_tracehook.patch
tracehook-wait_task_inactive.patch
task_current_syscall.patch
proc-pid-syscall.patch

