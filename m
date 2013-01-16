From: akpm@linux-foundation.org
Subject: + memory-failure-do-code-refactor-of-soft_offline_page.patch added to -mm tree
Date: Wed, 16 Jan 2013 15:56:18 -0800
Message-ID: <20130116235619.4750282004A@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f73.google.com ([209.85.212.73]:38526 "EHLO
	mail-vb0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752350Ab3APX4U (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 16 Jan 2013 18:56:20 -0500
Received: by mail-vb0-f73.google.com with SMTP id l1so241069vba.2
        for <mm-commits@vger.kernel.org>; Wed, 16 Jan 2013 15:56:20 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: qiuxishi@huawei.com, akpm@linux-foundation.org, andi@firstfloor.org, bp@alien8.de, jiang.liu@huawei.com, liwanp@linux.vnet.ibm.com


The patch titled
     Subject: memory-failure: do code refactor of soft_offline_page()
has been added to the -mm tree.  Its filename is
     memory-failure-do-code-refactor-of-soft_offline_page.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Xishi Qiu <qiuxishi@huawei.com>
Subject: memory-failure: do code refactor of soft_offline_page()

There are too many return points randomly intermingled with some "goto
done" return points.  So adjust the function structure, one for the
success path, the other for the failure path.  Use atomic_long_inc instead
of atomic_long_add.

Signed-off-by: Xishi Qiu <qiuxishi@huawei.com>
Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Suggested-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Cc: Andi Kleen <andi@firstfloor.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |   34 ++++++++++++++++++++--------------
 1 file changed, 20 insertions(+), 14 deletions(-)

diff -puN mm/memory-failure.c~memory-failure-do-code-refactor-of-soft_offline_page mm/memory-failure.c
--- a/mm/memory-failure.c~memory-failure-do-code-refactor-of-soft_offline_page
+++ a/mm/memory-failure.c
@@ -1421,12 +1421,13 @@ static int soft_offline_huge_page(struct
 
 	if (PageHWPoison(hpage)) {
 		pr_info("soft offline: %#lx hugepage already poisoned\n", pfn);
-		return -EBUSY;
+		ret = -EBUSY;
+		goto out;
 	}
 
 	ret = get_any_page(page, pfn, flags);
 	if (ret < 0)
-		return ret;
+		goto out;
 	if (ret == 0)
 		goto done;
 
@@ -1437,14 +1438,14 @@ static int soft_offline_huge_page(struct
 	if (ret) {
 		pr_info("soft offline: %#lx: migration failed %d, type %lx\n",
 			pfn, ret, page->flags);
-		return ret;
+		goto out;
 	}
 done:
 	/* keep elevated page count for bad page */
 	atomic_long_add(1 << compound_trans_order(hpage), &mce_bad_pages);
 	set_page_hwpoison_huge_page(hpage);
 	dequeue_hwpoisoned_huge_page(hpage);
-
+out:
 	return ret;
 }
 
@@ -1476,24 +1477,28 @@ int soft_offline_page(struct page *page,
 	unsigned long pfn = page_to_pfn(page);
 	struct page *hpage = compound_trans_head(page);
 
-	if (PageHuge(page))
-		return soft_offline_huge_page(page, flags);
+	if (PageHuge(page)) {
+		ret = soft_offline_huge_page(page, flags);
+		goto out;
+	}
 	if (PageTransHuge(hpage)) {
 		if (PageAnon(hpage) && unlikely(split_huge_page(hpage))) {
 			pr_info("soft offline: %#lx: failed to split THP\n",
 				pfn);
-			return -EBUSY;
+			ret = -EBUSY;
+			goto out;
 		}
 	}
 
 	if (PageHWPoison(page)) {
 		pr_info("soft offline: %#lx page already poisoned\n", pfn);
-		return -EBUSY;
+		ret = -EBUSY;
+		goto out;
 	}
 
 	ret = get_any_page(page, pfn, flags);
 	if (ret < 0)
-		return ret;
+		goto out;
 	if (ret == 0)
 		goto done;
 
@@ -1512,14 +1517,15 @@ int soft_offline_page(struct page *page,
 		 */
 		ret = get_any_page(page, pfn, 0);
 		if (ret < 0)
-			return ret;
+			goto out;
 		if (ret == 0)
 			goto done;
 	}
 	if (!PageLRU(page)) {
 		pr_info("soft_offline: %#lx: unknown non LRU page type %lx\n",
 			pfn, page->flags);
-		return -EIO;
+		ret = -EIO;
+		goto out;
 	}
 
 	/*
@@ -1575,12 +1581,12 @@ int soft_offline_page(struct page *page,
 			pfn, ret, page_count(page), page->flags);
 	}
 	if (ret)
-		return ret;
+		goto out;
 
 done:
 	/* keep elevated page count for bad page */
-	atomic_long_add(1, &mce_bad_pages);
+	atomic_long_inc(&mce_bad_pages);
 	SetPageHWPoison(page);
