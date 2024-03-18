Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D37EC381C8
	for <mm-commits@vger.kernel.org>; Mon, 18 Mar 2024 18:53:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710788011; cv=none; b=EM+3o3gOX8iAJNl5CkEpM2HPMZQgBZgkvnJZ72eLoEXDzfOR5WEpYObgn0BeopkTZ3woBHFG3ehgmvrnM1AtjPYM0EAFt/ATEc19xcyyrhJiRRQQiyooVjFgq8l9A8qEyuExT9lhu+F9LVgjK3YwNXWw0LMDGfuyQZCR/UAkCF4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710788011; c=relaxed/simple;
	bh=YZIWu6eTeS3MzFrqchTQTdfXW93oaH0KWyDXC0UB2Ng=;
	h=Date:To:From:Subject:Message-Id; b=S0XIWYObDftVxX68fmo2K2Dx70HMCG9kkzXYIwfIQAJ5SZrAQx7hT6XhuziGRvnL4eeP4zMVvW4qykq86e3r6Lo7CsfJGZsaA1cRsdBfmyPGZO7ZKamfyHa4d7xcOm7xLPwORzPPxXmrq0So32ofYX0IuoTwoHdJXM77x/Bo1Xo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ilpzw5DS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ilpzw5DS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98B2EC433F1;
	Mon, 18 Mar 2024 18:53:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1710788011;
	bh=YZIWu6eTeS3MzFrqchTQTdfXW93oaH0KWyDXC0UB2Ng=;
	h=Date:To:From:Subject:From;
	b=ilpzw5DSIu197F3iVLwOothTGc1hj+TszaX8+VGas/+k1XSdrr6lMpRQuL5sGoIZg
	 us/7YhUlzM8Qo090w0oOBiptRE73E2LnxmkqyqBkSXajeaXDLxIrNNwr91sGytfn7S
	 9GfPyeae0wg5LXzNh8wTx/LNzivg5BX11VccD3Yc=
Date: Mon, 18 Mar 2024 11:53:31 -0700
To: mm-commits@vger.kernel.org,rppt@kernel.org,bhe@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mm_initc-remove-arch_reserved_kernel_pages.patch added to mm-unstable branch
Message-Id: <20240318185331.98B2EC433F1@smtp.kernel.org>
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
Date: Mon, 18 Mar 2024 22:21:38 +0800

Since the current calculation of calc_nr_kernel_pages() has taken into
consideration of kernel reserved memory, no need to have
arch_reserved_kernel_pages() any more.

Link: https://lkml.kernel.org/r/20240318142138.783350-7-bhe@redhat.com
Signed-off-by: Baoquan He <bhe@redhat.com>
Cc: Mike Rapoport (IBM) <rppt@kernel.org>
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
@@ -3221,9 +3221,6 @@ static inline void show_mem(void)
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
@@ -2383,17 +2383,6 @@ void __init page_alloc_init_late(void)
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
@@ -2436,7 +2425,6 @@ void *__init alloc_large_system_hash(con
 	if (!numentries) {
 		/* round applicable memory size up to nearest megabyte */
 		numentries = nr_kernel_pages;
-		numentries -= arch_reserved_kernel_pages();
 
 		/* It isn't necessary when PAGE_SIZE >= 1MB */
 		if (PAGE_SIZE < SZ_1M)
_

Patches currently in -mm which might be from bhe@redhat.com are

mm-mm_initc-remove-the-useless-dma_reserve.patch
x86-remove-memblock_find_dma_reserve.patch
mm-mm_initc-add-new-function-calc_nr_kernel_pages.patch
mm-mm_initc-remove-meaningless-calculation-of-zone-managed_pages-in-free_area_init_core.patch
mm-mm_initc-remove-unneeded-calc_memmap_size.patch
mm-mm_initc-remove-arch_reserved_kernel_pages.patch

