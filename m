From: akpm@linux-foundation.org
Subject: - x86_64-display-more-intutive-error-message-if-kernel-is-not-2mb-aligned.patch removed from -mm tree
Date: Fri, 11 May 2007 22:32:24 -0700
Message-ID: <200705120532.l4C5WOD8002043@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:47318 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750930AbXELFch (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 12 May 2007 01:32:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vgoyal@in.ibm.com, ak@suse.de, ebiederm@xmission.com, mm-commits@vger.kernel.org


The patch titled
     x86_64: display more intuitive error message if kernel is not 2MB aligned
has been removed from the -mm tree.  Its filename was
     x86_64-display-more-intutive-error-message-if-kernel-is-not-2mb-aligned.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: x86_64: display more intuitive error message if kernel is not 2MB aligned
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
fix-i-oat-for-kexec.patch
