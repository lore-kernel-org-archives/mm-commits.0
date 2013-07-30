From: akpm@linux-foundation.org
Subject: + fs-binfmts-whitespace-fixes-with-scripts-cleanfile.patch added
 to -mm tree
Date: Tue, 30 Jul 2013 14:06:39 -0700
Message-ID: <51f82adf.Uh77z+AHLldmXFIc%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47414 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756391Ab3G3VGk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Jul 2013 17:06:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, zach@zachsthings.com, viro@zeniv.linux.org.uk, zml@linux.vnet.ibm.com

Subject: + fs-binfmts-whitespace-fixes-with-scripts-cleanfile.patch added to -mm tree
To: zml@linux.vnet.ibm.com,viro@zeniv.linux.org.uk,zach@zachsthings.com
From: akpm@linux-foundation.org
Date: Tue, 30 Jul 2013 14:06:39 -0700


The patch titled
     Subject: fs/binfmts: whitespace fixes with scripts/cleanfile
has been added to the -mm tree.  Its filename is
     fs-binfmts-whitespace-fixes-with-scripts-cleanfile.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fs-binfmts-whitespace-fixes-with-scripts-cleanfile.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fs-binfmts-whitespace-fixes-with-scripts-cleanfile.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Zach Levis <zml@linux.vnet.ibm.com>
Subject: fs/binfmts: whitespace fixes with scripts/cleanfile

Obligatory first-patchset whitespace commit

Signed-off-by: Zach Levis <zach@zachsthings.com>
Signed-off-by: Zach Levis <zml@linux.vnet.ibm.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/binfmt_aout.c      |    8 ++++----
 fs/binfmt_elf.c       |   38 +++++++++++++++++++-------------------
 fs/binfmt_elf_fdpic.c |    8 ++++----
 fs/binfmt_em86.c      |    4 ++--
 fs/binfmt_flat.c      |   26 +++++++++++++-------------
 fs/binfmt_misc.c      |   24 ++++++++++++------------
 fs/binfmt_script.c    |    8 ++++----
 fs/binfmt_som.c       |    2 +-
 fs/exec.c             |   12 ++++++------
 9 files changed, 65 insertions(+), 65 deletions(-)

diff -puN fs/binfmt_aout.c~fs-binfmts-whitespace-fixes-with-scripts-cleanfile fs/binfmt_aout.c
--- a/fs/binfmt_aout.c~fs-binfmts-whitespace-fixes-with-scripts-cleanfile
+++ a/fs/binfmt_aout.c
@@ -62,7 +62,7 @@ static int aout_core_dump(struct coredum
 	fs = get_fs();
 	set_fs(KERNEL_DS);
 	has_dumped = 1;
-       	strncpy(dump.u_comm, current->comm, sizeof(dump.u_comm));
+	strncpy(dump.u_comm, current->comm, sizeof(dump.u_comm));
 	dump.u_ar0 = offsetof(struct user, regs);
 	dump.signal = cprm->siginfo->si_signo;
 	aout_dump_thread(cprm->regs, &dump);
@@ -300,7 +300,7 @@ static int load_aout_binary(struct linux
 
 		if ((fd_offset & ~PAGE_MASK) != 0 && printk_ratelimit())
 		{
-			printk(KERN_WARNING 
+			printk(KERN_WARNING
 			       "fd_offset is not page aligned. Please convert program: %s\n",
 			       bprm->file->f_path.dentry->d_name.name);
 		}
@@ -389,12 +389,12 @@ static int load_aout_library(struct file
 	if ((N_TXTOFF(ex) & ~PAGE_MASK) != 0) {
 		if (printk_ratelimit())
 		{
-			printk(KERN_WARNING 
+			printk(KERN_WARNING
 			       "N_TXTOFF is not page aligned. Please convert library: %s\n",
 			       file->f_path.dentry->d_name.name);
 		}
 		vm_brk(start_addr, ex.a_text + ex.a_data + ex.a_bss);
-		
+
 		read_code(file, start_addr, N_TXTOFF(ex),
 			  ex.a_text + ex.a_data);
 		retval = 0;
diff -puN fs/binfmt_elf.c~fs-binfmts-whitespace-fixes-with-scripts-cleanfile fs/binfmt_elf.c
--- a/fs/binfmt_elf.c~fs-binfmts-whitespace-fixes-with-scripts-cleanfile
+++ a/fs/binfmt_elf.c
@@ -218,7 +218,7 @@ create_elf_tables(struct linux_binprm *b
 	} while (0)
 
 #ifdef ARCH_DLINFO
-	/* 
+	/*
 	 * ARCH_DLINFO must come first so PPC can do its special alignment of
 	 * AUXV.
 	 * update AT_VECTOR_SIZE_ARCH if the number of NEW_AUX_ENT() in
@@ -239,7 +239,7 @@ create_elf_tables(struct linux_binprm *b
 	NEW_AUX_ENT(AT_EUID, from_kuid_munged(cred->user_ns, cred->euid));
 	NEW_AUX_ENT(AT_GID, from_kgid_munged(cred->user_ns, cred->gid));
 	NEW_AUX_ENT(AT_EGID, from_kgid_munged(cred->user_ns, cred->egid));
- 	NEW_AUX_ENT(AT_SECURE, security_bprm_secureexec(bprm));
+	NEW_AUX_ENT(AT_SECURE, security_bprm_secureexec(bprm));
 	NEW_AUX_ENT(AT_RANDOM, (elf_addr_t)(unsigned long)u_rand_bytes);
 #ifdef ELF_HWCAP2
 	NEW_AUX_ENT(AT_HWCAP2, ELF_HWCAP2);
@@ -433,7 +433,7 @@ static unsigned long load_elf_interp(str
 	error = -EIO;
 	if (retval != size) {
 		if (retval < 0)
-			error = retval;	
+			error = retval;
 		goto out_close;
 	}
 
@@ -452,7 +452,7 @@ static unsigned long load_elf_interp(str
 			unsigned long k, map_addr;
 
 			if (eppnt->p_flags & PF_R)
-		    		elf_prot = PROT_READ;
+				elf_prot = PROT_READ;
 			if (eppnt->p_flags & PF_W)
 				elf_prot |= PROT_WRITE;
 			if (eppnt->p_flags & PF_X)
@@ -570,7 +570,7 @@ static unsigned long randomize_stack_top
 static int load_elf_binary(struct linux_binprm *bprm)
 {
 	struct file *interpreter = NULL; /* to shut gcc up */
- 	unsigned long load_addr = 0, load_bias = 0;
+	unsigned long load_addr = 0, load_bias = 0;
 	int load_addr_set = 0;
 	char * elf_interpreter = NULL;
 	unsigned long error;
@@ -595,7 +595,7 @@ static int load_elf_binary(struct linux_
 		retval = -ENOMEM;
 		goto out_ret;
 	}
-	
+
 	/* Get the exec-header */
 	loc->elf_ex = *((struct elfhdr *)bprm->buf);
 
@@ -615,7 +615,7 @@ static int load_elf_binary(struct linux_
 	if (loc->elf_ex.e_phentsize != sizeof(struct elf_phdr))
 		goto out;
 	if (loc->elf_ex.e_phnum < 1 ||
-	 	loc->elf_ex.e_phnum > 65536U / sizeof(struct elf_phdr))
+		loc->elf_ex.e_phnum > 65536U / sizeof(struct elf_phdr))
 		goto out;
 	size = loc->elf_ex.e_phnum * sizeof(struct elf_phdr);
 	retval = -ENOMEM;
@@ -647,7 +647,7 @@ static int load_elf_binary(struct linux_
 			 * is an a.out format binary
 			 */
 			retval = -ENOEXEC;
-			if (elf_ppnt->p_filesz > PATH_MAX || 
+			if (elf_ppnt->p_filesz > PATH_MAX ||
 			    elf_ppnt->p_filesz < 2)
 				goto out_free_ph;
 
@@ -745,7 +745,7 @@ static int load_elf_binary(struct linux_
 		send_sig(SIGKILL, current, 0);
 		goto out_free_dentry;
 	}
-	
+
 	current->mm->start_stack = bprm->p;
 
 	/* Now we do a little grungy work by mmapping the ELF image into
@@ -760,7 +760,7 @@ static int load_elf_binary(struct linux_
 
 		if (unlikely (elf_brk > elf_bss)) {
 			unsigned long nbyte;
-	            
+
 			/* There was a PT_LOAD segment with p_memsz > p_filesz
 			   before this one. Map anonymous pages, if needed,
 			   and clear the area.  */
@@ -1292,7 +1292,7 @@ static void fill_elf_note_phdr(struct el
 	return;
 }
 
-static void fill_note(struct memelfnote *note, const char *name, int type, 
+static void fill_note(struct memelfnote *note, const char *name, int type,
 		unsigned int sz, void *data)
 {
 	note->name = name;
@@ -1344,7 +1344,7 @@ static int fill_psinfo(struct elf_prpsin
 {
 	const struct cred *cred;
 	unsigned int i, len;
-	
+
 	/* first copy the parameters from user space */
 	memset(psinfo, 0, sizeof(struct elf_prpsinfo));
 
@@ -1378,7 +1378,7 @@ static int fill_psinfo(struct elf_prpsin
 	SET_GID(psinfo->pr_gid, from_kgid_munged(cred->user_ns, cred->gid));
 	rcu_read_unlock();
 	strncpy(psinfo->pr_fname, p->comm, sizeof(psinfo->pr_fname));
-	
+
 	return 0;
 }
 
@@ -1779,8 +1779,8 @@ static int elf_dump_thread_status(long s
 	t->num_notes = 0;
 
 	fill_prstatus(&t->prstatus, p, signr);
-	elf_core_copy_task_regs(p, &t->prstatus.pr_reg);	
-	
+	elf_core_copy_task_regs(p, &t->prstatus.pr_reg);
+
 	fill_note(&t->notes[0], "CORE", NT_PRSTATUS, sizeof(t->prstatus),
 		  &(t->prstatus));
 	t->num_notes++;
@@ -1801,7 +1801,7 @@ static int elf_dump_thread_status(long s
 		t->num_notes++;
 		sz += notesize(&t->notes[2]);
 	}
-#endif	
+#endif
 	return sz;
 }
 
@@ -2053,7 +2053,7 @@ static int elf_core_dump(struct coredump
 
 	/*
 	 * We no longer stop all VM operations.
-	 * 
+	 *
 	 * This is because those proceses that could possibly change map_count
 	 * or the mmap / vma pages are now blocked in do_exit on current
 	 * finishing this core dump.
@@ -2062,7 +2062,7 @@ static int elf_core_dump(struct coredump
 	 * the map_count or the pages allocated. So no possibility of crashing
 	 * exists while dumping the mm->vm_next areas to the core file.
 	 */
-  
+
 	/* alloc memory for large data structures: too large to be on stack */
 	elf = kmalloc(sizeof(*elf), GFP_KERNEL);
 	if (!elf)
@@ -2168,7 +2168,7 @@ static int elf_core_dump(struct coredump
 	if (!elf_core_write_extra_phdrs(cprm->file, offset, &size, cprm->limit))
 		goto end_coredump;
 
- 	/* write out the notes section */
+	/* write out the notes section */
 	if (!write_note_info(&info, cprm->file, &foffset))
 		goto end_coredump;
 
diff -puN fs/binfmt_elf_fdpic.c~fs-binfmts-whitespace-fixes-with-scripts-cleanfile fs/binfmt_elf_fdpic.c
--- a/fs/binfmt_elf_fdpic.c~fs-binfmts-whitespace-fixes-with-scripts-cleanfile
+++ a/fs/binfmt_elf_fdpic.c
@@ -1595,8 +1595,8 @@ static int elf_fdpic_core_dump(struct co
 	struct memelfnote *notes = NULL;
 	struct elf_prstatus *prstatus = NULL;	/* NT_PRSTATUS */
 	struct elf_prpsinfo *psinfo = NULL;	/* NT_PRPSINFO */
- 	LIST_HEAD(thread_list);
- 	struct list_head *t;
+	LIST_HEAD(thread_list);
+	struct list_head *t;
 	elf_fpregset_t *fpu = NULL;
 #ifdef ELF_CORE_COPY_XFPREGS
 	elf_fpxregset_t *xfpu = NULL;
@@ -1705,7 +1705,7 @@ static int elf_fdpic_core_dump(struct co
 	fill_note(&notes[numnote++], "CORE", NT_AUXV,
 		  i * sizeof(elf_addr_t), auxv);
 
-  	/* Try to dump the FPU. */
+	/* Try to dump the FPU. */
 	if ((prstatus->pr_fpvalid =
 	     elf_core_copy_task_fpregs(current, cprm->regs, fpu)))
 		fill_note(notes + numnote++,
@@ -1795,7 +1795,7 @@ static int elf_fdpic_core_dump(struct co
 	if (!elf_core_write_extra_phdrs(cprm->file, offset, &size, cprm->limit))
 		goto end_coredump;
 
- 	/* write out the notes section */
+	/* write out the notes section */
 	for (i = 0; i < numnote; i++)
 		if (!writenote(notes + i, cprm->file, &foffset))
 			goto end_coredump;
diff -puN fs/binfmt_em86.c~fs-binfmts-whitespace-fixes-with-scripts-cleanfile fs/binfmt_em86.c
--- a/fs/binfmt_em86.c~fs-binfmts-whitespace-fixes-with-scripts-cleanfile
+++ a/fs/binfmt_em86.c
@@ -63,11 +63,11 @@ static int load_em86(struct linux_binprm
 	 */
 	remove_arg_zero(bprm);
 	retval = copy_strings_kernel(1, &bprm->filename, bprm);
-	if (retval < 0) return retval; 
+	if (retval < 0) return retval;
 	bprm->argc++;
 	if (i_arg) {
 		retval = copy_strings_kernel(1, &i_arg, bprm);
-		if (retval < 0) return retval; 
+		if (retval < 0) return retval;
 		bprm->argc++;
 	}
 	retval = copy_strings_kernel(1, &i_name, bprm);
diff -puN fs/binfmt_flat.c~fs-binfmts-whitespace-fixes-with-scripts-cleanfile fs/binfmt_flat.c
--- a/fs/binfmt_flat.c~fs-binfmts-whitespace-fixes-with-scripts-cleanfile
+++ a/fs/binfmt_flat.c
@@ -388,7 +388,7 @@ void old_reloc(unsigned long rl)
 #endif
 	flat_v2_reloc_t	r;
 	unsigned long *ptr;
-	
+
 	r.value = rl;
 #if defined(CONFIG_COLDFIRE)
 	ptr = (unsigned long *) (current->mm->start_code + r.reloc.offset);
@@ -401,7 +401,7 @@ void old_reloc(unsigned long rl)
 		"(address %p, currently %x) into segment %s\n",
 		r.reloc.offset, ptr, (int)*ptr, segment[r.reloc.type]);
 #endif
-	
+
 	switch (r.reloc.type) {
 	case OLD_FLAT_RELOC_TYPE_TEXT:
 		*ptr += current->mm->start_code;
@@ -420,7 +420,7 @@ void old_reloc(unsigned long rl)
 #ifdef DEBUG
 	printk("Relocation became %x\n", (int)*ptr);
 #endif
-}		
+}
 
 /****************************************************************************/
 
@@ -479,7 +479,7 @@ static int load_flat_file(struct linux_b
 		ret = -ENOEXEC;
 		goto err;
 	}
-	
+
 	/* Don't allow old format executables to use shared libraries */
 	if (rev == OLD_FLAT_VERSION && id != 0) {
 		printk("BINFMT_FLAT: shared libraries are not available before rev 0x%x\n",
@@ -581,7 +581,7 @@ static int load_flat_file(struct linux_b
 		fpos = ntohl(hdr->data_start);
 #ifdef CONFIG_BINFMT_ZFLAT
 		if (flags & FLAT_FLAG_GZDATA) {
-			result = decompress_exec(bprm, fpos, (char *) datapos, 
+			result = decompress_exec(bprm, fpos, (char *) datapos,
 						 full_data, 0);
 		} else
 #endif
@@ -704,7 +704,7 @@ static int load_flat_file(struct linux_b
 	libinfo->lib_list[id].loaded = 1;
 	libinfo->lib_list[id].entry = (0x00ffffff & ntohl(hdr->entry)) + textpos;
 	libinfo->lib_list[id].build_date = ntohl(hdr->build_date);
-	
+
 	/*
 	 * We just load the allocations into some temporary memory to
 	 * help simplify all this mumbo jumbo
@@ -784,11 +784,11 @@ static int load_flat_file(struct linux_b
 		for (i=0; i < relocs; i++)
 			old_reloc(ntohl(reloc[i]));
 	}
-	
+
 	flush_icache_range(start_code, end_code);
 
 	/* zero the BSS,  BRK and stack areas */
-	memset((void*)(datapos + data_len), 0, bss_len + 
+	memset((void*)(datapos + data_len), 0, bss_len +
 			(memp + memp_size - stack_len -		/* end brk */
 			libinfo->lib_list[id].start_brk) +	/* start brk */
 			stack_len);
@@ -882,11 +882,11 @@ static int load_flat_binary(struct linux
 	stack_len += (bprm->argc + 1) * sizeof(char *); /* the argv array */
 	stack_len += (bprm->envc + 1) * sizeof(char *); /* the envp array */
 	stack_len += FLAT_STACK_ALIGN - 1;  /* reserve for upcoming alignment */
-	
+
 	res = load_flat_file(bprm, &libinfo, 0, &stack_len);
 	if (IS_ERR_VALUE(res))
 		return res;
-	
+
 	/* Update data segment pointers for all libraries */
 	for (i=0; i<MAX_SHARED_LIBS; i++)
 		if (libinfo.lib_list[i].loaded)
@@ -908,7 +908,7 @@ static int load_flat_binary(struct linux
 			((char *) page_address(bprm->page[i/PAGE_SIZE]))[i % PAGE_SIZE];
 
 	sp = (unsigned long *) create_flat_tables(p, bprm);
-	
+
 	/* Fake some return addresses to ensure the call chain will
 	 * initialise library in order for us.  We are required to call
 	 * lib 1 first, then 2, ... and finally the main program (id 0).
@@ -924,7 +924,7 @@ static int load_flat_binary(struct linux
 		}
 	}
 #endif
-	
+
 	/* Stash our initial stack pointer into the mm structure */
 	current->mm->start_stack = (unsigned long )sp;
 
@@ -933,7 +933,7 @@ static int load_flat_binary(struct linux
 #endif
 	DBG_FLT("start_thread(regs=0x%x, entry=0x%x, start_stack=0x%x)\n",
 		(int)regs, (int)start_addr, (int)current->mm->start_stack);
-	
+
 	start_thread(regs, start_addr, current->mm->start_stack);
 
 	return 0;
diff -puN fs/binfmt_misc.c~fs-binfmts-whitespace-fixes-with-scripts-cleanfile fs/binfmt_misc.c
--- a/fs/binfmt_misc.c~fs-binfmts-whitespace-fixes-with-scripts-cleanfile
+++ a/fs/binfmt_misc.c
@@ -62,7 +62,7 @@ static struct file_system_type bm_fs_typ
 static struct vfsmount *bm_mnt;
 static int entry_count;
 
-/* 
+/*
  * Check if we support the binfmt
  * if we do, return the node, else NULL
  * locking is done in load_misc_binary
@@ -138,12 +138,12 @@ static int load_misc_binary(struct linux
 		/* if the binary should be opened on behalf of the
 		 * interpreter than keep it open and assign descriptor
 		 * to it */
- 		fd_binary = get_unused_fd();
- 		if (fd_binary < 0) {
- 			retval = fd_binary;
- 			goto _ret;
- 		}
- 		fd_install(fd_binary, bprm->file);
+		fd_binary = get_unused_fd();
+		if (fd_binary < 0) {
+			retval = fd_binary;
+			goto _ret;
+		}
+		fd_install(fd_binary, bprm->file);
 
 		/* if the binary is not readable than enforce mm->dumpable=0
 		   regardless of the interpreter's permissions */
@@ -156,11 +156,11 @@ static int load_misc_binary(struct linux
 		bprm->interp_flags |= BINPRM_FLAGS_EXECFD;
 		bprm->interp_data = fd_binary;
 
- 	} else {
- 		allow_write_access(bprm->file);
- 		fput(bprm->file);
- 		bprm->file = NULL;
- 	}
+	} else {
+		allow_write_access(bprm->file);
+		fput(bprm->file);
+		bprm->file = NULL;
+	}
 	/* make argv[1] be the path to the binary */
 	retval = copy_strings_kernel (1, &bprm->interp, bprm);
 	if (retval < 0)
diff -puN fs/binfmt_script.c~fs-binfmts-whitespace-fixes-with-scripts-cleanfile fs/binfmt_script.c
--- a/fs/binfmt_script.c~fs-binfmts-whitespace-fixes-with-scripts-cleanfile
+++ a/fs/binfmt_script.c
@@ -45,7 +45,7 @@ static int load_script(struct linux_binp
 			break;
 	}
 	for (cp = bprm->buf+2; (*cp == ' ') || (*cp == '\t'); cp++);
-	if (*cp == '\0') 
+	if (*cp == '\0')
 		return -ENOEXEC; /* No interpreter name found */
 	i_name = cp;
 	i_arg = NULL;
@@ -70,15 +70,15 @@ static int load_script(struct linux_binp
 	if (retval)
 		return retval;
 	retval = copy_strings_kernel(1, &bprm->interp, bprm);
-	if (retval < 0) return retval; 
+	if (retval < 0) return retval;
 	bprm->argc++;
 	if (i_arg) {
 		retval = copy_strings_kernel(1, &i_arg, bprm);
-		if (retval < 0) return retval; 
+		if (retval < 0) return retval;
 		bprm->argc++;
 	}
 	retval = copy_strings_kernel(1, &i_name, bprm);
-	if (retval) return retval; 
+	if (retval) return retval;
 	bprm->argc++;
 	retval = bprm_change_interp(interp, bprm);
 	if (retval < 0)
diff -puN fs/binfmt_som.c~fs-binfmts-whitespace-fixes-with-scripts-cleanfile fs/binfmt_som.c
--- a/fs/binfmt_som.c~fs-binfmts-whitespace-fixes-with-scripts-cleanfile
+++ a/fs/binfmt_som.c
@@ -2,7 +2,7 @@
  * linux/fs/binfmt_som.c
  *
  * These are the functions used to load SOM format executables as used
- * by HP-UX.  
+ * by HP-UX.
  *
  * Copyright 1999 Matthew Wilcox <willy@bofh.ai>
  * based on binfmt_elf which is
diff -puN fs/exec.c~fs-binfmts-whitespace-fixes-with-scripts-cleanfile fs/exec.c
--- a/fs/exec.c~fs-binfmts-whitespace-fixes-with-scripts-cleanfile
+++ a/fs/exec.c
@@ -19,7 +19,7 @@
  * current->executable is only used by the procfs.  This allows a dispatch
  * table to check for several different types  of binary formats.  We keep
  * trying until we recognize the file or we run out of supported binary
- * formats. 
+ * formats.
  */
 
 #include <linux/slab.h>
@@ -155,7 +155,7 @@ SYSCALL_DEFINE1(uselib, const char __use
 exit:
 	fput(file);
 out:
-  	return error;
+	return error;
 }
 
 #ifdef CONFIG_MMU
@@ -1141,7 +1141,7 @@ void setup_new_exec(struct linux_binprm
 	   group */
 
 	current->self_exec_id++;
-			
+
 	flush_signal_handlers(current, 0);
 	do_close_on_exec(current->files);
 }
@@ -1267,8 +1267,8 @@ static int check_unsafe_exec(struct linu
 	return res;
 }
 
-/* 
- * Fill the binprm structure from the inode. 
+/*
+ * Fill the binprm structure from the inode.
  * Check permissions, then read the first 128 (BINPRM_BUF_SIZE) bytes
  *
  * This may be called multiple times for binary chains (scripts for example).
@@ -1371,7 +1371,7 @@ EXPORT_SYMBOL(remove_arg_zero);
 int search_binary_handler(struct linux_binprm *bprm)
 {
 	unsigned int depth = bprm->recursion_depth;
-	int try,retval;
+	int try, retval;
 	struct linux_binfmt *fmt;
 	pid_t old_pid, old_vpid;
 
_

Patches currently in -mm which might be from zml@linux.vnet.ibm.com are

fs-binfmts-add-a-name-field-to-the-binfmt-struct.patch
fs-binfmts-better-handling-of-binfmt-loops.patch
fs-binfmts-whitespace-fixes-with-scripts-cleanfile.patch

