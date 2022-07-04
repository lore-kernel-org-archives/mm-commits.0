Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CBBBCC433EF
	for <mm-commits@archiver.kernel.org>; Mon,  4 Jul 2022 01:12:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232847AbiGDBMW (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 3 Jul 2022 21:12:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232842AbiGDBLL (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 3 Jul 2022 21:11:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CED3163D5
        for <mm-commits@vger.kernel.org>; Sun,  3 Jul 2022 18:10:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6091E611FA
        for <mm-commits@vger.kernel.org>; Mon,  4 Jul 2022 01:10:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B345EC341C7;
        Mon,  4 Jul 2022 01:10:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1656897046;
        bh=vEOoA41FhpP5wwqf8aWTyAgw9oDJsjy7QtoKm7uV7Ck=;
        h=Date:To:From:Subject:From;
        b=KWHUj0H1iHZVrLX8cyi5gbpozNYYfyNmpSKxF3LLIu+mGkbdOW9yJG5J/cHrC4JjY
         k44/qSsVoY2xOMtTQurdkaEe4bDjIjNHJ9qacrUkNcMckIhVE7TlUV+rcpqM/HV9zO
         ASDgmAm9s0kUu+5x4GUp4XGeP9iqWhzH3uiwtLI0=
Date:   Sun, 03 Jul 2022 18:10:46 -0700
To:     mm-commits@vger.kernel.org, osalvador@suse.de,
        mike.kravetz@oracle.com, songmuchun@bytedance.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-hugetlb-remove-minimum_order-variable.patch removed from -mm tree
Message-Id: <20220704011046.B345EC341C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: hugetlb: remove minimum_order variable
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-remove-minimum_order-variable.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Muchun Song <songmuchun@bytedance.com>
Subject: mm: hugetlb: remove minimum_order variable
Date: Thu, 16 Jun 2022 11:38:46 +0800

commit 641844f5616d ("mm/hugetlb: introduce minimum hugepage order") fixed
a static checker warning and introduced a global variable minimum_order to
fix the warning.  However, the local variable in
dissolve_free_huge_pages() can be initialized to
huge_page_order(&default_hstate) to fix the warning.

So remove minimum_order to simplify the code.

Link: https://lkml.kernel.org/r/20220616033846.96937-1-songmuchun@bytedance.com
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   18 +++++++-----------
 1 file changed, 7 insertions(+), 11 deletions(-)

--- a/mm/hugetlb.c~mm-hugetlb-remove-minimum_order-variable
+++ a/mm/hugetlb.c
@@ -66,12 +66,6 @@ static bool hugetlb_cma_page(struct page
 #endif
 static unsigned long hugetlb_cma_size __initdata;
 
-/*
- * Minimum page order among possible hugepage sizes, set to a proper value
- * at boot time.
- */
-static unsigned int minimum_order __read_mostly = UINT_MAX;
-
 __initdata LIST_HEAD(huge_boot_pages);
 
 /* for command line parsing */
@@ -2152,11 +2146,17 @@ int dissolve_free_huge_pages(unsigned lo
 	unsigned long pfn;
 	struct page *page;
 	int rc = 0;
+	unsigned int order;
+	struct hstate *h;
 
 	if (!hugepages_supported())
 		return rc;
 
-	for (pfn = start_pfn; pfn < end_pfn; pfn += 1 << minimum_order) {
+	order = huge_page_order(&default_hstate);
+	for_each_hstate(h)
+		order = min(order, huge_page_order(h));
+
+	for (pfn = start_pfn; pfn < end_pfn; pfn += 1 << order) {
 		page = pfn_to_page(pfn);
 		rc = dissolve_free_huge_page(page);
 		if (rc)
@@ -3148,9 +3148,6 @@ static void __init hugetlb_init_hstates(
 	struct hstate *h, *h2;
 
 	for_each_hstate(h) {
-		if (minimum_order > huge_page_order(h))
-			minimum_order = huge_page_order(h);
-
 		/* oversize hugepages were init'ed in early boot */
 		if (!hstate_is_gigantic(h))
 			hugetlb_hstate_alloc_pages(h);
@@ -3175,7 +3172,6 @@ static void __init hugetlb_init_hstates(
 				h->demote_order = h2->order;
 		}
 	}
-	VM_BUG_ON(minimum_order == UINT_MAX);
 }
 
 static void __init report_hugepages(void)
_

Patches currently in -mm which might be from songmuchun@bytedance.com are

mm-hugetlb_vmemmap-delete-hugetlb_optimize_vmemmap_enabled.patch
mm-hugetlb_vmemmap-optimize-vmemmap_optimize_mode-handling.patch
mm-hugetlb_vmemmap-introduce-the-name-hvo.patch
mm-hugetlb_vmemmap-move-vmemmap-code-related-to-hugetlb-to-hugetlb_vmemmapc.patch
mm-hugetlb_vmemmap-replace-early_param-with-core_param.patch
mm-hugetlb_vmemmap-improve-hugetlb_vmemmap-code-readability.patch
mm-hugetlb_vmemmap-move-code-comments-to-vmemmap_deduprst.patch
mm-hugetlb_vmemmap-use-ptrs_per_pte-instead-of-pmd_size-page_size.patch
mm-memcontrol-remove-dead-code-and-comments.patch
mm-rename-unlock_page_lruvec_irq-_irqrestore-to-lruvec_unlock_irq-_irqrestore.patch
mm-memcontrol-prepare-objcg-api-for-non-kmem-usage.patch
mm-memcontrol-make-lruvec-lock-safe-when-lru-pages-are-reparented.patch
mm-vmscan-rework-move_pages_to_lru.patch
mm-thp-make-split-queue-lock-safe-when-lru-pages-are-reparented.patch
mm-memcontrol-make-all-the-callers-of-foliopage_memcg-safe.patch
mm-memcontrol-introduce-memcg_reparent_ops.patch
mm-memcontrol-use-obj_cgroup-apis-to-charge-the-lru-pages.patch
mm-lru-add-vm_warn_on_once_folio-to-lru-maintenance-function.patch

