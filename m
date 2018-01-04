From: akpm@linux-foundation.org
Subject: + mm-migrate-remove-reason-argument-from-new_page_t.patch added
 to -mm tree
Date: Wed, 03 Jan 2018 16:04:45 -0800
Message-ID: <5a4d6f9d.W6gncXunCpXZMtbb%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36024 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751014AbeADAEq (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 3 Jan 2018 19:04:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.com, ar@linux.vnet.ibm.com, khandual@linux.vnet.ibm.com, kirill.shutemov@linux.intel.com, mike.kravetz@oracle.com, n-horiguchi@ah.jp.nec.com, vbabka@suse.cz, zi.yan@cs.rutgers.edu, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, migrate: remove reason argument from new_page_t
has been added to the -mm tree.  Its filename is
     mm-migrate-remove-reason-argument-from-new_page_t.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-migrate-remove-reason-argument-from-new_page_t.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-migrate-remove-reason-argument-from-new_page_t.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Michal Hocko <mhocko@suse.com>
Subject: mm, migrate: remove reason argument from new_page_t

No allocation callback is using this argument anymore.  new_page_node used
to use this parameter to convey node_id resp.  migration error up to
move_pages code (do_move_page_to_node_array).  The error status never made
it into the final status field and we have a better way to communicate
node id to the status field now.  All other allocation callbacks simply
ignored the argument so we can drop it finally.

Link: http://lkml.kernel.org/r/20180103082555.14592-3-mhocko@kernel.org
Signed-off-by: Michal Hocko <mhocko@suse.com>
Reviewed-by: Zi Yan <zi.yan@cs.rutgers.edu>
Cc: Andrea Reale <ar@linux.vnet.ibm.com>
Cc: Anshuman Khandual <khandual@linux.vnet.ibm.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/migrate.h        |    3 +--
 include/linux/page-isolation.h |    3 +--
 mm/compaction.c                |    3 +--
 mm/internal.h                  |    2 +-
 mm/memory_hotplug.c            |    3 +--
 mm/mempolicy.c                 |    6 +++---
 mm/migrate.c                   |   18 ++----------------
 mm/page_isolation.c            |    3 +--
 8 files changed, 11 insertions(+), 30 deletions(-)

diff -puN include/linux/migrate.h~mm-migrate-remove-reason-argument-from-new_page_t include/linux/migrate.h
--- a/include/linux/migrate.h~mm-migrate-remove-reason-argument-from-new_page_t
+++ a/include/linux/migrate.h
@@ -7,8 +7,7 @@
 #include <linux/migrate_mode.h>
 #include <linux/hugetlb.h>
 
-typedef struct page *new_page_t(struct page *page, unsigned long private,
-				int **reason);
+typedef struct page *new_page_t(struct page *page, unsigned long private);
 typedef void free_page_t(struct page *page, unsigned long private);
 
 /*
diff -puN include/linux/page-isolation.h~mm-migrate-remove-reason-argument-from-new_page_t include/linux/page-isolation.h
--- a/include/linux/page-isolation.h~mm-migrate-remove-reason-argument-from-new_page_t
+++ a/include/linux/page-isolation.h
@@ -63,7 +63,6 @@ undo_isolate_page_range(unsigned long st
 int test_pages_isolated(unsigned long start_pfn, unsigned long end_pfn,
 			bool skip_hwpoisoned_pages);
 
-struct page *alloc_migrate_target(struct page *page, unsigned long private,
-				int **resultp);
+struct page *alloc_migrate_target(struct page *page, unsigned long private);
 
 #endif
diff -puN mm/compaction.c~mm-migrate-remove-reason-argument-from-new_page_t mm/compaction.c
--- a/mm/compaction.c~mm-migrate-remove-reason-argument-from-new_page_t
+++ a/mm/compaction.c
@@ -1165,8 +1165,7 @@ static void isolate_freepages(struct com
  * from the isolated freelists in the block we are migrating to.
  */
 static struct page *compaction_alloc(struct page *migratepage,
-					unsigned long data,
-					int **result)
+					unsigned long data)
 {
 	struct compact_control *cc = (struct compact_control *)data;
 	struct page *freepage;
diff -puN mm/internal.h~mm-migrate-remove-reason-argument-from-new_page_t mm/internal.h
--- a/mm/internal.h~mm-migrate-remove-reason-argument-from-new_page_t
+++ a/mm/internal.h
@@ -540,5 +540,5 @@ static inline bool is_migrate_highatomic
 }
 
 void setup_zone_pageset(struct zone *zone);
-extern struct page *alloc_new_node_page(struct page *page, unsigned long node, int **x);
+extern struct page *alloc_new_node_page(struct page *page, unsigned long node);
 #endif	/* __MM_INTERNAL_H */
diff -puN mm/memory_hotplug.c~mm-migrate-remove-reason-argument-from-new_page_t mm/memory_hotplug.c
--- a/mm/memory_hotplug.c~mm-migrate-remove-reason-argument-from-new_page_t
+++ a/mm/memory_hotplug.c
@@ -1344,8 +1344,7 @@ static unsigned long scan_movable_pages(
 	return 0;
 }
 
-static struct page *new_node_page(struct page *page, unsigned long private,
-		int **result)
+static struct page *new_node_page(struct page *page, unsigned long private)
 {
 	int nid = page_to_nid(page);
 	nodemask_t nmask = node_states[N_MEMORY];
diff -puN mm/mempolicy.c~mm-migrate-remove-reason-argument-from-new_page_t mm/mempolicy.c
--- a/mm/mempolicy.c~mm-migrate-remove-reason-argument-from-new_page_t
+++ a/mm/mempolicy.c
@@ -943,7 +943,7 @@ static void migrate_page_add(struct page
 }
 
 /* page allocation callback for NUMA node migration */
-struct page *alloc_new_node_page(struct page *page, unsigned long node, int **x)
+struct page *alloc_new_node_page(struct page *page, unsigned long node)
 {
 	if (PageHuge(page))
 		return alloc_huge_page_node(page_hstate(compound_head(page)),
@@ -1108,7 +1108,7 @@ int do_migrate_pages(struct mm_struct *m
  * list of pages handed to migrate_pages()--which is how we get here--
  * is in virtual address order.
  */
-static struct page *new_page(struct page *page, unsigned long start, int **x)
+static struct page *new_page(struct page *page, unsigned long start)
 {
 	struct vm_area_struct *vma;
 	unsigned long uninitialized_var(address);
@@ -1153,7 +1153,7 @@ int do_migrate_pages(struct mm_struct *m
 	return -ENOSYS;
 }
 
-static struct page *new_page(struct page *page, unsigned long start, int **x)
+static struct page *new_page(struct page *page, unsigned long start)
 {
 	return NULL;
 }
diff -puN mm/migrate.c~mm-migrate-remove-reason-argument-from-new_page_t mm/migrate.c
--- a/mm/migrate.c~mm-migrate-remove-reason-argument-from-new_page_t
+++ a/mm/migrate.c
@@ -1136,10 +1136,9 @@ static ICE_noinline int unmap_and_move(n
 				   enum migrate_reason reason)
 {
 	int rc = MIGRATEPAGE_SUCCESS;
-	int *result = NULL;
 	struct page *newpage;
 
-	newpage = get_new_page(page, private, &result);
+	newpage = get_new_page(page, private);
 	if (!newpage)
 		return -ENOMEM;
 
@@ -1230,12 +1229,6 @@ put_new:
 			put_page(newpage);
 	}
 
-	if (result) {
-		if (rc)
-			*result = rc;
-		else
-			*result = page_to_nid(newpage);
-	}
 	return rc;
 }
 
@@ -1263,7 +1256,6 @@ static int unmap_and_move_huge_page(new_
 				enum migrate_mode mode, int reason)
 {
 	int rc = -EAGAIN;
-	int *result = NULL;
 	int page_was_mapped = 0;
 	struct page *new_hpage;
 	struct anon_vma *anon_vma = NULL;
@@ -1280,7 +1272,7 @@ static int unmap_and_move_huge_page(new_
 		return -ENOSYS;
 	}
 
-	new_hpage = get_new_page(hpage, private, &result);
+	new_hpage = get_new_page(hpage, private);
 	if (!new_hpage)
 		return -ENOMEM;
 
@@ -1345,12 +1337,6 @@ out:
 	else
 		putback_active_hugepage(new_hpage);
 
-	if (result) {
-		if (rc)
-			*result = rc;
-		else
-			*result = page_to_nid(new_hpage);
-	}
 	return rc;
 }
 
diff -puN mm/page_isolation.c~mm-migrate-remove-reason-argument-from-new_page_t mm/page_isolation.c
--- a/mm/page_isolation.c~mm-migrate-remove-reason-argument-from-new_page_t
+++ a/mm/page_isolation.c
@@ -293,8 +293,7 @@ int test_pages_isolated(unsigned long st
 	return pfn < end_pfn ? -EBUSY : 0;
 }
 
-struct page *alloc_migrate_target(struct page *page, unsigned long private,
-				  int **resultp)
+struct page *alloc_migrate_target(struct page *page, unsigned long private)
 {
 	return new_page_nodemask(page, numa_node_id(), &node_states[N_MEMORY]);
 }
_

Patches currently in -mm which might be from mhocko@suse.com are

mm-drop-hotplug-lock-from-lru_add_drain_all.patch
mm-hugetlb-drop-hugepages_treat_as_movable-sysctl.patch
mm-introduce-map_fixed_safe.patch
fs-elf-drop-map_fixed-usage-from-elf_map.patch
mm-numa-rework-do_pages_move.patch
mm-migrate-remove-reason-argument-from-new_page_t.patch
mm-unclutter-thp-migration.patch
mm-hugetlb-unify-core-page-allocation-accounting-and-initialization.patch
mm-hugetlb-integrate-giga-hugetlb-more-naturally-to-the-allocation-path.patch
mm-hugetlb-do-not-rely-on-overcommit-limit-during-migration.patch
mm-hugetlb-get-rid-of-surplus-page-accounting-tricks.patch
mm-hugetlb-further-simplify-hugetlb-allocation-api.patch
hugetlb-mempolicy-fix-the-mbind-hugetlb-migration.patch

