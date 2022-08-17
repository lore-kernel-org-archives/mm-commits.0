Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C212C25B08
	for <mm-commits@archiver.kernel.org>; Wed, 17 Aug 2022 19:04:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241388AbiHQTEV (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 17 Aug 2022 15:04:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231939AbiHQTER (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 17 Aug 2022 15:04:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E76841D1C
        for <mm-commits@vger.kernel.org>; Wed, 17 Aug 2022 12:04:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3657AB81F05
        for <mm-commits@vger.kernel.org>; Wed, 17 Aug 2022 19:03:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B313DC433D6;
        Wed, 17 Aug 2022 19:03:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1660763036;
        bh=rFcYtf3iHDz+Anh2YN6tPzVOBXvfpjzjHHUYZ/ted0I=;
        h=Date:To:From:Subject:From;
        b=Ldd0kdGIE6w+MARNWEn/am3aTZCbcSfJQU5UkZX7huAhkXgYCuvBIivS7JQbKRCzD
         jk3sc8Sq7OwEJzbS1ogEBp8eGpu8olkE1aAAokC/i2Vn69te5TQdbagQmHN+yXnhEi
         KuOAg2siqJZG6bN//09qcCw0O3hT10L2crwUPwO8=
Date:   Wed, 17 Aug 2022 12:03:56 -0700
To:     mm-commits@vger.kernel.org, zhengqi.arch@bytedance.com,
        willy@infradead.org, will@kernel.org, vbabka@suse.cz,
        vaibhav@linux.ibm.com, tj@kernel.org, szhai2@cs.rochester.edu,
        suleiman@google.com, steven@liquorix.net, sofia.trinh@edi.works,
        rppt@kernel.org, peterz@infradead.org, oleksandr@natalenko.name,
        Michael@MichaelLarabel.com, mhocko@kernel.org, mgorman@suse.de,
        linmiaohe@huawei.com, holger@applied-asynchrony.com,
        Hi-Angel@yandex.ru, heftig@archlinux.org, hdanton@sina.com,
        hannes@cmpxchg.org, djbyrne@mtu.edu, d@chaos-reins.com,
        dave.hansen@linux.intel.com, corbet@lwn.net,
        catalin.marinas@arm.com, bgeffon@google.com, baohua@kernel.org,
        axboe@kernel.dk, aneesh.kumar@linux.ibm.com, ak@linux.intel.com,
        yuzhao@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-x86-add-config_arch_has_nonleaf_pmd_young.patch added to mm-unstable branch
Message-Id: <20220817190356.B313DC433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: x86: add CONFIG_ARCH_HAS_NONLEAF_PMD_YOUNG
has been added to the -mm mm-unstable branch.  Its filename is
     mm-x86-add-config_arch_has_nonleaf_pmd_young.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-x86-add-config_arch_has_nonleaf_pmd_young.patch

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
From: Yu Zhao <yuzhao@google.com>
Subject: mm: x86: add CONFIG_ARCH_HAS_NONLEAF_PMD_YOUNG
Date: Mon, 15 Aug 2022 01:13:21 -0600

Some architectures support the accessed bit in non-leaf PMD entries, e.g.,
x86 sets the accessed bit in a non-leaf PMD entry when using it as part of
linear address translation [1].  Page table walkers that clear the
accessed bit may use this capability to reduce their search space.

Note that:
1. Although an inline function is preferable, this capability is added
   as a configuration option for consistency with the existing macros.
2. Due to the little interest in other varieties, this capability was
   only tested on Intel and AMD CPUs.

Thanks to the following developers for their efforts [2][3].
  Randy Dunlap <rdunlap@infradead.org>
  Stephen Rothwell <sfr@canb.auug.org.au>

[1]: Intel 64 and IA-32 Architectures Software Developer's Manual
     Volume 3 (June 2021), section 4.8
[2] https://lore.kernel.org/r/bfdcc7c8-922f-61a9-aa15-7e7250f04af7@infradead.org/
[3] https://lore.kernel.org/r/20220413151513.5a0d7a7e@canb.auug.org.au/

Link: https://lkml.kernel.org/r/20220815071332.627393-3-yuzhao@google.com
Signed-off-by: Yu Zhao <yuzhao@google.com>
Reviewed-by: Barry Song <baohua@kernel.org>
Acked-by: Brian Geffon <bgeffon@google.com>
Acked-by: Jan Alexander Steffens (heftig) <heftig@archlinux.org>
Acked-by: Oleksandr Natalenko <oleksandr@natalenko.name>
Acked-by: Steven Barrett <steven@liquorix.net>
Acked-by: Suleiman Souhlal <suleiman@google.com>
Tested-by: Daniel Byrne <djbyrne@mtu.edu>
Tested-by: Donald Carr <d@chaos-reins.com>
Tested-by: Holger Hoffstätte <holger@applied-asynchrony.com>
Tested-by: Konstantin Kharlamov <Hi-Angel@yandex.ru>
Tested-by: Shuang Zhai <szhai2@cs.rochester.edu>
Tested-by: Sofia Trinh <sofia.trinh@edi.works>
Tested-by: Vaibhav Jain <vaibhav@linux.ibm.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Hillf Danton <hdanton@sina.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Michael Larabel <Michael@MichaelLarabel.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/Kconfig                   |    8 ++++++++
 arch/x86/Kconfig               |    1 +
 arch/x86/include/asm/pgtable.h |    3 ++-
 arch/x86/mm/pgtable.c          |    5 ++++-
 include/linux/pgtable.h        |    4 ++--
 5 files changed, 17 insertions(+), 4 deletions(-)

--- a/arch/Kconfig~mm-x86-add-config_arch_has_nonleaf_pmd_young
+++ a/arch/Kconfig
@@ -1416,6 +1416,14 @@ config DYNAMIC_SIGFRAME
 config HAVE_ARCH_NODE_DEV_GROUP
 	bool
 
+config ARCH_HAS_NONLEAF_PMD_YOUNG
+	bool
+	help
+	  Architectures that select this option are capable of setting the
+	  accessed bit in non-leaf PMD entries when using them as part of linear
+	  address translations. Page table walkers that clear the accessed bit
+	  may use this capability to reduce their search space.
+
 source "kernel/gcov/Kconfig"
 
 source "scripts/gcc-plugins/Kconfig"
--- a/arch/x86/include/asm/pgtable.h~mm-x86-add-config_arch_has_nonleaf_pmd_young
+++ a/arch/x86/include/asm/pgtable.h
@@ -815,7 +815,8 @@ static inline unsigned long pmd_page_vad
 
 static inline int pmd_bad(pmd_t pmd)
 {
-	return (pmd_flags(pmd) & ~_PAGE_USER) != _KERNPG_TABLE;
+	return (pmd_flags(pmd) & ~(_PAGE_USER | _PAGE_ACCESSED)) !=
+	       (_KERNPG_TABLE & ~_PAGE_ACCESSED);
 }
 
 static inline unsigned long pages_to_mb(unsigned long npg)
--- a/arch/x86/Kconfig~mm-x86-add-config_arch_has_nonleaf_pmd_young
+++ a/arch/x86/Kconfig
@@ -85,6 +85,7 @@ config X86
 	select ARCH_HAS_PMEM_API		if X86_64
 	select ARCH_HAS_PTE_DEVMAP		if X86_64
 	select ARCH_HAS_PTE_SPECIAL
+	select ARCH_HAS_NONLEAF_PMD_YOUNG	if PGTABLE_LEVELS > 2
 	select ARCH_HAS_UACCESS_FLUSHCACHE	if X86_64
 	select ARCH_HAS_COPY_MC			if X86_64
 	select ARCH_HAS_SET_MEMORY
--- a/arch/x86/mm/pgtable.c~mm-x86-add-config_arch_has_nonleaf_pmd_young
+++ a/arch/x86/mm/pgtable.c
@@ -550,7 +550,7 @@ int ptep_test_and_clear_young(struct vm_
 	return ret;
 }
 
-#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+#if defined(CONFIG_TRANSPARENT_HUGEPAGE) || defined(CONFIG_ARCH_HAS_NONLEAF_PMD_YOUNG)
 int pmdp_test_and_clear_young(struct vm_area_struct *vma,
 			      unsigned long addr, pmd_t *pmdp)
 {
@@ -562,6 +562,9 @@ int pmdp_test_and_clear_young(struct vm_
 
 	return ret;
 }
+#endif
+
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
 int pudp_test_and_clear_young(struct vm_area_struct *vma,
 			      unsigned long addr, pud_t *pudp)
 {
--- a/include/linux/pgtable.h~mm-x86-add-config_arch_has_nonleaf_pmd_young
+++ a/include/linux/pgtable.h
@@ -213,7 +213,7 @@ static inline int ptep_test_and_clear_yo
 #endif
 
 #ifndef __HAVE_ARCH_PMDP_TEST_AND_CLEAR_YOUNG
-#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+#if defined(CONFIG_TRANSPARENT_HUGEPAGE) || defined(CONFIG_ARCH_HAS_NONLEAF_PMD_YOUNG)
 static inline int pmdp_test_and_clear_young(struct vm_area_struct *vma,
 					    unsigned long address,
 					    pmd_t *pmdp)
@@ -234,7 +234,7 @@ static inline int pmdp_test_and_clear_yo
 	BUILD_BUG();
 	return 0;
 }
-#endif /* CONFIG_TRANSPARENT_HUGEPAGE */
+#endif /* CONFIG_TRANSPARENT_HUGEPAGE || CONFIG_ARCH_HAS_NONLEAF_PMD_YOUNG */
 #endif
 
 #ifndef __HAVE_ARCH_PTEP_CLEAR_YOUNG_FLUSH
_

Patches currently in -mm which might be from yuzhao@google.com are

mm-x86-arm64-add-arch_has_hw_pte_young.patch
mm-x86-add-config_arch_has_nonleaf_pmd_young.patch
mm-vmscanc-refactor-shrink_node.patch
revert-include-linux-mm_inlineh-fold-__update_lru_size-into-its-sole-caller.patch
mm-multi-gen-lru-groundwork.patch
mm-multi-gen-lru-minimal-implementation.patch
mm-multi-gen-lru-exploit-locality-in-rmap.patch
mm-multi-gen-lru-support-page-table-walks.patch
mm-multi-gen-lru-optimize-multiple-memcgs.patch
mm-multi-gen-lru-kill-switch.patch
mm-multi-gen-lru-thrashing-prevention.patch
mm-multi-gen-lru-debugfs-interface.patch
mm-multi-gen-lru-admin-guide.patch
mm-multi-gen-lru-design-doc.patch

