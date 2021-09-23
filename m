Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49B70C433FE
	for <mm-commits@archiver.kernel.org>; Thu, 23 Sep 2021 21:25:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1BE606124D
	for <mm-commits@archiver.kernel.org>; Thu, 23 Sep 2021 21:25:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243174AbhIWV1Q (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 23 Sep 2021 17:27:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:35328 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243291AbhIWV1P (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 23 Sep 2021 17:27:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EBD0960F6D;
        Thu, 23 Sep 2021 21:25:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1632432343;
        bh=F6y14x+TnMqGM1qL+vBrfnAh36qWfUqWeT4/62lWL50=;
        h=Date:From:To:Subject:From;
        b=R/TRZz4KAFzoF8cY359FEBGVMm3TAfgxcedkG29fs7Wb6ur7cyV1p7e8HFKOf8pGF
         lRLxtzxvjG6e1wpWasUVciKPgRy7w+v/SsQ68ftdMD8oY4G2dbqGKn4u0FaQSZHAyj
         jTL+ym20pcywuH9eZv70Ts8dUaS0+CihwH0DiCzQ=
Date:   Thu, 23 Sep 2021 14:25:42 -0700
From:   akpm@linux-foundation.org
To:     aneesh.kumar@linux.ibm.com, david@redhat.com, mhocko@suse.com,
        mike.kravetz@oracle.com, mm-commits@vger.kernel.org,
        naoya.horiguchi@linux.dev, osalvador@suse.de, rientjes@google.com,
        songmuchun@bytedance.com, ziy@nvidia.com
Subject:  +
 hugetlb-add-hpagecma-flag-and-code-to-free-non-gigantic-pages-in-cma.patch
 added to -mm tree
Message-ID: <20210923212542.8s9S-dUxW%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
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

Link: https://lkml.kernel.org/r/20210923175347.10727-3-mike.kravetz@oracle.com
Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>
Cc: "Aneesh Kumar K . V" <aneesh.kumar@linux.ibm.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Naoya Horiguchi <naoya.horiguchi@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/hugetlb.h |    7 ++++
 mm/hugetlb.c            |   66 +++++++++++++++++++++++++++-----------
 2 files changed, 54 insertions(+), 19 deletions(-)

--- a/include/linux/hugetlb.h~hugetlb-add-hpagecma-flag-and-code-to-free-non-gigantic-pages-in-cma
+++ a/include/linux/hugetlb.h
@@ -523,6 +523,11 @@ unsigned long hugetlb_get_unmapped_area(
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
@@ -530,6 +535,7 @@ enum hugetlb_page_flags {
 	HPG_temporary,
 	HPG_freed,
 	HPG_vmemmap_optimized,
+	HPG_cma,
 	__NR_HPAGEFLAGS,
 };
 
@@ -576,6 +582,7 @@ HPAGEFLAG(Migratable, migratable)
 HPAGEFLAG(Temporary, temporary)
 HPAGEFLAG(Freed, freed)
 HPAGEFLAG(VmemmapOptimized, vmemmap_optimized)
+HPAGEFLAG(Cma, cma)
 
 #ifdef CONFIG_HUGETLB_PAGE
 
--- a/mm/hugetlb.c~hugetlb-add-hpagecma-flag-and-code-to-free-non-gigantic-pages-in-cma
+++ a/mm/hugetlb.c
@@ -1272,6 +1272,7 @@ static void destroy_compound_gigantic_pa
 	atomic_set(compound_pincount_ptr(page), 0);
 
 	for (i = 1; i < nr_pages; i++, p = mem_map_next(p, page, i)) {
+		p->mapping = NULL;
 		clear_compound_head(p);
 		set_page_refcounted(p);
 	}
@@ -1283,16 +1284,12 @@ static void destroy_compound_gigantic_pa
 
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
@@ -1311,8 +1308,10 @@ static struct page *alloc_gigantic_page(
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
@@ -1322,8 +1321,10 @@ static struct page *alloc_gigantic_page(
 
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
@@ -1480,6 +1481,20 @@ static void __update_and_free_page(struc
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
@@ -2997,14 +3012,19 @@ static void __init hugetlb_init_hstates(
 			hugetlb_hstate_alloc_pages(h);
 
 		/*
-		 * Set demote order for each hstate.  Note that
-		 * h->demote_order is initially 0.
-		 */
-		for_each_hstate(h2) {
-			if (h2 == h)
-				continue;
-			if (h2->order < h->order && h2->order > h->demote_order)
-				h->demote_order = h2->order;
+		 * Set demote order for each hstate.  hstates are not ordered,
+		 * so this is brute force.  Note that h->demote_order is
+		 * initially 0.  If cma is used for gigantic pages, the smallest
+		 * demote size is HUGETLB_PAGE_ORDER.
+		 */
+		if (!hugetlb_cma_size || !(h->order <= HUGETLB_PAGE_ORDER)) {
+			for_each_hstate(h2) {
+				if (h2 == h)
+					continue;
+				if (h2->order < h->order &&
+				    h2->order > h->demote_order)
+					h->demote_order = h2->order;
+			}
 		}
 	}
 	VM_BUG_ON(minimum_order == UINT_MAX);
@@ -3555,6 +3575,8 @@ static ssize_t demote_size_store(struct
 	if (!t_hstate)
 		return -EINVAL;
 	demote_order = t_hstate->order;
+	if (demote_order < HUGETLB_PAGE_ORDER)
+		return -EINVAL;
 
 	/* demote order must be smaller hstate order */
 	h = kobj_to_hstate(kobj, &nid);
@@ -6563,7 +6585,13 @@ void __init hugetlb_cma_reserve(int orde
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

hugetlb-add-demote-hugetlb-page-sysfs-interfaces.patch
hugetlb-add-hpagecma-flag-and-code-to-free-non-gigantic-pages-in-cma.patch
hugetlb-add-demote-bool-to-gigantic-page-routines.patch
hugetlb-add-hugetlb-demote-page-support.patch

