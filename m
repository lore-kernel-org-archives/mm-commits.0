From: akpm@linux-foundation.org
Subject: + change-sysenter_setup-to-__cpuinit-improve-__init.patch added to -mm tree
Date: Wed, 21 Feb 2007 13:52:22 -0800
Message-ID: <200702212152.l1LLqMUC027551@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:50797 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422655AbXBUVwt (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 21 Feb 2007 16:52:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: prarit@redhat.com, ak@suse.de, mingo@elte.hu, zwane@infradead.org


The patch titled
     Change sysenter_setup to __cpuinit & improve __INIT, __INITDATA
has been added to the -mm tree.  Its filename is
     change-sysenter_setup-to-__cpuinit-improve-__init.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Change sysenter_setup to __cpuinit & improve __INIT, __INITDATA
From: Prarit Bhargava <prarit@redhat.com>

Change sysenter_setup to __cpuinit.
Add __CPUINIT & __CPUINITDATA.

Resolve MODPOST warnings similar to:

WARNING: vmlinux - Section mismatch: reference to .init.text:sysenter_setup from
 .text between 'identify_cpu' (at offset 0xc040a380) and 'detect_ht'

and

WARNING: vmlinux - Section mismatch: reference to .init.data:vsyscall_int80_end
from .text between 'sysenter_setup' (at offset 0xc041a269) and 'enable_sep_cpu'
WARNING: vmlinux - Section mismatch: reference to
.init.data:vsyscall_int80_start from .text between 'sysenter_setup' (at offset
0xc041a26e) and 'enable_sep_cpu'
WARNING: vmlinux - Section mismatch: reference to
.init.data:vsyscall_sysenter_end from .text between 'sysenter_setup' (at offset
0xc041a275) and 'enable_sep_cpu'
WARNING: vmlinux - Section mismatch: reference to
.init.data:vsyscall_sysenter_start from .text between 'sysenter_setup' (at
offset 0xc041a27a) and 'enable_sep_cpu'

Signed-off-by: Prarit Bhargava <prarit@redhat.com>
Cc: Zwane Mwaikambo <zwane@infradead.org>
Cc: Andi Kleen <ak@suse.de>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/sysenter.c |    2 +-
 arch/x86_64/kernel/head.S   |    4 +---
 include/linux/init.h        |    8 ++++++++
 3 files changed, 10 insertions(+), 4 deletions(-)

diff -puN arch/i386/kernel/sysenter.c~change-sysenter_setup-to-__cpuinit-improve-__init arch/i386/kernel/sysenter.c
--- a/arch/i386/kernel/sysenter.c~change-sysenter_setup-to-__cpuinit-improve-__init
+++ a/arch/i386/kernel/sysenter.c
@@ -72,7 +72,7 @@ extern const char vsyscall_int80_start, 
 extern const char vsyscall_sysenter_start, vsyscall_sysenter_end;
 static struct page *syscall_pages[1];
 
-int __init sysenter_setup(void)
+int __cpuinit sysenter_setup(void)
 {
 	void *syscall_page = (void *)get_zeroed_page(GFP_ATOMIC);
 	syscall_pages[0] = virt_to_page(syscall_page);
diff -puN arch/x86_64/kernel/head.S~change-sysenter_setup-to-__cpuinit-improve-__init arch/x86_64/kernel/head.S
--- a/arch/x86_64/kernel/head.S~change-sysenter_setup-to-__cpuinit-improve-__init
+++ a/arch/x86_64/kernel/head.S
@@ -324,9 +324,7 @@ ENTRY(wakeup_level4_pgt)
 	.quad	phys_level3_kernel_pgt | 0x007
 #endif
 
-#ifndef CONFIG_HOTPLUG_CPU
-	__INITDATA
-#endif
+	__CPUINITDATA
 	/*
 	 * This default setting generates an ident mapping at address 0x100000
 	 * and a mapping for the kernel that precisely maps virtual address
diff -puN include/linux/init.h~change-sysenter_setup-to-__cpuinit-improve-__init include/linux/init.h
--- a/include/linux/init.h~change-sysenter_setup-to-__cpuinit-improve-__init
+++ a/include/linux/init.h
@@ -56,6 +56,14 @@
 #define __FINIT		.previous
 #define __INITDATA	.section	".init.data","aw"
 
+#ifdef CONFIG_HOTPLUG_CPU
+#define __CPUINIT	.section	".text","ax"
+#define __CPUINITDATA	.section	".data","ax"
+#else
+#define __CPUINIT	__INIT
+#define __CPUINITDATA	__INITDATA
+#endif
+
 #ifndef __ASSEMBLY__
 /*
  * Used for initialization calls..
_

Patches currently in -mm which might be from prarit@redhat.com are

change-sysenter_setup-to-__cpuinit-improve-__init.patch
