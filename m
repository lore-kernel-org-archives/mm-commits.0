Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D1AF153BD9
	for <mm-commits@vger.kernel.org>; Thu, 12 Jun 2025 22:59:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749769146; cv=none; b=saDJhvYLHCjBCBPy40SPAcfdGKleJc02U95+c4jO5LJq6QJnzTAChHRDMtG3/XH17sWtTYeIs29rLI35MZ36DUJhnXdBJC/NVeBdrdcL1ZPZ7pqBsbCnPT5kgTQwCsZvSH4Z075kh6DcmdLUumELa9cMoXiYWbHkgkSQ9e3GUsU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749769146; c=relaxed/simple;
	bh=6orp7OJHcCDce+IDeAgwe9cHuHzVWfvsvZmrmdoIpoQ=;
	h=Date:To:From:Subject:Message-Id; b=D/ufDltyW2otE/wSE9ENT/wGyE/WChTLHOhw53O9LSKCSTJ15WfLP9Gu3vne3HhJZILSAP3PvSAmZqkgr/kzAoyoinvn0MjgkBDgVUb6r5zeekzQFmjWYyKHJuYK3qHdJytbre5+umip5EgMCZEESH7eKzIGjMwieDC8akYHnoA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Kd6wl46z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Kd6wl46z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C83BFC4CEEB;
	Thu, 12 Jun 2025 22:59:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1749769145;
	bh=6orp7OJHcCDce+IDeAgwe9cHuHzVWfvsvZmrmdoIpoQ=;
	h=Date:To:From:Subject:From;
	b=Kd6wl46zd810j/W2vkHCYMXzLymtTBH/CaWU6/8S+ktGCaf9DkJoFXWSVYO7KPbv5
	 JCy8etfWIRGgSmaLdcsaQ4kNH4f1eZ5CI79BcTVKQKBYKpO3D7AorEAd7dyoLTOXwI
	 +HXw2rgYoEPNhlihaMqDqYVoUTsxg13DCRC8lnPc=
Date: Thu, 12 Jun 2025 15:59:05 -0700
To: mm-commits@vger.kernel.org,phillip@squashfs.org.uk,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + squashfs-use-folios-in-squashfs_bio_read_cached.patch added to mm-nonmm-unstable branch
Message-Id: <20250612225905.C83BFC4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: squashfs: use folios in squashfs_bio_read_cached()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     squashfs-use-folios-in-squashfs_bio_read_cached.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/squashfs-use-folios-in-squashfs_bio_read_cached.patch

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
Subject: squashfs: use folios in squashfs_bio_read_cached()
Date: Thu, 12 Jun 2025 15:39:01 +0100

Remove an access to page->mapping and a few calls to the old page-based
APIs.  This doesn't support large folios, but it's still a nice
improvement.

Link: https://lkml.kernel.org/r/20250612143903.2849289-3-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Phillip Lougher <phillip@squashfs.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/squashfs/block.c |   45 ++++++++++++++++++++----------------------
 1 file changed, 22 insertions(+), 23 deletions(-)

--- a/fs/squashfs/block.c~squashfs-use-folios-in-squashfs_bio_read_cached
+++ a/fs/squashfs/block.c
@@ -80,23 +80,22 @@ static int squashfs_bio_read_cached(stru
 		struct address_space *cache_mapping, u64 index, int length,
 		u64 read_start, u64 read_end, int page_count)
 {
-	struct page *head_to_cache = NULL, *tail_to_cache = NULL;
+	struct folio *head_to_cache = NULL, *tail_to_cache = NULL;
 	struct block_device *bdev = fullbio->bi_bdev;
 	int start_idx = 0, end_idx = 0;
-	struct bvec_iter_all iter_all;
+	struct folio_iter fi;;
 	struct bio *bio = NULL;
-	struct bio_vec *bv;
 	int idx = 0;
 	int err = 0;
 #ifdef CONFIG_SQUASHFS_COMP_CACHE_FULL
-	struct page **cache_pages = kmalloc_array(page_count,
+	struct folio **cache_folios = kmalloc_array(page_count,
 			sizeof(void *), GFP_KERNEL | __GFP_ZERO);
 #endif
 
-	bio_for_each_segment_all(bv, fullbio, iter_all) {
-		struct page *page = bv->bv_page;
+	bio_for_each_folio_all(fi, fullbio) {
+		struct folio *folio = fi.folio;
 
-		if (page->mapping == cache_mapping) {
+		if (folio->mapping == cache_mapping) {
 			idx++;
 			continue;
 		}
@@ -111,13 +110,13 @@ static int squashfs_bio_read_cached(stru
 		 * adjacent blocks.
 		 */
 		if (idx == 0 && index != read_start)
-			head_to_cache = page;
+			head_to_cache = folio;
 		else if (idx == page_count - 1 && index + length != read_end)
-			tail_to_cache = page;
+			tail_to_cache = folio;
 #ifdef CONFIG_SQUASHFS_COMP_CACHE_FULL
 		/* Cache all pages in the BIO for repeated reads */
-		else if (cache_pages)
-			cache_pages[idx] = page;
+		else if (cache_folios)
+			cache_folios[idx] = folio;
 #endif
 
 		if (!bio || idx != end_idx) {
@@ -150,45 +149,45 @@ static int squashfs_bio_read_cached(stru
 		return err;
 
 	if (head_to_cache) {
-		int ret = add_to_page_cache_lru(head_to_cache, cache_mapping,
+		int ret = filemap_add_folio(cache_mapping, head_to_cache,
 						read_start >> PAGE_SHIFT,
 						GFP_NOIO);
 
 		if (!ret) {
-			SetPageUptodate(head_to_cache);
-			unlock_page(head_to_cache);
+			folio_mark_uptodate(head_to_cache);
+			folio_unlock(head_to_cache);
 		}
 
 	}
 
 	if (tail_to_cache) {
-		int ret = add_to_page_cache_lru(tail_to_cache, cache_mapping,
+		int ret = filemap_add_folio(cache_mapping, tail_to_cache,
 						(read_end >> PAGE_SHIFT) - 1,
 						GFP_NOIO);
 
 		if (!ret) {
-			SetPageUptodate(tail_to_cache);
-			unlock_page(tail_to_cache);
+			folio_mark_uptodate(tail_to_cache);
+			folio_unlock(tail_to_cache);
 		}
 	}
 
 #ifdef CONFIG_SQUASHFS_COMP_CACHE_FULL
-	if (!cache_pages)
+	if (!cache_folios)
 		goto out;
 
 	for (idx = 0; idx < page_count; idx++) {
-		if (!cache_pages[idx])
+		if (!cache_folios[idx])
 			continue;
-		int ret = add_to_page_cache_lru(cache_pages[idx], cache_mapping,
+		int ret = filemap_add_folio(cache_mapping, cache_folios[idx],
 						(read_start >> PAGE_SHIFT) + idx,
 						GFP_NOIO);
 
 		if (!ret) {
-			SetPageUptodate(cache_pages[idx]);
-			unlock_page(cache_pages[idx]);
+			folio_mark_uptodate(cache_folios[idx]);
+			folio_unlock(cache_folios[idx]);
 		}
 	}
-	kfree(cache_pages);
+	kfree(cache_folios);
 out:
 #endif
 	return 0;
_

Patches currently in -mm which might be from willy@infradead.org are

mm-restore-documentation-for-__free_pages.patch
squashfs-pass-the-inode-to-squashfs_readahead_fragment.patch
squashfs-use-folios-in-squashfs_bio_read_cached.patch

