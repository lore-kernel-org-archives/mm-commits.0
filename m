From: Andrew Morton <akpm@linux-foundation.org>
Subject: +
 mm-page_alloc-restrict-and-formalize-compound_page_dtors.patch added to -mm
 tree
Date: Mon, 18 May 2020 13:27:06 -0700
Message-ID: <20200518202706.cOOVOyFck%akpm@linux-foundation.org>
References: <20200513175005.1f4839360c18c0238df292d1@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:52424 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726227AbgERU1H (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 18 May 2020 16:27:07 -0400
In-Reply-To: <20200513175005.1f4839360c18c0238df292d1@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: anshuman.khandual@arm.com, david@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_alloc: restrict and formalize compound_page_dtors[]
has been added to the -mm tree.  Its filename is
     mm-page_alloc-restrict-and-formalize-compound_page_dtors.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-page_alloc-restrict-and-formalize-compound_page_dtors.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-page_alloc-restrict-and-formalize-compound_page_dtors.patch

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
@@ -859,7 +859,7 @@ enum compound_dtor_id {
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

mm-page_alloc-restrict-and-formalize-compound_page_dtors.patch
arm64-mm-drop-__have_arch_huge_ptep_get.patch
mm-hugetlb-define-a-generic-fallback-for-is_hugepage_only_range.patch
mm-hugetlb-define-a-generic-fallback-for-arch_clear_hugepage_flags.patch
powerpc-mm-drop-platform-defined-pmd_mknotpresent.patch
mm-thp-rename-pmd_mknotpresent-as-pmd_mknotvalid.patch
mm-thp-rename-pmd_mknotpresent-as-pmd_mkinvalid-v2.patch
x86-mm-define-mm_p4d_folded.patch
mm-debug-add-tests-validating-architecture-page-table-helpers.patch
mm-debug-add-tests-validating-architecture-page-table-helpers-v17.patch
mm-debug-add-tests-validating-architecture-page-table-helpers-v18.patch
