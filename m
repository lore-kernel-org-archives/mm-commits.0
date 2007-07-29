From: akpm@linux-foundation.org
Subject: - allow-individual-core-dump-methods-to-be-unlimited-when-sending-to-a-pipe.patch removed from -mm tree
Date: Sun, 29 Jul 2007 00:19:16 -0700
Message-ID: <200707290719.l6T7JGeO013458@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43570 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759991AbXG2HU0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 29 Jul 2007 03:20:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: nhorman@tuxdriver.com, ak@suse.de, alan@lxorguk.ukuu.org.uk, hidehiro.kawai.ez@hitachi.com, mm-commits@vger.kernel.org


The patch titled
     allow individual core dump methods to be unlimited when sending to a pipe
has been removed from the -mm tree.  Its filename was
     allow-individual-core-dump-methods-to-be-unlimited-when-sending-to-a-pipe.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: allow individual core dump methods to be unlimited when sending to a pipe
From: Neil Horman <nhorman@tuxdriver.com>

This is a follow on to the patch entitled:
update-coredump-path-in-kernel-to-not-check-coredump-rlim-if-core_pattern-is-a-pipe.patch
It allows individual core dump methods to have the core dump size limit
passed into them.  Its more efficient than each method having to retrieve
it on their own, and it allows for do_coredump to specify a infinite limit
in the event that a pipe is configured in /proc/sys/kernel/core_pattern, in
which case ulimit -c should not apply.

Signed-off-by: Neil Horman <nhorman@tuxdriver.com>
Cc: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mips/kernel/irixelf.c          |    5 ++---
 arch/sparc64/kernel/binfmt_aout32.c |    8 +++-----
 arch/x86_64/ia32/ia32_aout.c        |   10 ++++------
 fs/binfmt_aout.c                    |   16 ++++++----------
 fs/binfmt_elf.c                     |    5 ++---
 fs/binfmt_elf_fdpic.c               |    5 ++---
 fs/binfmt_flat.c                    |    4 ++--
 fs/binfmt_som.c                     |    2 +-
 fs/exec.c                           |    6 ++++--
 include/linux/binfmts.h             |    2 +-
 10 files changed, 27 insertions(+), 36 deletions(-)

diff -puN arch/mips/kernel/irixelf.c~allow-individual-core-dump-methods-to-be-unlimited-when-sending-to-a-pipe arch/mips/kernel/irixelf.c
--- a/arch/mips/kernel/irixelf.c~allow-individual-core-dump-methods-to-be-unlimited-when-sending-to-a-pipe
+++ a/arch/mips/kernel/irixelf.c
@@ -44,7 +44,7 @@
 static int load_irix_binary(struct linux_binprm * bprm, struct pt_regs * regs);
 static int load_irix_library(struct file *);
 static int irix_core_dump(long signr, struct pt_regs * regs,
-                          struct file *file);
+                          struct file *file, int limit);
 
 static struct linux_binfmt irix_format = {
 	NULL, THIS_MODULE, load_irix_binary, load_irix_library,
@@ -1088,7 +1088,7 @@ end_coredump:
  * and then they are actually written out.  If we run out of core limit
  * we just truncate.
  */
-static int irix_core_dump(long signr, struct pt_regs * regs, struct file *file)
+static int irix_core_dump(long signr, struct pt_regs * regs, struct file *file, int limit)
 {
 	int has_dumped = 0;
 	mm_segment_t fs;
@@ -1098,7 +1098,6 @@ static int irix_core_dump(long signr, st
 	struct vm_area_struct *vma;
 	struct elfhdr elf;
 	off_t offset = 0, dataoff;
-	int limit = current->signal->rlim[RLIMIT_CORE].rlim_cur;
 	int numnote = 3;
 	struct memelfnote notes[3];
 	struct elf_prstatus prstatus;	/* NT_PRSTATUS */
diff -puN arch/sparc64/kernel/binfmt_aout32.c~allow-individual-core-dump-methods-to-be-unlimited-when-sending-to-a-pipe arch/sparc64/kernel/binfmt_aout32.c
--- a/arch/sparc64/kernel/binfmt_aout32.c~allow-individual-core-dump-methods-to-be-unlimited-when-sending-to-a-pipe
+++ a/arch/sparc64/kernel/binfmt_aout32.c
@@ -83,7 +83,7 @@ if (file->f_op->llseek) { \
  * dumping of the process results in another error..
  */
 
-static int aout32_core_dump(long signr, struct pt_regs *regs, struct file *file)
+static int aout32_core_dump(long signr, struct pt_regs *regs, struct file *file, u32 limit)
 {
 	mm_segment_t fs;
 	int has_dumped = 0;
@@ -102,13 +102,11 @@ static int aout32_core_dump(long signr, 
 
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
diff -puN arch/x86_64/ia32/ia32_aout.c~allow-individual-core-dump-methods-to-be-unlimited-when-sending-to-a-pipe arch/x86_64/ia32/ia32_aout.c
--- a/arch/x86_64/ia32/ia32_aout.c~allow-individual-core-dump-methods-to-be-unlimited-when-sending-to-a-pipe
+++ a/arch/x86_64/ia32/ia32_aout.c
@@ -40,7 +40,7 @@ static int load_aout_binary(struct linux
 static int load_aout_library(struct file*);
 
 #ifdef CORE_DUMP
-static int aout_core_dump(long signr, struct pt_regs * regs, struct file *file);
+static int aout_core_dump(long signr, struct pt_regs * regs, struct file *file, u32 limit);
 
 /*
  * fill in the user structure for a core dump..
@@ -148,7 +148,7 @@ if (file->f_op->llseek) { \
  * dumping of the process results in another error..
  */
 
-static int aout_core_dump(long signr, struct pt_regs * regs, struct file *file)
+static int aout_core_dump(long signr, struct pt_regs * regs, struct file *file, u32 limit)
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
diff -puN fs/binfmt_aout.c~allow-individual-core-dump-methods-to-be-unlimited-when-sending-to-a-pipe fs/binfmt_aout.c
--- a/fs/binfmt_aout.c~allow-individual-core-dump-methods-to-be-unlimited-when-sending-to-a-pipe
+++ a/fs/binfmt_aout.c
@@ -31,7 +31,7 @@
 
 static int load_aout_binary(struct linux_binprm *, struct pt_regs * regs);
 static int load_aout_library(struct file*);
-static int aout_core_dump(long signr, struct pt_regs * regs, struct file *file);
+static int aout_core_dump(long signr, struct pt_regs * regs, struct file *file, u32 limit);
 
 static struct linux_binfmt aout_format = {
 	.module		= THIS_MODULE,
@@ -88,7 +88,7 @@ if (file->f_op->llseek) { \
  * dumping of the process results in another error..
  */
 
-static int aout_core_dump(long signr, struct pt_regs * regs, struct file *file)
+static int aout_core_dump(long signr, struct pt_regs * regs, struct file *file, u32 limit)
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
 
diff -puN fs/binfmt_elf.c~allow-individual-core-dump-methods-to-be-unlimited-when-sending-to-a-pipe fs/binfmt_elf.c
--- a/fs/binfmt_elf.c~allow-individual-core-dump-methods-to-be-unlimited-when-sending-to-a-pipe
+++ a/fs/binfmt_elf.c
@@ -52,7 +52,7 @@ static unsigned long elf_map (struct fil
  * don't even try.
  */
 #if defined(USE_ELF_CORE_DUMP) && defined(CONFIG_ELF_CORE)
-static int elf_core_dump(long signr, struct pt_regs *regs, struct file *file);
+static int elf_core_dump(long signr, struct pt_regs *regs, struct file *file, u32 limit);
 #else
 #define elf_core_dump	NULL
 #endif
@@ -1488,7 +1488,7 @@ static struct vm_area_struct *next_vma(s
  * and then they are actually written out.  If we run out of core limit
  * we just truncate.
  */
-static int elf_core_dump(long signr, struct pt_regs *regs, struct file *file)
+static int elf_core_dump(long signr, struct pt_regs *regs, struct file *file, u32 limit)
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
diff -puN fs/binfmt_elf_fdpic.c~allow-individual-core-dump-methods-to-be-unlimited-when-sending-to-a-pipe fs/binfmt_elf_fdpic.c
--- a/fs/binfmt_elf_fdpic.c~allow-individual-core-dump-methods-to-be-unlimited-when-sending-to-a-pipe
+++ a/fs/binfmt_elf_fdpic.c
@@ -75,7 +75,7 @@ static int elf_fdpic_map_file_by_direct_
 					     struct file *, struct mm_struct *);
 
 #if defined(USE_ELF_CORE_DUMP) && defined(CONFIG_ELF_CORE)
-static int elf_fdpic_core_dump(long, struct pt_regs *, struct file *);
+static int elf_fdpic_core_dump(long, struct pt_regs *, struct file *, u32 limit);
 #endif
 
 static struct linux_binfmt elf_fdpic_format = {
@@ -1552,7 +1552,7 @@ static int elf_fdpic_dump_segments(struc
  * we just truncate.
  */
 static int elf_fdpic_core_dump(long signr, struct pt_regs *regs,
-			       struct file *file)
+			       struct file *file, u32 limit)
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
diff -puN fs/binfmt_flat.c~allow-individual-core-dump-methods-to-be-unlimited-when-sending-to-a-pipe fs/binfmt_flat.c
--- a/fs/binfmt_flat.c~allow-individual-core-dump-methods-to-be-unlimited-when-sending-to-a-pipe
+++ a/fs/binfmt_flat.c
@@ -75,7 +75,7 @@ static int load_flat_shared_library(int 
 #endif
 
 static int load_flat_binary(struct linux_binprm *, struct pt_regs * regs);
-static int flat_core_dump(long signr, struct pt_regs * regs, struct file *file);
+static int flat_core_dump(long signr, struct pt_regs * regs, struct file *file, u32 limit);
 
 static struct linux_binfmt flat_format = {
 	.module		= THIS_MODULE,
@@ -90,7 +90,7 @@ static struct linux_binfmt flat_format =
  * Currently only a stub-function.
  */
 
-static int flat_core_dump(long signr, struct pt_regs * regs, struct file *file)
+static int flat_core_dump(long signr, struct pt_regs * regs, struct file *file, u32 limit)
 {
 	printk("Process %s:%d received signr %d and should have core dumped\n",
 			current->comm, current->pid, (int) signr);
diff -puN fs/binfmt_som.c~allow-individual-core-dump-methods-to-be-unlimited-when-sending-to-a-pipe fs/binfmt_som.c
--- a/fs/binfmt_som.c~allow-individual-core-dump-methods-to-be-unlimited-when-sending-to-a-pipe
+++ a/fs/binfmt_som.c
@@ -44,7 +44,7 @@ static int load_som_library(struct file 
  * don't even try.
  */
 #if 0
-static int som_core_dump(long signr, struct pt_regs * regs);
+static int som_core_dump(long signr, struct pt_regs * regs, u32 limit);
 #else
 #define som_core_dump	NULL
 #endif
diff -puN fs/exec.c~allow-individual-core-dump-methods-to-be-unlimited-when-sending-to-a-pipe fs/exec.c
--- a/fs/exec.c~allow-individual-core-dump-methods-to-be-unlimited-when-sending-to-a-pipe
+++ a/fs/exec.c
@@ -1703,6 +1703,7 @@ int do_coredump(long signr, int exit_cod
 	int fsuid = current->fsuid;
 	int flag = 0;
 	int ispipe = 0;
+	u32 core_limit = current->signal->rlim[RLIMIT_CORE].rlim_cur;
 
 	audit_core_dumps(signr);
 
@@ -1753,10 +1754,11 @@ int do_coredump(long signr, int exit_cod
 	 * as it does with any other process
 	 */
 	if ((!ispipe) &&
-	   (current->signal->rlim[RLIMIT_CORE].rlim_cur < binfmt->min_coredump))
+	   (core_limit < binfmt->min_coredump))
 		goto fail_unlock;
 
  	if (ispipe) {
+		core_limit = RLIM_INFINITY;
 		/* SIGPIPE can happen, but it's just never processed */
  		if(call_usermodehelper_pipe(corename+1, NULL, NULL, &file)) {
  			printk(KERN_INFO "Core dump to %s pipe failed\n",
@@ -1786,7 +1788,7 @@ int do_coredump(long signr, int exit_cod
 	if (!ispipe && do_truncate(file->f_path.dentry, 0, 0, file) != 0)
 		goto close_fail;
 
-	retval = binfmt->core_dump(signr, regs, file);
+	retval = binfmt->core_dump(signr, regs, file, core_limit);
 
 	if (retval)
 		current->signal->group_exit_code |= 0x80;
diff -puN include/linux/binfmts.h~allow-individual-core-dump-methods-to-be-unlimited-when-sending-to-a-pipe include/linux/binfmts.h
--- a/include/linux/binfmts.h~allow-individual-core-dump-methods-to-be-unlimited-when-sending-to-a-pipe
+++ a/include/linux/binfmts.h
@@ -68,7 +68,7 @@ struct linux_binfmt {
 	struct module *module;
 	int (*load_binary)(struct linux_binprm *, struct  pt_regs * regs);
 	int (*load_shlib)(struct file *);
-	int (*core_dump)(long signr, struct pt_regs * regs, struct file * file);
+	int (*core_dump)(long signr, struct pt_regs * regs, struct file * file, u32 limit);
 	unsigned long min_coredump;	/* minimal dump size */
 	int hasvdso;
 };
_

Patches currently in -mm which might be from nhorman@tuxdriver.com are

allow-individual-core-dump-methods-to-be-unlimited-when-sending-to-a-pipe.patch
