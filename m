Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1A30C41513
	for <mm-commits@archiver.kernel.org>; Fri, 11 Aug 2023 23:06:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237195AbjHKXGh (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 11 Aug 2023 19:06:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237117AbjHKXFV (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 11 Aug 2023 19:05:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A2793C32
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 16:03:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CEC8B67AD3
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 23:03:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31948C433C8;
        Fri, 11 Aug 2023 23:03:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691794998;
        bh=a4s9WYsHdZzawcI4HUml72X0AVY/v7KRuOIgdFyM+Rw=;
        h=Date:To:From:Subject:From;
        b=1H0AU+lZxCKOBf377fOMtXqSWbwGnXOA51VreKqtsYDt6JPmPZ3EFT6zGiurbalsB
         +47uCYUKY6NGIkBLxR+dFSqbFhBvTfaWejVOmPwG3M/n+C3zs/BaNrC31BRS1l1D0R
         zoGmsQoZcM0BwIwq/evH/h7swjh9Ic4KIxyaYxQ8=
Date:   Fri, 11 Aug 2023 16:03:17 -0700
To:     mm-commits@vger.kernel.org, will@kernel.org, osalvador@suse.de,
        npiggin@gmail.com, muchun.song@linux.dev, mpe@ellerman.id.au,
        mike.kravetz@oracle.com, joao.m.martins@oracle.com,
        dan.j.williams@intel.com, christophe.leroy@csgroup.eu,
        catalin.marinas@arm.com, aneesh.kumar@linux.ibm.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-vmemmap-optimization-split-hugetlb-and-devdax-vmemmap-optimization.patch removed from -mm tree
Message-Id: <20230811230318.31948C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/vmemmap optimization: split hugetlb and devdax vmemmap optimization
has been removed from the -mm tree.  Its filename was
     mm-vmemmap-optimization-split-hugetlb-and-devdax-vmemmap-optimization.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Subject: mm/vmemmap optimization: split hugetlb and devdax vmemmap optimization
Date: Tue, 25 Jul 2023 00:37:53 +0530

Arm disabled hugetlb vmemmap optimization [1] because hugetlb vmemmap
optimization includes an update of both the permissions (writeable to
read-only) and the output address (pfn) of the vmemmap ptes.  That is not
supported without unmapping of pte(marking it invalid) by some
architectures.

With DAX vmemmap optimization we don't require such pte updates and
architectures can enable DAX vmemmap optimization while having hugetlb
vmemmap optimization disabled.  Hence split DAX optimization support into
a different config.

s390, loongarch and riscv don't have devdax support.  So the DAX config is
not enabled for them.  With this change, arm64 should be able to select
DAX optimization

[1] commit 060a2c92d1b6 ("arm64: mm: hugetlb: Disable HUGETLB_PAGE_OPTIMIZE_VMEMMAP")

Link: https://lkml.kernel.org/r/20230724190759.483013-8-aneesh.kumar@linux.ibm.com
Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
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

 arch/loongarch/Kconfig |    2 +-
 arch/riscv/Kconfig     |    2 +-
 arch/s390/Kconfig      |    2 +-
 arch/x86/Kconfig       |    3 ++-
 fs/Kconfig             |    2 +-
 include/linux/mm.h     |    2 +-
 mm/Kconfig             |    5 ++++-
 7 files changed, 11 insertions(+), 7 deletions(-)

--- a/arch/loongarch/Kconfig~mm-vmemmap-optimization-split-hugetlb-and-devdax-vmemmap-optimization
+++ a/arch/loongarch/Kconfig
@@ -60,7 +60,7 @@ config LOONGARCH
 	select ARCH_USE_QUEUED_SPINLOCKS
 	select ARCH_WANT_DEFAULT_TOPDOWN_MMAP_LAYOUT
 	select ARCH_WANT_LD_ORPHAN_WARN
-	select ARCH_WANT_OPTIMIZE_VMEMMAP
+	select ARCH_WANT_OPTIMIZE_HUGETLB_VMEMMAP
 	select ARCH_WANTS_NO_INSTR
 	select BUILDTIME_TABLE_SORT
 	select COMMON_CLK
--- a/arch/riscv/Kconfig~mm-vmemmap-optimization-split-hugetlb-and-devdax-vmemmap-optimization
+++ a/arch/riscv/Kconfig
@@ -53,7 +53,7 @@ config RISCV
 	select ARCH_WANT_GENERAL_HUGETLB if !RISCV_ISA_SVNAPOT
 	select ARCH_WANT_HUGE_PMD_SHARE if 64BIT
 	select ARCH_WANT_LD_ORPHAN_WARN if !XIP_KERNEL
-	select ARCH_WANT_OPTIMIZE_VMEMMAP
+	select ARCH_WANT_OPTIMIZE_HUGETLB_VMEMMAP
 	select ARCH_WANTS_THP_SWAP if HAVE_ARCH_TRANSPARENT_HUGEPAGE
 	select BINFMT_FLAT_NO_DATA_START_OFFSET if !MMU
 	select BUILDTIME_TABLE_SORT if MMU
--- a/arch/s390/Kconfig~mm-vmemmap-optimization-split-hugetlb-and-devdax-vmemmap-optimization
+++ a/arch/s390/Kconfig
@@ -127,7 +127,7 @@ config S390
 	select ARCH_WANTS_NO_INSTR
 	select ARCH_WANT_DEFAULT_BPF_JIT
 	select ARCH_WANT_IPC_PARSE_VERSION
-	select ARCH_WANT_OPTIMIZE_VMEMMAP
+	select ARCH_WANT_OPTIMIZE_HUGETLB_VMEMMAP
 	select BUILDTIME_TABLE_SORT
 	select CLONE_BACKWARDS2
 	select DMA_OPS if PCI
--- a/arch/x86/Kconfig~mm-vmemmap-optimization-split-hugetlb-and-devdax-vmemmap-optimization
+++ a/arch/x86/Kconfig
@@ -128,7 +128,8 @@ config X86
 	select ARCH_WANT_GENERAL_HUGETLB
 	select ARCH_WANT_HUGE_PMD_SHARE
 	select ARCH_WANT_LD_ORPHAN_WARN
-	select ARCH_WANT_OPTIMIZE_VMEMMAP	if X86_64
+	select ARCH_WANT_OPTIMIZE_DAX_VMEMMAP	if X86_64
+	select ARCH_WANT_OPTIMIZE_HUGETLB_VMEMMAP	if X86_64
 	select ARCH_WANTS_THP_SWAP		if X86_64
 	select ARCH_HAS_PARANOID_L1D_FLUSH
 	select BUILDTIME_TABLE_SORT
--- a/fs/Kconfig~mm-vmemmap-optimization-split-hugetlb-and-devdax-vmemmap-optimization
+++ a/fs/Kconfig
@@ -254,7 +254,7 @@ config HUGETLB_PAGE
 
 config HUGETLB_PAGE_OPTIMIZE_VMEMMAP
 	def_bool HUGETLB_PAGE
-	depends on ARCH_WANT_OPTIMIZE_VMEMMAP
+	depends on ARCH_WANT_OPTIMIZE_HUGETLB_VMEMMAP
 	depends on SPARSEMEM_VMEMMAP
 
 config HUGETLB_PAGE_OPTIMIZE_VMEMMAP_DEFAULT_ON
--- a/include/linux/mm.h~mm-vmemmap-optimization-split-hugetlb-and-devdax-vmemmap-optimization
+++ a/include/linux/mm.h
@@ -3633,7 +3633,7 @@ void vmemmap_free(unsigned long start, u
 #endif
 
 #define VMEMMAP_RESERVE_NR	2
-#ifdef CONFIG_ARCH_WANT_OPTIMIZE_VMEMMAP
+#ifdef CONFIG_ARCH_WANT_OPTIMIZE_DAX_VMEMMAP
 static inline bool __vmemmap_can_optimize(struct vmem_altmap *altmap,
 					  struct dev_pagemap *pgmap)
 {
--- a/mm/Kconfig~mm-vmemmap-optimization-split-hugetlb-and-devdax-vmemmap-optimization
+++ a/mm/Kconfig
@@ -487,7 +487,10 @@ config SPARSEMEM_VMEMMAP
 # Select this config option from the architecture Kconfig, if it is preferred
 # to enable the feature of HugeTLB/dev_dax vmemmap optimization.
 #
-config ARCH_WANT_OPTIMIZE_VMEMMAP
+config ARCH_WANT_OPTIMIZE_DAX_VMEMMAP
+	bool
+
+config ARCH_WANT_OPTIMIZE_HUGETLB_VMEMMAP
 	bool
 
 config HAVE_MEMBLOCK_PHYS_MAP
_

Patches currently in -mm which might be from aneesh.kumar@linux.ibm.com are

mm-memory_hotplug-simplify-arch_mhp_memmap_on_memory_enable-kconfig.patch
mm-memory_hotplug-allow-memmap-on-memory-hotplug-request-to-fallback.patch
mm-memory_hotplug-allow-architecture-to-override-memmap-on-memory-support-check.patch
mm-memory_hotplug-support-memmap_on_memory-when-memmap-is-not-aligned-to-pageblocks.patch
powerpc-book3s64-memhotplug-enable-memmap-on-memory-for-radix.patch
mm-memory_hotplug-embed-vmem_altmap-details-in-memory-block.patch

