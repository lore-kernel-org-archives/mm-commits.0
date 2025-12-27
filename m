Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE33319F115
	for <mm-commits@vger.kernel.org>; Thu,  1 Jan 2026 01:49:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767232185; cv=none; b=BA6lmdSXinYA0gw23TS7kPm+gLiNNRMgkzlJ1V8CHOMVNmWbmzYcRs9w8G1SvQI1dOyZzSYkXW2EakPgc2e6szTQ6vQh4qHRIa9D6fIVaz0c1q+pcerFX6xNagjs51tAqwXi7uoCRsjSe6Rk3HvuseQzdQbQsv/HWzQx5h4ayO4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767232185; c=relaxed/simple;
	bh=zNCVAN4s+vSXLZ8UhI7JETY+BXZUulZ0qh0bk3ELqHw=;
	h=Date:To:From:Subject:Message-Id; b=XyYI/pcnb619UQvPymgW44ILfiSPqVdnNpaDEnOrrd3Mp0suNMnuVT3Oyso+y8ArOxmYTcbZAwKfUC0xSga+LD50cqS7y11hklKdAuM72zUDVdd2lyctESMnnIzWhk3royEItSv4yvkZA0TSoh3p0BJlPlCkbGQ/Y9YAZPRuXjA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=b9YkSXHP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="b9YkSXHP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FF4FC113D0;
	Thu,  1 Jan 2026 01:49:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1767232184;
	bh=zNCVAN4s+vSXLZ8UhI7JETY+BXZUulZ0qh0bk3ELqHw=;
	h=Date:To:From:Subject:From;
	b=b9YkSXHPf3CzGtdM3RbBpAolDwuVz+ye+6nzOKezI7XPyOK5k9X6j7gPCh7/EUXtC
	 lMQ92T9fnVy9r/Hf4Ivgg1lvzenVYGcPF3FhI/9VCZaqfWqvqYnzizFnW2Ha6DdA7D
	 3x9LIXoLvk7PxEsBY1fgXzO3grQ35WFfGYPZytOY=
Date: Wed, 31 Dec 2025 17:49:43 +9900
To: mm-commits@vger.kernel.org,tsbogend@alpha.franken.de,tglx@linutronix.de,markus.stockhausen@gmx.de,jelonek.jonas@gmail.com,hauke@hauke-m.de,chris.packham@alliedtelesis.co.nz,rppt@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mips-fix-highmem-initialization.patch added to mm-hotfixes-unstable branch
Message-Id: <20260101014944.3FF4FC113D0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mips: fix HIGHMEM initialization
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mips-fix-highmem-initialization.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mips-fix-highmem-initialization.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

mips-fix-highmem-initialization.patch
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

