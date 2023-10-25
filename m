Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BED4EC25B70
	for <mm-commits@archiver.kernel.org>; Wed, 25 Oct 2023 23:48:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231400AbjJYXsG (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 25 Oct 2023 19:48:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230522AbjJYXsD (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 25 Oct 2023 19:48:03 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B76EC187
        for <mm-commits@vger.kernel.org>; Wed, 25 Oct 2023 16:47:53 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83093C433C9;
        Wed, 25 Oct 2023 23:47:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1698277673;
        bh=xrsf5kl67sXlZDlDMKezWNNnNwYrGIr2oXm9LriiLiI=;
        h=Date:To:From:Subject:From;
        b=T7120h9CwmJrpcs8SyulfM5YZmcX4zOy7MGIdP6YiNbPVRQEraMABX1yTUMr+UOHu
         b5qenk2WJXekfJfT7jceLlBTlEdHQJKxqH+LAQZARvHo1CMai9IQtd5E7tL2+k2/X+
         MD2hWaHXuAqVT7YzuJlhYnwRkKw1PJtyIiuI2KV0=
Date:   Wed, 25 Oct 2023 16:47:52 -0700
To:     mm-commits@vger.kernel.org, p.raghav@samsung.com,
        konishi.ryusuke@gmail.com, agruenba@redhat.com,
        willy@infradead.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] buffer-add-get_nth_bh.patch removed from -mm tree
Message-Id: <20231025234753.83093C433C9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: buffer: add get_nth_bh()
has been removed from the -mm tree.  Its filename was
     buffer-add-get_nth_bh.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: buffer: add get_nth_bh()
Date: Mon, 16 Oct 2023 21:10:52 +0100

Extract this useful helper from nilfs_page_get_nth_block()

Link: https://lkml.kernel.org/r/20231016201114.1928083-6-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Acked-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Cc: Andreas Gruenbacher <agruenba@redhat.com>
Cc: Pankaj Raghav <p.raghav@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/page.h            |    7 +------
 include/linux/buffer_head.h |   22 ++++++++++++++++++++++
 2 files changed, 23 insertions(+), 6 deletions(-)

--- a/fs/nilfs2/page.h~buffer-add-get_nth_bh
+++ a/fs/nilfs2/page.h
@@ -55,12 +55,7 @@ unsigned long nilfs_find_uncommitted_ext
 static inline struct buffer_head *
 nilfs_page_get_nth_block(struct page *page, unsigned int count)
 {
-	struct buffer_head *bh = page_buffers(page);
-
-	while (count-- > 0)
-		bh = bh->b_this_page;
-	get_bh(bh);
-	return bh;
+	return get_nth_bh(page_buffers(page), count);
 }
 
 #endif /* _NILFS_PAGE_H */
--- a/include/linux/buffer_head.h~buffer-add-get_nth_bh
+++ a/include/linux/buffer_head.h
@@ -457,6 +457,28 @@ __bread(struct block_device *bdev, secto
 	return __bread_gfp(bdev, block, size, __GFP_MOVABLE);
 }
 
+/**
+ * get_nth_bh - Get a reference on the n'th buffer after this one.
+ * @bh: The buffer to start counting from.
+ * @count: How many buffers to skip.
+ *
+ * This is primarily useful for finding the nth buffer in a folio; in
+ * that case you pass the head buffer and the byte offset in the folio
+ * divided by the block size.  It can be used for other purposes, but
+ * it will wrap at the end of the folio rather than returning NULL or
+ * proceeding to the next folio for you.
+ *
+ * Return: The requested buffer with an elevated refcount.
+ */
+static inline __must_check
+struct buffer_head *get_nth_bh(struct buffer_head *bh, unsigned int count)
+{
+	while (count--)
+		bh = bh->b_this_page;
+	get_bh(bh);
+	return bh;
+}
+
 bool block_dirty_folio(struct address_space *mapping, struct folio *folio);
 
 #ifdef CONFIG_BUFFER_HEAD
_

Patches currently in -mm which might be from willy@infradead.org are


