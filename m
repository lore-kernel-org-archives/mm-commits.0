From: akpm@linux-foundation.org
Subject: + btt-remove-btt_rw_page.patch added to -mm tree
Date: Fri, 28 Jul 2017 14:20:54 -0700
Message-ID: <597baab6.knfR8sXqFsQKT9Aq%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52888 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752056AbdG1VU4 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 28 Jul 2017 17:20:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ross.zwisler@linux.intel.com, axboe@kernel.dk, dan.j.williams@intel.com, david@fromorbit.com, hch@infradead.org, jack@suse.cz, jmarchan@redhat.com, karam.lee@lge.com, minchan@kernel.org, ngupta@vflare.org, seungho1.park@lge.com, vishal.l.verma@intel.com, willy@infradead.org, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/nvdimm/btt.c: remove btt_rw_page()
has been added to the -mm tree.  Its filename is
     btt-remove-btt_rw_page.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/btt-remove-btt_rw_page.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/btt-remove-btt_rw_page.patch

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
Subject: drivers/nvdimm/btt.c: remove btt_rw_page()

Patch series "remove rw_page() from brd, pmem and btt".

Dan Williams and Christoph Hellwig have recently expressed doubt about
whether the rw_page() interface made sense for synchronous memory drivers
[1][2].  It's unclear whether this interface has any performance benefit
for these drivers, but as we continue to fix bugs it is clear that it does
have a maintenance burden.  This series removes the rw_page()
implementations in brd, pmem and btt to relieve this burden.

These patches have passed ext4 and XFS xfstest regression testing with
a memory mode pmem driver (without DAX), with pmem + btt and with brd.


This patch (of 3):

The rw_page() interface doesn't provide a clear performance benefit for
the BTT and has had a nonzero maintenance burden, so remove it.

Link: http://lkml.kernel.org/r/20170728165604.10455-2-ross.zwisler@linux.intel.com
Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Suggested-by: Dan Williams <dan.j.williams@intel.com>
Suggested-by: Christoph Hellwig <hch@infradead.org>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: "karam . lee" <karam.lee@lge.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Jerome Marchand <jmarchan@redhat.com>
Cc: Nitin Gupta <ngupta@vflare.org>
Cc: Seungho Park <seungho1.park@lge.com>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Vishal Verma <vishal.l.verma@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/nvdimm/btt.c |   17 -----------------
 1 file changed, 17 deletions(-)

diff -puN drivers/nvdimm/btt.c~btt-remove-btt_rw_page drivers/nvdimm/btt.c
--- a/drivers/nvdimm/btt.c~btt-remove-btt_rw_page
+++ a/drivers/nvdimm/btt.c
@@ -1236,22 +1236,6 @@ static blk_qc_t btt_make_request(struct
 	return BLK_QC_T_NONE;
 }
 
-static int btt_rw_page(struct block_device *bdev, sector_t sector,
-		struct page *page, bool is_write)
-{
-	struct btt *btt = bdev->bd_disk->private_data;
-	int rc;
-	unsigned int len;
-
-	len = hpage_nr_pages(page) * PAGE_SIZE;
-	rc = btt_do_bvec(btt, NULL, page, len, 0, is_write, sector);
-	if (rc == 0)
-		page_endio(page, is_write, 0);
-
-	return rc;
-}
-
