From: akpm@linux-foundation.org
Subject: [merged] nilfs2-remove-references-to-long-gone-super-operations.patch removed from -mm tree
Date: Tue, 31 Jul 2012 11:53:04 -0700
Message-ID: <20120731185304.B65EC1E0080@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ob0-f202.google.com ([209.85.214.202]:42024 "EHLO
	mail-ob0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756349Ab2GaSxI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 31 Jul 2012 14:53:08 -0400
Received: by mail-ob0-f202.google.com with SMTP id wc20so4679387obb.1
        for <mm-commits@vger.kernel.org>; Tue, 31 Jul 2012 11:53:08 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fernando@oss.ntt.co.jp, konishi.ryusuke@lab.ntt.co.jp, mm-commits@vger.kernel.org


The patch titled
     Subject: nilfs2: remove references to long gone super operations
has been removed from the -mm tree.  Its filename was
     nilfs2-remove-references-to-long-gone-super-operations.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Fernando Luis Vazquez Cao <fernando@oss.ntt.co.jp>
Subject: nilfs2: remove references to long gone super operations

->delete_inode(), ->write_super_lockfs(), ->unlockfs() are gone so remove
references to them in the NTFS code.  Noticed while cleaning up the
fsfreeze mess.

Signed-off-by: Fernando Luis Vazquez Cao <fernando@oss.ntt.co.jp>
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/super.c |    3 ---
 1 file changed, 3 deletions(-)

diff -puN fs/nilfs2/super.c~nilfs2-remove-references-to-long-gone-super-operations fs/nilfs2/super.c
--- a/fs/nilfs2/super.c~nilfs2-remove-references-to-long-gone-super-operations
+++ a/fs/nilfs2/super.c
@@ -677,7 +677,6 @@ static const struct super_operations nil
 	.destroy_inode  = nilfs_destroy_inode,
 	.dirty_inode    = nilfs_dirty_inode,
 	/* .write_inode    = nilfs_write_inode, */
-	/* .put_inode      = nilfs_put_inode, */
 	/* .drop_inode	  = nilfs_drop_inode, */
 	.evict_inode    = nilfs_evict_inode,
 	.put_super      = nilfs_put_super,
@@ -685,8 +684,6 @@ static const struct super_operations nil
 	.sync_fs        = nilfs_sync_fs,
 	.freeze_fs	= nilfs_freeze,
 	.unfreeze_fs	= nilfs_unfreeze,
-	/* .write_super_lockfs */
-	/* .unlockfs */
 	.statfs         = nilfs_statfs,
 	.remount_fs     = nilfs_remount,
 	/* .umount_begin */
_

Patches currently in -mm which might be from fernando@oss.ntt.co.jp are

origin.patch

