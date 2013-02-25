From: akpm@linux-foundation.org
Subject: [merged] ksm-enable-ksm-page-migration.patch removed from -mm tree
Date: Mon, 25 Feb 2013 12:54:08 -0800
Message-ID: <20130225205408.C532031C1FC@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f74.google.com ([209.85.213.74]:61341 "EHLO
	mail-yh0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754479Ab3BYUyK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 25 Feb 2013 15:54:10 -0500
Received: by mail-yh0-f74.google.com with SMTP id z6so348375yhz.1
        for <mm-commits@vger.kernel.org>; Mon, 25 Feb 2013 12:54:09 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hughd@google.com, aarcange@redhat.com, gerald.schaefer@de.ibm.com, izik.eidus@ravellosystems.com, kosaki.motohiro@gmail.com, pholasek@redhat.com, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ksm: enable KSM page migration
has been removed from the -mm tree.  Its filename was
     ksm-enable-ksm-page-migration.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
revert-x86-mm-make-spurious_fault-check-explicitly-check-the-present-bit.patch
pageattr-prevent-pse-and-gloabl-leftovers-to-confuse-pmd-pte_present-and-pmd_huge.patch
mm-accelerate-munlock-treatment-of-thp-pages.patch

