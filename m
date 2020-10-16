Return-Path: <SRS0=zz/k=DX=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C6C8C433E7
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 02:42:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 18BE92087D
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 02:42:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602816143;
	bh=tQ1QpcOuQj6wdLnIWqM2irP2MNlx82mK1umTwxvJHS4=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=HN8VxbToXuQFpQCfJt7dvvHDHLM61hejTL8WUXZ6j3veam7XGZhD/R8imuNT/I9Zp
	 XZNqZmDk6KGnIGxCw7LUoq0u9EbDLOtm/McEWrqZwUVZWQH+zeangfK1n74IeksnmG
	 CeCehEprawAr2d4eMsNgCmCLSm1QQIVKlfVYi25k=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388107AbgJPCmW (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 15 Oct 2020 22:42:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:57820 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728688AbgJPCmW (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 15 Oct 2020 22:42:22 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8CCA32087D;
        Fri, 16 Oct 2020 02:42:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602816140;
        bh=tQ1QpcOuQj6wdLnIWqM2irP2MNlx82mK1umTwxvJHS4=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=YKSj/UoWIauiFlQyapZ10eBO/ZyEGZIhUS85P2FpnSKw+Nbs8+OQjZKeayky62bK9
         Z3ZkvFIcD/D3LDHzqjYcM6pYnBFlUjsQ0OmNBoYFNNkPWSDLZBsbooKhYHgDAa0a2+
         ZVRIlhapIa4HlDwQdwF3GZooOfvRo9KMQO7xnChY=
Date:   Thu, 15 Oct 2020 19:42:20 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, kirill.shutemov@linux.intel.com,
        linux-mm@kvack.org, mm-commits@vger.kernel.org, sjpark@amazon.de,
        torvalds@linux-foundation.org, willy@infradead.org,
        ying.huang@intel.com
Subject:  [patch 024/156] mm/huge_memory: fix
 page_trans_huge_mapcount assumption of THP size
Message-ID: <20201016024220.nteu8nmb4%akpm@linux-foundation.org>
In-Reply-To: <20201015192732.f448da14e9854c7cb7299956@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
