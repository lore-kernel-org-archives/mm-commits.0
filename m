From: akpm@linux-foundation.org
Subject: [merged] powerpc-mm-add-pd_leaf-definitions.patch removed
 from -mm tree
Date: Tue, 04 Feb 2020 10:41:06 -0800
Message-ID: <20200204184106.Pbp6EuTVs%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:57020 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727480AbgBDSlJ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 4 Feb 2020 13:41:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alex@ghiti.fr, aou@eecs.berkeley.edu, ard.biesheuvel@linaro.org, arnd@arndb.de, benh@kernel.crashing.org, borntraeger@de.ibm.com, bp@alien8.de, catalin.marinas@arm.com, dave.hansen@linux.intel.com, davem@davemloft.net, gor@linux.ibm.com, heiko.carstens@de.ibm.com, hpa@zytor.com, james.morse@arm.com, jglisse@redhat.com, jhogan@kernel.org, kan.liang@linux.intel.com, linux@armlinux.org.uk, luto@kernel.org, mark.rutland@arm.com, mingo@redhat.com, mm-commits@vger.kernel.org, mpe@ellerman.id.au, paul.burton@mips.com, paul.walmsley@sifive.com, paulus@samba.org, peterz@infradead.org, ralf@linux-mips.org, steven.price@arm.com, tglx@linutronix.de, vgupta@synopsys.com, will@kernel.org, zong.li@sifive.com


The patch titled
     Subject: powerpc: mm: add p?d_leaf() definitions
has been removed from the -mm tree.  Its filename was
     powerpc-mm-add-pd_leaf-definitions.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Steven Price <steven.price@arm.com>
Subject: powerpc: mm: add p?d_leaf() definitions

walk_page_range() is going to be allowed to walk page tables other than
those of user space.  For this it needs to know when it has reached a
'leaf' entry in the page tables.  This information is provided by the
p?d_leaf() functions/macros.

For powerpc p?d_is_leaf() functions already exist.  Export them using the
new p?d_leaf() name.

Link: http://lkml.kernel.org/r/20191218162402.45610-7-steven.price@arm.com
Signed-off-by: Steven Price <steven.price@arm.com>
Acked-by: Michael Ellerman <mpe@ellerman.id.au>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Alexandre Ghiti <alex@ghiti.fr>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: James Hogan <jhogan@kernel.org>
Cc: James Morse <james.morse@arm.com>
Cc: Jerome Glisse <jglisse@redhat.com>
Cc: "Liang, Kan" <kan.liang@linux.intel.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Paul Burton <paul.burton@mips.com>
Cc: Paul Walmsley <paul.walmsley@sifive.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Russell King <linux@armlinux.org.uk>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Vineet Gupta <vgupta@synopsys.com>
Cc: Will Deacon <will@kernel.org>
Cc: Zong Li <zong.li@sifive.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/include/asm/book3s/64/pgtable.h |    3 +++
 1 file changed, 3 insertions(+)

--- a/arch/powerpc/include/asm/book3s/64/pgtable.h~powerpc-mm-add-pd_leaf-definitions
+++ a/arch/powerpc/include/asm/book3s/64/pgtable.h
@@ -1355,18 +1355,21 @@ static inline bool is_pte_rw_upgrade(uns
  * Like pmd_huge() and pmd_large(), but works regardless of config options
  */
 #define pmd_is_leaf pmd_is_leaf
+#define pmd_leaf pmd_is_leaf
 static inline bool pmd_is_leaf(pmd_t pmd)
 {
 	return !!(pmd_raw(pmd) & cpu_to_be64(_PAGE_PTE));
 }
 
 #define pud_is_leaf pud_is_leaf
+#define pud_leaf pud_is_leaf
 static inline bool pud_is_leaf(pud_t pud)
 {
 	return !!(pud_raw(pud) & cpu_to_be64(_PAGE_PTE));
 }
 
 #define pgd_is_leaf pgd_is_leaf
+#define pgd_leaf pgd_is_leaf
 static inline bool pgd_is_leaf(pgd_t pgd)
 {
 	return !!(pgd_raw(pgd) & cpu_to_be64(_PAGE_PTE));
_

Patches currently in -mm which might be from steven.price@arm.com are
