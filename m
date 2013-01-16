From: akpm@linux-foundation.org
Subject: + memory-failure-use-num_poisoned_pages-instead-of-mce_bad_pages.patch added to -mm tree
Date: Wed, 16 Jan 2013 15:56:21 -0800
Message-ID: <20130116235622.2D725100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f201.google.com ([209.85.161.201]:41443 "EHLO
	mail-gg0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756323Ab3APX4X (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 16 Jan 2013 18:56:23 -0500
Received: by mail-gg0-f201.google.com with SMTP id o6so240316ggm.2
        for <mm-commits@vger.kernel.org>; Wed, 16 Jan 2013 15:56:22 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: qiuxishi@huawei.com, andi@firstfloor.org, bp@alien8.de, jiang.liu@huawei.com, liwanp@linux.vnet.ibm.com


The patch titled
     Subject: memory-failure: use num_poisoned_pages instead of mce_bad_pages
has been added to the -mm tree.  Its filename is
     memory-failure-use-num_poisoned_pages-instead-of-mce_bad_pages.patch

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
Subject: memory-failure: use num_poisoned_pages instead of mce_bad_pages

Since MCE is an x86 concept, and this code is in mm/, it would be better
to use the name num_poisoned_pages instead of mce_bad_pages.

Signed-off-by: Xishi Qiu <qiuxishi@huawei.com>
Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Suggested-by: Borislav Petkov <bp@alien8.de>
Reviewed-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Cc: Andi Kleen <andi@firstfloor.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/meminfo.c   |    2 +-
 include/linux/mm.h  |    2 +-
 mm/memory-failure.c |   16 ++++++++--------
 3 files changed, 10 insertions(+), 10 deletions(-)

diff -puN fs/proc/meminfo.c~memory-failure-use-num_poisoned_pages-instead-of-mce_bad_pages fs/proc/meminfo.c
--- a/fs/proc/meminfo.c~memory-failure-use-num_poisoned_pages-instead-of-mce_bad_pages
+++ a/fs/proc/meminfo.c
@@ -158,7 +158,7 @@ static int meminfo_proc_show(struct seq_
 		vmi.used >> 10,
 		vmi.largest_chunk >> 10
 #ifdef CONFIG_MEMORY_FAILURE
-		,atomic_long_read(&mce_bad_pages) << (PAGE_SHIFT - 10)
+		,atomic_long_read(&num_poisoned_pages) << (PAGE_SHIFT - 10)
 #endif
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 		,K(global_page_state(NR_ANON_TRANSPARENT_HUGEPAGES) *
diff -puN include/linux/mm.h~memory-failure-use-num_poisoned_pages-instead-of-mce_bad_pages include/linux/mm.h
--- a/include/linux/mm.h~memory-failure-use-num_poisoned_pages-instead-of-mce_bad_pages
+++ a/include/linux/mm.h
@@ -1747,7 +1747,7 @@ extern int unpoison_memory(unsigned long
 extern int sysctl_memory_failure_early_kill;
 extern int sysctl_memory_failure_recovery;
 extern void shake_page(struct page *p, int access);
-extern atomic_long_t mce_bad_pages;
+extern atomic_long_t num_poisoned_pages;
 extern int soft_offline_page(struct page *page, int flags);
 
 extern void dump_page(struct page *page);
diff -puN mm/memory-failure.c~memory-failure-use-num_poisoned_pages-instead-of-mce_bad_pages mm/memory-failure.c
--- a/mm/memory-failure.c~memory-failure-use-num_poisoned_pages-instead-of-mce_bad_pages
+++ a/mm/memory-failure.c
@@ -61,7 +61,7 @@ int sysctl_memory_failure_early_kill __r
 
 int sysctl_memory_failure_recovery __read_mostly = 1;
 
-atomic_long_t mce_bad_pages __read_mostly = ATOMIC_LONG_INIT(0);
+atomic_long_t num_poisoned_pages __read_mostly = ATOMIC_LONG_INIT(0);
 
 #if defined(CONFIG_HWPOISON_INJECT) || defined(CONFIG_HWPOISON_INJECT_MODULE)
 
@@ -1040,7 +1040,7 @@ int memory_failure(unsigned long pfn, in
 	}
 
 	nr_pages = 1 << compound_trans_order(hpage);
-	atomic_long_add(nr_pages, &mce_bad_pages);
+	atomic_long_add(nr_pages, &num_poisoned_pages);
 
 	/*
 	 * We need/can do nothing about count=0 pages.
@@ -1070,7 +1070,7 @@ int memory_failure(unsigned long pfn, in
 			if (!PageHWPoison(hpage)
 			    || (hwpoison_filter(p) && TestClearPageHWPoison(p))
 			    || (p != hpage && TestSetPageHWPoison(hpage))) {
-				atomic_long_sub(nr_pages, &mce_bad_pages);
+				atomic_long_sub(nr_pages, &num_poisoned_pages);
 				return 0;
 			}
 			set_page_hwpoison_huge_page(hpage);
@@ -1128,7 +1128,7 @@ int memory_failure(unsigned long pfn, in
 	}
 	if (hwpoison_filter(p)) {
 		if (TestClearPageHWPoison(p))
-			atomic_long_sub(nr_pages, &mce_bad_pages);
+			atomic_long_sub(nr_pages, &num_poisoned_pages);
 		unlock_page(hpage);
 		put_page(hpage);
 		return 0;
@@ -1323,7 +1323,7 @@ int unpoison_memory(unsigned long pfn)
 			return 0;
 		}
 		if (TestClearPageHWPoison(p))
-			atomic_long_sub(nr_pages, &mce_bad_pages);
+			atomic_long_sub(nr_pages, &num_poisoned_pages);
 		pr_info("MCE: Software-unpoisoned free page %#lx\n", pfn);
 		return 0;
 	}
@@ -1337,7 +1337,7 @@ int unpoison_memory(unsigned long pfn)
 	 */
 	if (TestClearPageHWPoison(page)) {
 		pr_info("MCE: Software-unpoisoned page %#lx\n", pfn);
-		atomic_long_sub(nr_pages, &mce_bad_pages);
+		atomic_long_sub(nr_pages, &num_poisoned_pages);
 		freeit = 1;
 		if (PageHuge(page))
 			clear_page_hwpoison_huge_page(page);
@@ -1442,7 +1442,7 @@ static int soft_offline_huge_page(struct
 	}
 done:
 	/* keep elevated page count for bad page */
-	atomic_long_add(1 << compound_trans_order(hpage), &mce_bad_pages);
+	atomic_long_add(1 << compound_trans_order(hpage), &num_poisoned_pages);
 	set_page_hwpoison_huge_page(hpage);
 	dequeue_hwpoisoned_huge_page(hpage);
 out:
@@ -1585,7 +1585,7 @@ int soft_offline_page(struct page *page,
 
 done:
 	/* keep elevated page count for bad page */
-	atomic_long_inc(&mce_bad_pages);
+	atomic_long_inc(&num_poisoned_pages);
 	SetPageHWPoison(page);
 out:
 	return ret;
_

Patches currently in -mm which might be from qiuxishi@huawei.com are

memory-failure-fix-an-error-of-mce_bad_pages-statistics.patch
memory-failure-do-code-refactor-of-soft_offline_page.patch
memory-failure-use-num_poisoned_pages-instead-of-mce_bad_pages.patch

