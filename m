From: akpm@linux-foundation.org
Subject: [folded] do_wait-wakeup-optimization-change-__wake_up_parent-to-use-filtered-wakeup-selinux_bprm_committed_creds-use-__wake_up_parent.patch removed from -mm tree
Date: Wed, 23 Sep 2009 15:33:41 -0700
Message-ID: <200909232233.n8NMXflV025618@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44322 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751977AbZIWWeG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Sep 2009 18:34:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@redhat.com, dhowells@redhat.com, jmorris@namei.org, mingo@elte.hu, rnalumasu@gmail.com, roland@redhat.com, valdis.kletnieks@vt.edu, vmayatsk@redhat.com, mm-commits@vger.kernel.org


The patch titled
     selinux_bprm_committed_creds: use __wake_up_parent()
has been removed from the -mm tree.  Its filename was
     do_wait-wakeup-optimization-change-__wake_up_parent-to-use-filtered-wakeup-selinux_bprm_committed_creds-use-__wake_up_parent.patch

This patch was dropped because it was folded into do_wait-wakeup-optimization-change-__wake_up_parent-to-use-filtered-wakeup.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: selinux_bprm_committed_creds: use __wake_up_parent()
From: Oleg Nesterov <oleg@redhat.com>

(depends on ptrace-__ptrace_detach-do-__wake_up_parent-if-we-reap-the-tracee.patch
 which exports __wake_up_parent)

Spotted by Valdis.Kletnieks@vt.edu.

selinux_bprm_committed_creds() should not play with ->wait_chldexit, now
that __wake_up_parent() is exported change the code to use this helper.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: Roland McGrath <roland@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Ratan Nalumasu <rnalumasu@gmail.com>
Cc: Vitaly Mayatskikh <vmayatsk@redhat.com>
Acked-by: James Morris <jmorris@namei.org>
Tested-by: Valdis Kletnieks <valdis.kletnieks@vt.edu>
Reported-by: Valdis Kletnieks <valdis.kletnieks@vt.edu>
Acked-by: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 security/selinux/hooks.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN security/selinux/hooks.c~do_wait-wakeup-optimization-change-__wake_up_parent-to-use-filtered-wakeup-selinux_bprm_committed_creds-use-__wake_up_parent security/selinux/hooks.c
--- a/security/selinux/hooks.c~do_wait-wakeup-optimization-change-__wake_up_parent-to-use-filtered-wakeup-selinux_bprm_committed_creds-use-__wake_up_parent
+++ a/security/selinux/hooks.c
@@ -2405,7 +2405,7 @@ static void selinux_bprm_committed_creds
 	/* Wake up the parent if it is waiting so that it can recheck
 	 * wait permission to the new task SID. */
 	read_lock(&tasklist_lock);
-	wake_up_interruptible(&current->real_parent->signal->wait_chldexit);
+	__wake_up_parent(current, current->real_parent);
 	read_unlock(&tasklist_lock);
 }
 
_

Patches currently in -mm which might be from oleg@redhat.com are

origin.patch
cgroups-revert-cgroups-fix-pid-namespace-bug.patch
cgroups-add-a-read-only-procs-file-similar-to-tasks-that-shows-only-unique-tgids.patch
cgroups-ensure-correct-concurrent-opening-reading-of-pidlists-across-pid-namespaces.patch
cgroups-use-vmalloc-for-large-cgroups-pidlist-allocations.patch
cgroups-change-css_set-freeing-mechanism-to-be-under-rcu.patch
cgroups-let-ss-can_attach-and-ss-attach-do-whole-threadgroups-at-a-time.patch
ptrace-__ptrace_detach-do-__wake_up_parent-if-we-reap-the-tracee.patch
do_wait-wakeup-optimization-shift-security_task_wait-from-eligible_child-to-wait_consider_task.patch
do_wait-wakeup-optimization-change-__wake_up_parent-to-use-filtered-wakeup.patch
do_wait-wakeup-optimization-change-__wake_up_parent-to-use-filtered-wakeup-selinux_bprm_committed_creds-use-__wake_up_parent.patch
do_wait-wakeup-optimization-child_wait_callback-check-__wnothread-case.patch
do_wait-wakeup-optimization-fix-child_wait_callback-eligible_child-usage.patch
do_wait-wakeup-optimization-simplify-task_pid_type.patch
wait_consider_task-kill-parent-argument.patch
do_wait-fix-sys_waitid-specific-behaviour.patch
wait_noreap_copyout-check-for-wo_info-=-null.patch
signals-tracehook_notify_jctl-change.patch
signals-tracehook_notify_jctl-change-do_signal_stop-do-not-call-tracehook_notify_jctl-in-task_stopped-state.patch
signals-introduce-tracehook_finish_jctl-helper.patch
exec-fix-set_binfmt-vs-sys_delete_module-race.patch
signals-introduce-do_send_sig_info-helper.patch
signals-send_sigio-use-do_send_sig_info-to-avoid-check_kill_permission.patch
fcntl-add-f_etown_ex.patch
signals-inline-__fatal_signal_pending.patch
fork-disable-clone_parent-for-init.patch
pidns-deny-clone_parentclone_newpid-combination.patch
task_struct-cleanup-move-binfmt-field-to-mm_struct.patch

