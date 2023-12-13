Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F11828183A
	for <mm-commits@vger.kernel.org>; Wed, 13 Dec 2023 23:12:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="TBfngpSr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6B86C433C8;
	Wed, 13 Dec 2023 23:12:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1702509134;
	bh=sV1/4U3QRDHDDmI+S8yT4hY5NB6Uuyi1OEDIzlGVAbw=;
	h=Date:To:From:Subject:From;
	b=TBfngpSri5O642s2uUDuFOpsdnpdP0/xc40ysWAKgZv7RGiunX+HhElfjNx4Futnn
	 E/yW8cYYp6WtEq548q5iL1iLgbQDkEXzTkz3AIYmsm/7/xHJHrIe+bk98b4MyWkCbA
	 phVlIJOpaDV9KmdXVyEhZU8Ix+gIXHwyV5JAIZqI=
Date: Wed, 13 Dec 2023 15:12:14 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-remove-page_swap_info.patch added to mm-unstable branch
Message-Id: <20231213231214.B6B86C433C8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: remove page_swap_info()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-remove-page_swap_info.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-remove-page_swap_info.patch

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
Subject: mm: remove page_swap_info()
Date: Wed, 13 Dec 2023 21:58:40 +0000

It's more efficient to get the swap_info_struct by calling
swp_swap_info() directly.

Link: https://lkml.kernel.org/r/20231213215842.671461-12-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/swap.h |    3 +--
 mm/swap.h            |    2 +-
 mm/swapfile.c        |    8 +-------
 3 files changed, 3 insertions(+), 10 deletions(-)

--- a/include/linux/swap.h~mm-remove-page_swap_info
+++ a/include/linux/swap.h
@@ -487,8 +487,7 @@ extern sector_t swapdev_block(int, pgoff
 extern int __swap_count(swp_entry_t entry);
 extern int swap_swapcount(struct swap_info_struct *si, swp_entry_t entry);
 extern int swp_swapcount(swp_entry_t entry);
-extern struct swap_info_struct *page_swap_info(struct page *);
-extern struct swap_info_struct *swp_swap_info(swp_entry_t entry);
+struct swap_info_struct *swp_swap_info(swp_entry_t entry);
 struct backing_dev_info;
 extern int init_swap_address_space(unsigned int type, unsigned long nr_pages);
 extern void exit_swap_address_space(unsigned int type);
--- a/mm/swapfile.c~mm-remove-page_swap_info
+++ a/mm/swapfile.c
@@ -3369,18 +3369,12 @@ struct swap_info_struct *swp_swap_info(s
 	return swap_type_to_swap_info(swp_type(entry));
 }
 
-struct swap_info_struct *page_swap_info(struct page *page)
-{
-	swp_entry_t entry = page_swap_entry(page);
-	return swp_swap_info(entry);
-}
-
 /*
  * out-of-line methods to avoid include hell.
  */
 struct address_space *swapcache_mapping(struct folio *folio)
 {
-	return page_swap_info(&folio->page)->swap_file->f_mapping;
+	return swp_swap_info(folio->swap)->swap_file->f_mapping;
 }
 EXPORT_SYMBOL_GPL(swapcache_mapping);
 
--- a/mm/swap.h~mm-remove-page_swap_info
+++ a/mm/swap.h
@@ -60,7 +60,7 @@ struct page *swapin_readahead(swp_entry_
 
 static inline unsigned int folio_swap_flags(struct folio *folio)
 {
-	return page_swap_info(&folio->page)->flags;
+	return swp_swap_info(folio->swap)->flags;
 }
 #else /* CONFIG_SWAP */
 struct swap_iocb;
_

Patches currently in -mm which might be from willy@infradead.org are

buffer-return-bool-from-grow_dev_folio.patch
buffer-calculate-block-number-inside-folio_init_buffers.patch
buffer-fix-grow_buffers-for-block-size-page_size.patch
buffer-cast-block-to-loff_t-before-shifting-it.patch
buffer-fix-various-functions-for-block-size-page_size.patch
buffer-handle-large-folios-in-__block_write_begin_int.patch
buffer-fix-more-functions-for-block-size-page_size.patch
mm-convert-ksm_might_need_to_copy-to-work-on-folios.patch
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

