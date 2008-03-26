From: akpm@linux-foundation.org
Subject: - r-o-bind-mounts-write-counts-for-link-symlink.patch removed from -mm tree
Date: Wed, 26 Mar 2008 11:40:41 -0700
Message-ID: <200803261840.m2QIefkh028688@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59960 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757321AbYCZSqD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 26 Mar 2008 14:46:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: haveblue@us.ibm.com, hch@lst.de, viro@ZenIV.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     r/o bind mounts: write counts for link/symlink
has been removed from the -mm tree.  Its filename was
     r-o-bind-mounts-write-counts-for-link-symlink.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: r/o bind mounts: write counts for link/symlink
From: Dave Hansen <haveblue@us.ibm.com>

Acked-by: Al Viro <viro@ZenIV.linux.org.uk>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Dave Hansen <haveblue@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/namei.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff -puN fs/namei.c~r-o-bind-mounts-write-counts-for-link-symlink fs/namei.c
--- a/fs/namei.c~r-o-bind-mounts-write-counts-for-link-symlink
+++ a/fs/namei.c
@@ -2366,7 +2366,12 @@ asmlinkage long sys_symlinkat(const char
 	if (IS_ERR(dentry))
 		goto out_unlock;
 
+	error = mnt_want_write(nd.path.mnt);
+	if (error)
+		goto out_dput;
 	error = vfs_symlink(nd.path.dentry->d_inode, dentry, from, S_IALLUGO);
+	mnt_drop_write(nd.path.mnt);
+out_dput:
 	dput(dentry);
 out_unlock:
 	mutex_unlock(&nd.path.dentry->d_inode->i_mutex);
@@ -2461,7 +2466,12 @@ asmlinkage long sys_linkat(int olddfd, c
 	error = PTR_ERR(new_dentry);
 	if (IS_ERR(new_dentry))
 		goto out_unlock;
+	error = mnt_want_write(nd.path.mnt);
+	if (error)
+		goto out_dput;
 	error = vfs_link(old_nd.path.dentry, nd.path.dentry->d_inode, new_dentry);
+	mnt_drop_write(nd.path.mnt);
+out_dput:
 	dput(new_dentry);
 out_unlock:
 	mutex_unlock(&nd.path.dentry->d_inode->i_mutex);
_

Patches currently in -mm which might be from haveblue@us.ibm.com are

git-vfs.patch
hugetlb-decrease-hugetlb_lock-cycling-in-gather_surplus_huge_pages.patch
mm-make-mem_map-allocation-continuous.patch
vfs-create-proc-pid-mountinfo.patch
vfs-mountinfo-mm-fix.patch
vfs-pnode-cleanup.patch
vfs-mountinfo-stable-peer-group-id.patch
vfs-mountinfo-show-dominating-group-id.patch
vfs-optimization-to-proc-pid-mountinfo-patch.patch
vfs-mountinfo-only-show-mounts-under-tasks-root.patch
kprobes-prevent-probing-of-preempt_schedule.patch
kprobes-prevent-probing-of-preempt_schedule-fix.patch
kprobes-prevent-probing-of-preempt_schedule-checkpatch-fixes.patch
reiser4.patch
page-owner-tracking-leak-detector.patch

