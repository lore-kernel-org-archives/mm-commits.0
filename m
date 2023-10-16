Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 631B8CDB465
	for <mm-commits@archiver.kernel.org>; Mon, 16 Oct 2023 22:11:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233661AbjJPWK7 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 16 Oct 2023 18:10:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233494AbjJPWK5 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 16 Oct 2023 18:10:57 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6EE19B
        for <mm-commits@vger.kernel.org>; Mon, 16 Oct 2023 15:10:55 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64A05C433C9;
        Mon, 16 Oct 2023 22:10:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1697494255;
        bh=FvaCwkSEeq8NtFcfyJdqKS22X0ypQOBfq94COOdTj0Y=;
        h=Date:To:From:Subject:From;
        b=phm8m9FGoYrhhsOUjB4WuiisK9yPQbovtUX9ACsrM66DaEVbIufkRtKhAlUv2BKJm
         l66pCwX6n5dn9NiUQ0+PtzKNhJMOxDaBYSUuVYXKjd8GluBLIEeWf/F3Ql3/yWALJu
         7XbEqMLGd8yxrVv5OV9v5TxA6mYo82KT48I6hO64=
Date:   Mon, 16 Oct 2023 15:10:54 -0700
To:     mm-commits@vger.kernel.org, p.raghav@samsung.com,
        konishi.ryusuke@gmail.com, agruenba@redhat.com,
        willy@infradead.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + gfs2-convert-inode-unstuffing-to-use-a-folio.patch added to mm-unstable branch
Message-Id: <20231016221055.64A05C433C9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: gfs2: convert inode unstuffing to use a folio
has been added to the -mm mm-unstable branch.  Its filename is
     gfs2-convert-inode-unstuffing-to-use-a-folio.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/gfs2-convert-inode-unstuffing-to-use-a-folio.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: gfs2: convert inode unstuffing to use a folio
Date: Mon, 16 Oct 2023 21:10:53 +0100

Use the folio APIs, removing numerous hidden calls to compound_head(). 
Also remove the stale comment about the page being looked up if it's NULL.

Link: https://lkml.kernel.org/r/20231016201114.1928083-7-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Andreas Gruenbacher <agruenba@redhat.com>
Cc: Pankaj Raghav <p.raghav@samsung.com>
Cc: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/gfs2/bmap.c |   48 ++++++++++++++++++++++-------------------------
 1 file changed, 23 insertions(+), 25 deletions(-)

--- a/fs/gfs2/bmap.c~gfs2-convert-inode-unstuffing-to-use-a-folio
+++ a/fs/gfs2/bmap.c
@@ -43,53 +43,51 @@ struct metapath {
 static int punch_hole(struct gfs2_inode *ip, u64 offset, u64 length);
 
 /**
- * gfs2_unstuffer_page - unstuff a stuffed inode into a block cached by a page
+ * gfs2_unstuffer_folio - unstuff a stuffed inode into a block cached by a folio
  * @ip: the inode
  * @dibh: the dinode buffer
  * @block: the block number that was allocated
- * @page: The (optional) page. This is looked up if @page is NULL
+ * @folio: The folio.
  *
  * Returns: errno
  */
-
-static int gfs2_unstuffer_page(struct gfs2_inode *ip, struct buffer_head *dibh,
-			       u64 block, struct page *page)
+static int gfs2_unstuffer_folio(struct gfs2_inode *ip, struct buffer_head *dibh,
+			       u64 block, struct folio *folio)
 {
 	struct inode *inode = &ip->i_inode;
 
-	if (!PageUptodate(page)) {
-		void *kaddr = kmap(page);
+	if (!folio_test_uptodate(folio)) {
+		void *kaddr = kmap_local_folio(folio, 0);
 		u64 dsize = i_size_read(inode);
  
 		memcpy(kaddr, dibh->b_data + sizeof(struct gfs2_dinode), dsize);
-		memset(kaddr + dsize, 0, PAGE_SIZE - dsize);
-		kunmap(page);
+		memset(kaddr + dsize, 0, folio_size(folio) - dsize);
+		kunmap_local(kaddr);
 
-		SetPageUptodate(page);
+		folio_mark_uptodate(folio);
 	}
 
 	if (gfs2_is_jdata(ip)) {
-		struct buffer_head *bh;
+		struct buffer_head *bh = folio_buffers(folio);
 
-		if (!page_has_buffers(page))
-			create_empty_buffers(page, BIT(inode->i_blkbits),
-					     BIT(BH_Uptodate));
+		if (!bh)
+			bh = folio_create_empty_buffers(folio,
+				BIT(inode->i_blkbits), BIT(BH_Uptodate));
 
-		bh = page_buffers(page);
 		if (!buffer_mapped(bh))
 			map_bh(bh, inode->i_sb, block);
 
 		set_buffer_uptodate(bh);
 		gfs2_trans_add_data(ip->i_gl, bh);
 	} else {
-		set_page_dirty(page);
+		folio_mark_dirty(folio);
 		gfs2_ordered_add_inode(ip);
 	}
 
 	return 0;
 }
 
-static int __gfs2_unstuff_inode(struct gfs2_inode *ip, struct page *page)
+static int __gfs2_unstuff_inode(struct gfs2_inode *ip, struct folio *folio)
 {
 	struct buffer_head *bh, *dibh;
 	struct gfs2_dinode *di;
@@ -118,7 +116,7 @@ static int __gfs2_unstuff_inode(struct g
 					      dibh, sizeof(struct gfs2_dinode));
 			brelse(bh);
 		} else {
-			error = gfs2_unstuffer_page(ip, dibh, block, page);
+			error = gfs2_unstuffer_folio(ip, dibh, block, folio);
 			if (error)
 				goto out_brelse;
 		}
@@ -157,17 +155,17 @@ out_brelse:
 int gfs2_unstuff_dinode(struct gfs2_inode *ip)
 {
 	struct inode *inode = &ip->i_inode;
-	struct page *page;
+	struct folio *folio;
 	int error;
 
 	down_write(&ip->i_rw_mutex);
-	page = grab_cache_page(inode->i_mapping, 0);
-	error = -ENOMEM;
-	if (!page)
+	folio = filemap_grab_folio(inode->i_mapping, 0);
+	error = PTR_ERR(folio);
+	if (IS_ERR(folio))
 		goto out;
-	error = __gfs2_unstuff_inode(ip, page);
-	unlock_page(page);
-	put_page(page);
+	error = __gfs2_unstuff_inode(ip, folio);
+	folio_unlock(folio);
+	folio_put(folio);
 out:
 	up_write(&ip->i_rw_mutex);
 	return error;
_

Patches currently in -mm which might be from willy@infradead.org are

mm-make-lock_folio_maybe_drop_mmap-vma-lock-aware.patch
mm-call-wp_page_copy-under-the-vma-lock.patch
mm-handle-shared-faults-under-the-vma-lock.patch
mm-handle-cow-faults-under-the-vma-lock.patch
mm-handle-read-faults-under-the-vma-lock.patch
mm-handle-write-faults-to-ro-pages-under-the-vma-lock.patch
iomap-hold-state_lock-over-call-to-ifs_set_range_uptodate.patch
iomap-protect-read_bytes_pending-with-the-state_lock.patch
mm-add-folio_end_read.patch
ext4-use-folio_end_read.patch
buffer-use-folio_end_read.patch
iomap-use-folio_end_read.patch
bitops-add-xor_unlock_is_negative_byte.patch
alpha-implement-xor_unlock_is_negative_byte.patch
m68k-implement-xor_unlock_is_negative_byte.patch
mips-implement-xor_unlock_is_negative_byte.patch
powerpc-implement-arch_xor_unlock_is_negative_byte-on-32-bit.patch
riscv-implement-xor_unlock_is_negative_byte.patch
s390-implement-arch_xor_unlock_is_negative_byte.patch
mm-delete-checks-for-xor_unlock_is_negative_byte.patch
mm-add-folio_xor_flags_has_waiters.patch
mm-make-__end_folio_writeback-return-void.patch
mm-use-folio_xor_flags_has_waiters-in-folio_end_writeback.patch
filemap-remove-use-of-wait-bookmarks.patch
sched-remove-wait-bookmarks.patch
buffer-return-bool-from-grow_dev_folio.patch
buffer-make-folio_create_empty_buffers-return-a-buffer_head.patch
mpage-convert-map_buffer_to_folio-to-folio_create_empty_buffers.patch
ext4-convert-to-folio_create_empty_buffers.patch
buffer-add-get_nth_bh.patch
gfs2-convert-inode-unstuffing-to-use-a-folio.patch
gfs2-convert-gfs2_getbuf-to-folios.patch
gfs2-convert-gfs2_getjdatabuf-to-use-a-folio.patch
gfs2-convert-gfs2_write_buf_to_page-to-use-a-folio.patch
nilfs2-convert-nilfs_mdt_freeze_buffer-to-use-a-folio.patch
nilfs2-convert-nilfs_grab_buffer-to-use-a-folio.patch
nilfs2-convert-nilfs_copy_page-to-nilfs_copy_folio.patch
nilfs2-convert-nilfs_mdt_forget_block-to-use-a-folio.patch
nilfs2-convert-nilfs_mdt_get_frozen_buffer-to-use-a-folio.patch
nilfs2-remove-nilfs_page_get_nth_block.patch
nilfs2-convert-nilfs_lookup_dirty_data_buffers-to-use-folio_create_empty_buffers.patch
ntfs-convert-ntfs_read_block-to-use-a-folio.patch
ntfs-convert-ntfs_writepage-to-use-a-folio.patch
ntfs-convert-ntfs_prepare_pages_for_non_resident_write-to-folios.patch
ntfs3-convert-ntfs_zero_range-to-use-a-folio.patch
ocfs2-convert-ocfs2_map_page_blocks-to-use-a-folio.patch
reiserfs-convert-writepage-to-use-a-folio.patch
ufs-add-ufs_get_locked_folio-and-ufs_put_locked_folio.patch
ufs-use-ufs_get_locked_folio-in-ufs_alloc_lastblock.patch
ufs-convert-ufs_change_blocknr-to-use-folios.patch
ufs-remove-ufs_get_locked_page.patch
buffer-remove-folio_create_empty_buffers.patch

