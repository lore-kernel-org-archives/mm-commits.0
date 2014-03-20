From: akpm@linux-foundation.org
Subject: [merged] mips-replace-config_mips64-and-config_mips32_r2.patch
 removed from -mm tree
Date: Thu, 20 Mar 2014 12:42:34 -0700
Message-ID: <532b44aa.jN7Qz4JGtVSXFLEY%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33450 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933089AbaCTTmf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 20 Mar 2014 15:42:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, ralf@linux-mips.org, paul.burton@imgtec.com, linux@roeck-us.net, chenhc@lemote.com, aba@ayous.org, aaro.koskinen@iki.fi, pebolle@tiscali.nl

Subject: [merged] mips-replace-config_mips64-and-config_mips32_r2.patch removed from -mm tree
To: pebolle@tiscali.nl,aaro.koskinen@iki.fi,aba@ayous.org,chenhc@lemote.com,linux@roeck-us.net,paul.burton@imgtec.com,ralf@linux-mips.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 20 Mar 2014 12:42:34 -0700


The patch titled
     Subject: mips: replace CONFIG_MIPS64 and CONFIG_MIPS32_R2
has been removed from the -mm tree.  Its filename was
     mips-replace-config_mips64-and-config_mips32_r2.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Paul Bolle <pebolle@tiscali.nl>
Subject: mips: replace CONFIG_MIPS64 and CONFIG_MIPS32_R2

Commit 597ce1723e0f ("MIPS: Support for 64-bit FP with O32 binaries")
introduced references to two undefined Kconfig macros.  CONFIG_MIPS32_R2
should clearly be replaced with CONFIG_CPU_MIPS32_R2.  And CONFIG_MIPS64
should apparently be replaced with CONFIG_64BIT.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
Signed-off-by: Huacai Chen <chenhc@lemote.com>
Tested-by: Aaro Koskinen <aaro.koskinen@iki.fi>
Signed-off-by: Aaro Koskinen <aaro.koskinen@iki.fi>
Tested-by: Guenter Roeck <linux@roeck-us.net>
Cc: Paul Burton <paul.burton@imgtec.com>
Cc: Andreas Barth <aba@ayous.org>
Cc: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mips/include/asm/asmmacro.h |    4 ++--
 arch/mips/include/asm/fpu.h      |    2 +-
 arch/mips/kernel/r4k_fpu.S       |    8 ++++----
 3 files changed, 7 insertions(+), 7 deletions(-)

diff -puN arch/mips/include/asm/asmmacro.h~mips-replace-config_mips64-and-config_mips32_r2 arch/mips/include/asm/asmmacro.h
--- a/arch/mips/include/asm/asmmacro.h~mips-replace-config_mips64-and-config_mips32_r2
+++ a/arch/mips/include/asm/asmmacro.h
@@ -106,7 +106,7 @@
 	.endm
 
 	.macro	fpu_save_double thread status tmp
-#if defined(CONFIG_MIPS64) || defined(CONFIG_CPU_MIPS32_R2)
+#if defined(CONFIG_64BIT) || defined(CONFIG_CPU_MIPS32_R2)
 	sll	\tmp, \status, 5
 	bgez	\tmp, 10f
 	fpu_save_16odd \thread
@@ -159,7 +159,7 @@
 	.endm
 
 	.macro	fpu_restore_double thread status tmp
-#if defined(CONFIG_MIPS64) || defined(CONFIG_CPU_MIPS32_R2)
+#if defined(CONFIG_64BIT) || defined(CONFIG_CPU_MIPS32_R2)
 	sll	\tmp, \status, 5
 	bgez	\tmp, 10f				# 16 register mode?
 
diff -puN arch/mips/include/asm/fpu.h~mips-replace-config_mips64-and-config_mips32_r2 arch/mips/include/asm/fpu.h
--- a/arch/mips/include/asm/fpu.h~mips-replace-config_mips64-and-config_mips32_r2
+++ a/arch/mips/include/asm/fpu.h
@@ -57,7 +57,7 @@ static inline int __enable_fpu(enum fpu_
 		return 0;
 
 	case FPU_64BIT:
-#if !(defined(CONFIG_CPU_MIPS32_R2) || defined(CONFIG_MIPS64))
+#if !(defined(CONFIG_CPU_MIPS32_R2) || defined(CONFIG_64BIT))
 		/* we only have a 32-bit FPU */
 		return SIGFPE;
 #endif
diff -puN arch/mips/kernel/r4k_fpu.S~mips-replace-config_mips64-and-config_mips32_r2 arch/mips/kernel/r4k_fpu.S
--- a/arch/mips/kernel/r4k_fpu.S~mips-replace-config_mips64-and-config_mips32_r2
+++ a/arch/mips/kernel/r4k_fpu.S
@@ -35,9 +35,9 @@
 LEAF(_save_fp_context)
 	cfc1	t1, fcr31
 
-#if defined(CONFIG_64BIT) || defined(CONFIG_MIPS32_R2)
+#if defined(CONFIG_64BIT) || defined(CONFIG_CPU_MIPS32_R2)
 	.set	push
-#ifdef CONFIG_MIPS32_R2
+#ifdef CONFIG_CPU_MIPS32_R2
 	.set	mips64r2
 	mfc0	t0, CP0_STATUS
 	sll	t0, t0, 5
@@ -148,9 +148,9 @@ LEAF(_save_fp_context32)
 LEAF(_restore_fp_context)
 	EX	lw t0, SC_FPC_CSR(a0)
 
-#if defined(CONFIG_64BIT) || defined(CONFIG_MIPS32_R2)
+#if defined(CONFIG_64BIT) || defined(CONFIG_CPU_MIPS32_R2)
 	.set	push
-#ifdef CONFIG_MIPS32_R2
+#ifdef CONFIG_CPU_MIPS32_R2
 	.set	mips64r2
 	mfc0	t0, CP0_STATUS
 	sll	t0, t0, 5
_

Patches currently in -mm which might be from pebolle@tiscali.nl are

origin.patch
maintainers-update-ibm-serveraid-raid-info.patch
maintainers-mark-superh-orphan.patch
linux-next.patch

