From: akpm@linux-foundation.org
Subject: + mm-migrate-move_pages-supports-thp-migration.patch added to -mm tree
Date: Tue, 18 Jul 2017 15:27:23 -0700
Message-ID: <596e8b4b.0SmvN4pQ+/BNmJaH%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49996 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752481AbdGRW1Y (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 18 Jul 2017 18:27:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: n-horiguchi@ah.jp.nec.com, aarcange@redhat.com, dave.hansen@intel.com, dnellans@nvidia.com, hpa@zytor.com, khandual@linux.vnet.ibm.com, kirill.shutemov@linux.intel.com, mgorman@techsingularity.net, minchan@kernel.org, mingo@elte.hu, tglx@linutronix.de, vbabka@suse.cz, zi.yan@cs.rutgers.edu, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: migrate: move_pages() supports thp migration
has been added to the -mm tree.  Its filename is
     mm-migrate-move_pages-supports-thp-migration.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-migrate-move_pages-supports-thp-migration.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-migrate-move_pages-supports-thp-migration.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Subject: mm: migrate: move_pages() supports thp migration

This patch enables thp migration for move_pages(2).

Link: http://lkml.kernel.org/r/20170717193955.20207-10-zi.yan@sent.com
Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Signed-off-by: Zi Yan <zi.yan@cs.rutgers.edu>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Anshuman Khandual <khandual@linux.vnet.ibm.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: David Nellans <dnellans@nvidia.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |   45 ++++++++++++++++++++++++++++++++-------------
 1 file changed, 32 insertions(+), 13 deletions(-)

diff -puN mm/migrate.c~mm-migrate-move_pages-supports-thp-migration mm/migrate.c
--- a/mm/migrate.c~mm-migrate-move_pages-supports-thp-migration
+++ a/mm/migrate.c
@@ -184,8 +184,8 @@ void putback_movable_pages(struct list_h
 			unlock_page(page);
 			put_page(page);
 		} else {
-			dec_node_page_state(page, NR_ISOLATED_ANON +
-					page_is_file_cache(page));
+			mod_node_page_state(page_pgdat(page), NR_ISOLATED_ANON +
+					page_is_file_cache(page), -hpage_nr_pages(page));
 			putback_lru_page(page);
 		}
 	}
@@ -1145,8 +1145,8 @@ out:
 		 * as __PageMovable
 		 */
 		if (likely(!__PageMovable(page)))
-			dec_node_page_state(page, NR_ISOLATED_ANON +
-					page_is_file_cache(page));
+			mod_node_page_state(page_pgdat(page), NR_ISOLATED_ANON +
+					page_is_file_cache(page), -hpage_nr_pages(page));
 	}
 
 	/*
@@ -1420,7 +1420,17 @@ static struct page *new_page_node(struct
 	if (PageHuge(p))
 		return alloc_huge_page_node(page_hstate(compound_head(p)),
 					pm->node);
-	else
+	else if (thp_migration_supported() && PageTransHuge(p)) {
+		struct page *thp;
+
+		thp = alloc_pages_node(pm->node,
+			(GFP_TRANSHUGE | __GFP_THISNODE) & ~__GFP_RECLAIM,
+			HPAGE_PMD_ORDER);
+		if (!thp)
+			return NULL;
+		prep_transhuge_page(thp);
+		return thp;
+	} else
 		return __alloc_pages_node(pm->node,
 				GFP_HIGHUSER_MOVABLE | __GFP_THISNODE, 0);
 }
@@ -1447,6 +1457,8 @@ static int do_move_page_to_node_array(st
 	for (pp = pm; pp->node != MAX_NUMNODES; pp++) {
 		struct vm_area_struct *vma;
 		struct page *page;
+		struct page *head;
+		unsigned int follflags;
 
 		err = -EFAULT;
 		vma = find_vma(mm, pp->addr);
@@ -1454,8 +1466,10 @@ static int do_move_page_to_node_array(st
 			goto set_status;
 
 		/* FOLL_DUMP to ignore special (like zero) pages */
-		page = follow_page(vma, pp->addr,
-				FOLL_GET | FOLL_SPLIT | FOLL_DUMP);
+		follflags = FOLL_GET | FOLL_DUMP;
+		if (!thp_migration_supported())
+			follflags |= FOLL_SPLIT;
+		page = follow_page(vma, pp->addr, follflags);
 
 		err = PTR_ERR(page);
 		if (IS_ERR(page))
@@ -1465,7 +1479,6 @@ static int do_move_page_to_node_array(st
 		if (!page)
 			goto set_status;
 
-		pp->page = page;
 		err = page_to_nid(page);
 
 		if (err == pp->node)
@@ -1480,16 +1493,22 @@ static int do_move_page_to_node_array(st
 			goto put_and_set;
 
 		if (PageHuge(page)) {
-			if (PageHead(page))
+			if (PageHead(page)) {
 				isolate_huge_page(page, &pagelist);
+				err = 0;
+				pp->page = page;
+			}
 			goto put_and_set;
 		}
 
-		err = isolate_lru_page(page);
+		pp->page = compound_head(page);
+		head = compound_head(page);
+		err = isolate_lru_page(head);
 		if (!err) {
-			list_add_tail(&page->lru, &pagelist);
-			inc_node_page_state(page, NR_ISOLATED_ANON +
-					    page_is_file_cache(page));
+			list_add_tail(&head->lru, &pagelist);
+			mod_node_page_state(page_pgdat(head),
+				NR_ISOLATED_ANON + page_is_file_cache(head),
+				hpage_nr_pages(head));
 		}
 put_and_set:
 		/*
_

Patches currently in -mm which might be from n-horiguchi@ah.jp.nec.com are

mm-mempolicy-add-queue_pages_required.patch
mm-x86-move-_page_swp_soft_dirty-from-bit-7-to-bit-1.patch
mm-thp-introduce-separate-ttu-flag-for-thp-freezing.patch
mm-thp-introduce-config_arch_enable_thp_migration.patch
mm-soft-dirty-keep-soft-dirty-bits-over-thp-migration.patch
mm-mempolicy-mbind-and-migrate_pages-support-thp-migration.patch
mm-migrate-move_pages-supports-thp-migration.patch
mm-memory_hotplug-memory-hotremove-supports-thp-migration.patch

