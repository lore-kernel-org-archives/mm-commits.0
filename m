From: akpm@linux-foundation.org
Subject: + fix-x86_64-mm-relocatable-kernel-support.patch added to -mm tree
Date: Mon, 02 Apr 2007 14:08:44 -0700
Message-ID: <200704022108.l32L8iab009498@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:45713 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965889AbXDBVI7 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 2 Apr 2007 17:08:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: vgoyal@in.ibm.com, ak@suse.de, ebiederm@xmission.com


The patch titled
     x86_64-mm-relocatable-kernel-support: build-time checking
has been added to the -mm tree.  Its filename is
     fix-x86_64-mm-relocatable-kernel-support.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

 arch/x86_64/kernel/head64.c |    8 ++++++++
 include/asm-x86_64/page.h   |    1 +
 2 files changed, 9 insertions(+)

diff -puN arch/x86_64/kernel/head64.c~fix-x86_64-mm-relocatable-kernel-support arch/x86_64/kernel/head64.c
--- a/arch/x86_64/kernel/head64.c~fix-x86_64-mm-relocatable-kernel-support
+++ a/arch/x86_64/kernel/head64.c
@@ -62,6 +62,14 @@ void __init x86_64_start_kernel(char * r
 {
 	int i;
 
+	/*
+	 * Make sure kernel is aligned to 2MB address. Catching it at compile
+	 * time is better. Change your config file and compile the kernel
+	 * for a 2MB aligned address (CONFIG_PHYSICAL_START)
+	 */
+	BUILD_BUG_ON(ALIGN(CONFIG_PHYSICAL_START, __KERNEL_ALIGN)
+			!= CONFIG_PHYSICAL_START);
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
fix-x86_64-mm-relocatable-kernel-support.patch
kdump-kexec-calculate-note-size-at-compile-time.patch
