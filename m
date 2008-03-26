From: akpm@linux-foundation.org
Subject: - r-o-bind-mounts-elevate-write-count-for-vfs_rmdir.patch removed from -mm tree
Date: Wed, 26 Mar 2008 11:40:20 -0700
Message-ID: <200803261840.m2QIeKof028655@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43351 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758213AbYCZSkr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 26 Mar 2008 14:40:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: haveblue@us.ibm.com, hch@lst.de, serue@us.ibm.com, viro@ZenIV.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     r/o bind mounts: elevate write count for vfs_rmdir()
has been removed from the -mm tree.  Its filename was
     r-o-bind-mounts-elevate-write-count-for-vfs_rmdir.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: r/o bind mounts: elevate write count for vfs_rmdir()
From: Dave Hansen <haveblue@us.ibm.com>

Elevate the write count during the vfs_rmdir() call.

Acked-by: Serge Hallyn <serue@us.ibm.com>
Acked-by: Al Viro <viro@ZenIV.linux.org.uk>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Dave Hansen <haveblue@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/namei.c |    5 +++++
 1 file changed, 5 insertions(+)

diff -puN fs/namei.c~r-o-bind-mounts-elevate-write-count-for-vfs_rmdir fs/namei.c
--- a/fs/namei.c~r-o-bind-mounts-elevate-write-count-for-vfs_rmdir
+++ a/fs/namei.c
@@ -2190,7 +2190,12 @@ static long do_rmdir(int dfd, const char
 	error = PTR_ERR(dentry);
 	if (IS_ERR(dentry))
 		goto exit2;
+	error = mnt_want_write(nd.path.mnt);
+	if (error)
+		goto exit3;
 	error = vfs_rmdir(nd.path.dentry->d_inode, dentry);
+	mnt_drop_write(nd.path.mnt);
+exit3:
 	dput(dentry);
 exit2:
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

