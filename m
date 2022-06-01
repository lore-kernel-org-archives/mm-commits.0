Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04198C433EF
	for <mm-commits@archiver.kernel.org>; Wed,  1 Jun 2022 20:59:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230483AbiFAU66 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 1 Jun 2022 16:58:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230469AbiFAU64 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 1 Jun 2022 16:58:56 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8FE1176D4F
        for <mm-commits@vger.kernel.org>; Wed,  1 Jun 2022 13:58:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 807CEB816CC
        for <mm-commits@vger.kernel.org>; Wed,  1 Jun 2022 20:58:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB153C385B8;
        Wed,  1 Jun 2022 20:58:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1654117132;
        bh=rOoo9ufJNo7s03mi9wUaBXWx3w2MO4fPJ2svb2QLkwA=;
        h=Date:To:From:Subject:From;
        b=Y/Wrsc8JQE+1+49qRR4nXFdp8V68j8aOybkDQbYLAQXcWsPuuU5yN3oLNcwYdrvkW
         2opHWJ99/AVwSKZNQHwMIJnrPV6x9sLGNrxGZy6LQMLwdEFTLx4PwbnCitE1A5eCKk
         2vxUBMhzFGGZPXcNQLN7YZMSrQbt/1p/kfjNrStE=
Date:   Wed, 01 Jun 2022 13:58:51 -0700
To:     mm-commits@vger.kernel.org, zhengliang6@huawei.com,
        yi.zhang@huawei.com, Xiongwei.Song@windriver.com,
        willy@infradead.org, phillip@squashfs.org.uk, miaoxie@huawei.com,
        lkp@intel.com, houtao1@huawei.com, hsinyi@chromium.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + revert-squashfs-provide-backing_dev_info-in-order-to-disable-read-ahead.patch added to mm-nonmm-unstable branch
Message-Id: <20220601205851.EB153C385B8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: Revert "squashfs: provide backing_dev_info in order to disable read-ahead"
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     revert-squashfs-provide-backing_dev_info-in-order-to-disable-read-ahead.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/revert-squashfs-provide-backing_dev_info-in-order-to-disable-read-ahead.patch

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
Subject: Revert "squashfs: provide backing_dev_info in order to disable read-ahead"
Date: Wed, 1 Jun 2022 18:39:20 +0800

Patch series "Implement readahead for squashfs", v4.

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

This reverts commit 9eec1d897139e ("squashfs: provide backing_dev_info in
order to disable read-ahead").

Revert closing the readahead to squashfs since the readahead callback
for squashfs is implemented.

Link: https://lkml.kernel.org/r/20220601103922.1338320-1-hsinyi@chromium.org
Link: https://lkml.kernel.org/r/20220601103922.1338320-2-hsinyi@chromium.org
Signed-off-by: Hsin-Yi Wang <hsinyi@chromium.org>
Suggested-by: Xiongwei Song <Xiongwei.Song@windriver.com>
Cc: Hou Tao <houtao1@huawei.com>
Cc: kernel test robot <lkp@intel.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Miao Xie <miaoxie@huawei.com>
Cc: Phillip Lougher <phillip@squashfs.org.uk>
Cc: Zhang Yi <yi.zhang@huawei.com>
Cc: Zheng Liang <zhengliang6@huawei.com>
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

revert-squashfs-provide-backing_dev_info-in-order-to-disable-read-ahead.patch
squashfs-implement-readahead.patch

