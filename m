From: akpm@linux-foundation.org
Subject: - r-o-bind-mounts-make-access-use-new-r-o-helper.patch removed from -mm tree
Date: Wed, 26 Mar 2008 11:40:58 -0700
Message-ID: <200803261840.m2QIew7v028722@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38198 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758311AbYCZSlh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 26 Mar 2008 14:41:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: haveblue@us.ibm.com, hch@infradead.org, viro@ZenIV.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     r/o bind mounts: make access() use new r/o helper
has been removed from the -mm tree.  Its filename was
     r-o-bind-mounts-make-access-use-new-r-o-helper.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: r/o bind mounts: make access() use new r/o helper
From: Dave Hansen <haveblue@us.ibm.com>

It is OK to let access() go without using a mnt_want/drop_write() pair because
it doesn't actually do writes to the filesystem, and it is inherently racy
anyway.  This is a rare case when it is OK to use __mnt_is_readonly()
directly.

Acked-by: Al Viro <viro@ZenIV.linux.org.uk>
Signed-off-by: Christoph Hellwig <hch@infradead.org>
Signed-off-by: Dave Hansen <haveblue@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/open.c |   13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff -puN fs/open.c~r-o-bind-mounts-make-access-use-new-r-o-helper fs/open.c
--- a/fs/open.c~r-o-bind-mounts-make-access-use-new-r-o-helper
+++ a/fs/open.c
@@ -459,8 +459,17 @@ asmlinkage long sys_faccessat(int dfd, c
 	if(res || !(mode & S_IWOTH) ||
 	   special_file(nd.path.dentry->d_inode->i_mode))
 		goto out_path_release;
-
-	if(IS_RDONLY(nd.path.dentry->d_inode))
+	/*
+	 * This is a rare case where using __mnt_is_readonly()
+	 * is OK without a mnt_want/drop_write() pair.  Since
+	 * no actual write to the fs is performed here, we do
+	 * not need to telegraph to that to anyone.
+	 *
+	 * By doing this, we accept that this access is
+	 * inherently racy and know that the fs may change
+	 * state before we even see this result.
+	 */
+	if (__mnt_is_readonly(nd.path.mnt))
 		res = -EROFS;
 
 out_path_release:
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

