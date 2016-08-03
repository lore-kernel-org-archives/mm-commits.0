From: akpm@linux-foundation.org
Subject: [merged]
 nilfs2-emit-error-message-when-i-o-error-is-detected.patch removed from -mm tree
Date: Wed, 03 Aug 2016 11:13:08 -0700
Message-ID: <57a23434.vpHSdxosrHmhUTSN%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33339 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757858AbcHCSNr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Aug 2016 14:13:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: konishi.ryusuke@lab.ntt.co.jp, mm-commits@vger.kernel.org


The patch titled
     Subject: nilfs2: emit error message when I/O error is detected
has been removed from the -mm tree.  Its filename was
     nilfs2-emit-error-message-when-i-o-error-is-detected.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Subject: nilfs2: emit error message when I/O error is detected

When nilfs returned -EIO as an error code, it's not always clear if it
came from the underlying block device or not.  This will mend the issue by
having low level I/O routines of nilfs output an error message when they
detected an I/O error.

Link: http://lkml.kernel.org/r/1464875891-5443-7-git-send-email-konishi.ryusuke@lab.ntt.co.jp
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/btree.c   |    3 +++
 fs/nilfs2/gcinode.c |    9 ++++++++-
 fs/nilfs2/mdt.c     |    6 +++++-
 3 files changed, 16 insertions(+), 2 deletions(-)

diff -puN fs/nilfs2/btree.c~nilfs2-emit-error-message-when-i-o-error-is-detected fs/nilfs2/btree.c
--- a/fs/nilfs2/btree.c~nilfs2-emit-error-message-when-i-o-error-is-detected
+++ a/fs/nilfs2/btree.c
@@ -517,6 +517,9 @@ static int __nilfs_btree_get_block(const
 
  out_no_wait:
 	if (!buffer_uptodate(bh)) {
+		nilfs_msg(btree->b_inode->i_sb, KERN_ERR,
+			  "I/O error reading b-tree node block (ino=%lu, blocknr=%llu)",
+			  btree->b_inode->i_ino, (unsigned long long)ptr);
 		brelse(bh);
 		return -EIO;
 	}
diff -puN fs/nilfs2/gcinode.c~nilfs2-emit-error-message-when-i-o-error-is-detected fs/nilfs2/gcinode.c
--- a/fs/nilfs2/gcinode.c~nilfs2-emit-error-message-when-i-o-error-is-detected
+++ a/fs/nilfs2/gcinode.c
@@ -148,8 +148,15 @@ int nilfs_gccache_submit_read_node(struc
 int nilfs_gccache_wait_and_mark_dirty(struct buffer_head *bh)
 {
 	wait_on_buffer(bh);
-	if (!buffer_uptodate(bh))
+	if (!buffer_uptodate(bh)) {
+		struct inode *inode = bh->b_page->mapping->host;
+
+		nilfs_msg(inode->i_sb, KERN_ERR,
+			  "I/O error reading %s block for GC (ino=%lu, vblocknr=%llu)",
+			  buffer_nilfs_node(bh) ? "node" : "data",
+			  inode->i_ino, (unsigned long long)bh->b_blocknr);
 		return -EIO;
+	}
 	if (buffer_dirty(bh))
 		return -EEXIST;
 
diff -puN fs/nilfs2/mdt.c~nilfs2-emit-error-message-when-i-o-error-is-detected fs/nilfs2/mdt.c
--- a/fs/nilfs2/mdt.c~nilfs2-emit-error-message-when-i-o-error-is-detected
+++ a/fs/nilfs2/mdt.c
@@ -207,8 +207,12 @@ static int nilfs_mdt_read_block(struct i
 
  out_no_wait:
 	err = -EIO;
-	if (!buffer_uptodate(first_bh))
+	if (!buffer_uptodate(first_bh)) {
+		nilfs_msg(inode->i_sb, KERN_ERR,
+			  "I/O error reading meta-data file (ino=%lu, block-offset=%lu)",
+			  inode->i_ino, block);
 		goto failed_bh;
+	}
  out:
 	*out_bh = first_bh;
 	return 0;
_

Patches currently in -mm which might be from konishi.ryusuke@lab.ntt.co.jp are


