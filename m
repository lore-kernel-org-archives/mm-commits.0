From: akpm@linux-foundation.org
Subject: + um-add-earlyprintk-support.patch added to -mm tree
Date: Tue, 24 May 2011 12:34:50 -0700
Message-ID: <201105241934.p4OJYoum010612@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47862 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932953Ab1EXTe6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 24 May 2011 15:34:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: richard@nod.at


The patch titled
     um: add earlyprintk support
has been added to the -mm tree.  Its filename is
     um-add-earlyprintk-support.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: um: add earlyprintk support
From: Richard Weinberger <richard@nod.at>

User Mode Linux can also benefit from earlyprintk.  UML's earlyprintk
writes kernel messages directly to stdout.

Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/Kconfig.debug         |   10 +++++++++
 arch/um/include/shared/os.h   |    1 
 arch/um/kernel/Makefile       |    1 
 arch/um/kernel/early_printk.c |   33 ++++++++++++++++++++++++++++++++
 arch/um/os-Linux/util.c       |    5 ++++
 5 files changed, 50 insertions(+)

diff -puN arch/um/Kconfig.debug~um-add-earlyprintk-support arch/um/Kconfig.debug
--- a/arch/um/Kconfig.debug~um-add-earlyprintk-support
+++ a/arch/um/Kconfig.debug
@@ -37,4 +37,14 @@ config DEBUG_STACK_USAGE
 	  stack seen so far.
 
 	  This option will slow down process creation and destruction somewhat.
+
+config EARLY_PRINTK
+	bool "Early printk"
+	default y
+	---help---
+	  Write kernel log output directly to stdout.
+
+	  This is useful for kernel debugging when your machine crashes very
+	  early before the console code is initialized.
+
 endmenu
diff -puN arch/um/include/shared/os.h~um-add-earlyprintk-support arch/um/include/shared/os.h
--- a/arch/um/include/shared/os.h~um-add-earlyprintk-support
+++ a/arch/um/include/shared/os.h
@@ -245,6 +245,7 @@ extern int raw(int fd);
 extern void setup_machinename(char *machine_out);
 extern void setup_hostinfo(char *buf, int len);
 extern void os_dump_core(void) __attribute__ ((noreturn));
+extern void um_early_printk(const char *s, unsigned int n);
 
 /* time.c */
 extern void idle_sleep(unsigned long long nsecs);
diff -puN arch/um/kernel/Makefile~um-add-earlyprintk-support arch/um/kernel/Makefile
--- a/arch/um/kernel/Makefile~um-add-earlyprintk-support
+++ a/arch/um/kernel/Makefile
@@ -17,6 +17,7 @@ obj-y = config.o exec.o exitcode.o init_
 obj-$(CONFIG_BLK_DEV_INITRD) += initrd.o
 obj-$(CONFIG_GPROF)	+= gprof_syms.o
 obj-$(CONFIG_GCOV)	+= gmon_syms.o
+obj-$(CONFIG_EARLY_PRINTK) += early_printk.o
 
 USER_OBJS := config.o
 
diff -puN /dev/null arch/um/kernel/early_printk.c
--- /dev/null
+++ a/arch/um/kernel/early_printk.c
@@ -0,0 +1,33 @@
+/*
+ * Copyright (C) 2011 Richard Weinberger <richrd@nod.at>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/kernel.h>
+#include <linux/console.h>
+#include <linux/init.h>
+#include "os.h"
+
+static void early_console_write(struct console *con, const char *s, unsigned int n)
+{
+	um_early_printk(s, n);
+}
+
+static struct console early_console = {
+	.name = "earlycon",
+	.write = early_console_write,
+	.flags = CON_BOOT,
+	.index = -1,
+};
+
+static int __init setup_early_printk(char *buf)
+{
+	register_console(&early_console);
+
+	return 0;
+}
+
+early_param("earlyprintk", setup_early_printk);
diff -puN arch/um/os-Linux/util.c~um-add-earlyprintk-support arch/um/os-Linux/util.c
--- a/arch/um/os-Linux/util.c~um-add-earlyprintk-support
+++ a/arch/um/os-Linux/util.c
@@ -131,3 +131,8 @@ void os_dump_core(void)
 	remove_umid_dir();
 	uml_abort();
 }
+
+void um_early_printk(const char *s, unsigned int n)
+{
+	printf("%.*s", n, s);
+}
_

Patches currently in -mm which might be from richard@nod.at are

origin.patch
mm-mmu_gather-rework.patch
powerpc-mmu_gather-rework.patch
sparc-mmu_gather-rework.patch
s390-mmu_gather-rework.patch
arm-mmu_gather-rework.patch
sh-mmu_gather-rework.patch
ia64-mmu_gather-rework.patch
um-mmu_gather-rework.patch
mm-now-that-all-old-mmu_gather-code-is-gone-remove-the-storage.patch
mm-powerpc-move-the-rcu-page-table-freeing-into-generic-code.patch
mm-extended-batches-for-generic-mmu_gather.patch
lockdep-mutex-provide-mutex_lock_nest_lock.patch
mm-remove-i_mmap_lock-lockbreak.patch
mm-convert-i_mmap_lock-to-a-mutex.patch
mm-revert-page_lock_anon_vma-lock-annotation.patch
mm-improve-page_lock_anon_vma-comment.patch
mm-use-refcounts-for-page_lock_anon_vma.patch
mm-convert-anon_vma-lock-to-a-mutex.patch
mm-optimize-page_lock_anon_vma-fast-path.patch
um-os_dump_core-cleanup.patch
um-fix-uml_lib_path.patch
um-remove-sighup-handler.patch
um-add-earlyprintk-support.patch
um-add-ucast-ethernet-transport.patch
um-print-info-about-fatal-segfaults.patch
um-include-linux-prefetchh.patch
um-fix-crash-while-os_dump_core.patch
remove-unused-proc_change_penalty-constant.patch
lib-consolidate-debug_stack_usage-option.patch

