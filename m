Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A0D8C197A0
	for <mm-commits@archiver.kernel.org>; Thu, 16 Nov 2023 15:57:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231289AbjKPP50 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 16 Nov 2023 10:57:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231284AbjKPP5Z (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 16 Nov 2023 10:57:25 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F6F8101
        for <mm-commits@vger.kernel.org>; Thu, 16 Nov 2023 07:57:21 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E769C433C7;
        Thu, 16 Nov 2023 15:57:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1700150241;
        bh=XFi5QH0+U/1gS6FaT7kV0oqxU/8eYHOD5JQI53g338w=;
        h=Date:To:From:Subject:From;
        b=z1qr0CfKZ2yXDrKWzx2dK86oPGz1+/JwL8c8dB0YKqBtbb4MJtbTEDBkizA4S6qtu
         I89krCId6AJYmakA6Yplmv6JrnBEkrzVRVyxK86T70KV5RzcUWr2Or5VM3jYahH73X
         GdH833xixjc4x4dNFrwFpqfcX8+S9cLLEZm0dLEA=
Date:   Thu, 16 Nov 2023 07:57:20 -0800
To:     mm-commits@vger.kernel.org, phillip@squashfs.org.uk,
        eadavis@qq.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [nacked] squashfs-fix-oob-in-squashfs_readahead.patch removed from -mm tree
Message-Id: <20231116155721.0E769C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: squashfs: fix oob in squashfs_readahead
has been removed from the -mm tree.  Its filename was
     squashfs-fix-oob-in-squashfs_readahead.patch

This patch was dropped because it was nacked

------------------------------------------------------
From: Edward Adam Davis <eadavis@qq.com>
Subject: squashfs: fix oob in squashfs_readahead
Date: Wed, 15 Nov 2023 12:05:35 +0800

[Syz log]
SQUASHFS error: Failed to read block 0x6fc: -5
SQUASHFS error: Unable to read metadata cache entry [6fa]
SQUASHFS error: Unable to read metadata cache entry [6fa]
SQUASHFS error: Unable to read metadata cache entry [6fa]
==================================================================
BUG: KASAN: slab-out-of-bounds in __readahead_batch include/linux/pagemap.h:1364 [inline]
BUG: KASAN: slab-out-of-bounds in squashfs_readahead+0x9a6/0x20d0 fs/squashfs/file.c:569
Write of size 8 at addr ffff88801e393648 by task syz-executor100/5067

CPU: 1 PID: 5067 Comm: syz-executor100 Not tainted 6.6.0-syzkaller-15156-g13d88ac54ddd #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/09/2023
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0x1e7/0x2d0 lib/dump_stack.c:106
 print_address_description mm/kasan/report.c:364 [inline]
 print_report+0x163/0x540 mm/kasan/report.c:475
 kasan_report+0x142/0x170 mm/kasan/report.c:588
 __readahead_batch include/linux/pagemap.h:1364 [inline]
 squashfs_readahead+0x9a6/0x20d0 fs/squashfs/file.c:569
 read_pages+0x183/0x830 mm/readahead.c:160
 page_cache_ra_unbounded+0x68e/0x7c0 mm/readahead.c:269
 page_cache_sync_readahead include/linux/pagemap.h:1266 [inline]
 filemap_get_pages+0x49c/0x2080 mm/filemap.c:2497
 filemap_read+0x42b/0x10b0 mm/filemap.c:2593
 __kernel_read+0x425/0x8b0 fs/read_write.c:428
 integrity_kernel_read+0xb0/0xf0 security/integrity/iint.c:221
 ima_calc_file_hash_tfm security/integrity/ima/ima_crypto.c:485 [inline]
 ima_calc_file_shash security/integrity/ima/ima_crypto.c:516 [inline]
 ima_calc_file_hash+0xad1/0x1b30 security/integrity/ima/ima_crypto.c:573
 ima_collect_measurement+0x554/0xb30 security/integrity/ima/ima_api.c:290
 process_measurement+0x1373/0x21c0 security/integrity/ima/ima_main.c:359
 ima_file_check+0xf1/0x170 security/integrity/ima/ima_main.c:557
 do_open fs/namei.c:3624 [inline]
 path_openat+0x2893/0x3280 fs/namei.c:3779

[Bug]
path_openat() called open_last_lookups() before calling do_open() and
open_last_lookups() will eventually call squashfs_read_inode() to set
inode->i_size, but before setting i_size, it is necessary to obtain file_size
from the disk.

However, during the value retrieval process, the length of the value retrieved
from the disk was greater than output->length, resulting(-EIO) in the failure of
squashfs_read_data(), further leading to i_size has not been initialized,
i.e. its value is 0.

This resulted in the failure of squashfs_read_data(), where "SQUASHFS error:
Failed to read block 0x6fc: -5" was output in the syz log.
This also resulted in the failure of squashfs_cache_get(), outputting "SQUASHFS
error: Unable to read metadata cache entry [6fa]" in the syz log.

[Fix]
Before performing a read ahead operation in squashfs_read_folio() and
squashfs_readahead(), check if i_size is not 0 before continuing.

Optimize the return value of squashfs_read_data() and return -EFBIG when the
length is greater than output->length(or (index + length) >
msblk->bytes_used).

Link: https://lkml.kernel.org/r/tencent_35864B36740976B766CA3CC936A496AA3609@qq.com
Fixes: f268eedddf35 ("squashfs: extend "page actor" to handle missing pages")
Signed-off-by: Edward Adam Davis <eadavis@qq.com>
Reported-by: syzbot+604424eb051c2f696163@syzkaller.appspotmail.com
Tested-by: syzbot+604424eb051c2f696163@syzkaller.appspotmail.com
Cc: Phillip Lougher <phillip@squashfs.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/squashfs/block.c |    2 +-
 fs/squashfs/file.c  |    8 ++++++++
 2 files changed, 9 insertions(+), 1 deletion(-)

--- a/fs/squashfs/block.c~squashfs-fix-oob-in-squashfs_readahead
+++ a/fs/squashfs/block.c
@@ -323,7 +323,7 @@ int squashfs_read_data(struct super_bloc
 	}
 	if (length < 0 || length > output->length ||
 			(index + length) > msblk->bytes_used) {
-		res = -EIO;
+		res = length < 0 ? -EIO : -EFBIG;
 		goto out;
 	}
 
--- a/fs/squashfs/file.c~squashfs-fix-oob-in-squashfs_readahead
+++ a/fs/squashfs/file.c
@@ -461,6 +461,11 @@ static int squashfs_read_folio(struct fi
 	TRACE("Entered squashfs_readpage, page index %lx, start block %llx\n",
 				page->index, squashfs_i(inode)->start);
 
+	if (!file_end) {
+		res = -EINVAL;
+		goto out;
+	}
+
 	if (page->index >= ((i_size_read(inode) + PAGE_SIZE - 1) >>
 					PAGE_SHIFT))
 		goto out;
@@ -548,6 +553,9 @@ static void squashfs_readahead(struct re
 	loff_t file_end = i_size_read(inode) >> msblk->block_log;
 	unsigned int max_pages = 1UL << shift;
 
+	if (!file_end)
+		return;
+
 	readahead_expand(ractl, start, (len | mask) + 1);
 
 	pages = kmalloc_array(max_pages, sizeof(void *), GFP_KERNEL);
_

Patches currently in -mm which might be from eadavis@qq.com are


