Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01C813921FB;
	Wed, 29 Jul 2026 04:14:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785298455; cv=none; b=hHcR48KQR9VqeB8s8PxKU4pRRg4sGAPuVvmgJ3pZCX7AEFgMU1o0Hsn/m+n6vyk+vYkoGeK2GKF393NEtEhlWuVtcvBifkhGhYtPrebrcCnN1Ski/+S/e+LvNQQPAAy48Bh0aCLCnNhxhQyEJuBj9BmJqN7xFE+SwhzDHCBIqlI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785298455; c=relaxed/simple;
	bh=uAqWwSx1krd09YW9OEywXNUh2OLYaOBuiyAUiQJvrGk=;
	h=Date:To:From:Subject:Message-Id; b=nyXH5000tXeKvlry8LeRR4vfJmQgCJWt16p5lCxZm0GbiLf2zysQIxbHfMgN89NOi8+FL6tcrwB/UGGHFIvmMriws0JM2YSZA09u6hTmtAM6xnGPVRPspgYrYHWKWGwzb+iSqPz15Ub1ktmQ/7hGxkklo3BKagIVxaVMXKgeFFI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=F2DgNgW1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="F2DgNgW1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2CF21F000E9;
	Wed, 29 Jul 2026 04:14:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785298453;
	bh=89m40eLBioELf2OBipEcGjmcu1T409SGH9GwmoX+ioQ=;
	h=Date:To:From:Subject;
	b=F2DgNgW1tTdQ21a8Eb0jar8gaFsueALWxgVy28nJNH3U1+SiGNHmOpgA392TQXphU
	 HcyW7UcVE/dMiOc5C741jphYaXJZ6CwvEt9LdIdjOZZ87k5397ZpD2r6VTnYeQVxVw
	 tgHnnISIE++jWJSmgpVsRZ7eO3wD5di/w6BjWSjM=
Date: Tue, 28 Jul 2026 21:14:13 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,usama.arif@linux.dev,stable@vger.kernel.org,rppt@kernel.org,ritesh.list@gmail.com,osalvador@suse.de,osalvador@kernel.org,npiggin@gmail.com,mpe@ellerman.id.au,mclapinski@google.com,maddy@linux.ibm.com,ljs@kernel.org,liam@infradead.org,fvdl@google.com,david@kernel.org,aneesh.kumar@linux.ibm.com,songmuchun@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-hugetlb-fix-boot-panic-with-config_debug_vm-and-hvo-bootmem-pages.patch removed from -mm tree
Message-Id: <20260729041413.D2CF21F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/hugetlb: fix boot panic with CONFIG_DEBUG_VM and HVO bootmem pages
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-fix-boot-panic-with-config_debug_vm-and-hvo-bootmem-pages.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Tested-by: Michal Clapinski <mclapinski@google.com>
Reviewed-by: Michal Clapinski <mclapinski@google.com>
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

selftests-mm-remove-obsolete-hugetlb-vmemmap-test.patch

