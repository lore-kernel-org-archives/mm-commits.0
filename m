Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CCF8481BD
	for <mm-commits@vger.kernel.org>; Mon, 18 Dec 2023 18:44:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="uwuo2yfo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFB17C433C8;
	Mon, 18 Dec 2023 18:44:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1702925063;
	bh=NuIoGgansO49c2gHafrrS1CC5XGJ8bUsZMzjzuTuR4s=;
	h=Date:To:From:Subject:From;
	b=uwuo2yfo5R6RFPWgwSW2MzQgIUHI6oXFbpvLE4pw7nvInINn99ks3ZqCEuagvzLZO
	 dES5nZq5AzsJBhNxCNf7Ti4Ur9IdB17WjFVOP+gpY2ZRAwuE5tNsf2KkPplIORgD0l
	 0h08GL/FPYel/6LE99rekvhhNhR1SjRPcV3YegOc=
Date: Mon, 18 Dec 2023 10:44:23 -0800
To: mm-commits@vger.kernel.org,hch@lst.de,axboe@kernel.dk,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ocfs2-remove-writepage-implementation.patch added to mm-unstable branch
Message-Id: <20231218184423.CFB17C433C8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: ocfs2: remove writepage implementation
has been added to the -mm mm-unstable branch.  Its filename is
     ocfs2-remove-writepage-implementation.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ocfs2-remove-writepage-implementation.patch

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
Subject: ocfs2: remove writepage implementation
Date: Fri, 15 Dec 2023 20:02:41 +0000

If the filesystem implements migrate_folio and writepages, there is no
need for a writepage implementation.

Link: https://lkml.kernel.org/r/20231215200245.748418-11-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/aops.c        |   15 ++++++---------
 fs/ocfs2/ocfs2_trace.h |    2 --
 2 files changed, 6 insertions(+), 11 deletions(-)

--- a/fs/ocfs2/aops.c~ocfs2-remove-writepage-implementation
+++ a/fs/ocfs2/aops.c
@@ -389,21 +389,18 @@ out_unlock:
 /* Note: Because we don't support holes, our allocation has
  * already happened (allocation writes zeros to the file data)
  * so we don't have to worry about ordered writes in
- * ocfs2_writepage.
+ * ocfs2_writepages.
  *
- * ->writepage is called during the process of invalidating the page cache
+ * ->writepages is called during the process of invalidating the page cache
  * during blocked lock processing.  It can't block on any cluster locks
  * to during block mapping.  It's relying on the fact that the block
  * mapping can't have disappeared under the dirty pages that it is
  * being asked to write back.
  */
-static int ocfs2_writepage(struct page *page, struct writeback_control *wbc)
+static int ocfs2_writepages(struct address_space *mapping,
+		struct writeback_control *wbc)
 {
-	trace_ocfs2_writepage(
-		(unsigned long long)OCFS2_I(page->mapping->host)->ip_blkno,
-		page->index);
-
-	return block_write_full_page(page, ocfs2_get_block, wbc);
+	return mpage_writepages(mapping, wbc, ocfs2_get_block);
 }
 
 /* Taken from ext3. We don't necessarily need the full blown
@@ -2471,7 +2468,7 @@ const struct address_space_operations oc
 	.dirty_folio		= block_dirty_folio,
 	.read_folio		= ocfs2_read_folio,
 	.readahead		= ocfs2_readahead,
-	.writepage		= ocfs2_writepage,
+	.writepages		= ocfs2_writepages,
 	.write_begin		= ocfs2_write_begin,
 	.write_end		= ocfs2_write_end,
 	.bmap			= ocfs2_bmap,
--- a/fs/ocfs2/ocfs2_trace.h~ocfs2-remove-writepage-implementation
+++ a/fs/ocfs2/ocfs2_trace.h
@@ -1157,8 +1157,6 @@ DEFINE_OCFS2_ULL_ULL_EVENT(ocfs2_get_blo
 
 DEFINE_OCFS2_ULL_ULL_EVENT(ocfs2_readpage);
 
-DEFINE_OCFS2_ULL_ULL_EVENT(ocfs2_writepage);
-
 DEFINE_OCFS2_ULL_ULL_EVENT(ocfs2_bmap);
 
 TRACE_EVENT(ocfs2_try_to_write_inline_data,
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

