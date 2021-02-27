Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83940C433E9
	for <mm-commits@archiver.kernel.org>; Sat, 27 Feb 2021 02:29:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5467A64F40
	for <mm-commits@archiver.kernel.org>; Sat, 27 Feb 2021 02:29:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229912AbhB0C33 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 26 Feb 2021 21:29:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:51006 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229707AbhB0C32 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 26 Feb 2021 21:29:28 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 914B464F24;
        Sat, 27 Feb 2021 02:28:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614392904;
        bh=9wR9CHiu/iWdP1eilvoEy0y3thrMVAUYSdW+VcFhCKY=;
        h=Date:From:To:Subject:From;
        b=cM6dDAAhQOfGbO7Icqpz0DaPzHvVlGtTrKD7oilCUvja9OgMPN42O5q+u3pK2SGa8
         rWRjon9xuLHWASosE4wG6Px/EYRd5DdGDA/14oryaPD/9uoEFmDtNz50UG2ux1aX3f
         ztPjr31c/g/FHvOVpXTdBkpwvvQvLh6lygffeRik=
Date:   Fri, 26 Feb 2021 18:28:24 -0800
From:   akpm@linux-foundation.org
To:     dchinner@redhat.com, hannes@cmpxchg.org, hch@lst.de,
        hughd@google.com, jack@suse.cz, kirill.shutemov@linux.intel.com,
        mm-commits@vger.kernel.org, william.kucharski@oracle.com,
        willy@infradead.org, yang.shi@linux.alibaba.com
Subject:  [merged] iomap-use-mapping_seek_hole_data.patch removed
 from -mm tree
Message-ID: <20210227022824.O966yCMOK%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: iomap: use mapping_seek_hole_data
has been removed from the -mm tree.  Its filename was
     iomap-use-mapping_seek_hole_data.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: iomap: use mapping_seek_hole_data

Enhance mapping_seek_hole_data() to handle partially uptodate pages and
convert the iomap seek code to call it.

Link: https://lkml.kernel.org/r/20201112212641.27837-9-willy@infradead.org
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

 fs/iomap/seek.c |  125 ++++------------------------------------------
 mm/filemap.c    |   37 +++++++++++--
 2 files changed, 43 insertions(+), 119 deletions(-)

--- a/fs/iomap/seek.c~iomap-use-mapping_seek_hole_data
+++ a/fs/iomap/seek.c
@@ -10,122 +10,17 @@
 #include <linux/pagemap.h>
 #include <linux/pagevec.h>
 
-/*
- * Seek for SEEK_DATA / SEEK_HOLE within @page, starting at @lastoff.
- * Returns true if found and updates @lastoff to the offset in file.
- */
-static bool
-page_seek_hole_data(struct inode *inode, struct page *page, loff_t *lastoff,
-		int whence)
-{
-	const struct address_space_operations *ops = inode->i_mapping->a_ops;
-	unsigned int bsize = i_blocksize(inode), off;
-	bool seek_data = whence == SEEK_DATA;
-	loff_t poff = page_offset(page);
-
-	if (WARN_ON_ONCE(*lastoff >= poff + PAGE_SIZE))
-		return false;
-
-	if (*lastoff < poff) {
-		/*
-		 * Last offset smaller than the start of the page means we found
-		 * a hole:
-		 */
-		if (whence == SEEK_HOLE)
-			return true;
-		*lastoff = poff;
-	}
-
-	/*
-	 * Just check the page unless we can and should check block ranges:
-	 */
-	if (bsize == PAGE_SIZE || !ops->is_partially_uptodate)
-		return PageUptodate(page) == seek_data;
-
-	lock_page(page);
-	if (unlikely(page->mapping != inode->i_mapping))
-		goto out_unlock_not_found;
-
-	for (off = 0; off < PAGE_SIZE; off += bsize) {
-		if (offset_in_page(*lastoff) >= off + bsize)
-			continue;
-		if (ops->is_partially_uptodate(page, off, bsize) == seek_data) {
-			unlock_page(page);
-			return true;
-		}
-		*lastoff = poff + off + bsize;
-	}
-
-out_unlock_not_found:
-	unlock_page(page);
-	return false;
-}
-
-/*
- * Seek for SEEK_DATA / SEEK_HOLE in the page cache.
- *
- * Within unwritten extents, the page cache determines which parts are holes
- * and which are data: uptodate buffer heads count as data; everything else
- * counts as a hole.
- *
- * Returns the resulting offset on successs, and -ENOENT otherwise.
- */
-static loff_t
-page_cache_seek_hole_data(struct inode *inode, loff_t offset, loff_t length,
-		int whence)
-{
-	pgoff_t index = offset >> PAGE_SHIFT;
-	pgoff_t end = DIV_ROUND_UP(offset + length, PAGE_SIZE);
-	loff_t lastoff = offset;
-	struct pagevec pvec;
-
-	if (length <= 0)
-		return -ENOENT;
-
-	pagevec_init(&pvec);
-
-	do {
-		unsigned nr_pages, i;
-
-		nr_pages = pagevec_lookup_range(&pvec, inode->i_mapping, &index,
-						end - 1);
-		if (nr_pages == 0)
-			break;
-
-		for (i = 0; i < nr_pages; i++) {
-			struct page *page = pvec.pages[i];
-
-			if (page_seek_hole_data(inode, page, &lastoff, whence))
-				goto check_range;
-			lastoff = page_offset(page) + PAGE_SIZE;
-		}
-		pagevec_release(&pvec);
-	} while (index < end);
-
-	/* When no page at lastoff and we are not done, we found a hole. */
-	if (whence != SEEK_HOLE)
-		goto not_found;
-
-check_range:
-	if (lastoff < offset + length)
-		goto out;
-not_found:
-	lastoff = -ENOENT;
-out:
-	pagevec_release(&pvec);
-	return lastoff;
-}
-
-
 static loff_t
-iomap_seek_hole_actor(struct inode *inode, loff_t offset, loff_t length,
+iomap_seek_hole_actor(struct inode *inode, loff_t start, loff_t length,
 		      void *data, struct iomap *iomap, struct iomap *srcmap)
 {
+	loff_t offset = start;
+
 	switch (iomap->type) {
 	case IOMAP_UNWRITTEN:
-		offset = page_cache_seek_hole_data(inode, offset, length,
-						   SEEK_HOLE);
-		if (offset < 0)
+		offset = mapping_seek_hole_data(inode->i_mapping, start,
+				start + length, SEEK_HOLE);
+		if (offset == start + length)
 			return length;
 		fallthrough;
 	case IOMAP_HOLE:
@@ -164,15 +59,17 @@ iomap_seek_hole(struct inode *inode, lof
 EXPORT_SYMBOL_GPL(iomap_seek_hole);
 
 static loff_t
-iomap_seek_data_actor(struct inode *inode, loff_t offset, loff_t length,
+iomap_seek_data_actor(struct inode *inode, loff_t start, loff_t length,
 		      void *data, struct iomap *iomap, struct iomap *srcmap)
 {
+	loff_t offset = start;
+
 	switch (iomap->type) {
 	case IOMAP_HOLE:
 		return length;
 	case IOMAP_UNWRITTEN:
-		offset = page_cache_seek_hole_data(inode, offset, length,
-						   SEEK_DATA);
+		offset = mapping_seek_hole_data(inode->i_mapping, start,
+				start + length, SEEK_DATA);
 		if (offset < 0)
 			return length;
 		fallthrough;
--- a/mm/filemap.c~iomap-use-mapping_seek_hole_data
+++ a/mm/filemap.c
@@ -2553,11 +2553,36 @@ generic_file_read_iter(struct kiocb *ioc
 }
 EXPORT_SYMBOL(generic_file_read_iter);
 
-static inline bool page_seek_match(struct page *page, bool seek_data)
+static inline loff_t page_seek_hole_data(struct xa_state *xas,
+		struct address_space *mapping, struct page *page,
+		loff_t start, loff_t end, bool seek_data)
 {
+	const struct address_space_operations *ops = mapping->a_ops;
+	size_t offset, bsz = i_blocksize(mapping->host);
+
 	if (xa_is_value(page) || PageUptodate(page))
-		return seek_data;
-	return !seek_data;
+		return seek_data ? start : end;
+	if (!ops->is_partially_uptodate)
+		return seek_data ? end : start;
+
+	xas_pause(xas);
+	rcu_read_unlock();
+	lock_page(page);
+	if (unlikely(page->mapping != mapping))
+		goto unlock;
+
+	offset = offset_in_thp(page, start) & ~(bsz - 1);
+
+	do {
+		if (ops->is_partially_uptodate(page, offset, bsz) == seek_data)
+			break;
+		start = (start + bsz) & ~(bsz - 1);
+		offset += bsz;
+	} while (offset < thp_size(page));
+unlock:
+	unlock_page(page);
+	rcu_read_lock();
+	return start;
 }
 
 static inline
@@ -2607,9 +2632,11 @@ loff_t mapping_seek_hole_data(struct add
 			start = pos;
 		}
 
-		if (page_seek_match(page, seek_data))
+		pos += seek_page_size(&xas, page);
+		start = page_seek_hole_data(&xas, mapping, page, start, pos,
+				seek_data);
+		if (start < pos)
 			goto unlock;
-		start = pos + seek_page_size(&xas, page);
 		if (!xa_is_value(page))
 			put_page(page);
 	}
_

Patches currently in -mm which might be from willy@infradead.org are


