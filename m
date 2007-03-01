From: akpm@linux-foundation.org
Subject: + ecryptfs-check-xattr-operation-support-fix.patch added to -mm tree
Date: Wed, 28 Feb 2007 23:58:38 -0800
Message-ID: <200703010758.l217wcR8007991@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:33140 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752355AbXCAH7a (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 1 Mar 2007 02:59:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dmonakhov@sw.ru, dmonakhov@openvz.org, mhalcrow@us.ibm.com


The patch titled
     ecryptfs: check xattr operation support fix
has been added to the -mm tree.  Its filename is
     ecryptfs-check-xattr-operation-support-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: ecryptfs: check xattr operation support fix
From: Dmitriy Monakhov <dmonakhov@sw.ru>

  - ecryptfs_write_inode_size_to_metadata() error code was ignored.
  - i_op->setxattr() must be supported by lower fs because used below.

Signed-off-by: Monakhov Dmitriy <dmonakhov@openvz.org>
Acked-by: Michael Halcrow <mhalcrow@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ecryptfs/inode.c |    6 +++---
 fs/ecryptfs/mmap.c  |    3 ++-
 2 files changed, 5 insertions(+), 4 deletions(-)

diff -puN fs/ecryptfs/inode.c~ecryptfs-check-xattr-operation-support-fix fs/ecryptfs/inode.c
--- a/fs/ecryptfs/inode.c~ecryptfs-check-xattr-operation-support-fix
+++ a/fs/ecryptfs/inode.c
@@ -168,9 +168,9 @@ static int grow_file(struct dentry *ecry
 		goto out;
 	}
 	i_size_write(inode, 0);
-	ecryptfs_write_inode_size_to_metadata(lower_file, lower_inode, inode,
-					      ecryptfs_dentry,
-					      ECRYPTFS_LOWER_I_MUTEX_NOT_HELD);
+	rc = ecryptfs_write_inode_size_to_metadata(lower_file, lower_inode,
+			inode, ecryptfs_dentry,
+			ECRYPTFS_LOWER_I_MUTEX_NOT_HELD);
 	ecryptfs_inode_to_private(inode)->crypt_stat.flags |= ECRYPTFS_NEW_FILE;
 out:
 	return rc;
diff -puN fs/ecryptfs/mmap.c~ecryptfs-check-xattr-operation-support-fix fs/ecryptfs/mmap.c
--- a/fs/ecryptfs/mmap.c~ecryptfs-check-xattr-operation-support-fix
+++ a/fs/ecryptfs/mmap.c
@@ -502,7 +502,8 @@ static int ecryptfs_write_inode_size_to_
 		goto out;
 	}
 	lower_dentry = ecryptfs_dentry_to_lower(ecryptfs_dentry);
-	if (!lower_dentry->d_inode->i_op->getxattr) {
+	if (!lower_dentry->d_inode->i_op->getxattr ||
+			!lower_dentry->d_inode->i_op->setxattr) {
 		printk(KERN_WARNING
 		       "No support for setting xattr in lower filesystem\n");
 		rc = -ENOSYS;
_

Patches currently in -mm which might be from dmonakhov@sw.ru are

ecryptfs-check-xattr-operation-support-fix.patch
libata-handle-ata_pci_device_do_resume-failure-while-resuming-v2.patch
3c59x-handle-pci_enable_device-failure-while-resuming.patch
freevxfs-possible-null-pointer-dereference-fix.patch
reiserfs-possible-null-pointer-dereference-during-resize.patch
