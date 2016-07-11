From: akpm@linux-foundation.org
Subject: + ocfs2-cleanup-implemented-prototypes.patch added to -mm tree
Date: Mon, 11 Jul 2016 14:46:59 -0700
Message-ID: <578413d3.ooeovJ3tjS9Nm02n%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43352 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751887AbcGKVrA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 11 Jul 2016 17:47:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joseph.qi@huawei.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: cleanup implemented prototypes
has been added to the -mm tree.  Its filename is
     ocfs2-cleanup-implemented-prototypes.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-cleanup-implemented-prototypes.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-cleanup-implemented-prototypes.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Joseph Qi <joseph.qi@huawei.com>
Subject: ocfs2: cleanup implemented prototypes

Several prototypes in inode.h are just defined but not actually
implemented and used, so remove them.

Link: http://lkml.kernel.org/r/57763787.4020706@huawei.com
Signed-off-by: Joseph Qi <joseph.qi@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/inode.h |    7 -------
 fs/ocfs2/super.c |    1 -
 2 files changed, 8 deletions(-)

diff -puN fs/ocfs2/inode.h~ocfs2-cleanup-implemented-prototypes fs/ocfs2/inode.h
--- a/fs/ocfs2/inode.h~ocfs2-cleanup-implemented-prototypes
+++ a/fs/ocfs2/inode.h
@@ -145,22 +145,15 @@ int ocfs2_drop_inode(struct inode *inode
 struct inode *ocfs2_ilookup(struct super_block *sb, u64 feoff);
 struct inode *ocfs2_iget(struct ocfs2_super *osb, u64 feoff, unsigned flags,
 			 int sysfile_type);
-int ocfs2_inode_init_private(struct inode *inode);
 int ocfs2_inode_revalidate(struct dentry *dentry);
 void ocfs2_populate_inode(struct inode *inode, struct ocfs2_dinode *fe,
 			  int create_ino);
-void ocfs2_read_inode(struct inode *inode);
-void ocfs2_read_inode2(struct inode *inode, void *opaque);
-ssize_t ocfs2_rw_direct(int rw, struct file *filp, char *buf,
-			size_t size, loff_t *offp);
 void ocfs2_sync_blockdev(struct super_block *sb);
 void ocfs2_refresh_inode(struct inode *inode,
 			 struct ocfs2_dinode *fe);
 int ocfs2_mark_inode_dirty(handle_t *handle,
 			   struct inode *inode,
 			   struct buffer_head *bh);
-struct buffer_head *ocfs2_bread(struct inode *inode,
-				int block, int *err, int reada);
 
 void ocfs2_set_inode_flags(struct inode *inode);
 void ocfs2_get_inode_flags(struct ocfs2_inode_info *oi);
diff -puN fs/ocfs2/super.c~ocfs2-cleanup-implemented-prototypes fs/ocfs2/super.c
--- a/fs/ocfs2/super.c~ocfs2-cleanup-implemented-prototypes
+++ a/fs/ocfs2/super.c
@@ -2072,7 +2072,6 @@ static int ocfs2_initialize_super(struct
 	osb->osb_dx_seed[3] = le32_to_cpu(di->id2.i_super.s_uuid_hash);
 
 	osb->sb = sb;
-	/* Save off for ocfs2_rw_direct */
 	osb->s_sectsize_bits = blksize_bits(sector_size);
 	BUG_ON(!osb->s_sectsize_bits);
 
_

Patches currently in -mm which might be from joseph.qi@huawei.com are

ocfs2-cleanup-unneeded-goto-in-ocfs2_create_new_inode_locks.patch
ocfs2-dlm-fix-memory-leak-of-dlm_debug_ctxt.patch
ocfs2-cleanup-implemented-prototypes.patch

