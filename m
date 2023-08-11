Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E5CAC001B0
	for <mm-commits@archiver.kernel.org>; Fri, 11 Aug 2023 23:05:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236736AbjHKXFg (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 11 Aug 2023 19:05:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236812AbjHKXD4 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 11 Aug 2023 19:03:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3A374489
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 16:01:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 946A667AB8
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 23:01:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEFE6C433C9;
        Fri, 11 Aug 2023 23:01:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691794918;
        bh=UbvurS+0eRvvQ3sST6QXuIA7nHi23p+qII8MKaEzjP4=;
        h=Date:To:From:Subject:From;
        b=gEHoan1VdXaNTpsenGKnXmvMCh3O9O2DPvPRJyO/A3wKJfsvEoEaycB0dAOc34sN1
         Fz8aY0cac+5kcK6Iexkfnb40oyhQO8RkNrctxkmmmWUlm4vmcfDKvHdoAsYTys4uVC
         U9tF8REQrZs5yX7yN/gEUfwwB58mmNaVXzDZ0GiY=
Date:   Fri, 11 Aug 2023 16:01:57 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        songmuchun@bytedance.com, mike.kravetz@oracle.com,
        sidhartha.kumar@oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-hugetlb-get-rid-of-page_hstate.patch removed from -mm tree
Message-Id: <20230811230157.EEFE6C433C9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/hugetlb: get rid of page_hstate()
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-get-rid-of-page_hstate.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Subject: mm/hugetlb: get rid of page_hstate()
Date: Wed, 19 Jul 2023 11:41:45 -0700

Convert the last page_hstate() user to use folio_hstate() so page_hstate()
can be safely removed.

Link: https://lkml.kernel.org/r/20230719184145.301911-1-sidhartha.kumar@oracle.com
Signed-off-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
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
@@ -1785,10 +1785,10 @@ static void free_hpage_workfn(struct wor
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


