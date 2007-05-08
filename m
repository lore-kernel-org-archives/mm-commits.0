From: akpm@linux-foundation.org
Subject: + x86_64-display-more-intutive-error-message-if-kernel-is-not-2mb-aligned.patch added to -mm tree
Date: Tue, 08 May 2007 14:22:49 -0700
Message-ID: <200705082122.l48LMnXF002044@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:59763 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1032344AbXEHVXG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 17:23:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: vgoyal@in.ibm.com, ak@suse.de, ebiederm@xmission.com


The patch titled
     x86_64: display more intutive error message if kernel is not 2MB aligned
has been added to the -mm tree.  Its filename is
     x86_64-display-more-intutive-error-message-if-kernel-is-not-2mb-aligned.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: x86_64: display more intutive error message if kernel is not 2MB aligned
From: Vivek Goyal <vgoyal@in.ibm.com>

o x86_64 kernel needs to be compiled for 2MB aligned addresses. Currently
  we are using BUILD_BUG_ON() to warn the user if he has not done so. But
  looks like folks are not finding message very intutive and don't open
  the respective c file to find problem source. (Bug 8439)

arch/x86_64/kernel/head64.c: In function 'x86_64_start_kernel':
arch/x86_64/kernel/head64.c:70: error: size of array 'type name' is negative

o Using preprocessor directive #error to print a better message if
  CONFIG_PHYSICAL_START is not aligned to 2MB boundary.

Signed-off-by: Vivek Goyal <vgoyal@in.ibm.com>
Cc: Andi Kleen <ak@suse.de>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86_64/kernel/head64.c |    7 -------
 include/asm-x86_64/page.h   |    9 +++++++++
 2 files changed, 9 insertions(+), 7 deletions(-)

diff -puN arch/x86_64/kernel/head64.c~x86_64-display-more-intutive-error-message-if-kernel-is-not-2mb-aligned arch/x86_64/kernel/head64.c
--- a/arch/x86_64/kernel/head64.c~x86_64-display-more-intutive-error-message-if-kernel-is-not-2mb-aligned
+++ a/arch/x86_64/kernel/head64.c
@@ -62,13 +62,6 @@ void __init x86_64_start_kernel(char * r
 {
 	int i;
 
-	/*
-	 * Make sure kernel is aligned to 2MB address. Catching it at compile
-	 * time is better. Change your config file and compile the kernel
-	 * for a 2MB aligned address (CONFIG_PHYSICAL_START)
-	 */
-	BUILD_BUG_ON(CONFIG_PHYSICAL_START & (__KERNEL_ALIGN - 1));
-
 	/* clear bss before set_intr_gate with early_idt_handler */
 	clear_bss();
 
diff -puN include/asm-x86_64/page.h~x86_64-display-more-intutive-error-message-if-kernel-is-not-2mb-aligned include/asm-x86_64/page.h
--- a/include/asm-x86_64/page.h~x86_64-display-more-intutive-error-message-if-kernel-is-not-2mb-aligned
+++ a/include/asm-x86_64/page.h
@@ -80,6 +80,15 @@ extern unsigned long phys_base;
 #define __PHYSICAL_START	CONFIG_PHYSICAL_START
 #define __KERNEL_ALIGN		0x200000
 
+/*
+ * Make sure kernel is aligned to 2MB address. Catching it at compile
+ * time is better. Change your config file and compile the kernel
+ * for a 2MB aligned address (CONFIG_PHYSICAL_START)
+ */
+#if (CONFIG_PHYSICAL_START % __KERNEL_ALIGN) != 0
+#error "CONFIG_PHYSICAL_START must be a multiple of 2MB"
+#endif
+
 #define __START_KERNEL		(__START_KERNEL_map + __PHYSICAL_START)
 #define __START_KERNEL_map	_AC(0xffffffff80000000, UL)
 #define __PAGE_OFFSET           _AC(0xffff810000000000, UL)
_

Patches currently in -mm which might be from vgoyal@in.ibm.com are

origin.patch
kdump-kexec-calculate-note-size-at-compile-time.patch
fix-i-oat-for-kexec.patch
x86_64-display-more-intutive-error-message-if-kernel-is-not-2mb-aligned.patch
remove-hardcoding-of-hard_smp_processor_id-on-up.patch
use-the-apic-to-determine-the-hardware-processor-id-i386.patch
use-the-apic-to-determine-the-hardware-processor-id-x86_64.patch
always-ask-the-hardware-to-obtain-hardware-processor-id-ia64.patch
