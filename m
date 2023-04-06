Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94482C761A6
	for <mm-commits@archiver.kernel.org>; Thu,  6 Apr 2023 01:04:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234129AbjDFBEd (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 5 Apr 2023 21:04:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234563AbjDFBE2 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 5 Apr 2023 21:04:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9A5476B1;
        Wed,  5 Apr 2023 18:04:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 648DD64293;
        Thu,  6 Apr 2023 01:04:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BECD4C433D2;
        Thu,  6 Apr 2023 01:04:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1680743062;
        bh=XrxpDDRdSvdz7dovNp/kOXpmJI+nGFbi9XMyfaFGn9U=;
        h=Date:To:From:Subject:From;
        b=MFrc6oRWUYDNkKO7Bc8FIDWLiXaSsbWvAeyt6k9MYfZHTO3WbmFIXoFtJWL91txOe
         g85eVr7ta457XxGMZ95h7XfOHin5XJtF5EW4rJ0Hg89bLdSD7Kw0OCrXXrccCK0WjY
         pHxJZvbWbMaZ1rDXij56pw6vffL//cpC5+fT5akw=
Date:   Wed, 05 Apr 2023 18:04:22 -0700
To:     mm-commits@vger.kernel.org, usama.anjum@collabora.com,
        stable@vger.kernel.org, peterx@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-hugetlb-fix-uffd-wr-protection-for-cow-optimization-path-v3.patch removed from -mm tree
Message-Id: <20230406010422.BECD4C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm-hugetlb-fix-uffd-wr-protection-for-cow-optimization-path-v3
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-fix-uffd-wr-protection-for-cow-optimization-path-v3.patch

This patch was dropped because it was folded into mm-hugetlb-fix-uffd-wr-protection-for-cow-optimization-path.patch

------------------------------------------------------
From: Peter Xu <peterx@redhat.com>
Subject: mm-hugetlb-fix-uffd-wr-protection-for-cow-optimization-path-v3
Date: Fri, 24 Mar 2023 10:26:20 -0400

Link: https://lkml.kernel.org/r/20230324142620.2344140-1-peterx@redhat.com
Reported-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
Cc: linux-stable <stable@vger.kernel.org>
Fixes: 166f3ecc0daf ("mm/hugetlb: hook page faults for uffd write protection")
Signed-off-by: Peter Xu <peterx@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/mm/hugetlb.c~mm-hugetlb-fix-uffd-wr-protection-for-cow-optimization-path-v3
+++ a/mm/hugetlb.c
@@ -5491,11 +5491,11 @@ static vm_fault_t hugetlb_wp(struct mm_s
 	 * Never handle CoW for uffd-wp protected pages.  It should be only
 	 * handled when the uffd-wp protection is removed.
 	 *
-	 * Note that only the CoW optimization path can trigger this and
-	 * got skipped, because hugetlb_fault() will always resolve uffd-wp
-	 * bit first.
+	 * Note that only the CoW optimization path (in hugetlb_no_page())
+	 * can trigger this, because hugetlb_fault() will always resolve
+	 * uffd-wp bit first.
 	 */
-	if (huge_pte_uffd_wp(pte))
+	if (!unshare && huge_pte_uffd_wp(pte))
 		return 0;
 
 	/*
_

Patches currently in -mm which might be from peterx@redhat.com are

mm-hugetlb-fix-uffd-wr-protection-for-cow-optimization-path.patch
mm-khugepaged-check-again-on-anon-uffd-wp-during-isolation.patch
mm-uffd-uffd_feature_wp_unpopulated.patch
mm-uffd-uffd_feature_wp_unpopulated-fix.patch
selftests-mm-smoke-test-uffd_feature_wp_unpopulated.patch

