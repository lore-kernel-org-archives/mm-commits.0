Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36595C433FE
	for <mm-commits@archiver.kernel.org>; Tue, 10 May 2022 04:13:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232752AbiEJER0 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 10 May 2022 00:17:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236201AbiEJEQa (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 10 May 2022 00:16:30 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 460D123AE5B
        for <mm-commits@vger.kernel.org>; Mon,  9 May 2022 21:12:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 05312B81AF7
        for <mm-commits@vger.kernel.org>; Tue, 10 May 2022 04:12:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9E65C385C7;
        Tue, 10 May 2022 04:12:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652155925;
        bh=HmW9DLh4xT/523BpQ3GopI3XkhMre7MuULH90gJ22GA=;
        h=Date:To:From:Subject:From;
        b=yq/mfxhDVLNbDMMann9Ll8Y/brZy15gpwv3lTyesss4ZcIQgUNklk8DtZj/c6L9zF
         TNixxReCUIbiqDc3HZUve+qjgljuzmGRuHWhVQBi6iwYNZ3OcDwGW4i9kK+dvUIDco
         6/tb2984TJbcgmbj3X/Uferh7JvQb1oCxL2FMYb8=
Date:   Mon, 09 May 2022 21:12:05 -0700
To:     mm-commits@vger.kernel.org, mike.kravetz@oracle.com,
        david@redhat.com, songmuchun@bytedance.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-hugetlb_vmemmap-cleanup-hugetlb_vmemmap-related-functions.patch removed from -mm tree
Message-Id: <20220510041205.A9E65C385C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: hugetlb_vmemmap: cleanup hugetlb_vmemmap related functions
has been removed from the -mm tree.  Its filename was
     mm-hugetlb_vmemmap-cleanup-hugetlb_vmemmap-related-functions.patch

This patch was dropped because it was merged into mm-stable

------------------------------------------------------
From: Muchun Song <songmuchun@bytedance.com>
Subject: mm: hugetlb_vmemmap: cleanup hugetlb_vmemmap related functions

Patch series "cleanup hugetlb_vmemmap".

The word of "free" is not expressive enough to express the feature of
optimizing vmemmap pages associated with each HugeTLB, rename this keywork
to "optimize" is more clear.  In this series, cheanup related codes to
make it more clear and expressive.  This is suggested by David.


This patch (of 3):

The word of "free" is not expressive enough to express the feature of
optimizing vmemmap pages associated with each HugeTLB, rename this keywork
to "optimize".  And some function names are prefixed with "huge_page"
instead of "hugetlb", it is easily to be confused with THP.  In this
patch, cheanup related functions to make code more clear and expressive.

Link: https://lkml.kernel.org/r/20220404074652.68024-1-songmuchun@bytedance.com
Link: https://lkml.kernel.org/r/20220404074652.68024-2-songmuchun@bytedance.com
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/hugetlb.h |    2 -
 mm/hugetlb.c            |   10 ++++-----
 mm/hugetlb_vmemmap.c    |   42 ++++++++++++++++++--------------------
 mm/hugetlb_vmemmap.h    |   20 +++++++++---------
 4 files changed, 36 insertions(+), 38 deletions(-)

--- a/include/linux/hugetlb.h~mm-hugetlb_vmemmap-cleanup-hugetlb_vmemmap-related-functions
+++ a/include/linux/hugetlb.h
@@ -624,7 +624,7 @@ struct hstate {
 	unsigned int free_huge_pages_node[MAX_NUMNODES];
 	unsigned int surplus_huge_pages_node[MAX_NUMNODES];
 #ifdef CONFIG_HUGETLB_PAGE_FREE_VMEMMAP
-	unsigned int nr_free_vmemmap_pages;
+	unsigned int optimize_vmemmap_pages;
 #endif
 #ifdef CONFIG_CGROUP_HUGETLB
 	/* cgroup control files */
--- a/mm/hugetlb.c~mm-hugetlb_vmemmap-cleanup-hugetlb_vmemmap-related-functions
+++ a/mm/hugetlb.c
@@ -1540,7 +1540,7 @@ static void __update_and_free_page(struc
 	if (hstate_is_gigantic(h) && !gigantic_page_runtime_supported())
 		return;
 
-	if (alloc_huge_page_vmemmap(h, page)) {
+	if (hugetlb_vmemmap_alloc(h, page)) {
 		spin_lock_irq(&hugetlb_lock);
 		/*
 		 * If we cannot allocate vmemmap pages, just refuse to free the
@@ -1617,7 +1617,7 @@ static DECLARE_WORK(free_hpage_work, fre
 
 static inline void flush_free_hpage_work(struct hstate *h)
 {
-	if (free_vmemmap_pages_per_hpage(h))
+	if (hugetlb_optimize_vmemmap_pages(h))
 		flush_work(&free_hpage_work);
 }
 
@@ -1737,7 +1737,7 @@ static void __prep_account_new_huge_page
 
 static void __prep_new_huge_page(struct hstate *h, struct page *page)
 {
-	free_huge_page_vmemmap(h, page);
+	hugetlb_vmemmap_free(h, page);
 	INIT_LIST_HEAD(&page->lru);
 	set_compound_page_dtor(page, HUGETLB_PAGE_DTOR);
 	hugetlb_set_page_subpool(page, NULL);
@@ -2110,7 +2110,7 @@ retry:
 		 * Attempt to allocate vmemmmap here so that we can take
 		 * appropriate action on failure.
 		 */
-		rc = alloc_huge_page_vmemmap(h, head);
+		rc = hugetlb_vmemmap_alloc(h, head);
 		if (!rc) {
 			/*
 			 * Move PageHWPoison flag from head page to the raw
@@ -3425,7 +3425,7 @@ static int demote_free_huge_page(struct
 	remove_hugetlb_page_for_demote(h, page, false);
 	spin_unlock_irq(&hugetlb_lock);
 
-	rc = alloc_huge_page_vmemmap(h, page);
+	rc = hugetlb_vmemmap_alloc(h, page);
 	if (rc) {
 		/* Allocation of vmemmmap failed, we can not demote page */
 		spin_lock_irq(&hugetlb_lock);
--- a/mm/hugetlb_vmemmap.c~mm-hugetlb_vmemmap-cleanup-hugetlb_vmemmap-related-functions
+++ a/mm/hugetlb_vmemmap.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0
 /*
- * Free some vmemmap pages of HugeTLB
+ * Optimize vmemmap pages associated with HugeTLB
  *
  * Copyright (c) 2020, Bytedance. All rights reserved.
  *
@@ -192,7 +192,7 @@ DEFINE_STATIC_KEY_MAYBE(CONFIG_HUGETLB_P
 			hugetlb_free_vmemmap_enabled_key);
 EXPORT_SYMBOL(hugetlb_free_vmemmap_enabled_key);
 
-static int __init early_hugetlb_free_vmemmap_param(char *buf)
+static int __init hugetlb_vmemmap_early_param(char *buf)
 {
 	/* We cannot optimize if a "struct page" crosses page boundaries. */
 	if (!is_power_of_2(sizeof(struct page))) {
@@ -212,29 +212,26 @@ static int __init early_hugetlb_free_vme
 
 	return 0;
 }
-early_param("hugetlb_free_vmemmap", early_hugetlb_free_vmemmap_param);
-
-static inline unsigned long free_vmemmap_pages_size_per_hpage(struct hstate *h)
-{
-	return (unsigned long)free_vmemmap_pages_per_hpage(h) << PAGE_SHIFT;
-}
+early_param("hugetlb_free_vmemmap", hugetlb_vmemmap_early_param);
 
 /*
  * Previously discarded vmemmap pages will be allocated and remapping
  * after this function returns zero.
  */
-int alloc_huge_page_vmemmap(struct hstate *h, struct page *head)
+int hugetlb_vmemmap_alloc(struct hstate *h, struct page *head)
 {
 	int ret;
 	unsigned long vmemmap_addr = (unsigned long)head;
-	unsigned long vmemmap_end, vmemmap_reuse;
+	unsigned long vmemmap_end, vmemmap_reuse, vmemmap_pages;
 
 	if (!HPageVmemmapOptimized(head))
 		return 0;
 
-	vmemmap_addr += RESERVE_VMEMMAP_SIZE;
-	vmemmap_end = vmemmap_addr + free_vmemmap_pages_size_per_hpage(h);
-	vmemmap_reuse = vmemmap_addr - PAGE_SIZE;
+	vmemmap_addr	+= RESERVE_VMEMMAP_SIZE;
+	vmemmap_pages	= hugetlb_optimize_vmemmap_pages(h);
+	vmemmap_end	= vmemmap_addr + (vmemmap_pages << PAGE_SHIFT);
+	vmemmap_reuse	= vmemmap_addr - PAGE_SIZE;
+
 	/*
 	 * The pages which the vmemmap virtual address range [@vmemmap_addr,
 	 * @vmemmap_end) are mapped to are freed to the buddy allocator, and
@@ -250,17 +247,18 @@ int alloc_huge_page_vmemmap(struct hstat
 	return ret;
 }
 
-void free_huge_page_vmemmap(struct hstate *h, struct page *head)
+void hugetlb_vmemmap_free(struct hstate *h, struct page *head)
 {
 	unsigned long vmemmap_addr = (unsigned long)head;
-	unsigned long vmemmap_end, vmemmap_reuse;
+	unsigned long vmemmap_end, vmemmap_reuse, vmemmap_pages;
 
-	if (!free_vmemmap_pages_per_hpage(h))
+	vmemmap_pages = hugetlb_optimize_vmemmap_pages(h);
+	if (!vmemmap_pages)
 		return;
 
-	vmemmap_addr += RESERVE_VMEMMAP_SIZE;
-	vmemmap_end = vmemmap_addr + free_vmemmap_pages_size_per_hpage(h);
-	vmemmap_reuse = vmemmap_addr - PAGE_SIZE;
+	vmemmap_addr	+= RESERVE_VMEMMAP_SIZE;
+	vmemmap_end	= vmemmap_addr + (vmemmap_pages << PAGE_SHIFT);
+	vmemmap_reuse	= vmemmap_addr - PAGE_SIZE;
 
 	/*
 	 * Remap the vmemmap virtual address range [@vmemmap_addr, @vmemmap_end)
@@ -297,8 +295,8 @@ void __init hugetlb_vmemmap_init(struct
 	 * hugetlbpage.rst for more details.
 	 */
 	if (likely(vmemmap_pages > RESERVE_VMEMMAP_NR))
-		h->nr_free_vmemmap_pages = vmemmap_pages - RESERVE_VMEMMAP_NR;
+		h->optimize_vmemmap_pages = vmemmap_pages - RESERVE_VMEMMAP_NR;
 
-	pr_info("can free %d vmemmap pages for %s\n", h->nr_free_vmemmap_pages,
-		h->name);
+	pr_info("can optimize %d vmemmap pages for %s\n",
+		h->optimize_vmemmap_pages, h->name);
 }
--- a/mm/hugetlb_vmemmap.h~mm-hugetlb_vmemmap-cleanup-hugetlb_vmemmap-related-functions
+++ a/mm/hugetlb_vmemmap.h
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0
 /*
- * Free some vmemmap pages of HugeTLB
+ * Optimize vmemmap pages associated with HugeTLB
  *
  * Copyright (c) 2020, Bytedance. All rights reserved.
  *
@@ -11,25 +11,25 @@
 #include <linux/hugetlb.h>
 
 #ifdef CONFIG_HUGETLB_PAGE_FREE_VMEMMAP
-int alloc_huge_page_vmemmap(struct hstate *h, struct page *head);
-void free_huge_page_vmemmap(struct hstate *h, struct page *head);
+int hugetlb_vmemmap_alloc(struct hstate *h, struct page *head);
+void hugetlb_vmemmap_free(struct hstate *h, struct page *head);
 void hugetlb_vmemmap_init(struct hstate *h);
 
 /*
- * How many vmemmap pages associated with a HugeTLB page that can be freed
- * to the buddy allocator.
+ * How many vmemmap pages associated with a HugeTLB page that can be
+ * optimized and freed to the buddy allocator.
  */
-static inline unsigned int free_vmemmap_pages_per_hpage(struct hstate *h)
+static inline unsigned int hugetlb_optimize_vmemmap_pages(struct hstate *h)
 {
-	return h->nr_free_vmemmap_pages;
+	return h->optimize_vmemmap_pages;
 }
 #else
-static inline int alloc_huge_page_vmemmap(struct hstate *h, struct page *head)
+static inline int hugetlb_vmemmap_alloc(struct hstate *h, struct page *head)
 {
 	return 0;
 }
 
-static inline void free_huge_page_vmemmap(struct hstate *h, struct page *head)
+static inline void hugetlb_vmemmap_free(struct hstate *h, struct page *head)
 {
 }
 
@@ -37,7 +37,7 @@ static inline void hugetlb_vmemmap_init(
 {
 }
 
-static inline unsigned int free_vmemmap_pages_per_hpage(struct hstate *h)
+static inline unsigned int hugetlb_optimize_vmemmap_pages(struct hstate *h)
 {
 	return 0;
 }
_

Patches currently in -mm which might be from songmuchun@bytedance.com are

mm-hugetlb_vmemmap-disable-hugetlb_optimize_vmemmap-when-struct-page-crosses-page-boundaries.patch
mm-memory_hotplug-override-memmap_on_memory-when-hugetlb_free_vmemmap=on.patch
mm-hugetlb_vmemmap-use-kstrtobool-for-hugetlb_vmemmap-param-parsing.patch
mm-hugetlb_vmemmap-add-hugetlb_optimize_vmemmap-sysctl.patch

