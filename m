From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated]
 mm-vmstat-add-events-for-pmd-based-thp-migration-without-split.patch
 removed from -mm tree
Date: Tue, 07 Jul 2020 13:12:25 -0700
Message-ID: <20200707201225.x1hXmBB2f%akpm@linux-foundation.org>
References: <20200703151445.b6a0cfee402c7c5c4651f1b1@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:41996 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726763AbgGGUM0 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 7 Jul 2020 16:12:26 -0400
In-Reply-To: <20200703151445.b6a0cfee402c7c5c4651f1b1@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, anshuman.khandual@arm.com, cai@lca.pw, daniel.m.jordan@oracle.com, hannes@cmpxchg.org, hughd@google.com, jhubbard@nvidia.com, kirill.shutemov@linux.intel.com, mhocko@suse.com, mm-commits@vger.kernel.org, n-horiguchi@ah.jp.nec.com, yang.shi@linux.alibaba.com, ziy@nvidia.com


The patch titled
     Subject: mm/vmstat: add events for PMD based THP migration without split
has been removed from the -mm tree.  Its filename was
     mm-vmstat-add-events-for-pmd-based-thp-migration-without-split.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Anshuman Khandual <anshuman.khandual@arm.com>
Subject: mm/vmstat: add events for PMD based THP migration without split

This adds the following two new VM events which will help in validating
PMD based THP migration without split.  Statistics reported through these
events will help in performance debugging.

1. THP_PMD_MIGRATION_SUCCESS
2. THP_PMD_MIGRATION_FAILURE

[hughd@google.com: fix page migration crash in unmap_and_move()]
  Link: http://lkml.kernel.org/r/alpine.LSU.2.11.2005210643340.482@eggly.anvils
[anshuman.khandual@arm.com: rename thp_migration_success() to thp_pmd_migration_success() per John]
  Link: http://lkml.kernel.org/r/1590118444-21601-1-git-send-email-anshuman.khandual@arm.com
Link: http://lkml.kernel.org/r/1589784156-28831-1-git-send-email-anshuman.khandual@arm.com
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Qian Cai <cai@lca.pw>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Yang Shi <yang.shi@linux.alibaba.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Daniel Jordan <daniel.m.jordan@oracle.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/vm_event_item.h |    4 ++++
 mm/migrate.c                  |   23 +++++++++++++++++++++++
 mm/vmstat.c                   |    4 ++++
 3 files changed, 31 insertions(+)

--- a/include/linux/vm_event_item.h~mm-vmstat-add-events-for-pmd-based-thp-migration-without-split
+++ a/include/linux/vm_event_item.h
@@ -95,6 +95,10 @@ enum vm_event_item { PGPGIN, PGPGOUT, PS
 		THP_ZERO_PAGE_ALLOC_FAILED,
 		THP_SWPOUT,
 		THP_SWPOUT_FALLBACK,
+#ifdef CONFIG_ARCH_ENABLE_THP_MIGRATION
+		THP_PMD_MIGRATION_SUCCESS,
+		THP_PMD_MIGRATION_FAILURE,
+#endif
 #endif
 #ifdef CONFIG_MEMORY_BALLOON
 		BALLOON_INFLATE,
--- a/mm/migrate.c~mm-vmstat-add-events-for-pmd-based-thp-migration-without-split
+++ a/mm/migrate.c
@@ -1171,6 +1171,20 @@ out:
 #define ICE_noinline
 #endif
 
+#ifdef CONFIG_ARCH_ENABLE_THP_MIGRATION
+static inline void thp_pmd_migration_success(bool success)
+{
+	if (success)
+		count_vm_event(THP_PMD_MIGRATION_SUCCESS);
+	else
+		count_vm_event(THP_PMD_MIGRATION_FAILURE);
+}
+#else
+static inline void thp_pmd_migration_success(bool success)
+{
+}
+#endif
+
 /*
  * Obtain the lock on page, remove all ptes and migrate the page
  * to the newly allocated page in newpage.
@@ -1233,6 +1247,14 @@ out:
 	 * we want to retry.
 	 */
 	if (rc == MIGRATEPAGE_SUCCESS) {
+		/*
+		 * When the page to be migrated has been freed from under
+		 * us, that is considered a MIGRATEPAGE_SUCCESS, but no
+		 * newpage has been allocated. It should not be counted
+		 * as a successful THP migration.
+		 */
+		if (newpage && PageTransHuge(newpage))
+			thp_pmd_migration_success(true);
 		put_page(page);
 		if (reason == MR_MEMORY_FAILURE) {
 			/*
@@ -1475,6 +1497,7 @@ retry:
 					unlock_page(page);
 					if (!rc) {
 						list_safe_reset_next(page, page2, lru);
+						thp_pmd_migration_success(false);
 						goto retry;
 					}
 				}
--- a/mm/vmstat.c~mm-vmstat-add-events-for-pmd-based-thp-migration-without-split
+++ a/mm/vmstat.c
@@ -1320,6 +1320,10 @@ const char * const vmstat_text[] = {
 	"thp_zero_page_alloc_failed",
 	"thp_swpout",
 	"thp_swpout_fallback",
+#ifdef CONFIG_ARCH_ENABLE_THP_MIGRATION
+	"thp_pmd_migration_success",
+	"thp_pmd_migration_failure",
+#endif
 #endif
 #ifdef CONFIG_MEMORY_BALLOON
 	"balloon_inflate",
_

Patches currently in -mm which might be from anshuman.khandual@arm.com are

mm-debug_vm_pgtable-add-tests-validating-arch-helpers-for-core-mm-features.patch
mm-debug_vm_pgtable-add-tests-validating-advanced-arch-page-table-helpers.patch
mm-debug_vm_pgtable-add-debug-prints-for-individual-tests.patch
documentation-mm-add-descriptions-for-arch-page-table-helpers.patch
