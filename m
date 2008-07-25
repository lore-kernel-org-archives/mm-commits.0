From: akpm@linux-foundation.org
Subject: - coredump-elf_core_dump-skip-kernel-threads.patch removed from -mm tree
Date: Fri, 25 Jul 2008 15:59:52 -0700
Message-ID: <200807252259.m6PMxqhp003427@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53866 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754881AbYGYXGt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 25 Jul 2008 19:06:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@tv-sign.ru, roland@redhat.com, mm-commits@vger.kernel.org


The patch titled
     coredump: elf_core_dump: skip kernel threads
has been removed from the -mm tree.  Its filename was
     coredump-elf_core_dump-skip-kernel-threads.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: coredump: elf_core_dump: skip kernel threads
From: Oleg Nesterov <oleg@tv-sign.ru>

linux_binfmt->core_dump() runs before the process does exit_aio(), this
means that we can hit the kernel thread which shares the same ->mm. 
Afaics, nothing really bad can happen, but perhaps it makes sense to fix
this minor bug.

It is sad we have to iterate over all threads in system and use
GFP_ATOMIC.  Hopefully we can kill theses ugly do_each_thread()s, but this
needs some nontrivial changes in mm_struct and do_coredump.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Roland McGrath <roland@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/binfmt_elf.c       |    6 ++++++
 fs/binfmt_elf_fdpic.c |    3 +++
 2 files changed, 9 insertions(+)

diff -puN fs/binfmt_elf.c~coredump-elf_core_dump-skip-kernel-threads fs/binfmt_elf.c
--- a/fs/binfmt_elf.c~coredump-elf_core_dump-skip-kernel-threads
+++ a/fs/binfmt_elf.c
@@ -1520,6 +1520,9 @@ static int fill_note_info(struct elfhdr 
 	rcu_read_lock();
 	do_each_thread(g, p)
 		if (p->mm == dump_task->mm) {
+			if (p->flags & PF_KTHREAD)
+				continue;
+
 			t = kzalloc(offsetof(struct elf_thread_core_info,
 					     notes[info->thread_notes]),
 				    GFP_ATOMIC);
@@ -1724,6 +1727,9 @@ static int fill_note_info(struct elfhdr 
 		rcu_read_lock();
 		do_each_thread(g, p)
 			if (current->mm == p->mm && current != p) {
+				if (p->flags & PF_KTHREAD)
+					continue;
+
 				ets = kzalloc(sizeof(*ets), GFP_ATOMIC);
 				if (!ets) {
 					rcu_read_unlock();
diff -puN fs/binfmt_elf_fdpic.c~coredump-elf_core_dump-skip-kernel-threads fs/binfmt_elf_fdpic.c
--- a/fs/binfmt_elf_fdpic.c~coredump-elf_core_dump-skip-kernel-threads
+++ a/fs/binfmt_elf_fdpic.c
@@ -1626,6 +1626,9 @@ static int elf_fdpic_core_dump(long sign
 		rcu_read_lock();
 		do_each_thread(g,p)
 			if (current->mm == p->mm && current != p) {
+				if (p->flags & PF_KTHREAD)
+					continue;
+
 				tmp = kzalloc(sizeof(*tmp), GFP_ATOMIC);
 				if (!tmp) {
 					rcu_read_unlock();
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

