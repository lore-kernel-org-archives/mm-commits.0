From: akpm@linux-foundation.org
Subject: + proc-make-proc_fd_permission-thread-friendly.patch added to -mm tree
Date: Wed, 11 Sep 2013 13:13:09 -0700
Message-ID: <5230ced5.CLYOiIYn5crB14vi%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48366 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755701Ab3IKUNK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 11 Sep 2013 16:13:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, oleg@redhat.com

Subject: + proc-make-proc_fd_permission-thread-friendly.patch added to -mm tree
To: oleg@redhat.com
From: akpm@linux-foundation.org
Date: Wed, 11 Sep 2013 13:13:09 -0700


The patch titled
     Subject: proc: make proc_fd_permission() thread-friendly
has been added to the -mm tree.  Its filename is
     proc-make-proc_fd_permission-thread-friendly.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/proc-make-proc_fd_permission-thread-friendly.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/proc-make-proc_fd_permission-thread-friendly.patch

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
Subject: proc: make proc_fd_permission() thread-friendly

proc_fd_permission() says "process can still access /proc/self/fd after it
has executed a setuid()", but the "task_pid() = proc_pid() check only
helps if the task is group leader, /proc/self points to
/proc/<leader-pid>.

Change this check to use task_tgid() so that the whole thread group can
access its /proc/self/fd or /proc/<tid-of-sub-thread>/fd.

Notes:
	- CLONE_THREAD does not require CLONE_FILES so task->files
	  can differ, but I don't think this can lead to any security
	  problem. And this matches same_thread_group() in
	  __ptrace_may_access().

	- /proc/self should probably point to /proc/<thread-tid>, but
	  it is too late to change the rules. Perhaps it makes sense
	  to add /proc/thread though.

Test-case:

	void *tfunc(void *arg)
	{
		assert(opendir("/proc/self/fd"));
		return NULL;
	}

	int main(void)
	{
		pthread_t t;
		pthread_create(&t, NULL, tfunc, NULL);
		pthread_join(t, NULL);
		return 0;
	}

fails if, say, this executable is not readable and suid_dumpable = 0.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/fd.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/proc/fd.c~proc-make-proc_fd_permission-thread-friendly fs/proc/fd.c
--- a/fs/proc/fd.c~proc-make-proc_fd_permission-thread-friendly
+++ a/fs/proc/fd.c
@@ -286,7 +286,7 @@ int proc_fd_permission(struct inode *ino
 	int rv = generic_permission(inode, mask);
 	if (rv == 0)
 		return 0;
-	if (task_pid(current) == proc_pid(inode))
+	if (task_tgid(current) == proc_pid(inode))
 		rv = 0;
 	return rv;
 }
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
__ptrace_may_access-should-not-deny-sub-threads.patch
move-exit_task_namespaces-outside-of-exit_notify-fix.patch
proc-make-proc_fd_permission-thread-friendly.patch
exec-introduce-exec_binprm-for-depth-==-0-code.patch
exec-kill-int-depth-in-search_binary_handler.patch
exec-proc_exec_connector-should-be-called-only-once.patch
exec-move-allow_write_access-fput-to-exec_binprm.patch
exec-kill-load_binary-=-null-check-in-search_binary_handler.patch
exec-cleanup-the-config_modules-logic.patch
exec-dont-retry-if-request_module-fails.patch
exec-cleanup-the-error-handling-in-search_binary_handler.patch

