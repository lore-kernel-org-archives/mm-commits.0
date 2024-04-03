Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E54E2F24
	for <mm-commits@vger.kernel.org>; Wed,  3 Apr 2024 21:18:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712179127; cv=none; b=onDf/CyDEA3zXCuE00VYqHBNAMzlq9HHKIq5JqxDURa49F8kUWe30cXqEx++JhelykuaGIp/1uPqbw5pn2ifrUPRAxR1EIykmQ5fa8OApd1VpitAQtHx+uVCX+bGcodp1ga8TndP5ayX6CXLH3xhvV3NrWEpcLVQuD3yhiqkGCk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712179127; c=relaxed/simple;
	bh=qqaJ91/URHfyTJUAZsbXczohizUZSneeEvd+AftVD2A=;
	h=Date:To:From:Subject:Message-Id; b=nEpOIWH0q/wjc/XlmZsGaUdFNEMuHCCwO+E3sWmXrw7FPUgkOYz6X+RRP+0SNFU9jcxn+oenzjxXHTLHrozIPfFaWO4vxjl0RvRnaUw+sdZtHLv2uXm+wO3HYfBZxP03WOGXTdsKyVcxRJZw8d/FKUQN66Z+aiQ7C+mh6MXFgKM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=yxMM78tm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="yxMM78tm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 991F7C433F1;
	Wed,  3 Apr 2024 21:18:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1712179126;
	bh=qqaJ91/URHfyTJUAZsbXczohizUZSneeEvd+AftVD2A=;
	h=Date:To:From:Subject:From;
	b=yxMM78tmuxcNRUucB6/16Y4Y1lDhVOIq6p3aC+ckF8tWgIUmsRT6AXa7HRiaVfPyZ
	 bZiTi96FEfuVBkaXgJFJxkZW2QtclAzN1E5g15GGLQl6MmuL+ac+FXfO1pOAkaGCX5
	 dGmrrJGfoky4IFYwfHgIu0FpvcIZJXeLmNZ0cE9g=
Date: Wed, 03 Apr 2024 14:18:45 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,vbabka@suse.cz,shy828301@gmail.com,ryan.roberts@arm.com,rppt@kernel.org,riel@surriel.com,muchun.song@linux.dev,mpe@ellerman.id.au,mike.kravetz@oracle.com,lstoakes@gmail.com,kirill@shutemov.name,jthoughton@google.com,jhubbard@nvidia.com,jgg@nvidia.com,hch@infradead.org,david@redhat.com,christophe.leroy@csgroup.eu,axelrasmussen@google.com,aneesh.kumar@kernel.org,andrew.jones@linux.dev,aarcange@redhat.com,peterx@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-arch-provide-pud_pfn-fallback-fix.patch added to mm-unstable branch
Message-Id: <20240403211846.991F7C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: fixup! mm/arch: provide pud_pfn() fallback
has been added to the -mm mm-unstable branch.  Its filename is
     mm-arch-provide-pud_pfn-fallback-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-arch-provide-pud_pfn-fallback-fix.patch

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
Subject: fixup! mm/arch: provide pud_pfn() fallback
Date: Tue, 2 Apr 2024 21:32:49 -0400

fix loongson defconfig

Link: https://lkml.kernel.org/r/20240403013249.1418299-4-peterx@redhat.com
Signed-off-by: Peter Xu <peterx@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Andrew Jones <andrew.jones@linux.dev>
Cc: Aneesh Kumar K.V (IBM) <aneesh.kumar@kernel.org>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: James Houghton <jthoughton@google.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Kirill A. Shutemov <kirill@shutemov.name>
Cc: Lorenzo Stoakes <lstoakes@gmail.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: "Mike Rapoport (IBM)" <rppt@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Rik van Riel <riel@surriel.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Yang Shi <shy828301@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pgtable.h |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/include/linux/pgtable.h~mm-arch-provide-pud_pfn-fallback-fix
+++ a/include/linux/pgtable.h
@@ -1824,9 +1824,13 @@ typedef unsigned int pgtbl_mod_mask;
  * code.  Now it happens too for pud_pfn (and can happen for larger
  * mappings too in the future; we're not there yet).  Instead of defining
  * it for all archs (like pmd_pfn), provide a fallback.
+ *
+ * Note that returning 0 here means any arch that didn't define this can
+ * get severely wrong when it hits a real pud leaf.  It's arch's
+ * responsibility to properly define it when a huge pud is possible.
  */
 #ifndef pud_pfn
-#define pud_pfn(x) ({ BUILD_BUG(); 0; })
+#define pud_pfn(x) 0
 #endif
 
 /*
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
selftests-mm-run_vmtestssh-fix-hugetlb-mem-size-calculation-fix.patch
mm-kconfig-config_pgtable_has_huge_leaves.patch
mm-hugetlb-declare-hugetlbfs_pagecache_present-non-static.patch
mm-make-hpage_pxd_-macros-even-if-thp.patch
mm-introduce-vma_pgtable_walk_beginend.patch
mm-arch-provide-pud_pfn-fallback.patch
mm-arch-provide-pud_pfn-fallback-fix.patch
mm-gup-drop-folio_fast_pin_allowed-in-hugepd-processing.patch
mm-gup-refactor-record_subpages-to-find-1st-small-page.patch
mm-gup-handle-hugetlb-for-no_page_table.patch
mm-gup-cache-pudp-in-follow_pud_mask.patch
mm-gup-handle-huge-pud-for-follow_pud_mask.patch
mm-gup-handle-huge-pmd-for-follow_pmd_mask.patch
mm-gup-handle-huge-pmd-for-follow_pmd_mask-fix.patch
mm-gup-handle-hugepd-for-follow_page.patch
mm-gup-handle-hugetlb-in-the-generic-follow_page_mask-code.patch
mm-allow-anon-exclusive-check-over-hugetlb-tail-pages.patch

