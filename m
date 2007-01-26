From: akpm@osdl.org
Subject: - fix-blk_direct_io-bio-preparation.patch removed from -mm tree
Date: Thu, 25 Jan 2007 23:51:35 -0800
Message-ID: <200701260751.l0Q7pZt6010741@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:50466 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030810AbXAZHvh (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 26 Jan 2007 02:51:37 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kenneth.w.chen@intel.com, mm-commits@vger.kernel.org


The patch titled
     fix blk_direct_IO bio preparation
has been removed from the -mm tree.  Its filename was
     fix-blk_direct_io-bio-preparation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: fix blk_direct_IO bio preparation
From: "Chen, Kenneth W" <kenneth.w.chen@intel.com>

For large size DIO that needs multiple bio, one full page worth of data was
lost at the boundary of bio's maximum sector or segment limits.  After a
bio is full and got submitted.  The outer while (nbytes) { ...  } loop will
allocate a new bio and just march on to index into next page.  It just
forgets about the page that bio_add_page() rejected when previous bio is
full.  Fix it by put the rejected page back to pvec so we pick it up again
for the next bio.

Signed-off-by: Ken Chen <kenneth.w.chen@intel.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/block_dev.c |    8 ++++++++
 1 file changed, 8 insertions(+)

diff -puN fs/block_dev.c~fix-blk_direct_io-bio-preparation fs/block_dev.c
--- a/fs/block_dev.c~fix-blk_direct_io-bio-preparation
+++ a/fs/block_dev.c
@@ -190,6 +190,12 @@ static struct page *blk_get_page(unsigne
 	return pvec->page[pvec->idx++];
 }
 
+/* return a page back to pvec array */
+static void blk_unget_page(struct page *page, struct pvec *pvec)
+{
+	pvec->page[--pvec->idx] = page;
+}
+
 static ssize_t
 blkdev_direct_IO(int rw, struct kiocb *iocb, const struct iovec *iov,
 		 loff_t pos, unsigned long nr_segs)
@@ -278,6 +284,8 @@ same_bio:
 				count = min(count, nbytes);
 				goto same_bio;
 			}
+		} else {
+			blk_unget_page(page, &pvec);
 		}
 
 		/* bio is ready, submit it */
_

Patches currently in -mm which might be from kenneth.w.chen@intel.com are

ia64-alignment-bug-in-ldscript.patch
aio-fix-buggy-put_ioctx-call-in-aio_complete-v2.patch
mm-only-sched-add-a-few-scheduler-event-counters.patch
