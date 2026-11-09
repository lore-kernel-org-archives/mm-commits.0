Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794207839;
	b=JFJGfmYrEcqo+SmLK3aNnveEVXuCAyBVus+4GcJRisEPdiC3/TfW7C1qQ0hVzqZwexOE
	 BgCaZdERocCROAWWMWKHKwwyOuRr/26sF6zv5LpQTFN3MLbQfRER+LO1V2ollTWhjmdOc
	 ipaBoBRezeW/w3dhil6qaPdHYhd0/WFmmRohiWv9+Lhgdy5NvllOE47euJWa3qAcEPqI1
	 JY9d5whH5fqpkeCCYq2V80rguvP7LbkhqeXD8tnaob/PNEPKbvnDBQGuMBDKlpdXqJ9mg
	 iK5uAh6uye8/Fr8q3HU8Fg6mESQuglbwK+loZbl9geAX+YdoRSFfrCgprsnf4nqbuYg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794207839;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=eVkJY437LeurHNM3t6S+iPH96RXg+ZldzF7l4zXUF3U=;
	b=0pOfvTRGG0Rl/Df3MT4+hJ302XwEqJa+QAPlL3RWfNrKunJ6yWb0VtNurJjKB7oJj3qn
	 9SATym6L1cFOCRE8GbWNpYru5bcFcVAssjZPAN7pY3vjngJvif30ZjSakKyim1dXdDv0u
	 SSaMEtcglMJ2kb5famc/NWljIVJVZYwVXSC7ODDL+ul3j9q441bsjV+mRpZ6KR4nytIzm
	 pnOiZi1DzZNKtcluFPGZ4A8ALQKuIclyWzAzsGorJxXMquZ5429Kon67g+DxUtd2OKDP3
	 uKHb1N3cdhS5yjAlAR7ivA1oLd0rxS0O6r0+7yCGi/Gn3myKvBqvyHszGi0yaPnecRA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=X8Qmxs07;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C19F7606A31C
	for <mm-commits@vger.kernel.org>; Mon,  9 Nov 2026 07:03:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=X8Qmxs07
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AFC51F0089F;
	Mon,  9 Nov 2026 07:03:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794207838;
	bh=eVkJY437LeurHNM3t6S+iPH96RXg+ZldzF7l4zXUF3U=;
	h=Date:To:From:Subject;
	b=X8Qmxs07Y+77oLvNkVBo3iQDo463vlM2ufOz+UhSZEzzq2NUARMzeZwh5PbqM9ad5
	 BwbCX3Y6LDfHpncY3FDG49qxDQXd7LXw6qB4sxTMAVvSHsktm7iTSkPHgMEWHXN81o
	 Q5F4mEqq0uhZIxx6/f5R8cU+wV2ej99ZMMyw8XsQ=
Date: Sun, 08 Nov 2026 23:03:57 -0800
To: mm-commits@vger.kernel.org,xueyuan.chen21@gmail.com,will@kernel.org,
	urezki@gmail.com,ryan.roberts@arm.com,rppt@kernel.org,npiggin@gmail.com,
	mpe@ellerman.id.au,maddy@linux.ibm.com,leo.yan@arm.com,
	jiangwenxiaomi@gmail.com,dev.jain@arm.com,david@kernel.org,
	chleroy@kernel.org,catalin.marinas@arm.com,baohua@kernel.org,
	anshuman.khandual@arm.com,andrew+kernel@donnellan.id.au,jiangwen6@xiaomi.com,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + powerpc-8xx-add-vmap_pte_set_huge.patch added to mm-new branch
Message-Id: <20261109070358.4AFC51F0089F@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: powerpc/8xx: add vmap_pte_set_huge()
has been added to the -mm mm-new branch.  Its filename is
     powerpc-8xx-add-vmap_pte_set_huge.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/powerpc-8xx-add-vmap_pte_set_huge.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

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
From: Wen Jiang <jiangwen6@xiaomi.com>
Subject: powerpc/8xx: add vmap_pte_set_huge()
Date: Sat, 07 Nov 2026 21:49:45 +0800

vmap installs PTE-level block mappings (SZ_16K/SZ_512K on powerpc/8xx)
by reusing set_huge_pte_at(), a HugeTLB helper gated by
CONFIG_HUGETLB_PAGE. This makes the feature silently unavailable on
CONFIG_HUGETLB_PAGE=n kernels and couples mm/vmalloc.c to HugeTLB
internals it does not otherwise need.

Add vmap_pte_set_huge() to powerpc/8xx, next to the existing
pmd_clear_huge()/pud_clear_huge() in mm/nohash/8xx.c. It builds the huge
PTE and writes it into the backing cells directly, without going through
set_huge_pte_at(), so it does not depend on CONFIG_HUGETLB_PAGE.

No vmap_pte_clear_huge() is needed: 8xx does not implement
arch_vmap_pte_range_unmap_size(), so the vmap unmap path never takes the
PTE-clearing branch.

In practice PPC_8xx selects HUGETLBFS unconditionally, so
CONFIG_HUGETLB_PAGE=n does not occur there today; this is a decoupling
cleanup rather than a new configuration.

There is no caller yet: mm/vmalloc.c is converted later in this series,
once the generic fallbacks are in place.

Link: https://lore.kernel.org/20261107134953.748622-3-jiangwenxiaomi@gmail.com
Signed-off-by: Wen Jiang <jiangwen6@xiaomi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Christophe Leroy (CS GROUP) <chleroy@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Uladzislau Rezki (Sony) <urezki@gmail.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: <leo.yan@arm.com>
Cc: Xueyuan Chen <xueyuan.chen21@gmail.com>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Andrew Donnellan <andrew+kernel@donnellan.id.au>
Cc: Wen Jiang <jiangwenxiaomi@gmail.com>
---

 arch/powerpc/include/asm/nohash/32/pte-8xx.h |    4 ++
 arch/powerpc/mm/nohash/8xx.c                 |   29 +++++++++++++++++
 2 files changed, 33 insertions(+)

--- a/arch/powerpc/include/asm/nohash/32/pte-8xx.h~powerpc-8xx-add-vmap_pte_set_huge
+++ a/arch/powerpc/include/asm/nohash/32/pte-8xx.h
@@ -235,6 +235,10 @@ static inline pte_t ptep_get(pte_t *ptep
 }
 #endif /* CONFIG_PPC_16K_PAGES */
 
+#define __HAVE_ARCH_VMAP_PTE_SET_HUGE
+void vmap_pte_set_huge(pte_t *ptep, unsigned long addr, phys_addr_t phys,
+		       pgprot_t prot, unsigned long size);
+
 #endif
 
 #endif /* __KERNEL__ */
--- a/arch/powerpc/mm/nohash/8xx.c~powerpc-8xx-add-vmap_pte_set_huge
+++ a/arch/powerpc/mm/nohash/8xx.c
@@ -220,3 +220,32 @@ int pmd_clear_huge(pmd_t *pmd)
 {
 	 return 0;
 }
+
+/*
+ * vmap PTE-level block mapping. Sets a present kernel mapping directly,
+ * so unlike set_huge_pte_at() it needs neither CONFIG_HUGETLB_PAGE nor
+ * set_pte_filter() (a no-op for non-exec kernel mappings).
+ */
+void vmap_pte_set_huge(pte_t *ptep, unsigned long addr, phys_addr_t phys,
+		       pgprot_t prot, unsigned long size)
+{
+	pmd_t *pmdp = pmd_off(&init_mm, addr);
+	pte_t pte = pfn_pte(PHYS_PFN(phys), prot);
+	pte_basic_t val;
+	pte_basic_t *entry = (pte_basic_t *)ptep;
+	int num, i;
+
+	pte = arch_make_huge_pte(pte, ilog2(size), 0);
+	val = pte_val(pte);
+
+	/*
+	 * Make sure hardware valid bit is not set. We don't do
+	 * tlb flush for this update.
+	 */
+	VM_WARN_ON(pte_hw_valid(*ptep) && !pte_protnone(*ptep));
+
+	num = number_of_cells_per_pte(pmdp, val, 1);
+
+	for (i = 0; i < num; i++, entry++, val += SZ_4K)
+		*entry = val;
+}
_

Patches currently in -mm which might be from jiangwen6@xiaomi.com are

arm64-mm-add-vmap_pte_set_huge-and-vmap_pte_clear_huge.patch
powerpc-8xx-add-vmap_pte_set_huge.patch
mm-vmalloc-use-vmap_pte_set_huge-vmap_pte_clear_huge-for-pte-level-block-mappings.patch
arm64-hugetlb-drop-the-init_mm-special-case-in-clear_flush.patch
mm-vmalloc-extract-vmap_set_ptes-to-consolidate-pte-mapping-logic.patch
mm-vmalloc-extract-vm_shift-to-consolidate-mapping-shift-selection.patch

