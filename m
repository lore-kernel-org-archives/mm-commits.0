From: akpm@linux-foundation.org
Subject: - coredump-elf_fdpic_core_dump-use-core_state-dumper-list.patch removed from -mm tree
Date: Fri, 25 Jul 2008 16:00:04 -0700
Message-ID: <200807252300.m6PN04tT003551@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56527 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751536AbYGYXA5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 25 Jul 2008 19:00:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@tv-sign.ru, dhowells@redhat.com, roland@redhat.com, mm-commits@vger.kernel.org


The patch titled
     coredump: elf_fdpic_core_dump: use core_state->dumper list
has been removed from the -mm tree.  Its filename was
     coredump-elf_fdpic_core_dump-use-core_state-dumper-list.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: coredump: elf_fdpic_core_dump: use core_state->dumper list
From: Oleg Nesterov <oleg@tv-sign.ru>

Kill the nasty rcu_read_lock() + do_each_thread() loop, use the list
encoded in mm->core_state instead, s/GFP_ATOMIC/GFP_KERNEL/.

This patch allows futher cleanups in binfmt_elf_fdpic.c.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Acked-by: Roland McGrath <roland@redhat.com>
Cc: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/binfmt_elf_fdpic.c |   29 ++++++++++++-----------------
 1 file changed, 12 insertions(+), 17 deletions(-)

diff -puN fs/binfmt_elf_fdpic.c~coredump-elf_fdpic_core_dump-use-core_state-dumper-list fs/binfmt_elf_fdpic.c
--- a/fs/binfmt_elf_fdpic.c~coredump-elf_fdpic_core_dump-use-core_state-dumper-list
+++ a/fs/binfmt_elf_fdpic.c
@@ -1573,7 +1573,6 @@ static int elf_fdpic_core_dump(long sign
 	struct memelfnote *notes = NULL;
 	struct elf_prstatus *prstatus = NULL;	/* NT_PRSTATUS */
 	struct elf_prpsinfo *psinfo = NULL;	/* NT_PRPSINFO */
- 	struct task_struct *g, *p;
  	LIST_HEAD(thread_list);
  	struct list_head *t;
 	elf_fpregset_t *fpu = NULL;
@@ -1622,23 +1621,19 @@ static int elf_fdpic_core_dump(long sign
 #endif
 
 	if (signr) {
+		struct core_thread *ct;
 		struct elf_thread_status *tmp;
-		rcu_read_lock();
-		do_each_thread(g,p)
-			if (current->mm == p->mm && current != p) {
-				if (p->flags & PF_KTHREAD)
-					continue;
-
-				tmp = kzalloc(sizeof(*tmp), GFP_ATOMIC);
-				if (!tmp) {
-					rcu_read_unlock();
-					goto cleanup;
-				}
-				tmp->thread = p;
-				list_add(&tmp->list, &thread_list);
-			}
-		while_each_thread(g,p);
-		rcu_read_unlock();
+
+		for (ct = current->mm->core_state->dumper.next;
+						ct; ct = ct->next) {
+			tmp = kzalloc(sizeof(*tmp), GFP_KERNEL);
+			if (!tmp)
+				goto cleanup;
+
+			tmp->thread = ct->task;
+			list_add(&tmp->list, &thread_list);
+		}
+
 		list_for_each(t, &thread_list) {
 			struct elf_thread_status *tmp;
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

