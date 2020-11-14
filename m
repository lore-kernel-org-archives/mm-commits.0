Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6971EC4742C
	for <mm-commits@archiver.kernel.org>; Sat, 14 Nov 2020 01:45:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2865322277
	for <mm-commits@archiver.kernel.org>; Sat, 14 Nov 2020 01:45:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="IcmdFlzb"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726228AbgKNBpb (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 13 Nov 2020 20:45:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:54160 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726081AbgKNBpb (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 13 Nov 2020 20:45:31 -0500
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E78FD22265;
        Sat, 14 Nov 2020 01:45:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605318329;
        bh=4qKxYGPedSapzj3jbhOzAAkXVdP62vsSd47WQnQ98kI=;
        h=Date:From:To:Subject:From;
        b=IcmdFlzbQVbQT6TO1cNYfpeAZQSfOHuMNa3emrUjGqEFqXtS60PNkZZr+RQZqfAXg
         kuF8376p3Uk9H3F9Cp9Ex0L9isCl44yEEcxjbI8DPxvNjAgcrsc+zBYEyyf/ufHt60
         D4DuQQhc4pn+7KnBIBkLEVwgHzNvIJulzT/LJ9jo=
Date:   Fri, 13 Nov 2020 17:45:28 -0800
From:   akpm@linux-foundation.org
To:     dchinner@redhat.com, hannes@cmpxchg.org, hch@lst.de,
        hughd@google.com, jack@suse.cz, kirill.shutemov@linux.intel.com,
        mm-commits@vger.kernel.org, william.kucharski@oracle.com,
        willy@infradead.org, yang.shi@linux.alibaba.com
Subject:  + mm-filemap-add-mapping_seek_hole_data.patch added to
 -mm tree
Message-ID: <20201114014528.gL5X2uMDn%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/filemap: add mapping_seek_hole_data
has been added to the -mm tree.  Its filename is
     mm-filemap-add-mapping_seek_hole_data.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-filemap-add-mapping_seek_hole_data.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-filemap-add-mapping_seek_hole_data.patch

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
Subject: mm/filemap: add mapping_seek_hole_data

Rewrite shmem_seek_hole_data() and move it to filemap.c.

Link: https://lkml.kernel.org/r/20201112212641.27837-8-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: William Kucharski <william.kucharski@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Dave Chinner <dchinner@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Yang Shi <yang.shi@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pagemap.h |    2 +
 mm/filemap.c            |   75 ++++++++++++++++++++++++++++++++++++++
 mm/shmem.c              |   74 ++-----------------------------------
 3 files changed, 81 insertions(+), 70 deletions(-)

--- a/include/linux/pagemap.h~mm-filemap-add-mapping_seek_hole_data
+++ a/include/linux/pagemap.h
@@ -761,6 +761,8 @@ extern void __delete_from_page_cache(str
 int replace_page_cache_page(struct page *old, struct page *new, gfp_t gfp_mask);
 void delete_from_page_cache_batch(struct address_space *mapping,
 				  struct pagevec *pvec);
+loff_t mapping_seek_hole_data(struct address_space *, loff_t start, loff_t end,
+		int whence);
 
 /*
  * Like add_to_page_cache_locked, but used to add newly allocated pages:
--- a/mm/filemap.c~mm-filemap-add-mapping_seek_hole_data
+++ a/mm/filemap.c
@@ -2586,6 +2586,81 @@ out:
 }
 EXPORT_SYMBOL(generic_file_read_iter);
 
+static inline bool page_seek_match(struct page *page, bool seek_data)
+{
+	if (xa_is_value(page) || PageUptodate(page))
+		return seek_data;
+	return !seek_data;
+}
+
+static inline
+unsigned int seek_page_size(struct xa_state *xas, struct page *page)
+{
+	if (xa_is_value(page))
+		return PAGE_SIZE << xa_get_order(xas->xa, xas->xa_index);
+	return thp_size(page);
+}
+
+/**
+ * mapping_seek_hole_data - Seek for SEEK_DATA / SEEK_HOLE in the page cache.
+ * @mapping: Address space to search.
+ * @start: First byte to consider.
+ * @end: Limit of search (exclusive).
+ * @whence: Either SEEK_HOLE or SEEK_DATA.
+ *
+ * If the page cache knows which blocks contain holes and which blocks
+ * contain data, your filesystem can use this function to implement
+ * SEEK_HOLE and SEEK_DATA.  This is useful for filesystems which are
+ * entirely memory-based such as tmpfs, and filesystems which support
+ * unwritten extents.
+ *
+ * Return: The requested offset on successs, or -ENXIO if @whence specifies
+ * SEEK_DATA and there is no data after @start.  There is an implicit hole
+ * after @end - 1, so SEEK_HOLE returns @end if all the bytes between @start
+ * and @end contain data.
+ */
+loff_t mapping_seek_hole_data(struct address_space *mapping, loff_t start,
+		loff_t end, int whence)
+{
+	XA_STATE(xas, &mapping->i_pages, start >> PAGE_SHIFT);
+	pgoff_t max = (end - 1) / PAGE_SIZE;
+	bool seek_data = (whence == SEEK_DATA);
+	struct page *page;
+
+	if (end <= start)
+		return -ENXIO;
+
+	rcu_read_lock();
+	while ((page = find_get_entry(&xas, max, XA_PRESENT))) {
+		loff_t pos = xas.xa_index * PAGE_SIZE;
+
+		if (start < pos) {
+			if (!seek_data)
+				goto unlock;
+			start = pos;
+		}
+
+		if (page_seek_match(page, seek_data))
+			goto unlock;
+		start = pos + seek_page_size(&xas, page);
+		put_page(page);
+	}
+	rcu_read_unlock();
+
+	if (seek_data)
+		return -ENXIO;
+	goto out;
+
+unlock:
+	rcu_read_unlock();
+	if (!xa_is_value(page))
+		put_page(page);
+out:
+	if (start > end)
+		return end;
+	return start;
+}
+
 #ifdef CONFIG_MMU
 #define MMAP_LOTSAMISS  (100)
 /*
--- a/mm/shmem.c~mm-filemap-add-mapping_seek_hole_data
+++ a/mm/shmem.c
@@ -2694,86 +2694,20 @@ static ssize_t shmem_file_read_iter(stru
 	return retval ? retval : error;
 }
 
-/*
- * llseek SEEK_DATA or SEEK_HOLE through the page cache.
- */
-static pgoff_t shmem_seek_hole_data(struct address_space *mapping,
-				    pgoff_t index, pgoff_t end, int whence)
-{
-	struct page *page;
-	struct pagevec pvec;
-	pgoff_t indices[PAGEVEC_SIZE];
-	bool done = false;
-	int i;
-
-	pagevec_init(&pvec);
-	pvec.nr = 1;		/* start small: we may be there already */
-	while (!done) {
-		pvec.nr = find_get_entries(mapping, index,
-					pvec.nr, pvec.pages, indices);
-		if (!pvec.nr) {
-			if (whence == SEEK_DATA)
-				index = end;
-			break;
-		}
-		for (i = 0; i < pvec.nr; i++, index++) {
-			if (index < indices[i]) {
-				if (whence == SEEK_HOLE) {
-					done = true;
-					break;
-				}
-				index = indices[i];
-			}
-			page = pvec.pages[i];
-			if (page && !xa_is_value(page)) {
-				if (!PageUptodate(page))
-					page = NULL;
-			}
-			if (index >= end ||
-			    (page && whence == SEEK_DATA) ||
-			    (!page && whence == SEEK_HOLE)) {
-				done = true;
-				break;
-			}
-		}
-		pagevec_remove_exceptionals(&pvec);
-		pagevec_release(&pvec);
-		pvec.nr = PAGEVEC_SIZE;
-		cond_resched();
-	}
-	return index;
-}
-
 static loff_t shmem_file_llseek(struct file *file, loff_t offset, int whence)
 {
 	struct address_space *mapping = file->f_mapping;
 	struct inode *inode = mapping->host;
-	pgoff_t start, end;
-	loff_t new_offset;
 
 	if (whence != SEEK_DATA && whence != SEEK_HOLE)
 		return generic_file_llseek_size(file, offset, whence,
 					MAX_LFS_FILESIZE, i_size_read(inode));
+	if (offset < 0)
+		return -ENXIO;
+
 	inode_lock(inode);
 	/* We're holding i_mutex so we can access i_size directly */
-
-	if (offset < 0 || offset >= inode->i_size)
-		offset = -ENXIO;
-	else {
-		start = offset >> PAGE_SHIFT;
-		end = (inode->i_size + PAGE_SIZE - 1) >> PAGE_SHIFT;
-		new_offset = shmem_seek_hole_data(mapping, start, end, whence);
-		new_offset <<= PAGE_SHIFT;
-		if (new_offset > offset) {
-			if (new_offset < inode->i_size)
-				offset = new_offset;
-			else if (whence == SEEK_DATA)
-				offset = -ENXIO;
-			else
-				offset = inode->i_size;
-		}
-	}
-
+	offset = mapping_seek_hole_data(mapping, offset, inode->i_size, whence);
 	if (offset >= 0)
 		offset = vfs_setpos(file, offset, MAX_LFS_FILESIZE);
 	inode_unlock(inode);
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

