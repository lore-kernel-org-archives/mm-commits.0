From: akpm@linux-foundation.org
Subject: [merged] swap-use-bdev_read_page-bdev_write_page.patch removed
 from -mm tree
Date: Thu, 05 Jun 2014 12:50:36 -0700
Message-ID: <5390ca0c.NBPRS3+7QF6Q+KRm%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56022 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751581AbaFETuh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Jun 2014 15:50:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, hughd@google.com, dheeraj.reddy@intel.com, david@fromorbit.com, matthew.r.wilcox@intel.com

Subject: [merged] swap-use-bdev_read_page-bdev_write_page.patch removed from -mm tree
To: matthew.r.wilcox@intel.com,david@fromorbit.com,dheeraj.reddy@intel.com,hughd@google.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 05 Jun 2014 12:50:36 -0700


The patch titled
     Subject: swap: use bdev_read_page() / bdev_write_page()
has been removed from the -mm tree.  Its filename was
     swap-use-bdev_read_page-bdev_write_page.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Matthew Wilcox <matthew.r.wilcox@intel.com>
Subject: swap: use bdev_read_page() / bdev_write_page()

By calling the device driver to write the page directly, we avoid
allocating a BIO, which allows us to free memory without allocating
memory.

[akpm@linux-foundation.org: fix used-uninitialized bug]
Signed-off-by: Matthew Wilcox <matthew.r.wilcox@intel.com>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Dheeraj Reddy <dheeraj.reddy@intel.com>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_io.c |   21 ++++++++++++++++++++-
 1 file changed, 20 insertions(+), 1 deletion(-)

diff -puN mm/page_io.c~swap-use-bdev_read_page-bdev_write_page mm/page_io.c
--- a/mm/page_io.c~swap-use-bdev_read_page-bdev_write_page
+++ a/mm/page_io.c
@@ -248,11 +248,16 @@ out:
 	return ret;
 }
 
+static sector_t swap_page_sector(struct page *page)
+{
+	return (sector_t)__page_file_index(page) << (PAGE_CACHE_SHIFT - 9);
+}
+
 int __swap_writepage(struct page *page, struct writeback_control *wbc,
 	void (*end_write_func)(struct bio *, int))
 {
 	struct bio *bio;
-	int ret = 0, rw = WRITE;
+	int ret, rw = WRITE;
 	struct swap_info_struct *sis = page_swap_info(page);
 
 	if (sis->flags & SWP_FILE) {
@@ -297,6 +302,13 @@ int __swap_writepage(struct page *page,
 		return ret;
 	}
 
+	ret = bdev_write_page(sis->bdev, swap_page_sector(page), page, wbc);
+	if (!ret) {
+		count_vm_event(PSWPOUT);
+		return 0;
+	}
+
+	ret = 0;
 	bio = get_swap_bio(GFP_NOIO, page, end_write_func);
 	if (bio == NULL) {
 		set_page_dirty(page);
@@ -338,6 +350,13 @@ int swap_readpage(struct page *page)
 		return ret;
 	}
 
+	ret = bdev_read_page(sis->bdev, swap_page_sector(page), page);
+	if (!ret) {
+		count_vm_event(PSWPIN);
+		return 0;
+	}
+
+	ret = 0;
 	bio = get_swap_bio(GFP_KERNEL, page, end_swap_bio_read);
 	if (bio == NULL) {
 		unlock_page(page);
_

Patches currently in -mm which might be from matthew.r.wilcox@intel.com are

origin.patch
mm-introduce-do_shared_fault-and-drop-do_fault-fix-fix.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
linux-next.patch

