From: akpm@linux-foundation.org
Subject: - lguest-the-host-code-lguest-use-standard-bootloader-format-fix-badly-sized.patch removed from -mm tree
Date: Wed, 09 May 2007 02:43:04 -0700
Message-ID: <200705090943.l499h5wH020203@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:44033 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754689AbXEIJoH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 May 2007 05:44:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rusty@rustcorp.com.au, mm-commits@vger.kernel.org


The patch titled
     lguest: use standard bootloader format, fix badly-sized initrds
has been removed from the -mm tree.  Its filename was
     lguest-the-host-code-lguest-use-standard-bootloader-format-fix-badly-sized.patch

This patch was dropped because it was folded into lguest-the-host-code.patch

------------------------------------------------------
Subject: lguest: use standard bootloader format, fix badly-sized initrds
From: Rusty Russell <rusty@rustcorp.com.au>

Eric Biederman complained that lguest doesn't use the Linux standard boot
header format.  He's got a good point.

This also simplifies the code: the example launcher writes the header
directly, rather than lguest writing into it during boot.

While we're touching this code, we also fix the problem of initrd's which
don't have a page-aligned size.

This anticipates changing the paravirt-finding routines to use a "platform
type" field from %esi, rather than a "probe all until one succeeds"
routine, but doesn't actually change that code.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/lguest/lguest.c         |   20 ++++++++------------
 drivers/lguest/lguest_asm.S     |    5 ++++-
 drivers/lguest/lguest_user.c    |    4 +---
 include/linux/lguest.h          |    5 -----
 include/linux/lguest_launcher.h |    8 --------
 5 files changed, 13 insertions(+), 29 deletions(-)

diff -puN /dev/null /dev/null
diff -puN drivers/lguest/lguest.c~lguest-the-host-code-lguest-use-standard-bootloader-format-fix-badly-sized drivers/lguest/lguest.c
--- a/drivers/lguest/lguest.c~lguest-the-host-code-lguest-use-standard-bootloader-format-fix-badly-sized
+++ a/drivers/lguest/lguest.c
@@ -52,7 +52,6 @@ struct lguest_data lguest_data = {
 	.blocked_interrupts = { 1 }, /* Block timer interrupts */
 };
 struct lguest_device_desc *lguest_devices;
-static __initdata const struct lguest_boot_info *boot = __va(0);
 
 static enum paravirt_lazy_mode lazy_mode;
 static void lguest_lazy_mode(enum paravirt_lazy_mode mode)
@@ -377,8 +376,7 @@ static __init char *lguest_memory_setup(
 	/* We do this here because lockcheck barfs if before start_kernel */
 	atomic_notifier_chain_register(&panic_notifier_list, &paniced);
 
-	e820.nr_map = 0;
-	add_memory_region(0, PFN_PHYS(boot->max_pfn), E820_RAM);
+	add_memory_region(E820_MAP->addr, E820_MAP->size, E820_MAP->type);
 	return "LGUEST";
 }
 
@@ -409,8 +407,14 @@ static unsigned lguest_patch(u8 type, u1
 	return insn_len;
 }
 
-__init void lguest_init(void)
+__init void lguest_init(void *boot)
 {
+	/* Copy boot parameters first. */
+	memcpy(boot_params, boot, PARAM_SIZE);
+	memcpy(boot_command_line,
+	       __va(*(unsigned long *)(boot_params + NEW_CL_POINTER)),
+	       COMMAND_LINE_SIZE);
+
 	paravirt_ops.name = "lguest";
 	paravirt_ops.paravirt_enabled = 1;
 	paravirt_ops.kernel_rpl = 1;
@@ -459,7 +463,6 @@ __init void lguest_init(void)
 	paravirt_ops.wbinvd = lguest_wbinvd;
 
 	hcall(LHCALL_LGUEST_INIT, __pa(&lguest_data), 0, 0);
-	strncpy(boot_command_line, boot->cmdline, COMMAND_LINE_SIZE);
 
 	/* We use top of mem for initial pagetables. */
 	init_pg_tables_end = __pa(pg0);
@@ -485,13 +488,6 @@ __init void lguest_init(void)
 
 	add_preferred_console("hvc", 0, NULL);
 
-	if (boot->initrd_size) {
-		/* We stash this at top of memory. */
-		INITRD_START = boot->max_pfn*PAGE_SIZE - boot->initrd_size;
-		INITRD_SIZE = boot->initrd_size;
-		LOADER_TYPE = 0xFF;
-	}
-
 	pm_power_off = lguest_power_off;
 	start_kernel();
 }
diff -puN drivers/lguest/lguest_asm.S~lguest-the-host-code-lguest-use-standard-bootloader-format-fix-badly-sized drivers/lguest/lguest_asm.S
--- a/drivers/lguest/lguest_asm.S~lguest-the-host-code-lguest-use-standard-bootloader-format-fix-badly-sized
+++ a/drivers/lguest/lguest_asm.S
@@ -10,7 +10,8 @@
  * This is where we begin: we have a magic signature which the launcher looks
  * for.  The plan is that the Linux boot protocol will be extended with a
  * "platform type" field which will guide us here from the normal entry point,
- * but for the moment this suffices.
+ * but for the moment this suffices.  We pass the virtual address of the boot
+ * info to lguest_init().
  *
  * We put it in .init.text will be discarded after boot.
  */
@@ -18,6 +19,8 @@
 .ascii "GenuineLguest"
 	/* Set up initial stack. */
  	movl $(init_thread_union+THREAD_SIZE),%esp
+	movl %esi, %eax
+	addl $__PAGE_OFFSET, %eax
 	jmp lguest_init
 
 /* The templates for inline patching. */
diff -puN drivers/lguest/lguest_user.c~lguest-the-host-code-lguest-use-standard-bootloader-format-fix-badly-sized drivers/lguest/lguest_user.c
--- a/drivers/lguest/lguest_user.c~lguest-the-host-code-lguest-use-standard-bootloader-format-fix-badly-sized
+++ a/drivers/lguest/lguest_user.c
@@ -7,13 +7,11 @@
 static void setup_regs(struct lguest_regs *regs, unsigned long start)
 {
 	/* Write out stack in format lguest expects, so we can switch to it. */
-	regs->edi = LGUEST_MAGIC_EDI;
-	regs->ebp = LGUEST_MAGIC_EBP;
-	regs->esi = LGUEST_MAGIC_ESI;
 	regs->ds = regs->es = regs->ss = __KERNEL_DS|GUEST_PL;
 	regs->cs = __KERNEL_CS|GUEST_PL;
 	regs->eflags = 0x202; 	/* Interrupts enabled. */
 	regs->eip = start;
+	/* esi points to our boot information (physical address 0) */
 }
 
 /* + addr */
diff -puN include/linux/lguest.h~lguest-the-host-code-lguest-use-standard-bootloader-format-fix-badly-sized include/linux/lguest.h
--- a/include/linux/lguest.h~lguest-the-host-code-lguest-use-standard-bootloader-format-fix-badly-sized
+++ a/include/linux/lguest.h
@@ -3,11 +3,6 @@
 #ifndef _ASM_LGUEST_H
 #define _ASM_LGUEST_H
 
-/* These are randomly chosen numbers which indicate we're an lguest at boot */
-#define LGUEST_MAGIC_EBP 0x4C687970
-#define LGUEST_MAGIC_EDI 0x652D4D65
-#define LGUEST_MAGIC_ESI 0xFFFFFFFF
-
 #ifndef __ASSEMBLY__
 #include <asm/irq.h>
 
diff -puN include/linux/lguest_launcher.h~lguest-the-host-code-lguest-use-standard-bootloader-format-fix-badly-sized include/linux/lguest_launcher.h
--- a/include/linux/lguest_launcher.h~lguest-the-host-code-lguest-use-standard-bootloader-format-fix-badly-sized
+++ a/include/linux/lguest_launcher.h
@@ -17,14 +17,6 @@ struct lguest_dma
 	u16 len[LGUEST_MAX_DMA_SECTIONS];
 };
 
-/* This is found at address 0. */
-struct lguest_boot_info
-{
-	u32 max_pfn;
-	u32 initrd_size;
-	char cmdline[256];
-};
-
 struct lguest_block_page
 {
 	/* 0 is a read, 1 is a write. */
_

Patches currently in -mm which might be from rusty@rustcorp.com.au are

origin.patch
____call_usermodehelper-dont-flush_signals.patch
wait_for_helper-remove-unneeded-do_sigaction.patch
futex-new-private-futexes.patch
compiler-introduce-__used-and-__maybe_unused.patch
xfs-clean-up-shrinker-games.patch
mm-merge-populate-and-nopage-into-fault-fixes-nonlinear-fix.patch
mm-clean-up-and-kernelify-shrinker-registration.patch
add-ability-to-keep-track-of-callers-of-symbol_getput.patch
update-mtd-use-of-symbol_getput.patch
update-dvb-use-of-symbol_getput.patch
lguest-export-symbols-for-lguest-as-a-module.patch
lguest-the-guest-code.patch
lguest-the-host-code.patch
lguest-the-host-code-lguest-use-standard-bootloader-format-fix-badly-sized.patch
lguest-the-asm-offsets.patch
lguest-the-makefile-and-kconfig.patch
lguest-the-console-driver.patch
lguest-the-net-driver.patch
lguest-the-net-driver-lguest-2621-mm1-update-lguest-net-stats-inlinepatch.patch
lguest-the-net-driver-two-net-bugfixes.patch
lguest-the-block-driver.patch
lguest-the-documentation-example-launcher.patch
lguest-the-documentation-example-launcher-fix-lguest-documentation-error.patch
lguest-documentation-and-example-updates.patch
lguest-the-documentation-example-launcher-dont-use-paravirt_probe-its-dying-doc.patch
lguest-use-standard-bootloader-format-fix-badly-sized-doc.patch
lguest-two-net-bugfixes-doc.patch
lguest-the-host-code-vs-futex-new-private-futexes.patch
mm-clean-up-and-kernelify-shrinker-registration-reiser4.patch
