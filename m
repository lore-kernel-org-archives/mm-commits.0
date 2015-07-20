From: akpm@linux-foundation.org
Subject: + lib-show_memc-correct-reserved-memory-calculation.patch added
 to -mm tree
Date: Mon, 20 Jul 2015 15:49:36 -0700
Message-ID: <55ad7b00.Ul4QzDaeJpeEqmNh%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41507 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757158AbbGTWth (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 20 Jul 2015 18:49:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vishnu.ps@samsung.com, dpetigara@broadcom.com, iamjoonsoo.kim@lge.com, lauraa@codeaurora.org, laurent.pinchart+renesas@ideasonboard.com, m.szyprowski@samsung.com, mina86@mina86.com, sasha.levin@oracle.com, mm-commits@vger.kernel.org


The patch titled
     Subject: lib/show_mem.c: correct reserved memory calculation
has been added to the -mm tree.  Its filename is
     lib-show_memc-correct-reserved-memory-calculation.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/lib-show_memc-correct-reserved-memory-calculation.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/lib-show_memc-correct-reserved-memory-calculation.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Vishnu Pratap Singh <vishnu.ps@samsung.com>
Subject: lib/show_mem.c: correct reserved memory calculation

CMA reserved memory is not part of total reserved memory.
Currently when we print the total reserve memory it considers
cma as part of reserve memory and do minus of totalcma_pages
from reserved, which is wrong. In cases where total reserved
is less than cma reserved we will get negative values & while
printing we print as unsigned and we will get a very large value.

Below is the show mem output on X86 ubuntu based system where
CMA reserved is 100MB (25600 pages) & total reserved is ~40MB(10316 pages).
And reserve memory shows a large value because of this bug.

Before:
[  127.066430] 898908 pages RAM
[  127.066432] 671682 pages HighMem/MovableOnly
[  127.066434] 4294952012 pages reserved
[  127.066436] 25600 pages cma reserved

After:
[   44.663129] 898908 pages RAM
[   44.663130] 671682 pages HighMem/MovableOnly
[   44.663130] 10316 pages reserved
[   44.663131] 25600 pages cma reserved

Signed-off-by: Vishnu Pratap Singh <vishnu.ps@samsung.com>
Cc: Michal Nazarewicz <mina86@mina86.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Cc: Sasha Levin <sasha.levin@oracle.com>
Cc: Danesh Petigara <dpetigara@broadcom.com>
Cc: Laura Abbott <lauraa@codeaurora.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/show_mem.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff -puN lib/show_mem.c~lib-show_memc-correct-reserved-memory-calculation lib/show_mem.c
--- a/lib/show_mem.c~lib-show_memc-correct-reserved-memory-calculation
+++ a/lib/show_mem.c
@@ -38,11 +38,9 @@ void show_mem(unsigned int filter)
 
 	printk("%lu pages RAM\n", total);
 	printk("%lu pages HighMem/MovableOnly\n", highmem);
+	printk("%lu pages reserved\n", reserved);
 #ifdef CONFIG_CMA
-	printk("%lu pages reserved\n", (reserved - totalcma_pages));
 	printk("%lu pages cma reserved\n", totalcma_pages);
-#else
-	printk("%lu pages reserved\n", reserved);
 #endif
 #ifdef CONFIG_QUICKLIST
 	printk("%lu pages in pagetable cache\n",
_

Patches currently in -mm which might be from vishnu.ps@samsung.com are

lib-show_memc-correct-reserved-memory-calculation.patch

