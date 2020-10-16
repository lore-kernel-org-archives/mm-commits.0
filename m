Return-Path: <SRS0=zz/k=DX=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6BAF3C433E7
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 20:48:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 115AB21655
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 20:48:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602881310;
	bh=OZHPI0/4AM5Ww4dU6Dv3VqmK/1RKuFSaoX2soF8rPaI=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=CLZmTsNCsZRLOVrSJJZRiWIgzLgM/KAdXS7E+pPf8sQtUvbCpa7CPjMq3udhTddDY
	 VpAsY/1k3PrcrMKQvh3pk4sc2v2pb7FTj4ynp4r+vK4UL2H1pC+MoD4cG+dZUmmkVz
	 yvK1cI0fg4Zg+mRnZsiizV3B3RiOt0GGdCQ5qUFw=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392700AbgJPUs3 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 16 Oct 2020 16:48:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:37896 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391060AbgJPUs2 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 16 Oct 2020 16:48:28 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0D174214DB;
        Fri, 16 Oct 2020 20:48:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602881308;
        bh=OZHPI0/4AM5Ww4dU6Dv3VqmK/1RKuFSaoX2soF8rPaI=;
        h=Date:From:To:Subject:From;
        b=WzcCdoorSgxdQ8gt1ppfqebsfblIbK5RFtQ0QbvLDZUT3vAQkYbntJWlHGCOnXfQe
         EJOzdCh4OWp0fkQrYg5MN1+Xy08XJjWbJQLcDGwE7piickX8JIISn8LJArRdfLBOtY
         6N89jStZNE9pHfqVApu2VA7V2J/qNUE4/L3rwGPY=
Date:   Fri, 16 Oct 2020 13:48:27 -0700
From:   akpm@linux-foundation.org
To:     kirill.shutemov@linux.intel.com, mm-commits@vger.kernel.org,
        sjpark@amazon.de, willy@infradead.org, ying.huang@intel.com
Subject:  [merged]
 mm-huge_memory-fix-can_split_huge_page-assumption-of-thp-size.patch removed
 from -mm tree
Message-ID: <20201016204827.YdM6Eg7mC%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/huge_memory: fix can_split_huge_page assumption of THP size
has been removed from the -mm tree.  Its filename was
     mm-huge_memory-fix-can_split_huge_page-assumption-of-thp-size.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm/huge_memory: fix can_split_huge_page assumption of THP size

Ask the page how many subpages it has instead of assuming it's PMD size.

Link: https://lkml.kernel.org/r/20200908195539.25896-8-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Reviewed-by: SeongJae Park <sjpark@amazon.de>
Acked-by: "Huang, Ying" <ying.huang@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/huge_memory.c~mm-huge_memory-fix-can_split_huge_page-assumption-of-thp-size
+++ a/mm/huge_memory.c
@@ -2582,9 +2582,9 @@ bool can_split_huge_page(struct page *pa
 
 	/* Additional pins from page cache */
 	if (PageAnon(page))
-		extra_pins = PageSwapCache(page) ? HPAGE_PMD_NR : 0;
+		extra_pins = PageSwapCache(page) ? thp_nr_pages(page) : 0;
 	else
-		extra_pins = HPAGE_PMD_NR;
+		extra_pins = thp_nr_pages(page);
 	if (pextra_pins)
 		*pextra_pins = extra_pins;
 	return total_mapcount(page) == page_count(page) - extra_pins - 1;
_

Patches currently in -mm which might be from willy@infradead.org are

mm-update-the-documentation-for-vfree.patch

