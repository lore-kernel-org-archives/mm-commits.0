Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 097D1215F43
	for <mm-commits@vger.kernel.org>; Mon, 17 Mar 2025 05:12:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742188344; cv=none; b=o1fGyNMIelRzyynMKHqU0mTlbgqCzn0cfomA4O7i70HqZTf3gEy9IG/M6emEXsI2+E6e8gpX8qc28EpMrvZCkRwZRV1eYfmOWG89+RK22ifyS8WqG1AaqCSIPdCBrq6iCsJrIbhUthe6AdzoD00scmuvHn1dwzLY6ot4FPmrmqo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742188344; c=relaxed/simple;
	bh=RgDisQ+0yESXb+uPpjdgtb+6DzVce8w6SFb+CmJm2l8=;
	h=Date:To:From:Subject:Message-Id; b=HiSvRaPl6Wls8YkCVWQfHIoSNr+huBrxrl42u8Dnl6c16hVvlETQO8fBPZSNKGpOfygxZ/Qr9o8OWiSXri7a0ICSZynWdqFsy4YDe8R5J4bEFyrwUcmQ0oi3BDqtCT5ycLJIgX+6hI7t4c/K25KDRkHRKLVqDruSlWRJWa54gDc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=rhZXhyzS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="rhZXhyzS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2A45C4CEEC;
	Mon, 17 Mar 2025 05:12:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742188343;
	bh=RgDisQ+0yESXb+uPpjdgtb+6DzVce8w6SFb+CmJm2l8=;
	h=Date:To:From:Subject:From;
	b=rhZXhyzSwVNwfU54wfwoTJ+OeZl8/sD6993B2PoQuI1j8zwBv63IY3PlR+vZEOwsX
	 TqLqwJ36F1YadXJeAHw8ktZadaBGwgtV9oe/VTpEBfhiLYywFNd0isEPNy5t97B7tM
	 vN7bxGyGIqgN1N7UE/ZRj0iQGgcT+J3RQtKsASYg=
Date: Sun, 16 Mar 2025 22:12:23 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] fs-convert-block_commit_write-to-take-a-folio.patch removed from -mm tree
Message-Id: <20250317051223.D2A45C4CEEC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: fs: convert block_commit_write() to take a folio
has been removed from the -mm tree.  Its filename was
     fs-convert-block_commit_write-to-take-a-folio.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: fs: convert block_commit_write() to take a folio
Date: Mon, 17 Feb 2025 19:20:06 +0000

All callers now have a folio, so pass it in instead of converting
folio->page->folio.

Link: https://lkml.kernel.org/r/20250217192009.437916-1-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/buffer.c                 |   14 ++++----------
 fs/ext4/inline.c            |    2 +-
 fs/ext4/move_extent.c       |    2 +-
 fs/iomap/buffered-io.c      |    2 +-
 fs/ocfs2/aops.c             |    4 ++--
 fs/ocfs2/file.c             |    2 +-
 fs/udf/file.c               |    2 +-
 include/linux/buffer_head.h |    2 +-
 8 files changed, 12 insertions(+), 18 deletions(-)

--- a/fs/buffer.c~fs-convert-block_commit_write-to-take-a-folio
+++ a/fs/buffer.c
@@ -2166,7 +2166,7 @@ int __block_write_begin(struct folio *fo
 }
 EXPORT_SYMBOL(__block_write_begin);
 
-static void __block_commit_write(struct folio *folio, size_t from, size_t to)
+void block_commit_write(struct folio *folio, size_t from, size_t to)
 {
 	size_t block_start, block_end;
 	bool partial = false;
@@ -2204,6 +2204,7 @@ static void __block_commit_write(struct
 	if (!partial)
 		folio_mark_uptodate(folio);
 }
+EXPORT_SYMBOL(block_commit_write);
 
 /*
  * block_write_begin takes care of the basic task of block allocation and
@@ -2262,7 +2263,7 @@ int block_write_end(struct file *file, s
 	flush_dcache_folio(folio);
 
 	/* This could be a short (even 0-length) commit */
-	__block_commit_write(folio, start, start + copied);
+	block_commit_write(folio, start, start + copied);
 
 	return copied;
 }
@@ -2578,13 +2579,6 @@ int cont_write_begin(struct file *file,
 }
 EXPORT_SYMBOL(cont_write_begin);
 
-void block_commit_write(struct page *page, unsigned from, unsigned to)
-{
-	struct folio *folio = page_folio(page);
-	__block_commit_write(folio, from, to);
-}
-EXPORT_SYMBOL(block_commit_write);
-
 /*
  * block_page_mkwrite() is not allowed to change the file size as it gets
  * called from a page fault handler when a page is first dirtied. Hence we must
@@ -2630,7 +2624,7 @@ int block_page_mkwrite(struct vm_area_st
 	if (unlikely(ret))
 		goto out_unlock;
 
-	__block_commit_write(folio, 0, end);
+	block_commit_write(folio, 0, end);
 
 	folio_mark_dirty(folio);
 	folio_wait_stable(folio);
--- a/fs/ext4/inline.c~fs-convert-block_commit_write-to-take-a-folio
+++ a/fs/ext4/inline.c
@@ -637,7 +637,7 @@ retry:
 		goto retry;
 
 	if (folio)
-		block_commit_write(&folio->page, from, to);
+		block_commit_write(folio, from, to);
 out:
 	if (folio) {
 		folio_unlock(folio);
--- a/fs/ext4/move_extent.c~fs-convert-block_commit_write-to-take-a-folio
+++ a/fs/ext4/move_extent.c
@@ -399,7 +399,7 @@ data_copy:
 		bh = bh->b_this_page;
 	}
 
-	block_commit_write(&folio[0]->page, from, from + replaced_size);
+	block_commit_write(folio[0], from, from + replaced_size);
 
 	/* Even in case of data=writeback it is reasonable to pin
 	 * inode to transaction, to prevent unexpected data loss */
--- a/fs/iomap/buffered-io.c~fs-convert-block_commit_write-to-take-a-folio
+++ a/fs/iomap/buffered-io.c
@@ -1484,7 +1484,7 @@ static loff_t iomap_folio_mkwrite_iter(s
 					      &iter->iomap);
 		if (ret)
 			return ret;
-		block_commit_write(&folio->page, 0, length);
+		block_commit_write(folio, 0, length);
 	} else {
 		WARN_ON_ONCE(!folio_test_uptodate(folio));
 		folio_mark_dirty(folio);
--- a/fs/ocfs2/aops.c~fs-convert-block_commit_write-to-take-a-folio
+++ a/fs/ocfs2/aops.c
@@ -920,7 +920,7 @@ static void ocfs2_write_failure(struct i
 				ocfs2_jbd2_inode_add_write(wc->w_handle, inode,
 							   user_pos, user_len);
 
-			block_commit_write(&folio->page, from, to);
+			block_commit_write(folio, from, to);
 		}
 	}
 }
@@ -2012,7 +2012,7 @@ int ocfs2_write_end_nolock(struct addres
 				ocfs2_jbd2_inode_add_write(handle, inode,
 							   start_byte, length);
 			}
-			block_commit_write(&folio->page, from, to);
+			block_commit_write(folio, from, to);
 		}
 	}
 
--- a/fs/ocfs2/file.c~fs-convert-block_commit_write-to-take-a-folio
+++ a/fs/ocfs2/file.c
@@ -813,7 +813,7 @@ static int ocfs2_write_zero_page(struct
 
 
 		/* must not update i_size! */
-		block_commit_write(&folio->page, block_start + 1, block_start + 1);
+		block_commit_write(folio, block_start + 1, block_start + 1);
 	}
 
 	/*
--- a/fs/udf/file.c~fs-convert-block_commit_write-to-take-a-folio
+++ a/fs/udf/file.c
@@ -69,7 +69,7 @@ static vm_fault_t udf_page_mkwrite(struc
 		goto out_unlock;
 	}
 
-	block_commit_write(&folio->page, 0, end);
+	block_commit_write(folio, 0, end);
 out_dirty:
 	folio_mark_dirty(folio);
 	folio_wait_stable(folio);
--- a/include/linux/buffer_head.h~fs-convert-block_commit_write-to-take-a-folio
+++ a/include/linux/buffer_head.h
@@ -271,7 +271,7 @@ int cont_write_begin(struct file *, stru
 			unsigned, struct folio **, void **,
 			get_block_t *, loff_t *);
 int generic_cont_expand_simple(struct inode *inode, loff_t size);
-void block_commit_write(struct page *page, unsigned int from, unsigned int to);
+void block_commit_write(struct folio *folio, size_t from, size_t to);
 int block_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf,
 				get_block_t get_block);
 sector_t generic_block_bmap(struct address_space *, sector_t, get_block_t *);
_

Patches currently in -mm which might be from willy@infradead.org are

dax-remove-access-to-page-index.patch
dax-use-folios-more-widely-within-dax.patch
hugetlb-convert-hugetlb_vma_maps_page-to-hugetlb_vma_maps_pfn.patch
hugetlb-convert-adjust_range_hwpoison-to-take-a-folio.patch
mm-convert-lru_add_page_tail-to-lru_add_split_folio.patch
mm-separate-folio_split_memcg_refs-from-split_page_memcg.patch
mm-simplify-split_page_memcg.patch
mm-remove-references-to-folio-in-split_page_memcg.patch
mm-simplify-folio_memcg_charged.patch
mm-remove-references-to-folio-in-__memcg_kmem_uncharge_page.patch
ocfs2-use-memcpy_to_folio-in-ocfs2_symlink_get_block.patch
ocfs2-remove-reference-to-bh-b_page.patch

