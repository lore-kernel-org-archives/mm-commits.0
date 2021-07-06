Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F376DC07E96
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:17:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D899561C91
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:17:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231740AbhGFTTu (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 6 Jul 2021 15:19:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:53726 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229991AbhGFTTt (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 6 Jul 2021 15:19:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 973BD61C7C;
        Tue,  6 Jul 2021 19:17:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625599030;
        bh=JBdOQJvXKHNnxWPznE1C3yGsaS22FIMNxGGCuY/krPQ=;
        h=Date:From:To:Subject:From;
        b=fyVJn4VmHO9ee9McWZv3oH92kB4VCt3m7igRSQPDT9JnI0F3j4jOhKd/2U8RG+Sc3
         LwUYixORcBgRWremVoYdAexrkpmKR9vvpl+IBAGCwXoHnCKHUWp/z3ccFSk/gL2xx4
         ZPCEbm/CffjrGVboil9I4QwszTFG574/nFzCeK8Q=
Date:   Tue, 06 Jul 2021 12:17:10 -0700
From:   akpm@linux-foundation.org
To:     chenhuang5@huawei.com, corbet@lwn.net, david@redhat.com,
        duanxiongchun@bytedance.com, mhocko@suse.com,
        mike.kravetz@oracle.com, mm-commits@vger.kernel.org,
        osalvador@suse.de, songmuchun@bytedance.com
Subject:  [merged]
 mm-sparsemem-use-huge-pmd-mapping-for-vmemmap-pages.patch removed from -mm
 tree
Message-ID: <20210706191710.y93TVvHDT%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: sparsemem: use huge PMD mapping for vmemmap pages
has been removed from the -mm tree.  Its filename was
     mm-sparsemem-use-huge-pmd-mapping-for-vmemmap-pages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Muchun Song <songmuchun@bytedance.com>
Subject: mm: sparsemem: use huge PMD mapping for vmemmap pages

The preparation of splitting huge PMD mapping of vmemmap pages is ready,
so switch the mapping from PTE to PMD.

Link: https://lkml.kernel.org/r/20210616094915.34432-3-songmuchun@bytedance.com
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Chen Huang <chenhuang5@huawei.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Xiongchun Duan <duanxiongchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/kernel-parameters.txt |    7 ---
 arch/x86/mm/init_64.c                           |    8 +---
 include/linux/hugetlb.h                         |   25 +++-----------
 mm/memory_hotplug.c                             |    2 -
 4 files changed, 9 insertions(+), 33 deletions(-)

--- a/arch/x86/mm/init_64.c~mm-sparsemem-use-huge-pmd-mapping-for-vmemmap-pages
+++ a/arch/x86/mm/init_64.c
@@ -34,7 +34,6 @@
 #include <linux/gfp.h>
 #include <linux/kcore.h>
 #include <linux/bootmem_info.h>
-#include <linux/hugetlb.h>
 
 #include <asm/processor.h>
 #include <asm/bios_ebda.h>
@@ -1610,8 +1609,7 @@ int __meminit vmemmap_populate(unsigned
 	VM_BUG_ON(!IS_ALIGNED(start, PAGE_SIZE));
 	VM_BUG_ON(!IS_ALIGNED(end, PAGE_SIZE));
 
-	if ((is_hugetlb_free_vmemmap_enabled()  && !altmap) ||
-	    end - start < PAGES_PER_SECTION * sizeof(struct page))
+	if (end - start < PAGES_PER_SECTION * sizeof(struct page))
 		err = vmemmap_populate_basepages(start, end, node, NULL);
 	else if (boot_cpu_has(X86_FEATURE_PSE))
 		err = vmemmap_populate_hugepages(start, end, node, altmap);
@@ -1639,8 +1637,6 @@ void register_page_bootmem_memmap(unsign
 	pmd_t *pmd;
 	unsigned int nr_pmd_pages;
 	struct page *page;
-	bool base_mapping = !boot_cpu_has(X86_FEATURE_PSE) ||
-			    is_hugetlb_free_vmemmap_enabled();
 
 	for (; addr < end; addr = next) {
 		pte_t *pte = NULL;
@@ -1666,7 +1662,7 @@ void register_page_bootmem_memmap(unsign
 		}
 		get_page_bootmem(section_nr, pud_page(*pud), MIX_SECTION_INFO);
 
-		if (base_mapping) {
+		if (!boot_cpu_has(X86_FEATURE_PSE)) {
 			next = (addr + PAGE_SIZE) & PAGE_MASK;
 			pmd = pmd_offset(pud, addr);
 			if (pmd_none(*pmd))
--- a/Documentation/admin-guide/kernel-parameters.txt~mm-sparsemem-use-huge-pmd-mapping-for-vmemmap-pages
+++ a/Documentation/admin-guide/kernel-parameters.txt
@@ -1572,13 +1572,6 @@
 			enabled.
 			Allows heavy hugetlb users to free up some more
 			memory (6 * PAGE_SIZE for each 2MB hugetlb page).
-			This feauture is not free though. Large page
-			tables are not used to back vmemmap pages which
-			can lead to a performance degradation for some
-			workloads. Also there will be memory allocation
-			required when hugetlb pages are freed from the
-			pool which can lead to corner cases under heavy
-			memory pressure.
 			Format: { on | off (default) }
 
 			on:  enable the feature
--- a/include/linux/hugetlb.h~mm-sparsemem-use-huge-pmd-mapping-for-vmemmap-pages
+++ a/include/linux/hugetlb.h
@@ -895,20 +895,6 @@ static inline void huge_ptep_modify_prot
 }
 #endif
 
-#ifdef CONFIG_HUGETLB_PAGE_FREE_VMEMMAP
-extern bool hugetlb_free_vmemmap_enabled;
-
-static inline bool is_hugetlb_free_vmemmap_enabled(void)
-{
-	return hugetlb_free_vmemmap_enabled;
-}
-#else
-static inline bool is_hugetlb_free_vmemmap_enabled(void)
-{
-	return false;
-}
-#endif
-
 #else	/* CONFIG_HUGETLB_PAGE */
 struct hstate {};
 
@@ -1063,13 +1049,14 @@ static inline void set_huge_swap_pte_at(
 					pte_t *ptep, pte_t pte, unsigned long sz)
 {
 }
-
-static inline bool is_hugetlb_free_vmemmap_enabled(void)
-{
-	return false;
-}
 #endif	/* CONFIG_HUGETLB_PAGE */
 
+#ifdef CONFIG_HUGETLB_PAGE_FREE_VMEMMAP
+extern bool hugetlb_free_vmemmap_enabled;
+#else
+#define hugetlb_free_vmemmap_enabled	false
+#endif
+
 static inline spinlock_t *huge_pte_lock(struct hstate *h,
 					struct mm_struct *mm, pte_t *pte)
 {
--- a/mm/memory_hotplug.c~mm-sparsemem-use-huge-pmd-mapping-for-vmemmap-pages
+++ a/mm/memory_hotplug.c
@@ -1056,7 +1056,7 @@ bool mhp_supports_memmap_on_memory(unsig
 	 *       populate a single PMD.
 	 */
 	return memmap_on_memory &&
-	       !is_hugetlb_free_vmemmap_enabled() &&
+	       !hugetlb_free_vmemmap_enabled &&
 	       IS_ENABLED(CONFIG_MHP_MEMMAP_ON_MEMORY) &&
 	       size == memory_block_size_bytes() &&
 	       IS_ALIGNED(vmemmap_size, PMD_SIZE) &&
_

Patches currently in -mm which might be from songmuchun@bytedance.com are


