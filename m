From: akpm@linux-foundation.org
Subject: + powerpc-fadump-remove-dependency-with-config_kexec.patch added
 to -mm tree
Date: Tue, 28 Mar 2017 16:21:31 -0700
Message-ID: <58daeffb.KJPcKZFoC+Ou9pfD%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51674 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753829AbdC1XVe (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 28 Mar 2017 19:21:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hbathini@linux.vnet.ibm.com, dyoung@redhat.com, ebiederm@xmission.com, fenghua.yu@intel.com, mahesh@linux.vnet.ibm.com, mpe@ellerman.id.au, tony.luck@intel.com, vgoyal@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: powerpc/fadump: remove dependency with CONFIG_KEXEC
has been added to the -mm tree.  Its filename is
     powerpc-fadump-remove-dependency-with-config_kexec.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/powerpc-fadump-remove-dependency-with-config_kexec.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/powerpc-fadump-remove-dependency-with-config_kexec.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Hari Bathini <hbathini@linux.vnet.ibm.com>
Subject: powerpc/fadump: remove dependency with CONFIG_KEXEC

Now that crashkernel parameter parsing and vmcoreinfo related code is
moved under CONFIG_CRASH_CORE instead of CONFIG_KEXEC_CORE, remove
dependency with CONFIG_KEXEC for CONFIG_FA_DUMP.  While here, get rid of
definitions of fadump_append_elf_note() & fadump_final_note() functions to
reuse similar functions compiled under CONFIG_CRASH_CORE.

Link: http://lkml.kernel.org/r/149035343956.6881.1536459326017709354.stgit@hbathini.in.ibm.com
Signed-off-by: Hari Bathini <hbathini@linux.vnet.ibm.com>
Reviewed-by: Mahesh Salgaonkar <mahesh@linux.vnet.ibm.com>
Acked-by: Michael Ellerman <mpe@ellerman.id.au>
Cc: Fenghua Yu <fenghua.yu@intel.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Dave Young <dyoung@redhat.com>
Cc: Eric Biederman <ebiederm@xmission.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/Kconfig               |   10 ++++---
 arch/powerpc/include/asm/fadump.h  |    2 +
 arch/powerpc/kernel/crash.c        |    2 -
 arch/powerpc/kernel/fadump.c       |   34 ++-------------------------
 arch/powerpc/kernel/setup-common.c |    5 +++
 5 files changed, 16 insertions(+), 37 deletions(-)

diff -puN arch/powerpc/Kconfig~powerpc-fadump-remove-dependency-with-config_kexec arch/powerpc/Kconfig
--- a/arch/powerpc/Kconfig~powerpc-fadump-remove-dependency-with-config_kexec
+++ a/arch/powerpc/Kconfig
@@ -522,21 +522,23 @@ config RELOCATABLE_TEST
 	  relocation code.
 
 config CRASH_DUMP
-	bool "Build a kdump crash kernel"
+	bool "Build a dump capture kernel"
 	depends on PPC64 || 6xx || FSL_BOOKE || (44x && !SMP)
 	select RELOCATABLE if (PPC64 && !COMPILE_TEST) || 44x || FSL_BOOKE
 	help
-	  Build a kernel suitable for use as a kdump capture kernel.
+	  Build a kernel suitable for use as a dump capture kernel.
 	  The same kernel binary can be used as production kernel and dump
 	  capture kernel.
 
 config FA_DUMP
 	bool "Firmware-assisted dump"
-	depends on PPC64 && PPC_RTAS && CRASH_DUMP && KEXEC_CORE
+	depends on PPC64 && PPC_RTAS
+	select CRASH_CORE
+	select CRASH_DUMP
 	help
 	  A robust mechanism to get reliable kernel crash dump with
 	  assistance from firmware. This approach does not use kexec,
-	  instead firmware assists in booting the kdump kernel
+	  instead firmware assists in booting the capture kernel
 	  while preserving memory contents. Firmware-assisted dump
 	  is meant to be a kdump replacement offering robustness and
 	  speed not possible without system firmware assistance.
diff -puN arch/powerpc/include/asm/fadump.h~powerpc-fadump-remove-dependency-with-config_kexec arch/powerpc/include/asm/fadump.h
--- a/arch/powerpc/include/asm/fadump.h~powerpc-fadump-remove-dependency-with-config_kexec
+++ a/arch/powerpc/include/asm/fadump.h
@@ -73,6 +73,8 @@
 	reg_entry++;							\
 })
 
+extern int crashing_cpu;
+
 /* Kernel Dump section info */
 struct fadump_section {
 	__be32	request_flag;
diff -puN arch/powerpc/kernel/crash.c~powerpc-fadump-remove-dependency-with-config_kexec arch/powerpc/kernel/crash.c
--- a/arch/powerpc/kernel/crash.c~powerpc-fadump-remove-dependency-with-config_kexec
+++ a/arch/powerpc/kernel/crash.c
@@ -43,8 +43,6 @@
 #define IPI_TIMEOUT		10000
 #define REAL_MODE_TIMEOUT	10000
 
-/* This keeps a track of which one is the crashing cpu. */
-int crashing_cpu = -1;
 static int time_to_dump;
 
 #define CRASH_HANDLER_MAX 3
diff -puN arch/powerpc/kernel/fadump.c~powerpc-fadump-remove-dependency-with-config_kexec arch/powerpc/kernel/fadump.c
--- a/arch/powerpc/kernel/fadump.c~powerpc-fadump-remove-dependency-with-config_kexec
+++ a/arch/powerpc/kernel/fadump.c
@@ -509,34 +509,6 @@ fadump_read_registers(struct fadump_reg_
 	return reg_entry;
 }
 
-static u32 *fadump_append_elf_note(u32 *buf, char *name, unsigned type,
-						void *data, size_t data_len)
-{
-	struct elf_note note;
-
-	note.n_namesz = strlen(name) + 1;
-	note.n_descsz = data_len;
-	note.n_type   = type;
-	memcpy(buf, &note, sizeof(note));
-	buf += (sizeof(note) + 3)/4;
-	memcpy(buf, name, note.n_namesz);
-	buf += (note.n_namesz + 3)/4;
-	memcpy(buf, data, note.n_descsz);
-	buf += (note.n_descsz + 3)/4;
-
-	return buf;
-}
-
-static void fadump_final_note(u32 *buf)
-{
-	struct elf_note note;
-
-	note.n_namesz = 0;
-	note.n_descsz = 0;
-	note.n_type   = 0;
-	memcpy(buf, &note, sizeof(note));
-}
-
 static u32 *fadump_regs_to_elf_notes(u32 *buf, struct pt_regs *regs)
 {
 	struct elf_prstatus prstatus;
@@ -547,8 +519,8 @@ static u32 *fadump_regs_to_elf_notes(u32
 	 * prstatus.pr_pid = ????
 	 */
 	elf_core_copy_kernel_regs(&prstatus.pr_reg, regs);
-	buf = fadump_append_elf_note(buf, KEXEC_CORE_NOTE_NAME, NT_PRSTATUS,
-				&prstatus, sizeof(prstatus));
+	buf = append_elf_note(buf, CRASH_CORE_NOTE_NAME, NT_PRSTATUS,
+			      &prstatus, sizeof(prstatus));
 	return buf;
 }
 
@@ -689,7 +661,7 @@ static int __init fadump_build_cpu_notes
 			note_buf = fadump_regs_to_elf_notes(note_buf, &regs);
 		}
 	}
-	fadump_final_note(note_buf);
+	final_note(note_buf);
 
 	if (fdh) {
 		pr_debug("Updating elfcore header (%llx) with cpu notes\n",
diff -puN arch/powerpc/kernel/setup-common.c~powerpc-fadump-remove-dependency-with-config_kexec arch/powerpc/kernel/setup-common.c
--- a/arch/powerpc/kernel/setup-common.c~powerpc-fadump-remove-dependency-with-config_kexec
+++ a/arch/powerpc/kernel/setup-common.c
@@ -125,6 +125,11 @@ int ppc_do_canonicalize_irqs;
 EXPORT_SYMBOL(ppc_do_canonicalize_irqs);
 #endif
 
+#ifdef CONFIG_CRASH_CORE
+/* This keeps a track of which one is the crashing cpu. */
+int crashing_cpu = -1;
+#endif
+
 /* also used by kexec */
 void machine_shutdown(void)
 {
_

Patches currently in -mm which might be from hbathini@linux.vnet.ibm.com are

crash-move-crashkernel-parsing-and-vmcore-related-code-under-config_crash_core.patch
ia64-reuse-append_elf_note-and-final_note-functions.patch
powerpc-fadump-remove-dependency-with-config_kexec.patch
powerpc-fadump-reuse-crashkernel-parameter-for-fadump-memory-reservation.patch
powerpc-fadump-update-documentation-about-crashkernel-parameter-reuse.patch

