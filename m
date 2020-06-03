From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 070/131] hugetlbfs: move hugepagesz= parsing to
 arch independent code
Date: Wed, 03 Jun 2020 16:00:38 -0700
Message-ID: <20200603230038.-AcTE5eTv%akpm@linux-foundation.org>
References: <20200603155549.e041363450869eaae4c7f05b@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:42958 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725821AbgFCXAl (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 3 Jun 2020 19:00:41 -0400
In-Reply-To: <20200603155549.e041363450869eaae4c7f05b@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, almasrymina@google.com, anders.roxell@linaro.org, aneesh.kumar@linux.ibm.com, aou@eecs.berkeley.edu, benh@kernel.crashing.org, borntraeger@de.ibm.com, cai@lca.pw, catalin.marinas@arm.com, christophe.leroy@c-s.fr, corbet@lwn.net, dave.hansen@linux.intel.com, davem@davemloft.net, gerald.schaefer@de.ibm.com, gor@linux.ibm.com, heiko.carstens@de.ibm.com, linux-mm@kvack.org, longpeng2@huawei.com, mike.kravetz@oracle.com, mingo@redhat.com, mm-commits@vger.kernel.org, nitesh@redhat.com, palmer@dabbelt.com, paul.walmsley@sifive.com, paulus@samba.org, peterx@redhat.com, rdunlap@infradead.org, sandipan@linux.ibm.com, sfr@canb.auug.org.au, tglx@linutronix.de, torvalds@linux-foundation.org, will@kernel.org

From: Mike Kravetz <mike.kravetz@oracle.com>
Subject: hugetlbfs: move hugepagesz= parsing to arch independent code

Now that architectures provide arch_hugetlb_valid_size(), parsing of
"hugepagesz=" can be done in architecture independent code.  Create a
single routine to handle hugepagesz= parsing and remove all arch specific
routines.  We can also remove the interface hugetlb_bad_size() as this is
no longer used outside arch independent code.

This also provides consistent behavior of hugetlbfs command line options. 
The hugepagesz= option should only be specified once for a specific size,
but some architectures allow multiple instances.  This appears to be more
of an oversight when code was added by some architectures to set up ALL
huge pages sizes.

Link: http://lkml.kernel.org/r/20200417185049.275845-3-mike.kravetz@oracle.com
Link: http://lkml.kernel.org/r/20200428205614.246260-3-mike.kravetz@oracle.com
Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>
Acked-by: Mina Almasry <almasrymina@google.com>
Reviewed-by: Peter Xu <peterx@redhat.com>
Acked-by: Gerald Schaefer <gerald.schaefer@de.ibm.com>	[s390]
Acked-by: Will Deacon <will@kernel.org>
Tested-by: Sandipan Das <sandipan@linux.ibm.com>
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
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Anders Roxell <anders.roxell@linaro.org>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Cc: Qian Cai <cai@lca.pw>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/mm/hugetlbpage.c   |   15 ---------------
 arch/powerpc/mm/hugetlbpage.c |   15 ---------------
 arch/riscv/mm/hugetlbpage.c   |   16 ----------------
 arch/s390/mm/hugetlbpage.c    |   18 ------------------
 arch/sparc/mm/init_64.c       |   22 ----------------------
 arch/x86/mm/hugetlbpage.c     |   16 ----------------
 include/linux/hugetlb.h       |    1 -
 mm/hugetlb.c                  |   23 +++++++++++++++++------
 8 files changed, 17 insertions(+), 109 deletions(-)

--- a/arch/arm64/mm/hugetlbpage.c~hugetlbfs-move-hugepagesz=-parsing-to-arch-independent-code
+++ a/arch/arm64/mm/hugetlbpage.c
@@ -478,18 +478,3 @@ bool __init arch_hugetlb_valid_size(unsi
 
 	return false;
 }
-
-static __init int setup_hugepagesz(char *opt)
-{
-	unsigned long ps = memparse(opt, &opt);
-
-	if (arch_hugetlb_valid_size(ps)) {
-		add_huge_page_size(ps);
-		return 1;
-	}
-
-	hugetlb_bad_size();
-	pr_err("hugepagesz: Unsupported page size %lu K\n", ps >> 10);
-	return 0;
-}
-__setup("hugepagesz=", setup_hugepagesz);
--- a/arch/powerpc/mm/hugetlbpage.c~hugetlbfs-move-hugepagesz=-parsing-to-arch-independent-code
+++ a/arch/powerpc/mm/hugetlbpage.c
@@ -589,21 +589,6 @@ static int __init add_huge_page_size(uns
 	return 0;
 }
 
-static int __init hugepage_setup_sz(char *str)
-{
-	unsigned long long size;
-
-	size = memparse(str, &str);
-
-	if (add_huge_page_size(size) != 0) {
-		hugetlb_bad_size();
-		pr_err("Invalid huge page size specified(%llu)\n", size);
-	}
-
-	return 1;
-}
-__setup("hugepagesz=", hugepage_setup_sz);
-
 static int __init hugetlbpage_init(void)
 {
 	bool configured = false;
--- a/arch/riscv/mm/hugetlbpage.c~hugetlbfs-move-hugepagesz=-parsing-to-arch-independent-code
+++ a/arch/riscv/mm/hugetlbpage.c
@@ -22,22 +22,6 @@ bool __init arch_hugetlb_valid_size(unsi
 		return false;
 }
 
-static __init int setup_hugepagesz(char *opt)
-{
-	unsigned long ps = memparse(opt, &opt);
-
-	if (arch_hugetlb_valid_size(ps)) {
-		hugetlb_add_hstate(ilog2(ps) - PAGE_SHIFT);
-		return 1;
-	}
-
-	hugetlb_bad_size();
-	pr_err("hugepagesz: Unsupported page size %lu M\n", ps >> 20);
-	return 0;
-
-}
-__setup("hugepagesz=", setup_hugepagesz);
-
 #ifdef CONFIG_CONTIG_ALLOC
 static __init int gigantic_pages_init(void)
 {
--- a/arch/s390/mm/hugetlbpage.c~hugetlbfs-move-hugepagesz=-parsing-to-arch-independent-code
+++ a/arch/s390/mm/hugetlbpage.c
@@ -264,24 +264,6 @@ bool __init arch_hugetlb_valid_size(unsi
 		return false;
 }
 
-static __init int setup_hugepagesz(char *opt)
-{
-	unsigned long size;
-	char *string = opt;
-
-	size = memparse(opt, &opt);
-	if (arch_hugetlb_valid_size(size)) {
-		hugetlb_add_hstate(ilog2(size) - PAGE_SHIFT);
-	} else {
-		hugetlb_bad_size();
-		pr_err("hugepagesz= specifies an unsupported page size %s\n",
-			string);
-		return 0;
-	}
-	return 1;
-}
-__setup("hugepagesz=", setup_hugepagesz);
-
 static unsigned long hugetlb_get_unmapped_area_bottomup(struct file *file,
 		unsigned long addr, unsigned long len,
 		unsigned long pgoff, unsigned long flags)
--- a/arch/sparc/mm/init_64.c~hugetlbfs-move-hugepagesz=-parsing-to-arch-independent-code
+++ a/arch/sparc/mm/init_64.c
@@ -397,28 +397,6 @@ bool __init arch_hugetlb_valid_size(unsi
 
 	return true;
 }
-
-static int __init setup_hugepagesz(char *string)
-{
-	unsigned long long hugepage_size;
-	int rc = 0;
-
-	hugepage_size = memparse(string, &string);
-
-	if (!arch_hugetlb_valid_size((unsigned long)hugepage_size)) {
-		hugetlb_bad_size();
-		pr_err("hugepagesz=%llu not supported by MMU.\n",
-			hugepage_size);
-		goto out;
-	}
-
-	add_huge_page_size(hugepage_size);
-	rc = 1;
-
-out:
-	return rc;
-}
-__setup("hugepagesz=", setup_hugepagesz);
 #endif	/* CONFIG_HUGETLB_PAGE */
 
 void update_mmu_cache(struct vm_area_struct *vma, unsigned long address, pte_t *ptep)
--- a/arch/x86/mm/hugetlbpage.c~hugetlbfs-move-hugepagesz=-parsing-to-arch-independent-code
+++ a/arch/x86/mm/hugetlbpage.c
@@ -191,22 +191,6 @@ bool __init arch_hugetlb_valid_size(unsi
 		return false;
 }
 
-static __init int setup_hugepagesz(char *opt)
-{
-	unsigned long ps = memparse(opt, &opt);
-
-	if (arch_hugetlb_valid_size(ps)) {
-		hugetlb_add_hstate(ilog2(ps) - PAGE_SHIFT);
-	} else {
-		hugetlb_bad_size();
-		printk(KERN_ERR "hugepagesz: Unsupported page size %lu M\n",
-			ps >> 20);
-		return 0;
-	}
-	return 1;
-}
-__setup("hugepagesz=", setup_hugepagesz);
-
 #ifdef CONFIG_CONTIG_ALLOC
 static __init int gigantic_pages_init(void)
 {
--- a/include/linux/hugetlb.h~hugetlbfs-move-hugepagesz=-parsing-to-arch-independent-code
+++ a/include/linux/hugetlb.h
@@ -519,7 +519,6 @@ int huge_add_to_page_cache(struct page *
 int __init __alloc_bootmem_huge_page(struct hstate *h);
 int __init alloc_bootmem_huge_page(struct hstate *h);
 
-void __init hugetlb_bad_size(void);
 void __init hugetlb_add_hstate(unsigned order);
 bool __init arch_hugetlb_valid_size(unsigned long size);
 struct hstate *size_to_hstate(unsigned long size);
--- a/mm/hugetlb.c~hugetlbfs-move-hugepagesz=-parsing-to-arch-independent-code
+++ a/mm/hugetlb.c
@@ -3262,12 +3262,6 @@ bool __init __attribute((weak)) arch_hug
 	return size == HPAGE_SIZE;
 }
 
-/* Should be called on processing a hugepagesz=... option */
-void __init hugetlb_bad_size(void)
-{
-	parsed_valid_hugepagesz = false;
-}
