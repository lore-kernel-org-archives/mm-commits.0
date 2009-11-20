From: akpm@linux-foundation.org
Subject: + binfmt-introduce-coredump-parameter-structure.patch added to -mm tree
Date: Fri, 20 Nov 2009 14:12:14 -0800
Message-ID: <200911202212.nAKMCF2v012068@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48987 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753166AbZKTWMp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 20 Nov 2009 17:12:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mhiramat@redhat.com, dhowells@redhat.com, hidehiro.kawai.ez@hitachi.com, lethal@linux-sh.org, mingo@elte.hu, oleg@redhat.com, roland@redhat.com, vapier@gentoo.org


The patch titled
     binfmt: introduce coredump parameter structure
has been added to the -mm tree.  Its filename is
     binfmt-introduce-coredump-parameter-structure.patch

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
Subject: binfmt: introduce coredump parameter structure
From: Masami Hiramatsu <mhiramat@redhat.com>

These patches are for fixing coredump mm->flags consistency issue.

---
1787         if (mm->core_state || !get_dumpable(mm)) {  <- (1)
1788                 up_write(&mm->mmap_sem);
1789                 put_cred(cred);
1790                 goto fail;
1791         }
1792
[...]
1798         if (get_dumpable(mm) == 2) {    /* Setuid core dump mode */ <-(2)
1799                 flag = O_EXCL;          /* Stop rewrite attacks */
1800                 cred->fsuid = 0;        /* Dump root private */
1801         }
---

Since dumpable bits are not protected by lock, there is a chance to change
these bits between (1) and (2).

To solve this issue, this patch copies mm->flags to
coredump_params.mm_flags at the beginning of do_coredump() and uses it
instead of get_dumpable() while dumping core.  This series also introduce
coredump parameter structure for simplify bimfmt->core_dump interface.



This patch:

Introduce coredump parameter data structure (struct coredump_params) for
simplifying binfmt->core_dump() arguments.  This also cleanup DUMP_WRITE()
in elf_core_dump() by style issue.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Suggested-by: Ingo Molnar <mingo@elte.hu>
Cc: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Roland McGrath <roland@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Mike Frysinger <vapier@gentoo.org>
Cc: David Howells <dhowells@redhat.com>
Cc: Paul Mundt <lethal@linux-sh.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/binfmt_aout.c        |   13 +++++++------
 fs/binfmt_elf.c         |   38 ++++++++++++++++++++++----------------
 fs/binfmt_elf_fdpic.c   |   28 ++++++++++++++--------------
 fs/binfmt_flat.c        |    6 +++---
 fs/binfmt_som.c         |    2 +-
 fs/exec.c               |   38 +++++++++++++++++++++-----------------
 include/linux/binfmts.h |   10 +++++++++-
 7 files changed, 77 insertions(+), 58 deletions(-)

diff -puN fs/binfmt_aout.c~binfmt-introduce-coredump-parameter-structure fs/binfmt_aout.c
--- a/fs/binfmt_aout.c~binfmt-introduce-coredump-parameter-structure
+++ a/fs/binfmt_aout.c
@@ -32,7 +32,7 @@
 
 static int load_aout_binary(struct linux_binprm *, struct pt_regs * regs);
 static int load_aout_library(struct file*);
-static int aout_core_dump(long signr, struct pt_regs *regs, struct file *file, unsigned long limit);
+static int aout_core_dump(struct coredump_params *cprm);
 
 static struct linux_binfmt aout_format = {
 	.module		= THIS_MODULE,
@@ -89,8 +89,9 @@ if (file->f_op->llseek) { \
  * dumping of the process results in another error..
  */
 
-static int aout_core_dump(long signr, struct pt_regs *regs, struct file *file, unsigned long limit)
+static int aout_core_dump(struct coredump_params *cprm)
 {
+	struct file *file = cprm->file;
 	mm_segment_t fs;
 	int has_dumped = 0;
 	unsigned long dump_start, dump_size;
@@ -108,16 +109,16 @@ static int aout_core_dump(long signr, st
 	current->flags |= PF_DUMPCORE;
        	strncpy(dump.u_comm, current->comm, sizeof(dump.u_comm));
 	dump.u_ar0 = offsetof(struct user, regs);
-	dump.signal = signr;
-	aout_dump_thread(regs, &dump);
+	dump.signal = cprm->signr;
+	aout_dump_thread(cprm->regs, &dump);
 
 /* If the size of the dump file exceeds the rlimit, then see what would happen
    if we wrote the stack, but not the data area.  */
-	if ((dump.u_dsize + dump.u_ssize+1) * PAGE_SIZE > limit)
+	if ((dump.u_dsize + dump.u_ssize+1) * PAGE_SIZE > cprm->limit)
 		dump.u_dsize = 0;
 
 /* Make sure we have enough room to write the stack and data areas. */
-	if ((dump.u_ssize + 1) * PAGE_SIZE > limit)
+	if ((dump.u_ssize + 1) * PAGE_SIZE > cprm->limit)
 		dump.u_ssize = 0;
 
 /* make sure we actually have a data and stack area to dump */
diff -puN fs/binfmt_elf.c~binfmt-introduce-coredump-parameter-structure fs/binfmt_elf.c
--- a/fs/binfmt_elf.c~binfmt-introduce-coredump-parameter-structure
+++ a/fs/binfmt_elf.c
@@ -45,7 +45,7 @@ static unsigned long elf_map(struct file
  * don't even try.
  */
 #if defined(USE_ELF_CORE_DUMP) && defined(CONFIG_ELF_CORE)
-static int elf_core_dump(long signr, struct pt_regs *regs, struct file *file, unsigned long limit);
+static int elf_core_dump(struct coredump_params *cprm);
 #else
 #define elf_core_dump	NULL
 #endif
@@ -1277,10 +1277,6 @@ static int writenote(struct memelfnote *
 }
 #undef DUMP_WRITE
 
-#define DUMP_WRITE(addr, nr)	\
-	if ((size += (nr)) > limit || !dump_write(file, (addr), (nr))) \
-		goto end_coredump;
-
 static void fill_elf_header(struct elfhdr *elf, int segs,
 			    u16 machine, u32 flags, u8 osabi)
 {
@@ -1906,7 +1902,7 @@ static struct vm_area_struct *next_vma(s
  * and then they are actually written out.  If we run out of core limit
  * we just truncate.
  */
-static int elf_core_dump(long signr, struct pt_regs *regs, struct file *file, unsigned long limit)
+static int elf_core_dump(struct coredump_params *cprm)
 {
 	int has_dumped = 0;
 	mm_segment_t fs;
@@ -1952,7 +1948,7 @@ static int elf_core_dump(long signr, str
 	 * notes.  This also sets up the file header.
 	 */
 	if (!fill_note_info(elf, segs + 1, /* including notes section */
-			    &info, signr, regs))
+			    &info, cprm->signr, cprm->regs))
 		goto cleanup;
 
 	has_dumped = 1;
@@ -1961,7 +1957,10 @@ static int elf_core_dump(long signr, str
 	fs = get_fs();
 	set_fs(KERNEL_DS);
 
-	DUMP_WRITE(elf, sizeof(*elf));
+	size += sizeof(*elf);
+	if (size > cprm->limit || !dump_write(cprm->file, elf, sizeof(*elf)))
+		goto end_coredump;
+
 	offset += sizeof(*elf);				/* Elf header */
 	offset += (segs + 1) * sizeof(struct elf_phdr); /* Program headers */
 	foffset = offset;
@@ -1975,7 +1974,10 @@ static int elf_core_dump(long signr, str
 
 		fill_elf_note_phdr(&phdr, sz, offset);
 		offset += sz;
-		DUMP_WRITE(&phdr, sizeof(phdr));
+		size += sizeof(phdr);
+		if (size > cprm->limit ||
+		    !dump_write(cprm->file, &phdr, sizeof(phdr)))
+			goto end_coredump;
 	}
 
 	dataoff = offset = roundup(offset, ELF_EXEC_PAGESIZE);
@@ -2006,7 +2008,10 @@ static int elf_core_dump(long signr, str
 			phdr.p_flags |= PF_X;
 		phdr.p_align = ELF_EXEC_PAGESIZE;
 
-		DUMP_WRITE(&phdr, sizeof(phdr));
+		size += sizeof(phdr);
+		if (size > cprm->limit ||
+		    !dump_write(cprm->file, &phdr, sizeof(phdr)))
+			goto end_coredump;
 	}
 
 #ifdef ELF_CORE_WRITE_EXTRA_PHDRS
@@ -2014,14 +2019,14 @@ static int elf_core_dump(long signr, str
 #endif
 
  	/* write out the notes section */
-	if (!write_note_info(&info, file, &foffset))
+	if (!write_note_info(&info, cprm->file, &foffset))
 		goto end_coredump;
 
-	if (elf_coredump_extra_notes_write(file, &foffset))
+	if (elf_coredump_extra_notes_write(cprm->file, &foffset))
 		goto end_coredump;
 
 	/* Align to page */
-	if (!dump_seek(file, dataoff - foffset))
+	if (!dump_seek(cprm->file, dataoff - foffset))
 		goto end_coredump;
 
 	for (vma = first_vma(current, gate_vma); vma != NULL;
@@ -2038,12 +2043,13 @@ static int elf_core_dump(long signr, str
 			page = get_dump_page(addr);
 			if (page) {
 				void *kaddr = kmap(page);
-				stop = ((size += PAGE_SIZE) > limit) ||
-					!dump_write(file, kaddr, PAGE_SIZE);
+				stop = ((size += PAGE_SIZE) > cprm->limit) ||
+					!dump_write(cprm->file, kaddr,
+						    PAGE_SIZE);
 				kunmap(page);
 				page_cache_release(page);
 			} else
-				stop = !dump_seek(file, PAGE_SIZE);
+				stop = !dump_seek(cprm->file, PAGE_SIZE);
 			if (stop)
 				goto end_coredump;
 		}
diff -puN fs/binfmt_elf_fdpic.c~binfmt-introduce-coredump-parameter-structure fs/binfmt_elf_fdpic.c
--- a/fs/binfmt_elf_fdpic.c~binfmt-introduce-coredump-parameter-structure
+++ a/fs/binfmt_elf_fdpic.c
@@ -76,7 +76,7 @@ static int elf_fdpic_map_file_by_direct_
 					     struct file *, struct mm_struct *);
 
 #if defined(USE_ELF_CORE_DUMP) && defined(CONFIG_ELF_CORE)
-static int elf_fdpic_core_dump(long, struct pt_regs *, struct file *, unsigned long limit);
+static int elf_fdpic_core_dump(struct coredump_params *cprm);
 #endif
 
 static struct linux_binfmt elf_fdpic_format = {
@@ -1582,8 +1582,7 @@ static int elf_fdpic_dump_segments(struc
  * and then they are actually written out.  If we run out of core limit
  * we just truncate.
  */
-static int elf_fdpic_core_dump(long signr, struct pt_regs *regs,
-			       struct file *file, unsigned long limit)
+static int elf_fdpic_core_dump(struct coredump_params *cprm)
 {
 #define	NUM_NOTES	6
 	int has_dumped = 0;
@@ -1642,7 +1641,7 @@ static int elf_fdpic_core_dump(long sign
 		goto cleanup;
 #endif
 
-	if (signr) {
+	if (cprm->signr) {
 		struct core_thread *ct;
 		struct elf_thread_status *tmp;
 
@@ -1661,14 +1660,14 @@ static int elf_fdpic_core_dump(long sign
 			int sz;
 
 			tmp = list_entry(t, struct elf_thread_status, list);
-			sz = elf_dump_thread_status(signr, tmp);
+			sz = elf_dump_thread_status(cprm->signr, tmp);
 			thread_status_size += sz;
 		}
 	}
 
 	/* now collect the dump for the current */
-	fill_prstatus(prstatus, current, signr);
-	elf_core_copy_regs(&prstatus->pr_reg, regs);
+	fill_prstatus(prstatus, current, cprm->signr);
+	elf_core_copy_regs(&prstatus->pr_reg, cprm->regs);
 
 	segs = current->mm->map_count;
 #ifdef ELF_CORE_EXTRA_PHDRS
@@ -1703,7 +1702,7 @@ static int elf_fdpic_core_dump(long sign
 
   	/* Try to dump the FPU. */
 	if ((prstatus->pr_fpvalid =
-	     elf_core_copy_task_fpregs(current, regs, fpu)))
+	     elf_core_copy_task_fpregs(current, cprm->regs, fpu)))
 		fill_note(notes + numnote++,
 			  "CORE", NT_PRFPREG, sizeof(*fpu), fpu);
 #ifdef ELF_CORE_COPY_XFPREGS
@@ -1774,7 +1773,7 @@ static int elf_fdpic_core_dump(long sign
 
  	/* write out the notes section */
 	for (i = 0; i < numnote; i++)
-		if (!writenote(notes + i, file))
+		if (!writenote(notes + i, cprm->file))
 			goto end_coredump;
 
 	/* write out the thread status notes section */
@@ -1783,25 +1782,26 @@ static int elf_fdpic_core_dump(long sign
 				list_entry(t, struct elf_thread_status, list);
 
 		for (i = 0; i < tmp->num_notes; i++)
-			if (!writenote(&tmp->notes[i], file))
+			if (!writenote(&tmp->notes[i], cprm->file))
 				goto end_coredump;
 	}
 
-	if (!dump_seek(file, dataoff))
+	if (!dump_seek(cprm->file, dataoff))
 		goto end_coredump;
 
-	if (elf_fdpic_dump_segments(file, &size, &limit, mm_flags) < 0)
+	if (elf_fdpic_dump_segments(cprm->file, &size, &cprm->limit,
+				    mm_flags) < 0)
 		goto end_coredump;
 
 #ifdef ELF_CORE_WRITE_EXTRA_DATA
 	ELF_CORE_WRITE_EXTRA_DATA;
 #endif
 
-	if (file->f_pos != offset) {
+	if (cprm->file->f_pos != offset) {
 		/* Sanity check */
 		printk(KERN_WARNING
 		       "elf_core_dump: file->f_pos (%lld) != offset (%lld)\n",
-		       file->f_pos, offset);
+		       cprm->file->f_pos, offset);
 	}
 
 end_coredump:
diff -puN fs/binfmt_flat.c~binfmt-introduce-coredump-parameter-structure fs/binfmt_flat.c
--- a/fs/binfmt_flat.c~binfmt-introduce-coredump-parameter-structure
+++ a/fs/binfmt_flat.c
@@ -87,7 +87,7 @@ static int load_flat_shared_library(int 
 #endif
 
 static int load_flat_binary(struct linux_binprm *, struct pt_regs * regs);
-static int flat_core_dump(long signr, struct pt_regs *regs, struct file *file, unsigned long limit);
+static int flat_core_dump(struct coredump_params *cprm);
 
 static struct linux_binfmt flat_format = {
 	.module		= THIS_MODULE,
@@ -102,10 +102,10 @@ static struct linux_binfmt flat_format =
  * Currently only a stub-function.
  */
 
-static int flat_core_dump(long signr, struct pt_regs *regs, struct file *file, unsigned long limit)
+static int flat_core_dump(struct coredump_params *cprm)
 {
 	printk("Process %s:%d received signr %d and should have core dumped\n",
-			current->comm, current->pid, (int) signr);
+			current->comm, current->pid, (int) cprm->signr);
 	return(1);
 }
 
diff -puN fs/binfmt_som.c~binfmt-introduce-coredump-parameter-structure fs/binfmt_som.c
--- a/fs/binfmt_som.c~binfmt-introduce-coredump-parameter-structure
+++ a/fs/binfmt_som.c
@@ -43,7 +43,7 @@ static int load_som_library(struct file 
  * don't even try.
  */
 #if 0
-static int som_core_dump(long signr, struct pt_regs *regs, unsigned long limit);
+static int som_core_dump(struct coredump_params *cprm);
 #else
 #define som_core_dump	NULL
 #endif
diff -puN fs/exec.c~binfmt-introduce-coredump-parameter-structure fs/exec.c
--- a/fs/exec.c~binfmt-introduce-coredump-parameter-structure
+++ a/fs/exec.c
@@ -1761,17 +1761,20 @@ void do_coredump(long signr, int exit_co
 	struct mm_struct *mm = current->mm;
 	struct linux_binfmt * binfmt;
 	struct inode * inode;
-	struct file * file;
 	const struct cred *old_cred;
 	struct cred *cred;
 	int retval = 0;
 	int flag = 0;
 	int ispipe = 0;
-	unsigned long core_limit = current->signal->rlim[RLIMIT_CORE].rlim_cur;
 	char **helper_argv = NULL;
 	int helper_argc = 0;
 	int dump_count = 0;
 	static atomic_t core_dump_count = ATOMIC_INIT(0);
+	struct coredump_params cprm = {
+		.signr = signr,
+		.regs = regs,
+		.limit = current->signal->rlim[RLIMIT_CORE].rlim_cur,
+	};
 
 	audit_core_dumps(signr);
 
@@ -1827,15 +1830,15 @@ void do_coredump(long signr, int exit_co
 	ispipe = format_corename(corename, signr);
 	unlock_kernel();
 
-	if ((!ispipe) && (core_limit < binfmt->min_coredump))
+	if ((!ispipe) && (cprm.limit < binfmt->min_coredump))
 		goto fail_unlock;
 
  	if (ispipe) {
-		if (core_limit == 0) {
+		if (cprm.limit == 0) {
 			/*
 			 * Normally core limits are irrelevant to pipes, since
 			 * we're not writing to the file system, but we use
-			 * core_limit of 0 here as a speacial value. Any
+			 * cprm.limit of 0 here as a speacial value. Any
 			 * non-zero limit gets set to RLIM_INFINITY below, but
 			 * a limit of 0 skips the dump.  This is a consistent
 			 * way to catch recursive crashes.  We can still crash
@@ -1868,25 +1871,25 @@ void do_coredump(long signr, int exit_co
 			goto fail_dropcount;
 		}
 
-		core_limit = RLIM_INFINITY;
+		cprm.limit = RLIM_INFINITY;
 
 		/* SIGPIPE can happen, but it's just never processed */
 		if (call_usermodehelper_pipe(helper_argv[0], helper_argv, NULL,
-				&file)) {
+				&cprm.file)) {
  			printk(KERN_INFO "Core dump to %s pipe failed\n",
 			       corename);
 			goto fail_dropcount;
  		}
  	} else
- 		file = filp_open(corename,
+		cprm.file = filp_open(corename,
 				 O_CREAT | 2 | O_NOFOLLOW | O_LARGEFILE | flag,
 				 0600);
-	if (IS_ERR(file))
+	if (IS_ERR(cprm.file))
 		goto fail_dropcount;
-	inode = file->f_path.dentry->d_inode;
+	inode = cprm.file->f_path.dentry->d_inode;
 	if (inode->i_nlink > 1)
 		goto close_fail;	/* multiple links - don't dump */
-	if (!ispipe && d_unhashed(file->f_path.dentry))
+	if (!ispipe && d_unhashed(cprm.file->f_path.dentry))
 		goto close_fail;
 
 	/* AK: actually i see no reason to not allow this for named pipes etc.,
@@ -1899,21 +1902,22 @@ void do_coredump(long signr, int exit_co
 	 */
 	if (inode->i_uid != current_fsuid())
 		goto close_fail;
-	if (!file->f_op)
+	if (!cprm.file->f_op)
 		goto close_fail;
-	if (!file->f_op->write)
+	if (!cprm.file->f_op->write)
 		goto close_fail;
-	if (!ispipe && do_truncate(file->f_path.dentry, 0, 0, file) != 0)
+	if (!ispipe &&
+	    do_truncate(cprm.file->f_path.dentry, 0, 0, cprm.file) != 0)
 		goto close_fail;
 
-	retval = binfmt->core_dump(signr, regs, file, core_limit);
+	retval = binfmt->core_dump(&cprm);
 
 	if (retval)
 		current->signal->group_exit_code |= 0x80;
 close_fail:
 	if (ispipe && core_pipe_limit)
-		wait_for_dump_helpers(file);
-	filp_close(file, NULL);
+		wait_for_dump_helpers(cprm.file);
+	filp_close(cprm.file, NULL);
 fail_dropcount:
 	if (dump_count)
 		atomic_dec(&core_dump_count);
diff -puN include/linux/binfmts.h~binfmt-introduce-coredump-parameter-structure include/linux/binfmts.h
--- a/include/linux/binfmts.h~binfmt-introduce-coredump-parameter-structure
+++ a/include/linux/binfmts.h
@@ -68,6 +68,14 @@ struct linux_binprm{
 
 #define BINPRM_MAX_RECURSION 4
 
+/* Function parameter for binfmt->coredump */
+struct coredump_params {
+	long signr;
+	struct pt_regs *regs;
+	struct file *file;
+	unsigned long limit;
+};
+
 /*
  * This structure defines the functions that are used to load the binary formats that
  * linux accepts.
@@ -77,7 +85,7 @@ struct linux_binfmt {
 	struct module *module;
 	int (*load_binary)(struct linux_binprm *, struct  pt_regs * regs);
 	int (*load_shlib)(struct file *);
-	int (*core_dump)(long signr, struct pt_regs *regs, struct file *file, unsigned long limit);
+	int (*core_dump)(struct coredump_params *cprm);
 	unsigned long min_coredump;	/* minimal dump size */
 	int hasvdso;
 };
_

Patches currently in -mm which might be from mhiramat@redhat.com are

linux-next.patch
binfmt-introduce-coredump-parameter-structure.patch
binfmt-pass-mm-flags-as-a-coredump-parameter-for-consistency.patch

