Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70C02C43334
	for <mm-commits@archiver.kernel.org>; Mon,  4 Jul 2022 01:12:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232849AbiGDBMW (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 3 Jul 2022 21:12:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232864AbiGDBLL (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 3 Jul 2022 21:11:11 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DD9163E4
        for <mm-commits@vger.kernel.org>; Sun,  3 Jul 2022 18:10:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E0622B80BEB
        for <mm-commits@vger.kernel.org>; Mon,  4 Jul 2022 01:10:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86FDEC341C6;
        Mon,  4 Jul 2022 01:10:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1656897045;
        bh=cYSGnpM5joJgp7tCeRxWyCbOVWfkkzZ+6BDb3PmrB1A=;
        h=Date:To:From:Subject:From;
        b=E5HO6zUROWbLkLLCEVy25wifk7DlGYHQ8TrCr28FCPEDJQUYHSLP7lZSZBTLSxkaQ
         0zs7JTpnq44OxHMArRINuM+t1opS7qX8wVNO1e38gUycSuR0LHnnvhcs1DX5tLd3zq
         WdauYoazfl+fte33lDXJLdDVqrGy19olVu3SA97I=
Date:   Sun, 03 Jul 2022 18:10:44 -0700
To:     mm-commits@vger.kernel.org, paulmck@kernel.org, osalvador@suse.de,
        mike.kravetz@oracle.com, duanxiongchun@bytedance.com,
        david@redhat.com, corbet@lwn.net, songmuchun@bytedance.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memory_hotplug-make-hugetlb_optimize_vmemmap-compatible-with-memmap_on_memory.patch removed from -mm tree
Message-Id: <20220704011045.86FDEC341C6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: memory_hotplug: make hugetlb_optimize_vmemmap compatible with memmap_on_memory
has been removed from the -mm tree.  Its filename was
     mm-memory_hotplug-make-hugetlb_optimize_vmemmap-compatible-with-memmap_on_memory.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Muchun Song <songmuchun@bytedance.com>
Subject: mm: memory_hotplug: make hugetlb_optimize_vmemmap compatible with memmap_on_memory
Date: Fri, 17 Jun 2022 21:56:50 +0800

For now, the feature of hugetlb_free_vmemmap is not compatible with the
feature of memory_hotplug.memmap_on_memory, and hugetlb_free_vmemmap takes
precedence over memory_hotplug.memmap_on_memory.  However, someone wants
to make memory_hotplug.memmap_on_memory takes precedence over
hugetlb_free_vmemmap since memmap_on_memory makes it more likely to
succeed memory hotplug in close-to-OOM situations.  So the decision of
making hugetlb_free_vmemmap take precedence is not wise and elegant.

The proper approach is to have hugetlb_vmemmap.c do the check whether the
section which the HugeTLB pages belong to can be optimized.  If the
section's vmemmap pages are allocated from the added memory block itself,
hugetlb_free_vmemmap should refuse to optimize the vmemmap, otherwise, do
the optimization.  Then both kernel parameters are compatible.  So this
patch introduces VmemmapSelfHosted to mask any non-optimizable vmemmap
pages.  The hugetlb_vmemmap can use this flag to detect if a vmemmap page
can be optimized.

[songmuchun@bytedance.com: walk vmemmap page tables to avoid false-positive]
  Link: https://lkml.kernel.org/r/20220620110616.12056-3-songmuchun@bytedance.com
Link: https://lkml.kernel.org/r/20220617135650.74901-3-songmuchun@bytedance.com
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Co-developed-by: Oscar Salvador <osalvador@suse.de>
Signed-off-by: Oscar Salvador <osalvador@suse.de>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Paul E. McKenney <paulmck@kernel.org>
Cc: Xiongchun Duan <duanxiongchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/kernel-parameters.txt |   22 ++--
 Documentation/admin-guide/sysctl/vm.rst         |    5 -
 include/linux/memory_hotplug.h                  |    9 -
 include/linux/page-flags.h                      |   11 ++
 mm/hugetlb_vmemmap.c                            |   66 ++++++++++++--
 mm/memory_hotplug.c                             |   27 ++---
 6 files changed, 93 insertions(+), 47 deletions(-)

--- a/Documentation/admin-guide/kernel-parameters.txt~mm-memory_hotplug-make-hugetlb_optimize_vmemmap-compatible-with-memmap_on_memory
+++ a/Documentation/admin-guide/kernel-parameters.txt
@@ -1722,9 +1722,11 @@
 			Built with CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP_DEFAULT_ON=y,
 			the default is on.
 
-			This is not compatible with memory_hotplug.memmap_on_memory.
-			If both parameters are enabled, hugetlb_free_vmemmap takes
-			precedence over memory_hotplug.memmap_on_memory.
+			Note that the vmemmap pages may be allocated from the added
+			memory block itself when memory_hotplug.memmap_on_memory is
+			enabled, those vmemmap pages cannot be optimized even if this
+			feature is enabled.  Other vmemmap pages not allocated from
+			the added memory block itself do not be affected.
 
 	hung_task_panic=
 			[KNL] Should the hung task detector generate panics.
@@ -3068,10 +3070,12 @@
 			[KNL,X86,ARM] Boolean flag to enable this feature.
 			Format: {on | off (default)}
 			When enabled, runtime hotplugged memory will
-			allocate its internal metadata (struct pages)
-			from the hotadded memory which will allow to
-			hotadd a lot of memory without requiring
-			additional memory to do so.
+			allocate its internal metadata (struct pages,
+			those vmemmap pages cannot be optimized even
+			if hugetlb_free_vmemmap is enabled) from the
+			hotadded memory which will allow to hotadd a
+			lot of memory without requiring additional
+			memory to do so.
 			This feature is disabled by default because it
 			has some implication on large (e.g. GB)
 			allocations in some configurations (e.g. small
@@ -3081,10 +3085,6 @@
 			Note that even when enabled, there are a few cases where
 			the feature is not effective.
 
-			This is not compatible with hugetlb_free_vmemmap. If
-			both parameters are enabled, hugetlb_free_vmemmap takes
-			precedence over memory_hotplug.memmap_on_memory.
-
 	memtest=	[KNL,X86,ARM,M68K,PPC,RISCV] Enable memtest
 			Format: <integer>
 			default : 0 <disable>
--- a/Documentation/admin-guide/sysctl/vm.rst~mm-memory_hotplug-make-hugetlb_optimize_vmemmap-compatible-with-memmap_on_memory
+++ a/Documentation/admin-guide/sysctl/vm.rst
@@ -565,9 +565,8 @@ See Documentation/admin-guide/mm/hugetlb
 hugetlb_optimize_vmemmap
 ========================
 
-This knob is not available when memory_hotplug.memmap_on_memory (kernel parameter)
-is configured or the size of 'struct page' (a structure defined in
-include/linux/mm_types.h) is not power of two (an unusual system config could
+This knob is not available when the size of 'struct page' (a structure defined
+in include/linux/mm_types.h) is not power of two (an unusual system config could
 result in this).
 
 Enable (set to 1) or disable (set to 0) the feature of optimizing vmemmap pages
--- a/include/linux/memory_hotplug.h~mm-memory_hotplug-make-hugetlb_optimize_vmemmap-compatible-with-memmap_on_memory
+++ a/include/linux/memory_hotplug.h
@@ -351,13 +351,4 @@ void arch_remove_linear_mapping(u64 star
 extern bool mhp_supports_memmap_on_memory(unsigned long size);
 #endif /* CONFIG_MEMORY_HOTPLUG */
 
-#ifdef CONFIG_MHP_MEMMAP_ON_MEMORY
-bool mhp_memmap_on_memory(void);
-#else
-static inline bool mhp_memmap_on_memory(void)
-{
-	return false;
-}
-#endif
-
 #endif /* __LINUX_MEMORY_HOTPLUG_H */
--- a/include/linux/page-flags.h~mm-memory_hotplug-make-hugetlb_optimize_vmemmap-compatible-with-memmap_on_memory
+++ a/include/linux/page-flags.h
@@ -193,6 +193,11 @@ enum pageflags {
 
 	/* Only valid for buddy pages. Used to track pages that are reported */
 	PG_reported = PG_uptodate,
+
+#ifdef CONFIG_MEMORY_HOTPLUG
+	/* For self-hosted memmap pages */
+	PG_vmemmap_self_hosted = PG_owner_priv_1,
+#endif
 };
 
 #define PAGEFLAGS_MASK		((1UL << NR_PAGEFLAGS) - 1)
@@ -628,6 +633,12 @@ PAGEFLAG_FALSE(SkipKASanPoison, skip_kas
  */
 __PAGEFLAG(Reported, reported, PF_NO_COMPOUND)
 
+#ifdef CONFIG_MEMORY_HOTPLUG
+PAGEFLAG(VmemmapSelfHosted, vmemmap_self_hosted, PF_ANY)
+#else
+PAGEFLAG_FALSE(VmemmapSelfHosted, vmemmap_self_hosted)
+#endif
+
 /*
  * On an anonymous page mapped into a user virtual memory area,
  * page->mapping points to its anon_vma, not to a struct address_space;
--- a/mm/hugetlb_vmemmap.c~mm-memory_hotplug-make-hugetlb_optimize_vmemmap-compatible-with-memmap_on_memory
+++ a/mm/hugetlb_vmemmap.c
@@ -10,7 +10,7 @@
  */
 #define pr_fmt(fmt)	"HugeTLB: " fmt
 
-#include <linux/memory_hotplug.h>
+#include <linux/memory.h>
 #include "hugetlb_vmemmap.h"
 
 /*
@@ -97,18 +97,68 @@ int hugetlb_vmemmap_alloc(struct hstate
 	return ret;
 }
 
+static unsigned int vmemmap_optimizable_pages(struct hstate *h,
+					      struct page *head)
+{
+	if (READ_ONCE(vmemmap_optimize_mode) == VMEMMAP_OPTIMIZE_OFF)
+		return 0;
+
+	if (IS_ENABLED(CONFIG_MEMORY_HOTPLUG)) {
+		pmd_t *pmdp, pmd;
+		struct page *vmemmap_page;
+		unsigned long vaddr = (unsigned long)head;
+
+		/*
+		 * Only the vmemmap page's vmemmap page can be self-hosted.
+		 * Walking the page tables to find the backing page of the
+		 * vmemmap page.
+		 */
+		pmdp = pmd_off_k(vaddr);
+		/*
+		 * The READ_ONCE() is used to stabilize *pmdp in a register or
+		 * on the stack so that it will stop changing under the code.
+		 * The only concurrent operation where it can be changed is
+		 * split_vmemmap_huge_pmd() (*pmdp will be stable after this
+		 * operation).
+		 */
+		pmd = READ_ONCE(*pmdp);
+		if (pmd_leaf(pmd))
+			vmemmap_page = pmd_page(pmd) + pte_index(vaddr);
+		else
+			vmemmap_page = pte_page(*pte_offset_kernel(pmdp, vaddr));
+		/*
+		 * Due to HugeTLB alignment requirements and the vmemmap pages
+		 * being at the start of the hotplugged memory region in
+		 * memory_hotplug.memmap_on_memory case. Checking any vmemmap
+		 * page's vmemmap page if it is marked as VmemmapSelfHosted is
+		 * sufficient.
+		 *
+		 * [                  hotplugged memory                  ]
+		 * [        section        ][...][        section        ]
+		 * [ vmemmap ][              usable memory               ]
+		 *   ^   |     |                                        |
+		 *   +---+     |                                        |
+		 *     ^       |                                        |
+		 *     +-------+                                        |
+		 *          ^                                           |
+		 *          +-------------------------------------------+
+		 */
+		if (PageVmemmapSelfHosted(vmemmap_page))
+			return 0;
+	}
+
+	return hugetlb_optimize_vmemmap_pages(h);
+}
+
 void hugetlb_vmemmap_free(struct hstate *h, struct page *head)
 {
 	unsigned long vmemmap_addr = (unsigned long)head;
 	unsigned long vmemmap_end, vmemmap_reuse, vmemmap_pages;
 
-	vmemmap_pages = hugetlb_optimize_vmemmap_pages(h);
+	vmemmap_pages = vmemmap_optimizable_pages(h, head);
 	if (!vmemmap_pages)
 		return;
 
-	if (READ_ONCE(vmemmap_optimize_mode) == VMEMMAP_OPTIMIZE_OFF)
-		return;
-
 	static_branch_inc(&hugetlb_optimize_vmemmap_key);
 
 	vmemmap_addr	+= RESERVE_VMEMMAP_SIZE;
@@ -199,10 +249,10 @@ static struct ctl_table hugetlb_vmemmap_
 static __init int hugetlb_vmemmap_sysctls_init(void)
 {
 	/*
-	 * If "memory_hotplug.memmap_on_memory" is enabled or "struct page"
-	 * crosses page boundaries, the vmemmap pages cannot be optimized.
+	 * If "struct page" crosses page boundaries, the vmemmap pages cannot
+	 * be optimized.
 	 */
-	if (!mhp_memmap_on_memory() && is_power_of_2(sizeof(struct page)))
+	if (is_power_of_2(sizeof(struct page)))
 		register_sysctl_init("vm", hugetlb_vmemmap_sysctls);
 
 	return 0;
--- a/mm/memory_hotplug.c~mm-memory_hotplug-make-hugetlb_optimize_vmemmap-compatible-with-memmap_on_memory
+++ a/mm/memory_hotplug.c
@@ -43,30 +43,22 @@
 #include "shuffle.h"
 
 #ifdef CONFIG_MHP_MEMMAP_ON_MEMORY
-static int memmap_on_memory_set(const char *val, const struct kernel_param *kp)
-{
-	if (hugetlb_optimize_vmemmap_enabled())
-		return 0;
-	return param_set_bool(val, kp);
-}
-
-static const struct kernel_param_ops memmap_on_memory_ops = {
-	.flags	= KERNEL_PARAM_OPS_FL_NOARG,
-	.set	= memmap_on_memory_set,
-	.get	= param_get_bool,
-};
-
 /*
  * memory_hotplug.memmap_on_memory parameter
  */
 static bool memmap_on_memory __ro_after_init;
-module_param_cb(memmap_on_memory, &memmap_on_memory_ops, &memmap_on_memory, 0444);
+module_param(memmap_on_memory, bool, 0444);
 MODULE_PARM_DESC(memmap_on_memory, "Enable memmap on memory for memory hotplug");
 
-bool mhp_memmap_on_memory(void)
+static inline bool mhp_memmap_on_memory(void)
 {
 	return memmap_on_memory;
 }
+#else
+static inline bool mhp_memmap_on_memory(void)
+{
+	return false;
+}
 #endif
 
 enum {
@@ -1035,7 +1027,7 @@ int mhp_init_memmap_on_memory(unsigned l
 			      struct zone *zone)
 {
 	unsigned long end_pfn = pfn + nr_pages;
-	int ret;
+	int ret, i;
 
 	ret = kasan_add_zero_shadow(__va(PFN_PHYS(pfn)), PFN_PHYS(nr_pages));
 	if (ret)
@@ -1043,6 +1035,9 @@ int mhp_init_memmap_on_memory(unsigned l
 
 	move_pfn_range_to_zone(zone, pfn, nr_pages, NULL, MIGRATE_UNMOVABLE);
 
+	for (i = 0; i < nr_pages; i++)
+		SetPageVmemmapSelfHosted(pfn_to_page(pfn + i));
+
 	/*
 	 * It might be that the vmemmap_pages fully span sections. If that is
 	 * the case, mark those sections online here as otherwise they will be
_

Patches currently in -mm which might be from songmuchun@bytedance.com are

mm-hugetlb-remove-minimum_order-variable.patch
mm-hugetlb_vmemmap-delete-hugetlb_optimize_vmemmap_enabled.patch
mm-hugetlb_vmemmap-optimize-vmemmap_optimize_mode-handling.patch
mm-hugetlb_vmemmap-introduce-the-name-hvo.patch
mm-hugetlb_vmemmap-move-vmemmap-code-related-to-hugetlb-to-hugetlb_vmemmapc.patch
mm-hugetlb_vmemmap-replace-early_param-with-core_param.patch
mm-hugetlb_vmemmap-improve-hugetlb_vmemmap-code-readability.patch
mm-hugetlb_vmemmap-move-code-comments-to-vmemmap_deduprst.patch
mm-hugetlb_vmemmap-use-ptrs_per_pte-instead-of-pmd_size-page_size.patch
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

