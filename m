From: akpm@linux-foundation.org
Subject: [merged] fs-make-sure-data-stored-into-inode-is-properly-seen-before-unlocking-new-inode.patch removed from -mm tree
Date: Tue, 22 Sep 2009 13:36:52 -0700
Message-ID: <200909222036.n8MKaq5n030695@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46180 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752570AbZIVUi1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 22 Sep 2009 16:38:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jack@suse.cz, hch@infradead.org, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     fs: make sure data stored into inode is properly seen before unlocking new inode
has been removed from the -mm tree.  Its filename was
     fs-make-sure-data-stored-into-inode-is-properly-seen-before-unlocking-new-inode.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fs: make sure data stored into inode is properly seen before unlocking new inode
From: Jan Kara <jack@suse.cz>

In theory it could happen that on one CPU we initialize a new inode but
clearing of I_NEW | I_LOCK gets reordered before some of the
initialization.  Thus on another CPU we return not fully uptodate inode
from iget_locked().

This seems to fix a corruption issue on ext3 mounted over NFS.

[akpm@linux-foundation.org: add some commentary]
Signed-off-by: Jan Kara <jack@suse.cz>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/inode.c |   14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff -puN fs/inode.c~fs-make-sure-data-stored-into-inode-is-properly-seen-before-unlocking-new-inode fs/inode.c
--- a/fs/inode.c~fs-make-sure-data-stored-into-inode-is-properly-seen-before-unlocking-new-inode
+++ a/fs/inode.c
@@ -695,13 +695,15 @@ void unlock_new_inode(struct inode *inod
 	}
 #endif
 	/*
-	 * This is special!  We do not need the spinlock
-	 * when clearing I_LOCK, because we're guaranteed
-	 * that nobody else tries to do anything about the
-	 * state of the inode when it is locked, as we
-	 * just created it (so there can be no old holders
-	 * that haven't tested I_LOCK).
+	 * This is special!  We do not need the spinlock when clearing I_LOCK,
+	 * because we're guaranteed that nobody else tries to do anything about
+	 * the state of the inode when it is locked, as we just created it (so
+	 * there can be no old holders that haven't tested I_LOCK).
+	 * However we must emit the memory barrier so that other CPUs reliably
+	 * see the clearing of I_LOCK after the other inode initialisation has
+	 * completed.
 	 */
+	smp_mb();
 	WARN_ON((inode->i_state & (I_LOCK|I_NEW)) != (I_LOCK|I_NEW));
 	inode->i_state &= ~(I_LOCK|I_NEW);
 	wake_up_inode(inode);
_

Patches currently in -mm which might be from jack@suse.cz are

origin.patch
linux-next.patch
vfs-split-generic_forget_inode-so-that-hugetlbfs-does-not-have-to-copy-it.patch
fs-new-truncate-helpers.patch
fs-use-new-truncate-helpers.patch
fs-introduce-new-truncate-sequence.patch
fs-convert-simple-fs-to-new-truncate.patch
tmpfs-convert-to-use-the-new-truncate-convention.patch
ext2-convert-to-use-the-new-truncate-convention.patch
ext2-convert-to-use-the-new-truncate-convention-fix.patch
fat-convert-to-use-the-new-truncate-convention.patch
btrfs-convert-to-use-the-new-truncate-convention.patch
jfs-convert-to-use-the-new-truncate-convention.patch
udf-convert-to-use-the-new-truncate-convention.patch
minix-convert-to-use-the-new-truncate-convention.patch
reiserfs-truncate-blocks-not-used-by-a-write-v2.patch
reiser4-update-names-of-quota-methods.patch

