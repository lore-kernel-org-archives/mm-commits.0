Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3405C433F5
	for <mm-commits@archiver.kernel.org>; Tue, 22 Mar 2022 19:10:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231312AbiCVTLk (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 22 Mar 2022 15:11:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231269AbiCVTLj (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 22 Mar 2022 15:11:39 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93B6664733
        for <mm-commits@vger.kernel.org>; Tue, 22 Mar 2022 12:10:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3E0EFB81D5F
        for <mm-commits@vger.kernel.org>; Tue, 22 Mar 2022 19:10:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C89B1C340EC;
        Tue, 22 Mar 2022 19:10:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1647976208;
        bh=rljAaHI1wH+1mIC8afqVH6Ylf3wLL9f0yHaifNmeaRM=;
        h=Date:To:From:Subject:From;
        b=ielVaZJ86lywCSXkiGCmOAnZb4Y4LVgsC+s3bqOY2bFEsSMrBncjmG1Htli/2ACT0
         KeX9zcFx4QqTemulCj4Dni6tTQ/9iLPXFVbpPlLMn4ExMg1U3o/OES21H3brtB7tke
         EYATQp33otg1h5clODyzCUC9mfCUktr8ifb53vmk=
Date:   Tue, 22 Mar 2022 12:10:08 -0700
To:     mm-commits@vger.kernel.org, jhubbard@nvidia.com, peterx@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-dont-skip-swap-entry-even-if-zap_details-specified-v5.patch removed from -mm tree
Message-Id: <20220322191008.C89B1C340EC@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-dont-skip-swap-entry-even-if-zap_details-specified-v5
has been removed from the -mm tree.  Its filename was
     mm-dont-skip-swap-entry-even-if-zap_details-specified-v5.patch

This patch was dropped because it was folded into mm-dont-skip-swap-entry-even-if-zap_details-specified.patch

------------------------------------------------------
From: Peter Xu <peterx@redhat.com>
Subject: mm-dont-skip-swap-entry-even-if-zap_details-specified-v5

comment tweaks

Link: https://lkml.kernel.org/r/20220217060746.71256-2-peterx@redhat.com
Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Peter Xu <peterx@redhat.com>
Reviewed-by: John Hubbard <jhubbard@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

--- a/mm/memory.c~mm-dont-skip-swap-entry-even-if-zap_details-specified-v5
+++ a/mm/memory.c
@@ -1335,7 +1335,7 @@ zap_skip_check_mapping(struct zap_detail
 	if (should_zap_cows(details))
 		return false;
 
-	/* E.g. zero page */
+	/* E.g. the caller passes NULL for the case of a zero page */
 	if (!page)
 		return false;
 
@@ -1421,11 +1421,7 @@ again:
 		}
 
 		if (!non_swap_entry(entry)) {
-			/*
-			 * If this is a genuine swap entry, then it must be an
-			 * private anon page.  If the caller wants to skip
-			 * COWed pages, ignore it.
-			 */
+			/* Genuine swap entry, hence a private anon page */
 			if (!should_zap_cows(details))
 				continue;
 			rss[MM_SWAPENTS]--;
@@ -1437,7 +1433,6 @@ again:
 				continue;
 			rss[mm_counter(page)]--;
 		} else if (is_hwpoison_entry(entry)) {
-			/* If the caller wants to skip COWed pages, ignore it */
 			if (!should_zap_cows(details))
 				continue;
 		} else {
_

Patches currently in -mm which might be from peterx@redhat.com are

mm-fix-invalid-page-pointer-returned-with-foll_pin-gups.patch
mm-dont-skip-swap-entry-even-if-zap_details-specified.patch
mm-rename-zap_skip_check_mapping-to-should_zap_page.patch
mm-change-zap_detailszap_mapping-into-even_cows.patch
mm-rework-swap-handling-of-zap_pte_range.patch

