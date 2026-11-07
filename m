Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794034443;
	b=yFHFfcxI8gFJ9/QYP4BdkmwZu47oddw1O6/+1sXJKgcOsSAKsr0apL/53ZeJTugv7Rap
	 p5J6Cv+QXBpl0MeyZJprfy3st+yFivxVwy8NwOOnu7wNUlY9WZEOA+iiKXXmaidGIscke
	 8Y1Nx8Wmk+rbrKbdVVim5PhPcOfINN4gH6QMJD06k6tXYimXvagrAa2g0HOwwOFLjiknz
	 JWr2NvZAE9QrFMCu4Kjg7UXHck65xYWSMMKPXY/E23ZxXjZwzkNHA3y2oGL6720CoQolZ
	 l8wf9Mwy8O0GkuNbDxF5LOg9nNgcePx1KS60Za8UJoMoAkbhp6G8qCwaqImhRNxp9xg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794034443;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=+Q/oq7pF0tZFp5MMVXv2LB1heS4RFoyMBj44gApFHZY=;
	b=m0dOLu+MK/mZCyH1PYy04Ds8xI5TsgktjycPe2CqYkL/RcHAnT3JjJEF4LGRb+/QWog2
	 AZyshKAF001O22D+nlyvS2rmdfncTBMM8+t4PHdaK43wDQloV0RgO9s7xte540FyKVswY
	 1uHe/wjJtwV+hKt+LopjorfLEhJrq1BX68CT90n1IjfmGpz/Od0T/CGAYV1ZI54elRnEz
	 ZtLXn6mnjJsUIQavA+kwRYxfY59Weqmh0YrMGRSiz06wHfTBvmWBl9NkKtPlCQn84W88L
	 rprRMA95kzGuzTCnuJt7wvpDi7s9vsPH5+do1K2y3v8Xu8s98/kqw5rw/n4YY0z7rlA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=LFpflY0s;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FE0A606A32C
	for <mm-commits@vger.kernel.org>; Sat,  7 Nov 2026 06:54:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=LFpflY0s
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3A651F0089F;
	Sat,  7 Nov 2026 06:54:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794034442;
	bh=+Q/oq7pF0tZFp5MMVXv2LB1heS4RFoyMBj44gApFHZY=;
	h=Date:To:From:Subject;
	b=LFpflY0sZvHgHdhSKfPIs+GdUa0Qupta6uKQUZyoSqxnzmeYnuxI+gAPar31hMBLy
	 2KIAloes7BeonJwOY2GoA6oRT5q3nxgypuMnGJr0+IT0xsThkB2InaK42o82/2k/JZ
	 AWHX++sArdHvpSuNKySQxAZIRo8uIKkAARgtRads=
Date: Fri, 06 Nov 2026 22:54:02 -0800
To: mm-commits@vger.kernel.org,sshegde@linux.ibm.com,rppt@kernel.org,
	ritesh.list@gmail.com,qi.zheng@linux.dev,osalvador@suse.de,npiggin@gmail.com,
	mpe@ellerman.id.au,maddy@linux.ibm.com,lance.yang@linux.dev,
	kernel@xen0n.name,david@kernel.org,chleroy@kernel.org,chenhuacai@kernel.org,
	muchun.song@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + loongarch-mm-disable-device-dax-vmemmap-optimization.patch added to mm-new branch
Message-Id: <20261107065402.A3A651F0089F@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: loongarch/mm: disable device DAX vmemmap optimization
has been added to the -mm mm-new branch.  Its filename is
     loongarch-mm-disable-device-dax-vmemmap-optimization.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/loongarch-mm-disable-device-dax-vmemmap-optimization.patch

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
From: Muchun Song <muchun.song@linux.dev>
Subject: loongarch/mm: disable device DAX vmemmap optimization
Date: Sat, 07 Nov 2026 12:31:20 +0800

LoongArch selects ARCH_WANT_OPTIMIZE_HUGETLB_VMEMMAP but not
ARCH_WANT_OPTIMIZE_DAX_VMEMMAP. Its vmemmap_free() implementation is also
empty, so it cannot tear down optimized Device DAX mappings.

A later change removes the generic Device DAX architecture gate and lets
vmemmap_populate() decide whether a section can use optimization. Clear the
section compound order in the LoongArch path so Device DAX keeps using
unoptimized mappings.

This does not affect HugeTLB HVO: LoongArch does not support gigantic
pages, so HugeTLB does not use section-based vmemmap optimization there.

Link: https://lore.kernel.org/20261107043122.25650-4-songmuchun@bytedance.com
Signed-off-by: Muchun Song <muchun.song@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Christophe Leroy <chleroy@kernel.org>
Cc: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
Cc: Shrikanth Hegde <sshegde@linux.ibm.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Qi Zheng <qi.zheng@linux.dev>
Cc: Huacai Chen <chenhuacai@kernel.org>
Cc: WANG Xuerui <kernel@xen0n.name>
---

 arch/loongarch/mm/init.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/arch/loongarch/mm/init.c~loongarch-mm-disable-device-dax-vmemmap-optimization
+++ a/arch/loongarch/mm/init.c
@@ -15,6 +15,7 @@
 #include <linux/memblock.h>
 #include <linux/memremap.h>
 #include <linux/mm.h>
+#include <linux/vmemmap-optimization.h>
 #include <linux/mman.h>
 #include <linux/highmem.h>
 #include <linux/swap.h>
@@ -143,6 +144,7 @@ void __meminit vmemmap_set_pmd(pmd_t *pm
 int __meminit vmemmap_populate(unsigned long start, unsigned long end,
 			       int node, struct vmem_altmap *altmap)
 {
+	section_vmemmap_optimization_disable(start, end);
 #if CONFIG_PGTABLE_LEVELS == 2
 	return vmemmap_populate_basepages(start, end, node, NULL);
 #else
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
powerpc-mm-make-vmemmap_populate_compound_pages-static.patch
powerpc-mm-drop-powerpc-vmemmap_can_optimize.patch
loongarch-mm-disable-device-dax-vmemmap-optimization.patch
mm-sparse-vmemmap-drop-vmemmap_can_optimize.patch
mm-sparse-vmemmap-drop-pgmap-from-vmemmap-population-apis.patch

