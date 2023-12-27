Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DCC647F54
	for <mm-commits@vger.kernel.org>; Wed, 27 Dec 2023 20:41:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="IL0jo/qZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF8CFC433C7;
	Wed, 27 Dec 2023 20:41:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1703709679;
	bh=QsqVBbzciW5ejBsI3vY+7o+5BbSXgR9rH1q/QkDppzs=;
	h=Date:To:From:Subject:From;
	b=IL0jo/qZoSFTKWGag0wcJxIFYbPi1kvEJtAgP/5midTyFIK1fN8LCtG+Gt7lnw+im
	 BxjDgm1t8TvwC1KxuMwzYoxhd5kvhOwB9QR0q0lyosHUp+gjrADgc6DtOQTmrICOE3
	 jyj/3J1YWHUp7iVuKEM5zU58/0UDrPUA9teUkDuE=
Date: Wed, 27 Dec 2023 12:41:18 -0800
To: mm-commits@vger.kernel.org,yuzhao@google.com,lkp@intel.com,donettom@linux.vnet.ibm.com,aneesh.kumar@linux.ibm.com,kinseyho@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mglru-add-config_arch_has_hw_pte_young.patch added to mm-unstable branch
Message-Id: <20231227204118.EF8CFC433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/mglru: add CONFIG_ARCH_HAS_HW_PTE_YOUNG
has been added to the -mm mm-unstable branch.  Its filename is
     mm-mglru-add-config_arch_has_hw_pte_young.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mglru-add-config_arch_has_hw_pte_young.patch

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
From: Kinsey Ho <kinseyho@google.com>
Subject: mm/mglru: add CONFIG_ARCH_HAS_HW_PTE_YOUNG
Date: Wed, 27 Dec 2023 14:12:01 +0000

Patch series "mm/mglru: Kconfig cleanup", v4.

This series is the result of the following discussion:
https://lore.kernel.org/47066176-bd93-55dd-c2fa-002299d9e034@linux.ibm.com/

It mainly avoids building the code that walks page tables on CPUs that
use it, i.e., those don't support hardware accessed bit. Specifically,
it introduces a new Kconfig to guard some of functions added by
commit bd74fdaea146 ("mm: multi-gen LRU: support page table walks")
on CPUs like POWER9, on which the series was tested.


This patch (of 5):

Some architectures are able to set the accessed bit in PTEs when PTEs
are used as part of linear address translations.

Add CONFIG_ARCH_HAS_HW_PTE_YOUNG for such architectures to be able to
override arch_has_hw_pte_young().

Link: https://lkml.kernel.org/r/20231227141205.2200125-1-kinseyho@google.com
Link: https://lkml.kernel.org/r/20231227141205.2200125-2-kinseyho@google.com
Signed-off-by: Kinsey Ho <kinseyho@google.com>
Co-developed-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Tested-by: Donet Tom <donettom@linux.vnet.ibm.com>
Acked-by: Yu Zhao <yuzhao@google.com>
Cc: kernel test robot <lkp@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/Kconfig                   |    8 ++++++++
 arch/arm64/Kconfig             |    1 +
 arch/x86/Kconfig               |    1 +
 arch/x86/include/asm/pgtable.h |    6 ------
 include/linux/pgtable.h        |    2 +-
 5 files changed, 11 insertions(+), 7 deletions(-)

--- a/arch/arm64/Kconfig~mm-mglru-add-config_arch_has_hw_pte_young
+++ a/arch/arm64/Kconfig
@@ -36,6 +36,7 @@ config ARM64
 	select ARCH_HAS_NON_OVERLAPPING_ADDRESS_SPACE
 	select ARCH_HAS_PTE_DEVMAP
 	select ARCH_HAS_PTE_SPECIAL
+	select ARCH_HAS_HW_PTE_YOUNG
 	select ARCH_HAS_SETUP_DMA_OPS
 	select ARCH_HAS_SET_DIRECT_MAP
 	select ARCH_HAS_SET_MEMORY
--- a/arch/Kconfig~mm-mglru-add-config_arch_has_hw_pte_young
+++ a/arch/Kconfig
@@ -1470,6 +1470,14 @@ config DYNAMIC_SIGFRAME
 config HAVE_ARCH_NODE_DEV_GROUP
 	bool
 
+config ARCH_HAS_HW_PTE_YOUNG
+	bool
+	help
+	  Architectures that select this option are capable of setting the
+	  accessed bit in PTE entries when using them as part of linear address
+	  translations. Architectures that require runtime check should select
+	  this option and override arch_has_hw_pte_young().
+
 config ARCH_HAS_NONLEAF_PMD_YOUNG
 	bool
 	help
--- a/arch/x86/include/asm/pgtable.h~mm-mglru-add-config_arch_has_hw_pte_young
+++ a/arch/x86/include/asm/pgtable.h
@@ -1679,12 +1679,6 @@ static inline bool arch_has_pfn_modify_c
 	return boot_cpu_has_bug(X86_BUG_L1TF);
 }
 
-#define arch_has_hw_pte_young arch_has_hw_pte_young
-static inline bool arch_has_hw_pte_young(void)
-{
-	return true;
-}
-
 #define arch_check_zapped_pte arch_check_zapped_pte
 void arch_check_zapped_pte(struct vm_area_struct *vma, pte_t pte);
 
--- a/arch/x86/Kconfig~mm-mglru-add-config_arch_has_hw_pte_young
+++ a/arch/x86/Kconfig
@@ -88,6 +88,7 @@ config X86
 	select ARCH_HAS_PMEM_API		if X86_64
 	select ARCH_HAS_PTE_DEVMAP		if X86_64
 	select ARCH_HAS_PTE_SPECIAL
+	select ARCH_HAS_HW_PTE_YOUNG
 	select ARCH_HAS_NONLEAF_PMD_YOUNG	if PGTABLE_LEVELS > 2
 	select ARCH_HAS_UACCESS_FLUSHCACHE	if X86_64
 	select ARCH_HAS_COPY_MC			if X86_64
--- a/include/linux/pgtable.h~mm-mglru-add-config_arch_has_hw_pte_young
+++ a/include/linux/pgtable.h
@@ -375,7 +375,7 @@ static inline bool arch_has_hw_nonleaf_p
  */
 static inline bool arch_has_hw_pte_young(void)
 {
-	return false;
+	return IS_ENABLED(CONFIG_ARCH_HAS_HW_PTE_YOUNG);
 }
 #endif
 
_

Patches currently in -mm which might be from kinseyho@google.com are

mm-mglru-add-config_arch_has_hw_pte_young.patch
mm-mglru-add-config_lru_gen_walks_mmu.patch
mm-mglru-remove-config_memcg.patch
mm-mglru-add-dummy-pmd_dirty.patch
mm-mglru-remove-config_transparent_hugepage.patch

