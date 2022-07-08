Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D0F3CCA480
	for <mm-commits@archiver.kernel.org>; Fri,  8 Jul 2022 00:54:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236326AbiGHAy0 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 7 Jul 2022 20:54:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236343AbiGHAyZ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 7 Jul 2022 20:54:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52E536B26F
        for <mm-commits@vger.kernel.org>; Thu,  7 Jul 2022 17:54:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E327C612CE
        for <mm-commits@vger.kernel.org>; Fri,  8 Jul 2022 00:54:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 406EAC3411E;
        Fri,  8 Jul 2022 00:54:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1657241663;
        bh=3ODPJN6IDJ7RcuopGV7F6rHCqgrCacu6zmJ+R9rnyQU=;
        h=Date:To:From:Subject:From;
        b=a8/4sWfSbchH9fWru416qlMrJ7dDIZD2f6zxSwr1k5GJaenGcJSuK7eVHgVRsfwdB
         kcYoGSlbcuuyUHRVwPFVvUnLSPUCR2dvIV1hemBbDf2zxGNli3wZxRYv3bvKYAY9R6
         ZKYtuDow4yzO74doKe8Hx+LDfE6C9u2ngINEgSpU=
Date:   Thu, 07 Jul 2022 17:54:22 -0700
To:     mm-commits@vger.kernel.org, songmuchun@bytedance.com,
        shy828301@gmail.com, osalvador@suse.de, mike.kravetz@oracle.com,
        liushixin2@huawei.com, linmiaohe@huawei.com, david@redhat.com,
        naoya.horiguchi@nec.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-hwpoison-make-unpoison-aware-of-raw-error-info-in-hwpoisoned-hugepage.patch removed from -mm tree
Message-Id: <20220708005423.406EAC3411E@smtp.kernel.org>
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
Date: Mon, 4 Jul 2022 10:33:08 +0900

Raw error info list needs to be removed when hwpoisoned hugetlb is
unpoisoned.  And unpoison handler needs to know how many errors there are
in the target hugepage.  So add them.

Link: https://lkml.kernel.org/r/20220704013312.2415700-6-naoya.horiguchi@linux.dev
Signed-off-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Liu Shixin <liushixin2@huawei.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Yang Shi <shy828301@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/swapops.h |    9 +++++++++
 mm/memory-failure.c     |   31 +++++++++++++++++++++++++------
 2 files changed, 34 insertions(+), 6 deletions(-)

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
@@ -1722,22 +1722,33 @@ static inline int hugetlb_set_page_hwpoi
 	return ret;
 }
 
-inline int hugetlb_clear_page_hwpoison(struct page *hpage)
+static inline long free_raw_hwp_pages(struct page *hpage, bool move_flag)
 {
 	struct llist_head *head;
 	struct llist_node *t, *tnode;
+	long count = 0;
 
-	if (!HPageRawHwpUnreliable(hpage))
-		ClearPageHWPoison(hpage);
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
+inline int hugetlb_clear_page_hwpoison(struct page *hpage)
+{
+	int ret = -EBUSY;
+
+	if (!HPageRawHwpUnreliable(hpage))
+		ret = !TestClearPageHWPoison(hpage);
+	free_raw_hwp_pages(hpage, true);
+	return ret;
 }
 
 /*
@@ -1882,6 +1893,9 @@ static inline int try_memory_failure_hug
 	return 0;
 }
 
+static inline void free_raw_hwp_pages(struct page *hpage, bool move_flag)
+{
+}
 #endif	/* CONFIG_HUGETLB_PAGE */
 
 static int memory_failure_dev_pagemap(unsigned long pfn, int flags,
@@ -2287,6 +2301,7 @@ int unpoison_memory(unsigned long pfn)
 	struct page *p;
 	int ret = -EBUSY;
 	int freeit = 0;
+	long count = 1;
 	static DEFINE_RATELIMIT_STATE(unpoison_rs, DEFAULT_RATELIMIT_INTERVAL,
 					DEFAULT_RATELIMIT_BURST);
 
@@ -2334,6 +2349,8 @@ int unpoison_memory(unsigned long pfn)
 
 	ret = get_hwpoison_page(p, MF_UNPOISON);
 	if (!ret) {
+		if (PageHuge(p))
+			count = free_raw_hwp_pages(page, false);
 		ret = TestClearPageHWPoison(page) ? 0 : -EBUSY;
 	} else if (ret < 0) {
 		if (ret == -EHWPOISON) {
@@ -2342,6 +2359,8 @@ int unpoison_memory(unsigned long pfn)
 			unpoison_pr_info("Unpoison: failed to grab page %#lx\n",
 					 pfn, &unpoison_rs);
 	} else {
+		if (PageHuge(p))
+			count = free_raw_hwp_pages(page, false);
 		freeit = !!TestClearPageHWPoison(p);
 
 		put_page(page);
@@ -2354,7 +2373,7 @@ int unpoison_memory(unsigned long pfn)
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
mm-hwpoison-make-unpoison-aware-of-raw-error-info-in-hwpoisoned-hugepage-fix.patch
mm-hwpoison-set-pg_hwpoison-for-busy-hugetlb-pages.patch
mm-hwpoison-make-__page_handle_poison-returns-int.patch
mm-hwpoison-skip-raw-hwpoison-page-in-freeing-1gb-hugepage.patch
mm-hwpoison-enable-memory-error-handling-on-1gb-hugepage.patch

