From: akpm@linux-foundation.org
Subject: + cgroup-brace-coding-style-fix.patch added to -mm tree
Date: Sat, 27 Oct 2007 01:02:55 -0700
Message-ID: <200710270802.l9R82tVv003968@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38300 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751413AbXJ0IDC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 27 Oct 2007 04:03:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: pj@sgi.com, menage@google.com


The patch titled
     cgroup brace coding style fix
has been added to the -mm tree.  Its filename is
     cgroup-brace-coding-style-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
@@ -1183,9 +1183,8 @@ static int attach_task(struct cgroup *cg
 	for_each_subsys(root, ss) {
 		if (ss->can_attach) {
 			retval = ss->can_attach(ss, cgrp, tsk);
-			if (retval) {
+			if (retval)
 				return retval;
-			}
 		}
 	}
 
@@ -1194,9 +1193,8 @@ static int attach_task(struct cgroup *cg
 	 * based on its final set of cgroups
 	 */
 	newcg = find_css_set(cg, cgrp);
-	if (!newcg) {
+	if (!newcg)
 		return -ENOMEM;
-	}
 
 	task_lock(tsk);
 	if (tsk->flags & PF_EXITING) {
@@ -1216,9 +1214,8 @@ static int attach_task(struct cgroup *cg
 	write_unlock(&css_set_lock);
 
 	for_each_subsys(root, ss) {
-		if (ss->attach) {
+		if (ss->attach)
 			ss->attach(ss, cgrp, oldcgrp, tsk);
-		}
 	}
 	set_bit(CGRP_RELEASABLE, &oldcgrp->flags);
 	synchronize_rcu();
@@ -1354,9 +1351,8 @@ static ssize_t cgroup_common_file_write(
 	{
 		struct cgroupfs_root *root = cgrp->root;
 		/* Strip trailing newline */
-		if (nbytes && (buffer[nbytes-1] == '\n')) {
+		if (nbytes && (buffer[nbytes-1] == '\n'))
 			buffer[nbytes-1] = 0;
-		}
 
 		/* We never write anything other than '\0'
 		 * into the last char of release_agent_path,
@@ -2126,9 +2122,8 @@ static inline int cgroup_has_css_refs(st
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

kernel-cgroupc-remove-dead-code.patch
cgroup-brace-coding-style-fix.patch
cgroup-simplify-space-stripping.patch
cgroup-simplify-space-stripping-fix.patch
