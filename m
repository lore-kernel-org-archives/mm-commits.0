From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 30/67] riscv: mm: add p?d_leaf() definitions
Date: Mon, 03 Feb 2020 17:35:28 -0800
Message-ID: <20200204013528.5zuUm6D8c%akpm@linux-foundation.org>
References: <20200203173311.6269a8be06a05e5a4aa08a93@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:34754 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727148AbgBDBfc (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 3 Feb 2020 20:35:32 -0500
In-Reply-To: <20200203173311.6269a8be06a05e5a4aa08a93@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, alex@ghiti.fr, aou@eecs.berkeley.edu, ard.biesheuvel@linaro.org, arnd@arndb.de, benh@kernel.crashing.org, borntraeger@de.ibm.com, bp@alien8.de, catalin.marinas@arm.com, dave.hansen@linux.intel.com, davem@davemloft.net, gor@linux.ibm.com, heiko.carstens@de.ibm.com, hpa@zytor.com, james.morse@arm.com, jglisse@redhat.com, jhogan@kernel.org, kan.liang@linux.intel.com, linux-mm@kvack.org, linux@armlinux.org.uk, luto@kernel.org, mark.rutland@arm.com, mingo@redhat.com, mm-commits@vger.kernel.org, mpe@ellerman.id.au, paul.burton@mips.com, paul.walmsley@sifive.com, paulus@samba.org, peterz@infradead.org, ralf@linux-mips.org, steven.price@arm.com, tglx@linutronix.de, torvalds@linux-foundation.org, vgupta@synopsys.com, will@kernel.org, zong.li@sifive.com

From: Steven Price <steven.price@arm.com>
Subject: riscv: mm: add p?d_leaf() definitions

walk_page_range() is going to be allowed to walk page tables other than
those of user space.  For this it needs to know when it has reached a
'leaf' entry in the page tables.  This information is provided by the
p?d_leaf() functions/macros.

For riscv a page is a leaf page when it has a read, write or execute bit
set on it.

Link: http://lkml.kernel.org/r/20191218162402.45610-8-steven.price@arm.com
Signed-off-by: Steven Price <steven.price@arm.com>
Reviewed-by: Alexandre Ghiti <alex@ghiti.fr>
Reviewed-by: Zong Li <zong.li@sifive.com>
Acked-by: Paul Walmsley <paul.walmsley@sifive.com>	[arch/riscv]
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
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
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Paul Burton <paul.burton@mips.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Russell King <linux@armlinux.org.uk>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Vineet Gupta <vgupta@synopsys.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/riscv/include/asm/pgtable-64.h |    7 +++++++
 arch/riscv/include/asm/pgtable.h    |    7 +++++++
 2 files changed, 14 insertions(+)

--- a/arch/riscv/include/asm/pgtable-64.h~riscv-mm-add-pd_leaf-definitions
+++ a/arch/riscv/include/asm/pgtable-64.h
@@ -43,6 +43,13 @@ static inline int pud_bad(pud_t pud)
 	return !pud_present(pud);
 }
 
+#define pud_leaf	pud_leaf
+static inline int pud_leaf(pud_t pud)
+{
+	return pud_present(pud) &&
+	       (pud_val(pud) & (_PAGE_READ | _PAGE_WRITE | _PAGE_EXEC));
+}
+
 static inline void set_pud(pud_t *pudp, pud_t pud)
 {
 	*pudp = pud;
--- a/arch/riscv/include/asm/pgtable.h~riscv-mm-add-pd_leaf-definitions
+++ a/arch/riscv/include/asm/pgtable.h
@@ -130,6 +130,13 @@ static inline int pmd_bad(pmd_t pmd)
 	return !pmd_present(pmd);
 }
 
+#define pmd_leaf	pmd_leaf
+static inline int pmd_leaf(pmd_t pmd)
+{
+	return pmd_present(pmd) &&
+	       (pmd_val(pmd) & (_PAGE_READ | _PAGE_WRITE | _PAGE_EXEC));
+}
+
 static inline void set_pmd(pmd_t *pmdp, pmd_t pmd)
 {
 	*pmdp = pmd;
_
