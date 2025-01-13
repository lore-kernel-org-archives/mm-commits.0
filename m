Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F31EF15D5B6
	for <mm-commits@vger.kernel.org>; Mon, 13 Jan 2025 04:24:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736742253; cv=none; b=cpjLNSlr+xsQI7GRJDK1Ezb/DdODCavn5dPN8vcez/GqYs4U5duesPMl8U6bRQuhXrJicmmnrKY0pgRO9n5/JegeRMeL/vN+drjDtH4NFFJZ1TmPiRhFdFUJ7q/r0IXXI/mMJYULowYYkU87c+Jxz74WXYCeoP0AwzdOPlrtca8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736742253; c=relaxed/simple;
	bh=TtJrSUPZrm5A/yQTtT3ZVI/L5QOYj+pyzJKzNaA5cp4=;
	h=Date:To:From:Subject:Message-Id; b=YqQHogt9D3bzruRuXVdhaVdma/LBZsiupp4OpaLflg4JEkatODcJI5LqLzz2kgfeVXgyjB0rgh++peqY3cAqCSZ+xGK3nQdBbg3dZ3X0H5aU911C9E6qZwy/i87X2QQMdWv1QoLZd28iP4EvVkKxeMZ1Qf5R6TBC/y3HmWxatN0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=PJHUvU8F; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="PJHUvU8F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C23D4C4CED6;
	Mon, 13 Jan 2025 04:24:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736742252;
	bh=TtJrSUPZrm5A/yQTtT3ZVI/L5QOYj+pyzJKzNaA5cp4=;
	h=Date:To:From:Subject:From;
	b=PJHUvU8FS1e0T20vxGsnWwpUmD7cpklmKWaVzjCuqMcADJ+6mv1iHE8vAc+bGJ74r
	 smSbAAFJ+QetgKx8XeyJdquHR2nAbxCPZGP6EsVGFzg0dprzr3bFsUlP5wHm1x0QWD
	 xqXyZxfRwOTycFhAr+3+e358vS1CU/JuLVWbkeZM=
Date: Sun, 12 Jan 2025 20:24:12 -0800
To: mm-commits@vger.kernel.org,ryan.roberts@arm.com,phillip@squashfs.org.uk,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] squashfs-convert-squashfs_fill_page-to-take-a-folio.patch removed from -mm tree
Message-Id: <20250113042412.C23D4C4CED6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: squashfs: convert squashfs_fill_page() to take a folio
has been removed from the -mm tree.  Its filename was
     squashfs-convert-squashfs_fill_page-to-take-a-folio.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: squashfs: convert squashfs_fill_page() to take a folio
Date: Fri, 20 Dec 2024 22:46:28 +0000

squashfs_fill_page is only used in this file, so make it static.
Use kmap_local instead of kmap_atomic, and return a bool so that
the caller can use folio_end_read() which saves an atomic operation
over calling folio_mark_uptodate() followed by folio_unlock().

[willy@infradead.org: fix polarity of "uptodate" Thanks to Ryan for testing]
  Link: https://lkml.kernel.org/r/20250110163300.3346321-2-willy@infradead.org
Link: https://lkml.kernel.org/r/20241220224634.723899-5-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Tested-by: Ryan Roberts <ryan.roberts@arm.com>
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
+		bool updated = false;
 
 		TRACE("bytes %zu, i %d, available_bytes %zu\n", bytes, i, avail);
 
@@ -412,9 +415,9 @@ void squashfs_copy_cache(struct folio *f
 		if (folio_test_uptodate(push_folio))
 			goto skip_folio;
 
-		squashfs_fill_page(&push_folio->page, buffer, offset, avail);
+		updated = squashfs_fill_page(push_folio, buffer, offset, avail);
 skip_folio:
-		folio_unlock(push_folio);
+		folio_end_read(push_folio, updated);
 		if (i != folio->index)
 			folio_put(push_folio);
 	}
--- a/fs/squashfs/squashfs.h~squashfs-convert-squashfs_fill_page-to-take-a-folio
+++ a/fs/squashfs/squashfs.h
@@ -73,7 +73,6 @@ extern __le64 *squashfs_read_fragment_in
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
mm-remove-pagetranstail.patch

