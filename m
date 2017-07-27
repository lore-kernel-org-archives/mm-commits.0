From: akpm@linux-foundation.org
Subject: + block-thp-make-block_device_operationsrw_page-support-thp.patch added to -mm tree
Date: Thu, 27 Jul 2017 16:37:14 -0700
Message-ID: <597a792a.ep/AnaIRfsbYvWPX%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37680 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751634AbdG0XhP (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 27 Jul 2017 19:37:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ying.huang@intel.com, aarcange@redhat.com, axboe@kernel.dk, dan.j.williams@intel.com, hannes@cmpxchg.org, hughd@google.com, kirill.shutemov@linux.intel.com, mhocko@kernel.org, minchan@kernel.org, riel@redhat.com, ross.zwisler@intel.com, shli@kernel.org, vishal.l.verma@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: block, THP: make block_device_operations.rw_page support THP
has been added to the -mm tree.  Its filename is
     block-thp-make-block_device_operationsrw_page-support-thp.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/block-thp-make-block_device_operationsrw_page-support-thp.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/block-thp-make-block_device_operationsrw_page-support-thp.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Huang Ying <ying.huang@intel.com>
Subject: block, THP: make block_device_operations.rw_page support THP

The .rw_page in struct block_device_operations is used by the swap
subsystem to read/write the page contents from/into the corresponding swap
slot in the swap device.  To support the THP (Transparent Huge Page) swap
optimization, the .rw_page is enhanced to support to read/write THP if
possible.

Link: http://lkml.kernel.org/r/20170724051840.2309-6-ying.huang@intel.com
Signed-off-by: "Huang, Ying" <ying.huang@intel.com>
Reviewed-by: Ross Zwisler <ross.zwisler@intel.com> [for brd.c, zram_drv.c, pmem.c]
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Vishal L Verma <vishal.l.verma@intel.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Rik van Riel <riel@redhat.com>
Cc: Shaohua Li <shli@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/brd.c           |    6 ++++-
 drivers/block/zram/zram_drv.c |    2 +
 drivers/nvdimm/btt.c          |    4 ++-
 drivers/nvdimm/pmem.c         |   37 ++++++++++++++++++++++++--------
 4 files changed, 38 insertions(+), 11 deletions(-)

diff -puN drivers/block/brd.c~block-thp-make-block_device_operationsrw_page-support-thp drivers/block/brd.c
--- a/drivers/block/brd.c~block-thp-make-block_device_operationsrw_page-support-thp
+++ a/drivers/block/brd.c
@@ -326,7 +326,11 @@ static int brd_rw_page(struct block_devi
 		       struct page *page, bool is_write)
 {
 	struct brd_device *brd = bdev->bd_disk->private_data;
-	int err = brd_do_bvec(brd, page, PAGE_SIZE, 0, is_write, sector);
+	int err;
+
+	if (PageTransHuge(page))
+		return -ENOTSUPP;
+	err = brd_do_bvec(brd, page, PAGE_SIZE, 0, is_write, sector);
 	page_endio(page, is_write, err);
 	return err;
 }
diff -puN drivers/block/zram/zram_drv.c~block-thp-make-block_device_operationsrw_page-support-thp drivers/block/zram/zram_drv.c
--- a/drivers/block/zram/zram_drv.c~block-thp-make-block_device_operationsrw_page-support-thp
+++ a/drivers/block/zram/zram_drv.c
@@ -1284,6 +1284,8 @@ static int zram_rw_page(struct block_dev
 	struct zram *zram;
 	struct bio_vec bv;
 
+	if (PageTransHuge(page))
+		return -ENOTSUPP;
 	zram = bdev->bd_disk->private_data;
 
 	if (!valid_io_request(zram, sector, PAGE_SIZE)) {
diff -puN drivers/nvdimm/btt.c~block-thp-make-block_device_operationsrw_page-support-thp drivers/nvdimm/btt.c
--- a/drivers/nvdimm/btt.c~block-thp-make-block_device_operationsrw_page-support-thp
+++ a/drivers/nvdimm/btt.c
@@ -1241,8 +1241,10 @@ static int btt_rw_page(struct block_devi
 {
 	struct btt *btt = bdev->bd_disk->private_data;
 	int rc;
+	unsigned int len;
 
-	rc = btt_do_bvec(btt, NULL, page, PAGE_SIZE, 0, is_write, sector);
+	len = hpage_nr_pages(page) * PAGE_SIZE;
+	rc = btt_do_bvec(btt, NULL, page, len, 0, is_write, sector);
 	if (rc == 0)
 		page_endio(page, is_write, 0);
 
diff -puN drivers/nvdimm/pmem.c~block-thp-make-block_device_operationsrw_page-support-thp drivers/nvdimm/pmem.c
--- a/drivers/nvdimm/pmem.c~block-thp-make-block_device_operationsrw_page-support-thp
+++ a/drivers/nvdimm/pmem.c
@@ -80,22 +80,40 @@ static blk_status_t pmem_clear_poison(st
 static void write_pmem(void *pmem_addr, struct page *page,
 		unsigned int off, unsigned int len)
 {
-	void *mem = kmap_atomic(page);
+	unsigned int chunk;
+	void *mem;
 
-	memcpy_flushcache(pmem_addr, mem + off, len);
-	kunmap_atomic(mem);
+	while (len) {
+		mem = kmap_atomic(page);
+		chunk = min_t(unsigned int, len, PAGE_SIZE);
+		memcpy_flushcache(pmem_addr, mem + off, chunk);
+		kunmap_atomic(mem);
+		len -= chunk;
+		off = 0;
+		page++;
+		pmem_addr += PAGE_SIZE;
+	}
 }
 
 static blk_status_t read_pmem(struct page *page, unsigned int off,
 		void *pmem_addr, unsigned int len)
 {
+	unsigned int chunk;
 	int rc;
-	void *mem = kmap_atomic(page);
+	void *mem;
 
-	rc = memcpy_mcsafe(mem + off, pmem_addr, len);
-	kunmap_atomic(mem);
-	if (rc)
-		return BLK_STS_IOERR;
+	while (len) {
+		mem = kmap_atomic(page);
+		chunk = min_t(unsigned int, len, PAGE_SIZE);
+		rc = memcpy_mcsafe(mem + off, pmem_addr, chunk);
+		kunmap_atomic(mem);
+		if (rc)
+			return BLK_STS_IOERR;
+		len -= chunk;
+		off = 0;
+		page++;
+		pmem_addr += PAGE_SIZE;
+	}
 	return BLK_STS_OK;
 }
 
@@ -188,7 +206,8 @@ static int pmem_rw_page(struct block_dev
 	struct pmem_device *pmem = bdev->bd_queue->queuedata;
 	blk_status_t rc;
 
-	rc = pmem_do_bvec(pmem, page, PAGE_SIZE, 0, is_write, sector);
+	rc = pmem_do_bvec(pmem, page, hpage_nr_pages(page) * PAGE_SIZE,
+			  0, is_write, sector);
 
 	/*
 	 * The ->rw_page interface is subtle and tricky.  The core
_

Patches currently in -mm which might be from ying.huang@intel.com are

mm-thp-swap-support-to-clear-swap-cache-flag-for-thp-swapped-out.patch
mm-thp-swap-support-to-reclaim-swap-space-for-thp-swapped-out.patch
mm-thp-swap-make-reuse_swap_page-works-for-thp-swapped-out.patch
mm-thp-swap-dont-allocate-huge-cluster-for-file-backed-swap-device.patch
block-thp-make-block_device_operationsrw_page-support-thp.patch
test-code-to-write-thp-to-swap-device-as-a-whole.patch
mm-thp-swap-support-to-split-thp-for-thp-swapped-out.patch
memcg-thp-swap-support-move-mem-cgroup-charge-for-thp-swapped-out.patch
memcg-thp-swap-avoid-to-duplicated-charge-thp-in-swap-cache.patch
memcg-thp-swap-make-mem_cgroup_swapout-support-thp.patch
mm-thp-swap-delay-splitting-thp-after-swapped-out.patch
mm-thp-swap-add-thp-swapping-out-fallback-counting.patch

