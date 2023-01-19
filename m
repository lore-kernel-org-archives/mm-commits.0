Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1284AC004D4
	for <mm-commits@archiver.kernel.org>; Thu, 19 Jan 2023 22:49:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230184AbjASWtq (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 19 Jan 2023 17:49:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230296AbjASWtM (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 19 Jan 2023 17:49:12 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD6E1AA5EA
        for <mm-commits@vger.kernel.org>; Thu, 19 Jan 2023 14:32:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8F40B61D8E
        for <mm-commits@vger.kernel.org>; Thu, 19 Jan 2023 22:32:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4BABC433D2;
        Thu, 19 Jan 2023 22:32:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1674167549;
        bh=l1zkp0sU/JZ+D5+PaQEcUphEUEFqF5q9+pn8UbCII9w=;
        h=Date:To:From:Subject:From;
        b=SM3afr5AS1nlfQEf+tFebw7CaL8enjYz/LHTeINobSdvPEDb+s73EoTEkbVWu1UPU
         2e3ew0GFffj6IvAU3GfDTM7G+MZeUWcCGdfuC1olY8kH5w/O+sc+F2r0LZH0f1CmbI
         MQo95W0lbt+Pgo0LegI6X1HO5ahCKkmx7lt5nJFw=
Date:   Thu, 19 Jan 2023 14:32:28 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        songmuchun@bytedance.com, mike.kravetz@oracle.com,
        jhubbard@nvidia.com, sidhartha.kumar@oracle.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb-convert-putback_active_hugepage-to-take-in-a-folio.patch added to mm-unstable branch
Message-Id: <20230119223228.E4BABC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hugetlb: convert putback_active_hugepage to take in a folio
has been added to the -mm mm-unstable branch.  Its filename is
     mm-hugetlb-convert-putback_active_hugepage-to-take-in-a-folio.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb-convert-putback_active_hugepage-to-take-in-a-folio.patch

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
Subject: mm/hugetlb: convert putback_active_hugepage to take in a folio
Date: Thu, 19 Jan 2023 13:14:40 -0800

Convert putback_active_hugepage() to putback_active_hugetlb_folio(), this
removes one user of the Huge Page macros which take in a page.  The
callers in migrate.c are also cleaned up by being able to directly use the
src and dst folio variables.

Link: https://lkml.kernel.org/r/20230119211446.54165-4-sidhartha.kumar@oracle.com
Signed-off-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/include/linux/hugetlb.h~mm-hugetlb-convert-putback_active_hugepage-to-take-in-a-folio
+++ a/include/linux/hugetlb.h
@@ -174,7 +174,7 @@ int isolate_hugetlb(struct folio *folio,
 int get_hwpoison_hugetlb_folio(struct folio *folio, bool *hugetlb, bool unpoison);
 int get_huge_page_for_hwpoison(unsigned long pfn, int flags,
 				bool *migratable_cleared);
-void putback_active_hugepage(struct page *page);
+void putback_active_hugetlb_folio(struct folio *folio);
 void move_hugetlb_state(struct folio *old_folio, struct folio *new_folio, int reason);
 void free_huge_page(struct page *page);
 void hugetlb_fix_reserve_counts(struct inode *inode);
@@ -428,7 +428,7 @@ static inline int get_huge_page_for_hwpo
 	return 0;
 }
 
-static inline void putback_active_hugepage(struct page *page)
+static inline void putback_active_hugetlb_folio(struct folio *folio)
 {
 }
 
--- a/mm/hugetlb.c~mm-hugetlb-convert-putback_active_hugepage-to-take-in-a-folio
+++ a/mm/hugetlb.c
@@ -7302,13 +7302,13 @@ int get_huge_page_for_hwpoison(unsigned
 	return ret;
 }
 
-void putback_active_hugepage(struct page *page)
+void putback_active_hugetlb_folio(struct folio *folio)
 {
 	spin_lock_irq(&hugetlb_lock);
-	SetHPageMigratable(page);
-	list_move_tail(&page->lru, &(page_hstate(page))->hugepage_activelist);
+	folio_set_hugetlb_migratable(folio);
+	list_move_tail(&folio->lru, &(folio_hstate(folio))->hugepage_activelist);
 	spin_unlock_irq(&hugetlb_lock);
-	put_page(page);
+	folio_put(folio);
 }
 
 void move_hugetlb_state(struct folio *old_folio, struct folio *new_folio, int reason)
--- a/mm/migrate.c~mm-hugetlb-convert-putback_active_hugepage-to-take-in-a-folio
+++ a/mm/migrate.c
@@ -151,7 +151,7 @@ void putback_movable_pages(struct list_h
 
 	list_for_each_entry_safe(page, page2, l, lru) {
 		if (unlikely(PageHuge(page))) {
-			putback_active_hugepage(page);
+			putback_active_hugetlb_folio(page_folio(page));
 			continue;
 		}
 		list_del(&page->lru);
@@ -1374,7 +1374,7 @@ static int unmap_and_move_huge_page(new_
 
 	if (folio_ref_count(src) == 1) {
 		/* page was freed from under us. So we are done. */
-		putback_active_hugepage(hpage);
+		putback_active_hugetlb_folio(src);
 		return MIGRATEPAGE_SUCCESS;
 	}
 
@@ -1459,7 +1459,7 @@ out_unlock:
 	folio_unlock(src);
 out:
 	if (rc == MIGRATEPAGE_SUCCESS)
-		putback_active_hugepage(hpage);
+		putback_active_hugetlb_folio(src);
 	else if (rc != -EAGAIN)
 		list_move_tail(&src->lru, ret);
 
@@ -1471,7 +1471,7 @@ out:
 	if (put_new_page)
 		put_new_page(new_hpage, private);
 	else
-		putback_active_hugepage(new_hpage);
+		putback_active_hugetlb_folio(dst);
 
 	return rc;
 }
_

Patches currently in -mm which might be from sidhartha.kumar@oracle.com are

mm-remove-the-hugetlb-field-from-struct-page.patch
mm-memory-failure-convert-__get_huge_page_for_hwpoison-to-folios.patch
mm-memory-failure-convert-try_memory_failure_hugetlb-to-folios.patch
mm-memory-failure-convert-hugetlb_clear_page_hwpoison-to-folios.patch
mm-memory-failure-convert-free_raw_hwp_pages-to-folios.patch
mm-memory-failure-convert-raw_hwp_list_head-to-folios.patch
mm-memory-failure-convert-__free_raw_hwp_pages-to-folios.patch
mm-memory-failure-convert-hugetlb_set_page_hwpoison-to-folios.patch
mm-memory-failure-convert-unpoison_memory-to-folios.patch
mm-hugetlb-convert-isolate_hugetlb-to-folios.patch
mm-hugetlb-convert-__update_and_free_page-to-folios.patch
mm-hugetlb-convert-dequeue_hugetlb_page-functions-to-folios.patch
mm-hugetlb-convert-alloc_surplus_huge_page-to-folios.patch
mm-hugetlb-increase-use-of-folios-in-alloc_huge_page.patch
mm-hugetlb-convert-alloc_migrate_huge_page-to-folios.patch
mm-hugetlb-convert-restore_reserve_on_error-to-folios.patch
mm-hugetlb-convert-demote_free_huge_page-to-folios.patch
mm-hugetlb-convert-get_hwpoison_huge_page-to-folios.patch
mm-hugetlb-convert-hugetlb_install_page-to-folios.patch
mm-hugetlb-convert-hugetlbfs_pagecache_present-to-folios.patch
mm-hugetlb-convert-putback_active_hugepage-to-take-in-a-folio.patch
mm-rmap-change-hugepage_add_new_anon_rmap-to-take-in-a-folio.patch
mm-hugetlb-convert-alloc_huge_page-to-alloc_hugetlb_folio.patch
mm-hugetlb-convert-restore_reserve_on_error-to-take-in-a-folio.patch
mm-hugetlb-convert-hugetlb_add_to_page_cache-to-take-in-a-folio.patch
mm-hugetlb-convert-hugetlb_wp-to-take-in-a-folio.patch
documentation-mm-update-hugetlbfs-documentation-to-mention-alloc_hugetlb_folio.patch

