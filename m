From: akpm@linux-foundation.org
Subject: + powerpc-use-linux-elfcore-compath.patch added to -mm tree
Date: Tue, 07 Aug 2007 13:29:02 -0700
Message-ID: <200708072029.l77KT29V002447@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34431 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934588AbXHGU3u (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 Aug 2007 16:29:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: roland@redhat.com, ak@suse.de, benh@kernel.crashing.org, paulus@samba.org, tony.luck@intel.com


The patch titled
     powerpc: Use linux/elfcore-compat.h
has been added to the -mm tree.  Its filename is
     powerpc-use-linux-elfcore-compath.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: powerpc: Use linux/elfcore-compat.h
From: Roland McGrath <roland@redhat.com>

This makes powerpc64's compat code use the new linux/elfcore-compat.h,
reducing some hand-copied duplication.

Signed-off-by: Roland McGrath <roland@redhat.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Andi Kleen <ak@suse.de>
Cc: "Luck, Tony" <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/kernel/binfmt_elf32.c |   67 ++++++++++++---------------
 include/asm-powerpc/elf.h          |   38 ++++++++-------
 2 files changed, 51 insertions(+), 54 deletions(-)

diff -puN arch/powerpc/kernel/binfmt_elf32.c~powerpc-use-linux-elfcore-compath arch/powerpc/kernel/binfmt_elf32.c
--- a/arch/powerpc/kernel/binfmt_elf32.c~powerpc-use-linux-elfcore-compath
+++ a/arch/powerpc/kernel/binfmt_elf32.c
@@ -13,49 +13,44 @@
  * 2 of the License, or (at your option) any later version.
  */
 
-#define ELF_ARCH		EM_PPC
-#define ELF_CLASS		ELFCLASS32
-#define ELF_DATA		ELFDATA2MSB;
-
 #include <asm/processor.h>
 #include <linux/module.h>
-#include <linux/elfcore.h>
 #include <linux/compat.h>
+#include <linux/elfcore-compat.h>
 
-#define elf_prstatus elf_prstatus32
-struct elf_prstatus32
+#undef	ELF_ARCH
+#undef	ELF_CLASS
+#define ELF_CLASS	ELFCLASS32
+#define ELF_ARCH	EM_PPC
+
+#undef	elfhdr
+#undef	elf_phdr
+#undef	elf_note
+#undef	elf_addr_t
+#define elfhdr		elf32_hdr
+#define elf_phdr	elf32_phdr
+#define elf_note	elf32_note
+#define elf_addr_t	Elf32_Off
+
+#define elf_prstatus	compat_elf_prstatus
+#define elf_prpsinfo	compat_elf_prpsinfo
+
+#define elf_core_copy_regs compat_elf_core_copy_regs
+static inline void compat_elf_core_copy_regs(compat_elf_gregset_t *elf_regs,
+					     struct pt_regs *regs)
 {
-	struct elf_siginfo pr_info;	/* Info associated with signal */
-	short	pr_cursig;		/* Current signal */
-	unsigned int pr_sigpend;	/* Set of pending signals */
-	unsigned int pr_sighold;	/* Set of held signals */
-	pid_t	pr_pid;
-	pid_t	pr_ppid;
-	pid_t	pr_pgrp;
-	pid_t	pr_sid;
-	struct compat_timeval pr_utime;	/* User time */
-	struct compat_timeval pr_stime;	/* System time */
-	struct compat_timeval pr_cutime;	/* Cumulative user time */
-	struct compat_timeval pr_cstime;	/* Cumulative system time */
-	elf_gregset_t pr_reg;		/* General purpose registers. */
-	int pr_fpvalid;		/* True if math co-processor being used. */
-};
+	PPC_ELF_CORE_COPY_REGS((*elf_regs), regs);
+}
 
-#define elf_prpsinfo elf_prpsinfo32
-struct elf_prpsinfo32
+#define elf_core_copy_task_regs compat_elf_core_copy_task_regs
+static int compat_elf_core_copy_task_regs(struct task_struct *tsk,
+					  compat_elf_gregset_t *elf_regs)
 {
-	char	pr_state;	/* numeric process state */
-	char	pr_sname;	/* char for pr_state */
-	char	pr_zomb;	/* zombie */
-	char	pr_nice;	/* nice val */
-	unsigned int pr_flag;	/* flags */
-	u32	pr_uid;
-	u32	pr_gid;
-	pid_t	pr_pid, pr_ppid, pr_pgrp, pr_sid;
-	/* Lots missing */
-	char	pr_fname[16];	/* filename of executable */
-	char	pr_psargs[ELF_PRARGSZ];	/* initial part of arg list */
-};
+	struct pt_regs *regs = tsk->thread.regs;
+	if (regs)
+		compat_elf_core_copy_regs(elf_regs, regs);
+	return 1;
+}
 
 #include <linux/time.h>
 
diff -puN include/asm-powerpc/elf.h~powerpc-use-linux-elfcore-compath include/asm-powerpc/elf.h
--- a/include/asm-powerpc/elf.h~powerpc-use-linux-elfcore-compath
+++ a/include/asm-powerpc/elf.h
@@ -101,6 +101,7 @@ typedef elf_greg_t64 elf_gregset_t64[ELF
 
 typedef unsigned int elf_greg_t32;
 typedef elf_greg_t32 elf_gregset_t32[ELF_NGREG];
+typedef elf_gregset_t32 compat_elf_gregset_t;
 
 /*
  * ELF_ARCH, CLASS, and DATA are used to set parameters in the core dumps.
@@ -175,26 +176,27 @@ typedef elf_vrreg_t elf_vrregset_t32[ELF
 
 #define ELF_ET_DYN_BASE         (0x20000000)
 
-/* Common routine for both 32-bit and 64-bit processes */
+/*
+ * Our registers are always unsigned longs, whether we're a 32 bit
+ * process or 64 bit, on either a 64 bit or 32 bit kernel.
+ *
+ * This macro relies on elf_regs[i] having the right type to truncate to,
+ * either u32 or u64.  It defines the body of the elf_core_copy_regs
+ * function, either the native one with elf_gregset_t elf_regs or
+ * the 32-bit one with elf_gregset_t32 elf_regs.
+ */
+#define PPC_ELF_CORE_COPY_REGS(elf_regs, regs) \
+	int i, nregs = min(sizeof(*regs) / sizeof(unsigned long), \
+			   (size_t)ELF_NGREG);			  \
+	for (i = 0; i < nregs; i++) \
+		elf_regs[i] = ((unsigned long *) regs)[i]; \
+	memset(&elf_regs[i], 0, (ELF_NGREG - i) * sizeof(elf_regs[0]))
+
+/* Common routine for both 32-bit and 64-bit native processes */
 static inline void ppc_elf_core_copy_regs(elf_gregset_t elf_regs,
-					    struct pt_regs *regs)
+					  struct pt_regs *regs)
 {
-	int i, nregs;
-
-	memset((void *)elf_regs, 0, sizeof(elf_gregset_t));
-
-	/* Our registers are always unsigned longs, whether we're a 32 bit
-	 * process or 64 bit, on either a 64 bit or 32 bit kernel.
-	 * Don't use ELF_GREG_TYPE here. */
-	nregs = sizeof(struct pt_regs) / sizeof(unsigned long);
-	if (nregs > ELF_NGREG)
-		nregs = ELF_NGREG;
-
-	for (i = 0; i < nregs; i++) {
-		/* This will correctly truncate 64 bit registers to 32 bits
-		 * for a 32 bit process on a 64 bit kernel. */
-		elf_regs[i] = (elf_greg_t)((ELF_GREG_TYPE *)regs)[i];
-	}
+	PPC_ELF_CORE_COPY_REGS(elf_regs, regs);
 }
 #define ELF_CORE_COPY_REGS(gregs, regs) ppc_elf_core_copy_regs(gregs, regs);
 
_

Patches currently in -mm which might be from roland@redhat.com are

powerpc-vdso-install-unstripped-copies-on-disk.patch
pass-g-to-assembler-under-config_debug_info.patch
i386-vdso-install-unstripped-copies-on-disk.patch
i386-vdso-install-unstripped-copies-on-disk-fix.patch
x86_64-ia32-vdso-install-unstripped-copies-on-disk.patch
clone-flag-clone_parent_tidptr-leaves-invalid-results-in-memory.patch
add-sys-module-name-notes.patch
do_sigaction-remove-now-unneeded-recalc_sigpending.patch
handle-the-multi-threaded-inits-exit-properly.patch
add-linux-elfcore-compath.patch
x86_64-use-linux-elfcore-compath.patch
powerpc-use-linux-elfcore-compath.patch
