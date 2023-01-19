Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4D7BC677F1
	for <mm-commits@archiver.kernel.org>; Thu, 19 Jan 2023 01:15:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229999AbjASBPb (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 18 Jan 2023 20:15:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230010AbjASBO1 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 18 Jan 2023 20:14:27 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28FD169218
        for <mm-commits@vger.kernel.org>; Wed, 18 Jan 2023 17:14:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C259DB81FB9
        for <mm-commits@vger.kernel.org>; Thu, 19 Jan 2023 01:14:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F3ADC433F0;
        Thu, 19 Jan 2023 01:14:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1674090841;
        bh=cRNUd5N45qKvINRhYzB9R3IR69g7dhWx9mf1C2kJgKs=;
        h=Date:To:From:Subject:From;
        b=gXOKRGl32Sze2Fl4D9T45n/4wYFMMINEZY2bZpCH346bj9hL8QJ1mQQitSTH0WSaa
         GHHEjV0xO5H5ELCc4CbrnqRHMiOFdOxo9I9MztEwlNwFIqKvpvAjlbLGHDh9bqxO+f
         K7n1m1IleS+LJELvRHgcKkAlKv7sQ2PsZ9zwOitI=
Date:   Wed, 18 Jan 2023 17:14:01 -0800
To:     mm-commits@vger.kernel.org, jack@suse.cz, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] buffer-replace-obvious-uses-of-b_page-with-b_folio.patch removed from -mm tree
Message-Id: <20230119011401.6F3ADC433F0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: buffer: replace obvious uses of b_page with b_folio
has been removed from the -mm tree.  Its filename was
     buffer-replace-obvious-uses-of-b_page-with-b_folio.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: buffer: replace obvious uses of b_page with b_folio
Date: Thu, 15 Dec 2022 21:43:52 +0000

These cases just check if it's NULL, or use b_page to get to the page's
address space.  They are assumptions that b_page never points to a tail
page.

Link: https://lkml.kernel.org/r/20221215214402.3522366-3-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/buffer.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/fs/buffer.c~buffer-replace-obvious-uses-of-b_page-with-b_folio
+++ a/fs/buffer.c
@@ -321,7 +321,7 @@ static void end_buffer_async_read_io(str
 {
 	/* Decrypt if needed */
 	if (uptodate &&
-	    fscrypt_inode_uses_fs_layer_crypto(bh->b_page->mapping->host)) {
+	    fscrypt_inode_uses_fs_layer_crypto(bh->b_folio->mapping->host)) {
 		struct decrypt_bh_ctx *ctx = kmalloc(sizeof(*ctx), GFP_ATOMIC);
 
 		if (ctx) {
@@ -570,7 +570,7 @@ void write_boundary_block(struct block_d
 void mark_buffer_dirty_inode(struct buffer_head *bh, struct inode *inode)
 {
 	struct address_space *mapping = inode->i_mapping;
-	struct address_space *buffer_mapping = bh->b_page->mapping;
+	struct address_space *buffer_mapping = bh->b_folio->mapping;
 
 	mark_buffer_dirty(bh);
 	if (!mapping->private_data) {
@@ -1073,7 +1073,7 @@ __getblk_slow(struct block_device *bdev,
  * and then attach the address_space's inode to its superblock's dirty
  * inode list.
  *
- * mark_buffer_dirty() is atomic.  It takes bh->b_page->mapping->private_lock,
+ * mark_buffer_dirty() is atomic.  It takes bh->b_folio->mapping->private_lock,
  * i_pages lock and mapping->host->i_lock.
  */
 void mark_buffer_dirty(struct buffer_head *bh)
@@ -1117,8 +1117,8 @@ void mark_buffer_write_io_error(struct b
 
 	set_buffer_write_io_error(bh);
 	/* FIXME: do we need to set this in both places? */
-	if (bh->b_page && bh->b_page->mapping)
-		mapping_set_error(bh->b_page->mapping, -EIO);
+	if (bh->b_folio && bh->b_folio->mapping)
+		mapping_set_error(bh->b_folio->mapping, -EIO);
 	if (bh->b_assoc_map)
 		mapping_set_error(bh->b_assoc_map, -EIO);
 	rcu_read_lock();
@@ -1154,7 +1154,7 @@ void __bforget(struct buffer_head *bh)
 {
 	clear_buffer_dirty(bh);
 	if (bh->b_assoc_map) {
-		struct address_space *buffer_mapping = bh->b_page->mapping;
+		struct address_space *buffer_mapping = bh->b_folio->mapping;
 
 		spin_lock(&buffer_mapping->private_lock);
 		list_del_init(&bh->b_assoc_buffers);
_

Patches currently in -mm which might be from willy@infradead.org are

mm-remove-folio_pincount_ptr-and-head_compound_pincount.patch
mm-convert-head_subpages_mapcount-into-folio_nr_pages_mapped.patch
doc-clarify-refcount-section-by-referring-to-folios-pages.patch
mm-convert-total_compound_mapcount-to-folio_total_mapcount.patch
mm-convert-page_remove_rmap-to-use-a-folio-internally.patch
mm-convert-page_add_anon_rmap-to-use-a-folio-internally.patch
mm-convert-page_add_file_rmap-to-use-a-folio-internally.patch
mm-add-folio_add_new_anon_rmap.patch
mm-add-folio_add_new_anon_rmap-fix-2.patch
page_alloc-use-folio-fields-directly.patch
mm-use-a-folio-in-hugepage_add_anon_rmap-and-hugepage_add_new_anon_rmap.patch
mm-use-entire_mapcount-in-__page_dup_rmap.patch
mm-debug-remove-call-to-head_compound_mapcount.patch
hugetlb-remove-uses-of-folio_mapcount_ptr.patch
mm-convert-page_mapcount-to-use-folio_entire_mapcount.patch
mm-remove-head_compound_mapcount-and-_ptr-functions.patch
mm-reimplement-compound_order.patch
mm-reimplement-compound_nr.patch
mm-reimplement-compound_nr-fix.patch
mm-convert-set_compound_page_dtor-and-set_compound_order-to-folios.patch
mm-convert-is_transparent_hugepage-to-use-a-folio.patch
mm-convert-destroy_large_folio-to-use-folio_dtor.patch
hugetlb-remove-uses-of-compound_dtor-and-compound_nr.patch
mm-remove-first-tail-page-members-from-struct-page.patch
doc-correct-struct-folio-kernel-doc.patch
mm-move-page-deferred_list-to-folio-_deferred_list.patch
mm-huge_memory-remove-page_deferred_list.patch
mm-huge_memory-convert-get_deferred_split_queue-to-take-a-folio.patch
mm-convert-deferred_split_huge_page-to-deferred_split_folio.patch
shmem-convert-shmem_write_end-to-use-a-folio.patch
mm-add-vma_alloc_zeroed_movable_folio.patch
mm-convert-do_anonymous_page-to-use-a-folio.patch
mm-convert-wp_page_copy-to-use-folios.patch
mm-use-a-folio-in-copy_pte_range.patch
mm-use-a-folio-in-copy_present_pte.patch
mm-fs-convert-inode_attach_wb-to-take-a-folio.patch
mm-convert-mem_cgroup_css_from_page-to-mem_cgroup_css_from_folio.patch
mm-remove-page_evictable.patch
mm-remove-mlock_vma_page.patch
mm-remove-munlock_vma_page.patch
mm-clean-up-mlock_page-munlock_page-references-in-comments.patch
rmap-add-folio-parameter-to-__page_set_anon_rmap.patch
filemap-convert-filemap_map_pmd-to-take-a-folio.patch
filemap-convert-filemap_range_has_page-to-use-a-folio.patch
readahead-convert-readahead_expand-to-use-a-folio.patch

