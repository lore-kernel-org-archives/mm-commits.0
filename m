Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35EB5C677F1
	for <mm-commits@archiver.kernel.org>; Thu, 19 Jan 2023 01:22:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230161AbjASBWK (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 18 Jan 2023 20:22:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230167AbjASBUD (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 18 Jan 2023 20:20:03 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CC836CCF0
        for <mm-commits@vger.kernel.org>; Wed, 18 Jan 2023 17:16:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 194176176F
        for <mm-commits@vger.kernel.org>; Thu, 19 Jan 2023 01:16:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73258C433D2;
        Thu, 19 Jan 2023 01:16:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1674091011;
        bh=HKSCyG/q7E9uJjTC7a+7A2ohbfXhHZAebi5UulW7sDc=;
        h=Date:To:From:Subject:From;
        b=L2GRtR1bxWNa2aYClaQOONmpQEfiSY+wvKJWYasyUdRKfLrwvWCA0iVEDPKpqAbJt
         ysJjTUd3t/KGdSTUFhRgV6yzCQNpMN2qx2ad9palELU/X6CB5NbHCrh+8+dwRWjeA2
         7qBzY4c3Skj0cSRUuvuC9JwqlRyAik03of2obc3M=
Date:   Wed, 18 Jan 2023 17:16:50 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org, tytso@mit.edu,
        vishal.moola@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] ext4-convert-mext_page_double_lock-to-mext_folio_double_lock.patch removed from -mm tree
Message-Id: <20230119011651.73258C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: ext4: convert mext_page_double_lock() to mext_folio_double_lock()
has been removed from the -mm tree.  Its filename was
     ext4-convert-mext_page_double_lock-to-mext_folio_double_lock.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
Subject: ext4: convert mext_page_double_lock() to mext_folio_double_lock()
Date: Wed, 7 Dec 2022 10:10:09 -0800

Convert mext_page_double_lock() to use folios.  This change saves 146
bytes of kernel text.  It also removes 6 calls to compound_head() and 2
calls to folio_file_page().

Link: https://lkml.kernel.org/r/20221207181009.4016-1-vishal.moola@gmail.com
Signed-off-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext4/move_extent.c |   46 ++++++++++++++++++++--------------------
 1 file changed, 23 insertions(+), 23 deletions(-)

--- a/fs/ext4/move_extent.c~ext4-convert-mext_page_double_lock-to-mext_folio_double_lock
+++ a/fs/ext4/move_extent.c
@@ -110,22 +110,23 @@ out:
 }
 
 /**
- * mext_page_double_lock - Grab and lock pages on both @inode1 and @inode2
+ * mext_folio_double_lock - Grab and lock folio on both @inode1 and @inode2
  *
  * @inode1:	the inode structure
  * @inode2:	the inode structure
- * @index1:	page index
- * @index2:	page index
- * @page:	result page vector
+ * @index1:	folio index
+ * @index2:	folio index
+ * @folio:	result folio vector
  *
- * Grab two locked pages for inode's by inode order
+ * Grab two locked folio for inode's by inode order
  */
 static int
-mext_page_double_lock(struct inode *inode1, struct inode *inode2,
-		      pgoff_t index1, pgoff_t index2, struct page *page[2])
+mext_folio_double_lock(struct inode *inode1, struct inode *inode2,
+		      pgoff_t index1, pgoff_t index2, struct folio *folio[2])
 {
 	struct address_space *mapping[2];
 	unsigned int flags;
+	unsigned fgp_flags = FGP_LOCK | FGP_WRITE | FGP_CREAT | FGP_STABLE;
 
 	BUG_ON(!inode1 || !inode2);
 	if (inode1 < inode2) {
@@ -138,28 +139,30 @@ mext_page_double_lock(struct inode *inod
 	}
 
 	flags = memalloc_nofs_save();
-	page[0] = grab_cache_page_write_begin(mapping[0], index1);
-	if (!page[0]) {
+	folio[0] = __filemap_get_folio(mapping[0], index1, fgp_flags,
+			mapping_gfp_mask(mapping[0]));
+	if (!folio[0]) {
 		memalloc_nofs_restore(flags);
 		return -ENOMEM;
 	}
 
-	page[1] = grab_cache_page_write_begin(mapping[1], index2);
+	folio[1] = __filemap_get_folio(mapping[1], index2, fgp_flags,
+			mapping_gfp_mask(mapping[1]));
 	memalloc_nofs_restore(flags);
-	if (!page[1]) {
-		unlock_page(page[0]);
-		put_page(page[0]);
+	if (!folio[1]) {
+		folio_unlock(folio[0]);
+		folio_put(folio[0]);
 		return -ENOMEM;
 	}
 	/*
-	 * grab_cache_page_write_begin() may not wait on page's writeback if
+	 * __filemap_get_folio() may not wait on folio's writeback if
 	 * BDI not demand that. But it is reasonable to be very conservative
-	 * here and explicitly wait on page's writeback
+	 * here and explicitly wait on folio's writeback
 	 */
-	wait_on_page_writeback(page[0]);
-	wait_on_page_writeback(page[1]);
+	folio_wait_writeback(folio[0]);
+	folio_wait_writeback(folio[1]);
 	if (inode1 > inode2)
-		swap(page[0], page[1]);
+		swap(folio[0], folio[1]);
 
 	return 0;
 }
@@ -252,7 +255,6 @@ move_extent_per_page(struct file *o_filp
 		     int block_len_in_page, int unwritten, int *err)
 {
 	struct inode *orig_inode = file_inode(o_filp);
-	struct page *pagep[2] = {NULL, NULL};
 	struct folio *folio[2] = {NULL, NULL};
 	handle_t *handle;
 	ext4_lblk_t orig_blk_offset, donor_blk_offset;
@@ -303,8 +305,8 @@ again:
 
 	replaced_size = data_size;
 
-	*err = mext_page_double_lock(orig_inode, donor_inode, orig_page_offset,
-				     donor_page_offset, pagep);
+	*err = mext_folio_double_lock(orig_inode, donor_inode, orig_page_offset,
+				     donor_page_offset, folio);
 	if (unlikely(*err < 0))
 		goto stop_journal;
 	/*
@@ -314,8 +316,6 @@ again:
 	 * hold page's lock, if it is still the case data copy is not
 	 * necessary, just swap data blocks between orig and donor.
 	 */
-	folio[0] = page_folio(pagep[0]);
-	folio[1] = page_folio(pagep[1]);
 
 	VM_BUG_ON_FOLIO(folio_test_large(folio[0]), folio[0]);
 	VM_BUG_ON_FOLIO(folio_test_large(folio[1]), folio[1]);
_

Patches currently in -mm which might be from vishal.moola@gmail.com are

mm-khugepaged-introduce-release_pte_folio-to-replace-release_pte_page.patch
mm-khugepaged-convert-release_pte_pages-to-use-folios.patch
pagemap-add-filemap_grab_folio.patch
filemap-added-filemap_get_folios_tag.patch
filemap-convert-__filemap_fdatawait_range-to-use-filemap_get_folios_tag.patch
page-writeback-convert-write_cache_pages-to-use-filemap_get_folios_tag.patch
afs-convert-afs_writepages_region-to-use-filemap_get_folios_tag.patch
btrfs-convert-btree_write_cache_pages-to-use-filemap_get_folio_tag.patch
btrfs-convert-extent_write_cache_pages-to-use-filemap_get_folios_tag.patch
ceph-convert-ceph_writepages_start-to-use-filemap_get_folios_tag.patch
cifs-convert-wdata_alloc_and_fillpages-to-use-filemap_get_folios_tag.patch
ext4-convert-mpage_prepare_extent_to_map-to-use-filemap_get_folios_tag.patch
f2fs-convert-f2fs_fsync_node_pages-to-use-filemap_get_folios_tag.patch
f2fs-convert-f2fs_flush_inline_data-to-use-filemap_get_folios_tag.patch
f2fs-convert-f2fs_sync_node_pages-to-use-filemap_get_folios_tag.patch
f2fs-convert-f2fs_write_cache_pages-to-use-filemap_get_folios_tag.patch
f2fs-convert-last_fsync_dnode-to-use-filemap_get_folios_tag.patch
f2fs-convert-f2fs_sync_meta_pages-to-use-filemap_get_folios_tag.patch
gfs2-convert-gfs2_write_cache_jdata-to-use-filemap_get_folios_tag.patch
nilfs2-convert-nilfs_lookup_dirty_data_buffers-to-use-filemap_get_folios_tag.patch
nilfs2-convert-nilfs_lookup_dirty_node_buffers-to-use-filemap_get_folios_tag.patch
nilfs2-convert-nilfs_btree_lookup_dirty_buffers-to-use-filemap_get_folios_tag.patch
nilfs2-convert-nilfs_copy_dirty_pages-to-use-filemap_get_folios_tag.patch
nilfs2-convert-nilfs_clear_dirty_pages-to-use-filemap_get_folios_tag.patch
filemap-remove-find_get_pages_range_tag.patch

