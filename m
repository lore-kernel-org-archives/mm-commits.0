From: Andrew Morton <akpm@linux-foundation.org>
Subject: +
 mm-vmstat-add-events-for-pmd-based-thp-migration-without-split.patch added
 to -mm tree
Date: Mon, 18 May 2020 13:34:23 -0700
Message-ID: <20200518203423.MPBp5PFKR%akpm@linux-foundation.org>
References: <20200513175005.1f4839360c18c0238df292d1@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:56742 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726250AbgERUe0 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 18 May 2020 16:34:26 -0400
In-Reply-To: <20200513175005.1f4839360c18c0238df292d1@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, anshuman.khandual@arm.com, cai@lca.pw, daniel.m.jordan@oracle.com, hannes@cmpxchg.org, jhubbard@nvidia.com, kirill.shutemov@linux.intel.com, mhocko@suse.com, mm-commits@vger.kernel.org, n-horiguchi@ah.jp.nec.com, yang.shi@linux.alibaba.com, ziy@nvidia.com


The patch titled
     Subject: mm/vmstat: add events for PMD based THP migration without split
has been added to the -mm tree.  Its filename is
     mm-vmstat-add-events-for-pmd-based-thp-migration-without-split.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-vmstat-add-events-for-pmd-based-thp-migration-without-split.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-vmstat-add-events-for-pmd-based-thp-migration-without-split.patch

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
Subject: mm/vmstat: add events for PMD based THP migration without split

This adds the following two new VM events which will help in validating
PMD based THP migration without split.  Statistics reported through these
events will help in performance debugging.

1. THP_PMD_MIGRATION_SUCCESS
2. THP_PMD_MIGRATION_FAILURE

Link: http://lkml.kernel.org/r/1589784156-28831-1-git-send-email-anshuman.khandual@arm.com
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
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
 mm/migrate.c                  |   15 +++++++++++++++
 mm/vmstat.c                   |    4 ++++
 3 files changed, 23 insertions(+)

--- a/include/linux/vm_event_item.h~mm-vmstat-add-events-for-pmd-based-thp-migration-without-split
+++ a/include/linux/vm_event_item.h
@@ -91,6 +91,10 @@ enum vm_event_item { PGPGIN, PGPGOUT, PS
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
@@ -1177,6 +1177,18 @@ out:
 #define ICE_noinline
 #endif
 
+#ifdef CONFIG_ARCH_ENABLE_THP_MIGRATION
+static inline void thp_migration_success(bool success)
+{
+	if (success)
+		count_vm_event(THP_PMD_MIGRATION_SUCCESS);
+	else
+		count_vm_event(THP_PMD_MIGRATION_FAILURE);
+}
+#else
+static inline void thp_migration_success(bool success) { }
+#endif
+
 /*
  * Obtain the lock on page, remove all ptes and migrate the page
  * to the newly allocated page in newpage.
@@ -1239,6 +1251,8 @@ out:
 	 * we want to retry.
 	 */
 	if (rc == MIGRATEPAGE_SUCCESS) {
+		if (PageTransHuge(newpage))
+			thp_migration_success(true);
 		put_page(page);
 		if (reason == MR_MEMORY_FAILURE) {
 			/*
@@ -1481,6 +1495,7 @@ retry:
 					unlock_page(page);
 					if (!rc) {
 						list_safe_reset_next(page, page2, lru);
+						thp_migration_success(false);
 						goto retry;
 					}
 				}
--- a/mm/vmstat.c~mm-vmstat-add-events-for-pmd-based-thp-migration-without-split
+++ a/mm/vmstat.c
@@ -1274,6 +1274,10 @@ const char * const vmstat_text[] = {
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

mm-page_alloc-restrict-and-formalize-compound_page_dtors.patch
arm64-mm-drop-__have_arch_huge_ptep_get.patch
mm-hugetlb-define-a-generic-fallback-for-is_hugepage_only_range.patch
mm-hugetlb-define-a-generic-fallback-for-arch_clear_hugepage_flags.patch
powerpc-mm-drop-platform-defined-pmd_mknotpresent.patch
mm-thp-rename-pmd_mknotpresent-as-pmd_mknotvalid.patch
mm-thp-rename-pmd_mknotpresent-as-pmd_mkinvalid-v2.patch
mm-vmstat-add-events-for-pmd-based-thp-migration-without-split.patch
x86-mm-define-mm_p4d_folded.patch
mm-debug-add-tests-validating-architecture-page-table-helpers.patch
mm-debug-add-tests-validating-architecture-page-table-helpers-v17.patch
mm-debug-add-tests-validating-architecture-page-table-helpers-v18.patch
