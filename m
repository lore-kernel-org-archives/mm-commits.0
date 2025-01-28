Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF9C32837B
	for <mm-commits@vger.kernel.org>; Tue, 28 Jan 2025 00:09:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738022973; cv=none; b=E4tfhARNziz2bQHdihSB481KnZMveQbDHNemormp47NKGuE1jMx2/6pHeaUoOWroejRONLTM/M4BJsuh0+I/s6/OoHYPV7QanzAZ4xe4CY+Rj4Q/s/wuf8HerTeAgDIbz7bvrgI/exhIzqnsL3sJeHTtxIzFAeV5JtJ2WM3R2ms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738022973; c=relaxed/simple;
	bh=YcLKHq90MVLqCDgE69FRxvU5z/FZzFNqS3lnbCrlrLU=;
	h=Date:To:From:Subject:Message-Id; b=dSjPg9b5iwJph5GhOIQlUXPq4A6xuKutLwHPERmG0U0WTzWzKLWSG+25cXj36LZqoqkHBMZYTsaLCkReOinm3P0gBzmc2HLdwn8VgirXgkshH+HEE6iLOhNN/Wzw2bem6Fme3pG22/XwfmQMUvFBxWt8uk8xGontiWIBokXNpLI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=wx7pbHCp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="wx7pbHCp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30F92C4CEE0;
	Tue, 28 Jan 2025 00:09:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1738022973;
	bh=YcLKHq90MVLqCDgE69FRxvU5z/FZzFNqS3lnbCrlrLU=;
	h=Date:To:From:Subject:From;
	b=wx7pbHCpQy08xg9Puog5CdJ80RscBhbIaAJ/ynYeUPN4HCf6Ub3u7rx4KtaRiAp5L
	 /Bi7kLk0SFAyFX5NZH/jH9lwsNQ3oMP4R57XODqEr+uoxnzRMaxh9nMwbVNU2+1CPS
	 OwSyPTo2AeWjnU3mvmTgAFlolZrcNif96M5lnclM=
Date: Mon, 27 Jan 2025 16:09:32 -0800
To: mm-commits@vger.kernel.org,yuzhao@google.com,yaozhenguo1@gmail.com,usama.arif@bytedance.com,rppt@kernel.org,roman.gushchin@linux.dev,peterz@infradead.org,muchun.song@linux.dev,mpe@ellerman.id.au,maddy@linux.ibm.com,luto@kernel.org,joao.m.martins@oracle.com,hca@linux.ibm.com,gor@linux.ibm.com,dave.hansen@linux.intel.com,agordeev@linux.ibm.com,fvdl@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-cma-introduce-cma_intersects-function.patch added to mm-unstable branch
Message-Id: <20250128000933.30F92C4CEE0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/cma: introduce cma_intersects function
has been added to the -mm mm-unstable branch.  Its filename is
     mm-cma-introduce-cma_intersects-function.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-cma-introduce-cma_intersects-function.patch

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
Subject: mm/cma: introduce cma_intersects function
Date: Mon, 27 Jan 2025 23:21:43 +0000

Now that CMA areas can have multiple physical ranges, code can't assume a
CMA struct represents a base_pfn plus a size, as returned from
cma_get_base.

Most cases are ok though, since they all explicitly refer to CMA areas
that were created using existing interfaces (cma_declare_contiguous_nid or
cma_init_reserved_mem), which guarantees they have just one physical
range.

An exception is the s390 code, which walks all CMA ranges to see if they
intersect with a range of memory that is about to be hotremoved.  So, in
the future, it might run in to multi-range areas.  To keep this check
working, define a cma_intersects function.  This just checks if a physaddr
range intersects any of the ranges.  Use it in the s390 check.

Link: https://lkml.kernel.org/r/20250127232207.3888640-4-fvdl@google.com
Signed-off-by: Frank van der Linden <fvdl@google.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Joao Martins <joao.m.martins@oracle.com>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Roman Gushchin (Cruise) <roman.gushchin@linux.dev>
Cc: Usama Arif <usama.arif@bytedance.com>
Cc: Yu Zhao <yuzhao@google.com>
Cc: Zhenguo Yao <yaozhenguo1@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/s390/mm/init.c |   13 +++++--------
 include/linux/cma.h |    1 +
 mm/cma.c            |   21 +++++++++++++++++++++
 3 files changed, 27 insertions(+), 8 deletions(-)

--- a/arch/s390/mm/init.c~mm-cma-introduce-cma_intersects-function
+++ a/arch/s390/mm/init.c
@@ -239,16 +239,13 @@ struct s390_cma_mem_data {
 static int s390_cma_check_range(struct cma *cma, void *data)
 {
 	struct s390_cma_mem_data *mem_data;
-	unsigned long start, end;
 
 	mem_data = data;
-	start = cma_get_base(cma);
-	end = start + cma_get_size(cma);
-	if (end < mem_data->start)
-		return 0;
-	if (start >= mem_data->end)
-		return 0;
-	return -EBUSY;
+
+	if (cma_intersects(cma, mem_data->start, mem_data->end))
+		return -EBUSY;
+
+	return 0;
 }
 
 static int s390_cma_mem_notifier(struct notifier_block *nb,
--- a/include/linux/cma.h~mm-cma-introduce-cma_intersects-function
+++ a/include/linux/cma.h
@@ -53,6 +53,7 @@ extern bool cma_pages_valid(struct cma *
 extern bool cma_release(struct cma *cma, const struct page *pages, unsigned long count);
 
 extern int cma_for_each_area(int (*it)(struct cma *cma, void *data), void *data);
+extern bool cma_intersects(struct cma *cma, unsigned long start, unsigned long end);
 
 extern void cma_reserve_pages_on_error(struct cma *cma);
 
--- a/mm/cma.c~mm-cma-introduce-cma_intersects-function
+++ a/mm/cma.c
@@ -988,3 +988,24 @@ int cma_for_each_area(int (*it)(struct c
 
 	return 0;
 }
+
+bool cma_intersects(struct cma *cma, unsigned long start, unsigned long end)
+{
+	int r;
+	struct cma_memrange *cmr;
+	unsigned long rstart, rend;
+
+	for (r = 0; r < cma->nranges; r++) {
+		cmr = &cma->ranges[r];
+
+		rstart = PFN_PHYS(cmr->base_pfn);
+		rend = PFN_PHYS(cmr->base_pfn + cmr->count);
+		if (end < rstart)
+			continue;
+		if (start >= rend)
+			continue;
+		return true;
+	}
+
+	return false;
+}
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

