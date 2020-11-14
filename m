Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1EC43C63697
	for <mm-commits@archiver.kernel.org>; Sat, 14 Nov 2020 01:45:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DA8A222269
	for <mm-commits@archiver.kernel.org>; Sat, 14 Nov 2020 01:45:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="r4wJfQic"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726248AbgKNBpd (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 13 Nov 2020 20:45:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:54212 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726081AbgKNBpd (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 13 Nov 2020 20:45:33 -0500
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F0A0122267;
        Sat, 14 Nov 2020 01:45:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605318332;
        bh=KwDe9CHSPNPs8yJtqsXHop4g5y7citUYCqqNEEW5vJU=;
        h=Date:From:To:Subject:From;
        b=r4wJfQichri1Bnijiq1Y3NUTPYk1g3oV6SkLcAfZupqdKDpe4/OPmhHTxAUNEIgVg
         gUR7bVLiyQpP2kZ2z1y6wEYRCyrSl3GOsA1i3y4Gu4RqpYSgNz6hxLDVjHclozbyxm
         ZCeeNpuiKB3EwcPV3VVRylN+dtI6HOlYCdcCJt9g=
Date:   Fri, 13 Nov 2020 17:45:31 -0800
From:   akpm@linux-foundation.org
To:     dchinner@redhat.com, hannes@cmpxchg.org, hch@lst.de,
        hughd@google.com, jack@suse.cz, kirill.shutemov@linux.intel.com,
        mm-commits@vger.kernel.org, william.kucharski@oracle.com,
        willy@infradead.org, yang.shi@linux.alibaba.com
Subject:  + iomap-use-mapping_seek_hole_data.patch added to -mm
 tree
Message-ID: <20201114014531.yanDNG7k7%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: iomap: use mapping_seek_hole_data
has been added to the -mm tree.  Its filename is
     iomap-use-mapping_seek_hole_data.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/iomap-use-mapping_seek_hole_data.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/iomap-use-mapping_seek_hole_data.patch

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
@@ -2586,11 +2586,36 @@ out:
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
@@ -2640,9 +2665,11 @@ loff_t mapping_seek_hole_data(struct add
 			start = pos;
 		}
 
-		if (page_seek_match(page, seek_data))
+		pos += seek_page_size(&xas, page);
+		start = page_seek_hole_data(&xas, mapping, page, start, pos,
+				seek_data);
+		if (start < pos)
 			goto unlock;
-		start = pos + seek_page_size(&xas, page);
 		put_page(page);
 	}
 	rcu_read_unlock();
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

