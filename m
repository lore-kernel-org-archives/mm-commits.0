From: akpm@linux-foundation.org
Subject: + vfs-reorder-vfs_getxattr-to-avoid-unnecessary-calls-to-the-lsm.patch added to -mm tree
Date: Thu, 01 Nov 2007 12:36:07 -0700
Message-ID: <20071101193607.9E5D2432BDC@localhost>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.45.13]:34588 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754191AbXKATgg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 Nov 2007 15:36:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dpquigl@tycho.nsa.gov, casey@schaufler-ca.com, chrisw@sous-sol.org, hch@lst.de, jmorris@namei.org, sds@tycho.nsa.gov, serue@us.ibm.com, viro@zeniv.linux.org.uk


The patch titled
     VFS: Reorder vfs_getxattr to avoid unnecessary calls to the LSM
has been added to the -mm tree.  Its filename is
     vfs-reorder-vfs_getxattr-to-avoid-unnecessary-calls-to-the-lsm.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: VFS: Reorder vfs_getxattr to avoid unnecessary calls to the LSM
From: "David P. Quigley" <dpquigl@tycho.nsa.gov>

Originally vfs_getxattr would pull the security xattr variable using
the inode getxattr handle and then proceed to clobber it with a subsequent call
to the LSM.

This patch reorders the two operations such that when the xattr requested is
in the security namespace it first attempts to grab the value from the LSM
directly.

If it fails to obtain the value because there is no module present or the
module does not support the operation it will fall back to using the inode
getxattr operation.

In the event that both are inaccessible it returns EOPNOTSUPP.

Signed-off-by: David P. Quigley <dpquigl@tycho.nsa.gov>
Cc: Stephen Smalley <sds@tycho.nsa.gov>
Cc: Chris Wright <chrisw@sous-sol.org>
Cc: James Morris <jmorris@namei.org>
Cc: Serge Hallyn <serue@us.ibm.com>
Cc: Casey Schaufler <casey@schaufler-ca.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/xattr.c |   15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff -puN fs/xattr.c~vfs-reorder-vfs_getxattr-to-avoid-unnecessary-calls-to-the-lsm fs/xattr.c
--- a/fs/xattr.c~vfs-reorder-vfs_getxattr-to-avoid-unnecessary-calls-to-the-lsm
+++ a/fs/xattr.c
@@ -145,11 +145,6 @@ vfs_getxattr(struct dentry *dentry, char
 	if (error)
 		return error;
 
-	if (inode->i_op->getxattr)
-		error = inode->i_op->getxattr(dentry, name, value, size);
-	else
-		error = -EOPNOTSUPP;
-
 	if (!strncmp(name, XATTR_SECURITY_PREFIX,
 				XATTR_SECURITY_PREFIX_LEN)) {
 		const char *suffix = name + XATTR_SECURITY_PREFIX_LEN;
@@ -158,9 +153,15 @@ vfs_getxattr(struct dentry *dentry, char
 		 * Only overwrite the return value if a security module
 		 * is actually active.
 		 */
-		if (ret != -EOPNOTSUPP)
-			error = ret;
+		if (ret == -EOPNOTSUPP)
+			goto nolsm;
+		return ret;
 	}
+nolsm:
+	if (inode->i_op->getxattr)
+		error = inode->i_op->getxattr(dentry, name, value, size);
+	else
+		error = -EOPNOTSUPP;
 
 	return error;
 }
_

Patches currently in -mm which might be from dpquigl@tycho.nsa.gov are

vfs-security-rework-inode_getsecurity-and-callers-to.patch
vfs-reorder-vfs_getxattr-to-avoid-unnecessary-calls-to-the-lsm.patch
