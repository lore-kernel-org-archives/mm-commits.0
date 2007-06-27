From: akpm@linux-foundation.org
Subject: + file-capabilities-introduce-cap_setfcap.patch added to -mm tree
Date: Wed, 27 Jun 2007 12:41:09 -0700
Message-ID: <200706271941.l5RJf9ZP004313@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60643 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756255AbXF0TmJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 27 Jun 2007 15:42:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: serue@us.ibm.com, agm@google.com, casey@schaufler-ca.com, chrisw@sous-sol.org, jmorris@namei.org, kaigai@kaigai.gr.jp, sds@tycho.nsa.gov


The patch titled
     file capabilities: introduce cap_setfcap
has been added to the -mm tree.  Its filename is
     file-capabilities-introduce-cap_setfcap.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: file capabilities: introduce cap_setfcap
From: Serge E. Hallyn <serue@us.ibm.com>

Setting file capabilities previously required the cap_sys_admin capability,
since they are stored as extended attributes in the security.* namespace.

Introduce CAP_SETFCAP (to mirror CAP_SETPCAP), and require it for setting
file capabilities instead of CAP_SYS_ADMIN.

Quoting Andrew Morgan,

"CAP_SYS_ADMIN is way too overloaded and this
functionality is special."

Signed-off-by: Serge E. Hallyn <serue@us.ibm.com>
Cc: Chris Wright <chrisw@sous-sol.org>
Cc: Andrew Morgan <agm@google.com>
Cc: Casey Schaufler <casey@schaufler-ca.com>
Cc: Stephen Smalley <sds@tycho.nsa.gov>
Cc: KaiGai Kohei <kaigai@kaigai.gr.jp>
Cc: James Morris <jmorris@namei.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/capability.h |    4 +++-
 security/commoncap.c       |   12 ++++++++++--
 2 files changed, 13 insertions(+), 3 deletions(-)

diff -puN include/linux/capability.h~file-capabilities-introduce-cap_setfcap include/linux/capability.h
--- a/include/linux/capability.h~file-capabilities-introduce-cap_setfcap
+++ a/include/linux/capability.h
@@ -325,7 +325,9 @@ typedef __u32 kernel_cap_t;
 
 #define CAP_AUDIT_CONTROL    30
 
-#define CAP_NUMCAPS	     31
+#define CAP_SETFCAP	     31
+
+#define CAP_NUMCAPS	     32
 
 #ifdef __KERNEL__
 /* 
diff -puN security/commoncap.c~file-capabilities-introduce-cap_setfcap security/commoncap.c
--- a/security/commoncap.c~file-capabilities-introduce-cap_setfcap
+++ a/security/commoncap.c
@@ -290,7 +290,11 @@ int cap_bprm_secureexec (struct linux_bi
 int cap_inode_setxattr(struct dentry *dentry, char *name, void *value,
 		       size_t size, int flags)
 {
-	if (!strncmp(name, XATTR_SECURITY_PREFIX,
+	if (!strcmp(name, XATTR_NAME_CAPS)) {
+		if (!capable(CAP_SETFCAP))
+			return -EPERM;
+		return 0;
+	} else if (!strncmp(name, XATTR_SECURITY_PREFIX,
 		     sizeof(XATTR_SECURITY_PREFIX) - 1)  &&
 	    !capable(CAP_SYS_ADMIN))
 		return -EPERM;
@@ -299,7 +303,11 @@ int cap_inode_setxattr(struct dentry *de
 
 int cap_inode_removexattr(struct dentry *dentry, char *name)
 {
-	if (!strncmp(name, XATTR_SECURITY_PREFIX,
+	if (!strcmp(name, XATTR_NAME_CAPS)) {
+		if (!capable(CAP_SETFCAP))
+			return -EPERM;
+		return 0;
+	} else if (!strncmp(name, XATTR_SECURITY_PREFIX,
 		     sizeof(XATTR_SECURITY_PREFIX) - 1)  &&
 	    !capable(CAP_SYS_ADMIN))
 		return -EPERM;
_

Patches currently in -mm which might be from serue@us.ibm.com are

implement-file-posix-capabilities.patch
implement-file-posix-capabilities-fix.patch
file-capabilities-introduce-cap_setfcap.patch
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
