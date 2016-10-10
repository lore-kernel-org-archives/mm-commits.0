From: akpm@linux-foundation.org
Subject: [merged]
 mm-move-phys_mem_access_prot_allowed-declaration-to-pgtableh.patch removed
 from -mm tree
Date: Mon, 10 Oct 2016 15:45:46 -0700
Message-ID: <57fc1a1a.RkLNhnwX7w6OAJWh%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37177 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752421AbcJJWpr (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 10 Oct 2016 18:45:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: baoyou.xie@linaro.org, ralf@linux-mips.org, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: move phys_mem_access_prot_allowed() declaration to pgtable.h
has been removed from the -mm tree.  Its filename was
     mm-move-phys_mem_access_prot_allowed-declaration-to-pgtableh.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Baoyou Xie <baoyou.xie@linaro.org>
Subject: mm: move phys_mem_access_prot_allowed() declaration to pgtable.h

We get 1 warning when building kernel with W=1:
drivers/char/mem.c:220:12: warning: no previous prototype for 'phys_mem_access_prot_allowed' [-Wmissing-prototypes]
 int __weak phys_mem_access_prot_allowed(struct file *file,

In fact, its declaration is spreading to several header files in different
architecture, but need to be declare in common header file.

So this patch moves phys_mem_access_prot_allowed() to pgtable.h.

Link: http://lkml.kernel.org/r/1473751597-12139-1-git-send-email-baoyou.xie@linaro.org
Signed-off-by: Baoyou Xie <baoyou.xie@linaro.org>
Acked-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mips/include/asm/pgtable.h      |    2 --
 arch/x86/include/asm/pgtable_types.h |    2 --
 include/asm-generic/pgtable.h        |    3 +++
 3 files changed, 3 insertions(+), 4 deletions(-)

diff -puN arch/mips/include/asm/pgtable.h~mm-move-phys_mem_access_prot_allowed-declaration-to-pgtableh arch/mips/include/asm/pgtable.h
--- a/arch/mips/include/asm/pgtable.h~mm-move-phys_mem_access_prot_allowed-declaration-to-pgtableh
+++ a/arch/mips/include/asm/pgtable.h
@@ -673,8 +673,6 @@ static inline pmd_t pmdp_huge_get_and_cl
 struct file;
 pgprot_t phys_mem_access_prot(struct file *file, unsigned long pfn,
 		unsigned long size, pgprot_t vma_prot);
-int phys_mem_access_prot_allowed(struct file *file, unsigned long pfn,
-		unsigned long size, pgprot_t *vma_prot);
 #endif
 
 /*
diff -puN arch/x86/include/asm/pgtable_types.h~mm-move-phys_mem_access_prot_allowed-declaration-to-pgtableh arch/x86/include/asm/pgtable_types.h
--- a/arch/x86/include/asm/pgtable_types.h~mm-move-phys_mem_access_prot_allowed-declaration-to-pgtableh
+++ a/arch/x86/include/asm/pgtable_types.h
@@ -439,8 +439,6 @@ extern pgprot_t pgprot_writethrough(pgpr
 struct file;
 pgprot_t phys_mem_access_prot(struct file *file, unsigned long pfn,
                               unsigned long size, pgprot_t vma_prot);
-int phys_mem_access_prot_allowed(struct file *file, unsigned long pfn,
-                              unsigned long size, pgprot_t *vma_prot);
 
 /* Install a pte for a particular vaddr in kernel space. */
 void set_pte_vaddr(unsigned long vaddr, pte_t pte);
diff -puN include/asm-generic/pgtable.h~mm-move-phys_mem_access_prot_allowed-declaration-to-pgtableh include/asm-generic/pgtable.h
--- a/include/asm-generic/pgtable.h~mm-move-phys_mem_access_prot_allowed-declaration-to-pgtableh
+++ a/include/asm-generic/pgtable.h
@@ -800,6 +800,9 @@ static inline int pmd_clear_huge(pmd_t *
 #endif
 #endif
 
+struct file;
+int phys_mem_access_prot_allowed(struct file *file, unsigned long pfn,
+			unsigned long size, pgprot_t *vma_prot);
 #endif /* !__ASSEMBLY__ */
 
 #ifndef io_remap_pfn_range
_

Patches currently in -mm which might be from baoyou.xie@linaro.org are


