From: akpm@linux-foundation.org
Subject: - slim-fix-security-issue-with-the-task_post_setuid-hook.patch removed from -mm tree
Date: Mon, 05 Mar 2007 18:14:16 -0800
Message-ID: <200703060214.l262EHV1009082@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:47210 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933854AbXCFCOV (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 5 Mar 2007 21:14:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kjhall@us.ibm.com, sds@tycho.nsa.gov, zohar@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     slim: fix security issue with the task_post_setuid hook
has been removed from the -mm tree.  Its filename was
     slim-fix-security-issue-with-the-task_post_setuid-hook.patch

This patch was dropped because it was folded into slim-debug-output.patch

------------------------------------------------------
Subject: slim: fix security issue with the task_post_setuid hook
From: Kylene Jo Hall <kjhall@us.ibm.com>

Much thanks to Stephen Smalley for finding this security hole opened by not
calling the dummy_ops function in the task_post_setuid hook of the SLIM
LSM.  This patch fixes that as well as resolves an existing issue where we
should have been handling all LSM_SETID types.

Signed-off-by: Mimi Zohar <zohar@us.ibm.com>
Signed-off-by: Kylene Hall <kjhall@us.ibm.com>
Cc: Stephen Smalley <sds@tycho.nsa.gov>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 security/slim/slm_main.c |   77 ++++++++++++++++++++-----------------
 1 file changed, 42 insertions(+), 35 deletions(-)

diff -puN security/slim/slm_main.c~slim-fix-security-issue-with-the-task_post_setuid-hook security/slim/slm_main.c
--- a/security/slim/slm_main.c~slim-fix-security-issue-with-the-task_post_setuid-hook
+++ a/security/slim/slm_main.c
@@ -29,6 +29,8 @@
 
 #include "slim.h"
 
+extern struct security_operations dummy_security_ops;
+
 unsigned int slm_debug = SLM_BASE;
 #define XATTR_NAME "security.slim.level"
 
@@ -1175,43 +1177,48 @@ static int slm_task_post_setuid(uid_t ol
 				uid_t old_suid, int flags)
 {
 	struct slm_tsec_data *cur_tsec = current->security;
+	int rc;
 
-	if (cur_tsec && flags == LSM_SETID_ID) {
-		/*set process to USER level integrity for everything but root */
-		dprintk(SLM_VERBOSE, "ruid %d euid %d suid %d "
-			"cur: uid %d euid %d suid %d\n",
+	/*set process to USER level integrity for everything but root */
+	dprintk(SLM_VERBOSE, "ruid %d euid %d suid %d "
+			"cur: uid %d euid %d suid %d "
+			"permitted %x effective %x\n",
 			old_ruid, old_euid, old_suid,
-			current->uid, current->euid, current->suid);
-		spin_lock(&cur_tsec->lock);
-		if ((cur_tsec->iac_r == cur_tsec->iac_wx)
-		    && (cur_tsec->iac_r == SLM_IAC_UNTRUSTED)) {
-			dprintk(SLM_INTEGRITY,
-				"Integrity: pid %d iac_r %d "
-				" iac_wx %d remains UNTRUSTED\n",
-				current->pid, cur_tsec->iac_r,
-				cur_tsec->iac_wx);
-		} else if (current->suid != 0) {
-			dprintk(SLM_INTEGRITY, "setting: pid %d iac_r %d "
-				" iac_wx %d to USER\n",
-				current->pid, cur_tsec->iac_r,
-				cur_tsec->iac_wx);
-			cur_tsec->iac_r = SLM_IAC_USER;
-			cur_tsec->iac_wx = SLM_IAC_USER;
-		} else if ((current->uid == 0) && (old_ruid != 0)) {
-			dprintk(SLM_INTEGRITY, "setting: pid %d iac_r %d "
-				" iac_wx %d to SYSTEM\n",
-				current->pid, cur_tsec->iac_r,
-				cur_tsec->iac_wx);
-			cur_tsec->iac_r = SLM_IAC_SYSTEM;
-			cur_tsec->iac_wx = SLM_IAC_SYSTEM;
-		} else
-			dprintk(SLM_INTEGRITY, "%s: pid %d iac_r %d "
-				" iac_wx %d \n", __FUNCTION__,
-				current->pid, cur_tsec->iac_r,
-				cur_tsec->iac_wx);
-		spin_unlock(&cur_tsec->lock);
-	}
-	return 0;
+			current->uid, current->euid, current->suid,
+			current->cap_permitted, current->cap_effective);
+	rc = dummy_security_ops.task_post_setuid(old_ruid, old_euid,
+						 old_suid, flags);
+	spin_lock(&cur_tsec->lock);
+	if ((cur_tsec->iac_r == cur_tsec->iac_wx)
+	    && (cur_tsec->iac_r == SLM_IAC_UNTRUSTED)) {
+		dprintk(SLM_INTEGRITY,
+			"Integrity: pid %d iac_r %d "
+			" iac_wx %d remains UNTRUSTED\n",
+			current->pid, cur_tsec->iac_r,
+			cur_tsec->iac_wx);
+		current->cap_permitted = 0;
+		current->cap_effective = 0;
+	} else if (current->suid != 0) {
+		dprintk(SLM_INTEGRITY, "setting: pid %d iac_r %d "
+			" iac_wx %d to USER\n",
+			current->pid, cur_tsec->iac_r,
+			cur_tsec->iac_wx);
+		cur_tsec->iac_r = SLM_IAC_USER;
+		cur_tsec->iac_wx = SLM_IAC_USER;
+	} else if ((current->uid == 0) && (old_ruid != 0)) {
+		dprintk(SLM_INTEGRITY, "setting: pid %d iac_r %d "
+			" iac_wx %d to SYSTEM\n",
+			current->pid, cur_tsec->iac_r,
+			cur_tsec->iac_wx);
+		cur_tsec->iac_r = SLM_IAC_SYSTEM;
+		cur_tsec->iac_wx = SLM_IAC_SYSTEM;
+	} else
+		dprintk(SLM_INTEGRITY, "%s: pid %d iac_r %d "
+			" iac_wx %d \n", __FUNCTION__,
+			current->pid, cur_tsec->iac_r,
+			cur_tsec->iac_wx);
+	spin_unlock(&cur_tsec->lock);
+	return rc;
 }
 
 static int slm_setprocattr(struct task_struct *tsk,
_

Patches currently in -mm which might be from kjhall@us.ibm.com are

mprotect-patch-for-use-by-slim.patch
integrity-service-api-and-dummy-provider.patch
slim-main-patch.patch
slim-secfs-patch.patch
slim-make-and-config-stuff.patch
slim-debug-output.patch
slim-fix-security-issue-with-the-task_post_setuid-hook.patch
slim-secfs-inode-i_private-build-fix.patch
slim-documentation.patch
panic-on-slim-selinux.patch
