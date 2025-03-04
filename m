Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEFAB179BD
	for <mm-commits@vger.kernel.org>; Tue,  4 Mar 2025 02:48:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741056518; cv=none; b=kcKD1O0Zzas5xNshIf4CzzFIxQgEt54+g+A5IkglrmhGTD4WKHDms9y9AgNtqZGSF8nPb+9p9V3JRrxIzFpXIyfwTR5iNFv1c4eit24uUfpjcfxDjfJ691fywZE5DekeAulWWfc8Tyt+NEWP1ZnNM9pn0BwPcc0geAqUbpYF/6k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741056518; c=relaxed/simple;
	bh=9z2YvFJ1bTTNGVq3Kh5DYe0HCwbEbYoD2b6yOgyHcds=;
	h=Date:To:From:Subject:Message-Id; b=Z06QRdys5qvHnM6y118jnLFKm0SEKT/ybmNXfrQV26Mq24eNaSiJN9VqmcTx2EeqjPjyslWcCud0AIO8RKgEvnjMHKN1D7wEYezPD856wYwUS7cCZpsFSiQxnR107nFZszjCK2n3lmycz1lqrC4vx5seb8sJGPOnlznIB2qotNk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=nBrwD94K; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="nBrwD94K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 201C5C4CEE4;
	Tue,  4 Mar 2025 02:48:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1741056518;
	bh=9z2YvFJ1bTTNGVq3Kh5DYe0HCwbEbYoD2b6yOgyHcds=;
	h=Date:To:From:Subject:From;
	b=nBrwD94Kg+8e5ILjG8T0gcUVQ4eI7zj0C5vVT4eIrPDStPo3JUrsYiqTth9NI94EU
	 RFWFCJmcbRwutiKbeCDGctGC2+hYfS+rdcJKYCv70l3h2g8AzLd9etE4tc2/pWe20M
	 /d4Ih8vtDVG6wEvRkYdIDtKXRn3oqwlWQbotVrDg=
Date: Mon, 03 Mar 2025 18:48:37 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,yuzhao@google.com,usamaarif642@gmail.com,roman.gushchin@linux.dev,peterz@infradead.org,osalvador@suse.de,muchun.song@linux.dev,mpe@ellerman.id.au,maddy@linux.ibm.com,luto@kernel.org,joao.m.martins@oracle.com,hca@linux.ibm.com,hannes@cmpxchg.org,gor@linux.ibm.com,david@redhat.com,dave.hansen@linux.intel.com,dan.carpenter@linaro.org,arnd@arndb.de,agordeev@linux.ibm.com,fvdl@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-cma-introduce-cma_intersects-function.patch added to mm-unstable branch
Message-Id: <20250304024838.201C5C4CEE4@smtp.kernel.org>
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
Date: Fri, 28 Feb 2025 18:29:04 +0000

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

Link: https://lkml.kernel.org/r/20250228182928.2645936-4-fvdl@google.com
Signed-off-by: Frank van der Linden <fvdl@google.com>
Acked-by: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Dan Carpenter <dan.carpenter@linaro.org>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Joao Martins <joao.m.martins@oracle.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Roman Gushchin (Cruise) <roman.gushchin@linux.dev>
Cc: Usama Arif <usamaarif642@gmail.com>
Cc: Yu Zhao <yuzhao@google.com>
Cc: Zi Yan <ziy@nvidia.com>
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
@@ -978,3 +978,24 @@ int cma_for_each_area(int (*it)(struct c
 
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

