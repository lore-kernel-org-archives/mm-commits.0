Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64620C25B6B
	for <mm-commits@archiver.kernel.org>; Wed, 25 Oct 2023 23:48:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232348AbjJYXsM (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 25 Oct 2023 19:48:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231225AbjJYXsE (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 25 Oct 2023 19:48:04 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27119194
        for <mm-commits@vger.kernel.org>; Wed, 25 Oct 2023 16:47:57 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6163C433CB;
        Wed, 25 Oct 2023 23:47:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1698277677;
        bh=s8a7YPL4PDdeXFCjfKVWxo/HDJqtHjlv6Ig/a0El+7Q=;
        h=Date:To:From:Subject:From;
        b=oDLTKyI4RkHuwyCBGkjggZtIBssoUr1zUW/B4n1gczRGvfWGVhiV7/+J2utLxH1/L
         f4GBGdVoslXC+HeHWquL7EEpmNlEiD6X/ndsQg0m3YYqfj19J2JyxyBoU4/lt9NWC+
         5REs7r6lkP6at9JWB7MvGVuGhWDE7Ef3326p/qVI=
Date:   Wed, 25 Oct 2023 16:47:56 -0700
To:     mm-commits@vger.kernel.org, p.raghav@samsung.com,
        konishi.ryusuke@gmail.com, agruenba@redhat.com,
        willy@infradead.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] gfs2-convert-gfs2_write_buf_to_page-to-use-a-folio.patch removed from -mm tree
Message-Id: <20231025234756.E6163C433CB@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: gfs2: convert gfs2_write_buf_to_page() to use a folio
has been removed from the -mm tree.  Its filename was
     gfs2-convert-gfs2_write_buf_to_page-to-use-a-folio.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: gfs2: convert gfs2_write_buf_to_page() to use a folio
Date: Mon, 16 Oct 2023 21:10:56 +0100

Remove several folio->page->folio conversions.

Link: https://lkml.kernel.org/r/20231016201114.1928083-10-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Andreas Gruenbacher <agruenba@redhat.com>
Cc: Pankaj Raghav <p.raghav@samsung.com>
Cc: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/gfs2/quota.c |   39 ++++++++++++++++++++-------------------
 1 file changed, 20 insertions(+), 19 deletions(-)

--- a/fs/gfs2/quota.c~gfs2-convert-gfs2_write_buf_to_page-to-use-a-folio
+++ a/fs/gfs2/quota.c
@@ -749,7 +749,7 @@ static int gfs2_write_buf_to_page(struct
 	struct gfs2_inode *ip = GFS2_I(sdp->sd_quota_inode);
 	struct inode *inode = &ip->i_inode;
 	struct address_space *mapping = inode->i_mapping;
-	struct page *page;
+	struct folio *folio;
 	struct buffer_head *bh;
 	u64 blk;
 	unsigned bsize = sdp->sd_sb.sb_bsize, bnum = 0, boff = 0;
@@ -758,15 +758,15 @@ static int gfs2_write_buf_to_page(struct
 	blk = index << (PAGE_SHIFT - sdp->sd_sb.sb_bsize_shift);
 	boff = off % bsize;
 
-	page = grab_cache_page(mapping, index);
-	if (!page)
-		return -ENOMEM;
-	if (!page_has_buffers(page))
-		create_empty_buffers(page, bsize, 0);
-
-	bh = page_buffers(page);
-	for(;;) {
-		/* Find the beginning block within the page */
+	folio = filemap_grab_folio(mapping, index);
+	if (IS_ERR(folio))
+		return PTR_ERR(folio);
+	bh = folio_buffers(folio);
+	if (!bh)
+		bh = folio_create_empty_buffers(folio, bsize, 0);
+
+	for (;;) {
+		/* Find the beginning block within the folio */
 		if (pg_off >= ((bnum * bsize) + bsize)) {
 			bh = bh->b_this_page;
 			bnum++;
@@ -779,9 +779,10 @@ static int gfs2_write_buf_to_page(struct
 				goto unlock_out;
 			/* If it's a newly allocated disk block, zero it */
 			if (buffer_new(bh))
-				zero_user(page, bnum * bsize, bh->b_size);
+				folio_zero_range(folio, bnum * bsize,
+						bh->b_size);
 		}
-		if (PageUptodate(page))
+		if (folio_test_uptodate(folio))
 			set_buffer_uptodate(bh);
 		if (bh_read(bh, REQ_META | REQ_PRIO) < 0)
 			goto unlock_out;
@@ -797,17 +798,17 @@ static int gfs2_write_buf_to_page(struct
 		break;
 	}
 
-	/* Write to the page, now that we have setup the buffer(s) */
-	memcpy_to_page(page, off, buf, bytes);
-	flush_dcache_page(page);
-	unlock_page(page);
-	put_page(page);
+	/* Write to the folio, now that we have setup the buffer(s) */
+	memcpy_to_folio(folio, off, buf, bytes);
+	flush_dcache_folio(folio);
+	folio_unlock(folio);
+	folio_put(folio);
 
 	return 0;
 
 unlock_out:
-	unlock_page(page);
-	put_page(page);
+	folio_unlock(folio);
+	folio_put(folio);
 	return -EIO;
 }
 
_

Patches currently in -mm which might be from willy@infradead.org are


