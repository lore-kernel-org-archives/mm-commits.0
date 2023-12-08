Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AB5F5025D
	for <mm-commits@vger.kernel.org>; Fri,  8 Dec 2023 19:50:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="yKX0xTQs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E6B7C433C8;
	Fri,  8 Dec 2023 19:50:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1702065025;
	bh=dc3V8YEUK8MO1VdE/8OB8wimYQeBAQZU4B32D+tPaDE=;
	h=Date:To:From:Subject:From;
	b=yKX0xTQsX/oLJ/g9np369+377hxX8QiQxZe9hoNxQAYRq6VzDyGXxHBRErFpFSbNf
	 5eRJ4/ms41pjSEYpR+ZqwGB85HuYDxzpi6tPzsVtu3FrRVkZT2VDoEA6lbKIkxl4zK
	 d8lCWYRGRaSVNkpVqVCOQjKpYjHgillvh5+2DoAs=
Date: Fri, 08 Dec 2023 11:50:24 -0800
To: mm-commits@vger.kernel.org,sfr@canb.auug.org.au,lkp@intel.com,ignat@cloudflare.com,eric_devolder@yahoo.com,bhe@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + sh-kexec-fix-the-incorrect-ifdeffery-and-dependency-of-config_kexec.patch added to mm-hotfixes-unstable branch
Message-Id: <20231208195025.8E6B7C433C8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: sh, kexec: fix the incorrect ifdeffery and dependency of CONFIG_KEXEC
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     sh-kexec-fix-the-incorrect-ifdeffery-and-dependency-of-config_kexec.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/sh-kexec-fix-the-incorrect-ifdeffery-and-dependency-of-config_kexec.patch

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
Subject: sh, kexec: fix the incorrect ifdeffery and dependency of CONFIG_KEXEC
Date: Fri, 8 Dec 2023 15:30:35 +0800

The select of KEXEC for CRASH_DUMP in kernel/Kconfig.kexec will be
dropped, then compiling errors will be triggered if below config
items are set:

===
CONFIG_CRASH_CORE=y
CONFIG_KEXEC_CORE=y
CONFIG_CRASH_DUMP=y
===

Here, change the dependency of building kexec_core related object files,
and the ifdeffery on SuperH from CONFIG_KEXEC to CONFIG_KEXEC_CORE.

Link: https://lkml.kernel.org/r/20231208073036.7884-5-bhe@redhat.com
Signed-off-by: Baoquan He <bhe@redhat.com>
Cc: Eric DeVolder <eric_devolder@yahoo.com>
Cc: Ignat Korchagin <ignat@cloudflare.com>
Cc: kernel test robot <lkp@intel.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sh/include/asm/kexec.h |    4 ++--
 arch/sh/kernel/Makefile     |    2 +-
 arch/sh/kernel/reboot.c     |    4 ++--
 arch/sh/kernel/setup.c      |    2 +-
 4 files changed, 6 insertions(+), 6 deletions(-)

--- a/arch/sh/include/asm/kexec.h~sh-kexec-fix-the-incorrect-ifdeffery-and-dependency-of-config_kexec
+++ a/arch/sh/include/asm/kexec.h
@@ -28,7 +28,7 @@
 /* The native architecture */
 #define KEXEC_ARCH KEXEC_ARCH_SH
 
-#ifdef CONFIG_KEXEC
+#ifdef CONFIG_KEXEC_CORE
 /* arch/sh/kernel/machine_kexec.c */
 void reserve_crashkernel(void);
 
@@ -67,6 +67,6 @@ static inline void crash_setup_regs(stru
 }
 #else
 static inline void reserve_crashkernel(void) { }
-#endif /* CONFIG_KEXEC */
+#endif /* CONFIG_KEXEC_CORE */
 
 #endif /* __ASM_SH_KEXEC_H */
--- a/arch/sh/kernel/Makefile~sh-kexec-fix-the-incorrect-ifdeffery-and-dependency-of-config_kexec
+++ a/arch/sh/kernel/Makefile
@@ -33,7 +33,7 @@ obj-$(CONFIG_SMP)		+= smp.o
 obj-$(CONFIG_SH_STANDARD_BIOS)	+= sh_bios.o
 obj-$(CONFIG_KGDB)		+= kgdb.o
 obj-$(CONFIG_MODULES)		+= sh_ksyms_32.o module.o
-obj-$(CONFIG_KEXEC)		+= machine_kexec.o relocate_kernel.o
+obj-$(CONFIG_KEXEC_CORE)	+= machine_kexec.o relocate_kernel.o
 obj-$(CONFIG_CRASH_DUMP)	+= crash_dump.o
 obj-$(CONFIG_STACKTRACE)	+= stacktrace.o
 obj-$(CONFIG_IO_TRAPPED)	+= io_trapped.o
--- a/arch/sh/kernel/reboot.c~sh-kexec-fix-the-incorrect-ifdeffery-and-dependency-of-config_kexec
+++ a/arch/sh/kernel/reboot.c
@@ -63,7 +63,7 @@ struct machine_ops machine_ops = {
 	.shutdown	= native_machine_shutdown,
 	.restart	= native_machine_restart,
 	.halt		= native_machine_halt,
-#ifdef CONFIG_KEXEC
+#ifdef CONFIG_KEXEC_CORE
 	.crash_shutdown = native_machine_crash_shutdown,
 #endif
 };
@@ -88,7 +88,7 @@ void machine_halt(void)
 	machine_ops.halt();
 }
 
-#ifdef CONFIG_KEXEC
+#ifdef CONFIG_KEXEC_CORE
 void machine_crash_shutdown(struct pt_regs *regs)
 {
 	machine_ops.crash_shutdown(regs);
--- a/arch/sh/kernel/setup.c~sh-kexec-fix-the-incorrect-ifdeffery-and-dependency-of-config_kexec
+++ a/arch/sh/kernel/setup.c
@@ -220,7 +220,7 @@ void __init __add_active_range(unsigned
 	request_resource(res, &code_resource);
 	request_resource(res, &data_resource);
 	request_resource(res, &bss_resource);
-#ifdef CONFIG_KEXEC
+#ifdef CONFIG_KEXEC_CORE
 	request_resource(res, &crashk_res);
 #endif
 
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

