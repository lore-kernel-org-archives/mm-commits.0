Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85EF32777EE
	for <mm-commits@vger.kernel.org>; Thu, 27 Feb 2025 22:29:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740695369; cv=none; b=orZge4jLhd4kU1nbLvgZzwZpEkVM9Z7KkU9Z/iQ5rfkqWof93YTxNihcr6HBwbqFDU1gAu2NIRHv6qeEoqDbfMt03E3GKHuCkQ/hsbCxNOMAPqRe1iMZnmQqN1+jvr2Rzerg7o7Xlir3X5Q9C9Y9xNdbZ8U9ajCxBqe4S9UylIU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740695369; c=relaxed/simple;
	bh=gj8ZWQKpfLfpiHGD8TnHflGUoYCRas5t/xY/gT+dnlA=;
	h=Date:To:From:Subject:Message-Id; b=JOPpl6sZsD2OgpEf5Ua8s67F5+0K4jEmVz5Z/HMVCOL1UYLXr8R8MQotGqYM3JZPoufEaMHyg1+Vc+64ydl32/cqHbPC3sacvl7lR83G9vJAUNj8Q2jRQHY9wdZhqJZByJgRGwtGLL4JyFqKtsMsexlxthVhYiYIpPpFL+0j++c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=dTStI/Oe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="dTStI/Oe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFE41C4CEDD;
	Thu, 27 Feb 2025 22:29:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1740695369;
	bh=gj8ZWQKpfLfpiHGD8TnHflGUoYCRas5t/xY/gT+dnlA=;
	h=Date:To:From:Subject:From;
	b=dTStI/OetVO0FH9dsk077FrwsLOaIM671pdJgXASwblqqQdow8P+StCsHLN28bHG3
	 ++QDknl2xt+eRkNzpvmAdFeUHBHM91he63JjtwsWRl9gvja30xTJdjHGlR8Acy7w7O
	 1BfGx7aQE2duZVEkOyguc780woN54YRRbtBem788=
Date: Thu, 27 Feb 2025 14:29:28 -0800
To: mm-commits@vger.kernel.org,hannes@cmpxchg.org,fvdl@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-sparse-allow-for-alternate-vmemmap-section-init-at-boot-fix.patch added to mm-unstable branch
Message-Id: <20250227222928.DFE41C4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: make SPARSEMEM_VMEMMAP_PREINIT an internal option
has been added to the -mm mm-unstable branch.  Its filename is
     mm-sparse-allow-for-alternate-vmemmap-section-init-at-boot-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-sparse-allow-for-alternate-vmemmap-section-init-at-boot-fix.patch

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
From: Frank van der Linden <fvdl@google.com>
Subject: mm: make SPARSEMEM_VMEMMAP_PREINIT an internal option
Date: Thu, 27 Feb 2025 18:57:17 +0000

SPARSEMEM_VMEMMAP_PREINIT is not useful as a user-facing option, it is
just something that should be selected if a subsystem wishes to do vmemmap
preinit.  That's currently only HUGETLB_PAGE_OPTIMIZE_VMEMMAP.

So, make it a default-less option that is only selected by
HUGETLB_PAGE_OPTIMIZE_VMEMMAP, iff the architecture has noted it is
capable of doing hugetlb vmemmap preinit.  That is done via
ARCH_WANT_HUGETLB_VMEMMAP_PREINIT, renamed from
ARCH_WANT_SPARSE_VMEMMAP_PREINIT.

Link: https://lkml.kernel.org/r/20250227185717.1265644-1-fvdl@google.com
Fixes: a916062fdd134 ("mm/sparse: allow for alternate vmemmap section init at boot")
Signed-off-by: Frank van der Linden <fvdl@google.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/Kconfig |    1 +
 fs/Kconfig       |    1 +
 mm/Kconfig       |    9 ++++-----
 3 files changed, 6 insertions(+), 5 deletions(-)

--- a/arch/x86/Kconfig~mm-sparse-allow-for-alternate-vmemmap-section-init-at-boot-fix
+++ a/arch/x86/Kconfig
@@ -146,6 +146,7 @@ config X86
 	select ARCH_WANT_LD_ORPHAN_WARN
 	select ARCH_WANT_OPTIMIZE_DAX_VMEMMAP	if X86_64
 	select ARCH_WANT_OPTIMIZE_HUGETLB_VMEMMAP	if X86_64
+	select ARCH_WANT_HUGETLB_VMEMMAP_PREINIT if X86_64
 	select ARCH_WANTS_THP_SWAP		if X86_64
 	select ARCH_HAS_PARANOID_L1D_FLUSH
 	select BUILDTIME_TABLE_SORT
--- a/fs/Kconfig~mm-sparse-allow-for-alternate-vmemmap-section-init-at-boot-fix
+++ a/fs/Kconfig
@@ -286,6 +286,7 @@ config HUGETLB_PAGE_OPTIMIZE_VMEMMAP
 	def_bool HUGETLB_PAGE
 	depends on ARCH_WANT_OPTIMIZE_HUGETLB_VMEMMAP
 	depends on SPARSEMEM_VMEMMAP
+	select SPARSEMEM_VMEMMAP_PREINIT if ARCH_WANT_HUGETLB_VMEMMAP_PREINIT
 
 config HUGETLB_PMD_PAGE_TABLE_SHARING
 	def_bool HUGETLB_PAGE
--- a/mm/Kconfig~mm-sparse-allow-for-alternate-vmemmap-section-init-at-boot-fix
+++ a/mm/Kconfig
@@ -443,13 +443,9 @@ config SPARSEMEM_VMEMMAP
 	  pfn_to_page and page_to_pfn operations.  This is the most
 	  efficient option when sufficient kernel resources are available.
 
-config ARCH_WANT_SPARSEMEM_VMEMMAP_PREINIT
+config SPARSEMEM_VMEMMAP_PREINIT
 	bool
 
-config SPARSEMEM_VMEMMAP_PREINIT
-	bool "Early init of sparse memory virtual memmap"
-	depends on SPARSEMEM_VMEMMAP && ARCH_WANT_SPARSEMEM_VMEMMAP_PREINIT
-	default y
 #
 # Select this config option from the architecture Kconfig, if it is preferred
 # to enable the feature of HugeTLB/dev_dax vmemmap optimization.
@@ -460,6 +456,9 @@ config ARCH_WANT_OPTIMIZE_DAX_VMEMMAP
 config ARCH_WANT_OPTIMIZE_HUGETLB_VMEMMAP
 	bool
 
+config ARCH_WANT_HUGETLB_VMEMMAP_PREINIT
+	bool
+
 config HAVE_MEMBLOCK_PHYS_MAP
 	bool
 
_

Patches currently in -mm which might be from fvdl@google.com are

mm-cma-export-total-and-free-number-of-pages-for-cma-areas.patch
mm-cma-support-multiple-contiguous-ranges-if-requested.patch
mm-cma-introduce-cma_intersects-function.patch
mm-hugetlb-use-cma_declare_contiguous_multi.patch
mm-hugetlb-remove-redundant-__clearpagereserved.patch
mm-hugetlb-use-online-nodes-for-bootmem-allocation.patch
mm-hugetlb-convert-cmdline-parameters-from-setup-to-early.patch
x86-mm-make-register_page_bootmem_memmap-handle-pte-mappings.patch
mm-bootmem_info-export-register_page_bootmem_memmap.patch
mm-sparse-allow-for-alternate-vmemmap-section-init-at-boot.patch
mm-sparse-allow-for-alternate-vmemmap-section-init-at-boot-fix.patch
mm-hugetlb-set-migratetype-for-bootmem-folios.patch
mm-define-__init_reserved_page_zone-function.patch
mm-hugetlb-check-bootmem-pages-for-zone-intersections.patch
mm-sparse-add-vmemmap__hvo-functions.patch
mm-hugetlb-deal-with-multiple-calls-to-hugetlb_bootmem_alloc.patch
mm-hugetlb-move-huge_boot_pages-list-init-to-hugetlb_bootmem_alloc.patch
mm-hugetlb-add-pre-hvo-framework.patch
mm-hugetlb_vmemmap-fix-hugetlb_vmemmap_restore_folios-definition.patch
mm-hugetlb-do-pre-hvo-for-bootmem-allocated-pages.patch
x86-setup-call-hugetlb_bootmem_alloc-early.patch
x86-mm-set-arch_want_sparsemem_vmemmap_preinit.patch
mm-cma-simplify-zone-intersection-check.patch
mm-cma-introduce-a-cma-validate-function.patch
mm-cma-introduce-interface-for-early-reservations.patch
mm-hugetlb-add-hugetlb_cma_only-cmdline-option.patch
mm-hugetlb-enable-bootmem-allocation-from-cma-areas.patch
mm-hugetlb-move-hugetlb-cma-code-in-to-its-own-file.patch

