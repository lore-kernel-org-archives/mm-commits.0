Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E17CC433E6
	for <mm-commits@archiver.kernel.org>; Sat, 27 Feb 2021 02:29:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3BFD264F3D
	for <mm-commits@archiver.kernel.org>; Sat, 27 Feb 2021 02:29:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229993AbhB0C32 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 26 Feb 2021 21:29:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:51002 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229912AbhB0C31 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 26 Feb 2021 21:29:27 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8FF2464F21;
        Sat, 27 Feb 2021 02:28:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614392901;
        bh=IPyaboRfBkI3r76RQDbNwoy61wLe0WnfodyJ/m0fpHs=;
        h=Date:From:To:Subject:From;
        b=mZ6lXyArJh8fhCLHRoB33DWGnkoxOFm1RXGP33bKoW9TUgF4r9QPHFedTaSOA74mZ
         vF/nxnuGSzfwwUwE/nMSx/J/B1XKjAZNsp7RnxBUVEVB1GPgnNABb3tdoDgH33huTY
         13nZWdvgkattZsFTFyFrNrF2XciW58MBtvNsyZow=
Date:   Fri, 26 Feb 2021 18:28:21 -0800
From:   akpm@linux-foundation.org
To:     dchinner@redhat.com, hannes@cmpxchg.org, hch@lst.de,
        hughd@google.com, jack@suse.cz, kirill.shutemov@linux.intel.com,
        mm-commits@vger.kernel.org, william.kucharski@oracle.com,
        willy@infradead.org, yang.shi@linux.alibaba.com
Subject:  [merged] mm-filemap-add-mapping_seek_hole_data.patch
 removed from -mm tree
Message-ID: <20210227022821.Zh96Y1oX7%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/filemap: add mapping_seek_hole_data
has been removed from the -mm tree.  Its filename was
     mm-filemap-add-mapping_seek_hole_data.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm/filemap: add mapping_seek_hole_data

Rewrite shmem_seek_hole_data() and move it to filemap.c.

[willy@infradead.org: don't put an xa_is_value() page]
  Link: https://lkml.kernel.org/r/20201124041507.28996-4-willy@infradead.org
Link: https://lkml.kernel.org/r/20201112212641.27837-8-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: William Kucharski <william.kucharski@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Cc: Dave Chinner <dchinner@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Yang Shi <yang.shi@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pagemap.h |    2 +
 mm/filemap.c            |   76 ++++++++++++++++++++++++++++++++++++++
 mm/shmem.c              |   74 ++-----------------------------------
 3 files changed, 82 insertions(+), 70 deletions(-)

--- a/include/linux/pagemap.h~mm-filemap-add-mapping_seek_hole_data
+++ a/include/linux/pagemap.h
@@ -760,6 +760,8 @@ extern void __delete_from_page_cache(str
 void replace_page_cache_page(struct page *old, struct page *new);
 void delete_from_page_cache_batch(struct address_space *mapping,
 				  struct pagevec *pvec);
+loff_t mapping_seek_hole_data(struct address_space *, loff_t start, loff_t end,
+		int whence);
 
 /*
  * Like add_to_page_cache_locked, but used to add newly allocated pages:
--- a/mm/filemap.c~mm-filemap-add-mapping_seek_hole_data
+++ a/mm/filemap.c
@@ -2553,6 +2553,82 @@ generic_file_read_iter(struct kiocb *ioc
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
+		if (!xa_is_value(page))
+			put_page(page);
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
@@ -2668,86 +2668,20 @@ static ssize_t shmem_file_read_iter(stru
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


