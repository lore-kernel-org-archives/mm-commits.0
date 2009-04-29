From: akpm@linux-foundation.org
Subject: + ptrace-selinux_bprm_committed_creds-simplify-__wake_up_parent-code-and-s-parent-real_parent.patch added to -mm tree
Date: Wed, 29 Apr 2009 15:20:44 -0700
Message-ID: <200904292220.n3TMKiUL030018@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44982 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761802AbZD2WZz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 29 Apr 2009 18:25:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@redhat.com, dhowells@redhat.com, eparis@parisplace.org, jmorris@namei.org, roland@redhat.com, sds@tycho.nsa.gov


The patch titled
     ptrace: selinux_bprm_committed_creds: simplify __wake_up_parent() code and s/parent/real_parent/
has been added to the -mm tree.  Its filename is
     ptrace-selinux_bprm_committed_creds-simplify-__wake_up_parent-code-and-s-parent-real_parent.patch

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
Subject: ptrace: selinux_bprm_committed_creds: simplify __wake_up_parent() code and s/parent/real_parent/
From: Oleg Nesterov <oleg@redhat.com>

selinux_bprm_committed_creds() should wake up ->real_parent, not ->parent.

We shouldn't worry about the tracer if current is ptraced, exec() must not
succeed if the tracer has no rights to trace this task after cred
changing.  But we should notify ->real_parent which is, well, real parent.

Also, we don't need _irq to take tasklist, and we don't need parent's
->siglock to wake_up_interruptible(real_parent->signal->wait_chldexit). 
Since we hold tasklist, real_parent->signal must be stable.  Otherwise
spin_lock(siglock) is not safe too and can't help anyway.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: Stephen Smalley <sds@tycho.nsa.gov>
Cc: David Howells <dhowells@redhat.com>
Cc: Eric Paris <eparis@parisplace.org>
Cc: James Morris <jmorris@namei.org>
Cc: Roland McGrath <roland@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 security/selinux/hooks.c |   11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff -puN security/selinux/hooks.c~ptrace-selinux_bprm_committed_creds-simplify-__wake_up_parent-code-and-s-parent-real_parent security/selinux/hooks.c
--- a/security/selinux/hooks.c~ptrace-selinux_bprm_committed_creds-simplify-__wake_up_parent-code-and-s-parent-real_parent
+++ a/security/selinux/hooks.c
@@ -2375,10 +2375,8 @@ static void selinux_bprm_committed_creds
 {
 	const struct task_security_struct *tsec = current_security();
 	struct itimerval itimer;
-	struct sighand_struct *psig;
 	u32 osid, sid;
 	int rc, i;
-	unsigned long flags;
 
 	osid = tsec->osid;
 	sid = tsec->sid;
@@ -2408,12 +2406,9 @@ static void selinux_bprm_committed_creds
 
 	/* Wake up the parent if it is waiting so that it can recheck
 	 * wait permission to the new task SID. */
-	read_lock_irq(&tasklist_lock);
-	psig = current->parent->sighand;
-	spin_lock_irqsave(&psig->siglock, flags);
-	wake_up_interruptible(&current->parent->signal->wait_chldexit);
-	spin_unlock_irqrestore(&psig->siglock, flags);
-	read_unlock_irq(&tasklist_lock);
+	read_lock(&tasklist_lock);
+	wake_up_interruptible(&current->real_parent->signal->wait_chldexit);
+	read_unlock(&tasklist_lock);
 }
 
 /* superblock security operations */
_

Patches currently in -mm which might be from oleg@redhat.com are

origin.patch
maintainers-add-ptrace-entry.patch
linux-next.patch
ptrace-selinux_bprm_committed_creds-simplify-__wake_up_parent-code-and-s-parent-real_parent.patch
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

