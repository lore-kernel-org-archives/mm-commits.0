From: akpm@linux-foundation.org
Subject: +
 mm-memory-failurec-move-set_migratetype_isolate-outside-get_any_page.patch
 added to -mm tree
Date: Fri, 20 Sep 2013 14:17:21 -0700
Message-ID: <523cbb61.bT/NkwMW3PhsTaGA%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37008 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753191Ab3ITVRW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 20 Sep 2013 17:17:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, liwanp@linux.vnet.ibm.com, gong.chen@linux.intel.com, ak@linux.intel.com, n-horiguchi@ah.jp.nec.com

Subject: + mm-memory-failurec-move-set_migratetype_isolate-outside-get_any_page.patch added to -mm tree
To: n-horiguchi@ah.jp.nec.com,ak@linux.intel.com,gong.chen@linux.intel.com,liwanp@linux.vnet.ibm.com
From: akpm@linux-foundation.org
Date: Fri, 20 Sep 2013 14:17:21 -0700


The patch titled
     Subject: mm/memory-failure.c: move set_migratetype_isolate() outside get_any_page()
has been added to the -mm tree.  Its filename is
     mm-memory-failurec-move-set_migratetype_isolate-outside-get_any_page.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memory-failurec-move-set_migratetype_isolate-outside-get_any_page.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memory-failurec-move-set_migratetype_isolate-outside-get_any_page.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Subject: mm/memory-failure.c: move set_migratetype_isolate() outside get_any_page()

Chen Gong pointed out that set/unset_migratetype_isolate() was done in
readable/maintenable.  So this patch makes it done in soft_offline_page().

With this patch, we get to hold lock_memory_hotplug() longer but it's not
a problem because races between memory hotplug and soft offline are very
rare.

Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Reviewed-by: Chen, Gong <gong.chen@linux.intel.com>
Acked-by: Andi Kleen <ak@linux.intel.com>
Reviewed-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |   36 +++++++++++++++++-------------------
 1 file changed, 17 insertions(+), 19 deletions(-)

diff -puN mm/memory-failure.c~mm-memory-failurec-move-set_migratetype_isolate-outside-get_any_page mm/memory-failure.c
--- a/mm/memory-failure.c~mm-memory-failurec-move-set_migratetype_isolate-outside-get_any_page
+++ a/mm/memory-failure.c
@@ -1421,19 +1421,6 @@ static int __get_any_page(struct page *p
 		return 1;
 
 	/*
-	 * The lock_memory_hotplug prevents a race with memory hotplug.
-	 * This is a big hammer, a better would be nicer.
-	 */
-	lock_memory_hotplug();
-
-	/*
-	 * Isolate the page, so that it doesn't get reallocated if it
-	 * was free. This flag should be kept set until the source page
-	 * is freed and PG_hwpoison on it is set.
-	 */
-	if (get_pageblock_migratetype(p) != MIGRATE_ISOLATE)
-		set_migratetype_isolate(p, true);
-	/*
 	 * When the target page is a free hugepage, just remove it
 	 * from free hugepage list.
 	 */
@@ -1453,7 +1440,6 @@ static int __get_any_page(struct page *p
 		/* Not a free page */
 		ret = 1;
 	}
-	unlock_memory_hotplug();
 	return ret;
 }
 
@@ -1652,15 +1638,28 @@ int soft_offline_page(struct page *page,
 		}
 	}
 
+	/*
+	 * The lock_memory_hotplug prevents a race with memory hotplug.
+	 * This is a big hammer, a better would be nicer.
+	 */
+	lock_memory_hotplug();
+
+	/*
+	 * Isolate the page, so that it doesn't get reallocated if it
+	 * was free. This flag should be kept set until the source page
+	 * is freed and PG_hwpoison on it is set.
+	 */
+	if (get_pageblock_migratetype(page) != MIGRATE_ISOLATE)
+		set_migratetype_isolate(page, true);
+
 	ret = get_any_page(page, pfn, flags);
-	if (ret < 0)
-		goto unset;
-	if (ret) { /* for in-use pages */
+	unlock_memory_hotplug();
+	if (ret > 0) { /* for in-use pages */
 		if (PageHuge(page))
 			ret = soft_offline_huge_page(page, flags);
 		else
 			ret = __soft_offline_page(page, flags);
-	} else { /* for free pages */
+	} else if (ret == 0) { /* for free pages */
 		if (PageHuge(page)) {
 			set_page_hwpoison_huge_page(hpage);
 			dequeue_hwpoisoned_huge_page(hpage);
@@ -1671,7 +1670,6 @@ int soft_offline_page(struct page *page,
 			atomic_long_inc(&num_poisoned_pages);
 		}
 	}
-unset:
 	unset_migratetype_isolate(page, MIGRATE_MOVABLE);
 	return ret;
 }
_

Patches currently in -mm which might be from n-horiguchi@ah.jp.nec.com are

mm-remove-obsolete-comments-about-page-table-lock.patch
mm-memory-failurec-move-set_migratetype_isolate-outside-get_any_page.patch

