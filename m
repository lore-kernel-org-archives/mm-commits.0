From: akpm@linux-foundation.org
Subject: [merged]
 pidns-kill-the-unnecessary-clone_newpid-in-copy_process.patch removed from
 -mm tree
Date: Thu, 12 Sep 2013 12:41:11 -0700
Message-ID: <523218d7.UfX/a4PwFayrqa4g%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57823 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751687Ab3ILTlM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 12 Sep 2013 15:41:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, walters@redhat.com, luto@amacapital.net, ebiederm@xmission.com, oleg@redhat.com

Subject: [merged] pidns-kill-the-unnecessary-clone_newpid-in-copy_process.patch removed from -mm tree
To: oleg@redhat.com,ebiederm@xmission.com,luto@amacapital.net,walters@redhat.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 12 Sep 2013 12:41:11 -0700


The patch titled
     Subject: pidns: kill the unnecessary CLONE_NEWPID in copy_process()
has been removed from the -mm tree.  Its filename was
     pidns-kill-the-unnecessary-clone_newpid-in-copy_process.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

 kernel/fork.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff -puN kernel/fork.c~pidns-kill-the-unnecessary-clone_newpid-in-copy_process kernel/fork.c
--- a/kernel/fork.c~pidns-kill-the-unnecessary-clone_newpid-in-copy_process
+++ a/kernel/fork.c
@@ -1177,9 +1177,8 @@ static struct task_struct *copy_process(
 	 * allow it to share a thread group or signal handlers with the
 	 * forking task.
 	 */
-	if ((clone_flags & (CLONE_SIGHAND | CLONE_NEWPID)) &&
-	    (task_active_pid_ns(current) !=
-	     current->nsproxy->pid_ns_for_children))
+	if ((clone_flags & CLONE_SIGHAND) && (task_active_pid_ns(current) !=
+					current->nsproxy->pid_ns_for_children))
 		return ERR_PTR(-EINVAL);
 
 	retval = security_task_create(clone_flags);
_

Patches currently in -mm which might be from oleg@redhat.com are

origin.patch
anon_inodefs-forbid-open-via-proc.patch
autofs4-allow-autofs-to-work-outside-the-initial-pid-namespace.patch
autofs4-translate-pids-to-the-right-namespace-for-the-daemon.patch
signals-eventpoll-set-saved_sigmask-at-the-start.patch

