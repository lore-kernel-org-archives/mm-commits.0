Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE67FC001B0
	for <mm-commits@archiver.kernel.org>; Fri, 11 Aug 2023 23:06:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234919AbjHKXGP (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 11 Aug 2023 19:06:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237038AbjHKXFG (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 11 Aug 2023 19:05:06 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AFA92722
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 16:03:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B6DF667B10
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 23:03:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C38AC433CB;
        Fri, 11 Aug 2023 23:03:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691794990;
        bh=BVcaPzfEuXbncCTJRiXXYjNRNJ/p+HWJwpJOzB40Cjg=;
        h=Date:To:From:Subject:From;
        b=KDVhjlp6WdO8pCsqJQ69U/YyDDqFJNY9uWC4JhpkFuzI0/alzer5fReZBbyfDNPs7
         4DxsILoXZVyUXS/OgmBnL+hxzqGAVOODDoQbjcLd11rvLuyj2h+KJj3QUmZ7e808Sy
         SMu0eJo9fs33sm1KMOOYigmf8xmbcOvzIM4VZazM=
Date:   Fri, 11 Aug 2023 16:03:09 -0700
To:     mm-commits@vger.kernel.org, will@kernel.org, osalvador@suse.de,
        npiggin@gmail.com, muchun.song@linux.dev, mpe@ellerman.id.au,
        mike.kravetz@oracle.com, joao.m.martins@oracle.com,
        dan.j.williams@intel.com, christophe.leroy@csgroup.eu,
        catalin.marinas@arm.com, aneesh.kumar@linux.ibm.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-hugepage-pud-allow-arch-specific-helper-function-to-check-huge-page-pud-support.patch removed from -mm tree
Message-Id: <20230811230310.1C38AC433CB@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/hugepage pud: allow arch-specific helper function to check huge page pud support
has been removed from the -mm tree.  Its filename was
     mm-hugepage-pud-allow-arch-specific-helper-function-to-check-huge-page-pud-support.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Subject: mm/hugepage pud: allow arch-specific helper function to check huge page pud support
Date: Tue, 25 Jul 2023 00:37:47 +0530

Patch series "Add support for DAX vmemmap optimization for ppc64", v6.

This patch series implements changes required to support DAX vmemmap
optimization for ppc64.  The vmemmap optimization is only enabled with
radix MMU translation and 1GB PUD mapping with 64K page size.

The patch series also splits the hugetlb vmemmap optimization as a
separate Kconfig variable so that architectures can enable DAX vmemmap
optimization without enabling hugetlb vmemmap optimization.  This should
enable architectures like arm64 to enable DAX vmemmap optimization while
they can't enable hugetlb vmemmap optimization.  More details of the same
are in patch "mm/vmemmap optimization: Split hugetlb and devdax vmemmap
optimization".

With 64K page size for 16384 pages added (1G) we save 14 pages
With 4K page size for 262144 pages added (1G) we save 4094 pages
With 4K page size for 512 pages added (2M) we save 6 pages


This patch (of 13):

Architectures like powerpc would like to enable transparent huge page pud
support only with radix translation.  To support that add
has_transparent_pud_hugepage() helper that architectures can override.

[aneesh.kumar@linux.ibm.com: use the new has_transparent_pud_hugepage()]
  Link: https://lkml.kernel.org/r/87tttrvtaj.fsf@linux.ibm.com
Link: https://lkml.kernel.org/r/20230724190759.483013-1-aneesh.kumar@linux.ibm.com
Link: https://lkml.kernel.org/r/20230724190759.483013-2-aneesh.kumar@linux.ibm.com
Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Reviewed-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Joao Martins <joao.m.martins@oracle.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/nvdimm/pfn_devs.c |    2 +-
 include/linux/pgtable.h   |    3 +++
 mm/debug_vm_pgtable.c     |   16 +++++++---------
 3 files changed, 11 insertions(+), 10 deletions(-)

--- a/drivers/nvdimm/pfn_devs.c~mm-hugepage-pud-allow-arch-specific-helper-function-to-check-huge-page-pud-support
+++ a/drivers/nvdimm/pfn_devs.c
@@ -100,7 +100,7 @@ static unsigned long *nd_pfn_supported_a
 
 	if (has_transparent_hugepage()) {
 		alignments[1] = HPAGE_PMD_SIZE;
-		if (IS_ENABLED(CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD))
+		if (has_transparent_pud_hugepage())
 			alignments[2] = HPAGE_PUD_SIZE;
 	}
 
--- a/include/linux/pgtable.h~mm-hugepage-pud-allow-arch-specific-helper-function-to-check-huge-page-pud-support
+++ a/include/linux/pgtable.h
@@ -1505,6 +1505,9 @@ typedef unsigned int pgtbl_mod_mask;
 #define has_transparent_hugepage() IS_BUILTIN(CONFIG_TRANSPARENT_HUGEPAGE)
 #endif
 
+#ifndef has_transparent_pud_hugepage
+#define has_transparent_pud_hugepage() IS_BUILTIN(CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD)
+#endif
 /*
  * On some architectures it depends on the mm if the p4d/pud or pmd
  * layer of the page table hierarchy is folded or not.
--- a/mm/debug_vm_pgtable.c~mm-hugepage-pud-allow-arch-specific-helper-function-to-check-huge-page-pud-support
+++ a/mm/debug_vm_pgtable.c
@@ -302,7 +302,7 @@ static void __init pud_basic_tests(struc
 	unsigned long val = idx, *ptr = &val;
 	pud_t pud;
 
-	if (!has_transparent_hugepage())
+	if (!has_transparent_pud_hugepage())
 		return;
 
 	pr_debug("Validating PUD basic (%pGv)\n", ptr);
@@ -343,7 +343,7 @@ static void __init pud_advanced_tests(st
 	unsigned long vaddr = args->vaddr;
 	pud_t pud;
 
-	if (!has_transparent_hugepage())
+	if (!has_transparent_pud_hugepage())
 		return;
 
 	page = (args->pud_pfn != ULONG_MAX) ? pfn_to_page(args->pud_pfn) : NULL;
@@ -405,7 +405,7 @@ static void __init pud_leaf_tests(struct
 {
 	pud_t pud;
 
-	if (!has_transparent_hugepage())
+	if (!has_transparent_pud_hugepage())
 		return;
 
 	pr_debug("Validating PUD leaf\n");
@@ -732,7 +732,7 @@ static void __init pud_devmap_tests(stru
 {
 	pud_t pud;
 
-	if (!has_transparent_hugepage())
+	if (!has_transparent_pud_hugepage())
 		return;
 
 	pr_debug("Validating PUD devmap\n");
@@ -981,7 +981,7 @@ static void __init pud_thp_tests(struct
 {
 	pud_t pud;
 
-	if (!has_transparent_hugepage())
+	if (!has_transparent_pud_hugepage())
 		return;
 
 	pr_debug("Validating PUD based THP\n");
@@ -1022,8 +1022,7 @@ static void __init destroy_args(struct p
 
 	/* Free (huge) page */
 	if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) &&
-	    IS_ENABLED(CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD) &&
-	    has_transparent_hugepage() &&
+	    has_transparent_pud_hugepage() &&
 	    args->pud_pfn != ULONG_MAX) {
 		if (args->is_contiguous_page) {
 			free_contig_range(args->pud_pfn,
@@ -1274,8 +1273,7 @@ static int __init init_args(struct pgtab
 	 * if we fail to allocate (huge) pages.
 	 */
 	if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) &&
-	    IS_ENABLED(CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD) &&
-	    has_transparent_hugepage()) {
+	    has_transparent_pud_hugepage()) {
 		page = debug_vm_pgtable_alloc_huge_page(args,
 				HPAGE_PUD_SHIFT - PAGE_SHIFT);
 		if (page) {
_

Patches currently in -mm which might be from aneesh.kumar@linux.ibm.com are

mm-memory_hotplug-simplify-arch_mhp_memmap_on_memory_enable-kconfig.patch
mm-memory_hotplug-allow-memmap-on-memory-hotplug-request-to-fallback.patch
mm-memory_hotplug-allow-architecture-to-override-memmap-on-memory-support-check.patch
mm-memory_hotplug-support-memmap_on_memory-when-memmap-is-not-aligned-to-pageblocks.patch
powerpc-book3s64-memhotplug-enable-memmap-on-memory-for-radix.patch
mm-memory_hotplug-embed-vmem_altmap-details-in-memory-block.patch

