From: akpm@linux-foundation.org
Subject: +
 nilfs2-fix-race-condition-that-causes-file-system-corruption.patch added to -mm tree
Date: Wed, 01 Nov 2017 14:16:13 -0700
Message-ID: <59fa399d.xfLyU2vtl2jaqece%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40982 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933194AbdKAVQO (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 1 Nov 2017 17:16:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andreas.rohner@gmx.net, konishi.ryusuke@lab.ntt.co.jp, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: nilfs2: fix race condition that causes file system corruption
has been added to the -mm tree.  Its filename is
     nilfs2-fix-race-condition-that-causes-file-system-corruption.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/nilfs2-fix-race-condition-that-causes-file-system-corruption.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/nilfs2-fix-race-condition-that-causes-file-system-corruption.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andreas Rohner <andreas.rohner@gmx.net>
Subject: nilfs2: fix race condition that causes file system corruption

There is a race condition between nilfs_dirty_inode() and
nilfs_set_file_dirty().

When a file is opened, nilfs_dirty_inode() is called to update the access
timestamp in the inode.  It calls __nilfs_mark_inode_dirty() in a separate
transaction.  __nilfs_mark_inode_dirty() caches the ifile buffer_head in
the i_bh field of the inode info structure and marks it as dirty.

After some data was written to the file in another transaction, the
function nilfs_set_file_dirty() is called, which adds the inode to the
ns_dirty_files list.

Then the segment construction calls nilfs_segctor_collect_dirty_files(),
which goes through the ns_dirty_files list and checks the i_bh field.  If
there is a cached buffer_head in i_bh it is not marked as dirty again.

Since nilfs_dirty_inode() and nilfs_set_file_dirty() use separate
transactions, it is possible that a segment construction that writes out
the ifile occurs in-between the two.  If this happens the inode is not on
the ns_dirty_files list, but its ifile block is still marked as dirty and
written out.

In the next segment construction, the data for the file is written out and
nilfs_bmap_propagate() updates the b-tree.  Eventually the bmap root is
written into the i_bh block, which is not dirty, because it was written
out in another segment construction.

As a result the bmap update can be lost, which leads to file system
corruption.  Either the virtual block address points to an unallocated DAT
block, or the DAT entry will be reused for something different.

The error can remain undetected for a long time.  A typical error message
would be one of the "bad btree" errors or a warning that a DAT entry could
not be found.

This bug can be reproduced reliably by a simple benchmark that creates and
overwrites millions of 4k files.

Link: http://lkml.kernel.org/r/1509367935-3086-2-git-send-email-konishi.ryusuke@lab.ntt.co.jp
Signed-off-by: Andreas Rohner <andreas.rohner@gmx.net>
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Tested-by: Andreas Rohner <andreas.rohner@gmx.net>
Tested-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/segment.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN fs/nilfs2/segment.c~nilfs2-fix-race-condition-that-causes-file-system-corruption fs/nilfs2/segment.c
--- a/fs/nilfs2/segment.c~nilfs2-fix-race-condition-that-causes-file-system-corruption
+++ a/fs/nilfs2/segment.c
@@ -1954,8 +1954,6 @@ static int nilfs_segctor_collect_dirty_f
 					  err, ii->vfs_inode.i_ino);
 				return err;
 			}
-			mark_buffer_dirty(ibh);
-			nilfs_mdt_mark_dirty(ifile);
 			spin_lock(&nilfs->ns_inode_lock);
 			if (likely(!ii->i_bh))
 				ii->i_bh = ibh;
@@ -1964,6 +1962,10 @@ static int nilfs_segctor_collect_dirty_f
 			goto retry;
 		}
 
+		// Always redirty the buffer to avoid race condition
+		mark_buffer_dirty(ii->i_bh);
+		nilfs_mdt_mark_dirty(ifile);
+
 		clear_bit(NILFS_I_QUEUED, &ii->i_state);
 		set_bit(NILFS_I_BUSY, &ii->i_state);
 		list_move_tail(&ii->i_dirty, &sci->sc_dirty_files);
_

Patches currently in -mm which might be from andreas.rohner@gmx.net are

nilfs2-fix-race-condition-that-causes-file-system-corruption.patch

