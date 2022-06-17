Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1662BC433EF
	for <mm-commits@archiver.kernel.org>; Fri, 17 Jun 2022 23:01:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349580AbiFQXBv (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 17 Jun 2022 19:01:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238420AbiFQXBu (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 17 Jun 2022 19:01:50 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58271633AB
        for <mm-commits@vger.kernel.org>; Fri, 17 Jun 2022 16:01:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id ADA09CE2D3D
        for <mm-commits@vger.kernel.org>; Fri, 17 Jun 2022 23:01:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13A2EC3411D;
        Fri, 17 Jun 2022 23:01:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1655506906;
        bh=1wwOUbftwhrzlH31bfIBE9b23o2DkS1ETZGID0dpZ0o=;
        h=Date:To:From:Subject:From;
        b=dr90LSmA0//w3Q0oACUmLNc3RRuzUDQOtJ5zQD2SwHRKrhvS7YfZ7YG6xIr+HN0Mm
         RiSWPWBaATDdKP0xw3GRnZCaqu3QSnas0wauM8oIsa1IezJl2w40IMZWedQEl4yvwS
         Ro3teVWvDu6tPHYJvgBFbusItsK3GG2xkoKiL9ik=
Date:   Fri, 17 Jun 2022 16:01:45 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmscan-convert-reclaim_clean_pages_from_list-to-folios.patch added to mm-unstable branch
Message-Id: <20220617230146.13A2EC3411D@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/vmscan: convert reclaim_clean_pages_from_list() to folios
has been added to the -mm mm-unstable branch.  Its filename is
     mm-vmscan-convert-reclaim_clean_pages_from_list-to-folios.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmscan-convert-reclaim_clean_pages_from_list-to-folios.patch

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
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm/vmscan: convert reclaim_clean_pages_from_list() to folios
Date: Fri, 17 Jun 2022 16:42:44 +0100

Patch series "nvert much of vmscan to folios"

vmscan always operates on folios since it puts the pages on the LRU list. 
Switching all of these functions from pages to folios saves 1483 bytes of
text from removing all the baggage around calling compound_page() and
similar functions.


This patch (of 5):

This is a straightforward conversion which removes several hidden calls
to compound_head, saving 330 bytes of kernel text.

Link: https://lkml.kernel.org/r/20220617154248.700416-1-willy@infradead.org
Link: https://lkml.kernel.org/r/20220617154248.700416-2-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page-flags.h |    6 ++++++
 mm/vmscan.c                |   22 +++++++++++-----------
 2 files changed, 17 insertions(+), 11 deletions(-)

--- a/include/linux/page-flags.h~mm-vmscan-convert-reclaim_clean_pages_from_list-to-folios
+++ a/include/linux/page-flags.h
@@ -676,6 +676,12 @@ static __always_inline bool PageAnon(str
 	return folio_test_anon(page_folio(page));
 }
 
+static __always_inline bool __folio_test_movable(const struct folio *folio)
+{
+	return ((unsigned long)folio->mapping & PAGE_MAPPING_FLAGS) ==
+			PAGE_MAPPING_MOVABLE;
+}
+
 static __always_inline int __PageMovable(struct page *page)
 {
 	return ((unsigned long)page->mapping & PAGE_MAPPING_FLAGS) ==
--- a/mm/vmscan.c~mm-vmscan-convert-reclaim_clean_pages_from_list-to-folios
+++ a/mm/vmscan.c
@@ -2047,7 +2047,7 @@ keep:
 }
 
 unsigned int reclaim_clean_pages_from_list(struct zone *zone,
-					    struct list_head *page_list)
+					    struct list_head *folio_list)
 {
 	struct scan_control sc = {
 		.gfp_mask = GFP_KERNEL,
@@ -2055,16 +2055,16 @@ unsigned int reclaim_clean_pages_from_li
 	};
 	struct reclaim_stat stat;
 	unsigned int nr_reclaimed;
-	struct page *page, *next;
-	LIST_HEAD(clean_pages);
+	struct folio *folio, *next;
+	LIST_HEAD(clean_folios);
 	unsigned int noreclaim_flag;
 
-	list_for_each_entry_safe(page, next, page_list, lru) {
-		if (!PageHuge(page) && page_is_file_lru(page) &&
-		    !PageDirty(page) && !__PageMovable(page) &&
-		    !PageUnevictable(page)) {
-			ClearPageActive(page);
-			list_move(&page->lru, &clean_pages);
+	list_for_each_entry_safe(folio, next, folio_list, lru) {
+		if (!folio_test_hugetlb(folio) && folio_is_file_lru(folio) &&
+		    !folio_test_dirty(folio) && !__folio_test_movable(folio) &&
+		    !folio_test_unevictable(folio)) {
+			folio_clear_active(folio);
+			list_move(&folio->lru, &clean_folios);
 		}
 	}
 
@@ -2075,11 +2075,11 @@ unsigned int reclaim_clean_pages_from_li
 	 * change in the future.
 	 */
 	noreclaim_flag = memalloc_noreclaim_save();
-	nr_reclaimed = shrink_page_list(&clean_pages, zone->zone_pgdat, &sc,
+	nr_reclaimed = shrink_page_list(&clean_folios, zone->zone_pgdat, &sc,
 					&stat, true);
 	memalloc_noreclaim_restore(noreclaim_flag);
 
-	list_splice(&clean_pages, page_list);
+	list_splice(&clean_folios, folio_list);
 	mod_node_page_state(zone->zone_pgdat, NR_ISOLATED_FILE,
 			    -(long)nr_reclaimed);
 	/*
_

Patches currently in -mm which might be from willy@infradead.org are

mm-add-vma-iterator.patch
mmap-use-the-vma-iterator-in-count_vma_pages_range.patch
proc-remove-vma-rbtree-use-from-nommu.patch
arm64-remove-mmap-linked-list-from-vdso.patch
parisc-remove-mmap-linked-list-from-cache-handling.patch
powerpc-remove-mmap-linked-list-walks.patch
s390-remove-vma-linked-list-walks.patch
x86-remove-vma-linked-list-walks.patch
xtensa-remove-vma-linked-list-walks.patch
cxl-remove-vma-linked-list-walk.patch
optee-remove-vma-linked-list-walk.patch
um-remove-vma-linked-list-walk.patch
coredump-remove-vma-linked-list-walk.patch
exec-use-vma-iterator-instead-of-linked-list.patch
fs-proc-task_mmu-stop-using-linked-list-and-highest_vm_end.patch
acct-use-vma-iterator-instead-of-linked-list.patch
perf-use-vma-iterator.patch
sched-use-maple-tree-iterator-to-walk-vmas.patch
fork-use-vma-iterator.patch
mm-khugepaged-stop-using-vma-linked-list.patch
mm-ksm-use-vma-iterators-instead-of-vma-linked-list.patch
mm-mlock-use-vma-iterator-and-maple-state-instead-of-vma-linked-list.patch
mm-pagewalk-use-vma_find-instead-of-vma-linked-list.patch
i915-use-the-vma-iterator.patch
nommu-remove-uses-of-vma-linked-list.patch
mm-vmscan-convert-reclaim_clean_pages_from_list-to-folios.patch
mm-vmscan-convert-isolate_lru_pages-to-use-a-folio.patch
mm-vmscan-convert-move_pages_to_lru-to-use-a-folio.patch
mm-vmscan-convert-shrink_active_list-to-use-a-folio.patch
mm-vmscan-convert-reclaim_pages-to-use-a-folio.patch

