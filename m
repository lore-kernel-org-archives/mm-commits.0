From: akpm@linux-foundation.org
Subject: [merged]
 mm-hwpoison-ratelimit-messages-from-unpoison_memory.patch removed from -mm
 tree
Date: Fri, 06 Nov 2015 12:08:18 -0800
Message-ID: <563d08b2.9CMYvPe2ygt+70cM%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48746 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1033695AbbKFUIS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 6 Nov 2015 15:08:18 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: n-horiguchi@ah.jp.nec.com, andi@firstfloor.org, wanpeng.li@hotmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: hwpoison: ratelimit messages from unpoison_memory()
has been removed from the -mm tree.  Its filename was
     mm-hwpoison-ratelimit-messages-from-unpoison_memory.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Subject: mm: hwpoison: ratelimit messages from unpoison_memory()

Currently kernel prints out results of every single unpoison event, which
i= s not necessary because unpoison is purely a testing feature and
testers can = get little or no information from lots of lines of unpoison
log storm.  So this patch ratelimits printk in unpoison_memory().

This patch introduces a file local ratelimit_state, which adds 64 bytes to
memory-failure.o.  If we apply pr_info_ratelimited() for 8 callsite below,
2= 56 bytes is added, so it's a win.

Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Wanpeng Li <wanpeng.li@hotmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |   34 +++++++++++++++++++++++++---------
 1 file changed, 25 insertions(+), 9 deletions(-)

diff -puN mm/memory-failure.c~mm-hwpoison-ratelimit-messages-from-unpoison_memory mm/memory-failure.c
--- a/mm/memory-failure.c~mm-hwpoison-ratelimit-messages-from-unpoison_memory
+++ a/mm/memory-failure.c
@@ -56,6 +56,7 @@
 #include <linux/memory_hotplug.h>
 #include <linux/mm_inline.h>
 #include <linux/kfifo.h>
+#include <linux/ratelimit.h>
 #include "internal.h"
 #include "ras/ras_event.h"
 
@@ -1403,6 +1404,12 @@ static int __init memory_failure_init(vo
 }
 core_initcall(memory_failure_init);
 
+#define unpoison_pr_info(fmt, pfn, rs)			\
+({							\
+	if (__ratelimit(rs))				\
+		pr_info(fmt, pfn);			\
+})
+
 /**
  * unpoison_memory - Unpoison a previously poisoned page
  * @pfn: Page number of the to be unpoisoned page
@@ -1421,6 +1428,8 @@ int unpoison_memory(unsigned long pfn)
 	struct page *p;
 	int freeit = 0;
 	unsigned int nr_pages;
+	static DEFINE_RATELIMIT_STATE(unpoison_rs, DEFAULT_RATELIMIT_INTERVAL,
+					DEFAULT_RATELIMIT_BURST);
 
 	if (!pfn_valid(pfn))
 		return -ENXIO;
@@ -1429,23 +1438,26 @@ int unpoison_memory(unsigned long pfn)
 	page = compound_head(p);
 
 	if (!PageHWPoison(p)) {
-		pr_info("MCE: Page was already unpoisoned %#lx\n", pfn);
+		unpoison_pr_info("MCE: Page was already unpoisoned %#lx\n",
+				 pfn, &unpoison_rs);
 		return 0;
 	}
 
 	if (page_count(page) > 1) {
-		pr_info("MCE: Someone grabs the hwpoison page %#lx\n", pfn);
+		unpoison_pr_info("MCE: Someone grabs the hwpoison page %#lx\n",
+				 pfn, &unpoison_rs);
 		return 0;
 	}
 
 	if (page_mapped(page)) {
-		pr_info("MCE: Someone maps the hwpoison page %#lx\n", pfn);
+		unpoison_pr_info("MCE: Someone maps the hwpoison page %#lx\n",
+				 pfn, &unpoison_rs);
 		return 0;
 	}
 
 	if (page_mapping(page)) {
-		pr_info("MCE: the hwpoison page has non-NULL mapping %#lx\n",
-			pfn);
+		unpoison_pr_info("MCE: the hwpoison page has non-NULL mapping %#lx\n",
+				 pfn, &unpoison_rs);
 		return 0;
 	}
 
@@ -1455,7 +1467,8 @@ int unpoison_memory(unsigned long pfn)
 	 * In such case, we yield to memory_failure() and make unpoison fail.
 	 */
 	if (!PageHuge(page) && PageTransHuge(page)) {
-		pr_info("MCE: Memory failure is now running on %#lx\n", pfn);
+		unpoison_pr_info("MCE: Memory failure is now running on %#lx\n",
+				 pfn, &unpoison_rs);
 		return 0;
 	}
 
@@ -1469,12 +1482,14 @@ int unpoison_memory(unsigned long pfn)
 		 * to the end.
 		 */
 		if (PageHuge(page)) {
-			pr_info("MCE: Memory failure is now running on free hugepage %#lx\n", pfn);
+			unpoison_pr_info("MCE: Memory failure is now running on free hugepage %#lx\n",
+					 pfn, &unpoison_rs);
 			return 0;
 		}
 		if (TestClearPageHWPoison(p))
 			num_poisoned_pages_dec();
-		pr_info("MCE: Software-unpoisoned free page %#lx\n", pfn);
+		unpoison_pr_info("MCE: Software-unpoisoned free page %#lx\n",
+				 pfn, &unpoison_rs);
 		return 0;
 	}
 
@@ -1486,7 +1501,8 @@ int unpoison_memory(unsigned long pfn)
 	 * the free buddy page pool.
 	 */
 	if (TestClearPageHWPoison(page)) {
-		pr_info("MCE: Software-unpoisoned page %#lx\n", pfn);
+		unpoison_pr_info("MCE: Software-unpoisoned page %#lx\n",
+				 pfn, &unpoison_rs);
 		num_poisoned_pages_sub(nr_pages);
 		freeit = 1;
 		if (PageHuge(page))
_

Patches currently in -mm which might be from n-horiguchi@ah.jp.nec.com are


