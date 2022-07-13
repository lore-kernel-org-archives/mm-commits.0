Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71B5BCCA481
	for <mm-commits@archiver.kernel.org>; Wed, 13 Jul 2022 17:36:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231560AbiGMRgf (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 13 Jul 2022 13:36:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236216AbiGMRge (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 13 Jul 2022 13:36:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DA702CCA6
        for <mm-commits@vger.kernel.org>; Wed, 13 Jul 2022 10:36:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A094561D0B
        for <mm-commits@vger.kernel.org>; Wed, 13 Jul 2022 17:36:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF5D8C34114;
        Wed, 13 Jul 2022 17:36:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1657733792;
        bh=5ROnoHIT3Af4MNGlkTron+kGgAMD58zx9CqjPZxUepw=;
        h=Date:To:From:Subject:From;
        b=15PWc0j9XZyD+BWa2tANqS/PplAREx/OLZfRw4Kd10dfXL1j+Cu+xT3YEyUmcOlr/
         Drf5flaPEIJkGNJ+EmNNCIEmJI6xZNbopb6h3SWmoDF/JgXOU5x5dE8LgzB620hWW7
         aj/W68qg7x+BU9Rv6VqCBlbjBcVlkak/P/7FaiEY=
Date:   Wed, 13 Jul 2022 10:36:31 -0700
To:     mm-commits@vger.kernel.org, songmuchun@bytedance.com,
        shy828301@gmail.com, osalvador@suse.de, mike.kravetz@oracle.com,
        lkp@intel.com, liushixin2@huawei.com, linmiaohe@huawei.com,
        david@redhat.com, naoya.horiguchi@nec.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-hwpoison-make-unpoison-aware-of-raw-error-info-in-hwpoisoned-hugepage.patch removed from -mm tree
Message-Id: <20220713173631.EF5D8C34114@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm, hwpoison: make unpoison aware of raw error info in hwpoisoned hugepage
has been removed from the -mm tree.  Its filename was
     mm-hwpoison-make-unpoison-aware-of-raw-error-info-in-hwpoisoned-hugepage.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Naoya Horiguchi <naoya.horiguchi@nec.com>
Subject: mm, hwpoison: make unpoison aware of raw error info in hwpoisoned hugepage
Date: Fri, 8 Jul 2022 14:36:49 +0900

Raw error info list needs to be removed when hwpoisoned hugetlb is
unpoisoned.  And unpoison handler needs to know how many errors there are
in the target hugepage.  So add them.

HPageVmemmapOptimized(hpage) and HPageRawHwpUnreliable(hpage)) can't be
unpoisoned, so let's skip them.

Link: https://lkml.kernel.org/r/20220708053653.964464-5-naoya.horiguchi@linux.dev
Signed-off-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Reported-by: kernel test robot <lkp@intel.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Liu Shixin <liushixin2@huawei.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Yang Shi <shy828301@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/swapops.h |    9 ++++++
 mm/memory-failure.c     |   50 +++++++++++++++++++++++++++++++++-----
 2 files changed, 53 insertions(+), 6 deletions(-)

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
@@ -1720,22 +1720,41 @@ static int hugetlb_set_page_hwpoison(str
 	return ret;
 }
 
-int hugetlb_clear_page_hwpoison(struct page *hpage)
+static long free_raw_hwp_pages(struct page *hpage, bool move_flag)
 {
 	struct llist_head *head;
 	struct llist_node *t, *tnode;
+	long count = 0;
 
-	if (!HPageRawHwpUnreliable(hpage))
-		ClearPageHWPoison(hpage);
+	/*
+	 * HPageVmemmapOptimized hugepages can't be unpoisoned because
+	 * struct pages for tail pages are required to free hwpoisoned
+	 * hugepages.  HPageRawHwpUnreliable hugepages shouldn't be
+	 * unpoisoned by definition.
+	 */
+	if (HPageVmemmapOptimized(hpage) || HPageRawHwpUnreliable(hpage))
+		return 0;
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
-	return 0;
+	return count;
+}
+
+int hugetlb_clear_page_hwpoison(struct page *hpage)
+{
+	int ret = -EBUSY;
+
+	if (!HPageRawHwpUnreliable(hpage))
+		ret = !TestClearPageHWPoison(hpage);
+	free_raw_hwp_pages(hpage, true);
+	return ret;
 }
 
 /*
@@ -1879,6 +1898,10 @@ static inline int try_memory_failure_hug
 	return 0;
 }
 
+static inline long free_raw_hwp_pages(struct page *hpage, bool move_flag)
+{
+	return 0;
+}
 #endif	/* CONFIG_HUGETLB_PAGE */
 
 static int memory_failure_dev_pagemap(unsigned long pfn, int flags,
@@ -2284,6 +2307,7 @@ int unpoison_memory(unsigned long pfn)
 	struct page *p;
 	int ret = -EBUSY;
 	int freeit = 0;
+	long count = 1;
 	static DEFINE_RATELIMIT_STATE(unpoison_rs, DEFAULT_RATELIMIT_INTERVAL,
 					DEFAULT_RATELIMIT_BURST);
 
@@ -2331,6 +2355,13 @@ int unpoison_memory(unsigned long pfn)
 
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
@@ -2339,6 +2370,13 @@ int unpoison_memory(unsigned long pfn)
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
@@ -2351,7 +2389,7 @@ int unpoison_memory(unsigned long pfn)
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

mm-hugetlb-separate-path-for-hwpoison-entry-in-copy_hugetlb_page_range.patch
mm-hwpoison-set-pg_hwpoison-for-busy-hugetlb-pages.patch
mm-hwpoison-make-__page_handle_poison-returns-int.patch
mm-hwpoison-skip-raw-hwpoison-page-in-freeing-1gb-hugepage.patch
mm-hwpoison-enable-memory-error-handling-on-1gb-hugepage.patch

