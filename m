Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEA4A1B87C9
	for <mm-commits@vger.kernel.org>; Wed, 29 Jan 2025 23:25:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738193142; cv=none; b=Y8HDLT7KvDfi2XW/aU5vMAMTe+YgdxvsIbi9b5nxoOJA2/X5/SLlYq5JhznpbpSmb+LSSQOPYUtsFpPbVzd0Mq+33XIrczW4ZGk5iDcZWJedwQ7gUt5HGqX0A2D4yTxXsCirC8Nrq94VBLKSnjKeqjIPSg4AUxdXKDcdPX4dM+A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738193142; c=relaxed/simple;
	bh=eXTGV7shYAVxc/T6mo95JRIS9/cdMGFIoBB2PV2j+YI=;
	h=Date:To:From:Subject:Message-Id; b=j3yIbQIKONJpnavS2yBZhrqqzXkJTzfnRqtxvUYjue3I4+svLZOBKzAChbpUQBd8Fu1Laui50O1scijU4HIaCnK894ERBd8z0RhPlDDO3cin4YOyacWwZkVu49MYyN3rxRY4BJNAIk2zaTZvPVv2eU6+acjL2yElvtOr/xI7U24=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=cR/Jf6P+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="cR/Jf6P+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4062EC4CED1;
	Wed, 29 Jan 2025 23:25:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1738193142;
	bh=eXTGV7shYAVxc/T6mo95JRIS9/cdMGFIoBB2PV2j+YI=;
	h=Date:To:From:Subject:From;
	b=cR/Jf6P+CMOH87cwV/LUdoSJ84182u8vZ8dk4SW+ClmMyGYKAS/Ef/Knm29/BsRuH
	 RSwDgdO1KF2F3grhjoseDpE/3PFWP/fam5c9GJSYkcze8wvIItI17WKwbddktNhB2f
	 DTpe97rdq3hJvSANROAnu49EqvrpU7gybSM5s4TY=
Date: Wed, 29 Jan 2025 15:25:41 -0800
To: mm-commits@vger.kernel.org,yuzhao@google.com,yaozhenguo1@gmail.com,usamaarif642@gmail.com,roman.gushchin@linux.dev,peterz@infradead.org,muchun.song@linux.dev,mpe@ellerman.id.au,maddy@linux.ibm.com,luto@kernel.org,joao.m.martins@oracle.com,hca@linux.ibm.com,gor@linux.ibm.com,dave.hansen@linux.intel.com,agordeev@linux.ibm.com,fvdl@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb-fix-round-robin-bootmem-allocation.patch added to mm-unstable branch
Message-Id: <20250129232542.4062EC4CED1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/hugetlb: fix round-robin bootmem allocation
has been added to the -mm mm-unstable branch.  Its filename is
     mm-hugetlb-fix-round-robin-bootmem-allocation.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb-fix-round-robin-bootmem-allocation.patch

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
From: Frank van der Linden <fvdl@google.com>
Subject: mm/hugetlb: fix round-robin bootmem allocation
Date: Wed, 29 Jan 2025 22:41:34 +0000

Commit b5389086ad7b ("hugetlbfs: extend the definition of hugepages
parameter to support node allocation") changed the NUMA_NO_NODE
round-robin allocation behavior in case of a failure to allocate from one
NUMA node.  The code originally moved on to the next node to try again,
but now it immediately breaks out of the loop.

Restore the original behavior.

Link: https://lkml.kernel.org/r/20250129224157.2046079-6-fvdl@google.com
Fixes: b5389086ad7b ("hugetlbfs: extend the definition of hugepages parameter to support node allocation")
Signed-off-by: Frank van der Linden <fvdl@google.com>
Cc: Zhenguo Yao <yaozhenguo1@gmail.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Joao Martins <joao.m.martins@oracle.com>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Roman Gushchin (Cruise) <roman.gushchin@linux.dev>
Cc: Usama Arif <usamaarif642@gmail.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Yu Zhao <yuzhao@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   22 +++++++++++++---------
 1 file changed, 13 insertions(+), 9 deletions(-)

--- a/mm/hugetlb.c~mm-hugetlb-fix-round-robin-bootmem-allocation
+++ a/mm/hugetlb.c
@@ -3156,16 +3156,13 @@ int __alloc_bootmem_huge_page(struct hst
 		m = memblock_alloc_try_nid_raw(
 				huge_page_size(h), huge_page_size(h),
 				0, MEMBLOCK_ALLOC_ACCESSIBLE, node);
-		/*
-		 * Use the beginning of the huge page to store the
-		 * huge_bootmem_page struct (until gather_bootmem
-		 * puts them into the mem_map).
-		 */
-		if (!m)
-			return 0;
-		goto found;
+		if (m)
+			break;
 	}
 
+	if (!m)
+		return 0;
+
 found:
 
 	/*
@@ -3177,7 +3174,14 @@ found:
 	 */
 	memblock_reserved_mark_noinit(virt_to_phys((void *)m + PAGE_SIZE),
 		huge_page_size(h) - PAGE_SIZE);
-	/* Put them into a private list first because mem_map is not up yet */
+	/*
+	 * Use the beginning of the huge page to store the
+	 * huge_bootmem_page struct (until gather_bootmem
+	 * puts them into the mem_map).
+	 *
+	 * Put them into a private list first because mem_map
+	 * is not up yet.
+	 */
 	INIT_LIST_HEAD(&m->list);
 	list_add(&m->list, &huge_boot_pages[node]);
 	m->hstate = h;
_

Patches currently in -mm which might be from fvdl@google.com are

mm-cma-export-total-and-free-number-of-pages-for-cma-areas.patch
mm-cma-support-multiple-contiguous-ranges-if-requested.patch
mm-cma-introduce-cma_intersects-function.patch
mm-hugetlb-use-cma_declare_contiguous_multi.patch
mm-hugetlb-fix-round-robin-bootmem-allocation.patch
mm-hugetlb-remove-redundant-__clearpagereserved.patch
mm-hugetlb-use-online-nodes-for-bootmem-allocation.patch
mm-hugetlb-convert-cmdline-parameters-from-setup-to-early.patch
x86-mm-make-register_page_bootmem_memmap-handle-pte-mappings.patch
mm-bootmem_info-export-register_page_bootmem_memmap.patch
mm-sparse-allow-for-alternate-vmemmap-section-init-at-boot.patch
mm-hugetlb-set-migratetype-for-bootmem-folios.patch
mm-define-__init_reserved_page_zone-function.patch
mm-hugetlb-check-bootmem-pages-for-zone-intersections.patch
mm-sparse-add-vmemmap__hvo-functions.patch
mm-hugetlb-deal-with-multiple-calls-to-hugetlb_bootmem_alloc.patch
mm-hugetlb-move-huge_boot_pages-list-init-to-hugetlb_bootmem_alloc.patch
mm-hugetlb-add-pre-hvo-framework.patch
mm-hugetlb_vmemmap-fix-hugetlb_vmemmap_restore_folios-definition.patch
mm-hugetlb-do-pre-hvo-for-bootmem-allocated-pages.patch
x86-setup-call-hugetlb_bootmem_alloc-early.patch
x86-mm-set-arch_want_sparsemem_vmemmap_preinit.patch
mm-cma-simplify-zone-intersection-check.patch
mm-cma-introduce-a-cma-validate-function.patch
mm-cma-introduce-interface-for-early-reservations.patch
mm-hugetlb-add-hugetlb_cma_only-cmdline-option.patch
mm-hugetlb-enable-bootmem-allocation-from-cma-areas.patch
mm-hugetlb-move-hugetlb-cma-code-in-to-its-own-file.patch

