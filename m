Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2BEAAC4742C
	for <mm-commits@archiver.kernel.org>; Sat, 14 Nov 2020 01:45:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E4B6C2225D
	for <mm-commits@archiver.kernel.org>; Sat, 14 Nov 2020 01:45:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="ArnTs49x"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726087AbgKNBpV (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 13 Nov 2020 20:45:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:54054 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726081AbgKNBpV (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 13 Nov 2020 20:45:21 -0500
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F111A2225F;
        Sat, 14 Nov 2020 01:45:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605318319;
        bh=pAr5jYJW8DflvGjqpcOHbQ7aI5+Zxyq7OWwDq0QQ4J4=;
        h=Date:From:To:Subject:From;
        b=ArnTs49xPItokT2lPgujQqQcH55HzPHEi2kOhNdY5ny18gcJYe1rsBVr01fxC+222
         FHq8NzxQzEi9a3pL564lp32oLLubI6/I5PV1MesptFbJgDepggGvLWMrN/B5GM/S+T
         A8ZHhBtnSyUuwDDwcxLccNr5niJFK2E3vMTr2fXI=
Date:   Fri, 13 Nov 2020 17:45:18 -0800
From:   akpm@linux-foundation.org
To:     dchinner@redhat.com, hannes@cmpxchg.org, hch@lst.de,
        hughd@google.com, jack@suse.cz, kirill.shutemov@linux.intel.com,
        mm-commits@vger.kernel.org, william.kucharski@oracle.com,
        willy@infradead.org, yang.shi@linux.alibaba.com
Subject:  + mm-add-fgp_entry.patch added to -mm tree
Message-ID: <20201114014518.JUvaqcum6%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: add FGP_ENTRY
has been added to the -mm tree.  Its filename is
     mm-add-fgp_entry.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-add-fgp_entry.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-add-fgp_entry.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: add FGP_ENTRY

The functionality of find_lock_entry() and find_get_entry() can be
provided by pagecache_get_pages(), which lets us delete find_lock_entry()
and make find_get_entry() static.

Link: https://lkml.kernel.org/r/20201112212641.27837-5-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Dave Chinner <dchinner@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: William Kucharski <william.kucharski@oracle.com>
Cc: Yang Shi <yang.shi@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pagemap.h |    1 
 mm/filemap.c            |   44 ++++++--------------------------------
 mm/internal.h           |    3 --
 mm/shmem.c              |    3 +-
 mm/swap_state.c         |    3 +-
 5 files changed, 13 insertions(+), 41 deletions(-)

--- a/include/linux/pagemap.h~mm-add-fgp_entry
+++ a/include/linux/pagemap.h
@@ -315,6 +315,7 @@ pgoff_t page_cache_prev_miss(struct addr
 #define FGP_NOWAIT		0x00000020
 #define FGP_FOR_MMAP		0x00000040
 #define FGP_HEAD		0x00000080
+#define FGP_ENTRY		0x00000100
 
 struct page *pagecache_get_page(struct address_space *mapping, pgoff_t offset,
 		int fgp_flags, gfp_t cache_gfp_mask);
--- a/mm/filemap.c~mm-add-fgp_entry
+++ a/mm/filemap.c
@@ -1662,7 +1662,7 @@ pgoff_t page_cache_prev_miss(struct addr
 }
 EXPORT_SYMBOL(page_cache_prev_miss);
 
-/**
+/*
  * find_get_entry - find and get a page cache entry
  * @mapping: the address_space to search
  * @index: The page cache index.
@@ -1675,7 +1675,7 @@ EXPORT_SYMBOL(page_cache_prev_miss);
  *
  * Return: The head page or shadow entry, %NULL if nothing is found.
  */
-struct page *find_get_entry(struct address_space *mapping, pgoff_t index)
+static struct page *find_get_entry(struct address_space *mapping, pgoff_t index)
 {
 	XA_STATE(xas, &mapping->i_pages, index);
 	struct page *page;
@@ -1712,39 +1712,6 @@ out:
 }
 
 /**
- * find_lock_entry - Locate and lock a page cache entry.
- * @mapping: The address_space to search.
- * @index: The page cache index.
- *
- * Looks up the page at @mapping & @index.  If there is a page in the
- * cache, the head page is returned locked and with an increased refcount.
- *
- * If the slot holds a shadow entry of a previously evicted page, or a
- * swap entry from shmem/tmpfs, it is returned.
- *
- * Context: May sleep.
- * Return: The head page or shadow entry, %NULL if nothing is found.
- */
-struct page *find_lock_entry(struct address_space *mapping, pgoff_t index)
-{
-	struct page *page;
-
-repeat:
-	page = find_get_entry(mapping, index);
-	if (page && !xa_is_value(page)) {
-		lock_page(page);
-		/* Has the page been truncated? */
-		if (unlikely(page->mapping != mapping)) {
-			unlock_page(page);
-			put_page(page);
-			goto repeat;
-		}
-		VM_BUG_ON_PAGE(!thp_contains(page, index), page);
-	}
-	return page;
-}
-
-/**
  * pagecache_get_page - Find and get a reference to a page.
  * @mapping: The address_space to search.
  * @index: The page index.
@@ -1759,6 +1726,8 @@ repeat:
  * * %FGP_LOCK - The page is returned locked.
  * * %FGP_HEAD - If the page is present and a THP, return the head page
  *   rather than the exact page specified by the index.
+ * * %FGP_ENTRY - If there is a shadow / swap / DAX entry, return it
+ *   instead of allocating a new page to replace it.
  * * %FGP_CREAT - If no page is present then a new page is allocated using
  *   @gfp_mask and added to the page cache and the VM's LRU list.
  *   The page is returned locked and with an increased refcount.
@@ -1783,8 +1752,11 @@ struct page *pagecache_get_page(struct a
 
 repeat:
 	page = find_get_entry(mapping, index);
-	if (xa_is_value(page))
+	if (xa_is_value(page)) {
+		if (fgp_flags & FGP_ENTRY)
+			return page;
 		page = NULL;
+	}
 	if (!page)
 		goto no_page;
 
--- a/mm/internal.h~mm-add-fgp_entry
+++ a/mm/internal.h
@@ -60,9 +60,6 @@ static inline void force_page_cache_read
 	force_page_cache_ra(&ractl, &file->f_ra, nr_to_read);
 }
 
-struct page *find_get_entry(struct address_space *mapping, pgoff_t index);
-struct page *find_lock_entry(struct address_space *mapping, pgoff_t index);
-
 /**
  * page_evictable - test whether a page is evictable
  * @page: the page to test
--- a/mm/shmem.c~mm-add-fgp_entry
+++ a/mm/shmem.c
@@ -1831,7 +1831,8 @@ repeat:
 	sbinfo = SHMEM_SB(inode->i_sb);
 	charge_mm = vma ? vma->vm_mm : current->mm;
 
-	page = find_lock_entry(mapping, index);
+	page = pagecache_get_page(mapping, index,
+					FGP_ENTRY | FGP_HEAD | FGP_LOCK, 0);
 	if (xa_is_value(page)) {
 		error = shmem_swapin_page(inode, index, &page,
 					  sgp, gfp, vma, fault_type);
--- a/mm/swap_state.c~mm-add-fgp_entry
+++ a/mm/swap_state.c
@@ -427,7 +427,8 @@ struct page *find_get_incore_page(struct
 {
 	swp_entry_t swp;
 	struct swap_info_struct *si;
-	struct page *page = find_get_entry(mapping, index);
+	struct page *page = pagecache_get_page(mapping, index,
+						FGP_ENTRY | FGP_HEAD, 0);
 
 	if (!page)
 		return page;
_

Patches currently in -mm which might be from willy@infradead.org are

mm-fix-readahead_page_batch-for-retry-entries.patch
mm-fix-madvise-willneed-performance-problem.patch
mm-page-flags-fix-comment.patch
mm-page_alloc-add-__free_pages-documentation.patch
mm-make-pagecache-tagged-lookups-return-only-head-pages.patch
mm-shmem-use-pagevec_lookup-in-shmem_unlock_mapping.patch
mm-swap-optimise-get_shadow_from_swap_cache.patch
mm-add-fgp_entry.patch
mm-filemap-rename-find_get_entry-to-mapping_get_entry.patch
mm-filemap-add-helper-for-finding-pages.patch
mm-filemap-add-mapping_seek_hole_data.patch
iomap-use-mapping_seek_hole_data.patch
mm-add-and-use-find_lock_entries.patch
mm-add-an-end-parameter-to-find_get_entries.patch
mm-add-an-end-parameter-to-pagevec_lookup_entries.patch
mm-remove-nr_entries-parameter-from-pagevec_lookup_entries.patch
mm-pass-pvec-directly-to-find_get_entries.patch
mm-remove-pagevec_lookup_entries.patch
mm-truncateshmem-handle-truncates-that-split-thps.patch
mm-filemap-return-only-head-pages-from-find_get_entries.patch
mm-introduce-memfd_secret-system-call-to-create-secret-memory-areas-fix.patch

