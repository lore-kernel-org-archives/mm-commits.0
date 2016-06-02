From: akpm@linux-foundation.org
Subject: + nilfs2-emit-error-message-when-i-o-error-is-detected.patch
 added to -mm tree
Date: Thu, 02 Jun 2016 13:20:00 -0700
Message-ID: <575094f0.L1gX6ffjszYnDm5F%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50866 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932766AbcFBUUB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 2 Jun 2016 16:20:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: konishi.ryusuke@lab.ntt.co.jp, mm-commits@vger.kernel.org


The patch titled
     Subject: nilfs2: emit error message when I/O error is detected
has been added to the -mm tree.  Its filename is
     nilfs2-emit-error-message-when-i-o-error-is-detected.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/nilfs2-emit-error-message-when-i-o-error-is-detected.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/nilfs2-emit-error-message-when-i-o-error-is-detected.patch

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
@@ -515,6 +515,9 @@ static int __nilfs_btree_get_block(const
 
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
@@ -147,8 +147,15 @@ int nilfs_gccache_submit_read_node(struc
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
@@ -206,8 +206,12 @@ static int nilfs_mdt_read_block(struct i
 
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

nilfs2-hide-function-name-argument-from-nilfs_error.patch
nilfs2-add-nilfs_msg-message-interface.patch
nilfs2-embed-a-back-pointer-to-super-block-instance-in-nilfs-object.patch
nilfs2-reduce-bare-use-of-printk-with-nilfs_msg.patch
nilfs2-replace-nilfs_warning-with-nilfs_msg.patch
nilfs2-emit-error-message-when-i-o-error-is-detected.patch
nilfs2-do-not-use-yield.patch
nilfs2-refactor-parser-of-snapshot-mount-option.patch

