From: akpm@linux-foundation.org
Subject: [merged]
 mm-page_alloc-restrict-and-formalize-compound_page_dtors.patch removed from
 -mm tree
Date: Thu, 04 Jun 2020 10:18:21 -0700
Message-ID: <20200604171821.TDqml6Nn1%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:39908 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730116AbgFDRSW (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 4 Jun 2020 13:18:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: anshuman.khandual@arm.com, david@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_alloc: restrict and formalize compound_page_dtors[]
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-restrict-and-formalize-compound_page_dtors.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Anshuman Khandual <anshuman.khandual@arm.com>
Subject: mm/page_alloc: restrict and formalize compound_page_dtors[]

Restrict elements in compound_page_dtors[] array per NR_COMPOUND_DTORS and
explicitly position them according to enum compound_dtor_id.  This
improves protection against possible misalignment between
compound_page_dtors[] and enum compound_dtor_id later on.

Link: http://lkml.kernel.org/r/1589795958-19317-1-git-send-email-anshuman.khandual@arm.com
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    2 +-
 mm/page_alloc.c    |   10 +++++-----
 2 files changed, 6 insertions(+), 6 deletions(-)

--- a/include/linux/mm.h~mm-page_alloc-restrict-and-formalize-compound_page_dtors
+++ a/include/linux/mm.h
@@ -867,7 +867,7 @@ enum compound_dtor_id {
 #endif
 	NR_COMPOUND_DTORS,
 };
-extern compound_page_dtor * const compound_page_dtors[];
+extern compound_page_dtor * const compound_page_dtors[NR_COMPOUND_DTORS];
 
 static inline void set_compound_page_dtor(struct page *page,
 		enum compound_dtor_id compound_dtor)
--- a/mm/page_alloc.c~mm-page_alloc-restrict-and-formalize-compound_page_dtors
+++ a/mm/page_alloc.c
@@ -302,14 +302,14 @@ const char * const migratetype_names[MIG
 #endif
 };
 
-compound_page_dtor * const compound_page_dtors[] = {
-	NULL,
-	free_compound_page,
+compound_page_dtor * const compound_page_dtors[NR_COMPOUND_DTORS] = {
+	[NULL_COMPOUND_DTOR] = NULL,
+	[COMPOUND_PAGE_DTOR] = free_compound_page,
 #ifdef CONFIG_HUGETLB_PAGE
-	free_huge_page,
+	[HUGETLB_PAGE_DTOR] = free_huge_page,
 #endif
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
-	free_transhuge_page,
+	[TRANSHUGE_PAGE_DTOR] = free_transhuge_page,
 #endif
 };
 
_

Patches currently in -mm which might be from anshuman.khandual@arm.com are

mm-vmstat-add-events-for-pmd-based-thp-migration-without-split.patch
mm-vmstat-add-events-for-pmd-based-thp-migration-without-split-update.patch
x86-mm-define-mm_p4d_folded.patch
mm-debug-add-tests-validating-architecture-page-table-helpers.patch
mm-debug-add-tests-validating-architecture-page-table-helpers-v17.patch
mm-debug-add-tests-validating-architecture-page-table-helpers-v18.patch
