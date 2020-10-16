Return-Path: <SRS0=zz/k=DX=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF0D5C433DF
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 20:48:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6BFE9216C4
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 20:48:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602881312;
	bh=RyBoTVtU5zjvmxxax0rgieyr9iCecfv+lLNJTwePS2g=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=jnIGqF96efPEvjkf7rtCieNij4IZcHD+wJDjwDRjXlazocBi6olZw5sBPZ9Rc92xX
	 q3JokgDbKOjjIoJMFjZs/c+Fc/aZ8VNlRjePDY3dJ1kqgc2IqcRSS0RLstV20zzIom
	 G4b0eph96suHQX303OfrRbmYv5fGx2CxvUUNOf/M=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392701AbgJPUsc (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 16 Oct 2020 16:48:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:37924 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391060AbgJPUsb (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 16 Oct 2020 16:48:31 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CB272214DB;
        Fri, 16 Oct 2020 20:48:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602881311;
        bh=RyBoTVtU5zjvmxxax0rgieyr9iCecfv+lLNJTwePS2g=;
        h=Date:From:To:Subject:From;
        b=Y8AFrPE6xNH2pNZhyAWpSXkRtzmxd5f64gmcuI6ULXiMwTTo3SkJuN2ijKZ6DKnAh
         GrUAe11wrQw+uDOmuWSCfKbVNsqqnz8PcaHC/hBOqYWN6sVPlEhQMBAyxrINGDD9Hg
         zlrH7kqgfEe56pn/M7ZEQyaKIDMXALkKDIr5dayQ=
Date:   Fri, 16 Oct 2020 13:48:30 -0700
From:   akpm@linux-foundation.org
To:     kirill.shutemov@linux.intel.com, mm-commits@vger.kernel.org,
        sjpark@amazon.de, willy@infradead.org, ying.huang@intel.com
Subject:  [merged] mm-rmap-fix-assumptions-of-thp-size.patch
 removed from -mm tree
Message-ID: <20201016204830.Ao24XYR-A%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/rmap: fix assumptions of THP size
has been removed from the -mm tree.  Its filename was
     mm-rmap-fix-assumptions-of-thp-size.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from willy@infradead.org are

mm-update-the-documentation-for-vfree.patch

