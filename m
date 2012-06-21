From: akpm@linux-foundation.org
Subject: [merged] nilfs2-ensure-proper-cache-clearing-for-gc-inodes.patch removed from -mm tree
Date: Thu, 21 Jun 2012 12:25:13 -0700
Message-ID: <20120621192513.8B441A00B0@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-we0-f202.google.com ([74.125.82.202]:46556 "EHLO
	mail-we0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759939Ab2FUTZP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 21 Jun 2012 15:25:15 -0400
Received: by weyu7 with SMTP id u7so63402wey.1
        for <mm-commits@vger.kernel.org>; Thu, 21 Jun 2012 12:25:14 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: konishi.ryusuke@lab.ntt.co.jp, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: nilfs2: ensure proper cache clearing for gc-inodes
has been removed from the -mm tree.  Its filename was
     nilfs2-ensure-proper-cache-clearing-for-gc-inodes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Subject: nilfs2: ensure proper cache clearing for gc-inodes

A gc-inode is a pseudo inode used to buffer the blocks to be moved by
garbage collection.

Block caches of gc-inodes must be cleared every time a garbage collection
function (nilfs_clean_segments) completes.  Otherwise, stale blocks
buffered in the caches may be wrongly reused in successive calls of the GC
function.

For user files, this is not a problem because their gc-inodes are
distinguished by a checkpoint number as well as an inode number.  They
never buffer different blocks if either an inode number, a checkpoint
number, or a block offset differs.

However, gc-inodes of sufile, cpfile and DAT file can store different data
for the same block offset.  Thus, the nilfs_clean_segments function can
move incorrect block for these meta-data files if an old block is cached. 
I found this is really causing meta-data corruption in nilfs.

This fixes the issue by ensuring cache clear of gc-inodes and resolves
reported GC problems including checkpoint file corruption, b-tree
corruption, and the following warning during GC.

  nilfs_palloc_freev: entry number 307234 already freed.
  ...

Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Tested-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Cc: <stable@vger.kernel.org>	[2.6.37+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/gcinode.c |    2 ++
 fs/nilfs2/segment.c |    2 ++
 2 files changed, 4 insertions(+)

diff -puN fs/nilfs2/gcinode.c~nilfs2-ensure-proper-cache-clearing-for-gc-inodes fs/nilfs2/gcinode.c
--- a/fs/nilfs2/gcinode.c~nilfs2-ensure-proper-cache-clearing-for-gc-inodes
+++ a/fs/nilfs2/gcinode.c
@@ -191,6 +191,8 @@ void nilfs_remove_all_gcinodes(struct th
 	while (!list_empty(head)) {
 		ii = list_first_entry(head, struct nilfs_inode_info, i_dirty);
 		list_del_init(&ii->i_dirty);
+		truncate_inode_pages(&ii->vfs_inode.i_data, 0);
+		nilfs_btnode_cache_clear(&ii->i_btnode_cache);
 		iput(&ii->vfs_inode);
 	}
 }
diff -puN fs/nilfs2/segment.c~nilfs2-ensure-proper-cache-clearing-for-gc-inodes fs/nilfs2/segment.c
--- a/fs/nilfs2/segment.c~nilfs2-ensure-proper-cache-clearing-for-gc-inodes
+++ a/fs/nilfs2/segment.c
@@ -2309,6 +2309,8 @@ nilfs_remove_written_gcinodes(struct the
 		if (!test_bit(NILFS_I_UPDATED, &ii->i_state))
 			continue;
 		list_del_init(&ii->i_dirty);
+		truncate_inode_pages(&ii->vfs_inode.i_data, 0);
+		nilfs_btnode_cache_clear(&ii->i_btnode_cache);
 		iput(&ii->vfs_inode);
 	}
 }
_

Patches currently in -mm which might be from konishi.ryusuke@lab.ntt.co.jp are

origin.patch

