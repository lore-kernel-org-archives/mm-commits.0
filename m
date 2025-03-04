Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E0C21B3F3D
	for <mm-commits@vger.kernel.org>; Tue,  4 Mar 2025 02:49:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741056582; cv=none; b=jJKltokG1qIL6wk4xEBy4zibE0Z58OXt/+nPGS/TXAdPWfT15B0XD8mKfwjo0selt+DmsglFVu9wBbmbzwBzyEKsF3920YvOoBfz1P6Ra2Fi2/eAWItalu6CD9e7Afito5aG7+r/mdU/hOk+WwCuWksS3MhhMhmoIeF9RS9OaeI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741056582; c=relaxed/simple;
	bh=I7S+00nxRYlBcS2BPOpoPDxpWY7uYJG2Kgzj+xIWvec=;
	h=Date:To:From:Subject:Message-Id; b=R4XcSZM4PWPVED32PkmB3QABr3KVZE0CjMX7Tzqa2smAj5Y6hkTrYxxTcXoUM+bHQN0aSyZoZO3QaFB5XTNM/A2KxAT6MYhnokfszv2GX03wOdZpUQj647dMWNDwGU5rGwAjW2Rn7Zqe5t51+ajFM7ysgV61hsSoyckOTV2Udlo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=U5mUhTom; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="U5mUhTom"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70F65C4CEE4;
	Tue,  4 Mar 2025 02:49:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1741056582;
	bh=I7S+00nxRYlBcS2BPOpoPDxpWY7uYJG2Kgzj+xIWvec=;
	h=Date:To:From:Subject:From;
	b=U5mUhTomn2+Axdnce3WBP25CjbzPi5U1yYDmIWYlWMRzigVndsyXEFbXNFGcbippy
	 b7CVU0/Oz+UFbJVEU5j3GStR2UMEsiz4N58daTB2TSvGNJDjKUoWzMEiYyk8PZEOWQ
	 tle5NMsbsvs3PzEAI72zlNBgEHVQrKNALyX8wOGQ=
Date: Mon, 03 Mar 2025 18:49:41 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,yuzhao@google.com,usamaarif642@gmail.com,roman.gushchin@linux.dev,peterz@infradead.org,osalvador@suse.de,muchun.song@linux.dev,mpe@ellerman.id.au,maddy@linux.ibm.com,luto@kernel.org,joao.m.martins@oracle.com,hca@linux.ibm.com,hannes@cmpxchg.org,gor@linux.ibm.com,david@redhat.com,dave.hansen@linux.intel.com,dan.carpenter@linaro.org,arnd@arndb.de,agordeev@linux.ibm.com,fvdl@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb-add-hugetlb_cma_only-cmdline-option.patch added to mm-unstable branch
Message-Id: <20250304024942.70F65C4CEE4@smtp.kernel.org>
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
Date: Fri, 28 Feb 2025 18:29:26 +0000

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

Link: https://lkml.kernel.org/r/20250228182928.2645936-26-fvdl@google.com
Signed-off-by: Frank van der Linden <fvdl@google.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Dan Carpenter <dan.carpenter@linaro.org>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Joao Martins <joao.m.martins@oracle.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Roman Gushchin (Cruise) <roman.gushchin@linux.dev>
Cc: Usama Arif <usamaarif642@gmail.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Yu Zhao <yuzhao@google.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/kernel-parameters.txt |    7 +++++++
 mm/hugetlb.c                                    |   14 ++++++++++++++
 2 files changed, 21 insertions(+)

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
@@ -59,6 +59,7 @@ struct hstate hstates[HUGE_MAX_HSTATE];
 static struct cma *hugetlb_cma[MAX_NUMNODES];
 static unsigned long hugetlb_cma_size_in_node[MAX_NUMNODES] __initdata;
 #endif
+static bool hugetlb_cma_only;
 static unsigned long hugetlb_cma_size __initdata;
 
 __initdata struct list_head huge_boot_pages[MAX_NUMNODES];
@@ -1510,6 +1511,9 @@ retry:
 	}
 #endif
 	if (!folio) {
+		if (hugetlb_cma_only)
+			return NULL;
+
 		folio = folio_alloc_gigantic(order, gfp_mask, nid, nodemask);
 		if (!folio)
 			return NULL;
@@ -4746,6 +4750,9 @@ static __init void hugetlb_parse_params(
 
 		hcp->setup(hcp->val);
 	}
+
+	if (!hugetlb_cma_size)
+		hugetlb_cma_only = false;
 }
 
 /*
@@ -7858,6 +7865,13 @@ static int __init cmdline_parse_hugetlb_
 
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
x86-mm-set-arch_want_hugetlb_vmemmap_preinit.patch
mm-cma-simplify-zone-intersection-check.patch
mm-cma-introduce-a-cma-validate-function.patch
mm-cma-introduce-interface-for-early-reservations.patch
mm-hugetlb-add-hugetlb_cma_only-cmdline-option.patch
mm-hugetlb-enable-bootmem-allocation-from-cma-areas.patch
mm-hugetlb-move-hugetlb-cma-code-in-to-its-own-file.patch

