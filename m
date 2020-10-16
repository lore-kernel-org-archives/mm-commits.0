Return-Path: <SRS0=zz/k=DX=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86C9DC433E7
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 03:06:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 456A32087D
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 03:06:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602817560;
	bh=RGDVu50YtQcqr96w9tGkwP+uISiLNUqTH9xkzGTbwRI=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=r5fSlGgKnEX5YnLLzgF1V58u8qSG9f0Z1Mr8jMy359Nj8+s/U+BQb8LdFZs6DUGgC
	 GWXMruztH1H3k63d5h9cWPIQC2dGNPa2ImXGaBjnG2ZEVml2bUC4bxCzPYf4NIP5ZW
	 +mmhwskkV+TBe1GV9gO5qwpIriXYvOQUTpRlmz5c=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393946AbgJPDF7 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 15 Oct 2020 23:05:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:44406 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728261AbgJPDF7 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 15 Oct 2020 23:05:59 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 219F320878;
        Fri, 16 Oct 2020 03:05:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602817557;
        bh=RGDVu50YtQcqr96w9tGkwP+uISiLNUqTH9xkzGTbwRI=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=jWgmIZF734jH8pTUp9DFp33MJIkMPSGZaCX0gWw4DX/myvhbBMksU5vV/Xq+ZWaFc
         hlGezap9wAjH20ngbvHAqqHsBLTNhCPsTW7KSCqSI/lO1IcsbM6U56krbczM69zN2S
         jZUJsBOdTMAdO7TKag9x1PYurbQnWMSRSkLThAgo=
Date:   Thu, 15 Oct 2020 20:05:56 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, kirill.shutemov@linux.intel.com,
        mm-commits@vger.kernel.org, sjpark@amazon.de,
        torvalds@linux-foundation.org, willy@infradead.org,
        ying.huang@intel.com
Subject:  [patch 029/156] mm/vmscan: allow arbitrary sized pages to
 be paged out
Message-ID: <20201016030556.6JlnVsMzy%akpm@linux-foundation.org>
In-Reply-To: <20201015194043.84cda0c1d6ca2a6847f2384a@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm/vmscan: allow arbitrary sized pages to be paged out

Remove the assumption that a compound page has HPAGE_PMD_NR pins from the
page cache.

Link: https://lkml.kernel.org/r/20200908195539.25896-12-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Acked-by: "Huang, Ying" <ying.huang@intel.com>
Reviewed-by: SeongJae Park <sjpark@amazon.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/mm/vmscan.c~mm-vmscan-allow-arbitrary-sized-pages-to-be-paged-out
+++ a/mm/vmscan.c
@@ -725,8 +725,7 @@ static inline int is_page_cache_freeable
 	 * that isolated the page, the page cache and optional buffer
 	 * heads at page->private.
 	 */
-	int page_cache_pins = PageTransHuge(page) && PageSwapCache(page) ?
-		HPAGE_PMD_NR : 1;
+	int page_cache_pins = thp_nr_pages(page);
 	return page_count(page) - page_has_private(page) == 1 + page_cache_pins;
 }
 
_
