From: akpm@linux-foundation.org
Subject: + zram-implement-rw_page-operation-of-zram-fix.patch added to -mm tree
Date: Wed, 05 Nov 2014 14:38:50 -0800
Message-ID: <545aa6fa.yhFVVF/mKofA3yfc%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36024 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751020AbaKEWit (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 5 Nov 2014 17:38:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: minchan@kernel.org, david@fromorbit.com, karam.lee@lge.com, willy@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: zram: make rw_page opeartion return 0
has been added to the -mm tree.  Its filename is
     zram-implement-rw_page-operation-of-zram-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/zram-implement-rw_page-operation-of-zram-fix.patch
		echo and later at
		echo  http://ozlabs.org/~akpm/mmotm/broken-out/zram-implement-rw_page-operation-of-zram-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Minchan Kim <minchan@kernel.org>
Subject: zram: make rw_page opeartion return 0

zram_rw_page returns error code to upper layer with PG_error flag
of the page but it should be wrong usage. If submitted IO is
hard fail(ie, I/O again will not succeed), we should return 0,
indicating that the submission was successful but the IO operation
failed.

http://marc.info/?l=linux-mm&m=141511693112734&w=2

This patch fixes below BUG.

[  179.987592] zram0: detected capacity change from 2147483648 to 0
[  179.987570] page:ffffea00008d6300 count:2 mapcount:0 mapping:ffff880025348e88 index:0x0
[  179.987570] flags: 0x100000000020002(error|mappedtodisk)
[  179.987570] page dumped because: VM_BUG_ON_PAGE(!PageLocked(page))
[  179.987570] ------------[ cut here ]------------
[  179.987570] kernel BUG at mm/filemap.c:747!
[  179.987570] invalid opcode: 0000 [#1] SMP
[  179.987570] Dumping ftrace buffer:
[  179.987570]    (ftrace buffer empty)
[  179.987570] Modules linked in:
[  179.987570] CPU: 10 PID: 23080 Comm: udisks-part-id Not tainted 3.18.0-rc2+ #584
[  179.987570] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[  179.987570] task: ffff88001de74200 ti: ffff88001b220000 task.ti: ffff88001b220000
[  179.987570] RIP: 0010:[<ffffffff8114ae12>]  [<ffffffff8114ae12>] unlock_page+0x82/0x90
[  179.987570] RSP: 0018:ffff88001b223998  EFLAGS: 00010246
[  179.987570] RAX: 0000000000000036 RBX: ffff88001e009a50 RCX: 000000000910090f
[  179.987570] RDX: 0000000000000910 RSI: 0000000000000001 RDI: ffffffff81600a7f
[  179.987570] RBP: ffff88001b223998 R08: 0000000000000001 R09: 0000000000000001
[  179.987570] R10: 0000000000000001 R11: 0000000000000000 R12: 0000000000000001
[  179.987570] R13: ffff88001e0099c0 R14: 00000000fffffffb R15: ffff88001e0099c0
[  179.987570] FS:  00007fcb17c73800(0000) GS:ffff880027f40000(0000) knlGS:0000000000000000
[  179.987570] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  179.987570] CR2: 00007fff1629ebc8 CR3: 000000001dc4f000 CR4: 00000000000006e0
[  179.987570] Stack:
[  179.987570]  ffff88001b2239a8 ffffffff8114afde ffff88001b2239d8 ffffffff811f2e52
[  179.987570]  ffff88001e0099c0 00000000fffffffb 0000000000000000 ffff880025348e88
[  179.987570]  ffff88001b223a08 ffffffff812e9ad3 ffff88001b223a08 ffffffff8109b6b3
[  179.987570] Call Trace:
[  179.987570]  [<ffffffff8114afde>] page_endio+0x1e/0x80
[  179.987570]  [<ffffffff811f2e52>] mpage_end_io+0x42/0x60
[  179.987570]  [<ffffffff812e9ad3>] bio_endio+0x53/0xa0
[  179.987570]  [<ffffffff8109b6b3>] ? up_read+0x23/0x40
[  179.987570]  [<ffffffff81413f09>] zram_make_request+0x2a9/0x3c0
[  179.987570]  [<ffffffff812ee330>] generic_make_request+0xc0/0x100
[  179.987570]  [<ffffffff812ee3e5>] submit_bio+0x75/0x140
[  179.987570]  [<ffffffff812ee375>] ? submit_bio+0x5/0x140
[  179.987570]  [<ffffffff811f2e03>] mpage_bio_submit+0x33/0x40
[  179.987570]  [<ffffffff811f3de5>] mpage_readpages+0xf5/0x110
[  179.987570]  [<ffffffff811ed7a0>] ? I_BDEV+0x10/0x10
[  179.987570]  [<ffffffff811ed7a0>] ? I_BDEV+0x10/0x10
[  179.987570]  [<ffffffff81603241>] ? ftrace_call+0x5/0x2f
[  179.987570]  [<ffffffff81603241>] ? ftrace_call+0x5/0x2f
[  179.987570]  [<ffffffff811ee190>] ? blkdev_write_begin+0x30/0x30
[  179.987570]  [<ffffffff811ed7a0>] ? I_BDEV+0x10/0x10
[  179.987570]  [<ffffffff811ee1ad>] blkdev_readpages+0x1d/0x20
[  179.987570]  [<ffffffff81158ed4>] __do_page_cache_readahead+0x204/0x290
[  179.987570]  [<ffffffff81158d99>] ? __do_page_cache_readahead+0xc9/0x290
[  179.987570]  [<ffffffff8114b045>] ? find_get_entry+0x5/0x130
[  179.987570]  [<ffffffff811593cd>] force_page_cache_readahead+0x7d/0xb0
[  179.987570]  [<ffffffff81159443>] page_cache_sync_readahead+0x43/0x50
[  179.987570]  [<ffffffff8114d0e1>] generic_file_read_iter+0x451/0x650
[  179.987570]  [<ffffffff81603241>] ? ftrace_call+0x5/0x2f
[  179.987570]  [<ffffffff811ed947>] blkdev_read_iter+0x37/0x40
[  179.987570]  [<ffffffff811b4358>] new_sync_read+0x78/0xb0
[  179.987570]  [<ffffffff811b555b>] vfs_read+0xab/0x180
[  179.987570]  [<ffffffff811b5682>] SyS_read+0x52/0xb0
[  179.987570]  [<ffffffff816011d2>] system_call_fastpath+0x12/0x17
[  179.987570] Code: 00 4c 8b 82 f8 00 00 00 31 d2 48 d3 ee 48 8d 3c f6 48 89 c6 49 8d 3c f8 e8 dc 9f f4 ff 5d c3 48 c7 c6 88 2c a0 81 e8 1e a8 02 00 <0f> 0b 66 66 66 2e 0f 1f 84 00 00 00 00 00 e8 bb 83 4b 00 55 48
[  179.987570] RIP  [<ffffffff8114ae12>] unlock_page+0x82/0x90
[  179.987570]  RSP <ffff88001b223998>
[  179.987570] ---[ end trace 39c73c1d9da87ec4 ]---
[  180.030327] zram0: detected capacity change from 0 to 2147483648
[  180.033795] Adding 2097148k swap on /dev/zram0.  Priority:-1 extents:1 across:2097148k SSFS
[  181.978291] zram_kern_compi (2685): drop_caches: 3

Signed-off-by: Minchan Kim <minchan@kernel.org>
Cc: Matthew Wilcox <willy@linux.intel.com>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Karam Lee <karam.lee@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |   17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff -puN drivers/block/zram/zram_drv.c~zram-implement-rw_page-operation-of-zram-fix drivers/block/zram/zram_drv.c
--- a/drivers/block/zram/zram_drv.c~zram-implement-rw_page-operation-of-zram-fix
+++ a/drivers/block/zram/zram_drv.c
@@ -948,7 +948,7 @@ static void zram_slot_free_notify(struct
 static int zram_rw_page(struct block_device *bdev, sector_t sector,
 		       struct page *page, int rw)
 {
-	int offset, ret;
+	int offset, err;
 	u32 index;
 	struct zram *zram;
 	struct bio_vec bv;
@@ -956,13 +956,13 @@ static int zram_rw_page(struct block_dev
 	zram = bdev->bd_disk->private_data;
 	if (!valid_io_request(zram, sector, PAGE_SIZE)) {
 		atomic64_inc(&zram->stats.invalid_io);
-		ret = -EINVAL;
+		err = -EINVAL;
 		goto out;
 	}
 
 	down_read(&zram->init_lock);
 	if (unlikely(!init_done(zram))) {
-		ret = -EIO;
+		err = -EIO;
 		goto out_unlock;
 	}
 
@@ -973,13 +973,18 @@ static int zram_rw_page(struct block_dev
 	bv.bv_len = PAGE_SIZE;
 	bv.bv_offset = 0;
 
-	ret = zram_bvec_rw(zram, &bv, index, offset, rw);
+	err = zram_bvec_rw(zram, &bv, index, offset, rw);
 
 out_unlock:
 	up_read(&zram->init_lock);
 out:
-	page_endio(page, rw, ret);
-	return ret;
+	page_endio(page, rw, err);
+
+	/*
+	 * Return 0 prevents I/O fallback trial caused by rw_page fail
+	 * and upper layer can handle this IO error via page error.
+	 */
+	return 0;
 }
 
 static const struct block_device_operations zram_devops = {
_

Patches currently in -mm which might be from minchan@kernel.org are

mm-compaction-skip-the-range-until-proper-target-pageblock-is-met.patch
mm-page_alloc-fix-incorrect-isolation-behavior-by-rechecking-migratetype.patch
mm-page_alloc-add-freepage-on-isolate-pageblock-to-correct-buddy-list.patch
mm-page_alloc-move-freepage-counting-logic-to-__free_one_page.patch
mm-page_alloc-restrict-max-order-of-merging-on-isolated-pageblock.patch
mm-alloc_contig_range-demote-pages-busy-message-from-warn-to-info.patch
mm-compaction-pass-classzone_idx-and-alloc_flags-to-watermark-checking.patch
mm-compaction-simplify-deferred-compaction.patch
mm-compaction-defer-only-on-compact_complete.patch
mm-compaction-always-update-cached-scanner-positions.patch
mm-compaction-more-focused-lru-and-pcplists-draining.patch
zsmalloc-merge-size_class-to-reduce-fragmentation.patch
zram-remove-bio-parameter-from-zram_bvec_rw.patch
zram-change-parameter-from-vaild_io_request.patch
zram-implement-rw_page-operation-of-zram.patch
zram-implement-rw_page-operation-of-zram-fix.patch
debugging-keep-track-of-page-owners.patch
page-owners-correct-page-order-when-to-free-page.patch

