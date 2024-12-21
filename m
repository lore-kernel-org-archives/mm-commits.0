Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99F0513A244
	for <mm-commits@vger.kernel.org>; Sat, 21 Dec 2024 04:07:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734754062; cv=none; b=nPEft3Wb4XFFB6OXn4QC3BsAGCFI4roaUDDQ7r0bMKIk5Iq5EmduLFusETaMwrO+TKAEO7mWRXYczkoC+rlLAZydbdkb1wlDVmCRCSN2e4kQ1nYwJc7/Me8a+C5vbHTJwf/f0gC/OnpZwQN2SpLHvweIFaMBjmqtqGdaqxjRldg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734754062; c=relaxed/simple;
	bh=YdQ3TFEClvxtMvfYZuC4Y3VgJffsuDl2TeEmpLFK91U=;
	h=Date:To:From:Subject:Message-Id; b=T8NxYlR+mmn4urQUpr9nyLyLGbmf7CzkS8io1uPMUJhfZW/y52RKuKgPEW8EeXFh+/jnkSTnynixS4f6t/rSvyb6p6qHEkCgLwLLSbMMZm1D1Twzht+gIeOFz5nqnuIeYYgId7B8516oFrZiNaShycxz4qEYefwjZYfPU2Mn+Gs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=OnOJLnIz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="OnOJLnIz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65A87C4CECE;
	Sat, 21 Dec 2024 04:07:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1734754062;
	bh=YdQ3TFEClvxtMvfYZuC4Y3VgJffsuDl2TeEmpLFK91U=;
	h=Date:To:From:Subject:From;
	b=OnOJLnIz4faWgd096dhV3H2nX4tQy1dVfmxN3UWe5/kD0WD+HRRGoWu8fcKtUBTFy
	 3eM1b0Sc/hK0/E4fbXWwGTWGQwb/LFY7YxPAxWEndF7EAT4GGhv9+8wFQtoHjrVQyt
	 cOfbMqkAyiXZm/b1yJ/OZrRtwkDVNaEHC4e0qckI=
Date: Fri, 20 Dec 2024 20:07:41 -0800
To: mm-commits@vger.kernel.org,phillip@squashfs.org.uk,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + squashfs-convert-squashfs_copy_cache-to-take-a-folio.patch added to mm-nonmm-unstable branch
Message-Id: <20241221040742.65A87C4CECE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: squashfs; convert squashfs_copy_cache() to take a folio
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     squashfs-convert-squashfs_copy_cache-to-take-a-folio.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/squashfs-convert-squashfs_copy_cache-to-take-a-folio.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
Subject: squashfs; convert squashfs_copy_cache() to take a folio
Date: Fri, 20 Dec 2024 22:46:27 +0000

Remove accesses to page->index and page->mapping.  Also use folio
APIs where available.  This code still assumes order 0 folios.

Link: https://lkml.kernel.org/r/20241220224634.723899-4-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Phillip Lougher <phillip@squashfs.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/squashfs/file.c       |   46 ++++++++++++++++++++-----------------
 fs/squashfs/file_cache.c |    2 -
 fs/squashfs/squashfs.h   |    4 +--
 3 files changed, 28 insertions(+), 24 deletions(-)

--- a/fs/squashfs/file.c~squashfs-convert-squashfs_copy_cache-to-take-a-folio
+++ a/fs/squashfs/file.c
@@ -378,13 +378,15 @@ void squashfs_fill_page(struct page *pag
 }
 
 /* Copy data into page cache  */
-void squashfs_copy_cache(struct page *page, struct squashfs_cache_entry *buffer,
-	int bytes, int offset)
+void squashfs_copy_cache(struct folio *folio,
+		struct squashfs_cache_entry *buffer, size_t bytes,
+		size_t offset)
 {
-	struct inode *inode = page->mapping->host;
+	struct address_space *mapping = folio->mapping;
+	struct inode *inode = mapping->host;
 	struct squashfs_sb_info *msblk = inode->i_sb->s_fs_info;
 	int i, mask = (1 << (msblk->block_log - PAGE_SHIFT)) - 1;
-	int start_index = page->index & ~mask, end_index = start_index | mask;
+	int start_index = folio->index & ~mask, end_index = start_index | mask;
 
 	/*
 	 * Loop copying datablock into pages.  As the datablock likely covers
@@ -394,25 +396,27 @@ void squashfs_copy_cache(struct page *pa
 	 */
 	for (i = start_index; i <= end_index && bytes > 0; i++,
 			bytes -= PAGE_SIZE, offset += PAGE_SIZE) {
-		struct page *push_page;
-		int avail = buffer ? min_t(int, bytes, PAGE_SIZE) : 0;
+		struct folio *push_folio;
+		size_t avail = buffer ? min(bytes, PAGE_SIZE) : 0;
 
-		TRACE("bytes %d, i %d, available_bytes %d\n", bytes, i, avail);
+		TRACE("bytes %zu, i %d, available_bytes %zu\n", bytes, i, avail);
 
-		push_page = (i == page->index) ? page :
-			grab_cache_page_nowait(page->mapping, i);
+		push_folio = (i == folio->index) ? folio :
+			__filemap_get_folio(mapping, i,
+					FGP_LOCK|FGP_CREAT|FGP_NOFS|FGP_NOWAIT,
+					mapping_gfp_mask(mapping));
 
-		if (!push_page)
+		if (!push_folio)
 			continue;
 
-		if (PageUptodate(push_page))
-			goto skip_page;
+		if (folio_test_uptodate(push_folio))
+			goto skip_folio;
 
-		squashfs_fill_page(push_page, buffer, offset, avail);
-skip_page:
-		unlock_page(push_page);
-		if (i != page->index)
-			put_page(push_page);
+		squashfs_fill_page(&push_folio->page, buffer, offset, avail);
+skip_folio:
+		folio_unlock(push_folio);
+		if (i != folio->index)
+			folio_put(push_folio);
 	}
 }
 
@@ -430,16 +434,16 @@ static int squashfs_readpage_fragment(st
 			squashfs_i(inode)->fragment_block,
 			squashfs_i(inode)->fragment_size);
 	else
-		squashfs_copy_cache(&folio->page, buffer, expected,
+		squashfs_copy_cache(folio, buffer, expected,
 			squashfs_i(inode)->fragment_offset);
 
 	squashfs_cache_put(buffer);
 	return res;
 }
 
-static int squashfs_readpage_sparse(struct page *page, int expected)
+static int squashfs_readpage_sparse(struct folio *folio, int expected)
 {
-	squashfs_copy_cache(page, NULL, expected, 0);
+	squashfs_copy_cache(folio, NULL, expected, 0);
 	return 0;
 }
 
@@ -470,7 +474,7 @@ static int squashfs_read_folio(struct fi
 			goto out;
 
 		if (res == 0)
-			res = squashfs_readpage_sparse(&folio->page, expected);
+			res = squashfs_readpage_sparse(folio, expected);
 		else
 			res = squashfs_readpage_block(folio, block, res, expected);
 	} else
--- a/fs/squashfs/file_cache.c~squashfs-convert-squashfs_copy_cache-to-take-a-folio
+++ a/fs/squashfs/file_cache.c
@@ -29,7 +29,7 @@ int squashfs_readpage_block(struct folio
 		ERROR("Unable to read page, block %llx, size %x\n", block,
 			bsize);
 	else
-		squashfs_copy_cache(&folio->page, buffer, expected, 0);
+		squashfs_copy_cache(folio, buffer, expected, 0);
 
 	squashfs_cache_put(buffer);
 	return res;
--- a/fs/squashfs/squashfs.h~squashfs-convert-squashfs_copy_cache-to-take-a-folio
+++ a/fs/squashfs/squashfs.h
@@ -68,8 +68,8 @@ extern __le64 *squashfs_read_fragment_in
 
 /* file.c */
 void squashfs_fill_page(struct page *, struct squashfs_cache_entry *, int, int);
-void squashfs_copy_cache(struct page *, struct squashfs_cache_entry *, int,
-				int);
+void squashfs_copy_cache(struct folio *, struct squashfs_cache_entry *,
+		size_t bytes, size_t offset);
 
 /* file_xxx.c */
 int squashfs_readpage_block(struct folio *, u64 block, int bsize, int expected);
_

Patches currently in -mm which might be from willy@infradead.org are

mm-page_alloc-cache-page_zone-result-in-free_unref_page.patch
mm-make-alloc_pages_mpol-static.patch
mm-page_alloc-export-free_frozen_pages-instead-of-free_unref_page.patch
mm-page_alloc-move-set_page_refcounted-to-callers-of-post_alloc_hook.patch
mm-page_alloc-move-set_page_refcounted-to-callers-of-prep_new_page.patch
mm-page_alloc-move-set_page_refcounted-to-callers-of-get_page_from_freelist.patch
mm-page_alloc-move-set_page_refcounted-to-callers-of-__alloc_pages_cpuset_fallback.patch
mm-page_alloc-move-set_page_refcounted-to-callers-of-__alloc_pages_may_oom.patch
mm-page_alloc-move-set_page_refcounted-to-callers-of-__alloc_pages_direct_compact.patch
mm-page_alloc-move-set_page_refcounted-to-callers-of-__alloc_pages_direct_reclaim.patch
mm-page_alloc-move-set_page_refcounted-to-callers-of-__alloc_pages_slowpath.patch
mm-page_alloc-move-set_page_refcounted-to-end-of-__alloc_pages.patch
mm-page_alloc-add-__alloc_frozen_pages.patch
mm-mempolicy-add-alloc_frozen_pages.patch
slab-allocate-frozen-pages.patch
ocfs2-handle-a-symlink-read-error-correctly.patch
ocfs2-convert-ocfs2_page_mkwrite-to-use-a-folio.patch
ocfs2-pass-mmap_folio-around-instead-of-mmap_page.patch
ocfs2-convert-ocfs2_read_inline_data-to-take-a-folio.patch
ocfs2-use-a-folio-in-ocfs2_fast_symlink_read_folio.patch
ocfs2-remove-ocfs2_start_walk_page_trans-prototype.patch
iov_iter-remove-setting-of-page-index.patch
squashfs-use-a-folio-throughout-squashfs_read_folio.patch
squashfs-pass-a-folio-to-squashfs_readpage_fragment.patch
squashfs-convert-squashfs_readpage_block-to-take-a-folio.patch
squashfs-convert-squashfs_copy_cache-to-take-a-folio.patch
squashfs-convert-squashfs_fill_page-to-take-a-folio.patch

