From: akpm@linux-foundation.org
Subject: [merged] shmem-recalculate-file-inode-when-fstat.patch removed
 from -mm tree
Date: Wed, 09 Sep 2015 12:53:14 -0700
Message-ID: <55f08e2a.LmJsDeVMb4Bvhzch%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41000 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755369AbbIITxP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 Sep 2015 15:53:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yuzhao@google.com, hughd@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: shmem: recalculate file inode when fstat
has been removed from the -mm tree.  Its filename was
     shmem-recalculate-file-inode-when-fstat.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Yu Zhao <yuzhao@google.com>
Subject: shmem: recalculate file inode when fstat

Shmem uses shmem_recalc_inode to update i_blocks when it allocates page,
undoes range or swaps.  But mm can drop clean page without notifying
shmem.  This makes fstat sometimes return out-of-date block size.

The problem can be partially solved when we add inode_operations->getattr
which calls shmem_recalc_inode to update i_blocks for fstat.

shmem_recalc_inode also updates counter used by statfs and
vm_committed_as.  For them the situation is not changed.  They still
suffer from the discrepancy after dropping clean page and before the
function is called by aforementioned triggers.

Signed-off-by: Yu Zhao <yuzhao@google.com>
Signed-off-by: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |   16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff -puN mm/shmem.c~shmem-recalculate-file-inode-when-fstat mm/shmem.c
--- a/mm/shmem.c~shmem-recalculate-file-inode-when-fstat
+++ a/mm/shmem.c
@@ -542,6 +542,21 @@ void shmem_truncate_range(struct inode *
 }
 EXPORT_SYMBOL_GPL(shmem_truncate_range);
 
+static int shmem_getattr(struct vfsmount *mnt, struct dentry *dentry,
+			 struct kstat *stat)
+{
+	struct inode *inode = dentry->d_inode;
+	struct shmem_inode_info *info = SHMEM_I(inode);
+
+	spin_lock(&info->lock);
+	shmem_recalc_inode(inode);
+	spin_unlock(&info->lock);
+
+	generic_fillattr(inode, stat);
+
+	return 0;
+}
+
 static int shmem_setattr(struct dentry *dentry, struct iattr *attr)
 {
 	struct inode *inode = d_inode(dentry);
@@ -3122,6 +3137,7 @@ static const struct file_operations shme
 };
 
 static const struct inode_operations shmem_inode_operations = {
+	.getattr	= shmem_getattr,
 	.setattr	= shmem_setattr,
 #ifdef CONFIG_TMPFS_XATTR
 	.setxattr	= shmem_setxattr,
_

Patches currently in -mm which might be from yuzhao@google.com are


