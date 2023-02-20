Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3AE8FC64EC7
	for <mm-commits@archiver.kernel.org>; Mon, 20 Feb 2023 20:47:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231553AbjBTUrH (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 20 Feb 2023 15:47:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231951AbjBTUrG (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 20 Feb 2023 15:47:06 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE1B330CA
        for <mm-commits@vger.kernel.org>; Mon, 20 Feb 2023 12:47:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6108EB80DC7
        for <mm-commits@vger.kernel.org>; Mon, 20 Feb 2023 20:47:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05807C4339B;
        Mon, 20 Feb 2023 20:46:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1676926020;
        bh=pg+6cAx3AQPhm8b0H+jyMI0+DH+JI/j1CMVFVO83hxg=;
        h=Date:To:From:Subject:From;
        b=Kc61GIcI2t1NNcmKg2f6m+CPM1K8JQknNQt8UUD8F4kPpI1m1+XyVyzdGuxns/L5W
         5Y7tCge2+CO8rqokAjub+j+tQcbpkErW83W9QNtn5UKgF7V9AloFTj8e+FDJ/3kXn/
         U73/6ZEd8RS2gDphLTKM8i3R1fmvkoF47PbT4BLk=
Date:   Mon, 20 Feb 2023 12:46:59 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        torvalds@linux-foundation.org, sj@kernel.org, david@redhat.com,
        baolin.wang@linux.alibaba.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-change-to-return-bool-for-isolate_lru_page.patch removed from -mm tree
Message-Id: <20230220204700.05807C4339B@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: change to return bool for isolate_lru_page()
has been removed from the -mm tree.  Its filename was
     mm-change-to-return-bool-for-isolate_lru_page.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Baolin Wang <baolin.wang@linux.alibaba.com>
Subject: mm: change to return bool for isolate_lru_page()
Date: Wed, 15 Feb 2023 18:39:35 +0800

The isolate_lru_page() can only return 0 or -EBUSY, and most users did not
care about the negative error of isolate_lru_page(), except one user in
add_page_for_migration().  So we can convert the isolate_lru_page() to
return a boolean value, which can help to make the code more clear when
checking the return value of isolate_lru_page().

Also convert all users' logic of checking the isolation state.

No functional changes intended.

Link: https://lkml.kernel.org/r/3074c1ab628d9dbf139b33f248a8bc253a3f95f0.1676424378.git.baolin.wang@linux.alibaba.com
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Acked-by: Linus Torvalds <torvalds@linux-foundation.org>
Reviewed-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/folio-compat.c~mm-change-to-return-bool-for-isolate_lru_page
+++ a/mm/folio-compat.c
@@ -113,17 +113,11 @@ struct page *grab_cache_page_write_begin
 }
 EXPORT_SYMBOL(grab_cache_page_write_begin);
 
-int isolate_lru_page(struct page *page)
+bool isolate_lru_page(struct page *page)
 {
-	bool ret;
-
 	if (WARN_RATELIMIT(PageTail(page), "trying to isolate tail page"))
-		return -EBUSY;
-	ret = folio_isolate_lru((struct folio *)page);
-	if (ret)
-		return 0;
-
-	return -EBUSY;
+		return false;
+	return folio_isolate_lru((struct folio *)page);
 }
 
 void putback_lru_page(struct page *page)
--- a/mm/internal.h~mm-change-to-return-bool-for-isolate_lru_page
+++ a/mm/internal.h
@@ -187,7 +187,7 @@ pgprot_t __init early_memremap_pgprot_ad
 /*
  * in mm/vmscan.c:
  */
-int isolate_lru_page(struct page *page);
+bool isolate_lru_page(struct page *page);
 bool folio_isolate_lru(struct folio *folio);
 void putback_lru_page(struct page *page);
 void folio_putback_lru(struct folio *folio);
--- a/mm/khugepaged.c~mm-change-to-return-bool-for-isolate_lru_page
+++ a/mm/khugepaged.c
@@ -636,7 +636,7 @@ static int __collapse_huge_page_isolate(
 		 * Isolate the page to avoid collapsing an hugepage
 		 * currently in use by the VM.
 		 */
-		if (isolate_lru_page(page)) {
+		if (!isolate_lru_page(page)) {
 			unlock_page(page);
 			result = SCAN_DEL_PAGE_LRU;
 			goto out;
--- a/mm/memcontrol.c~mm-change-to-return-bool-for-isolate_lru_page
+++ a/mm/memcontrol.c
@@ -6176,7 +6176,7 @@ static int mem_cgroup_move_charge_pte_ra
 		target_type = get_mctgt_type_thp(vma, addr, *pmd, &target);
 		if (target_type == MC_TARGET_PAGE) {
 			page = target.page;
-			if (!isolate_lru_page(page)) {
+			if (isolate_lru_page(page)) {
 				if (!mem_cgroup_move_account(page, true,
 							     mc.from, mc.to)) {
 					mc.precharge -= HPAGE_PMD_NR;
@@ -6226,7 +6226,7 @@ retry:
 			 */
 			if (PageTransCompound(page))
 				goto put;
-			if (!device && isolate_lru_page(page))
+			if (!device && !isolate_lru_page(page))
 				goto put;
 			if (!mem_cgroup_move_account(page, false,
 						mc.from, mc.to)) {
--- a/mm/memory-failure.c~mm-change-to-return-bool-for-isolate_lru_page
+++ a/mm/memory-failure.c
@@ -846,7 +846,7 @@ static const char * const action_page_ty
  */
 static int delete_from_lru_cache(struct page *p)
 {
-	if (!isolate_lru_page(p)) {
+	if (isolate_lru_page(p)) {
 		/*
 		 * Clear sensible page flags, so that the buddy system won't
 		 * complain when the page is unpoison-and-freed.
@@ -2513,7 +2513,7 @@ static bool isolate_page(struct page *pa
 		bool lru = !__PageMovable(page);
 
 		if (lru)
-			isolated = !isolate_lru_page(page);
+			isolated = isolate_lru_page(page);
 		else
 			isolated = !isolate_movable_page(page,
 							 ISOLATE_UNEVICTABLE);
--- a/mm/memory_hotplug.c~mm-change-to-return-bool-for-isolate_lru_page
+++ a/mm/memory_hotplug.c
@@ -1632,6 +1632,7 @@ do_migrate_range(unsigned long start_pfn
 
 	for (pfn = start_pfn; pfn < end_pfn; pfn++) {
 		struct folio *folio;
+		bool isolated;
 
 		if (!pfn_valid(pfn))
 			continue;
@@ -1667,9 +1668,10 @@ do_migrate_range(unsigned long start_pfn
 		 * We can skip free pages. And we can deal with pages on
 		 * LRU and non-lru movable pages.
 		 */
-		if (PageLRU(page))
-			ret = isolate_lru_page(page);
-		else
+		if (PageLRU(page)) {
+			isolated = isolate_lru_page(page);
+			ret = isolated ? 0 : -EBUSY;
+		} else
 			ret = isolate_movable_page(page, ISOLATE_UNEVICTABLE);
 		if (!ret) { /* Success */
 			list_add_tail(&page->lru, &source);
--- a/mm/migrate.c~mm-change-to-return-bool-for-isolate_lru_page
+++ a/mm/migrate.c
@@ -2132,11 +2132,14 @@ static int add_page_for_migration(struct
 		}
 	} else {
 		struct page *head;
+		bool isolated;
 
 		head = compound_head(page);
-		err = isolate_lru_page(head);
-		if (err)
+		isolated = isolate_lru_page(head);
+		if (!isolated) {
+			err = -EBUSY;
 			goto out_putpage;
+		}
 
 		err = 1;
 		list_add_tail(&head->lru, pagelist);
@@ -2541,7 +2544,7 @@ static int numamigrate_isolate_page(pg_d
 		return 0;
 	}
 
-	if (isolate_lru_page(page))
+	if (!isolate_lru_page(page))
 		return 0;
 
 	mod_node_page_state(page_pgdat(page), NR_ISOLATED_ANON + page_is_file_lru(page),
--- a/mm/migrate_device.c~mm-change-to-return-bool-for-isolate_lru_page
+++ a/mm/migrate_device.c
@@ -388,7 +388,7 @@ static unsigned long migrate_device_unma
 				allow_drain = false;
 			}
 
-			if (isolate_lru_page(page)) {
+			if (!isolate_lru_page(page)) {
 				src_pfns[i] &= ~MIGRATE_PFN_MIGRATE;
 				restore++;
 				continue;
_

Patches currently in -mm which might be from baolin.wang@linux.alibaba.com are


