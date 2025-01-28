Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1C31170A1B
	for <mm-commits@vger.kernel.org>; Tue, 28 Jan 2025 00:10:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738023034; cv=none; b=Vb7/bSix6LUHqBoWelF0GWQj21NT1BiCmBaEBLmA5xqP+Cn/XucJUS9XFt7SWQ8GANCgh9q1h6lcsrA81Eg0Rcb9s1qTJraQ2JTSjHNvKDOrhSgaLD4oM1NufAlLnsLTg71Xv+xelt1UjxcUD1PLncmBKVpyZ5cPqmCARpnb370=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738023034; c=relaxed/simple;
	bh=PKpZpyZvSd1ns6g5lLIyK8jiMHXaPbtHALgqEt1XWqk=;
	h=Date:To:From:Subject:Message-Id; b=JGVhCi4861DLHttB66NGT4Dn4usLo1Oy5otgAmYXSaIzKiL8mBRlO07hfQMcmiVQQpc7y+fM5azt+m44vOB8v7/FRnZFublXK3xUPdlyP/2J7GOP4zzQ55fWGQsj/uFWFTNZOJXOeAA4KwM/uZsfJFBYqrHBBZ571VNwIyAIh3s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=TZqkkHz+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="TZqkkHz+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8825EC4CED2;
	Tue, 28 Jan 2025 00:10:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1738023034;
	bh=PKpZpyZvSd1ns6g5lLIyK8jiMHXaPbtHALgqEt1XWqk=;
	h=Date:To:From:Subject:From;
	b=TZqkkHz++LG/T6UT1v6vbVpzVnecxCWaleo8hPZ+8hZ6gCGDob53niR7pANHqLxQh
	 vx60Mi8VIvcZM6PGaPeg0u5dBiWEwcR7Zy3e0MCZ5yl2kgcvCk7yRdLMZeZ7JbuLFE
	 eMpduW1+FJSLfpwLmGZZNBdeRSNyFDljDCst96Gk=
Date: Mon, 27 Jan 2025 16:10:34 -0800
To: mm-commits@vger.kernel.org,yuzhao@google.com,yaozhenguo1@gmail.com,usama.arif@bytedance.com,rppt@kernel.org,roman.gushchin@linux.dev,peterz@infradead.org,muchun.song@linux.dev,mpe@ellerman.id.au,maddy@linux.ibm.com,luto@kernel.org,joao.m.martins@oracle.com,hca@linux.ibm.com,gor@linux.ibm.com,dave.hansen@linux.intel.com,agordeev@linux.ibm.com,fvdl@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb-add-hugetlb_cma_only-cmdline-option.patch added to mm-unstable branch
Message-Id: <20250128001034.8825EC4CED2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/hugetlb: add hugetlb_cma_only cmdline option
has been added to the -mm mm-unstable branch.  Its filename is
     mm-hugetlb-add-hugetlb_cma_only-cmdline-option.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb-add-hugetlb_cma_only-cmdline-option.patch

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
Subject: mm/hugetlb: add hugetlb_cma_only cmdline option
Date: Mon, 27 Jan 2025 23:22:06 +0000

Add an option to force hugetlb gigantic pages to be allocated using CMA
only (if hugetlb_cma is enabled).  This avoids a fallback to allocation
from the rest of system memory if the CMA allocation fails.  This makes
the size of hugetlb_cma a hard upper boundary for gigantic hugetlb page
allocations.

This is useful because, with a large CMA area, the kernel's unmovable
allocations will have less room to work with and it is undesirable for new
hugetlb gigantic page allocations to be done from that remaining area.  It
will eat in to the space available for unmovable allocations, leading to
unwanted system behavior (OOMs because the kernel fails to do unmovable
allocations).

So, with this enabled, an administrator can force a hard upper bound for
runtime gigantic page allocations, and have more predictable system
behavior.

Link: https://lkml.kernel.org/r/20250127232207.3888640-27-fvdl@google.com
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

 Documentation/admin-guide/kernel-parameters.txt |    7 +++++++
 mm/hugetlb.c                                    |   11 +++++++++++
 2 files changed, 18 insertions(+)

--- a/Documentation/admin-guide/kernel-parameters.txt~mm-hugetlb-add-hugetlb_cma_only-cmdline-option
+++ a/Documentation/admin-guide/kernel-parameters.txt
@@ -1892,6 +1892,13 @@
 			hugepages using the CMA allocator. If enabled, the
 			boot-time allocation of gigantic hugepages is skipped.
 
+	hugetlb_cma_only=
+			[HW,CMA,EARLY] When allocating new HugeTLB pages, only
+			try to allocate from the CMA areas.
+
+			This option does nothing if hugetlb_cma= is not also
+			specified.
+
 	hugetlb_free_vmemmap=
 			[KNL] Requires CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP
 			enabled.
--- a/mm/hugetlb.c~mm-hugetlb-add-hugetlb_cma_only-cmdline-option
+++ a/mm/hugetlb.c
@@ -60,6 +60,7 @@ struct hstate hstates[HUGE_MAX_HSTATE];
 static struct cma *hugetlb_cma[MAX_NUMNODES];
 static unsigned long hugetlb_cma_size_in_node[MAX_NUMNODES] __initdata;
 #endif
+static bool hugetlb_cma_only;
 static unsigned long hugetlb_cma_size __initdata;
 
 __initdata struct list_head huge_boot_pages[MAX_NUMNODES];
@@ -1511,6 +1512,9 @@ retry:
 	}
 #endif
 	if (!folio) {
+		if (hugetlb_cma_size && hugetlb_cma_only)
+			return NULL;
+
 		folio = folio_alloc_gigantic(order, gfp_mask, nid, nodemask);
 		if (!folio)
 			return NULL;
@@ -7844,6 +7848,13 @@ static int __init cmdline_parse_hugetlb_
 
 early_param("hugetlb_cma", cmdline_parse_hugetlb_cma);
 
+static int __init cmdline_parse_hugetlb_cma_only(char *p)
+{
+	return kstrtobool(p, &hugetlb_cma_only);
+}
+
+early_param("hugetlb_cma_only", cmdline_parse_hugetlb_cma_only);
+
 void __init hugetlb_cma_reserve(int order)
 {
 	unsigned long size, reserved, per_node;
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

