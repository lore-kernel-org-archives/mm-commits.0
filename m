From: akpm@linux-foundation.org
Subject: + mm-fix-wrong-argument-of-migrate_huge_pages-in-soft_offline_huge_page.patch added to -mm tree
Date: Wed, 18 Jul 2012 15:15:00 -0700
Message-ID: <20120718221501.1B4B320004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lb0-f202.google.com ([209.85.217.202]:33401 "EHLO
	mail-lb0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752043Ab2GRWPE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 18 Jul 2012 18:15:04 -0400
Received: by lbbgp10 with SMTP id gp10so114070lbb.1
        for <mm-commits@vger.kernel.org>; Wed, 18 Jul 2012 15:15:02 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: js1304@gmail.com, aneesh.kumar@linux.vnet.ibm.com, cl@linux.com, mgorman@suse.de, rientjes@google.com


The patch titled
     Subject: mm: fix wrong argument of migrate_huge_pages() in soft_offline_huge_page()
has been added to the -mm tree.  Its filename is
     mm-fix-wrong-argument-of-migrate_huge_pages-in-soft_offline_huge_page.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Subject: Subject: mm: fix wrong argument of migrate_huge_pages() in soft_offline_huge_page()

Patches currently in -mm which might be from js1304@gmail.com are

linux-next.patch
mm-fix-wrong-argument-of-migrate_huge_pages-in-soft_offline_huge_page.patch

