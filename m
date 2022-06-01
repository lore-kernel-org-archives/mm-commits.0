Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60662C433EF
	for <mm-commits@archiver.kernel.org>; Wed,  1 Jun 2022 20:59:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230499AbiFAU7D (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 1 Jun 2022 16:59:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230479AbiFAU66 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 1 Jun 2022 16:58:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B4271B6FFC
        for <mm-commits@vger.kernel.org>; Wed,  1 Jun 2022 13:58:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C0FE461243
        for <mm-commits@vger.kernel.org>; Wed,  1 Jun 2022 20:58:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EC77C385B8;
        Wed,  1 Jun 2022 20:58:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1654117136;
        bh=l9Yc+f1Ce6yh4jcCHKyQb8R0wdAMtrq+f2q8Kzi018Y=;
        h=Date:To:From:Subject:From;
        b=AlX63y1IKlvzNmpPe3jx7j33mlVyiyibi0N64aPbkoZBTOOW1eOsUj4tsqjMPP55P
         uXvGEtx1RUOjdus+D1EiUDEmGa6cStg3SXy25jcvsqxYrjZcon1y+pA4iZ36E9FIul
         ezNwPOyN10ZIoLU8gaiP6EVYafplybIOtJTmloWQ=
Date:   Wed, 01 Jun 2022 13:58:55 -0700
To:     mm-commits@vger.kernel.org, zhengliang6@huawei.com,
        yi.zhang@huawei.com, Xiongwei.Song@windriver.com,
        willy@infradead.org, phillip@squashfs.org.uk, miaoxie@huawei.com,
        lkp@intel.com, houtao1@huawei.com, hsinyi@chromium.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + squashfs-implement-readahead.patch added to mm-nonmm-unstable branch
Message-Id: <20220601205856.1EC77C385B8@smtp.kernel.org>
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
Date: Wed, 1 Jun 2022 18:39:22 +0800

Implement readahead callback for squashfs.  It will read datablocks which
cover pages in readahead request.  For a few cases it will not mark page
as uptodate, including:

- file end is 0.
- zero filled blocks.
- current batch of pages isn't in the same datablock or not enough in a
  datablock.
- decompressor error.
Otherwise pages will be marked as uptodate. The unhandled pages will be
updated by readpage later.

Link: https://lkml.kernel.org/r/20220601103922.1338320-4-hsinyi@chromium.org
Signed-off-by: Hsin-Yi Wang <hsinyi@chromium.org>
Suggested-by: Matthew Wilcox <willy@infradead.org>
Reported-by: Matthew Wilcox <willy@infradead.org>
Reported-by: Phillip Lougher <phillip@squashfs.org.uk>
Reported-by: Xiongwei Song <Xiongwei.Song@windriver.com>
Cc: Zheng Liang <zhengliang6@huawei.com>
Cc: Zhang Yi <yi.zhang@huawei.com>
Cc: Hou Tao <houtao1@huawei.com>
Cc: Miao Xie <miaoxie@huawei.com>
Cc: kernel test robot <lkp@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/squashfs/file.c |   97 ++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 96 insertions(+), 1 deletion(-)

--- a/fs/squashfs/file.c~squashfs-implement-readahead
+++ a/fs/squashfs/file.c
@@ -39,6 +39,7 @@
 #include "squashfs_fs_sb.h"
 #include "squashfs_fs_i.h"
 #include "squashfs.h"
+#include "page_actor.h"
 
 /*
  * Locate cache slot in range [offset, index] for specified inode.  If
@@ -495,7 +496,101 @@ out:
 	return 0;
 }
 
+static void squashfs_readahead(struct readahead_control *ractl)
+{
+	struct inode *inode = ractl->mapping->host;
+	struct squashfs_sb_info *msblk = inode->i_sb->s_fs_info;
+	size_t mask = (1UL << msblk->block_log) - 1;
+	unsigned short shift = msblk->block_log - PAGE_SHIFT;
+	loff_t start = readahead_pos(ractl) &~ mask;
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
+	actor = squashfs_page_actor_init_special(pages, max_pages, 0);
+	if (!actor)
+		goto out;
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
+		if (readahead_pos(ractl) >= i_size_read(inode) ||
+		    nr_pages < max_pages)
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
+		res = squashfs_read_data(inode->i_sb, block, bsize, NULL,
+					 actor);
+
+		if (res == expected) {
+			int bytes;
+
+			/* Last page may have trailing bytes not filled */
+			bytes = res % PAGE_SIZE;
+			if (bytes) {
+				void *pageaddr;
+
+				pageaddr = kmap_atomic(pages[nr_pages - 1]);
+				memset(pageaddr + bytes, 0, PAGE_SIZE - bytes);
+				kunmap_atomic(pageaddr);
+			}
+
+			for (i = 0; i < nr_pages; i++)
+				SetPageUptodate(pages[i]);
+		}
+
+		for (i = 0; i < nr_pages; i++) {
+			unlock_page(pages[i]);
+			put_page(pages[i]);
+		}
+	}
+
+	kfree(actor);
+	kfree(pages);
+	return;
+
+skip_pages:
+	for (i = 0; i < nr_pages; i++) {
+		unlock_page(pages[i]);
+		put_page(pages[i]);
+	}
+
+	kfree(actor);
+out:
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

