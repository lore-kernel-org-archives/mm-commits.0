Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68D2DC64EC7
	for <mm-commits@archiver.kernel.org>; Wed, 15 Feb 2023 20:59:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229462AbjBOU7A (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 15 Feb 2023 15:59:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230010AbjBOU6o (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 15 Feb 2023 15:58:44 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C284474CD
        for <mm-commits@vger.kernel.org>; Wed, 15 Feb 2023 12:56:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E98F261D69
        for <mm-commits@vger.kernel.org>; Wed, 15 Feb 2023 20:55:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45D98C433EF;
        Wed, 15 Feb 2023 20:55:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1676494528;
        bh=KzneInbO7eF/Y92y3R+z0GxBqjDzN5RZt+cww9pHoTw=;
        h=Date:To:From:Subject:From;
        b=SIz7j87b3vnxVxshcp9OzJOfZ8WearkiBxgatDamaLYKSadwvOaxBdnO8PDlB4rL6
         n61D1AYr2EZfQ+y4LoDMZ89snDnM91i33pwU7Tkn5wFFFCKe8bBDHNO0qR/9sHTGmw
         jPsN2IaWqmmGOcMPiq8x4ckD4Ijl89wl8Dy2B+ws=
Date:   Wed, 15 Feb 2023 12:55:27 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        torvalds@linux-foundation.org, sj@kernel.org, david@redhat.com,
        baolin.wang@linux.alibaba.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-change-to-return-bool-for-isolate_lru_page.patch added to mm-unstable branch
Message-Id: <20230215205528.45D98C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: change to return bool for isolate_lru_page()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-change-to-return-bool-for-isolate_lru_page.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-change-to-return-bool-for-isolate_lru_page.patch

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

 mm/folio-compat.c   |   12 +++---------
 mm/internal.h       |    2 +-
 mm/khugepaged.c     |    2 +-
 mm/memcontrol.c     |    4 ++--
 mm/memory-failure.c |    4 ++--
 mm/memory_hotplug.c |    8 +++++---
 mm/migrate.c        |    9 ++++++---
 mm/migrate_device.c |    2 +-
 8 files changed, 21 insertions(+), 22 deletions(-)

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
@@ -659,7 +659,7 @@ static int __collapse_huge_page_isolate(
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

mm-change-to-return-bool-for-folio_isolate_lru.patch
mm-change-to-return-bool-for-isolate_lru_page.patch
mm-hugetlb-change-to-return-bool-for-isolate_hugetlb.patch
mm-change-to-return-bool-for-isolate_movable_page.patch

