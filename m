From: akpm@linux-foundation.org
Subject: - kdump-make-elfcorehdr_addr-independent-of-config_proc_vmcore.patch removed from -mm tree
Date: Mon, 20 Oct 2008 13:37:02 -0700
Message-ID: <200810202037.m9KKb2lH011521@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34815 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754429AbYJTUsJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 20 Oct 2008 16:48:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vgoyal@redhat.com, ebiederm@xmission.com, horms@verge.net.au, lethal@linux-sh.org, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     kdump: make elfcorehdr_addr independent of CONFIG_PROC_VMCORE
has been removed from the -mm tree.  Its filename was
     kdump-make-elfcorehdr_addr-independent-of-config_proc_vmcore.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: kdump: make elfcorehdr_addr independent of CONFIG_PROC_VMCORE
From: Vivek Goyal <vgoyal@redhat.com>

o elfcorehdr_addr is used by not only the code under CONFIG_PROC_VMCORE
  but also by the code which is not inside CONFIG_PROC_VMCORE.  For
  example, is_kdump_kernel() is used by powerpc code to determine if
  kernel is booting after a panic then use previous kernel's TCE table. 
  So even if CONFIG_PROC_VMCORE is not set in second kernel, one should be
  able to correctly determine that we are booting after a panic and setup
  calgary iommu accordingly.

o So remove the assumption that elfcorehdr_addr is under
  CONFIG_PROC_VMCORE.

o Move definition of elfcorehdr_addr to arch dependent crash files. 
  (Unfortunately crash dump does not have an arch independent file
  otherwise that would have been the best place).

o kexec.c is not the right place as one can Have CRASH_DUMP enabled in
  second kernel without KEXEC being enabled.

o I don't see sh setup code parsing the command line for
  elfcorehdr_addr.  I am wondering how does vmcore interface work on sh. 
  Anyway, I am atleast defining elfcoredhr_addr so that compilation is not
  broken on sh.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
Acked-by: "Eric W. Biederman" <ebiederm@xmission.com>
Acked-by: Simon Horman <horms@verge.net.au>
Acked-by: Paul Mundt <lethal@linux-sh.org>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/kernel/crash_dump.c    |    4 ++++
 arch/ia64/kernel/setup.c         |    9 ++++++++-
 arch/powerpc/kernel/crash_dump.c |   10 ++++++++--
 arch/sh/kernel/crash_dump.c      |    3 +++
 arch/x86/kernel/crash_dump_32.c  |    3 +++
 arch/x86/kernel/crash_dump_64.c  |    3 +++
 arch/x86/kernel/setup.c          |    8 +++++++-
 fs/proc/vmcore.c                 |    3 ---
 include/linux/crash_dump.h       |   14 ++++++++++----
 9 files changed, 46 insertions(+), 11 deletions(-)

diff -puN arch/ia64/kernel/crash_dump.c~kdump-make-elfcorehdr_addr-independent-of-config_proc_vmcore arch/ia64/kernel/crash_dump.c
--- a/arch/ia64/kernel/crash_dump.c~kdump-make-elfcorehdr_addr-independent-of-config_proc_vmcore
+++ a/arch/ia64/kernel/crash_dump.c
@@ -8,10 +8,14 @@
 
 #include <linux/errno.h>
 #include <linux/types.h>
+#include <linux/crash_dump.h>
 
 #include <asm/page.h>
 #include <asm/uaccess.h>
 
+/* Stores the physical address of elf header of crash image. */
+unsigned long long elfcorehdr_addr = ELFCORE_ADDR_MAX;
+
 /**
  * copy_oldmem_page - copy one page from "oldmem"
  * @pfn: page frame number to be copied
diff -puN arch/ia64/kernel/setup.c~kdump-make-elfcorehdr_addr-independent-of-config_proc_vmcore arch/ia64/kernel/setup.c
--- a/arch/ia64/kernel/setup.c~kdump-make-elfcorehdr_addr-independent-of-config_proc_vmcore
+++ a/arch/ia64/kernel/setup.c
@@ -478,7 +478,12 @@ static __init int setup_nomca(char *s)
 }
 early_param("nomca", setup_nomca);
 
-#ifdef CONFIG_PROC_VMCORE
+/*
+ * Note: elfcorehdr_addr is not just limited to vmcore. It is also used by
+ * is_kdump_kernel() to determine if we are booting after a panic. Hence
+ * ifdef it under CONFIG_CRASH_DUMP and not CONFIG_PROC_VMCORE.
+ */
+#ifdef CONFIG_CRASH_DUMP
 /* elfcorehdr= specifies the location of elf core header
  * stored by the crashed kernel.
  */
@@ -491,7 +496,9 @@ static int __init parse_elfcorehdr(char 
 	return 0;
 }
 early_param("elfcorehdr", parse_elfcorehdr);
+#endif
 
+#ifdef CONFIG_PROC_VMCORE
 int __init reserve_elfcorehdr(unsigned long *start, unsigned long *end)
 {
 	unsigned long length;
diff -puN arch/powerpc/kernel/crash_dump.c~kdump-make-elfcorehdr_addr-independent-of-config_proc_vmcore arch/powerpc/kernel/crash_dump.c
--- a/arch/powerpc/kernel/crash_dump.c~kdump-make-elfcorehdr_addr-independent-of-config_proc_vmcore
+++ a/arch/powerpc/kernel/crash_dump.c
@@ -27,6 +27,9 @@
 #define DBG(fmt...)
 #endif
 
+/* Stores the physical address of elf header of crash image. */
+unsigned long long elfcorehdr_addr = ELFCORE_ADDR_MAX;
+
 void __init reserve_kdump_trampoline(void)
 {
 	lmb_reserve(0, KDUMP_RESERVE_LIMIT);
@@ -66,7 +69,11 @@ void __init setup_kdump_trampoline(void)
 	DBG(" <- setup_kdump_trampoline()\n");
 }
 
-#ifdef CONFIG_PROC_VMCORE
+/*
+ * Note: elfcorehdr_addr is not just limited to vmcore. It is also used by
+ * is_kdump_kernel() to determine if we are booting after a panic. Hence
+ * ifdef it under CONFIG_CRASH_DUMP and not CONFIG_PROC_VMCORE.
+ */
 static int __init parse_elfcorehdr(char *p)
 {
 	if (p)
@@ -75,7 +82,6 @@ static int __init parse_elfcorehdr(char 
 	return 1;
 }
 __setup("elfcorehdr=", parse_elfcorehdr);
-#endif
 
 static int __init parse_savemaxmem(char *p)
 {
diff -puN arch/sh/kernel/crash_dump.c~kdump-make-elfcorehdr_addr-independent-of-config_proc_vmcore arch/sh/kernel/crash_dump.c
--- a/arch/sh/kernel/crash_dump.c~kdump-make-elfcorehdr_addr-independent-of-config_proc_vmcore
+++ a/arch/sh/kernel/crash_dump.c
@@ -10,6 +10,9 @@
 #include <linux/io.h>
 #include <asm/uaccess.h>
 
+/* Stores the physical address of elf header of crash image. */
+unsigned long long elfcorehdr_addr = ELFCORE_ADDR_MAX;
+
 /**
  * copy_oldmem_page - copy one page from "oldmem"
  * @pfn: page frame number to be copied
diff -puN arch/x86/kernel/crash_dump_32.c~kdump-make-elfcorehdr_addr-independent-of-config_proc_vmcore arch/x86/kernel/crash_dump_32.c
--- a/arch/x86/kernel/crash_dump_32.c~kdump-make-elfcorehdr_addr-independent-of-config_proc_vmcore
+++ a/arch/x86/kernel/crash_dump_32.c
@@ -13,6 +13,9 @@
 
 static void *kdump_buf_page;
 
+/* Stores the physical address of elf header of crash image. */
+unsigned long long elfcorehdr_addr = ELFCORE_ADDR_MAX;
+
 /**
  * copy_oldmem_page - copy one page from "oldmem"
  * @pfn: page frame number to be copied
diff -puN arch/x86/kernel/crash_dump_64.c~kdump-make-elfcorehdr_addr-independent-of-config_proc_vmcore arch/x86/kernel/crash_dump_64.c
--- a/arch/x86/kernel/crash_dump_64.c~kdump-make-elfcorehdr_addr-independent-of-config_proc_vmcore
+++ a/arch/x86/kernel/crash_dump_64.c
@@ -10,6 +10,9 @@
 #include <linux/uaccess.h>
 #include <linux/io.h>
 
+/* Stores the physical address of elf header of crash image. */
+unsigned long long elfcorehdr_addr = ELFCORE_ADDR_MAX;
+
 /**
  * copy_oldmem_page - copy one page from "oldmem"
  * @pfn: page frame number to be copied
diff -puN arch/x86/kernel/setup.c~kdump-make-elfcorehdr_addr-independent-of-config_proc_vmcore arch/x86/kernel/setup.c
--- a/arch/x86/kernel/setup.c~kdump-make-elfcorehdr_addr-independent-of-config_proc_vmcore
+++ a/arch/x86/kernel/setup.c
@@ -561,7 +561,13 @@ static void __init reserve_standard_io_r
 
 }
 
-#ifdef CONFIG_PROC_VMCORE
+/*
+ * Note: elfcorehdr_addr is not just limited to vmcore. It is also used by
+ * is_kdump_kernel() to determine if we are booting after a panic. Hence
+ * ifdef it under CONFIG_CRASH_DUMP and not CONFIG_PROC_VMCORE.
+ */
+
+#ifdef CONFIG_CRASH_DUMP
 /* elfcorehdr= specifies the location of elf core header
  * stored by the crashed kernel. This option will be passed
  * by kexec loader to the capture kernel.
diff -puN fs/proc/vmcore.c~kdump-make-elfcorehdr_addr-independent-of-config_proc_vmcore fs/proc/vmcore.c
--- a/fs/proc/vmcore.c~kdump-make-elfcorehdr_addr-independent-of-config_proc_vmcore
+++ a/fs/proc/vmcore.c
@@ -32,9 +32,6 @@ static size_t elfcorebuf_sz;
 /* Total size of vmcore file. */
 static u64 vmcore_size;
 
-/* Stores the physical address of elf header of crash image. */
-unsigned long long elfcorehdr_addr = ELFCORE_ADDR_MAX;
-
 struct proc_dir_entry *proc_vmcore = NULL;
 
 /* Reads a page from the oldmem device from given offset. */
diff -puN include/linux/crash_dump.h~kdump-make-elfcorehdr_addr-independent-of-config_proc_vmcore include/linux/crash_dump.h
--- a/include/linux/crash_dump.h~kdump-make-elfcorehdr_addr-independent-of-config_proc_vmcore
+++ a/include/linux/crash_dump.h
@@ -9,11 +9,7 @@
 
 #define ELFCORE_ADDR_MAX	(-1ULL)
 
-#ifdef CONFIG_PROC_VMCORE
 extern unsigned long long elfcorehdr_addr;
-#else
-static const unsigned long long elfcorehdr_addr = ELFCORE_ADDR_MAX;
-#endif
 
 extern ssize_t copy_oldmem_page(unsigned long, char *, size_t,
 						unsigned long, int);
@@ -28,6 +24,16 @@ extern struct proc_dir_entry *proc_vmcor
 
 #define vmcore_elf_check_arch(x) (elf_check_arch(x) || vmcore_elf_check_arch_cross(x))
 
+/*
+ * is_kdump_kernel() checks whether this kernel is booting after a panic of
+ * previous kernel or not. This is determined by checking if previous kernel
+ * has passed the elf core header address on command line.
+ *
+ * This is not just a test if CONFIG_CRASH_DUMP is enabled or not. It will
+ * return 1 if CONFIG_CRASH_DUMP=y and if kernel is booting after a panic of
+ * previous kernel.
+ */
+
 static inline int is_kdump_kernel(void)
 {
 	return (elfcorehdr_addr != ELFCORE_ADDR_MAX) ? 1 : 0;
_

Patches currently in -mm which might be from vgoyal@redhat.com are

origin.patch
memrlimit-add-memrlimit-controller-documentation.patch
memrlimit-setup-the-memrlimit-controller.patch
memrlimit-add-memrlimit-controller-accounting-and-control.patch
memrlimit-add-memrlimit-controller-accounting-and-control-memory-rlimit-enhance-mm_owner_changed-callback-to-deal-with-exited-owner.patch
memrlimit-add-memrlimit-controller-accounting-and-control-memory-rlimit-fix-crash-on-fork.patch
memrlimit-improve-error-handling.patch
memrlimit-improve-error-handling-update.patch
memrlimit-handle-attach_task-failure-add-can_attach-callback.patch

