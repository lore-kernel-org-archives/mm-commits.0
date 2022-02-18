Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0642C433F5
	for <mm-commits@archiver.kernel.org>; Fri, 18 Feb 2022 03:50:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229484AbiBRDu0 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 17 Feb 2022 22:50:26 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:52536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229471AbiBRDuZ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 17 Feb 2022 22:50:25 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2304215A02
        for <mm-commits@vger.kernel.org>; Thu, 17 Feb 2022 19:50:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A8BDB61DF8
        for <mm-commits@vger.kernel.org>; Fri, 18 Feb 2022 03:50:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EED94C340E9;
        Fri, 18 Feb 2022 03:50:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1645156209;
        bh=nF+ERqOgFLjNaaManIUaQXQnuQclRdr10Y7PK5C5B9g=;
        h=Date:To:From:Subject:From;
        b=L6JDfdy/ZmP3Rhq8t99FqwEEoV036Ox7NwsUg3w3g/3PU7vDXKunH8eIgCppODxQs
         n2uKM0KeyW8lcti3YLQOoo7uPCkGyINjPUHz6N0bKlyNU4x1wpjIXnKusb+jBEYycQ
         OT1UFW88DtV4VQ5wUQ6PUwIN/IEbt02SrDt5vgNk=
Date:   Thu, 17 Feb 2022 19:50:08 -0800
To:     mm-commits@vger.kernel.org, jhubbard@nvidia.com, peterx@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-dont-skip-swap-entry-even-if-zap_details-specified-v5.patch added to -mm tree
Message-Id: <20220218035008.EED94C340E9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-dont-skip-swap-entry-even-if-zap_details-specified-v5
has been added to the -mm tree.  Its filename is
     mm-dont-skip-swap-entry-even-if-zap_details-specified-v5.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-dont-skip-swap-entry-even-if-zap_details-specified-v5.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-dont-skip-swap-entry-even-if-zap_details-specified-v5.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
mm-dont-skip-swap-entry-even-if-zap_details-specified-v5.patch
mm-rename-zap_skip_check_mapping-to-should_zap_page.patch
mm-change-zap_detailszap_mapping-into-even_cows.patch
mm-rework-swap-handling-of-zap_pte_range.patch

