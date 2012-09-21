From: akpm@linux-foundation.org
Subject: [failures] coredump-pass-siginfo_t-to-do_coredump-and-below-not-merely-signr.patch removed from -mm tree
Date: Fri, 21 Sep 2012 12:24:26 -0700
Message-ID: <20120921192427.6EC19200059@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wg0-f74.google.com ([74.125.82.74]:53046 "EHLO
	mail-wg0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933138Ab2IUTYa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 21 Sep 2012 15:24:30 -0400
Received: by wgbdt11 with SMTP id dt11so200022wgb.1
        for <mm-commits@vger.kernel.org>; Fri, 21 Sep 2012 12:24:29 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vda.linux@googlemail.com, amwang@redhat.com, jmfoote@cert.org, oleg@redhat.com, palves@redhat.com, roland@hack.frob.com, mm-commits@vger.kernel.org


The patch titled
     Subject: coredump: pass siginfo_t* to do_coredump() and below, not merely signr
has been removed from the -mm tree.  Its filename was
     coredump-pass-siginfo_t-to-do_coredump-and-below-not-merely-signr.patch

This patch was dropped because it had testing failures

------------------------------------------------------
From: Denys Vlasenko <vda.linux@googlemail.com>
Subject: coredump: pass siginfo_t* to do_coredump() and below, not merely signr

This is a preparatory patch for the introduction of NT_SIGINFO elf note.

With this patch we pass "siginfo_t *siginfo" instead of "int signr" to
do_coredump() and put it into coredump_params.  It will be used by the
next patch.  Most changes are simple s/signr/siginfo->si_signo/.

Signed-off-by: Denys Vlasenko <vda.linux@googlemail.com>
Reviewed-by: Oleg Nesterov <oleg@redhat.com>
Cc: Amerigo Wang <amwang@redhat.com>
Cc: "Jonathan M. Foote" <jmfoote@cert.org>
Cc: Roland McGrath <roland@hack.frob.com>
Cc: Pedro Alves <palves@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/binfmt_aout.c         |    2 +-
 fs/binfmt_elf.c          |   14 +++++++-------
 fs/binfmt_elf_fdpic.c    |    6 +++---
 fs/binfmt_flat.c         |    2 +-
 fs/coredump.c            |   10 +++++-----
 include/linux/binfmts.h  |    2 +-
 include/linux/coredump.h |    4 ++--
 kernel/signal.c          |    2 +-
 8 files changed, 21 insertions(+), 21 deletions(-)

diff -puN fs/binfmt_aout.c~coredump-pass-siginfo_t-to-do_coredump-and-below-not-merely-signr fs/binfmt_aout.c
--- a/fs/binfmt_aout.c~coredump-pass-siginfo_t-to-do_coredump-and-below-not-merely-signr
+++ a/fs/binfmt_aout.c
@@ -65,7 +65,7 @@ static int aout_core_dump(struct coredum
 	current->flags |= PF_DUMPCORE;
        	strncpy(dump.u_comm, current->comm, sizeof(dump.u_comm));
 	dump.u_ar0 = offsetof(struct user, regs);
-	dump.signal = cprm->signr;
+	dump.signal = cprm->siginfo->si_signo;
 	aout_dump_thread(cprm->regs, &dump);
 
 /* If the size of the dump file exceeds the rlimit, then see what would happen
diff -puN fs/binfmt_elf.c~coredump-pass-siginfo_t-to-do_coredump-and-below-not-merely-signr fs/binfmt_elf.c
--- a/fs/binfmt_elf.c~coredump-pass-siginfo_t-to-do_coredump-and-below-not-merely-signr
+++ a/fs/binfmt_elf.c
@@ -1479,7 +1479,7 @@ static int fill_thread_core_info(struct 
 
 static int fill_note_info(struct elfhdr *elf, int phdrs,
 			  struct elf_note_info *info,
-			  long signr, struct pt_regs *regs)
+			  siginfo_t *siginfo, struct pt_regs *regs)
 {
 	struct task_struct *dump_task = current;
 	const struct user_regset_view *view = task_user_regset_view(dump_task);
@@ -1549,7 +1549,7 @@ static int fill_note_info(struct elfhdr 
 	 * Now fill in each thread's information.
 	 */
 	for (t = info->thread; t != NULL; t = t->next)
-		if (!fill_thread_core_info(t, view, signr, &info->size))
+		if (!fill_thread_core_info(t, view, siginfo->si_signo, &info->size))
 			return 0;
 
 	/*
@@ -1712,14 +1712,14 @@ static int elf_note_info_init(struct elf
 
 static int fill_note_info(struct elfhdr *elf, int phdrs,
 			  struct elf_note_info *info,
-			  long signr, struct pt_regs *regs)
+			  siginfo_t *siginfo, struct pt_regs *regs)
 {
 	struct list_head *t;
 
 	if (!elf_note_info_init(info))
 		return 0;
 
-	if (signr) {
+	if (siginfo->si_signo) {
 		struct core_thread *ct;
 		struct elf_thread_status *ets;
 
@@ -1737,13 +1737,13 @@ static int fill_note_info(struct elfhdr 
 			int sz;
 
 			ets = list_entry(t, struct elf_thread_status, list);
-			sz = elf_dump_thread_status(signr, ets);
+			sz = elf_dump_thread_status(siginfo->si_signo, ets);
 			info->thread_status_size += sz;
 		}
 	}
 	/* now collect the dump for the current */
 	memset(info->prstatus, 0, sizeof(*info->prstatus));
-	fill_prstatus(info->prstatus, current, signr);
+	fill_prstatus(info->prstatus, current, siginfo->si_signo);
 	elf_core_copy_regs(&info->prstatus->pr_reg, regs);
 
 	/* Set up header */
@@ -1950,7 +1950,7 @@ static int elf_core_dump(struct coredump
 	 * Collect all the non-memory information about the process for the
 	 * notes.  This also sets up the file header.
 	 */
-	if (!fill_note_info(elf, e_phnum, &info, cprm->signr, cprm->regs))
+	if (!fill_note_info(elf, e_phnum, &info, cprm->siginfo, cprm->regs))
 		goto cleanup;
 
 	has_dumped = 1;
diff -puN fs/binfmt_elf_fdpic.c~coredump-pass-siginfo_t-to-do_coredump-and-below-not-merely-signr fs/binfmt_elf_fdpic.c
--- a/fs/binfmt_elf_fdpic.c~coredump-pass-siginfo_t-to-do_coredump-and-below-not-merely-signr
+++ a/fs/binfmt_elf_fdpic.c
@@ -1641,7 +1641,7 @@ static int elf_fdpic_core_dump(struct co
 		goto cleanup;
 #endif
 
-	if (cprm->signr) {
+	if (cprm->siginfo->si_signo) {
 		struct core_thread *ct;
 		struct elf_thread_status *tmp;
 
@@ -1660,13 +1660,13 @@ static int elf_fdpic_core_dump(struct co
 			int sz;
 
 			tmp = list_entry(t, struct elf_thread_status, list);
-			sz = elf_dump_thread_status(cprm->signr, tmp);
+			sz = elf_dump_thread_status(cprm->siginfo->si_signo, tmp);
 			thread_status_size += sz;
 		}
 	}
 
 	/* now collect the dump for the current */
-	fill_prstatus(prstatus, current, cprm->signr);
+	fill_prstatus(prstatus, current, cprm->siginfo->si_signo);
 	elf_core_copy_regs(&prstatus->pr_reg, cprm->regs);
 
 	segs = current->mm->map_count;
diff -puN fs/binfmt_flat.c~coredump-pass-siginfo_t-to-do_coredump-and-below-not-merely-signr fs/binfmt_flat.c
--- a/fs/binfmt_flat.c~coredump-pass-siginfo_t-to-do_coredump-and-below-not-merely-signr
+++ a/fs/binfmt_flat.c
@@ -107,7 +107,7 @@ static struct linux_binfmt flat_format =
 static int flat_core_dump(struct coredump_params *cprm)
 {
 	printk("Process %s:%d received signr %d and should have core dumped\n",
-			current->comm, current->pid, (int) cprm->signr);
+			current->comm, current->pid, (int) cprm->siginfo->si_signo);
 	return(1);
 }
 
diff -puN fs/coredump.c~coredump-pass-siginfo_t-to-do_coredump-and-below-not-merely-signr fs/coredump.c
--- a/fs/coredump.c~coredump-pass-siginfo_t-to-do_coredump-and-below-not-merely-signr
+++ a/fs/coredump.c
@@ -200,7 +200,7 @@ static int format_corename(struct core_n
 				break;
 			/* signal that caused the coredump */
 			case 's':
-				err = cn_printf(cn, "%ld", cprm->signr);
+				err = cn_printf(cn, "%ld", cprm->siginfo->si_signo);
 				break;
 			/* UNIX time of coredump */
 			case 't': {
@@ -467,7 +467,7 @@ static int umh_pipe_setup(struct subproc
 	return 0;
 }
 
-void do_coredump(long signr, int exit_code, struct pt_regs *regs)
+void do_coredump(siginfo_t *siginfo, struct pt_regs *regs)
 {
 	struct core_state core_state;
 	struct core_name cn;
@@ -481,7 +481,7 @@ void do_coredump(long signr, int exit_co
 	bool need_nonrelative = false;
 	static atomic_t core_dump_count = ATOMIC_INIT(0);
 	struct coredump_params cprm = {
-		.signr = signr,
+		.siginfo = siginfo,
 		.regs = regs,
 		.limit = rlimit(RLIMIT_CORE),
 		/*
@@ -492,7 +492,7 @@ void do_coredump(long signr, int exit_co
 		.mm_flags = mm->flags,
 	};
 
-	audit_core_dumps(signr);
+	audit_core_dumps(siginfo->si_signo);
 
 	binfmt = mm->binfmt;
 	if (!binfmt || !binfmt->core_dump)
@@ -516,7 +516,7 @@ void do_coredump(long signr, int exit_co
 		need_nonrelative = true;
 	}
 
-	retval = coredump_wait(exit_code, &core_state);
+	retval = coredump_wait(siginfo->si_signo, &core_state);
 	if (retval < 0)
 		goto fail_creds;
 
diff -puN include/linux/binfmts.h~coredump-pass-siginfo_t-to-do_coredump-and-below-not-merely-signr include/linux/binfmts.h
--- a/include/linux/binfmts.h~coredump-pass-siginfo_t-to-do_coredump-and-below-not-merely-signr
+++ a/include/linux/binfmts.h
@@ -74,7 +74,7 @@ struct linux_binprm {
 
 /* Function parameter for binfmt->coredump */
 struct coredump_params {
-	long signr;
+	siginfo_t *siginfo;
 	struct pt_regs *regs;
 	struct file *file;
 	unsigned long limit;
diff -puN include/linux/coredump.h~coredump-pass-siginfo_t-to-do_coredump-and-below-not-merely-signr include/linux/coredump.h
--- a/include/linux/coredump.h~coredump-pass-siginfo_t-to-do_coredump-and-below-not-merely-signr
+++ a/include/linux/coredump.h
@@ -12,9 +12,9 @@
 extern int dump_write(struct file *file, const void *addr, int nr);
 extern int dump_seek(struct file *file, loff_t off);
 #ifdef CONFIG_COREDUMP
-extern void do_coredump(long signr, int exit_code, struct pt_regs *regs);
+extern void do_coredump(siginfo_t *siginfo, struct pt_regs *regs);
 #else
-static inline void do_coredump(long signr, int exit_code, struct pt_regs *regs) {}
+static inline void do_coredump(siginfo_t *siginfo, struct pt_regs *regs) {}
 #endif
 
 #endif /* _LINUX_COREDUMP_H */
diff -puN kernel/signal.c~coredump-pass-siginfo_t-to-do_coredump-and-below-not-merely-signr kernel/signal.c
--- a/kernel/signal.c~coredump-pass-siginfo_t-to-do_coredump-and-below-not-merely-signr
+++ a/kernel/signal.c
@@ -2360,7 +2360,7 @@ relock:
 			 * first and our do_group_exit call below will use
 			 * that value and ignore the one we pass it.
 			 */
-			do_coredump(info->si_signo, info->si_signo, regs);
+			do_coredump(info, regs);
 		}
 
 		/*
_

Patches currently in -mm which might be from vda.linux@googlemail.com are

lib-vsprintf-optimize-division-by-10-for-small-integers.patch
lib-vsprintf-optimize-division-by-10000.patch
lib-vsprintf-optimize-put_dec_trunc8.patch
lib-vsprintf-fix-broken-comments.patch
coredump-prevent-double-free-on-an-error-path-in-core-dumper.patch
coredump-add-support-for-%d=__get_dumpable-in-core-name.patch
coredump-add-a-new-elf-note-with-siginfo-of-the-signal.patch
coredump-extend-core-dump-note-section-to-contain-file-names-of-mapped-files.patch

