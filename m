From: akpm@linux-foundation.org
Subject: [merged] pidns-fix-vfork-after-unshareclone_newpid.patch removed
 from -mm tree
Date: Thu, 12 Sep 2013 12:41:09 -0700
Message-ID: <523218d5.azEdVN5KB4SFSiCJ%akpm__12262.2488801882$1379014891$gmane$org@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57817 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754144Ab3ILTlK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 12 Sep 2013 15:41:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, walters@redhat.com, stable@vger.kernel.org, luto@amacapital.net, ebiederm@xmission.com, oleg@redhat.com

Subject: [merged] pidns-fix-vfork-after-unshareclone_newpid.patch removed from -mm tree
To: oleg@redhat.com,ebiederm@xmission.com,luto@amacapital.net,stable@vger.kernel.org,walters@redhat.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 12 Sep 2013 12:41:09 -0700


The patch titled
     Subject: pidns: fix vfork() after unshare(CLONE_NEWPID)
has been removed from the -mm tree.  Its filename was
     pidns-fix-vfork-after-unshareclone_newpid.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Oleg Nesterov <oleg@redhat.com>
Subject: pidns: fix vfork() after unshare(CLONE_NEWPID)

8382fcac ("pidns: Outlaw thread creation after unshare(CLONE_NEWPID)")
nacks CLONE_VM if the forking process unshared pid_ns, this obviously
breaks vfork:

	int main(void)
	{
		assert(unshare(CLONE_NEWUSER | CLONE_NEWPID) == 0);
		assert(vfork() >= 0);
		_exit(0);
		return 0;
	}

fails without this patch.

Change this check to use CLONE_SIGHAND instead.  This also forbids
CLONE_THREAD automatically, and this is what the comment implies.

We could probably even drop CLONE_SIGHAND and use CLONE_THREAD, but it
would be safer to not do this.  The current check denies CLONE_SIGHAND
implicitely and there is no reason to change this.

Eric said "CLONE_SIGHAND is fine.  CLONE_THREAD would be even better. 
Having shared signal handling between two different pid namespaces is the
case that we are fundamentally guarding against."

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Reported-by: Colin Walters <walters@redhat.com>
Acked-by: Andy Lutomirski <luto@amacapital.net>
Reviewed-by: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/fork.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff -puN kernel/fork.c~pidns-fix-vfork-after-unshareclone_newpid kernel/fork.c
--- a/kernel/fork.c~pidns-fix-vfork-after-unshareclone_newpid
+++ a/kernel/fork.c
@@ -1173,10 +1173,11 @@ static struct task_struct *copy_process(
 		return ERR_PTR(-EINVAL);
 
 	/*
-	 * If the new process will be in a different pid namespace
-	 * don't allow the creation of threads.
+	 * If the new process will be in a different pid namespace don't
+	 * allow it to share a thread group or signal handlers with the
+	 * forking task.
 	 */
-	if ((clone_flags & (CLONE_VM|CLONE_NEWPID)) &&
+	if ((clone_flags & (CLONE_SIGHAND | CLONE_NEWPID)) &&
 	    (task_active_pid_ns(current) !=
 	     current->nsproxy->pid_ns_for_children))
 		return ERR_PTR(-EINVAL);
_

Patches currently in -mm which might be from oleg@redhat.com are

origin.patch
anon_inodefs-forbid-open-via-proc.patch
autofs4-allow-autofs-to-work-outside-the-initial-pid-namespace.patch
autofs4-translate-pids-to-the-right-namespace-for-the-daemon.patch
signals-eventpoll-set-saved_sigmask-at-the-start.patch

