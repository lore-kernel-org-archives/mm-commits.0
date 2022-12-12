Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 363D0C4167B
	for <mm-commits@archiver.kernel.org>; Mon, 12 Dec 2022 02:15:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230499AbiLLCPQ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 11 Dec 2022 21:15:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230394AbiLLCOc (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 11 Dec 2022 21:14:32 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06BABDF12
        for <mm-commits@vger.kernel.org>; Sun, 11 Dec 2022 18:14:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 982A660EC7
        for <mm-commits@vger.kernel.org>; Mon, 12 Dec 2022 02:14:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED543C433D2;
        Mon, 12 Dec 2022 02:14:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1670811252;
        bh=zgL2kPV4Wt1lsC78PfKQ7hWer2bPIKHuRD3HpxgsteY=;
        h=Date:To:From:Subject:From;
        b=OSkp/l0XCTahcx0ho2hxy+1Za5p2DVzEcXKv53mVWjdVIqScarf33BjNJlRv1nIt2
         HdCqhdxjSJ/RAoJx3jvlKpOCL+XEBpKUcaZLJQn/m6R5Wy0IH1cG8V1GRofVLXJ9GJ
         bdrq8/+hth9x4sNAXmQl0jDZHjls3rKdVC/ey/j8=
Date:   Sun, 11 Dec 2022 18:14:11 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        mszeredi@redhat.com, mike.kravetz@oracle.com,
        vishal.moola@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] khugepage-replace-lru_cache_add-with-folio_add_lru.patch removed from -mm tree
Message-Id: <20221212021411.ED543C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: khugepage: replace lru_cache_add() with folio_add_lru()
has been removed from the -mm tree.  Its filename was
     khugepage-replace-lru_cache_add-with-folio_add_lru.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
Subject: khugepage: replace lru_cache_add() with folio_add_lru()
Date: Tue, 1 Nov 2022 10:53:25 -0700

Replaces some calls with their folio equivalents.  This is in preparation
for the removal of lru_cache_add().  This replaces 3 calls to
compound_head() with 1.

Link: https://lkml.kernel.org/r/20221101175326.13265-5-vishal.moola@gmail.com
Signed-off-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/khugepaged.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

--- a/mm/khugepaged.c~khugepage-replace-lru_cache_add-with-folio_add_lru
+++ a/mm/khugepaged.c
@@ -2013,6 +2013,7 @@ xa_unlocked:
 
 	if (result == SCAN_SUCCEED) {
 		struct page *page, *tmp;
+		struct folio *folio;
 
 		/*
 		 * Replacing old pages with new one has succeeded, now we
@@ -2040,11 +2041,13 @@ xa_unlocked:
 			index++;
 		}
 
-		SetPageUptodate(hpage);
-		page_ref_add(hpage, HPAGE_PMD_NR - 1);
+		folio = page_folio(hpage);
+		folio_mark_uptodate(folio);
+		folio_ref_add(folio, HPAGE_PMD_NR - 1);
+
 		if (is_shmem)
-			set_page_dirty(hpage);
-		lru_cache_add(hpage);
+			folio_mark_dirty(folio);
+		folio_add_lru(folio);
 
 		/*
 		 * Remove pte page tables, so we can re-fault the page as huge.
_

Patches currently in -mm which might be from vishal.moola@gmail.com are


