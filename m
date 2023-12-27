Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3B4547F54
	for <mm-commits@vger.kernel.org>; Wed, 27 Dec 2023 20:41:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="B9TdFHsn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 719DEC433C7;
	Wed, 27 Dec 2023 20:41:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1703709683;
	bh=e4gVlg5eZ8SP0QC8cZgGyeL+8e7xBQoYF+W4BObDhI8=;
	h=Date:To:From:Subject:From;
	b=B9TdFHsn2Ljtc5/etRcCup43iwDrQRSs0QTpUOoQEUeG7KSWsJ0uUuyFzD1VnuGVo
	 CsuLN7IGgTfDA/bQBBzCTFIR+Qx9Z3MTwdksQUjXsPYEVOKsopURZyM5mJ+l7EkF93
	 VcNXjREcFfbzk1cpQEYVJc7MzrjGMDta+ewsFqTc=
Date: Wed, 27 Dec 2023 12:41:22 -0800
To: mm-commits@vger.kernel.org,yuzhao@google.com,lkp@intel.com,donettom@linux.vnet.ibm.com,aneesh.kumar@linux.ibm.com,kinseyho@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mglru-add-dummy-pmd_dirty.patch added to mm-unstable branch
Message-Id: <20231227204123.719DEC433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/mglru: add dummy pmd_dirty()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-mglru-add-dummy-pmd_dirty.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mglru-add-dummy-pmd_dirty.patch

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
Subject: mm/mglru: add dummy pmd_dirty()
Date: Wed, 27 Dec 2023 14:12:04 +0000

Add dummy pmd_dirty() for architectures that don't provide it.
This is similar to commit 6617da8fb565 ("mm: add dummy pmd_young()
for architectures not having it").

Link: https://lkml.kernel.org/r/20231227141205.2200125-5-kinseyho@google.com
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202312210606.1Etqz3M4-lkp@intel.com/
Closes: https://lore.kernel.org/oe-kbuild-all/202312210042.xQEiqlEh-lkp@intel.com/
Signed-off-by: Kinsey Ho <kinseyho@google.com>
Suggested-by: Yu Zhao <yuzhao@google.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Cc: Donet Tom <donettom@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/loongarch/include/asm/pgtable.h |    1 +
 arch/mips/include/asm/pgtable.h      |    1 +
 arch/riscv/include/asm/pgtable.h     |    1 +
 arch/s390/include/asm/pgtable.h      |    1 +
 arch/sparc/include/asm/pgtable_64.h  |    1 +
 arch/x86/include/asm/pgtable.h       |    1 +
 include/linux/pgtable.h              |    7 +++++++
 7 files changed, 13 insertions(+)

--- a/arch/loongarch/include/asm/pgtable.h~mm-mglru-add-dummy-pmd_dirty
+++ a/arch/loongarch/include/asm/pgtable.h
@@ -523,6 +523,7 @@ static inline pmd_t pmd_wrprotect(pmd_t
 	return pmd;
 }
 
+#define pmd_dirty pmd_dirty
 static inline int pmd_dirty(pmd_t pmd)
 {
 	return !!(pmd_val(pmd) & (_PAGE_DIRTY | _PAGE_MODIFIED));
--- a/arch/mips/include/asm/pgtable.h~mm-mglru-add-dummy-pmd_dirty
+++ a/arch/mips/include/asm/pgtable.h
@@ -655,6 +655,7 @@ static inline pmd_t pmd_mkwrite_novma(pm
 	return pmd;
 }
 
+#define pmd_dirty pmd_dirty
 static inline int pmd_dirty(pmd_t pmd)
 {
 	return !!(pmd_val(pmd) & _PAGE_MODIFIED);
--- a/arch/riscv/include/asm/pgtable.h~mm-mglru-add-dummy-pmd_dirty
+++ a/arch/riscv/include/asm/pgtable.h
@@ -673,6 +673,7 @@ static inline int pmd_write(pmd_t pmd)
 	return pte_write(pmd_pte(pmd));
 }
 
+#define pmd_dirty pmd_dirty
 static inline int pmd_dirty(pmd_t pmd)
 {
 	return pte_dirty(pmd_pte(pmd));
--- a/arch/s390/include/asm/pgtable.h~mm-mglru-add-dummy-pmd_dirty
+++ a/arch/s390/include/asm/pgtable.h
@@ -770,6 +770,7 @@ static inline int pud_write(pud_t pud)
 	return (pud_val(pud) & _REGION3_ENTRY_WRITE) != 0;
 }
 
+#define pmd_dirty pmd_dirty
 static inline int pmd_dirty(pmd_t pmd)
 {
 	return (pmd_val(pmd) & _SEGMENT_ENTRY_DIRTY) != 0;
--- a/arch/sparc/include/asm/pgtable_64.h~mm-mglru-add-dummy-pmd_dirty
+++ a/arch/sparc/include/asm/pgtable_64.h
@@ -706,6 +706,7 @@ static inline unsigned long pmd_write(pm
 #define pud_write(pud)	pte_write(__pte(pud_val(pud)))
 
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
+#define pmd_dirty pmd_dirty
 static inline unsigned long pmd_dirty(pmd_t pmd)
 {
 	pte_t pte = __pte(pmd_val(pmd));
--- a/arch/x86/include/asm/pgtable.h~mm-mglru-add-dummy-pmd_dirty
+++ a/arch/x86/include/asm/pgtable.h
@@ -141,6 +141,7 @@ static inline int pte_young(pte_t pte)
 	return pte_flags(pte) & _PAGE_ACCESSED;
 }
 
+#define pmd_dirty pmd_dirty
 static inline bool pmd_dirty(pmd_t pmd)
 {
 	return pmd_flags(pmd) & _PAGE_DIRTY_BITS;
--- a/include/linux/pgtable.h~mm-mglru-add-dummy-pmd_dirty
+++ a/include/linux/pgtable.h
@@ -184,6 +184,13 @@ static inline int pmd_young(pmd_t pmd)
 }
 #endif
 
+#ifndef pmd_dirty
+static inline int pmd_dirty(pmd_t pmd)
+{
+	return 0;
+}
+#endif
+
 /*
  * A facility to provide lazy MMU batching.  This allows PTE updates and
  * page invalidations to be delayed until a call to leave lazy MMU mode
_

Patches currently in -mm which might be from kinseyho@google.com are

mm-mglru-add-config_arch_has_hw_pte_young.patch
mm-mglru-add-config_lru_gen_walks_mmu.patch
mm-mglru-remove-config_memcg.patch
mm-mglru-add-dummy-pmd_dirty.patch
mm-mglru-remove-config_transparent_hugepage.patch

