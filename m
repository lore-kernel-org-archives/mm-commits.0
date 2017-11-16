From: akpm@linux-foundation.org
Subject: [patch 113/131] Unify migrate_pages and move_pages access
 checks
Date: Wed, 15 Nov 2017 17:38:14 -0800
Message-ID: <20171116013814.KEgrf3NmN%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40446 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933653AbdKPBiQ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 15 Nov 2017 20:38:16 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, ebiederm@xmission.com, keescook@chromium.org, mhocko@suse.com, mm-commits@vger.kernel.org, otto.ebeling@iki.fi, torvalds@linux-foundation.org, w@1wt.eu

From: Otto Ebeling <otto.ebeling@iki.fi>
Subject: Unify migrate_pages and move_pages access checks

197e7e521384a23b ("Sanitize 'move_pages()' permission checks") fixed a
security issue I reported in the move_pages syscall, and made it so that
you can't act on set-uid processes unless you have the CAP_SYS_PTRACE
capability.

Unify the access check logic of migrate_pages to match the new behavior of
move_pages.  We discussed this a bit in the security@ list and thought
it'd be good for consistency even though there's no evident security
impact.  The NUMA node access checks are left intact and require
CAP_SYS_NICE as before.

Link: http://lkml.kernel.org/r/alpine.DEB.2.11.1710011830320.6333@lakka.kapsi.fi
Signed-off-by: Otto Ebeling <otto.ebeling@iki.fi>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: Willy Tarreau <w@1wt.eu>
Cc: Kees Cook <keescook@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mempolicy.c |   13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

diff -puN mm/mempolicy.c~unify-migrate_pages-and-move_pages-access-checks mm/mempolicy.c
--- a/mm/mempolicy.c~unify-migrate_pages-and-move_pages-access-checks
+++ a/mm/mempolicy.c
@@ -85,6 +85,7 @@
 #include <linux/interrupt.h>
 #include <linux/init.h>
 #include <linux/compat.h>
+#include <linux/ptrace.h>
 #include <linux/swap.h>
 #include <linux/seq_file.h>
 #include <linux/proc_fs.h>
@@ -1365,7 +1366,6 @@ SYSCALL_DEFINE4(migrate_pages, pid_t, pi
 		const unsigned long __user *, old_nodes,
 		const unsigned long __user *, new_nodes)
 {
-	const struct cred *cred = current_cred(), *tcred;
 	struct mm_struct *mm = NULL;
 	struct task_struct *task;
 	nodemask_t task_nodes;
@@ -1401,15 +1401,10 @@ SYSCALL_DEFINE4(migrate_pages, pid_t, pi
 	err = -EINVAL;
 
 	/*
-	 * Check if this process has the right to modify the specified
-	 * process. The right exists if the process has administrative
-	 * capabilities, superuser privileges or the same
-	 * userid as the target process.
+	 * Check if this process has the right to modify the specified process.
+	 * Use the regular "ptrace_may_access()" checks.
 	 */
-	tcred = __task_cred(task);
-	if (!uid_eq(cred->euid, tcred->suid) && !uid_eq(cred->euid, tcred->uid) &&
-	    !uid_eq(cred->uid,  tcred->suid) && !uid_eq(cred->uid,  tcred->uid) &&
-	    !capable(CAP_SYS_NICE)) {
+	if (!ptrace_may_access(task, PTRACE_MODE_READ_REALCREDS)) {
 		rcu_read_unlock();
 		err = -EPERM;
 		goto out_put;
_
