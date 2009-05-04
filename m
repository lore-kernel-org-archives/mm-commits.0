From: akpm@linux-foundation.org
Subject: [merged] ptrace-s-parent-real_parent-in-binfmt_elf_fdpicc.patch removed from -mm tree
Date: Mon, 04 May 2009 13:13:35 -0700
Message-ID: <200905042013.n44KDZog022621@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51718 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751667AbZEDURH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 4 May 2009 16:17:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@redhat.com, dhowells@redhat.com, gerg@snapgear.com, roland@redhat.com, mm-commits@vger.kernel.org


The patch titled
     ptrace: s/parent/real_parent/ in binfmt_elf_fdpic.c
has been removed from the -mm tree.  Its filename was
     ptrace-s-parent-real_parent-in-binfmt_elf_fdpicc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ptrace: s/parent/real_parent/ in binfmt_elf_fdpic.c
From: Oleg Nesterov <oleg@redhat.com>

->real_parent is the parent. ->parent may be the tracer.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: David Howells <dhowells@redhat.com>
Acked-by: Roland McGrath <roland@redhat.com>
Cc: Greg Ungerer <gerg@snapgear.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/binfmt_elf_fdpic.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN fs/binfmt_elf_fdpic.c~ptrace-s-parent-real_parent-in-binfmt_elf_fdpicc fs/binfmt_elf_fdpic.c
--- a/fs/binfmt_elf_fdpic.c~ptrace-s-parent-real_parent-in-binfmt_elf_fdpicc
+++ a/fs/binfmt_elf_fdpic.c
@@ -1388,7 +1388,7 @@ static void fill_prstatus(struct elf_prs
 	prstatus->pr_sigpend = p->pending.signal.sig[0];
 	prstatus->pr_sighold = p->blocked.sig[0];
 	prstatus->pr_pid = task_pid_vnr(p);
-	prstatus->pr_ppid = task_pid_vnr(p->parent);
+	prstatus->pr_ppid = task_pid_vnr(p->real_parent);
 	prstatus->pr_pgrp = task_pgrp_vnr(p);
 	prstatus->pr_sid = task_session_vnr(p);
 	if (thread_group_leader(p)) {
@@ -1433,7 +1433,7 @@ static int fill_psinfo(struct elf_prpsin
 	psinfo->pr_psargs[len] = 0;
 
 	psinfo->pr_pid = task_pid_vnr(p);
-	psinfo->pr_ppid = task_pid_vnr(p->parent);
+	psinfo->pr_ppid = task_pid_vnr(p->real_parent);
 	psinfo->pr_pgrp = task_pgrp_vnr(p);
 	psinfo->pr_sid = task_session_vnr(p);
 
_

Patches currently in -mm which might be from oleg@redhat.com are

origin.patch
linux-next.patch
slow_work_thread-should-do-the-exclusive-wait.patch
rework-fix-is_single_threaded.patch
getrusage-fill-ru_maxrss-value.patch
ptrace-remove-pt_dtrace-from-arch-h8300.patch
ptrace-remove-pt_dtrace-from-avr32-mn10300-parisc-s390-sh-xtensa.patch
ptrace-remove-pt_dtrace-from-m68k-m68knommu.patch
ptrace-remove-pt_dtrace-from-arch-m32r.patch
ptrace-mm_need_new_owner-use-real_parent-to-search-in-the-siblings.patch
ptrace-tracehook_unsafe_exec-remove-the-stale-comment.patch
ptrace-tracehook_unsafe_exec-remove-the-stale-comment-fix.patch
ptrace-do-not-use-task-ptrace-directly-in-core-kernel.patch
copy_process-remove-the-unneeded-clear_tsk_thread_flagtif_sigpending.patch
elf_core_dump-use-rcu_read_lock-to-access-real_parent.patch
kthreads-simplify-the-startup-synchronization.patch
kthreads-rework-kthread_stop.patch
kthreads-simplify-migration_thread-exit-path.patch
signals-split-do_tkill.patch
signals-implement-sys_rt_tgsigqueueinfo.patch
x86-hookup-sys_rt_tgsigqueueinfo.patch
signals-tracehook_notify_jctl-change.patch

