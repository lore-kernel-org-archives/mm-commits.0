From: akpm@linux-foundation.org
Subject: + smack-update-for-file-capabilities.patch added to -mm tree
Date: Fri, 22 Feb 2008 23:32:19 -0800
Message-ID: <200802230733.m1N7X8wl018193@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:42856 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763853AbYBWIEn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 23 Feb 2008 03:04:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: casey@schaufler-ca.com, jmorris@namei.org, paul.moore@hp.com, sds@tycho.nsa.gov, serue@us.ibm.com


The patch titled
     Smack: update for file capabilities
has been added to the -mm tree.  Its filename is
     smack-update-for-file-capabilities.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Smack: update for file capabilities
From: Casey Schaufler <casey@schaufler-ca.com>

Update the Smack LSM to allow the registration of the capability "module"
as a secondary LSM.  Integrate the new hooks required for file based
capabilities.

Signed-off-by: Casey Schaufler <casey@schaufler-ca.com>
Cc: Serge Hallyn <serue@us.ibm.com>
Cc: Stephen Smalley <sds@tycho.nsa.gov>
Cc: Paul Moore <paul.moore@hp.com>
Cc: James Morris <jmorris@namei.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 security/smack/smack_lsm.c |   87 +++++++++++++++++++++++++++++------
 1 file changed, 74 insertions(+), 13 deletions(-)

diff -puN security/smack/smack_lsm.c~smack-update-for-file-capabilities security/smack/smack_lsm.c
--- a/security/smack/smack_lsm.c~smack-update-for-file-capabilities
+++ a/security/smack/smack_lsm.c
@@ -584,14 +584,20 @@ static int smack_inode_getattr(struct vf
 static int smack_inode_setxattr(struct dentry *dentry, char *name,
 				void *value, size_t size, int flags)
 {
-	if (!capable(CAP_MAC_ADMIN)) {
-		if (strcmp(name, XATTR_NAME_SMACK) == 0 ||
-		    strcmp(name, XATTR_NAME_SMACKIPIN) == 0 ||
-		    strcmp(name, XATTR_NAME_SMACKIPOUT) == 0)
-			return -EPERM;
-	}
+	int rc = 0;
+
+	if (strcmp(name, XATTR_NAME_SMACK) == 0 ||
+	    strcmp(name, XATTR_NAME_SMACKIPIN) == 0 ||
+	    strcmp(name, XATTR_NAME_SMACKIPOUT) == 0) {
+		if (!capable(CAP_MAC_ADMIN))
+			rc = -EPERM;
+	} else
+		rc = cap_inode_setxattr(dentry, name, value, size, flags);
+
+	if (rc == 0)
+		rc = smk_curacc(smk_of_inode(dentry->d_inode), MAY_WRITE);
 
-	return smk_curacc(smk_of_inode(dentry->d_inode), MAY_WRITE);
+	return rc;
 }
 
 /**
@@ -658,10 +664,20 @@ static int smack_inode_getxattr(struct d
  */
 static int smack_inode_removexattr(struct dentry *dentry, char *name)
 {
-	if (strcmp(name, XATTR_NAME_SMACK) == 0 && !capable(CAP_MAC_ADMIN))
-		return -EPERM;
+	int rc = 0;
 
-	return smk_curacc(smk_of_inode(dentry->d_inode), MAY_WRITE);
+	if (strcmp(name, XATTR_NAME_SMACK) == 0 ||
+	    strcmp(name, XATTR_NAME_SMACKIPIN) == 0 ||
+	    strcmp(name, XATTR_NAME_SMACKIPOUT) == 0) {
+		if (!capable(CAP_MAC_ADMIN))
+			rc = -EPERM;
+	} else
+		rc = cap_inode_removexattr(dentry, name);
+
+	if (rc == 0)
+		rc = smk_curacc(smk_of_inode(dentry->d_inode), MAY_WRITE);
+
+	return rc;
 }
 
 /**
@@ -1016,7 +1032,12 @@ static void smack_task_getsecid(struct t
  */
 static int smack_task_setnice(struct task_struct *p, int nice)
 {
-	return smk_curacc(p->security, MAY_WRITE);
+	int rc;
+
+	rc = cap_task_setnice(p, nice);
+	if (rc == 0)
+		rc = smk_curacc(p->security, MAY_WRITE);
+	return rc;
 }
 
 /**
@@ -1028,7 +1049,12 @@ static int smack_task_setnice(struct tas
  */
 static int smack_task_setioprio(struct task_struct *p, int ioprio)
 {
-	return smk_curacc(p->security, MAY_WRITE);
+	int rc;
+
+	rc = cap_task_setioprio(p, ioprio);
+	if (rc == 0)
+		rc = smk_curacc(p->security, MAY_WRITE);
+	return rc;
 }
 
 /**
@@ -1053,7 +1079,12 @@ static int smack_task_getioprio(struct t
 static int smack_task_setscheduler(struct task_struct *p, int policy,
 				   struct sched_param *lp)
 {
-	return smk_curacc(p->security, MAY_WRITE);
+	int rc;
+
+	rc = cap_task_setscheduler(p, policy, lp);
+	if (rc == 0)
+		rc = smk_curacc(p->security, MAY_WRITE);
+	return rc;
 }
 
 /**
@@ -1093,6 +1124,11 @@ static int smack_task_movememory(struct 
 static int smack_task_kill(struct task_struct *p, struct siginfo *info,
 			   int sig, u32 secid)
 {
+	int rc;
+
+	rc = cap_task_kill(p, info, sig, secid);
+	if (rc != 0)
+		return rc;
 	/*
 	 * Special cases where signals really ought to go through
 	 * in spite of policy. Stephen Smalley suggests it may
@@ -1776,6 +1812,27 @@ static int smack_ipc_permission(struct k
 	return smk_curacc(isp, may);
 }
 
+/* module stacking operations */
+
+/**
+ * smack_register_security - stack capability module
+ * @name: module name
+ * @ops: module operations - ignored
+ *
+ * Allow the capability module to register.
+ */
+static int smack_register_security(const char *name,
+				   struct security_operations *ops)
+{
+	if (strcmp(name, "capability") != 0)
+		return -EINVAL;
+
+	printk(KERN_INFO "%s:  Registering secondary module %s\n",
+	       __func__, name);
+
+	return 0;
+}
+
 /**
  * smack_d_instantiate - Make sure the blob is correct on an inode
  * @opt_dentry: unused
@@ -2393,6 +2450,8 @@ static struct security_operations smack_
 	.inode_post_setxattr = 		smack_inode_post_setxattr,
 	.inode_getxattr = 		smack_inode_getxattr,
 	.inode_removexattr = 		smack_inode_removexattr,
+	.inode_need_killpriv =		cap_inode_need_killpriv,
+	.inode_killpriv =		cap_inode_killpriv,
 	.inode_getsecurity = 		smack_inode_getsecurity,
 	.inode_setsecurity = 		smack_inode_setsecurity,
 	.inode_listsecurity = 		smack_inode_listsecurity,
@@ -2452,6 +2511,8 @@ static struct security_operations smack_
 	.netlink_send =			cap_netlink_send,
 	.netlink_recv = 		cap_netlink_recv,
 
+	.register_security = 		smack_register_security,
+
 	.d_instantiate = 		smack_d_instantiate,
 
 	.getprocattr = 			smack_getprocattr,
_

Patches currently in -mm which might be from casey@schaufler-ca.com are

smack-update-for-file-capabilities.patch
