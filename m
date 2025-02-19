Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD26138B
	for <mm-commits@vger.kernel.org>; Wed, 19 Feb 2025 00:04:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739923477; cv=none; b=qkd4S8MiSEr7eNYMx5mxyxoRBk2s/CRAmZpnCVc57m1x8hvjXICySnrN0LnFt+uNMHaQVkEe4y5gO9zv4+ECzOhPB9QN4su9/TaSGFUvo1NaCUXJ0ikvWFJaAyYVNlTymexFdfCGrb9wjRI4nVHhyEnFTpVBHWVkPMVhCA5xZ4Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739923477; c=relaxed/simple;
	bh=I52Zqis0p3jjQJAK3OjOJ96YBpN8Z8CYGh2/sOW92V0=;
	h=Date:To:From:Subject:Message-Id; b=STev8w3PQd2RXWKuGGitxq5SphHteSXAHwYasv4mVUQMq2uQUXi1yCyGKhWLV1/avsrCNzdj7I2Oou+eG2pysKgLjh3HJZozWycYFX5ITxcoHq5zHaEJ9BLK8K/ZCLUhPUWJeHUHqZnDgujHO99pl6HMgXi4FOpOdUN8bCJT7E8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=2ro4CGk9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="2ro4CGk9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42099C4CEE6;
	Wed, 19 Feb 2025 00:04:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1739923477;
	bh=I52Zqis0p3jjQJAK3OjOJ96YBpN8Z8CYGh2/sOW92V0=;
	h=Date:To:From:Subject:From;
	b=2ro4CGk9HkTMMbFz26CYaCD+E6BSyheI0SCFsV6GGXoh46V7gbFfwCv+6RVddlIxk
	 UCsIOP5eg1fQMxja9axm2nneQXR0j5u2Zb9reONut7yAtgnnwFNb62M7+G91eo383Y
	 cqXIWB+yj8Y57pa+dJ3vkoTOLxd8SzTd4vssoGEk=
Date: Tue, 18 Feb 2025 16:04:36 -0800
To: mm-commits@vger.kernel.org,yuzhao@google.com,usamaarif642@gmail.com,roman.gushchin@linux.dev,peterz@infradead.org,osalvador@suse.de,muchun.song@linux.dev,mpe@ellerman.id.au,maddy@linux.ibm.com,luto@kernel.org,joao.m.martins@oracle.com,hca@linux.ibm.com,gor@linux.ibm.com,dave.hansen@linux.intel.com,dan.carpenter@linaro.org,agordeev@linux.ibm.com,fvdl@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb-move-huge_boot_pages-list-init-to-hugetlb_bootmem_alloc.patch added to mm-unstable branch
Message-Id: <20250219000437.42099C4CEE6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/hugetlb: move huge_boot_pages list init to hugetlb_bootmem_alloc
has been added to the -mm mm-unstable branch.  Its filename is
     mm-hugetlb-move-huge_boot_pages-list-init-to-hugetlb_bootmem_alloc.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb-move-huge_boot_pages-list-init-to-hugetlb_bootmem_alloc.patch

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
Subject: mm/hugetlb: move huge_boot_pages list init to hugetlb_bootmem_alloc
Date: Tue, 18 Feb 2025 18:16:44 +0000

Instead of initializing the per-node hugetlb bootmem pages list from the
alloc function, we can now do it in a somewhat cleaner way, since there is
an explicit hugetlb_bootmem_alloc function.  Initialize the lists there.

Link: https://lkml.kernel.org/r/20250218181656.207178-17-fvdl@google.com
Signed-off-by: Frank van der Linden <fvdl@google.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Dan Carpenter <dan.carpenter@linaro.org>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Joao Martins <joao.m.martins@oracle.com>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Roman Gushchin (Cruise) <roman.gushchin@linux.dev>
Cc: Usama Arif <usamaarif642@gmail.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Yu Zhao <yuzhao@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   19 +++++++------------
 1 file changed, 7 insertions(+), 12 deletions(-)

--- a/mm/hugetlb.c~mm-hugetlb-move-huge_boot_pages-list-init-to-hugetlb_bootmem_alloc
+++ a/mm/hugetlb.c
@@ -3574,7 +3574,6 @@ static unsigned long __init hugetlb_page
 static void __init hugetlb_hstate_alloc_pages(struct hstate *h)
 {
 	unsigned long allocated;
-	static bool initialized __initdata;
 
 	/* skip gigantic hugepages allocation if hugetlb_cma enabled */
 	if (hstate_is_gigantic(h) && hugetlb_cma_size) {
@@ -3582,17 +3581,6 @@ static void __init hugetlb_hstate_alloc_
 		return;
 	}
 
-	/* hugetlb_hstate_alloc_pages will be called many times, initialize huge_boot_pages once */
-	if (!initialized) {
-		int i = 0;
-
-		for (i = 0; i < MAX_NUMNODES; i++)
-			INIT_LIST_HEAD(&huge_boot_pages[i]);
-		h->next_nid_to_alloc = first_online_node;
-		h->next_nid_to_free = first_online_node;
-		initialized = true;
-	}
-
 	/* do node specific alloc */
 	if (hugetlb_hstate_alloc_pages_specific_nodes(h))
 		return;
@@ -4916,13 +4904,20 @@ bool __init hugetlb_bootmem_allocated(vo
 void __init hugetlb_bootmem_alloc(void)
 {
 	struct hstate *h;
+	int i;
 
 	if (__hugetlb_bootmem_allocated)
 		return;
 
+	for (i = 0; i < MAX_NUMNODES; i++)
+		INIT_LIST_HEAD(&huge_boot_pages[i]);
+
 	hugetlb_parse_params();
 
 	for_each_hstate(h) {
+		h->next_nid_to_alloc = first_online_node;
+		h->next_nid_to_free = first_online_node;
+
 		if (hstate_is_gigantic(h))
 			hugetlb_hstate_alloc_pages(h);
 	}
_

Patches currently in -mm which might be from fvdl@google.com are

mm-cma-export-total-and-free-number-of-pages-for-cma-areas.patch
mm-cma-support-multiple-contiguous-ranges-if-requested.patch
mm-cma-introduce-cma_intersects-function.patch
mm-hugetlb-use-cma_declare_contiguous_multi.patch
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

