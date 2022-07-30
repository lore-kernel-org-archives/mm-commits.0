Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15C20C00144
	for <mm-commits@archiver.kernel.org>; Sat, 30 Jul 2022 01:13:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239688AbiG3BNP (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 29 Jul 2022 21:13:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239558AbiG3BNO (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 29 Jul 2022 21:13:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65BCD261A
        for <mm-commits@vger.kernel.org>; Fri, 29 Jul 2022 18:13:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D022261B74
        for <mm-commits@vger.kernel.org>; Sat, 30 Jul 2022 01:13:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28B3DC433D7;
        Sat, 30 Jul 2022 01:13:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1659143591;
        bh=kL5mf5aMWVCVSbfswaAQtshqTprP6gMAHVRNC4J5qrY=;
        h=Date:To:From:Subject:From;
        b=g5YT1Qs2X0Rr5jqFNTT0QGikxm03jfwKtLDPpqtakrfeStXfOw2y04Dvy49d2T0Ft
         engNWt2/uocib6KnfLaacbL/WC4jOjCs8hGIUGFzMxtn9MPNJaDCHlf//30vIUuHbQ
         jMqfm6WWQmPPOtL7D7VuoRMPN1qFLgKeHveBnpyc=
Date:   Fri, 29 Jul 2022 18:13:10 -0700
To:     mm-commits@vger.kernel.org, zhengliang6@huawei.com,
        yi.zhang@huawei.com, Xiongwei.Song@windriver.com,
        willy@infradead.org, m.szyprowski@samsung.com, miaoxie@huawei.com,
        lkp@intel.com, hsinyi@chromium.org, houtao1@huawei.com,
        phillip@squashfs.org.uk, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] squashfs-support-reading-fragments-in-readahead-call.patch removed from -mm tree
Message-Id: <20220730011311.28B3DC433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: squashfs: support reading fragments in readahead call
has been removed from the -mm tree.  Its filename was
     squashfs-support-reading-fragments-in-readahead-call.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Phillip Lougher <phillip@squashfs.org.uk>
Subject: squashfs: support reading fragments in readahead call
Date: Fri, 17 Jun 2022 16:38:15 +0800

Add a function which can be used to read fragments in the readahead call.

This function is necessary because filesystems built with the -tailends
(or -always-use-fragments) option may have fragments present which cannot
be currently handled.

Link: https://lkml.kernel.org/r/20220617083810.337573-5-hsinyi@chromium.org
Signed-off-by: Phillip Lougher <phillip@squashfs.org.uk>
Signed-off-by: Hsin-Yi Wang <hsinyi@chromium.org>
Cc: Hou Tao <houtao1@huawei.com>
Cc: kernel test robot <lkp@intel.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Miao Xie <miaoxie@huawei.com>
Cc: Xiongwei Song <Xiongwei.Song@windriver.com>
Cc: Zhang Yi <yi.zhang@huawei.com>
Cc: Zheng Liang <zhengliang6@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/squashfs/file.c |   47 ++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 44 insertions(+), 3 deletions(-)

--- a/fs/squashfs/file.c~squashfs-support-reading-fragments-in-readahead-call
+++ a/fs/squashfs/file.c
@@ -496,6 +496,41 @@ out:
 	return 0;
 }
 
+static int squashfs_readahead_fragment(struct page **page,
+	unsigned int pages, unsigned int expected)
+{
+	struct inode *inode = page[0]->mapping->host;
+	struct squashfs_cache_entry *buffer = squashfs_get_fragment(inode->i_sb,
+		squashfs_i(inode)->fragment_block,
+		squashfs_i(inode)->fragment_size);
+	struct squashfs_sb_info *msblk = inode->i_sb->s_fs_info;
+	unsigned int n, mask = (1 << (msblk->block_log - PAGE_SHIFT)) - 1;
+
+	if (buffer->error)
+		goto out;
+
+	expected += squashfs_i(inode)->fragment_offset;
+
+	for (n = 0; n < pages; n++) {
+		unsigned int base = (page[n]->index & mask) << PAGE_SHIFT;
+		unsigned int offset = base + squashfs_i(inode)->fragment_offset;
+
+		if (expected > offset) {
+			unsigned int avail = min_t(unsigned int, expected -
+				offset, PAGE_SIZE);
+
+			squashfs_fill_page(page[n], buffer, offset, avail);
+		}
+
+		unlock_page(page[n]);
+		put_page(page[n]);
+	}
+
+out:
+	squashfs_cache_put(buffer);
+	return buffer->error;
+}
+
 static void squashfs_readahead(struct readahead_control *ractl)
 {
 	struct inode *inode = ractl->mapping->host;
@@ -512,9 +547,6 @@ static void squashfs_readahead(struct re
 
 	readahead_expand(ractl, start, (len | mask) + 1);
 
-	if (file_end == 0)
-		return;
-
 	pages = kmalloc_array(max_pages, sizeof(void *), GFP_KERNEL);
 	if (!pages)
 		return;
@@ -540,6 +572,15 @@ static void squashfs_readahead(struct re
 			   (i_size_read(inode) & (msblk->block_size - 1)) :
 			    msblk->block_size;
 
+		if (index == file_end && squashfs_i(inode)->fragment_block !=
+						SQUASHFS_INVALID_BLK) {
+			res = squashfs_readahead_fragment(pages, nr_pages,
+							  expected);
+			if (res)
+				goto skip_pages;
+			continue;
+		}
+
 		bsize = read_blocklist(inode, index, &block);
 		if (bsize == 0)
 			goto skip_pages;
_

Patches currently in -mm which might be from phillip@squashfs.org.uk are


