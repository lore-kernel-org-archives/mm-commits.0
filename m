From: akpm@linux-foundation.org
Subject: [merged]
 nilfs2-fix-deadlock-of-segment-constructor-during-recovery.patch removed
 from -mm tree
Date: Mon, 16 Mar 2015 11:02:42 -0700
Message-ID: <55071ac2.bEHzRT+rCytzBPLt%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33541 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932944AbbCPSCn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 16 Mar 2015 14:02:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: konishi.ryusuke@lab.ntt.co.jp, stable@vger.kernel.org, viro@zeniv.linux.org.uk, yshuiv7@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: nilfs2: fix deadlock of segment constructor during recovery
has been removed from the -mm tree.  Its filename was
     nilfs2-fix-deadlock-of-segment-constructor-during-recovery.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Subject: nilfs2: fix deadlock of segment constructor during recovery

According to a report from Yuxuan Shui, nilfs2 in kernel 3.19 got stuck
during recovery at mount time.  The code path that caused the deadlock was
as follows:

  nilfs_fill_super()
    load_nilfs()
      nilfs_salvage_orphan_logs()
        * Do roll-forwarding, attach segment constructor for recovery,
          and kick it.

        nilfs_segctor_thread()
          nilfs_segctor_thread_construct()
           * A lock is held with nilfs_transaction_lock()
             nilfs_segctor_do_construct()
               nilfs_segctor_drop_written_files()
                 iput()
                   iput_final()
                     write_inode_now()
                       writeback_single_inode()
                         __writeback_single_inode()
                           do_writepages()
                             nilfs_writepage()
                               nilfs_construct_dsync_segment()
                                 nilfs_transaction_lock() --> deadlock

This can happen if commit 7ef3ff2fea8b ("nilfs2: fix deadlock of segment
constructor over I_SYNC flag") is applied and roll-forward recovery was
performed at mount time.  The roll-forward recovery can happen if datasync
write is done and the file system crashes immediately after that.  For
instance, we can reproduce the issue with the following steps:

 < nilfs2 is mounted on /nilfs (device: /dev/sdb1) >
 # dd if=/dev/zero of=/nilfs/test bs=4k count=1 && sync
 # dd if=/dev/zero of=/nilfs/test conv=notrunc oflag=dsync bs=4k
 count=1 && reboot -nfh
 < the system will immediately reboot >
 # mount -t nilfs2 /dev/sdb1 /nilfs

The deadlock occurs because iput() can run segment constructor through
writeback_single_inode() if MS_ACTIVE flag is not set on sb->s_flags.  The
above commit changed segment constructor so that it calls iput()
asynchronously for inodes with i_nlink == 0, but that change was
imperfect.

This fixes the another deadlock by deferring iput() in segment constructor
even for the case that mount is not finished, that is, for the case that
MS_ACTIVE flag is not set.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Reported-by: Yuxuan Shui <yshuiv7@gmail.com>
Tested-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/segment.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff -puN fs/nilfs2/segment.c~nilfs2-fix-deadlock-of-segment-constructor-during-recovery fs/nilfs2/segment.c
--- a/fs/nilfs2/segment.c~nilfs2-fix-deadlock-of-segment-constructor-during-recovery
+++ a/fs/nilfs2/segment.c
@@ -1907,6 +1907,7 @@ static void nilfs_segctor_drop_written_f
 					     struct the_nilfs *nilfs)
 {
 	struct nilfs_inode_info *ii, *n;
+	int during_mount = !(sci->sc_super->s_flags & MS_ACTIVE);
 	int defer_iput = false;
 
 	spin_lock(&nilfs->ns_inode_lock);
@@ -1919,10 +1920,10 @@ static void nilfs_segctor_drop_written_f
 		brelse(ii->i_bh);
 		ii->i_bh = NULL;
 		list_del_init(&ii->i_dirty);
-		if (!ii->vfs_inode.i_nlink) {
+		if (!ii->vfs_inode.i_nlink || during_mount) {
 			/*
-			 * Defer calling iput() to avoid a deadlock
-			 * over I_SYNC flag for inodes with i_nlink == 0
+			 * Defer calling iput() to avoid deadlocks if
+			 * i_nlink == 0 or mount is not yet finished.
 			 */
 			list_add_tail(&ii->i_dirty, &sci->sc_iput_queue);
 			defer_iput = true;
_

Patches currently in -mm which might be from konishi.ryusuke@lab.ntt.co.jp are


