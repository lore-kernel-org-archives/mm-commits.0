From: akpm@osdl.org
Subject: + fix-blk_direct_io-bio-preparation.patch added to -mm tree
Date: Thu, 11 Jan 2007 13:55:25 -0800
Message-ID: <200701112155.l0BLtQHc004167@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:37723 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932105AbXAKVzp (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 11 Jan 2007 16:55:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kenneth.w.chen@intel.com


The patch titled
     fix blk_direct_IO bio preparation
has been added to the -mm tree.  Its filename is
     fix-blk_direct_io-bio-preparation.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
 1 files changed, 8 insertions(+)

diff -puN fs/block_dev.c~fix-blk_direct_io-bio-preparation fs/block_dev.c
--- a/fs/block_dev.c~fix-blk_direct_io-bio-preparation
+++ a/fs/block_dev.c
@@ -190,6 +190,12 @@ static struct page *blk_get_page(unsigne
 	return pvec->page[pvec->idx++];
 }
 
+/* return a pge back to pvec array */
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

blockdev-direct_io-fix-signedness-bug.patch
submitchecklist-update.patch
fix-blk_direct_io-bio-preparation.patch
ia64-alignment-bug-in-ldscript.patch
aio-fix-buggy-put_ioctx-call-in-aio_complete-v2.patch
mm-only-sched-add-a-few-scheduler-event-counters.patch
