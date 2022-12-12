Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7AA68C4332F
	for <mm-commits@archiver.kernel.org>; Mon, 12 Dec 2022 02:15:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231294AbiLLCO7 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 11 Dec 2022 21:14:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230420AbiLLCOQ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 11 Dec 2022 21:14:16 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9302ADED6
        for <mm-commits@vger.kernel.org>; Sun, 11 Dec 2022 18:14:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 25C8860EC5
        for <mm-commits@vger.kernel.org>; Mon, 12 Dec 2022 02:14:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7ACCBC433D2;
        Mon, 12 Dec 2022 02:14:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1670811248;
        bh=MNtWeTuYzs51p5HvDXaaJO7x0m4EEHy1+G1H6miDQ6Y=;
        h=Date:To:From:Subject:From;
        b=Mh9DJ3qdxXNZpOSQLyQ4ZVzqnz82OZr5zd8gsmm2x3R3Jh2JJbCXVw9SjBD5CZNX4
         JU3Z5Zs3EhFdQKKyMHpHlhM7FT4L3oEu+uK341u36nKPkJLhb1vSJUoF2+wpKHJ10w
         E/xY0sEIEbHslms0pY9hurNLH0sjOMj7hvnBx5xs=
Date:   Sun, 11 Dec 2022 18:14:07 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        mszeredi@redhat.com, mike.kravetz@oracle.com,
        vishal.moola@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] filemap-convert-replace_page_cache_page-to-replace_page_cache_folio.patch removed from -mm tree
Message-Id: <20221212021408.7ACCBC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: filemap: convert replace_page_cache_page() to replace_page_cache_folio()
has been removed from the -mm tree.  Its filename was
     filemap-convert-replace_page_cache_page-to-replace_page_cache_folio.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
Subject: filemap: convert replace_page_cache_page() to replace_page_cache_folio()
Date: Tue, 1 Nov 2022 10:53:22 -0700

Patch series "Removing the lru_cache_add() wrapper".

This patchset replaces all calls of lru_cache_add() with the folio
equivalent: folio_add_lru().  This is allows us to get rid of the wrapper
The series passes xfstests and the userfaultfd selftests.


This patch (of 5):

Eliminates 7 calls to compound_head().

Link: https://lkml.kernel.org/r/20221101175326.13265-1-vishal.moola@gmail.com
Link: https://lkml.kernel.org/r/20221101175326.13265-2-vishal.moola@gmail.com
Signed-off-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fuse/dev.c           |    2 -
 include/linux/pagemap.h |    2 -
 mm/filemap.c            |   50 ++++++++++++++++++--------------------
 3 files changed, 26 insertions(+), 28 deletions(-)

--- a/fs/fuse/dev.c~filemap-convert-replace_page_cache_page-to-replace_page_cache_folio
+++ a/fs/fuse/dev.c
@@ -837,7 +837,7 @@ static int fuse_try_move_page(struct fus
 	if (WARN_ON(PageMlocked(oldpage)))
 		goto out_fallback_unlock;
 
-	replace_page_cache_page(oldpage, newpage);
+	replace_page_cache_folio(page_folio(oldpage), page_folio(newpage));
 
 	get_page(newpage);
 
--- a/include/linux/pagemap.h~filemap-convert-replace_page_cache_page-to-replace_page_cache_folio
+++ a/include/linux/pagemap.h
@@ -1102,7 +1102,7 @@ int filemap_add_folio(struct address_spa
 		pgoff_t index, gfp_t gfp);
 void filemap_remove_folio(struct folio *folio);
 void __filemap_remove_folio(struct folio *folio, void *shadow);
-void replace_page_cache_page(struct page *old, struct page *new);
+void replace_page_cache_folio(struct folio *old, struct folio *new);
 void delete_from_page_cache_batch(struct address_space *mapping,
 				  struct folio_batch *fbatch);
 bool filemap_release_folio(struct folio *folio, gfp_t gfp);
--- a/mm/filemap.c~filemap-convert-replace_page_cache_page-to-replace_page_cache_folio
+++ a/mm/filemap.c
@@ -788,56 +788,54 @@ int file_write_and_wait_range(struct fil
 EXPORT_SYMBOL(file_write_and_wait_range);
 
 /**
- * replace_page_cache_page - replace a pagecache page with a new one
- * @old:	page to be replaced
- * @new:	page to replace with
+ * replace_page_cache_folio - replace a pagecache folio with a new one
+ * @old:	folio to be replaced
+ * @new:	folio to replace with
  *
- * This function replaces a page in the pagecache with a new one.  On
- * success it acquires the pagecache reference for the new page and
- * drops it for the old page.  Both the old and new pages must be
- * locked.  This function does not add the new page to the LRU, the
+ * This function replaces a folio in the pagecache with a new one.  On
+ * success it acquires the pagecache reference for the new folio and
+ * drops it for the old folio.  Both the old and new folios must be
+ * locked.  This function does not add the new folio to the LRU, the
  * caller must do that.
  *
  * The remove + add is atomic.  This function cannot fail.
  */
-void replace_page_cache_page(struct page *old, struct page *new)
+void replace_page_cache_folio(struct folio *old, struct folio *new)
 {
-	struct folio *fold = page_folio(old);
-	struct folio *fnew = page_folio(new);
 	struct address_space *mapping = old->mapping;
 	void (*free_folio)(struct folio *) = mapping->a_ops->free_folio;
 	pgoff_t offset = old->index;
 	XA_STATE(xas, &mapping->i_pages, offset);
 
-	VM_BUG_ON_PAGE(!PageLocked(old), old);
-	VM_BUG_ON_PAGE(!PageLocked(new), new);
-	VM_BUG_ON_PAGE(new->mapping, new);
+	VM_BUG_ON_FOLIO(!folio_test_locked(old), old);
+	VM_BUG_ON_FOLIO(!folio_test_locked(new), new);
+	VM_BUG_ON_FOLIO(new->mapping, new);
 
-	get_page(new);
+	folio_get(new);
 	new->mapping = mapping;
 	new->index = offset;
 
-	mem_cgroup_migrate(fold, fnew);
+	mem_cgroup_migrate(old, new);
 
 	xas_lock_irq(&xas);
 	xas_store(&xas, new);
 
 	old->mapping = NULL;
 	/* hugetlb pages do not participate in page cache accounting. */
-	if (!PageHuge(old))
-		__dec_lruvec_page_state(old, NR_FILE_PAGES);
-	if (!PageHuge(new))
-		__inc_lruvec_page_state(new, NR_FILE_PAGES);
-	if (PageSwapBacked(old))
-		__dec_lruvec_page_state(old, NR_SHMEM);
-	if (PageSwapBacked(new))
-		__inc_lruvec_page_state(new, NR_SHMEM);
+	if (!folio_test_hugetlb(old))
+		__lruvec_stat_sub_folio(old, NR_FILE_PAGES);
+	if (!folio_test_hugetlb(new))
+		__lruvec_stat_add_folio(new, NR_FILE_PAGES);
+	if (folio_test_swapbacked(old))
+		__lruvec_stat_sub_folio(old, NR_SHMEM);
+	if (folio_test_swapbacked(new))
+		__lruvec_stat_add_folio(new, NR_SHMEM);
 	xas_unlock_irq(&xas);
 	if (free_folio)
-		free_folio(fold);
-	folio_put(fold);
+		free_folio(old);
+	folio_put(old);
 }
-EXPORT_SYMBOL_GPL(replace_page_cache_page);
+EXPORT_SYMBOL_GPL(replace_page_cache_folio);
 
 noinline int __filemap_add_folio(struct address_space *mapping,
 		struct folio *folio, pgoff_t index, gfp_t gfp, void **shadowp)
_

Patches currently in -mm which might be from vishal.moola@gmail.com are


