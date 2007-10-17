From: akpm@linux-foundation.org
Subject: + i386-paravirt-boot-sequence.patch added to -mm tree
Date: Wed, 17 Oct 2007 14:35:54 -0700
Message-ID: <200710172135.l9HLZsX1009477@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50918 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761886AbXJQVg3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 17 Oct 2007 17:36:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rusty@rustcorp.com.au, James.Bottomley@HansenPartnership.com, ak@suse.de, ebiederm@xmission.com, hpa@zytor.com, jeremy@xensource.com, mingo@elte.hu, tglx@linutronix.de, vgoyal@in.ibm.com, zach@vmware.com


The patch titled
     i386: paravirt boot sequence
has been added to the -mm tree.  Its filename is
     i386-paravirt-boot-sequence.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: i386: paravirt boot sequence
From: Rusty Russell <rusty@rustcorp.com.au>

This patch uses the updated boot protocol to do paravirtualized boot.
If the boot version is >= 2.07, then it will do two things:

 1. Check the bootparams loadflags to see if we should reload the
    segment registers and clear interrupts.  This is appropriate
    for normal native boot and some paravirtualized environments, but
    inapproprate for others.

 2. Check the hardware architecture, and dispatch to the appropriate
    kernel entrypoint.  If the bootloader doesn't set this, then we
    simply do the normal boot sequence.

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Acked-by: H. Peter Anvin <hpa@zytor.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Vivek Goyal <vgoyal@in.ibm.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Zachary Amsden <zach@vmware.com>
Cc: Andi Kleen <ak@suse.de>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/boot/compressed/head_32.S |   15 +++++++--
 arch/x86/boot/compressed/misc_32.c |    3 +
 arch/x86/boot/header.S             |    7 +++-
 arch/x86/kernel/head_32.S          |   44 +++++++++++++++++++++++++--
 4 files changed, 63 insertions(+), 6 deletions(-)

diff -puN arch/x86/boot/compressed/head_32.S~i386-paravirt-boot-sequence arch/x86/boot/compressed/head_32.S
--- a/arch/x86/boot/compressed/head_32.S~i386-paravirt-boot-sequence
+++ a/arch/x86/boot/compressed/head_32.S
@@ -27,13 +27,22 @@
 #include <asm/segment.h>
 #include <asm/page.h>
 #include <asm/boot.h>
+#include <asm/asm-offsets.h>
 
 .section ".text.head","ax",@progbits
 	.globl startup_32
 
 startup_32:
-	cld
-	cli
+	/* check to see if KEEP_SEGMENTS flag is meaningful */
+	cmpw $0x207, BP_version(%esi)
+	jb 1f
+
+	/* test KEEP_SEGMENTS flag to see if the bootloader is asking
+	 * us to not reload segments */
+	testb $(1<<6), BP_loadflags(%esi)
+	jnz 2f
+
+1:	cli
 	movl $(__BOOT_DS),%eax
 	movl %eax,%ds
 	movl %eax,%es
@@ -41,6 +50,8 @@ startup_32:
 	movl %eax,%gs
 	movl %eax,%ss
 
+2:	cld
+
 /* Calculate the delta between where we were compiled to run
  * at and where we were actually loaded at.  This can only be done
  * with a short local call on x86.  Nothing  else will tell us what
diff -puN arch/x86/boot/compressed/misc_32.c~i386-paravirt-boot-sequence arch/x86/boot/compressed/misc_32.c
--- a/arch/x86/boot/compressed/misc_32.c~i386-paravirt-boot-sequence
+++ a/arch/x86/boot/compressed/misc_32.c
@@ -247,6 +247,9 @@ static void putstr(const char *s)
 	int x,y,pos;
 	char c;
 
+	if (RM_SCREEN_INFO.orig_video_mode == 0 && lines == 0 && cols == 0)
+		return;
+
 	x = RM_SCREEN_INFO.orig_x;
 	y = RM_SCREEN_INFO.orig_y;
 
diff -puN arch/x86/boot/header.S~i386-paravirt-boot-sequence arch/x86/boot/header.S
--- a/arch/x86/boot/header.S~i386-paravirt-boot-sequence
+++ a/arch/x86/boot/header.S
@@ -119,7 +119,7 @@ _start:
 	# Part 2 of the header, from the old setup.S
 
 		.ascii	"HdrS"		# header signature
-		.word	0x0206		# header version number (>= 0x0105)
+		.word	0x0207		# header version number (>= 0x0105)
 					# or else old loadlin-1.5 will fail)
 		.globl realmode_swtch
 realmode_swtch:	.word	0, 0		# default_switch, SETUPSEG
@@ -214,6 +214,11 @@ cmdline_size:   .long   COMMAND_LINE_SIZ
                                                 #added with boot protocol
                                                 #version 2.06
 
+hardware_subarch:	.long 0			# subarchitecture, added with 2.07
+						# default to 0 for normal x86 PC
+
+hardware_subarch_data:	.quad 0
+
 # End of setup header #####################################################
 
 	.section ".inittext", "ax"
diff -puN arch/x86/kernel/head_32.S~i386-paravirt-boot-sequence arch/x86/kernel/head_32.S
--- a/arch/x86/kernel/head_32.S~i386-paravirt-boot-sequence
+++ a/arch/x86/kernel/head_32.S
@@ -70,22 +70,30 @@ INIT_MAP_BEYOND_END = BOOTBITMAP_SIZE + 
  */
 .section .text.head,"ax",@progbits
 ENTRY(startup_32)
+	/* check to see if KEEP_SEGMENTS flag is meaningful */
+	cmpw $0x207, BP_version(%esi)
+	jb 1f
+
+	/* test KEEP_SEGMENTS flag to see if the bootloader is asking
+		us to not reload segments */
+	testb $(1<<6), BP_loadflags(%esi)
+	jnz 2f
 
 /*
  * Set segments to known values.
  */
-	cld
-	lgdt boot_gdt_descr - __PAGE_OFFSET
+1:	lgdt boot_gdt_descr - __PAGE_OFFSET
 	movl $(__BOOT_DS),%eax
 	movl %eax,%ds
 	movl %eax,%es
 	movl %eax,%fs
 	movl %eax,%gs
+2:
 
 /*
  * Clear BSS first so that there are no surprises...
- * No need to cld as DF is already clear from cld above...
  */
+	cld
 	xorl %eax,%eax
 	movl $__bss_start - __PAGE_OFFSET,%edi
 	movl $__bss_stop - __PAGE_OFFSET,%ecx
@@ -119,6 +127,35 @@ ENTRY(startup_32)
 	movsl
 1:
 
+#ifdef CONFIG_PARAVIRT
+	cmpw $0x207, (boot_params + BP_version - __PAGE_OFFSET)
+	jb default_entry
+
+	/* Paravirt-compatible boot parameters.  Look to see what architecture
+		we're booting under. */
+	movl (boot_params + BP_hardware_subarch - __PAGE_OFFSET), %eax
+	cmpl $num_subarch_entries, %eax
+	jae bad_subarch
+
+	movl subarch_entries - __PAGE_OFFSET(,%eax,4), %eax
+	subl $__PAGE_OFFSET, %eax
+	jmp *%eax
+
+bad_subarch:
+WEAK(lguest_entry)
+WEAK(xen_entry)
+	/* Unknown implementation; there's really
+	   nothing we can do at this point. */
+	ud2a
+.data
+subarch_entries:
+	.long default_entry		/* normal x86/PC */
+	.long lguest_entry		/* lguest hypervisor */
+	.long xen_entry			/* Xen hypervisor */
+num_subarch_entries = (. - subarch_entries) / 4
+.previous
+#endif /* CONFIG_PARAVIRT */
+
 /*
  * Initialize page tables.  This creates a PDE and a set of page
  * tables, which are located immediately beyond _end.  The variable
@@ -131,6 +168,7 @@ ENTRY(startup_32)
  */
 page_pde_offset = (__PAGE_OFFSET >> 20);
 
+default_entry:
 	movl $(pg0 - __PAGE_OFFSET), %edi
 	movl $(swapper_pg_dir - __PAGE_OFFSET), %edx
 	movl $0x007, %eax			/* 0x007 = PRESENT+RW+USER */
_

Patches currently in -mm which might be from rusty@rustcorp.com.au are

origin.patch
remove-unsafe-from-module-struct.patch
delay-creation-of-khcvd-thread.patch
hvc-console-is-also-used-by-iseries-so-add-that-to-hvc_driver-help.patch
module-return-error-when-mod_sysfs_init-failed.patch
git-kvm.patch
update-boot-spec-to-207.patch
add-weak-for-creating-weak-asm-labels.patch
i386-paravirt-boot-sequence.patch
make-asm-x86-bootparamh-includable-from-userspace.patch
cpu-hotplug-cpu-deliver-cpu_up_canceled-only-to-notify_oked-callbacks-with-cpu_up_prepare.patch
linux-kernel-markers.patch
linux-kernel-markers-checkpatch-fixes.patch
linux-kernel-markers-coding-style-fixes.patch
linux-kernel-markers-samples-coding-style-fix.patch
mm-clean-up-and-kernelify-shrinker-registration-reiser4.patch
