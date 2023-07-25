Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D263EB64DD
	for <mm-commits@archiver.kernel.org>; Tue, 25 Jul 2023 19:31:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230044AbjGYTbL (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 25 Jul 2023 15:31:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230259AbjGYTbK (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 25 Jul 2023 15:31:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3503E2115
        for <mm-commits@vger.kernel.org>; Tue, 25 Jul 2023 12:31:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C451F61883
        for <mm-commits@vger.kernel.org>; Tue, 25 Jul 2023 19:31:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2311AC433C7;
        Tue, 25 Jul 2023 19:31:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1690313468;
        bh=fP/lcy0RgYBfPHHtcy1iokqCTmfphN5ZCtfhtyTWaRA=;
        h=Date:To:From:Subject:From;
        b=HvzLrMuwlwOdNruUKfwXai2TQ5cX/7WNFv93Ku+TU+mcELp/jQ0yoJKWfr6Lo+XkU
         xLwMXsuWW1lP4gRDAPwi8+Ny/qPIt/spWVEcUaVXO310KhMdh1QQrdxc3pshGXXtrT
         t2hyP6yEj1RAmnxreLN9W12Q8R6MGqt02ryakstA=
Date:   Tue, 25 Jul 2023 12:31:07 -0700
To:     mm-commits@vger.kernel.org, will@kernel.org, osalvador@suse.de,
        npiggin@gmail.com, muchun.song@linux.dev, mpe@ellerman.id.au,
        mike.kravetz@oracle.com, joao.m.martins@oracle.com,
        dan.j.williams@intel.com, christophe.leroy@csgroup.eu,
        catalin.marinas@arm.com, aneesh.kumar@linux.ibm.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugepage-pud-allow-arch-specific-helper-function-to-check-huge-page-pud-support.patch added to mm-unstable branch
Message-Id: <20230725193108.2311AC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hugepage pud: allow arch-specific helper function to check huge page pud support
has been added to the -mm mm-unstable branch.  Its filename is
     mm-hugepage-pud-allow-arch-specific-helper-function-to-check-huge-page-pud-support.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugepage-pud-allow-arch-specific-helper-function-to-check-huge-page-pud-support.patch

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


Architectures like powerpc would like to enable transparent huge page pud
support only with radix translation.  To support that add
has_transparent_pud_hugepage() helper that architectures can override.

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
 2 files changed, 4 insertions(+), 1 deletion(-)

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
_

Patches currently in -mm which might be from aneesh.kumar@linux.ibm.com are

mm-hugepage-pud-allow-arch-specific-helper-function-to-check-huge-page-pud-support.patch
mm-change-pudp_huge_get_and_clear_full-take-vm_area_struct-as-arg.patch
mm-vmemmap-improve-vmemmap_can_optimize-and-allow-architectures-to-override.patch
mm-vmemmap-allow-architectures-to-override-how-vmemmap-optimization-works.patch
mm-add-pud_same-similar-to-__have_arch_p4d_same.patch
mm-huge-pud-use-transparent-huge-pud-helpers-only-with-config_transparent_hugepage.patch
mm-vmemmap-optimization-split-hugetlb-and-devdax-vmemmap-optimization.patch
powerpc-mm-trace-convert-trace-event-to-trace-event-class.patch
powerpc-book3s64-mm-enable-transparent-pud-hugepage.patch
powerpc-book3s64-vmemmap-switch-radix-to-use-a-different-vmemmap-handling-function.patch
powerpc-book3s64-radix-add-support-for-vmemmap-optimization-for-radix.patch
powerpc-book3s64-radix-remove-mmu_vmemmap_psize.patch
powerpc-book3s64-radix-add-debug-message-to-give-more-details-of-vmemmap-allocation.patch

