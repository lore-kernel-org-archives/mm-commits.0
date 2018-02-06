From: akpm@linux-foundation.org
Subject: + fontswap-thp-fix.patch added to -mm tree
Date: Mon, 05 Feb 2018 16:24:45 -0800
Message-ID: <5a78f5cd.ECDEASpRYnvw7dGH%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41262 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752364AbeBFAYq (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 5 Feb 2018 19:24:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: huang.ying.caritas@gmail.com, ddstreet@ieee.org, kirill.shutemov@linux.intel.com, mhocko@kernel.org, minchan@kernel.org, sergey.senozhatsky.work@gmail.com, sjenning@redhat.com, stable@vger.kerenl.org, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: fontswap: thp fix
has been added to the -mm tree.  Its filename is
     fontswap-thp-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fontswap-thp-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fontswap-thp-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Huang Ying <huang.ying.caritas@gmail.com>
Subject: mm: fontswap: thp fix


Link: http://lkml.kernel.org/r/87d11j4pdy.fsf@yhuang-dev.intel.com
Fixes: bd4c82c22c367e068 ("mm, THP, swap: delay splitting THP after swapped out")
Reported-by: Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Seth Jennings <sjenning@redhat.com>
Cc: Dan Streetman <ddstreet@ieee.org>
Cc: "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>
Cc: <stable@vger.kerenl.org>
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

fontswap-thp-fix.patch

