Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C51D7C433EF
	for <mm-commits@archiver.kernel.org>; Fri, 14 Jan 2022 22:03:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230093AbiANWDe (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 14 Jan 2022 17:03:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230078AbiANWDd (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 14 Jan 2022 17:03:33 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B302BC061574
        for <mm-commits@vger.kernel.org>; Fri, 14 Jan 2022 14:03:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4E3E361FF6
        for <mm-commits@vger.kernel.org>; Fri, 14 Jan 2022 22:03:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D26CC36AE9;
        Fri, 14 Jan 2022 22:03:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642197812;
        bh=qgTwgytU62x3ftLkNF/pxm98+myLzfnACdaOnksfyw4=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=xkwq3AU6W7cYXR5uAAje09hFKir99TIfMOwb51DOA9CynvdEbKy0xlVJKDPbitvbR
         roWYvxWoyMFspktgPikxm/aWdaxF6ol4VvQPMOiTL904qqkr4zP5TWINezAJlL+oQh
         qmWDqNhcPUH8gcI1BwpU+ZPNN7PlYMw5JmCIKU5Y=
Date:   Fri, 14 Jan 2022 14:03:31 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, houtao1@huawei.com, linux-mm@kvack.org,
        miaoxie@huawei.com, mm-commits@vger.kernel.org,
        phillip@squashfs.org.uk, torvalds@linux-foundation.org,
        yi.zhang@huawei.com, zhengliang6@huawei.com
Subject:  [patch 013/146] squashfs: provide backing_dev_info in
 order to disable read-ahead
Message-ID: <20220114220331.FqvedamY0%akpm@linux-foundation.org>
In-Reply-To: <20220114140222.6b14f0061194d3200000c52d@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Zheng Liang <zhengliang6@huawei.com>
Subject: squashfs: provide backing_dev_info in order to disable read-ahead

Commit c1f6925e1091 ("mm: put readahead pages in cache earlier") causes
the read performance of squashfs to deteriorate.Through testing, we find
that the performance will be back by closing the readahead of squashfs. 
So we want to learn the way of ubifs, provides backing_dev_info and
disable read-ahead.

--------------------------------------------------------------------
We tested the following data by fio.
squashfs image blocksize=128K
test command:
fio --name basic --bs=? --filename="/mnt/test_file" --rw=? --iodepth=1 --ioengine=psync --runtime=200 --time_based

turn on squashfs readahead in 5.10 kernel
bs(k)      read/randread           MB/s
4            randread              271
128          randread              231
1024         randread              246
4            read                  310
128          read                  245
1024         read                  247

turn off squashfs readahead in 5.10 kernel
bs(k)      read/randread           MB/s
4            randread              293
128          randread              330
1024         randread              363
4            read                  338
128          read                  360
1024         read                  365

turn on squashfs readahead and revert the
commit c1f6925e1091("mm: put readahead
pages in cache earlier") in 5.10 kernel
bs(k)      read/randread           MB/s
4           randread               289
128         randread               306
1024        randread               335
4           read                   337
128         read                   336
1024        read                   338

Link: https://lkml.kernel.org/r/20211116113141.1391026-1-zhengliang6@huawei.com
Signed-off-by: Zheng Liang <zhengliang6@huawei.com>
Reviewed-by: Phillip Lougher <phillip@squashfs.org.uk>
Cc: Zhang Yi <yi.zhang@huawei.com>
Cc: Hou Tao <houtao1@huawei.com>
Cc: Miao Xie <miaoxie@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/squashfs/super.c |   33 +++++++++++++++++++++++++++++++++
 1 file changed, 33 insertions(+)

--- a/fs/squashfs/super.c~squashfs-provides-backing_dev_info-in-order-to-disable-read-ahead
+++ a/fs/squashfs/super.c
@@ -29,6 +29,7 @@
 #include <linux/module.h>
 #include <linux/magic.h>
 #include <linux/xattr.h>
+#include <linux/backing-dev.h>
 
 #include "squashfs_fs.h"
 #include "squashfs_fs_sb.h"
@@ -112,6 +113,24 @@ static const struct squashfs_decompresso
 	return decompressor;
 }
 
+static int squashfs_bdi_init(struct super_block *sb)
+{
+	int err;
+	unsigned int major = MAJOR(sb->s_dev);
+	unsigned int minor = MINOR(sb->s_dev);
+
+	bdi_put(sb->s_bdi);
+	sb->s_bdi = &noop_backing_dev_info;
+
+	err = super_setup_bdi_name(sb, "squashfs_%u_%u", major, minor);
+	if (err)
+		return err;
+
+	sb->s_bdi->ra_pages = 0;
+	sb->s_bdi->io_pages = 0;
+
+	return 0;
+}
 
 static int squashfs_fill_super(struct super_block *sb, struct fs_context *fc)
 {
@@ -127,6 +146,20 @@ static int squashfs_fill_super(struct su
 
 	TRACE("Entered squashfs_fill_superblock\n");
 
+	/*
+	 * squashfs provides 'backing_dev_info' in order to disable read-ahead. For
+	 * squashfs, I/O is not deferred, it is done immediately in readpage,
+	 * which means the user would always have to wait their own I/O. So the effect
+	 * of readahead is very weak for squashfs. squashfs_bdi_init will set
+	 * sb->s_bdi->ra_pages and sb->s_bdi->io_pages to 0 and close readahead for
+	 * squashfs.
+	 */
+	err = squashfs_bdi_init(sb);
+	if (err) {
+		errorf(fc, "squashfs init bdi failed");
+		return err;
+	}
+
 	sb->s_fs_info = kzalloc(sizeof(*msblk), GFP_KERNEL);
 	if (sb->s_fs_info == NULL) {
 		ERROR("Failed to allocate squashfs_sb_info\n");
_
