From: akpm@linux-foundation.org
Subject: + nilfs2-ensure-proper-cache-clearing-for-gc-inodes.patch added to -mm tree
Date: Mon, 11 Jun 2012 14:03:14 -0700
Message-ID: <20120611210314.AC098A026A@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f202.google.com ([209.85.161.202]:62314 "EHLO
	mail-gg0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751009Ab2FKVDP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 11 Jun 2012 17:03:15 -0400
Received: by ggeh3 with SMTP id h3so411856gge.1
        for <mm-commits@vger.kernel.org>; Mon, 11 Jun 2012 14:03:15 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: konishi.ryusuke@lab.ntt.co.jp, stable@vger.kernel.org


The patch titled
     Subject: nilfs2: ensure proper cache clearing for gc-inodes
has been added to the -mm tree.  Its filename is
     nilfs2-ensure-proper-cache-clearing-for-gc-inodes.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Subject: Subject: nilfs2: ensure proper cache clearing for gc-inodes

Patches currently in -mm which might be from konishi.ryusuke@lab.ntt.co.jp are

nilfs2-ensure-proper-cache-clearing-for-gc-inodes.patch

