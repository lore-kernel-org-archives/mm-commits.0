Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67535C4320A
	for <mm-commits@archiver.kernel.org>; Mon, 16 Aug 2021 23:29:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4FA0E60F58
	for <mm-commits@archiver.kernel.org>; Mon, 16 Aug 2021 23:29:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234704AbhHPX3z (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 16 Aug 2021 19:29:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:56156 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234791AbhHPX3y (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 16 Aug 2021 19:29:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C359A60F36;
        Mon, 16 Aug 2021 23:29:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1629156562;
        bh=QtHS1FnaQd4g5QluaCQkLtLHviXnru21cRk+fuP5mX8=;
        h=Date:From:To:Subject:From;
        b=K0J0bD//9LXg+I6B21RpvtjmLchCsumoYAx1KTZpxg1LL2uIAXLTHudJ0G3nnQE96
         T6sQyogsidY9F6xCzdanlD6AuKpkDqZI/tpaJSeM4Qjnz6keJYUVFsoqvX3hqOcazf
         CmNjfbmK0WaJF1aa9W+blNPPKlWqUbi669CI7leE=
Date:   Mon, 16 Aug 2021 16:29:21 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, ziy@nvidia.com,
        songmuchun@bytedance.com, rientjes@google.com, osalvador@suse.de,
        naoya.horiguchi@linux.dev, mhocko@suse.com, david@redhat.com,
        mike.kravetz@oracle.com
Subject:  +
 hugetlb-add-hpagecma-flag-and-code-to-free-non-gigantic-pages-in-cma.patch
 added to -mm tree
Message-ID: <20210816232921.bH9kQ%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: hugetlb: add HPageCma flag and code to free non-gigantic pages in CMA
has been added to the -mm tree.  Its filename is
     hugetlb-add-hpagecma-flag-and-code-to-free-non-gigantic-pages-in-cma.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/hugetlb-add-hpagecma-flag-and-code-to-free-non-gigantic-pages-in-cma.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/hugetlb-add-hpagecma-flag-and-code-to-free-non-gigantic-pages-in-cma.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Mike Kravetz <mike.kravetz@oracle.com>
Subject: hugetlb: add HPageCma flag and code to free non-gigantic pages in CMA

When huge page demotion is fully implemented, gigantic pages can be
demoted to a smaller huge page size.  For example, on x86 a 1G page can be
demoted to 512 2M pages.  However, gigantic pages can potentially be
allocated from CMA.  If a gigantic page which was allocated from CMA is
demoted, the corresponding demoted pages needs to be returned to CMA.

In order to track hugetlb pages that need to be returned to CMA, add the
hugetlb specific flag HPageCma.  Flag is set when a huge page is allocated
from CMA and transferred to any demoted pages.  Non-gigantic huge page
freeing code checks for the flag and takes appropriate action.

This also requires a change to CMA reservations for gigantic pages. 
Currently, the 'order_per_bit' is set to the gigantic page size.  However,
if gigantic pages can be demoted this needs to be set to the order of the
smallest huge page.  At CMA reservation time we do not know the size of
the smallest huge page size, so use HUGETLB_PAGE_ORDER.  Also, prohibit
demotion to huge page sizes smaller than HUGETLB_PAGE_ORDER.

Link: https://lkml.kernel.org/r/20210816224953.157796-3-mike.kravetz@oracle.com
Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Naoya Horiguchi <naoya.horiguchi@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/hugetlb.h |    7 +++++
 mm/hugetlb.c            |   46 ++++++++++++++++++++++++++++----------
 2 files changed, 41 insertions(+), 12 deletions(-)

--- a/include/linux/hugetlb.h~hugetlb-add-hpagecma-flag-and-code-to-free-non-gigantic-pages-in-cma
+++ a/include/linux/hugetlb.h
@@ -533,6 +533,11 @@ unsigned long hugetlb_get_unmapped_area(
  * HPG_freed - Set when page is on the free lists.
  *	Synchronization: hugetlb_lock held for examination and modification.
  * HPG_vmemmap_optimized - Set when the vmemmap pages of the page are freed.
+ * HPG_cma - Set if huge page was directly allocated from CMA area via
+ *	cma_alloc.  Initially set for gigantic page cma allocations, but can
+ *	be set in non-gigantic pages if gigantic pages are demoted.
+ *	Synchronization: Only accessed or modified when there is only one
+ *	reference to the page at allocation, free or demote time.
  */
 enum hugetlb_page_flags {
 	HPG_restore_reserve = 0,
@@ -540,6 +545,7 @@ enum hugetlb_page_flags {
 	HPG_temporary,
 	HPG_freed,
 	HPG_vmemmap_optimized,
+	HPG_cma,
 	__NR_HPAGEFLAGS,
 };
 
@@ -586,6 +592,7 @@ HPAGEFLAG(Migratable, migratable)
 HPAGEFLAG(Temporary, temporary)
 HPAGEFLAG(Freed, freed)
 HPAGEFLAG(VmemmapOptimized, vmemmap_optimized)
+HPAGEFLAG(Cma, cma)
 
 #ifdef CONFIG_HUGETLB_PAGE
 
--- a/mm/hugetlb.c~hugetlb-add-hpagecma-flag-and-code-to-free-non-gigantic-pages-in-cma
+++ a/mm/hugetlb.c
@@ -1262,6 +1262,7 @@ static void destroy_compound_gigantic_pa
 	atomic_set(compound_pincount_ptr(page), 0);
 
 	for (i = 1; i < nr_pages; i++, p = mem_map_next(p, page, i)) {
+		p->mapping = NULL;
 		clear_compound_head(p);
 		set_page_refcounted(p);
 	}
@@ -1273,16 +1274,12 @@ static void destroy_compound_gigantic_pa
 
 static void free_gigantic_page(struct page *page, unsigned int order)
 {
-	/*
-	 * If the page isn't allocated using the cma allocator,
-	 * cma_release() returns false.
-	 */
 #ifdef CONFIG_CMA
-	if (cma_release(hugetlb_cma[page_to_nid(page)], page, 1 << order))
-		return;
+	if (HPageCma(page))
+		cma_release(hugetlb_cma[page_to_nid(page)], page, 1 << order);
+	else
 #endif
-
-	free_contig_range(page_to_pfn(page), 1 << order);
+		free_contig_range(page_to_pfn(page), 1 << order);
 }
 
 #ifdef CONFIG_CONTIG_ALLOC
@@ -1301,8 +1298,10 @@ static struct page *alloc_gigantic_page(
 		if (hugetlb_cma[nid]) {
 			page = cma_alloc(hugetlb_cma[nid], nr_pages,
 					huge_page_order(h), true);
-			if (page)
+			if (page) {
+				SetHPageCma(page);
 				return page;
+			}
 		}
 
 		if (!(gfp_mask & __GFP_THISNODE)) {
@@ -1312,8 +1311,10 @@ static struct page *alloc_gigantic_page(
 
 				page = cma_alloc(hugetlb_cma[node], nr_pages,
 						huge_page_order(h), true);
-				if (page)
+				if (page) {
+					SetHPageCma(page);
 					return page;
+				}
 			}
 		}
 	}
@@ -1470,6 +1471,20 @@ static void __update_and_free_page(struc
 		destroy_compound_gigantic_page(page, huge_page_order(h));
 		free_gigantic_page(page, huge_page_order(h));
 	} else {
+#ifdef CONFIG_CMA
+		/*
+		 * Could be a page that was demoted from a gigantic page
+		 * which was allocated in a CMA area.
+		 */
+		if (HPageCma(page)) {
+			destroy_compound_gigantic_page(page,
+					huge_page_order(h));
+			if (!cma_release(hugetlb_cma[page_to_nid(page)], page,
+					1 << huge_page_order(h)))
+				VM_BUG_ON_PAGE(1, page);
+			return;
+		}
+#endif
 		__free_pages(page, huge_page_order(h));
 	}
 }
@@ -2983,7 +2998,8 @@ static void __init hugetlb_init_hstates(
 		for_each_hstate(h2) {
 			if (h2 == h)
 				continue;
-			if (h2->order < h->order && h2->order > h->demote_order)
+			if (h2->order >= HUGETLB_PAGE_ORDER &&
+			    h2->order < h->order && h2->order > h->demote_order)
 				h->demote_order = h2->order;
 		}
 	}
@@ -6498,7 +6514,13 @@ void __init hugetlb_cma_reserve(int orde
 		size = round_up(size, PAGE_SIZE << order);
 
 		snprintf(name, sizeof(name), "hugetlb%d", nid);
-		res = cma_declare_contiguous_nid(0, size, 0, PAGE_SIZE << order,
+		/*
+		 * Note that 'order per bit' is based on smallest size that
+		 * may be returned to CMA allocator in the case of
+		 * huge page demotion.
+		 */
+		res = cma_declare_contiguous_nid(0, size, 0,
+						PAGE_SIZE << HUGETLB_PAGE_ORDER,
 						 0, false, name,
 						 &hugetlb_cma[nid], nid);
 		if (res) {
_

Patches currently in -mm which might be from mike.kravetz@oracle.com are

hugetlb-simplify-prep_compound_gigantic_page-ref-count-racing-code.patch
hugetlb-drop-ref-count-earlier-after-page-allocation.patch
hugetlb-before-freeing-hugetlb-page-set-dtor-to-appropriate-value.patch
hugetlb-add-demote-hugetlb-page-sysfs-interfaces.patch
hugetlb-add-hpagecma-flag-and-code-to-free-non-gigantic-pages-in-cma.patch
hugetlb-add-demote-bool-to-gigantic-page-routines.patch
hugetlb-add-hugetlb-demote-page-support.patch
hugetlb-document-the-demote-sysfs-interfaces.patch
hugetlb-vmemmap-optimizations-when-demoting-hugetlb-pages.patch
hugetlb-prepare-destroy-and-prep-routines-for-vmemmap-optimized-pages.patch
hugetlb-optimized-demote-vmemmap-optimizatized-pages.patch

