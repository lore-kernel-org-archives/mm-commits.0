Return-Path: <SRS0=UeFd=EL=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39434C2D0A3
	for <mm-commits@archiver.kernel.org>; Thu,  5 Nov 2020 00:49:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DFC9E21527
	for <mm-commits@archiver.kernel.org>; Thu,  5 Nov 2020 00:49:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1604537351;
	bh=sPYTeEeJ19O/8MSa05+5lkduqDDpkIxOo1AcX1f8x1I=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=E6Rc2JhtsgY2B3p2mkCZNXeggyR1ZCmK8PF1rCRcLWQMNQ46rY7etasgLRaeOTgnn
	 ovYvYVqke1ynEgG9j/tqEzzkLvp8wQZOveIKYcswON8Ff1/j+MsnPTSeI2iaSz7/uF
	 +q2AeX5D1IdxcjCm0XkEBA0FGr7QzbPZaDWmamvU=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732555AbgKEAtL (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 4 Nov 2020 19:49:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:52272 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726539AbgKEAtL (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 4 Nov 2020 19:49:11 -0500
Received: from X1 (unknown [208.106.6.120])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F2D3D20867;
        Thu,  5 Nov 2020 00:49:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604537350;
        bh=sPYTeEeJ19O/8MSa05+5lkduqDDpkIxOo1AcX1f8x1I=;
        h=Date:From:To:Subject:From;
        b=rWi3W5I3Baqgv2tGzemYLQK5bNkrtEXVmFMXUi2W5fE4QQHdv+YPc8/8IbEdLPV/z
         XCrsUYA3KcHoe42he7nqsSJEIaQY2uTLpx1dzVrPiNJqHzcSUQamia1ZiUplKflL/z
         MAOtA24h6ip+QVpsosd59P/RsZg7u/fFqTPCh4Vk=
Date:   Wed, 04 Nov 2020 16:49:09 -0800
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, vbabka@suse.cz, mhocko@kernel.org,
        jglisse@redhat.com, hughd@google.com, hannes@cmpxchg.org,
        dan.j.williams@intel.com, aarcange@redhat.com, shakeelb@google.com
Subject:  + mm-rmap-always-do-ttu_ignore_access.patch added to -mm
 tree
Message-ID: <20201105004909.ITHpV%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/rmap: always do TTU_IGNORE_ACCESS
has been added to the -mm tree.  Its filename is
     mm-rmap-always-do-ttu_ignore_access.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-rmap-always-do-ttu_ignore_access.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-rmap-always-do-ttu_ignore_access.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Shakeel Butt <shakeelb@google.com>
Subject: mm/rmap: always do TTU_IGNORE_ACCESS

Since commit 369ea8242c0f ("mm/rmap: update to new mmu_notifier semantic
v2"), the code to check the secondary MMU's page table access bit is
broken for !(TTU_IGNORE_ACCESS) because the page is unmapped from the
secondary MMU's page table before the check.  More specifically for those
secondary MMUs which unmap the memory in
mmu_notifier_invalidate_range_start() like kvm.

However memory reclaim is the only user of !(TTU_IGNORE_ACCESS) or the
absence of TTU_IGNORE_ACCESS and it explicitly performs the page table
access check before trying to unmap the page.  So, at worst the reclaim
will miss accesses in a very short window if we remove page table access
check in unmapping code.

There is an unintented consequence of !(TTU_IGNORE_ACCESS) for the memcg
reclaim.  From memcg reclaim the page_referenced() only account the
accesses from the processes which are in the same memcg of the target page
but the unmapping code is considering accesses from all the processes, so,
decreasing the effectiveness of memcg reclaim.

The simplest solution is to always assume TTU_IGNORE_ACCESS in unmapping
code.

Link: https://lkml.kernel.org/r/20201104231928.1494083-1-shakeelb@google.com
Fixes: 369ea8242c0f ("mm/rmap: update to new mmu_notifier semantic v2")
Signed-off-by: Shakeel Butt <shakeelb@google.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jerome Glisse <jglisse@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/rmap.h |    1 -
 mm/huge_memory.c     |    2 +-
 mm/memory-failure.c  |    2 +-
 mm/memory_hotplug.c  |    2 +-
 mm/migrate.c         |    8 +++-----
 mm/rmap.c            |    9 ---------
 mm/vmscan.c          |   14 +++++---------
 7 files changed, 11 insertions(+), 27 deletions(-)

--- a/include/linux/rmap.h~mm-rmap-always-do-ttu_ignore_access
+++ a/include/linux/rmap.h
@@ -91,7 +91,6 @@ enum ttu_flags {
 
 	TTU_SPLIT_HUGE_PMD	= 0x4,	/* split huge PMD if any */
 	TTU_IGNORE_MLOCK	= 0x8,	/* ignore mlock */
-	TTU_IGNORE_ACCESS	= 0x10,	/* don't age */
 	TTU_IGNORE_HWPOISON	= 0x20,	/* corrupted page is recoverable */
 	TTU_BATCH_FLUSH		= 0x40,	/* Batch TLB flushes where possible
 					 * and caller guarantees they will
--- a/mm/huge_memory.c~mm-rmap-always-do-ttu_ignore_access
+++ a/mm/huge_memory.c
@@ -2322,7 +2322,7 @@ void vma_adjust_trans_huge(struct vm_are
 
 static void unmap_page(struct page *page)
 {
-	enum ttu_flags ttu_flags = TTU_IGNORE_MLOCK | TTU_IGNORE_ACCESS |
+	enum ttu_flags ttu_flags = TTU_IGNORE_MLOCK |
 		TTU_RMAP_LOCKED | TTU_SPLIT_HUGE_PMD;
 	bool unmap_success;
 
--- a/mm/memory-failure.c~mm-rmap-always-do-ttu_ignore_access
+++ a/mm/memory-failure.c
@@ -989,7 +989,7 @@ static int get_hwpoison_page(struct page
 static bool hwpoison_user_mappings(struct page *p, unsigned long pfn,
 				  int flags, struct page **hpagep)
 {
-	enum ttu_flags ttu = TTU_IGNORE_MLOCK | TTU_IGNORE_ACCESS;
+	enum ttu_flags ttu = TTU_IGNORE_MLOCK;
 	struct address_space *mapping;
 	LIST_HEAD(tokill);
 	bool unmap_success = true;
--- a/mm/memory_hotplug.c~mm-rmap-always-do-ttu_ignore_access
+++ a/mm/memory_hotplug.c
@@ -1304,7 +1304,7 @@ do_migrate_range(unsigned long start_pfn
 			if (WARN_ON(PageLRU(page)))
 				isolate_lru_page(page);
 			if (page_mapped(page))
-				try_to_unmap(page, TTU_IGNORE_MLOCK | TTU_IGNORE_ACCESS);
+				try_to_unmap(page, TTU_IGNORE_MLOCK);
 			continue;
 		}
 
--- a/mm/migrate.c~mm-rmap-always-do-ttu_ignore_access
+++ a/mm/migrate.c
@@ -1122,8 +1122,7 @@ static int __unmap_and_move(struct page
 		/* Establish migration ptes */
 		VM_BUG_ON_PAGE(PageAnon(page) && !PageKsm(page) && !anon_vma,
 				page);
-		try_to_unmap(page,
-			TTU_MIGRATION|TTU_IGNORE_MLOCK|TTU_IGNORE_ACCESS);
+		try_to_unmap(page, TTU_MIGRATION|TTU_IGNORE_MLOCK);
 		page_was_mapped = 1;
 	}
 
@@ -1339,8 +1338,7 @@ static int unmap_and_move_huge_page(new_
 			goto unlock_put_anon;
 
 		try_to_unmap(hpage,
-			TTU_MIGRATION|TTU_IGNORE_MLOCK|TTU_IGNORE_ACCESS|
-			TTU_RMAP_LOCKED);
+			TTU_MIGRATION|TTU_IGNORE_MLOCK|TTU_RMAP_LOCKED);
 		page_was_mapped = 1;
 		/*
 		 * Leave mapping locked until after subsequent call to
@@ -2684,7 +2682,7 @@ static void migrate_vma_prepare(struct m
  */
 static void migrate_vma_unmap(struct migrate_vma *migrate)
 {
-	int flags = TTU_MIGRATION | TTU_IGNORE_MLOCK | TTU_IGNORE_ACCESS;
+	int flags = TTU_MIGRATION | TTU_IGNORE_MLOCK;
 	const unsigned long npages = migrate->npages;
 	const unsigned long start = migrate->start;
 	unsigned long addr, i, restore = 0;
--- a/mm/rmap.c~mm-rmap-always-do-ttu_ignore_access
+++ a/mm/rmap.c
@@ -1536,15 +1536,6 @@ static bool try_to_unmap_one(struct page
 			goto discard;
 		}
 
-		if (!(flags & TTU_IGNORE_ACCESS)) {
-			if (ptep_clear_flush_young_notify(vma, address,
-						pvmw.pte)) {
-				ret = false;
-				page_vma_mapped_walk_done(&pvmw);
-				break;
-			}
-		}
-
 		/* Nuke the page table entry. */
 		flush_cache_page(vma, address, pte_pfn(*pvmw.pte));
 		if (should_defer_flush(mm, flags)) {
--- a/mm/vmscan.c~mm-rmap-always-do-ttu_ignore_access
+++ a/mm/vmscan.c
@@ -1072,7 +1072,6 @@ static void page_check_dirty_writeback(s
 static unsigned int shrink_page_list(struct list_head *page_list,
 				     struct pglist_data *pgdat,
 				     struct scan_control *sc,
-				     enum ttu_flags ttu_flags,
 				     struct reclaim_stat *stat,
 				     bool ignore_references)
 {
@@ -1297,7 +1296,7 @@ static unsigned int shrink_page_list(str
 		 * processes. Try to unmap it here.
 		 */
 		if (page_mapped(page)) {
-			enum ttu_flags flags = ttu_flags | TTU_BATCH_FLUSH;
+			enum ttu_flags flags = TTU_BATCH_FLUSH;
 			bool was_swapbacked = PageSwapBacked(page);
 
 			if (unlikely(PageTransHuge(page)))
@@ -1514,7 +1513,7 @@ unsigned int reclaim_clean_pages_from_li
 	}
 
 	nr_reclaimed = shrink_page_list(&clean_pages, zone->zone_pgdat, &sc,
-			TTU_IGNORE_ACCESS, &stat, true);
+					&stat, true);
 	list_splice(&clean_pages, page_list);
 	mod_node_page_state(zone->zone_pgdat, NR_ISOLATED_FILE,
 			    -(long)nr_reclaimed);
@@ -1958,8 +1957,7 @@ shrink_inactive_list(unsigned long nr_to
 	if (nr_taken == 0)
 		return 0;
 
-	nr_reclaimed = shrink_page_list(&page_list, pgdat, sc, 0,
-				&stat, false);
+	nr_reclaimed = shrink_page_list(&page_list, pgdat, sc, &stat, false);
 
 	spin_lock_irq(&pgdat->lru_lock);
 
@@ -2131,8 +2129,7 @@ unsigned long reclaim_pages(struct list_
 
 		nr_reclaimed += shrink_page_list(&node_page_list,
 						NODE_DATA(nid),
-						&sc, 0,
-						&dummy_stat, false);
+						&sc, &dummy_stat, false);
 		while (!list_empty(&node_page_list)) {
 			page = lru_to_page(&node_page_list);
 			list_del(&page->lru);
@@ -2145,8 +2142,7 @@ unsigned long reclaim_pages(struct list_
 	if (!list_empty(&node_page_list)) {
 		nr_reclaimed += shrink_page_list(&node_page_list,
 						NODE_DATA(nid),
-						&sc, 0,
-						&dummy_stat, false);
+						&sc, &dummy_stat, false);
 		while (!list_empty(&node_page_list)) {
 			page = lru_to_page(&node_page_list);
 			list_del(&page->lru);
_

Patches currently in -mm which might be from shakeelb@google.com are

mm-rmap-always-do-ttu_ignore_access.patch

