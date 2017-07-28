From: akpm@linux-foundation.org
Subject: + pmem-remove-pmem_rw_page.patch added to -mm tree
Date: Fri, 28 Jul 2017 14:20:57 -0700
Message-ID: <597baab9.FH+g5LTKji0tvx32%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52916 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752628AbdG1VU6 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 28 Jul 2017 17:20:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ross.zwisler@linux.intel.com, axboe@kernel.dk, dan.j.williams@intel.com, david@fromorbit.com, hch@infradead.org, jack@suse.cz, jmarchan@redhat.com, karam.lee@lge.com, minchan@kernel.org, ngupta@vflare.org, seungho1.park@lge.com, vishal.l.verma@intel.com, willy@infradead.org, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/nvdimm/pmem.c: remove pmem_rw_page()
has been added to the -mm tree.  Its filename is
     pmem-remove-pmem_rw_page.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/pmem-remove-pmem_rw_page.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/pmem-remove-pmem_rw_page.patch

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
Subject: drivers/nvdimm/pmem.c: remove pmem_rw_page()

The rw_page() interface doesn't provide a clear performance benefit for
PMEM and has had a nonzero maintenance burden, so remove it.

Link: http://lkml.kernel.org/r/20170728165604.10455-3-ross.zwisler@linux.intel.com
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

 drivers/nvdimm/pmem.c |   22 ----------------------
 1 file changed, 22 deletions(-)

diff -puN drivers/nvdimm/pmem.c~pmem-remove-pmem_rw_page drivers/nvdimm/pmem.c
--- a/drivers/nvdimm/pmem.c~pmem-remove-pmem_rw_page
+++ a/drivers/nvdimm/pmem.c
@@ -200,27 +200,6 @@ static blk_qc_t pmem_make_request(struct
 	return BLK_QC_T_NONE;
 }
 
-static int pmem_rw_page(struct block_device *bdev, sector_t sector,
-		       struct page *page, bool is_write)
-{
-	struct pmem_device *pmem = bdev->bd_queue->queuedata;
-	blk_status_t rc;
-
-	rc = pmem_do_bvec(pmem, page, hpage_nr_pages(page) * PAGE_SIZE,
-			  0, is_write, sector);
-
-	/*
-	 * The ->rw_page interface is subtle and tricky.  The core
-	 * retries on any error, so we can only invoke page_endio() in
-	 * the successful completion case.  Otherwise, we'll see crashes
-	 * caused by double completion.
-	 */
-	if (rc == 0)
-		page_endio(page, is_write, 0);
-
-	return blk_status_to_errno(rc);
-}
