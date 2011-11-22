From: akpm@linux-foundation.org
Subject: + fs-binfmt_elf-create-kconfig-variable-for-pie-randomization.patch added to -mm tree
Date: Tue, 22 Nov 2011 15:26:00 -0800
Message-ID: <201111222326.pAMNQ1Hq006228@wpaz5.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gx0-f202.google.com ([209.85.161.202]:59220 "EHLO
	mail-gx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752726Ab1KVX0H (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 22 Nov 2011 18:26:07 -0500
Received: by ggdk5 with SMTP id k5so149734ggd.1
        for <mm-commits@vger.kernel.org>; Tue, 22 Nov 2011 15:26:06 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ddaney.cavm@gmail.com, david.daney@cavium.com, hpa@zytor.com, linux@arm.linux.org.uk, mingo@redhat.com, ralf@linux-mips.org, tglx@linutronix.de, viro@zeniv.linux.org.uk


The patch titled
     Subject: fs: binfmt_elf: create Kconfig variable for PIE randomization
has been added to the -mm tree.  Its filename is
     fs-binfmt_elf-create-kconfig-variable-for-pie-randomization.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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
@@ -30,6 +30,7 @@ config ARM
 	select HAVE_SPARSE_IRQ
 	select GENERIC_IRQ_SHOW
 	select CPU_PM if (SUSPEND || CPU_IDLE)
+	select ARCH_BINFMT_ELF_RANDOMIZE_PIE
 	help
 	  The ARM series is a line of low-power-consumption RISC chip designs
 	  licensed by ARM Ltd and targeted at embedded applications and
diff -puN arch/x86/Kconfig~fs-binfmt_elf-create-kconfig-variable-for-pie-randomization arch/x86/Kconfig
--- a/arch/x86/Kconfig~fs-binfmt_elf-create-kconfig-variable-for-pie-randomization
+++ a/arch/x86/Kconfig
@@ -60,6 +60,7 @@ config X86
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
Subject: Subject: fs: binfmt_elf: create Kconfig variable for PIE randomization

Patches currently in -mm which might be from ddaney.cavm@gmail.com are

linux-next.patch
fs-binfmt_elf-create-kconfig-variable-for-pie-randomization.patch
mips-randomize-pie-load-address.patch

