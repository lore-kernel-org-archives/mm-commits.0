Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD5D3C433EF
	for <mm-commits@archiver.kernel.org>; Fri, 17 Jun 2022 23:30:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232947AbiFQXaT (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 17 Jun 2022 19:30:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235147AbiFQXaT (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 17 Jun 2022 19:30:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 810DF66F91
        for <mm-commits@vger.kernel.org>; Fri, 17 Jun 2022 16:30:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1A8D261D3D
        for <mm-commits@vger.kernel.org>; Fri, 17 Jun 2022 23:30:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 733CFC3411B;
        Fri, 17 Jun 2022 23:30:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1655508617;
        bh=su/Zq5KLGjds/BzSjWjXZW+gxxWRlvMivhtnw/Ldq+Q=;
        h=Date:To:From:Subject:From;
        b=aHNxpB28IxA3gTLxdi/i2T78la5dsm5BOknGfzGJwqdt+5T4Iosp1XNJt6OzmT2f1
         3Qf9ZFjgIs6+yvLHlmegK7CFBYH/Y1rRjRJK7XOemgN5S1LgUPhGecQhQftcl+pKJ2
         ZYwnk54cPUQmaiTPThAydGEXHqon4DK99PGYsO6o=
Date:   Fri, 17 Jun 2022 16:30:16 -0700
To:     mm-commits@vger.kernel.org, zhengliang6@huawei.com,
        yi.zhang@huawei.com, Xiongwei.Song@windriver.com,
        willy@infradead.org, phillip@squashfs.org.uk,
        m.szyprowski@samsung.com, miaoxie@huawei.com, lkp@intel.com,
        houtao1@huawei.com, akpm@linux-foundation.org, hsinyi@chromium.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + squashfs-implement-readahead.patch added to mm-nonmm-unstable branch
Message-Id: <20220617233017.733CFC3411B@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: squashfs: implement readahead
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     squashfs-implement-readahead.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/squashfs-implement-readahead.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

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

revert-squashfs-provide-backing_dev_info-in-order-to-disable-read-ahead.patch
squashfs-implement-readahead.patch

