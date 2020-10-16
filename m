Return-Path: <SRS0=zz/k=DX=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED3ADC433E7
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 03:05:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 998962087D
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 03:05:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602817535;
	bh=zHASiUDz758IL+Etgbjq3oRtoew3nAEe4RdntxV5XTM=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=RH4x2J6XI42VpvYvLT7dAnnuWyAlO+3N2GGwxWPkOK8YamHSbZ6igNsQqI7wNlNGr
	 rk29VYEbxx0Q5mSm1SRlsHq4cbBY5k562ztaC0rCyEkLnuWy/fLlpl9gBxmkJKjUAZ
	 bAgZVaFmXmaZLB555VZAynoLGmx5r3xeOA10byXg=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393939AbgJPDFf (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 15 Oct 2020 23:05:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:44174 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728261AbgJPDFe (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 15 Oct 2020 23:05:34 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A7F2320789;
        Fri, 16 Oct 2020 03:05:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602817534;
        bh=zHASiUDz758IL+Etgbjq3oRtoew3nAEe4RdntxV5XTM=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=WG9XBMunWTb6td0ZBhfK9v0EM/iBVix+b0JWVVS7nrxAfxmB3SH6mD2lo4Mx+K2GY
         slTtM2Cw4wPXGdmNSOrEApbGLXxbEtRXdvgUAebzSsCOP4T9HduruHDekW1wdRs6gy
         2S6IhAdpDNRJihRIys956KVDDvCa0NNMfrA0mvmA=
Date:   Thu, 15 Oct 2020 20:05:33 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, kirill@shutemov.name,
        mm-commits@vger.kernel.org, sjpark@amazon.de,
        torvalds@linux-foundation.org, willy@infradead.org,
        ying.huang@intel.com
Subject:  [patch 022/156] mm/huge_memory: fix total_mapcount
 assumption of page size
Message-ID: <20201016030533.5zSL28RLv%akpm@linux-foundation.org>
In-Reply-To: <20201015194043.84cda0c1d6ca2a6847f2384a@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: "Kirill A. Shutemov" <kirill@shutemov.name>
Subject: mm/huge_memory: fix total_mapcount assumption of page size

File THPs may now be of arbitrary order.

Link: https://lkml.kernel.org/r/20200908195539.25896-5-willy@infradead.org
Signed-off-by: Kirill A. Shutemov <kirill@shutemov.name>
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: SeongJae Park <sjpark@amazon.de>
Cc: Huang Ying <ying.huang@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/mm/huge_memory.c~mm-huge_memory-fix-total_mapcount-assumption-of-page-size
+++ a/mm/huge_memory.c
@@ -2494,7 +2494,7 @@ static void __split_huge_page(struct pag
 
 int total_mapcount(struct page *page)
 {
-	int i, compound, ret;
+	int i, compound, nr, ret;
 
 	VM_BUG_ON_PAGE(PageTail(page), page);
 
@@ -2502,16 +2502,17 @@ int total_mapcount(struct page *page)
 		return atomic_read(&page->_mapcount) + 1;
 
 	compound = compound_mapcount(page);
+	nr = compound_nr(page);
 	if (PageHuge(page))
 		return compound;
 	ret = compound;
-	for (i = 0; i < HPAGE_PMD_NR; i++)
+	for (i = 0; i < nr; i++)
 		ret += atomic_read(&page[i]._mapcount) + 1;
 	/* File pages has compound_mapcount included in _mapcount */
 	if (!PageAnon(page))
-		return ret - compound * HPAGE_PMD_NR;
+		return ret - compound * nr;
 	if (PageDoubleMap(page))
-		ret -= HPAGE_PMD_NR;
+		ret -= nr;
 	return ret;
 }
 
_
