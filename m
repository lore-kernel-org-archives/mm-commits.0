Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794023614;
	b=g5z/6Qrx3bMy4Y2oF6zymrJqMQv1uQwj+dvmZu8OBDDXm8kC5kGnHSITmxwNVLxOjRZB
	 qJtXEwFayeXVcle5EFw4/rJw8YlYwDZ93lkr80LMyA7QwdyaMSdclRQGuAbEh8QkQaaGZ
	 OMGC3fZ3b3bFxYlwnM17n5bbXmnFkRGdaOeNAc/gdyAYP5smDkjFBaEiE1ghSuEEew6eU
	 3PR/HQGeUPXE1DxPhu0H1sOgJAtiKRbQeCZxchzLYF7SzgU6FWN5pwM2VXWqx1RFC+l9m
	 B9iXH5aMDEW+wYJ+JQ6rZQ/lDgn02eaFMUH1PXbKbI1IHnnr4eGADle0DzjZQBlcU4g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794023614;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=o4DwnkoAsfaMPUxLyKpWTn3LdejqmaAxd58lzuVbQ0w=;
	b=Fv4MhSPS/ktzxUHJvn6FGhUKyGgJYBgIbBlsH+wO5DCwfGwMOWC6hIdikFazXob40+qa
	 9s8Ua3f3XHD1wHSDgIpSLsE3P9AehIrAuHrkKmc40r1wMYmdCFl7aSsEgbQcf4ESQYJ3A
	 vtVyaVwWpNgPvjL1CfcZD0unGTj64s/8MOpZSHhXWXk8ifxC8l290RpMFvF+HkK0Lihry
	 EFm6j/hAATVpUWe7U+qEBYUsHl9H/92o7wRygOT1LAqaZD9veypmwkJx4fIrrex0Li47C
	 GR4M7dvhYaG9Y/6VFOKvgTRZKXD4nJQcDmplAeaVc4VtrDKNNMqdMQG+lwdcxOewWow==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=zBprfGpa;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90476606A326
	for <mm-commits@vger.kernel.org>; Sat,  7 Nov 2026 03:53:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=zBprfGpa
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A7D61F0089F;
	Sat,  7 Nov 2026 03:53:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794023614;
	bh=o4DwnkoAsfaMPUxLyKpWTn3LdejqmaAxd58lzuVbQ0w=;
	h=Date:To:From:Subject;
	b=zBprfGpaSTcDe8f0T2MOQrdyIZsGsLlIQfM4DS0jFtEoM7FTaXYO9/OuTVe/ZE1m8
	 xQln/kGBGK4bQAfO0Cv1NC5wzg9DgLIQa6mMokb+uhFp7Hr7lTG4ACJaS9DqJOhTRi
	 Hki3mDOR8rSAzXdQ1BOSLh3ek8/A4zkSWdjbVbjI=
Date: Fri, 06 Nov 2026 19:53:33 -0800
To: mm-commits@vger.kernel.org,muchun.song@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb_vmemmap-remove-hugetlb-specific-vmemmap-optimization-macros.patch added to mm-unstable branch
Message-Id: <20261107035334.4A7D61F0089F@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: mm: hugetlb_vmemmap: remove HugeTLB-specific vmemmap optimization macros
has been added to the -mm mm-unstable branch.  Its filename is
     mm-hugetlb_vmemmap-remove-hugetlb-specific-vmemmap-optimization-macros.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb_vmemmap-remove-hugetlb-specific-vmemmap-optimization-macros.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Muchun Song <muchun.song@linux.dev>
Subject: mm: hugetlb_vmemmap: remove HugeTLB-specific vmemmap optimization macros
Date: Sat, 07 Nov 2026 10:27:45 +0800

Vmemmap optimization is no longer HugeTLB-specific, so the remaining
HugeTLB-local reserve macros are redundant.

Replace them with the generic definitions to remove duplication and keep
the HugeTLB vmemmap code aligned with the common optimization macros.

Link: https://lore.kernel.org/20261107022756.77731-3-songmuchun@bytedance.com
Signed-off-by: Muchun Song <muchun.song@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Reviewed-by: Qi Zheng <qi.zheng@linux.dev>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Tested-by: Andrew Morton <akpm@linux-foundation.org>
Cc: James Houghton <jthoughton@google.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Yili Zhang <zhangyili01@baidu.com>
Cc: Kiryl Shutsemau <kas@kernel.org>
Cc: "Oscar Salvador (SUSE)" <osalvador@kernel.org>
Cc: Huacai Chen <chenhuacai@kernel.org>
---

 include/linux/vmemmap-optimization.h |    4 ++--
 mm/hugetlb.c                         |    4 ++--
 mm/hugetlb_vmemmap.c                 |    6 +++---
 mm/hugetlb_vmemmap.h                 |   10 ++--------
 4 files changed, 9 insertions(+), 15 deletions(-)

--- a/include/linux/vmemmap-optimization.h~mm-hugetlb_vmemmap-remove-hugetlb-specific-vmemmap-optimization-macros
+++ a/include/linux/vmemmap-optimization.h
@@ -27,8 +27,8 @@
 
 /* The number of retained vmemmap pages with HVO enabled. */
 #define VMEMMAP_OPTIMIZATION_PAGES		1
-#define VMEMMAP_OPTIMIZATION_NR_STRUCT_PAGES	\
-	(VMEMMAP_OPTIMIZATION_PAGES * PAGE_SIZE / sizeof(struct page))
+#define VMEMMAP_OPTIMIZATION_SIZE		(VMEMMAP_OPTIMIZATION_PAGES * PAGE_SIZE)
+#define VMEMMAP_OPTIMIZATION_NR_STRUCT_PAGES	(VMEMMAP_OPTIMIZATION_SIZE / sizeof(struct page))
 #define VMEMMAP_OPTIMIZATION_MIN_ORDER		(ilog2(VMEMMAP_OPTIMIZATION_NR_STRUCT_PAGES) + 1)
 
 #ifdef CONFIG_VMEMMAP_OPTIMIZATION
--- a/mm/hugetlb.c~mm-hugetlb_vmemmap-remove-hugetlb-specific-vmemmap-optimization-macros
+++ a/mm/hugetlb.c
@@ -3317,7 +3317,7 @@ static void __init prep_and_add_bootmem_
 			 * be no contention.
 			 */
 			hugetlb_folio_init_tail_vmemmap(folio, h,
-					HUGETLB_VMEMMAP_RESERVE_PAGES,
+					VMEMMAP_OPTIMIZATION_NR_STRUCT_PAGES,
 					pages_per_huge_page(h));
 		}
 		hugetlb_bootmem_init_migratetype(folio, h);
@@ -3357,7 +3357,7 @@ static void __init gather_bootmem_preall
 		WARN_ON(folio_ref_count(folio) != 1);
 
 		hugetlb_folio_init_vmemmap(folio, h,
-					   HUGETLB_VMEMMAP_RESERVE_PAGES);
+					   VMEMMAP_OPTIMIZATION_NR_STRUCT_PAGES);
 		init_new_hugetlb_folio(folio);
 
 		if (vmemmap_optimizable_order(pfn_to_section_compound_order(pfn)))
--- a/mm/hugetlb_vmemmap.c~mm-hugetlb_vmemmap-remove-hugetlb-specific-vmemmap-optimization-macros
+++ a/mm/hugetlb_vmemmap.c
@@ -408,7 +408,7 @@ static int __hugetlb_vmemmap_restore_fol
 	vmemmap_start	= (unsigned long)&folio->page;
 	vmemmap_end	= vmemmap_start + hugetlb_vmemmap_size(h);
 
-	vmemmap_start	+= HUGETLB_VMEMMAP_RESERVE_SIZE;
+	vmemmap_start	+= VMEMMAP_OPTIMIZATION_SIZE;
 
 	/*
 	 * The pages which the vmemmap virtual address range [@vmemmap_start,
@@ -677,8 +677,8 @@ static int __init hugetlb_vmemmap_init(v
 {
 	const struct hstate *h;
 
-	/* HUGETLB_VMEMMAP_RESERVE_SIZE should cover all used struct pages */
-	BUILD_BUG_ON(__NR_USED_SUBPAGE > HUGETLB_VMEMMAP_RESERVE_PAGES);
+	/* VMEMMAP_OPTIMIZATION_NR_STRUCT_PAGES should cover all used struct pages */
+	BUILD_BUG_ON(__NR_USED_SUBPAGE > VMEMMAP_OPTIMIZATION_NR_STRUCT_PAGES);
 
 	for_each_hstate(h) {
 		if (hugetlb_vmemmap_optimizable(h)) {
--- a/mm/hugetlb_vmemmap.h~mm-hugetlb_vmemmap-remove-hugetlb-specific-vmemmap-optimization-macros
+++ a/mm/hugetlb_vmemmap.h
@@ -9,13 +9,7 @@
 #ifndef _LINUX_HUGETLB_VMEMMAP_H
 #define _LINUX_HUGETLB_VMEMMAP_H
 #include <linux/hugetlb.h>
-
-/*
- * Reserve one vmemmap page, all vmemmap addresses are mapped to it. See
- * Documentation/mm/vmemmap_dedup.rst.
- */
-#define HUGETLB_VMEMMAP_RESERVE_SIZE	PAGE_SIZE
-#define HUGETLB_VMEMMAP_RESERVE_PAGES	(HUGETLB_VMEMMAP_RESERVE_SIZE / sizeof(struct page))
+#include <linux/vmemmap-optimization.h>
 
 #ifdef CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP
 int hugetlb_vmemmap_restore_folio(const struct hstate *h, struct folio *folio);
@@ -37,7 +31,7 @@ static inline unsigned int hugetlb_vmemm
  */
 static inline unsigned int hugetlb_vmemmap_optimizable_size(const struct hstate *h)
 {
-	int size = hugetlb_vmemmap_size(h) - HUGETLB_VMEMMAP_RESERVE_SIZE;
+	int size = hugetlb_vmemmap_size(h) - VMEMMAP_OPTIMIZATION_SIZE;
 
 	if (!is_power_of_2(sizeof(struct page)))
 		return 0;
_

Patches currently in -mm which might be from muchun.song@linux.dev are

mm-fix-missing-page-table-destructor-in-pagetable_free.patch
riscv-mm-fix-hotplug-page-table-destructor-handling.patch
riscv-mm-fix-missing-destructor-for-hotplug-pud-tables.patch
arm64-mm-fix-destructor-for-unconstructed-hotplug-page-tables.patch
mm-sparse-vmemmap-map-shared-vmemmap-tail-pages-as-read-only.patch
powerpc-mm-map-shared-vmemmap-tail-pages-as-read-only.patch
mm-hugetlb_vmemmap-remove-vmemmap_wrprotect_hvo.patch
mm-hugetlb_vmemmap-remove-hugetlb_vmemmap_optimize_bootmem_folios.patch
mm-generalize-kernel-pte-table-allocation.patch
mm-generalize-pmd-page-table-allocation.patch
mm-generalize-pud-page-table-allocation.patch
mm-remove-pagetable_dtor_free.patch
mm-remove-redundant-pagetable_dtor-calls.patch
mm-hugetlb_vmemmap-remove-hugetlb-specific-vmemmap-optimization-macros.patch
mm-hugetlb_vmemmap-unify-vmemmap_splitremap_no_tlb_flush.patch
mm-hugetlb_vmemmap-simplify-vmemmap-head-page-handling.patch
mm-hugetlb_vmemmap-generalize-vmemmap-page-allocation.patch
mm-hugetlb_vmemmap-unify-writable-vmemmap-page-preparation.patch
mm-hugetlb_vmemmap-rename-vmemmap_remap_pte-to-vmemmap_optimize_pte.patch
mm-hugetlb_vmemmap-simplify-shared-tail-page-handling.patch
mm-hugetlb_vmemmap-move-alloc_vmemmap_page_list-next-to-its-free-helper.patch
mm-hugetlb_vmemmap-make-vmemmap-optimization-folio-oriented.patch
mm-hugetlb_vmemmap-make-vmemmap-restoration-folio-oriented.patch
mm-hugetlb_vmemmap-unify-vmemmap-range-restoration.patch
mm-hugetlb_vmemmap-make-vmemmap-pte-conversion-folio-oriented.patch
mm-hugetlb-fix-validation-of-unsupported-hugetlb-orders.patch

