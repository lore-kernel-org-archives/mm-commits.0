Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 344DBC6FD18
	for <mm-commits@archiver.kernel.org>; Tue, 18 Apr 2023 23:38:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231598AbjDRXit (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 18 Apr 2023 19:38:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231673AbjDRXgz (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 18 Apr 2023 19:36:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC28210247
        for <mm-commits@vger.kernel.org>; Tue, 18 Apr 2023 16:35:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C46C462F22
        for <mm-commits@vger.kernel.org>; Tue, 18 Apr 2023 23:35:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27EDEC433D2;
        Tue, 18 Apr 2023 23:35:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1681860943;
        bh=JHS0ViLXfbaRo8lzVBSl0kfIbfYTYI52HtfT3hnpM54=;
        h=Date:To:From:Subject:From;
        b=n3hQA90OSwgoI2ZFyRtDQJbA4scOqf9f/sSz50XeGsLtEXFR4nv56FAQJLtaBY+NP
         xQj/0o9X9jxUQ8Y9myG7l5VfNI69iAuM8hGyxJdOOsjOfJz4qvo4TmW8u84aGQrvRi
         zwyXrrR4C+N5SLXREhWnzg3c6L6KzzE1MbiZ0hL8=
Date:   Tue, 18 Apr 2023 16:35:42 -0700
To:     mm-commits@vger.kernel.org, tsahu@linux.ibm.com,
        songmuchun@bytedance.com, mike.kravetz@oracle.com,
        joao.m.martins@oracle.com, dan.j.williams@intel.com,
        aneesh.kumar@linux.ibm.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-hugetlb_vmemmap-rename-arch_want_hugetlb_page_optimize_vmemmap.patch removed from -mm tree
Message-Id: <20230418233543.27EDEC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/hugetlb_vmemmap: rename ARCH_WANT_HUGETLB_PAGE_OPTIMIZE_VMEMMAP
has been removed from the -mm tree.  Its filename was
     mm-hugetlb_vmemmap-rename-arch_want_hugetlb_page_optimize_vmemmap.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
@@ -3561,7 +3561,7 @@ void vmemmap_free(unsigned long start, u
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


