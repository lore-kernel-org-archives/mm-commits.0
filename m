From: akpm@linux-foundation.org
Subject: + use-list_head-in-binfmt-handling-update.patch added to -mm tree
Date: Thu, 26 Jul 2007 21:50:10 -0700
Message-ID: <200707270450.l6R4oAEp006094@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55795 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751671AbXG0Eux (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 27 Jul 2007 00:50:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: adobriyan@sw.ru


The patch titled
     Use list_head in binfmt handling
has been added to the -mm tree.  Its filename is
     use-list_head-in-binfmt-handling-update.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Use list_head in binfmt handling
From: Alexey Dobriyan <adobriyan@sw.ru>

Switch single-linked binfmt formats list to usual list_head's.  This leads
to one-liners in register_binfmt() and unregister_binfmt().  The downside
is one pointer more in struct linux_binfmt.  This is not a problem, since
the set of registered binfmts on typical box is very small -- (ELF +
something distro enabled for you).

Test-booted, played with executable .txt files, modprobe/rmmod binfmt_misc.

Signed-off-by: Alexey Dobriyan <adobriyan@sw.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mips/kernel/irixelf.c          |    7 +++--
 arch/sparc64/kernel/binfmt_aout32.c |    7 +++--
 fs/exec.c                           |   34 ++++----------------------
 include/linux/binfmts.h             |    2 -
 4 files changed, 17 insertions(+), 33 deletions(-)

diff -puN arch/mips/kernel/irixelf.c~use-list_head-in-binfmt-handling-update arch/mips/kernel/irixelf.c
--- a/arch/mips/kernel/irixelf.c~use-list_head-in-binfmt-handling-update
+++ a/arch/mips/kernel/irixelf.c
@@ -47,8 +47,11 @@ static int irix_core_dump(long signr, st
                           struct file *file);
 
 static struct linux_binfmt irix_format = {
-	NULL, THIS_MODULE, load_irix_binary, load_irix_library,
-	irix_core_dump, PAGE_SIZE
+	.module		= THIS_MODULE,
+	.load_binary	= load_irix_binary,
+	.load_shlib	= load_irix_library,
+	.core_dump	= irix_core_dump,
+	.min_coredump	= PAGE_SIZE,
 };
 
 /* Debugging routines. */
diff -puN arch/sparc64/kernel/binfmt_aout32.c~use-list_head-in-binfmt-handling-update arch/sparc64/kernel/binfmt_aout32.c
--- a/arch/sparc64/kernel/binfmt_aout32.c~use-list_head-in-binfmt-handling-update
+++ a/arch/sparc64/kernel/binfmt_aout32.c
@@ -38,8 +38,11 @@ static int load_aout32_library(struct fi
 static int aout32_core_dump(long signr, struct pt_regs * regs, struct file *file);
 
 static struct linux_binfmt aout32_format = {
-	NULL, THIS_MODULE, load_aout32_binary, load_aout32_library, aout32_core_dump,
-	PAGE_SIZE
+	.module		= THIS_MODULE,
+	.load_binary	= load_aout32_binary,
+	.load_shlib	= load_aout32_library,
+	.core_dump	= aout32_core_dump,
+	.min_coredump	= PAGE_SIZE,
 };
 
 static void set_brk(unsigned long start, unsigned long end)
diff -puN fs/exec.c~use-list_head-in-binfmt-handling-update fs/exec.c
--- a/fs/exec.c~use-list_head-in-binfmt-handling-update
+++ a/fs/exec.c
@@ -67,27 +67,15 @@ int suid_dumpable = 0;
 EXPORT_SYMBOL(suid_dumpable);
 /* The maximal length of core_pattern is also specified in sysctl.c */
 
-static struct linux_binfmt *formats;
+static LIST_HEAD(formats);
 static DEFINE_RWLOCK(binfmt_lock);
 
 int register_binfmt(struct linux_binfmt * fmt)
 {
-	struct linux_binfmt ** tmp = &formats;
-
 	if (!fmt)
 		return -EINVAL;
-	if (fmt->next)
-		return -EBUSY;
 	write_lock(&binfmt_lock);
-	while (*tmp) {
-		if (fmt == *tmp) {
-			write_unlock(&binfmt_lock);
-			return -EBUSY;
-		}
-		tmp = &(*tmp)->next;
-	}
-	fmt->next = formats;
-	formats = fmt;
+	list_add(&fmt->lh, &formats);
 	write_unlock(&binfmt_lock);
 	return 0;	
 }
@@ -96,20 +84,10 @@ EXPORT_SYMBOL(register_binfmt);
 
 int unregister_binfmt(struct linux_binfmt * fmt)
 {
-	struct linux_binfmt ** tmp = &formats;
-
 	write_lock(&binfmt_lock);
-	while (*tmp) {
-		if (fmt == *tmp) {
-			*tmp = fmt->next;
-			fmt->next = NULL;
-			write_unlock(&binfmt_lock);
-			return 0;
-		}
-		tmp = &(*tmp)->next;
-	}
+	list_del(&fmt->lh);
 	write_unlock(&binfmt_lock);
-	return -EINVAL;
+	return 0;
 }
 
 EXPORT_SYMBOL(unregister_binfmt);
@@ -156,7 +134,7 @@ asmlinkage long sys_uselib(const char __
 		struct linux_binfmt * fmt;
 
 		read_lock(&binfmt_lock);
-		for (fmt = formats ; fmt ; fmt = fmt->next) {
+		list_for_each_entry(fmt, &formats, lh) {
 			if (!fmt->load_shlib)
 				continue;
 			if (!try_module_get(fmt->module))
@@ -1290,7 +1268,7 @@ int search_binary_handler(struct linux_b
 	retval = -ENOENT;
 	for (try=0; try<2; try++) {
 		read_lock(&binfmt_lock);
-		for (fmt = formats ; fmt ; fmt = fmt->next) {
+		list_for_each_entry(fmt, &formats, lh) {
 			int (*fn)(struct linux_binprm *, struct pt_regs *) = fmt->load_binary;
 			if (!fn)
 				continue;
diff -puN include/linux/binfmts.h~use-list_head-in-binfmt-handling-update include/linux/binfmts.h
--- a/include/linux/binfmts.h~use-list_head-in-binfmt-handling-update
+++ a/include/linux/binfmts.h
@@ -64,7 +64,7 @@ struct linux_binprm{
  * linux accepts.
  */
 struct linux_binfmt {
-	struct linux_binfmt * next;
+	struct list_head lh;
 	struct module *module;
 	int (*load_binary)(struct linux_binprm *, struct  pt_regs * regs);
 	int (*load_shlib)(struct file *);
_

Patches currently in -mm which might be from adobriyan@sw.ru are

x86_powernow_k8_acpi-must-depend-on-acpi.patch
gitignore-update.patch
consolidate-ptrace_detach.patch
use-list_head-in-binfmt-handling-update.patch
use-list_head-in-binfmt-handling.patch
use-list_head-in-binfmt-handling-fix.patch
make-unregister_binfmt-return-void.patch
fix-leaks-on-proc-schedsched_debugtimer_listtimer_stats.patch
fix-leak-on-proc-lockdep_stats.patch
slab_panic-more-proc-posix-timers-shmem.patch
add-kernel-notifierc.patch
add-kernel-notifierc-fix.patch
add-kernel-notifierc-fix-2.patch
