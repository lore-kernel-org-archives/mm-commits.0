From: akpm@linux-foundation.org
Subject: - clone-flag-clone_parent_tidptr-leaves-invalid-results-in-memory.patch removed from -mm tree
Date: Tue, 02 Oct 2007 11:01:22 -0700
Message-ID: <200710021801.l92I1MRV015242@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53464 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753280AbXJBSCR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 2 Oct 2007 14:02:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dan@codesourcery.com, ebiederm@xmission.com, oleg@tv-sign.ru, roland@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Clone flag CLONE_PARENT_TIDPTR leaves invalid results in memory
has been removed from the -mm tree.  Its filename was
     clone-flag-clone_parent_tidptr-leaves-invalid-results-in-memory.patch

This patch was dropped because it is obsolete

------------------------------------------------------
Subject: Clone flag CLONE_PARENT_TIDPTR leaves invalid results in memory
From: Daniel Jacobowitz <dan@codesourcery.com>

Fix http://bugzilla.kernel.org/show_bug.cgi?id=7210

Do not implement CLONE_PARENT_SETTID until we know that clone will succeed. 
If we do it too early NPTL's data structures temporarily reference a
non-existant TID.

Signed-off-by: Daniel Jacobowitz <dan@codesourcery.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Acked-by: Roland McGrath <roland@redhat.com>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/fork.c |   14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff -puN kernel/fork.c~clone-flag-clone_parent_tidptr-leaves-invalid-results-in-memory kernel/fork.c
--- a/kernel/fork.c~clone-flag-clone_parent_tidptr-leaves-invalid-results-in-memory
+++ a/kernel/fork.c
@@ -1041,11 +1041,6 @@ static struct task_struct *copy_process(
 	delayacct_tsk_init(p);	/* Must remain after dup_task_struct() */
 	copy_flags(clone_flags, p);
 	p->pid = pid_nr(pid);
-	retval = -EFAULT;
-	if (clone_flags & CLONE_PARENT_SETTID)
-		if (put_user(p->pid, parent_tidptr))
-			goto bad_fork_cleanup_delays_binfmt;
-
 	INIT_LIST_HEAD(&p->children);
 	INIT_LIST_HEAD(&p->sibling);
 	p->vfork_done = NULL;
@@ -1286,6 +1281,14 @@ static struct task_struct *copy_process(
 	total_forks++;
 	spin_unlock(&current->sighand->siglock);
 	write_unlock_irq(&tasklist_lock);
+
+	/*
+	 * Now that we know the fork has succeeded, record the new
+	 * TID.  It's too late to back out if this fails.
+	 */
+	if (clone_flags & CLONE_PARENT_SETTID)
+		put_user(p->pid, parent_tidptr);
+
 	proc_fork_connector(p);
 	return p;
 
@@ -1316,7 +1319,6 @@ bad_fork_cleanup_policy:
 bad_fork_cleanup_cpuset:
 #endif
 	cpuset_exit(p);
-bad_fork_cleanup_delays_binfmt:
 	delayacct_tsk_free(p);
 	if (p->binfmt)
 		module_put(p->binfmt->module);
_

Patches currently in -mm which might be from dan@codesourcery.com are

clone-flag-clone_parent_tidptr-leaves-invalid-results-in-memory.patch
