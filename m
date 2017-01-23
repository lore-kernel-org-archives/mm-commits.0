From: akpm@linux-foundation.org
Subject: + nilfs2-use-i_blocksize.patch added to -mm tree
Date: Mon, 23 Jan 2017 14:55:24 -0800
Message-ID: <588689dc.MgM9CafDq09L5cS7%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44730 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751746AbdAWWzZ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 23 Jan 2017 17:55:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: geliangtang@gmail.com, konishi.ryusuke@lab.ntt.co.jp, mm-commits@vger.kernel.org


The patch titled
     Subject: nilfs2: use i_blocksize()
has been added to the -mm tree.  Its filename is
     nilfs2-use-i_blocksize.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/nilfs2-use-i_blocksize.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/nilfs2-use-i_blocksize.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Geliang Tang <geliangtang@gmail.com>
Subject: nilfs2: use i_blocksize()

Since i_blocksize() helper has been defined in fs.h, use it instead
of open-coding.

Link: http://lkml.kernel.org/r/1485184655-3895-3-git-send-email-konishi.ryusuke@lab.ntt.co.jp
Signed-off-by: Geliang Tang <geliangtang@gmail.com>
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/alloc.c |    2 +-
 fs/nilfs2/btree.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -puN fs/nilfs2/alloc.c~nilfs2-use-i_blocksize fs/nilfs2/alloc.c
--- a/fs/nilfs2/alloc.c~nilfs2-use-i_blocksize
+++ a/fs/nilfs2/alloc.c
@@ -34,7 +34,7 @@
 static inline unsigned long
 nilfs_palloc_groups_per_desc_block(const struct inode *inode)
 {
-	return (1UL << inode->i_blkbits) /
+	return i_blocksize(inode) /
 		sizeof(struct nilfs_palloc_group_desc);
 }
 
diff -puN fs/nilfs2/btree.c~nilfs2-use-i_blocksize fs/nilfs2/btree.c
--- a/fs/nilfs2/btree.c~nilfs2-use-i_blocksize
+++ a/fs/nilfs2/btree.c
@@ -119,7 +119,7 @@ nilfs_btree_node_set_nchildren(struct ni
 
 static int nilfs_btree_node_size(const struct nilfs_bmap *btree)
 {
-	return 1 << btree->b_inode->i_blkbits;
+	return i_blocksize(btree->b_inode);
 }
 
 static int nilfs_btree_nchildren_per_block(const struct nilfs_bmap *btree)
_

Patches currently in -mm which might be from geliangtang@gmail.com are

mm-vmallocc-use-rb_entry_safe.patch
writeback-use-rb_entry.patch
proc-use-rb_entry.patch
nilfs2-use-nilfs_btree_node_size.patch
nilfs2-use-i_blocksize.patch
fs-add-i_blocksize-fix.patch

