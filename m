From: akpm@linux-foundation.org
Subject: [merged] userns-userns-check-user-namespace-for-task-file-uid-equivalence-checks.patch removed from -mm tree
Date: Fri, 25 Mar 2011 00:27:00 -0700
Message-ID: <201103250726.p2P7Qs3C026193@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53587 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933960Ab1CYH1G (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 25 Mar 2011 03:27:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: serge@hallyn.com, daniel.lezcano@free.fr, dhowells@redhat.com, ebiederm@xmission.com, jmorris@namei.org, serge.hallyn@canonical.com, mm-commits@vger.kernel.org


The patch titled
     userns: userns: check user namespace for task->file uid equivalence checks
has been removed from the -mm tree.  Its filename was
     userns-userns-check-user-namespace-for-task-file-uid-equivalence-checks.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: userns: userns: check user namespace for task->file uid equivalence checks
From: "Serge E. Hallyn" <serge@hallyn.com>

Cheat for now and say all files belong to init_user_ns.  Next step will be
to let superblocks belong to a user_ns, and derive inode_userns(inode)
from inode->i_sb->s_user_ns.  Finally we'll introduce more flexible
arrangements.

Changelog:
	Feb 15: make is_owner_or_cap take const struct inode
	Feb 23: make is_owner_or_cap bool

[akpm@linux-foundation.org: coding-style fixes]
Signed-off-by: Serge E. Hallyn <serge.hallyn@canonical.com>
Acked-by: "Eric W. Biederman" <ebiederm@xmission.com>
Acked-by: Daniel Lezcano <daniel.lezcano@free.fr>
Acked-by: David Howells <dhowells@redhat.com>
Cc: James Morris <jmorris@namei.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/inode.c         |   17 +++++++++++++++++
 fs/namei.c         |   21 ++++++++++++++++-----
 include/linux/fs.h |    9 +++++++--
 3 files changed, 40 insertions(+), 7 deletions(-)

diff -puN fs/inode.c~userns-userns-check-user-namespace-for-task-file-uid-equivalence-checks fs/inode.c
--- a/fs/inode.c~userns-userns-check-user-namespace-for-task-file-uid-equivalence-checks
+++ a/fs/inode.c
@@ -25,6 +25,7 @@
 #include <linux/async.h>
 #include <linux/posix_acl.h>
 #include <linux/ima.h>
+#include <linux/cred.h>
 
 /*
  * This is needed for the following functions:
@@ -1733,3 +1734,19 @@ void inode_init_owner(struct inode *inod
 	inode->i_mode = mode;
 }
 EXPORT_SYMBOL(inode_init_owner);
+
+/*
+ * return true if current either has CAP_FOWNER to the
+ * file, or owns the file.
+ */
+bool is_owner_or_cap(const struct inode *inode)
+{
+	struct user_namespace *ns = inode_userns(inode);
+
+	if (current_user_ns() == ns && current_fsuid() == inode->i_uid)
+		return true;
+	if (ns_capable(ns, CAP_FOWNER))
+		return true;
+	return false;
+}
+EXPORT_SYMBOL(is_owner_or_cap);
diff -puN fs/namei.c~userns-userns-check-user-namespace-for-task-file-uid-equivalence-checks fs/namei.c
--- a/fs/namei.c~userns-userns-check-user-namespace-for-task-file-uid-equivalence-checks
+++ a/fs/namei.c
@@ -183,6 +183,9 @@ static int acl_permission_check(struct i
 
 	mask &= MAY_READ | MAY_WRITE | MAY_EXEC;
 
+	if (current_user_ns() != inode_userns(inode))
+		goto other_perms;
+
 	if (current_fsuid() == inode->i_uid)
 		mode >>= 6;
 	else {
@@ -196,6 +199,7 @@ static int acl_permission_check(struct i
 			mode >>= 3;
 	}
 
+other_perms:
 	/*
 	 * If the DACs are ok we don't need any capability check.
 	 */
@@ -237,7 +241,7 @@ int generic_permission(struct inode *ino
 	 * Executable DACs are overridable if at least one exec bit is set.
 	 */
 	if (!(mask & MAY_EXEC) || execute_ok(inode))
-		if (capable(CAP_DAC_OVERRIDE))
+		if (ns_capable(inode_userns(inode), CAP_DAC_OVERRIDE))
 			return 0;
 
 	/*
@@ -245,7 +249,7 @@ int generic_permission(struct inode *ino
 	 */
 	mask &= MAY_READ | MAY_WRITE | MAY_EXEC;
 	if (mask == MAY_READ || (S_ISDIR(inode->i_mode) && !(mask & MAY_WRITE)))
-		if (capable(CAP_DAC_READ_SEARCH))
+		if (ns_capable(inode_userns(inode), CAP_DAC_READ_SEARCH))
 			return 0;
 
 	return -EACCES;
@@ -654,6 +658,7 @@ static inline int handle_reval_path(stru
 static inline int exec_permission(struct inode *inode, unsigned int flags)
 {
 	int ret;
+	struct user_namespace *ns = inode_userns(inode);
 
 	if (inode->i_op->permission) {
 		ret = inode->i_op->permission(inode, MAY_EXEC, flags);
@@ -666,7 +671,8 @@ static inline int exec_permission(struct
 	if (ret == -ECHILD)
 		return ret;
 
-	if (capable(CAP_DAC_OVERRIDE) || capable(CAP_DAC_READ_SEARCH))
+	if (ns_capable(ns, CAP_DAC_OVERRIDE) ||
+			ns_capable(ns, CAP_DAC_READ_SEARCH))
 		goto ok;
 
 	return ret;
@@ -1842,11 +1848,15 @@ static inline int check_sticky(struct in
 
 	if (!(dir->i_mode & S_ISVTX))
 		return 0;
+	if (current_user_ns() != inode_userns(inode))
+		goto other_userns;
 	if (inode->i_uid == fsuid)
 		return 0;
 	if (dir->i_uid == fsuid)
 		return 0;
-	return !capable(CAP_FOWNER);
+
+other_userns:
+	return !ns_capable(inode_userns(inode), CAP_FOWNER);
 }
 
 /*
@@ -2440,7 +2450,8 @@ int vfs_mknod(struct inode *dir, struct 
 	if (error)
 		return error;
 
-	if ((S_ISCHR(mode) || S_ISBLK(mode)) && !capable(CAP_MKNOD))
+	if ((S_ISCHR(mode) || S_ISBLK(mode)) &&
+	    !ns_capable(inode_userns(dir), CAP_MKNOD))
 		return -EPERM;
 
 	if (!dir->i_op->mknod)
diff -puN include/linux/fs.h~userns-userns-check-user-namespace-for-task-file-uid-equivalence-checks include/linux/fs.h
--- a/include/linux/fs.h~userns-userns-check-user-namespace-for-task-file-uid-equivalence-checks
+++ a/include/linux/fs.h
@@ -1457,8 +1457,13 @@ enum {
 #define put_fs_excl() atomic_dec(&current->fs_excl)
 #define has_fs_excl() atomic_read(&current->fs_excl)
 
-#define is_owner_or_cap(inode)	\
-	((current_fsuid() == (inode)->i_uid) || capable(CAP_FOWNER))
+/*
+ * until VFS tracks user namespaces for inodes, just make all files
+ * belong to init_user_ns
+ */
+extern struct user_namespace init_user_ns;
+#define inode_userns(inode) (&init_user_ns)
+extern bool is_owner_or_cap(const struct inode *inode);
 
 /* not quite ready to be deprecated, but... */
 extern void lock_super(struct super_block *);
_

Patches currently in -mm which might be from serge@hallyn.com are

origin.patch
lib-hexdumpc-make-hex2bin-return-the-updated-src-address.patch
fs-binfmt_miscc-use-kernels-hex_to_bin-method.patch
fs-binfmt_miscc-use-kernels-hex_to_bin-method-fix.patch
fs-binfmt_miscc-use-kernels-hex_to_bin-method-fix-fix.patch

