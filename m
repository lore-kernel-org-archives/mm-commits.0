From: akpm@linux-foundation.org
Subject: [merged]
 fork-unify-and-tighten-up-clone_newuser-clone_newpid-checks.patch removed
 from -mm tree
Date: Thu, 12 Sep 2013 12:41:13 -0700
Message-ID: <523218d9.159MWefErcMYwieh%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57827 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751687Ab3ILTlO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 12 Sep 2013 15:41:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, walters@redhat.com, luto@amacapital.net, ebiederm@xmission.com, oleg@redhat.com

Subject: [merged] fork-unify-and-tighten-up-clone_newuser-clone_newpid-checks.patch removed from -mm tree
To: oleg@redhat.com,ebiederm@xmission.com,luto@amacapital.net,walters@redhat.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 12 Sep 2013 12:41:13 -0700


The patch titled
     Subject: fork: unify and tighten up CLONE_NEWUSER/CLONE_NEWPID checks
has been removed from the -mm tree.  Its filename was
     fork-unify-and-tighten-up-clone_newuser-clone_newpid-checks.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

 kernel/fork.c |   24 +++++++++---------------
 1 file changed, 9 insertions(+), 15 deletions(-)

diff -puN kernel/fork.c~fork-unify-and-tighten-up-clone_newuser-clone_newpid-checks kernel/fork.c
--- a/kernel/fork.c~fork-unify-and-tighten-up-clone_newuser-clone_newpid-checks
+++ a/kernel/fork.c
@@ -1173,13 +1173,16 @@ static struct task_struct *copy_process(
 		return ERR_PTR(-EINVAL);
 
 	/*
-	 * If the new process will be in a different pid namespace don't
-	 * allow it to share a thread group or signal handlers with the
-	 * forking task.
+	 * If the new process will be in a different pid or user namespace
+	 * do not allow it to share a thread group or signal handlers or
+	 * parent with the forking task.
 	 */
-	if ((clone_flags & CLONE_SIGHAND) && (task_active_pid_ns(current) !=
-					current->nsproxy->pid_ns_for_children))
-		return ERR_PTR(-EINVAL);
+	if (clone_flags & (CLONE_SIGHAND | CLONE_PARENT)) {
+		if ((clone_flags & (CLONE_NEWUSER | CLONE_NEWPID)) ||
+		    (task_active_pid_ns(current) !=
+				current->nsproxy->pid_ns_for_children))
+			return ERR_PTR(-EINVAL);
+	}
 
 	retval = security_task_create(clone_flags);
 	if (retval)
@@ -1576,15 +1579,6 @@ long do_fork(unsigned long clone_flags,
 	long nr;
 
 	/*
-	 * Do some preliminary argument and permissions checking before we
-	 * actually start allocating stuff
-	 */
-	if (clone_flags & (CLONE_NEWUSER | CLONE_NEWPID)) {
-		if (clone_flags & (CLONE_THREAD|CLONE_PARENT))
-			return -EINVAL;
-	}
