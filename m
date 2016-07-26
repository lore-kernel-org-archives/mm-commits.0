From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-make-optimistic-check-for-swapin-readahead-fix-4.patch removed from -mm
 tree
Date: Tue, 26 Jul 2016 14:11:46 -0700
Message-ID: <5797d212.AQJ4IltSThH/j6kh%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54719 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758343AbcGZVLr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 26 Jul 2016 17:11:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sfr@canb.auug.org.au, mm-commits@vger.kernel.org


The patch titled
     Subject: linux-next: build failure after merge of the akpm-current tree
has been removed from the -mm tree.  Its filename was
     mm-make-optimistic-check-for-swapin-readahead-fix-4.patch

This patch was dropped because it was folded into mm-make-optimistic-check-for-swapin-readahead.patch

------------------------------------------------------
From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: linux-next: build failure after merge of the akpm-current tree

Hi Andrew,

After merging the akpm-current tree, today's linux-next build (powerpc
allyesconfig) failed like this:

In file included from include/linux/mm.h:400:0,
                 from mm/huge_memory.c:10:
include/linux/huge_mm.h:53:22: error: initializer element is not constant
 #define HPAGE_PMD_NR (1<<HPAGE_PMD_ORDER)
                      ^
mm/huge_memory.c:104:62: note: in expansion of macro 'HPAGE_PMD_NR'
 static unsigned int khugepaged_max_ptes_swap __read_mostly = HPAGE_PMD_NR/8;
                                                              ^

Caused by commit

  5c38823a834f ("mm: make optimistic check for swapin readahead")

We had this error some time ago, so I have added teh same patch as
last time:

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Mon, 2 May 2016 18:25:42 +1000
Subject: [PATCH] mm: make optimistic check for swapin readahead fix

Link: http://lkml.kernel.org/r/20160616154503.65806e12@canb.auug.org.au
Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 1 file changed, 2 insertions(+), 1 deletion(-)

index f0cd9dbc1157..6aabfa166b6d 100644
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN mm/huge_memory.c~mm-make-optimistic-check-for-swapin-readahead-fix-4 mm/huge_memory.c
--- a/mm/huge_memory.c~mm-make-optimistic-check-for-swapin-readahead-fix-4
+++ a/mm/huge_memory.c
@@ -101,7 +101,7 @@ static DECLARE_WAIT_QUEUE_HEAD(khugepage
  * fault.
  */
 static unsigned int khugepaged_max_ptes_none __read_mostly;
-static unsigned int khugepaged_max_ptes_swap __read_mostly = HPAGE_PMD_NR/8;
+static unsigned int khugepaged_max_ptes_swap __read_mostly;
 
 static int khugepaged(void *none);
 static int khugepaged_slab_init(void);
@@ -704,6 +704,7 @@ static int __init hugepage_init(void)
 
 	khugepaged_pages_to_scan = HPAGE_PMD_NR * 8;
 	khugepaged_max_ptes_none = HPAGE_PMD_NR - 1;
+	khugepaged_max_ptes_swap = HPAGE_PMD_NR / 8;
 	/*
 	 * hugepages can't be allocated by the buddy allocator
 	 */
_

Patches currently in -mm which might be from sfr@canb.auug.org.au are

mm-make-optimistic-check-for-swapin-readahead.patch

