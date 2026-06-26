Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B96F31B6D1A
	for <mm-commits@vger.kernel.org>; Fri, 26 Jun 2026 00:47:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782434827; cv=none; b=UwlYH34IIZEyYL+HkLidptstg+J/K48yEfUlk9Jue8VRMHraDXHlg8buZBcnGQHr+mSAstYiatDtSAw+EUkfPt+WSuzIw3PBtcmiMW6MbsgwMgeQ2nbqZYD5HdokQfr9cLNE8/RlR9nIG/PkxdiyKNsmWPiRRNtUMkzrY1XAkcM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782434827; c=relaxed/simple;
	bh=02Y8gHulipSW5WIXJ5VaNVMBiYmWd6z0o2kkhr1rkjU=;
	h=Date:To:From:Subject:Message-Id; b=SwfxvDt8CyDi/qSTpFizPyKNUdzm7ZEAKk2eC8FwPTmGBBis5WSnwbXtWmGdz3w73pI4XGBeUa4h+Sy7DEsQ/MR8MzlJusZkUJ6867MBUdRTNJs//OMj5W/ZAFGk7fndB3jrZXf89/r9VLyVm3YRQdvmxBQSAxzNC0PYxg+W/q4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=BAyfNjlA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="BAyfNjlA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C3F81F000E9;
	Fri, 26 Jun 2026 00:47:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782434825;
	bh=2ZShjw6aJma0lC35GXGSQ0FJPkqbqAfRjcMfWdGMiOY=;
	h=Date:To:From:Subject;
	b=BAyfNjlAYHhQpSCMYDZZxJS2karXiEqhyPQRgbNcm6uEYyx7/nLUMcH3HhP4LCMWE
	 Si6+LIOZYiqjleOZXj4A9gEKbdzWKq2vr8tEIjIOzRYhwfwOtX5XaedmVSNa/f1lSb
	 qz/urVPBDH6OA2zR8nMMxoRaOV4H/xtFpI51Isuc=
Date: Thu, 25 Jun 2026 17:47:04 -0700
To: mm-commits@vger.kernel.org,songmuchun@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb-fix-boot-panic-with-config_debug_vm-and-hvo-bootmem-pages.patch added to mm-new branch
Message-Id: <20260626004705.4C3F81F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/hugetlb: fix boot panic with CONFIG_DEBUG_VM and HVO bootmem pages
has been added to the -mm mm-new branch.  Its filename is
     mm-hugetlb-fix-boot-panic-with-config_debug_vm-and-hvo-bootmem-pages.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb-fix-boot-panic-with-config_debug_vm-and-hvo-bootmem-pages.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

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
From: Muchun Song <songmuchun@bytedance.com>
Subject: mm/hugetlb: fix boot panic with CONFIG_DEBUG_VM and HVO bootmem pages
Date: Fri, 12 Jun 2026 11:58:45 +0800

Patch series "mm: Refactor bootmem gigantic hugepage allocation", v4.

This series is split out from the earlier larger series "mm: Generalize
HVO for HugeTLB and device DAX" [1].  It collects the first 19 patches of
that series as a standalone set of fixes and preparatory cleanups around
bootmem HugeTLB handling, sparse initialization ordering, and related
vmemmap setup.

The first patches fix a few bugs found while reviewing the existing code,
including incorrect bootmem HVO handling, wrong vmemmap registration
arguments, a powerpc compound-vmemmap tracking bug, and too-late
initialization of gigantic bootmem HugeTLB struct pages.

The rest of the series reorders early memory initialization so the
relevant zone state is available before sparse and HugeTLB boot-time setup
runs, then simplifies the remaining bootmem gigantic hugepage allocation
path and removes code made obsolete by that rework.

At a high level:
  - patches [1-4] fix boot-time and arch-specific bugs
  - patches [5-12] reorder and simplify sparse/mm/hugetlb early init
  - patches [13-19] refactor bootmem gigantic hugepage allocation and
    remove obsolete helpers and state


This patch (of 19):

Commit 622026e87c40 ("mm/hugetlb: remove fake head pages") switched
HVO to reuse per-zone shared tail pages from zone->vmemmap_tails[].

Those shared tail pages were initialized in hugetlb_vmemmap_init(), but
bootmem HugeTLB folios are prepared earlier from
gather_bootmem_prealloc().  With hugetlb_free_vmemmap=on,
prep_and_add_bootmem_folios() can access pageblock flags on bootmem
HugeTLB pages whose mirrored tail struct pages already point to the shared
tail page.  On CONFIG_DEBUG_VM kernels, get_pfnblock_bitmap_bitidx() then
dereferences the still-uninitialized shared tail page and can panic during
boot.

Initialize zone->vmemmap_tails[] from gather_bootmem_prealloc(), before
bootmem HugeTLB folios are processed, and drop the later initialization
from hugetlb_vmemmap_init().

This bug only affects CONFIG_DEBUG_VM kernels, where the relevant
assertion is evaluated.

Link: https://lore.kernel.org/20260612035903.2468601-1-songmuchun@bytedance.com
Link: https://lore.kernel.org/20260612035903.2468601-2-songmuchun@bytedance.com
Fixes: 622026e87c40 ("mm/hugetlb: remove fake head pages")
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: Oscar Salvador <osalvador@suse.de>
Cc: Michal Clapinski <mclapinski@google.com>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Frank van der Linden <fvdl@google.com>
Cc: Oscar Salvador (SUSE) <osalvador@kernel.org>
Cc: Usama Arif <usama.arif@linux.dev>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c         |   25 +++++++++++++++++++++++++
 mm/hugetlb_vmemmap.c |   17 -----------------
 mm/sparse-vmemmap.c  |    2 +-
 3 files changed, 26 insertions(+), 18 deletions(-)

--- a/mm/hugetlb.c~mm-hugetlb-fix-boot-panic-with-config_debug_vm-and-hvo-bootmem-pages
+++ a/mm/hugetlb.c
@@ -3365,6 +3365,31 @@ static void __init gather_bootmem_preall
 		.max_threads	= num_node_state(N_MEMORY),
 		.numa_aware	= true,
 	};
+#ifdef CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP
+	struct zone *zone;
+
+	for_each_zone(zone) {
+		for (int i = 0; i < NR_VMEMMAP_TAILS; i++) {
+			struct page *tail, *p;
+			unsigned int order;
+
+			tail = zone->vmemmap_tails[i];
+			if (!tail)
+				continue;
+
+			order = i + VMEMMAP_TAIL_MIN_ORDER;
+			p = page_to_virt(tail);
+			/*
+			 * prep_and_add_bootmem_folios() can access pageblock
+			 * flags on bootmem HugeTLB pages, so initialize the
+			 * shared tail struct pages here before bootmem folios
+			 * start using them.
+			 */
+			for (int j = 0; j < PAGE_SIZE / sizeof(struct page); j++)
+				init_compound_tail(p + j, NULL, order, zone);
+		}
+	}
+#endif
 
 	padata_do_multithreaded(&job);
 }
--- a/mm/hugetlb_vmemmap.c~mm-hugetlb-fix-boot-panic-with-config_debug_vm-and-hvo-bootmem-pages
+++ a/mm/hugetlb_vmemmap.c
@@ -870,27 +870,10 @@ static const struct ctl_table hugetlb_vm
 static int __init hugetlb_vmemmap_init(void)
 {
 	const struct hstate *h;
-	struct zone *zone;
 
 	/* HUGETLB_VMEMMAP_RESERVE_SIZE should cover all used struct pages */
 	BUILD_BUG_ON(__NR_USED_SUBPAGE > HUGETLB_VMEMMAP_RESERVE_PAGES);
 
-	for_each_zone(zone) {
-		for (int i = 0; i < NR_VMEMMAP_TAILS; i++) {
-			struct page *tail, *p;
-			unsigned int order;
-
-			tail = zone->vmemmap_tails[i];
-			if (!tail)
-				continue;
-
-			order = i + VMEMMAP_TAIL_MIN_ORDER;
-			p = page_to_virt(tail);
-			for (int j = 0; j < PAGE_SIZE / sizeof(struct page); j++)
-				init_compound_tail(p + j, NULL, order, zone);
-		}
-	}
-
 	for_each_hstate(h) {
 		if (hugetlb_vmemmap_optimizable(h)) {
 			register_sysctl_init("vm", hugetlb_vmemmap_sysctls);
--- a/mm/sparse-vmemmap.c~mm-hugetlb-fix-boot-panic-with-config_debug_vm-and-hvo-bootmem-pages
+++ a/mm/sparse-vmemmap.c
@@ -342,7 +342,7 @@ static __meminit struct page *vmemmap_ge
 	 *
 	 * Any initialization done here will be overwritten by memmap_init().
 	 *
-	 * hugetlb_vmemmap_init() will take care of initialization after
+	 * gather_bootmem_prealloc() will take care of initialization after
 	 * memmap_init().
 	 */
 
_

Patches currently in -mm which might be from songmuchun@bytedance.com are

mm-hugetlb-fix-boot-panic-with-config_debug_vm-and-hvo-bootmem-pages.patch
mm-hugetlb_vmemmap-fix-__hugetlb_vmemmap_optimize_folios.patch
powerpc-mm-fix-wrong-addr_pfn-tracking-in-compound-vmemmap-population.patch
mm-hugetlb-initialize-gigantic-bootmem-hugepage-struct-pages-earlier.patch
mm-mm_init-simplify-deferred_free_pages-migratetype-init.patch
mm-sparse-panic-on-memmap-and-usemap-allocation-failure.patch
mm-sparse-move-subsection_map_init-into-sparse_init.patch
mm-mm_init-defer-sparse_init-until-after-zone-initialization.patch
mm-mm_init-defer-hugetlb-reservation-until-after-zone-initialization.patch
mm-mm_init-remove-set_pageblock_order-call-from-sparse_init.patch
mm-sparse-move-sparse_vmemmap_init_nid_late-into-sparse_init_nid.patch
mm-hugetlb_cma-validate-hugetlb-cma-range-by-zone-at-reserve-time.patch
mm-hugetlb-refactor-early-boot-gigantic-hugepage-allocation.patch
mm-hugetlb-free-cross-zone-bootmem-gigantic-pages-after-allocation.patch
mm-hugetlb_vmemmap-move-bootmem-hvo-setup-to-early-init.patch
mm-hugetlb-remove-obsolete-bootmem-cross-zone-checks.patch
mm-sparse-vmemmap-remove-sparse_vmemmap_init_nid_late.patch
mm-hugetlb-remove-unused-bootmem-cma-field.patch
mm-mm_init-fold-__init_page_from_nid-into-__init_deferred_page.patch

