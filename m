Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F053A1494C0
	for <mm-commits@vger.kernel.org>; Tue, 21 May 2024 19:58:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716321497; cv=none; b=XZ16rXVUu0OKQCwCzU/IsMiHu/kI00Bxc6SEO0i6tNmFK4O5yMATWfWGa4IIKulDbAqBLa7kuFFu3jjCxKFZQrmD7eb8Gr564jk/JGNoOZOpvFFVshYQCp1M0LaRtNG7qsxJe/7dHVcLh7/1zxqQrgFzw00NlRVBmTcNsuLc9QM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716321497; c=relaxed/simple;
	bh=XJKay3vUOe3nMmhRbYoEhqZXL9cBreScwQB7+D7HDGI=;
	h=Date:To:From:Subject:Message-Id; b=NTDQMD8CIGr/DaNzpEUhXCE2y4cnEVocAf5yf5M7OZOs6Og3HV0qGPMrbv1b2s+6vYrHf8xXr18J4gHslVcalKk6ZAO8Pbm1pBdX8g4GW6EGE4ZdV/duHRxRWNc6U4fu0ZeOP1jW14jtlzWpj2K+DFZsjyBNGtNLXuMV31ZXXq4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=px+UmYsq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="px+UmYsq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6F2CC2BD11;
	Tue, 21 May 2024 19:58:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1716321496;
	bh=XJKay3vUOe3nMmhRbYoEhqZXL9cBreScwQB7+D7HDGI=;
	h=Date:To:From:Subject:From;
	b=px+UmYsqRYQPffEtMNG4/xNBFbQXIiUbmfd2GHOdf/W7YfvYnRGfLCToLG9cb1GSP
	 0E1a8QSqY/1o9UUaAbu0kbg7JiA7/Vx1zZ3RqQi5jHnKOMfHpaGZx5tBsNbaCyABf6
	 q7bDkgJj3Sw1E1U48NowVRAlS58n/8YK5KrwltVg=
Date: Tue, 21 May 2024 12:58:16 -0700
To: mm-commits@vger.kernel.org,yosryahmed@google.com,ying.huang@intel.com,xiubli@redhat.com,willy@infradead.org,v-songbaohua@oppo.com,trond.myklebust@hammerspace.com,ryan.roberts@arm.com,neilb@suse.de,minchan@kernel.org,marc.dionne@auristor.com,konishi.ryusuke@gmail.com,jlayton@kernel.org,jaegeuk@kernel.org,idryomov@gmail.com,hughd@google.com,dhowells@redhat.com,david@redhat.com,chrisl@kernel.org,chao@kernel.org,anna@kernel.org,kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-drop-page_index-and-simplify-folio_index.patch added to mm-unstable branch
Message-Id: <20240521195816.C6F2CC2BD11@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: drop page_index and simplify folio_index
has been added to the -mm mm-unstable branch.  Its filename is
     mm-drop-page_index-and-simplify-folio_index.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-drop-page_index-and-simplify-folio_index.patch

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
@@ -780,7 +780,7 @@ static inline struct page *grab_cache_pa
 			mapping_gfp_mask(mapping));
 }
 
-#define swapcache_index(folio)	__page_file_index(&(folio)->page)
+extern pgoff_t __folio_swap_cache_index(struct folio *folio);
 
 /**
  * folio_index - File index of a folio.
@@ -795,9 +795,9 @@ static inline struct page *grab_cache_pa
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
@@ -3474,12 +3474,11 @@ struct address_space *swapcache_mapping(
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

f2fs-drop-usage-of-page_index.patch
nilfs2-drop-usage-of-page_index.patch
ceph-drop-usage-of-page_index.patch
nfs-remove-nfs_page_lengthg-and-usage-of-page_index.patch
afs-drop-usage-of-folio_file_pos.patch
netfs-drop-usage-of-folio_file_pos.patch
nfs-drop-usage-of-folio_file_pos.patch
mm-swap-get-the-swap-device-offset-directly.patch
mm-remove-page_file_offset-and-folio_file_pos.patch
mm-drop-page_index-and-simplify-folio_index.patch
mm-swap-reduce-swap-cache-search-space.patch

