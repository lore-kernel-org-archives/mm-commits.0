From: akpm@linux-foundation.org
Subject: - skip-writing-data-pages-when-inode-is-under-i_sync.patch removed from -mm tree
Date: Tue, 05 Feb 2008 14:32:04 -0800
Message-ID: <200802052231.m15MVjsa012187@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54659 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932219AbYBEWnA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Feb 2008 17:43:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: qiyong@fc-cn.com, a.p.zijlstra@chello.nl, hugh@veritas.com, joern@wohnheim.fh-wedel.de, mrubin@google.com, torvalds@linux-foundation.org, wfg@mail.ustc.edu.cn, mm-commits@vger.kernel.org


The patch titled
     skip writing data pages when inode is under I_SYNC
has been removed from the -mm tree.  Its filename was
     skip-writing-data-pages-when-inode-is-under-i_sync.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: skip writing data pages when inode is under I_SYNC
From: Qi Yong <qiyong@fc-cn.com>

Since I_SYNC was split out from I_LOCK, the concern in commit
4b89eed93e0fa40a63e3d7b1796ec1337ea7a3aa is not longer valid.

We should revert to the original behavior: in __writeback_single_inode(),
when we find an I_SYNC-ed inode and we're not doing a data-integrity sync,
skip writing entirely.  Otherwise, we are double calling do_writepages()

Signed-off-by: Qi Yong <qiyong@fc-cn.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Hugh Dickins <hugh@veritas.com>
Cc: Joern Engel <joern@wohnheim.fh-wedel.de>
Cc: WU Fengguang <wfg@mail.ustc.edu.cn>
Cc: Michael Rubin <mrubin@google.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fs-writeback.c |   13 +------------
 1 file changed, 1 insertion(+), 12 deletions(-)

diff -puN fs/fs-writeback.c~skip-writing-data-pages-when-inode-is-under-i_sync fs/fs-writeback.c
--- a/fs/fs-writeback.c~skip-writing-data-pages-when-inode-is-under-i_sync
+++ a/fs/fs-writeback.c
@@ -334,9 +334,6 @@ __writeback_single_inode(struct inode *i
 		WARN_ON(inode->i_state & I_WILL_FREE);
 
 	if ((wbc->sync_mode != WB_SYNC_ALL) && (inode->i_state & I_SYNC)) {
-		struct address_space *mapping = inode->i_mapping;
-		int ret;
-
 		/*
 		 * We're skipping this inode because it's locked, and we're not
 		 * doing writeback-for-data-integrity.  Move it to s_more_io so
@@ -345,15 +342,7 @@ __writeback_single_inode(struct inode *i
 		 * completed a full scan of s_io.
 		 */
 		requeue_io(inode);
-
-		/*
-		 * Even if we don't actually write the inode itself here,
-		 * we can at least start some of the data writeout..
-		 */
-		spin_unlock(&inode_lock);
-		ret = do_writepages(mapping, wbc);
-		spin_lock(&inode_lock);
-		return ret;
+		return 0;
 	}
 
 	/*
_

Patches currently in -mm which might be from qiyong@fc-cn.com are

origin.patch
kill-an-unused-ptr_err-in-bdev_cache_init.patch
