From: akpm@linux-foundation.org
Subject: [merged]
 ocfs2-prune-the-dcache-before-deleting-the-dentry-of-directory.patch
 removed from -mm tree
Date: Wed, 11 Feb 2015 12:21:28 -0800
Message-ID: <54dbb9c8.y8Pn9Y65JfctfQ2s%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40862 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751782AbbBKUV3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 11 Feb 2015 15:21:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alex.chen@huawei.com, jlbec@evilplan.org, joseph.qi@huawei.com, mfasheh@suse.com, xuejiufei@huawei.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: prune the dcache before deleting the dentry of directory
has been removed from the -mm tree.  Its filename was
     ocfs2-prune-the-dcache-before-deleting-the-dentry-of-directory.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: alex chen <alex.chen@huawei.com>
Subject: ocfs2: prune the dcache before deleting the dentry of directory

In ocfs2_dentry_convert_worker, we should prune the dcache before deleting
the dentry of directory, otherwise, in the following cases the inode of
directory will still remain in orphan directory until the device being
umounted.

Mount point: /mnt/ocfs2
Node A                              Node B
mkdir /mnt/ocfs2/testdir
  ocfs2_mkdir
  ->ocfs2_mknod
  ->ocfs2_dentry_attach_lock
  ->ocfs2_dentry_lock(dentry, 0)
  ... ...
touch /mnt/ocfs2/testdir/testfile
                                    unlink /mnt/test/testdir/testfile
                                    rmdir /mnt/ocfs2/testdir
                                      ocfs2_unlink
                                      ->ocfs2_remote_dentry_delete
                                      ->ocfs2_dentry_lock(dentry, 1)
                                      ... ...
... ...
ocfs2_downconvert_thread
->ocfs2_unblock_lock
->ocfs2_dentry_convert_worker
->ocfs2_find_local_alias
  ->dget_dlock
->d_delete
Here the dentry can not be
released because the children's
dentry is negative but still exist.
Finally, this inode will still remain
in orphan directory until its children
are destroyed.

So before deleting dentry of directory, we should prune the dcache to
remove unused children of the parent dentry by shrink_dcache_parent().

Signed-off-by: Alex Chen <alex.chen@huawei.com>
Reviewed-by: Joseph Qi <joseph.qi@huawei.com>
Reviewed-by: joyce.xue <xuejiufei@huawei.com>
Reviewed-by: Mark Fasheh <mfasheh@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/dlmglue.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN fs/ocfs2/dlmglue.c~ocfs2-prune-the-dcache-before-deleting-the-dentry-of-directory fs/ocfs2/dlmglue.c
--- a/fs/ocfs2/dlmglue.c~ocfs2-prune-the-dcache-before-deleting-the-dentry-of-directory
+++ a/fs/ocfs2/dlmglue.c
@@ -3750,6 +3750,9 @@ static int ocfs2_dentry_convert_worker(s
 			break;
 		spin_unlock(&dentry_attach_lock);
 
+		if (S_ISDIR(dl->dl_inode->i_mode))
+			shrink_dcache_parent(dentry);
+
 		mlog(0, "d_delete(%pd);\n", dentry);
 
 		/*
_

Patches currently in -mm which might be from alex.chen@huawei.com are

origin.patch
linux-next.patch
ocfs2-prepare-some-interfaces-used-in-append-direct-io.patch
ocfs2-add-functions-to-add-and-remove-inode-in-orphan-dir.patch
ocfs2-add-functions-to-add-and-remove-inode-in-orphan-dir-fix.patch
ocfs2-add-orphan-recovery-types-in-ocfs2_recover_orphans.patch
ocfs2-implement-ocfs2_direct_io_write.patch
ocfs2-implement-ocfs2_direct_io_write-fix.patch
ocfs2-allocate-blocks-in-ocfs2_direct_io_get_blocks.patch
ocfs2-do-not-fallback-to-buffer-i-o-write-if-appending.patch
ocfs2-complete-the-rest-request-through-buffer-io.patch
ocfs2-wait-for-orphan-recovery-first-once-append-o_direct-write-crash.patch
ocfs2-set-append-dio-as-a-ro-compat-feature.patch

