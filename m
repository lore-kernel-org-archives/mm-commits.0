Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B5CDC25B6B
	for <mm-commits@archiver.kernel.org>; Wed, 25 Oct 2023 23:48:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231825AbjJYXsZ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 25 Oct 2023 19:48:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231190AbjJYXsL (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 25 Oct 2023 19:48:11 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D88BB92
        for <mm-commits@vger.kernel.org>; Wed, 25 Oct 2023 16:48:03 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A363BC433CA;
        Wed, 25 Oct 2023 23:48:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1698277683;
        bh=t2WD7ENn4TsGZQiX60JvUFOtEWiVT5QFc7dBV4tKmBA=;
        h=Date:To:From:Subject:From;
        b=o4yqj3yrHr98KJwdfAQq3+Q/kRM5Zb6cdnHweoZdkucxnpUDhc/n1/ukPisvlFnO0
         Yh9w07Xup52o+do/CNqFtslGSXP3gjiC5ZVKnK2pxAJW081KF/9Y/mFSr3V3dUt29h
         p1QE2X850MZc7CH7QxkBYSXFBzZyujzbA3Qr/45s=
Date:   Wed, 25 Oct 2023 16:48:03 -0700
To:     mm-commits@vger.kernel.org, p.raghav@samsung.com,
        konishi.ryusuke@gmail.com, agruenba@redhat.com,
        willy@infradead.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] ntfs-convert-ntfs_read_block-to-use-a-folio.patch removed from -mm tree
Message-Id: <20231025234803.A363BC433CA@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: ntfs: convert ntfs_read_block() to use a folio
has been removed from the -mm tree.  Its filename was
     ntfs-convert-ntfs_read_block-to-use-a-folio.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: ntfs: convert ntfs_read_block() to use a folio
Date: Mon, 16 Oct 2023 21:11:04 +0100

The caller already has the folio, so pass it in and use the folio API
throughout saving five hidden calls to compound_head().

Link: https://lkml.kernel.org/r/20231016201114.1928083-18-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Andreas Gruenbacher <agruenba@redhat.com>
Cc: Pankaj Raghav <p.raghav@samsung.com>
Cc: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ntfs/aops.c |   44 +++++++++++++++++++-------------------------
 1 file changed, 19 insertions(+), 25 deletions(-)

--- a/fs/ntfs/aops.c~ntfs-convert-ntfs_read_block-to-use-a-folio
+++ a/fs/ntfs/aops.c
@@ -145,13 +145,12 @@ still_busy:
 }
 
 /**
- * ntfs_read_block - fill a @page of an address space with data
- * @page:	page cache page to fill with data
+ * ntfs_read_block - fill a @folio of an address space with data
+ * @folio:	page cache folio to fill with data
  *
- * Fill the page @page of the address space belonging to the @page->host inode.
  * We read each buffer asynchronously and when all buffers are read in, our io
  * completion handler ntfs_end_buffer_read_async(), if required, automatically
- * applies the mst fixups to the page before finally marking it uptodate and
+ * applies the mst fixups to the folio before finally marking it uptodate and
  * unlocking it.
  *
  * We only enforce allocated_size limit because i_size is checked for in
@@ -161,7 +160,7 @@ still_busy:
  *
  * Contains an adapted version of fs/buffer.c::block_read_full_folio().
  */
-static int ntfs_read_block(struct page *page)
+static int ntfs_read_block(struct folio *folio)
 {
 	loff_t i_size;
 	VCN vcn;
@@ -178,7 +177,7 @@ static int ntfs_read_block(struct page *
 	int i, nr;
 	unsigned char blocksize_bits;
 
-	vi = page->mapping->host;
+	vi = folio->mapping->host;
 	ni = NTFS_I(vi);
 	vol = ni->vol;
 
@@ -188,15 +187,10 @@ static int ntfs_read_block(struct page *
 	blocksize = vol->sb->s_blocksize;
 	blocksize_bits = vol->sb->s_blocksize_bits;
 
-	if (!page_has_buffers(page)) {
-		create_empty_buffers(page, blocksize, 0);
-		if (unlikely(!page_has_buffers(page))) {
-			unlock_page(page);
-			return -ENOMEM;
-		}
-	}
-	bh = head = page_buffers(page);
-	BUG_ON(!bh);
+	head = folio_buffers(folio);
+	if (!head)
+		head = folio_create_empty_buffers(folio, blocksize, 0);
+	bh = head;
 
 	/*
 	 * We may be racing with truncate.  To avoid some of the problems we
@@ -205,11 +199,11 @@ static int ntfs_read_block(struct page *
 	 * may leave some buffers unmapped which are now allocated.  This is
 	 * not a problem since these buffers will just get mapped when a write
 	 * occurs.  In case of a shrinking truncate, we will detect this later
-	 * on due to the runlist being incomplete and if the page is being
+	 * on due to the runlist being incomplete and if the folio is being
 	 * fully truncated, truncate will throw it away as soon as we unlock
 	 * it so no need to worry what we do with it.
 	 */
-	iblock = (s64)page->index << (PAGE_SHIFT - blocksize_bits);
+	iblock = (s64)folio->index << (PAGE_SHIFT - blocksize_bits);
 	read_lock_irqsave(&ni->size_lock, flags);
 	lblock = (ni->allocated_size + blocksize - 1) >> blocksize_bits;
 	init_size = ni->initialized_size;
@@ -221,7 +215,7 @@ static int ntfs_read_block(struct page *
 	}
 	zblock = (init_size + blocksize - 1) >> blocksize_bits;
 
-	/* Loop through all the buffers in the page. */
+	/* Loop through all the buffers in the folio. */
 	rl = NULL;
 	nr = i = 0;
 	do {
@@ -299,7 +293,7 @@ lock_retry_remap:
 			if (!err)
 				err = -EIO;
 			bh->b_blocknr = -1;
-			SetPageError(page);
+			folio_set_error(folio);
 			ntfs_error(vol->sb, "Failed to read from inode 0x%lx, "
 					"attribute type 0x%x, vcn 0x%llx, "
 					"offset 0x%x because its location on "
@@ -312,13 +306,13 @@ lock_retry_remap:
 		/*
 		 * Either iblock was outside lblock limits or
 		 * ntfs_rl_vcn_to_lcn() returned error.  Just zero that portion
-		 * of the page and set the buffer uptodate.
+		 * of the folio and set the buffer uptodate.
 		 */
 handle_hole:
 		bh->b_blocknr = -1UL;
 		clear_buffer_mapped(bh);
 handle_zblock:
-		zero_user(page, i * blocksize, blocksize);
+		folio_zero_range(folio, i * blocksize, blocksize);
 		if (likely(!err))
 			set_buffer_uptodate(bh);
 	} while (i++, iblock++, (bh = bh->b_this_page) != head);
@@ -349,11 +343,11 @@ handle_zblock:
 		return 0;
 	}
 	/* No i/o was scheduled on any of the buffers. */
-	if (likely(!PageError(page)))
-		SetPageUptodate(page);
+	if (likely(!folio_test_error(folio)))
+		folio_mark_uptodate(folio);
 	else /* Signal synchronous i/o error. */
 		nr = -EIO;
-	unlock_page(page);
+	folio_unlock(folio);
 	return nr;
 }
 
@@ -433,7 +427,7 @@ retry_readpage:
 	/* NInoNonResident() == NInoIndexAllocPresent() */
 	if (NInoNonResident(ni)) {
 		/* Normal, non-resident data stream. */
-		return ntfs_read_block(page);
+		return ntfs_read_block(folio);
 	}
 	/*
 	 * Attribute is resident, implying it is not compressed or encrypted.
_

Patches currently in -mm which might be from willy@infradead.org are


