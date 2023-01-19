Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28FA6C38159
	for <mm-commits@archiver.kernel.org>; Thu, 19 Jan 2023 01:16:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229968AbjASBQD (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 18 Jan 2023 20:16:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229969AbjASBOn (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 18 Jan 2023 20:14:43 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5179169B24
        for <mm-commits@vger.kernel.org>; Wed, 18 Jan 2023 17:14:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E3C26617E4
        for <mm-commits@vger.kernel.org>; Thu, 19 Jan 2023 01:14:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EA5FC433F1;
        Thu, 19 Jan 2023 01:14:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1674090852;
        bh=CA8jp+3n4Br42SXvBb3V5XiSdPd0B1Fkyy11OmdJwgo=;
        h=Date:To:From:Subject:From;
        b=yuDaivDdyrLDTNXJ3IMV2NKCqag9vXakQuHoKvOADpnMn8VVMNg84y/AbAhIEQLEP
         AMSEneG7YktzgEtK1XwdGEk6q/HxrPuYbiRjvBMJ56mxPm7dWMx2RAc5f+1FX7AfWq
         7tM5XyPhUXH4Joso5GOl4LOYMDL9IeXtbf2YmlfE=
Date:   Wed, 18 Jan 2023 17:14:11 -0800
To:     mm-commits@vger.kernel.org, jack@suse.cz, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] nilfs2-replace-obvious-uses-of-b_page-with-b_folio.patch removed from -mm tree
Message-Id: <20230119011412.4EA5FC433F1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: nilfs2: replace obvious uses of b_page with b_folio
has been removed from the -mm tree.  Its filename was
     nilfs2-replace-obvious-uses-of-b_page-with-b_folio.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: nilfs2: replace obvious uses of b_page with b_folio
Date: Thu, 15 Dec 2022 21:44:00 +0000

These places just use b_page to get to the buffer's address_space or the
index of the page the buffer is in.

Link: https://lkml.kernel.org/r/20221215214402.3522366-11-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/btnode.c  |    2 +-
 fs/nilfs2/btree.c   |    2 +-
 fs/nilfs2/gcinode.c |    2 +-
 fs/nilfs2/mdt.c     |    4 ++--
 fs/nilfs2/segment.c |    2 +-
 5 files changed, 6 insertions(+), 6 deletions(-)

--- a/fs/nilfs2/btnode.c~nilfs2-replace-obvious-uses-of-b_page-with-b_folio
+++ a/fs/nilfs2/btnode.c
@@ -188,7 +188,7 @@ int nilfs_btnode_prepare_change_key(stru
 		struct page *opage = obh->b_page;
 		lock_page(opage);
 retry:
-		/* BUG_ON(oldkey != obh->b_page->index); */
+		/* BUG_ON(oldkey != obh->b_folio->index); */
 		if (unlikely(oldkey != opage->index))
 			NILFS_PAGE_BUG(opage,
 				       "invalid oldkey %lld (newkey=%lld)",
--- a/fs/nilfs2/btree.c~nilfs2-replace-obvious-uses-of-b_page-with-b_folio
+++ a/fs/nilfs2/btree.c
@@ -398,7 +398,7 @@ int nilfs_btree_broken_node_block(struct
 	if (buffer_nilfs_checked(bh))
 		return 0;
 
-	inode = bh->b_page->mapping->host;
+	inode = bh->b_folio->mapping->host;
 	ret = nilfs_btree_node_broken((struct nilfs_btree_node *)bh->b_data,
 				      bh->b_size, inode, bh->b_blocknr);
 	if (likely(!ret))
--- a/fs/nilfs2/gcinode.c~nilfs2-replace-obvious-uses-of-b_page-with-b_folio
+++ a/fs/nilfs2/gcinode.c
@@ -140,7 +140,7 @@ int nilfs_gccache_wait_and_mark_dirty(st
 {
 	wait_on_buffer(bh);
 	if (!buffer_uptodate(bh)) {
-		struct inode *inode = bh->b_page->mapping->host;
+		struct inode *inode = bh->b_folio->mapping->host;
 
 		nilfs_err(inode->i_sb,
 			  "I/O error reading %s block for GC (ino=%lu, vblocknr=%llu)",
--- a/fs/nilfs2/mdt.c~nilfs2-replace-obvious-uses-of-b_page-with-b_folio
+++ a/fs/nilfs2/mdt.c
@@ -563,7 +563,7 @@ int nilfs_mdt_freeze_buffer(struct inode
 	struct page *page;
 	int blkbits = inode->i_blkbits;
 
-	page = grab_cache_page(shadow->inode->i_mapping, bh->b_page->index);
+	page = grab_cache_page(shadow->inode->i_mapping, bh->b_folio->index);
 	if (!page)
 		return -ENOMEM;
 
@@ -595,7 +595,7 @@ nilfs_mdt_get_frozen_buffer(struct inode
 	struct page *page;
 	int n;
 
-	page = find_lock_page(shadow->inode->i_mapping, bh->b_page->index);
+	page = find_lock_page(shadow->inode->i_mapping, bh->b_folio->index);
 	if (page) {
 		if (page_has_buffers(page)) {
 			n = bh_offset(bh) >> inode->i_blkbits;
--- a/fs/nilfs2/segment.c~nilfs2-replace-obvious-uses-of-b_page-with-b_folio
+++ a/fs/nilfs2/segment.c
@@ -1581,7 +1581,7 @@ nilfs_segctor_update_payload_blocknr(str
 			nblocks = le32_to_cpu(finfo->fi_nblocks);
 			ndatablk = le32_to_cpu(finfo->fi_ndatablk);
 
-			inode = bh->b_page->mapping->host;
+			inode = bh->b_folio->mapping->host;
 
 			if (mode == SC_LSEG_DSYNC)
 				sc_op = &nilfs_sc_dsync_ops;
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

