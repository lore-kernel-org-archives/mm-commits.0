Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1786C433EF
	for <mm-commits@archiver.kernel.org>; Tue, 28 Jun 2022 19:25:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233204AbiF1TZz (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 28 Jun 2022 15:25:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233508AbiF1TZk (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 28 Jun 2022 15:25:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D01A19C21
        for <mm-commits@vger.kernel.org>; Tue, 28 Jun 2022 12:24:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 91B72616BA
        for <mm-commits@vger.kernel.org>; Tue, 28 Jun 2022 19:24:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6B8DC3411D;
        Tue, 28 Jun 2022 19:24:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1656444273;
        bh=rikdTepb0gpCRNv4nGfSDETaG4+bZocvf+gHvvdmYUY=;
        h=Date:To:From:Subject:From;
        b=VNy3Rp01e8Zv/5b6PjMqIpSkrgkLB4YStaJJAoAPVbP3zZc16pl5IK7LixaaoTQ+I
         lfXJ5sXWDIs/6+yNGyGiTMnBnQX/cHRSJRUH6PvZu0RGN8HqoXpD+CC4TrOq1iMXCA
         Sr1iSt3YD8rCHa2xUvnydvsTshz399Hs8oyiZppc=
Date:   Tue, 28 Jun 2022 12:24:32 -0700
To:     mm-commits@vger.kernel.org, will@kernel.org, osalvador@suse.de,
        mike.kravetz@oracle.com, duanxiongchun@bytedance.com,
        david@redhat.com, corbet@lwn.net, catalin.marinas@arm.com,
        anshuman.khandual@arm.com, songmuchun@bytedance.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb_vmemmap-introduce-the-name-hvo.patch added to mm-unstable branch
Message-Id: <20220628192432.E6B8DC3411D@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: hugetlb_vmemmap: introduce the name HVO
has been added to the -mm mm-unstable branch.  Its filename is
     mm-hugetlb_vmemmap-introduce-the-name-hvo.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb_vmemmap-introduce-the-name-hvo.patch

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
From: Muchun Song <songmuchun@bytedance.com>
Subject: mm: hugetlb_vmemmap: introduce the name HVO
Date: Tue, 28 Jun 2022 17:22:30 +0800

It it inconvenient to mention the feature of optimizing vmemmap pages
associated with HugeTLB pages when communicating with others since there
is no specific or abbreviated name for it when it is first introduced. 
Let us give it a name HVO (HugeTLB Vmemmap Optimization) from now.

This commit also updates the document about "hugetlb_free_vmemmap" by the
way discussed in thread [1].

Link: https://lore.kernel.org/all/21aae898-d54d-cc4b-a11f-1bb7fddcfffa@redhat.com/ [1]
Link: https://lkml.kernel.org/r/20220628092235.91270-4-songmuchun@bytedance.com
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Will Deacon <will@kernel.org>
Cc: Xiongchun Duan <duanxiongchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/kernel-parameters.txt |    7 ++++---
 Documentation/admin-guide/mm/hugetlbpage.rst    |    4 ++--
 Documentation/admin-guide/mm/memory-hotplug.rst |    4 ++--
 Documentation/admin-guide/sysctl/vm.rst         |    3 +--
 Documentation/mm/vmemmap_dedup.rst              |    2 ++
 fs/Kconfig                                      |   12 +++++-------
 include/linux/page-flags.h                      |    3 +--
 mm/hugetlb_vmemmap.c                            |    8 ++++----
 mm/hugetlb_vmemmap.h                            |    4 ++--
 9 files changed, 23 insertions(+), 24 deletions(-)

--- a/Documentation/admin-guide/kernel-parameters.txt~mm-hugetlb_vmemmap-introduce-the-name-hvo
+++ a/Documentation/admin-guide/kernel-parameters.txt
@@ -1712,12 +1712,13 @@
 	hugetlb_free_vmemmap=
 			[KNL] Reguires CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP
 			enabled.
+			Control if HugeTLB Vmemmap Optimization (HVO) is enabled.
 			Allows heavy hugetlb users to free up some more
 			memory (7 * PAGE_SIZE for each 2MB hugetlb page).
-			Format: { [oO][Nn]/Y/y/1 | [oO][Ff]/N/n/0 (default) }
+			Format: { on | off (default) }
 
-			[oO][Nn]/Y/y/1: enable the feature
-			[oO][Ff]/N/n/0: disable the feature
+			on: enable HVO
+			off: disable HVO
 
 			Built with CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP_DEFAULT_ON=y,
 			the default is on.
--- a/Documentation/admin-guide/mm/hugetlbpage.rst~mm-hugetlb_vmemmap-introduce-the-name-hvo
+++ a/Documentation/admin-guide/mm/hugetlbpage.rst
@@ -164,8 +164,8 @@ default_hugepagesz
 	will all result in 256 2M huge pages being allocated.  Valid default
 	huge page size is architecture dependent.
 hugetlb_free_vmemmap
-	When CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP is set, this enables optimizing
-	unused vmemmap pages associated with each HugeTLB page.
+	When CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP is set, this enables HugeTLB
+	Vmemmap Optimization (HVO).
 
 When multiple huge page sizes are supported, ``/proc/sys/vm/nr_hugepages``
 indicates the current number of pre-allocated huge pages of the default size.
--- a/Documentation/admin-guide/mm/memory-hotplug.rst~mm-hugetlb_vmemmap-introduce-the-name-hvo
+++ a/Documentation/admin-guide/mm/memory-hotplug.rst
@@ -653,8 +653,8 @@ block might fail:
 - Concurrent activity that operates on the same physical memory area, such as
   allocating gigantic pages, can result in temporary offlining failures.
 
-- Out of memory when dissolving huge pages, especially when freeing unused
-  vmemmap pages associated with each hugetlb page is enabled.
+- Out of memory when dissolving huge pages, especially when HugeTLB Vmemmap
+  Optimization (HVO) is enabled.
 
   Offlining code may be able to migrate huge page contents, but may not be able
   to dissolve the source huge page because it fails allocating (unmovable) pages
--- a/Documentation/admin-guide/sysctl/vm.rst~mm-hugetlb_vmemmap-introduce-the-name-hvo
+++ a/Documentation/admin-guide/sysctl/vm.rst
@@ -569,8 +569,7 @@ This knob is not available when the size
 in include/linux/mm_types.h) is not power of two (an unusual system config could
 result in this).
 
-Enable (set to 1) or disable (set to 0) the feature of optimizing vmemmap pages
-associated with each HugeTLB page.
+Enable (set to 1) or disable (set to 0) HugeTLB Vmemmap Optimization (HVO).
 
 Once enabled, the vmemmap pages of subsequent allocation of HugeTLB pages from
 buddy allocator will be optimized (7 pages per 2MB HugeTLB page and 4095 pages
--- a/Documentation/mm/vmemmap_dedup.rst~mm-hugetlb_vmemmap-introduce-the-name-hvo
+++ a/Documentation/mm/vmemmap_dedup.rst
@@ -7,6 +7,8 @@ A vmemmap diet for HugeTLB and Device DA
 HugeTLB
 =======
 
+This section is to explain how HugeTLB Vmemmap Optimization (HVO) works.
+
 The struct page structures (page structs) are used to describe a physical
 page frame. By default, there is a one-to-one mapping from a page frame to
 it's corresponding page struct.
--- a/fs/Kconfig~mm-hugetlb_vmemmap-introduce-the-name-hvo
+++ a/fs/Kconfig
@@ -247,8 +247,7 @@ config HUGETLB_PAGE
 
 #
 # Select this config option from the architecture Kconfig, if it is preferred
-# to enable the feature of minimizing overhead of struct page associated with
-# each HugeTLB page.
+# to enable the feature of HugeTLB Vmemmap Optimization (HVO).
 #
 config ARCH_WANT_HUGETLB_PAGE_OPTIMIZE_VMEMMAP
 	bool
@@ -259,14 +258,13 @@ config HUGETLB_PAGE_OPTIMIZE_VMEMMAP
 	depends on SPARSEMEM_VMEMMAP
 
 config HUGETLB_PAGE_OPTIMIZE_VMEMMAP_DEFAULT_ON
-	bool "Default optimizing vmemmap pages of HugeTLB to on"
+	bool "HugeTLB Vmemmap Optimization (HVO) defaults to on"
 	default n
 	depends on HUGETLB_PAGE_OPTIMIZE_VMEMMAP
 	help
-	  When using HUGETLB_PAGE_OPTIMIZE_VMEMMAP, the optimizing unused vmemmap
-	  pages associated with each HugeTLB page is default off. Say Y here
-	  to enable optimizing vmemmap pages of HugeTLB by default. It can then
-	  be disabled on the command line via hugetlb_free_vmemmap=off.
+	  The HugeTLB VmemmapvOptimization (HVO) defaults to off. Say Y here to
+	  enable HVO by default. It can be disabled via hugetlb_free_vmemmap=off
+	  (boot command line) or hugetlb_optimize_vmemmap (sysctl).
 
 config MEMFD_CREATE
 	def_bool TMPFS || HUGETLBFS
--- a/include/linux/page-flags.h~mm-hugetlb_vmemmap-introduce-the-name-hvo
+++ a/include/linux/page-flags.h
@@ -208,8 +208,7 @@ enum pageflags {
 DECLARE_STATIC_KEY_FALSE(hugetlb_optimize_vmemmap_key);
 
 /*
- * If the feature of optimizing vmemmap pages associated with each HugeTLB
- * page is enabled, the head vmemmap page frame is reused and all of the tail
+ * If HVO is enabled, the head vmemmap page frame is reused and all of the tail
  * vmemmap addresses map to the head vmemmap page frame (furture details can
  * refer to the figure at the head of the mm/hugetlb_vmemmap.c).  In other
  * words, there are more than one page struct with PG_head associated with each
--- a/mm/hugetlb_vmemmap.c~mm-hugetlb_vmemmap-introduce-the-name-hvo
+++ a/mm/hugetlb_vmemmap.c
@@ -1,8 +1,8 @@
 // SPDX-License-Identifier: GPL-2.0
 /*
- * Optimize vmemmap pages associated with HugeTLB
+ * HugeTLB Vmemmap Optimization (HVO)
  *
- * Copyright (c) 2020, Bytedance. All rights reserved.
+ * Copyright (c) 2020, ByteDance. All rights reserved.
  *
  *     Author: Muchun Song <songmuchun@bytedance.com>
  *
@@ -156,8 +156,8 @@ void __init hugetlb_vmemmap_init(struct
 
 	/*
 	 * There are only (RESERVE_VMEMMAP_SIZE / sizeof(struct page)) struct
-	 * page structs that can be used when CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP,
-	 * so add a BUILD_BUG_ON to catch invalid usage of the tail struct page.
+	 * page structs that can be used when HVO is enabled, add a BUILD_BUG_ON
+	 * to catch invalid usage of the tail page structs.
 	 */
 	BUILD_BUG_ON(__NR_USED_SUBPAGE >=
 		     RESERVE_VMEMMAP_SIZE / sizeof(struct page));
--- a/mm/hugetlb_vmemmap.h~mm-hugetlb_vmemmap-introduce-the-name-hvo
+++ a/mm/hugetlb_vmemmap.h
@@ -1,8 +1,8 @@
 // SPDX-License-Identifier: GPL-2.0
 /*
- * Optimize vmemmap pages associated with HugeTLB
+ * HugeTLB Vmemmap Optimization (HVO)
  *
- * Copyright (c) 2020, Bytedance. All rights reserved.
+ * Copyright (c) 2020, ByteDance. All rights reserved.
  *
  *     Author: Muchun Song <songmuchun@bytedance.com>
  */
_

Patches currently in -mm which might be from songmuchun@bytedance.com are

mm-sparsemem-fix-missing-higher-order-allocation-splitting.patch
mm-memory_hotplug-enumerate-all-supported-section-flags.patch
mm-memory_hotplug-enumerate-all-supported-section-flags-v5.patch
mm-memory_hotplug-make-hugetlb_optimize_vmemmap-compatible-with-memmap_on_memory.patch
mm-memory_hotplug-make-hugetlb_optimize_vmemmap-compatible-with-memmap_on_memory-v5.patch
mm-hugetlb-remove-minimum_order-variable.patch
mm-memcontrol-remove-dead-code-and-comments.patch
mm-rename-unlock_page_lruvec_irq-_irqrestore-to-lruvec_unlock_irq-_irqrestore.patch
mm-memcontrol-prepare-objcg-api-for-non-kmem-usage.patch
mm-memcontrol-make-lruvec-lock-safe-when-lru-pages-are-reparented.patch
mm-vmscan-rework-move_pages_to_lru.patch
mm-thp-make-split-queue-lock-safe-when-lru-pages-are-reparented.patch
mm-memcontrol-make-all-the-callers-of-foliopage_memcg-safe.patch
mm-memcontrol-introduce-memcg_reparent_ops.patch
mm-memcontrol-use-obj_cgroup-apis-to-charge-the-lru-pages.patch
mm-lru-add-vm_warn_on_once_folio-to-lru-maintenance-function.patch
mm-hugetlb_vmemmap-delete-hugetlb_optimize_vmemmap_enabled.patch
mm-hugetlb_vmemmap-optimize-vmemmap_optimize_mode-handling.patch
mm-hugetlb_vmemmap-introduce-the-name-hvo.patch
mm-hugetlb_vmemmap-move-vmemmap-code-related-to-hugetlb-to-hugetlb_vmemmapc.patch
mm-hugetlb_vmemmap-replace-early_param-with-core_param.patch
mm-hugetlb_vmemmap-improve-hugetlb_vmemmap-code-readability.patch
mm-hugetlb_vmemmap-move-code-comments-to-vmemmap_deduprst.patch
mm-hugetlb_vmemmap-use-ptrs_per_pte-instead-of-pmd_size-page_size.patch

