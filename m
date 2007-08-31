From: akpm@linux-foundation.org
Subject: + hibernation-arbitrary-boot-kernel-support-on-x86_64-rev-2.patch added to -mm tree
Date: Fri, 31 Aug 2007 11:11:48 -0700
Message-ID: <200708311811.l7VIBmvI020150@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51915 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965762AbXHaSMR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 31 Aug 2007 14:12:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rjw@sisk.pl, ak@suse.de, pavel@ucw.cz


The patch titled
     Hibernation: Arbitrary boot kernel support on x86_64
has been added to the -mm tree.  Its filename is
     hibernation-arbitrary-boot-kernel-support-on-x86_64-rev-2.patch

*** Remember to use Documentation/SubmitChecklist when testing your cod=
e ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to =
find
out what to do about this

------------------------------------------------------
Subject: Hibernation: Arbitrary boot kernel support on x86_64
=46rom: Rafael J. Wysocki <rjw@sisk.pl>

Make it possible to restore a hibernation image on x86_64 with the help=
 of a
kernel different from the one in the image.

The idea is to split the core restoration code into two separate parts =
and to
place each of them in a different page.  =A0The first part belongs to t=
he boot
kernel and is executed as the last step of the image kernel's memory
restoration procedure.  =A0Before being executed, it is relocated to a =
safe page
that won't be overwritten while copying the image kernel pages.

The final operation performed by it is a jump to the second part of the=
 core
restoration code that belongs to the image kernel and has just been res=
tored.=20
This code makes the CPU switch to the image kernel's page tables and re=
stores
the state of general purpose registers (including the stack pointer) fr=
om
before the hibernation.

The main issue with this idea is that in order to jump to the second pa=
rt of
the core restoration code the boot kernel needs to know its address.=20
=A0However, this address may be passed to it in the image header.  =A0N=
amely, the
part of the image header previously used for checking if the version of=
 the
image kernel is correct can be replaced with some architecture specific=
 data
that will allow the boot kernel to jump to the right address within the=
 image
kernel.  =A0These data should also be used for checking if the image ke=
rnel is
compatible with the boot kernel (as far as the memory restroration proc=
edure
is concerned).  It can be done, for example, with the help of a "magic"=
 value
that has to be equal in both kernels, so that they can be regarded as
compatible.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Acked-by: Pavel Machek <pavel@ucw.cz>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86_64/Kconfig              |    5 ++
 arch/x86_64/kernel/suspend.c     |   54 ++++++++++++++++++++++++++++-
 arch/x86_64/kernel/suspend_asm.S |   41 ++++++++++++++++++----
 include/asm-x86_64/suspend.h     |    3 +
 4 files changed, 95 insertions(+), 8 deletions(-)

diff -puN arch/x86_64/Kconfig~hibernation-arbitrary-boot-kernel-support=
-on-x86_64-rev-2 arch/x86_64/Kconfig
--- a/arch/x86_64/Kconfig~hibernation-arbitrary-boot-kernel-support-on-=
x86_64-rev-2
+++ a/arch/x86_64/Kconfig
@@ -725,6 +725,11 @@ menu "Power management options"
=20
 source kernel/power/Kconfig
=20
+config ARCH_HIBERNATION_HEADER
+	bool
+	depends on HIBERNATION
+	default y
+
 source "drivers/acpi/Kconfig"
=20
 source "arch/x86_64/kernel/cpufreq/Kconfig"
diff -puN arch/x86_64/kernel/suspend.c~hibernation-arbitrary-boot-kerne=
l-support-on-x86_64-rev-2 arch/x86_64/kernel/suspend.c
--- a/arch/x86_64/kernel/suspend.c~hibernation-arbitrary-boot-kernel-su=
pport-on-x86_64-rev-2
+++ a/arch/x86_64/kernel/suspend.c
@@ -145,8 +145,16 @@ void fix_processor_context(void)
 /* Defined in arch/x86_64/kernel/suspend_asm.S */
 extern int restore_image(void);
=20
+/*
+ * Address to jump to in the last phase of restore in order to get to =
the image
+ * kernel's text (this value is passed in the image header).
+ */
+unsigned long restore_jump_address;
+
 pgd_t *temp_level4_pgt;
=20
+void *relocated_restore_code;
+
 static int res_phys_pud_init(pud_t *pud, unsigned long address, unsign=
ed long end)
 {
 	long i, j;
@@ -170,7 +178,7 @@ static int res_phys_pud_init(pud_t *pud,
=20
 			if (paddr >=3D end)
 				break;
-			pe =3D _PAGE_NX | _PAGE_PSE | _KERNPG_TABLE | paddr;
+			pe =3D __PAGE_KERNEL_LARGE_EXEC | paddr;
 			pe &=3D __supported_pte_mask;
 			set_pmd(pmd, __pmd(pe));
 		}
@@ -217,6 +225,13 @@ int swsusp_arch_resume(void)
 	/* We have got enough memory and from now on we cannot recover */
 	if ((error =3D set_up_temporary_mappings()))
 		return error;
+
+	relocated_restore_code =3D (void *)get_safe_page(GFP_ATOMIC);
+	if (!relocated_restore_code)
+		return -ENOMEM;
+	memcpy(relocated_restore_code, &core_restore_code,
+	       &restore_registers - &core_restore_code);
+
 	restore_image();
 	return 0;
 }
@@ -231,4 +246,41 @@ int pfn_is_nosave(unsigned long pfn)
 	unsigned long nosave_end_pfn =3D PAGE_ALIGN(__pa_symbol(&__nosave_end=
)) >> PAGE_SHIFT;
 	return (pfn >=3D nosave_begin_pfn) && (pfn < nosave_end_pfn);
 }
+
+struct restore_data_record {
+	unsigned long jump_address;
+	unsigned long control;
+};
+
+#define RESTORE_MAGIC	0x0123456789ABCDEFUL
+
+/**
+ *	arch_hibernation_header_save - populate the architecture specific p=
art
+ *		of a hibernation image header
+ *	@addr: address to save the data at
+ */
+int arch_hibernation_header_save(void *addr, unsigned int max_size)
+{
+	struct restore_data_record *rdr =3D addr;
+
+	if (max_size < sizeof(struct restore_data_record))
+		return -EOVERFLOW;
+	rdr->jump_address =3D restore_jump_address;
+	rdr->control =3D (restore_jump_address ^ RESTORE_MAGIC);
+	return 0;
+}
+
+/**
+ *	arch_hibernation_header_restore - read the architecture specific da=
ta
+ *		from the hibernation image header
+ *	@addr: address to read the data from
+ */
+int arch_hibernation_header_restore(void *addr)
+{
+	struct restore_data_record *rdr =3D addr;
+
+	restore_jump_address =3D rdr->jump_address;
+	return (rdr->control =3D=3D (restore_jump_address ^ RESTORE_MAGIC)) ?
+			0 : -EINVAL;
+}
 #endif /* CONFIG_HIBERNATION */
diff -puN arch/x86_64/kernel/suspend_asm.S~hibernation-arbitrary-boot-k=
ernel-support-on-x86_64-rev-2 arch/x86_64/kernel/suspend_asm.S
--- a/arch/x86_64/kernel/suspend_asm.S~hibernation-arbitrary-boot-kerne=
l-support-on-x86_64-rev-2
+++ a/arch/x86_64/kernel/suspend_asm.S
@@ -2,8 +2,8 @@
  *
  * Distribute under GPLv2.
  *
- * swsusp_arch_resume may not use any stack, nor any variable that is
- * not "NoSave" during copying pages:
+ * swsusp_arch_resume must not use any stack or any nonlocal variables=
 while
+ * copying pages:
  *
  * Its rewriting one kernel image with another. What is stack in "old"
  * image could very well be data page in "new" image, and overwriting
@@ -36,6 +36,10 @@ ENTRY(swsusp_arch_suspend)
 	pushfq
 	popq	pt_regs_eflags(%rax)
=20
+	/* save the address of restore_registers */
+	movq	$restore_registers, %rax
+	movq	%rax, restore_jump_address(%rip)
+
 	call swsusp_save
 	ret
=20
@@ -54,7 +58,16 @@ ENTRY(restore_image)
 	movq	%rcx, %cr3;
 	movq	%rax, %cr4;  # turn PGE back on
=20
+	/* prepare to jump to the image kernel */
+	movq	restore_jump_address(%rip), %rax
+
+	/* prepare to copy image data to their original locations */
 	movq	restore_pblist(%rip), %rdx
+	movq	relocated_restore_code(%rip), %rcx
+	jmpq	*%rcx
+
+	/* code below has been relocated to a safe page */
+ENTRY(core_restore_code)
 loop:
 	testq	%rdx, %rdx
 	jz	done
@@ -62,7 +75,7 @@ loop:
 	/* get addresses from the pbe and copy the page */
 	movq	pbe_address(%rdx), %rsi
 	movq	pbe_orig_address(%rdx), %rdi
-	movq	$512, %rcx
+	movq	$(PAGE_SIZE >> 3), %rcx
 	rep
 	movsq
=20
@@ -70,6 +83,20 @@ loop:
 	movq	pbe_next(%rdx), %rdx
 	jmp	loop
 done:
+	/* jump to the restore_registers address from the image header */
+	jmpq	*%rax
+	/*
+	 * NOTE: This assumes that the boot kernel's text mapping covers the
+	 * image kernel's page containing restore_registers and the address o=
f
+	 * this page is the same as in the image kernel's text mapping (it
+	 * should always be true, because the text mapping is linear, startin=
g
+	 * from 0, and is supposed to cover the entire kernel text for every
+	 * kernel).
+	 *
+	 * code below belongs to the image kernel
+	 */
+
+ENTRY(restore_registers)
 	/* go back to the original page tables */
 	movq    $(init_level4_pgt - __START_KERNEL_map), %rax
 	addq    phys_base(%rip), %rax
@@ -84,10 +111,7 @@ done:
 	movq	%rcx, %cr3
 	movq	%rax, %cr4;  # turn PGE back on
=20
-	movl	$24, %eax
-	movl	%eax, %ds
-
-	/* We don't restore %rax, it must be 0 anyway */
+	/* restore GPRs (we don't restore %rax, it must be 0 anyway) */
 	movq	$saved_context, %rax
 	movq	pt_regs_rsp(%rax), %rsp
 	movq	pt_regs_rbp(%rax), %rbp
@@ -109,4 +133,7 @@ done:
=20
 	xorq	%rax, %rax
=20
+	/* tell the hibernation core that we've just restored the memory */
+	movq	%rax, in_suspend(%rip)
+
 	ret
diff -puN include/asm-x86_64/suspend.h~hibernation-arbitrary-boot-kerne=
l-support-on-x86_64-rev-2 include/asm-x86_64/suspend.h
--- a/include/asm-x86_64/suspend.h~hibernation-arbitrary-boot-kernel-su=
pport-on-x86_64-rev-2
+++ a/include/asm-x86_64/suspend.h
@@ -43,4 +43,7 @@ extern void fix_processor_context(void);
 /* routines for saving/restoring kernel state */
 extern int acpi_save_state_mem(void);
=20
+extern char core_restore_code;
+extern char restore_registers;
+
 #endif /* __ASM_X86_64_SUSPEND_H */
_

Patches currently in -mm which might be from rjw@sisk.pl are

origin.patch
hibernation-make-sure-that-acpi-is-enabled-in-acpi_hibernation_finish.p=
atch
acpi-clean-up-acpi_enter_sleep_state_prep.patch
uli526x-add-suspend-and-resume-routines.patch
make-kernel-power-maincsuspend_enter-static.patch
pm-move-definition-of-struct-pm_ops-to-suspendh.patch
pm-rename-struct-pm_ops-and-related-things.patch
pm-rework-struct-platform_suspend_ops.patch
pm-make-suspend_ops-static.patch
pm-rework-struct-hibernation_ops.patch
pm-rename-hibernation_ops-to-platform_hibernation_ops.patch
freezer-document-relationship-with-memory-shrinking.patch
freezer-do-not-sync-filesystems-from-freeze_processes.patch
freezer-prevent-new-tasks-from-inheriting-tif_freeze-set.patch
freezer-introduce-freezer-firendly-waiting-macros.patch
freezer-introduce-freezer-firendly-waiting-macros-fix.patch
freezer-do-not-send-signals-to-kernel-threads.patch
unexport-pm_power_off_prepare.patch
pm_trace-displays-the-wrong-time-from-the-rtc.patch
freezer-be-more-verbose.patch
freezer-use-wait-queue-instead-of-busy-looping.patch
freezer-measure-freezing-time.patch
serial-turn-serial-console-suspend-a-boot-rather-than-compile-time-opti=
on.patch
serial-turn-serial-console-suspend-a-boot-rather-than-compile-time-opti=
on-update.patch
s2ram-kill-old-debugging-junk.patch
hibernation-arbitrary-boot-kernel-support-generic-code-rev-2.patch
hibernation-arbitrary-boot-kernel-support-on-x86_64-rev-2.patch
hibernation-pass-cr3-in-the-image-header-on-x86_64-rev-2.patch
hibernation-use-temporary-page-tables-for-kernel-text-mapping-on-x86_64=
=2Epatch
pnp-make-pnpacpi_suspend-handle-errors.patch
shrink_slab-handle-bad-shrinkers.patch
