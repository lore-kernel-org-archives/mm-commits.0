Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD5D8C43334
	for <mm-commits@archiver.kernel.org>; Fri, 17 Jun 2022 23:33:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236484AbiFQXdZ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 17 Jun 2022 19:33:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230296AbiFQXdZ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 17 Jun 2022 19:33:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04D325B8A6
        for <mm-commits@vger.kernel.org>; Fri, 17 Jun 2022 16:33:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 940B061D55
        for <mm-commits@vger.kernel.org>; Fri, 17 Jun 2022 23:33:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2D80C3411B;
        Fri, 17 Jun 2022 23:33:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1655508803;
        bh=mAm+pAhuMvZxk3bSugtPL09Z9Gx9uYKdxfDORUe8WuQ=;
        h=Date:To:From:Subject:From;
        b=1hOdVeeV+i/VWJWAC/gHQ7j1Bk15tggLhYgTXhwAPDBblKeCYFNJGFO18y0x7vGzR
         e8vqMBYBoISJyZxCvE7A6L2Lt5e5ZXNx5J5kYnjwVcZlnKjvwwrjB/kvhLvRhqp80X
         BjSqvIXBM+q7B5+3K3zSg+uju9QySfToMcSHT5io=
Date:   Fri, 17 Jun 2022 16:33:22 -0700
To:     mm-commits@vger.kernel.org, osalvador@suse.de,
        mike.kravetz@oracle.com, songmuchun@bytedance.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb-remove-minimum_order-variable.patch added to mm-unstable branch
Message-Id: <20220617233322.E2D80C3411B@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: hugetlb: remove minimum_order variable
has been added to the -mm mm-unstable branch.  Its filename is
     mm-hugetlb-remove-minimum_order-variable.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb-remove-minimum_order-variable.patch

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
@@ -2161,11 +2155,17 @@ int dissolve_free_huge_pages(unsigned lo
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
@@ -3157,9 +3157,6 @@ static void __init hugetlb_init_hstates(
 	struct hstate *h, *h2;
 
 	for_each_hstate(h) {
-		if (minimum_order > huge_page_order(h))
-			minimum_order = huge_page_order(h);
-
 		/* oversize hugepages were init'ed in early boot */
 		if (!hstate_is_gigantic(h))
 			hugetlb_hstate_alloc_pages(h);
@@ -3184,7 +3181,6 @@ static void __init hugetlb_init_hstates(
 				h->demote_order = h2->order;
 		}
 	}
-	VM_BUG_ON(minimum_order == UINT_MAX);
 }
 
 static void __init report_hugepages(void)
_

Patches currently in -mm which might be from songmuchun@bytedance.com are

mm-memory_hotplug-enumerate-all-supported-section-flags.patch
mm-memory_hotplug-make-hugetlb_optimize_vmemmap-compatible-with-memmap_on_memory.patch
mm-hugetlb-remove-minimum_order-variable.patch

