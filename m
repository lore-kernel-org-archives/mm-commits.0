Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A26AEC636CC
	for <mm-commits@archiver.kernel.org>; Fri,  3 Feb 2023 06:41:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232528AbjBCGlw (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Feb 2023 01:41:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232411AbjBCGke (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 3 Feb 2023 01:40:34 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 337948F536
        for <mm-commits@vger.kernel.org>; Thu,  2 Feb 2023 22:37:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C3DB761D97
        for <mm-commits@vger.kernel.org>; Fri,  3 Feb 2023 06:37:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2ADD0C433EF;
        Fri,  3 Feb 2023 06:37:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675406255;
        bh=mPFFDHnzPKct6BFgqL3LTrfEZ+/l2hpG7bvaQAziAh8=;
        h=Date:To:From:Subject:From;
        b=d81EATyz7XG26XD3r2zCOXETbPjRfQjoTqkZ3yQmoNZXjOTQvpoXRtRpm+M6Bgu3/
         EalE9uSi5uP3mZH3SuowBUSlBp+qunnWctPjcjj2pqZ/FXlBV8nkkX9aiWlHxStfx8
         vcCSOX5FWkB64wCkS1kafoNRin8EIySxWjDg3PFA=
Date:   Thu, 02 Feb 2023 22:37:34 -0800
To:     mm-commits@vger.kernel.org, ziy@nvidia.com, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-use-a-folio-in-copy_present_pte.patch removed from -mm tree
Message-Id: <20230203063735.2ADD0C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: use a folio in copy_present_pte()
has been removed from the -mm tree.  Its filename was
     mm-use-a-folio-in-copy_present_pte.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: use a folio in copy_present_pte()
Date: Mon, 16 Jan 2023 19:18:13 +0000

We still have to keep the page around because we need to know which page
in the folio we're copying, but we can replace five implict calls to
compound_head() with one.

Link: https://lkml.kernel.org/r/20230116191813.2145215-6-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/memory.c~mm-use-a-folio-in-copy_present_pte
+++ a/mm/memory.c
@@ -906,25 +906,28 @@ copy_present_pte(struct vm_area_struct *
 	unsigned long vm_flags = src_vma->vm_flags;
 	pte_t pte = *src_pte;
 	struct page *page;
+	struct folio *folio;
 
 	page = vm_normal_page(src_vma, addr, pte);
-	if (page && PageAnon(page)) {
+	if (page)
+		folio = page_folio(page);
+	if (page && folio_test_anon(folio)) {
 		/*
 		 * If this page may have been pinned by the parent process,
 		 * copy the page immediately for the child so that we'll always
 		 * guarantee the pinned page won't be randomly replaced in the
 		 * future.
 		 */
-		get_page(page);
+		folio_get(folio);
 		if (unlikely(page_try_dup_anon_rmap(page, false, src_vma))) {
-			/* Page maybe pinned, we have to copy. */
-			put_page(page);
+			/* Page may be pinned, we have to copy. */
+			folio_put(folio);
 			return copy_present_page(dst_vma, src_vma, dst_pte, src_pte,
 						 addr, rss, prealloc, page);
 		}
 		rss[MM_ANONPAGES]++;
 	} else if (page) {
-		get_page(page);
+		folio_get(folio);
 		page_dup_file_rmap(page, false);
 		rss[mm_counter_file(page)]++;
 	}
@@ -937,7 +940,7 @@ copy_present_pte(struct vm_area_struct *
 		ptep_set_wrprotect(src_mm, addr, src_pte);
 		pte = pte_wrprotect(pte);
 	}
-	VM_BUG_ON(page && PageAnon(page) && PageAnonExclusive(page));
+	VM_BUG_ON(page && folio_test_anon(folio) && PageAnonExclusive(page));
 
 	/*
 	 * If it's a shared mapping, mark it clean in
_

Patches currently in -mm which might be from willy@infradead.org are


