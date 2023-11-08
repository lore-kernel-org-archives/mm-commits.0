Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C061BC001B2
	for <mm-commits@archiver.kernel.org>; Wed,  8 Nov 2023 21:11:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231961AbjKHVLr (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 8 Nov 2023 16:11:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231976AbjKHVLn (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 8 Nov 2023 16:11:43 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADAA62587;
        Wed,  8 Nov 2023 13:11:41 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49C0EC433C8;
        Wed,  8 Nov 2023 21:11:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1699477901;
        bh=XnYgYTnAQMzeWLt09qDwgRFdx0ODRBNDlyt7kMGFjKI=;
        h=Date:To:From:Subject:From;
        b=P4xgE/Xusu0xKMNtC9owxvbUJ/nP//mvp9UuX/jTHAiEbRwnSMOA0qF8kGazV0jmR
         0ufAhXqgTgKwQWcq7vsYYNpv6sv8sFaNODZB9lOouHm9++kSiU+/icqTKatSTTu1hd
         yS9MF+/+JV236wNyWuStfNm+nZpeyVD8iI9MNUKQ=
Date:   Wed, 08 Nov 2023 13:11:40 -0800
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org,
        naoya.horiguchi@nec.com, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-convert-isolate_page-to-mf_isolate_folio.patch added to mm-hotfixes-unstable branch
Message-Id: <20231108211141.49C0EC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: convert isolate_page() to mf_isolate_folio()
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-convert-isolate_page-to-mf_isolate_folio.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-convert-isolate_page-to-mf_isolate_folio.patch

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
Subject: mm: convert isolate_page() to mf_isolate_folio()
Date: Wed, 8 Nov 2023 18:28:08 +0000

The only caller now has a folio, so pass it in and operate on it.  Saves
many page->folio conversions and introduces only one folio->page
conversion when calling isolate_movable_page().

Link: https://lkml.kernel.org/r/20231108182809.602073-6-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: <stable@vger.kernel.org>
Cc: Naoya Horiguchi <naoya.horiguchi@nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |   28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

--- a/mm/memory-failure.c~mm-convert-isolate_page-to-mf_isolate_folio
+++ a/mm/memory-failure.c
@@ -2602,37 +2602,37 @@ unlock_mutex:
 }
 EXPORT_SYMBOL(unpoison_memory);
 
-static bool isolate_page(struct page *page, struct list_head *pagelist)
+static bool mf_isolate_folio(struct folio *folio, struct list_head *pagelist)
 {
 	bool isolated = false;
 
-	if (PageHuge(page)) {
-		isolated = isolate_hugetlb(page_folio(page), pagelist);
+	if (folio_test_hugetlb(folio)) {
+		isolated = isolate_hugetlb(folio, pagelist);
 	} else {
-		bool lru = !__PageMovable(page);
+		bool lru = !__folio_test_movable(folio);
 
 		if (lru)
-			isolated = isolate_lru_page(page);
+			isolated = folio_isolate_lru(folio);
 		else
-			isolated = isolate_movable_page(page,
+			isolated = isolate_movable_page(&folio->page,
 							ISOLATE_UNEVICTABLE);
 
 		if (isolated) {
-			list_add(&page->lru, pagelist);
+			list_add(&folio->lru, pagelist);
 			if (lru)
-				inc_node_page_state(page, NR_ISOLATED_ANON +
-						    page_is_file_lru(page));
+				node_stat_add_folio(folio, NR_ISOLATED_ANON +
+						    folio_is_file_lru(folio));
 		}
 	}
 
 	/*
-	 * If we succeed to isolate the page, we grabbed another refcount on
-	 * the page, so we can safely drop the one we got from get_any_page().
-	 * If we failed to isolate the page, it means that we cannot go further
+	 * If we succeed to isolate the folio, we grabbed another refcount on
+	 * the folio, so we can safely drop the one we got from get_any_page().
+	 * If we failed to isolate the folio, it means that we cannot go further
 	 * and we will return an error, so drop the reference we got from
 	 * get_any_page() as well.
 	 */
-	put_page(page);
+	folio_put(folio);
 	return isolated;
 }
 
@@ -2686,7 +2686,7 @@ static int soft_offline_in_use_page(stru
 		return 0;
 	}
 
-	if (isolate_page(&folio->page, &pagelist)) {
+	if (mf_isolate_folio(folio, &pagelist)) {
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

