Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D09D3C25B6E
	for <mm-commits@archiver.kernel.org>; Wed, 25 Oct 2023 23:48:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231232AbjJYXs2 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 25 Oct 2023 19:48:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231225AbjJYXsQ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 25 Oct 2023 19:48:16 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC11218C
        for <mm-commits@vger.kernel.org>; Wed, 25 Oct 2023 16:48:06 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 780EDC433C8;
        Wed, 25 Oct 2023 23:48:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1698277686;
        bh=taqiiV/cLgtyfMDUJ7tlrpwELKujJxE+sgouCzk2Ij4=;
        h=Date:To:From:Subject:From;
        b=RefhCyNbi2CuseBwrB6n2Pg4H9xfMTvNRxZNaWvyRLaXcbntuSDVO6uDleaCWzCxD
         OE2EsP8LYUgU81xW8PYh7UwLfgTKcyJiMDbFp7F+NgxG7wD9MOfg5s8vHzgLnc0RET
         +j53ycPdu33jXtDs1rZxHe1SI7qDwuoBz0s8ySfc=
Date:   Wed, 25 Oct 2023 16:48:05 -0700
To:     mm-commits@vger.kernel.org, p.raghav@samsung.com,
        konishi.ryusuke@gmail.com, agruenba@redhat.com,
        willy@infradead.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] ntfs3-convert-ntfs_zero_range-to-use-a-folio.patch removed from -mm tree
Message-Id: <20231025234806.780EDC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: ntfs3: convert ntfs_zero_range() to use a folio
has been removed from the -mm tree.  Its filename was
     ntfs3-convert-ntfs_zero_range-to-use-a-folio.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: ntfs3: convert ntfs_zero_range() to use a folio
Date: Mon, 16 Oct 2023 21:11:07 +0100

Use the folio API throughout, saving six hidden calls to compound_head().

Link: https://lkml.kernel.org/r/20231016201114.1928083-21-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Andreas Gruenbacher <agruenba@redhat.com>
Cc: Pankaj Raghav <p.raghav@samsung.com>
Cc: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ntfs3/file.c |   33 +++++++++++++++++----------------
 1 file changed, 17 insertions(+), 16 deletions(-)

--- a/fs/ntfs3/file.c~ntfs3-convert-ntfs_zero_range-to-use-a-folio
+++ a/fs/ntfs3/file.c
@@ -187,7 +187,7 @@ static int ntfs_zero_range(struct inode
 	struct buffer_head *head, *bh;
 	u32 bh_next, bh_off, to;
 	sector_t iblock;
-	struct page *page;
+	struct folio *folio;
 
 	for (; idx < idx_end; idx += 1, from = 0) {
 		page_off = (loff_t)idx << PAGE_SHIFT;
@@ -195,16 +195,17 @@ static int ntfs_zero_range(struct inode
 						       PAGE_SIZE;
 		iblock = page_off >> inode->i_blkbits;
 
-		page = find_or_create_page(mapping, idx,
-					   mapping_gfp_constraint(mapping,
-								  ~__GFP_FS));
-		if (!page)
-			return -ENOMEM;
+		folio = __filemap_get_folio(mapping, idx,
+				FGP_LOCK | FGP_ACCESSED | FGP_CREAT,
+				mapping_gfp_constraint(mapping, ~__GFP_FS));
+		if (IS_ERR(folio))
+			return PTR_ERR(folio);
+
+		head = folio_buffers(folio);
+		if (!head)
+			head = folio_create_empty_buffers(folio, blocksize, 0);
 
-		if (!page_has_buffers(page))
-			create_empty_buffers(page, blocksize, 0);
-
-		bh = head = page_buffers(page);
+		bh = head;
 		bh_off = 0;
 		do {
 			bh_next = bh_off + blocksize;
@@ -220,14 +221,14 @@ static int ntfs_zero_range(struct inode
 			}
 
 			/* Ok, it's mapped. Make sure it's up-to-date. */
-			if (PageUptodate(page))
+			if (folio_test_uptodate(folio))
 				set_buffer_uptodate(bh);
 
 			if (!buffer_uptodate(bh)) {
 				err = bh_read(bh, 0);
 				if (err < 0) {
-					unlock_page(page);
-					put_page(page);
+					folio_unlock(folio);
+					folio_put(folio);
 					goto out;
 				}
 			}
@@ -237,10 +238,10 @@ static int ntfs_zero_range(struct inode
 		} while (bh_off = bh_next, iblock += 1,
 			 head != (bh = bh->b_this_page));
 
-		zero_user_segment(page, from, to);
+		folio_zero_segment(folio, from, to);
 
-		unlock_page(page);
-		put_page(page);
+		folio_unlock(folio);
+		folio_put(folio);
 		cond_resched();
 	}
 out:
_

Patches currently in -mm which might be from willy@infradead.org are


