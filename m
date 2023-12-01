Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3B34C4167B
	for <mm-commits@archiver.kernel.org>; Fri,  1 Dec 2023 18:05:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229468AbjLASE5 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 1 Dec 2023 13:04:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229454AbjLASE5 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 1 Dec 2023 13:04:57 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F30F1E6
        for <mm-commits@vger.kernel.org>; Fri,  1 Dec 2023 10:05:02 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AB5DC433C7;
        Fri,  1 Dec 2023 18:05:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1701453902;
        bh=t+D1nySkrzriQF23sZvf5EX1mVqxg0QGCAR8TEBIzgk=;
        h=Date:To:From:Subject:From;
        b=2pCoavGsVIbALpjz3T766ujLb3AaT1Fsg7dAXa+HCeC4PQynSocjz5r7dJSVU5yQ0
         CoE5lgmhAKdrTfaMhcwuj07uFhn2JkQb6g1ySuxI7J7sgaoJ0GYQMAWkhn5TriMgvm
         CgE9zYV7Ob6o0rA6lvlaFxyIjeuyG5tpC8IydpqU=
Date:   Fri, 01 Dec 2023 10:05:01 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        ryan.roberts@arm.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-readahead-do-not-allow-order-1-folio.patch added to mm-unstable branch
Message-Id: <20231201180502.7AB5DC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/readahead: do not allow order-1 folio
has been added to the -mm mm-unstable branch.  Its filename is
     mm-readahead-do-not-allow-order-1-folio.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-readahead-do-not-allow-order-1-folio.patch

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
From: Ryan Roberts <ryan.roberts@arm.com>
Subject: mm/readahead: do not allow order-1 folio
Date: Fri, 1 Dec 2023 16:10:45 +0000

The THP machinery does not support order-1 folios because it requires meta
data spanning the first 3 `struct page`s.  So order-2 is the smallest
large folio that we can safely create.

There was a theoretical bug whereby if ra->size was 2 or 3 pages (due to
the device-specific bdi->ra_pages being set that way), we could end up
with order = 1.  Fix this by unconditionally checking if the preferred
order is 1 and if so, set it to 0.  Previously this was done in a few
specific places, but with this refactoring it is done just once,
unconditionally, at the end of the calculation.

This is a theoretical bug found during review of the code; I have no
evidence to suggest this manifests in the real world (I expect all
device-specific ra_pages values are much bigger than 3).

Link: https://lkml.kernel.org/r/20231201161045.3962614-1-ryan.roberts@arm.com
Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/readahead.c |   14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

--- a/mm/readahead.c~mm-readahead-do-not-allow-order-1-folio
+++ a/mm/readahead.c
@@ -511,16 +511,14 @@ void page_cache_ra_order(struct readahea
 		unsigned int order = new_order;
 
 		/* Align with smaller pages if needed */
-		if (index & ((1UL << order) - 1)) {
+		if (index & ((1UL << order) - 1))
 			order = __ffs(index);
-			if (order == 1)
-				order = 0;
-		}
 		/* Don't allocate pages past EOF */
-		while (index + (1UL << order) - 1 > limit) {
-			if (--order == 1)
-				order = 0;
-		}
+		while (index + (1UL << order) - 1 > limit)
+			order--;
+		/* THP machinery does not support order-1 */
+		if (order == 1)
+			order = 0;
 		err = ra_alloc_folio(ractl, index, mark, order, gfp);
 		if (err)
 			break;
_

Patches currently in -mm which might be from ryan.roberts@arm.com are

mm-readahead-do-not-allow-order-1-folio.patch

