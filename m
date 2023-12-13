Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 352C48183A
	for <mm-commits@vger.kernel.org>; Wed, 13 Dec 2023 23:12:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="tq24a0m+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3EEAC433C8;
	Wed, 13 Dec 2023 23:12:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1702509128;
	bh=x0FE1bB31XXwNezCf12vBbwFblUf/vhd/OItlUbR24w=;
	h=Date:To:From:Subject:From;
	b=tq24a0m+zjBpACvXJfwdDM0SWZl6DvdWf8yuFm0+m8SWpXsu0CQ0mqUStc2VI7Sq1
	 gLI/8qge7iA0bQc+DbjY38bTqMYJAPi0bWaaLQhGkrPGLORPmtcA+h8f56GSFWxu1x
	 lw1LRF6sD+RoFXytzrCUHo2zGNy3SKpKl7CIJywU=
Date: Wed, 13 Dec 2023 15:12:07 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-pass-a-folio-to-swap_readpage_bdev_async.patch added to mm-unstable branch
Message-Id: <20231213231207.F3EEAC433C8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: pass a folio to swap_readpage_bdev_async()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-pass-a-folio-to-swap_readpage_bdev_async.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-pass-a-folio-to-swap_readpage_bdev_async.patch

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
Subject: mm: pass a folio to swap_readpage_bdev_async()
Date: Wed, 13 Dec 2023 21:58:37 +0000

Make it plain that this takes the head page (which before this point
was just an assumption, but is now enforced by the compiler).

Link: https://lkml.kernel.org/r/20231213215842.671461-9-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_io.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/mm/page_io.c~mm-pass-a-folio-to-swap_readpage_bdev_async
+++ a/mm/page_io.c
@@ -480,15 +480,15 @@ static void swap_readpage_bdev_sync(stru
 	put_task_struct(current);
 }
 
-static void swap_readpage_bdev_async(struct page *page,
+static void swap_readpage_bdev_async(struct folio *folio,
 		struct swap_info_struct *sis)
 {
 	struct bio *bio;
 
 	bio = bio_alloc(sis->bdev, 1, REQ_OP_READ, GFP_KERNEL);
-	bio->bi_iter.bi_sector = swap_page_sector(page);
+	bio->bi_iter.bi_sector = swap_page_sector(&folio->page);
 	bio->bi_end_io = end_swap_bio_read;
-	__bio_add_page(bio, page, thp_size(page), 0);
+	bio_add_folio_nofail(bio, folio, folio_size(folio), 0);
 	count_vm_event(PSWPIN);
 	submit_bio(bio);
 }
@@ -524,7 +524,7 @@ void swap_readpage(struct page *page, bo
 	} else if (synchronous || (sis->flags & SWP_SYNCHRONOUS_IO)) {
 		swap_readpage_bdev_sync(folio, sis);
 	} else {
-		swap_readpage_bdev_async(page, sis);
+		swap_readpage_bdev_async(folio, sis);
 	}
 
 	if (workingset) {
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

