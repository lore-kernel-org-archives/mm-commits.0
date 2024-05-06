Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68A1529D08
	for <mm-commits@vger.kernel.org>; Mon,  6 May 2024 00:58:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714957089; cv=none; b=iX0PuopyHrUDVVgzRMR8bCP3F1zqhwx62Dgg9rFzCjjPJ76FaiVhh2LK35hgdvzFRdDhE7amddJ/CPWQY926yLMO+6a2ZeuvK3+7kxGwXMpVf2CMumOHwvomFTjG3wri7GRo5pohWnwpJdKgWvIlbZ1n4QprSlq4Lx2Mzr49qbI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714957089; c=relaxed/simple;
	bh=Wv6COqF6CN0TVGRUX7UY2ocntGlwdNwJ49nEofU+jrQ=;
	h=Date:To:From:Subject:Message-Id; b=B6kMW/fvo8iJ6dl6JWcYJ9cLae5ps4aSGbNxgPtYdiTSXyz290sT9E0qh+sr9+r+I4fn9QwIeeWFvLYlb0OeGExT9l2eM/SSS7QLG4YvkNXCOlhPOmW9a8vvXMCslsKgINBbFFPrFIPdJ+/FelMBTAYNHV4wrGCGwljIaip0tmk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=WlAfKxrR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="WlAfKxrR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DA36C116B1;
	Mon,  6 May 2024 00:58:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714957089;
	bh=Wv6COqF6CN0TVGRUX7UY2ocntGlwdNwJ49nEofU+jrQ=;
	h=Date:To:From:Subject:From;
	b=WlAfKxrRc81RiPCbaoP6cnHTcX233MSqPWj7Ki1CQPGAHzWO+wglKCuOIGPzs5mVr
	 VatbNhyYHLm+ZJtgyHWIX665qOF1pX/H6gK2oZep0xxc3uoafq6oOCrEga6rMH1h5N
	 CQKU5JE7j2rR+nCF1GLSBRYBynpXWAIWagaSQlFU=
Date: Sun, 05 May 2024 17:58:08 -0700
To: mm-commits@vger.kernel.org,osalvador@suse.de,linmiaohe@huawei.com,jane.chu@oracle.com,dan.j.williams@intel.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-convert-hugetlb_page_mapping_lock_write-to-folio.patch removed from -mm tree
Message-Id: <20240506005809.3DA36C116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: convert hugetlb_page_mapping_lock_write to folio
has been removed from the -mm tree.  Its filename was
     mm-convert-hugetlb_page_mapping_lock_write-to-folio.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: convert hugetlb_page_mapping_lock_write to folio
Date: Fri, 12 Apr 2024 20:35:03 +0100

The page is only used to get the mapping, so the folio will do just as
well.  Both callers already have a folio available, so this saves a call
to compound_head().

Link: https://lkml.kernel.org/r/20240412193510.2356957-7-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Jane Chu  <jane.chu@oracle.com>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Acked-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/hugetlb.h |    6 +++---
 mm/hugetlb.c            |    6 +++---
 mm/memory-failure.c     |    2 +-
 mm/migrate.c            |    2 +-
 4 files changed, 8 insertions(+), 8 deletions(-)

--- a/include/linux/hugetlb.h~mm-convert-hugetlb_page_mapping_lock_write-to-folio
+++ a/include/linux/hugetlb.h
@@ -178,7 +178,7 @@ bool hugetlbfs_pagecache_present(struct
 				 struct vm_area_struct *vma,
 				 unsigned long address);
 
-struct address_space *hugetlb_page_mapping_lock_write(struct page *hpage);
+struct address_space *hugetlb_folio_mapping_lock_write(struct folio *folio);
 
 extern int sysctl_hugetlb_shm_group;
 extern struct list_head huge_boot_pages[MAX_NUMNODES];
@@ -297,8 +297,8 @@ static inline unsigned long hugetlb_tota
 	return 0;
 }
 
-static inline struct address_space *hugetlb_page_mapping_lock_write(
-							struct page *hpage)
+static inline struct address_space *hugetlb_folio_mapping_lock_write(
+							struct folio *folio)
 {
 	return NULL;
 }
--- a/mm/hugetlb.c~mm-convert-hugetlb_page_mapping_lock_write-to-folio
+++ a/mm/hugetlb.c
@@ -2155,13 +2155,13 @@ static bool prep_compound_gigantic_folio
 /*
  * Find and lock address space (mapping) in write mode.
  *
- * Upon entry, the page is locked which means that page_mapping() is
+ * Upon entry, the folio is locked which means that folio_mapping() is
  * stable.  Due to locking order, we can only trylock_write.  If we can
  * not get the lock, simply return NULL to caller.
  */
-struct address_space *hugetlb_page_mapping_lock_write(struct page *hpage)
+struct address_space *hugetlb_folio_mapping_lock_write(struct folio *folio)
 {
-	struct address_space *mapping = page_mapping(hpage);
+	struct address_space *mapping = folio_mapping(folio);
 
 	if (!mapping)
 		return mapping;
--- a/mm/memory-failure.c~mm-convert-hugetlb_page_mapping_lock_write-to-folio
+++ a/mm/memory-failure.c
@@ -1624,7 +1624,7 @@ static bool hwpoison_user_mappings(struc
 		 * TTU_RMAP_LOCKED to indicate we have taken the lock
 		 * at this higher level.
 		 */
-		mapping = hugetlb_page_mapping_lock_write(hpage);
+		mapping = hugetlb_folio_mapping_lock_write(folio);
 		if (mapping) {
 			try_to_unmap(folio, ttu|TTU_RMAP_LOCKED);
 			i_mmap_unlock_write(mapping);
--- a/mm/migrate.c~mm-convert-hugetlb_page_mapping_lock_write-to-folio
+++ a/mm/migrate.c
@@ -1425,7 +1425,7 @@ static int unmap_and_move_huge_page(new_
 			 * semaphore in write mode here and set TTU_RMAP_LOCKED
 			 * to let lower levels know we have taken the lock.
 			 */
-			mapping = hugetlb_page_mapping_lock_write(&src->page);
+			mapping = hugetlb_folio_mapping_lock_write(src);
 			if (unlikely(!mapping))
 				goto unlock_put_anon;
 
_

Patches currently in -mm which might be from willy@infradead.org are

squashfs-convert-squashfs_symlink_read_folio-to-use-folio-apis.patch
squashfs-remove-calls-to-set-the-folio-error-flag.patch
nilfs2-remove-calls-to-folio_set_error-and-folio_clear_error.patch

