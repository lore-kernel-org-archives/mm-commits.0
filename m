From: akpm@linux-foundation.org
Subject: +
 mm-fix-device-dax-pud-write-faults-triggered-by-get_user_pages.patch added
 to -mm tree
Date: Tue, 14 Nov 2017 12:22:05 -0800
Message-ID: <5a0b506d.gdHEe0hT/liGOSJu%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54906 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754051AbdKNUWH (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 14 Nov 2017 15:22:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dan.j.williams@intel.com, arnd@arndb.de, catalin.marinas@arm.com, dave.hansen@intel.com, davem@davemloft.net, hpa@zytor.com, kirill.shutemov@linux.intel.com, mingo@redhat.com, stable@vger.kernel.org, tglx@linutronix.de, will.deacon@arm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: fix device-dax pud write-faults triggered by get_user_pages()
has been added to the -mm tree.  Its filename is
     mm-fix-device-dax-pud-write-faults-triggered-by-get_user_pages.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-fix-device-dax-pud-write-faults-triggered-by-get_user_pages.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-fix-device-dax-pud-write-faults-triggered-by-get_user_pages.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Dan Williams <dan.j.williams@intel.com>
Subject: mm: fix device-dax pud write-faults triggered by get_user_pages()

Currently only get_user_pages_fast() can safely handle the writable gup
case due to its use of pud_access_permitted() to check whether the pud
entry is writable.  In the gup slow path pud_write() is used instead of
pud_access_permitted() and to date it has been unimplemented, just calls
BUG_ON().

    kernel BUG at ./include/linux/hugetlb.h:244!
    [..]
    RIP: 0010:follow_devmap_pud+0x482/0x490
    [..]
    Call Trace:
     follow_page_mask+0x28c/0x6e0
     __get_user_pages+0xe4/0x6c0
     get_user_pages_unlocked+0x130/0x1b0
     get_user_pages_fast+0x89/0xb0
     iov_iter_get_pages_alloc+0x114/0x4a0
     nfs_direct_read_schedule_iovec+0xd2/0x350
     ? nfs_start_io_direct+0x63/0x70
     nfs_file_direct_read+0x1e0/0x250
     nfs_file_read+0x90/0xc0

For now this just implements a simple check for the _PAGE_RW bit similar
to pmd_write.  However, this implies that the gup-slow-path check is
missing the extra checks that the gup-fast-path performs with
pud_access_permitted.  Later patches will align all checks to use the
'access_permitted' helper if the architecture provides it.  Note that the
generic 'access_permitted' helper fallback is the simple _PAGE_RW check on
architectures that do not define the 'access_permitted' helper(s).

Link: http://lkml.kernel.org/r/151043109938.2842.14834662818213616199.stgit@dwillia2-desk3.amr.corp.intel.com
Fixes: a00cc7d9dd93 ("mm, x86: add support for PUD-sized transparent hugepages")
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Will Deacon <will.deacon@arm.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/include/asm/pgtable.h    |    1 +
 arch/sparc/include/asm/pgtable_64.h |    1 +
 arch/x86/include/asm/pgtable.h      |    6 ++++++
 include/asm-generic/pgtable.h       |    9 +++++++++
 include/linux/hugetlb.h             |    8 --------
 5 files changed, 17 insertions(+), 8 deletions(-)

diff -puN arch/arm64/include/asm/pgtable.h~mm-fix-device-dax-pud-write-faults-triggered-by-get_user_pages arch/arm64/include/asm/pgtable.h
--- a/arch/arm64/include/asm/pgtable.h~mm-fix-device-dax-pud-write-faults-triggered-by-get_user_pages
+++ a/arch/arm64/include/asm/pgtable.h
@@ -340,6 +340,7 @@ static inline int pmd_protnone(pmd_t pmd
 #define pfn_pmd(pfn,prot)	(__pmd(((phys_addr_t)(pfn) << PAGE_SHIFT) | pgprot_val(prot)))
 #define mk_pmd(page,prot)	pfn_pmd(page_to_pfn(page),prot)
 
+#define __HAVE_ARCH_PUD_WRITE
 #define pud_write(pud)		pte_write(pud_pte(pud))
 #define pud_pfn(pud)		(((pud_val(pud) & PUD_MASK) & PHYS_MASK) >> PAGE_SHIFT)
 
diff -puN arch/sparc/include/asm/pgtable_64.h~mm-fix-device-dax-pud-write-faults-triggered-by-get_user_pages arch/sparc/include/asm/pgtable_64.h
--- a/arch/sparc/include/asm/pgtable_64.h~mm-fix-device-dax-pud-write-faults-triggered-by-get_user_pages
+++ a/arch/sparc/include/asm/pgtable_64.h
@@ -723,6 +723,7 @@ static inline unsigned long pmd_write(pm
 	return pte_write(pte);
 }
 
+#define __HAVE_ARCH_PUD_WRITE
 #define pud_write(pud)	pte_write(__pte(pud_val(pud)))
 
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
diff -puN arch/x86/include/asm/pgtable.h~mm-fix-device-dax-pud-write-faults-triggered-by-get_user_pages arch/x86/include/asm/pgtable.h
--- a/arch/x86/include/asm/pgtable.h~mm-fix-device-dax-pud-write-faults-triggered-by-get_user_pages
+++ a/arch/x86/include/asm/pgtable.h
@@ -1088,6 +1088,12 @@ static inline void pmdp_set_wrprotect(st
 	clear_bit(_PAGE_BIT_RW, (unsigned long *)pmdp);
 }
 
+#define __HAVE_ARCH_PUD_WRITE
+static inline int pud_write(pud_t pud)
+{
+	return pud_flags(pud) & _PAGE_RW;
+}
+
 /*
  * clone_pgd_range(pgd_t *dst, pgd_t *src, int count);
  *
diff -puN include/asm-generic/pgtable.h~mm-fix-device-dax-pud-write-faults-triggered-by-get_user_pages include/asm-generic/pgtable.h
--- a/include/asm-generic/pgtable.h~mm-fix-device-dax-pud-write-faults-triggered-by-get_user_pages
+++ a/include/asm-generic/pgtable.h
@@ -812,6 +812,15 @@ static inline int pmd_write(pmd_t pmd)
 	return 0;
 }
 #endif /* __HAVE_ARCH_PMD_WRITE */
+
+#ifndef __HAVE_ARCH_PUD_WRITE
+static inline int pud_write(pud_t pud)
+{
+	BUG();
+	return 0;
+}
+#endif /* __HAVE_ARCH_PUD_WRITE */
+
 #endif /* CONFIG_TRANSPARENT_HUGEPAGE */
 
 #if !defined(CONFIG_TRANSPARENT_HUGEPAGE) || \
diff -puN include/linux/hugetlb.h~mm-fix-device-dax-pud-write-faults-triggered-by-get_user_pages include/linux/hugetlb.h
--- a/include/linux/hugetlb.h~mm-fix-device-dax-pud-write-faults-triggered-by-get_user_pages
+++ a/include/linux/hugetlb.h
@@ -239,14 +239,6 @@ static inline int pgd_write(pgd_t pgd)
 }
 #endif
 
-#ifndef pud_write
-static inline int pud_write(pud_t pud)
-{
-	BUG();
-	return 0;
-}
-#endif
