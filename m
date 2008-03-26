From: akpm@linux-foundation.org
Subject: - r-o-bind-mounts-elevate-mnt_writers-for-unlink-callers.patch removed from -mm tree
Date: Wed, 26 Mar 2008 11:40:26 -0700
Message-ID: <200803261840.m2QIeQSe028664@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41394 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760979AbYCZSkr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 26 Mar 2008 14:40:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: haveblue@us.ibm.com, hch@lst.de, viro@ZenIV.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     r/o bind mounts: elevate mnt_writers for unlink callers
has been removed from the -mm tree.  Its filename was
     r-o-bind-mounts-elevate-mnt_writers-for-unlink-callers.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: r/o bind mounts: elevate mnt_writers for unlink callers
From: Dave Hansen <haveblue@us.ibm.com>

Acked-by: Al Viro <viro@ZenIV.linux.org.uk>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Dave Hansen <haveblue@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/namei.c   |    4 ++++
 ipc/mqueue.c |    5 ++++-
 2 files changed, 8 insertions(+), 1 deletion(-)

diff -puN fs/namei.c~r-o-bind-mounts-elevate-mnt_writers-for-unlink-callers fs/namei.c
--- a/fs/namei.c~r-o-bind-mounts-elevate-mnt_writers-for-unlink-callers
+++ a/fs/namei.c
@@ -2281,7 +2281,11 @@ static long do_unlinkat(int dfd, const c
 		inode = dentry->d_inode;
 		if (inode)
 			atomic_inc(&inode->i_count);
+		error = mnt_want_write(nd.path.mnt);
+		if (error)
+			goto exit2;
 		error = vfs_unlink(nd.path.dentry->d_inode, dentry);
+		mnt_drop_write(nd.path.mnt);
 	exit2:
 		dput(dentry);
 	}
diff -puN ipc/mqueue.c~r-o-bind-mounts-elevate-mnt_writers-for-unlink-callers ipc/mqueue.c
--- a/ipc/mqueue.c~r-o-bind-mounts-elevate-mnt_writers-for-unlink-callers
+++ a/ipc/mqueue.c
@@ -742,8 +742,11 @@ asmlinkage long sys_mq_unlink(const char
 	inode = dentry->d_inode;
 	if (inode)
 		atomic_inc(&inode->i_count);
-
+	err = mnt_want_write(mqueue_mnt);
+	if (err)
+		goto out_err;
 	err = vfs_unlink(dentry->d_parent->d_inode, dentry);
+	mnt_drop_write(mqueue_mnt);
 out_err:
 	dput(dentry);
 
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

