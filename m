Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAC9513AC2
	for <mm-commits@vger.kernel.org>; Fri, 29 Dec 2023 20:00:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="pNIRb4/u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 363E5C433CA;
	Fri, 29 Dec 2023 20:00:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1703880020;
	bh=uPw2sKUKkb+Y8tFGdRFHuRTX+2OJnwfOBY4dzVqEbbs=;
	h=Date:To:From:Subject:From;
	b=pNIRb4/ukztKjrKRZtGD6xClI7dkjRQZeNaQptQQba7srsuciuyURvEMcqxSIJF+n
	 VQGuOAxqs5rUEGIS+S6fcb7rE3mhz26czJ/HRKae3HwSBMK6QeFCbAJsQQSW8C/aSr
	 61WVAHOaCWYgDIGe1y1mbsYcCdHBnlyDTEo5C2gk=
Date: Fri, 29 Dec 2023 12:00:19 -0800
To: mm-commits@vger.kernel.org,hch@lst.de,axboe@kernel.dk,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] fs-remove-clean_page_buffers.patch removed from -mm tree
Message-Id: <20231229200020.363E5C433CA@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: fs: remove clean_page_buffers()
has been removed from the -mm tree.  Its filename was
     fs-remove-clean_page_buffers.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

mm-remove-inc-dec-lruvec-page-state-functions.patch
slub-use-alloc_pages_node-in-alloc_slab_page.patch
slub-use-folio-apis-in-free_large_kmalloc.patch
slub-use-a-folio-in-__kmalloc_large_node.patch
mm-khugepaged-use-a-folio-more-in-collapse_file.patch
mm-memcontrol-remove-__mod_lruvec_page_state.patch

