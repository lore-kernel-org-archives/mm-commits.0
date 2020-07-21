Return-Path: <SRS0=3Kjr=BA=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2410C433E5
	for <mm-commits@archiver.kernel.org>; Tue, 21 Jul 2020 21:21:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BCCD12073A
	for <mm-commits@archiver.kernel.org>; Tue, 21 Jul 2020 21:21:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1595366476;
	bh=UBq93mqDKgL1Gcjv2HZgi3PZjjx/VSFHr0BbTuZjhCI=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=d7kXiBEzS0WrtO2sGtDivyAE6o0goUCFf43HE3mFqSPrgjjo38fTksx8/UDp+FBFY
	 r0a5d7C8ntRHAt+7chdWsrqPDpMyRpwiZnElfI5RtLxI8Tp/Bs4mu1WRBcevbz60mY
	 u8JtVfVBs1u/o93iYJRKjSCB9P7E9zR4TaLWRW2k=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730304AbgGUVVQ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 21 Jul 2020 17:21:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:39542 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731231AbgGUVVP (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 21 Jul 2020 17:21:15 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 806F320717;
        Tue, 21 Jul 2020 21:21:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595366475;
        bh=UBq93mqDKgL1Gcjv2HZgi3PZjjx/VSFHr0BbTuZjhCI=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=j3yonOFc2tpNJ4PUbD2jNBO0BoZ7lrmVNKvHmPCMpjbRywArAscrLouYHabixpL+4
         TgT2dBmXBsmBWDtcDgthJ8xpHEmZdf4E0+jzOd6rAksj1lpuI6sHkfYXqBqiS0qfWN
         BiVOWXb9orott1P7X4L8pOQFTsPSroC3p8WdT3Uw=
Date:   Tue, 21 Jul 2020 14:21:15 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     mike.kravetz@oracle.com, mm-commits@vger.kernel.org,
        sfr@canb.auug.org.au
Subject:  +
 mm-hugetlb-avoid-hardcoding-while-checking-if-cma-is-enabled-fix-fix.patch
 added to -mm tree
Message-ID: <20200721212115.yv1m5BuHF%akpm@linux-foundation.org>
In-Reply-To: <20200703151445.b6a0cfee402c7c5c4651f1b1@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hugetlb: better checks before using hugetlb_cma
has been added to the -mm tree.  Its filename is
     mm-hugetlb-avoid-hardcoding-while-checking-if-cma-is-enabled-fix-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-hugetlb-avoid-hardcoding-while-checking-if-cma-is-enabled-fix-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-hugetlb-avoid-hardcoding-while-checking-if-cma-is-enabled-fix-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: mm/hugetlb: better checks before using hugetlb_cma

Link: http://lkml.kernel.org/r/20200721205716.6dbaa56b@canb.auug.org.au
Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
Acked-by: Mike Kravetz <mike.kravetz@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/mm/hugetlb.c~mm-hugetlb-avoid-hardcoding-while-checking-if-cma-is-enabled-fix-fix
+++ a/mm/hugetlb.c
@@ -1238,9 +1238,10 @@ static void free_gigantic_page(struct pa
 	 * If the page isn't allocated using the cma allocator,
 	 * cma_release() returns false.
 	 */
-	if (IS_ENABLED(CONFIG_CMA) &&
-	    cma_release(hugetlb_cma[page_to_nid(page)], page, 1 << order))
+#ifdef CONFIG_CMA
+	if (cma_release(hugetlb_cma[page_to_nid(page)], page, 1 << order))
 		return;
+#endif
 
 	free_contig_range(page_to_pfn(page), 1 << order);
 }
@@ -1251,7 +1252,8 @@ static struct page *alloc_gigantic_page(
 {
 	unsigned long nr_pages = 1UL << huge_page_order(h);
 
-	if (IS_ENABLED(CONFIG_CMA)) {
+#ifdef CONFIG_CMA
+	{
 		struct page *page;
 		int node;
 
@@ -1265,6 +1267,7 @@ static struct page *alloc_gigantic_page(
 				return page;
 		}
 	}
+#endif
 
 	return alloc_contig_pages(nr_pages, gfp_mask, nid, nodemask);
 }
_

Patches currently in -mm which might be from sfr@canb.auug.org.au are

mm-hugetlb-avoid-hardcoding-while-checking-if-cma-is-enabled-fix-fix.patch

