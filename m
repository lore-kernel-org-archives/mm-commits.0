From: akpm@linux-foundation.org
Subject: - elfcore-compat-fix-uid-gid-types.patch removed from -mm tree
Date: Fri, 29 Feb 2008 16:46:12 -0800
Message-ID: <200803010046.m210kCnr029024@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:34298 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752073AbYCAArE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 29 Feb 2008 19:47:04 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: roland@redhat.com, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     elfcore-compat: fix uid/gid types
has been removed from the -mm tree.  Its filename was
     elfcore-compat-fix-uid-gid-types.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: elfcore-compat: fix uid/gid types
From: Roland McGrath <roland@redhat.com>

I overlooked the difference between __kernel_uid_t and uid_t when defining
struct compat_elf_prpsinfo.  The result is a regression in 32-bit core dumps
on x86_64, where the NT_PRPSINFO note has the wrong size and layout.  This
patch fixes it.

Signed-off-by: Roland McGrath <roland@redhat.com>
Acked-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/elfcore-compat.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN include/linux/elfcore-compat.h~elfcore-compat-fix-uid-gid-types include/linux/elfcore-compat.h
--- a/include/linux/elfcore-compat.h~elfcore-compat-fix-uid-gid-types
+++ a/include/linux/elfcore-compat.h
@@ -45,8 +45,8 @@ struct compat_elf_prpsinfo
 	char				pr_zomb;
 	char				pr_nice;
 	compat_ulong_t			pr_flag;
-	compat_uid_t			pr_uid;
-	compat_gid_t			pr_gid;
+	__compat_uid_t			pr_uid;
+	__compat_gid_t			pr_gid;
 	compat_pid_t			pr_pid, pr_ppid, pr_pgrp, pr_sid;
 	char				pr_fname[16];
 	char				pr_psargs[ELF_PRARGSZ];
_

Patches currently in -mm which might be from roland@redhat.com are

origin.patch
core-dump-user_regset-writeback.patch
git-x86.patch
arch-x86-kernel-ptracec-fix-defined-but-unused-warnings.patch
add-rusage_thread.patch
remove-unused-variable-from-send_signal.patch
turn-legacy_queue-macro-into-static-inline-function.patch
consolidate-checking-for-ignored-legacy-signals.patch
consolidate-checking-for-ignored-legacy-signals-simplify.patch
signals-do_signal_stop-use-signal_group_exit.patch
signals-do_group_exit-use-signal_group_exit-more-consistently.patch
lock_task_sighand-add-rcu-lock-unlock.patch
k_getrusage-dont-take-rcu_read_lock.patch
do_task_stat-dont-take-rcu_read_lock.patch
signals-consolidate-checks-for-whether-or-not-to-ignore-a-signal.patch
signals-clean-dequeue_signal-from-excess-checks-and-assignments.patch
signals-consolidate-send_sigqueue-and-send_group_sigqueue.patch
signals-cleanup-security_task_kill-usage-implementation.patch
free_pidmap-turn-it-into-free_pidmapstruct-upid.patch
put_pid-make-sure-we-dont-free-the-live-pid.patch

