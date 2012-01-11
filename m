From: akpm@linux-foundation.org
Subject: [merged] fs-binfmt_elf-create-kconfig-variable-for-pie-randomization.patch removed from -mm tree
Date: Wed, 11 Jan 2012 13:31:50 -0800
Message-ID: <20120111213150.C377E1E004D@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gx0-f202.google.com ([209.85.161.202]:61363 "EHLO
	mail-gx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753124Ab2AKVbv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 11 Jan 2012 16:31:51 -0500
Received: by mail-gx0-f202.google.com with SMTP id k3so134903ggn.1
        for <mm-commits@vger.kernel.org>; Wed, 11 Jan 2012 13:31:51 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ddaney.cavm@gmail.com, david.daney@cavium.com, hpa@zytor.com, linux@arm.linux.org.uk, mingo@redhat.com, ralf@linux-mips.org, tglx@linutronix.de, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: fs: binfmt_elf: create Kconfig variable for PIE randomization
has been removed from the -mm tree.  Its filename was
     fs-binfmt_elf-create-kconfig-variable-for-pie-randomization.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: David Daney <ddaney.cavm@gmail.com>
Subject: fs: binfmt_elf: create Kconfig variable for PIE randomization

Randomization of PIE load address is hard coded in binfmt_elf.c for X86
and ARM.  Create a new Kconfig variable
(CONFIG_ARCH_BINFMT_ELF_RANDOMIZE_PIE) for this and use it instead.  Thus
architecture specific policy is pushed out of the generic binfmt_elf.c and
into the architecture Kconfig files.

X86 and ARM Kconfigs are modified to select the new variable so there is
no change in behavior.  A follow on patch will select it for MIPS too.

Signed-off-by: David Daney <david.daney@cavium.com>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Acked-by: H. Peter Anvin <hpa@zytor.com>
Cc: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/Kconfig  |    1 +
 arch/x86/Kconfig  |    1 +
 fs/Kconfig.binfmt |    3 +++
 fs/binfmt_elf.c   |    2 +-
 4 files changed, 6 insertions(+), 1 deletion(-)

diff -puN arch/arm/Kconfig~fs-binfmt_elf-create-kconfig-variable-for-pie-randomization arch/arm/Kconfig
--- a/arch/arm/Kconfig~fs-binfmt_elf-create-kconfig-variable-for-pie-randomization
+++ a/arch/arm/Kconfig
@@ -16,6 +16,7 @@ config ARM
 	select HAVE_FTRACE_MCOUNT_RECORD if (!XIP_KERNEL)
 	select HAVE_DYNAMIC_FTRACE if (!XIP_KERNEL)
 	select HAVE_FUNCTION_GRAPH_TRACER if (!THUMB2_KERNEL)
+	select ARCH_BINFMT_ELF_RANDOMIZE_PIE
 	select HAVE_GENERIC_DMA_COHERENT
 	select HAVE_KERNEL_GZIP
 	select HAVE_KERNEL_LZO
diff -puN arch/x86/Kconfig~fs-binfmt_elf-create-kconfig-variable-for-pie-randomization arch/x86/Kconfig
--- a/arch/x86/Kconfig~fs-binfmt_elf-create-kconfig-variable-for-pie-randomization
+++ a/arch/x86/Kconfig
@@ -62,6 +62,7 @@ config X86
 	select ANON_INODES
 	select HAVE_ARCH_KMEMCHECK
 	select HAVE_USER_RETURN_NOTIFIER
+	select ARCH_BINFMT_ELF_RANDOMIZE_PIE
 	select HAVE_ARCH_JUMP_LABEL
 	select HAVE_TEXT_POKE_SMP
 	select HAVE_GENERIC_HARDIRQS
diff -puN fs/Kconfig.binfmt~fs-binfmt_elf-create-kconfig-variable-for-pie-randomization fs/Kconfig.binfmt
--- a/fs/Kconfig.binfmt~fs-binfmt_elf-create-kconfig-variable-for-pie-randomization
+++ a/fs/Kconfig.binfmt
@@ -27,6 +27,9 @@ config COMPAT_BINFMT_ELF
 	bool
 	depends on COMPAT && BINFMT_ELF
 
+config ARCH_BINFMT_ELF_RANDOMIZE_PIE
+	bool
+
 config BINFMT_ELF_FDPIC
 	bool "Kernel support for FDPIC ELF binaries"
 	default y
diff -puN fs/binfmt_elf.c~fs-binfmt_elf-create-kconfig-variable-for-pie-randomization fs/binfmt_elf.c
--- a/fs/binfmt_elf.c~fs-binfmt_elf-create-kconfig-variable-for-pie-randomization
+++ a/fs/binfmt_elf.c
@@ -794,7 +794,7 @@ static int load_elf_binary(struct linux_
 			 * default mmap base, as well as whatever program they
 			 * might try to exec.  This is because the brk will
 			 * follow the loader, and is not movable.  */
-#if defined(CONFIG_X86) || defined(CONFIG_ARM)
+#ifdef CONFIG_ARCH_BINFMT_ELF_RANDOMIZE_PIE
 			/* Memory randomization might have been switched off
 			 * in runtime via sysctl.
 			 * If that is the case, retain the original non-zero
_

Patches currently in -mm which might be from ddaney.cavm@gmail.com are

origin.patch
linux-next.patch

