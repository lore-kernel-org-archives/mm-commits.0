From: akpm@linux-foundation.org
Subject: + mm-compaction-use-async-migration-for-__gfp_no_kswapd-and-enforce-no-writeback.patch added to -mm tree
Date: Tue, 22 Mar 2011 14:53:13 -0700
Message-ID: <201103222153.p2MLrD0x029642@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34686 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932391Ab1CVVyD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 22 Mar 2011 17:54:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: aarcange@redhat.com, arthur.marsh@internode.on.net, cladisch@googlemail.com, hannes@cmpxchg.org, kamezawa.hiroyu@jp.fujitsu.com, mel@csn.ul.ie, minchan.kim@gmail.com


The patch titled
     mm: compaction: Use async migration for __GFP_NO_KSWAPD and enforce no writeback
has been added to the -mm tree.  Its filename is
     mm-compaction-use-async-migration-for-__gfp_no_kswapd-and-enforce-no-writeback.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: compaction: Use async migration for __GFP_NO_KSWAPD and enforce no writeback
From: Andrea Arcangeli <aarcange@redhat.com>

__GFP_NO_KSWAPD allocations are usually very expensive and not mandatory
to succeed as they have graceful fallback.  Waiting for I/O in those,
tends to be overkill in terms of latencies, so we can reduce their latency
by disabling sync migrate.

Unfortunately, even with async migration it's still possible for the
process to be blocked waiting for a request slot (e.g.  get_request_wait
in the block layer) when ->writepage is called.  To prevent
__GFP_NO_KSWAPD blocking, this patch prevents ->writepage being called on
dirty page cache for asynchronous migration.

[mel@csn.ul.ie: Avoid writebacks for NFS, retry locked pages, use bool]
Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Mel Gorman <mel@csn.ul.ie>
Cc: Arthur Marsh <arthur.marsh@internode.on.net>
Cc: Clemens Ladisch <cladisch@googlemail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Minchan Kim <minchan.kim@gmail.com>
Signed-off-by: Andrew Morton <>
---

 mm/migrate.c    |   48 +++++++++++++++++++++++++++++++---------------
 mm/page_alloc.c |    2 -
 2 files changed, 34 insertions(+), 16 deletions(-)

diff -puN mm/migrate.c~mm-compaction-use-async-migration-for-__gfp_no_kswapd-and-enforce-no-writeback mm/migrate.c
--- a/mm/migrate.c~mm-compaction-use-async-migration-for-__gfp_no_kswapd-and-enforce-no-writeback
+++ a/mm/migrate.c
@@ -564,7 +564,7 @@ static int fallback_migrate_page(struct 
  *  == 0 - success
  */
 static int move_to_new_page(struct page *newpage, struct page *page,
-						int remap_swapcache)
+					int remap_swapcache, bool sync)
 {
 	struct address_space *mapping;
 	int rc;
@@ -586,18 +586,28 @@ static int move_to_new_page(struct page 
 	mapping = page_mapping(page);
 	if (!mapping)
 		rc = migrate_page(mapping, newpage, page);
-	else if (mapping->a_ops->migratepage)
+	else {
 		/*
-		 * Most pages have a mapping and most filesystems
-		 * should provide a migration function. Anonymous
-		 * pages are part of swap space which also has its
-		 * own migration function. This is the most common
-		 * path for page migration.
+		 * Do not writeback pages if !sync and migratepage is
+		 * not pointing to migrate_page() which is nonblocking
+		 * (swapcache/tmpfs uses migratepage = migrate_page).
 		 */
-		rc = mapping->a_ops->migratepage(mapping,
-						newpage, page);
-	else
-		rc = fallback_migrate_page(mapping, newpage, page);
+		if (PageDirty(page) && !sync &&
+		    mapping->a_ops->migratepage != migrate_page)
+			rc = -EBUSY;
+		else if (mapping->a_ops->migratepage)
+			/*
+			 * Most pages have a mapping and most filesystems
+			 * should provide a migration function. Anonymous
+			 * pages are part of swap space which also has its
+			 * own migration function. This is the most common
+			 * path for page migration.
+			 */
+			rc = mapping->a_ops->migratepage(mapping,
+							newpage, page);
+		else
+			rc = fallback_migrate_page(mapping, newpage, page);
+	}
 
 	if (rc) {
 		newpage->mapping = NULL;
@@ -641,7 +651,7 @@ static int unmap_and_move(new_page_t get
 	rc = -EAGAIN;
 
 	if (!trylock_page(page)) {
-		if (!force)
+		if (!force || !sync)
 			goto move_newpage;
 
 		/*
@@ -686,7 +696,15 @@ static int unmap_and_move(new_page_t get
 	BUG_ON(charge);
 
 	if (PageWriteback(page)) {
-		if (!force || !sync)
+		/*
+		 * For !sync, there is no point retrying as the retry loop
+		 * is expected to be too short for PageWriteback to be cleared
+		 */
+		if (!sync) {
+			rc = -EBUSY;
+			goto uncharge;
+		}
+		if (!force)
 			goto uncharge;
 		wait_on_page_writeback(page);
 	}
@@ -757,7 +775,7 @@ static int unmap_and_move(new_page_t get
 
 skip_unmap:
 	if (!page_mapped(page))
-		rc = move_to_new_page(newpage, page, remap_swapcache);
+		rc = move_to_new_page(newpage, page, remap_swapcache, sync);
 
 	if (rc && remap_swapcache)
 		remove_migration_ptes(page, page);
@@ -850,7 +868,7 @@ static int unmap_and_move_huge_page(new_
 	try_to_unmap(hpage, TTU_MIGRATION|TTU_IGNORE_MLOCK|TTU_IGNORE_ACCESS);
 
 	if (!page_mapped(hpage))
-		rc = move_to_new_page(new_hpage, hpage, 1);
+		rc = move_to_new_page(new_hpage, hpage, 1, sync);
 
 	if (rc)
 		remove_migration_ptes(hpage, hpage);
diff -puN mm/page_alloc.c~mm-compaction-use-async-migration-for-__gfp_no_kswapd-and-enforce-no-writeback mm/page_alloc.c
--- a/mm/page_alloc.c~mm-compaction-use-async-migration-for-__gfp_no_kswapd-and-enforce-no-writeback
+++ a/mm/page_alloc.c
@@ -2103,7 +2103,7 @@ rebalance:
 					sync_migration);
 	if (page)
 		goto got_pg;
-	sync_migration = true;
+	sync_migration = !(gfp_mask & __GFP_NO_KSWAPD);
 
 	/* Try direct reclaim and then allocating */
 	page = __alloc_pages_direct_reclaim(gfp_mask, order,
_

Patches currently in -mm which might be from aarcange@redhat.com are

origin.patch
mm-compaction-prevent-kswapd-compacting-memory-to-reduce-cpu-usage.patch
mm-compaction-check-migrate_pagess-return-value-instead-of-list_empty.patch
mm-deactivate-invalidated-pages.patch
memcg-move-memcg-reclaimable-page-into-tail-of-inactive-list.patch
memcg-move-memcg-reclaimable-page-into-tail-of-inactive-list-fix.patch
mm-reclaim-invalidated-page-asap.patch
pagewalk-only-split-huge-pages-when-necessary.patch
smaps-break-out-smaps_pte_entry-from-smaps_pte_range.patch
smaps-pass-pte-size-argument-in-to-smaps_pte_entry.patch
smaps-teach-smaps_pte_range-about-thp-pmds.patch
smaps-have-smaps-show-transparent-huge-pages.patch
mm-vmscan-kswapd-should-not-free-an-excessive-number-of-pages-when-balancing-small-zones.patch
mm-compaction-minimise-the-time-irqs-are-disabled-while-isolating-free-pages.patch
mm-compaction-minimise-the-time-irqs-are-disabled-while-isolating-pages-for-migration.patch
mm-compaction-minimise-the-time-irqs-are-disabled-while-isolating-pages-for-migration-fix.patch
mm-compaction-use-async-migration-for-__gfp_no_kswapd-and-enforce-no-writeback.patch
mm-add-__gfp_other_node-flag.patch
mm-use-__gfp_other_node-for-transparent-huge-pages.patch
ksm-add-vm_stat-and-meminfo-entry-to-reflect-pte-mapping-to-ksm-pages.patch
ksm-add-vm_stat-and-meminfo-entry-to-reflect-pte-mapping-to-ksm-pages-fix.patch
ksm-add-vm_stat-and-meminfo-entry-to-reflect-pte-mapping-to-ksm-pages-fix-fix.patch
ksm-add-vm_stat-and-meminfo-entry-to-reflect-pte-mapping-to-ksm-pages-fix-fix-fix.patch
mm-add-vm-counters-for-transparent-hugepages.patch
memcg-use-native-word-page-statistics-counters-fix-event-counter-breakage-with-thp.patch

