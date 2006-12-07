From: akpm@osdl.org
Subject: - patch-to-fix-reiserfs-bad-path-release-panic-on-2619-rc1.patch removed from -mm tree
Date: Thu, 07 Dec 2006 15:02:01 -0800
Message-ID: <200612072302.kB7N21Up029826@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:52803 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163944AbWLGXHl (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 7 Dec 2006 18:07:41 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: suzuki@in.ibm.com, jack@suse.cz, jeffm@suse.com, reiserfs-dev@namesys.com, vs@namesys.com, mm-commits@vger.kernel.org


The patch titled
     fix reiserfs bad path release panic
has been removed from the -mm tree.  Its filename was
     patch-to-fix-reiserfs-bad-path-release-panic-on-2619-rc1.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: fix reiserfs bad path release panic
From: Suzuki K P <suzuki@in.ibm.com>

One of our test team hit a reiserfs_panic while running fsstress tests on
2.6.19-rc1.  The message looks like :

<0>REISERFS: panic(device Null superblock): reiserfs[5676]: assertion
!(p->path_length != 1 ) failed at
fs/reiserfs/stree.c:397:reiserfs_check_path: path not properly relsed.

The backtrace looked :

kernel BUG in reiserfs_panic at fs/reiserfs/prints.c:361!
3:mon> t
[c0000000688aafb0] c00000000014f964 .reiserfs_check_path+0x58/0x74
[c0000000688ab030] c000000000135474 .reiserfs_get_block+0x1444/0x1508
[c0000000688ab2a0] c0000000000cdc8c .__block_prepare_write+0x1c8/0x558
[c0000000688ab3d0] c0000000000ce050 .block_prepare_write+0x34/0x64
[c0000000688ab450] c000000000132784 .reiserfs_prepare_write+0x118/0x1d0
[c0000000688ab500] c00000000009df14 .generic_file_buffered_write+0x314/0x82c
[c0000000688ab6b0] c00000000009e77c
.__generic_file_aio_write_nolock+0x350/0x3e0
[c0000000688ab7e0] c00000000009e988 .__generic_file_write_nolock+0x78/0xb0
[c0000000688ab950] c00000000009eb18 .generic_file_write+0x60/0xf0
[c0000000688aba10] c000000000138d2c .reiserfs_file_write+0x198/0x2038
[c0000000688abcf0] c0000000000ca1a8 .vfs_write+0xd0/0x1b4
[c0000000688abd90] c0000000000ca8c8 .sys_write+0x4c/0x8c
[c0000000688abe30] c00000000000871c syscall_exit+0x0/0x4

Upon debugging I found that the restart_transaction was not releasing
the path if the th->refcount was > 1.

/*static*/
int restart_transaction(struct reiserfs_transaction_handle *th,
                           			struct inode *inode, struct path *path)
{
	[...]

         /* we cannot restart while nested */
         if (th->t_refcount > 1) { <<- Path is not released in this case!
                 return 0;
         }

         pathrelse(path); <<- Path released here.
	[...]

This could happen in such a situation :

In reiserfs/inode.c: reiserfs_get_block() ::

      if (repeat == NO_DISK_SPACE || repeat == QUOTA_EXCEEDED) {
          /* restart the transaction to give the journal a chance to free
           ** some blocks.  releases the path, so we have to go back to
           ** research if we succeed on the second try
           */
          SB_JOURNAL(inode->i_sb)->j_next_async_flush = 1;

        -->>  retval = restart_transaction(th, inode, &path); <<--

  We are supposed to release the path, no matter we succeed or fail. But
if the th->refcount is > 1, the path is still valid. And,

          if (retval)
                   goto failure;
          repeat =
              _allocate_block(th, block, inode,
                             &allocated_block_nr, NULL, create);

If the above allocate_block fails with NO_DISK_SPACE or QUOTA_EXCEEDED,
we would have path which is not released.

         if (repeat != NO_DISK_SPACE && repeat != QUOTA_EXCEEDED) {
                   goto research;
         }
         if (repeat == QUOTA_EXCEEDED)
                   retval = -EDQUOT;
         else
                   retval = -ENOSPC;
         goto failure;
	[...]

       failure:
	[...]
         reiserfs_check_path(&path); << Panics here !

Attached here is a patch which could fix the issue.


fix reiserfs/inode.c : restart_transaction() to release the path in all
cases.

The restart_transaction() doesn't release the path when the the journal
handle has a refcount > 1.  This would trigger a reiserfs_panic() if we
encounter an -ENOSPC / -EDQUOT in reiserfs_get_block().

Signed-off-by: Suzuki K P <suzuki@in.ibm.com>
Cc: "Vladimir V. Saveliev" <vs@namesys.com>
Cc: <reiserfs-dev@namesys.com>
Cc: Jeff Mahoney <jeffm@suse.com>
Acked-by: Jan Kara <jack@suse.cz>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/reiserfs/inode.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN fs/reiserfs/inode.c~patch-to-fix-reiserfs-bad-path-release-panic-on-2619-rc1 fs/reiserfs/inode.c
--- a/fs/reiserfs/inode.c~patch-to-fix-reiserfs-bad-path-release-panic-on-2619-rc1
+++ a/fs/reiserfs/inode.c
@@ -216,11 +216,12 @@ static int file_capable(struct inode *in
 	BUG_ON(!th->t_trans_id);
 	BUG_ON(!th->t_refcount);
 
+	pathrelse(path);
+
 	/* we cannot restart while nested */
 	if (th->t_refcount > 1) {
 		return 0;
 	}
-	pathrelse(path);
 	reiserfs_update_sd(th, inode);
 	err = journal_end(th, s, len);
 	if (!err) {
_

Patches currently in -mm which might be from suzuki@in.ibm.com are

origin.patch

