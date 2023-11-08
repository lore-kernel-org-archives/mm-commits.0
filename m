Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67677C4332F
	for <mm-commits@archiver.kernel.org>; Wed,  8 Nov 2023 21:38:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229659AbjKHViK (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 8 Nov 2023 16:38:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229460AbjKHViK (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 8 Nov 2023 16:38:10 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B9082585;
        Wed,  8 Nov 2023 13:38:08 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96991C433C7;
        Wed,  8 Nov 2023 21:38:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1699479487;
        bh=DkcbZ14ggYljHfcY8c5IurlhO1Ib6tvnd33/p5AVtgM=;
        h=Date:To:From:Subject:From;
        b=jawgpUcBuaqZcNQjHVImOzLsN5KAUNMvdosdoHwUF84tedungUzr+IGOCtQtKJAza
         xJfoC0XbhkqkXrirFtxTT6E5QoeqCr6JVcHKWBSpVvxtAxlGtSKwJehAL04K+tp1ME
         t5an0L5UIBl917n3KqukvBortVC1AvzC6PXfPLI4=
Date:   Wed, 08 Nov 2023 13:38:06 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        stable@vger.kernel.org, riel@surriel.com, hannes@cmpxchg.org,
        shr@devkernel.io, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-fix-for-negative-counter-nr_file_hugepages-v3.patch added to mm-hotfixes-unstable branch
Message-Id: <20231108213807.96991C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-fix-for-negative-counter-nr_file_hugepages-v3
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-fix-for-negative-counter-nr_file_hugepages-v3.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-fix-for-negative-counter-nr_file_hugepages-v3.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Stefan Roesch <shr@devkernel.io>
Subject: mm-fix-for-negative-counter-nr_file_hugepages-v3
Date: Wed, 8 Nov 2023 09:15:17 -0800

test for folio_test_pmd_mappable()

Link: https://lkml.kernel.org/r/20231108171517.2436103-1-shr@devkernel.io
Signed-off-by: Stefan Roesch <shr@devkernel.io>
Co-debugged-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Rik van Riel <riel@surriel.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |   16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

--- a/mm/huge_memory.c~mm-fix-for-negative-counter-nr_file_hugepages-v3
+++ a/mm/huge_memory.c
@@ -2769,13 +2769,15 @@ int split_huge_page_to_list(struct page
 			int nr = folio_nr_pages(folio);
 
 			xas_split(&xas, folio, folio_order(folio));
-			if (folio_test_swapbacked(folio)) {
-				__lruvec_stat_mod_folio(folio, NR_SHMEM_THPS,
-							-nr);
-			} else if (folio_test_pmd_mappable(folio)) {
-				__lruvec_stat_mod_folio(folio, NR_FILE_THPS,
-							-nr);
-				filemap_nr_thps_dec(mapping);
+			if (folio_test_pmd_mappable(folio)) {
+				if (folio_test_swapbacked(folio)) {
+					__lruvec_stat_mod_folio(folio,
+							NR_SHMEM_THPS, -nr);
+				} else {
+					__lruvec_stat_mod_folio(folio,
+							NR_FILE_THPS, -nr);
+					filemap_nr_thps_dec(mapping);
+				}
 			}
 		}
 
_

Patches currently in -mm which might be from shr@devkernel.io are

mm-fix-for-negative-counter-nr_file_hugepages.patch
mm-fix-for-negative-counter-nr_file_hugepages-v3.patch

