From: akpm@linux-foundation.org
Subject: [merged] coredump-add-a-new-elf-note-with-siginfo-of-the-signal.patch removed from -mm tree
Date: Fri, 05 Oct 2012 13:19:43 -0700
Message-ID: <20121005201944.4C68D20004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wg0-f74.google.com ([74.125.82.74]:53809 "EHLO
	mail-wg0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757185Ab2JEUTr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Oct 2012 16:19:47 -0400
Received: by mail-wg0-f74.google.com with SMTP id dt11so139945wgb.1
        for <mm-commits@vger.kernel.org>; Fri, 05 Oct 2012 13:19:46 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vda.linux@googlemail.com, amwang@redhat.com, fengguang.wu@intel.com, jmfoote@cert.org, oleg@redhat.com, palves@redhat.com, roland@hack.frob.com, sfr@canb.auug.org.au, mm-commits@vger.kernel.org


The patch titled
     Subject: coredump: add a new elf note with siginfo of the signal
has been removed from the -mm tree.  Its filename was
     coredump-add-a-new-elf-note-with-siginfo-of-the-signal.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
Reviewed-by: Oleg Nesterov <oleg@redhat.com>
Cc: Amerigo Wang <amwang@redhat.com>
Cc: "Jonathan M. Foote" <jmfoote@cert.org>
Cc: Roland McGrath <roland@hack.frob.com>
Cc: Pedro Alves <palves@redhat.com>
Cc: Fengguang Wu <fengguang.wu@intel.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/binfmt_elf.c        |   27 +++++++++++++++++++++++++--
 fs/compat_binfmt_elf.c |    6 ++++++
 include/linux/elf.h    |    5 +++++
 3 files changed, 36 insertions(+), 2 deletions(-)

diff -puN fs/binfmt_elf.c~coredump-add-a-new-elf-note-with-siginfo-of-the-signal fs/binfmt_elf.c
--- a/fs/binfmt_elf.c~coredump-add-a-new-elf-note-with-siginfo-of-the-signal
+++ a/fs/binfmt_elf.c
@@ -37,6 +37,10 @@
 #include <asm/page.h>
 #include <asm/exec.h>
 
+#ifndef user_siginfo_t
+#define user_siginfo_t siginfo_t
+#endif
+
 static int load_elf_binary(struct linux_binprm *bprm, struct pt_regs *regs);
 static int load_elf_library(struct file *);
 static unsigned long elf_map(struct file *, unsigned long, struct elf_phdr *,
@@ -1372,6 +1376,16 @@ static void fill_auxv_note(struct memelf
 	fill_note(note, "CORE", NT_AUXV, i * sizeof(elf_addr_t), auxv);
 }
 
+static void fill_siginfo_note(struct memelfnote *note, user_siginfo_t *csigdata,
+		siginfo_t *siginfo)
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
 
@@ -1385,7 +1399,9 @@ struct elf_thread_core_info {
 struct elf_note_info {
 	struct elf_thread_core_info *thread;
 	struct memelfnote psinfo;
+	struct memelfnote signote;
 	struct memelfnote auxv;
+	user_siginfo_t csigdata;
 	size_t size;
 	int thread_notes;
 };
@@ -1559,6 +1575,9 @@ static int fill_note_info(struct elfhdr 
 	fill_psinfo(psinfo, dump_task->group_leader, dump_task->mm);
 	info->size += notesize(&info->psinfo);
 
+	fill_siginfo_note(&info->signote, &info->csigdata, siginfo);
+	info->size += notesize(&info->signote);
+
 	fill_auxv_note(&info->auxv, current->mm);
 	info->size += notesize(&info->auxv);
 
@@ -1588,6 +1607,8 @@ static int write_note_info(struct elf_no
 
 		if (first && !writenote(&info->psinfo, file, foffset))
 			return 0;
+		if (first && !writenote(&info->signote, file, foffset))
+			return 0;
 		if (first && !writenote(&info->auxv, file, foffset))
 			return 0;
 
@@ -1681,6 +1702,7 @@ struct elf_note_info {
 #ifdef ELF_CORE_COPY_XFPREGS
 	elf_fpxregset_t *xfpu;
 #endif
+	user_siginfo_t csigdata;
 	int thread_status_size;
 	int numnote;
 };
@@ -1690,8 +1712,8 @@ static int elf_note_info_init(struct elf
 	memset(info, 0, sizeof(*info));
 	INIT_LIST_HEAD(&info->thread_list);
 
-	/* Allocate space for six ELF notes */
-	info->notes = kmalloc(6 * sizeof(struct memelfnote), GFP_KERNEL);
+	/* Allocate space for ELF notes */
+	info->notes = kmalloc(7 * sizeof(struct memelfnote), GFP_KERNEL);
 	if (!info->notes)
 		return 0;
 	info->psinfo = kmalloc(sizeof(*info->psinfo), GFP_KERNEL);
@@ -1763,6 +1785,7 @@ static int fill_note_info(struct elfhdr 
 
 	info->numnote = 2;
 
+	fill_siginfo_note(&info->notes[info->numnote++], &info->csigdata, siginfo);
 	fill_auxv_note(&info->notes[info->numnote++], current->mm);
 
 	/* Try to dump the FPU. */
diff -puN fs/compat_binfmt_elf.c~coredump-add-a-new-elf-note-with-siginfo-of-the-signal fs/compat_binfmt_elf.c
--- a/fs/compat_binfmt_elf.c~coredump-add-a-new-elf-note-with-siginfo-of-the-signal
+++ a/fs/compat_binfmt_elf.c
@@ -38,6 +38,12 @@
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

origin.patch

