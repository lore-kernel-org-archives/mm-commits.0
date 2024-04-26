Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 946EB7604D
	for <mm-commits@vger.kernel.org>; Fri, 26 Apr 2024 04:00:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714104002; cv=none; b=BynUggvhvhq+SGNEMm7MxdW8ML07aLugBlB7D6gHG4aOqQ9al0he+nSDUPclP/DOHcAnTPF5PqJThdxvOWk5yEqBqttY8mhHmF8yq8+KwbzLrdWyglCyU4qNnG6aOT3mSCXZ3FaHkDa8fFwik0ayKapscV7ngN0cQCl5otbh3YA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714104002; c=relaxed/simple;
	bh=sa4qoglmIWO2BsOpfBfHu09DLGk9WVc3dDxrNa20PHY=;
	h=Date:To:From:Subject:Message-Id; b=BS3+r0SKPmxJ9vxwKoQWos8SWg3I2IQ0/5B5CJOI1O6fIPNKdMwYOjCXUjNzqyooC4SSbHPA72JGzCEPQjvzkHdfmqw90wWmhS9hVIs9pcb2XNjTh+1cPNpjd6yEo5qMAYvXOhNg+F5niV+Jt1ZqU7QYYagH5S/P26BjwHtp05Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=uzkKQBGf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="uzkKQBGf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A45AC116B1;
	Fri, 26 Apr 2024 04:00:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714104002;
	bh=sa4qoglmIWO2BsOpfBfHu09DLGk9WVc3dDxrNa20PHY=;
	h=Date:To:From:Subject:From;
	b=uzkKQBGfABAeTZlLEG4CuG6TN73QXXjcoBpSoO4LdCOQqaakSRZM2h7qeYPqV6eQ3
	 24i9AdEwUwzo0AuV1Sxpi7OotrGiqkiBdSf8el1GafVoSNSAtYNPpxRJ48sNFbkWXq
	 MiSAGJxgun4bvaedjdXmwKQsxCi/8D1jRH7ETkpo=
Date: Thu, 25 Apr 2024 21:00:01 -0700
To: mm-commits@vger.kernel.org,rppt@kernel.org,bhe@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-mm_initc-remove-arch_reserved_kernel_pages.patch removed from -mm tree
Message-Id: <20240426040002.6A45AC116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/mm_init.c: remove arch_reserved_kernel_pages()
has been removed from the -mm tree.  Its filename was
     mm-mm_initc-remove-arch_reserved_kernel_pages.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Baoquan He <bhe@redhat.com>
Subject: mm/mm_init.c: remove arch_reserved_kernel_pages()
Date: Mon, 25 Mar 2024 22:56:46 +0800

Since the current calculation of calc_nr_kernel_pages() has taken into
consideration of kernel reserved memory, no need to have
arch_reserved_kernel_pages() any more.

Link: https://lkml.kernel.org/r/20240325145646.1044760-7-bhe@redhat.com
Signed-off-by: Baoquan He <bhe@redhat.com>
Reviewed-by: Mike Rapoport (IBM) <rppt@kernel.org>
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
@@ -3261,9 +3261,6 @@ static inline void show_mem(void)
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

documentation-kdump-clean-up-the-outdated-description.patch
kexec-fix-the-unexpected-kexec_dprintk-macro.patch
crash-add-prefix-for-crash-dumping-messages.patch

