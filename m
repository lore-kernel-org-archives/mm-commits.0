Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D144C25B71
	for <mm-commits@archiver.kernel.org>; Wed, 25 Oct 2023 23:47:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230264AbjJYXrz (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 25 Oct 2023 19:47:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229573AbjJYXrw (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 25 Oct 2023 19:47:52 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1020C18B
        for <mm-commits@vger.kernel.org>; Wed, 25 Oct 2023 16:47:50 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF631C433C7;
        Wed, 25 Oct 2023 23:47:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1698277669;
        bh=gOCjPVcQGU6Vy9ALkwFdEvOy6MB4KAJvOAJgAZKP8qk=;
        h=Date:To:From:Subject:From;
        b=uYQjg2CKvtzAib2PNiEN0CIm1QggBKdq1rsGU/uM9Qu/GoTFvlLlj5laCvdQpTVch
         UVLeUvWglCujMRzRC8ztWwPy62LyF+RcNaar/ZZnSSw0JzPcYQ8uNRPE3nZI/fbuhC
         6pvSAnnQyR6GtytlBmtUn+c1f9vzFJAqTcxomBrI=
Date:   Wed, 25 Oct 2023 16:47:49 -0700
To:     mm-commits@vger.kernel.org, songmuchun@bytedance.com,
        punit.agrawal@bytedance.com, mike.kravetz@oracle.com,
        fam.zheng@bytedance.com, usama.arif@bytedance.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] hugetlb_vmemmap-use-folio-argument-for-hugetlb_vmemmap_-functions.patch removed from -mm tree
Message-Id: <20231025234749.CF631C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: hugetlb_vmemmap: use folio argument for hugetlb_vmemmap_* functions
has been removed from the -mm tree.  Its filename was
     hugetlb_vmemmap-use-folio-argument-for-hugetlb_vmemmap_-functions.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Usama Arif <usama.arif@bytedance.com>
Subject: hugetlb_vmemmap: use folio argument for hugetlb_vmemmap_* functions
Date: Wed, 11 Oct 2023 15:45:57 +0100

Most function calls in hugetlb.c are made with folio arguments.  This
brings hugetlb_vmemmap calls inline with them by using folio instead of
head struct page.  Head struct page is still needed within these
functions.

The set/clear/test functions for hugepages are also changed to folio
versions.

Link: https://lkml.kernel.org/r/20231011144557.1720481-2-usama.arif@bytedance.com
Signed-off-by: Usama Arif <usama.arif@bytedance.com>
Reviewed-by: Muchun Song <songmuchun@bytedance.com>
Cc: Fam Zheng <fam.zheng@bytedance.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Punit Agrawal <punit.agrawal@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c         |   14 +++++------
 mm/hugetlb_vmemmap.c |   50 +++++++++++++++++++++--------------------
 mm/hugetlb_vmemmap.h |    8 +++---
 3 files changed, 37 insertions(+), 35 deletions(-)

--- a/mm/hugetlb.c~hugetlb_vmemmap-use-folio-argument-for-hugetlb_vmemmap_-functions
+++ a/mm/hugetlb.c
@@ -1747,10 +1747,10 @@ static void __update_and_free_hugetlb_fo
 
 	/*
 	 * If folio is not vmemmap optimized (!clear_dtor), then the folio
-	 * is no longer identified as a hugetlb page.  hugetlb_vmemmap_restore
+	 * is no longer identified as a hugetlb page.  hugetlb_vmemmap_restore_folio
 	 * can only be passed hugetlb pages and will BUG otherwise.
 	 */
-	if (clear_dtor && hugetlb_vmemmap_restore(h, &folio->page)) {
+	if (clear_dtor && hugetlb_vmemmap_restore_folio(h, folio)) {
 		spin_lock_irq(&hugetlb_lock);
 		/*
 		 * If we cannot allocate vmemmap pages, just refuse to free the
@@ -1893,7 +1893,7 @@ static void bulk_vmemmap_restore_error(s
 		 * quit processing the list to retry the bulk operation.
 		 */
 		list_for_each_entry_safe(folio, t_folio, folio_list, lru)
-			if (hugetlb_vmemmap_restore(h, &folio->page)) {
+			if (hugetlb_vmemmap_restore_folio(h, folio)) {
 				list_del(&folio->lru);
 				spin_lock_irq(&hugetlb_lock);
 				add_hugetlb_folio(h, folio, true);
@@ -2051,7 +2051,7 @@ static void init_new_hugetlb_folio(struc
 static void __prep_new_hugetlb_folio(struct hstate *h, struct folio *folio)
 {
 	init_new_hugetlb_folio(h, folio);
-	hugetlb_vmemmap_optimize(h, &folio->page);
+	hugetlb_vmemmap_optimize_folio(h, folio);
 }
 
 static void prep_new_hugetlb_folio(struct hstate *h, struct folio *folio, int nid)
@@ -2462,7 +2462,7 @@ retry:
 		 * non-vmemmap optimized hugetlb folios.
 		 */
 		if (folio_test_hugetlb(folio)) {
-			rc = hugetlb_vmemmap_restore(h, &folio->page);
+			rc = hugetlb_vmemmap_restore_folio(h, folio);
 			if (rc) {
 				spin_lock_irq(&hugetlb_lock);
 				add_hugetlb_folio(h, folio, false);
@@ -3886,11 +3886,11 @@ static int demote_free_hugetlb_folio(str
 	/*
 	 * If vmemmap already existed for folio, the remove routine above would
 	 * have cleared the hugetlb folio flag.  Hence the folio is technically
-	 * no longer a hugetlb folio.  hugetlb_vmemmap_restore can only be
+	 * no longer a hugetlb folio.  hugetlb_vmemmap_restore_folio can only be
 	 * passed hugetlb folios and will BUG otherwise.
 	 */
 	if (folio_test_hugetlb(folio)) {
-		rc = hugetlb_vmemmap_restore(h, &folio->page);
+		rc = hugetlb_vmemmap_restore_folio(h, folio);
 		if (rc) {
 			/* Allocation of vmemmmap failed, we can not demote folio */
 			spin_lock_irq(&hugetlb_lock);
--- a/mm/hugetlb_vmemmap.c~hugetlb_vmemmap-use-folio-argument-for-hugetlb_vmemmap_-functions
+++ a/mm/hugetlb_vmemmap.c
@@ -495,14 +495,15 @@ EXPORT_SYMBOL(hugetlb_optimize_vmemmap_k
 static bool vmemmap_optimize_enabled = IS_ENABLED(CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP_DEFAULT_ON);
 core_param(hugetlb_free_vmemmap, vmemmap_optimize_enabled, bool, 0);
 
-static int __hugetlb_vmemmap_restore(const struct hstate *h, struct page *head, unsigned long flags)
+static int __hugetlb_vmemmap_restore_folio(const struct hstate *h, struct folio *folio, unsigned long flags)
 {
 	int ret;
+	struct page *head = &folio->page;
 	unsigned long vmemmap_start = (unsigned long)head, vmemmap_end;
 	unsigned long vmemmap_reuse;
 
 	VM_WARN_ON_ONCE(!PageHuge(head));
-	if (!HPageVmemmapOptimized(head))
+	if (!folio_test_hugetlb_vmemmap_optimized(folio))
 		return 0;
 
 	vmemmap_end	= vmemmap_start + hugetlb_vmemmap_size(h);
@@ -518,7 +519,7 @@ static int __hugetlb_vmemmap_restore(con
 	 */
 	ret = vmemmap_remap_alloc(vmemmap_start, vmemmap_end, vmemmap_reuse, flags);
 	if (!ret) {
-		ClearHPageVmemmapOptimized(head);
+		folio_clear_hugetlb_vmemmap_optimized(folio);
 		static_branch_dec(&hugetlb_optimize_vmemmap_key);
 	}
 
@@ -526,18 +527,18 @@ static int __hugetlb_vmemmap_restore(con
 }
 
 /**
- * hugetlb_vmemmap_restore - restore previously optimized (by
- *				hugetlb_vmemmap_optimize()) vmemmap pages which
+ * hugetlb_vmemmap_restore_folio - restore previously optimized (by
+ *				hugetlb_vmemmap_optimize_folio()) vmemmap pages which
  *				will be reallocated and remapped.
  * @h:		struct hstate.
- * @head:	the head page whose vmemmap pages will be restored.
+ * @folio:     the folio whose vmemmap pages will be restored.
  *
- * Return: %0 if @head's vmemmap pages have been reallocated and remapped,
+ * Return: %0 if @folio's vmemmap pages have been reallocated and remapped,
  * negative error code otherwise.
  */
-int hugetlb_vmemmap_restore(const struct hstate *h, struct page *head)
+int hugetlb_vmemmap_restore_folio(const struct hstate *h, struct folio *folio)
 {
-	return __hugetlb_vmemmap_restore(h, head, 0);
+	return __hugetlb_vmemmap_restore_folio(h, folio, 0);
 }
 
 /**
@@ -563,7 +564,7 @@ long hugetlb_vmemmap_restore_folios(cons
 
 	list_for_each_entry_safe(folio, t_folio, folio_list, lru) {
 		if (folio_test_hugetlb_vmemmap_optimized(folio)) {
-			ret = __hugetlb_vmemmap_restore(h, &folio->page,
+			ret = __hugetlb_vmemmap_restore_folio(h, folio,
 						VMEMMAP_REMAP_NO_TLB_FLUSH);
 			if (ret)
 				break;
@@ -640,12 +641,13 @@ static bool vmemmap_should_optimize(cons
 	return true;
 }
 
-static int __hugetlb_vmemmap_optimize(const struct hstate *h,
-					struct page *head,
+static int __hugetlb_vmemmap_optimize_folio(const struct hstate *h,
+					struct folio *folio,
 					struct list_head *vmemmap_pages,
 					unsigned long flags)
 {
 	int ret = 0;
+	struct page *head = &folio->page;
 	unsigned long vmemmap_start = (unsigned long)head, vmemmap_end;
 	unsigned long vmemmap_reuse;
 
@@ -665,7 +667,7 @@ static int __hugetlb_vmemmap_optimize(co
 	 * If there is an error during optimization, we will immediately FLUSH
 	 * the TLB and clear the flag below.
 	 */
-	SetHPageVmemmapOptimized(head);
+	folio_set_hugetlb_vmemmap_optimized(folio);
 
 	vmemmap_end	= vmemmap_start + hugetlb_vmemmap_size(h);
 	vmemmap_reuse	= vmemmap_start;
@@ -681,27 +683,27 @@ static int __hugetlb_vmemmap_optimize(co
 							vmemmap_pages, flags);
 	if (ret) {
 		static_branch_dec(&hugetlb_optimize_vmemmap_key);
-		ClearHPageVmemmapOptimized(head);
+		folio_clear_hugetlb_vmemmap_optimized(folio);
 	}
 
 	return ret;
 }
 
 /**
- * hugetlb_vmemmap_optimize - optimize @head page's vmemmap pages.
+ * hugetlb_vmemmap_optimize_folio - optimize @folio's vmemmap pages.
  * @h:		struct hstate.
- * @head:	the head page whose vmemmap pages will be optimized.
+ * @folio:     the folio whose vmemmap pages will be optimized.
  *
- * This function only tries to optimize @head's vmemmap pages and does not
+ * This function only tries to optimize @folio's vmemmap pages and does not
  * guarantee that the optimization will succeed after it returns. The caller
- * can use HPageVmemmapOptimized(@head) to detect if @head's vmemmap pages
- * have been optimized.
+ * can use folio_test_hugetlb_vmemmap_optimized(@folio) to detect if @folio's
+ * vmemmap pages have been optimized.
  */
-void hugetlb_vmemmap_optimize(const struct hstate *h, struct page *head)
+void hugetlb_vmemmap_optimize_folio(const struct hstate *h, struct folio *folio)
 {
 	LIST_HEAD(vmemmap_pages);
 
-	__hugetlb_vmemmap_optimize(h, head, &vmemmap_pages, 0);
+	__hugetlb_vmemmap_optimize_folio(h, folio, &vmemmap_pages, 0);
 	free_vmemmap_page_list(&vmemmap_pages);
 }
 
@@ -745,7 +747,7 @@ void hugetlb_vmemmap_optimize_folios(str
 	flush_tlb_all();
 
 	list_for_each_entry(folio, folio_list, lru) {
-		int ret = __hugetlb_vmemmap_optimize(h, &folio->page,
+		int ret = __hugetlb_vmemmap_optimize_folio(h, folio,
 						&vmemmap_pages,
 						VMEMMAP_REMAP_NO_TLB_FLUSH);
 
@@ -754,14 +756,14 @@ void hugetlb_vmemmap_optimize_folios(str
 		 * encounter an ENOMEM,  free what we have and try again.
 		 * This can occur in the case that both spliting fails
 		 * halfway and head page allocation also failed. In this
-		 * case __hugetlb_vmemmap_optimize() would free memory
+		 * case __hugetlb_vmemmap_optimize_folio() would free memory
 		 * allowing more vmemmap remaps to occur.
 		 */
 		if (ret == -ENOMEM && !list_empty(&vmemmap_pages)) {
 			flush_tlb_all();
 			free_vmemmap_page_list(&vmemmap_pages);
 			INIT_LIST_HEAD(&vmemmap_pages);
-			__hugetlb_vmemmap_optimize(h, &folio->page,
+			__hugetlb_vmemmap_optimize_folio(h, folio,
 						&vmemmap_pages,
 						VMEMMAP_REMAP_NO_TLB_FLUSH);
 		}
--- a/mm/hugetlb_vmemmap.h~hugetlb_vmemmap-use-folio-argument-for-hugetlb_vmemmap_-functions
+++ a/mm/hugetlb_vmemmap.h
@@ -18,11 +18,11 @@
 #define HUGETLB_VMEMMAP_RESERVE_PAGES	(HUGETLB_VMEMMAP_RESERVE_SIZE / sizeof(struct page))
 
 #ifdef CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP
-int hugetlb_vmemmap_restore(const struct hstate *h, struct page *head);
+int hugetlb_vmemmap_restore_folio(const struct hstate *h, struct folio *folio);
 long hugetlb_vmemmap_restore_folios(const struct hstate *h,
 					struct list_head *folio_list,
 					struct list_head *non_hvo_folios);
-void hugetlb_vmemmap_optimize(const struct hstate *h, struct page *head);
+void hugetlb_vmemmap_optimize_folio(const struct hstate *h, struct folio *folio);
 void hugetlb_vmemmap_optimize_folios(struct hstate *h, struct list_head *folio_list);
 
 static inline unsigned int hugetlb_vmemmap_size(const struct hstate *h)
@@ -43,7 +43,7 @@ static inline unsigned int hugetlb_vmemm
 	return size > 0 ? size : 0;
 }
 #else
-static inline int hugetlb_vmemmap_restore(const struct hstate *h, struct page *head)
+static inline int hugetlb_vmemmap_restore_folio(const struct hstate *h, struct folio *folio)
 {
 	return 0;
 }
@@ -56,7 +56,7 @@ static long hugetlb_vmemmap_restore_foli
 	return 0;
 }
 
-static inline void hugetlb_vmemmap_optimize(const struct hstate *h, struct page *head)
+static inline void hugetlb_vmemmap_optimize_folio(const struct hstate *h, struct folio *folio)
 {
 }
 
_

Patches currently in -mm which might be from usama.arif@bytedance.com are


