From: akpm@linux-foundation.org
Subject: + iget-stop-unionfs-from-using-iget-and-read_inode-fix.patch added to -mm tree
Date: Sun, 11 Nov 2007 11:54:31 -0800
Message-ID: <200711111954.lABJsWVO021653@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52933 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756296AbXKKTyn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 11 Nov 2007 14:54:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ezk@cs.sunysb.edu


The patch titled
     Unionfs: stop using iget() and read_inode()
has been added to the -mm tree.  Its filename is
     iget-stop-unionfs-from-using-iget-and-read_inode-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Unionfs: stop using iget() and read_inode()
From: Erez Zadok <ezk@cs.sunysb.edu>

Unionfs: bugfix to initialize unionfs_inode_info node

Signed-off-by: Erez Zadok <ezk@cs.sunysb.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/unionfs/super.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN fs/unionfs/super.c~iget-stop-unionfs-from-using-iget-and-read_inode-fix fs/unionfs/super.c
--- a/fs/unionfs/super.c~iget-stop-unionfs-from-using-iget-and-read_inode-fix
+++ a/fs/unionfs/super.c
@@ -38,6 +38,7 @@ struct inode *unionfs_iget(struct super_
 
  	unionfs_read_lock(sb);
 
+	info = UNIONFS_I(inode);
 	memset(info, 0, offsetof(struct unionfs_inode_info, vfs_inode));
 	info->bstart = -1;
 	info->bend = -1;
_

Patches currently in -mm which might be from ezk@cs.sunysb.edu are

hugetlb-follow_hugetlb_page-for-write-access-fix.patch
git-unionfs.patch
unionfs-clear-partial-read.patch
vfs-apply-coding-standards-to-fs-ioctlc.patch
vfs-swap-do_ioctl-and-vfs_ioctl-names.patch
vfs-swap-do_ioctl-and-vfs_ioctl-names-fix.patch
vfs-factor-out-three-helpers-for-fibmap-fionbio-fioasync-file-ioctls.patch
add-64-bit-capability-support-to-the-kernel-fix-fix.patch
r-o-bind-mounts-track-number-of-mount-writer-fix-buggy-loop.patch
r-o-bind-mounts-track-number-of-mount-writer-fix-buggy-loop-checkpatch-fixes.patch
iget-stop-unionfs-from-using-iget-and-read_inode.patch
iget-stop-unionfs-from-using-iget-and-read_inode-fix.patch
