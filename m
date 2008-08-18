From: akpm@linux-foundation.org
Subject: - kexec-jump-rename-kexec_control_code_size-to-kexec_control_page_size.patch removed from -mm tree
Date: Mon, 18 Aug 2008 12:39:25 -0700
Message-ID: <200808181939.m7IJdPBI008296@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54764 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757589AbYHRTkN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 18 Aug 2008 15:40:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ying.huang@intel.com, benh@kernel.crashing.org, ebiederm@xmission.com, mingo@elte.hu, pavel@ucw.cz, rjw@sisk.pl, rmk@arm.linux.org.uk, vgoyal@redhat.com, mm-commits@vger.kernel.org


The patch titled
     kexec jump: rename KEXEC_CONTROL_CODE_SIZE to KEXEC_CONTROL_PAGE_SIZE
has been removed from the -mm tree.  Its filename was
     kexec-jump-rename-kexec_control_code_size-to-kexec_control_page_size.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: kexec jump: rename KEXEC_CONTROL_CODE_SIZE to KEXEC_CONTROL_PAGE_SIZE
From: Huang Ying <ying.huang@intel.com>

Rename KEXEC_CONTROL_CODE_SIZE to KEXEC_CONTROL_PAGE_SIZE, because control
page is used for not only code on some platform.  For example in kexec
jump, it is used for data and stack too.

[akpm@linux-foundation.org: unbreak powerpc and arm, finish conversion]
Signed-off-by: Huang Ying <ying.huang@intel.com>
Cc: Pavel Machek <pavel@ucw.cz>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Russell King <rmk@arm.linux.org.uk>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/include/asm/kexec.h           |    2 +-
 arch/arm/kernel/machine_kexec.c        |    2 +-
 arch/ia64/include/asm/kexec.h          |    2 +-
 arch/powerpc/include/asm/kexec.h       |    2 +-
 arch/powerpc/kernel/machine_kexec_32.c |    2 +-
 arch/s390/include/asm/kexec.h          |    2 +-
 arch/sh/include/asm/kexec.h            |    2 +-
 arch/x86/kernel/machine_kexec_32.c     |    2 +-
 include/asm-mips/kexec.h               |    2 +-
 include/asm-x86/kexec.h                |    4 ++--
 include/linux/kexec.h                  |    4 ++--
 kernel/kexec.c                         |    6 +++---
 12 files changed, 16 insertions(+), 16 deletions(-)

diff -puN arch/arm/include/asm/kexec.h~kexec-jump-rename-kexec_control_code_size-to-kexec_control_page_size arch/arm/include/asm/kexec.h
--- a/arch/arm/include/asm/kexec.h~kexec-jump-rename-kexec_control_code_size-to-kexec_control_page_size
+++ a/arch/arm/include/asm/kexec.h
@@ -10,7 +10,7 @@
 /* Maximum address we can use for the control code buffer */
 #define KEXEC_CONTROL_MEMORY_LIMIT (-1UL)
 
-#define KEXEC_CONTROL_CODE_SIZE	4096
+#define KEXEC_CONTROL_PAGE_SIZE	4096
 
 #define KEXEC_ARCH KEXEC_ARCH_ARM
 
diff -puN arch/arm/kernel/machine_kexec.c~kexec-jump-rename-kexec_control_code_size-to-kexec_control_page_size arch/arm/kernel/machine_kexec.c
--- a/arch/arm/kernel/machine_kexec.c~kexec-jump-rename-kexec_control_code_size-to-kexec_control_page_size
+++ a/arch/arm/kernel/machine_kexec.c
@@ -71,7 +71,7 @@ void machine_kexec(struct kimage *image)
 
 
 	flush_icache_range((unsigned long) reboot_code_buffer,
-			   (unsigned long) reboot_code_buffer + KEXEC_CONTROL_CODE_SIZE);
+			   (unsigned long) reboot_code_buffer + KEXEC_CONTROL_PAGE_SIZE);
 	printk(KERN_INFO "Bye!\n");
 
 	cpu_proc_fin();
diff -puN arch/ia64/include/asm/kexec.h~kexec-jump-rename-kexec_control_code_size-to-kexec_control_page_size arch/ia64/include/asm/kexec.h
--- a/arch/ia64/include/asm/kexec.h~kexec-jump-rename-kexec_control_code_size-to-kexec_control_page_size
+++ a/arch/ia64/include/asm/kexec.h
@@ -9,7 +9,7 @@
 /* Maximum address we can use for the control code buffer */
 #define KEXEC_CONTROL_MEMORY_LIMIT TASK_SIZE
 
-#define KEXEC_CONTROL_CODE_SIZE (8192 + 8192 + 4096)
+#define KEXEC_CONTROL_PAGE_SIZE (8192 + 8192 + 4096)
 
 /* The native architecture */
 #define KEXEC_ARCH KEXEC_ARCH_IA_64
diff -puN arch/powerpc/include/asm/kexec.h~kexec-jump-rename-kexec_control_code_size-to-kexec_control_page_size arch/powerpc/include/asm/kexec.h
--- a/arch/powerpc/include/asm/kexec.h~kexec-jump-rename-kexec_control_code_size-to-kexec_control_page_size
+++ a/arch/powerpc/include/asm/kexec.h
@@ -22,7 +22,7 @@
 #define KEXEC_CONTROL_MEMORY_LIMIT TASK_SIZE
 #endif
 
-#define KEXEC_CONTROL_CODE_SIZE 4096
+#define KEXEC_CONTROL_PAGE_SIZE 4096
 
 /* The native architecture */
 #ifdef __powerpc64__
diff -puN arch/powerpc/kernel/machine_kexec_32.c~kexec-jump-rename-kexec_control_code_size-to-kexec_control_page_size arch/powerpc/kernel/machine_kexec_32.c
--- a/arch/powerpc/kernel/machine_kexec_32.c~kexec-jump-rename-kexec_control_code_size-to-kexec_control_page_size
+++ a/arch/powerpc/kernel/machine_kexec_32.c
@@ -51,7 +51,7 @@ void default_machine_kexec(struct kimage
 						relocate_new_kernel_size);
 
 	flush_icache_range(reboot_code_buffer,
-				reboot_code_buffer + KEXEC_CONTROL_CODE_SIZE);
+				reboot_code_buffer + KEXEC_CONTROL_PAGE_SIZE);
 	printk(KERN_INFO "Bye!\n");
 
 	/* now call it */
diff -puN arch/s390/include/asm/kexec.h~kexec-jump-rename-kexec_control_code_size-to-kexec_control_page_size arch/s390/include/asm/kexec.h
--- a/arch/s390/include/asm/kexec.h~kexec-jump-rename-kexec_control_code_size-to-kexec_control_page_size
+++ a/arch/s390/include/asm/kexec.h
@@ -31,7 +31,7 @@
 #define KEXEC_CONTROL_MEMORY_LIMIT (1UL<<31)
 
 /* Allocate one page for the pdp and the second for the code */
-#define KEXEC_CONTROL_CODE_SIZE 4096
+#define KEXEC_CONTROL_PAGE_SIZE 4096
 
 /* The native architecture */
 #define KEXEC_ARCH KEXEC_ARCH_S390
diff -puN arch/sh/include/asm/kexec.h~kexec-jump-rename-kexec_control_code_size-to-kexec_control_page_size arch/sh/include/asm/kexec.h
--- a/arch/sh/include/asm/kexec.h~kexec-jump-rename-kexec_control_code_size-to-kexec_control_page_size
+++ a/arch/sh/include/asm/kexec.h
@@ -21,7 +21,7 @@
 /* Maximum address we can use for the control code buffer */
 #define KEXEC_CONTROL_MEMORY_LIMIT TASK_SIZE
 
-#define KEXEC_CONTROL_CODE_SIZE	4096
+#define KEXEC_CONTROL_PAGE_SIZE	4096
 
 /* The native architecture */
 #define KEXEC_ARCH KEXEC_ARCH_SH
diff -puN arch/x86/kernel/machine_kexec_32.c~kexec-jump-rename-kexec_control_code_size-to-kexec_control_page_size arch/x86/kernel/machine_kexec_32.c
--- a/arch/x86/kernel/machine_kexec_32.c~kexec-jump-rename-kexec_control_code_size-to-kexec_control_page_size
+++ a/arch/x86/kernel/machine_kexec_32.c
@@ -78,7 +78,7 @@ static void load_segments(void)
 /*
  * A architecture hook called to validate the
  * proposed image and prepare the control pages
- * as needed.  The pages for KEXEC_CONTROL_CODE_SIZE
+ * as needed.  The pages for KEXEC_CONTROL_PAGE_SIZE
  * have been allocated, but the segments have yet
  * been copied into the kernel.
  *
diff -puN include/asm-mips/kexec.h~kexec-jump-rename-kexec_control_code_size-to-kexec_control_page_size include/asm-mips/kexec.h
--- a/include/asm-mips/kexec.h~kexec-jump-rename-kexec_control_code_size-to-kexec_control_page_size
+++ a/include/asm-mips/kexec.h
@@ -16,7 +16,7 @@
  /* Maximum address we can use for the control code buffer */
 #define KEXEC_CONTROL_MEMORY_LIMIT (0x20000000)
 
-#define KEXEC_CONTROL_CODE_SIZE 4096
+#define KEXEC_CONTROL_PAGE_SIZE 4096
 
 /* The native architecture */
 #define KEXEC_ARCH KEXEC_ARCH_MIPS
diff -puN include/asm-x86/kexec.h~kexec-jump-rename-kexec_control_code_size-to-kexec_control_page_size include/asm-x86/kexec.h
--- a/include/asm-x86/kexec.h~kexec-jump-rename-kexec_control_code_size-to-kexec_control_page_size
+++ a/include/asm-x86/kexec.h
@@ -63,7 +63,7 @@
 /* Maximum address we can use for the control code buffer */
 # define KEXEC_CONTROL_MEMORY_LIMIT TASK_SIZE
 
-# define KEXEC_CONTROL_CODE_SIZE	4096
+# define KEXEC_CONTROL_PAGE_SIZE	4096
 
 /* The native architecture */
 # define KEXEC_ARCH KEXEC_ARCH_386
@@ -79,7 +79,7 @@
 # define KEXEC_CONTROL_MEMORY_LIMIT     (0xFFFFFFFFFFUL)
 
 /* Allocate one page for the pdp and the second for the code */
-# define KEXEC_CONTROL_CODE_SIZE  (4096UL + 4096UL)
+# define KEXEC_CONTROL_PAGE_SIZE  (4096UL + 4096UL)
 
 /* The native architecture */
 # define KEXEC_ARCH KEXEC_ARCH_X86_64
diff -puN include/linux/kexec.h~kexec-jump-rename-kexec_control_code_size-to-kexec_control_page_size include/linux/kexec.h
--- a/include/linux/kexec.h~kexec-jump-rename-kexec_control_code_size-to-kexec_control_page_size
+++ a/include/linux/kexec.h
@@ -25,8 +25,8 @@
 #error KEXEC_CONTROL_MEMORY_LIMIT not defined
 #endif
 
-#ifndef KEXEC_CONTROL_CODE_SIZE
-#error KEXEC_CONTROL_CODE_SIZE not defined
+#ifndef KEXEC_CONTROL_PAGE_SIZE
+#error KEXEC_CONTROL_PAGE_SIZE not defined
 #endif
 
 #ifndef KEXEC_ARCH
diff -puN kernel/kexec.c~kexec-jump-rename-kexec_control_code_size-to-kexec_control_page_size kernel/kexec.c
--- a/kernel/kexec.c~kexec-jump-rename-kexec_control_code_size-to-kexec_control_page_size
+++ a/kernel/kexec.c
@@ -77,7 +77,7 @@ int kexec_should_crash(struct task_struc
  *
  * The code for the transition from the current kernel to the
  * the new kernel is placed in the control_code_buffer, whose size
- * is given by KEXEC_CONTROL_CODE_SIZE.  In the best case only a single
+ * is given by KEXEC_CONTROL_PAGE_SIZE.  In the best case only a single
  * page of memory is necessary, but some architectures require more.
  * Because this memory must be identity mapped in the transition from
  * virtual to physical addresses it must live in the range
@@ -242,7 +242,7 @@ static int kimage_normal_alloc(struct ki
 	 */
 	result = -ENOMEM;
 	image->control_code_page = kimage_alloc_control_pages(image,
-					   get_order(KEXEC_CONTROL_CODE_SIZE));
+					   get_order(KEXEC_CONTROL_PAGE_SIZE));
 	if (!image->control_code_page) {
 		printk(KERN_ERR "Could not allocate control_code_buffer\n");
 		goto out;
@@ -317,7 +317,7 @@ static int kimage_crash_alloc(struct kim
 	 */
 	result = -ENOMEM;
 	image->control_code_page = kimage_alloc_control_pages(image,
-					   get_order(KEXEC_CONTROL_CODE_SIZE));
+					   get_order(KEXEC_CONTROL_PAGE_SIZE));
 	if (!image->control_code_page) {
 		printk(KERN_ERR "Could not allocate control_code_buffer\n");
 		goto out;
_

Patches currently in -mm which might be from ying.huang@intel.com are

origin.patch

