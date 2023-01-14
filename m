Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1FCC7C3DA78
	for <mm-commits@archiver.kernel.org>; Sat, 14 Jan 2023 03:53:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229678AbjANDx2 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 13 Jan 2023 22:53:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231190AbjANDxU (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 13 Jan 2023 22:53:20 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0F0B60DA
        for <mm-commits@vger.kernel.org>; Fri, 13 Jan 2023 19:53:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 536ECB822C0
        for <mm-commits@vger.kernel.org>; Sat, 14 Jan 2023 03:53:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DED06C433D2;
        Sat, 14 Jan 2023 03:53:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1673668391;
        bh=EUbqu0JN+YaWWBlfyVOdT/Gz72C1TMUJb4YATuIr81Y=;
        h=Date:To:From:Subject:From;
        b=crHS/uEpxvCjzUJ8x76WOaIlEzGzmxJLIQ19Okd6Ozb+uElBi5MWbuNjhCPvqR6rQ
         6hzlVSJB2csQl+p+3+dvgXm6hzJRzwvrj3yTzBWR69FLbc4e9yggUhYqhMlz3HQLl2
         V9qQ4u5v+tt7MgQP361Gsf7Abefe8mlmoM1IG33U=
Date:   Fri, 13 Jan 2023 19:53:10 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        songmuchun@bytedance.com, mike.kravetz@oracle.com,
        jhubbard@nvidia.com, sidhartha.kumar@oracle.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb-convert-restore_reserve_on_error-to-folios.patch added to mm-unstable branch
Message-Id: <20230114035310.DED06C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hugetlb: convert restore_reserve_on_error() to folios
has been added to the -mm mm-unstable branch.  Its filename is
     mm-hugetlb-convert-restore_reserve_on_error-to-folios.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb-convert-restore_reserve_on_error-to-folios.patch

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
From: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Subject: mm/hugetlb: convert restore_reserve_on_error() to folios
Date: Fri, 13 Jan 2023 16:30:56 -0600

Use the hugetlb folio flag macros inside restore_reserve_on_error() and
update the comments to reflect the use of folios.

Link: https://lkml.kernel.org/r/20230113223057.173292-8-sidhartha.kumar@oracle.com
Signed-off-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/hugetlb.c~mm-hugetlb-convert-restore_reserve_on_error-to-folios
+++ a/mm/hugetlb.c
@@ -2819,22 +2819,23 @@ static long vma_del_reservation(struct h
 void restore_reserve_on_error(struct hstate *h, struct vm_area_struct *vma,
 			unsigned long address, struct page *page)
 {
+	struct folio *folio = page_folio(page);
 	long rc = vma_needs_reservation(h, vma, address);
 
-	if (HPageRestoreReserve(page)) {
+	if (folio_test_hugetlb_restore_reserve(folio)) {
 		if (unlikely(rc < 0))
 			/*
 			 * Rare out of memory condition in reserve map
-			 * manipulation.  Clear HPageRestoreReserve so that
-			 * global reserve count will not be incremented
+			 * manipulation.  Clear hugetlb_restore_reserve so
+			 * that global reserve count will not be incremented
 			 * by free_huge_page.  This will make it appear
-			 * as though the reservation for this page was
+			 * as though the reservation for this folio was
 			 * consumed.  This may prevent the task from
-			 * faulting in the page at a later time.  This
+			 * faulting in the folio at a later time.  This
 			 * is better than inconsistent global huge page
 			 * accounting of reserve counts.
 			 */
-			ClearHPageRestoreReserve(page);
+			folio_clear_hugetlb_restore_reserve(folio);
 		else if (rc)
 			(void)vma_add_reservation(h, vma, address);
 		else
@@ -2845,7 +2846,7 @@ void restore_reserve_on_error(struct hst
 			 * This indicates there is an entry in the reserve map
 			 * not added by alloc_huge_page.  We know it was added
 			 * before the alloc_huge_page call, otherwise
-			 * HPageRestoreReserve would be set on the page.
+			 * hugetlb_restore_reserve would be set on the folio.
 			 * Remove the entry so that a subsequent allocation
 			 * does not consume a reservation.
 			 */
@@ -2854,12 +2855,12 @@ void restore_reserve_on_error(struct hst
 				/*
 				 * VERY rare out of memory condition.  Since
 				 * we can not delete the entry, set
-				 * HPageRestoreReserve so that the reserve
-				 * count will be incremented when the page
+				 * hugetlb_restore_reserve so that the reserve
+				 * count will be incremented when the folio
 				 * is freed.  This reserve will be consumed
 				 * on a subsequent allocation.
 				 */
-				SetHPageRestoreReserve(page);
+				folio_set_hugetlb_restore_reserve(folio);
 		} else if (rc < 0) {
 			/*
 			 * Rare out of memory condition from
@@ -2875,12 +2876,12 @@ void restore_reserve_on_error(struct hst
 				/*
 				 * For private mappings, no entry indicates
 				 * a reservation is present.  Since we can
-				 * not add an entry, set SetHPageRestoreReserve
-				 * on the page so reserve count will be
+				 * not add an entry, set hugetlb_restore_reserve
+				 * on the folio so reserve count will be
 				 * incremented when freed.  This reserve will
 				 * be consumed on a subsequent allocation.
 				 */
-				SetHPageRestoreReserve(page);
+				folio_set_hugetlb_restore_reserve(folio);
 		} else
 			/*
 			 * No reservation present, do nothing
_

Patches currently in -mm which might be from sidhartha.kumar@oracle.com are

mm-move-folio_set_compound_order-to-mm-internalh.patch
mm-introduce-folio_is_pfmemalloc.patch
mm-remove-the-hugetlb-field-from-struct-page.patch
mm-memory-failure-convert-__get_huge_page_for_hwpoison-to-folios.patch
mm-memory-failure-convert-try_memory_failure_hugetlb-to-folios.patch
mm-memory-failure-convert-hugetlb_clear_page_hwpoison-to-folios.patch
mm-memory-failure-convert-free_raw_hwp_pages-to-folios.patch
mm-memory-failure-convert-raw_hwp_list_head-to-folios.patch
mm-memory-failure-convert-__free_raw_hwp_pages-to-folios.patch
mm-memory-failure-convert-hugetlb_set_page_hwpoison-to-folios.patch
mm-memory-failure-convert-unpoison_memory-to-folios.patch
mm-hugetlb-convert-isolate_hugetlb-to-folios.patch
mm-hugetlb-convert-__update_and_free_page-to-folios.patch
mm-hugetlb-convert-dequeue_hugetlb_page-functions-to-folios.patch
mm-hugetlb-convert-alloc_surplus_huge_page-to-folios.patch
mm-hugetlb-increase-use-of-folios-in-alloc_huge_page.patch
mm-hugetlb-convert-alloc_migrate_huge_page-to-folios.patch
mm-hugetlb-convert-restore_reserve_on_error-to-folios.patch
mm-hugetlb-convert-demote_free_huge_page-to-folios.patch

