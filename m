From: akpm@linux-foundation.org
Subject: - replace-nt_prxfpreg-with-elf_core_xfpreg_type-define.patch removed from -mm tree
Date: Wed, 17 Oct 2007 23:51:02 -0700
Message-ID: <200710180651.l9I6p23x030139@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58445 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759119AbXJRGwS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 02:52:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: markn@au1.ibm.com, ak@suse.de, linux-arch@vger.kernel.org, mingo@elte.hu, paulus@samba.org, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     x86: replace NT_PRXFPREG with ELF_CORE_XFPREG_TYPE #define
has been removed from the -mm tree.  Its filename was
     replace-nt_prxfpreg-with-elf_core_xfpreg_type-define.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: x86: replace NT_PRXFPREG with ELF_CORE_XFPREG_TYPE #define
From: Mark Nelson <markn@au1.ibm.com>

Replace NT_PRXFPREG with ELF_CORE_XFPREG_TYPE in the coredump code which
allows for more flexibility in the note type for the state of 'extended
floating point' implementations in coredumps.  New note types can now be
added with an appropriate #define.

This does #define ELF_CORE_XFPREG_TYPE to be NT_PRXFPREG in all
current users so there's are no change in behaviour.

This will let us use different note types on powerpc for the Altivec/VMX
state that some PowerPC cpus have (G4, PPC970, POWER6) and for the SPE
(signal processing extension) state that some embedded PowerPC cpus from
Freescale have.

Signed-off-by: Mark Nelson <markn@au1.ibm.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Andi Kleen <ak@suse.de>
Cc: <linux-arch@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/ia32/elfcore32.h  |    1 +
 arch/x86/ia32/ia32_binfmt.c |    1 +
 fs/binfmt_elf.c             |    8 ++++----
 fs/binfmt_elf_fdpic.c       |    8 ++++----
 include/asm-x86/elf_32.h    |    1 +
 5 files changed, 11 insertions(+), 8 deletions(-)

diff -puN arch/ia64/ia32/elfcore32.h~replace-nt_prxfpreg-with-elf_core_xfpreg_type-define arch/ia64/ia32/elfcore32.h
--- a/arch/ia64/ia32/elfcore32.h~replace-nt_prxfpreg-with-elf_core_xfpreg_type-define
+++ a/arch/ia64/ia32/elfcore32.h
@@ -117,6 +117,7 @@ elf_core_copy_task_fpregs(struct task_st
 }
 
 #define ELF_CORE_COPY_XFPREGS 1
+#define ELF_CORE_XFPREG_TYPE NT_PRXFPREG
 static inline int
 elf_core_copy_task_xfpregs(struct task_struct *tsk, elf_fpxregset_t *xfpu)
 {
diff -puN arch/x86/ia32/ia32_binfmt.c~replace-nt_prxfpreg-with-elf_core_xfpreg_type-define arch/x86/ia32/ia32_binfmt.c
--- a/arch/x86/ia32/ia32_binfmt.c~replace-nt_prxfpreg-with-elf_core_xfpreg_type-define
+++ a/arch/x86/ia32/ia32_binfmt.c
@@ -188,6 +188,7 @@ elf_core_copy_task_fpregs(struct task_st
 }
 
 #define ELF_CORE_COPY_XFPREGS 1
+#define ELF_CORE_XFPREG_TYPE NT_PRXFPREG
 static inline int 
 elf_core_copy_task_xfpregs(struct task_struct *t, elf_fpxregset_t *xfpu)
 {
diff -puN fs/binfmt_elf.c~replace-nt_prxfpreg-with-elf_core_xfpreg_type-define fs/binfmt_elf.c
--- a/fs/binfmt_elf.c~replace-nt_prxfpreg-with-elf_core_xfpreg_type-define
+++ a/fs/binfmt_elf.c
@@ -1411,7 +1411,7 @@ struct elf_thread_status
 	elf_fpregset_t fpu;		/* NT_PRFPREG */
 	struct task_struct *thread;
 #ifdef ELF_CORE_COPY_XFPREGS
-	elf_fpxregset_t xfpu;		/* NT_PRXFPREG */
+	elf_fpxregset_t xfpu;		/* ELF_CORE_XFPREG_TYPE */
 #endif
 	struct memelfnote notes[3];
 	int num_notes;
@@ -1446,8 +1446,8 @@ static int elf_dump_thread_status(long s
 
 #ifdef ELF_CORE_COPY_XFPREGS
 	if (elf_core_copy_task_xfpregs(p, &t->xfpu)) {
-		fill_note(&t->notes[2], "LINUX", NT_PRXFPREG, sizeof(t->xfpu),
-			  &t->xfpu);
+		fill_note(&t->notes[2], "LINUX", ELF_CORE_XFPREG_TYPE,
+			  sizeof(t->xfpu), &t->xfpu);
 		t->num_notes++;
 		sz += notesize(&t->notes[2]);
 	}
@@ -1621,7 +1621,7 @@ static int elf_core_dump(long signr, str
 #ifdef ELF_CORE_COPY_XFPREGS
 	if (elf_core_copy_task_xfpregs(current, xfpu))
 		fill_note(notes + numnote++,
-			  "LINUX", NT_PRXFPREG, sizeof(*xfpu), xfpu);
+			  "LINUX", ELF_CORE_XFPREG_TYPE, sizeof(*xfpu), xfpu);
 #endif	
   
 	fs = get_fs();
diff -puN fs/binfmt_elf_fdpic.c~replace-nt_prxfpreg-with-elf_core_xfpreg_type-define fs/binfmt_elf_fdpic.c
--- a/fs/binfmt_elf_fdpic.c~replace-nt_prxfpreg-with-elf_core_xfpreg_type-define
+++ a/fs/binfmt_elf_fdpic.c
@@ -1417,7 +1417,7 @@ struct elf_thread_status
 	elf_fpregset_t fpu;		/* NT_PRFPREG */
 	struct task_struct *thread;
 #ifdef ELF_CORE_COPY_XFPREGS
-	elf_fpxregset_t xfpu;		/* NT_PRXFPREG */
+	elf_fpxregset_t xfpu;		/* ELF_CORE_XFPREG_TYPE */
 #endif
 	struct memelfnote notes[3];
 	int num_notes;
@@ -1453,8 +1453,8 @@ static int elf_dump_thread_status(long s
 
 #ifdef ELF_CORE_COPY_XFPREGS
 	if (elf_core_copy_task_xfpregs(p, &t->xfpu)) {
-		fill_note(&t->notes[2], "LINUX", NT_PRXFPREG, sizeof(t->xfpu),
-			  &t->xfpu);
+		fill_note(&t->notes[2], "LINUX", ELF_CORE_XFPREG_TYPE,
+			  sizeof(t->xfpu), &t->xfpu);
 		t->num_notes++;
 		sz += notesize(&t->notes[2]);
 	}
@@ -1690,7 +1690,7 @@ static int elf_fdpic_core_dump(long sign
 #ifdef ELF_CORE_COPY_XFPREGS
 	if (elf_core_copy_task_xfpregs(current, xfpu))
 		fill_note(notes + numnote++,
-			  "LINUX", NT_PRXFPREG, sizeof(*xfpu), xfpu);
+			  "LINUX", ELF_CORE_XFPREG_TYPE, sizeof(*xfpu), xfpu);
 #endif
 
 	fs = get_fs();
diff -puN include/asm-x86/elf_32.h~replace-nt_prxfpreg-with-elf_core_xfpreg_type-define include/asm-x86/elf_32.h
--- a/include/asm-x86/elf_32.h~replace-nt_prxfpreg-with-elf_core_xfpreg_type-define
+++ a/include/asm-x86/elf_32.h
@@ -129,6 +129,7 @@ extern int dump_task_extended_fpu (struc
 #define ELF_CORE_COPY_TASK_REGS(tsk, elf_regs) dump_task_regs(tsk, elf_regs)
 #define ELF_CORE_COPY_FPREGS(tsk, elf_fpregs) dump_task_fpu(tsk, elf_fpregs)
 #define ELF_CORE_COPY_XFPREGS(tsk, elf_xfpregs) dump_task_extended_fpu(tsk, elf_xfpregs)
+#define ELF_CORE_XFPREG_TYPE NT_PRXFPREG
 
 #define VDSO_HIGH_BASE		(__fix_to_virt(FIX_VDSO))
 #define VDSO_CURRENT_BASE	((unsigned long)current->mm->context.vdso)
_

Patches currently in -mm which might be from markn@au1.ibm.com are

origin.patch
