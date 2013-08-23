From: akpm@linux-foundation.org
Subject: +
 fork-unify-and-tighten-up-clone_newuser-clone_newpid-checks.patch added to
 -mm tree
Date: Fri, 23 Aug 2013 16:20:22 -0700
Message-ID: <5217ee36.aVQb/DumssTj7Pk3%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:32932 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756542Ab3HWXUX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 23 Aug 2013 19:20:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, walters@redhat.com, luto@amacapital.net, ebiederm@xmission.com, oleg@redhat.com

Subject: + fork-unify-and-tighten-up-clone_newuser-clone_newpid-checks.patch added to -mm tree
To: oleg@redhat.com,ebiederm@xmission.com,luto@amacapital.net,walters@redhat.com
From: akpm@linux-foundation.org
Date: Fri, 23 Aug 2013 16:20:22 -0700


The patch titled
     Subject: fork: unify and tighten up CLONE_NEWUSER/CLONE_NEWPID checks
has been added to the -mm tree.  Its filename is
     fork-unify-and-tighten-up-clone_newuser-clone_newpid-checks.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fork-unify-and-tighten-up-clone_newuser-clone_newpid-checks.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fork-unify-and-tighten-up-clone_newuser-clone_newpid-checks.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Oleg Nesterov <oleg@redhat.com>
Subject: fork: unify and tighten up CLONE_NEWUSER/CLONE_NEWPID checks

do_fork() denies CLONE_THREAD | CLONE_PARENT if NEWUSER | NEWPID.

Then later copy_process() denies CLONE_SIGHAND if the new process will be
in a different pid namespace (task_active_pid_ns() doesn't match
current->nsproxy->pid_ns).

This looks confusing and inconsistent.  CLONE_NEWPID is very similar to
the case when ->pid_ns was already unshared, we want the same restrictions
so copy_process() should also nack CLONE_PARENT.

And it would be better to deny CLONE_NEWUSER && CLONE_SIGHAND as well just
for consistency.

Kill the "CLONE_NEWUSER | CLONE_NEWPID" check in do_fork() and change
copy_process() to do the same check along with ->pid_ns check we already
have.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Andy Lutomirski <luto@amacapital.net>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Colin Walters <walters@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/fork.c |   23 ++++++++---------------
 1 file changed, 8 insertions(+), 15 deletions(-)

diff -puN kernel/fork.c~fork-unify-and-tighten-up-clone_newuser-clone_newpid-checks kernel/fork.c
--- a/kernel/fork.c~fork-unify-and-tighten-up-clone_newuser-clone_newpid-checks
+++ a/kernel/fork.c
@@ -1173,13 +1173,15 @@ static struct task_struct *copy_process(
 		return ERR_PTR(-EINVAL);
 
 	/*
-	 * If the new process will be in a different pid namespace don't
-	 * allow it to share a thread group or signal handlers with the
-	 * forking task.
+	 * If the new process will be in a different pid or user namespace
+	 * do not allow it to share a thread group or signal handlers or
+	 * parent with the forking task.
 	 */
-	if ((clone_flags & CLONE_SIGHAND) &&
-	    (task_active_pid_ns(current) != current->nsproxy->pid_ns))
-		return ERR_PTR(-EINVAL);
+	if (clone_flags & (CLONE_SIGHAND | CLONE_PARENT)) {
+		if ((clone_flags & (CLONE_NEWUSER | CLONE_NEWPID)) ||
+		    (task_active_pid_ns(current) != current->nsproxy->pid_ns))
+			return ERR_PTR(-EINVAL);
+	}
 
 	retval = security_task_create(clone_flags);
 	if (retval)
@@ -1576,15 +1578,6 @@ long do_fork(unsigned long clone_flags,
 	long nr;
 
 	/*
-	 * Do some preliminary argument and permissions checking before we
-	 * actually start allocating stuff
-	 */
-	if (clone_flags & (CLONE_NEWUSER | CLONE_NEWPID)) {
-		if (clone_flags & (CLONE_THREAD|CLONE_PARENT))
-			return -EINVAL;
-	}
-
-	/*
 	 * Determine whether and which event to report to ptracer.  When
 	 * called from kernel_thread or CLONE_UNTRACED is explicitly
 	 * requested, no event is reported; otherwise, report if the event
_

Patches currently in -mm which might be from oleg@redhat.com are

origin.patch
pidns-fix-vfork-after-unshareclone_newpid.patch
pidns-kill-the-unnecessary-clone_newpid-in-copy_process.patch
fork-unify-and-tighten-up-clone_newuser-clone_newpid-checks.patch
include-linux-schedh-dont-use-task-pid-tgid-in-same_thread_group-has_group_leader_pid.patch
mm-mempolicy-turn-vma_set_policy-into-vma_dup_policy.patch
mm-shift-vm_grows-check-from-mmap_region-to-do_mmap_pgoff-v2.patch
mm-do_mmap_pgoff-cleanup-the-usage-of-file_inode.patch
mm-mmap_region-kill-correct_wcount-inode-use-allow_write_access.patch
kernel-wide-fix-missing-validations-on-__get-__put-__copy_to-__copy_from_user.patch
task_work-minor-cleanups.patch
task_work-documentation.patch
autofs4-allow-autofs-to-work-outside-the-initial-pid-namespace.patch
autofs4-translate-pids-to-the-right-namespace-for-the-daemon.patch
__ptrace_may_access-should-not-deny-sub-threads.patch
signals-eventpoll-set-saved_sigmask-at-the-start.patch
move-exit_task_namespaces-outside-of-exit_notify-fix.patch
exec-introduce-exec_binprm-for-depth-==-0-code.patch
exec-kill-int-depth-in-search_binary_handler.patch
exec-proc_exec_connector-should-be-called-only-once.patch
exec-move-allow_write_access-fput-to-exec_binprm.patch
exec-kill-load_binary-=-null-check-in-search_binary_handler.patch
exec-cleanup-the-config_modules-logic.patch
exec-dont-retry-if-request_module-fails.patch
exec-cleanup-the-error-handling-in-search_binary_handler.patch
linux-next.patch

