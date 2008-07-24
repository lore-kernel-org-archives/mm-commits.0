From: akpm@linux-foundation.org
Subject: - ecryptfs-inodec-mmapc-use-unaligned-byteorder-helpers.patch removed from -mm tree
Date: Thu, 24 Jul 2008 16:28:59 -0700
Message-ID: <200807242328.m6ONSxXq011325@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57960 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756629AbYGXX3D (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 Jul 2008 19:29:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: harvey.harrison@gmail.com, mhalcrow@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     ecryptfs: inode.c mmap.c use unaligned byteorder helpers
has been removed from the -mm tree.  Its filename was
     ecryptfs-inodec-mmapc-use-unaligned-byteorder-helpers.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ecryptfs: inode.c mmap.c use unaligned byteorder helpers
From: Harvey Harrison <harvey.harrison@gmail.com>

Fixe sparse warnings:
fs/ecryptfs/inode.c:368:15: warning: cast to restricted __be64
fs/ecryptfs/mmap.c:385:12: warning: incorrect type in assignment (different base types)
fs/ecryptfs/mmap.c:385:12:    expected unsigned long long [unsigned] [assigned] [usertype] file_size
fs/ecryptfs/mmap.c:385:12:    got restricted __be64 [usertype] <noident>
fs/ecryptfs/mmap.c:428:12: warning: incorrect type in assignment (different base types)
fs/ecryptfs/mmap.c:428:12:    expected unsigned long long [unsigned] [assigned] [usertype] file_size
fs/ecryptfs/mmap.c:428:12:    got restricted __be64 [usertype] <noident>

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Michael Halcrow <mhalcrow@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ecryptfs/inode.c |    4 ++--
 fs/ecryptfs/mmap.c  |   11 +++--------
 2 files changed, 5 insertions(+), 10 deletions(-)

diff -puN fs/ecryptfs/inode.c~ecryptfs-inodec-mmapc-use-unaligned-byteorder-helpers fs/ecryptfs/inode.c
--- a/fs/ecryptfs/inode.c~ecryptfs-inodec-mmapc-use-unaligned-byteorder-helpers
+++ a/fs/ecryptfs/inode.c
@@ -31,6 +31,7 @@
 #include <linux/mount.h>
 #include <linux/crypto.h>
 #include <linux/fs_stack.h>
+#include <asm/unaligned.h>
 #include "ecryptfs_kernel.h"
 
 static struct dentry *lock_parent(struct dentry *dentry)
@@ -364,8 +365,7 @@ static struct dentry *ecryptfs_lookup(st
 		else
 			file_size = i_size_read(lower_dentry->d_inode);
 	} else {
-		memcpy(&file_size, page_virt, sizeof(file_size));
-		file_size = be64_to_cpu(file_size);
+		file_size = get_unaligned_be64(page_virt);
 	}
 	i_size_write(dentry->d_inode, (loff_t)file_size);
 	kmem_cache_free(ecryptfs_header_cache_2, page_virt);
diff -puN fs/ecryptfs/mmap.c~ecryptfs-inodec-mmapc-use-unaligned-byteorder-helpers fs/ecryptfs/mmap.c
--- a/fs/ecryptfs/mmap.c~ecryptfs-inodec-mmapc-use-unaligned-byteorder-helpers
+++ a/fs/ecryptfs/mmap.c
@@ -32,6 +32,7 @@
 #include <linux/file.h>
 #include <linux/crypto.h>
 #include <linux/scatterlist.h>
+#include <asm/unaligned.h>
 #include "ecryptfs_kernel.h"
 
 /**
@@ -372,7 +373,6 @@ out:
  */
 static int ecryptfs_write_inode_size_to_header(struct inode *ecryptfs_inode)
 {
-	u64 file_size;
 	char *file_size_virt;
 	int rc;
 
@@ -381,9 +381,7 @@ static int ecryptfs_write_inode_size_to_
 		rc = -ENOMEM;
 		goto out;
 	}
-	file_size = (u64)i_size_read(ecryptfs_inode);
-	file_size = cpu_to_be64(file_size);
-	memcpy(file_size_virt, &file_size, sizeof(u64));
+	put_unaligned_be64(i_size_read(ecryptfs_inode), file_size_virt);
 	rc = ecryptfs_write_lower(ecryptfs_inode, file_size_virt, 0,
 				  sizeof(u64));
 	kfree(file_size_virt);
@@ -403,7 +401,6 @@ static int ecryptfs_write_inode_size_to_
 	struct dentry *lower_dentry =
 		ecryptfs_inode_to_private(ecryptfs_inode)->lower_file->f_dentry;
 	struct inode *lower_inode = lower_dentry->d_inode;
-	u64 file_size;
 	int rc;
 
 	if (!lower_inode->i_op->getxattr || !lower_inode->i_op->setxattr) {
@@ -424,9 +421,7 @@ static int ecryptfs_write_inode_size_to_
 					   xattr_virt, PAGE_CACHE_SIZE);
 	if (size < 0)
 		size = 8;
-	file_size = (u64)i_size_read(ecryptfs_inode);
-	file_size = cpu_to_be64(file_size);
-	memcpy(xattr_virt, &file_size, sizeof(u64));
+	put_unaligned_be64(i_size_read(ecryptfs_inode), xattr_virt);
 	rc = lower_inode->i_op->setxattr(lower_dentry, ECRYPTFS_XATTR_NAME,
 					 xattr_virt, size, 0);
 	mutex_unlock(&lower_inode->i_mutex);
_

Patches currently in -mm which might be from harvey.harrison@gmail.com are

origin.patch
linux-next.patch
cifs-remove-global_extern-macro.patch
input-ads7846c-sparse-lock-annotation.patch
mtd-diskonchipc-fix-sparse-endian-warnings.patch
scsi-replace-remaining-__function__-occurrences.patch
fusion-replace-remaining-__function__-occurrences.patch
scsi-replace-__inline-with-inline.patch
scsi-aic79xx_core-fix-shadowed-variables-add-statics.patch
scsi-aic79xx-aic79xx_pcic-fix-shadowed-variables.patch
scsi-gdthc-use-unaligned-access-helpers.patch
scsi-gdthc-use-unaligned-access-helpers-checkpatch-fixes.patch
xfs-use-get_unaligned_-helpers.patch
xtensa-replace-remaining-__function__-occurences.patch
fs-ldm-use-get_unaligned_-helpers.patch
include-use-get-put_unaligned_-helpers.patch
lzo-use-get-put_unaligned_-helpers.patch
asm-generic-int-ll64h-always-provide-__su64.patch
olpc-olpc_batteryc-sparse-endian-annotations.patch
markers-fix-sparse-integer-as-null-pointer-warning.patch
scsi-use-the-common-hex_asc-array-rather-than-a-private-one.patch
isdn-use-the-common-ascii-hex-helpers.patch
net-use-the-common-ascii-hex-helpers.patch
cris-use-the-common-ascii-hex-helpers.patch
frv-use-the-common-ascii-hex-helpers.patch
ppc-use-the-common-ascii-hex-helpers.patch
ppc-use-the-common-ascii-hex-helpers-fix.patch
mn10300-use-the-common-ascii-hex-helpers.patch
byteorder-add-a-new-include-linux-swabh-to-define-byteswapping-functions.patch
byteorder-add-include-linux-byteorderh-to-define-endian-helpers.patch

