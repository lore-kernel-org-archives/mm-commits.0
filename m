From: akpm@linux-foundation.org
Subject: + core_pattern-ignore-rlimit_core-if-core_pattern-is-a-pipe.patch added to -mm tree
Date: Sun, 29 Jul 2007 00:31:16 -0700
Message-ID: <200707290731.l6T7VGa5013798@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35780 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757222AbXG2Hch (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 29 Jul 2007 03:32:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: nhorman@tuxdriver.com, jeremy@goop.org, martin.pitt@ubuntu.com, wwoods@redhat.com


The patch titled
     core_pattern: ignore RLIMIT_CORE if core_pattern is a pipe
has been added to the -mm tree.  Its filename is
     core_pattern-ignore-rlimit_core-if-core_pattern-is-a-pipe.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: core_pattern: ignore RLIMIT_CORE if core_pattern is a pipe
From: Neil Horman <nhorman@tuxdriver.com>

For some time /proc/sys/kernel/core_pattern has been able to set its output
destination as a pipe, allowing a user space helper to receive and
intellegently process a core.  This infrastructure however has some
shortcommings which can be enhanced.  Specifically:

1) The coredump code in the kernel should ignore RLIMIT_CORE limitation
   when core_pattern is a pipe, since file system resources are not being
   consumed in this case, unless the user application wishes to save the core,
   at which point the app is restricted by usual file system limits and
   restrictions.

2) The core_pattern code should be able to parse and pass options to the
   user space helper as an argv array.  The real core limit of the uid of the
   crashing proces should also be passable to the user space helper (since it
   is overridden to zero when called).

3) Some miscellaneous bugs need to be cleaned up (specifically the
   recognition of a recursive core dump, should the user mode helper itself
   crash.  Also, the core dump code in the kernel should not wait for the user
   mode helper to exit, since the same context is responsible for writing to
   the pipe, and a read of the pipe by the user mode helper will result in a
   deadlock.



This patch:

Remove the check of RLIMIT_CORE if core_pattern is a pipe.  In the event that
core_pattern is a pipe, the entire core will be fed to the user mode helper.

Signed-off-by: Neil Horman <nhorman@tuxdriver.com>
Cc: <martin.pitt@ubuntu.com>
Cc: <wwoods@redhat.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mips/kernel/irixelf.c          |    5 ++---
 arch/sparc64/kernel/binfmt_aout32.c |   10 ++++------
 arch/x86_64/ia32/ia32_aout.c        |   10 ++++------
 fs/binfmt_aout.c                    |   16 ++++++----------
 fs/binfmt_elf.c                     |    5 ++---
 fs/binfmt_elf_fdpic.c               |    5 ++---
 fs/binfmt_flat.c                    |    4 ++--
 fs/binfmt_som.c                     |    2 +-
 fs/exec.c                           |   19 +++++++++++++++----
 include/linux/binfmts.h             |    2 +-
 10 files changed, 39 insertions(+), 39 deletions(-)

diff -puN arch/mips/kernel/irixelf.c~core_pattern-ignore-rlimit_core-if-core_pattern-is-a-pipe arch/mips/kernel/irixelf.c
--- a/arch/mips/kernel/irixelf.c~core_pattern-ignore-rlimit_core-if-core_pattern-is-a-pipe
+++ a/arch/mips/kernel/irixelf.c
@@ -44,7 +44,7 @@
 static int load_irix_binary(struct linux_binprm * bprm, struct pt_regs * regs);
 static int load_irix_library(struct file *);
 static int irix_core_dump(long signr, struct pt_regs * regs,
-                          struct file *file);
+                          struct file *file, unsigned long limit);
 
 static struct linux_binfmt irix_format = {
 	.module		= THIS_MODULE,
@@ -1091,7 +1091,7 @@ end_coredump:
  * and then they are actually written out.  If we run out of core limit
  * we just truncate.
  */
-static int irix_core_dump(long signr, struct pt_regs * regs, struct file *file)
+static int irix_core_dump(long signr, struct pt_regs * regs, struct file *file, unsigned long limit)
 {
 	int has_dumped = 0;
 	mm_segment_t fs;
@@ -1101,7 +1101,6 @@ static int irix_core_dump(long signr, st
 	struct vm_area_struct *vma;
 	struct elfhdr elf;
 	off_t offset = 0, dataoff;
-	int limit = current->signal->rlim[RLIMIT_CORE].rlim_cur;
 	int numnote = 3;
 	struct memelfnote notes[3];
 	struct elf_prstatus prstatus;	/* NT_PRSTATUS */
diff -puN arch/sparc64/kernel/binfmt_aout32.c~core_pattern-ignore-rlimit_core-if-core_pattern-is-a-pipe arch/sparc64/kernel/binfmt_aout32.c
--- a/arch/sparc64/kernel/binfmt_aout32.c~core_pattern-ignore-rlimit_core-if-core_pattern-is-a-pipe
+++ a/arch/sparc64/kernel/binfmt_aout32.c
@@ -35,7 +35,7 @@
 
 static int load_aout32_binary(struct linux_binprm *, struct pt_regs * regs);
 static int load_aout32_library(struct file*);
-static int aout32_core_dump(long signr, struct pt_regs * regs, struct file *file);
+static int aout32_core_dump(long signr, struct pt_regs * regs, struct file *file, unsigned long limit);
 
 static struct linux_binfmt aout32_format = {
 	.module		= THIS_MODULE,
@@ -86,7 +86,7 @@ if (file->f_op->llseek) { \
  * dumping of the process results in another error..
  */
 
-static int aout32_core_dump(long signr, struct pt_regs *regs, struct file *file)
+static int aout32_core_dump(long signr, struct pt_regs *regs, struct file *file, unsigned long limit)
 {
 	mm_segment_t fs;
 	int has_dumped = 0;
@@ -105,13 +105,11 @@ static int aout32_core_dump(long signr, 
 
 /* If the size of the dump file exceeds the rlimit, then see what would happen
    if we wrote the stack, but not the data area.  */
-	if ((dump.u_dsize+dump.u_ssize) >
-	    current->signal->rlim[RLIMIT_CORE].rlim_cur)
+	if ((dump.u_dsize+dump.u_ssize) > limit)
 		dump.u_dsize = 0;
 
 /* Make sure we have enough room to write the stack and data areas. */
-	if ((dump.u_ssize) >
-	    current->signal->rlim[RLIMIT_CORE].rlim_cur)
+	if ((dump.u_ssize) > limit)
 		dump.u_ssize = 0;
 
 /* make sure we actually have a data and stack area to dump */
diff -puN arch/x86_64/ia32/ia32_aout.c~core_pattern-ignore-rlimit_core-if-core_pattern-is-a-pipe arch/x86_64/ia32/ia32_aout.c
--- a/arch/x86_64/ia32/ia32_aout.c~core_pattern-ignore-rlimit_core-if-core_pattern-is-a-pipe
+++ a/arch/x86_64/ia32/ia32_aout.c
@@ -40,7 +40,7 @@ static int load_aout_binary(struct linux
 static int load_aout_library(struct file*);
 
 #ifdef CORE_DUMP
-static int aout_core_dump(long signr, struct pt_regs * regs, struct file *file);
+static int aout_core_dump(long signr, struct pt_regs * regs, struct file *file, unsigned long limit);
 
 /*
  * fill in the user structure for a core dump..
@@ -148,7 +148,7 @@ if (file->f_op->llseek) { \
  * dumping of the process results in another error..
  */
 
-static int aout_core_dump(long signr, struct pt_regs * regs, struct file *file)
+static int aout_core_dump(long signr, struct pt_regs * regs, struct file *file, unsigned long limit)
 {
 	mm_segment_t fs;
 	int has_dumped = 0;
@@ -168,13 +168,11 @@ static int aout_core_dump(long signr, st
 
 /* If the size of the dump file exceeds the rlimit, then see what would happen
    if we wrote the stack, but not the data area.  */
-	if ((dump.u_dsize+dump.u_ssize+1) * PAGE_SIZE >
-	    current->signal->rlim[RLIMIT_CORE].rlim_cur)
+	if ((dump.u_dsize+dump.u_ssize+1) * PAGE_SIZE > limit)
 		dump.u_dsize = 0;
 
 /* Make sure we have enough room to write the stack and data areas. */
-	if ((dump.u_ssize+1) * PAGE_SIZE >
-	    current->signal->rlim[RLIMIT_CORE].rlim_cur)
+	if ((dump.u_ssize+1) * PAGE_SIZE > limit)
 		dump.u_ssize = 0;
 
 /* make sure we actually have a data and stack area to dump */
diff -puN fs/binfmt_aout.c~core_pattern-ignore-rlimit_core-if-core_pattern-is-a-pipe fs/binfmt_aout.c
--- a/fs/binfmt_aout.c~core_pattern-ignore-rlimit_core-if-core_pattern-is-a-pipe
+++ a/fs/binfmt_aout.c
@@ -31,7 +31,7 @@
 
 static int load_aout_binary(struct linux_binprm *, struct pt_regs * regs);
 static int load_aout_library(struct file*);
-static int aout_core_dump(long signr, struct pt_regs * regs, struct file *file);
+static int aout_core_dump(long signr, struct pt_regs * regs, struct file *file, unsigned long limit);
 
 static struct linux_binfmt aout_format = {
 	.module		= THIS_MODULE,
@@ -88,7 +88,7 @@ if (file->f_op->llseek) { \
  * dumping of the process results in another error..
  */
 
-static int aout_core_dump(long signr, struct pt_regs * regs, struct file *file)
+static int aout_core_dump(long signr, struct pt_regs * regs, struct file *file, unsigned long limit)
 {
 	mm_segment_t fs;
 	int has_dumped = 0;
@@ -123,23 +123,19 @@ static int aout_core_dump(long signr, st
 /* If the size of the dump file exceeds the rlimit, then see what would happen
    if we wrote the stack, but not the data area.  */
 #ifdef __sparc__
-	if ((dump.u_dsize+dump.u_ssize) >
-	    current->signal->rlim[RLIMIT_CORE].rlim_cur)
+	if ((dump.u_dsize+dump.u_ssize) > limit)
 		dump.u_dsize = 0;
 #else
-	if ((dump.u_dsize+dump.u_ssize+1) * PAGE_SIZE >
-	    current->signal->rlim[RLIMIT_CORE].rlim_cur)
+	if ((dump.u_dsize+dump.u_ssize+1) * PAGE_SIZE > limit)
 		dump.u_dsize = 0;
 #endif
 
 /* Make sure we have enough room to write the stack and data areas. */
 #ifdef __sparc__
-	if ((dump.u_ssize) >
-	    current->signal->rlim[RLIMIT_CORE].rlim_cur)
+	if ((dump.u_ssize) > limit)
 		dump.u_ssize = 0;
 #else
-	if ((dump.u_ssize+1) * PAGE_SIZE >
-	    current->signal->rlim[RLIMIT_CORE].rlim_cur)
+	if ((dump.u_ssize+1) * PAGE_SIZE > limit)
 		dump.u_ssize = 0;
 #endif
 
diff -puN fs/binfmt_elf.c~core_pattern-ignore-rlimit_core-if-core_pattern-is-a-pipe fs/binfmt_elf.c
--- a/fs/binfmt_elf.c~core_pattern-ignore-rlimit_core-if-core_pattern-is-a-pipe
+++ a/fs/binfmt_elf.c
@@ -52,7 +52,7 @@ static unsigned long elf_map (struct fil
  * don't even try.
  */
 #if defined(USE_ELF_CORE_DUMP) && defined(CONFIG_ELF_CORE)
-static int elf_core_dump(long signr, struct pt_regs *regs, struct file *file);
+static int elf_core_dump(long signr, struct pt_regs *regs, struct file *file, unsigned long limit);
 #else
 #define elf_core_dump	NULL
 #endif
@@ -1488,7 +1488,7 @@ static struct vm_area_struct *next_vma(s
  * and then they are actually written out.  If we run out of core limit
  * we just truncate.
  */
-static int elf_core_dump(long signr, struct pt_regs *regs, struct file *file)
+static int elf_core_dump(long signr, struct pt_regs *regs, struct file *file, unsigned long limit)
 {
 #define	NUM_NOTES	6
 	int has_dumped = 0;
@@ -1499,7 +1499,6 @@ static int elf_core_dump(long signr, str
 	struct vm_area_struct *vma, *gate_vma;
 	struct elfhdr *elf = NULL;
 	loff_t offset = 0, dataoff, foffset;
-	unsigned long limit = current->signal->rlim[RLIMIT_CORE].rlim_cur;
 	int numnote;
 	struct memelfnote *notes = NULL;
 	struct elf_prstatus *prstatus = NULL;	/* NT_PRSTATUS */
diff -puN fs/binfmt_elf_fdpic.c~core_pattern-ignore-rlimit_core-if-core_pattern-is-a-pipe fs/binfmt_elf_fdpic.c
--- a/fs/binfmt_elf_fdpic.c~core_pattern-ignore-rlimit_core-if-core_pattern-is-a-pipe
+++ a/fs/binfmt_elf_fdpic.c
@@ -75,7 +75,7 @@ static int elf_fdpic_map_file_by_direct_
 					     struct file *, struct mm_struct *);
 
 #if defined(USE_ELF_CORE_DUMP) && defined(CONFIG_ELF_CORE)
-static int elf_fdpic_core_dump(long, struct pt_regs *, struct file *);
+static int elf_fdpic_core_dump(long, struct pt_regs *, struct file *, unsigned long limit);
 #endif
 
 static struct linux_binfmt elf_fdpic_format = {
@@ -1552,7 +1552,7 @@ static int elf_fdpic_dump_segments(struc
  * we just truncate.
  */
 static int elf_fdpic_core_dump(long signr, struct pt_regs *regs,
-			       struct file *file)
+			       struct file *file, unsigned long limit)
 {
 #define	NUM_NOTES	6
 	int has_dumped = 0;
@@ -1563,7 +1563,6 @@ static int elf_fdpic_core_dump(long sign
 	struct vm_area_struct *vma;
 	struct elfhdr *elf = NULL;
 	loff_t offset = 0, dataoff;
-	unsigned long limit = current->signal->rlim[RLIMIT_CORE].rlim_cur;
 	int numnote;
 	struct memelfnote *notes = NULL;
 	struct elf_prstatus *prstatus = NULL;	/* NT_PRSTATUS */
diff -puN fs/binfmt_flat.c~core_pattern-ignore-rlimit_core-if-core_pattern-is-a-pipe fs/binfmt_flat.c
--- a/fs/binfmt_flat.c~core_pattern-ignore-rlimit_core-if-core_pattern-is-a-pipe
+++ a/fs/binfmt_flat.c
@@ -75,7 +75,7 @@ static int load_flat_shared_library(int 
 #endif
 
 static int load_flat_binary(struct linux_binprm *, struct pt_regs * regs);
-static int flat_core_dump(long signr, struct pt_regs * regs, struct file *file);
+static int flat_core_dump(long signr, struct pt_regs * regs, struct file *file, unsigned long limit);
 
 static struct linux_binfmt flat_format = {
 	.module		= THIS_MODULE,
@@ -90,7 +90,7 @@ static struct linux_binfmt flat_format =
  * Currently only a stub-function.
  */
 
-static int flat_core_dump(long signr, struct pt_regs * regs, struct file *file)
+static int flat_core_dump(long signr, struct pt_regs * regs, struct file *file, unsigned long limit)
 {
 	printk("Process %s:%d received signr %d and should have core dumped\n",
 			current->comm, current->pid, (int) signr);
diff -puN fs/binfmt_som.c~core_pattern-ignore-rlimit_core-if-core_pattern-is-a-pipe fs/binfmt_som.c
--- a/fs/binfmt_som.c~core_pattern-ignore-rlimit_core-if-core_pattern-is-a-pipe
+++ a/fs/binfmt_som.c
@@ -44,7 +44,7 @@ static int load_som_library(struct file 
  * don't even try.
  */
 #if 0
-static int som_core_dump(long signr, struct pt_regs * regs);
+static int som_core_dump(long signr, struct pt_regs * regs, unsigned long limit);
 #else
 #define som_core_dump	NULL
 #endif
diff -puN fs/exec.c~core_pattern-ignore-rlimit_core-if-core_pattern-is-a-pipe fs/exec.c
--- a/fs/exec.c~core_pattern-ignore-rlimit_core-if-core_pattern-is-a-pipe
+++ a/fs/exec.c
@@ -1703,6 +1703,7 @@ int do_coredump(long signr, int exit_cod
 	int fsuid = current->fsuid;
 	int flag = 0;
 	int ispipe = 0;
+	unsigned long core_limit = current->signal->rlim[RLIMIT_CORE].rlim_cur;
 
 	audit_core_dumps(signr);
 
@@ -1736,9 +1737,6 @@ int do_coredump(long signr, int exit_cod
 	 */
 	clear_thread_flag(TIF_SIGPENDING);
 
-	if (current->signal->rlim[RLIMIT_CORE].rlim_cur < binfmt->min_coredump)
-		goto fail_unlock;
-
 	/*
 	 * lock_kernel() because format_corename() is controlled by sysctl, which
 	 * uses lock_kernel()
@@ -1746,7 +1744,20 @@ int do_coredump(long signr, int exit_cod
  	lock_kernel();
 	ispipe = format_corename(corename, core_pattern, signr);
 	unlock_kernel();
+	/*
+	 * Don't bother to check the RLIMIT_CORE value if core_pattern points
+	 * to a pipe.  Since we're not writing directly to the filesystem
+	 * RLIMIT_CORE doesn't really apply, as no actual core file will be
+	 * created unless the pipe reader choses to write out the core file
+	 * at which point file size limits and permissions will be imposed
+	 * as it does with any other process
+	 */
+	if ((!ispipe) &&
+	   (core_limit < binfmt->min_coredump))
+		goto fail_unlock;
+
  	if (ispipe) {
+		core_limit = RLIM_INFINITY;
 		/* SIGPIPE can happen, but it's just never processed */
  		if(call_usermodehelper_pipe(corename+1, NULL, NULL, &file)) {
  			printk(KERN_INFO "Core dump to %s pipe failed\n",
@@ -1776,7 +1787,7 @@ int do_coredump(long signr, int exit_cod
 	if (!ispipe && do_truncate(file->f_path.dentry, 0, 0, file) != 0)
 		goto close_fail;
 
-	retval = binfmt->core_dump(signr, regs, file);
+	retval = binfmt->core_dump(signr, regs, file, core_limit);
 
 	if (retval)
 		current->signal->group_exit_code |= 0x80;
diff -puN include/linux/binfmts.h~core_pattern-ignore-rlimit_core-if-core_pattern-is-a-pipe include/linux/binfmts.h
--- a/include/linux/binfmts.h~core_pattern-ignore-rlimit_core-if-core_pattern-is-a-pipe
+++ a/include/linux/binfmts.h
@@ -68,7 +68,7 @@ struct linux_binfmt {
 	struct module *module;
 	int (*load_binary)(struct linux_binprm *, struct  pt_regs * regs);
 	int (*load_shlib)(struct file *);
-	int (*core_dump)(long signr, struct pt_regs * regs, struct file * file);
+	int (*core_dump)(long signr, struct pt_regs * regs, struct file * file, unsigned long limit);
 	unsigned long min_coredump;	/* minimal dump size */
 	int hasvdso;
 };
_

Patches currently in -mm which might be from nhorman@tuxdriver.com are

core_pattern-ignore-rlimit_core-if-core_pattern-is-a-pipe.patch
core_pattern-ignore-rlimit_core-if-core_pattern-is-a-pipe-fix.patch
core_pattern-allow-passing-of-arguments-to-user-mode-helper-when-core_pattern-is-a-pipe.patch
core_pattern-fix-up-a-few-miscellaneous-bugs.patch
core_pattern-fix-up-a-few-miscellaneous-bugs-fix.patch
