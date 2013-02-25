From: akpm@linux-foundation.org
Subject: [merged] memory-failure-fix-an-error-of-mce_bad_pages-statistics.patch removed from -mm tree
Date: Mon, 25 Feb 2013 12:51:49 -0800
Message-ID: <20130225205149.D825D5A4277@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f201.google.com ([209.85.160.201]:61496 "EHLO
	mail-gh0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759674Ab3BYUvv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 25 Feb 2013 15:51:51 -0500
Received: by mail-gh0-f201.google.com with SMTP id z19so347207ghb.2
        for <mm-commits@vger.kernel.org>; Mon, 25 Feb 2013 12:51:50 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: qiuxishi@huawei.com, andi@firstfloor.org, bp@alien8.de, jiang.liu@huawei.com, liwanp@linux.vnet.ibm.com, n-horiguchi@ah.jp.nec.com, mm-commits@vger.kernel.org


The patch titled
     Subject: memory-failure: fix an error of mce_bad_pages statistics
has been removed from the -mm tree.  Its filename was
     memory-failure-fix-an-error-of-mce_bad_pages-statistics.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Xishi Qiu <qiuxishi@huawei.com>
Subject: memory-failure: fix an error of mce_bad_pages statistics

$ echo paddr > /sys/devices/system/memory/soft_offline_page to offline a
*free* page, the value of mce_bad_pages will be added, and the page is set
HWPoison flag, but it is still managed by page buddy alocator.

$ cat /proc/meminfo | grep HardwareCorrupted shows the value.

If we offline the same page, the value of mce_bad_pages will be added
*again*, this means the value is incorrect now.  Assume the page is still
free during this short time.

soft_offline_page()
	get_any_page()
			"else if (is_free_buddy_page(p))" branch return 0
						"goto done";
                                           "atomic_long_add(1, &mce_bad_pages);"
										


This patch:

Move poisoned page check at the beginning of the function in order to
fix the error.

Signed-off-by: Xishi Qiu <qiuxishi@huawei.com>
Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Tested-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Cc: Andi Kleen <andi@firstfloor.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |   38 +++++++++++++++++---------------------
 1 file changed, 17 insertions(+), 21 deletions(-)

diff -puN mm/memory-failure.c~memory-failure-fix-an-error-of-mce_bad_pages-statistics mm/memory-failure.c
--- a/mm/memory-failure.c~memory-failure-fix-an-error-of-mce_bad_pages-statistics
+++ a/mm/memory-failure.c
@@ -1419,18 +1419,17 @@ static int soft_offline_huge_page(struct
 	unsigned long pfn = page_to_pfn(page);
 	struct page *hpage = compound_head(page);
 
+	if (PageHWPoison(hpage)) {
+		pr_info("soft offline: %#lx hugepage already poisoned\n", pfn);
+		return -EBUSY;
+	}
+
 	ret = get_any_page(page, pfn, flags);
 	if (ret < 0)
 		return ret;
 	if (ret == 0)
 		goto done;
 
-	if (PageHWPoison(hpage)) {
-		put_page(hpage);
-		pr_info("soft offline: %#lx hugepage already poisoned\n", pfn);
-		return -EBUSY;
-	}
-
 	/* Keep page count to indicate a given hugepage is isolated. */
 	ret = migrate_huge_page(hpage, new_page, MPOL_MF_MOVE_ALL, false,
 				MIGRATE_SYNC);
@@ -1441,12 +1440,11 @@ static int soft_offline_huge_page(struct
 		return ret;
 	}
 done:
-	if (!PageHWPoison(hpage))
-		atomic_long_add(1 << compound_trans_order(hpage),
-				&mce_bad_pages);
+	/* keep elevated page count for bad page */
+	atomic_long_add(1 << compound_trans_order(hpage), &mce_bad_pages);
 	set_page_hwpoison_huge_page(hpage);
 	dequeue_hwpoisoned_huge_page(hpage);
-	/* keep elevated page count for bad page */
+
 	return ret;
 }
 
@@ -1488,6 +1486,11 @@ int soft_offline_page(struct page *page,
 		}
 	}
 
+	if (PageHWPoison(page)) {
+		pr_info("soft offline: %#lx page already poisoned\n", pfn);
+		return -EBUSY;
+	}
+
 	ret = get_any_page(page, pfn, flags);
 	if (ret < 0)
 		return ret;
@@ -1519,19 +1522,11 @@ int soft_offline_page(struct page *page,
 		return -EIO;
 	}
 
-	lock_page(page);
-	wait_on_page_writeback(page);
-
 	/*
 	 * Synchronized using the page lock with memory_failure()
 	 */
-	if (PageHWPoison(page)) {
-		unlock_page(page);
-		put_page(page);
-		pr_info("soft offline: %#lx page already poisoned\n", pfn);
-		return -EBUSY;
-	}
