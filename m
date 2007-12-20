From: akpm@linux-foundation.org
Subject: - alpha-build-fixes.patch removed from -mm tree
Date: Thu, 20 Dec 2007 15:36:06 -0800
Message-ID: <200712202336.lBKNa6Zf018780@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34839 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753016AbXLTXgR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 20 Dec 2007 18:36:17 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ink@jurassic.park.msu.ru, rth@twiddle.net, mm-commits@vger.kernel.org


The patch titled
     alpha: build fixes
has been removed from the -mm tree.  Its filename was
     alpha-build-fixes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: alpha: build fixes
From: Ivan Kokshaysky <ink@jurassic.park.msu.ru>

This fixes some of the alpha-specific build problems, except a) modpost
warning about COMMON symbol "saved_config" and b) nasty final link
failure with gcc-4.x, -Os and scsi-disk driver configured built-in
(due to jump table in .rodata referencing discarded .exit.text).

- build failure with gcc-4.2.x: fix up casts in cia_io* routines to avoid
  warnings ('discards qualifiers from pointer target type'), which are
  failures, thanks to -Werror;
- modpost warnings: add missing __init qualifier for titan and marvel;
  for non-generic build, move machine vectors from .data to .data.init.refok
  section;
- unbreak CPU-specific optimization: rearrange cpuflags-y assignments
  so that extended -mcpu value (ev56, pca56, ev67) overrides basic
  one (ev5, ev6) and not vice versa.

Signed-off-by: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Richard Henderson <rth@twiddle.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/Makefile              |   10 +++++-----
 arch/alpha/kernel/err_ev7.c      |    2 +-
 arch/alpha/kernel/err_marvel.c   |    2 +-
 arch/alpha/kernel/err_titan.c    |    2 +-
 arch/alpha/kernel/machvec_impl.h |    2 +-
 include/asm-alpha/io_trivial.h   |   12 ++++++++----
 6 files changed, 17 insertions(+), 13 deletions(-)

diff -puN arch/alpha/Makefile~alpha-build-fixes arch/alpha/Makefile
--- a/arch/alpha/Makefile~alpha-build-fixes
+++ a/arch/alpha/Makefile
@@ -14,13 +14,13 @@ LDFLAGS_vmlinux	:= -static -N #-relax
 CHECKFLAGS	+= -D__alpha__ -m64
 cflags-y	:= -pipe -mno-fp-regs -ffixed-8 -msmall-data
 
-cpuflags-$(CONFIG_ALPHA_EV67)		:= -mcpu=ev67
-cpuflags-$(CONFIG_ALPHA_EV6)		:= -mcpu=ev6
+cpuflags-$(CONFIG_ALPHA_EV4)		:= -mcpu=ev4
+cpuflags-$(CONFIG_ALPHA_EV5)		:= -mcpu=ev5
+cpuflags-$(CONFIG_ALPHA_EV56)		:= -mcpu=ev56
 cpuflags-$(CONFIG_ALPHA_POLARIS)	:= -mcpu=pca56
 cpuflags-$(CONFIG_ALPHA_SX164)		:= -mcpu=pca56
-cpuflags-$(CONFIG_ALPHA_EV56)		:= -mcpu=ev56
-cpuflags-$(CONFIG_ALPHA_EV5)		:= -mcpu=ev5
-cpuflags-$(CONFIG_ALPHA_EV4)		:= -mcpu=ev4
+cpuflags-$(CONFIG_ALPHA_EV6)		:= -mcpu=ev6
+cpuflags-$(CONFIG_ALPHA_EV67)		:= -mcpu=ev67
 # If GENERIC, make sure to turn off any instruction set extensions that
 # the host compiler might have on by default.  Given that EV4 and EV5
 # have the same instruction set, prefer EV5 because an EV5 schedule is
diff -puN arch/alpha/kernel/err_ev7.c~alpha-build-fixes arch/alpha/kernel/err_ev7.c
--- a/arch/alpha/kernel/err_ev7.c~alpha-build-fixes
+++ a/arch/alpha/kernel/err_ev7.c
@@ -273,7 +273,7 @@ ev7_process_pal_subpacket(struct el_subp
 struct el_subpacket_handler ev7_pal_subpacket_handler =
 	SUBPACKET_HANDLER_INIT(EL_CLASS__PAL, ev7_process_pal_subpacket);
 
-void
+void __init
 ev7_register_error_handlers(void)
 {
 	int i;
diff -puN arch/alpha/kernel/err_marvel.c~alpha-build-fixes arch/alpha/kernel/err_marvel.c
--- a/arch/alpha/kernel/err_marvel.c~alpha-build-fixes
+++ a/arch/alpha/kernel/err_marvel.c
@@ -1152,7 +1152,7 @@ marvel_machine_check(u64 vector, u64 la_
 	mb();
 }
 
-void
+void __init
 marvel_register_error_handlers(void)
 {
 	ev7_register_error_handlers();
diff -puN arch/alpha/kernel/err_titan.c~alpha-build-fixes arch/alpha/kernel/err_titan.c
--- a/arch/alpha/kernel/err_titan.c~alpha-build-fixes
+++ a/arch/alpha/kernel/err_titan.c
@@ -564,7 +564,7 @@ static struct el_subpacket_handler titan
 	SUBPACKET_HANDLER_INIT(EL_CLASS__REGATTA_FAMILY, 
 			       el_process_regatta_subpacket);
 
-void
+void __init
 titan_register_error_handlers(void)
 {
 	size_t i;
diff -puN arch/alpha/kernel/machvec_impl.h~alpha-build-fixes arch/alpha/kernel/machvec_impl.h
--- a/arch/alpha/kernel/machvec_impl.h~alpha-build-fixes
+++ a/arch/alpha/kernel/machvec_impl.h
@@ -134,7 +134,7 @@
 #define __initmv __initdata
 #define ALIAS_MV(x)
 #else
-#define __initmv
+#define __initmv __initdata_refok
 
 /* GCC actually has a syntax for defining aliases, but is under some
    delusion that you shouldn't be able to declare it extern somewhere
diff -puN include/asm-alpha/io_trivial.h~alpha-build-fixes include/asm-alpha/io_trivial.h
--- a/include/asm-alpha/io_trivial.h~alpha-build-fixes
+++ a/include/asm-alpha/io_trivial.h
@@ -72,25 +72,29 @@ IO_CONCAT(__IO_PREFIX,writew)(u16 b, vol
 __EXTERN_INLINE u8
 IO_CONCAT(__IO_PREFIX,readb)(const volatile void __iomem *a)
 {
-	return IO_CONCAT(__IO_PREFIX,ioread8)((void __iomem *)a);
+	void __iomem *addr = (void __iomem *)a;
+	return IO_CONCAT(__IO_PREFIX,ioread8)(addr);
 }
 
 __EXTERN_INLINE u16
 IO_CONCAT(__IO_PREFIX,readw)(const volatile void __iomem *a)
 {
-	return IO_CONCAT(__IO_PREFIX,ioread16)((void __iomem *)a);
+	void __iomem *addr = (void __iomem *)a;
+	return IO_CONCAT(__IO_PREFIX,ioread16)(addr);
 }
 
 __EXTERN_INLINE void
 IO_CONCAT(__IO_PREFIX,writeb)(u8 b, volatile void __iomem *a)
 {
-	IO_CONCAT(__IO_PREFIX,iowrite8)(b, (void __iomem *)a);
+	void __iomem *addr = (void __iomem *)a;
+	IO_CONCAT(__IO_PREFIX,iowrite8)(b, addr);
 }
 
 __EXTERN_INLINE void
 IO_CONCAT(__IO_PREFIX,writew)(u16 b, volatile void __iomem *a)
 {
-	IO_CONCAT(__IO_PREFIX,iowrite16)(b, (void __iomem *)a);
+	void __iomem *addr = (void __iomem *)a;
+	IO_CONCAT(__IO_PREFIX,iowrite16)(b, addr);
 }
 #endif
 
_

Patches currently in -mm which might be from ink@jurassic.park.msu.ru are

origin.patch
iommu-sg-merging-alpha-make-pci_iommu-respect-the-segment-size-limits.patch
arch-alpha-removed-duplicate-includes.patch
alpha-atomic_add_return-should-return-int.patch
alpha-kill-deprecated-virt_to_bus.patch
alpha-doesnt-use-socketcall.patch
agp-alpha-nopage.patch
alpha-fix-warning-by-fixing-flush_tlb_kernel_range.patch
alpha-parisc-removing-config-variable-debug_rwlock.patch
get-rid-of-nr_open-and-introduce-a-sysctl_nr_open.patch
get-rid-of-nr_open-and-introduce-a-sysctl_nr_open-fix.patch
calibrate_delay-must-be-__cpuinit.patch
sanitize-the-type-of-struct-useru_ar0.patch
add-cmpxchg64-and-cmpxchg64_local-to-alpha.patch
make-sure-nobodys-leaking-resources.patch
