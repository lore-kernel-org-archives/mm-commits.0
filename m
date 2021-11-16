Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A8FFC433F5
	for <mm-commits@archiver.kernel.org>; Tue, 16 Nov 2021 21:17:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4989561BF5
	for <mm-commits@archiver.kernel.org>; Tue, 16 Nov 2021 21:17:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229543AbhKPVUB (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 16 Nov 2021 16:20:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:47952 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229532AbhKPVUA (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 16 Nov 2021 16:20:00 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2B10361BBD;
        Tue, 16 Nov 2021 21:17:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1637097423;
        bh=PlhpfgD1PwnQd6s+PsSVQR3S3RIZlUz/FryMWCfKwes=;
        h=Date:From:To:Subject:From;
        b=m78Sd5p3R9hMM5W55ll844frLCVi7QQhsfoPa810jkLWJvK16MaXpJdNk4gXIegJS
         YRZz8WOAG3eeBbxGUCXAocsglEqF282lgm59K2eO+FR6F7ddgyoQJczBUKa2bq8xjr
         T3BGvbgbvZmDoD7I+zz2iLgQAYmdR9MGbUnDLeQk=
Date:   Tue, 16 Nov 2021 13:17:02 -0800
From:   akpm@linux-foundation.org
To:     houtao1@huawei.com, miaoxie@huawei.com, mm-commits@vger.kernel.org,
        phillip@squashfs.org.uk, yi.zhang@huawei.com,
        zhengliang6@huawei.com
Subject:  +
 squashfs-provides-backing_dev_info-in-order-to-disable-read-ahead.patch
 added to -mm tree
Message-ID: <20211116211702.hwNv5thzD%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: squashfs: provide backing_dev_info in order to disable read-ahead
has been added to the -mm tree.  Its filename is
     squashfs-provides-backing_dev_info-in-order-to-disable-read-ahead.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/squashfs-provides-backing_dev_info-in-order-to-disable-read-ahead.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/squashfs-provides-backing_dev_info-in-order-to-disable-read-ahead.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Zheng Liang <zhengliang6@huawei.com>
Subject: squashfs: provide backing_dev_info in order to disable read-ahead

Commit c1f6925e1091("mm: put readahead pages in cache earlier") causes the
read performance of squashfs to deteriorate.Through testing, we find that
the performance will be back by closing the readahead of squashfs.  So we
want to learn the way of ubifs, provides backing_dev_info and disable
read-ahead.

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

Patches currently in -mm which might be from zhengliang6@huawei.com are

squashfs-provides-backing_dev_info-in-order-to-disable-read-ahead.patch

