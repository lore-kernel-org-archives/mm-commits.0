From: akpm@linux-foundation.org
Subject: + update-boot-spec-to-207.patch added to -mm tree
Date: Wed, 17 Oct 2007 14:35:50 -0700
Message-ID: <200710172135.l9HLZoIU009471@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55753 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755743AbXJQVgB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 17 Oct 2007 17:36:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rusty@rustcorp.com.au, ebiederm@xmission.com, hpa@zytor.com, jeremy@xensource.com, vgoyal@in.ibm.com


The patch titled
     update boot spec to 2.07
has been added to the -mm tree.  Its filename is
     update-boot-spec-to-207.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: update boot spec to 2.07
From: Rusty Russell <rusty@rustcorp.com.au>

Updates for version 2.07 of the boot protocol.  This includes:

load_flags.KEEP_SEGMENTS- flag to request/inhibit segment reloads
hardware_subarch	- what subarchitecture we're booting under
hardware_subarch_data	- per-architecture data

The intention of these changes is to make booting a paravirtualized
kernel work via the normal Linux boot protocol.

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Acked-by: H. Peter Anvin <hpa@zytor.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Vivek Goyal <vgoyal@in.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/i386/boot.txt      |   34 ++++++++++++++++++++++++++++-
 arch/x86/kernel/asm-offsets_32.c |    7 +++++
 include/asm-x86/bootparam.h      |    9 +++++--
 3 files changed, 47 insertions(+), 3 deletions(-)

diff -puN Documentation/i386/boot.txt~update-boot-spec-to-207 Documentation/i386/boot.txt
--- a/Documentation/i386/boot.txt~update-boot-spec-to-207
+++ a/Documentation/i386/boot.txt
@@ -168,6 +168,8 @@ Offset	Proto	Name		Meaning
 0234/1	2.05+	relocatable_kernel Whether kernel is relocatable or not
 0235/3	N/A	pad2		Unused
 0238/4	2.06+	cmdline_size	Maximum size of the kernel command line
+023C/4	2.07+	hardware_subarch Hardware subarchitecture
+0240/8	2.07+	hardware_subarch_data Subarchitecture-specific data
 
 (1) For backwards compatibility, if the setup_sects field contains 0, the
     real value is 4.
@@ -204,7 +206,7 @@ boot loaders can ignore those fields.
 
 The byte order of all fields is littleendian (this is x86, after all.)
 
-Field name:	setup_secs
+Field name:	setup_sects
 Type:		read
 Offset/size:	0x1f1/1
 Protocol:	ALL
@@ -356,6 +358,13 @@ Protocol:	2.00+
 	- If 0, the protected-mode code is loaded at 0x10000.
 	- If 1, the protected-mode code is loaded at 0x100000.
 
+  Bit 6 (write): KEEP_SEGMENTS
+	Protocol: 2.07+
+	- if 0, reload the segment registers in the 32bit entry point.
+	- if 1, do not reload the segment registers in the 32bit entry point.
+		Assume that %cs %ds %ss %es are all set to flat segments with
+		a base of 0 (or the equivalent for their environment).
+
   Bit 7 (write): CAN_USE_HEAP
 	Set this bit to 1 to indicate that the value entered in the
 	heap_end_ptr is valid.  If this field is clear, some setup code
@@ -480,6 +489,29 @@ Protocol:	2.06+
   cmdline_size characters. With protocol version 2.05 and earlier, the
   maximum size was 255.
 
+Field name:	hardware_subarch
+Type:		write
+Offset/size:	0x23c/4
+Protocol:	2.07+
+
+  In a paravirtualized environment the hardware low level architectural
+  pieces such as interrupt handling, page table handling, and
+  accessing process control registers needs to be done differently.
+
+  This field allows the bootloader to inform the kernel we are in one
+  one of those environments.
+
+  0x00000000	The default x86/PC environment
+  0x00000001	lguest
+  0x00000002	Xen
+
+Field name:	hardware_subarch_data
+Type:		write
+Offset/size:	0x240/8
+Protocol:	2.07+
+
+  A pointer to data that is specific to hardware subarch
+
 
 **** THE KERNEL COMMAND LINE
 
diff -puN arch/x86/kernel/asm-offsets_32.c~update-boot-spec-to-207 arch/x86/kernel/asm-offsets_32.c
--- a/arch/x86/kernel/asm-offsets_32.c~update-boot-spec-to-207
+++ a/arch/x86/kernel/asm-offsets_32.c
@@ -15,6 +15,7 @@
 #include <asm/fixmap.h>
 #include <asm/processor.h>
 #include <asm/thread_info.h>
+#include <asm/bootparam.h>
 #include <asm/elf.h>
 
 #include <xen/interface/xen.h>
@@ -144,4 +145,10 @@ void foo(void)
 	OFFSET(LGUEST_PAGES_regs_errcode, lguest_pages, regs.errcode);
 	OFFSET(LGUEST_PAGES_regs, lguest_pages, regs);
 #endif
+
+	BLANK();
+	OFFSET(BP_scratch, boot_params, scratch);
+	OFFSET(BP_loadflags, boot_params, hdr.loadflags);
+	OFFSET(BP_hardware_subarch, boot_params, hdr.hardware_subarch);
+	OFFSET(BP_version, boot_params, hdr.version);
 }
diff -puN include/asm-x86/bootparam.h~update-boot-spec-to-207 include/asm-x86/bootparam.h
--- a/include/asm-x86/bootparam.h~update-boot-spec-to-207
+++ a/include/asm-x86/bootparam.h
@@ -25,8 +25,9 @@ struct setup_header {
 	u16	kernel_version;
 	u8	type_of_loader;
 	u8	loadflags;
-#define LOADED_HIGH	0x01
-#define CAN_USE_HEAP	0x80
+#define LOADED_HIGH	(1<<0)
+#define KEEP_SEGMENTS	(1<<6)
+#define CAN_USE_HEAP	(1<<7)
 	u16	setup_move_size;
 	u32	code32_start;
 	u32	ramdisk_image;
@@ -38,6 +39,10 @@ struct setup_header {
 	u32	initrd_addr_max;
 	u32	kernel_alignment;
 	u8	relocatable_kernel;
+	u8	_pad2[3];
+	u32	cmdline_size;
+	u32	hardware_subarch;
+	u64	hardware_subarch_data;
 } __attribute__((packed));
 
 struct sys_desc_table {
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
