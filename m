From: akpm@linux-foundation.org
Subject: [failures] coredump-add-a-new-elf-note-with-siginfo-of-the-signal.patch removed from -mm tree
Date: Fri, 21 Sep 2012 12:24:31 -0700
Message-ID: <20120921192432.3EC3920004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-bk0-f74.google.com ([209.85.214.74]:32839 "EHLO
	mail-bk0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933111Ab2IUTYf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 21 Sep 2012 15:24:35 -0400
Received: by bkcjc3 with SMTP id jc3so238428bkc.1
        for <mm-commits@vger.kernel.org>; Fri, 21 Sep 2012 12:24:34 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vda.linux@googlemail.com, amwang@redhat.com, jmfoote@cert.org, oleg@redhat.com, palves@redhat.com, roland@hack.frob.com, mm-commits@vger.kernel.org


The patch titled
     Subject: coredump: add a new elf note with siginfo of the signal
has been removed from the -mm tree.  Its filename was
     coredump-add-a-new-elf-note-with-siginfo-of-the-signal.patch

This patch was dropped because it had testing failures

------------------------------------------------------
From: Denys Vlasenko <vda.linux@googlemail.com>
Subject: coredump: add a new elf note with siginfo of the signal

Existing PRSTATUS note contains only si_signo, si_code, si_errno fields
from the siginfo of the signal which caused core to be dumped.

There are tools which try to analyze crashes for possible security
implications, and they want to use, among other data, si_addr field from
the SIGSEGV.

This patch adds a new elf note, NT_SIGINFO, which contains the complete
siginfo_t of the signal which killed the process.

Signed-off-by: Denys Vlasenko <vda.linux@googlemail.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Amerigo Wang <amwang@redhat.com>
Cc: "Jonathan M. Foote" <jmfoote@cert.org>
Cc: Roland McGrath <roland@hack.frob.com>
Cc: Pedro Alves <palves@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/binfmt_elf.c        |   26 ++++++++++++++++++++++++--
 fs/compat_binfmt_elf.c |    7 +++++++
 include/linux/elf.h    |    5 +++++
 3 files changed, 36 insertions(+), 2 deletions(-)

diff -puN fs/binfmt_elf.c~coredump-add-a-new-elf-note-with-siginfo-of-the-signal fs/binfmt_elf.c
--- a/fs/binfmt_elf.c~coredump-add-a-new-elf-note-with-siginfo-of-the-signal
+++ a/fs/binfmt_elf.c
@@ -36,6 +36,10 @@
 #include <asm/param.h>
 #include <asm/page.h>
 
+#ifndef user_siginfo_t
+#define user_siginfo_t siginfo_t
+#endif
+
 static int load_elf_binary(struct linux_binprm *bprm, struct pt_regs *regs);
 static int load_elf_library(struct file *);
 static unsigned long elf_map(struct file *, unsigned long, struct elf_phdr *,
@@ -1371,6 +1375,15 @@ static void fill_auxv_note(struct memelf
 	fill_note(note, "CORE", NT_AUXV, i * sizeof(elf_addr_t), auxv);
 }
 
+static void fill_siginfo_note(struct memelfnote *note, user_siginfo_t *csigdata, siginfo_t *siginfo)
+{
+	mm_segment_t old_fs = get_fs();
+	set_fs(KERNEL_DS);
+	copy_siginfo_to_user((user_siginfo_t __user *) csigdata, siginfo);
+	set_fs(old_fs);
+	fill_note(note, "CORE", NT_SIGINFO, sizeof(*csigdata), csigdata);
+}
+
 #ifdef CORE_DUMP_USE_REGSET
 #include <linux/regset.h>
 
@@ -1384,7 +1397,9 @@ struct elf_thread_core_info {
 struct elf_note_info {
 	struct elf_thread_core_info *thread;
 	struct memelfnote psinfo;
+	struct memelfnote signote;
 	struct memelfnote auxv;
+	user_siginfo_t csigdata;
 	size_t size;
 	int thread_notes;
 };
@@ -1558,6 +1573,9 @@ static int fill_note_info(struct elfhdr 
 	fill_psinfo(psinfo, dump_task->group_leader, dump_task->mm);
 	info->size += notesize(&info->psinfo);
 
+	fill_siginfo_note(&info->signote, &info->csigdata, siginfo);
+	info->size += notesize(&info->signote);
+
 	fill_auxv_note(&info->auxv, current->mm);
 	info->size += notesize(&info->auxv);
 
@@ -1587,6 +1605,8 @@ static int write_note_info(struct elf_no
 
 		if (first && !writenote(&info->psinfo, file, foffset))
 			return 0;
+		if (first && !writenote(&info->signote, file, foffset))
+			return 0;
 		if (first && !writenote(&info->auxv, file, foffset))
 			return 0;
 
@@ -1680,6 +1700,7 @@ struct elf_note_info {
 #ifdef ELF_CORE_COPY_XFPREGS
 	elf_fpxregset_t *xfpu;
 #endif
+	user_siginfo_t csigdata;
 	int thread_status_size;
 	int numnote;
 };
@@ -1689,8 +1710,8 @@ static int elf_note_info_init(struct elf
 	memset(info, 0, sizeof(*info));
 	INIT_LIST_HEAD(&info->thread_list);
 
-	/* Allocate space for six ELF notes */
-	info->notes = kmalloc(6 * sizeof(struct memelfnote), GFP_KERNEL);
+	/* Allocate space for ELF notes */
+	info->notes = kmalloc(7 * sizeof(struct memelfnote), GFP_KERNEL);
 	if (!info->notes)
 		return 0;
 	info->psinfo = kmalloc(sizeof(*info->psinfo), GFP_KERNEL);
@@ -1762,6 +1783,7 @@ static int fill_note_info(struct elfhdr 
 
 	info->numnote = 2;
 
+	fill_siginfo_note(&info->notes[info->numnote++], &info->csigdata, siginfo);
 	fill_auxv_note(&info->notes[info->numnote++], current->mm);
 
 	/* Try to dump the FPU. */
diff -puN fs/compat_binfmt_elf.c~coredump-add-a-new-elf-note-with-siginfo-of-the-signal fs/compat_binfmt_elf.c
--- a/fs/compat_binfmt_elf.c~coredump-add-a-new-elf-note-with-siginfo-of-the-signal
+++ a/fs/compat_binfmt_elf.c
@@ -19,6 +19,7 @@
 
 #include <linux/elfcore-compat.h>
 #include <linux/time.h>
+#include <asm/sigframe.h> /* for compat_siginfo_t */
 
 /*
  * Rename the basic ELF layout types to refer to the 32-bit class of files.
@@ -38,6 +39,12 @@
 #define elf_addr_t	Elf32_Addr
 
 /*
+ * Some data types as stored in coredump.
+ */
+#define user_siginfo_t		compat_siginfo_t
+#define copy_siginfo_to_user	copy_siginfo_to_user32
+
+/*
  * The machine-dependent core note format types are defined in elfcore-compat.h,
  * which requires asm/elf.h to define compat_elf_gregset_t et al.
  */
diff -puN include/linux/elf.h~coredump-add-a-new-elf-note-with-siginfo-of-the-signal include/linux/elf.h
--- a/include/linux/elf.h~coredump-add-a-new-elf-note-with-siginfo-of-the-signal
+++ a/include/linux/elf.h
@@ -372,6 +372,11 @@ typedef struct elf64_shdr {
 #define NT_PRPSINFO	3
 #define NT_TASKSTRUCT	4
 #define NT_AUXV		6
+/*
+ * Note to userspace developers: size of NT_SIGINFO note may increase
+ * in the future to accomodate more fields, don't assume it is fixed!
+ */
+#define NT_SIGINFO      0x53494749
 #define NT_PRXFPREG     0x46e62b7f      /* copied from gdb5.1/include/elf/common.h */
 #define NT_PPC_VMX	0x100		/* PowerPC Altivec/VMX registers */
 #define NT_PPC_SPE	0x101		/* PowerPC SPE/EVR registers */
_

Patches currently in -mm which might be from vda.linux@googlemail.com are

lib-vsprintf-optimize-division-by-10-for-small-integers.patch
lib-vsprintf-optimize-division-by-10000.patch
lib-vsprintf-optimize-put_dec_trunc8.patch
lib-vsprintf-fix-broken-comments.patch
coredump-prevent-double-free-on-an-error-path-in-core-dumper.patch
coredump-add-support-for-%d=__get_dumpable-in-core-name.patch
coredump-extend-core-dump-note-section-to-contain-file-names-of-mapped-files.patch

