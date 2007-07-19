From: akpm@linux-foundation.org
Subject: + binfmt_elf-clean-up-the-pie-randomization-code.patch added to -mm tree
Date: Thu, 19 Jul 2007 15:54:36 -0700
Message-ID: <200707192254.l6JMsahB027150@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53593 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754884AbXGSWzB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Jul 2007 18:55:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: cebbert@redhat.com, honza@jikos.cz, jakub@redhat.com, roland@redhat.com


The patch titled
     binfmt_elf: clean up the PIE randomization code
has been added to the -mm tree.  Its filename is
     binfmt_elf-clean-up-the-pie-randomization-code.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: binfmt_elf: clean up the PIE randomization code
From: Chuck Ebbert <cebbert@redhat.com>

The recent PIE randomization patch changed the BAD_ADDR() macro
in binfmt_elf.c:

     -#define BAD_ADDR(x) ((unsigned long)(x) >= TASK_SIZE)
     +#define BAD_ADDR(x) IS_ERR_VALUE(x)

But in general this is not what is desired.  There was only one piece of
code that wanted to use a different check.  It is much cleaner and clearer
to revert part of the patch so the code works like it did before and the
change to the macro is unnecessary.  (This is what has been done in the Red
Hat Enterprise kernels.)

Signed-off-by: Chuck Ebbert <cebbert@redhat.com>
Cc: Jan Kratochvil <honza@jikos.cz>
Cc: Jakub Jelinek <jakub@redhat.com>
Cc: Roland McGrath <roland@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/binfmt_elf.c |   26 +++++++-------------------
 1 files changed, 7 insertions(+), 19 deletions(-)

diff -puN fs/binfmt_elf.c~binfmt_elf-clean-up-the-pie-randomization-code fs/binfmt_elf.c
--- a/fs/binfmt_elf.c~binfmt_elf-clean-up-the-pie-randomization-code
+++ a/fs/binfmt_elf.c
@@ -80,7 +80,7 @@ static struct linux_binfmt elf_format = 
 		.hasvdso	= 1
 };
 
-#define BAD_ADDR(x) IS_ERR_VALUE(x)
+#define BAD_ADDR(x) ((unsigned long)(x) >= TASK_SIZE)
 
 static int set_brk(unsigned long start, unsigned long end)
 {
@@ -357,7 +357,7 @@ static unsigned long total_mapping_size(
    an ELF header */
 
 static unsigned long load_elf_interp(struct elfhdr *interp_elf_ex,
-		struct file *interpreter, unsigned long *interp_map_addr,
+		struct file *interpreter, unsigned long *interp_load_addr,
 		unsigned long no_base)
 {
 	struct elf_phdr *elf_phdata;
@@ -434,8 +434,6 @@ static unsigned long load_elf_interp(str
 			map_addr = elf_map(interpreter, load_addr + vaddr,
 					   eppnt, elf_prot, elf_type, total_size);
 			total_size = 0;
-			if (!*interp_map_addr)
-				*interp_map_addr = map_addr;
 			error = map_addr;
 			if (BAD_ADDR(map_addr))
 				goto out_close;
@@ -501,7 +499,8 @@ static unsigned long load_elf_interp(str
 			goto out_close;
 	}
 
-	error = load_addr;
+	*interp_load_addr = load_addr;
+	error = ((unsigned long)interp_elf_ex->e_entry) + load_addr;
 
 out_close:
 	kfree(elf_phdata);
@@ -1001,25 +1000,14 @@ static int load_elf_binary(struct linux_
 	}
 
 	if (elf_interpreter) {
-		if (interpreter_type == INTERPRETER_AOUT) {
+		if (interpreter_type == INTERPRETER_AOUT)
 			elf_entry = load_aout_interp(&loc->interp_ex,
 						     interpreter);
-		} else {
-			unsigned long uninitialized_var(interp_map_addr);
-
+		else
 			elf_entry = load_elf_interp(&loc->interp_elf_ex,
 						    interpreter,
-						    &interp_map_addr,
+						    &interp_load_addr,
 						    load_bias);
-			if (!BAD_ADDR(elf_entry)) {
-				/*
-				 * load_elf_interp() returns relocation
-				 * adjustment
-				 */
-				interp_load_addr = elf_entry;
-				elf_entry += loc->interp_elf_ex.e_entry;
-			}
-		}
 		if (BAD_ADDR(elf_entry)) {
 			force_sig(SIGSEGV, current);
 			retval = IS_ERR((void *)elf_entry) ?
_

Patches currently in -mm which might be from cebbert@redhat.com are

origin.patch
git-acpi.patch
binfmt_elf-clean-up-the-pie-randomization-code.patch
