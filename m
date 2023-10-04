Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6893FE7C4F3
	for <mm-commits@archiver.kernel.org>; Wed,  4 Oct 2023 20:17:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233854AbjJDUR2 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 4 Oct 2023 16:17:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233787AbjJDURZ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 4 Oct 2023 16:17:25 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDF96BF
        for <mm-commits@vger.kernel.org>; Wed,  4 Oct 2023 13:17:21 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30392C433C7;
        Wed,  4 Oct 2023 20:17:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1696450641;
        bh=ZEvQkojHGcg0p+n8+N+xUjjnl51VMZ4+vtcJcKKDiJ8=;
        h=Date:To:From:Subject:From;
        b=sCwQxAeBNk0ieCva9JXeYUZN6qiCJrvoaHUWpLyu/VcyE+eQW8mhCvCYMu25VN4co
         zvPbh2j7ue3ReV94ZLvgj38TS7Pav/gjhAuOUWf9sHohQ1pgra8LGOTZ6HYeOayJhx
         sv+VnD8p5Ukq6vB45wZZpbXyejhH47pfIl/bVqRA=
Date:   Wed, 04 Oct 2023 13:17:19 -0700
To:     mm-commits@vger.kernel.org, usama.arif@bytedance.com,
        akpm@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-hugetlb-skip-initialization-of-gigantic-tail-struct-pages-if-freed-by-hvo-fix.patch removed from -mm tree
Message-Id: <20231004201721.30392C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm-hugetlb-skip-initialization-of-gigantic-tail-struct-pages-if-freed-by-hvo-fix
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-skip-initialization-of-gigantic-tail-struct-pages-if-freed-by-hvo-fix.patch

This patch was dropped because it was folded into mm-hugetlb-skip-initialization-of-gigantic-tail-struct-pages-if-freed-by-hvo.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-hugetlb-skip-initialization-of-gigantic-tail-struct-pages-if-freed-by-hvo-fix
Date: Fri Sep 15 03:52:55 PM PDT 2023

make it nicer for 80 cols

Cc: Usama Arif <usama.arif@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   21 +++++++++++++--------
 1 file changed, 13 insertions(+), 8 deletions(-)

--- a/mm/hugetlb.c~mm-hugetlb-skip-initialization-of-gigantic-tail-struct-pages-if-freed-by-hvo-fix
+++ a/mm/hugetlb.c
@@ -3205,7 +3205,8 @@ found:
 
 	/*
 	 * Only initialize the head struct page in memmap_init_reserved_pages,
-	 * rest of the struct pages will be initialized by the HugeTLB subsystem itself.
+	 * rest of the struct pages will be initialized by the HugeTLB
+	 * subsystem itself.
 	 * The head struct page is used to get folio information by the HugeTLB
 	 * subsystem like zone id and node id.
 	 */
@@ -3220,8 +3221,8 @@ found:
 
 /* Initialize [start_page:end_page_number] tail struct pages of a hugepage */
 static void __init hugetlb_folio_init_tail_vmemmap(struct folio *folio,
-						    unsigned long start_page_number,
-						    unsigned long end_page_number)
+					unsigned long start_page_number,
+					unsigned long end_page_number)
 {
 	enum zone_type zone = zone_idx(folio_zone(folio));
 	int nid = folio_nid(folio);
@@ -3239,8 +3240,9 @@ static void __init hugetlb_folio_init_ta
 	}
 }
 
-static void __init hugetlb_folio_init_vmemmap(struct folio *folio, struct hstate *h,
-					       unsigned long nr_pages)
+static void __init hugetlb_folio_init_vmemmap(struct folio *folio,
+					      struct hstate *h,
+					      unsigned long nr_pages)
 {
 	int ret;
 
@@ -3270,12 +3272,14 @@ static void __init gather_bootmem_preall
 		VM_BUG_ON(!hstate_is_gigantic(h));
 		WARN_ON(folio_ref_count(folio) != 1);
 
-		hugetlb_folio_init_vmemmap(folio, h, HUGETLB_VMEMMAP_RESERVE_PAGES);
+		hugetlb_folio_init_vmemmap(folio, h,
+					   HUGETLB_VMEMMAP_RESERVE_PAGES);
 		prep_new_hugetlb_folio(h, folio, folio_nid(folio));
 		/* If HVO fails, initialize all tail struct pages */
 		if (!HPageVmemmapOptimized(&folio->page))
-			hugetlb_folio_init_tail_vmemmap(folio, HUGETLB_VMEMMAP_RESERVE_PAGES,
-							pages_per_huge_page(h));
+			hugetlb_folio_init_tail_vmemmap(folio,
+						HUGETLB_VMEMMAP_RESERVE_PAGES,
+						pages_per_huge_page(h));
 		free_huge_folio(folio); /* add to the hugepage allocator */
 
 		/*
@@ -3287,6 +3291,7 @@ static void __init gather_bootmem_preall
 		cond_resched();
 	}
 }
+
 static void __init hugetlb_hstate_alloc_pages_onenode(struct hstate *h, int nid)
 {
 	unsigned long i;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-shmem-fix-race-in-shmem_undo_range-w-thp-fix.patch
mm-hugetlb-skip-initialization-of-gigantic-tail-struct-pages-if-freed-by-hvo.patch
fs-proc-task_mmu-implement-ioctl-to-get-and-optionally-clear-info-about-ptes-fix.patch
fs-proc-task_mmu-implement-ioctl-to-get-and-optionally-clear-info-about-ptes-fix-fix.patch
fs-proc-task_mmu-implement-ioctl-to-get-and-optionally-clear-info-about-ptes-fix-2.patch
mm-ksm-add-smart-page-scanning-mode-fix.patch
mm-ksm-document-smart-scan-mode-fix.patch
mm-ksm-document-smart-scan-mode-fix-2.patch
mm-kmem-scoped-objcg-protection-checkpatch-fixes.patch
mm-non-pmd-mappable-large-folios-for-folio_add_new_anon_rmap-fix.patch
mm-thp-introduce-anon_orders-and-anon_always_mask-sysfs-files-fix.patch
kthread-add-kthread_stop_put-v2-fix.patch

