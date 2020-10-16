Return-Path: <SRS0=zz/k=DX=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37EECC433E7
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 03:05:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E03CD20878
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 03:05:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602817546;
	bh=0JJpXIiUtEhRHfUwJHo7FDlQ2wVlQHjS3icu8q+CNrA=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=16jl3nIZ2wh7LPlMWk5axSssY5RvX+FDLoZBannYd/dP5hOzcrm3QBQwBSy2LAhN7
	 md0V4A3Fi2vtud/x+f56O5Tv7v4uZRyrdXppAZW8oxBtEboe9mGQtEe4XvMLvAM7TP
	 qEuQJOqbMEwsFIspo7/mELmpqqWsriCczeLTYq14=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393942AbgJPDFp (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 15 Oct 2020 23:05:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:44274 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728261AbgJPDFo (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 15 Oct 2020 23:05:44 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CF24220789;
        Fri, 16 Oct 2020 03:05:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602817544;
        bh=0JJpXIiUtEhRHfUwJHo7FDlQ2wVlQHjS3icu8q+CNrA=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=E3IGGzHvgfeJ/WPvIhbr4YytcW/TKPnNJpmykd35FHu/wI1VNra2pzpQJunPC8Ngv
         gETHdUR7y++7BFoVz3ubCrAPLIXI7OjS7c+arBtJDzsnReHCFnaTLJmrLED3EjtN63
         +5D8ExFcBQxArDOSzCDiLwbweyWQmpRNJWqtTd2E=
Date:   Thu, 15 Oct 2020 20:05:43 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, kirill.shutemov@linux.intel.com,
        mm-commits@vger.kernel.org, sjpark@amazon.de,
        torvalds@linux-foundation.org, willy@infradead.org,
        ying.huang@intel.com
Subject:  [patch 025/156] mm/huge_memory: fix can_split_huge_page
 assumption of THP size
Message-ID: <20201016030543.XRmYCy7XB%akpm@linux-foundation.org>
In-Reply-To: <20201015194043.84cda0c1d6ca2a6847f2384a@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
