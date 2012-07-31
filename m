From: akpm@linux-foundation.org
Subject: [merged] mm-fix-wrong-argument-of-migrate_huge_pages-in-soft_offline_huge_page.patch removed from -mm tree
Date: Tue, 31 Jul 2012 11:47:35 -0700
Message-ID: <20120731184735.E19E020004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wg0-f74.google.com ([74.125.82.74]:56364 "EHLO
	mail-wg0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756205Ab2GaSri (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 31 Jul 2012 14:47:38 -0400
Received: by wgbdt11 with SMTP id dt11so290965wgb.1
        for <mm-commits@vger.kernel.org>; Tue, 31 Jul 2012 11:47:37 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: js1304@gmail.com, aneesh.kumar@linux.vnet.ibm.com, cl@linux.com, mgorman@suse.de, rientjes@google.com, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: fix wrong argument of migrate_huge_pages() in soft_offline_huge_page()
has been removed from the -mm tree.  Its filename was
     mm-fix-wrong-argument-of-migrate_huge_pages-in-soft_offline_huge_page.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joonsoo Kim <js1304@gmail.com>
Subject: mm: fix wrong argument of migrate_huge_pages() in soft_offline_huge_page()

a6bc32b899223 ("mm: compaction: introduce sync-light migration for use by
compaction") changed the declaration of migrate_pages() and
migrate_huge_pages().  But it missed changing the argument of
migrate_huge_pages() in soft_offline_huge_page().  In this case, we should
call migrate_huge_pages() with MIGRATE_SYNC.

Additionally, there is a mismatch between type the of argument and the
function declaration for migrate_pages().

Signed-off-by: Joonsoo Kim <js1304@gmail.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Mel Gorman <mgorman@suse.de>
Acked-by: David Rientjes <rientjes@google.com>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN mm/memory-failure.c~mm-fix-wrong-argument-of-migrate_huge_pages-in-soft_offline_huge_page mm/memory-failure.c
--- a/mm/memory-failure.c~mm-fix-wrong-argument-of-migrate_huge_pages-in-soft_offline_huge_page
+++ a/mm/memory-failure.c
@@ -1433,8 +1433,8 @@ static int soft_offline_huge_page(struct
 	/* Keep page count to indicate a given hugepage is isolated. */
 
 	list_add(&hpage->lru, &pagelist);
-	ret = migrate_huge_pages(&pagelist, new_page, MPOL_MF_MOVE_ALL, 0,
-				true);
+	ret = migrate_huge_pages(&pagelist, new_page, MPOL_MF_MOVE_ALL, false,
+				MIGRATE_SYNC);
 	if (ret) {
 		struct page *page1, *page2;
 		list_for_each_entry_safe(page1, page2, &pagelist, lru)
@@ -1563,7 +1563,7 @@ int soft_offline_page(struct page *page,
 					    page_is_file_cache(page));
 		list_add(&page->lru, &pagelist);
 		ret = migrate_pages(&pagelist, new_page, MPOL_MF_MOVE_ALL,
-							0, MIGRATE_SYNC);
+							false, MIGRATE_SYNC);
 		if (ret) {
 			putback_lru_pages(&pagelist);
 			pr_info("soft offline: %#lx: migration failed %d, type %lx\n",
_

Patches currently in -mm which might be from js1304@gmail.com are

origin.patch

