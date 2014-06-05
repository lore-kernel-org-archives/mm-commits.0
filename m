From: akpm@linux-foundation.org
Subject: [merged]
 brd-return-enospc-rather-than-enomem-on-page-allocation-failure.patch
 removed from -mm tree
Date: Thu, 05 Jun 2014 12:50:40 -0700
Message-ID: <5390ca10.16Hx5pgKDVZUNPD4%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56030 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751581AbaFETul (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Jun 2014 15:50:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, hughd@google.com, dheeraj.reddy@intel.com, david@fromorbit.com, matthew.r.wilcox@intel.com

Subject: [merged] brd-return-enospc-rather-than-enomem-on-page-allocation-failure.patch removed from -mm tree
To: matthew.r.wilcox@intel.com,david@fromorbit.com,dheeraj.reddy@intel.com,hughd@google.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 05 Jun 2014 12:50:40 -0700


The patch titled
     Subject: brd: return -ENOSPC rather than -ENOMEM on page allocation failure
has been removed from the -mm tree.  Its filename was
     brd-return-enospc-rather-than-enomem-on-page-allocation-failure.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
do_shared_fault-check-that-mmap_sem-is-held.patch
linux-next.patch

