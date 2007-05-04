From: akpm@linux-foundation.org
Subject: + vfs-fix-passing-of-at_phdr-value-in-auxv-to-elf-interpreter.patch added to -mm tree
Date: Fri, 04 May 2007 13:51:36 -0700
Message-ID: <200705042051.l44KpaPB013883@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:44562 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1031405AbXEDUv5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 May 2007 16:51:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: godfroy@clipper.ens.fr, David.Madore@ens.fr, jakub@redhat.com, roland@redhat.com


The patch titled
     VFS: fix passing of AT_PHDR value in auxv to ELF interpreter
has been added to the -mm tree.  Its filename is
     vfs-fix-passing-of-at_phdr-value-in-auxv-to-elf-interpreter.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: VFS: fix passing of AT_PHDR value in auxv to ELF interpreter
From: Quentin Godfroy <godfroy@clipper.ens.fr>

On a dynamic ELF executable, the current kernel loader gives to the
interpreter (in the AUXV vector) the AT_PHDR argument as :
offset_of_phdr_in_file + first address.

It can be wrong for an executable where the program headers are not located
in the first loaded segment.

This patch corrects the behaviour.

Signed-off-by: Quentin Godfroy <godfroy@clipper.ens.fr>
Cc: "David A. Madore" <David.Madore@ens.fr>
Cc: Roland McGrath <roland@redhat.com>
Cc: Jakub Jelinek <jakub@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/binfmt_elf.c |   17 ++++++++++++++---
 1 files changed, 14 insertions(+), 3 deletions(-)

diff -puN fs/binfmt_elf.c~vfs-fix-passing-of-at_phdr-value-in-auxv-to-elf-interpreter fs/binfmt_elf.c
--- a/fs/binfmt_elf.c~vfs-fix-passing-of-at_phdr-value-in-auxv-to-elf-interpreter
+++ a/fs/binfmt_elf.c
@@ -134,6 +134,7 @@ static int padzero(unsigned long elf_bss
 static int
 create_elf_tables(struct linux_binprm *bprm, struct elfhdr *exec,
 		int interp_aout, unsigned long load_addr,
+		unsigned long phdr_addr,
 		unsigned long interp_load_addr)
 {
 	unsigned long p = bprm->p;
@@ -190,7 +191,7 @@ create_elf_tables(struct linux_binprm *b
 	NEW_AUX_ENT(AT_HWCAP, ELF_HWCAP);
 	NEW_AUX_ENT(AT_PAGESZ, ELF_EXEC_PAGESIZE);
 	NEW_AUX_ENT(AT_CLKTCK, CLOCKS_PER_SEC);
-	NEW_AUX_ENT(AT_PHDR, load_addr + exec->e_phoff);
+	NEW_AUX_ENT(AT_PHDR, phdr_addr);
 	NEW_AUX_ENT(AT_PHENT, sizeof(struct elf_phdr));
 	NEW_AUX_ENT(AT_PHNUM, exec->e_phnum);
 	NEW_AUX_ENT(AT_BASE, interp_load_addr);
@@ -529,7 +530,7 @@ static unsigned long randomize_stack_top
 static int load_elf_binary(struct linux_binprm *bprm, struct pt_regs *regs)
 {
 	struct file *interpreter = NULL; /* to shut gcc up */
- 	unsigned long load_addr = 0, load_bias = 0;
+ 	unsigned long load_addr = 0, load_bias = 0, phdr_addr = 0;
 	int load_addr_set = 0;
 	char * elf_interpreter = NULL;
 	unsigned int interpreter_type = INTERPRETER_NONE;
@@ -718,6 +719,16 @@ static int load_elf_binary(struct linux_
 			break;
 		}
 
+	elf_ppnt = elf_phdata;
+	for (i = 0; i< loc->elf_ex.e_phnum; i++, elf_ppnt++)
+		if (elf_ppnt->p_type == PT_PHDR) {
+			phdr_addr = elf_ppnt->p_vaddr;
+			break;
+		}
+	retval = -ENOEXEC;
+	if (!phdr_addr)
+		goto out_free_dentry;
+
 	/* Some simple consistency checks for the interpreter */
 	if (elf_interpreter) {
 		interpreter_type = INTERPRETER_ELF | INTERPRETER_AOUT;
@@ -987,7 +998,7 @@ static int load_elf_binary(struct linux_
 	current->flags &= ~PF_FORKNOEXEC;
 	create_elf_tables(bprm, &loc->elf_ex,
 			  (interpreter_type == INTERPRETER_AOUT),
-			  load_addr, interp_load_addr);
+			  load_addr, phdr_addr, interp_load_addr);
 	/* N.B. passed_fileno might not be initialized? */
 	if (interpreter_type == INTERPRETER_AOUT)
 		current->mm->arg_start += strlen(passed_fileno) + 1;
_

Patches currently in -mm which might be from godfroy@clipper.ens.fr are

vfs-fix-passing-of-at_phdr-value-in-auxv-to-elf-interpreter.patch
