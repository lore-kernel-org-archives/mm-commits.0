From: akpm@linux-foundation.org
Subject: + remove-aout-interpreter-support-in-elf-loader.patch added to -mm tree
Date: Thu, 31 Jan 2008 00:07:37 -0800
Message-ID: <200801310807.m0V87Iq0015560@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45383 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752895AbYAaIIj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 31 Jan 2008 03:08:39 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: andi@firstfloor.org, ak@suse.de, dhowells@redhat.com


The patch titled
     Remove a.out interpreter support in ELF loader
has been added to the -mm tree.  Its filename is
     remove-aout-interpreter-support-in-elf-loader.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Remove a.out interpreter support in ELF loader
From: Andi Kleen <andi@firstfloor.org>

Following the deprecation schedule the a.out ELF interpreter support
is removed now with this patch. a.out ELF interpreters were an transition
feature for moving a.out systems to ELF, but they're unlikely to be still
needed. Pure a.out systems will still work of course. This allows to
simplify the hairy ELF loader.

Signed-off-by: Andi Kleen <ak@suse.de>
Cc: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/feature-removal-schedule.txt |   11 -
 fs/binfmt_elf.c                            |  173 ++-----------------
 2 files changed, 21 insertions(+), 163 deletions(-)

diff -puN Documentation/feature-removal-schedule.txt~remove-aout-interpreter-support-in-elf-loader Documentation/feature-removal-schedule.txt
--- a/Documentation/feature-removal-schedule.txt~remove-aout-interpreter-support-in-elf-loader
+++ a/Documentation/feature-removal-schedule.txt
@@ -82,17 +82,6 @@ Who:	Eric Biederman <ebiederm@xmission.c
 
 ---------------------------
 
-What:  a.out interpreter support for ELF executables
-When:  2.6.25
-Files: fs/binfmt_elf.c
-Why:   Using a.out interpreters for ELF executables was a feature for
-       transition from a.out to ELF. But now it is unlikely to be still
-       needed anymore and removing it would simplify the hairy ELF
-       loader code.
-Who:   Andi Kleen <ak@suse.de>
-
----------------------------
-
 What:	remove EXPORT_SYMBOL(kernel_thread)
 When:	August 2006
 Files:	arch/*/kernel/*_ksyms.c
diff -puN fs/binfmt_elf.c~remove-aout-interpreter-support-in-elf-loader fs/binfmt_elf.c
--- a/fs/binfmt_elf.c~remove-aout-interpreter-support-in-elf-loader
+++ a/fs/binfmt_elf.c
@@ -134,8 +134,7 @@ static int padzero(unsigned long elf_bss
 
 static int
 create_elf_tables(struct linux_binprm *bprm, struct elfhdr *exec,
-		int interp_aout, unsigned long load_addr,
-		unsigned long interp_load_addr)
+		unsigned long load_addr, unsigned long interp_load_addr)
 {
 	unsigned long p = bprm->p;
 	int argc = bprm->argc;
@@ -223,12 +222,7 @@ create_elf_tables(struct linux_binprm *b
 
 	sp = STACK_ADD(p, ei_index);
 
-	items = (argc + 1) + (envc + 1);
-	if (interp_aout) {
-		items += 3; /* a.out interpreters require argv & envp too */
-	} else {
-		items += 1; /* ELF interpreters only put argc on the stack */
-	}
+	items = (argc + 1) + (envc + 1) + 1;
 	bprm->p = STACK_ROUND(sp, items);
 
 	/* Point sp at the lowest address on the stack */
@@ -251,16 +245,8 @@ create_elf_tables(struct linux_binprm *b
 	/* Now, let's put argc (and argv, envp if appropriate) on the stack */
 	if (__put_user(argc, sp++))
 		return -EFAULT;
-	if (interp_aout) {
-		argv = sp + 2;
-		envp = argv + argc + 1;
-		if (__put_user((elf_addr_t)(unsigned long)argv, sp++) ||
-		    __put_user((elf_addr_t)(unsigned long)envp, sp++))
-			return -EFAULT;
-	} else {
-		argv = sp;
-		envp = argv + argc + 1;
-	}
+	argv = sp;
+	envp = argv + argc + 1;
 
 	/* Populate argv and envp */
 	p = current->mm->arg_end = current->mm->arg_start;
@@ -513,61 +499,6 @@ out:
 	return error;
 }
 
-#ifdef CONFIG_ARCH_SUPPORTS_AOUT
-static unsigned long load_aout_interp(struct exec *interp_ex,
-		struct file *interpreter)
-{
-	unsigned long text_data, elf_entry = ~0UL;
-	char __user * addr;
-	loff_t offset;
-
-	current->mm->end_code = interp_ex->a_text;
-	text_data = interp_ex->a_text + interp_ex->a_data;
-	current->mm->end_data = text_data;
-	current->mm->brk = interp_ex->a_bss + text_data;
-
-	switch (N_MAGIC(*interp_ex)) {
-	case OMAGIC:
-		offset = 32;
-		addr = (char __user *)0;
-		break;
-	case ZMAGIC:
-	case QMAGIC:
-		offset = N_TXTOFF(*interp_ex);
-		addr = (char __user *)N_TXTADDR(*interp_ex);
-		break;
-	default:
-		goto out;
-	}
-
-	down_write(&current->mm->mmap_sem);	
-	do_brk(0, text_data);
-	up_write(&current->mm->mmap_sem);
-	if (!interpreter->f_op || !interpreter->f_op->read)
-		goto out;
-	if (interpreter->f_op->read(interpreter, addr, text_data, &offset) < 0)
-		goto out;
-	flush_icache_range((unsigned long)addr,
-	                   (unsigned long)addr + text_data);
-
-	down_write(&current->mm->mmap_sem);	
-	do_brk(ELF_PAGESTART(text_data + ELF_MIN_ALIGN - 1),
-		interp_ex->a_bss);
-	up_write(&current->mm->mmap_sem);
-	elf_entry = interp_ex->a_entry;
-
-out:
-	return elf_entry;
-}
-#else
-/* dummy extern - the function should never be called if !CONFIG_AOUT_BINFMT */
-static inline unsigned long load_aout_interp(struct exec *interp_ex,
-					     struct file *interpreter)
-{
-	return -ELIBACC;
-}
-#endif
-
 /*
  * These are the functions used to load ELF style executables and shared
  * libraries.  There is no binary dependent code anywhere else.
@@ -576,13 +507,6 @@ static inline unsigned long load_aout_in
 #define INTERPRETER_NONE 0
 #define INTERPRETER_ELF 2
 
-#ifdef CONFIG_ARCH_SUPPORTS_AOUT
-#define INTERPRETER_AOUT 1
-#define IS_AOUT_INTERP(x) ((x) == INTERPRETER_AOUT)
-#else
-#define IS_AOUT_INTERP(x) (0)
-#endif
-
 #ifndef STACK_RND_MASK
 #define STACK_RND_MASK (0x7ff >> (PAGE_SHIFT - 12))	/* 8MB of VA */
 #endif
@@ -609,7 +533,6 @@ static int load_elf_binary(struct linux_
  	unsigned long load_addr = 0, load_bias = 0;
 	int load_addr_set = 0;
 	char * elf_interpreter = NULL;
-	unsigned int interpreter_type = INTERPRETER_NONE;
 	unsigned long error;
 	struct elf_phdr *elf_ppnt, *elf_phdata;
 	unsigned long elf_bss, elf_brk;
@@ -620,7 +543,6 @@ static int load_elf_binary(struct linux_
 	unsigned long interp_load_addr = 0;
 	unsigned long start_code, end_code, start_data, end_data;
 	unsigned long reloc_func_desc = 0;
-	char passed_fileno[6];
 	struct files_struct *files;
 	int executable_stack = EXSTACK_DEFAULT;
 	unsigned long def_flags = 0;
@@ -789,62 +711,18 @@ static int load_elf_binary(struct linux_
 
 	/* Some simple consistency checks for the interpreter */
 	if (elf_interpreter) {
-		static int warn;
-#ifdef CONFIG_ARCH_SUPPORTS_AOUT
-		interpreter_type = INTERPRETER_ELF | INTERPRETER_AOUT;
-
-		/* Now figure out which format our binary is */
-		if ((N_MAGIC(loc->interp_ex) != OMAGIC) &&
-		    (N_MAGIC(loc->interp_ex) != ZMAGIC) &&
-		    (N_MAGIC(loc->interp_ex) != QMAGIC))
-			interpreter_type = INTERPRETER_ELF;
-#else
-		interpreter_type = INTERPRETER_ELF;
-#endif
-		if (memcmp(loc->interp_elf_ex.e_ident, ELFMAG, SELFMAG) != 0)
-			interpreter_type &= ~INTERPRETER_ELF;
-
-		if (IS_AOUT_INTERP(interpreter_type) && warn < 10) {
-			printk(KERN_WARNING "a.out ELF interpreter %s is "
-				"deprecated and will not be supported "
-				"after Linux 2.6.25\n", elf_interpreter);
-			warn++;
-		}
-
 		retval = -ELIBBAD;
-		if (!interpreter_type)
+		/* Not an ELF interpreter */
+		if (memcmp(loc->interp_elf_ex.e_ident, ELFMAG, SELFMAG) != 0)
 			goto out_free_dentry;
-
-		/* Make sure only one type was selected */
-		if ((interpreter_type & INTERPRETER_ELF) &&
-		     interpreter_type != INTERPRETER_ELF) {
-	     		// FIXME - ratelimit this before re-enabling
-			// printk(KERN_WARNING "ELF: Ambiguous type, using ELF\n");
-			interpreter_type = INTERPRETER_ELF;
-		}
 		/* Verify the interpreter has a valid arch */
-		if ((interpreter_type == INTERPRETER_ELF) &&
-		    !elf_check_arch(&loc->interp_elf_ex))
+		if (!elf_check_arch(&loc->interp_elf_ex))
 			goto out_free_dentry;
 	} else {
 		/* Executables without an interpreter also need a personality  */
 		SET_PERSONALITY(loc->elf_ex, 0);
 	}
 
-	/* OK, we are done with that, now set up the arg stuff,
-	   and then start this sucker up */
-	if (IS_AOUT_INTERP(interpreter_type) && !bprm->sh_bang) {
-		char *passed_p = passed_fileno;
-		sprintf(passed_fileno, "%d", elf_exec_fileno);
-
-		if (elf_interpreter) {
-			retval = copy_strings_kernel(1, &passed_p, bprm);
-			if (retval)
-				goto out_free_dentry; 
-			bprm->argc++;
-		}
-	}
-
 	/* Flush all traces of the currently running executable */
 	retval = flush_old_exec(bprm);
 	if (retval)
@@ -1022,24 +900,19 @@ static int load_elf_binary(struct linux_
 	}
 
 	if (elf_interpreter) {
-		if (IS_AOUT_INTERP(interpreter_type)) {
-			elf_entry = load_aout_interp(&loc->interp_ex,
-						     interpreter);
-		} else {
-			unsigned long uninitialized_var(interp_map_addr);
-
-			elf_entry = load_elf_interp(&loc->interp_elf_ex,
-						    interpreter,
-						    &interp_map_addr,
-						    load_bias);
-			if (!IS_ERR((void *)elf_entry)) {
-				/*
-				 * load_elf_interp() returns relocation
-				 * adjustment
-				 */
-				interp_load_addr = elf_entry;
-				elf_entry += loc->interp_elf_ex.e_entry;
-			}
+		unsigned long uninitialized_var(interp_map_addr);
+
+		elf_entry = load_elf_interp(&loc->interp_elf_ex,
+					    interpreter,
+					    &interp_map_addr,
+					    load_bias);
+		if (!IS_ERR((void *)elf_entry)) {
+			/*
+			 * load_elf_interp() returns relocation
+			 * adjustment
+			 */
+			interp_load_addr = elf_entry;
+			elf_entry += loc->interp_elf_ex.e_entry;
 		}
 		if (BAD_ADDR(elf_entry)) {
 			force_sig(SIGSEGV, current);
@@ -1063,8 +936,7 @@ static int load_elf_binary(struct linux_
 
 	kfree(elf_phdata);
 
-	if (!IS_AOUT_INTERP(interpreter_type))
-		sys_close(elf_exec_fileno);
+	sys_close(elf_exec_fileno);
 
 	set_binfmt(&elf_format);
 
@@ -1079,15 +951,12 @@ static int load_elf_binary(struct linux_
 	compute_creds(bprm);
 	current->flags &= ~PF_FORKNOEXEC;
 	retval = create_elf_tables(bprm, &loc->elf_ex,
-			  IS_AOUT_INTERP(interpreter_type),
 			  load_addr, interp_load_addr);
 	if (retval < 0) {
 		send_sig(SIGKILL, current, 0);
 		goto out;
 	}
 	/* N.B. passed_fileno might not be initialized? */
-	if (IS_AOUT_INTERP(interpreter_type))
-		current->mm->arg_start += strlen(passed_fileno) + 1;
 	current->mm->end_code = end_code;
 	current->mm->start_code = start_code;
 	current->mm->start_data = start_data;
_

Patches currently in -mm which might be from andi@firstfloor.org are

git-x86.patch
allow-executables-larger-than-2gb.patch
remove-aout-interpreter-support-in-elf-loader.patch
