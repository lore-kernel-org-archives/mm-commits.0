Return-Path: <SRS0=X2ny=CV=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D7D3C43461
	for <mm-commits@archiver.kernel.org>; Sat, 12 Sep 2020 19:11:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1C1E6207C3
	for <mm-commits@archiver.kernel.org>; Sat, 12 Sep 2020 19:11:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1599937899;
	bh=AUaJx+COEtz5LhML7DqMrAiV87lw9k6lwc6V1h985XY=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=D/WEwVS89N9kwSlV5zwyBfVFCX/L5MMnDjyPTAHeisyvCs/+yhlRDTun3Z9vmVr67
	 vuYkpwzLsAMEVY874DsXZ5FI2kluipSTsIcH2N9xGiC0thU787g5dkzA6X5ujvRQeX
	 SoLrp7MFyPIO9b9ur9leQUJd+NL4+2Cw7gHsbvMw=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725880AbgILTLi (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 12 Sep 2020 15:11:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:32930 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725838AbgILTLh (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 12 Sep 2020 15:11:37 -0400
Received: from X1 (unknown [209.33.215.130])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A7E26207C3;
        Sat, 12 Sep 2020 19:11:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599937896;
        bh=AUaJx+COEtz5LhML7DqMrAiV87lw9k6lwc6V1h985XY=;
        h=Date:From:To:Subject:From;
        b=iOUYX5U7gpmiTysCMAdokmZMZxK7d4PS7Hhhxd3huQmrYL7I5OJlEUj/fFoVaYN1I
         VZtMI1SRn8XQbHwAgcXxcdGFYb/hvIqxbV/2tFlqi2fuOdXvoiKSxfL9F8oXno4vbM
         BInqFbUb3nrTyLcpNx+KGQu0MZaoQ8MdDKZjKzgo=
Date:   Sat, 12 Sep 2020 12:11:36 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, ying.huang@intel.com,
        willy@infradead.org, kirill@shutemov.name
Subject:  +
 mm-huge_memory-fix-total_mapcount-assumption-of-page-size.patch added to -mm
 tree
Message-ID: <20200912191136.5s5Tv%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/huge_memory: fix total_mapcount assumption of page size
has been added to the -mm tree.  Its filename is
     mm-huge_memory-fix-total_mapcount-assumption-of-page-size.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-huge_memory-fix-total_mapcount-assumption-of-page-size.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-huge_memory-fix-total_mapcount-assumption-of-page-size.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill@shutemov.name>
Subject: mm/huge_memory: fix total_mapcount assumption of page size

File THPs may now be of arbitrary order.

Link: https://lkml.kernel.org/r/20200908195539.25896-5-willy@infradead.org
Signed-off-by: Kirill A. Shutemov <kirill@shutemov.name>
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Huang Ying <ying.huang@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/mm/huge_memory.c~mm-huge_memory-fix-total_mapcount-assumption-of-page-size
+++ a/mm/huge_memory.c
@@ -2465,7 +2465,7 @@ static void __split_huge_page(struct pag
 
 int total_mapcount(struct page *page)
 {
-	int i, compound, ret;
+	int i, compound, nr, ret;
 
 	VM_BUG_ON_PAGE(PageTail(page), page);
 
@@ -2473,16 +2473,17 @@ int total_mapcount(struct page *page)
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

Patches currently in -mm which might be from kirill@shutemov.name are

mm-huge_memory-fix-total_mapcount-assumption-of-page-size.patch
mm-huge_memory-fix-split-assumption-of-page-size.patch

