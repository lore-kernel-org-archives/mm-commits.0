From: akpm@linux-foundation.org
Subject: [merged]
 x86-mmefi-convert-ptdump_walk_pgd_level-to-take-a-mm_struct.patch removed
 from -mm tree
Date: Tue, 04 Feb 2020 10:41:36 -0800
Message-ID: <20200204184136.ckEyXbmeW%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:57852 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727480AbgBDSlj (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 4 Feb 2020 13:41:39 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alex@ghiti.fr, aou@eecs.berkeley.edu, ard.biesheuvel@linaro.org, arnd@arndb.de, benh@kernel.crashing.org, borntraeger@de.ibm.com, bp@alien8.de, catalin.marinas@arm.com, dave.hansen@linux.intel.com, davem@davemloft.net, gor@linux.ibm.com, heiko.carstens@de.ibm.com, hpa@zytor.com, james.morse@arm.com, jglisse@redhat.com, jhogan@kernel.org, kan.liang@linux.intel.com, linux@armlinux.org.uk, luto@kernel.org, mark.rutland@arm.com, mingo@redhat.com, mm-commits@vger.kernel.org, mpe@ellerman.id.au, paul.burton@mips.com, paul.walmsley@sifive.com, paulus@samba.org, peterz@infradead.org, ralf@linux-mips.org, steven.price@arm.com, tglx@linutronix.de, vgupta@synopsys.com, will@kernel.org, zong.li@sifive.com


The patch titled
     Subject: x86: mm+efi: convert ptdump_walk_pgd_level() to take a mm_struct
has been removed from the -mm tree.  Its filename was
     x86-mmefi-convert-ptdump_walk_pgd_level-to-take-a-mm_struct.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Steven Price <steven.price@arm.com>
Subject: x86: mm+efi: convert ptdump_walk_pgd_level() to take a mm_struct

To enable x86 to use the generic walk_page_range() function, the callers
of ptdump_walk_pgd_level() need to pass an mm_struct rather than the raw
pgd_t pointer.  Luckily since commit 7e904a91bf60 ("efi: Use efi_mm in x86
as well as ARM") we now have an mm_struct for EFI on x86.

Link: http://lkml.kernel.org/r/20191218162402.45610-18-steven.price@arm.com
Signed-off-by: Steven Price <steven.price@arm.com>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Alexandre Ghiti <alex@ghiti.fr>
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

 arch/x86/include/asm/pgtable.h |    2 +-
 arch/x86/mm/dump_pagetables.c  |    4 ++--
 arch/x86/platform/efi/efi_32.c |    2 +-
 arch/x86/platform/efi/efi_64.c |    4 ++--
 4 files changed, 6 insertions(+), 6 deletions(-)

--- a/arch/x86/include/asm/pgtable.h~x86-mmefi-convert-ptdump_walk_pgd_level-to-take-a-mm_struct
+++ a/arch/x86/include/asm/pgtable.h
@@ -29,7 +29,7 @@
 extern pgd_t early_top_pgt[PTRS_PER_PGD];
 int __init __early_make_pgtable(unsigned long address, pmdval_t pmd);
 
-void ptdump_walk_pgd_level(struct seq_file *m, pgd_t *pgd);
+void ptdump_walk_pgd_level(struct seq_file *m, struct mm_struct *mm);
 void ptdump_walk_pgd_level_debugfs(struct seq_file *m, pgd_t *pgd, bool user);
 void ptdump_walk_pgd_level_checkwx(void);
 void ptdump_walk_user_pgd_level_checkwx(void);
--- a/arch/x86/mm/dump_pagetables.c~x86-mmefi-convert-ptdump_walk_pgd_level-to-take-a-mm_struct
+++ a/arch/x86/mm/dump_pagetables.c
@@ -567,9 +567,9 @@ static void ptdump_walk_pgd_level_core(s
 		pr_info("x86/mm: Checked W+X mappings: passed, no W+X pages found.\n");
 }
 
-void ptdump_walk_pgd_level(struct seq_file *m, pgd_t *pgd)
+void ptdump_walk_pgd_level(struct seq_file *m, struct mm_struct *mm)
 {
-	ptdump_walk_pgd_level_core(m, pgd, false, true);
+	ptdump_walk_pgd_level_core(m, mm->pgd, false, true);
 }
 
 void ptdump_walk_pgd_level_debugfs(struct seq_file *m, pgd_t *pgd, bool user)
--- a/arch/x86/platform/efi/efi_32.c~x86-mmefi-convert-ptdump_walk_pgd_level-to-take-a-mm_struct
+++ a/arch/x86/platform/efi/efi_32.c
@@ -49,7 +49,7 @@ void efi_sync_low_kernel_mappings(void)
 void __init efi_dump_pagetable(void)
 {
 #ifdef CONFIG_EFI_PGT_DUMP
-	ptdump_walk_pgd_level(NULL, swapper_pg_dir);
+	ptdump_walk_pgd_level(NULL, &init_mm);
 #endif
 }
 
--- a/arch/x86/platform/efi/efi_64.c~x86-mmefi-convert-ptdump_walk_pgd_level-to-take-a-mm_struct
+++ a/arch/x86/platform/efi/efi_64.c
@@ -471,9 +471,9 @@ void __init efi_dump_pagetable(void)
 {
 #ifdef CONFIG_EFI_PGT_DUMP
 	if (efi_have_uv1_memmap())
-		ptdump_walk_pgd_level(NULL, swapper_pg_dir);
+		ptdump_walk_pgd_level(NULL, &init_mm);
 	else
-		ptdump_walk_pgd_level(NULL, efi_mm.pgd);
+		ptdump_walk_pgd_level(NULL, &efi_mm);
 #endif
 }
 
_

Patches currently in -mm which might be from steven.price@arm.com are
