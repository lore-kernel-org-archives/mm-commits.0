From: akpm@linux-foundation.org
Subject: [merged] mm-fix-dubious-code-in-__count_immobile_pages.patch removed from -mm tree
Date: Mon, 28 Feb 2011 13:10:51 -0800
Message-ID: <201102282110.p1SLApY5029337@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51328 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755186Ab1B1VN1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Feb 2011 16:13:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: namhyung@gmail.com, kamezawa.hiroyu@jp.fujitsu.com, minchan.kim@gmail.com, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     mm: fix dubious code in __count_immobile_pages()
has been removed from the -mm tree.  Its filename was
     mm-fix-dubious-code-in-__count_immobile_pages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: fix dubious code in __count_immobile_pages()
From: Namhyung Kim <namhyung@gmail.com>

When pfn_valid_within() failed 'iter' was incremented twice.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff -puN mm/page_alloc.c~mm-fix-dubious-code-in-__count_immobile_pages mm/page_alloc.c
--- a/mm/page_alloc.c~mm-fix-dubious-code-in-__count_immobile_pages
+++ a/mm/page_alloc.c
@@ -5376,10 +5376,9 @@ __count_immobile_pages(struct zone *zone
 	for (found = 0, iter = 0; iter < pageblock_nr_pages; iter++) {
 		unsigned long check = pfn + iter;
 
-		if (!pfn_valid_within(check)) {
-			iter++;
+		if (!pfn_valid_within(check))
 			continue;
-		}
+
 		page = pfn_to_page(check);
 		if (!page_count(page)) {
 			if (PageBuddy(page))
_

Patches currently in -mm which might be from namhyung@gmail.com are

origin.patch
linux-next.patch
mm-batch-free-pcp-list-if-possible.patch
mm-batch-free-pcp-list-if-possible-fix.patch
mempolicy-remove-redundant-check-in-__mpol_equal.patch
select-remove-unused-max_select_seconds.patch

