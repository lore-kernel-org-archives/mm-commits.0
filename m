From: akpm@linux-foundation.org
Subject: - s2ram-kill-old-debugging-junk.patch removed from -mm tree
Date: Thu, 18 Oct 2007 20:41:17 -0700
Message-ID: <200710190341.l9J3fH54012807@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39015 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934407AbXJSD4e (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 23:56:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: pavel@ucw.cz, ak@suse.de, pavel@suse.cz, rjw@sisk.pl, mm-commits@vger.kernel.org


The patch titled
     s2ram: kill old debugging junk
has been removed from the -mm tree.  Its filename was
     s2ram-kill-old-debugging-junk.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: s2ram: kill old debugging junk
From: Pavel Machek <pavel@ucw.cz>

This removes old debugging stuff, that should be no longer neccessary.  It
accessed VGA hardware (which may not be ready at this point), and used LEDs
at port 80 for debugging.

Signed-off-by: Pavel Machek <pavel@suse.cz>
Acked-by: Rafael J. Wysocki <rjw@sisk.pl>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/acpi/wakeup_32.S |   12 ----------
 arch/x86/kernel/acpi/wakeup_64.S |   32 -----------------------------
 2 files changed, 1 insertion(+), 43 deletions(-)

diff -puN arch/x86/kernel/acpi/wakeup_32.S~s2ram-kill-old-debugging-junk arch/x86/kernel/acpi/wakeup_32.S
--- a/arch/x86/kernel/acpi/wakeup_32.S~s2ram-kill-old-debugging-junk
+++ a/arch/x86/kernel/acpi/wakeup_32.S
@@ -11,7 +11,7 @@
 #
 # If physical address of wakeup_code is 0x12345, BIOS should call us with
 # cs = 0x1234, eip = 0x05
-# 
+#
 
 #define BEEP \
 	inb	$97, %al; 	\
@@ -52,7 +52,6 @@ wakeup_code:
 	BEEP
 1:
 	mov	$(wakeup_stack - wakeup_code), %sp		# Private stack is needed for ASUS board
-	movw	$0x0e00 + 'S', %fs:(0x12)
 
 	pushl	$0						# Kill any dangerous flags
 	popfl
@@ -90,9 +89,6 @@ wakeup_code:
 	# make sure %cr4 is set correctly (features, etc)
 	movl	real_save_cr4 - wakeup_code, %eax
 	movl	%eax, %cr4
-	movw	$0xb800, %ax
-	movw	%ax,%fs
-	movw	$0x0e00 + 'i', %fs:(0x12)
 	
 	# need a gdt -- use lgdtl to force 32-bit operands, in case
 	# the GDT is located past 16 megabytes.
@@ -102,8 +98,6 @@ wakeup_code:
 	movl	%eax, %cr0
 	jmp 1f
 1:
-	movw	$0x0e00 + 'n', %fs:(0x14)
-
 	movl	real_magic - wakeup_code, %eax
 	cmpl	$0x12345678, %eax
 	jne	bogus_real_magic
@@ -122,13 +116,11 @@ real_save_cr4:	.long 0
 real_magic:	.long 0
 video_mode:	.long 0
 realmode_flags:	.long 0
-beep_flags:	.long 0
 real_efer_save_restore:	.long 0
 real_save_efer_edx: 	.long 0
 real_save_efer_eax: 	.long 0
 
 bogus_real_magic:
-	movw	$0x0e00 + 'B', %fs:(0x12)
 	jmp bogus_real_magic
 
 /* This code uses an extended set of video mode numbers. These include:
@@ -194,7 +186,6 @@ wakeup_pmode_return:
 	movw	%ax, %es
 	movw	%ax, %fs
 	movw	%ax, %gs
-	movw	$0x0e00 + 'u', 0xb8016
 
 	# reload the gdt, as we need the full 32 bit address
 	lgdt	saved_gdt
@@ -218,7 +209,6 @@ wakeup_pmode_return:
 	jmp	*%eax
 
 bogus_magic:
-	movw	$0x0e00 + 'B', 0xb8018
 	jmp	bogus_magic
 
 
diff -puN arch/x86/kernel/acpi/wakeup_64.S~s2ram-kill-old-debugging-junk arch/x86/kernel/acpi/wakeup_64.S
--- a/arch/x86/kernel/acpi/wakeup_64.S~s2ram-kill-old-debugging-junk
+++ a/arch/x86/kernel/acpi/wakeup_64.S
@@ -41,7 +41,6 @@ wakeup_code:
 
 # Running in *copy* of this code, somewhere in low 1MB.
 
-	movb	$0xa1, %al	;  outb %al, $0x80
 	cli
 	cld
 	# setup data segment
@@ -65,11 +64,6 @@ wakeup_code:
 	cmpl	$0x12345678, %eax
 	jne	bogus_real_magic
 
-  	call	verify_cpu			# Verify the cpu supports long
-						# mode
-	testl	%eax, %eax
-	jnz	no_longmode
-
 	testl	$1, realmode_flags - wakeup_code
 	jz	1f
 	lcall   $0xc000,$3
@@ -84,12 +78,6 @@ wakeup_code:
 	call	mode_set
 1:
 
- 	movw	$0xb800, %ax
-	movw	%ax,%fs
-	movw	$0x0e00 + 'L', %fs:(0x10)
-
-	movb	$0xa2, %al	;  outb %al, $0x80
-	
 	mov	%ds, %ax			# Find 32bit wakeup_code addr
 	movzx   %ax, %esi			# (Convert %ds:gdt to a liner ptr)
 	shll    $4, %esi
@@ -117,14 +105,10 @@ wakeup_32_vector:
 	.code32
 wakeup_32:
 # Running in this code, but at low address; paging is not yet turned on.
-	movb	$0xa5, %al	;  outb %al, $0x80
 
 	movl	$__KERNEL_DS, %eax
 	movl	%eax, %ds
 
-	movw	$0x0e00 + 'i', %ds:(0xb8012)
-	movb	$0xa8, %al	;  outb %al, $0x80;
-
 	/*
 	 * Prepare for entering 64bits mode
 	 */
@@ -200,16 +184,11 @@ wakeup_long64:
 	 */
 	lgdt	cpu_gdt_descr
 
-	movw	$0x0e00 + 'n', %ds:(0xb8014)
-	movb	$0xa9, %al	;  outb %al, $0x80
-
 	movq    saved_magic, %rax
 	movq    $0x123456789abcdef0, %rdx
 	cmpq    %rdx, %rax
 	jne     bogus_64_magic
 
-	movw	$0x0e00 + 'u', %ds:(0xb8016)
-	
 	nop
 	nop
 	movw	$__KERNEL_DS, %ax
@@ -220,13 +199,11 @@ wakeup_long64:
 	movw	%ax, %gs
 	movq	saved_rsp, %rsp
 
-	movw	$0x0e00 + 'x', %ds:(0xb8018)
 	movq	saved_rbx, %rbx
 	movq	saved_rdi, %rdi
 	movq	saved_rsi, %rsi
 	movq	saved_rbp, %rbp
 
-	movw	$0x0e00 + '!', %ds:(0xb801a)
 	movq	saved_rip, %rax
 	jmp	*%rax
 
@@ -256,21 +233,12 @@ realmode_flags:	.quad 0
 
 .code16
 bogus_real_magic:
-	movb	$0xba,%al	;  outb %al,$0x80
 	jmp bogus_real_magic
 
 .code64
 bogus_64_magic:
-	movb	$0xb3,%al	;  outb %al,$0x80
 	jmp bogus_64_magic
 
-.code16
-no_longmode:
-	movb    $0xbc,%al       ;  outb %al,$0x80
-	jmp no_longmode
-
-#include "../verify_cpu_64.S"
-	
 /* This code uses an extended set of video mode numbers. These include:
  * Aliases for standard modes
  *	NORMAL_VGA (-1)
_

Patches currently in -mm which might be from pavel@ucw.cz are

origin.patch
git-acpi.patch
working-3d-dri-intel-agpko-resume-for-i815-chip.patch
