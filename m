From: Andrew Morton <akpm@linux-foundation.org>
Subject: +
 mm-vmstat-add-events-for-pmd-based-thp-migration-without-split-update.patch
 added to -mm tree
Date: Fri, 22 May 2020 17:51:02 -0700
Message-ID: <20200523005102.zAEInKoi9%akpm@linux-foundation.org>
References: <20200513175005.1f4839360c18c0238df292d1@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:48692 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731169AbgEWAvD (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 22 May 2020 20:51:03 -0400
In-Reply-To: <20200513175005.1f4839360c18c0238df292d1@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: anshuman.khandual@arm.com, hughd@google.com, jhubbard@nvidia.com, mm-commits@vger.kernel.org, n-horiguchi@ah.jp.nec.com, ziy@nvidia.com


The patch titled
     Subject: mm-vmstat-add-events-for-pmd-based-thp-migration-without-split-update
has been added to the -mm tree.  Its filename is
     mm-vmstat-add-events-for-pmd-based-thp-migration-without-split-update.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-vmstat-add-events-for-pmd-based-thp-migration-without-split-update.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-vmstat-add-events-for-pmd-based-thp-migration-without-split-update.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -1173,7 +1173,7 @@ out:
 #endif
 
 #ifdef CONFIG_ARCH_ENABLE_THP_MIGRATION
-static inline void thp_migration_success(bool success)
+static inline void thp_pmd_migration_success(bool success)
 {
 	if (success)
 		count_vm_event(THP_PMD_MIGRATION_SUCCESS);
@@ -1181,7 +1181,9 @@ static inline void thp_migration_success
 		count_vm_event(THP_PMD_MIGRATION_FAILURE);
 }
 #else
-static inline void thp_migration_success(bool success) { }
+static inline void thp_pmd_migration_success(bool success)
+{
+}
 #endif
 
 /*
@@ -1246,8 +1248,14 @@ out:
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
@@ -1490,7 +1498,7 @@ retry:
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

mm-page_alloc-restrict-and-formalize-compound_page_dtors.patch
arm64-mm-drop-__have_arch_huge_ptep_get.patch
mm-hugetlb-define-a-generic-fallback-for-is_hugepage_only_range.patch
mm-hugetlb-define-a-generic-fallback-for-arch_clear_hugepage_flags.patch
powerpc-mm-drop-platform-defined-pmd_mknotpresent.patch
mm-thp-rename-pmd_mknotpresent-as-pmd_mknotvalid.patch
mm-thp-rename-pmd_mknotpresent-as-pmd_mkinvalid-v2.patch
mm-vmstat-add-events-for-pmd-based-thp-migration-without-split.patch
mm-vmstat-add-events-for-pmd-based-thp-migration-without-split-update.patch
x86-mm-define-mm_p4d_folded.patch
mm-debug-add-tests-validating-architecture-page-table-helpers.patch
mm-debug-add-tests-validating-architecture-page-table-helpers-v17.patch
mm-debug-add-tests-validating-architecture-page-table-helpers-v18.patch
