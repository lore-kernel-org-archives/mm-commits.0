From: akpm@linux-foundation.org
Subject: - use-list_head-in-binfmt-handling-update.patch removed from -mm tree
Date: Wed, 17 Oct 2007 23:52:29 -0700
Message-ID: <200710180652.l9I6qTWW030288@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40775 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761229AbXJRHi7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 03:38:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@sw.ru, mm-commits@vger.kernel.org


The patch titled
     Use list_head in binfmt handling
has been removed from the -mm tree.  Its filename was
     use-list_head-in-binfmt-handling-update.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -66,27 +66,15 @@ int suid_dumpable = 0;
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
@@ -95,20 +83,10 @@ EXPORT_SYMBOL(register_binfmt);
 
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
@@ -155,7 +133,7 @@ asmlinkage long sys_uselib(const char __
 		struct linux_binfmt * fmt;
 
 		read_lock(&binfmt_lock);
-		for (fmt = formats ; fmt ; fmt = fmt->next) {
+		list_for_each_entry(fmt, &formats, lh) {
 			if (!fmt->load_shlib)
 				continue;
 			if (!try_module_get(fmt->module))
@@ -1284,7 +1262,7 @@ int search_binary_handler(struct linux_b
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
@@ -63,7 +63,7 @@ struct linux_binprm{
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

origin.patch
add-kernel-notifierc.patch
add-kernel-notifierc-fix.patch
add-kernel-notifierc-fix-2.patch
add-kernel-notifierc-fix-2-fix-3.patch
sysctl-core-stop-using-the-unnecessary-ctl_table-typedef.patch
sysctl-factor-out-sysctl_data.patch
sysct-mqueue-remove-the-binary-sysctl-numbers.patch
sysctl-remove-binary-sysctl-support-where-it-clearly-doesnt-work.patch
sysctl-fix-neighbour-table-sysctls.patch
sysctl-ipv6-route-flushing-kill-binary-path.patch
sysctl-remove-broken-sunrpc-debug-binary-sysctls.patch
sysctl-x86_64-remove-unnecessary-binary-paths.patch
sysctl-remove-broken-cdrom-binary-sysctls.patch
sysctl-ipv4-remove-binary-sysctl-paths-where-they-are-broken.patch
sysctl-remove-the-binary-interface-for-aio-nr-aio-max-nr-acpi_video_flags.patch
sysctl-error-on-bad-sysctl-tables.patch
sysctl-update-sysctl_check_table.patch
uninline-forkc-exitc.patch
uninline-forkc-exitc-checkpatch-fixes.patch
single_open-seq_release-leak-diagnostics.patch
