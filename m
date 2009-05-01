From: akpm@linux-foundation.org
Subject: [merged] do_wait-do-take-security_task_wait-into-account.patch removed from -mm tree
Date: Fri, 01 May 2009 13:14:19 -0700
Message-ID: <200905012014.n41KEJ1P024503@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51010 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761618AbZEAUT3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 1 May 2009 16:19:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@redhat.com, alan@lxorguk.ukuu.org.uk, dhowells@redhat.com, eparis@parisplace.org, jmorris@namei.org, roland@redhat.com, mm-commits@vger.kernel.org


The patch titled
     do_wait: do take security_task_wait() into account
has been removed from the -mm tree.  Its filename was
     do_wait-do-take-security_task_wait-into-account.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: do_wait: do take security_task_wait() into account
From: Oleg Nesterov <oleg@redhat.com>

I was never able to understand what should we actually do when
security_task_wait() fails, but the current code doesn't look right.

If ->task_wait() returns the error, we update *notask_error correctly. 
But then we either reap the child (despite the fact this was forbidden) or
clear *notask_error (and hide the securiy policy problems).

This patch assumes that "stolen by ptrace" doesn't matter.  If selinux
denies the child we should ignore it but make sure we report -EACCESS
instead of -ECHLD if there are no other eligible children.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: James Morris <jmorris@namei.org>
Cc: Roland McGrath <roland@redhat.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Eric Paris <eparis@parisplace.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/exit.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN kernel/exit.c~do_wait-do-take-security_task_wait-into-account kernel/exit.c
--- a/kernel/exit.c~do_wait-do-take-security_task_wait-into-account
+++ a/kernel/exit.c
@@ -1482,6 +1482,7 @@ static int wait_consider_task(struct tas
 		 */
 		if (*notask_error)
 			*notask_error = ret;
+		return 0;
 	}
 
 	if (likely(!ptrace) && unlikely(task_ptrace(p))) {
_

Patches currently in -mm which might be from oleg@redhat.com are

maintainers-add-ptrace-entry.patch
ptrace-s-parent-real_parent-in-binfmt_elf_fdpicc.patch
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

