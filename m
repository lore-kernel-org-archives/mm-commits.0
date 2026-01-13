Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5C423595D
	for <mm-commits@vger.kernel.org>; Tue, 13 Jan 2026 05:09:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768280974; cv=none; b=nOomEYic9xoi0cZdaq56ybJW35A+jyEpb+qcukjUDoeNQg7Ugs/NKlcB8SywyaWNLXka833wIVAwNsN0smRfMFx0XfpqoZkyA9NCg9DUipDMr1GuY8en/Gx/nRWFSzTKwEIlOBYHcfpqm/7JFYROXYzacstVC8Bg1aJ70n2gkCQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768280974; c=relaxed/simple;
	bh=4NQ4q0W7eraUgHvKe5G7VhmOmRlmlTHu5WM1h+ncrz4=;
	h=Date:To:From:Subject:Message-Id; b=EWxTzwOQzqgW9Fla7P5f5piR+yD9DVXnKFAP2fHYkhVAy/V4tUkvm38iNrVS066srIECEv839TZ1sk2P8cjENj1BoPEQvkqf73V2HH5hED3SoIkDtRTYKC6DH9+HrwtSANnDee8B5i2XE2DCopygp9X2tigR4JBbu23tmB+2uFo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=0M/2ZtrB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="0M/2ZtrB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACA97C116C6;
	Tue, 13 Jan 2026 05:09:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768280974;
	bh=4NQ4q0W7eraUgHvKe5G7VhmOmRlmlTHu5WM1h+ncrz4=;
	h=Date:To:From:Subject:From;
	b=0M/2ZtrBC3EJcwv74fa/mJiIfd0OAUgyDPdsV9O9vze6HCkkq3W9H0RYuIMJea/gx
	 MTDt6F8hLUAto1FYezIAog0upL7AL2RB56btfVLwKYGmE+V0ajjcHH7fT8jdkm1SFL
	 JUpwWMTtkavF2fZ388tmHxnOxDRsfVAMC+J4Ed/4=
Date: Mon, 12 Jan 2026 21:09:34 -0800
To: mm-commits@vger.kernel.org,tsbogend@alpha.franken.de,tglx@linutronix.de,markus.stockhausen@gmx.de,jelonek.jonas@gmail.com,hauke@hauke-m.de,chris.packham@alliedtelesis.co.nz,rppt@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mips-fix-highmem-initialization.patch removed from -mm tree
Message-Id: <20260113050934.ACA97C116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mips: fix HIGHMEM initialization
has been removed from the -mm tree.  Its filename was
     mips-fix-highmem-initialization.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Subject: mips: fix HIGHMEM initialization
Date: Wed, 31 Dec 2025 12:57:01 +0200

Commit 6faea3422e3b ("arch, mm: streamline HIGHMEM freeing") overzealously
removed mem_init_free_highmem() function that beside freeing high memory
pages checked for CPU support for high memory as a prerequisite.

Partially restore mem_init_free_highmem() with a new highmem_init() name
and make it discard high memory in case there is no CPU support for it.

Link: https://lkml.kernel.org/r/20251231105701.519711-1-rppt@kernel.org
Fixes: 6faea3422e3b ("arch, mm: streamline HIGHMEM freeing")
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reported-by: Markus Stockhausen <markus.stockhausen@gmx.de>
Cc: Chris Packham <chris.packham@alliedtelesis.co.nz>
Cc: Hauke Mehrtens <hauke@hauke-m.de>
Cc: Jonas Jelonek <jelonek.jonas@gmail.com>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: Thomas Gleinxer <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mips/mm/init.c |   23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

--- a/arch/mips/mm/init.c~mips-fix-highmem-initialization
+++ a/arch/mips/mm/init.c
@@ -425,6 +425,28 @@ void __init paging_init(void)
 static struct kcore_list kcore_kseg0;
 #endif
 
+static inline void __init highmem_init(void)
+{
+#ifdef CONFIG_HIGHMEM
+	unsigned long tmp;
+
+	/*
+	 * If CPU cannot support HIGHMEM discard the memory above highstart_pfn
+	 */
+	if (cpu_has_dc_aliases) {
+		memblock_remove(PFN_PHYS(highstart_pfn), -1);
+		return;
+	}
+
+	for (tmp = highstart_pfn; tmp < highend_pfn; tmp++) {
+		struct page *page = pfn_to_page(tmp);
+
+		if (!memblock_is_memory(PFN_PHYS(tmp)))
+			SetPageReserved(page);
+	}
+#endif
+}
+
 void __init arch_mm_preinit(void)
 {
 	/*
@@ -435,6 +457,7 @@ void __init arch_mm_preinit(void)
 
 	maar_init();
 	setup_zero_pages();	/* Setup zeroed pages.  */
+	highmem_init();
 
 #ifdef CONFIG_64BIT
 	if ((unsigned long) &_text > (unsigned long) CKSEG0)
_

Patches currently in -mm which might be from rppt@kernel.org are

alpha-introduce-arch_zone_limits_init.patch
arc-introduce-arch_zone_limits_init.patch
arm-introduce-arch_zone_limits_init.patch
arm64-introduce-arch_zone_limits_init.patch
csky-introduce-arch_zone_limits_init.patch
hexagon-introduce-arch_zone_limits_init.patch
loongarch-introduce-arch_zone_limits_init.patch
m68k-introduce-arch_zone_limits_init.patch
microblaze-introduce-arch_zone_limits_init.patch
mips-introduce-arch_zone_limits_init.patch
nios2-introduce-arch_zone_limits_init.patch
openrisc-introduce-arch_zone_limits_init.patch
parisc-introduce-arch_zone_limits_init.patch
powerpc-introduce-arch_zone_limits_init.patch
riscv-introduce-arch_zone_limits_init.patch
s390-introduce-arch_zone_limits_init.patch
sh-introduce-arch_zone_limits_init.patch
sparc-introduce-arch_zone_limits_init.patch
um-introduce-arch_zone_limits_init.patch
x86-introduce-arch_zone_limits_init.patch
xtensa-introduce-arch_zone_limits_init.patch
arch-mm-consolidate-initialization-of-nodes-zones-and-memory-map.patch
arch-mm-consolidate-initialization-of-sparse-memory-model.patch
mips-drop-paging_init.patch
x86-dont-reserve-hugetlb-memory-in-setup_arch.patch
mm-arch-consolidate-hugetlb-cma-reservation.patch
mm-hugetlb-drop-hugetlb_cma_check.patch
revert-mm-hugetlb-deal-with-multiple-calls-to-hugetlb_bootmem_alloc.patch
kho-abi-luo-make-generated-documentation-more-coherent.patch
kho-abi-memfd-make-generated-documentation-more-coherent.patch
kho-docs-combine-concepts-and-fdt-documentation.patch
kho-docs-combine-concepts-and-fdt-documentation-fix.patch
kho-abi-add-memblock-abi-header.patch

