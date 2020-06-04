From: akpm@linux-foundation.org
Subject: [merged]
 hugetlbfs-remove-hugetlb_add_hstate-warning-for-existing-hstate.patch
 removed from -mm tree
Date: Thu, 04 Jun 2020 10:19:19 -0700
Message-ID: <20200604171919.EUSvpt4Nh%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:41126 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730058AbgFDRTV (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 4 Jun 2020 13:19:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: almasrymina@google.com, anders.roxell@linaro.org, aneesh.kumar@linux.ibm.com, aou@eecs.berkeley.edu, benh@kernel.crashing.org, borntraeger@de.ibm.com, cai@lca.pw, catalin.marinas@arm.com, christophe.leroy@c-s.fr, corbet@lwn.net, dave.hansen@linux.intel.com, davem@davemloft.net, gerald.schaefer@de.ibm.com, gor@linux.ibm.com, heiko.carstens@de.ibm.com, longpeng2@huawei.com, mike.kravetz@oracle.com, mingo@redhat.com, mm-commits@vger.kernel.org, nitesh@redhat.com, palmer@dabbelt.com, paul.walmsley@sifive.com, paulus@samba.org, peterx@redhat.com, rdunlap@infradead.org, sfr@canb.auug.org.au, tglx@linutronix.de, will@kernel.org


The patch titled
     Subject: hugetlbfs: remove hugetlb_add_hstate() warning for existing hstate
has been removed from the -mm tree.  Its filename was
     hugetlbfs-remove-hugetlb_add_hstate-warning-for-existing-hstate.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mike Kravetz <mike.kravetz@oracle.com>
Subject: hugetlbfs: remove hugetlb_add_hstate() warning for existing hstate

hugetlb_add_hstate() prints a warning if the hstate already exists.  This
was originally done as part of kernel command line parsing.  If
'hugepagesz=' was specified more than once, the warning

	pr_warn("hugepagesz= specified twice, ignoring\n");

would be printed.

Some architectures want to enable all huge page sizes.  They would call
hugetlb_add_hstate for all supported sizes.  However, this was done after
command line processing and as a result hstates could have already been
created for some sizes.  To make sure no warning were printed, there would
often be code like:

	if (!size_to_hstate(size)
		hugetlb_add_hstate(ilog2(size) - PAGE_SHIFT)

The only time we want to print the warning is as the result of command
line processing.  So, remove the warning from hugetlb_add_hstate and add
it to the single arch independent routine processing "hugepagesz=".  After
this, calls to size_to_hstate() in arch specific code can be removed and
hugetlb_add_hstate can be called without worrying about warning messages.

[mike.kravetz@oracle.com: fix hugetlb initialization]
  Link: http://lkml.kernel.org/r/4c36c6ce-3774-78fa-abc4-b7346bf24348@oracle.com
  Link: http://lkml.kernel.org/r/20200428205614.246260-5-mike.kravetz@oracle.com
Link: http://lkml.kernel.org/r/20200417185049.275845-4-mike.kravetz@oracle.com
Link: http://lkml.kernel.org/r/20200428205614.246260-4-mike.kravetz@oracle.com
Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>
Acked-by: Mina Almasry <almasrymina@google.com>
Acked-by: Gerald Schaefer <gerald.schaefer@de.ibm.com>	[s390]
Acked-by: Will Deacon <will@kernel.org>
Tested-by: Anders Roxell <anders.roxell@linaro.org>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: Christophe Leroy <christophe.leroy@c-s.fr>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Longpeng <longpeng2@huawei.com>
Cc: Nitesh Narayan Lal <nitesh@redhat.com>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Paul Walmsley <paul.walmsley@sifive.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Cc: Qian Cai <cai@lca.pw>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/mm/hugetlbpage.c   |   16 ++++------------
 arch/powerpc/mm/hugetlbpage.c |    3 +--
 arch/riscv/mm/hugetlbpage.c   |    2 +-
 arch/sparc/mm/init_64.c       |   19 ++++---------------
 arch/x86/mm/hugetlbpage.c     |    2 +-
 mm/hugetlb.c                  |    9 ++++++---
 6 files changed, 17 insertions(+), 34 deletions(-)

--- a/arch/arm64/mm/hugetlbpage.c~hugetlbfs-remove-hugetlb_add_hstate-warning-for-existing-hstate
+++ a/arch/arm64/mm/hugetlbpage.c
@@ -443,22 +443,14 @@ void huge_ptep_clear_flush(struct vm_are
 	clear_flush(vma->vm_mm, addr, ptep, pgsize, ncontig);
 }
 
-static void __init add_huge_page_size(unsigned long size)
-{
-	if (size_to_hstate(size))
-		return;
-
-	hugetlb_add_hstate(ilog2(size) - PAGE_SHIFT);
-}
-
 static int __init hugetlbpage_init(void)
 {
 #ifdef CONFIG_ARM64_4K_PAGES
-	add_huge_page_size(PUD_SIZE);
+	hugetlb_add_hstate(PUD_SHIFT - PAGE_SHIFT);
 #endif
-	add_huge_page_size(CONT_PMD_SIZE);
-	add_huge_page_size(PMD_SIZE);
-	add_huge_page_size(CONT_PTE_SIZE);
+	hugetlb_add_hstate((CONT_PMD_SHIFT + PMD_SHIFT) - PAGE_SHIFT);
+	hugetlb_add_hstate(PMD_SHIFT - PAGE_SHIFT);
+	hugetlb_add_hstate((CONT_PTE_SHIFT + PAGE_SHIFT) - PAGE_SHIFT);
 
 	return 0;
 }
--- a/arch/powerpc/mm/hugetlbpage.c~hugetlbfs-remove-hugetlb_add_hstate-warning-for-existing-hstate
+++ a/arch/powerpc/mm/hugetlbpage.c
@@ -584,8 +584,7 @@ static int __init add_huge_page_size(uns
 	if (!arch_hugetlb_valid_size((unsigned long)size))
 		return -EINVAL;
 
-	if (!size_to_hstate(size))
-		hugetlb_add_hstate(shift - PAGE_SHIFT);
+	hugetlb_add_hstate(shift - PAGE_SHIFT);
 	return 0;
 }
 
--- a/arch/riscv/mm/hugetlbpage.c~hugetlbfs-remove-hugetlb_add_hstate-warning-for-existing-hstate
+++ a/arch/riscv/mm/hugetlbpage.c
@@ -26,7 +26,7 @@ bool __init arch_hugetlb_valid_size(unsi
 static __init int gigantic_pages_init(void)
 {
 	/* With CONTIG_ALLOC, we can allocate gigantic pages at runtime */
-	if (IS_ENABLED(CONFIG_64BIT) && !size_to_hstate(1UL << PUD_SHIFT))
+	if (IS_ENABLED(CONFIG_64BIT))
 		hugetlb_add_hstate(PUD_SHIFT - PAGE_SHIFT);
 	return 0;
 }
--- a/arch/sparc/mm/init_64.c~hugetlbfs-remove-hugetlb_add_hstate-warning-for-existing-hstate
+++ a/arch/sparc/mm/init_64.c
@@ -325,23 +325,12 @@ static void __update_mmu_tsb_insert(stru
 }
 
 #ifdef CONFIG_HUGETLB_PAGE
-static void __init add_huge_page_size(unsigned long size)
-{
-	unsigned int order;
-
-	if (size_to_hstate(size))
-		return;
-
-	order = ilog2(size) - PAGE_SHIFT;
-	hugetlb_add_hstate(order);
-}
-
 static int __init hugetlbpage_init(void)
 {
-	add_huge_page_size(1UL << HPAGE_64K_SHIFT);
-	add_huge_page_size(1UL << HPAGE_SHIFT);
-	add_huge_page_size(1UL << HPAGE_256MB_SHIFT);
-	add_huge_page_size(1UL << HPAGE_2GB_SHIFT);
+	hugetlb_add_hstate(HPAGE_64K_SHIFT - PAGE_SHIFT);
+	hugetlb_add_hstate(HPAGE_SHIFT - PAGE_SHIFT);
+	hugetlb_add_hstate(HPAGE_256MB_SHIFT - PAGE_SHIFT);
+	hugetlb_add_hstate(HPAGE_2GB_SHIFT - PAGE_SHIFT);
 
 	return 0;
 }
--- a/arch/x86/mm/hugetlbpage.c~hugetlbfs-remove-hugetlb_add_hstate-warning-for-existing-hstate
+++ a/arch/x86/mm/hugetlbpage.c
@@ -195,7 +195,7 @@ bool __init arch_hugetlb_valid_size(unsi
 static __init int gigantic_pages_init(void)
 {
 	/* With compaction or CMA we can allocate gigantic pages at runtime */
-	if (boot_cpu_has(X86_FEATURE_GBPAGES) && !size_to_hstate(1UL << PUD_SHIFT))
+	if (boot_cpu_has(X86_FEATURE_GBPAGES))
 		hugetlb_add_hstate(PUD_SHIFT - PAGE_SHIFT);
 	return 0;
 }
--- a/mm/hugetlb.c~hugetlbfs-remove-hugetlb_add_hstate-warning-for-existing-hstate
+++ a/mm/hugetlb.c
@@ -3222,8 +3222,7 @@ static int __init hugetlb_init(void)
 		}
 
 		default_hstate_size = HPAGE_SIZE;
-		if (!size_to_hstate(default_hstate_size))
-			hugetlb_add_hstate(HUGETLB_PAGE_ORDER);
+		hugetlb_add_hstate(HUGETLB_PAGE_ORDER);
 	}
 	default_hstate_idx = hstate_index(size_to_hstate(default_hstate_size));
 	if (default_hstate_max_huge_pages) {
@@ -3268,7 +3267,6 @@ void __init hugetlb_add_hstate(unsigned
 	unsigned long i;
 
 	if (size_to_hstate(PAGE_SIZE << order)) {
-		pr_warn("hugepagesz= specified twice, ignoring\n");
 		return;
 	}
 	BUG_ON(hugetlb_max_hstate >= HUGE_MAX_HSTATE);
@@ -3343,6 +3341,11 @@ static int __init hugepagesz_setup(char
 		return 0;
 	}
 
+	if (size_to_hstate(size)) {
+		pr_warn("HugeTLB: hugepagesz %s specified twice, ignoring\n", s);
+		return 0;
+	}
+
 	hugetlb_add_hstate(ilog2(size) - PAGE_SHIFT);
 	return 1;
 }
_

Patches currently in -mm which might be from mike.kravetz@oracle.com are
