Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0166A8470
	for <mm-commits@vger.kernel.org>; Mon, 18 Dec 2023 18:44:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="aGwxzCtZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68D13C433C7;
	Mon, 18 Dec 2023 18:44:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1702925048;
	bh=rSJixzcJ7zC488N1zKDODJ/UPHFvAAmBboOeRQern2w=;
	h=Date:To:From:Subject:From;
	b=aGwxzCtZ/JEu+R85ZCfmGUVEWJm0BRis8wb3J2ROXLsB7U9swiPQBivn5edsiqSOF
	 yb4C2sMyK1WLc3/619pzoRTPVjWteJoBq2Wy7EUZSLdE/7lBQueYaI3TnCmCypudUS
	 /+WVng46K9d5PbyYm/I7hOui/Dcftf+xeVoea/1A=
Date: Mon, 18 Dec 2023 10:44:07 -0800
To: mm-commits@vger.kernel.org,hch@lst.de,axboe@kernel.dk,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + fs-remove-clean_page_buffers.patch added to mm-unstable branch
Message-Id: <20231218184408.68D13C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: fs: remove clean_page_buffers()
has been added to the -mm mm-unstable branch.  Its filename is
     fs-remove-clean_page_buffers.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/fs-remove-clean_page_buffers.patch

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
Subject: fs: remove clean_page_buffers()
Date: Fri, 15 Dec 2023 20:02:32 +0000

Patch series "Clean up the writeback paths".

Most of these patches verge on the trivial, converting filesystems that
just use block_write_full_page() to use mpage_writepages().  But as we saw
with Christoph's earlier patchset, there can be some "interesting"
gotchas, and I clearly haven't tested the majority of filesystems I've
touched here.

Patches 3 & 4 get rid of a lot of stack usage on architectures with larger
page sizes; 1024 bytes on 64-bit systems with 64KiB pages.  It starts to
open the door to larger folio sizes on all architectures, but it's
certainly not enough yet.

Patch 14 is kind of trivial, but it's nice to get that simplification in.


This patch (of 14):

This function has been unused since the removal of bdev_write_page().

Link: https://lkml.kernel.org/r/20231215200245.748418-1-willy@infradead.org
Link: https://lkml.kernel.org/r/20231215200245.748418-2-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/mpage.c                  |   10 ----------
 include/linux/buffer_head.h |    1 -
 2 files changed, 11 deletions(-)

--- a/fs/mpage.c~fs-remove-clean_page_buffers
+++ a/fs/mpage.c
@@ -455,16 +455,6 @@ static void clean_buffers(struct page *p
 		try_to_free_buffers(page_folio(page));
 }
 
-/*
- * For situations where we want to clean all buffers attached to a page.
- * We don't need to calculate how many buffers are attached to the page,
- * we just need to specify a number larger than the maximum number of buffers.
- */
-void clean_page_buffers(struct page *page)
-{
-	clean_buffers(page, ~0U);
-}
-
 static int __mpage_writepage(struct folio *folio, struct writeback_control *wbc,
 		      void *data)
 {
--- a/include/linux/buffer_head.h~fs-remove-clean_page_buffers
+++ a/include/linux/buffer_head.h
@@ -270,7 +270,6 @@ int generic_write_end(struct file *, str
 				loff_t, unsigned, unsigned,
 				struct page *, void *);
 void folio_zero_new_buffers(struct folio *folio, size_t from, size_t to);
-void clean_page_buffers(struct page *page);
 int cont_write_begin(struct file *, struct address_space *, loff_t,
 			unsigned, struct page **, void **,
 			get_block_t *, loff_t *);
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

