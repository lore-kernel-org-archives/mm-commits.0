From: akpm@linux-foundation.org
Subject: - x86-initial-fixmap-support.patch removed from -mm tree
Date: Mon, 16 Jul 2007 13:48:32 -0700
Message-ID: <200707162048.l6GKmWEI001066@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48883 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758020AbXGPUss (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 16 Jul 2007 16:48:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ebiderman@xmission.com, ak@suse.de, bjorn.helgaas@hp.com, ebiderman@xmisson.com, kraxel@suse.de, rmk@arm.linux.org.uk, yinghai.lu@sun.com, mm-commits@vger.kernel.org


The patch titled
     x86: initial fixmap support
has been removed from the -mm tree.  Its filename was
     x86-initial-fixmap-support.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: x86: initial fixmap support
From: Eric W. Biderman <ebiderman@xmission.com>

Needed to get fixed virtual address for USB debug and earlycon with mmio.

Signed-off-by: Eric W. Biderman <ebiderman@xmisson.com>
Signed-off-by: Yinghai Lu <yinghai.lu@sun.com>
Cc: Andi Kleen <ak@suse.de>
Cc: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Russell King <rmk@arm.linux.org.uk>
Cc: Gerd Hoffmann <kraxel@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/head.S   |    8 ++++++++
 arch/x86_64/kernel/head.S |   15 ++++++++++++++-
 2 files changed, 22 insertions(+), 1 deletion(-)

diff -puN arch/i386/kernel/head.S~x86-initial-fixmap-support arch/i386/kernel/head.S
--- a/arch/i386/kernel/head.S~x86-initial-fixmap-support
+++ a/arch/i386/kernel/head.S
@@ -168,6 +168,12 @@ page_pde_offset = (__PAGE_OFFSET >> 20);
 .section .init.text,"ax",@progbits
 #endif
 
+	/* Do an early initialization of the fixmap area */
+	movl $(swapper_pg_dir - __PAGE_OFFSET), %edx
+	movl $(swapper_pg_pmd - __PAGE_OFFSET), %eax
+	addl $0x007, %eax			/* 0x007 = PRESENT+RW+USER */
+	movl %eax, 4092(%edx)
+
 #ifdef CONFIG_SMP
 ENTRY(startup_32_smp)
 	cld
@@ -507,6 +513,8 @@ ENTRY(_stext)
 .section ".bss.page_aligned","w"
 ENTRY(swapper_pg_dir)
 	.fill 1024,4,0
+ENTRY(swapper_pg_pmd)
+	.fill 1024,4,0
 ENTRY(empty_zero_page)
 	.fill 4096,1,0
 
diff -puN arch/x86_64/kernel/head.S~x86-initial-fixmap-support arch/x86_64/kernel/head.S
--- a/arch/x86_64/kernel/head.S~x86-initial-fixmap-support
+++ a/arch/x86_64/kernel/head.S
@@ -73,7 +73,11 @@ startup_64:
 	addq	%rbp, init_level4_pgt + (511*8)(%rip)
 
 	addq	%rbp, level3_ident_pgt + 0(%rip)
+
 	addq	%rbp, level3_kernel_pgt + (510*8)(%rip)
+	addq	%rbp, level3_kernel_pgt + (511*8)(%rip)
+
+	addq	%rbp, level2_fixmap_pgt + (506*8)(%rip)
 
 	/* Add an Identity mapping if I am above 1G */
 	leaq	_text(%rip), %rdi
@@ -314,7 +318,16 @@ NEXT_PAGE(level3_kernel_pgt)
 	.fill	510,8,0
 	/* (2^48-(2*1024*1024*1024)-((2^39)*511))/(2^30) = 510 */
 	.quad	level2_kernel_pgt - __START_KERNEL_map + _KERNPG_TABLE
-	.fill	1,8,0
+	.quad	level2_fixmap_pgt - __START_KERNEL_map + _PAGE_TABLE
+
+NEXT_PAGE(level2_fixmap_pgt)
+	.fill	506,8,0
+	.quad	level1_fixmap_pgt - __START_KERNEL_map + _PAGE_TABLE
+	/* 8MB reserved for vsyscalls + a 2MB hole = 4 + 1 entries */
+	.fill	5,8,0
+
+NEXT_PAGE(level1_fixmap_pgt)
+	.fill	512,8,0
 
 NEXT_PAGE(level2_ident_pgt)
 	/* Since I easily can, map the first 1G.
_

Patches currently in -mm which might be from ebiderman@xmission.com are

origin.patch
