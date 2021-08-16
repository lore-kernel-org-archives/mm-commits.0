Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E889C432BE
	for <mm-commits@archiver.kernel.org>; Mon, 16 Aug 2021 23:29:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 12F8F60F36
	for <mm-commits@archiver.kernel.org>; Mon, 16 Aug 2021 23:29:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234391AbhHPXa0 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 16 Aug 2021 19:30:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:56476 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234796AbhHPXaH (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 16 Aug 2021 19:30:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A09BC60F55;
        Mon, 16 Aug 2021 23:29:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1629156575;
        bh=LmS4luVgmnL/OZjR6RpkqG3jopALqZE5C790nIuXVTg=;
        h=Date:From:To:Subject:From;
        b=n5jPi4KUMTpP8i/COGCI8Yr4G9DjcujewgNwSmrigMMYWghb/FbD68jgnqff2xBut
         YRJFZ6efEi08o99ezox5cjmeYlU7hPbEQLshcAzpLC4nSbZdY1nnzlU8UyVKWZQ8px
         QgwiuwwoYQgtd0CkXRv1bYWpeiigulWfvZoJMbuE=
Date:   Mon, 16 Aug 2021 16:29:35 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, ziy@nvidia.com,
        songmuchun@bytedance.com, rientjes@google.com, osalvador@suse.de,
        naoya.horiguchi@linux.dev, mhocko@suse.com, david@redhat.com,
        mike.kravetz@oracle.com
Subject:  +
 hugetlb-optimized-demote-vmemmap-optimizatized-pages.patch added to -mm tree
Message-ID: <20210816232935.OuuUA%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: hugetlb: optimize demote vmemmap optimizatized pages
has been added to the -mm tree.  Its filename is
     hugetlb-optimized-demote-vmemmap-optimizatized-pages.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/hugetlb-optimized-demote-vmemmap-optimizatized-pages.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/hugetlb-optimized-demote-vmemmap-optimizatized-pages.patch

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
Subject: hugetlb: optimize demote vmemmap optimizatized pages

Put all the pieces together to optimize the process of demoting vmemmap
optimized pages.

Instead of allocating all vmemmap pages for a page to be demoted, use the
demote_huge_page_vmemmap routine which will only allocate/map pages needed
for the demoted pages.

For vmemmap optimized pages, use the destroy_compound_gigantic_page and
prep_compound_gigantic_page routines during demote.  These routines can
deal with vmemmap optimized pages, and know which page structs are
writable.

Link: https://lkml.kernel.org/r/20210816224953.157796-9-mike.kravetz@oracle.com
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

 mm/hugetlb.c |   27 ++++++++++++++++++++++++---
 1 file changed, 24 insertions(+), 3 deletions(-)

--- a/mm/hugetlb.c~hugetlb-optimized-demote-vmemmap-optimizatized-pages
+++ a/mm/hugetlb.c
@@ -3310,13 +3310,14 @@ static int demote_free_huge_page(struct
 	int i, nid = page_to_nid(page);
 	struct hstate *target_hstate;
 	bool cma_page = HPageCma(page);
+	bool vmemmap_optimized = HPageVmemmapOptimized(page);
 
 	target_hstate = size_to_hstate(PAGE_SIZE << h->demote_order);
 
 	remove_hugetlb_page_for_demote(h, page, false);
 	spin_unlock_irq(&hugetlb_lock);
 
-	if (alloc_huge_page_vmemmap(h, page)) {
+	if (demote_huge_page_vmemmap(h, page)) {
 		/* Allocation of vmemmmap failed, we can not demote page */
 		spin_lock_irq(&hugetlb_lock);
 		set_page_refcounted(page);
@@ -3328,16 +3329,36 @@ static int demote_free_huge_page(struct
 	 * Use destroy_compound_gigantic_page_for_demote for all huge page
 	 * sizes as it will not ref count pages.
 	 */
-	destroy_compound_gigantic_page_for_demote(page, huge_page_order(h));
+	if (vmemmap_optimized)
+		/*
+		 * If page is vmemmmap optimized, then demote_huge_page_vmemmap
+		 * added vmammap for each smaller page of target order size.
+		 * We must update/destroy all each of these smaller pages.
+		 */
+		for (i = 0; i < pages_per_huge_page(h);
+					i += pages_per_huge_page(target_hstate))
+			destroy_compound_gigantic_page_for_demote(page + i,
+					huge_page_order(target_hstate));
+	else
+		destroy_compound_gigantic_page_for_demote(page,
+							huge_page_order(h));
 
 	for (i = 0; i < pages_per_huge_page(h);
 				i += pages_per_huge_page(target_hstate)) {
-		if (hstate_is_gigantic(target_hstate))
+		/*
+		 * Use gigantic page prep for vmemmap_optimized pages of
+		 * all sizes as it has special vmemmap logic.  The generic
+		 * prep routine does not and should not know about hugetlb
+		 * vmemmap optimizations.
+		 */
+		if (hstate_is_gigantic(target_hstate) || vmemmap_optimized)
 			prep_compound_gigantic_page_for_demote(page + i,
 							target_hstate->order);
 		else
 			prep_compound_page(page + i, target_hstate->order);
 		set_page_private(page + i, 0);
+		if (vmemmap_optimized)
+			SetHPageVmemmapOptimized(page + i);
 		set_page_refcounted(page + i);
 		prep_new_huge_page(target_hstate, page + i, nid);
 		if (cma_page)
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

