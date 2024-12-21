Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5265B13A244
	for <mm-commits@vger.kernel.org>; Sat, 21 Dec 2024 04:07:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734754065; cv=none; b=oI5GGX13QvE5kqKELvg8orb4gAKnLdCKRMSSevDksmHujePMe30XP9rLLqUt6S9yztzWteg9ohQyYDY/KyQLzLnB/Mm2v04iGQezicU2LYK64dh4ZS9hY78jyzAJJyLXfQ1JvAvveJny5szxYaTLWSoAJ4uxvvn1fbthQqEUTSg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734754065; c=relaxed/simple;
	bh=pgb/zDgX6hShe7I3bsyanQd5WscB7/K7Plny9DwmVvU=;
	h=Date:To:From:Subject:Message-Id; b=A7erUl/dQxt2Nx1o02xGCEz//aAeMqvKxgMfYIX+2xwT0afVzHD3GAes3KkR7ql1lHrpDcMcDQ266jrWux9bd1W6dC+nT6kcvLAfWiWlQA/RgVVrz4eyKRPwcOr7tQCLmVwq1SBWEasg+jVAUtRdevqqq0tCtWXc5Qd4pG7SBd0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=JbLKNTci; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="JbLKNTci"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08185C4CECE;
	Sat, 21 Dec 2024 04:07:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1734754065;
	bh=pgb/zDgX6hShe7I3bsyanQd5WscB7/K7Plny9DwmVvU=;
	h=Date:To:From:Subject:From;
	b=JbLKNTcixWBL4/8I5INmf9ayNvNLsxRPk7i/FOW/IeuFkV1bY1r4X/vcYzJzIVnG3
	 SbWupkkpS/N7a6Y+xErF5bL8T5V9/C85bTffyvzm1aSXi0uGuARzaFLMPT4KUF7gU8
	 1BAIG2cT4jspoYzCgkpikX65Y767SDud0ddybvUM=
Date: Fri, 20 Dec 2024 20:07:44 -0800
To: mm-commits@vger.kernel.org,phillip@squashfs.org.uk,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + squashfs-convert-squashfs_fill_page-to-take-a-folio.patch added to mm-nonmm-unstable branch
Message-Id: <20241221040745.08185C4CECE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: squashfs: convert squashfs_fill_page() to take a folio
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     squashfs-convert-squashfs_fill_page-to-take-a-folio.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/squashfs-convert-squashfs_fill_page-to-take-a-folio.patch

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
Subject: squashfs: convert squashfs_fill_page() to take a folio
Date: Fri, 20 Dec 2024 22:46:28 +0000

squashfs_fill_page is only used in this file, so make it static.
Use kmap_local instead of kmap_atomic, and return a bool so that
the caller can use folio_end_read() which saves an atomic operation
over calling folio_mark_uptodate() followed by folio_unlock().

Link: https://lkml.kernel.org/r/20241220224634.723899-5-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Phillip Lougher <phillip@squashfs.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/squashfs/file.c     |   21 ++++++++++++---------
 fs/squashfs/squashfs.h |    1 -
 2 files changed, 12 insertions(+), 10 deletions(-)

--- a/fs/squashfs/file.c~squashfs-convert-squashfs_fill_page-to-take-a-folio
+++ a/fs/squashfs/file.c
@@ -362,19 +362,21 @@ static int read_blocklist(struct inode *
 	return squashfs_block_size(size);
 }
 
-void squashfs_fill_page(struct page *page, struct squashfs_cache_entry *buffer, int offset, int avail)
+static bool squashfs_fill_page(struct folio *folio,
+		struct squashfs_cache_entry *buffer, size_t offset,
+		size_t avail)
 {
-	int copied;
+	size_t copied;
 	void *pageaddr;
 
-	pageaddr = kmap_atomic(page);
+	pageaddr = kmap_local_folio(folio, 0);
 	copied = squashfs_copy_data(pageaddr, buffer, offset, avail);
 	memset(pageaddr + copied, 0, PAGE_SIZE - copied);
-	kunmap_atomic(pageaddr);
+	kunmap_local(pageaddr);
 
-	flush_dcache_page(page);
-	if (copied == avail)
-		SetPageUptodate(page);
+	flush_dcache_folio(folio);
+
+	return copied == avail;
 }
 
 /* Copy data into page cache  */
@@ -398,6 +400,7 @@ void squashfs_copy_cache(struct folio *f
 			bytes -= PAGE_SIZE, offset += PAGE_SIZE) {
 		struct folio *push_folio;
 		size_t avail = buffer ? min(bytes, PAGE_SIZE) : 0;
+		bool uptodate = true;
 
 		TRACE("bytes %zu, i %d, available_bytes %zu\n", bytes, i, avail);
 
@@ -412,9 +415,9 @@ void squashfs_copy_cache(struct folio *f
 		if (folio_test_uptodate(push_folio))
 			goto skip_folio;
 
-		squashfs_fill_page(&push_folio->page, buffer, offset, avail);
+		uptodate = squashfs_fill_page(push_folio, buffer, offset, avail);
 skip_folio:
-		folio_unlock(push_folio);
+		folio_end_read(push_folio, uptodate);
 		if (i != folio->index)
 			folio_put(push_folio);
 	}
--- a/fs/squashfs/squashfs.h~squashfs-convert-squashfs_fill_page-to-take-a-folio
+++ a/fs/squashfs/squashfs.h
@@ -67,7 +67,6 @@ extern __le64 *squashfs_read_fragment_in
 				u64, u64, unsigned int);
 
 /* file.c */
-void squashfs_fill_page(struct page *, struct squashfs_cache_entry *, int, int);
 void squashfs_copy_cache(struct folio *, struct squashfs_cache_entry *,
 		size_t bytes, size_t offset);
 
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

