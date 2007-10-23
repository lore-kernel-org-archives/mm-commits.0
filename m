From: akpm@linux-foundation.org
Subject: - capabilities-clean-up-file-capability-reading.patch removed from -mm tree
Date: Mon, 22 Oct 2007 23:46:30 -0700
Message-ID: <200710230646.l9N6kUvY004215@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47167 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751878AbXJWGrH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 23 Oct 2007 02:47:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: serue@us.ibm.com, chrisw@sous-sol.org, morgan@kernel.org, mm-commits@vger.kernel.org


The patch titled
     capabilities: clean up file capability reading
has been removed from the -mm tree.  Its filename was
     capabilities-clean-up-file-capability-reading.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: capabilities: clean up file capability reading
From: "Serge E. Hallyn" <serue@us.ibm.com>

Simplify the vfs_cap_data structure.

Also fix get_file_caps which was declaring
__le32 v1caps[XATTR_CAPS_SZ] on the stack, but
XATTR_CAPS_SZ is already * sizeof(__le32).

[akpm@linux-foundation.org: coding-style fixes]
Signed-off-by: Serge E. Hallyn <serue@us.ibm.com>
Cc: Andrew Morgan <morgan@kernel.org>
Cc: Chris Wright <chrisw@sous-sol.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/capability.h |    6 ++----
 security/commoncap.c       |   23 +++++++++++++++--------
 2 files changed, 17 insertions(+), 12 deletions(-)

diff -puN include/linux/capability.h~capabilities-clean-up-file-capability-reading include/linux/capability.h
--- a/include/linux/capability.h~capabilities-clean-up-file-capability-reading
+++ a/include/linux/capability.h
@@ -56,10 +56,8 @@ typedef struct __user_cap_data_struct {
 
 struct vfs_cap_data {
 	__u32 magic_etc;  /* Little endian */
-	struct {
-		__u32 permitted;    /* Little endian */
-		__u32 inheritable;  /* Little endian */
-	} data[1];
+	__u32 permitted;    /* Little endian */
+	__u32 inheritable;  /* Little endian */
 };
 
 #ifdef __KERNEL__
diff -puN security/commoncap.c~capabilities-clean-up-file-capability-reading security/commoncap.c
--- a/security/commoncap.c~capabilities-clean-up-file-capability-reading
+++ a/security/commoncap.c
@@ -190,7 +190,8 @@ int cap_inode_killpriv(struct dentry *de
 	return inode->i_op->removexattr(dentry, XATTR_NAME_CAPS);
 }
 
-static inline int cap_from_disk(__le32 *caps, struct linux_binprm *bprm,
+static inline int cap_from_disk(struct vfs_cap_data *caps,
+				struct linux_binprm *bprm,
 				int size)
 {
 	__u32 magic_etc;
@@ -198,7 +199,7 @@ static inline int cap_from_disk(__le32 *
 	if (size != XATTR_CAPS_SZ)
 		return -EINVAL;
 
-	magic_etc = le32_to_cpu(caps[0]);
+	magic_etc = le32_to_cpu(caps->magic_etc);
 
 	switch ((magic_etc & VFS_CAP_REVISION_MASK)) {
 	case VFS_CAP_REVISION:
@@ -206,8 +207,8 @@ static inline int cap_from_disk(__le32 *
 			bprm->cap_effective = true;
 		else
 			bprm->cap_effective = false;
-		bprm->cap_permitted = to_cap_t( le32_to_cpu(caps[1]) );
-		bprm->cap_inheritable = to_cap_t( le32_to_cpu(caps[2]) );
+		bprm->cap_permitted = to_cap_t(le32_to_cpu(caps->permitted));
+		bprm->cap_inheritable = to_cap_t(le32_to_cpu(caps->inheritable));
 		return 0;
 	default:
 		return -EINVAL;
@@ -219,7 +220,7 @@ static int get_file_caps(struct linux_bi
 {
 	struct dentry *dentry;
 	int rc = 0;
-	__le32 v1caps[XATTR_CAPS_SZ];
+	struct vfs_cap_data incaps;
 	struct inode *inode;
 
 	if (bprm->file->f_vfsmnt->mnt_flags & MNT_NOSUID) {
@@ -232,8 +233,14 @@ static int get_file_caps(struct linux_bi
 	if (!inode->i_op || !inode->i_op->getxattr)
 		goto out;
 
-	rc = inode->i_op->getxattr(dentry, XATTR_NAME_CAPS, &v1caps,
-							XATTR_CAPS_SZ);
+	rc = inode->i_op->getxattr(dentry, XATTR_NAME_CAPS, NULL, 0);
+	if (rc > 0) {
+		if (rc == XATTR_CAPS_SZ)
+			rc = inode->i_op->getxattr(dentry, XATTR_NAME_CAPS,
+						&incaps, XATTR_CAPS_SZ);
+		else
+			rc = -EINVAL;
+	}
 	if (rc == -ENODATA || rc == -EOPNOTSUPP) {
 		/* no data, that's ok */
 		rc = 0;
@@ -242,7 +249,7 @@ static int get_file_caps(struct linux_bi
 	if (rc < 0)
 		goto out;
 
-	rc = cap_from_disk(v1caps, bprm, rc);
+	rc = cap_from_disk(&incaps, bprm, rc);
 	if (rc)
 		printk(KERN_NOTICE "%s: cap_from_disk returned %d for %s\n",
 			__FUNCTION__, rc, bprm->filename);
_

Patches currently in -mm which might be from serue@us.ibm.com are

origin.patch
git-unionfs.patch
