Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1CAF1C433E6
	for <mm-commits@archiver.kernel.org>; Fri, 26 Feb 2021 01:16:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C1F8B64F24
	for <mm-commits@archiver.kernel.org>; Fri, 26 Feb 2021 01:16:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229556AbhBZBQT (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 25 Feb 2021 20:16:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:47954 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229508AbhBZBQS (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 25 Feb 2021 20:16:18 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 51D5764EDC;
        Fri, 26 Feb 2021 01:15:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614302137;
        bh=8lZ4OC8zIErX0CHe+/2dPFmBWQNT9SRfeJzRSD3whOE=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=wvCo83N6l5mQeDyiectWWh7g2M+rbmajehkNqnJolGu60Anqyf71lZMIGdxsP7q5u
         zM5NFSqt2J0W70M/83wB+WLfCRo6eTr6Fubor1U2oycGdZjNje9M2jZNuEdx0aGfMX
         VduCuVoUke7U5B7BLm+AZw4YYzDScMX9l5UAmLBg=
Date:   Thu, 25 Feb 2021 17:15:36 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, dchinner@redhat.com, hannes@cmpxchg.org,
        hch@lst.de, hughd@google.com, jack@suse.cz,
        kirill.shutemov@linux.intel.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        william.kucharski@oracle.com, willy@infradead.org,
        yang.shi@linux.alibaba.com
Subject:  [patch 004/118] mm: add FGP_ENTRY
Message-ID: <20210226011536.YFTPl8PHT%akpm@linux-foundation.org>
In-Reply-To: <20210225171452.713967e96554bb6a53e44a19@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: add FGP_ENTRY

The functionality of find_lock_entry() and find_get_entry() can be
provided by pagecache_get_page(), which lets us delete find_lock_entry()
and make find_get_entry() static.

Link: https://lkml.kernel.org/r/20201112212641.27837-5-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
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
@@ -1658,7 +1658,7 @@ pgoff_t page_cache_prev_miss(struct addr
 }
 EXPORT_SYMBOL(page_cache_prev_miss);
 
-/**
+/*
  * find_get_entry - find and get a page cache entry
  * @mapping: the address_space to search
  * @index: The page cache index.
@@ -1671,7 +1671,7 @@ EXPORT_SYMBOL(page_cache_prev_miss);
  *
  * Return: The head page or shadow entry, %NULL if nothing is found.
  */
-struct page *find_get_entry(struct address_space *mapping, pgoff_t index)
+static struct page *find_get_entry(struct address_space *mapping, pgoff_t index)
 {
 	XA_STATE(xas, &mapping->i_pages, index);
 	struct page *page;
@@ -1708,39 +1708,6 @@ out:
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
@@ -1755,6 +1722,8 @@ repeat:
  * * %FGP_LOCK - The page is returned locked.
  * * %FGP_HEAD - If the page is present and a THP, return the head page
  *   rather than the exact page specified by the index.
+ * * %FGP_ENTRY - If there is a shadow / swap / DAX entry, return it
+ *   instead of allocating a new page to replace it.
  * * %FGP_CREAT - If no page is present then a new page is allocated using
  *   @gfp_mask and added to the page cache and the VM's LRU list.
  *   The page is returned locked and with an increased refcount.
@@ -1779,8 +1748,11 @@ struct page *pagecache_get_page(struct a
 
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
@@ -1812,7 +1812,8 @@ repeat:
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
@@ -403,7 +403,8 @@ struct page *find_get_incore_page(struct
 {
 	swp_entry_t swp;
 	struct swap_info_struct *si;
-	struct page *page = find_get_entry(mapping, index);
+	struct page *page = pagecache_get_page(mapping, index,
+						FGP_ENTRY | FGP_HEAD, 0);
 
 	if (!page)
 		return page;
_
