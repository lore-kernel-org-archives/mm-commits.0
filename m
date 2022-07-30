Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6F88C3F6B0
	for <mm-commits@archiver.kernel.org>; Sat, 30 Jul 2022 01:13:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239558AbiG3BNP (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 29 Jul 2022 21:13:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239664AbiG3BNO (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 29 Jul 2022 21:13:14 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91D1C2ACA
        for <mm-commits@vger.kernel.org>; Fri, 29 Jul 2022 18:13:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3EA97B82925
        for <mm-commits@vger.kernel.org>; Sat, 30 Jul 2022 01:13:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7151C433D6;
        Sat, 30 Jul 2022 01:13:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1659143590;
        bh=sBpqRcCo7ducIWGa5jSdgHNPuOyB5laiGw0eMxIrQhI=;
        h=Date:To:From:Subject:From;
        b=iexuB5IYdN+1hcoWGUAIZUMM1ategPViFIWy+X2WHFiDPR6BptIFIzP1+ym+l+9AN
         Al9FkNOicdE8pEJT/5YLdRxZEQUqyzEmr+g/kW4L+xOSVbUMmNisB86X0TyvcijnJE
         04bhQWbXAL0kCZiKd7xqiXLRyuQ9SYFrQXI0VJEs=
Date:   Fri, 29 Jul 2022 18:13:09 -0700
To:     mm-commits@vger.kernel.org, zhengliang6@huawei.com,
        yi.zhang@huawei.com, Xiongwei.Song@windriver.com,
        willy@infradead.org, phillip@squashfs.org.uk,
        m.szyprowski@samsung.com, miaoxie@huawei.com, lkp@intel.com,
        houtao1@huawei.com, akpm@linux-foundation.org, hsinyi@chromium.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] squashfs-implement-readahead.patch removed from -mm tree
Message-Id: <20220730011309.E7151C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: squashfs: implement readahead
has been removed from the -mm tree.  Its filename was
     squashfs-implement-readahead.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Hsin-Yi Wang <hsinyi@chromium.org>
Subject: squashfs: implement readahead
Date: Fri, 17 Jun 2022 16:38:13 +0800

Implement readahead callback for squashfs.  It will read datablocks which
cover pages in readahead request.  For a few cases it will not mark page
as uptodate, including:

- file end is 0.
- zero filled blocks.
- current batch of pages isn't in the same datablock.
- decompressor error.

Otherwise pages will be marked as uptodate.  The unhandled pages will be
updated by readpage later.

Link: https://lkml.kernel.org/r/20220617083810.337573-4-hsinyi@chromium.org
Signed-off-by: Hsin-Yi Wang <hsinyi@chromium.org>
Suggested-by: Matthew Wilcox <willy@infradead.org>
Reported-by: Matthew Wilcox <willy@infradead.org>
Reported-by: Phillip Lougher <phillip@squashfs.org.uk>
Reported-by: Xiongwei Song <Xiongwei.Song@windriver.com>
Reported-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Hou Tao <houtao1@huawei.com>
Cc: kernel test robot <lkp@intel.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Miao Xie <miaoxie@huawei.com>
Cc: Zhang Yi <yi.zhang@huawei.com>
Cc: Zheng Liang <zhengliang6@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/squashfs/file.c |   92 ++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 91 insertions(+), 1 deletion(-)

--- a/fs/squashfs/file.c~squashfs-implement-readahead
+++ a/fs/squashfs/file.c
@@ -39,6 +39,7 @@
 #include "squashfs_fs_sb.h"
 #include "squashfs_fs_i.h"
 #include "squashfs.h"
+#include "page_actor.h"
 
 /*
  * Locate cache slot in range [offset, index] for specified inode.  If
@@ -495,7 +496,96 @@ out:
 	return 0;
 }
 
+static void squashfs_readahead(struct readahead_control *ractl)
+{
+	struct inode *inode = ractl->mapping->host;
+	struct squashfs_sb_info *msblk = inode->i_sb->s_fs_info;
+	size_t mask = (1UL << msblk->block_log) - 1;
+	unsigned short shift = msblk->block_log - PAGE_SHIFT;
+	loff_t start = readahead_pos(ractl) & ~mask;
+	size_t len = readahead_length(ractl) + readahead_pos(ractl) - start;
+	struct squashfs_page_actor *actor;
+	unsigned int nr_pages = 0;
+	struct page **pages;
+	int i, file_end = i_size_read(inode) >> msblk->block_log;
+	unsigned int max_pages = 1UL << shift;
+
+	readahead_expand(ractl, start, (len | mask) + 1);
+
+	if (file_end == 0)
+		return;
+
+	pages = kmalloc_array(max_pages, sizeof(void *), GFP_KERNEL);
+	if (!pages)
+		return;
+
+	for (;;) {
+		pgoff_t index;
+		int res, bsize;
+		u64 block = 0;
+		unsigned int expected;
+
+		nr_pages = __readahead_batch(ractl, pages, max_pages);
+		if (!nr_pages)
+			break;
+
+		if (readahead_pos(ractl) >= i_size_read(inode))
+			goto skip_pages;
+
+		index = pages[0]->index >> shift;
+		if ((pages[nr_pages - 1]->index >> shift) != index)
+			goto skip_pages;
+
+		expected = index == file_end ?
+			   (i_size_read(inode) & (msblk->block_size - 1)) :
+			    msblk->block_size;
+
+		bsize = read_blocklist(inode, index, &block);
+		if (bsize == 0)
+			goto skip_pages;
+
+		actor = squashfs_page_actor_init_special(msblk, pages, nr_pages,
+							 expected);
+		if (!actor)
+			goto skip_pages;
+
+		res = squashfs_read_data(inode->i_sb, block, bsize, NULL, actor);
+
+		kfree(actor);
+
+		if (res == expected) {
+			int bytes;
+
+			/* Last page (if present) may have trailing bytes not filled */
+			bytes = res % PAGE_SIZE;
+			if (pages[nr_pages - 1]->index == file_end && bytes)
+				memzero_page(pages[nr_pages - 1], bytes,
+					     PAGE_SIZE - bytes);
+
+			for (i = 0; i < nr_pages; i++) {
+				flush_dcache_page(pages[i]);
+				SetPageUptodate(pages[i]);
+			}
+		}
+
+		for (i = 0; i < nr_pages; i++) {
+			unlock_page(pages[i]);
+			put_page(pages[i]);
+		}
+	}
+
+	kfree(pages);
+	return;
+
+skip_pages:
+	for (i = 0; i < nr_pages; i++) {
+		unlock_page(pages[i]);
+		put_page(pages[i]);
+	}
+	kfree(pages);
+}
 
 const struct address_space_operations squashfs_aops = {
-	.read_folio = squashfs_read_folio
+	.read_folio = squashfs_read_folio,
+	.readahead = squashfs_readahead
 };
_

Patches currently in -mm which might be from hsinyi@chromium.org are


