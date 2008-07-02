From: akpm@linux-foundation.org
Subject: - x86-acpi-normalize-segment-descriptor-register-on-resume.patch removed from -mm tree
Date: Wed, 02 Jul 2008 00:46:44 -0700
Message-ID: <200807020746.m627kide005590@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49768 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753960AbYGBHsc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 2 Jul 2008 03:48:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hpa@zytor.com, kirill@shutemov.name, lenb@kernel.org, pavel@suse.cz, rjw@sisk.pl, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     x86 ACPI: normalize segment descriptor register on resume
has been removed from the -mm tree.  Its filename was
     x86-acpi-normalize-segment-descriptor-register-on-resume.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: x86 ACPI: normalize segment descriptor register on resume
From: H. Peter Anvin <hpa@zytor.com>

Some Dell laptops enter resume with apparent garbage in the segment
descriptor registers (almost certainly the result of a botched transition
from protected to real mode.) The only way to clean that up is to enter
protected mode ourselves and clean out the descriptor registers.

This fixes resume on Dell XPS M1210 and Dell D620.

Reference: http://bugzilla.kernel.org/show_bug.cgi?id=10927

(akpm: for 2.6.27-rc1, to be backported into 2.6.26.x if nothing blows up)

Signed-off-by: H. Peter Anvin <hpa@zytor.com>
Tested-by: Kirill A. Shutemov <kirill@shutemov.name>
Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Acked-by: Len Brown <lenb@kernel.org>
Acked-by: Pavel Machek <pavel@suse.cz>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/acpi/realmode/wakeup.S |   38 ++++++++++++++++++++++-
 arch/x86/kernel/acpi/realmode/wakeup.h |    5 +++
 arch/x86/kernel/acpi/sleep.c           |   16 +++++++++
 drivers/acpi/sleep/main.c              |    5 +--
 4 files changed, 59 insertions(+), 5 deletions(-)

diff -puN arch/x86/kernel/acpi/realmode/wakeup.S~x86-acpi-normalize-segment-descriptor-register-on-resume arch/x86/kernel/acpi/realmode/wakeup.S
--- a/arch/x86/kernel/acpi/realmode/wakeup.S~x86-acpi-normalize-segment-descriptor-register-on-resume
+++ a/arch/x86/kernel/acpi/realmode/wakeup.S
@@ -5,6 +5,7 @@
 #include <asm/msr-index.h>
 #include <asm/page.h>
 #include <asm/pgtable.h>
+#include <asm/processor-flags.h>
 
 	.code16
 	.section ".header", "a"
@@ -24,6 +25,11 @@ pmode_gdt:	.quad	0
 realmode_flags:	.long	0
 real_magic:	.long	0
 trampoline_segment:	.word 0
+_pad1:		.byte	0
+wakeup_jmp:	.byte	0xea	/* ljmpw */
+wakeup_jmp_off:	.word	3f
+wakeup_jmp_seg:	.word	0
+wakeup_gdt:	.quad	0, 0, 0
 signature:	.long	0x51ee1111
 
 	.text
@@ -34,11 +40,34 @@ _start:
 	cli
 	cld
 
+	/* Apparently some dimwit BIOS programmers don't know how to
+	   program a PM to RM transition, and we might end up here with
+	   junk in the data segment descriptor registers.  The only way
+	   to repair that is to go into PM and fix it ourselves... */
+	movw	$16, %cx
+	lgdtl	%cs:wakeup_gdt
+	movl	%cr0, %eax
+	orb	$X86_CR0_PE, %al
+	movl	%eax, %cr0
+	jmp	1f
+1:	ljmpw	$8, $2f
+2:
+	movw	%cx, %ds
+	movw	%cx, %es
+	movw	%cx, %ss
+	movw	%cx, %fs
+	movw	%cx, %gs
+
+	andb	$~X86_CR0_PE, %al
+	movl	%eax, %cr0
+	jmp	wakeup_jmp
+3:
 	/* Set up segments */
 	movw	%cs, %ax
 	movw	%ax, %ds
 	movw	%ax, %es
 	movw	%ax, %ss
+	lidtl	wakeup_idt
 
 	movl	$wakeup_stack_end, %esp
 
@@ -98,7 +127,14 @@ bogus_real_magic:
 	jmp	1b
 
 	.data
-	.balign	4
+	.balign	8
+
+	/* This is the standard real-mode IDT */
+wakeup_idt:
+	.word	0xffff		/* limit */
+	.long	0		/* address */
+	.word	0
+
 	.globl	HEAP, heap_end
 HEAP:
 	.long	wakeup_heap
diff -puN arch/x86/kernel/acpi/realmode/wakeup.h~x86-acpi-normalize-segment-descriptor-register-on-resume arch/x86/kernel/acpi/realmode/wakeup.h
--- a/arch/x86/kernel/acpi/realmode/wakeup.h~x86-acpi-normalize-segment-descriptor-register-on-resume
+++ a/arch/x86/kernel/acpi/realmode/wakeup.h
@@ -24,6 +24,11 @@ struct wakeup_header {
 	u32 realmode_flags;
 	u32 real_magic;
 	u16 trampoline_segment;	/* segment with trampoline code, 64-bit only */
+	u8  _pad1;
+	u8  wakeup_jmp;
+	u16 wakeup_jmp_off;
+	u16 wakeup_jmp_seg;
+	u64 wakeup_gdt[3];
 	u32 signature;		/* To check we have correct structure */
 } __attribute__((__packed__));
 
diff -puN arch/x86/kernel/acpi/sleep.c~x86-acpi-normalize-segment-descriptor-register-on-resume arch/x86/kernel/acpi/sleep.c
--- a/arch/x86/kernel/acpi/sleep.c~x86-acpi-normalize-segment-descriptor-register-on-resume
+++ a/arch/x86/kernel/acpi/sleep.c
@@ -50,6 +50,20 @@ int acpi_save_state_mem(void)
 
 	header->video_mode = saved_video_mode;
 
+	header->wakeup_jmp_seg = acpi_wakeup_address >> 4;
+	/* GDT[0]: GDT self-pointer */
+	header->wakeup_gdt[0] =
+		(u64)(sizeof(header->wakeup_gdt) - 1) +
+		((u64)(acpi_wakeup_address +
+			((char *)&header->wakeup_gdt - (char *)acpi_realmode))
+				<< 16);
+	/* GDT[1]: real-mode-like code segment */
+	header->wakeup_gdt[1] = (0x009bULL << 40) +
+		((u64)acpi_wakeup_address << 16) + 0xffff;
+	/* GDT[2]: real-mode-like data segment */
+	header->wakeup_gdt[2] = (0x0093ULL << 40) +
+		((u64)acpi_wakeup_address << 16) + 0xffff;
+
 #ifndef CONFIG_64BIT
 	store_gdt((struct desc_ptr *)&header->pmode_gdt);
 
@@ -113,7 +127,7 @@ void __init acpi_reserve_bootmem(void)
 		return;
 	}
 
-	acpi_wakeup_address = acpi_realmode;
+	acpi_wakeup_address = virt_to_phys((void *)acpi_realmode);
 }
 
 
diff -puN drivers/acpi/sleep/main.c~x86-acpi-normalize-segment-descriptor-register-on-resume drivers/acpi/sleep/main.c
--- a/drivers/acpi/sleep/main.c~x86-acpi-normalize-segment-descriptor-register-on-resume
+++ a/drivers/acpi/sleep/main.c
@@ -32,9 +32,8 @@ static int acpi_sleep_prepare(u32 acpi_s
 		if (!acpi_wakeup_address) {
 			return -EFAULT;
 		}
-		acpi_set_firmware_waking_vector((acpi_physical_address)
-						virt_to_phys((void *)
-							     acpi_wakeup_address));
+		acpi_set_firmware_waking_vector(
+				(acpi_physical_address)acpi_wakeup_address);
 
 	}
 	ACPI_FLUSH_CPU_CACHE();
_

Patches currently in -mm which might be from hpa@zytor.com are

linux-next.patch
asm-generic-int-ll64h-always-provide-__su64.patch
inflate-refactor-inflate-malloc-code.patch
inflate-refactor-inflate-malloc-code-checkpatch-fixes.patch

