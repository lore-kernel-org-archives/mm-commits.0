Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14C64C43381
	for <mm-commits@archiver.kernel.org>; Thu, 25 Feb 2021 19:23:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D25EE64F42
	for <mm-commits@archiver.kernel.org>; Thu, 25 Feb 2021 19:23:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234708AbhBYTW5 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 25 Feb 2021 14:22:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:33986 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234761AbhBYTUH (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 25 Feb 2021 14:20:07 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A130064F51;
        Thu, 25 Feb 2021 19:13:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614280391;
        bh=VNy6KbAr6Sb/G0LEYH+OSK3rWvMD/6b2fFVg6g3A1w0=;
        h=Date:From:To:Subject:From;
        b=MHpjMZnYicwdXknBsfrHyXe8iMnTgUlgKgQDM9VRzrh7jVDZ0KhNy0eDZUrE5xc+9
         4HLNXEk4yYKVqXFXxhwOHaITK1rgBWIx3E4eNORR1HQpVRTB/d4cGW3aY7lPsmPoCx
         bXnRQIr6BTPnKC7Her3/qTKGBEfTkBK1tX8R+tAc=
Date:   Thu, 25 Feb 2021 11:13:11 -0800
From:   akpm@linux-foundation.org
To:     hch@lst.de, kent.overstreet@gmail.com, linmiaohe@huawei.com,
        mm-commits@vger.kernel.org, willy@infradead.org
Subject:  [merged] mm-filemap-add-filemap_range_uptodate.patch
 removed from -mm tree
Message-ID: <20210225191311.q3MSLrgHG%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/filemap: add filemap_range_uptodate
has been removed from the -mm tree.  Its filename was
     mm-filemap-add-filemap_range_uptodate.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm/filemap: add filemap_range_uptodate

Move the complicated condition and the calculations out of
filemap_update_page() into its own function.

[willy@infradead.org: unlock page before dropping its refcount]
  Link: https://lkml.kernel.org/r/20210201125229.GO308988@casper.infradead.org
Link: https://lkml.kernel.org/r/20210122160140.223228-14-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Kent Overstreet <kent.overstreet@gmail.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |   65 +++++++++++++++++++++++++++++--------------------
 1 file changed, 39 insertions(+), 26 deletions(-)

--- a/mm/filemap.c~mm-filemap-add-filemap_range_uptodate
+++ a/mm/filemap.c
@@ -2233,11 +2233,36 @@ static int filemap_read_page(struct file
 	return error;
 }
 
+static bool filemap_range_uptodate(struct address_space *mapping,
+		loff_t pos, struct iov_iter *iter, struct page *page)
+{
+	int count;
+
+	if (PageUptodate(page))
+		return true;
+	/* pipes can't handle partially uptodate pages */
+	if (iov_iter_is_pipe(iter))
+		return false;
+	if (!mapping->a_ops->is_partially_uptodate)
+		return false;
+	if (mapping->host->i_blkbits >= (PAGE_SHIFT + thp_order(page)))
+		return false;
+
+	count = iter->count;
+	if (page_offset(page) > pos) {
+		count -= page_offset(page) - pos;
+		pos = 0;
+	} else {
+		pos -= page_offset(page);
+	}
+
+	return mapping->a_ops->is_partially_uptodate(page, pos, count);
+}
+
 static int filemap_update_page(struct kiocb *iocb,
 		struct address_space *mapping, struct iov_iter *iter,
-		struct page *page, loff_t pos, loff_t count)
+		struct page *page)
 {
-	struct inode *inode = mapping->host;
 	int error;
 
 	if (!trylock_page(page)) {
@@ -2254,26 +2279,15 @@ static int filemap_update_page(struct ki
 
 	if (!page->mapping)
 		goto truncated;
-	if (PageUptodate(page))
-		goto uptodate;
-	if (inode->i_blkbits == PAGE_SHIFT ||
-			!mapping->a_ops->is_partially_uptodate)
-		goto readpage;
-	/* pipes can't handle partially uptodate pages */
-	if (unlikely(iov_iter_is_pipe(iter)))
-		goto readpage;
-	if (!mapping->a_ops->is_partially_uptodate(page,
-				pos & (thp_size(page) - 1), count))
-		goto readpage;
-uptodate:
-	unlock_page(page);
-	return 0;
 
-readpage:
-	if (iocb->ki_flags & (IOCB_NOIO | IOCB_NOWAIT | IOCB_WAITQ)) {
-		unlock_page(page);
-		return -EAGAIN;
-	}
+	error = 0;
+	if (filemap_range_uptodate(mapping, iocb->ki_pos, iter, page))
+		goto unlock;
+
+	error = -EAGAIN;
+	if (iocb->ki_flags & (IOCB_NOIO | IOCB_NOWAIT | IOCB_WAITQ))
+		goto unlock;
+
 	error = filemap_read_page(iocb->ki_filp, mapping, page);
 	if (error == AOP_TRUNCATED_PAGE)
 		put_page(page);
@@ -2282,6 +2296,9 @@ truncated:
 	unlock_page(page);
 	put_page(page);
 	return AOP_TRUNCATED_PAGE;
+unlock:
+	unlock_page(page);
+	return error;
 }
 
 static int filemap_create_page(struct file *file,
@@ -2351,9 +2368,6 @@ got_pages:
 	{
 		struct page *page = pvec->pages[pvec->nr - 1];
 		pgoff_t pg_index = page->index;
-		loff_t pg_pos = max(iocb->ki_pos,
-				    (loff_t) pg_index << PAGE_SHIFT);
-		loff_t pg_count = iocb->ki_pos + iter->count - pg_pos;
 
 		if (PageReadahead(page)) {
 			if (iocb->ki_flags & IOCB_NOIO) {
@@ -2370,8 +2384,7 @@ got_pages:
 			if ((iocb->ki_flags & IOCB_WAITQ) &&
 			    pagevec_count(pvec) > 1)
 				iocb->ki_flags |= IOCB_NOWAIT;
-			err = filemap_update_page(iocb, mapping, iter, page,
-					pg_pos, pg_count);
+			err = filemap_update_page(iocb, mapping, iter, page);
 			if (err) {
 				if (err < 0)
 					put_page(page);
_

Patches currently in -mm which might be from willy@infradead.org are

mm-make-pagecache-tagged-lookups-return-only-head-pages.patch
mm-shmem-use-pagevec_lookup-in-shmem_unlock_mapping.patch
mm-swap-optimise-get_shadow_from_swap_cache.patch
mm-add-fgp_entry.patch
mm-filemap-rename-find_get_entry-to-mapping_get_entry.patch
mm-filemap-add-helper-for-finding-pages.patch
mm-filemap-add-helper-for-finding-pages-fix.patch
mm-filemap-add-mapping_seek_hole_data.patch
mm-filemap-add-mapping_seek_hole_data-fix.patch
iomap-use-mapping_seek_hole_data.patch
mm-add-and-use-find_lock_entries.patch
mm-add-and-use-find_lock_entries-fix.patch
mm-add-an-end-parameter-to-find_get_entries.patch
mm-add-an-end-parameter-to-pagevec_lookup_entries.patch
mm-remove-nr_entries-parameter-from-pagevec_lookup_entries.patch
mm-pass-pvec-directly-to-find_get_entries.patch
mm-remove-pagevec_lookup_entries.patch

