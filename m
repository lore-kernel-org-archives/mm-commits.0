Return-Path: <SRS0=zz/k=DX=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39EDFC433E7
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 02:42:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EAFF92087D
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 02:42:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602816160;
	bh=RGDVu50YtQcqr96w9tGkwP+uISiLNUqTH9xkzGTbwRI=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=r8KSYpex7xanDTkcMk7H4L+IJxW2Y9bTZmMpCs+ZqrSeu536RmEPW4HLlTt+d56PJ
	 jJ0CGk4msjdrljvrA7Kt2UgHqFi7rs0Dhn10hQAKfoMWeS1eOlme5IBkoIet+sacP7
	 Inzpx9zTRGMLfYx+M0WhpUlhL0/DETBDHfzdwiaA=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729760AbgJPCmj (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 15 Oct 2020 22:42:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:58108 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728688AbgJPCmj (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 15 Oct 2020 22:42:39 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3C9602087D;
        Fri, 16 Oct 2020 02:42:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602816157;
        bh=RGDVu50YtQcqr96w9tGkwP+uISiLNUqTH9xkzGTbwRI=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=DY3ORyiblvq7QvwtSGd2DEiiKFWagYnKaEywJAnhaDV2f34yiviXDd64puTBF+lTs
         YV/LK6jW8IoB/SEEqMpGvvVhNMUenFADzLnQyWqZgHUMgCpR3qjnp8oI5cl32j3L8O
         SObXnBcLS3XhLdtSCzNttqZdlg3GxLIl+EF5OBuI=
Date:   Thu, 15 Oct 2020 19:42:36 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, kirill.shutemov@linux.intel.com,
        linux-mm@kvack.org, mm-commits@vger.kernel.org, sjpark@amazon.de,
        torvalds@linux-foundation.org, willy@infradead.org,
        ying.huang@intel.com
Subject:  [patch 029/156] mm/vmscan: allow arbitrary sized pages to
 be paged out
Message-ID: <20201016024236.SNovRu1QH%akpm@linux-foundation.org>
In-Reply-To: <20201015192732.f448da14e9854c7cb7299956@linux-foundation.org>
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
