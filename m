Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7EF5CCA47E
	for <mm-commits@archiver.kernel.org>; Fri, 17 Jun 2022 02:59:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379892AbiFQC7Q (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 16 Jun 2022 22:59:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379893AbiFQC7M (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 16 Jun 2022 22:59:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFBDD66200
        for <mm-commits@vger.kernel.org>; Thu, 16 Jun 2022 19:59:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8BBEB61CFB
        for <mm-commits@vger.kernel.org>; Fri, 17 Jun 2022 02:59:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2927C34114;
        Fri, 17 Jun 2022 02:59:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1655434748;
        bh=9Jafjwqo3XAqFzbdxQNnyaMnq5Jqs62t/gnfOTu1kqg=;
        h=Date:To:From:Subject:From;
        b=QsGilpp/sOXwf6/OmzXjb9VIJFE6bkE5903s0NW5xW7+NooZpQLcfjLqhnGaq4BO6
         Hq90ei81N0DJ1DJn8hgePeT95/wAWAsbxj7FKyRfMQtOfeFvFkjepzspQvp1NIkKj6
         eC4OFBmQkcELsa/LoSKFAgrj/lj4kIdVOvMjwITg=
Date:   Thu, 16 Jun 2022 19:59:07 -0700
To:     mm-commits@vger.kernel.org, Xiongwei.Song@windriver.com,
        willy@infradead.org, hsinyi@chromium.org, phillip@squashfs.org.uk,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] squashfs-dont-use-intermediate-buffer-if-pages-missing.patch removed from -mm tree
Message-Id: <20220617025907.E2927C34114@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: squashfs: don't use intermediate buffer if pages missing
has been removed from the -mm tree.  Its filename was
     squashfs-dont-use-intermediate-buffer-if-pages-missing.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Phillip Lougher <phillip@squashfs.org.uk>
Subject: squashfs: don't use intermediate buffer if pages missing
Date: Sat, 11 Jun 2022 04:21:33 +0100

Now that the "page actor" can handle missing pages, we don't have to fall
back to using an intermediate buffer in Squashfs_readpage_block() if all
the pages necessary can't be obtained.

Link: https://lkml.kernel.org/r/20220611032133.5743-3-phillip@squashfs.org.uk
Signed-off-by: Phillip Lougher <phillip@squashfs.org.uk>
Cc: Hsin-Yi Wang <hsinyi@chromium.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Xiongwei Song <Xiongwei.Song@windriver.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/squashfs/file_direct.c |   75 +++++-------------------------------
 1 file changed, 12 insertions(+), 63 deletions(-)

--- a/fs/squashfs/file_direct.c~squashfs-dont-use-intermediate-buffer-if-pages-missing
+++ a/fs/squashfs/file_direct.c
@@ -18,9 +18,6 @@
 #include "squashfs.h"
 #include "page_actor.h"
 
-static int squashfs_read_cache(struct page *target_page, u64 block, int bsize,
-	int pages, struct page **page, int bytes);
-
 /* Read separately compressed datablock directly into page cache */
 int squashfs_readpage_block(struct page *target_page, u64 block, int bsize,
 	int expected)
@@ -33,7 +30,7 @@ int squashfs_readpage_block(struct page
 	int mask = (1 << (msblk->block_log - PAGE_SHIFT)) - 1;
 	int start_index = target_page->index & ~mask;
 	int end_index = start_index | mask;
-	int i, n, pages, missing_pages, bytes, res = -ENOMEM;
+	int i, n, pages, bytes, res = -ENOMEM;
 	struct page **page;
 	struct squashfs_page_actor *actor;
 	void *pageaddr;
@@ -48,44 +45,29 @@ int squashfs_readpage_block(struct page
 		return res;
 
 	/* Try to grab all the pages covered by the Squashfs block */
-	for (missing_pages = 0, i = 0, n = start_index; i < pages; i++, n++) {
+	for (i = 0, n = start_index; n <= end_index; n++) {
 		page[i] = (n == target_page->index) ? target_page :
 			grab_cache_page_nowait(target_page->mapping, n);
 
-		if (page[i] == NULL) {
-			missing_pages++;
+		if (page[i] == NULL)
 			continue;
-		}
 
 		if (PageUptodate(page[i])) {
 			unlock_page(page[i]);
 			put_page(page[i]);
-			page[i] = NULL;
-			missing_pages++;
+			continue;
 		}
-	}
-
-	if (missing_pages) {
-		/*
-		 * Couldn't get one or more pages, this page has either
-		 * been VM reclaimed, but others are still in the page cache
-		 * and uptodate, or we're racing with another thread in
-		 * squashfs_readpage also trying to grab them.  Fall back to
-		 * using an intermediate buffer.
-		 */
-		res = squashfs_read_cache(target_page, block, bsize, pages,
-							page, expected);
-		if (res < 0)
-			goto mark_errored;
 
-		goto out;
+		i++;
 	}
 
+	pages = i;
+
 	/*
 	 * Create a "page actor" which will kmap and kunmap the
 	 * page cache pages appropriately within the decompressor
 	 */
-	actor = squashfs_page_actor_init_special(msblk, page, pages, 0);
+	actor = squashfs_page_actor_init_special(msblk, page, pages, expected);
 	if (actor == NULL)
 		goto out;
 
@@ -102,12 +84,12 @@ int squashfs_readpage_block(struct page
 		goto mark_errored;
 	}
 
-	/* Last page may have trailing bytes not filled */
+	/* Last page (if present) may have trailing bytes not filled */
 	bytes = res % PAGE_SIZE;
-	if (bytes) {
-		pageaddr = kmap_atomic(page[pages - 1]);
+	if (page[pages - 1]->index == end_index && bytes) {
+		pageaddr = kmap_local_page(page[pages - 1]);
 		memset(pageaddr + bytes, 0, PAGE_SIZE - bytes);
-		kunmap_atomic(pageaddr);
+		kunmap_local(pageaddr);
 	}
 
 	/* Mark pages as uptodate, unlock and release */
@@ -140,36 +122,3 @@ out:
 	kfree(page);
 	return res;
 }
-
-
-static int squashfs_read_cache(struct page *target_page, u64 block, int bsize,
-	int pages, struct page **page, int bytes)
-{
-	struct inode *i = target_page->mapping->host;
-	struct squashfs_cache_entry *buffer = squashfs_get_datablock(i->i_sb,
-						 block, bsize);
-	int res = buffer->error, n, offset = 0;
-
-	if (res) {
-		ERROR("Unable to read page, block %llx, size %x\n", block,
-			bsize);
-		goto out;
-	}
-
-	for (n = 0; n < pages && bytes > 0; n++,
-			bytes -= PAGE_SIZE, offset += PAGE_SIZE) {
-		int avail = min_t(int, bytes, PAGE_SIZE);
-
-		if (page[n] == NULL)
-			continue;
-
-		squashfs_fill_page(page[n], buffer, offset, avail);
-		unlock_page(page[n]);
-		if (page[n] != target_page)
-			put_page(page[n]);
-	}
-
-out:
-	squashfs_cache_put(buffer);
-	return res;
-}
_

Patches currently in -mm which might be from phillip@squashfs.org.uk are

squashfs-always-build-file-direct-version-of-page-actor.patch

