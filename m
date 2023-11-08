Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3472C41535
	for <mm-commits@archiver.kernel.org>; Wed,  8 Nov 2023 21:11:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230474AbjKHVLr (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 8 Nov 2023 16:11:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231961AbjKHVLm (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 8 Nov 2023 16:11:42 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8828D2586;
        Wed,  8 Nov 2023 13:11:40 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22439C433C7;
        Wed,  8 Nov 2023 21:11:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1699477900;
        bh=jdbskGOuknQV1Nlq1HeFXMTqgWTEPzRZKKjz6uzk6qk=;
        h=Date:To:From:Subject:From;
        b=w3OnsfLpGafQT+elT1kI91Y5sGwsBZT1CmsaMHYaJVLoifJY6LM0TZi1seBh3AuPM
         LFZzAOlxz1vHwkxiUaefu6u0ppwJg4XmdC4N5lRbv2jm0fU+85uXVAwN6C12Dw/muP
         Lt3PflyrN5gNmcQwTg65kyk7Oue/0J+kpYXykSLA=
Date:   Wed, 08 Nov 2023 13:11:39 -0800
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org,
        naoya.horiguchi@nec.com, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-convert-soft_offline_in_use_page-to-use-a-folio.patch added to mm-hotfixes-unstable branch
Message-Id: <20231108211140.22439C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: convert soft_offline_in_use_page() to use a folio
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-convert-soft_offline_in_use_page-to-use-a-folio.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-convert-soft_offline_in_use_page-to-use-a-folio.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: convert soft_offline_in_use_page() to use a folio
Date: Wed, 8 Nov 2023 18:28:07 +0000

Replace the existing head-page logic with folio logic.

Link: https://lkml.kernel.org/r/20231108182809.602073-5-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: <stable@vger.kernel.org>
Cc: Naoya Horiguchi <naoya.horiguchi@nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |   24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

--- a/mm/memory-failure.c~mm-convert-soft_offline_in_use_page-to-use-a-folio
+++ a/mm/memory-failure.c
@@ -2645,40 +2645,40 @@ static int soft_offline_in_use_page(stru
 {
 	long ret = 0;
 	unsigned long pfn = page_to_pfn(page);
-	struct page *hpage = compound_head(page);
+	struct folio *folio = page_folio(page);
 	char const *msg_page[] = {"page", "hugepage"};
-	bool huge = PageHuge(page);
+	bool huge = folio_test_hugetlb(folio);
 	LIST_HEAD(pagelist);
 	struct migration_target_control mtc = {
 		.nid = NUMA_NO_NODE,
 		.gfp_mask = GFP_USER | __GFP_MOVABLE | __GFP_RETRY_MAYFAIL,
 	};
 
-	if (!huge && PageTransHuge(hpage)) {
+	if (!huge && folio_test_large(folio)) {
 		if (try_to_split_thp_page(page)) {
 			pr_info("soft offline: %#lx: thp split failed\n", pfn);
 			return -EBUSY;
 		}
-		hpage = page;
+		folio = page_folio(page);
 	}
 
-	lock_page(page);
+	folio_lock(folio);
 	if (!huge)
-		wait_on_page_writeback(page);
+		folio_wait_writeback(folio);
 	if (PageHWPoison(page)) {
-		unlock_page(page);
-		put_page(page);
+		folio_unlock(folio);
+		folio_put(folio);
 		pr_info("soft offline: %#lx page already poisoned\n", pfn);
 		return 0;
 	}
 
-	if (!huge && PageLRU(page) && !PageSwapCache(page))
+	if (!huge && folio_test_lru(folio) && !folio_test_swapcache(folio))
 		/*
 		 * Try to invalidate first. This should work for
 		 * non dirty unmapped page cache pages.
 		 */
-		ret = invalidate_inode_page(page);
-	unlock_page(page);
+		ret = mapping_evict_folio(folio_mapping(folio), folio);
+	folio_unlock(folio);
 
 	if (ret) {
 		pr_info("soft_offline: %#lx: invalidated\n", pfn);
@@ -2686,7 +2686,7 @@ static int soft_offline_in_use_page(stru
 		return 0;
 	}
 
-	if (isolate_page(hpage, &pagelist)) {
+	if (isolate_page(&folio->page, &pagelist)) {
 		ret = migrate_pages(&pagelist, alloc_migration_target, NULL,
 			(unsigned long)&mtc, MIGRATE_SYNC, MR_MEMORY_FAILURE, NULL);
 		if (!ret) {
_

Patches currently in -mm which might be from willy@infradead.org are

mm-make-mapping_evict_folio-the-preferred-way-to-evict-clean-folios.patch
mm-convert-__do_fault-to-use-a-folio.patch
mm-use-mapping_evict_folio-in-truncate_error_page.patch
mm-convert-soft_offline_in_use_page-to-use-a-folio.patch
mm-convert-isolate_page-to-mf_isolate_folio.patch
mm-remove-invalidate_inode_page.patch

