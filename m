From: akpm@linux-foundation.org
Subject: [to-be-updated] fontswap-thp-fix.patch removed from -mm tree
Date: Wed, 07 Feb 2018 13:06:22 -0800
Message-ID: <5a7b6a4e.PPj+OTu1GwDGFyUp%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58266 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754670AbeBGVGY (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 7 Feb 2018 16:06:24 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: huang.ying.caritas@gmail.com, ddstreet@ieee.org, kirill.shutemov@linux.intel.com, mhocko@kernel.org, minchan@kernel.org, sergey.senozhatsky@gmail.com, sergey.senozhatsky.work@gmail.com, sjenning@redhat.com, stable@vger.kernel.org, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: fontswap: thp fix
has been removed from the -mm tree.  Its filename was
     fontswap-thp-fix.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Huang Ying <huang.ying.caritas@gmail.com>
Subject: mm: fontswap: thp fix


Link: http://lkml.kernel.org/r/87d11j4pdy.fsf@yhuang-dev.intel.com
Fixes: bd4c82c22c367e068 ("mm, THP, swap: delay splitting THP after swapped out")
Reported-by: Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
Tested-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Seth Jennings <sjenning@redhat.com>
Cc: Dan Streetman <ddstreet@ieee.org>
Cc: "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_io.c |    2 +-
 mm/vmscan.c  |   16 +++++++++++++---
 2 files changed, 14 insertions(+), 4 deletions(-)

diff -puN mm/page_io.c~fontswap-thp-fix mm/page_io.c
--- a/mm/page_io.c~fontswap-thp-fix
+++ a/mm/page_io.c
@@ -250,7 +250,7 @@ int swap_writepage(struct page *page, st
 		unlock_page(page);
 		goto out;
 	}
-	if (frontswap_store(page) == 0) {
+	if (!PageTransHuge(page) && frontswap_store(page) == 0) {
 		set_page_writeback(page);
 		unlock_page(page);
 		end_page_writeback(page);
diff -puN mm/vmscan.c~fontswap-thp-fix mm/vmscan.c
--- a/mm/vmscan.c~fontswap-thp-fix
+++ a/mm/vmscan.c
@@ -55,6 +55,7 @@
 
 #include <linux/swapops.h>
 #include <linux/balloon_compaction.h>
+#include <linux/frontswap.h>
 
 #include "internal.h"
 
@@ -1121,13 +1122,22 @@ static unsigned long shrink_page_list(st
 					if (!can_split_huge_page(page, NULL))
 						goto activate_locked;
 					/*
+					 * Split THP if frontswap enabled,
+					 * because it cannot process THP
+					 */
+					if (frontswap_enabled()) {
+						if (split_huge_page_to_list(
+							page, page_list))
+							goto activate_locked;
+					}
+					/*
 					 * Split pages without a PMD map right
 					 * away. Chances are some or all of the
 					 * tail pages can be freed without IO.
 					 */
-					if (!compound_mapcount(page) &&
-					    split_huge_page_to_list(page,
-								    page_list))
+					else if (!compound_mapcount(page) &&
+						 split_huge_page_to_list(page,
+							page_list))
 						goto activate_locked;
 				}
 				if (!add_to_swap(page)) {
_

Patches currently in -mm which might be from huang.ying.caritas@gmail.com are

mm-swap-frontswap-fix-thp-swap-if-frontswap-enabled.patch

