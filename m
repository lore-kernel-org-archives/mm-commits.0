From: akpm@linux-foundation.org
Subject: +
 brd-return-enospc-rather-than-enomem-on-page-allocation-failure.patch added to -mm tree
Date: Thu, 24 Apr 2014 11:18:03 -0700
Message-ID: <5359555b.DOl3VXn7eDC7JrGY%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38239 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758844AbaDXSSE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 24 Apr 2014 14:18:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, hughd@google.com, dheeraj.reddy@intel.com, david@fromorbit.com, matthew.r.wilcox@intel.com

Subject: + brd-return-enospc-rather-than-enomem-on-page-allocation-failure.patch added to -mm tree
To: matthew.r.wilcox@intel.com,david@fromorbit.com,dheeraj.reddy@intel.com,hughd@google.com
From: akpm@linux-foundation.org
Date: Thu, 24 Apr 2014 11:18:03 -0700


The patch titled
     Subject: brd: return -ENOSPC rather than -ENOMEM on page allocation failure
has been added to the -mm tree.  Its filename is
     brd-return-enospc-rather-than-enomem-on-page-allocation-failure.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/brd-return-enospc-rather-than-enomem-on-page-allocation-failure.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/brd-return-enospc-rather-than-enomem-on-page-allocation-failure.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Matthew Wilcox <matthew.r.wilcox@intel.com>
Subject: brd: return -ENOSPC rather than -ENOMEM on page allocation failure

brd is effectively a thinly provisioned device.  Thinly provisioned
devices return -ENOSPC when they can't write a new block.  -ENOMEM is an
implementation detail that callers shouldn't know.

Signed-off-by: Matthew Wilcox <matthew.r.wilcox@intel.com>
Acked-by: Dave Chinner <david@fromorbit.com>
Cc: Dheeraj Reddy <dheeraj.reddy@intel.com>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/brd.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN drivers/block/brd.c~brd-return-enospc-rather-than-enomem-on-page-allocation-failure drivers/block/brd.c
--- a/drivers/block/brd.c~brd-return-enospc-rather-than-enomem-on-page-allocation-failure
+++ a/drivers/block/brd.c
@@ -200,11 +200,11 @@ static int copy_to_brd_setup(struct brd_
 
 	copy = min_t(size_t, n, PAGE_SIZE - offset);
 	if (!brd_insert_page(brd, sector))
-		return -ENOMEM;
+		return -ENOSPC;
 	if (copy < n) {
 		sector += copy >> SECTOR_SHIFT;
 		if (!brd_insert_page(brd, sector))
-			return -ENOMEM;
+			return -ENOSPC;
 	}
 	return 0;
 }
@@ -384,7 +384,7 @@ static int brd_direct_access(struct bloc
 		return -ERANGE;
 	page = brd_insert_page(brd, sector);
 	if (!page)
-		return -ENOMEM;
+		return -ENOSPC;
 	*kaddr = page_address(page);
 	*pfn = page_to_pfn(page);
 
_

Patches currently in -mm which might be from matthew.r.wilcox@intel.com are

origin.patch
mm-introduce-do_shared_fault-and-drop-do_fault-fix-fix.patch
fs-bufferc-remove-block_write_full_page_endio.patch
fs-mpagec-factor-clean_buffers-out-of-__mpage_writepage.patch
fs-mpagec-factor-page_endio-out-of-mpage_end_io.patch
fs-block_devc-add-bdev_read_page-and-bdev_write_page.patch
swap-use-bdev_read_page-bdev_write_page.patch
brd-add-support-for-rw_page.patch
brd-return-enospc-rather-than-enomem-on-page-allocation-failure.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
linux-next.patch

