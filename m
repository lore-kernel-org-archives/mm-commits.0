Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1077E1E0E10
	for <mm-commits@vger.kernel.org>; Wed, 29 Jan 2025 23:25:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738193147; cv=none; b=r8ybE+VFXuL4yOfCXJoJdMaFbJrVEe390ZkCnxOBM15GmoDlnMbsZJ6HpzwmquhBFySECU/z1J2kDHHopAB+0Uz9aDMcdR3qmWBYdG5TDeUkahX0ePqgTxy8+4wv8iWIn8bfZWCDtKZrWxby4+07pm7Bj8JissLu9RAdSoNiz+w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738193147; c=relaxed/simple;
	bh=Npxf+JT2QVP1jWG9oEL2u+Upg4Vb8L5iu8ChAlC9f6g=;
	h=Date:To:From:Subject:Message-Id; b=qky18PERfG9QLL85dRqhvCBF2h/aqw7nDMYqzIqb+9fmv1Q1WkKKKwqB5SS5nJfT3E1qf9N7ymy44gFGA+LyaOmBwKHuiylhhl3MD+0TDHbTw90p8o6F8fFmFEFw6QI/5r5ZxkiG0Ssj/r7j1A68trmFCSoijuIOr8oWr0Jbh0c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=abrm1+VE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="abrm1+VE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D522C4CEE0;
	Wed, 29 Jan 2025 23:25:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1738193146;
	bh=Npxf+JT2QVP1jWG9oEL2u+Upg4Vb8L5iu8ChAlC9f6g=;
	h=Date:To:From:Subject:From;
	b=abrm1+VEl8vbESE4LNAzw0u6klsweTssug/KhNUYwtnudRsIht80ivtETbbNXNuHX
	 UtsAMYyHXZXpW+kEKMM0SgDmIYaXzlSNnco49xqjJMSKP+4BsoI/KBSItXbiEagkJB
	 1mBDu1v1N6FZckRyZFmi1qyZ9KfjWQR5YUSuiAp8=
Date: Wed, 29 Jan 2025 15:25:45 -0800
To: mm-commits@vger.kernel.org,yuzhao@google.com,yaozhenguo1@gmail.com,usamaarif642@gmail.com,roman.gushchin@linux.dev,peterz@infradead.org,muchun.song@linux.dev,mpe@ellerman.id.au,maddy@linux.ibm.com,luto@kernel.org,joao.m.martins@oracle.com,hca@linux.ibm.com,gor@linux.ibm.com,dave.hansen@linux.intel.com,agordeev@linux.ibm.com,fvdl@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb-use-online-nodes-for-bootmem-allocation.patch added to mm-unstable branch
Message-Id: <20250129232546.5D522C4CEE0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/hugetlb: use online nodes for bootmem allocation
has been added to the -mm mm-unstable branch.  Its filename is
     mm-hugetlb-use-online-nodes-for-bootmem-allocation.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb-use-online-nodes-for-bootmem-allocation.patch

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
Subject: mm/hugetlb: use online nodes for bootmem allocation
Date: Wed, 29 Jan 2025 22:41:36 +0000

Later commits will move hugetlb bootmem allocation to earlier in init,
when N_MEMORY has not yet been set on nodes.  Use online nodes instead. 
At most, this wastes just a few cycles once during boot (and most likely
none).

Link: https://lkml.kernel.org/r/20250129224157.2046079-8-fvdl@google.com
Signed-off-by: Frank van der Linden <fvdl@google.com>
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
Cc: Zhenguo Yao <yaozhenguo1@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/mm/hugetlb.c~mm-hugetlb-use-online-nodes-for-bootmem-allocation
+++ a/mm/hugetlb.c
@@ -3152,7 +3152,7 @@ int __alloc_bootmem_huge_page(struct hst
 		goto found;
 	}
 	/* allocate from next node when distributing huge pages */
-	for_each_node_mask_to_alloc(&h->next_nid_to_alloc, nr_nodes, node, &node_states[N_MEMORY]) {
+	for_each_node_mask_to_alloc(&h->next_nid_to_alloc, nr_nodes, node, &node_states[N_ONLINE]) {
 		m = memblock_alloc_try_nid_raw(
 				huge_page_size(h), huge_page_size(h),
 				0, MEMBLOCK_ALLOC_ACCESSIBLE, node);
@@ -4550,8 +4550,8 @@ void __init hugetlb_add_hstate(unsigned
 	for (i = 0; i < MAX_NUMNODES; ++i)
 		INIT_LIST_HEAD(&h->hugepage_freelists[i]);
 	INIT_LIST_HEAD(&h->hugepage_activelist);
-	h->next_nid_to_alloc = first_memory_node;
-	h->next_nid_to_free = first_memory_node;
+	h->next_nid_to_alloc = first_online_node;
+	h->next_nid_to_free = first_online_node;
 	snprintf(h->name, HSTATE_NAME_LEN, "hugepages-%lukB",
 					huge_page_size(h)/SZ_1K);
 
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

