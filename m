From: akpm@linux-foundation.org
Subject: + file-caps-update-selinux-xattr-hooks.patch added to -mm tree
Date: Thu, 05 Jul 2007 11:56:05 -0700
Message-ID: <200707051856.l65Iu5N2012842@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57196 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760243AbXGES4r (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Jul 2007 14:56:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: serue@us.ibm.com, casey@schaufler-ca.com, chrisw@sous-sol.org, jmorris@namei.org, kaigai@kaigai.gr.jp, morgan@kernel.org, sds@tycho.nsa.gov


The patch titled
     file caps: update selinux xattr hooks
has been added to the -mm tree.  Its filename is
     file-caps-update-selinux-xattr-hooks.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: file caps: update selinux xattr hooks
From: "Serge E. Hallyn" <serue@us.ibm.com>

SELinux does not call out to its secondary module for setxattr or
removexattr mediation, as the secondary module would incorrectly prevent
writing of selinux xattrs.  This means that when selinux and capability are
both loaded, admins will be able to write file capabilities with
CAP_SYS_ADMIN as before, not with CAP_SETFCAP.

Update the selinux hooks to hardcode logic for the special consideration
for file caps.  Also consolidate the handling of non-selinux xattrs in
removexattr and setxattr.

Signed-off-by: Serge E. Hallyn <serue@us.ibm.com>
Cc: Chris Wright <chrisw@sous-sol.org>
Cc: Andrew Morgan <morgan@kernel.org>
Cc: Casey Schaufler <casey@schaufler-ca.com>
Cc: Stephen Smalley <sds@tycho.nsa.gov>
Cc: KaiGai Kohei <kaigai@kaigai.gr.jp>
Cc: James Morris <jmorris@namei.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 security/selinux/hooks.c |   50 +++++++++++++++++--------------------
 1 files changed, 23 insertions(+), 27 deletions(-)

diff -puN security/selinux/hooks.c~file-caps-update-selinux-xattr-hooks security/selinux/hooks.c
--- a/security/selinux/hooks.c~file-caps-update-selinux-xattr-hooks
+++ a/security/selinux/hooks.c
@@ -2290,6 +2290,25 @@ static int selinux_inode_getattr(struct 
 	return dentry_has_perm(current, mnt, dentry, FILE__GETATTR);
 }
 
+static int selinux_inode_setotherxattr(struct dentry *dentry, char *name)
+{
+	if (!strncmp(name, XATTR_SECURITY_PREFIX,
+		     sizeof XATTR_SECURITY_PREFIX - 1)) {
+		if (!strcmp(name, XATTR_NAME_CAPS)) {
+			if (!capable(CAP_SETFCAP))
+				return -EPERM;
+		} else if (!capable(CAP_SYS_ADMIN)) {
+			/* A different attribute in the security namespace.
+			   Restrict to administrator. */
+			return -EPERM;
+		}
+	}
+
+	/* Not an attribute we recognize, so just check the
+	   ordinary setattr permission. */
+	return dentry_has_perm(current, NULL, dentry, FILE__SETATTR);
+}
+
 static int selinux_inode_setxattr(struct dentry *dentry, char *name, void *value, size_t size, int flags)
 {
 	struct task_security_struct *tsec = current->security;
@@ -2300,19 +2319,8 @@ static int selinux_inode_setxattr(struct
 	u32 newsid;
 	int rc = 0;
 
-	if (strcmp(name, XATTR_NAME_SELINUX)) {
-		if (!strncmp(name, XATTR_SECURITY_PREFIX,
-			     sizeof XATTR_SECURITY_PREFIX - 1) &&
-		    !capable(CAP_SYS_ADMIN)) {
-			/* A different attribute in the security namespace.
-			   Restrict to administrator. */
-			return -EPERM;
-		}
-
-		/* Not an attribute we recognize, so just check the
-		   ordinary setattr permission. */
-		return dentry_has_perm(current, NULL, dentry, FILE__SETATTR);
-	}
+	if (strcmp(name, XATTR_NAME_SELINUX))
+		return selinux_inode_setotherxattr(dentry, name);
 
 	sbsec = inode->i_sb->s_security;
 	if (sbsec->behavior == SECURITY_FS_USE_MNTPOINT)
@@ -2386,20 +2394,8 @@ static int selinux_inode_listxattr (stru
 
 static int selinux_inode_removexattr (struct dentry *dentry, char *name)
 {
-	if (strcmp(name, XATTR_NAME_SELINUX)) {
-		if (!strncmp(name, XATTR_SECURITY_PREFIX,
-			     sizeof XATTR_SECURITY_PREFIX - 1) &&
-		    !capable(CAP_SYS_ADMIN)) {
-			/* A different attribute in the security namespace.
-			   Restrict to administrator. */
-			return -EPERM;
-		}
-
-		/* Not an attribute we recognize, so just check the
-		   ordinary setattr permission. Might want a separate
-		   permission for removexattr. */
-		return dentry_has_perm(current, NULL, dentry, FILE__SETATTR);
-	}
+	if (strcmp(name, XATTR_NAME_SELINUX))
+		return selinux_inode_setotherxattr(dentry, name);
 
 	/* No one is allowed to remove a SELinux security label.
 	   You can change the label, but all data must be labeled. */
_

Patches currently in -mm which might be from serue@us.ibm.com are

implement-file-posix-capabilities.patch
implement-file-posix-capabilities-fix.patch
file-capabilities-introduce-cap_setfcap.patch
file-capabilities-get_file_caps-cleanups.patch
file-caps-update-selinux-xattr-hooks.patch
remove-config_uts_ns-and-config_ipc_ns.patch
user-namespace-add-the-framework.patch
user-namespace-add-unshare.patch
mm-fix-create_new_namespaces-return-value.patch
cpuset-zero-malloc-revert-the-old-cpuset-fix.patch
containersv10-basic-container-framework.patch
containersv10-basic-container-framework-fix.patch
containersv10-example-cpu-accounting-subsystem.patch
containersv10-example-cpu-accounting-subsystem-fix.patch
containersv10-add-tasks-file-interface.patch
containersv10-add-tasks-file-interface-fix.patch
containersv10-add-fork-exit-hooks.patch
containersv10-add-fork-exit-hooks-fix.patch
containersv10-add-container_clone-interface.patch
containersv10-add-container_clone-interface-fix.patch
containersv10-add-procfs-interface.patch
containersv10-add-procfs-interface-fix.patch
containersv10-make-cpusets-a-client-of-containers.patch
containersv10-share-css_group-arrays-between-tasks-with-same-container-memberships.patch
containersv10-share-css_group-arrays-between-tasks-with-same-container-memberships-fix.patch
containersv10-share-css_group-arrays-between-tasks-with-same-container-memberships-cpuset-zero-malloc-fix-for-new-containers.patch
containersv10-simple-debug-info-subsystem.patch
containersv10-simple-debug-info-subsystem-fix.patch
containersv10-simple-debug-info-subsystem-fix-2.patch
containersv10-support-for-automatic-userspace-release-agents.patch
containers-implement-subsys-post_clone.patch
containers-implement-namespace-tracking-subsystem-v3.patch
