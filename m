Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08A95C433EF
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:44:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E55CF61284
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:44:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234339AbhKKCrm (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 10 Nov 2021 21:47:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:52712 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234338AbhKKCrm (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 10 Nov 2021 21:47:42 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 88F2E61208;
        Thu, 11 Nov 2021 02:44:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636598693;
        bh=Y2YMGo4dlMMpJyDS5rS2zlM2hnlCapB1RyEMydaHKdU=;
        h=Date:From:To:Subject:From;
        b=Ljeg/DoeEkMM2jT2XK2f20YkL0ajZ5Hjuefut29eKaN+iVdnK+Opy/uzTfHDlf4qN
         mdttzRmPp6/Sjs26GRfHosbtgSXMGLU7oOvt6JAN7jtAQ5TSKzYfw1U7EcPtU+q8KI
         d5ODc1463mLuoqkjEuqh7MfqTKzKgwckbf9oxqkw=
Date:   Wed, 10 Nov 2021 18:44:53 -0800
From:   akpm@linux-foundation.org
To:     aneesh.kumar@linux.ibm.com, david@redhat.com, mhocko@suse.com,
        mike.kravetz@oracle.com, mm-commits@vger.kernel.org,
        naoya.horiguchi@linux.dev, nghialm78@gmail.com, osalvador@suse.de,
        rientjes@google.com, songmuchun@bytedance.com, ziy@nvidia.com
Subject:  [merged]
 hugetlb-be-sure-to-free-demoted-cma-pages-to-cma.patch removed from -mm
 tree
Message-ID: <20211111024453.uQnzq6vLQ%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: hugetlb: be sure to free demoted CMA pages to CMA
has been removed from the -mm tree.  Its filename was
     hugetlb-be-sure-to-free-demoted-cma-pages-to-cma.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mike Kravetz <mike.kravetz@oracle.com>
Subject: hugetlb: be sure to free demoted CMA pages to CMA

When huge page demotion is fully implemented, gigantic pages can be
demoted to a smaller huge page size.  For example, on x86 a 1G page can be
demoted to 512 2M pages.  However, gigantic pages can potentially be
allocated from CMA.  If a gigantic page which was allocated from CMA is
demoted, the corresponding demoted pages needs to be returned to CMA.

Use the new interface cma_pages_valid() to determine if a non-gigantic
hugetlb page should be freed to CMA.  Also, clear mapping field of these
pages as expected by cma_release.

This also requires a change to CMA region creation for gigantic pages. 
CMA uses a per-region bit map to track allocations.  When setting up the
region, you specify how many pages each bit represents.  Currently, only
gigantic pages are allocated/freed from CMA so the region is set up such
that one bit represents a gigantic page size allocation.

With demote, a gigantic page (allocation) could be split into smaller size
pages.  And, these smaller size pages will be freed to CMA.  So, since the
per-region bit map needs to be set up to represent the smallest
allocation/free size, it now needs to be set to the smallest huge page
size which can be freed to CMA.

Unfortunately, we set up the CMA region for huge pages before we set up
huge pages sizes (hstates).  So, technically we do not know the smallest
huge page size as this can change via command line options and
architecture specific code.  Therefore, at region setup time we use
HUGETLB_PAGE_ORDER as the smallest possible huge page size that can be
given back to CMA.  It is possible that this value is sub-optimal for some
architectures/config options.  If needed, this can be addressed in follow
on work.

Link: https://lkml.kernel.org/r/20211007181918.136982-4-mike.kravetz@oracle.com
Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>
Cc: "Aneesh Kumar K . V" <aneesh.kumar@linux.ibm.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Naoya Horiguchi <naoya.horiguchi@linux.dev>
Cc: Nghia Le <nghialm78@gmail.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   41 +++++++++++++++++++++++++++++++++++++++--
 1 file changed, 39 insertions(+), 2 deletions(-)

--- a/mm/hugetlb.c~hugetlb-be-sure-to-free-demoted-cma-pages-to-cma
+++ a/mm/hugetlb.c
@@ -50,6 +50,16 @@ struct hstate hstates[HUGE_MAX_HSTATE];
 
 #ifdef CONFIG_CMA
 static struct cma *hugetlb_cma[MAX_NUMNODES];
+static bool hugetlb_cma_page(struct page *page, unsigned int order)
+{
+	return cma_pages_valid(hugetlb_cma[page_to_nid(page)], page,
+				1 << order);
+}
+#else
+static bool hugetlb_cma_page(struct page *page, unsigned int order)
+{
+	return false;
+}
 #endif
 static unsigned long hugetlb_cma_size __initdata;
 
@@ -1272,6 +1282,7 @@ static void destroy_compound_gigantic_pa
 	atomic_set(compound_pincount_ptr(page), 0);
 
 	for (i = 1; i < nr_pages; i++, p = mem_map_next(p, page, i)) {
+		p->mapping = NULL;
 		clear_compound_head(p);
 		set_page_refcounted(p);
 	}
@@ -1476,7 +1487,13 @@ static void __update_and_free_page(struc
 				1 << PG_active | 1 << PG_private |
 				1 << PG_writeback);
 	}
-	if (hstate_is_gigantic(h)) {
+
+	/*
+	 * Non-gigantic pages demoted from CMA allocated gigantic pages
+	 * need to be given back to CMA in free_gigantic_page.
+	 */
+	if (hstate_is_gigantic(h) ||
+	    hugetlb_cma_page(page, huge_page_order(h))) {
 		destroy_compound_gigantic_page(page, huge_page_order(h));
 		free_gigantic_page(page, huge_page_order(h));
 	} else {
@@ -3001,9 +3018,13 @@ static void __init hugetlb_init_hstates(
 		 * h->demote_order is initially 0.
 		 * - We can not demote gigantic pages if runtime freeing
 		 *   is not supported, so skip this.
+		 * - If CMA allocation is possible, we can not demote
+		 *   HUGETLB_PAGE_ORDER or smaller size pages.
 		 */
 		if (hstate_is_gigantic(h) && !gigantic_page_runtime_supported())
 			continue;
+		if (hugetlb_cma_size && h->order <= HUGETLB_PAGE_ORDER)
+			continue;
 		for_each_hstate(h2) {
 			if (h2 == h)
 				continue;
@@ -3555,6 +3576,8 @@ static ssize_t demote_size_store(struct
 	if (!demote_hstate)
 		return -EINVAL;
 	demote_order = demote_hstate->order;
+	if (demote_order < HUGETLB_PAGE_ORDER)
+		return -EINVAL;
 
 	/* demote order must be smaller than hstate order */
 	h = kobj_to_hstate(kobj, &nid);
@@ -6543,6 +6566,7 @@ void __init hugetlb_cma_reserve(int orde
 	if (hugetlb_cma_size < (PAGE_SIZE << order)) {
 		pr_warn("hugetlb_cma: cma area should be at least %lu MiB\n",
 			(PAGE_SIZE << order) / SZ_1M);
+		hugetlb_cma_size = 0;
 		return;
 	}
 
@@ -6563,7 +6587,13 @@ void __init hugetlb_cma_reserve(int orde
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
@@ -6579,6 +6609,13 @@ void __init hugetlb_cma_reserve(int orde
 		if (reserved >= hugetlb_cma_size)
 			break;
 	}
+
+	if (!reserved)
+		/*
+		 * hugetlb_cma_size is used to determine if allocations from
+		 * cma are possible.  Set to zero if no cma regions are set up.
+		 */
+		hugetlb_cma_size = 0;
 }
 
 void __init hugetlb_cma_check(void)
_

Patches currently in -mm which might be from mike.kravetz@oracle.com are


