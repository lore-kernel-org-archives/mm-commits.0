Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A380C3A5A7
	for <mm-commits@archiver.kernel.org>; Wed,  7 Dec 2022 00:21:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229480AbiLGAVW (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 6 Dec 2022 19:21:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbiLGAVV (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 6 Dec 2022 19:21:21 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B0E6429A7
        for <mm-commits@vger.kernel.org>; Tue,  6 Dec 2022 16:21:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DA87E6193B
        for <mm-commits@vger.kernel.org>; Wed,  7 Dec 2022 00:21:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18D00C433C1;
        Wed,  7 Dec 2022 00:21:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1670372478;
        bh=Adt2a4Lxy6zw9N/VKILq4Yy6yjZ6YpDjjoh4ulKE/Kk=;
        h=Date:To:From:Subject:From;
        b=d6ZaR6XgmJD8Qtlg4YN2IA+N5UCbjPEUkSP0xhKI6AQTtEk5QNBXOnIDqJiHAE4Yz
         fAU/zZVnnpms3QgurXp7+94C/5M0P7cG8QZoGvYZ2T+JJ3YvNtbzBGiSq9kzUdh5et
         aGzToDQR/SM3VqllD9v76XZfFGM8inixov9i0Ops=
Date:   Tue, 06 Dec 2022 16:21:16 -0800
To:     mm-commits@vger.kernel.org, sidhartha.kumar@oracle.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb-change-hugetlb-allocation-functions-to-return-a-folio-fix.patch added to mm-unstable branch
Message-Id: <20221207002118.18D00C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hugetlb: update alloc_and_dissolve_hugetlb_folio comments
has been added to the -mm mm-unstable branch.  Its filename is
     mm-hugetlb-change-hugetlb-allocation-functions-to-return-a-folio-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb-change-hugetlb-allocation-functions-to-return-a-folio-fix.patch

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
Subject: mm/hugetlb: update alloc_and_dissolve_hugetlb_folio comments
Date: Tue, 6 Dec 2022 15:35:12 -0800

Update the comments inside alloc_and_dissolve_hugetlb_folio to reflect the
conversion to folios.

Link: https://lkml.kernel.org/r/20221206233512.146535-1-sidhartha.kumar@oracle.com
Signed-off-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


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
mm-hugetlb-change-hugetlb-allocation-functions-to-return-a-folio-fix.patch

