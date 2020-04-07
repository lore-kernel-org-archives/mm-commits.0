From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 139/166] fs/binfmt_elf.c: delete "loc" variable
Date: Mon, 06 Apr 2020 20:11:26 -0700
Message-ID: <20200407031126.6z2h97L99%akpm@linux-foundation.org>
References: <20200406200254.a69ebd9e08c4074e41ddebaf@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:57172 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726628AbgDGDL2 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 6 Apr 2020 23:11:28 -0400
In-Reply-To: <20200406200254.a69ebd9e08c4074e41ddebaf@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, akpm@linux-foundation.org, linux-mm@kvack.org, mm-commits@vger.kernel.org, torvalds@linux-foundation.org

From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: fs/binfmt_elf.c: delete "loc" variable

"loc" variable became just a wrapper for PT_INTERP ELF header after main
ELF header was moved to "bprm->buf".  Delete it.

Link: http://lkml.kernel.org/r/20200219184847.GA4871@avx2
Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/binfmt_elf.c |   32 +++++++++++++++-----------------
 1 file changed, 15 insertions(+), 17 deletions(-)

--- a/fs/binfmt_elf.c~elf-delete-loc-variable
+++ a/fs/binfmt_elf.c
@@ -699,15 +699,13 @@ static int load_elf_binary(struct linux_
 	unsigned long reloc_func_desc __maybe_unused = 0;
 	int executable_stack = EXSTACK_DEFAULT;
 	struct elfhdr *elf_ex = (struct elfhdr *)bprm->buf;
-	struct {
-		struct elfhdr interp_elf_ex;
-	} *loc;
+	struct elfhdr *interp_elf_ex;
 	struct arch_elf_state arch_state = INIT_ARCH_ELF_STATE;
 	struct mm_struct *mm;
 	struct pt_regs *regs;
 
-	loc = kmalloc(sizeof(*loc), GFP_KERNEL);
-	if (!loc) {
+	interp_elf_ex = kmalloc(sizeof(*interp_elf_ex), GFP_KERNEL);
+	if (!interp_elf_ex) {
 		retval = -ENOMEM;
 		goto out_ret;
 	}
@@ -772,8 +770,8 @@ static int load_elf_binary(struct linux_
 		would_dump(bprm, interpreter);
 
 		/* Get the exec headers */
-		retval = elf_read(interpreter, &loc->interp_elf_ex,
-				  sizeof(loc->interp_elf_ex), 0);
+		retval = elf_read(interpreter, interp_elf_ex,
+				  sizeof(*interp_elf_ex), 0);
 		if (retval < 0)
 			goto out_free_dentry;
 
@@ -807,25 +805,25 @@ out_free_interp:
 	if (interpreter) {
 		retval = -ELIBBAD;
 		/* Not an ELF interpreter */
-		if (memcmp(loc->interp_elf_ex.e_ident, ELFMAG, SELFMAG) != 0)
+		if (memcmp(interp_elf_ex->e_ident, ELFMAG, SELFMAG) != 0)
 			goto out_free_dentry;
 		/* Verify the interpreter has a valid arch */
-		if (!elf_check_arch(&loc->interp_elf_ex) ||
-		    elf_check_fdpic(&loc->interp_elf_ex))
+		if (!elf_check_arch(interp_elf_ex) ||
+		    elf_check_fdpic(interp_elf_ex))
 			goto out_free_dentry;
 
 		/* Load the interpreter program headers */
-		interp_elf_phdata = load_elf_phdrs(&loc->interp_elf_ex,
+		interp_elf_phdata = load_elf_phdrs(interp_elf_ex,
 						   interpreter);
 		if (!interp_elf_phdata)
 			goto out_free_dentry;
 
 		/* Pass PT_LOPROC..PT_HIPROC headers to arch code */
 		elf_ppnt = interp_elf_phdata;
-		for (i = 0; i < loc->interp_elf_ex.e_phnum; i++, elf_ppnt++)
+		for (i = 0; i < interp_elf_ex->e_phnum; i++, elf_ppnt++)
 			switch (elf_ppnt->p_type) {
 			case PT_LOPROC ... PT_HIPROC:
-				retval = arch_elf_pt_proc(&loc->interp_elf_ex,
+				retval = arch_elf_pt_proc(interp_elf_ex,
 							  elf_ppnt, interpreter,
 							  true, &arch_state);
 				if (retval)
@@ -840,7 +838,7 @@ out_free_interp:
 	 * the exec syscall.
 	 */
 	retval = arch_check_elf(elf_ex,
-				!!interpreter, &loc->interp_elf_ex,
+				!!interpreter, interp_elf_ex,
 				&arch_state);
 	if (retval)
 		goto out_free_dentry;
@@ -1056,7 +1054,7 @@ out_free_interp:
 	}
 
 	if (interpreter) {
-		elf_entry = load_elf_interp(&loc->interp_elf_ex,
+		elf_entry = load_elf_interp(interp_elf_ex,
 					    interpreter,
 					    load_bias, interp_elf_phdata);
 		if (!IS_ERR((void *)elf_entry)) {
@@ -1065,7 +1063,7 @@ out_free_interp:
 			 * adjustment
 			 */
 			interp_load_addr = elf_entry;
-			elf_entry += loc->interp_elf_ex.e_entry;
+			elf_entry += interp_elf_ex->e_entry;
 		}
 		if (BAD_ADDR(elf_entry)) {
 			retval = IS_ERR((void *)elf_entry) ?
@@ -1154,7 +1152,7 @@ out_free_interp:
 	start_thread(regs, elf_entry, bprm->p);
 	retval = 0;
 out:
-	kfree(loc);
+	kfree(interp_elf_ex);
 out_ret:
 	return retval;
 
_
