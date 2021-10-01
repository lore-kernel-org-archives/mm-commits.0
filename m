Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE0AFC433EF
	for <mm-commits@archiver.kernel.org>; Fri,  1 Oct 2021 23:26:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 89C5E61AAB
	for <mm-commits@archiver.kernel.org>; Fri,  1 Oct 2021 23:26:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231395AbhJAX2P (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 1 Oct 2021 19:28:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:42460 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230479AbhJAX2K (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 1 Oct 2021 19:28:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EB53761A7B;
        Fri,  1 Oct 2021 23:26:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1633130785;
        bh=HmzWyQ2v62HqW1TqcIs/vJi1dWM6XPm9GXFIu13eZnM=;
        h=Date:From:To:Subject:From;
        b=yUAHlzUuMI5ejfmJPB5eLPzbhJd5QwFUBrjlN/qM/AIPWJTFBuCEKZdOp4KCEzQii
         /qgnTp9G9aXI3cPEdmr54KXeyXPmBkngFhx4/BrzurLfRqh+HZ9Gawv32RkXODuJBE
         upxJupq4ZjLDx4GoHqq8yiU5UYe4ldPd8d22k/cg=
Date:   Fri, 01 Oct 2021 16:26:24 -0700
From:   akpm@linux-foundation.org
To:     aneesh.kumar@linux.ibm.com, david@redhat.com, mhocko@suse.com,
        mike.kravetz@oracle.com, mm-commits@vger.kernel.org,
        naoya.horiguchi@linux.dev, osalvador@suse.de, rientjes@google.com,
        songmuchun@bytedance.com, ziy@nvidia.com
Subject:  + hugetlb-be-sure-to-free-demoted-cma-pages-to-cma.patch
 added to -mm tree
Message-ID: <20211001232624.aX9AYBAAv%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: hugetlb: be sure to free demoted CMA pages to CMA
has been added to the -mm tree.  Its filename is
     hugetlb-be-sure-to-free-demoted-cma-pages-to-cma.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/hugetlb-be-sure-to-free-demoted-cma-pages-to-cma.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/hugetlb-be-sure-to-free-demoted-cma-pages-to-cma.patch

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
Subject: hugetlb: be sure to free demoted CMA pages to CMA

When huge page demotion is fully implemented, gigantic pages can be
demoted to a smaller huge page size.  For example, on x86 a 1G page can be
demoted to 512 2M pages.  However, gigantic pages can potentially be
allocated from CMA.  If a gigantic page which was allocated from CMA is
demoted, the corresponding demoted pages needs to be returned to CMA.

Use the new interface cma_pages_valid() to determine if a non-gigantic
hugetlb page should be freed to CMA.  Also, clear mapping field of these
pages as expected by cma_release.

This also requires a change to CMA reservations for gigantic pages. 
Currently, the 'order_per_bit' is set to the gigantic page size.  However,
if gigantic pages can be demoted this needs to be set to the order of the
smallest huge page.  At CMA reservation time we do not know the size of
the smallest huge page size, so use HUGETLB_PAGE_ORDER.  Also, prohibit
demotion to huge page sizes smaller than HUGETLB_PAGE_ORDER.

Link: https://lkml.kernel.org/r/20211001175210.45968-4-mike.kravetz@oracle.com
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

 mm/hugetlb.c |   32 +++++++++++++++++++++++++++++---
 1 file changed, 29 insertions(+), 3 deletions(-)

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
@@ -3003,7 +3020,8 @@ static void __init hugetlb_init_hstates(
 		 *   is not supported.
 		 */
 		if (!hstate_is_gigantic(h) ||
-		    gigantic_page_runtime_supported()) {
+		    gigantic_page_runtime_supported() ||
+		    !hugetlb_cma_size || !(h->order <= HUGETLB_PAGE_ORDER)) {
 			for_each_hstate(h2) {
 				if (h2 == h)
 					continue;
@@ -3555,6 +3573,8 @@ static ssize_t demote_size_store(struct
 	if (!t_hstate)
 		return -EINVAL;
 	demote_order = t_hstate->order;
+	if (demote_order < HUGETLB_PAGE_ORDER)
+		return -EINVAL;
 
 	/* demote order must be smaller hstate order */
 	h = kobj_to_hstate(kobj, &nid);
@@ -6563,7 +6583,13 @@ void __init hugetlb_cma_reserve(int orde
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
mm-cma-add-cma_pages_valid-to-determine-if-pages-are-in-cma.patch
hugetlb-be-sure-to-free-demoted-cma-pages-to-cma.patch
hugetlb-add-demote-bool-to-gigantic-page-routines.patch
hugetlb-add-hugetlb-demote-page-support.patch

