Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6AEDCC61DA4
	for <mm-commits@archiver.kernel.org>; Fri,  3 Feb 2023 06:38:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232338AbjBCGiQ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Feb 2023 01:38:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232341AbjBCGgg (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 3 Feb 2023 01:36:36 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 017C68BDF8
        for <mm-commits@vger.kernel.org>; Thu,  2 Feb 2023 22:36:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id ACC05B82981
        for <mm-commits@vger.kernel.org>; Fri,  3 Feb 2023 06:36:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56CECC4339B;
        Fri,  3 Feb 2023 06:36:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675406184;
        bh=LyocK97YdKePMdkgjpsMA3/fK1L/h1nTdD2OCSabuYo=;
        h=Date:To:From:Subject:From;
        b=L6MGki4oO7xrCxm3PoMUo8MAvHhfD0FvDnJazyKXJR4baITdLRke11LOzkdAnEXWr
         /owigKSL6eyuS2V/+5DexCkRCP5xn9CvsezVF/rtdk+LsRXAiUBkkabWBQCNuW2Gof
         K00pSPipIwY2ti6BhhXlmT3viyoIPJ0UeT2Izsms=
Date:   Thu, 02 Feb 2023 22:36:23 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        mike.kravetz@oracle.com, vishal.moola@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-khugepaged-introduce-release_pte_folio-to-replace-release_pte_page.patch removed from -mm tree
Message-Id: <20230203063624.56CECC4339B@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/khugepaged: introduce release_pte_folio() to replace release_pte_page()
has been removed from the -mm tree.  Its filename was
     mm-khugepaged-introduce-release_pte_folio-to-replace-release_pte_page.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
Subject: mm/khugepaged: introduce release_pte_folio() to replace release_pte_page()
Date: Fri, 13 Jan 2023 16:15:55 -0800

release_pte_page() is converted to be a wrapper for release_pte_folio() to
help facilitate the khugepaged conversion to folios.

This replaces 3 calls to compound_head() with 1, and saves 85 bytes of
kernel text.

Link: https://lkml.kernel.org/r/20230114001556.43795-1-vishal.moola@gmail.com
Signed-off-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/khugepaged.c~mm-khugepaged-introduce-release_pte_folio-to-replace-release_pte_page
+++ a/mm/khugepaged.c
@@ -490,13 +490,18 @@ void __khugepaged_exit(struct mm_struct
 	}
 }
 
+static void release_pte_folio(struct folio *folio)
+{
+	node_stat_mod_folio(folio,
+			NR_ISOLATED_ANON + folio_is_file_lru(folio),
+			-folio_nr_pages(folio));
+	folio_unlock(folio);
+	folio_putback_lru(folio);
+}
+
 static void release_pte_page(struct page *page)
 {
-	mod_node_page_state(page_pgdat(page),
-			NR_ISOLATED_ANON + page_is_file_lru(page),
-			-compound_nr(page));
-	unlock_page(page);
-	putback_lru_page(page);
+	release_pte_folio(page_folio(page));
 }
 
 static void release_pte_pages(pte_t *pte, pte_t *_pte,
_

Patches currently in -mm which might be from vishal.moola@gmail.com are

mm-add-folio_estimated_sharers.patch
mm-mempolicy-convert-queue_pages_pmd-to-queue_folios_pmd.patch
mm-mempolicy-convert-queue_pages_pte_range-to-queue_folios_pte_range.patch
mm-mempolicy-convert-queue_pages_hugetlb-to-queue_folios_hugetlb.patch
mm-mempolicy-convert-queue_pages_required-to-queue_folio_required.patch
mm-mempolicy-convert-migrate_page_add-to-migrate_folio_add.patch
mm-add-folio_get_nontail_page.patch
mm-migrate-add-folio_movable_ops.patch
mm-migrate-convert-isolate_movable_page-to-use-folios.patch
mm-migrate-convert-putback_movable_pages-to-use-folios.patch

