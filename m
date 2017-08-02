From: akpm@linux-foundation.org
Subject: [withdrawn] brd-remove-brd_rw_page.patch removed from -mm tree
Date: Wed, 02 Aug 2017 15:29:20 -0700
Message-ID: <59825240.f0EdxxgyP4FCsRCa%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49372 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751214AbdHBW3V (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 2 Aug 2017 18:29:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ross.zwisler@linux.intel.com, axboe@kernel.dk, dan.j.williams@intel.com, david@fromorbit.com, hch@infradead.org, jack@suse.cz, jmarchan@redhat.com, karam.lee@lge.com, minchan@kernel.org, ngupta@vflare.org, seungho1.park@lge.com, vishal.l.verma@intel.com, willy@infradead.org, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/block/brd.c: remove brd_rw_page()
has been removed from the -mm tree.  Its filename was
     brd-remove-brd_rw_page.patch

This patch was dropped because it was withdrawn

------------------------------------------------------
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: drivers/block/brd.c: remove brd_rw_page()

The rw_page() interface doesn't provide a clear performance benefit for
BRD and has had a nonzero maintenance burden, so remove it.

Link: http://lkml.kernel.org/r/20170728165604.10455-4-ross.zwisler@linux.intel.com
Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Suggested-by: Dan Williams <dan.j.williams@intel.com>
Suggested-by: Christoph Hellwig <hch@infradead.org>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: "karam . lee" <karam.lee@lge.com>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Jerome Marchand <jmarchan@redhat.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Nitin Gupta <ngupta@vflare.org>
Cc: Seungho Park <seungho1.park@lge.com>
Cc: Vishal Verma <vishal.l.verma@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/brd.c |   14 --------------
 1 file changed, 14 deletions(-)

diff -puN drivers/block/brd.c~brd-remove-brd_rw_page drivers/block/brd.c
--- a/drivers/block/brd.c~brd-remove-brd_rw_page
+++ a/drivers/block/brd.c
@@ -322,19 +322,6 @@ io_error:
 	return BLK_QC_T_NONE;
 }
 
-static int brd_rw_page(struct block_device *bdev, sector_t sector,
-		       struct page *page, bool is_write)
-{
-	struct brd_device *brd = bdev->bd_disk->private_data;
-	int err;
-
-	if (PageTransHuge(page))
-		return -ENOTSUPP;
-	err = brd_do_bvec(brd, page, PAGE_SIZE, 0, is_write, sector);
-	page_endio(page, is_write, err);
-	return err;
-}
