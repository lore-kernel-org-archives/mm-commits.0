From: akpm@linux-foundation.org
Subject: +
 ocfs2-prune-the-dcache-before-deleting-the-dentry-of-directory.patch added
 to -mm tree
Date: Tue, 27 Jan 2015 14:28:55 -0800
Message-ID: <54c81127.RNm4Daep9MF93Q/i%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38706 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933106AbbA0W24 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 27 Jan 2015 17:28:56 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alex.chen@huawei.com, jlbec@evilplan.org, joseph.qi@huawei.com, mfasheh@suse.com, xuejiufei@huawei.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: prune the dcache before deleting the dentry of directory
has been added to the -mm tree.  Its filename is
     ocfs2-prune-the-dcache-before-deleting-the-dentry-of-directory.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-prune-the-dcache-before-deleting-the-dentry-of-directory.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-prune-the-dcache-before-deleting-the-dentry-of-directory.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Cc: Mark Fasheh <mfasheh@suse.com>
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

ocfs2-fix-snprintf-format-specifier-in-dlmdebugc.patch
ocfs2-fix-journal-commit-deadlock-in-ocfs2_convert_inline_data_to_extents.patch
ocfs2-add-a-mount-option-journal_async_commit-on-ocfs2-filesystem.patch
ocfs2-prune-the-dcache-before-deleting-the-dentry-of-directory.patch
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

