From: akpm@linux-foundation.org
Subject: [merged] arm64-initialize-pgprot-info-earlier-in-boot.patch
 removed from -mm tree
Date: Tue, 08 Apr 2014 14:51:29 -0700
Message-ID: <53446f61.zHoevB8ozpN8tXEA%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57337 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756713AbaDHVva (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Apr 2014 17:51:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, will.deacon@arm.com, tglx@linutronix.de, mingo@elte.hu, hpa@zytor.com, dyoung@redhat.com, catalin.marinas@arm.com, borislav.petkov@amd.com, msalter@redhat.com

Subject: [merged] arm64-initialize-pgprot-info-earlier-in-boot.patch removed from -mm tree
To: msalter@redhat.com,borislav.petkov@amd.com,catalin.marinas@arm.com,dyoung@redhat.com,hpa@zytor.com,mingo@elte.hu,tglx@linutronix.de,will.deacon@arm.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 08 Apr 2014 14:51:29 -0700


The patch titled
     Subject: arm64: initialize pgprot info earlier in boot
has been removed from the -mm tree.  Its filename was
     arm64-initialize-pgprot-info-earlier-in-boot.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mark Salter <msalter@redhat.com>
Subject: arm64: initialize pgprot info earlier in boot

Presently, paging_init() calls init_mem_pgprot() to initialize pgprot
values used by macros such as PAGE_KERNEL, PAGE_KERNEL_EXEC, etc.  The new
fixmap and early_ioremap support also needs to use these macros before
paging_init() is called.  This patch moves the init_mem_pgprot() call out
of paging_init() and into setup_arch() so that pgprot_default gets
initialized in time for fixmap and early_ioremap.

Signed-off-by: Mark Salter <msalter@redhat.com>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Borislav Petkov <borislav.petkov@amd.com>
Cc: Dave Young <dyoung@redhat.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/include/asm/mmu.h |    1 +
 arch/arm64/kernel/setup.c    |    2 ++
 arch/arm64/mm/mmu.c          |    3 +--
 3 files changed, 4 insertions(+), 2 deletions(-)

diff -puN arch/arm64/include/asm/mmu.h~arm64-initialize-pgprot-info-earlier-in-boot arch/arm64/include/asm/mmu.h
--- a/arch/arm64/include/asm/mmu.h~arm64-initialize-pgprot-info-earlier-in-boot
+++ a/arch/arm64/include/asm/mmu.h
@@ -27,5 +27,6 @@ typedef struct {
 extern void paging_init(void);
 extern void setup_mm_for_reboot(void);
 extern void __iomem *early_io_map(phys_addr_t phys, unsigned long virt);
+extern void init_mem_pgprot(void);
 
 #endif
diff -puN arch/arm64/kernel/setup.c~arm64-initialize-pgprot-info-earlier-in-boot arch/arm64/kernel/setup.c
--- a/arch/arm64/kernel/setup.c~arm64-initialize-pgprot-info-earlier-in-boot
+++ a/arch/arm64/kernel/setup.c
@@ -360,6 +360,8 @@ void __init setup_arch(char **cmdline_p)
 
 	*cmdline_p = boot_command_line;
 
+	init_mem_pgprot();
+
 	parse_early_param();
 
 	arm64_memblock_init();
diff -puN arch/arm64/mm/mmu.c~arm64-initialize-pgprot-info-earlier-in-boot arch/arm64/mm/mmu.c
--- a/arch/arm64/mm/mmu.c~arm64-initialize-pgprot-info-earlier-in-boot
+++ a/arch/arm64/mm/mmu.c
@@ -125,7 +125,7 @@ early_param("cachepolicy", early_cachepo
 /*
  * Adjust the PMD section entries according to the CPU in use.
  */
-static void __init init_mem_pgprot(void)
+void __init init_mem_pgprot(void)
 {
 	pteval_t default_pgprot;
 	int i;
@@ -357,7 +357,6 @@ void __init paging_init(void)
 {
 	void *zero_page;
 
-	init_mem_pgprot();
 	map_mem();
 
 	/*
_

Patches currently in -mm which might be from msalter@redhat.com are

origin.patch

