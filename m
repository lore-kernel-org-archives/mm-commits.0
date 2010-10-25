From: akpm@linux-foundation.org
Subject: + binfmt_elf-cleanups.patch added to -mm tree
Date: Mon, 25 Oct 2010 16:39:34 -0700
Message-ID: <201010252339.o9PNdZFw022956@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51116 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757170Ab0JYXkL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 25 Oct 2010 19:40:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mikpe@it.uu.se


The patch titled
     binfmt_elf: cleanups
has been added to the -mm tree.  Its filename is
     binfmt_elf-cleanups.patch

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
Subject: binfmt_elf: cleanups
From: Mikael Pettersson <mikpe@it.uu.se>

This cleans up a few bits in binfmt_elf.c and binfmts.h:

- the hasvdso field in struct linux_binfmt is unused, so remove it and
  the only initialization of it

- the elf_map CPP symbol is not defined anywhere in the kernel, so
  remove an unnecessary #ifndef elf_map

- reduce excessive indentation in elf_format's initializer

- add missing spaces, remove extraneous spaces

No functional changes, but tested on x86 (32 and 64 bit), powerpc (32 and
64 bit), sparc64, arm, and alpha.

Signed-off-by: Mikael Pettersson <mikpe@it.uu.se>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/binfmt_elf.c         |   23 +++++++++--------------
 include/linux/binfmts.h |    5 ++---
 2 files changed, 11 insertions(+), 17 deletions(-)

diff -puN fs/binfmt_elf.c~binfmt_elf-cleanups fs/binfmt_elf.c
--- a/fs/binfmt_elf.c~binfmt_elf-cleanups
+++ a/fs/binfmt_elf.c
@@ -66,12 +66,11 @@ static int elf_core_dump(struct coredump
 #define ELF_PAGEALIGN(_v) (((_v) + ELF_MIN_ALIGN - 1) & ~(ELF_MIN_ALIGN - 1))
 
 static struct linux_binfmt elf_format = {
-		.module		= THIS_MODULE,
-		.load_binary	= load_elf_binary,
-		.load_shlib	= load_elf_library,
-		.core_dump	= elf_core_dump,
-		.min_coredump	= ELF_EXEC_PAGESIZE,
-		.hasvdso	= 1
+	.module		= THIS_MODULE,
+	.load_binary	= load_elf_binary,
+	.load_shlib	= load_elf_library,
+	.core_dump	= elf_core_dump,
+	.min_coredump	= ELF_EXEC_PAGESIZE,
 };
 
 #define BAD_ADDR(x) ((unsigned long)(x) >= TASK_SIZE)
@@ -316,8 +315,6 @@ create_elf_tables(struct linux_binprm *b
 	return 0;
 }
 
-#ifndef elf_map
-
 static unsigned long elf_map(struct file *filep, unsigned long addr,
 		struct elf_phdr *eppnt, int prot, int type,
 		unsigned long total_size)
@@ -354,8 +351,6 @@ static unsigned long elf_map(struct file
 	return(map_addr);
 }
 
-#endif /* !elf_map */
-
 static unsigned long total_mapping_size(struct elf_phdr *cmds, int nr)
 {
 	int i, first_idx = -1, last_idx = -1;
@@ -421,7 +416,7 @@ static unsigned long load_elf_interp(str
 		goto out;
 
 	retval = kernel_read(interpreter, interp_elf_ex->e_phoff,
-			     (char *)elf_phdata,size);
+			     (char *)elf_phdata, size);
 	error = -EIO;
 	if (retval != size) {
 		if (retval < 0)
@@ -601,7 +596,7 @@ static int load_elf_binary(struct linux_
 		goto out;
 	if (!elf_check_arch(&loc->elf_ex))
 		goto out;
-	if (!bprm->file->f_op||!bprm->file->f_op->mmap)
+	if (!bprm->file->f_op || !bprm->file->f_op->mmap)
 		goto out;
 
 	/* Now read in all of the header information */
@@ -761,8 +756,8 @@ static int load_elf_binary(struct linux_
 			/* There was a PT_LOAD segment with p_memsz > p_filesz
 			   before this one. Map anonymous pages, if needed,
 			   and clear the area.  */
-			retval = set_brk (elf_bss + load_bias,
-					  elf_brk + load_bias);
+			retval = set_brk(elf_bss + load_bias,
+					 elf_brk + load_bias);
 			if (retval) {
 				send_sig(SIGKILL, current, 0);
 				goto out_free_dentry;
diff -puN include/linux/binfmts.h~binfmt_elf-cleanups include/linux/binfmts.h
--- a/include/linux/binfmts.h~binfmt_elf-cleanups
+++ a/include/linux/binfmts.h
@@ -25,7 +25,7 @@ struct pt_regs;
 /*
  * This structure is used to hold the arguments that are used when loading binaries.
  */
-struct linux_binprm{
+struct linux_binprm {
 	char buf[BINPRM_BUF_SIZE];
 #ifdef CONFIG_MMU
 	struct vm_area_struct *vma;
@@ -88,7 +88,6 @@ struct linux_binfmt {
 	int (*load_shlib)(struct file *);
 	int (*core_dump)(struct coredump_params *cprm);
 	unsigned long min_coredump;	/* minimal dump size */
-	int hasvdso;
 };
 
 extern int __register_binfmt(struct linux_binfmt *fmt, int insert);
@@ -108,7 +107,7 @@ extern void unregister_binfmt(struct lin
 
 extern int prepare_binprm(struct linux_binprm *);
 extern int __must_check remove_arg_zero(struct linux_binprm *);
-extern int search_binary_handler(struct linux_binprm *,struct pt_regs *);
+extern int search_binary_handler(struct linux_binprm *, struct pt_regs *);
 extern int flush_old_exec(struct linux_binprm * bprm);
 extern void setup_new_exec(struct linux_binprm * bprm);
 
_

Patches currently in -mm which might be from mikpe@it.uu.se are

binfmt_elf-cleanups.patch

