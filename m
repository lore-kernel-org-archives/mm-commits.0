From: akpm@linux-foundation.org
Subject: + mm-khugepaged-add-exceed_max_ptes_-helpers.patch added
 to -mm tree
Date: Wed, 29 Apr 2020 16:59:18 -0700
Message-ID: <20200429235918.jv8tXUZ2i%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:54872 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726511AbgD2X7U (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 29 Apr 2020 19:59:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, hughd@google.com, kirill.shutemov@linux.intel.com, mm-commits@vger.kernel.org, yang.shi@linux.alibaba.com


The patch titled
     Subject: mm: khugepaged: add exceed_max_ptes_* helpers
has been added to the -mm tree.  Its filename is
     mm-khugepaged-add-exceed_max_ptes_-helpers.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-khugepaged-add-exceed_max_ptes_-helpers.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-khugepaged-add-exceed_max_ptes_-helpers.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Yang Shi <yang.shi@linux.alibaba.com>
Subject: mm: khugepaged: add exceed_max_ptes_* helpers

The max_ptes_{swap|none|shared} are defined to tune the behavior of
khugepaged.  The are checked at a couple of places with open coding. 
Replace the opencoding to exceed_pax_ptes_{swap|none_shared} helpers to
improve the readability.

Link: http://lkml.kernel.org/r/1588200982-69492-1-git-send-email-yang.shi@linux.alibaba.com
Signed-off-by: Yang Shi <yang.shi@linux.alibaba.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/khugepaged.c |   27 +++++++++++++++++++++------
 1 file changed, 21 insertions(+), 6 deletions(-)

--- a/mm/khugepaged.c~mm-khugepaged-add-exceed_max_ptes_-helpers
+++ a/mm/khugepaged.c
@@ -339,6 +339,21 @@ struct attribute_group khugepaged_attr_g
 };
 #endif /* CONFIG_SYSFS */
 
+static inline bool exceed_max_ptes_none(unsigned int *nr_ptes)
+{
+	return (++(*nr_ptes) > khugepaged_max_ptes_none);
+}
+
+static inline bool exceed_max_ptes_swap(unsigned int *nr_ptes)
+{
+	return (++(*nr_ptes) > khugepaged_max_ptes_swap);
+}
+
+static inline bool exceed_max_ptes_shared(unsigned int *nr_ptes)
+{
+	return (++(*nr_ptes) > khugepaged_max_ptes_shared);
+}
+
 int hugepage_madvise(struct vm_area_struct *vma,
 		     unsigned long *vm_flags, int advice)
 {
@@ -604,7 +619,7 @@ static int __collapse_huge_page_isolate(
 		if (pte_none(pteval) || (pte_present(pteval) &&
 				is_zero_pfn(pte_pfn(pteval)))) {
 			if (!userfaultfd_armed(vma) &&
-			    ++none_or_zero <= khugepaged_max_ptes_none) {
+			    !exceed_max_ptes_none(&none_or_zero)) {
 				continue;
 			} else {
 				result = SCAN_EXCEED_NONE_PTE;
@@ -624,7 +639,7 @@ static int __collapse_huge_page_isolate(
 		VM_BUG_ON_PAGE(!PageAnon(page), page);
 
 		if (page_mapcount(page) > 1 &&
-				++shared > khugepaged_max_ptes_shared) {
+				exceed_max_ptes_shared(&shared)) {
 			result = SCAN_EXCEED_SHARED_PTE;
 			goto out;
 		}
@@ -1234,7 +1249,7 @@ static int khugepaged_scan_pmd(struct mm
 	     _pte++, _address += PAGE_SIZE) {
 		pte_t pteval = *_pte;
 		if (is_swap_pte(pteval)) {
-			if (++unmapped <= khugepaged_max_ptes_swap) {
+			if (!exceed_max_ptes_swap(&unmapped)) {
 				/*
 				 * Always be strict with uffd-wp
 				 * enabled swap entries.  Please see
@@ -1252,7 +1267,7 @@ static int khugepaged_scan_pmd(struct mm
 		}
 		if (pte_none(pteval) || is_zero_pfn(pte_pfn(pteval))) {
 			if (!userfaultfd_armed(vma) &&
-			    ++none_or_zero <= khugepaged_max_ptes_none) {
+			    !exceed_max_ptes_none(&none_or_zero)) {
 				continue;
 			} else {
 				result = SCAN_EXCEED_NONE_PTE;
@@ -1286,7 +1301,7 @@ static int khugepaged_scan_pmd(struct mm
 		}
 
 		if (page_mapcount(page) > 1 &&
-				++shared > khugepaged_max_ptes_shared) {
+				exceed_max_ptes_shared(&shared)) {
 			result = SCAN_EXCEED_SHARED_PTE;
 			goto out_unmap;
 		}
@@ -1961,7 +1976,7 @@ static void khugepaged_scan_file(struct
 			continue;
 
 		if (xa_is_value(page)) {
-			if (++swap > khugepaged_max_ptes_swap) {
+			if (exceed_max_ptes_swap(&swap)) {
 				result = SCAN_EXCEED_SWAP_PTE;
 				break;
 			}
_

Patches currently in -mm which might be from yang.shi@linux.alibaba.com are

mm-khugepaged-add-exceed_max_ptes_-helpers.patch
mm-khugepaged-dont-have-to-put-being-freed-page-back-to-lru.patch
mm-thp-dont-need-drain-lru-cache-when-splitting-and-mlocking-thp.patch
