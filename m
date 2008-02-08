From: akpm@linux-foundation.org
Subject: - cgroup-brace-coding-style-fix.patch removed from -mm tree
Date: Fri, 08 Feb 2008 00:02:42 -0800
Message-ID: <200802080802.m1882Nb4014034@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40571 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761845AbYBHITt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Feb 2008 03:19:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: pj@sgi.com, menage@google.com, mm-commits@vger.kernel.org


The patch titled
     cgroup brace coding style fix
has been removed from the -mm tree.  Its filename was
     cgroup-brace-coding-style-fix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cgroup brace coding style fix
From: Paul Jackson <pj@sgi.com>

Coding style fix - one line conditionals don't get braces.

Signed-off-by: Paul Jackson <pj@sgi.com>
Acked-by: Paul Menage <menage@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/cgroup.c |   15 +++++----------
 1 file changed, 5 insertions(+), 10 deletions(-)

diff -puN kernel/cgroup.c~cgroup-brace-coding-style-fix kernel/cgroup.c
--- a/kernel/cgroup.c~cgroup-brace-coding-style-fix
+++ a/kernel/cgroup.c
@@ -1181,9 +1181,8 @@ static int attach_task(struct cgroup *cg
 	for_each_subsys(root, ss) {
 		if (ss->can_attach) {
 			retval = ss->can_attach(ss, cgrp, tsk);
-			if (retval) {
+			if (retval)
 				return retval;
-			}
 		}
 	}
 
@@ -1192,9 +1191,8 @@ static int attach_task(struct cgroup *cg
 	 * based on its final set of cgroups
 	 */
 	newcg = find_css_set(cg, cgrp);
-	if (!newcg) {
+	if (!newcg)
 		return -ENOMEM;
-	}
 
 	task_lock(tsk);
 	if (tsk->flags & PF_EXITING) {
@@ -1214,9 +1212,8 @@ static int attach_task(struct cgroup *cg
 	write_unlock(&css_set_lock);
 
 	for_each_subsys(root, ss) {
-		if (ss->attach) {
+		if (ss->attach)
 			ss->attach(ss, cgrp, oldcgrp, tsk);
-		}
 	}
 	set_bit(CGRP_RELEASABLE, &oldcgrp->flags);
 	synchronize_rcu();
@@ -1352,9 +1349,8 @@ static ssize_t cgroup_common_file_write(
 	{
 		struct cgroupfs_root *root = cgrp->root;
 		/* Strip trailing newline */
-		if (nbytes && (buffer[nbytes-1] == '\n')) {
+		if (nbytes && (buffer[nbytes-1] == '\n'))
 			buffer[nbytes-1] = 0;
-		}
 
 		/* We never write anything other than '\0'
 		 * into the last char of release_agent_path,
@@ -2124,9 +2120,8 @@ static inline int cgroup_has_css_refs(st
 		 * matter, since it can only happen if the cgroup
 		 * has been deleted and hence no longer needs the
 		 * release agent to be called anyway. */
-		if (css && atomic_read(&css->refcnt)) {
+		if (css && atomic_read(&css->refcnt))
 			return 1;
-		}
 	}
 	return 0;
 }
_

Patches currently in -mm which might be from pj@sgi.com are

origin.patch
proc-seqfile-convert-proc_pid_status-to-properly-handle-pid-namespaces.patch
proc-seqfile-convert-proc_pid_status-to-properly-handle-pid-namespaces-checkpatch-fixes.patch
proc-seqfile-convert-proc_pid_status-to-properly-handle-pid-namespaces-nommu-fix.patch
