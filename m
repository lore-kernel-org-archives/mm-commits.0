Return-Path: <SRS0=zz/k=DX=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76E8FC433DF
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 20:48:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 18A8F216C4
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 20:48:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602881306;
	bh=xBIOtdFQBXcB7uSCo11PV3OPscgmaiS4v1UVD78YcZw=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=LZ8MBgb4bYdDJIdUwWFkLxuKSjUz6uMwpiunP9gqTwu4iIbWtsorTANCIav0xNRt9
	 AFJ3hGfb+LngfE+xoszohw5pDw2PBeOv06xNZw3kWikLKC9ofi4DpvMvN5N3RHeijD
	 wnl0Db34OSR4YNZvXrU8qYCWd6UabctO52BGnsmY=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392698AbgJPUsZ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 16 Oct 2020 16:48:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:37866 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391060AbgJPUsZ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 16 Oct 2020 16:48:25 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C7262214DB;
        Fri, 16 Oct 2020 20:48:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602881305;
        bh=xBIOtdFQBXcB7uSCo11PV3OPscgmaiS4v1UVD78YcZw=;
        h=Date:From:To:Subject:From;
        b=JwZ20QYFBwMKPj7nNpSZjYj9CQ8Xc74lcB/TD0kSOs/FPaZXLlAP/JV8qfsBweUcJ
         wFAvZTOP0SQdRjm4Re1gzuxJBS2e2whLs4NFw/BZKW3kSr/OKaClWZaZT6T6orYtP8
         1ecxBeURqQ6P+yVyRiUsE+klXh+uyrrch9/x08wg=
Date:   Fri, 16 Oct 2020 13:48:24 -0700
From:   akpm@linux-foundation.org
To:     kirill.shutemov@linux.intel.com, mm-commits@vger.kernel.org,
        sjpark@amazon.de, willy@infradead.org, ying.huang@intel.com
Subject:  [merged]
 mm-huge_memory-fix-page_trans_huge_mapcount-assumption-of-thp-size.patch
 removed from -mm tree
Message-ID: <20201016204824.fOMmXOUYJ%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/huge_memory: fix page_trans_huge_mapcount assumption of THP size
has been removed from the -mm tree.  Its filename was
     mm-huge_memory-fix-page_trans_huge_mapcount-assumption-of-thp-size.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm/huge_memory: fix page_trans_huge_mapcount assumption of THP size

Ask the page what size it is instead of assuming it's PMD size.

Link: https://lkml.kernel.org/r/20200908195539.25896-7-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Reviewed-by: SeongJae Park <sjpark@amazon.de>
Cc: Huang Ying <ying.huang@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/huge_memory.c~mm-huge_memory-fix-page_trans_huge_mapcount-assumption-of-thp-size
+++ a/mm/huge_memory.c
@@ -2558,14 +2558,14 @@ int page_trans_huge_mapcount(struct page
 	page = compound_head(page);
 
 	_total_mapcount = ret = 0;
-	for (i = 0; i < HPAGE_PMD_NR; i++) {
+	for (i = 0; i < thp_nr_pages(page); i++) {
 		mapcount = atomic_read(&page[i]._mapcount) + 1;
 		ret = max(ret, mapcount);
 		_total_mapcount += mapcount;
 	}
 	if (PageDoubleMap(page)) {
 		ret -= 1;
-		_total_mapcount -= HPAGE_PMD_NR;
+		_total_mapcount -= thp_nr_pages(page);
 	}
 	mapcount = compound_mapcount(page);
 	ret += mapcount;
_

Patches currently in -mm which might be from willy@infradead.org are

mm-update-the-documentation-for-vfree.patch

