Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66E70C4332F
	for <mm-commits@archiver.kernel.org>; Mon, 12 Dec 2022 01:15:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230492AbiLLBPw (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 11 Dec 2022 20:15:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229475AbiLLBPu (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 11 Dec 2022 20:15:50 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BFC06573
        for <mm-commits@vger.kernel.org>; Sun, 11 Dec 2022 17:15:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F2ED0B80B25
        for <mm-commits@vger.kernel.org>; Mon, 12 Dec 2022 01:15:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC8F4C433EF;
        Mon, 12 Dec 2022 01:15:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1670807746;
        bh=A/Oj+NsVQyPicm1VHpN4CKldsAJP7wXhqoLUuix8NcU=;
        h=Date:To:From:Subject:From;
        b=VrzQphuijbHw59PWvO/1ACjlubMaDika7S5/EE6cgQv6bEg0ZQju/ObWadYpcViSf
         KP19bC60XhsJFoNokhHqeWF4A1Z26FwXmFJzxNX46bA6K9oSIe9SsJ8KixVovtbQsA
         vs3JkFWxz6Xrvw2yax3tNr2oI3ponRszem/X1ZeY=
Date:   Sun, 11 Dec 2022 17:15:45 -0800
To:     mm-commits@vger.kernel.org, sidhartha.kumar@oracle.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-hugetlb-change-hugetlb-allocation-functions-to-return-a-folio-fix.patch removed from -mm tree
Message-Id: <20221212011546.AC8F4C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/hugetlb: update alloc_and_dissolve_hugetlb_folio comments
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-change-hugetlb-allocation-functions-to-return-a-folio-fix.patch

This patch was dropped because it was folded into mm-hugetlb-change-hugetlb-allocation-functions-to-return-a-folio.patch

------------------------------------------------------
From: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Subject: mm/hugetlb: update alloc_and_dissolve_hugetlb_folio comments
Date: Tue, 6 Dec 2022 15:35:12 -0800

Update the comments inside alloc_and_dissolve_hugetlb_folio to reflect the
conversion to folios.

Link: https://lkml.kernel.org/r/20221206233512.146535-1-sidhartha.kumar@oracle.com
Signed-off-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

--- a/mm/hugetlb.c~mm-hugetlb-change-hugetlb-allocation-functions-to-return-a-folio-fix
+++ a/mm/hugetlb.c
@@ -2757,8 +2757,8 @@ static int alloc_and_dissolve_hugetlb_fo
 	int ret = 0;
 
 	/*
-	 * Before dissolving the page, we need to allocate a new one for the
-	 * pool to remain stable.  Here, we allocate the page and 'prep' it
+	 * Before dissolving the folio, we need to allocate a new one for the
+	 * pool to remain stable.  Here, we allocate the folio and 'prep' it
 	 * by doing everything but actually updating counters and adding to
 	 * the pool.  This simplifies and let us do most of the processing
 	 * under the lock.
@@ -2786,7 +2786,7 @@ retry:
 		goto free_new;
 	} else if (!folio_test_hugetlb_freed(old_folio)) {
 		/*
-		 * Page's refcount is 0 but it has not been enqueued in the
+		 * Folio's refcount is 0 but it has not been enqueued in the
 		 * freelist yet. Race window is small, so we can succeed here if
 		 * we retry.
 		 */
@@ -2795,7 +2795,7 @@ retry:
 		goto retry;
 	} else {
 		/*
-		 * Ok, old_page is still a genuine free hugepage. Remove it from
+		 * Ok, old_folio is still a genuine free hugepage. Remove it from
 		 * the freelist and decrease the counters. These will be
 		 * incremented again when calling __prep_account_new_huge_page()
 		 * and enqueue_hugetlb_folio() for new_folio. The counters will
@@ -2804,14 +2804,14 @@ retry:
 		remove_hugetlb_folio(h, old_folio, false);
 
 		/*
-		 * Ref count on new page is already zero as it was dropped
+		 * Ref count on new_folio is already zero as it was dropped
 		 * earlier.  It can be directly added to the pool free list.
 		 */
 		__prep_account_new_huge_page(h, nid);
 		enqueue_hugetlb_folio(h, new_folio);
 
 		/*
-		 * Pages have been replaced, we can safely free the old one.
+		 * Folio has been replaced, we can safely free the old one.
 		 */
 		spin_unlock_irq(&hugetlb_lock);
 		update_and_free_hugetlb_folio(h, old_folio, false);
@@ -2821,7 +2821,7 @@ retry:
 
 free_new:
 	spin_unlock_irq(&hugetlb_lock);
-	/* Page has a zero ref count, but needs a ref to be freed */
+	/* Folio has a zero ref count, but needs a ref to be freed */
 	folio_ref_unfreeze(new_folio, 1);
 	update_and_free_hugetlb_folio(h, new_folio, false);
 
_

Patches currently in -mm which might be from sidhartha.kumar@oracle.com are

mm-add-folio-dtor-and-order-setter-functions.patch
mm-hugetlb-convert-destroy_compound_gigantic_page-to-folios.patch
mm-hugetlb-convert-dissolve_free_huge_page-to-folios.patch
mm-hugetlb-convert-remove_hugetlb_page-to-folios.patch
mm-hugetlb-convert-update_and_free_page-to-folios.patch
mm-hugetlb-convert-add_hugetlb_page-to-folios-and-add-hugetlb_cma_folio.patch
mm-hugetlb-convert-enqueue_huge_page-to-folios.patch
mm-hugetlb-convert-free_gigantic_page-to-folios.patch
mm-hugetlb-convert-hugetlb-prep-functions-to-folios.patch
mm-hugetlb-change-hugetlb-allocation-functions-to-return-a-folio.patch

