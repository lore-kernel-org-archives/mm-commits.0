Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E374ACCA47F
	for <mm-commits@archiver.kernel.org>; Fri,  8 Jul 2022 20:27:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239823AbiGHU1a (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 8 Jul 2022 16:27:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240050AbiGHU1Z (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 8 Jul 2022 16:27:25 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2AEE88F1F
        for <mm-commits@vger.kernel.org>; Fri,  8 Jul 2022 13:27:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 75C49B80522
        for <mm-commits@vger.kernel.org>; Fri,  8 Jul 2022 20:27:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23BC5C341C0;
        Fri,  8 Jul 2022 20:27:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1657312042;
        bh=6mNtSACpM/Qy9RCslXbQEf5ykRQZEOl7734RpFe1WcI=;
        h=Date:To:From:Subject:From;
        b=z+qLPVhHoAPh5Hv3Sf4O4gVGLlW2L/w3WrMPMOcMKOwyR2IBm2TwhYDAZri9g3QMk
         lpdiB9LLeqmLZ90INtEP5J0o+duKI8s+Jp2CTM1HUxhWll22JkNABK0r9FiPXJAar2
         k8XDImVQ5DIJFkH3bCTRpN59yS0wOjbO3JHhrMaM=
Date:   Fri, 08 Jul 2022 13:27:21 -0700
To:     mm-commits@vger.kernel.org, songmuchun@bytedance.com,
        shy828301@gmail.com, osalvador@suse.de, mike.kravetz@oracle.com,
        lkp@intel.com, liushixin2@huawei.com, linmiaohe@huawei.com,
        david@redhat.com, naoya.horiguchi@nec.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hwpoison-make-unpoison-aware-of-raw-error-info-in-hwpoisoned-hugepage.patch added to mm-unstable branch
Message-Id: <20220708202722.23BC5C341C0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm, hwpoison: make unpoison aware of raw error info in hwpoisoned hugepage
has been added to the -mm mm-unstable branch.  Its filename is
     mm-hwpoison-make-unpoison-aware-of-raw-error-info-in-hwpoisoned-hugepage.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hwpoison-make-unpoison-aware-of-raw-error-info-in-hwpoisoned-hugepage.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

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
mm-hugetlb-check-gigantic_page_runtime_supported-in-return_unused_surplus_pages.patch
mm-hugetlb-make-pud_huge-and-follow_huge_pud-aware-of-non-present-pud-entry.patch
mm-hwpoison-hugetlb-support-saving-mechanism-of-raw-error-pages.patch
mm-hwpoison-make-unpoison-aware-of-raw-error-info-in-hwpoisoned-hugepage.patch
mm-hwpoison-set-pg_hwpoison-for-busy-hugetlb-pages.patch
mm-hwpoison-make-__page_handle_poison-returns-int.patch
mm-hwpoison-skip-raw-hwpoison-page-in-freeing-1gb-hugepage.patch
mm-hwpoison-enable-memory-error-handling-on-1gb-hugepage.patch

