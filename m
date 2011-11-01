From: akpm@linux-foundation.org
Subject: [merged] hwpoison-convert-pr_debugs-to-pr_infos.patch removed from -mm tree
Date: Tue, 01 Nov 2011 14:11:15 -0700
Message-ID: <201111012111.pA1LBFW5016023@hpaq7.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([74.125.121.67]:15833 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750795Ab1KAVLV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Nov 2011 17:11:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dnelson@redhat.com, ak@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: HWPOISON: convert pr_debug()s to pr_info()s
has been removed from the -mm tree.  Its filename was
     hwpoison-convert-pr_debugs-to-pr_infos.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Dean Nelson <dnelson@redhat.com>
Subject: HWPOISON: convert pr_debug()s to pr_info()s

Commit fb46e73520940b ("HWPOISON: Convert pr_debugs to pr_info) authored
by Andi Kleen converted a number of pr_debug()s to pr_info()s.

About the same time additional code with pr_debug()s was added by two
other commits 8c6c2ecb4466 ("HWPOSION, hugetlb: recover from free hugepage
error when !MF_COUNT_INCREASED") and d950b95882f3d ("HWPOISON, hugetlb:
soft offlining for hugepage").  And these pr_debug()s failed to get
converted to pr_info()s.

This patch converts them as well.  And does some minor related whitespace
cleanup.

Signed-off-by: Dean Nelson <dnelson@redhat.com>
Reviewed-by: Andi Kleen <ak@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff -puN mm/memory-failure.c~hwpoison-convert-pr_debugs-to-pr_infos mm/memory-failure.c
--- a/mm/memory-failure.c~hwpoison-convert-pr_debugs-to-pr_infos
+++ a/mm/memory-failure.c
@@ -1310,7 +1310,7 @@ int unpoison_memory(unsigned long pfn)
 		 * to the end.
 		 */
 		if (PageHuge(page)) {
-			pr_debug("MCE: Memory failure is now running on free hugepage %#lx\n", pfn);
+			pr_info("MCE: Memory failure is now running on free hugepage %#lx\n", pfn);
 			return 0;
 		}
 		if (TestClearPageHWPoison(p))
@@ -1419,7 +1419,7 @@ static int soft_offline_huge_page(struct
 
 	if (PageHWPoison(hpage)) {
 		put_page(hpage);
-		pr_debug("soft offline: %#lx hugepage already poisoned\n", pfn);
+		pr_info("soft offline: %#lx hugepage already poisoned\n", pfn);
 		return -EBUSY;
 	}
 
@@ -1433,8 +1433,8 @@ static int soft_offline_huge_page(struct
 		list_for_each_entry_safe(page1, page2, &pagelist, lru)
 			put_page(page1);
 
-		pr_debug("soft offline: %#lx: migration failed %d, type %lx\n",
-			 pfn, ret, page->flags);
+		pr_info("soft offline: %#lx: migration failed %d, type %lx\n",
+			pfn, ret, page->flags);
 		if (ret > 0)
 			ret = -EIO;
 		return ret;
@@ -1505,7 +1505,7 @@ int soft_offline_page(struct page *page,
 	}
 	if (!PageLRU(page)) {
 		pr_info("soft_offline: %#lx: unknown non LRU page type %lx\n",
-				pfn, page->flags);
+			pfn, page->flags);
 		return -EIO;
 	}
 
@@ -1566,7 +1566,7 @@ int soft_offline_page(struct page *page,
 		}
 	} else {
 		pr_info("soft offline: %#lx: isolation failed: %d, page count %d, type %lx\n",
-				pfn, ret, page_count(page), page->flags);
+			pfn, ret, page_count(page), page->flags);
 	}
 	if (ret)
 		return ret;
_

Patches currently in -mm which might be from dnelson@redhat.com are

origin.patch
linux-next.patch

