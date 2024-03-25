Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC4F57492
	for <mm-commits@vger.kernel.org>; Mon, 25 Mar 2024 18:11:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711390280; cv=none; b=bsXrFApygohv491l4iSMdKt0jozkWbuhP0cmBfccnQzh8NYuKIBKHsTJilQw63fHLsoba0zcR/eYFZAT1LKKuN5NaVWbsTLvj7kOjXq2PC+Rr8gLIMgyVHGZhIW+XgZyYXxizIxaJxKgGmdZii494jEBHW5Yj0tpc+vU2cywG/Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711390280; c=relaxed/simple;
	bh=qphFlwfZeLAJGaemYvX1PHhiUPf37H+wH1mk47feMAM=;
	h=Date:To:From:Subject:Message-Id; b=Ed/nRAn/S0t6cnHpuydWz1QFpeGkTbLhQQMNNIvyECb4MMXKK0C7icgjCzIDQqkIvO8NYc6T1RRocE9FI64coDu2QB40DR2/KhIwNc7UEjQAZMQLk3g5m0EDqKG2a0X8ca8r1B8VH/wR5mBJvWr5VAcNlKcDFvJ8+LIkgJaGIUk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=iPY3IqQV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="iPY3IqQV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35DCDC43390;
	Mon, 25 Mar 2024 18:11:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1711390280;
	bh=qphFlwfZeLAJGaemYvX1PHhiUPf37H+wH1mk47feMAM=;
	h=Date:To:From:Subject:From;
	b=iPY3IqQVNbzITer3VRFOtxUgtCEH82u0P9BoLh0d1J2Q/bTBVn2z+j/d+eaeD6KdJ
	 4NI9Eik5q4oZO+SsViTB5kUzOT9Dvy7JwtXpMwrn+e5fDCNkexC/kQx3h4Ukm0buoX
	 OI4YnqB9byufQXvybMOyHrnniJgb1/YldrU5/3QE=
Date: Mon, 25 Mar 2024 11:11:19 -0700
To: mm-commits@vger.kernel.org,rppt@kernel.org,bhe@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mm_initc-remove-arch_reserved_kernel_pages.patch added to mm-unstable branch
Message-Id: <20240325181120.35DCDC43390@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/mm_init.c: remove arch_reserved_kernel_pages()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-mm_initc-remove-arch_reserved_kernel_pages.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mm_initc-remove-arch_reserved_kernel_pages.patch

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
From: Baoquan He <bhe@redhat.com>
Subject: mm/mm_init.c: remove arch_reserved_kernel_pages()
Date: Mon, 25 Mar 2024 22:56:46 +0800

Since the current calculation of calc_nr_kernel_pages() has taken into
consideration of kernel reserved memory, no need to have
arch_reserved_kernel_pages() any more.

Link: https://lkml.kernel.org/r/20240325145646.1044760-7-bhe@redhat.com
Signed-off-by: Baoquan He <bhe@redhat.com>
Cc: "Mike Rapoport (IBM)" <rppt@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/include/asm/mmu.h |    4 ----
 arch/powerpc/kernel/fadump.c   |    5 -----
 include/linux/mm.h             |    3 ---
 mm/mm_init.c                   |   12 ------------
 4 files changed, 24 deletions(-)

--- a/arch/powerpc/include/asm/mmu.h~mm-mm_initc-remove-arch_reserved_kernel_pages
+++ a/arch/powerpc/include/asm/mmu.h
@@ -406,9 +406,5 @@ extern void *abatron_pteptrs[2];
 #include <asm/nohash/mmu.h>
 #endif
 
-#if defined(CONFIG_FA_DUMP) || defined(CONFIG_PRESERVE_FA_DUMP)
-#define __HAVE_ARCH_RESERVED_KERNEL_PAGES
-#endif
-
 #endif /* __KERNEL__ */
 #endif /* _ASM_POWERPC_MMU_H_ */
--- a/arch/powerpc/kernel/fadump.c~mm-mm_initc-remove-arch_reserved_kernel_pages
+++ a/arch/powerpc/kernel/fadump.c
@@ -1735,8 +1735,3 @@ static void __init fadump_reserve_crash_
 		memblock_reserve(mstart, msize);
 	}
 }
-
-unsigned long __init arch_reserved_kernel_pages(void)
-{
-	return memblock_reserved_size() / PAGE_SIZE;
-}
--- a/include/linux/mm.h~mm-mm_initc-remove-arch_reserved_kernel_pages
+++ a/include/linux/mm.h
@@ -3258,9 +3258,6 @@ static inline void show_mem(void)
 extern long si_mem_available(void);
 extern void si_meminfo(struct sysinfo * val);
 extern void si_meminfo_node(struct sysinfo *val, int nid);
-#ifdef __HAVE_ARCH_RESERVED_KERNEL_PAGES
-extern unsigned long arch_reserved_kernel_pages(void);
-#endif
 
 extern __printf(3, 4)
 void warn_alloc(gfp_t gfp_mask, nodemask_t *nodemask, const char *fmt, ...);
--- a/mm/mm_init.c~mm-mm_initc-remove-arch_reserved_kernel_pages
+++ a/mm/mm_init.c
@@ -2374,17 +2374,6 @@ void __init page_alloc_init_late(void)
 	page_alloc_sysctl_init();
 }
 
-#ifndef __HAVE_ARCH_RESERVED_KERNEL_PAGES
-/*
- * Returns the number of pages that arch has reserved but
- * is not known to alloc_large_system_hash().
- */
-static unsigned long __init arch_reserved_kernel_pages(void)
-{
-	return 0;
-}
-#endif
-
 /*
  * Adaptive scale is meant to reduce sizes of hash tables on large memory
  * machines. As memory size is increased the scale is also increased but at
@@ -2427,7 +2416,6 @@ void *__init alloc_large_system_hash(con
 	if (!numentries) {
 		/* round applicable memory size up to nearest megabyte */
 		numentries = nr_kernel_pages;
-		numentries -= arch_reserved_kernel_pages();
 
 		/* It isn't necessary when PAGE_SIZE >= 1MB */
 		if (PAGE_SIZE < SZ_1M)
_

Patches currently in -mm which might be from bhe@redhat.com are

mm-vmallocc-optimize-to-reduce-arguments-of-alloc_vmap_area.patch
x86-remove-unneeded-memblock_find_dma_reserve.patch
mm-mm_initc-remove-the-useless-dma_reserve.patch
mm-mm_initc-add-new-function-calc_nr_all_pages.patch
mm-mm_initc-remove-meaningless-calculation-of-zone-managed_pages-in-free_area_init_core.patch
mm-mm_initc-remove-unneeded-calc_memmap_size.patch
mm-mm_initc-remove-arch_reserved_kernel_pages.patch

