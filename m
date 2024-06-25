Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D7FB13CF9E
	for <mm-commits@vger.kernel.org>; Tue, 25 Jun 2024 04:59:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719291559; cv=none; b=WrlYXlgCQNSOkc5b9vTl4rADQLl2HAnFI+l9geuxdl3wc9yEfx97zrLnwZrKSeUNMOxMVMwExPd+QDMtaewnruE9TrGmdXQVhZwlJQJtCw1/pOoFDF4YzgvcHXRRhwLkC4L810JqkUeitdKOmoGKH2bjAGyfqqPxve7LxbyjWCA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719291559; c=relaxed/simple;
	bh=LLnIEubOxDhPI+KNgKu6IwVDoUrfjwf8Kx15JIWnMyk=;
	h=Date:To:From:Subject:Message-Id; b=VNDHdPmGETufkpfrWoEtkf7oeneFkfH2eFT8oV/FxMS2gBzxCvirGj9bL7u3YQ92OfCWxCZ3nDTcx8Kd2C1CgmeKRUeSIdMkR1eKcYSLZjfB/rIOGfx/X1GajmZ+9a8OFFqrJ6kkIHWpjtfIuA/GyTdOSf42nX5Ra8SkByCRrlY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=x9Uw7l6o; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="x9Uw7l6o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF1A7C32782;
	Tue, 25 Jun 2024 04:59:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719291559;
	bh=LLnIEubOxDhPI+KNgKu6IwVDoUrfjwf8Kx15JIWnMyk=;
	h=Date:To:From:Subject:From;
	b=x9Uw7l6occ+IrfZyQB5LS2Nj82LFDyo/hEfDtL6MTNoVtB09et3P8ZS1JNO7ZjEUh
	 pkbgFQ7BwtHKfvG1lTVfetoNwjjN3aZkFsj6neZZD9bQ30IOyuTjesg9VNvW+3Us5C
	 wmJX1+/cA5BHr6s0IwNNt5IzI2m79kUcM+3fNQe8=
Date: Mon, 24 Jun 2024 21:59:18 -0700
To: mm-commits@vger.kernel.org,yosryahmed@google.com,ying.huang@intel.com,xiubli@redhat.com,willy@infradead.org,v-songbaohua@oppo.com,trond.myklebust@hammerspace.com,ryan.roberts@arm.com,neilb@suse.de,minchan@kernel.org,marc.dionne@auristor.com,konishi.ryusuke@gmail.com,jlayton@kernel.org,jaegeuk@kernel.org,idryomov@gmail.com,hughd@google.com,dhowells@redhat.com,david@redhat.com,chrisl@kernel.org,chao@kernel.org,anna@kernel.org,kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-drop-page_index-and-simplify-folio_index.patch removed from -mm tree
Message-Id: <20240625045918.EF1A7C32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: drop page_index and simplify folio_index
has been removed from the -mm tree.  Its filename was
     mm-drop-page_index-and-simplify-folio_index.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kairui Song <kasong@tencent.com>
Subject: mm: drop page_index and simplify folio_index
Date: Wed, 22 May 2024 01:58:52 +0800

There are two helpers for retrieving the index within address space for
mixed usage of swap cache and page cache:

- page_index
- folio_index

This commit drops page_index, as we have eliminated all users, and
converts folio_index's helper __page_file_index to use folio to avoid the
page conversion.

Link: https://lkml.kernel.org/r/20240521175854.96038-11-ryncsn@gmail.com
Signed-off-by: Kairui Song <kasong@tencent.com>
Reviewed-by: "Huang, Ying" <ying.huang@intel.com>
Cc: Anna Schumaker <anna@kernel.org>
Cc: Barry Song <v-songbaohua@oppo.com>
Cc: Chao Yu <chao@kernel.org>
Cc: Chris Li <chrisl@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Ilya Dryomov <idryomov@gmail.com>
Cc: Jaegeuk Kim <jaegeuk@kernel.org>
Cc: Jeff Layton <jlayton@kernel.org>
Cc: Marc Dionne <marc.dionne@auristor.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: NeilBrown <neilb@suse.de>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Cc: Trond Myklebust <trond.myklebust@hammerspace.com>
Cc: Xiubo Li <xiubli@redhat.com>
Cc: Yosry Ahmed <yosryahmed@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h      |   13 -------------
 include/linux/pagemap.h |    8 ++++----
 mm/swapfile.c           |    7 +++----
 3 files changed, 7 insertions(+), 21 deletions(-)

--- a/include/linux/mm.h~mm-drop-page_index-and-simplify-folio_index
+++ a/include/linux/mm.h
@@ -2290,19 +2290,6 @@ static inline void *folio_address(const
 	return page_address(&folio->page);
 }
 
-extern pgoff_t __page_file_index(struct page *page);
-
-/*
- * Return the pagecache index of the passed page.  Regular pagecache pages
- * use ->index whereas swapcache pages use swp_offset(->private)
- */
-static inline pgoff_t page_index(struct page *page)
-{
-	if (unlikely(PageSwapCache(page)))
-		return __page_file_index(page);
-	return page->index;
-}
-
 /*
  * Return true only if the page has been allocated with
  * ALLOC_NO_WATERMARKS and the low watermark was not
--- a/include/linux/pagemap.h~mm-drop-page_index-and-simplify-folio_index
+++ a/include/linux/pagemap.h
@@ -792,7 +792,7 @@ static inline struct page *grab_cache_pa
 			mapping_gfp_mask(mapping));
 }
 
-#define swapcache_index(folio)	__page_file_index(&(folio)->page)
+extern pgoff_t __folio_swap_cache_index(struct folio *folio);
 
 /**
  * folio_index - File index of a folio.
@@ -807,9 +807,9 @@ static inline struct page *grab_cache_pa
  */
 static inline pgoff_t folio_index(struct folio *folio)
 {
-        if (unlikely(folio_test_swapcache(folio)))
-                return swapcache_index(folio);
-        return folio->index;
+	if (unlikely(folio_test_swapcache(folio)))
+		return __folio_swap_cache_index(folio);
+	return folio->index;
 }
 
 /**
--- a/mm/swapfile.c~mm-drop-page_index-and-simplify-folio_index
+++ a/mm/swapfile.c
@@ -3449,12 +3449,11 @@ struct address_space *swapcache_mapping(
 }
 EXPORT_SYMBOL_GPL(swapcache_mapping);
 
-pgoff_t __page_file_index(struct page *page)
+pgoff_t __folio_swap_cache_index(struct folio *folio)
 {
-	swp_entry_t swap = page_swap_entry(page);
-	return swp_offset(swap);
+	return swp_offset(folio->swap);
 }
-EXPORT_SYMBOL_GPL(__page_file_index);
+EXPORT_SYMBOL_GPL(__folio_swap_cache_index);
 
 /*
  * add_swap_count_continuation - called when a swap count is duplicated
_

Patches currently in -mm which might be from kasong@tencent.com are


