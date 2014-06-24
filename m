From: akpm@linux-foundation.org
Subject: [merged] refcount-take-rw_lock-in-ocfs2_reflink.patch removed
 from -mm tree
Date: Tue, 24 Jun 2014 12:02:57 -0700
Message-ID: <53a9cb61.5cTN7qMx+fdTGmMA%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35669 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753302AbaFXTC6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 24 Jun 2014 15:02:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: wen.gang.wang@oracle.com, jlbec@evilplan.org, mfasheh@suse.de, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: refcount: take rw_lock in ocfs2_reflink
has been removed from the -mm tree.  Its filename was
     refcount-take-rw_lock-in-ocfs2_reflink.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Wengang Wang <wen.gang.wang@oracle.com>
Subject: ocfs2: refcount: take rw_lock in ocfs2_reflink

This patch tries to fix this crash:

 #5 [ffff88003c1cd690] do_invalid_op at ffffffff810166d5
 #6 [ffff88003c1cd730] invalid_op at ffffffff8159b2de
    [exception RIP: ocfs2_direct_IO_get_blocks+359]
    RIP: ffffffffa05dfa27  RSP: ffff88003c1cd7e8  RFLAGS: 00010202
    RAX: 0000000000000000  RBX: ffff88003c1cdaa8  RCX: 0000000000000000
    RDX: 000000000000000c  RSI: ffff880027a95000  RDI: ffff88003c79b540
    RBP: ffff88003c1cd858   R8: 0000000000000000   R9: ffffffff815f6ba0
    R10: 00000000000001c9  R11: 00000000000001c9  R12: ffff88002d271500
    R13: 0000000000000001  R14: 0000000000000000  R15: 0000000000001000
    ORIG_RAX: ffffffffffffffff  CS: 0010  SS: 0018
 #7 [ffff88003c1cd860] do_direct_IO at ffffffff811cd31b
 #8 [ffff88003c1cd950] direct_IO_iovec at ffffffff811cde9c
 #9 [ffff88003c1cd9b0] do_blockdev_direct_IO at ffffffff811ce764
#10 [ffff88003c1cdb80] __blockdev_direct_IO at ffffffff811ce7cc
#11 [ffff88003c1cdbb0] ocfs2_direct_IO at ffffffffa05df756 [ocfs2]
#12 [ffff88003c1cdbe0] generic_file_direct_write_iter at ffffffff8112f935
#13 [ffff88003c1cdc40] ocfs2_file_write_iter at ffffffffa0600ccc [ocfs2]
#14 [ffff88003c1cdd50] do_aio_write at ffffffff8119126c
#15 [ffff88003c1cddc0] aio_rw_vect_retry at ffffffff811d9bb4
#16 [ffff88003c1cddf0] aio_run_iocb at ffffffff811db880
#17 [ffff88003c1cde30] io_submit_one at ffffffff811dc238
#18 [ffff88003c1cde80] do_io_submit at ffffffff811dc437
#19 [ffff88003c1cdf70] sys_io_submit at ffffffff811dc530
#20 [ffff88003c1cdf80] system_call_fastpath at ffffffff8159a159

It crashes at
	BUG_ON(create && (ext_flags & OCFS2_EXT_REFCOUNTED));
in ocfs2_direct_IO_get_blocks.

ocfs2_direct_IO_get_blocks is expecting the OCFS2_EXT_REFCOUNTED be removed in
ocfs2_prepare_inode_for_write() if it was there. But no cluster lock is taken
during the time before (or inside) ocfs2_prepare_inode_for_write() and after
ocfs2_direct_IO_get_blocks().

It can happen in this case:

Node A(which crashes)				Node B
------------------------                 ---------------------------
ocfs2_file_aio_write
  ocfs2_prepare_inode_for_write
    ocfs2_inode_lock
    ...
    ocfs2_inode_unlock
  #no refcount found
....					ocfs2_reflink
					  ocfs2_inode_lock
					  ...
					  ocfs2_inode_unlock
					  #now, refcount flag set on extent

					...
					flush change to disk

ocfs2_direct_IO_get_blocks
  ocfs2_get_clusters
    #extent map miss
    #buffer_head miss
    read extents from disk
  found refcount flag on extent
  crash..

Fix:
Take rw_lock in ocfs2_reflink path

Signed-off-by: Wengang Wang <wen.gang.wang@oracle.com>
Reviewed-by: Mark Fasheh <mfasheh@suse.de>
Cc: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/refcounttree.c |    8 ++++++++
 1 file changed, 8 insertions(+)

diff -puN fs/ocfs2/refcounttree.c~refcount-take-rw_lock-in-ocfs2_reflink fs/ocfs2/refcounttree.c
--- a/fs/ocfs2/refcounttree.c~refcount-take-rw_lock-in-ocfs2_reflink
+++ a/fs/ocfs2/refcounttree.c
@@ -4288,9 +4288,16 @@ static int ocfs2_reflink(struct dentry *
 		goto out;
 	}
 
+	error = ocfs2_rw_lock(inode, 1);
+	if (error) {
+		mlog_errno(error);
+		goto out;
+	}
+
 	error = ocfs2_inode_lock(inode, &old_bh, 1);
 	if (error) {
 		mlog_errno(error);
+		ocfs2_rw_unlock(inode, 1);
 		goto out;
 	}
 
@@ -4302,6 +4309,7 @@ static int ocfs2_reflink(struct dentry *
 	up_write(&OCFS2_I(inode)->ip_xattr_sem);
 
 	ocfs2_inode_unlock(inode, 1);
+	ocfs2_rw_unlock(inode, 1);
 	brelse(old_bh);
 
 	if (error) {
_

Patches currently in -mm which might be from wen.gang.wang@oracle.com are

origin.patch

