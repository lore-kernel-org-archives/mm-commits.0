From: akpm@linux-foundation.org
Subject: + pidns-kill-the-unnecessary-clone_newpid-in-copy_process.patch
 added to -mm tree
Date: Fri, 23 Aug 2013 16:20:21 -0700
Message-ID: <5217ee35.sEeahVOelINV2GYJ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:32929 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756539Ab3HWXUW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 23 Aug 2013 19:20:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, walters@redhat.com, luto@amacapital.net, ebiederm@xmission.com, oleg@redhat.com

Subject: + pidns-kill-the-unnecessary-clone_newpid-in-copy_process.patch added to -mm tree
To: oleg@redhat.com,ebiederm@xmission.com,luto@amacapital.net,walters@redhat.com
From: akpm@linux-foundation.org
Date: Fri, 23 Aug 2013 16:20:21 -0700


The patch titled
     Subject: pidns: kill the unnecessary CLONE_NEWPID in copy_process()
has been added to the -mm tree.  Its filename is
     pidns-kill-the-unnecessary-clone_newpid-in-copy_process.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/pidns-kill-the-unnecessary-clone_newpid-in-copy_process.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/pidns-kill-the-unnecessary-clone_newpid-in-copy_process.patch

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
Subject: pidns: kill the unnecessary CLONE_NEWPID in copy_process()

8382fcac ("pidns: Outlaw thread creation after unshare(CLONE_NEWPID)")
nacks CLONE_NEWPID if the forking process unshared pid_ns.  This is
correct but unnecessary, copy_pid_ns() does the same check.

Remove the CLONE_NEWPID check to cleanup the code and prepare for the next
change.

Test-case:

	static int child(void *arg)
	{
		return 0;
	}

	static char stack[16 * 1024];

	int main(void)
	{
		pid_t pid;

		assert(unshare(CLONE_NEWUSER | CLONE_NEWPID) == 0);

		pid = clone(child, stack + sizeof(stack) / 2,
				CLONE_NEWPID | SIGCHLD, NULL);
		assert(pid < 0 && errno == EINVAL);

		return 0;
	}

clone(CLONE_NEWPID) correctly fails with or without this change.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Andy Lutomirski <luto@amacapital.net>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Colin Walters <walters@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/fork.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/fork.c~pidns-kill-the-unnecessary-clone_newpid-in-copy_process kernel/fork.c
--- a/kernel/fork.c~pidns-kill-the-unnecessary-clone_newpid-in-copy_process
+++ a/kernel/fork.c
@@ -1177,7 +1177,7 @@ static struct task_struct *copy_process(
 	 * allow it to share a thread group or signal handlers with the
 	 * forking task.
 	 */
-	if ((clone_flags & (CLONE_SIGHAND | CLONE_NEWPID)) &&
+	if ((clone_flags & CLONE_SIGHAND) &&
 	    (task_active_pid_ns(current) != current->nsproxy->pid_ns))
 		return ERR_PTR(-EINVAL);
 
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

