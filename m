From: akpm@linux-foundation.org
Subject: + elf_core_dump-use-rcu_read_lock-to-access-real_parent.patch added to -mm tree
Date: Wed, 29 Apr 2009 14:48:27 -0700
Message-ID: <200904292148.n3TLmR6Z012896@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35286 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752548AbZD2Vt7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 29 Apr 2009 17:49:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@redhat.com, dhowells@redhat.com, roland@redhat.com


The patch titled
     elf_core_dump: use rcu_read_lock() to access ->real_parent
has been added to the -mm tree.  Its filename is
     elf_core_dump-use-rcu_read_lock-to-access-real_parent.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: elf_core_dump: use rcu_read_lock() to access ->real_parent
From: Oleg Nesterov <oleg@redhat.com>

In theory it is not safe to dereference ->parent/real_parent without
tasklist or rcu lock, we can race with re-parenting.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Roland McGrath <roland@redhat.com>
Cc: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/binfmt_elf.c       |    8 ++++++--
 fs/binfmt_elf_fdpic.c |    8 ++++++--
 2 files changed, 12 insertions(+), 4 deletions(-)

diff -puN fs/binfmt_elf.c~elf_core_dump-use-rcu_read_lock-to-access-real_parent fs/binfmt_elf.c
--- a/fs/binfmt_elf.c~elf_core_dump-use-rcu_read_lock-to-access-real_parent
+++ a/fs/binfmt_elf.c
@@ -1340,8 +1340,10 @@ static void fill_prstatus(struct elf_prs
 	prstatus->pr_info.si_signo = prstatus->pr_cursig = signr;
 	prstatus->pr_sigpend = p->pending.signal.sig[0];
 	prstatus->pr_sighold = p->blocked.sig[0];
+	rcu_read_lock();
+	prstatus->pr_ppid = task_pid_vnr(rcu_dereference(p->real_parent));
+	rcu_read_unlock();
 	prstatus->pr_pid = task_pid_vnr(p);
-	prstatus->pr_ppid = task_pid_vnr(p->real_parent);
 	prstatus->pr_pgrp = task_pgrp_vnr(p);
 	prstatus->pr_sid = task_session_vnr(p);
 	if (thread_group_leader(p)) {
@@ -1382,8 +1384,10 @@ static int fill_psinfo(struct elf_prpsin
 			psinfo->pr_psargs[i] = ' ';
 	psinfo->pr_psargs[len] = 0;
 
+	rcu_read_lock();
+	psinfo->pr_ppid = task_pid_vnr(rcu_dereference(p->real_parent));
+	rcu_read_unlock();
 	psinfo->pr_pid = task_pid_vnr(p);
-	psinfo->pr_ppid = task_pid_vnr(p->real_parent);
 	psinfo->pr_pgrp = task_pgrp_vnr(p);
 	psinfo->pr_sid = task_session_vnr(p);
 
diff -puN fs/binfmt_elf_fdpic.c~elf_core_dump-use-rcu_read_lock-to-access-real_parent fs/binfmt_elf_fdpic.c
--- a/fs/binfmt_elf_fdpic.c~elf_core_dump-use-rcu_read_lock-to-access-real_parent
+++ a/fs/binfmt_elf_fdpic.c
@@ -1387,8 +1387,10 @@ static void fill_prstatus(struct elf_prs
 	prstatus->pr_info.si_signo = prstatus->pr_cursig = signr;
 	prstatus->pr_sigpend = p->pending.signal.sig[0];
 	prstatus->pr_sighold = p->blocked.sig[0];
+	rcu_read_lock();
+	prstatus->pr_ppid = task_pid_vnr(rcu_dereference(p->real_parent));
+	rcu_read_unlock();
 	prstatus->pr_pid = task_pid_vnr(p);
-	prstatus->pr_ppid = task_pid_vnr(p->real_parent);
 	prstatus->pr_pgrp = task_pgrp_vnr(p);
 	prstatus->pr_sid = task_session_vnr(p);
 	if (thread_group_leader(p)) {
@@ -1432,8 +1434,10 @@ static int fill_psinfo(struct elf_prpsin
 			psinfo->pr_psargs[i] = ' ';
 	psinfo->pr_psargs[len] = 0;
 
+	rcu_read_lock();
+	psinfo->pr_ppid = task_pid_vnr(rcu_dereference(p->real_parent));
+	rcu_read_unlock();
 	psinfo->pr_pid = task_pid_vnr(p);
-	psinfo->pr_ppid = task_pid_vnr(p->real_parent);
 	psinfo->pr_pgrp = task_pgrp_vnr(p);
 	psinfo->pr_sid = task_session_vnr(p);
 
_

Patches currently in -mm which might be from oleg@redhat.com are

origin.patch
maintainers-add-ptrace-entry.patch
linux-next.patch
ptrace-s-parent-real_parent-in-binfmt_elf_fdpicc.patch
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
copy_process-remove-the-unneeded-clear_tsk_thread_flagtif_sigpending.patch
elf_core_dump-use-rcu_read_lock-to-access-real_parent.patch
kthreads-simplify-the-startup-synchronization.patch
kthreads-rework-kthread_stop.patch
kthreads-simplify-migration_thread-exit-path.patch
signals-split-do_tkill.patch
signals-implement-sys_rt_tgsigqueueinfo.patch
x86-hookup-sys_rt_tgsigqueueinfo.patch
signals-tracehook_notify_jctl-change.patch

