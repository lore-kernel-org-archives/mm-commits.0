From: akpm@linux-foundation.org
Subject: + brd-remove-brd_rw_page.patch added to -mm tree
Date: Fri, 28 Jul 2017 14:20:59 -0700
Message-ID: <597baabb.5P4vN5rDTojWji1s%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52938 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752494AbdG1VVA (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 28 Jul 2017 17:21:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ross.zwisler@linux.intel.com, axboe@kernel.dk, dan.j.williams@intel.com, david@fromorbit.com, hch@infradead.org, jack@suse.cz, jmarchan@redhat.com, karam.lee@lge.com, minchan@kernel.org, ngupta@vflare.org, seungho1.park@lge.com, vishal.l.verma@intel.com, willy@infradead.org, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/block/brd.c: remove brd_rw_page()
has been added to the -mm tree.  Its filename is
     brd-remove-brd_rw_page.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/brd-remove-brd_rw_page.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/brd-remove-brd_rw_page.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
