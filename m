Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69C49EB64DC
	for <mm-commits@archiver.kernel.org>; Mon, 19 Jun 2023 23:26:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230047AbjFSX0u (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 19 Jun 2023 19:26:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230038AbjFSXYv (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 19 Jun 2023 19:24:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A82719BE
        for <mm-commits@vger.kernel.org>; Mon, 19 Jun 2023 16:23:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4F8C860FAF
        for <mm-commits@vger.kernel.org>; Mon, 19 Jun 2023 23:23:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA361C433C8;
        Mon, 19 Jun 2023 23:23:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1687216992;
        bh=gdHP0pIdJfGDdUyN3JnGITaHX+3+HfRS0SnU/M7Orsk=;
        h=Date:To:From:Subject:From;
        b=Uf7jio92adn39IVNWFkphGN01JWlgOvlEVcCMfNrdUNPHHM/Iq2CFAcIyzb1KrbTM
         BtlmWJdTAViQjdPKut3+4UJ930tuMLeF7cGT3v7RZzo2wa2KfdpOzQJQ0m8D0QfLmO
         FTZRKK5PMP5mf4Sb46Q5J3LWbQGGJKcqAkKlHdJ8=
Date:   Mon, 19 Jun 2023 16:23:12 -0700
To:     mm-commits@vger.kernel.org, rpeterso@redhat.com, mcgrof@kernel.org,
        hare@suse.com, agruenba@redhat.com, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] buffer-convert-init_page_buffers-to-folio_init_buffers.patch removed from -mm tree
Message-Id: <20230619232312.AA361C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: buffer: convert init_page_buffers() to folio_init_buffers()
has been removed from the -mm tree.  Its filename was
     buffer-convert-init_page_buffers-to-folio_init_buffers.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: buffer: convert init_page_buffers() to folio_init_buffers()
Date: Mon, 12 Jun 2023 22:01:38 +0100

Use the folio API and pass the folio from both callers.  Saves a hidden
call to compound_head().

Link: https://lkml.kernel.org/r/20230612210141.730128-12-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Andreas Gruenbacher <agruenba@redhat.com>
Cc: Bob Peterson <rpeterso@redhat.com>
Cc: Hannes Reinecke <hare@suse.com>
Cc: Luis Chamberlain <mcgrof@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/buffer.c |   18 ++++++++----------
 1 file changed, 8 insertions(+), 10 deletions(-)

--- a/fs/buffer.c~buffer-convert-init_page_buffers-to-folio_init_buffers
+++ a/fs/buffer.c
@@ -934,15 +934,14 @@ static sector_t blkdev_max_block(struct
 }
 
 /*
- * Initialise the state of a blockdev page's buffers.
+ * Initialise the state of a blockdev folio's buffers.
  */ 
-static sector_t
-init_page_buffers(struct page *page, struct block_device *bdev,
-			sector_t block, int size)
+static sector_t folio_init_buffers(struct folio *folio,
+		struct block_device *bdev, sector_t block, int size)
 {
-	struct buffer_head *head = page_buffers(page);
+	struct buffer_head *head = folio_buffers(folio);
 	struct buffer_head *bh = head;
-	int uptodate = PageUptodate(page);
+	bool uptodate = folio_test_uptodate(folio);
 	sector_t end_block = blkdev_max_block(bdev, size);
 
 	do {
@@ -998,9 +997,8 @@ grow_dev_page(struct block_device *bdev,
 	bh = folio_buffers(folio);
 	if (bh) {
 		if (bh->b_size == size) {
-			end_block = init_page_buffers(&folio->page, bdev,
-						(sector_t)index << sizebits,
-						size);
+			end_block = folio_init_buffers(folio, bdev,
+					(sector_t)index << sizebits, size);
 			goto done;
 		}
 		if (!try_to_free_buffers(folio))
@@ -1016,7 +1014,7 @@ grow_dev_page(struct block_device *bdev,
 	 */
 	spin_lock(&inode->i_mapping->private_lock);
 	link_dev_buffers(&folio->page, bh);
-	end_block = init_page_buffers(&folio->page, bdev,
+	end_block = folio_init_buffers(folio, bdev,
 			(sector_t)index << sizebits, size);
 	spin_unlock(&inode->i_mapping->private_lock);
 done:
_

Patches currently in -mm which might be from willy@infradead.org are


