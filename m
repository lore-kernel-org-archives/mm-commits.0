From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged]
 mm-vmstat-add-events-for-pmd-based-thp-migration-without-split-update.patch
 removed from -mm tree
Date: Tue, 07 Jul 2020 13:11:28 -0700
Message-ID: <20200707201128.mjYv0NMAV%akpm@linux-foundation.org>
References: <20200703151445.b6a0cfee402c7c5c4651f1b1@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:41732 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726273AbgGGUL3 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 7 Jul 2020 16:11:29 -0400
In-Reply-To: <20200703151445.b6a0cfee402c7c5c4651f1b1@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: anshuman.khandual@arm.com, hughd@google.com, jhubbard@nvidia.com, mm-commits@vger.kernel.org, n-horiguchi@ah.jp.nec.com, ziy@nvidia.com


The patch titled
     Subject: mm-vmstat-add-events-for-pmd-based-thp-migration-without-split-update
has been removed from the -mm tree.  Its filename was
     mm-vmstat-add-events-for-pmd-based-thp-migration-without-split-update.patch

This patch was dropped because it was folded into mm-vmstat-add-events-for-pmd-based-thp-migration-without-split.patch

------------------------------------------------------
From: Anshuman Khandual <anshuman.khandual@arm.com>
Subject: mm-vmstat-add-events-for-pmd-based-thp-migration-without-split-update

rename thp_migration_success() to thp_pmd_migration_success() per John

Link: http://lkml.kernel.org/r/1590118444-21601-1-git-send-email-anshuman.khandual@arm.com
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |   16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

--- a/mm/migrate.c~mm-vmstat-add-events-for-pmd-based-thp-migration-without-split-update
+++ a/mm/migrate.c
@@ -1172,7 +1172,7 @@ out:
 #endif
 
 #ifdef CONFIG_ARCH_ENABLE_THP_MIGRATION
-static inline void thp_migration_success(bool success)
+static inline void thp_pmd_migration_success(bool success)
 {
 	if (success)
 		count_vm_event(THP_PMD_MIGRATION_SUCCESS);
@@ -1180,7 +1180,9 @@ static inline void thp_migration_success
 		count_vm_event(THP_PMD_MIGRATION_FAILURE);
 }
 #else
-static inline void thp_migration_success(bool success) { }
+static inline void thp_pmd_migration_success(bool success)
+{
+}
 #endif
 
 /*
@@ -1245,8 +1247,14 @@ out:
 	 * we want to retry.
 	 */
 	if (rc == MIGRATEPAGE_SUCCESS) {
+		/*
+		 * When the page to be migrated has been freed from under
+		 * us, that is considered a MIGRATEPAGE_SUCCESS, but no
+		 * newpage has been allocated. It should not be counted
+		 * as a successful THP migration.
+		 */
 		if (newpage && PageTransHuge(newpage))
-			thp_migration_success(true);
+			thp_pmd_migration_success(true);
 		put_page(page);
 		if (reason == MR_MEMORY_FAILURE) {
 			/*
@@ -1489,7 +1497,7 @@ retry:
 					unlock_page(page);
 					if (!rc) {
 						list_safe_reset_next(page, page2, lru);
-						thp_migration_success(false);
+						thp_pmd_migration_success(false);
 						goto retry;
 					}
 				}
_

Patches currently in -mm which might be from anshuman.khandual@arm.com are

mm-debug_vm_pgtable-add-tests-validating-arch-helpers-for-core-mm-features.patch
mm-debug_vm_pgtable-add-tests-validating-advanced-arch-page-table-helpers.patch
mm-debug_vm_pgtable-add-debug-prints-for-individual-tests.patch
documentation-mm-add-descriptions-for-arch-page-table-helpers.patch
mm-vmstat-add-events-for-pmd-based-thp-migration-without-split.patch
