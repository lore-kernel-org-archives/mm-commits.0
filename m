From: akpm@linux-foundation.org
Subject: +
 mm-move-phys_mem_access_prot_allowed-declaration-to-pgtableh.patch added to -mm tree
Date: Tue, 13 Sep 2016 14:21:16 -0700
Message-ID: <57d86dcc./VhRPiiNwatl7Dko%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34968 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751488AbcIMVVR (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 13 Sep 2016 17:21:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: baoyou.xie@linaro.org, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: move phys_mem_access_prot_allowed() declaration to pgtable.h
has been added to the -mm tree.  Its filename is
     mm-move-phys_mem_access_prot_allowed-declaration-to-pgtableh.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-move-phys_mem_access_prot_allowed-declaration-to-pgtableh.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-move-phys_mem_access_prot_allowed-declaration-to-pgtableh.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm-move-phys_mem_access_prot_allowed-declaration-to-pgtableh.patch

