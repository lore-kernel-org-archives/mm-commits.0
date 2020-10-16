Return-Path: <SRS0=zz/k=DX=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0741DC433E7
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 03:05:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B02D62087D
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 03:05:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602817548;
	bh=eWTX/d9jy4fYhpQee8h9fSjqbMtA+9QST59o7QsRFk8=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=HRf7uZF/7THbXRifvoMX5X3sbUveh3KL7Z1U14DcZ3Bk1J/h4plu7BgoeG/C7ydFo
	 VMSav2b5M8EzqqxcYKQ14i65G8LnMR1uPExYT6O+11j4B3NCCKRQ7i9U8+WwSMlXT6
	 ybmwNvdXQhpjaPR1V0iCwFczY5jqw0eNchBbCdAI=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393943AbgJPDFs (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 15 Oct 2020 23:05:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:44304 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728261AbgJPDFs (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 15 Oct 2020 23:05:48 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3D26C20789;
        Fri, 16 Oct 2020 03:05:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602817547;
        bh=eWTX/d9jy4fYhpQee8h9fSjqbMtA+9QST59o7QsRFk8=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=MD3I1RNnDo2WGEglEUW88KHiDaj558boNXjP7ztF9ss5gLU3t/YzheMHUc5rOOAof
         scTEHQwID95VkOFSw4M+CHwTlieth+5bfL88cWjySC+XfH1EPscja+MU7saGYTrwS1
         IAzh7Z1YqJH2jDjUdKBBEM3AWOPtQEqEwVD7XoGw=
Date:   Thu, 15 Oct 2020 20:05:46 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, kirill.shutemov@linux.intel.com,
        mm-commits@vger.kernel.org, sjpark@amazon.de,
        torvalds@linux-foundation.org, willy@infradead.org,
        ying.huang@intel.com
Subject:  [patch 026/156] mm/rmap: fix assumptions of THP size
Message-ID: <20201016030546.LgyVGkwLX%akpm@linux-foundation.org>
In-Reply-To: <20201015194043.84cda0c1d6ca2a6847f2384a@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm/rmap: fix assumptions of THP size

Ask the page what size it is instead of assuming it's PMD size.  Do this
for anon pages as well as file pages for when someone decides to support
that.  Leave the assumption alone for pages which are PMD mapped; we don't
currently grow THPs beyond PMD size, so we don't need to change this code
yet.

Link: https://lkml.kernel.org/r/20200908195539.25896-9-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Reviewed-by: SeongJae Park <sjpark@amazon.de>
Cc: Huang Ying <ying.huang@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/rmap.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/mm/rmap.c~mm-rmap-fix-assumptions-of-thp-size
+++ a/mm/rmap.c
@@ -1205,7 +1205,7 @@ void page_add_file_rmap(struct page *pag
 	VM_BUG_ON_PAGE(compound && !PageTransHuge(page), page);
 	lock_page_memcg(page);
 	if (compound && PageTransHuge(page)) {
-		for (i = 0, nr = 0; i < HPAGE_PMD_NR; i++) {
+		for (i = 0, nr = 0; i < thp_nr_pages(page); i++) {
 			if (atomic_inc_and_test(&page[i]._mapcount))
 				nr++;
 		}
@@ -1246,7 +1246,7 @@ static void page_remove_file_rmap(struct
 
 	/* page still mapped by someone else? */
 	if (compound && PageTransHuge(page)) {
-		for (i = 0, nr = 0; i < HPAGE_PMD_NR; i++) {
+		for (i = 0, nr = 0; i < thp_nr_pages(page); i++) {
 			if (atomic_add_negative(-1, &page[i]._mapcount))
 				nr++;
 		}
@@ -1293,7 +1293,7 @@ static void page_remove_anon_compound_rm
 		 * Subpages can be mapped with PTEs too. Check how many of
 		 * them are still mapped.
 		 */
-		for (i = 0, nr = 0; i < HPAGE_PMD_NR; i++) {
+		for (i = 0, nr = 0; i < thp_nr_pages(page); i++) {
 			if (atomic_add_negative(-1, &page[i]._mapcount))
 				nr++;
 		}
@@ -1303,10 +1303,10 @@ static void page_remove_anon_compound_rm
 		 * page of the compound page is unmapped, but at least one
 		 * small page is still mapped.
 		 */
-		if (nr && nr < HPAGE_PMD_NR)
+		if (nr && nr < thp_nr_pages(page))
 			deferred_split_huge_page(page);
 	} else {
-		nr = HPAGE_PMD_NR;
+		nr = thp_nr_pages(page);
 	}
 
 	if (unlikely(PageMlocked(page)))
_
