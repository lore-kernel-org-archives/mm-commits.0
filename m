From: akpm@linux-foundation.org
Subject: + replace-nt_prxfpreg-with-elf_core_xfpreg_type-define.patch added to -mm tree
Date: Mon, 15 Oct 2007 13:19:44 -0700
Message-ID: <200710152019.l9FKJj1M023188@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43473 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934856AbXJOUUi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Oct 2007 16:20:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: markn@au1.ibm.com, ak@suse.de, linux-arch@vger.kernel.org, mingo@elte.hu, paulus@samba.org, tglx@linutronix.de


The patch titled
     x86: replace NT_PRXFPREG with ELF_CORE_XFPREG_TYPE #define
has been added to the -mm tree.  Its filename is
     replace-nt_prxfpreg-with-elf_core_xfpreg_type-define.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

 arch/ia64/ia32/elfcore32.h |    1 +
 fs/binfmt_elf.c            |    8 ++++----
 fs/binfmt_elf_fdpic.c      |    8 ++++----
 3 files changed, 9 insertions(+), 8 deletions(-)

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
_

Patches currently in -mm which might be from markn@au1.ibm.com are

origin.patch
replace-nt_prxfpreg-with-elf_core_xfpreg_type-define.patch
powerpc-add-altivec-vmx-state-to-coredumps.patch
