From: akpm@linux-foundation.org
Subject: +
 hugetlbfs-move-hugepagesz=-parsing-to-arch-independent-code.patch added to
 -mm tree
Date: Fri, 17 Apr 2020 12:17:21 -0700
Message-ID: <20200417191721.Ok9accc8i%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:39342 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728260AbgDQTRY (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 17 Apr 2020 15:17:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: almasrymina@google.com, aou@eecs.berkeley.edu, benh@kernel.crashing.org, borntraeger@de.ibm.com, catalin.marinas@arm.com, christophe.leroy@c-s.fr, corbet@lwn.net, dave.hansen@linux.intel.com, davem@davemloft.net, gor@linux.ibm.com, heiko.carstens@de.ibm.com, longpeng2@huawei.com, mike.kravetz@oracle.com, mingo@redhat.com, mm-commits@vger.kernel.org, nitesh@redhat.com, palmer@dabbelt.com, paul.walmsley@sifive.com, paulus@samba.org, peterx@redhat.com, rdunlap@infradead.org, tglx@linutronix.de, will@kernel.org


The patch titled
     Subject: hugetlbfs: move hugepagesz= parsing to arch independent code
has been added to the -mm tree.  Its filename is
     hugetlbfs-move-hugepagesz=-parsing-to-arch-independent-code.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/hugetlbfs-move-hugepagesz%3D-parsing-to-arch-independent-code.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/hugetlbfs-move-hugepagesz%3D-parsing-to-arch-independent-code.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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
Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>
Acked-by: Mina Almasry <almasrymina@google.com>
Reviewed-by: Peter Xu <peterx@redhat.com>
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
Cc: Will Deacon <will@kernel.org>
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
@@ -485,18 +485,3 @@ bool __init arch_hugetlb_valid_size(unsi
 
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
@@ -593,21 +593,6 @@ static int __init add_huge_page_size(uns
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
@@ -261,24 +261,6 @@ bool __init arch_hugetlb_valid_size(unsi
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
-
 void __init hugetlb_add_hstate(unsigned int order)
 {
 	struct hstate *h;
@@ -3337,6 +3331,23 @@ static int __init hugetlb_nrpages_setup(
 }
 __setup("hugepages=", hugetlb_nrpages_setup);
 
+static int __init hugepagesz_setup(char *s)
+{
+	unsigned long size;
+
+	size = (unsigned long)memparse(s, NULL);
+
+	if (!arch_hugetlb_valid_size(size)) {
+		parsed_valid_hugepagesz = false;
+		pr_err("HugeTLB: unsupported hugepagesz %s\n", s);
+		return 0;
+	}
+
+	hugetlb_add_hstate(ilog2(size) - PAGE_SHIFT);
+	return 1;
+}
+__setup("hugepagesz=", hugepagesz_setup);
+
 static int __init default_hugepagesz_setup(char *s)
 {
 	unsigned long size;
_

Patches currently in -mm which might be from mike.kravetz@oracle.com are

hugetlbfs-add-arch_hugetlb_valid_size.patch
hugetlbfs-move-hugepagesz=-parsing-to-arch-independent-code.patch
hugetlbfs-remove-hugetlb_add_hstate-warning-for-existing-hstate.patch
hugetlbfs-clean-up-command-line-processing.patch
