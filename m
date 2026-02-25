Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7C9A3E9F7A
	for <mm-commits@vger.kernel.org>; Wed, 25 Feb 2026 19:51:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772049066; cv=none; b=eG1yv4A+9iy9zphH+p9Wo3oEUQ1DUYw3n+e/j95uaGNZ63+wX0zr8CuvduxySZIkt/bMMZrFNC4CUMPIoXwW5lvCPDNfDkz2D1wZqeWNL+Tcwofp7LK1dk046enZf1PLHHMIhUatgt2vNel8rnWM58YHUCBC91ckWhMSTfZJCkg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772049066; c=relaxed/simple;
	bh=e2ZznDrcGigqvlJfaJT7EXxZhNvM/Nj+DA5ZdD/qOi8=;
	h=Date:To:From:Subject:Message-Id; b=uCoht1Bln5Q38aeDPJ370KQopaOVRLxSbbIP5S1z08xjI8PfK+K64LFGNHEMF3x+OmnHRSfYQvJVJpN3s7grin/HbslVQiyBaSYFqm8r6Srl2OtoD8HGczy108N+RcX3+nuQArwpVp13xQZHPIjp+p+IBLizYKK0vEqksyfWud4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=cGkQmEDA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="cGkQmEDA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34A1AC116D0;
	Wed, 25 Feb 2026 19:51:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1772049065;
	bh=e2ZznDrcGigqvlJfaJT7EXxZhNvM/Nj+DA5ZdD/qOi8=;
	h=Date:To:From:Subject:From;
	b=cGkQmEDA/KXKv/oaitMBC9P4cNuXKkQepJ2tzKNHXRH0CxIdH4vkCHlaqZ4zKw+DQ
	 jGJdZGZhM5B72xD7fXcTKLRKgrwA7pXlUxGu7ZiwiivHcUZMCOTxAffQo5A4+BaTGF
	 cvCTo+mq8k/KVJr8X/mut7BVRnYnTyegzImQtc2A=
Date: Wed, 25 Feb 2026 11:51:04 -0800
To: mm-commits@vger.kernel.org,rppt@kernel.org,pratyush@kernel.org,pasha.tatashin@soleen.com,graf@amazon.com,epetron@amazon.de,mclapinski@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kho-fix-deferred-init-of-kho-scratch.patch added to mm-new branch
Message-Id: <20260225195105.34A1AC116D0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kho: fix deferred init of kho scratch
has been added to the -mm mm-new branch.  Its filename is
     kho-fix-deferred-init-of-kho-scratch.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kho-fix-deferred-init-of-kho-scratch.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

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
From: Michal Clapinski <mclapinski@google.com>
Subject: kho: fix deferred init of kho scratch
Date: Wed, 25 Feb 2026 16:39:54 +0100

Patch series "kho: add support for deferred struct page init", v5.

When CONFIG_DEFERRED_STRUCT_PAGE_INIT (hereinafter DEFERRED) is enabled,
struct page initialization is deferred to parallel kthreads that run later
in the boot process.

Currently, KHO is incompatible with DEFERRED.  This series fixes that
incompatibility.


This patch (of 2):

Currently, mm_core_init calls kho_memory_init, which calls
kho_release_scratch.

If DEFERRED is enabled, kho_release_scratch will first initialize the
struct pages of kho scratch.  This is not needed.  We can just let
page_alloc_init_late init it.

Next, kho_release_scratch will mark scratch as MIGRATE_CMA.  If DEFERRED
is enabled, this will be overwritten later in deferred_free_pages.

To fix this, I removed the whole kho_release_scratch.  Marking the
pageblocks as MIGRATE_CMA now happens in kho_init, which runs after
deferred_free_pages.

Link: https://lkml.kernel.org/r/20260225153955.1006649-1-mclapinski@google.com
Link: https://lkml.kernel.org/r/20260225153955.1006649-2-mclapinski@google.com
Signed-off-by: Michal Clapinski <mclapinski@google.com>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Alexander Graf <graf@amazon.com>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Pratyush Yadav <pratyush@kernel.org>
Cc: Evangelos Petrongonas <epetron@amazon.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memblock.h           |    2 -
 kernel/liveupdate/kexec_handover.c |   43 ++++++---------------------
 mm/memblock.c                      |   22 -------------
 3 files changed, 11 insertions(+), 56 deletions(-)

--- a/include/linux/memblock.h~kho-fix-deferred-init-of-kho-scratch
+++ a/include/linux/memblock.h
@@ -614,11 +614,9 @@ static inline void memtest_report_meminf
 #ifdef CONFIG_MEMBLOCK_KHO_SCRATCH
 void memblock_set_kho_scratch_only(void);
 void memblock_clear_kho_scratch_only(void);
-void memmap_init_kho_scratch_pages(void);
 #else
 static inline void memblock_set_kho_scratch_only(void) { }
 static inline void memblock_clear_kho_scratch_only(void) { }
-static inline void memmap_init_kho_scratch_pages(void) {}
 #endif
 
 #endif /* _LINUX_MEMBLOCK_H */
--- a/kernel/liveupdate/kexec_handover.c~kho-fix-deferred-init-of-kho-scratch
+++ a/kernel/liveupdate/kexec_handover.c
@@ -1388,11 +1388,6 @@ static __init int kho_init(void)
 	if (err)
 		goto err_free_fdt;
 
-	if (fdt) {
-		kho_in_debugfs_init(&kho_in.dbg, fdt);
-		return 0;
-	}
-
 	for (int i = 0; i < kho_scratch_cnt; i++) {
 		unsigned long base_pfn = PHYS_PFN(kho_scratch[i].addr);
 		unsigned long count = kho_scratch[i].size >> PAGE_SHIFT;
@@ -1408,8 +1403,17 @@ static __init int kho_init(void)
 		 */
 		kmemleak_ignore_phys(kho_scratch[i].addr);
 		for (pfn = base_pfn; pfn < base_pfn + count;
-		     pfn += pageblock_nr_pages)
-			init_cma_reserved_pageblock(pfn_to_page(pfn));
+		     pfn += pageblock_nr_pages) {
+			if (fdt)
+				init_cma_pageblock(pfn_to_page(pfn));
+			else
+				init_cma_reserved_pageblock(pfn_to_page(pfn));
+		}
+	}
+
+	if (fdt) {
+		kho_in_debugfs_init(&kho_in.dbg, fdt);
+		return 0;
 	}
 
 	WARN_ON_ONCE(kho_debugfs_fdt_add(&kho_out.dbg, "fdt",
@@ -1435,35 +1439,10 @@ err_free_scratch:
 }
 fs_initcall(kho_init);
 
-static void __init kho_release_scratch(void)
-{
-	phys_addr_t start, end;
-	u64 i;
-
-	memmap_init_kho_scratch_pages();
-
-	/*
-	 * Mark scratch mem as CMA before we return it. That way we
-	 * ensure that no kernel allocations happen on it. That means
-	 * we can reuse it as scratch memory again later.
-	 */
-	__for_each_mem_range(i, &memblock.memory, NULL, NUMA_NO_NODE,
-			     MEMBLOCK_KHO_SCRATCH, &start, &end, NULL) {
-		ulong start_pfn = pageblock_start_pfn(PFN_DOWN(start));
-		ulong end_pfn = pageblock_align(PFN_UP(end));
-		ulong pfn;
-
-		for (pfn = start_pfn; pfn < end_pfn; pfn += pageblock_nr_pages)
-			init_pageblock_migratetype(pfn_to_page(pfn),
-						   MIGRATE_CMA, false);
-	}
-}
-
 void __init kho_memory_init(void)
 {
 	if (kho_in.scratch_phys) {
 		kho_scratch = phys_to_virt(kho_in.scratch_phys);
-		kho_release_scratch();
 
 		if (kho_mem_retrieve(kho_get_fdt()))
 			kho_in.fdt_phys = 0;
--- a/mm/memblock.c~kho-fix-deferred-init-of-kho-scratch
+++ a/mm/memblock.c
@@ -959,28 +959,6 @@ __init void memblock_clear_kho_scratch_o
 {
 	kho_scratch_only = false;
 }
-
-__init void memmap_init_kho_scratch_pages(void)
-{
-	phys_addr_t start, end;
-	unsigned long pfn;
-	int nid;
-	u64 i;
-
-	if (!IS_ENABLED(CONFIG_DEFERRED_STRUCT_PAGE_INIT))
-		return;
-
-	/*
-	 * Initialize struct pages for free scratch memory.
-	 * The struct pages for reserved scratch memory will be set up in
-	 * reserve_bootmem_region()
-	 */
-	__for_each_mem_range(i, &memblock.memory, NULL, NUMA_NO_NODE,
-			     MEMBLOCK_KHO_SCRATCH, &start, &end, &nid) {
-		for (pfn = PFN_UP(start); pfn < PFN_DOWN(end); pfn++)
-			init_deferred_page(pfn, nid);
-	}
-}
 #endif
 
 /**
_

Patches currently in -mm which might be from mclapinski@google.com are

kho-fix-deferred-init-of-kho-scratch.patch

