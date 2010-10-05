From: akpm@linux-foundation.org
Subject: + ecryptfs-call-vfs_setxattr-in-ecryptfs_setxattr-v2.patch added to -mm tree
Date: Tue, 05 Oct 2010 12:04:33 -0700
Message-ID: <201010051904.o95J4X77013850@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49460 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752597Ab0JETFW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Oct 2010 15:05:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: roberto.sassu@polito.it, jmorris@namei.org, kirkland@canonical.com, tyhicks@linux.vnet.ibm.com


The patch titled
     ecryptfs: call vfs_setxattr() in ecryptfs_setxattr()
has been added to the -mm tree.  Its filename is
     ecryptfs-call-vfs_setxattr-in-ecryptfs_setxattr-v2.patch

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
Subject: ecryptfs: call vfs_setxattr() in ecryptfs_setxattr()
From: Roberto Sassu <roberto.sassu@polito.it>

Ecryptfs is a stackable filesystem which relies on lower filesystems the
ability of setting/getting extended attributes.

If there is a security module enabled on the system it updates the
'security' field of inodes according to the owned extended attribute set
with the function vfs_setxattr().  When this function is performed on a
ecryptfs filesystem the 'security' field is not updated for the lower
filesystem since the call security_inode_post_setxattr() is missing for
the lower inode.

Further, the call security_inode_setxattr() is missing for the lower
inode, leading to policy violations in the security module because
specific checks for this hook are not performed (i.  e.  filesystem
'associate' permission on SELinux is not checked for the lower
filesystem).

This patch replaces the call of the setxattr() method of the lower inode
in the function ecryptfs_setxattr() with vfs_setxattr().

Signed-off-by: Roberto Sassu <roberto.sassu@polito.it>
Reviewed-by: Tyler Hicks <tyhicks@linux.vnet.ibm.com>
Cc: Dustin Kirkland <kirkland@canonical.com>
Cc: James Morris <jmorris@namei.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ecryptfs/inode.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff -puN fs/ecryptfs/inode.c~ecryptfs-call-vfs_setxattr-in-ecryptfs_setxattr-v2 fs/ecryptfs/inode.c
--- a/fs/ecryptfs/inode.c~ecryptfs-call-vfs_setxattr-in-ecryptfs_setxattr-v2
+++ a/fs/ecryptfs/inode.c
@@ -32,6 +32,7 @@
 #include <linux/crypto.h>
 #include <linux/fs_stack.h>
 #include <linux/slab.h>
+#include <linux/xattr.h>
 #include <asm/unaligned.h>
 #include "ecryptfs_kernel.h"
 
@@ -1108,10 +1109,8 @@ ecryptfs_setxattr(struct dentry *dentry,
 		rc = -EOPNOTSUPP;
 		goto out;
 	}
-	mutex_lock(&lower_dentry->d_inode->i_mutex);
-	rc = lower_dentry->d_inode->i_op->setxattr(lower_dentry, name, value,
-						   size, flags);
-	mutex_unlock(&lower_dentry->d_inode->i_mutex);
+
+	rc = vfs_setxattr(lower_dentry, name, value, size, flags);
 out:
 	return rc;
 }
_

Patches currently in -mm which might be from roberto.sassu@polito.it are

ecryptfs-call-vfs_setxattr-in-ecryptfs_setxattr-v2.patch

