Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B7C6CD37AD
	for <mm-commits@archiver.kernel.org>; Fri, 15 Sep 2023 22:55:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231819AbjIOWzZ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 15 Sep 2023 18:55:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237995AbjIOWzV (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 15 Sep 2023 18:55:21 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0B9283
        for <mm-commits@vger.kernel.org>; Fri, 15 Sep 2023 15:55:15 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C3B4C433C7;
        Fri, 15 Sep 2023 22:55:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1694818515;
        bh=9V2EP/s+urKTRDkpZktEMhXgrUf5dSF3riBGcTwtRwI=;
        h=Date:To:From:Subject:From;
        b=mNRtFzpi2lYyYb9UKc5njYu0B7ZfXmbwT1oIEuJPdeAk3t33i0mmLci9dRsWK4Sev
         UoeGqB/d6ksG9+C8E4zCkvlZdWphTdlJVQfmhmoGXCgk4ZA5ob3HhLaALV8AGFbVRr
         S4p6V7chtge/KUrXq15mm5eFQRH5CH9CbfVtQGqQ=
Date:   Fri, 15 Sep 2023 15:55:14 -0700
To:     mm-commits@vger.kernel.org, usama.arif@bytedance.com,
        akpm@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb-skip-initialization-of-gigantic-tail-struct-pages-if-freed-by-hvo-fix.patch added to mm-unstable branch
Message-Id: <20230915225515.5C3B4C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-hugetlb-skip-initialization-of-gigantic-tail-struct-pages-if-freed-by-hvo-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-hugetlb-skip-initialization-of-gigantic-tail-struct-pages-if-freed-by-hvo-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb-skip-initialization-of-gigantic-tail-struct-pages-if-freed-by-hvo-fix.patch

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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-hugetlb-skip-initialization-of-gigantic-tail-struct-pages-if-freed-by-hvo-fix
Date: Fri Sep 15 03:52:55 PM PDT 2023

make it nicer for 80 cols

Cc: Usama Arif <usama.arif@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   20 ++++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

--- a/mm/hugetlb.c~mm-hugetlb-skip-initialization-of-gigantic-tail-struct-pages-if-freed-by-hvo-fix
+++ a/mm/hugetlb.c
@@ -3151,7 +3151,8 @@ found:
 
 	/*
 	 * Only initialize the head struct page in memmap_init_reserved_pages,
-	 * rest of the struct pages will be initialized by the HugeTLB subsystem itself.
+	 * rest of the struct pages will be initialized by the HugeTLB
+	 * subsystem itself.
 	 * The head struct page is used to get folio information by the HugeTLB
 	 * subsystem like zone id and node id.
 	 */
@@ -3166,8 +3167,8 @@ found:
 
 /* Initialize [start_page:end_page_number] tail struct pages of a hugepage */
 static void __init hugetlb_folio_init_tail_vmemmap(struct folio *folio,
-						    unsigned long start_page_number,
-						    unsigned long end_page_number)
+					unsigned long start_page_number,
+					unsigned long end_page_number)
 {
 	enum zone_type zone = zone_idx(folio_zone(folio));
 	int nid = folio_nid(folio);
@@ -3185,8 +3186,9 @@ static void __init hugetlb_folio_init_ta
 	}
 }
 
-static void __init hugetlb_folio_init_vmemmap(struct folio *folio, struct hstate *h,
-					       unsigned long nr_pages)
+static void __init hugetlb_folio_init_vmemmap(struct folio *folio,
+					      struct hstate *h,
+					      unsigned long nr_pages)
 {
 	int ret;
 
@@ -3216,12 +3218,14 @@ static void __init gather_bootmem_preall
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
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-shmem-fix-race-in-shmem_undo_range-w-thp-fix.patch
revert-scripts-gdb-symbols-add-specific-ko-module-load-command.patch
mm-memcg-add-thp-swap-out-info-for-anonymous-reclaim-fix.patch
mm-hugetlb-skip-initialization-of-gigantic-tail-struct-pages-if-freed-by-hvo-fix.patch
kthread-add-kthread_stop_put-v2-fix.patch

