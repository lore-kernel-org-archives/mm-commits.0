From: akpm@osdl.org
Subject: + clone-flag-clone_parent_tidptr-leaves-invalid-results-in-memory.patch added to -mm tree
Date: Tue, 02 Jan 2007 15:48:18 -0800
Message-ID: <200701022348.l02NmIHj001644@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:45988 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753056AbXABXsm (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 2 Jan 2007 18:48:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dan@codesourcery.com, ebiederm@xmission.com, oleg@tv-sign.ru, roland@redhat.com


The patch titled
     Clone flag CLONE_PARENT_TIDPTR leaves invalid results in memory
has been added to the -mm tree.  Its filename is
     clone-flag-clone_parent_tidptr-leaves-invalid-results-in-memory.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Clone flag CLONE_PARENT_TIDPTR leaves invalid results in memory
From: Daniel Jacobowitz <dan@codesourcery.com>

Fix http://bugzilla.kernel.org/show_bug.cgi?id=7210

Do not implement CLONE_PARENT_SETTID until we know that clone will succeed. 
If we do it too early NPTL's data structures temporarily reference a
non-existant TID.

Signed-off-by: Daniel Jacobowitz <dan@codesourcery.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Roland McGrath <roland@redhat.com>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 kernel/fork.c |   13 ++++++++-----
 1 files changed, 8 insertions(+), 5 deletions(-)

diff -puN kernel/fork.c~clone-flag-clone_parent_tidptr-leaves-invalid-results-in-memory kernel/fork.c
--- a/kernel/fork.c~clone-flag-clone_parent_tidptr-leaves-invalid-results-in-memory
+++ a/kernel/fork.c
@@ -1022,10 +1022,6 @@ static struct task_struct *copy_process(
 	delayacct_tsk_init(p);	/* Must remain after dup_task_struct() */
 	copy_flags(clone_flags, p);
 	p->pid = pid;
-	retval = -EFAULT;
-	if (clone_flags & CLONE_PARENT_SETTID)
-		if (put_user(p->pid, parent_tidptr))
-			goto bad_fork_cleanup_delays_binfmt;
 
 	INIT_LIST_HEAD(&p->children);
 	INIT_LIST_HEAD(&p->sibling);
@@ -1261,6 +1257,14 @@ static struct task_struct *copy_process(
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
 
@@ -1291,7 +1295,6 @@ bad_fork_cleanup_policy:
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
