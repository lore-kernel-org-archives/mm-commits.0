Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E6CAC25B08
	for <mm-commits@archiver.kernel.org>; Tue,  9 Aug 2022 01:14:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244733AbiHIBO4 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 8 Aug 2022 21:14:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244737AbiHIBOb (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 8 Aug 2022 21:14:31 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 828191DA61
        for <mm-commits@vger.kernel.org>; Mon,  8 Aug 2022 18:14:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 448B2B81116
        for <mm-commits@vger.kernel.org>; Tue,  9 Aug 2022 01:14:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D962EC433D7;
        Tue,  9 Aug 2022 01:14:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1660007667;
        bh=LD4ZMVIVayUFjxsFb4pG8PStfBlkfGnnLkyPBk0HH+k=;
        h=Date:To:From:Subject:From;
        b=OHwj8gVoZvYvZYm1LIeWftBMJ2cDe0FQ6fKkQZk679zR9K0EKp64afdnMPoivjaKa
         cXHOzarN+uK82hrasBrdgA6vg/tWDefXKOPerA84akwSP5mDRx5oVFa5eAN8u1qfbx
         rhjE8yKX1Nh1ZogKb1jSXB428wccqpuM4BGUsjPw=
Date:   Mon, 08 Aug 2022 18:14:27 -0700
To:     mm-commits@vger.kernel.org, songmuchun@bytedance.com,
        shy828301@gmail.com, osalvador@suse.de, mike.kravetz@oracle.com,
        lkp@intel.com, liushixin2@huawei.com, linmiaohe@huawei.com,
        david@redhat.com, naoya.horiguchi@nec.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-hwpoison-make-unpoison-aware-of-raw-error-info-in-hwpoisoned-hugepage.patch removed from -mm tree
Message-Id: <20220809011427.D962EC433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm, hwpoison: make unpoison aware of raw error info in hwpoisoned hugepage
has been removed from the -mm tree.  Its filename was
     mm-hwpoison-make-unpoison-aware-of-raw-error-info-in-hwpoisoned-hugepage.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Naoya Horiguchi <naoya.horiguchi@nec.com>
Subject: mm, hwpoison: make unpoison aware of raw error info in hwpoisoned hugepage
Date: Thu, 14 Jul 2022 13:24:16 +0900

Raw error info list needs to be removed when hwpoisoned hugetlb is
unpoisoned.  And unpoison handler needs to know how many errors there are
in the target hugepage.  So add them.

HPageVmemmapOptimized(hpage) and HPageRawHwpUnreliable(hpage)) sometimes
can't be unpoisoned, so skip them.

Link: https://lkml.kernel.org/r/20220714042420.1847125-5-naoya.horiguchi@linux.dev
Signed-off-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Reported-by: kernel test robot <lkp@intel.com>
Reviewed-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Liu Shixin <liushixin2@huawei.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Yang Shi <shy828301@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/swapops.h |    9 ++++++
 mm/memory-failure.c     |   52 ++++++++++++++++++++++++++++++++++----
 2 files changed, 56 insertions(+), 5 deletions(-)

--- a/include/linux/swapops.h~mm-hwpoison-make-unpoison-aware-of-raw-error-info-in-hwpoisoned-hugepage
+++ a/include/linux/swapops.h
@@ -490,6 +490,11 @@ static inline void num_poisoned_pages_de
 	atomic_long_dec(&num_poisoned_pages);
 }
 
+static inline void num_poisoned_pages_sub(long i)
+{
+	atomic_long_sub(i, &num_poisoned_pages);
+}
+
 #else
 
 static inline swp_entry_t make_hwpoison_entry(struct page *page)
@@ -505,6 +510,10 @@ static inline int is_hwpoison_entry(swp_
 static inline void num_poisoned_pages_inc(void)
 {
 }
+
+static inline void num_poisoned_pages_sub(long i)
+{
+}
 #endif
 
 static inline int non_swap_entry(swp_entry_t entry)
--- a/mm/memory-failure.c~mm-hwpoison-make-unpoison-aware-of-raw-error-info-in-hwpoisoned-hugepage
+++ a/mm/memory-failure.c
@@ -1678,19 +1678,23 @@ static inline struct llist_head *raw_hwp
 	return (struct llist_head *)&page_private(hpage + SUBPAGE_INDEX_HWPOISON);
 }
 
-static void __free_raw_hwp_pages(struct page *hpage)
+static unsigned long __free_raw_hwp_pages(struct page *hpage, bool move_flag)
 {
 	struct llist_head *head;
 	struct llist_node *t, *tnode;
+	unsigned long count = 0;
 
 	head = raw_hwp_list_head(hpage);
 	llist_for_each_safe(tnode, t, head->first) {
 		struct raw_hwp_page *p = container_of(tnode, struct raw_hwp_page, node);
 
-		SetPageHWPoison(p->page);
+		if (move_flag)
+			SetPageHWPoison(p->page);
 		kfree(p);
+		count++;
 	}
 	llist_del_all(head);
+	return count;
 }
 
 static int hugetlb_set_page_hwpoison(struct page *hpage, struct page *page)
@@ -1733,17 +1737,36 @@ static int hugetlb_set_page_hwpoison(str
 		 * Once HPageRawHwpUnreliable is set, raw_hwp_page is not
 		 * used any more, so free it.
 		 */
-		__free_raw_hwp_pages(hpage);
+		__free_raw_hwp_pages(hpage, false);
 	}
 	return ret;
 }
 
+static unsigned long free_raw_hwp_pages(struct page *hpage, bool move_flag)
+{
+	/*
+	 * HPageVmemmapOptimized hugepages can't be freed because struct
+	 * pages for tail pages are required but they don't exist.
+	 */
+	if (move_flag && HPageVmemmapOptimized(hpage))
+		return 0;
+
+	/*
+	 * HPageRawHwpUnreliable hugepages shouldn't be unpoisoned by
+	 * definition.
+	 */
+	if (HPageRawHwpUnreliable(hpage))
+		return 0;
+
+	return __free_raw_hwp_pages(hpage, move_flag);
+}
+
 void hugetlb_clear_page_hwpoison(struct page *hpage)
 {
 	if (HPageRawHwpUnreliable(hpage))
 		return;
 	ClearPageHWPoison(hpage);
-	__free_raw_hwp_pages(hpage);
+	free_raw_hwp_pages(hpage, true);
 }
 
 /*
@@ -1887,6 +1910,10 @@ static inline int try_memory_failure_hug
 	return 0;
 }
 
+static inline unsigned long free_raw_hwp_pages(struct page *hpage, bool flag)
+{
+	return 0;
+}
 #endif	/* CONFIG_HUGETLB_PAGE */
 
 static int memory_failure_dev_pagemap(unsigned long pfn, int flags,
@@ -2292,6 +2319,7 @@ int unpoison_memory(unsigned long pfn)
 	struct page *p;
 	int ret = -EBUSY;
 	int freeit = 0;
+	unsigned long count = 1;
 	static DEFINE_RATELIMIT_STATE(unpoison_rs, DEFAULT_RATELIMIT_INTERVAL,
 					DEFAULT_RATELIMIT_BURST);
 
@@ -2339,6 +2367,13 @@ int unpoison_memory(unsigned long pfn)
 
 	ret = get_hwpoison_page(p, MF_UNPOISON);
 	if (!ret) {
+		if (PageHuge(p)) {
+			count = free_raw_hwp_pages(page, false);
+			if (count == 0) {
+				ret = -EBUSY;
+				goto unlock_mutex;
+			}
+		}
 		ret = TestClearPageHWPoison(page) ? 0 : -EBUSY;
 	} else if (ret < 0) {
 		if (ret == -EHWPOISON) {
@@ -2347,6 +2382,13 @@ int unpoison_memory(unsigned long pfn)
 			unpoison_pr_info("Unpoison: failed to grab page %#lx\n",
 					 pfn, &unpoison_rs);
 	} else {
+		if (PageHuge(p)) {
+			count = free_raw_hwp_pages(page, false);
+			if (count == 0) {
+				ret = -EBUSY;
+				goto unlock_mutex;
+			}
+		}
 		freeit = !!TestClearPageHWPoison(p);
 
 		put_page(page);
@@ -2359,7 +2401,7 @@ int unpoison_memory(unsigned long pfn)
 unlock_mutex:
 	mutex_unlock(&mf_mutex);
 	if (!ret || freeit) {
-		num_poisoned_pages_dec();
+		num_poisoned_pages_sub(count);
 		unpoison_pr_info("Unpoison: Software-unpoisoned page %#lx\n",
 				 page_to_pfn(p), &unpoison_rs);
 	}
_

Patches currently in -mm which might be from naoya.horiguchi@nec.com are


