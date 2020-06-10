From: akpm@linux-foundation.org
Subject: [merged]
 m68k-mm-motorola-move-comment-about-page-table-allocation-funcitons.patch
 removed from -mm tree
Date: Tue, 09 Jun 2020 17:38:55 -0700
Message-ID: <20200610003855.CotFy9i68%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:40684 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725963AbgFJAi6 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 9 Jun 2020 20:38:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arnd@arndb.de, bcain@codeaurora.org, bp@alien8.de, catalin.marinas@arm.com, chris@zankel.net, dalias@libc.org, davem@davemloft.net, deanbo422@gmail.com, deller@gmx.de, geert@linux-m68k.org, gerg@linux-m68k.org, green.hu@gmail.com, guoren@kernel.org, gxt@pku.edu.cn, heiko.carstens@de.ibm.com, jcmvbkbc@gmail.com, ley.foon.tan@intel.com, linux@armlinux.org.uk, mattst88@gmail.com, mingo@redhat.com, mm-commits@vger.kernel.org, monstr@monstr.eu, mpe@ellerman.id.au, msalter@redhat.com, nickhu@andestech.com, paul.walmsley@sifive.com, richard@nod.at, rppt@linux.ibm.com, shorne@gmail.com, tglx@linutronix.de, tony.luck@intel.com, tsbogend@alpha.franken.de, vgupta@synopsys.com, will@kernel.org, willy@infradead.org, ysato@users.sourceforge.jp


The patch titled
     Subject: m68k/mm/motorola: move comment about page table allocation funcitons
has been removed from the -mm tree.  Its filename was
     m68k-mm-motorola-move-comment-about-page-table-allocation-funcitons.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mike Rapoport <rppt@linux.ibm.com>
Subject: m68k/mm/motorola: move comment about page table allocation funcitons

The comment about page table allocation functions resides in
include/asm/motorola_pgtable.h while the functions live in
include/asm/motorola_pgaloc.h.

Move the comment close to the code.

Link: http://lkml.kernel.org/r/20200514170327.31389-6-rppt@kernel.org
Signed-off-by: Mike Rapoport <rppt@linux.ibm.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Brian Cain <bcain@codeaurora.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Chris Zankel <chris@zankel.net>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Greentime Hu <green.hu@gmail.com>
Cc: Greg Ungerer <gerg@linux-m68k.org>
Cc: Guan Xuetao <gxt@pku.edu.cn>
Cc: Guo Ren <guoren@kernel.org>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Helge Deller <deller@gmx.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Ley Foon Tan <ley.foon.tan@intel.com>
Cc: Mark Salter <msalter@redhat.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Matt Turner <mattst88@gmail.com>
Cc: Max Filippov <jcmvbkbc@gmail.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Michal Simek <monstr@monstr.eu>
Cc: Nick Hu <nickhu@andestech.com>
Cc: Paul Walmsley <paul.walmsley@sifive.com>
Cc: Richard Weinberger <richard@nod.at>
Cc: Rich Felker <dalias@libc.org>
Cc: Russell King <linux@armlinux.org.uk>
Cc: Stafford Horne <shorne@gmail.com>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Vincent Chen <deanbo422@gmail.com>
Cc: Vineet Gupta <vgupta@synopsys.com>
Cc: Will Deacon <will@kernel.org>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/m68k/include/asm/motorola_pgalloc.h |    6 ++++++
 arch/m68k/include/asm/motorola_pgtable.h |    6 ------
 2 files changed, 6 insertions(+), 6 deletions(-)

--- a/arch/m68k/include/asm/motorola_pgalloc.h~m68k-mm-motorola-move-comment-about-page-table-allocation-funcitons
+++ a/arch/m68k/include/asm/motorola_pgalloc.h
@@ -18,6 +18,12 @@ extern void init_pointer_table(void *tab
 extern void *get_pointer_table(int type);
 extern int free_pointer_table(void *table, int type);
 
+/*
+ * Allocate and free page tables. The xxx_kernel() versions are
+ * used to allocate a kernel page table - this turns on ASN bits
+ * if any.
+ */
+
 static inline pte_t *pte_alloc_one_kernel(struct mm_struct *mm)
 {
 	return get_pointer_table(TABLE_PTE);
--- a/arch/m68k/include/asm/motorola_pgtable.h~m68k-mm-motorola-move-comment-about-page-table-allocation-funcitons
+++ a/arch/m68k/include/asm/motorola_pgtable.h
@@ -227,12 +227,6 @@ static inline pte_t *pte_offset_kernel(p
 #define pte_offset_map(pmdp,address) ((pte_t *)__pmd_page(*pmdp) + (((address) >> PAGE_SHIFT) & (PTRS_PER_PTE - 1)))
 #define pte_unmap(pte)		((void)0)
 
-/*
- * Allocate and free page tables. The xxx_kernel() versions are
- * used to allocate a kernel page table - this turns on ASN bits
- * if any.
- */
