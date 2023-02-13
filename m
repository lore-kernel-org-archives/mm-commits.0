Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B430C636CC
	for <mm-commits@archiver.kernel.org>; Mon, 13 Feb 2023 23:55:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231322AbjBMXz1 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 13 Feb 2023 18:55:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231301AbjBMXzS (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 13 Feb 2023 18:55:18 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E973116AF9
        for <mm-commits@vger.kernel.org>; Mon, 13 Feb 2023 15:55:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8372E6135E
        for <mm-commits@vger.kernel.org>; Mon, 13 Feb 2023 23:55:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA956C4339B;
        Mon, 13 Feb 2023 23:55:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1676332515;
        bh=OBp3EXRGRWmrmvgTWcTq25zKlCLFbDd7ZLET8Y75sBI=;
        h=Date:To:From:Subject:From;
        b=abD7I+Mu3ceVzPRLmYd3SiBYyyBZg69VcRMKrFZtBPTUTRF5aWzMy95FbLnQ/X8z9
         jBawsJmUgUJKkLPEnOS0+B3dFzGX2MfRLEw2SzpmzYPuLy/oT16ryehSCcEfavOOHI
         KgyI4gYKFnHd3rbw7/vtt9MlrPGAxPFN4NPhD2Mo=
Date:   Mon, 13 Feb 2023 15:55:15 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        songmuchun@bytedance.com, mike.kravetz@oracle.com,
        jhubbard@nvidia.com, sidhartha.kumar@oracle.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-hugetlb-convert-restore_reserve_on_error-to-folios.patch removed from -mm tree
Message-Id: <20230213235515.DA956C4339B@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/hugetlb: convert restore_reserve_on_error() to folios
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-convert-restore_reserve_on_error-to-folios.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


