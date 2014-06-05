From: akpm@linux-foundation.org
Subject: [merged] brd-add-support-for-rw_page.patch removed from -mm tree
Date: Thu, 05 Jun 2014 12:50:38 -0700
Message-ID: <5390ca0e./mZquWigYqoGYvA/%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56026 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751581AbaFETuj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Jun 2014 15:50:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, hughd@google.com, dheeraj.reddy@intel.com, david@fromorbit.com, matthew.r.wilcox@intel.com

Subject: [merged] brd-add-support-for-rw_page.patch removed from -mm tree
To: matthew.r.wilcox@intel.com,david@fromorbit.com,dheeraj.reddy@intel.com,hughd@google.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 05 Jun 2014 12:50:38 -0700


The patch titled
     Subject: brd: add support for rw_page()
has been removed from the -mm tree.  Its filename was
     brd-add-support-for-rw_page.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Matthew Wilcox <matthew.r.wilcox@intel.com>
Subject: brd: add support for rw_page()

Signed-off-by: Matthew Wilcox <matthew.r.wilcox@intel.com>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Dheeraj Reddy <dheeraj.reddy@intel.com>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/brd.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff -puN drivers/block/brd.c~brd-add-support-for-rw_page drivers/block/brd.c
--- a/drivers/block/brd.c~brd-add-support-for-rw_page
+++ a/drivers/block/brd.c
@@ -360,6 +360,15 @@ out:
 	bio_endio(bio, err);
 }
 
+static int brd_rw_page(struct block_device *bdev, sector_t sector,
+		       struct page *page, int rw)
+{
+	struct brd_device *brd = bdev->bd_disk->private_data;
+	int err = brd_do_bvec(brd, page, PAGE_CACHE_SIZE, 0, rw, sector);
+	page_endio(page, rw & WRITE, err);
+	return err;
+}
+
 #ifdef CONFIG_BLK_DEV_XIP
 static int brd_direct_access(struct block_device *bdev, sector_t sector,
 			void **kaddr, unsigned long *pfn)
@@ -419,6 +428,7 @@ static int brd_ioctl(struct block_device
 
 static const struct block_device_operations brd_fops = {
 	.owner =		THIS_MODULE,
+	.rw_page =		brd_rw_page,
 	.ioctl =		brd_ioctl,
 #ifdef CONFIG_BLK_DEV_XIP
 	.direct_access =	brd_direct_access,
_

Patches currently in -mm which might be from matthew.r.wilcox@intel.com are

origin.patch
mm-introduce-do_shared_fault-and-drop-do_fault-fix-fix.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
linux-next.patch

