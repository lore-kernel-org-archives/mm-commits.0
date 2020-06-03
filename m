From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 069/131] hugetlbfs: add arch_hugetlb_valid_size
Date: Wed, 03 Jun 2020 16:00:34 -0700
Message-ID: <20200603230034.71SYLN5lu%akpm@linux-foundation.org>
References: <20200603155549.e041363450869eaae4c7f05b@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:42852 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725821AbgFCXAh (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 3 Jun 2020 19:00:37 -0400
In-Reply-To: <20200603155549.e041363450869eaae4c7f05b@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, almasrymina@google.com, anders.roxell@linaro.org, aneesh.kumar@linux.ibm.com, aou@eecs.berkeley.edu, benh@kernel.crashing.org, borntraeger@de.ibm.com, cai@lca.pw, catalin.marinas@arm.com, christophe.leroy@c-s.fr, corbet@lwn.net, dave.hansen@linux.intel.com, davem@davemloft.net, gerald.schaefer@de.ibm.com, gor@linux.ibm.com, heiko.carstens@de.ibm.com, linux-mm@kvack.org, longpeng2@huawei.com, mike.kravetz@oracle.com, mingo@redhat.com, mm-commits@vger.kernel.org, nitesh@redhat.com, palmer@dabbelt.com, paul.walmsley@sifive.com, paulus@samba.org, peterx@redhat.com, rdunlap@infradead.org, sfr@canb.auug.org.au, tglx@linutronix.de, torvalds@linux-foundation.org, will@kernel.org

From: Mike Kravetz <mike.kravetz@oracle.com>
Subject: hugetlbfs: add arch_hugetlb_valid_size

Patch series "Clean up hugetlb boot command line processing", v4.

Longpeng(Mike) reported a weird message from hugetlb command line
processing and proposed a solution [1].  While the proposed patch does
address the specific issue, there are other related issues in command line
processing.  As hugetlbfs evolved, updates to command line processing have
been made to meet immediate needs and not necessarily in a coordinated
manner.  The result is that some processing is done in arch specific code,
some is done in arch independent code and coordination is problematic. 
Semantics can vary between architectures.

The patch series does the following:
- Define arch specific arch_hugetlb_valid_size routine used to validate
  passed huge page sizes.
- Move hugepagesz= command line parsing out of arch specific code and into
  an arch independent routine.
- Clean up command line processing to follow desired semantics and
  document those semantics.

[1] https://lore.kernel.org/linux-mm/20200305033014.1152-1-longpeng2@huawei.com


This patch (of 3):

The architecture independent routine hugetlb_default_setup sets up the
default huge pages size.  It has no way to verify if the passed value is
valid, so it accepts it and attempts to validate at a later time.  This
requires undocumented cooperation between the arch specific and arch
independent code.

For architectures that support more than one huge page size, provide a
routine arch_hugetlb_valid_size to validate a huge page size. 
hugetlb_default_setup can use this to validate passed values.

arch_hugetlb_valid_size will also be used in a subsequent patch to move
processing of the "hugepagesz=" in arch specific code to a common routine
in arch independent code.

Link: http://lkml.kernel.org/r/20200428205614.246260-1-mike.kravetz@oracle.com
Link: http://lkml.kernel.org/r/20200428205614.246260-2-mike.kravetz@oracle.com
Link: http://lkml.kernel.org/r/20200417185049.275845-1-mike.kravetz@oracle.com
Link: http://lkml.kernel.org/r/20200417185049.275845-2-mike.kravetz@oracle.com
Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>
Acked-by: Gerald Schaefer <gerald.schaefer@de.ibm.com>	[s390]
Acked-by: Will Deacon <will@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Paul Walmsley <paul.walmsley@sifive.com>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Longpeng <longpeng2@huawei.com>
Cc: Christophe Leroy <christophe.leroy@c-s.fr>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Mina Almasry <almasrymina@google.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Nitesh Narayan Lal <nitesh@redhat.com>
Cc: Anders Roxell <anders.roxell@linaro.org>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Cc: Qian Cai <cai@lca.pw>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/mm/hugetlbpage.c   |   17 +++++++++++++----
 arch/powerpc/mm/hugetlbpage.c |   20 +++++++++++++-------
 arch/riscv/mm/hugetlbpage.c   |   26 +++++++++++++++++---------
 arch/s390/mm/hugetlbpage.c    |   16 ++++++++++++----
 arch/sparc/mm/init_64.c       |   24 ++++++++++++++++--------
 arch/x86/mm/hugetlbpage.c     |   17 +++++++++++++----
 include/linux/hugetlb.h       |    1 +
 mm/hugetlb.c                  |   21 ++++++++++++++++++---
 8 files changed, 103 insertions(+), 39 deletions(-)

--- a/arch/arm64/mm/hugetlbpage.c~hugetlbfs-add-arch_hugetlb_valid_size
+++ a/arch/arm64/mm/hugetlbpage.c
@@ -464,17 +464,26 @@ static int __init hugetlbpage_init(void)
 }
 arch_initcall(hugetlbpage_init);
 
-static __init int setup_hugepagesz(char *opt)
+bool __init arch_hugetlb_valid_size(unsigned long size)
 {
-	unsigned long ps = memparse(opt, &opt);
-
-	switch (ps) {
+	switch (size) {
 #ifdef CONFIG_ARM64_4K_PAGES
 	case PUD_SIZE:
 #endif
 	case CONT_PMD_SIZE:
 	case PMD_SIZE:
 	case CONT_PTE_SIZE:
+		return true;
+	}
+
+	return false;
+}
+
+static __init int setup_hugepagesz(char *opt)
+{
+	unsigned long ps = memparse(opt, &opt);
+
+	if (arch_hugetlb_valid_size(ps)) {
 		add_huge_page_size(ps);
 		return 1;
 	}
--- a/arch/powerpc/mm/hugetlbpage.c~hugetlbfs-add-arch_hugetlb_valid_size
+++ a/arch/powerpc/mm/hugetlbpage.c
@@ -558,7 +558,7 @@ unsigned long vma_mmu_pagesize(struct vm
 	return vma_kernel_pagesize(vma);
 }
 
-static int __init add_huge_page_size(unsigned long long size)
+bool __init arch_hugetlb_valid_size(unsigned long size)
 {
 	int shift = __ffs(size);
 	int mmu_psize;
@@ -566,20 +566,26 @@ static int __init add_huge_page_size(uns
 	/* Check that it is a page size supported by the hardware and
 	 * that it fits within pagetable and slice limits. */
 	if (size <= PAGE_SIZE || !is_power_of_2(size))
-		return -EINVAL;
+		return false;
 
 	mmu_psize = check_and_get_huge_psize(shift);
 	if (mmu_psize < 0)
-		return -EINVAL;
+		return false;
 
 	BUG_ON(mmu_psize_defs[mmu_psize].shift != shift);
 
-	/* Return if huge page size has already been setup */
-	if (size_to_hstate(size))
-		return 0;
+	return true;
+}
 
-	hugetlb_add_hstate(shift - PAGE_SHIFT);
+static int __init add_huge_page_size(unsigned long long size)
+{
+	int shift = __ffs(size);
+
+	if (!arch_hugetlb_valid_size((unsigned long)size))
+		return -EINVAL;
 
+	if (!size_to_hstate(size))
+		hugetlb_add_hstate(shift - PAGE_SHIFT);
 	return 0;
 }
 
--- a/arch/riscv/mm/hugetlbpage.c~hugetlbfs-add-arch_hugetlb_valid_size
+++ a/arch/riscv/mm/hugetlbpage.c
@@ -12,21 +12,29 @@ int pmd_huge(pmd_t pmd)
 	return pmd_leaf(pmd);
 }
 
+bool __init arch_hugetlb_valid_size(unsigned long size)
+{
+	if (size == HPAGE_SIZE)
+		return true;
+	else if (IS_ENABLED(CONFIG_64BIT) && size == PUD_SIZE)
+		return true;
+	else
+		return false;
+}
+
 static __init int setup_hugepagesz(char *opt)
 {
 	unsigned long ps = memparse(opt, &opt);
 
-	if (ps == HPAGE_SIZE) {
-		hugetlb_add_hstate(HPAGE_SHIFT - PAGE_SHIFT);
-	} else if (IS_ENABLED(CONFIG_64BIT) && ps == PUD_SIZE) {
-		hugetlb_add_hstate(PUD_SHIFT - PAGE_SHIFT);
-	} else {
-		hugetlb_bad_size();
-		pr_err("hugepagesz: Unsupported page size %lu M\n", ps >> 20);
-		return 0;
+	if (arch_hugetlb_valid_size(ps)) {
+		hugetlb_add_hstate(ilog2(ps) - PAGE_SHIFT);
+		return 1;
 	}
 
-	return 1;
+	hugetlb_bad_size();
+	pr_err("hugepagesz: Unsupported page size %lu M\n", ps >> 20);
+	return 0;
+
 }
 __setup("hugepagesz=", setup_hugepagesz);
 
--- a/arch/s390/mm/hugetlbpage.c~hugetlbfs-add-arch_hugetlb_valid_size
+++ a/arch/s390/mm/hugetlbpage.c
@@ -254,16 +254,24 @@ follow_huge_pud(struct mm_struct *mm, un
 	return pud_page(*pud) + ((address & ~PUD_MASK) >> PAGE_SHIFT);
 }
 
+bool __init arch_hugetlb_valid_size(unsigned long size)
+{
+	if (MACHINE_HAS_EDAT1 && size == PMD_SIZE)
+		return true;
+	else if (MACHINE_HAS_EDAT2 && size == PUD_SIZE)
+		return true;
+	else
+		return false;
+}
+
 static __init int setup_hugepagesz(char *opt)
 {
 	unsigned long size;
 	char *string = opt;
 
 	size = memparse(opt, &opt);
-	if (MACHINE_HAS_EDAT1 && size == PMD_SIZE) {
-		hugetlb_add_hstate(PMD_SHIFT - PAGE_SHIFT);
-	} else if (MACHINE_HAS_EDAT2 && size == PUD_SIZE) {
-		hugetlb_add_hstate(PUD_SHIFT - PAGE_SHIFT);
+	if (arch_hugetlb_valid_size(size)) {
+		hugetlb_add_hstate(ilog2(size) - PAGE_SHIFT);
 	} else {
 		hugetlb_bad_size();
 		pr_err("hugepagesz= specifies an unsupported page size %s\n",
--- a/arch/sparc/mm/init_64.c~hugetlbfs-add-arch_hugetlb_valid_size
+++ a/arch/sparc/mm/init_64.c
@@ -360,16 +360,11 @@ static void __init pud_huge_patch(void)
 	__asm__ __volatile__("flush %0" : : "r" (addr));
 }
 
-static int __init setup_hugepagesz(char *string)
+bool __init arch_hugetlb_valid_size(unsigned long size)
 {
-	unsigned long long hugepage_size;
-	unsigned int hugepage_shift;
+	unsigned int hugepage_shift = ilog2(size);
 	unsigned short hv_pgsz_idx;
 	unsigned int hv_pgsz_mask;
-	int rc = 0;
-
-	hugepage_size = memparse(string, &string);
-	hugepage_shift = ilog2(hugepage_size);
 
 	switch (hugepage_shift) {
 	case HPAGE_16GB_SHIFT:
@@ -397,7 +392,20 @@ static int __init setup_hugepagesz(char
 		hv_pgsz_mask = 0;
 	}
 
-	if ((hv_pgsz_mask & cpu_pgsz_mask) == 0U) {
+	if ((hv_pgsz_mask & cpu_pgsz_mask) == 0U)
+		return false;
+
+	return true;
+}
+
+static int __init setup_hugepagesz(char *string)
+{
+	unsigned long long hugepage_size;
+	int rc = 0;
+
+	hugepage_size = memparse(string, &string);
+
+	if (!arch_hugetlb_valid_size((unsigned long)hugepage_size)) {
 		hugetlb_bad_size();
 		pr_err("hugepagesz=%llu not supported by MMU.\n",
 			hugepage_size);
--- a/arch/x86/mm/hugetlbpage.c~hugetlbfs-add-arch_hugetlb_valid_size
+++ a/arch/x86/mm/hugetlbpage.c
@@ -181,13 +181,22 @@ get_unmapped_area:
 #endif /* CONFIG_HUGETLB_PAGE */
 
 #ifdef CONFIG_X86_64
+bool __init arch_hugetlb_valid_size(unsigned long size)
+{
+	if (size == PMD_SIZE)
+		return true;
+	else if (size == PUD_SIZE && boot_cpu_has(X86_FEATURE_GBPAGES))
+		return true;
+	else
+		return false;
+}
+
 static __init int setup_hugepagesz(char *opt)
 {
 	unsigned long ps = memparse(opt, &opt);
-	if (ps == PMD_SIZE) {
-		hugetlb_add_hstate(PMD_SHIFT - PAGE_SHIFT);
-	} else if (ps == PUD_SIZE && boot_cpu_has(X86_FEATURE_GBPAGES)) {
-		hugetlb_add_hstate(PUD_SHIFT - PAGE_SHIFT);
+
+	if (arch_hugetlb_valid_size(ps)) {
+		hugetlb_add_hstate(ilog2(ps) - PAGE_SHIFT);
 	} else {
 		hugetlb_bad_size();
 		printk(KERN_ERR "hugepagesz: Unsupported page size %lu M\n",
--- a/include/linux/hugetlb.h~hugetlbfs-add-arch_hugetlb_valid_size
+++ a/include/linux/hugetlb.h
@@ -521,6 +521,7 @@ int __init alloc_bootmem_huge_page(struc
 
 void __init hugetlb_bad_size(void);
 void __init hugetlb_add_hstate(unsigned order);
+bool __init arch_hugetlb_valid_size(unsigned long size);
 struct hstate *size_to_hstate(unsigned long size);
 
 #ifndef HUGE_MAX_HSTATE
--- a/mm/hugetlb.c~hugetlbfs-add-arch_hugetlb_valid_size
+++ a/mm/hugetlb.c
@@ -3256,6 +3256,12 @@ static int __init hugetlb_init(void)
 }
 subsys_initcall(hugetlb_init);
 
+/* Overwritten by architectures with more huge page sizes */
+bool __init __attribute((weak)) arch_hugetlb_valid_size(unsigned long size)
+{
+	return size == HPAGE_SIZE;
+}
+
 /* Should be called on processing a hugepagesz=... option */
 void __init hugetlb_bad_size(void)
 {
@@ -3331,12 +3337,21 @@ static int __init hugetlb_nrpages_setup(
 }
 __setup("hugepages=", hugetlb_nrpages_setup);
 
-static int __init hugetlb_default_setup(char *s)
+static int __init default_hugepagesz_setup(char *s)
 {
-	default_hstate_size = memparse(s, &s);
+	unsigned long size;
+
+	size = (unsigned long)memparse(s, NULL);
+
+	if (!arch_hugetlb_valid_size(size)) {
+		pr_err("HugeTLB: unsupported default_hugepagesz %s\n", s);
+		return 0;
+	}
+
+	default_hstate_size = size;
 	return 1;
 }
-__setup("default_hugepagesz=", hugetlb_default_setup);
+__setup("default_hugepagesz=", default_hugepagesz_setup);
 
 static unsigned int cpuset_mems_nr(unsigned int *array)
 {
_
