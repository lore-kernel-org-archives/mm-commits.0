Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C3F9176AB5
	for <mm-commits@vger.kernel.org>; Tue, 28 Jan 2025 00:10:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738023010; cv=none; b=Abg1M2IReD/T9V2HytuMN76UXCQahkyDKT7/xSU1lCtM9VkLkKLWex+ejo0OBW5aBk70raTcOhd/UPdhbVPkC3hEhcwSkBDpijrZJcizynkwXA/wegyIUS2ZztJkODc22ohEPZJi/RlwsWJUwOhy0zmNRxmRmOILyyLeBqhKDGY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738023010; c=relaxed/simple;
	bh=9wK85jMggRT2Fdct8GJ4CFPveHKL+lBpCb+fRe4oolI=;
	h=Date:To:From:Subject:Message-Id; b=CVV5PQt2LfWACRzfhaTsaPTugY1uyBAFJXsni8BNnaXVEyeKxILWTOqXRTml4dBJFhHlxlw9gavxGI4dfCnrNE953u+Ql4NbAVRHgwptG2OBJEMUxgoHkDRoBf4SnPL0L1pxW95p2o46vkIG94AsC8YbG6cbrTByq8aE6HK4jRE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=eNwvY+fM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="eNwvY+fM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA9E7C4CED2;
	Tue, 28 Jan 2025 00:10:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1738023010;
	bh=9wK85jMggRT2Fdct8GJ4CFPveHKL+lBpCb+fRe4oolI=;
	h=Date:To:From:Subject:From;
	b=eNwvY+fMWHB34aqL3MMtxKI3SuDOj/eSXzci/yrBTxAZC18Wg11Ep4LkW9YplPqLz
	 PSwcu3ZeBq/J+pp4BELRiTib9wxW6cm4ouoxiZ6rR4e1sRt9j8WN/u1AG1LGxRymwt
	 N2FOm8ZnbkEWwN4pZNPUysxfGj0j8/LNdKnmQNXE=
Date: Mon, 27 Jan 2025 16:10:09 -0800
To: mm-commits@vger.kernel.org,yuzhao@google.com,yaozhenguo1@gmail.com,usama.arif@bytedance.com,rppt@kernel.org,roman.gushchin@linux.dev,peterz@infradead.org,muchun.song@linux.dev,mpe@ellerman.id.au,maddy@linux.ibm.com,luto@kernel.org,joao.m.martins@oracle.com,hca@linux.ibm.com,gor@linux.ibm.com,dave.hansen@linux.intel.com,agordeev@linux.ibm.com,fvdl@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb-move-huge_boot_pages-list-init-to-hugetlb_bootmem_alloc.patch added to mm-unstable branch
Message-Id: <20250128001009.EA9E7C4CED2@smtp.kernel.org>
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
Date: Mon, 27 Jan 2025 23:21:57 +0000

Instead of initializing the per-node hugetlb bootmem pages list from the
alloc function, we can now do it in a somewhat cleaner way, since there is
an explicit hugetlb_bootmem_alloc function.  Initialize the lists there.

Link: https://lkml.kernel.org/r/20250127232207.3888640-18-fvdl@google.com
Signed-off-by: Frank van der Linden <fvdl@google.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Joao Martins <joao.m.martins@oracle.com>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Roman Gushchin (Cruise) <roman.gushchin@linux.dev>
Cc: Usama Arif <usama.arif@bytedance.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Yu Zhao <yuzhao@google.com>
Cc: Zhenguo Yao <yaozhenguo1@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   19 +++++++------------
 1 file changed, 7 insertions(+), 12 deletions(-)

--- a/mm/hugetlb.c~mm-hugetlb-move-huge_boot_pages-list-init-to-hugetlb_bootmem_alloc
+++ a/mm/hugetlb.c
@@ -3579,7 +3579,6 @@ static unsigned long __init hugetlb_page
 static void __init hugetlb_hstate_alloc_pages(struct hstate *h)
 {
 	unsigned long allocated;
-	static bool initialized __initdata;
 
 	/* skip gigantic hugepages allocation if hugetlb_cma enabled */
 	if (hstate_is_gigantic(h) && hugetlb_cma_size) {
@@ -3587,17 +3586,6 @@ static void __init hugetlb_hstate_alloc_
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
@@ -4921,13 +4909,20 @@ bool __init hugetlb_bootmem_allocated(vo
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

