Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93AED134B7
	for <mm-commits@vger.kernel.org>; Fri, 29 Dec 2023 20:00:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="B1A9PH/V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DF3BC433C7;
	Fri, 29 Dec 2023 20:00:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1703880010;
	bh=MULzJZwWlN87hmj4yJNiH9ck3nJ5EjztNucKR8rhOTA=;
	h=Date:To:From:Subject:From;
	b=B1A9PH/VDTL+xxS5yQ9Ta9i2eOhTlDU5xKuEyxXZL5YmT7N4oYliU4BHjBOKTs27l
	 VYlA3zv2+nEV4+dHIFYjOKeIDQ/rvLuIneLpeKcXAZU43y/41RfOeuhV/edbf0PO+N
	 RFrwVjhNaPR9xpXZPFleWi0YELtmhdXo0XfE07GM=
Date: Fri, 29 Dec 2023 12:00:09 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-pass-a-folio-to-swap_readpage_bdev_sync.patch removed from -mm tree
Message-Id: <20231229200010.5DF3BC433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: pass a folio to swap_readpage_bdev_sync()
has been removed from the -mm tree.  Its filename was
     mm-pass-a-folio-to-swap_readpage_bdev_sync.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: pass a folio to swap_readpage_bdev_sync()
Date: Wed, 13 Dec 2023 21:58:36 +0000

Make it plain that this takes the head page (which before this point
was just an assumption, but is now enforced by the compiler).

Link: https://lkml.kernel.org/r/20231213215842.671461-8-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_io.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/mm/page_io.c~mm-pass-a-folio-to-swap_readpage_bdev_sync
+++ a/mm/page_io.c
@@ -454,15 +454,15 @@ static void swap_readpage_fs(struct foli
 		*plug = sio;
 }
 
-static void swap_readpage_bdev_sync(struct page *page,
+static void swap_readpage_bdev_sync(struct folio *folio,
 		struct swap_info_struct *sis)
 {
 	struct bio_vec bv;
 	struct bio bio;
 
 	bio_init(&bio, sis->bdev, &bv, 1, REQ_OP_READ);
-	bio.bi_iter.bi_sector = swap_page_sector(page);
-	__bio_add_page(&bio, page, thp_size(page), 0);
+	bio.bi_iter.bi_sector = swap_page_sector(&folio->page);
+	bio_add_folio_nofail(&bio, folio, folio_size(folio), 0);
 	/*
 	 * Keep this task valid during swap readpage because the oom killer may
 	 * attempt to access it in the page fault retry time check.
@@ -516,7 +516,7 @@ void swap_readpage(struct page *page, bo
 	} else if (data_race(sis->flags & SWP_FS_OPS)) {
 		swap_readpage_fs(folio, plug);
 	} else if (synchronous || (sis->flags & SWP_SYNCHRONOUS_IO)) {
-		swap_readpage_bdev_sync(page, sis);
+		swap_readpage_bdev_sync(folio, sis);
 	} else {
 		swap_readpage_bdev_async(page, sis);
 	}
_

Patches currently in -mm which might be from willy@infradead.org are

mm-remove-inc-dec-lruvec-page-state-functions.patch
slub-use-alloc_pages_node-in-alloc_slab_page.patch
slub-use-folio-apis-in-free_large_kmalloc.patch
slub-use-a-folio-in-__kmalloc_large_node.patch
mm-khugepaged-use-a-folio-more-in-collapse_file.patch
mm-memcontrol-remove-__mod_lruvec_page_state.patch

