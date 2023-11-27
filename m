Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 017BFC07D5B
	for <mm-commits@archiver.kernel.org>; Mon, 27 Nov 2023 17:21:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229554AbjK0RVh (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 27 Nov 2023 12:21:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229541AbjK0RVg (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 27 Nov 2023 12:21:36 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58626192
        for <mm-commits@vger.kernel.org>; Mon, 27 Nov 2023 09:21:42 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED078C433C9;
        Mon, 27 Nov 2023 17:21:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1701105702;
        bh=Ms965xzk+ApDvS20gq6kE20MPL7b5UMeSIvS6AdarQQ=;
        h=Date:To:From:Subject:From;
        b=Dsp0OzuTNkQHPXmJaGyYk73I7Rz16i+JlOptxb23sFukS8UqXSJmT03p5ILFPkH8l
         N7uc/MLQoyQBWf1YYYq/ez6UARXVbfs5SFm878Azf7MgsFQFXnBRr7EvSzMz0hefzC
         ra/tdeIMRoz8gppvQkgm3d1DcxoeNor/lc04JkPc=
Date:   Mon, 27 Nov 2023 09:21:41 -0800
To:     mm-commits@vger.kernel.org, songmuchun@bytedance.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb_vmemmap-convert-page-to-folio.patch added to mm-unstable branch
Message-Id: <20231127172141.ED078C433C9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: hugetlb_vmemmap: convert page to folio
has been added to the -mm mm-unstable branch.  Its filename is
     mm-hugetlb_vmemmap-convert-page-to-folio.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb_vmemmap-convert-page-to-folio.patch

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
From: Muchun Song <songmuchun@bytedance.com>
Subject: mm: hugetlb_vmemmap: convert page to folio
Date: Mon, 27 Nov 2023 16:46:45 +0800

There are still some places where it does not be converted to folio, this
patch convert all of them to folio.  And this patch also does some trival
cleanup to fix the code style problems.

Link: https://lkml.kernel.org/r/20231127084645.27017-5-songmuchun@bytedance.com
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb_vmemmap.c |   51 ++++++++++++++++++++---------------------
 1 file changed, 25 insertions(+), 26 deletions(-)

--- a/mm/hugetlb_vmemmap.c~mm-hugetlb_vmemmap-convert-page-to-folio
+++ a/mm/hugetlb_vmemmap.c
@@ -280,7 +280,7 @@ static void vmemmap_restore_pte(pte_t *p
  * Return: %0 on success, negative error code otherwise.
  */
 static int vmemmap_remap_split(unsigned long start, unsigned long end,
-				unsigned long reuse)
+			       unsigned long reuse)
 {
 	int ret;
 	struct vmemmap_remap_walk walk = {
@@ -447,14 +447,14 @@ EXPORT_SYMBOL(hugetlb_optimize_vmemmap_k
 static bool vmemmap_optimize_enabled = IS_ENABLED(CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP_DEFAULT_ON);
 core_param(hugetlb_free_vmemmap, vmemmap_optimize_enabled, bool, 0);
 
-static int __hugetlb_vmemmap_restore_folio(const struct hstate *h, struct folio *folio, unsigned long flags)
+static int __hugetlb_vmemmap_restore_folio(const struct hstate *h,
+					   struct folio *folio, unsigned long flags)
 {
 	int ret;
-	struct page *head = &folio->page;
-	unsigned long vmemmap_start = (unsigned long)head, vmemmap_end;
+	unsigned long vmemmap_start = (unsigned long)&folio->page, vmemmap_end;
 	unsigned long vmemmap_reuse;
 
-	VM_WARN_ON_ONCE(!PageHuge(head));
+	VM_WARN_ON_ONCE_FOLIO(!folio_test_hugetlb(folio), folio);
 	if (!folio_test_hugetlb_vmemmap_optimized(folio))
 		return 0;
 
@@ -517,7 +517,7 @@ long hugetlb_vmemmap_restore_folios(cons
 	list_for_each_entry_safe(folio, t_folio, folio_list, lru) {
 		if (folio_test_hugetlb_vmemmap_optimized(folio)) {
 			ret = __hugetlb_vmemmap_restore_folio(h, folio,
-						VMEMMAP_REMAP_NO_TLB_FLUSH);
+							      VMEMMAP_REMAP_NO_TLB_FLUSH);
 			if (ret)
 				break;
 			restored++;
@@ -535,9 +535,9 @@ long hugetlb_vmemmap_restore_folios(cons
 }
 
 /* Return true iff a HugeTLB whose vmemmap should and can be optimized. */
-static bool vmemmap_should_optimize(const struct hstate *h, const struct page *head)
+static bool vmemmap_should_optimize_folio(const struct hstate *h, struct folio *folio)
 {
-	if (HPageVmemmapOptimized((struct page *)head))
+	if (folio_test_hugetlb_vmemmap_optimized(folio))
 		return false;
 
 	if (!READ_ONCE(vmemmap_optimize_enabled))
@@ -550,17 +550,16 @@ static bool vmemmap_should_optimize(cons
 }
 
 static int __hugetlb_vmemmap_optimize_folio(const struct hstate *h,
-					struct folio *folio,
-					struct list_head *vmemmap_pages,
-					unsigned long flags)
+					    struct folio *folio,
+					    struct list_head *vmemmap_pages,
+					    unsigned long flags)
 {
 	int ret = 0;
-	struct page *head = &folio->page;
-	unsigned long vmemmap_start = (unsigned long)head, vmemmap_end;
+	unsigned long vmemmap_start = (unsigned long)&folio->page, vmemmap_end;
 	unsigned long vmemmap_reuse;
 
-	VM_WARN_ON_ONCE(!PageHuge(head));
-	if (!vmemmap_should_optimize(h, head))
+	VM_WARN_ON_ONCE_FOLIO(!folio_test_hugetlb(folio), folio);
+	if (!vmemmap_should_optimize_folio(h, folio))
 		return ret;
 
 	static_branch_inc(&hugetlb_optimize_vmemmap_key);
@@ -588,7 +587,7 @@ static int __hugetlb_vmemmap_optimize_fo
 	 * the caller.
 	 */
 	ret = vmemmap_remap_free(vmemmap_start, vmemmap_end, vmemmap_reuse,
-							vmemmap_pages, flags);
+				 vmemmap_pages, flags);
 	if (ret) {
 		static_branch_dec(&hugetlb_optimize_vmemmap_key);
 		folio_clear_hugetlb_vmemmap_optimized(folio);
@@ -615,12 +614,12 @@ void hugetlb_vmemmap_optimize_folio(cons
 	free_vmemmap_page_list(&vmemmap_pages);
 }
 
-static int hugetlb_vmemmap_split(const struct hstate *h, struct page *head)
+static int hugetlb_vmemmap_split_folio(const struct hstate *h, struct folio *folio)
 {
-	unsigned long vmemmap_start = (unsigned long)head, vmemmap_end;
+	unsigned long vmemmap_start = (unsigned long)&folio->page, vmemmap_end;
 	unsigned long vmemmap_reuse;
 
-	if (!vmemmap_should_optimize(h, head))
+	if (!vmemmap_should_optimize_folio(h, folio))
 		return 0;
 
 	vmemmap_end	= vmemmap_start + hugetlb_vmemmap_size(h);
@@ -640,7 +639,7 @@ void hugetlb_vmemmap_optimize_folios(str
 	LIST_HEAD(vmemmap_pages);
 
 	list_for_each_entry(folio, folio_list, lru) {
-		int ret = hugetlb_vmemmap_split(h, &folio->page);
+		int ret = hugetlb_vmemmap_split_folio(h, folio);
 
 		/*
 		 * Spliting the PMD requires allocating a page, thus lets fail
@@ -655,9 +654,10 @@ void hugetlb_vmemmap_optimize_folios(str
 	flush_tlb_all();
 
 	list_for_each_entry(folio, folio_list, lru) {
-		int ret = __hugetlb_vmemmap_optimize_folio(h, folio,
-						&vmemmap_pages,
-						VMEMMAP_REMAP_NO_TLB_FLUSH);
+		int ret;
+
+		ret = __hugetlb_vmemmap_optimize_folio(h, folio, &vmemmap_pages,
+						       VMEMMAP_REMAP_NO_TLB_FLUSH);
 
 		/*
 		 * Pages to be freed may have been accumulated.  If we
@@ -671,9 +671,8 @@ void hugetlb_vmemmap_optimize_folios(str
 			flush_tlb_all();
 			free_vmemmap_page_list(&vmemmap_pages);
 			INIT_LIST_HEAD(&vmemmap_pages);
-			__hugetlb_vmemmap_optimize_folio(h, folio,
-						&vmemmap_pages,
-						VMEMMAP_REMAP_NO_TLB_FLUSH);
+			__hugetlb_vmemmap_optimize_folio(h, folio, &vmemmap_pages,
+							 VMEMMAP_REMAP_NO_TLB_FLUSH);
 		}
 	}
 
_

Patches currently in -mm which might be from songmuchun@bytedance.com are

mm-pagewalk-assert-write-mmap-lock-only-for-walking-the-user-page-tables.patch
mm-hugetlb_vmemmap-use-walk_page_range_novma-to-simplify-the-code.patch
mm-hugetlb_vmemmap-move-pagevmemmapselfhosted-check-to-split_vmemmap_huge_pmd.patch
mm-hugetlb_vmemmap-convert-page-to-folio.patch

