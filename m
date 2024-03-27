Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF96B14EC6D
	for <mm-commits@vger.kernel.org>; Wed, 27 Mar 2024 17:53:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711562027; cv=none; b=ttHtgpV9VAOHG8rHLuwGfK39e7PwMsdXtfCzxkY6oVyptjy5C/JqR7DoZaPzHWMcrAqyvcJB2oc9NWucZGJA/oJwZoBTQX9StG0ELW6Ym0dKysJ1GQKGi0wBd+PYQgUOLdmwRDUVrnbekxL5tHFVRGB8YSGEHbHRVewOsJHbAG0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711562027; c=relaxed/simple;
	bh=fZDy+z0OujH/TwbR0wAlWo9XNhSsWKNXmBvvvDQ26Xo=;
	h=Date:To:From:Subject:Message-Id; b=LJFCsmDTBSwNOp31p1CIrVib6vzYYlhkQc2+GqhRW3lIo+N7r67AzSzwCVdhrOyubUaMSKbAANr5c+anNcUdXMH8/iDDkZxioSvQ7SkWDQoB4PXNt9xIMLY4rRUziXB3/YVphrBGEJZOPWVX4DQQ2R36Ydbeclsx5dX2/FSIbKg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=S8F9JVKm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="S8F9JVKm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61C4CC433C7;
	Wed, 27 Mar 2024 17:53:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1711562027;
	bh=fZDy+z0OujH/TwbR0wAlWo9XNhSsWKNXmBvvvDQ26Xo=;
	h=Date:To:From:Subject:From;
	b=S8F9JVKm9QOUQ4qZbpvBVmRK6qvIUoVTGoHpNBzx7VpK+LBCOOxkaT+kQ/9JFFCmT
	 xwI5uORfP9D4bLHxxJEYFAaKfwIWt8IWkNTcdZ5xyb3RvVpHj8qoR8wxO9f98Hi4G5
	 WDqUEiwr7AbfdEx2utFXcoVtL/XAnbG4JWOXZ7zg=
Date: Wed, 27 Mar 2024 10:53:46 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,vbabka@suse.cz,shy828301@gmail.com,rppt@kernel.org,riel@surriel.com,muchun.song@linux.dev,mpe@ellerman.id.au,mike.kravetz@oracle.com,lstoakes@gmail.com,kirill@shutemov.name,jthoughton@google.com,jhubbard@nvidia.com,jgg@nvidia.com,hch@infradead.org,david@redhat.com,christophe.leroy@csgroup.eu,axelrasmussen@google.com,aneesh.kumar@kernel.org,andrew.jones@linux.dev,aarcange@redhat.com,peterx@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-arch-provide-pud_pfn-fallback.patch added to mm-unstable branch
Message-Id: <20240327175347.61C4CC433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/arch: provide pud_pfn() fallback
has been added to the -mm mm-unstable branch.  Its filename is
     mm-arch-provide-pud_pfn-fallback.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-arch-provide-pud_pfn-fallback.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Peter Xu <peterx@redhat.com>
Subject: mm/arch: provide pud_pfn() fallback
Date: Wed, 27 Mar 2024 11:23:24 -0400

The comment in the code explains the reasons.  We took a different
approach comparing to pmd_pfn() by providing a fallback function.

Another option is to provide some lower level config options (compare to
HUGETLB_PAGE or THP) to identify which layer an arch can support for such
huge mappings.  However that can be an overkill.

Link: https://lkml.kernel.org/r/20240327152332.950956-6-peterx@redhat.com
Signed-off-by: Peter Xu <peterx@redhat.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Cc: Mike Rapoport (IBM) <rppt@kernel.org>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Andrew Jones <andrew.jones@linux.dev>
Cc: Aneesh Kumar K.V (IBM) <aneesh.kumar@kernel.org>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: James Houghton <jthoughton@google.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Kirill A. Shutemov <kirill@shutemov.name>
Cc: Lorenzo Stoakes <lstoakes@gmail.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Rik van Riel <riel@surriel.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Yang Shi <shy828301@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/riscv/include/asm/pgtable.h    |    1 +
 arch/s390/include/asm/pgtable.h     |    1 +
 arch/sparc/include/asm/pgtable_64.h |    1 +
 arch/x86/include/asm/pgtable.h      |    1 +
 include/linux/pgtable.h             |   10 ++++++++++
 5 files changed, 14 insertions(+)

--- a/arch/riscv/include/asm/pgtable.h~mm-arch-provide-pud_pfn-fallback
+++ a/arch/riscv/include/asm/pgtable.h
@@ -642,6 +642,7 @@ static inline unsigned long pmd_pfn(pmd_
 
 #define __pud_to_phys(pud)  (__page_val_to_pfn(pud_val(pud)) << PAGE_SHIFT)
 
+#define pud_pfn pud_pfn
 static inline unsigned long pud_pfn(pud_t pud)
 {
 	return ((__pud_to_phys(pud) & PUD_MASK) >> PAGE_SHIFT);
--- a/arch/s390/include/asm/pgtable.h~mm-arch-provide-pud_pfn-fallback
+++ a/arch/s390/include/asm/pgtable.h
@@ -1414,6 +1414,7 @@ static inline unsigned long pud_deref(pu
 	return (unsigned long)__va(pud_val(pud) & origin_mask);
 }
 
+#define pud_pfn pud_pfn
 static inline unsigned long pud_pfn(pud_t pud)
 {
 	return __pa(pud_deref(pud)) >> PAGE_SHIFT;
--- a/arch/sparc/include/asm/pgtable_64.h~mm-arch-provide-pud_pfn-fallback
+++ a/arch/sparc/include/asm/pgtable_64.h
@@ -875,6 +875,7 @@ static inline bool pud_leaf(pud_t pud)
 	return pte_val(pte) & _PAGE_PMD_HUGE;
 }
 
+#define pud_pfn pud_pfn
 static inline unsigned long pud_pfn(pud_t pud)
 {
 	pte_t pte = __pte(pud_val(pud));
--- a/arch/x86/include/asm/pgtable.h~mm-arch-provide-pud_pfn-fallback
+++ a/arch/x86/include/asm/pgtable.h
@@ -234,6 +234,7 @@ static inline unsigned long pmd_pfn(pmd_
 	return (pfn & pmd_pfn_mask(pmd)) >> PAGE_SHIFT;
 }
 
+#define pud_pfn pud_pfn
 static inline unsigned long pud_pfn(pud_t pud)
 {
 	phys_addr_t pfn = pud_val(pud);
--- a/include/linux/pgtable.h~mm-arch-provide-pud_pfn-fallback
+++ a/include/linux/pgtable.h
@@ -1820,6 +1820,16 @@ typedef unsigned int pgtbl_mod_mask;
 #endif
 
 /*
+ * We always define pmd_pfn for all archs as it's used in lots of generic
+ * code.  Now it happens too for pud_pfn (and can happen for larger
+ * mappings too in the future; we're not there yet).  Instead of defining
+ * it for all archs (like pmd_pfn), provide a fallback.
+ */
+#ifndef pud_pfn
+#define pud_pfn(x) ({ BUILD_BUG(); 0; })
+#endif
+
+/*
  * Some architectures have MMUs that are configurable or selectable at boot
  * time. These lead to variable PTRS_PER_x. For statically allocated arrays it
  * helps to have a static maximum value.
_

Patches currently in -mm which might be from peterx@redhat.com are

mm-hmm-process-pud-swap-entry-without-pud_huge.patch
mm-gup-cache-p4d-in-follow_p4d_mask.patch
mm-gup-check-p4d-presence-before-going-on.patch
mm-x86-change-pxd_huge-behavior-to-exclude-swap-entries.patch
mm-sparc-change-pxd_huge-behavior-to-exclude-swap-entries.patch
mm-arm-use-macros-to-define-pmd-pud-helpers.patch
mm-arm-redefine-pmd_huge-with-pmd_leaf.patch
mm-arm64-merge-pxd_huge-and-pxd_leaf-definitions.patch
mm-powerpc-redefine-pxd_huge-with-pxd_leaf.patch
mm-gup-merge-pxd-huge-mapping-checks.patch
mm-treewide-replace-pxd_huge-with-pxd_leaf.patch
mm-treewide-remove-pxd_huge.patch
mm-arm-remove-pmd_thp_or_huge.patch
mm-document-pxd_leaf-api.patch
selftests-mm-run_vmtestssh-fix-hugetlb-mem-size-calculation.patch
mm-kconfig-config_pgtable_has_huge_leaves.patch
mm-hugetlb-declare-hugetlbfs_pagecache_present-non-static.patch
mm-make-hpage_pxd_-macros-even-if-thp.patch
mm-introduce-vma_pgtable_walk_beginend.patch
mm-arch-provide-pud_pfn-fallback.patch
mm-gup-drop-folio_fast_pin_allowed-in-hugepd-processing.patch
mm-gup-refactor-record_subpages-to-find-1st-small-page.patch
mm-gup-handle-hugetlb-for-no_page_table.patch
mm-gup-cache-pudp-in-follow_pud_mask.patch
mm-gup-handle-huge-pud-for-follow_pud_mask.patch
mm-gup-handle-huge-pmd-for-follow_pmd_mask.patch
mm-gup-handle-hugepd-for-follow_page.patch
mm-gup-handle-hugetlb-in-the-generic-follow_page_mask-code.patch

