From: akpm@linux-foundation.org
Subject: [merged] zram-implement-rw_page-operation-of-zram.patch removed
 from -mm tree
Date: Sat, 13 Dec 2014 20:08:42 -0800
Message-ID: <548d0d4a.zT23Xwq5XIjuEPcu%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47753 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752833AbaLNEIe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sat, 13 Dec 2014 23:08:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: karam.lee@lge.com, jmarchan@redhat.com, matthew.r.wilcox@intel.com, minchan@kernel.org, ngupta@vflare.org, sergey.senozhatsky@gmail.com, seungho1.park@lge.com, mm-commits@vger.kernel.org


The patch titled
     Subject: zram: implement rw_page operation of zram
has been removed from the -mm tree.  Its filename was
     zram-implement-rw_page-operation-of-zram.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "karam.lee" <karam.lee@lge.com>
Subject: zram: implement rw_page operation of zram

This patch implements rw_page operation for zram block device.

I implemented the feature in zram and tested it.  Test bed was the G2, LG
electronic mobile device, whtich has msm8974 processor and 2GB memory.

With a memory allocation test program consuming memory, the system
generates swap.

Operating time of swap_write_page() was measured.

--------------------------------------------------
|             |   operating time   | improvement |
|             |  (20 runs average) |             |
--------------------------------------------------
|with patch   |    1061.15 us      |    +2.4%    |
--------------------------------------------------
|without patch|    1087.35 us      |             |
--------------------------------------------------

Each test(with paged_io,with BIO) result set shows normal distribution and
has equal variance.  I mean the two values are valid result to compare.  I
can say operation with paged I/O(without BIO) is faster 2.4% with
confidence level 95%.

[minchan@kernel.org: make rw_page opeartion return 0]
[minchan@kernel.org: rely on the bi_end_io for zram_rw_page fails]
[sergey.senozhatsky@gmail.com: code cleanup]
[minchan@kernel.org: add comment]
Signed-off-by: karam.lee <karam.lee@lge.com>
Acked-by: Minchan Kim <minchan@kernel.org>
Acked-by: Jerome Marchand <jmarchan@redhat.com>
Cc: Matthew Wilcox <matthew.r.wilcox@intel.com>
Cc: Nitin Gupta <ngupta@vflare.org>
Cc: <seungho1.park@lge.com>
Signed-off-by: Minchan Kim <minchan@kernel.org>
Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |   44 ++++++++++++++++++++++++++++++++
 1 file changed, 44 insertions(+)

diff -puN drivers/block/zram/zram_drv.c~zram-implement-rw_page-operation-of-zram drivers/block/zram/zram_drv.c
--- a/drivers/block/zram/zram_drv.c~zram-implement-rw_page-operation-of-zram
+++ a/drivers/block/zram/zram_drv.c
@@ -945,8 +945,52 @@ static void zram_slot_free_notify(struct
 	atomic64_inc(&zram->stats.notify_free);
 }
 
+static int zram_rw_page(struct block_device *bdev, sector_t sector,
+		       struct page *page, int rw)
+{
+	int offset, err;
+	u32 index;
+	struct zram *zram;
+	struct bio_vec bv;
+
+	zram = bdev->bd_disk->private_data;
+	if (!valid_io_request(zram, sector, PAGE_SIZE)) {
+		atomic64_inc(&zram->stats.invalid_io);
+		return -EINVAL;
+	}
+
+	down_read(&zram->init_lock);
+	if (unlikely(!init_done(zram))) {
+		err = -EIO;
+		goto out_unlock;
+	}
+
+	index = sector >> SECTORS_PER_PAGE_SHIFT;
+	offset = sector & (SECTORS_PER_PAGE - 1) << SECTOR_SHIFT;
+
+	bv.bv_page = page;
+	bv.bv_len = PAGE_SIZE;
+	bv.bv_offset = 0;
+
+	err = zram_bvec_rw(zram, &bv, index, offset, rw);
+out_unlock:
+	up_read(&zram->init_lock);
+	/*
+	 * If I/O fails, just return error(ie, non-zero) without
+	 * calling page_endio.
+	 * It causes resubmit the I/O with bio request by upper functions
+	 * of rw_page(e.g., swap_readpage, __swap_writepage) and
+	 * bio->bi_end_io does things to handle the error
+	 * (e.g., SetPageError, set_page_dirty and extra works).
+	 */
+	if (err == 0)
+		page_endio(page, rw, 0);
+	return err;
+}
+
 static const struct block_device_operations zram_devops = {
 	.swap_slot_free_notify = zram_slot_free_notify,
+	.rw_page = zram_rw_page,
 	.owner = THIS_MODULE
 };
 
_

Patches currently in -mm which might be from karam.lee@lge.com are

origin.patch

