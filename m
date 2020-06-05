From: akpm@linux-foundation.org
Subject: [merged]
 sh-fault-modernize-printing-of-kernel-messages.patch removed from -mm tree
Date: Fri, 05 Jun 2020 13:16:55 -0700
Message-ID: <20200605201655.SE60Q5GuV%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:41836 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727087AbgFEUQ5 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 5 Jun 2020 16:16:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arnd@arndb.de, bcain@codeaurora.org, benh@kernel.crashing.org, catalin.marinas@arm.com, christophe.leroy@c-s.fr, dalias@libc.org, fenghua.yu@intel.com, geert+renesas@glider.be, gxt@pku.edu.cn, james.morse@arm.com, jonas@southpole.se, julien.thierry.kdev@gmail.com, ley.foon.tan@intel.com, linux@armlinux.org.uk, maz@kernel.org, mm-commits@vger.kernel.org, mpe@ellerman.id.au, paulus@samba.org, rppt@linux.ibm.com, shorne@gmail.com, stefan.kristiansson@saunalahti.fi, suzuki.poulose@arm.com, tony.luck@intel.com, will@kernel.org, ysato@users.sourceforge.jp


The patch titled
     Subject: sh: fault: modernize printing of kernel messages
has been removed from the -mm tree.  Its filename was
     sh-fault-modernize-printing-of-kernel-messages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Geert Uytterhoeven <geert+renesas@glider.be>
Subject: sh: fault: modernize printing of kernel messages

  - Convert from printk() to pr_*(),
  - Add missing continuations,
  - Use "%llx" to format u64,
  - Join multiple prints in show_fault_oops() into a single print.

Link: http://lkml.kernel.org/r/20200414153455.21744-10-rppt@kernel.org
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Mike Rapoport <rppt@linux.ibm.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Brian Cain <bcain@codeaurora.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Christophe Leroy <christophe.leroy@c-s.fr>
Cc: Fenghua Yu <fenghua.yu@intel.com>
Cc: Guan Xuetao <gxt@pku.edu.cn>
Cc: James Morse <james.morse@arm.com>
Cc: Jonas Bonn <jonas@southpole.se>
Cc: Julien Thierry <julien.thierry.kdev@gmail.com>
Cc: Ley Foon Tan <ley.foon.tan@intel.com>
Cc: Marc Zyngier <maz@kernel.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Rich Felker <dalias@libc.org>
Cc: Russell King <linux@armlinux.org.uk>
Cc: Stafford Horne <shorne@gmail.com>
Cc: Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>
Cc: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Will Deacon <will@kernel.org>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sh/mm/fault.c |   38 ++++++++++++++++++--------------------
 1 file changed, 18 insertions(+), 20 deletions(-)

--- a/arch/sh/mm/fault.c~sh-fault-modernize-printing-of-kernel-messages
+++ a/arch/sh/mm/fault.c
@@ -47,10 +47,10 @@ static void show_pte(struct mm_struct *m
 			pgd = swapper_pg_dir;
 	}
 
-	printk(KERN_ALERT "pgd = %p\n", pgd);
+	pr_alert("pgd = %p\n", pgd);
 	pgd += pgd_index(addr);
-	printk(KERN_ALERT "[%08lx] *pgd=%0*Lx", addr,
-	       (u32)(sizeof(*pgd) * 2), (u64)pgd_val(*pgd));
+	pr_alert("[%08lx] *pgd=%0*llx", addr, (u32)(sizeof(*pgd) * 2),
+		 (u64)pgd_val(*pgd));
 
 	do {
 		pud_t *pud;
@@ -61,33 +61,33 @@ static void show_pte(struct mm_struct *m
 			break;
 
 		if (pgd_bad(*pgd)) {
-			printk("(bad)");
+			pr_cont("(bad)");
 			break;
 		}
 
 		pud = pud_offset(pgd, addr);
 		if (PTRS_PER_PUD != 1)
-			printk(", *pud=%0*Lx", (u32)(sizeof(*pud) * 2),
-			       (u64)pud_val(*pud));
+			pr_cont(", *pud=%0*llx", (u32)(sizeof(*pud) * 2),
+				(u64)pud_val(*pud));
 
 		if (pud_none(*pud))
 			break;
 
 		if (pud_bad(*pud)) {
-			printk("(bad)");
+			pr_cont("(bad)");
 			break;
 		}
 
 		pmd = pmd_offset(pud, addr);
 		if (PTRS_PER_PMD != 1)
-			printk(", *pmd=%0*Lx", (u32)(sizeof(*pmd) * 2),
-			       (u64)pmd_val(*pmd));
+			pr_cont(", *pmd=%0*llx", (u32)(sizeof(*pmd) * 2),
+				(u64)pmd_val(*pmd));
 
 		if (pmd_none(*pmd))
 			break;
 
 		if (pmd_bad(*pmd)) {
-			printk("(bad)");
+			pr_cont("(bad)");
 			break;
 		}
 
@@ -96,11 +96,11 @@ static void show_pte(struct mm_struct *m
 			break;
 
 		pte = pte_offset_kernel(pmd, addr);
-		printk(", *pte=%0*Lx", (u32)(sizeof(*pte) * 2),
-		       (u64)pte_val(*pte));
+		pr_cont(", *pte=%0*llx", (u32)(sizeof(*pte) * 2),
+			(u64)pte_val(*pte));
 	} while (0);
 
-	printk("\n");
+	pr_cont("\n");
 }
 
 static inline pmd_t *vmalloc_sync_one(pgd_t *pgd, unsigned long address)
@@ -188,14 +188,12 @@ show_fault_oops(struct pt_regs *regs, un
 	if (!oops_may_print())
 		return;
 
-	printk(KERN_ALERT "BUG: unable to handle kernel ");
-	if (address < PAGE_SIZE)
-		printk(KERN_CONT "NULL pointer dereference");
-	else
-		printk(KERN_CONT "paging request");
