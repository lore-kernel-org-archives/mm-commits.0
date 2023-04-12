Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63100C77B6C
	for <mm-commits@archiver.kernel.org>; Wed, 12 Apr 2023 21:32:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229451AbjDLVc6 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 12 Apr 2023 17:32:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229492AbjDLVc6 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 12 Apr 2023 17:32:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1C167A9A
        for <mm-commits@vger.kernel.org>; Wed, 12 Apr 2023 14:32:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4A9D26397A
        for <mm-commits@vger.kernel.org>; Wed, 12 Apr 2023 21:32:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7442C4339B;
        Wed, 12 Apr 2023 21:32:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1681335175;
        bh=z4bz+/QpxZdgTqU4i/Ck5boxIySSRn91u91RjXvcd78=;
        h=Date:To:From:Subject:From;
        b=loGp61QqIaONtVFhxqFCQ8II4SgLDje/qOTtFhdNPsUJJy6s5FE3Ikz6b2E7MP+wV
         1OiBcP8o7GGyuxjWvye3CuhU71dgPuLTU66Gc3JeUN1DX8kMtwm0GrC+B6EfWwoDy/
         llIkvOAMlnKtFVLenoBgokbSvxnzJ+GRCxKlo7hY=
Date:   Wed, 12 Apr 2023 14:32:55 -0700
To:     mm-commits@vger.kernel.org, tsahu@linux.ibm.com,
        songmuchun@bytedance.com, mike.kravetz@oracle.com,
        joao.m.martins@oracle.com, dan.j.williams@intel.com,
        aneesh.kumar@linux.ibm.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb_vmemmap-rename-arch_want_hugetlb_page_optimize_vmemmap.patch added to mm-unstable branch
Message-Id: <20230412213255.A7442C4339B@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hugetlb_vmemmap: rename ARCH_WANT_HUGETLB_PAGE_OPTIMIZE_VMEMMAP
has been added to the -mm mm-unstable branch.  Its filename is
     mm-hugetlb_vmemmap-rename-arch_want_hugetlb_page_optimize_vmemmap.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb_vmemmap-rename-arch_want_hugetlb_page_optimize_vmemmap.patch

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
Subject: mm/hugetlb_vmemmap: rename ARCH_WANT_HUGETLB_PAGE_OPTIMIZE_VMEMMAP
Date: Wed, 12 Apr 2023 10:30:25 +0530

Now we use ARCH_WANT_HUGETLB_PAGE_OPTIMIZE_VMEMMAP config option to
indicate devdax and hugetlb vmemmap optimization support.  Hence rename
that to a generic ARCH_WANT_OPTIMIZE_VMEMMAP

Link: https://lkml.kernel.org/r/20230412050025.84346-2-aneesh.kumar@linux.ibm.com
Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Reviewed-by: Muchun Song <songmuchun@bytedance.com>
Cc: Joao Martins <joao.m.martins@oracle.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Tarun Sahu <tsahu@linux.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/loongarch/Kconfig |    2 +-
 arch/s390/Kconfig      |    2 +-
 arch/x86/Kconfig       |    2 +-
 fs/Kconfig             |    9 +--------
 include/linux/mm.h     |    2 +-
 mm/Kconfig             |    6 ++++++
 6 files changed, 11 insertions(+), 12 deletions(-)

--- a/arch/loongarch/Kconfig~mm-hugetlb_vmemmap-rename-arch_want_hugetlb_page_optimize_vmemmap
+++ a/arch/loongarch/Kconfig
@@ -53,8 +53,8 @@ config LOONGARCH
 	select ARCH_USE_QUEUED_RWLOCKS
 	select ARCH_USE_QUEUED_SPINLOCKS
 	select ARCH_WANT_DEFAULT_TOPDOWN_MMAP_LAYOUT
-	select ARCH_WANT_HUGETLB_PAGE_OPTIMIZE_VMEMMAP
 	select ARCH_WANT_LD_ORPHAN_WARN
+	select ARCH_WANT_OPTIMIZE_VMEMMAP
 	select ARCH_WANTS_NO_INSTR
 	select BUILDTIME_TABLE_SORT
 	select COMMON_CLK
--- a/arch/s390/Kconfig~mm-hugetlb_vmemmap-rename-arch_want_hugetlb_page_optimize_vmemmap
+++ a/arch/s390/Kconfig
@@ -126,8 +126,8 @@ config S390
 	select ARCH_WANTS_DYNAMIC_TASK_STRUCT
 	select ARCH_WANTS_NO_INSTR
 	select ARCH_WANT_DEFAULT_BPF_JIT
-	select ARCH_WANT_HUGETLB_PAGE_OPTIMIZE_VMEMMAP
 	select ARCH_WANT_IPC_PARSE_VERSION
+	select ARCH_WANT_OPTIMIZE_VMEMMAP
 	select BUILDTIME_TABLE_SORT
 	select CLONE_BACKWARDS2
 	select DMA_OPS if PCI
--- a/arch/x86/Kconfig~mm-hugetlb_vmemmap-rename-arch_want_hugetlb_page_optimize_vmemmap
+++ a/arch/x86/Kconfig
@@ -126,8 +126,8 @@ config X86
 	select ARCH_WANTS_NO_INSTR
 	select ARCH_WANT_GENERAL_HUGETLB
 	select ARCH_WANT_HUGE_PMD_SHARE
-	select ARCH_WANT_HUGETLB_PAGE_OPTIMIZE_VMEMMAP	if X86_64
 	select ARCH_WANT_LD_ORPHAN_WARN
+	select ARCH_WANT_OPTIMIZE_VMEMMAP	if X86_64
 	select ARCH_WANTS_THP_SWAP		if X86_64
 	select ARCH_HAS_PARANOID_L1D_FLUSH
 	select BUILDTIME_TABLE_SORT
--- a/fs/Kconfig~mm-hugetlb_vmemmap-rename-arch_want_hugetlb_page_optimize_vmemmap
+++ a/fs/Kconfig
@@ -250,16 +250,9 @@ config HUGETLBFS
 config HUGETLB_PAGE
 	def_bool HUGETLBFS
 
-#
-# Select this config option from the architecture Kconfig, if it is preferred
-# to enable the feature of HugeTLB Vmemmap Optimization (HVO).
-#
-config ARCH_WANT_HUGETLB_PAGE_OPTIMIZE_VMEMMAP
-	bool
-
 config HUGETLB_PAGE_OPTIMIZE_VMEMMAP
 	def_bool HUGETLB_PAGE
-	depends on ARCH_WANT_HUGETLB_PAGE_OPTIMIZE_VMEMMAP
+	depends on ARCH_WANT_OPTIMIZE_VMEMMAP
 	depends on SPARSEMEM_VMEMMAP
 
 config HUGETLB_PAGE_OPTIMIZE_VMEMMAP_DEFAULT_ON
--- a/include/linux/mm.h~mm-hugetlb_vmemmap-rename-arch_want_hugetlb_page_optimize_vmemmap
+++ a/include/linux/mm.h
@@ -3562,7 +3562,7 @@ void vmemmap_free(unsigned long start, u
 		struct vmem_altmap *altmap);
 #endif
 
-#ifdef CONFIG_ARCH_WANT_HUGETLB_PAGE_OPTIMIZE_VMEMMAP
+#ifdef CONFIG_ARCH_WANT_OPTIMIZE_VMEMMAP
 static inline bool vmemmap_can_optimize(struct vmem_altmap *altmap,
 					   struct dev_pagemap *pgmap)
 {
--- a/mm/Kconfig~mm-hugetlb_vmemmap-rename-arch_want_hugetlb_page_optimize_vmemmap
+++ a/mm/Kconfig
@@ -479,6 +479,12 @@ config SPARSEMEM_VMEMMAP
 	  SPARSEMEM_VMEMMAP uses a virtually mapped memmap to optimise
 	  pfn_to_page and page_to_pfn operations.  This is the most
 	  efficient option when sufficient kernel resources are available.
+#
+# Select this config option from the architecture Kconfig, if it is preferred
+# to enable the feature of HugeTLB/dev_dax vmemmap optimization.
+#
+config ARCH_WANT_OPTIMIZE_VMEMMAP
+	bool
 
 config HAVE_MEMBLOCK_PHYS_MAP
 	bool
_

Patches currently in -mm which might be from aneesh.kumar@linux.ibm.com are

mm-vmemmap-devdax-fix-kernel-crash-when-probing-devdax-devices.patch
mm-hugetlb_vmemmap-rename-arch_want_hugetlb_page_optimize_vmemmap.patch

