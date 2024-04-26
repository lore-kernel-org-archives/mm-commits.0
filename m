Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 549C17FBC3
	for <mm-commits@vger.kernel.org>; Fri, 26 Apr 2024 04:00:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714104055; cv=none; b=JR4Z2Lgy/9J+mvdO8QnOjmLOQ969amiIi77exz2bjWrbX5dliMPaoQylUev1m2a199Y0Cp/P4yLhMXnKck2VJ8qKF81ZXrQI81K/3YEC42PZ4DsCgJw4zR2hcs4X+v1K+jmehxASy2Irp3OxDJ4G10ZK2lx1ed/rm5ecs4F4+HM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714104055; c=relaxed/simple;
	bh=sDKl828js0Hu8rdsVYnTNdQRdBX0A2X3WtuQ8OZ+5W4=;
	h=Date:To:From:Subject:Message-Id; b=LttnrBtN8vT0OzQtXtlMB0C5Nit9b5ACVYpXCPtH9mW4Gf9NZu3ccuaSK5NhvL972JpZ3nJtzAIW6WqZAPm2lAOERxFo5flG0quZwLRQlXHTzgTgJ2Rf3oqTgiYm9Gw7X2h0MZ10xtHIpgY1Wab9G8KxOcXSjE3vPhuqOrDxlCk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=yheNryA4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="yheNryA4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 248A9C113CD;
	Fri, 26 Apr 2024 04:00:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714104055;
	bh=sDKl828js0Hu8rdsVYnTNdQRdBX0A2X3WtuQ8OZ+5W4=;
	h=Date:To:From:Subject:From;
	b=yheNryA4bPv5GsLNUlloDe3lYEfAAgGugGEQlOmj6Tpo++//+2VoR+UygfaqkyVzP
	 tCr79fi2AngrGgTj+riHjK8IKeo1JOxcJXeYAOFVdfzCsg0o9zlLaG7RNyIFEnC6uK
	 0ucJjslMBpiwIH7gxtCumgCKrGoJtlnoaliUVYuM=
Date: Thu, 25 Apr 2024 21:00:54 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,vbabka@suse.cz,shy828301@gmail.com,ryan.roberts@arm.com,rppt@kernel.org,riel@surriel.com,muchun.song@linux.dev,mpe@ellerman.id.au,lstoakes@gmail.com,kirill@shutemov.name,jthoughton@google.com,jhubbard@nvidia.com,jgg@nvidia.com,hch@infradead.org,david@redhat.com,christophe.leroy@csgroup.eu,axelrasmussen@google.com,aneesh.kumar@kernel.org,andrew.jones@linux.dev,aarcange@redhat.com,peterx@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-arch-provide-pud_pfn-fallback.patch removed from -mm tree
Message-Id: <20240426040055.248A9C113CD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/arch: provide pud_pfn() fallback
has been removed from the -mm tree.  Its filename was
     mm-arch-provide-pud_pfn-fallback.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Peter Xu <peterx@redhat.com>
Subject: mm/arch: provide pud_pfn() fallback
Date: Wed, 27 Mar 2024 11:23:24 -0400

The comment in the code explains the reasons.  We took a different
approach comparing to pmd_pfn() by providing a fallback function.

Another option is to provide some lower level config options (compare to
HUGETLB_PAGE or THP) to identify which layer an arch can support for such
huge mappings.  However that can be an overkill.

[peterx@redhat.com: fix loongson defconfig]
  Link: https://lkml.kernel.org/r/20240403013249.1418299-4-peterx@redhat.com
Link: https://lkml.kernel.org/r/20240327152332.950956-6-peterx@redhat.com
Signed-off-by: Peter Xu <peterx@redhat.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Tested-by: Ryan Roberts <ryan.roberts@arm.com>
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
 include/linux/pgtable.h             |   14 ++++++++++++++
 5 files changed, 18 insertions(+)

--- a/arch/riscv/include/asm/pgtable.h~mm-arch-provide-pud_pfn-fallback
+++ a/arch/riscv/include/asm/pgtable.h
@@ -648,6 +648,7 @@ static inline unsigned long pmd_pfn(pmd_
 
 #define __pud_to_phys(pud)  (__page_val_to_pfn(pud_val(pud)) << PAGE_SHIFT)
 
+#define pud_pfn pud_pfn
 static inline unsigned long pud_pfn(pud_t pud)
 {
 	return ((__pud_to_phys(pud) & PUD_MASK) >> PAGE_SHIFT);
--- a/arch/s390/include/asm/pgtable.h~mm-arch-provide-pud_pfn-fallback
+++ a/arch/s390/include/asm/pgtable.h
@@ -1405,6 +1405,7 @@ static inline unsigned long pud_deref(pu
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
@@ -1820,6 +1820,20 @@ typedef unsigned int pgtbl_mod_mask;
 #endif
 
 /*
+ * We always define pmd_pfn for all archs as it's used in lots of generic
+ * code.  Now it happens too for pud_pfn (and can happen for larger
+ * mappings too in the future; we're not there yet).  Instead of defining
+ * it for all archs (like pmd_pfn), provide a fallback.
+ *
+ * Note that returning 0 here means any arch that didn't define this can
+ * get severely wrong when it hits a real pud leaf.  It's arch's
+ * responsibility to properly define it when a huge pud is possible.
+ */
+#ifndef pud_pfn
+#define pud_pfn(x) 0
+#endif
+
+/*
  * Some architectures have MMUs that are configurable or selectable at boot
  * time. These lead to variable PTRS_PER_x. For statically allocated arrays it
  * helps to have a static maximum value.
_

Patches currently in -mm which might be from peterx@redhat.com are

mm-userfaultfd-reset-ptes-when-close-for-wr-protected-ones.patch
mm-hugetlb-assert-hugetlb_lock-in-__hugetlb_cgroup_commit_charge.patch
mm-page_table_check-support-userfault-wr-protect-entries.patch

