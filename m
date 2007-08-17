From: akpm@linux-foundation.org
Subject: + s2ram-kill-old-debugging-junk.patch added to -mm tree
Date: Fri, 17 Aug 2007 12:38:06 -0700
Message-ID: <200708171938.l7HJc6DM026117@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41503 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750897AbXHQTjJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 17 Aug 2007 15:39:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: pavel@ucw.cz, ak@suse.de, pavel@suse.cz, rjw@sisk.pl


The patch titled
     s2ram: kill old debugging junk
has been added to the -mm tree.  Its filename is
     s2ram-kill-old-debugging-junk.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

 arch/i386/kernel/acpi/wakeup.S   |   32 ------------------
 arch/x86_64/kernel/acpi/wakeup.S |   51 -----------------------------
 2 files changed, 1 insertion(+), 82 deletions(-)

diff -puN arch/i386/kernel/acpi/wakeup.S~s2ram-kill-old-debugging-junk arch/i386/kernel/acpi/wakeup.S
--- a/arch/i386/kernel/acpi/wakeup.S~s2ram-kill-old-debugging-junk
+++ a/arch/i386/kernel/acpi/wakeup.S
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
@@ -153,29 +145,9 @@ bogus_real_magic:
 # Setting of user mode (AX=mode ID) => CF=success
 mode_set:
 	movw	%ax, %bx
-#if 0
-	cmpb	$0xff, %ah
-	jz	setalias
-
-	testb	$VIDEO_RECALC>>8, %ah
-	jnz	_setrec
-
-	cmpb	$VIDEO_FIRST_RESOLUTION>>8, %ah
-	jnc	setres
-	
-	cmpb	$VIDEO_FIRST_SPECIAL>>8, %ah
-	jz	setspc
-
-	cmpb	$VIDEO_FIRST_V7>>8, %ah
-	jz	setv7
-#endif
 	
 	cmpb	$VIDEO_FIRST_VESA>>8, %ah
 	jnc	check_vesa
-#if 0	
-	orb	%ah, %ah
-	jz	setmenu
-#endif
 	
 	decb	%ah
 #	jz	setbios				  Add bios modes later
@@ -215,7 +187,6 @@ wakeup_pmode_return:
 	movw	%ax, %es
 	movw	%ax, %fs
 	movw	%ax, %gs
-	movw	$0x0e00 + 'u', 0xb8016
 
 	# reload the gdt, as we need the full 32 bit address
 	lgdt	saved_gdt
@@ -239,7 +210,6 @@ wakeup_pmode_return:
 	jmp	*%eax
 
 bogus_magic:
-	movw	$0x0e00 + 'B', 0xb8018
 	jmp	bogus_magic
 
 
diff -puN arch/x86_64/kernel/acpi/wakeup.S~s2ram-kill-old-debugging-junk arch/x86_64/kernel/acpi/wakeup.S
--- a/arch/x86_64/kernel/acpi/wakeup.S~s2ram-kill-old-debugging-junk
+++ a/arch/x86_64/kernel/acpi/wakeup.S
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
 	call	mode_seta
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
 
@@ -256,20 +233,12 @@ realmode_flags:	.quad 0
 
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
-#include "../verify_cpu.S"
 	
 /* This code uses an extended set of video mode numbers. These include:
  * Aliases for standard modes
@@ -294,29 +263,9 @@ no_longmode:
 .code16
 mode_seta:
 	movw	%ax, %bx
-#if 0
-	cmpb	$0xff, %ah
-	jz	setalias
-
-	testb	$VIDEO_RECALC>>8, %ah
-	jnz	_setrec
-
-	cmpb	$VIDEO_FIRST_RESOLUTION>>8, %ah
-	jnc	setres
-	
-	cmpb	$VIDEO_FIRST_SPECIAL>>8, %ah
-	jz	setspc
-
-	cmpb	$VIDEO_FIRST_V7>>8, %ah
-	jz	setv7
-#endif
 	
 	cmpb	$VIDEO_FIRST_VESA>>8, %ah
 	jnc	check_vesaa
-#if 0	
-	orb	%ah, %ah
-	jz	setmenu
-#endif
 	
 	decb	%ah
 #	jz	setbios				  Add bios modes later
_

Patches currently in -mm which might be from pavel@ucw.cz are

working-3d-dri-intel-agpko-resume-for-i815-chip.patch
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
freezer-do-not-send-signals-to-kernel-threads.patch
freezer-be-more-verbose.patch
freezer-use-wait-queue-instead-of-busy-looping.patch
freezer-measure-freezing-time.patch
serial-turn-serial-console-suspend-a-boot-rather-than-compile-time-option.patch
serial-turn-serial-console-suspend-a-boot-rather-than-compile-time-option-update.patch
s2ram-kill-old-debugging-junk.patch
