Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB26FC43334
	for <mm-commits@archiver.kernel.org>; Sat, 11 Jun 2022 20:58:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232630AbiFKU6q (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 11 Jun 2022 16:58:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232277AbiFKU62 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 11 Jun 2022 16:58:28 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2099335270
        for <mm-commits@vger.kernel.org>; Sat, 11 Jun 2022 13:58:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 7EC14CE0959
        for <mm-commits@vger.kernel.org>; Sat, 11 Jun 2022 20:58:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0746C34116;
        Sat, 11 Jun 2022 20:58:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1654981103;
        bh=gPY0oh7TLhwB8ud8PpNLy5DoyKFS4OtaOGrM2dzH3P8=;
        h=Date:To:From:Subject:From;
        b=S/89iXgZCj/yBxWh4vOyezzqIoY2H7TiWqgSV1n+PEclXOLdsEE/iIgSJDMOWJJTA
         ciZweJn7c5bUcBcSKRrhXAghUrXGpzgi2l8D1NXITGu1cl7fARSQl7Z5JEJemBaf7k
         CRNxI0+qUUPkTBGVLLUTe0/CbdfvDel6tc/DrL7o=
Date:   Sat, 11 Jun 2022 13:58:22 -0700
To:     mm-commits@vger.kernel.org, zhengliang6@huawei.com,
        yi.zhang@huawei.com, Xiongwei.Song@windriver.com,
        willy@infradead.org, phillip@squashfs.org.uk,
        m.szyprowski@samsung.com, miaoxie@huawei.com, houtao1@huawei.com,
        hsinyi@chromium.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] revert-squashfs-provide-backing_dev_info-in-order-to-disable-read-ahead.patch removed from -mm tree
Message-Id: <20220611205823.A0746C34116@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: Revert "squashfs: provide backing_dev_info in order to disable read-ahead"
has been removed from the -mm tree.  Its filename was
     revert-squashfs-provide-backing_dev_info-in-order-to-disable-read-ahead.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Hsin-Yi Wang <hsinyi@chromium.org>
Subject: Revert "squashfs: provide backing_dev_info in order to disable read-ahead"
Date: Mon, 6 Jun 2022 23:03:03 +0800

Patch series "Implement readahead for squashfs", v5.

Commit c1f6925e1091("mm: put readahead pages in cache earlier") requires
fs to implement readahead callback.  Otherwise there will be a performance
regression.

Commit 9eec1d897139("squashfs: provide backing_dev_info in order to
disable read-ahead") mitigates the performance drop issue for squashfs by
closing readahead for it.

This series implements readahead callback for squashfs.  The previous
discussion are in [1] and [2].

[1] https://lore.kernel.org/all/CAJMQK-g9G6KQmH-V=BRGX0swZji9Wxe_2c7ht-MMAapdFy2pXw@mail.gmail.com/T/
[2] https://lore.kernel.org/linux-mm/Yn5Yij9pRPCzDozt@casper.infradead.org/t/#m4af4473b94f98a4996cb11756b633a07e5e059d1


This patch (of 3):

This reverts commit 9eec1d897139e5d ("squashfs: provide backing_dev_info
in order to disable read-ahead").

Revert closing the readahead to squashfs since the readahead callback
for squashfs is implemented.

Link: https://lkml.kernel.org/r/20220606150305.1883410-1-hsinyi@chromium.org
Link: https://lkml.kernel.org/r/20220606150305.1883410-2-hsinyi@chromium.org
Signed-off-by: Hsin-Yi Wang <hsinyi@chromium.org>
Suggested-by: Xiongwei Song <Xiongwei.Song@windriver.com>
Cc: Phillip Lougher <phillip@squashfs.org.uk>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Zheng Liang <zhengliang6@huawei.com>
Cc: Zhang Yi <yi.zhang@huawei.com>
Cc: Hou Tao <houtao1@huawei.com>
Cc: Miao Xie <miaoxie@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/squashfs/super.c |   33 ---------------------------------
 1 file changed, 33 deletions(-)

--- a/fs/squashfs/super.c~revert-squashfs-provide-backing_dev_info-in-order-to-disable-read-ahead
+++ a/fs/squashfs/super.c
@@ -29,7 +29,6 @@
 #include <linux/module.h>
 #include <linux/magic.h>
 #include <linux/xattr.h>
-#include <linux/backing-dev.h>
 
 #include "squashfs_fs.h"
 #include "squashfs_fs_sb.h"
@@ -113,24 +112,6 @@ static const struct squashfs_decompresso
 	return decompressor;
 }
 
-static int squashfs_bdi_init(struct super_block *sb)
-{
-	int err;
-	unsigned int major = MAJOR(sb->s_dev);
-	unsigned int minor = MINOR(sb->s_dev);
-
-	bdi_put(sb->s_bdi);
-	sb->s_bdi = &noop_backing_dev_info;
-
-	err = super_setup_bdi_name(sb, "squashfs_%u_%u", major, minor);
-	if (err)
-		return err;
-
-	sb->s_bdi->ra_pages = 0;
-	sb->s_bdi->io_pages = 0;
-
-	return 0;
-}
 
 static int squashfs_fill_super(struct super_block *sb, struct fs_context *fc)
 {
@@ -146,20 +127,6 @@ static int squashfs_fill_super(struct su
 
 	TRACE("Entered squashfs_fill_superblock\n");
 
-	/*
-	 * squashfs provides 'backing_dev_info' in order to disable read-ahead. For
-	 * squashfs, I/O is not deferred, it is done immediately in read_folio,
-	 * which means the user would always have to wait their own I/O. So the effect
-	 * of readahead is very weak for squashfs. squashfs_bdi_init will set
-	 * sb->s_bdi->ra_pages and sb->s_bdi->io_pages to 0 and close readahead for
-	 * squashfs.
-	 */
-	err = squashfs_bdi_init(sb);
-	if (err) {
-		errorf(fc, "squashfs init bdi failed");
-		return err;
-	}
-
 	sb->s_fs_info = kzalloc(sizeof(*msblk), GFP_KERNEL);
 	if (sb->s_fs_info == NULL) {
 		ERROR("Failed to allocate squashfs_sb_info\n");
_

Patches currently in -mm which might be from hsinyi@chromium.org are

squashfs-implement-readahead.patch

