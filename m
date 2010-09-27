From: akpm@linux-foundation.org
Subject: + ecryptfs-call-__vfs_setxattr_noperm-in-ecryptfs_setxattr.patch added to -mm tree
Date: Mon, 27 Sep 2010 14:20:19 -0700
Message-ID: <201009272120.o8RLKJd3017330@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39958 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753411Ab0I0VUd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 27 Sep 2010 17:20:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: roberto.sassu@polito.it, jmorris@namei.org, kirkland@canonical.com, tyhicks@linux.vnet.ibm.com


The patch titled
     ecryptfs: call __vfs_setxattr_noperm() in ecryptfs_setxattr()
has been added to the -mm tree.  Its filename is
     ecryptfs-call-__vfs_setxattr_noperm-in-ecryptfs_setxattr.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ecryptfs: call __vfs_setxattr_noperm() in ecryptfs_setxattr()
From: Roberto Sassu <roberto.sassu@polito.it>

Ecryptfs is a stackable filesystem which relies on lower filesystems the
ability of setting/getting extended attributes.

If there is a security module enabled on the system it updates the
'security' field of inodes according to the owned extended attribute set
with the function vfs_setxattr().  When this function is performed on a
ecryptfs filesystem the 'security' field is not updated for the lower
filesystem since the call security_inode_post_setxattr() is missing for
the lower inode.

This patch makes the function __vfs_setxattr_noperm() available for
modules and replaces the call to the setxattr() method of the lower inode
with the exported function.

Signed-off-by: Roberto Sassu <roberto.sassu@polito.it>
Cc: Tyler Hicks <tyhicks@linux.vnet.ibm.com>
Cc: Dustin Kirkland <kirkland@canonical.com>
Cc: James Morris <jmorris@namei.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ecryptfs/inode.c |    5 +++--
 fs/xattr.c          |    1 +
 2 files changed, 4 insertions(+), 2 deletions(-)

diff -puN fs/ecryptfs/inode.c~ecryptfs-call-__vfs_setxattr_noperm-in-ecryptfs_setxattr fs/ecryptfs/inode.c
--- a/fs/ecryptfs/inode.c~ecryptfs-call-__vfs_setxattr_noperm-in-ecryptfs_setxattr
+++ a/fs/ecryptfs/inode.c
@@ -32,6 +32,7 @@
 #include <linux/crypto.h>
 #include <linux/fs_stack.h>
 #include <linux/slab.h>
+#include <linux/xattr.h>
 #include <asm/unaligned.h>
 #include "ecryptfs_kernel.h"
 
@@ -1109,8 +1110,8 @@ ecryptfs_setxattr(struct dentry *dentry,
 		goto out;
 	}
 	mutex_lock(&lower_dentry->d_inode->i_mutex);
-	rc = lower_dentry->d_inode->i_op->setxattr(lower_dentry, name, value,
-						   size, flags);
+	rc = __vfs_setxattr_noperm(lower_dentry, name, value,
+				   size, flags);
 	mutex_unlock(&lower_dentry->d_inode->i_mutex);
 out:
 	return rc;
diff -puN fs/xattr.c~ecryptfs-call-__vfs_setxattr_noperm-in-ecryptfs_setxattr fs/xattr.c
--- a/fs/xattr.c~ecryptfs-call-__vfs_setxattr_noperm-in-ecryptfs_setxattr
+++ a/fs/xattr.c
@@ -106,6 +106,7 @@ int __vfs_setxattr_noperm(struct dentry 
 
 	return error;
 }
+EXPORT_SYMBOL_GPL(__vfs_setxattr_noperm);
 
 
 int
_

Patches currently in -mm which might be from roberto.sassu@polito.it are

ecryptfs-call-__vfs_setxattr_noperm-in-ecryptfs_setxattr.patch

