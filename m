From: akpm@linux-foundation.org
Subject: + zram-implement-rw_page-operation-of-zram.patch added to -mm
 tree
Date: Thu, 23 Oct 2014 12:53:50 -0700
Message-ID: <54495cce.QoxJQcdHSfqti7jI%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45703 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754024AbaJWTxu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 23 Oct 2014 15:53:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: karam.lee@lge.com, jmarchan@redhat.com, matthew.r.wilcox@intel.com, minchan@kernel.org, ngupta@vflare.org, seungho1.park@lge.com, mm-commits@vger.kernel.org


The patch titled
     Subject: zram: implement rw_page operation of zram
has been added to the -mm tree.  Its filename is
     zram-implement-rw_page-operation-of-zram.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/zram-implement-rw_page-operation-of-zram.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/zram-implement-rw_page-operation-of-zram.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

Signed-off-by: karam.lee <karam.lee@lge.com>
Acked-by: Minchan Kim <minchan@kernel.org>
Acked-by: Jerome Marchand <jmarchan@redhat.com>
Cc: Matthew Wilcox <matthew.r.wilcox@intel.com>
Cc: Nitin Gupta <ngupta@vflare.org>
Cc: <seungho1.park@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |   38 ++++++++++++++++++++++++++++++++
 1 file changed, 38 insertions(+)

diff -puN drivers/block/zram/zram_drv.c~zram-implement-rw_page-operation-of-zram drivers/block/zram/zram_drv.c
--- a/drivers/block/zram/zram_drv.c~zram-implement-rw_page-operation-of-zram
+++ a/drivers/block/zram/zram_drv.c
@@ -942,8 +942,46 @@ static void zram_slot_free_notify(struct
 	atomic64_inc(&zram->stats.notify_free);
 }
 
+static int zram_rw_page(struct block_device *bdev, sector_t sector,
+		       struct page *page, int rw)
+{
+	int offset, ret;
+	u32 index;
+	struct zram *zram;
+	struct bio_vec bv;
+
+	zram = bdev->bd_disk->private_data;
+	if (!valid_io_request(zram, sector, PAGE_SIZE)) {
+		atomic64_inc(&zram->stats.invalid_io);
+		ret = -EINVAL;
+		goto out;
+	}
+
+	down_read(&zram->init_lock);
+	if (unlikely(!init_done(zram))) {
+		ret = -EIO;
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
+	ret = zram_bvec_rw(zram, &bv, index, offset, rw);
+
+out_unlock:
+	up_read(&zram->init_lock);
+out:
+	page_endio(page, rw, ret);
+	return ret;
+}
+
 static const struct block_device_operations zram_devops = {
 	.swap_slot_free_notify = zram_slot_free_notify,
+	.rw_page = zram_rw_page,
 	.owner = THIS_MODULE
 };
 
_

Patches currently in -mm which might be from karam.lee@lge.com are

zram-remove-bio-parameter-from-zram_bvec_rw.patch
zram-change-parameter-from-vaild_io_request.patch
zram-implement-rw_page-operation-of-zram.patch

