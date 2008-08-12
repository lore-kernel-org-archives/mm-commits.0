From: akpm@linux-foundation.org
Subject: + kexec-jump-rename-kexec_control_code_size-to-kexec_control_page_size.patch added to -mm tree
Date: Tue, 12 Aug 2008 16:15:43 -0700
Message-ID: <200808122315.m7CNFhRK018736@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49137 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751871AbYHLXQV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 12 Aug 2008 19:16:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ying.huang@intel.com, ebiederm@xmission.com, mingo@elte.hu, pavel@ucw.cz, rjw@sisk.pl, vgoyal@redhat.com


The patch titled
     kexec jump: rename KEXEC_CONTROL_CODE_SIZE to KEXEC_CONTROL_PAGE_SIZE
has been added to the -mm tree.  Its filename is
     kexec-jump-rename-kexec_control_code_size-to-kexec_control_page_size.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: kexec jump: rename KEXEC_CONTROL_CODE_SIZE to KEXEC_CONTROL_PAGE_SIZE
From: Huang Ying <ying.huang@intel.com>

Rename KEXEC_CONTROL_CODE_SIZE to KEXEC_CONTROL_PAGE_SIZE, because control
page is used for not only code on some platform.  For example in kexec
jump, it is used for data and stack too.

Signed-off-by: Huang Ying <ying.huang@intel.com>
Cc: Pavel Machek <pavel@ucw.cz>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/include/asm/kexec.h     |    2 +-
 arch/ia64/include/asm/kexec.h    |    2 +-
 arch/powerpc/include/asm/kexec.h |    2 +-
 arch/s390/include/asm/kexec.h    |    2 +-
 arch/sh/include/asm/kexec.h      |    2 +-
 include/asm-mips/kexec.h         |    2 +-
 include/asm-x86/kexec.h          |    4 ++--
 include/linux/kexec.h            |    4 ++--
 kernel/kexec.c                   |    4 ++--
 9 files changed, 12 insertions(+), 12 deletions(-)

diff -puN arch/arm/include/asm/kexec.h~kexec-jump-rename-kexec_control_code_size-to-kexec_control_page_size arch/arm/include/asm/kexec.h
--- a/arch/arm/include/asm/kexec.h~kexec-jump-rename-kexec_control_code_size-to-kexec_control_page_size
+++ a/arch/arm/include/asm/kexec.h
@@ -10,7 +10,7 @@
 /* Maximum address we can use for the control code buffer */
 #define KEXEC_CONTROL_MEMORY_LIMIT (-1UL)
 
-#define KEXEC_CONTROL_CODE_SIZE	4096
+#define KEXEC_CONTROL_PAGE_SIZE	4096
 
 #define KEXEC_ARCH KEXEC_ARCH_ARM
 
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
kexec-jump-clean-up-ifdef-and-comments.patch
kexec-jump-rename-kexec_control_code_size-to-kexec_control_page_size.patch
kexec-jump-check-code-size-in-control-page.patch
kexec-jump-remove-duplication-of-kexec_restart_prepare.patch
kexec-jump-in-sync-with-hibernation-implementation.patch
kexec-jump-__ftrace_enabled_save-restore.patch
kexec-jump-fix-for-ftrace.patch

