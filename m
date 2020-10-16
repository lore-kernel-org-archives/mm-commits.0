Return-Path: <SRS0=zz/k=DX=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55025C433DF
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 20:48:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0B965216C4
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 20:48:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602881321;
	bh=iuGFxcLESNrfxzeMW2TB1SadztmQju4Uy31KSAXKrN8=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=YRIy0HYQwFG1B8LWCLhFqDrVlQW+HulBG7zT1yDGc/wWWqsMrizKfKYxDecJ5AE5c
	 /1IBoxf8g1kfKv4eaWQiQQNekimEqecWDIfRernYY1F2KFEyr4bxa+13P+4NjCvVZ0
	 2eMee4UfsyGVu9JTXbJWJrAAigpTDGYnugMR/2JI=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392704AbgJPUsk (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 16 Oct 2020 16:48:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:38008 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391060AbgJPUsk (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 16 Oct 2020 16:48:40 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CE18F214DB;
        Fri, 16 Oct 2020 20:48:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602881320;
        bh=iuGFxcLESNrfxzeMW2TB1SadztmQju4Uy31KSAXKrN8=;
        h=Date:From:To:Subject:From;
        b=EYlx94+SImAvF5VCTAHC6+CWRMHFzbJnrfGJKdN//UxnYNXC9Q4l9C9nVmNyMCurR
         0e1gUx3vwJpNusRyiwBniC4BHuzg6ux+RqmoBZihfBxZowTjOieQQA1calax0T6mLj
         A86Tap4ulEROxcdAew/53ox9gRPflSoNY6i3buwM=
Date:   Fri, 16 Oct 2020 13:48:39 -0700
From:   akpm@linux-foundation.org
To:     kirill.shutemov@linux.intel.com, mm-commits@vger.kernel.org,
        sjpark@amazon.de, willy@infradead.org, ying.huang@intel.com
Subject:  [merged]
 mm-vmscan-allow-arbitrary-sized-pages-to-be-paged-out.patch removed from
 -mm tree
Message-ID: <20201016204839.BdK-iddVo%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/vmscan: allow arbitrary sized pages to be paged out
has been removed from the -mm tree.  Its filename was
     mm-vmscan-allow-arbitrary-sized-pages-to-be-paged-out.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from willy@infradead.org are

mm-update-the-documentation-for-vfree.patch

