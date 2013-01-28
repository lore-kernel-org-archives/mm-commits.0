From: akpm@linux-foundation.org
Subject: + ksm-enable-ksm-page-migration.patch added to -mm tree
Date: Mon, 28 Jan 2013 15:51:00 -0800
Message-ID: <20130128235101.34C175A41B9@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ia0-f201.google.com ([209.85.210.201]:52210 "EHLO
	mail-ia0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753307Ab3A1XvD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 28 Jan 2013 18:51:03 -0500
Received: by mail-ia0-f201.google.com with SMTP id t4so623323iag.2
        for <mm-commits@vger.kernel.org>; Mon, 28 Jan 2013 15:51:02 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hughd@google.com, aarcange@redhat.com, gerald.schaefer@de.ibm.com, izik.eidus@ravellosystems.com, kosaki.motohiro@gmail.com, pholasek@redhat.com, riel@redhat.com


The patch titled
     Subject: ksm: enable KSM page migration
has been added to the -mm tree.  Its filename is
     ksm-enable-ksm-page-migration.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: ksm: enable KSM page migration

Migration of KSM pages is now safe: remove the PageKsm restrictions from
mempolicy.c and migrate.c.

But keep PageKsm out of __unmap_and_move()'s anon_vma contortions, which
are irrelevant to KSM: it looks as if that code was preventing hotremove
migration of KSM pages, unless they happened to be in swapcache.

There is some question as to whether enforcing a NUMA mempolicy migration
ought to migrate KSM pages, mapped into entirely unrelated processes; but
moving page_mapcount > 1 is only permitted with MPOL_MF_MOVE_ALL anyway,
and it seems reasonable to assume that you wouldn't set MADV_MERGEABLE on
any area where this is a worry.

Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Petr Holasek <pholasek@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Izik Eidus <izik.eidus@ravellosystems.com>
Cc: Gerald Schaefer <gerald.schaefer@de.ibm.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mempolicy.c |    3 +--
 mm/migrate.c   |   21 +++------------------
 2 files changed, 4 insertions(+), 20 deletions(-)

diff -puN mm/mempolicy.c~ksm-enable-ksm-page-migration mm/mempolicy.c
--- a/mm/mempolicy.c~ksm-enable-ksm-page-migration
+++ a/mm/mempolicy.c
@@ -496,9 +496,8 @@ static int check_pte_range(struct vm_are
 		/*
 		 * vm_normal_page() filters out zero pages, but there might
 		 * still be PageReserved pages to skip, perhaps in a VDSO.
-		 * And we cannot move PageKsm pages sensibly or safely yet.
 		 */
-		if (PageReserved(page) || PageKsm(page))
+		if (PageReserved(page))
 			continue;
 		nid = page_to_nid(page);
 		if (node_isset(nid, *nodes) == !!(flags & MPOL_MF_INVERT))
diff -puN mm/migrate.c~ksm-enable-ksm-page-migration mm/migrate.c
--- a/mm/migrate.c~ksm-enable-ksm-page-migration
+++ a/mm/migrate.c
@@ -731,20 +731,6 @@ static int __unmap_and_move(struct page 
 		lock_page(page);
 	}
 
-	/*
-	 * Only memory hotplug's offline_pages() caller has locked out KSM,
-	 * and can safely migrate a KSM page.  The other cases have skipped
-	 * PageKsm along with PageReserved - but it is only now when we have
-	 * the page lock that we can be certain it will not go KSM beneath us
-	 * (KSM will not upgrade a page from PageAnon to PageKsm when it sees
-	 * its pagecount raised, but only here do we take the page lock which
-	 * serializes that).
-	 */
-	if (PageKsm(page) && !offlining) {
-		rc = -EBUSY;
-		goto unlock;
-	}
-
 	/* charge against new page */
 	mem_cgroup_prepare_migration(page, newpage, &mem);
 
@@ -771,7 +757,7 @@ static int __unmap_and_move(struct page 
 	 * File Caches may use write_page() or lock_page() in migration, then,
 	 * just care Anon page here.
 	 */
-	if (PageAnon(page)) {
+	if (PageAnon(page) && !PageKsm(page)) {
 		/*
 		 * Only page_lock_anon_vma_read() understands the subtleties of
 		 * getting a hold on an anon_vma from outside one of its mms.
@@ -851,7 +837,6 @@ uncharge:
 	mem_cgroup_end_migration(mem, page, newpage,
 				 (rc == MIGRATEPAGE_SUCCESS ||
 				  rc == MIGRATEPAGE_BALLOON_SUCCESS));
-unlock:
 	unlock_page(page);
 out:
 	return rc;
@@ -1155,7 +1140,7 @@ static int do_move_page_to_node_array(st
 			goto set_status;
 
 		/* Use PageReserved to check for zero page */
-		if (PageReserved(page) || PageKsm(page))
+		if (PageReserved(page))
 			goto put_and_set;
 
 		pp->page = page;
@@ -1317,7 +1302,7 @@ static void do_pages_stat_array(struct m
 
 		err = -ENOENT;
 		/* Use PageReserved to check for zero page */
-		if (!page || PageReserved(page) || PageKsm(page))
+		if (!page || PageReserved(page))
 			goto set_status;
 
 		err = page_to_nid(page);
_

Patches currently in -mm which might be from hughd@google.com are

linux-next.patch
revert-x86-mm-make-spurious_fault-check-explicitly-check-the-present-bit.patch
pageattr-prevent-pse-and-gloabl-leftovers-to-confuse-pmd-pte_present-and-pmd_huge.patch
mm-memcg-only-evict-file-pages-when-we-have-plenty.patch
mm-vmscan-save-work-scanning-almost-empty-lru-lists.patch
mm-vmscan-clarify-how-swappiness-highest-priority-memcg-interact.patch
mm-vmscan-improve-comment-on-low-page-cache-handling.patch
mm-vmscan-clean-up-get_scan_count.patch
mm-vmscan-clean-up-get_scan_count-fix.patch
mm-vmscan-compaction-works-against-zones-not-lruvecs.patch
mm-vmscan-compaction-works-against-zones-not-lruvecs-fix.patch
mm-reduce-rmap-overhead-for-ex-ksm-page-copies-created-on-swap-faults.patch
mm-page_allocc-__setup_per_zone_wmarks-make-min_pages-unsigned-long.patch
mm-vmscanc-__zone_reclaim-replace-max_t-with-max.patch
mmksm-use-new-hashtable-implementation.patch
mm-make-madvisemadv_willneed-support-swap-file-prefetch.patch
mm-make-madvisemadv_willneed-support-swap-file-prefetch-fix.patch
mm-make-madvisemadv_willneed-support-swap-file-prefetch-fix-fix.patch
mm-avoid-calling-pgdat_balanced-needlessly.patch
mm-numa-fix-minor-typo-in-numa_next_scan.patch
mm-numa-take-thp-into-account-when-migrating-pages-for-numa-balancing.patch
mm-numa-handle-side-effects-in-count_vm_numa_events-for-config_numa_balancing.patch
mm-move-page-flags-layout-to-separate-header.patch
mm-fold-page-_last_nid-into-page-flags-where-possible.patch
mm-numa-cleanup-flow-of-transhuge-page-migration.patch
mm-dont-inline-page_mapping.patch
swap-make-each-swap-partition-have-one-address_space.patch
swap-make-each-swap-partition-have-one-address_space-fix.patch
swap-add-per-partition-lock-for-swapfile.patch
memcg-reduce-the-size-of-struct-memcg-244-fold.patch
memcg-reduce-the-size-of-struct-memcg-244-fold-fix.patch
ksm-allow-trees-per-numa-node.patch
ksm-add-sysfs-abi-documentation.patch
ksm-trivial-tidyups.patch
ksm-reorganize-ksm_check_stable_tree.patch
ksm-get_ksm_page-locked.patch
ksm-remove-old-stable-nodes-more-thoroughly.patch
ksm-make-ksm-page-migration-possible.patch
ksm-make-merge_across_nodes-migration-safe.patch
ksm-enable-ksm-page-migration.patch
mm-remove-offlining-arg-to-migrate_pages.patch
ksm-stop-hotremove-lockdep-warning.patch
mm-prevent-addition-of-pages-to-swap-if-may_writepage-is-unset.patch

