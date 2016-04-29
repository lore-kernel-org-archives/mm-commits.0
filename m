From: akpm@linux-foundation.org
Subject: + nilfs2-get-rid-of-nilfs_mdt_mark_block_dirty.patch added to -mm tree
Date: Fri, 29 Apr 2016 13:40:27 -0700
Message-ID: <5723c6bb.cc6WjgHyhE1pnrC2%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43857 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753005AbcD2Uk2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 29 Apr 2016 16:40:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: konishi.ryusuke@lab.ntt.co.jp, mm-commits@vger.kernel.org


The patch titled
     Subject: nilfs2: get rid of nilfs_mdt_mark_block_dirty()
has been added to the -mm tree.  Its filename is
     nilfs2-get-rid-of-nilfs_mdt_mark_block_dirty.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/nilfs2-get-rid-of-nilfs_mdt_mark_block_dirty.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/nilfs2-get-rid-of-nilfs_mdt_mark_block_dirty.patch

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
Subject: nilfs2: get rid of nilfs_mdt_mark_block_dirty()

nilfs_mdt_mark_block_dirty() can be replaced with primary functions
like nilfs_mdt_get_block() and mark_buffer_dirty(), and it's used only
by nilfs_ioctl_mark_blocks_dirty().

This gets rid of the function to simplify the interface of metadata
file.

Link: http://lkml.kernel.org/r/1461935747-10380-8-git-send-email-konishi.ryusuke@lab.ntt.co.jp
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/ioctl.c |   11 ++++++++---
 fs/nilfs2/mdt.c   |   28 ----------------------------
 fs/nilfs2/mdt.h   |    1 -
 3 files changed, 8 insertions(+), 32 deletions(-)

diff -puN fs/nilfs2/ioctl.c~nilfs2-get-rid-of-nilfs_mdt_mark_block_dirty fs/nilfs2/ioctl.c
--- a/fs/nilfs2/ioctl.c~nilfs2-get-rid-of-nilfs_mdt_mark_block_dirty
+++ a/fs/nilfs2/ioctl.c
@@ -779,6 +779,7 @@ static int nilfs_ioctl_mark_blocks_dirty
 	size_t nmembs = argv->v_nmembs;
 	struct nilfs_bmap *bmap = NILFS_I(nilfs->ns_dat)->i_bmap;
 	struct nilfs_bdesc *bdescs = buf;
+	struct buffer_head *bh;
 	int ret, i;
 
 	for (i = 0; i < nmembs; i++) {
@@ -796,12 +797,16 @@ static int nilfs_ioctl_mark_blocks_dirty
 			/* skip dead block */
 			continue;
 		if (bdescs[i].bd_level == 0) {
-			ret = nilfs_mdt_mark_block_dirty(nilfs->ns_dat,
-							 bdescs[i].bd_offset);
-			if (ret < 0) {
+			ret = nilfs_mdt_get_block(nilfs->ns_dat,
+						  bdescs[i].bd_offset,
+						  false, NULL, &bh);
+			if (unlikely(ret)) {
 				WARN_ON(ret == -ENOENT);
 				return ret;
 			}
+			mark_buffer_dirty(bh);
+			nilfs_mdt_mark_dirty(nilfs->ns_dat);
+			put_bh(bh);
 		} else {
 			ret = nilfs_bmap_mark(bmap, bdescs[i].bd_offset,
 					      bdescs[i].bd_level);
diff -puN fs/nilfs2/mdt.c~nilfs2-get-rid-of-nilfs_mdt_mark_block_dirty fs/nilfs2/mdt.c
--- a/fs/nilfs2/mdt.c~nilfs2-get-rid-of-nilfs_mdt_mark_block_dirty
+++ a/fs/nilfs2/mdt.c
@@ -389,34 +389,6 @@ int nilfs_mdt_forget_block(struct inode
 	return ret;
 }
 
-/**
- * nilfs_mdt_mark_block_dirty - mark a block on the meta data file dirty.
- * @inode: inode of the meta data file
- * @block: block offset
- *
- * Return Value: On success, it returns 0. On error, the following negative
- * error code is returned.
- *
- * %-ENOMEM - Insufficient memory available.
- *
- * %-EIO - I/O error
- *
- * %-ENOENT - the specified block does not exist (hole block)
- */
-int nilfs_mdt_mark_block_dirty(struct inode *inode, unsigned long block)
-{
-	struct buffer_head *bh;
-	int err;
-
-	err = nilfs_mdt_read_block(inode, block, 0, &bh);
-	if (unlikely(err))
-		return err;
-	mark_buffer_dirty(bh);
-	nilfs_mdt_mark_dirty(inode);
-	brelse(bh);
-	return 0;
-}
-
 int nilfs_mdt_fetch_dirty(struct inode *inode)
 {
 	struct nilfs_inode_info *ii = NILFS_I(inode);
diff -puN fs/nilfs2/mdt.h~nilfs2-get-rid-of-nilfs_mdt_mark_block_dirty fs/nilfs2/mdt.h
--- a/fs/nilfs2/mdt.h~nilfs2-get-rid-of-nilfs_mdt_mark_block_dirty
+++ a/fs/nilfs2/mdt.h
@@ -79,7 +79,6 @@ int nilfs_mdt_find_block(struct inode *i
 			 struct buffer_head **out_bh);
 int nilfs_mdt_delete_block(struct inode *, unsigned long);
 int nilfs_mdt_forget_block(struct inode *, unsigned long);
-int nilfs_mdt_mark_block_dirty(struct inode *, unsigned long);
 int nilfs_mdt_fetch_dirty(struct inode *);
 
 int nilfs_mdt_init(struct inode *inode, gfp_t gfp_mask, size_t objsz);
_

Patches currently in -mm which might be from konishi.ryusuke@lab.ntt.co.jp are

nilfs2-fix-white-space-issue-in-nilfs_mount.patch
nilfs2-remove-space-before-comma.patch
nilfs2-remove-fsf-mailing-address-from-gpl-notices.patch
nilfs2-clean-up-old-e-mail-addresses.patch
maintainers-add-web-link-for-nilfs-project.patch
nilfs2-clarify-permission-to-replicate-the-design.patch
nilfs2-get-rid-of-nilfs_mdt_mark_block_dirty.patch
nilfs2-move-cleanup-code-of-metadata-file-from-inode-routines.patch
nilfs2-replace-__attribute__packed-with-__packed.patch
nilfs2-add-missing-line-spacing.patch
nilfs2-clean-trailing-semicolons-in-macros.patch

