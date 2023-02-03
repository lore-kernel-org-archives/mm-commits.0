Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3B64C636D7
	for <mm-commits@archiver.kernel.org>; Fri,  3 Feb 2023 06:36:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232272AbjBCGgW (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Feb 2023 01:36:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232138AbjBCGfq (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 3 Feb 2023 01:35:46 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 888788B305
        for <mm-commits@vger.kernel.org>; Thu,  2 Feb 2023 22:35:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2C72FB82980
        for <mm-commits@vger.kernel.org>; Fri,  3 Feb 2023 06:35:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE564C433EF;
        Fri,  3 Feb 2023 06:35:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675406142;
        bh=Z8dvf/tXMzVspPQHfaOgBk9sv6U4SKyv+I9Gm/swj2E=;
        h=Date:To:From:Subject:From;
        b=1EnbAT26lTsJs3I0baurQIuTuXaCpV2fA272Dckh8eTleeCxlBU1tVeFdOwuN7aqe
         V0UKZJYX66Jft8wE2KEmQhLeU/bT2MchJu0UgCsWq7Cx2sun8alTd6gBm3nIQTX0z4
         QfXl+LKevwx6BYJd6X0cAXSiJRryd4HA+w4sYeJA=
Date:   Thu, 02 Feb 2023 22:35:42 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-use-a-folio-in-hugepage_add_anon_rmap-and-hugepage_add_new_anon_rmap.patch removed from -mm tree
Message-Id: <20230203063542.CE564C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: use a folio in hugepage_add_anon_rmap() and hugepage_add_new_anon_rmap()
has been removed from the -mm tree.  Its filename was
     mm-use-a-folio-in-hugepage_add_anon_rmap-and-hugepage_add_new_anon_rmap.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: use a folio in hugepage_add_anon_rmap() and hugepage_add_new_anon_rmap()
Date: Wed, 11 Jan 2023 14:28:56 +0000

Remove uses of compound_mapcount_ptr()

Link: https://lkml.kernel.org/r/20230111142915.1001531-11-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/rmap.c~mm-use-a-folio-in-hugepage_add_anon_rmap-and-hugepage_add_new_anon_rmap
+++ a/mm/rmap.c
@@ -2528,13 +2528,14 @@ void rmap_walk_locked(struct folio *foli
 void hugepage_add_anon_rmap(struct page *page, struct vm_area_struct *vma,
 			    unsigned long address, rmap_t flags)
 {
+	struct folio *folio = page_folio(page);
 	struct anon_vma *anon_vma = vma->anon_vma;
 	int first;
 
-	BUG_ON(!PageLocked(page));
+	BUG_ON(!folio_test_locked(folio));
 	BUG_ON(!anon_vma);
 	/* address might be in next vma when migration races vma_adjust */
-	first = atomic_inc_and_test(compound_mapcount_ptr(page));
+	first = atomic_inc_and_test(&folio->_entire_mapcount);
 	VM_BUG_ON_PAGE(!first && (flags & RMAP_EXCLUSIVE), page);
 	VM_BUG_ON_PAGE(!first && PageAnonExclusive(page), page);
 	if (first)
@@ -2545,10 +2546,12 @@ void hugepage_add_anon_rmap(struct page
 void hugepage_add_new_anon_rmap(struct page *page,
 			struct vm_area_struct *vma, unsigned long address)
 {
+	struct folio *folio = page_folio(page);
+
 	BUG_ON(address < vma->vm_start || address >= vma->vm_end);
 	/* increment count (starts at -1) */
-	atomic_set(compound_mapcount_ptr(page), 0);
-	ClearHPageRestoreReserve(page);
+	atomic_set(&folio->_entire_mapcount, 0);
+	folio_clear_hugetlb_restore_reserve(folio);
 	__page_set_anon_rmap(page, vma, address, 1);
 }
 #endif /* CONFIG_HUGETLB_PAGE */
_

Patches currently in -mm which might be from willy@infradead.org are


