From: akpm@google.com
Subject: + hwpoison-convert-pr_debugs-to-pr_infos.patch added to -mm tree
Date: Tue, 20 Sep 2011 15:23:26 -0700
Message-ID: <201109202223.p8KMNQYJ020470@wpaz17.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([74.125.121.67]:19532 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751741Ab1ITWXe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 20 Sep 2011 18:23:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dnelson@redhat.com, ak@linux.intel.com


The patch titled
     Subject: [PATCH] HWPOISON: Convert pr_debug()s to pr_info()s
has been added to the -mm tree.  Its filename is
     hwpoison-convert-pr_debugs-to-pr_infos.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Dean Nelson <dnelson@redhat.com>
Subject: [PATCH] HWPOISON: Convert pr_debug()s to pr_info()s

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
Signed-off-by: Andrew Morton <akpm@google.com>
---

 mm/memory-failure.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff -puN mm/memory-failure.c~hwpoison-convert-pr_debugs-to-pr_infos mm/memory-failure.c
--- a/mm/memory-failure.c~hwpoison-convert-pr_debugs-to-pr_infos
+++ a/mm/memory-failure.c
@@ -1311,7 +1311,7 @@ int unpoison_memory(unsigned long pfn)
 		 * to the end.
 		 */
 		if (PageHuge(page)) {
-			pr_debug("MCE: Memory failure is now running on free hugepage %#lx\n", pfn);
+			pr_info("MCE: Memory failure is now running on free hugepage %#lx\n", pfn);
 			return 0;
 		}
 		if (TestClearPageHWPoison(p))
@@ -1420,7 +1420,7 @@ static int soft_offline_huge_page(struct
 
 	if (PageHWPoison(hpage)) {
 		put_page(hpage);
-		pr_debug("soft offline: %#lx hugepage already poisoned\n", pfn);
+		pr_info("soft offline: %#lx hugepage already poisoned\n", pfn);
 		return -EBUSY;
 	}
 
@@ -1434,8 +1434,8 @@ static int soft_offline_huge_page(struct
 		list_for_each_entry_safe(page1, page2, &pagelist, lru)
 			put_page(page1);
 
-		pr_debug("soft offline: %#lx: migration failed %d, type %lx\n",
-			 pfn, ret, page->flags);
+		pr_info("soft offline: %#lx: migration failed %d, type %lx\n",
+			pfn, ret, page->flags);
 		if (ret > 0)
 			ret = -EIO;
 		return ret;
@@ -1506,7 +1506,7 @@ int soft_offline_page(struct page *page,
 	}
 	if (!PageLRU(page)) {
 		pr_info("soft_offline: %#lx: unknown non LRU page type %lx\n",
-				pfn, page->flags);
+			pfn, page->flags);
 		return -EIO;
 	}
 
@@ -1567,7 +1567,7 @@ int soft_offline_page(struct page *page,
 		}
 	} else {
 		pr_info("soft offline: %#lx: isolation failed: %d, page count %d, type %lx\n",
-				pfn, ret, page_count(page), page->flags);
+			pfn, ret, page_count(page), page->flags);
 	}
 	if (ret)
 		return ret;
_
Subject: Subject: [PATCH] HWPOISON: Convert pr_debug()s to pr_info()s

Patches currently in -mm which might be from dnelson@redhat.com are

linux-next.patch
hwpoison-convert-pr_debugs-to-pr_infos.patch

