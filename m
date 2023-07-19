Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0EEDFC0015E
	for <mm-commits@archiver.kernel.org>; Wed, 19 Jul 2023 19:13:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229531AbjGSTNp (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 19 Jul 2023 15:13:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbjGSTNo (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 19 Jul 2023 15:13:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82B12199A
        for <mm-commits@vger.kernel.org>; Wed, 19 Jul 2023 12:13:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 095F7617E4
        for <mm-commits@vger.kernel.org>; Wed, 19 Jul 2023 19:13:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61530C433C7;
        Wed, 19 Jul 2023 19:13:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1689794022;
        bh=cAEsJ4Nm9FT2enY7JKm8OlDVu0c5nBFYeb9mzI8od8I=;
        h=Date:To:From:Subject:From;
        b=HmI0dVy6PLWhdx3b//4QuWcGYtaSbrCJnMHwnsYAlnPU9+wR6A6USfGj1ygRWi4I7
         ysZOQqGB0aeANl45majzQ3rzEzM13KlxJJapVfMIdD677FW5sgAtGQmEYxBZO+KLj7
         iF+3g69iT3/l6MjqvFdNtRXq9uBMrnxDFN3YiCDo=
Date:   Wed, 19 Jul 2023 12:13:41 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        songmuchun@bytedance.com, mike.kravetz@oracle.com,
        sidhartha.kumar@oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb-get-rid-of-page_hstate.patch added to mm-unstable branch
Message-Id: <20230719191342.61530C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hugetlb: get rid of page_hstate()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-hugetlb-get-rid-of-page_hstate.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb-get-rid-of-page_hstate.patch

This patch will later appear in the mm-unstable branch at
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
From: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Subject: mm/hugetlb: get rid of page_hstate()
Date: Wed, 19 Jul 2023 11:41:45 -0700

Convert the last page_hstate() user to use folio_hstate() so page_hstate()
can be safely removed.

Link: https://lkml.kernel.org/r/20230719184145.301911-1-sidhartha.kumar@oracle.com
Signed-off-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/hugetlb.h |   10 ----------
 mm/hugetlb.c            |    6 +++---
 mm/page_isolation.c     |    8 ++++----
 3 files changed, 7 insertions(+), 17 deletions(-)

--- a/include/linux/hugetlb.h~mm-hugetlb-get-rid-of-page_hstate
+++ a/include/linux/hugetlb.h
@@ -841,11 +841,6 @@ static inline struct hstate *folio_hstat
 	return size_to_hstate(folio_size(folio));
 }
 
-static inline struct hstate *page_hstate(struct page *page)
-{
-	return folio_hstate(page_folio(page));
-}
-
 static inline unsigned hstate_index_to_shift(unsigned index)
 {
 	return hstates[index].order + PAGE_SHIFT;
@@ -1061,11 +1056,6 @@ static inline struct hstate *folio_hstat
 {
 	return NULL;
 }
-
-static inline struct hstate *page_hstate(struct page *page)
-{
-	return NULL;
-}
 
 static inline struct hstate *size_to_hstate(unsigned long size)
 {
--- a/mm/hugetlb.c~mm-hugetlb-get-rid-of-page_hstate
+++ a/mm/hugetlb.c
@@ -1812,10 +1812,10 @@ static void free_hpage_workfn(struct wor
 		node = node->next;
 		page->mapping = NULL;
 		/*
-		 * The VM_BUG_ON_PAGE(!PageHuge(page), page) in page_hstate()
-		 * is going to trigger because a previous call to
+		 * The VM_BUG_ON_FOLIO(!folio_test_hugetlb(folio), folio) in
+		 * folio_hstate() is going to trigger because a previous call to
 		 * remove_hugetlb_folio() will call folio_set_compound_dtor
-		 * (folio, NULL_COMPOUND_DTOR), so do not use page_hstate()
+		 * (folio, NULL_COMPOUND_DTOR), so do not use folio_hstate()
 		 * directly.
 		 */
 		h = size_to_hstate(page_size(page));
--- a/mm/page_isolation.c~mm-hugetlb-get-rid-of-page_hstate
+++ a/mm/page_isolation.c
@@ -79,17 +79,17 @@ static struct page *has_unmovable_pages(
 		 * handle each tail page individually in migration.
 		 */
 		if (PageHuge(page) || PageTransCompound(page)) {
-			struct page *head = compound_head(page);
+			struct folio *folio = page_folio(page);
 			unsigned int skip_pages;
 
 			if (PageHuge(page)) {
-				if (!hugepage_migration_supported(page_hstate(head)))
+				if (!hugepage_migration_supported(folio_hstate(folio)))
 					return page;
-			} else if (!PageLRU(head) && !__PageMovable(head)) {
+			} else if (!folio_test_lru(folio) && !__folio_test_movable(folio)) {
 				return page;
 			}
 
-			skip_pages = compound_nr(head) - (page - head);
+			skip_pages = folio_nr_pages(folio) - folio_page_idx(folio, page);
 			pfn += skip_pages - 1;
 			continue;
 		}
_

Patches currently in -mm which might be from sidhartha.kumar@oracle.com are

mm-memory-failure-fix-hardware-poison-check-in-unpoison_memory.patch
mm-increase-usage-of-folio_next_index-helper.patch
mm-memory-convert-do_page_mkwrite-to-use-folios.patch
mm-memory-convert-wp_page_shared-to-use-folios.patch
mm-memory-convert-do_shared_fault-to-folios.patch
mm-memory-convert-do_read_fault-to-use-folios.patch
mm-memory-pass-folio-into-do_page_mkwrite.patch
mm-hugetlb-get-rid-of-page_hstate.patch

