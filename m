From: akpm@linux-foundation.org
Subject: + shmem-recalculate-file-inode-when-fstat.patch added to -mm tree
Date: Tue, 18 Aug 2015 14:25:06 -0700
Message-ID: <55d3a2b2.EAhX1Cqv5NUWUStj%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46983 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753085AbbHRVZH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 18 Aug 2015 17:25:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yuzhao@google.com, hughd@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: shmem: recalculate file inode when fstat
has been added to the -mm tree.  Its filename is
     shmem-recalculate-file-inode-when-fstat.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/shmem-recalculate-file-inode-when-fstat.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/shmem-recalculate-file-inode-when-fstat.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

shmem-recalculate-file-inode-when-fstat.patch

