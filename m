From: akpm@linux-foundation.org
Subject: + shrink-task_struct-if-config_futex=n.patch added to -mm tree
Date: Thu, 23 Aug 2007 14:12:43 -0700
Message-ID: <200708232112.l7NLChmb027143@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39063 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759703AbXHWVN7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 23 Aug 2007 17:13:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: adobriyan@sw.ru, mingo@elte.hu


The patch titled
     Shrink task_struct if CONFIG_FUTEX=n
has been added to the -mm tree.  Its filename is
     shrink-task_struct-if-config_futex=n.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Shrink task_struct if CONFIG_FUTEX=n
From: Alexey Dobriyan <adobriyan@sw.ru>

robust_list, compat_robust_list, pi_state_list, pi_state_cache are
really used if futexes are on.

Signed-off-by: Alexey Dobriyan <adobriyan@sw.ru>
Acked-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/sched.h |    3 ++-
 kernel/exit.c         |    6 +++++-
 kernel/fork.c         |    3 ++-
 3 files changed, 9 insertions(+), 3 deletions(-)

diff -puN include/linux/sched.h~shrink-task_struct-if-config_futex=n include/linux/sched.h
--- a/include/linux/sched.h~shrink-task_struct-if-config_futex=n
+++ a/include/linux/sched.h
@@ -1095,13 +1095,14 @@ struct task_struct {
 	int cpuset_mems_generation;
 	int cpuset_mem_spread_rotor;
 #endif
+#ifdef CONFIG_FUTEX
 	struct robust_list_head __user *robust_list;
 #ifdef CONFIG_COMPAT
 	struct compat_robust_list_head __user *compat_robust_list;
 #endif
 	struct list_head pi_state_list;
 	struct futex_pi_state *pi_state_cache;
-
+#endif
 	atomic_t fs_excl;	/* holding fs exclusive resources */
 	struct rcu_head rcu;
 
diff -puN kernel/exit.c~shrink-task_struct-if-config_futex=n kernel/exit.c
--- a/kernel/exit.c~shrink-task_struct-if-config_futex=n
+++ a/kernel/exit.c
@@ -955,12 +955,14 @@ fastcall NORET_TYPE void do_exit(long co
 		exit_itimers(tsk->signal);
 	}
 	acct_collect(code, group_dead);
+#ifdef CONFIG_FUTEX
 	if (unlikely(tsk->robust_list))
 		exit_robust_list(tsk);
-#if defined(CONFIG_FUTEX) && defined(CONFIG_COMPAT)
+#ifdef CONFIG_COMPAT
 	if (unlikely(tsk->compat_robust_list))
 		compat_exit_robust_list(tsk);
 #endif
+#endif
 	if (group_dead)
 		tty_audit_exit();
 	if (unlikely(tsk->audit_context))
@@ -995,6 +997,7 @@ fastcall NORET_TYPE void do_exit(long co
 	mpol_free(tsk->mempolicy);
 	tsk->mempolicy = NULL;
 #endif
+#ifdef CONFIG_FUTEX
 	/*
 	 * This must happen late, after the PID is not
 	 * hashed anymore:
@@ -1003,6 +1006,7 @@ fastcall NORET_TYPE void do_exit(long co
 		exit_pi_state_list(tsk);
 	if (unlikely(current->pi_state_cache))
 		kfree(current->pi_state_cache);
+#endif
 	/*
 	 * Make sure we are holding no locks:
 	 */
diff -puN kernel/fork.c~shrink-task_struct-if-config_futex=n kernel/fork.c
--- a/kernel/fork.c~shrink-task_struct-if-config_futex=n
+++ a/kernel/fork.c
@@ -1140,13 +1140,14 @@ static struct task_struct *copy_process(
 	 * Clear TID on mm_release()?
 	 */
 	p->clear_child_tid = (clone_flags & CLONE_CHILD_CLEARTID) ? child_tidptr: NULL;
+#ifdef CONFIG_FUTEX
 	p->robust_list = NULL;
 #ifdef CONFIG_COMPAT
 	p->compat_robust_list = NULL;
 #endif
 	INIT_LIST_HEAD(&p->pi_state_list);
 	p->pi_state_cache = NULL;
-
+#endif
 	/*
 	 * sigaltstack should be cleared when sharing the same VM
 	 */
_

Patches currently in -mm which might be from adobriyan@sw.ru are

fix-ver_linux-glibc-version-printing.patch
consolidate-ptrace_detach.patch
use-list_head-in-binfmt-handling-update.patch
make-unregister_binfmt-return-void.patch
slab_panic-more-proc-posix-timers-shmem.patch
add-kernel-notifierc.patch
add-kernel-notifierc-fix.patch
add-kernel-notifierc-fix-2.patch
tweak-proc-ipmi-removal.patch
shrink-task_struct-if-config_futex=n.patch
lguest-should-depend-on-config_futex.patch
sysctl-core-stop-using-the-unnecessary-ctl_table-typedef.patch
sysctl-factor-out-sysctl_data.patch
sysctl-error-on-bad-sysctl-tables.patch
sysctl-update-sysctl_check_table.patch
sysct-mqueue-remove-the-binary-sysctl-numbers.patch
sysctl-remove-binary-sysctl-support-where-it-clearly-doesnt-work.patch
sysctl-fix-neighbour-table-sysctls.patch
sysctl-ipv6-route-flushing-kill-binary-path.patch
sysctl-remove-broken-sunrpc-debug-binary-sysctls.patch
sysctl-x86_64-remove-unnecessary-binary-paths.patch
sysctl-remove-broken-cdrom-binary-sysctls.patch
sysctl-ipv4-remove-binary-sysctl-paths-where-they-are-broken.patch
sysctl-remove-the-binary-interface-for-aio-nr-aio-max-nr-acpi_video_flags.patch
single_open-seq_release-leak-diagnostics.patch
