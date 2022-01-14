Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09428C433F5
	for <mm-commits@archiver.kernel.org>; Fri, 14 Jan 2022 22:09:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230257AbiANWJO (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 14 Jan 2022 17:09:14 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:60642 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230238AbiANWJM (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 14 Jan 2022 17:09:12 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A2B00B8262E
        for <mm-commits@vger.kernel.org>; Fri, 14 Jan 2022 22:09:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09DDDC36AE5;
        Fri, 14 Jan 2022 22:09:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642198150;
        bh=Ilbibu6gt61locO/NIi/QYhj8p/ZfYjIBqjfa1d6kXw=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=MCbaqil789pe9GrxT8YYssrbfgl6hgq57g/vhbq5023eCDMuMcwZM1tujp6eqkGCv
         bN/38RNOGwew5pNSIQA11n0w4Yq/ZMUNzIVwyodVuyMZt7YQxVMjgBCA+gl9DIYlfN
         kcoBXPyPbE1orUk9VhzecHOhannAQxoGK6plyeeQ=
Date:   Fri, 14 Jan 2022 14:09:09 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, aneesh.kumar@linux.vnet.ibm.com,
        david@redhat.com, dinghui@sangfor.com.cn, linmiaohe@huawei.com,
        linux-mm@kvack.org, mhocko@suse.com, mm-commits@vger.kernel.org,
        naoya.horiguchi@nec.com, osalvador@suse.de, peterx@redhat.com,
        shy828301@gmail.com, tony.luck@intel.com,
        torvalds@linux-foundation.org
Subject:  [patch 113/146] mm/hwpoison: fix unpoison_memory()
Message-ID: <20220114220909.zXvwN3m7r%akpm@linux-foundation.org>
In-Reply-To: <20220114140222.6b14f0061194d3200000c52d@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Naoya Horiguchi <naoya.horiguchi@nec.com>
Subject: mm/hwpoison: fix unpoison_memory()

After recent soft-offline rework, error pages can be taken off from buddy
allocator, but the existing unpoison_memory() does not properly undo the
operation.  Moreover, due to the recent change on __get_hwpoison_page(),
get_page_unless_zero() is hardly called for hwpoisoned pages.  So
__get_hwpoison_page() highly likely returns -EBUSY (meaning to fail to
grab page refcount) and unpoison just clears PG_hwpoison without releasing
a refcount.  That does not lead to a critical issue like kernel panic, but
unpoisoned pages never get back to buddy (leaked permanently), which is
not good.

To (partially) fix this, we need to identify "taken off" pages from other
types of hwpoisoned pages.  We can't use refcount or page flags for this
purpose, so a pseudo flag is defined by hacking ->private field.  Someone
might think that put_page() is enough to cancel taken-off pages, but the
normal free path contains some operations not suitable for the current
purpose, and can fire VM_BUG_ON().

Note that unpoison_memory() is now supposed to be cancel hwpoison events
injected only by madvise() or
/sys/devices/system/memory/{hard,soft}_offline_page, not by MCE injection,
so please don't try to use unpoison when testing with MCE injection.

[lkp@intel.com: report build failure for ARCH=i386]
Link: https://lkml.kernel.org/r/20211115084006.3728254-4-naoya.horiguchi@linux.dev
Signed-off-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Reviewed-by: Yang Shi <shy828301@gmail.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Ding Hui <dinghui@sangfor.com.cn>
Cc: Tony Luck <tony.luck@intel.com>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Peter Xu <peterx@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h         |    1 
 include/linux/page-flags.h |    4 +
 mm/memory-failure.c        |  109 ++++++++++++++++++++++++++++-------
 mm/page_alloc.c            |   27 ++++++++
 4 files changed, 122 insertions(+), 19 deletions(-)

--- a/include/linux/mm.h~mm-hwpoison-fix-unpoison_memory
+++ a/include/linux/mm.h
@@ -3174,6 +3174,7 @@ enum mf_flags {
 	MF_ACTION_REQUIRED = 1 << 1,
 	MF_MUST_KILL = 1 << 2,
 	MF_SOFT_OFFLINE = 1 << 3,
+	MF_UNPOISON = 1 << 4,
 };
 extern int memory_failure(unsigned long pfn, int flags);
 extern void memory_failure_queue(unsigned long pfn, int flags);
--- a/include/linux/page-flags.h~mm-hwpoison-fix-unpoison_memory
+++ a/include/linux/page-flags.h
@@ -522,7 +522,11 @@ PAGEFLAG_FALSE(Uncached, uncached)
 PAGEFLAG(HWPoison, hwpoison, PF_ANY)
 TESTSCFLAG(HWPoison, hwpoison, PF_ANY)
 #define __PG_HWPOISON (1UL << PG_hwpoison)
+#define MAGIC_HWPOISON	0x48575053U	/* HWPS */
+extern void SetPageHWPoisonTakenOff(struct page *page);
+extern void ClearPageHWPoisonTakenOff(struct page *page);
 extern bool take_page_off_buddy(struct page *page);
+extern bool put_page_back_buddy(struct page *page);
 #else
 PAGEFLAG_FALSE(HWPoison, hwpoison)
 #define __PG_HWPOISON 0
--- a/mm/memory-failure.c~mm-hwpoison-fix-unpoison_memory
+++ a/mm/memory-failure.c
@@ -1160,6 +1160,22 @@ static int page_action(struct page_state
 	return (result == MF_RECOVERED || result == MF_DELAYED) ? 0 : -EBUSY;
 }
 
+static inline bool PageHWPoisonTakenOff(struct page *page)
+{
+	return PageHWPoison(page) && page_private(page) == MAGIC_HWPOISON;
+}
+
+void SetPageHWPoisonTakenOff(struct page *page)
+{
+	set_page_private(page, MAGIC_HWPOISON);
+}
+
+void ClearPageHWPoisonTakenOff(struct page *page)
+{
+	if (PageHWPoison(page))
+		set_page_private(page, 0);
+}
+
 /*
  * Return true if a page type of a given page is supported by hwpoison
  * mechanism (while handling could fail), otherwise false.  This function
@@ -1262,6 +1278,27 @@ out:
 	return ret;
 }
 
+static int __get_unpoison_page(struct page *page)
+{
+	struct page *head = compound_head(page);
+	int ret = 0;
+	bool hugetlb = false;
+
+	ret = get_hwpoison_huge_page(head, &hugetlb);
+	if (hugetlb)
+		return ret;
+
+	/*
+	 * PageHWPoisonTakenOff pages are not only marked as PG_hwpoison,
+	 * but also isolated from buddy freelist, so need to identify the
+	 * state and have to cancel both operations to unpoison.
+	 */
+	if (PageHWPoisonTakenOff(page))
+		return -EHWPOISON;
+
+	return get_page_unless_zero(page) ? 1 : 0;
+}
+
 /**
  * get_hwpoison_page() - Get refcount for memory error handling
  * @p:		Raw error page (hit by memory error)
@@ -1278,18 +1315,26 @@ out:
  * extra care for the error page's state (as done in __get_hwpoison_page()),
  * and has some retry logic in get_any_page().
  *
+ * When called from unpoison_memory(), the caller should already ensure that
+ * the given page has PG_hwpoison. So it's never reused for other page
+ * allocations, and __get_unpoison_page() never races with them.
+ *
  * Return: 0 on failure,
  *         1 on success for in-use pages in a well-defined state,
  *         -EIO for pages on which we can not handle memory errors,
  *         -EBUSY when get_hwpoison_page() has raced with page lifecycle
- *         operations like allocation and free.
+ *         operations like allocation and free,
+ *         -EHWPOISON when the page is hwpoisoned and taken off from buddy.
  */
 static int get_hwpoison_page(struct page *p, unsigned long flags)
 {
 	int ret;
 
 	zone_pcp_disable(page_zone(p));
-	ret = get_any_page(p, flags);
+	if (flags & MF_UNPOISON)
+		ret = __get_unpoison_page(p);
+	else
+		ret = get_any_page(p, flags);
 	zone_pcp_enable(page_zone(p));
 
 	return ret;
@@ -1937,6 +1982,28 @@ core_initcall(memory_failure_init);
 		pr_info(fmt, pfn);			\
 })
 
+static inline int clear_page_hwpoison(struct ratelimit_state *rs, struct page *p)
+{
+	if (TestClearPageHWPoison(p)) {
+		unpoison_pr_info("Unpoison: Software-unpoisoned page %#lx\n",
+				 page_to_pfn(p), rs);
+		num_poisoned_pages_dec();
+		return 1;
+	}
+	return 0;
+}
+
+static inline int unpoison_taken_off_page(struct ratelimit_state *rs,
+					  struct page *p)
+{
+	if (put_page_back_buddy(p)) {
+		unpoison_pr_info("Unpoison: Software-unpoisoned page %#lx\n",
+				 page_to_pfn(p), rs);
+		return 0;
+	}
+	return -EBUSY;
+}
+
 /**
  * unpoison_memory - Unpoison a previously poisoned page
  * @pfn: Page number of the to be unpoisoned page
@@ -1953,9 +2020,7 @@ int unpoison_memory(unsigned long pfn)
 {
 	struct page *page;
 	struct page *p;
-	int freeit = 0;
-	int ret = 0;
-	unsigned long flags = 0;
+	int ret = -EBUSY;
 	static DEFINE_RATELIMIT_STATE(unpoison_rs, DEFAULT_RATELIMIT_INTERVAL,
 					DEFAULT_RATELIMIT_BURST);
 
@@ -1991,24 +2056,30 @@ int unpoison_memory(unsigned long pfn)
 		goto unlock_mutex;
 	}
 
-	if (!get_hwpoison_page(p, flags)) {
-		if (TestClearPageHWPoison(p))
-			num_poisoned_pages_dec();
-		unpoison_pr_info("Unpoison: Software-unpoisoned free page %#lx\n",
-				 pfn, &unpoison_rs);
+	if (PageSlab(page) || PageTable(page))
 		goto unlock_mutex;
-	}
 
-	if (TestClearPageHWPoison(page)) {
-		unpoison_pr_info("Unpoison: Software-unpoisoned page %#lx\n",
-				 pfn, &unpoison_rs);
-		num_poisoned_pages_dec();
-		freeit = 1;
-	}
+	ret = get_hwpoison_page(p, MF_UNPOISON);
+	if (!ret) {
+		if (clear_page_hwpoison(&unpoison_rs, page))
+			ret = 0;
+		else
+			ret = -EBUSY;
+	} else if (ret < 0) {
+		if (ret == -EHWPOISON) {
+			ret = unpoison_taken_off_page(&unpoison_rs, p);
+		} else
+			unpoison_pr_info("Unpoison: failed to grab page %#lx\n",
+					 pfn, &unpoison_rs);
+	} else {
+		int freeit = clear_page_hwpoison(&unpoison_rs, p);
 
-	put_page(page);
-	if (freeit && !(pfn == my_zero_pfn(0) && page_count(p) == 1))
 		put_page(page);
+		if (freeit && !(pfn == my_zero_pfn(0) && page_count(p) == 1)) {
+			put_page(page);
+			ret = 0;
+		}
+	}
 
 unlock_mutex:
 	mutex_unlock(&mf_mutex);
--- a/mm/page_alloc.c~mm-hwpoison-fix-unpoison_memory
+++ a/mm/page_alloc.c
@@ -19,6 +19,7 @@
 #include <linux/mm.h>
 #include <linux/highmem.h>
 #include <linux/swap.h>
+#include <linux/swapops.h>
 #include <linux/interrupt.h>
 #include <linux/pagemap.h>
 #include <linux/jiffies.h>
@@ -9508,6 +9509,7 @@ bool take_page_off_buddy(struct page *pa
 			del_page_from_free_list(page_head, zone, page_order);
 			break_down_buddy_pages(zone, page_head, page, 0,
 						page_order, migratetype);
+			SetPageHWPoisonTakenOff(page);
 			if (!is_migrate_isolate(migratetype))
 				__mod_zone_freepage_state(zone, -1, migratetype);
 			ret = true;
@@ -9519,6 +9521,31 @@ bool take_page_off_buddy(struct page *pa
 	spin_unlock_irqrestore(&zone->lock, flags);
 	return ret;
 }
+
+/*
+ * Cancel takeoff done by take_page_off_buddy().
+ */
+bool put_page_back_buddy(struct page *page)
+{
+	struct zone *zone = page_zone(page);
+	unsigned long pfn = page_to_pfn(page);
+	unsigned long flags;
+	int migratetype = get_pfnblock_migratetype(page, pfn);
+	bool ret = false;
+
+	spin_lock_irqsave(&zone->lock, flags);
+	if (put_page_testzero(page)) {
+		ClearPageHWPoisonTakenOff(page);
+		__free_one_page(page, pfn, zone, 0, migratetype, FPI_NONE);
+		if (TestClearPageHWPoison(page)) {
+			num_poisoned_pages_dec();
+			ret = true;
+		}
+	}
+	spin_unlock_irqrestore(&zone->lock, flags);
+
+	return ret;
+}
 #endif
 
 #ifdef CONFIG_ZONE_DMA
_
