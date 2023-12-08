Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EE483B297
	for <mm-commits@vger.kernel.org>; Fri,  8 Dec 2023 19:50:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="2SE2AC8h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C633C433C9;
	Fri,  8 Dec 2023 19:50:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1702065019;
	bh=iSP+OnC3UsVNdcYec71X9JBYmGR7v105XkAMs23Cp4g=;
	h=Date:To:From:Subject:From;
	b=2SE2AC8hdK1+sXYX8B28ysROAtDDVxREi/ohNSJWlOoKYQrzCrBJgkxmLmh59JV3m
	 Y88P4VUFZ1SfvCZI/9KgwJomcxMklDTA0rF8mwQGBq4l78t2ii7vpEh0cQ/v5W3zQi
	 e5w5TXHcItQ5PMmWjJDNZjcPdAEvG23cTOCs35AI=
Date: Fri, 08 Dec 2023 11:50:18 -0800
To: mm-commits@vger.kernel.org,sfr@canb.auug.org.au,lkp@intel.com,ignat@cloudflare.com,eric_devolder@yahoo.com,bhe@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + m68k-kexec-fix-the-incorrect-ifdeffery-and-build-dependency-of-config_kexec.patch added to mm-hotfixes-unstable branch
Message-Id: <20231208195019.4C633C433C9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: m68k, kexec: fix the incorrect ifdeffery and build dependency of CONFIG_KEXEC
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     m68k-kexec-fix-the-incorrect-ifdeffery-and-build-dependency-of-config_kexec.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/m68k-kexec-fix-the-incorrect-ifdeffery-and-build-dependency-of-config_kexec.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Baoquan He <bhe@redhat.com>
Subject: m68k, kexec: fix the incorrect ifdeffery and build dependency of CONFIG_KEXEC
Date: Fri, 8 Dec 2023 15:30:33 +0800

The select of KEXEC for CRASH_DUMP in kernel/Kconfig.kexec will be
dropped, then compiling errors will be triggered if below config items are
set:

===
CONFIG_CRASH_CORE=y
CONFIG_KEXEC_CORE=y
CONFIG_CRASH_DUMP=y
===

Here, change the dependency of buinding machine_kexec.o relocate_kernel.o
and the ifdeffery in asm/kexe.h to CONFIG_KEXEC_CORE.

Link: https://lkml.kernel.org/r/20231208073036.7884-3-bhe@redhat.com
Signed-off-by: Baoquan He <bhe@redhat.com>
Cc: Eric DeVolder <eric_devolder@yahoo.com>
Cc: Ignat Korchagin <ignat@cloudflare.com>
Cc: kernel test robot <lkp@intel.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/m68k/include/asm/kexec.h |    4 ++--
 arch/m68k/kernel/Makefile     |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

--- a/arch/m68k/include/asm/kexec.h~m68k-kexec-fix-the-incorrect-ifdeffery-and-build-dependency-of-config_kexec
+++ a/arch/m68k/include/asm/kexec.h
@@ -2,7 +2,7 @@
 #ifndef _ASM_M68K_KEXEC_H
 #define _ASM_M68K_KEXEC_H
 
-#ifdef CONFIG_KEXEC
+#ifdef CONFIG_KEXEC_CORE
 
 /* Maximum physical address we can use pages from */
 #define KEXEC_SOURCE_MEMORY_LIMIT (-1UL)
@@ -25,6 +25,6 @@ static inline void crash_setup_regs(stru
 
 #endif /* __ASSEMBLY__ */
 
-#endif /* CONFIG_KEXEC */
+#endif /* CONFIG_KEXEC_CORE */
 
 #endif /* _ASM_M68K_KEXEC_H */
--- a/arch/m68k/kernel/Makefile~m68k-kexec-fix-the-incorrect-ifdeffery-and-build-dependency-of-config_kexec
+++ a/arch/m68k/kernel/Makefile
@@ -25,7 +25,7 @@ obj-$(CONFIG_PCI) += pcibios.o
 
 obj-$(CONFIG_M68K_NONCOHERENT_DMA) += dma.o
 
-obj-$(CONFIG_KEXEC)		+= machine_kexec.o relocate_kernel.o
+obj-$(CONFIG_KEXEC_CORE)	+= machine_kexec.o relocate_kernel.o
 obj-$(CONFIG_BOOTINFO_PROC)	+= bootinfo_proc.o
 obj-$(CONFIG_UBOOT)		+= uboot.o
 
_

Patches currently in -mm which might be from bhe@redhat.com are

riscv-fix-vmallc_start-definition.patch
loongarch-kexec-change-dependency-of-object-files.patch
m68k-kexec-fix-the-incorrect-ifdeffery-and-build-dependency-of-config_kexec.patch
mips-kexec-fix-the-incorrect-ifdeffery-and-dependency-of-config_kexec.patch
sh-kexec-fix-the-incorrect-ifdeffery-and-dependency-of-config_kexec.patch
x86-kexec-fix-the-wrong-ifdeffery-config_kexec.patch
resource-add-walk_system_ram_res_rev.patch
kexec_file-load-kernel-at-top-of-system-ram-if-required.patch
kexec_file-add-kexec_file-flag-to-control-debug-printing.patch
kexec_file-print-out-debugging-message-if-required.patch
kexec_file-x86-print-out-debugging-message-if-required.patch
kexec_file-arm64-print-out-debugging-message-if-required.patch
kexec_file-ricv-print-out-debugging-message-if-required.patch
kexec_file-power-print-out-debugging-message-if-required.patch
kexec_file-parisc-print-out-debugging-message-if-required.patch
riscv-kexec-fix-the-ifdeffery-for-aflags_kexec_relocateo.patch

