From: akpm@osdl.org
Subject: - sys-remove-unused-variable.patch removed from -mm tree
Date: Thu, 07 Dec 2006 15:16:19 -0800
Message-ID: <200612072316.kB7NGJMM030819@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:53626 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163728AbWLGXQZ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 7 Dec 2006 18:16:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rientjes@cs.washington.edu, dcb314@hotmail.com, mm-commits@vger.kernel.org


The patch titled
     sys: remove unused variable
has been removed from the -mm tree.  Its filename was
     sys-remove-unused-variable.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: sys: remove unused variable
From: David Rientjes <rientjes@cs.washington.edu>

Remove unused 'new_ruid' variable.

Reported by David Binderman <dcb314@hotmail.com>.

Signed-off-by: David Rientjes <rientjes@cs.washington.edu>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 kernel/sys.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN kernel/sys.c~sys-remove-unused-variable kernel/sys.c
--- a/kernel/sys.c~sys-remove-unused-variable
+++ a/kernel/sys.c
@@ -1102,14 +1102,14 @@ asmlinkage long sys_setreuid(uid_t ruid,
 asmlinkage long sys_setuid(uid_t uid)
 {
 	int old_euid = current->euid;
-	int old_ruid, old_suid, new_ruid, new_suid;
+	int old_ruid, old_suid, new_suid;
 	int retval;
 
 	retval = security_task_setuid(uid, (uid_t)-1, (uid_t)-1, LSM_SETID_ID);
 	if (retval)
 		return retval;
 
-	old_ruid = new_ruid = current->uid;
+	old_ruid = current->uid;
 	old_suid = current->suid;
 	new_suid = old_suid;
 	
_

Patches currently in -mm which might be from rientjes@cs.washington.edu are

origin.patch
video-sis-remove-unnecessary-variables-in-sis_ddc2delay.patch
hrtimers-clean-up-locking-fix.patch

