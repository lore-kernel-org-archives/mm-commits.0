From: akpm@linux-foundation.org
Subject: [merged]
 mm-fix-negative-left-shift-count-when-page_shift-20.patch removed from -mm
 tree
Date: Thu, 12 Sep 2013 12:42:33 -0700
Message-ID: <52321929.giqy/RhNPxMpyhh4%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58012 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753000Ab3ILTmd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 12 Sep 2013 15:42:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, uulinux@gmail.com

Subject: [merged] mm-fix-negative-left-shift-count-when-page_shift-20.patch removed from -mm tree
To: uulinux@gmail.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 12 Sep 2013 12:42:33 -0700


The patch titled
     Subject: mm: fix negative left shift count when PAGE_SHIFT > 20
has been removed from the -mm tree.  Its filename was
     mm-fix-negative-left-shift-count-when-page_shift-20.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jerry Zhou <uulinux@gmail.com>
Subject: mm: fix negative left shift count when PAGE_SHIFT > 20

When PAGE_SHIFT > 20, the result of "20 - PAGE_SHIFT" is negative. The
previous calculating here will generate an unexpected result. In
addition, if PAGE_SIZE >= 1MB, The memory size of "numentries" was
already integral multiple of 1MB.

Signed-off-by: Jerry Zhou <uulinux@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff -puN mm/page_alloc.c~mm-fix-negative-left-shift-count-when-page_shift-20 mm/page_alloc.c
--- a/mm/page_alloc.c~mm-fix-negative-left-shift-count-when-page_shift-20
+++ a/mm/page_alloc.c
@@ -5745,9 +5745,10 @@ void *__init alloc_large_system_hash(con
 	if (!numentries) {
 		/* round applicable memory size up to nearest megabyte */
 		numentries = nr_kernel_pages;
-		numentries += (1UL << (20 - PAGE_SHIFT)) - 1;
-		numentries >>= 20 - PAGE_SHIFT;
-		numentries <<= 20 - PAGE_SHIFT;
+
+		/* It isn't necessary when PAGE_SIZE >= 1MB */
+		if (PAGE_SHIFT < 20)
+			numentries = round_up(numentries, (1<<20)/PAGE_SIZE);
 
 		/* limit to 1 bucket per 2^scale bytes of low memory */
 		if (scale > PAGE_SHIFT)
_

Patches currently in -mm which might be from uulinux@gmail.com are

origin.patch

