From: akpm@linux-foundation.org
Subject: - fix-x86_64-mm-relocatable-kernel-support.patch removed from -mm tree
Date: Fri, 13 Apr 2007 16:29:44 -0700
Message-ID: <200704132329.l3DNTiNq012648@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:60554 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161140AbXDMX3y (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 13 Apr 2007 19:29:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vgoyal@in.ibm.com, ak@suse.de, ebiederm@xmission.com, mm-commits@vger.kernel.org


The patch titled
     x86_64-mm-relocatable-kernel-support: build-time checking
has been removed from the -mm tree.  Its filename was
     fix-x86_64-mm-relocatable-kernel-support.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: x86_64-mm-relocatable-kernel-support: build-time checking
From: Vivek Goyal <vgoyal@in.ibm.com>

o X86_64 kernel should run from 2MB aligned address for two reasons.
	- Performance.
	- For relocatable kernels, page tables are updated based on difference
	  between compile time address and load time physical address.
	  This difference should be multiple of 2MB as kernel text and data
	  is mapped using 2MB pages and PMD should be pointing to a 2MB
	  aligned address. Life is simpler if both compile time and load time
	  kernel addresses are 2MB aligned.

o Flag the error at compile time if one is trying to build a kernel which
  does not meet alignment restrictions.

Signed-off-by: Vivek Goyal <vgoyal@in.ibm.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86_64/boot/compressed/misc.c |    2 +-
 arch/x86_64/kernel/head64.c        |    7 +++++++
 include/asm-x86_64/page.h          |    1 +
 3 files changed, 9 insertions(+), 1 deletion(-)

diff -puN arch/x86_64/boot/compressed/misc.c~fix-x86_64-mm-relocatable-kernel-support arch/x86_64/boot/compressed/misc.c
--- a/arch/x86_64/boot/compressed/misc.c~fix-x86_64-mm-relocatable-kernel-support
+++ a/arch/x86_64/boot/compressed/misc.c
@@ -358,7 +358,7 @@ asmlinkage void decompress_kernel(void *
 	insize = input_len;
 	inptr  = 0;
 
-	if ((ulg)output & 0x1fffffUL)
+	if ((ulg)output & (__KERNEL_ALIGN - 1))
 		error("Destination address not 2M aligned");
 	if ((ulg)output >= 0xffffffffffUL)
 		error("Destination address too large");
diff -puN arch/x86_64/kernel/head64.c~fix-x86_64-mm-relocatable-kernel-support arch/x86_64/kernel/head64.c
--- a/arch/x86_64/kernel/head64.c~fix-x86_64-mm-relocatable-kernel-support
+++ a/arch/x86_64/kernel/head64.c
@@ -62,6 +62,13 @@ void __init x86_64_start_kernel(char * r
 {
 	int i;
 
+	/*
+	 * Make sure kernel is aligned to 2MB address. Catching it at compile
+	 * time is better. Change your config file and compile the kernel
+	 * for a 2MB aligned address (CONFIG_PHYSICAL_START)
+	 */
+	BUILD_BUG_ON(CONFIG_PHYSICAL_START & (__KERNEL_ALIGN - 1));
+
 	/* clear bss before set_intr_gate with early_idt_handler */
 	clear_bss();
 
diff -puN include/asm-x86_64/page.h~fix-x86_64-mm-relocatable-kernel-support include/asm-x86_64/page.h
--- a/include/asm-x86_64/page.h~fix-x86_64-mm-relocatable-kernel-support
+++ a/include/asm-x86_64/page.h
@@ -78,6 +78,7 @@ extern unsigned long phys_base;
 #endif /* !__ASSEMBLY__ */
 
 #define __PHYSICAL_START	CONFIG_PHYSICAL_START
+#define __KERNEL_ALIGN		0x200000
 #define __START_KERNEL		(__START_KERNEL_map + __PHYSICAL_START)
 #define __START_KERNEL_map	0xffffffff80000000
 #define __PAGE_OFFSET           0xffff810000000000
_

Patches currently in -mm which might be from vgoyal@in.ibm.com are

fix-i-oat-for-kexec.patch
kdump-kexec-calculate-note-size-at-compile-time.patch
kdump-kexec-calculate-note-size-at-compile-time-update.patch
kdump-kexec-calculate-note-size-at-compile-time-update-2.patch
remove-hardcoding-of-hard_smp_processor_id-on-up.patch
use-the-apic-to-determine-the-hardware-processor-id-i386.patch
use-the-apic-to-determine-the-hardware-processor-id-x86_64.patch
always-ask-the-hardware-to-obtain-hardware-processor-id-ia64.patch
