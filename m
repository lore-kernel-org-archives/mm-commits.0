Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 082F05D746
	for <mm-commits@vger.kernel.org>; Mon, 18 Dec 2023 18:44:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="BUsEZaA6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 806CFC433C8;
	Mon, 18 Dec 2023 18:44:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1702925060;
	bh=QiA2OlbICjz9FA1CDZMJq/UnP1eiSPjKzAC4bXEHCi4=;
	h=Date:To:From:Subject:From;
	b=BUsEZaA6WVW1y+5Nb5IFALPyhzXNdB6oxhrm0UTHZVAMw/wzvNmASE4Q5k3HEiRrj
	 qiGFA9kkp87htfhuCan+mJatC+GpVjOcnAtaH9oDKkIMlrzYG8majUD2H1j6XvIRQA
	 6tzhI8NIRv9PIuwXemif/yu+Ua4q+L0zfcUzxjNU=
Date: Mon, 18 Dec 2023 10:44:19 -0800
To: mm-commits@vger.kernel.org,hch@lst.de,axboe@kernel.dk,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + hfsplus-really-remove-hfsplus_writepage.patch added to mm-unstable branch
Message-Id: <20231218184420.806CFC433C8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: hfsplus: really remove hfsplus_writepage
has been added to the -mm mm-unstable branch.  Its filename is
     hfsplus-really-remove-hfsplus_writepage.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/hfsplus-really-remove-hfsplus_writepage.patch

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
Subject: hfsplus: really remove hfsplus_writepage
Date: Fri, 15 Dec 2023 20:02:39 +0000

The earlier commit to remove hfsplus_writepage only removed it from one of
the aops.  Remove it from the btree_aops as well.

Link: https://lkml.kernel.org/r/20231215200245.748418-9-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hfsplus/inode.c |    8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

--- a/fs/hfsplus/inode.c~hfsplus-really-remove-hfsplus_writepage
+++ a/fs/hfsplus/inode.c
@@ -28,11 +28,6 @@ static int hfsplus_read_folio(struct fil
 	return block_read_full_folio(folio, hfsplus_get_block);
 }
 
-static int hfsplus_writepage(struct page *page, struct writeback_control *wbc)
-{
-	return block_write_full_page(page, hfsplus_get_block, wbc);
-}
-
 static void hfsplus_write_failed(struct address_space *mapping, loff_t to)
 {
 	struct inode *inode = mapping->host;
@@ -159,9 +154,10 @@ const struct address_space_operations hf
 	.dirty_folio	= block_dirty_folio,
 	.invalidate_folio = block_invalidate_folio,
 	.read_folio	= hfsplus_read_folio,
-	.writepage	= hfsplus_writepage,
+	.writepages	= hfsplus_writepages,
 	.write_begin	= hfsplus_write_begin,
 	.write_end	= generic_write_end,
+	.migrate_folio	= buffer_migrate_folio,
 	.bmap		= hfsplus_bmap,
 	.release_folio	= hfsplus_release_folio,
 };
_

Patches currently in -mm which might be from willy@infradead.org are

mm-memory-failure-pass-the-folio-and-the-page-to-collect_procs.patch
mm-memory-failure-check-the-mapcount-of-the-precise-page.patch
mm-memory-failure-cast-index-to-loff_t-before-shifting-it.patch
mailmap-add-an-old-address-for-naoya-horiguchi.patch
buffer-return-bool-from-grow_dev_folio.patch
buffer-calculate-block-number-inside-folio_init_buffers.patch
buffer-fix-grow_buffers-for-block-size-page_size.patch
buffer-cast-block-to-loff_t-before-shifting-it.patch
buffer-fix-various-functions-for-block-size-page_size.patch
buffer-handle-large-folios-in-__block_write_begin_int.patch
buffer-fix-more-functions-for-block-size-page_size.patch
mm-convert-ksm_might_need_to_copy-to-work-on-folios.patch
mm-convert-ksm_might_need_to_copy-to-work-on-folios-fix.patch
mm-remove-pageanonexclusive-assertions-in-unuse_pte.patch
mm-convert-unuse_pte-to-use-a-folio-throughout.patch
mm-remove-some-calls-to-page_add_new_anon_rmap.patch
mm-remove-stale-example-from-comment.patch
mm-remove-references-to-page_add_new_anon_rmap-in-comments.patch
mm-convert-migrate_vma_insert_page-to-use-a-folio.patch
mm-convert-collapse_huge_page-to-use-a-folio.patch
mm-remove-page_add_new_anon_rmap-and-lru_cache_add_inactive_or_unevictable.patch
mm-return-the-folio-from-__read_swap_cache_async.patch
mm-pass-a-folio-to-__swap_writepage.patch
mm-pass-a-folio-to-swap_writepage_fs.patch
mm-pass-a-folio-to-swap_writepage_bdev_sync.patch
mm-pass-a-folio-to-swap_writepage_bdev_async.patch
mm-pass-a-folio-to-swap_readpage_fs.patch
mm-pass-a-folio-to-swap_readpage_bdev_sync.patch
mm-pass-a-folio-to-swap_readpage_bdev_async.patch
mm-convert-swap_page_sector-to-swap_folio_sector.patch
mm-convert-swap_readpage-to-swap_read_folio.patch
mm-remove-page_swap_info.patch
mm-return-a-folio-from-read_swap_cache_async.patch
mm-convert-swap_cluster_readahead-and-swap_vma_readahead-to-return-a-folio.patch
fs-remove-clean_page_buffers.patch
fs-convert-clean_buffers-to-take-a-folio.patch
fs-reduce-stack-usage-in-__mpage_writepage.patch
fs-reduce-stack-usage-in-do_mpage_readpage.patch
adfs-remove-writepage-implementation.patch
bfs-remove-writepage-implementation.patch
hfs-really-remove-hfs_writepage.patch
hfsplus-really-remove-hfsplus_writepage.patch
minix-remove-writepage-implementation.patch
ocfs2-remove-writepage-implementation.patch
sysv-remove-writepage-implementation.patch
ufs-remove-writepage-implementation.patch
fs-convert-block_write_full_page-to-block_write_full_folio.patch
fs-remove-the-bh_end_io-argument-from-__block_write_full_folio.patch

