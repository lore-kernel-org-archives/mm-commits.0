From: akpm@osdl.org
Subject: - kexec--kdump-unify-elf-note-code.patch removed from -mm tree
Date: Thu, 07 Dec 2006 15:17:04 -0800
Message-ID: <200612072317.kB7NH4K4030899@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:53808 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163860AbWLGXRZ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 7 Dec 2006 18:17:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: magnus@valinux.co.jp, ak@suse.de, benh@kernel.crashing.org, paulus@samba.org, vgoyal@in.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Kexec / Kdump: Unify elf note code
has been removed from the -mm tree.  Its filename was
     kexec--kdump-unify-elf-note-code.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Kexec / Kdump: Unify elf note code
From: Magnus Damm <magnus@valinux.co.jp>

The elf note saving code is currently duplicated over several
architectures.  This cleanup patch simply adds code to a common file and
then replaces the arch-specific code with calls to the newly added code.

The only drawback with this approach is that s390 doesn't fully support
kexec-on-panic which for that arch leads to introduction of unused code.

Signed-off-by: Magnus Damm <magnus@valinux.co.jp>
Cc: Vivek Goyal <vgoyal@in.ibm.com>
Cc: Andi Kleen <ak@suse.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 arch/i386/kernel/crash.c    |   66 --------------------------------
 arch/powerpc/kernel/crash.c |   59 -----------------------------
 arch/x86_64/kernel/crash.c  |   69 ----------------------------------
 include/linux/kexec.h       |    1 
 kernel/kexec.c              |   56 +++++++++++++++++++++++++++
 5 files changed, 63 insertions(+), 188 deletions(-)

diff -puN arch/i386/kernel/crash.c~kexec--kdump-unify-elf-note-code arch/i386/kernel/crash.c
--- a/arch/i386/kernel/crash.c~kexec--kdump-unify-elf-note-code
+++ a/arch/i386/kernel/crash.c
@@ -31,68 +31,6 @@
 /* This keeps a track of which one is crashing cpu. */
 static int crashing_cpu;
 
-static u32 *append_elf_note(u32 *buf, char *name, unsigned type, void *data,
-							       size_t data_len)
-{
-	struct elf_note note;
-
-	note.n_namesz = strlen(name) + 1;
-	note.n_descsz = data_len;
-	note.n_type   = type;
-	memcpy(buf, &note, sizeof(note));
-	buf += (sizeof(note) +3)/4;
-	memcpy(buf, name, note.n_namesz);
-	buf += (note.n_namesz + 3)/4;
-	memcpy(buf, data, note.n_descsz);
-	buf += (note.n_descsz + 3)/4;
-
-	return buf;
-}
-
-static void final_note(u32 *buf)
-{
-	struct elf_note note;
-
-	note.n_namesz = 0;
-	note.n_descsz = 0;
-	note.n_type   = 0;
-	memcpy(buf, &note, sizeof(note));
-}
-
-static void crash_save_this_cpu(struct pt_regs *regs, int cpu)
-{
-	struct elf_prstatus prstatus;
-	u32 *buf;
-
-	if ((cpu < 0) || (cpu >= NR_CPUS))
-		return;
-
-	/* Using ELF notes here is opportunistic.
-	 * I need a well defined structure format
-	 * for the data I pass, and I need tags
-	 * on the data to indicate what information I have
-	 * squirrelled away.  ELF notes happen to provide
-	 * all of that, so there is no need to invent something new.
-	 */
-	buf = (u32*)per_cpu_ptr(crash_notes, cpu);
-	if (!buf)
-		return;
-	memset(&prstatus, 0, sizeof(prstatus));
-	prstatus.pr_pid = current->pid;
-	elf_core_copy_regs(&prstatus.pr_reg, regs);
-	buf = append_elf_note(buf, "CORE", NT_PRSTATUS, &prstatus,
-				sizeof(prstatus));
-	final_note(buf);
-}
-
-static void crash_save_self(struct pt_regs *regs)
-{
-	int cpu;
-
-	cpu = safe_smp_processor_id();
-	crash_save_this_cpu(regs, cpu);
-}
-
 #if defined(CONFIG_SMP) && defined(CONFIG_X86_LOCAL_APIC)
 static atomic_t waiting_for_crash_ipi;
 
@@ -121,7 +59,7 @@ static int crash_nmi_callback(struct not
 		crash_fixup_ss_esp(&fixed_regs, regs);
 		regs = &fixed_regs;
 	}
-	crash_save_this_cpu(regs, cpu);
+	crash_save_cpu(regs, cpu);
 	disable_local_APIC();
 	atomic_dec(&waiting_for_crash_ipi);
 	/* Assume hlt works */
@@ -195,5 +133,5 @@ void machine_crash_shutdown(struct pt_re
 #if defined(CONFIG_X86_IO_APIC)
 	disable_IO_APIC();
 #endif
-	crash_save_self(regs);
+	crash_save_cpu(regs, safe_smp_processor_id());
 }
diff -puN arch/powerpc/kernel/crash.c~kexec--kdump-unify-elf-note-code arch/powerpc/kernel/crash.c
--- a/arch/powerpc/kernel/crash.c~kexec--kdump-unify-elf-note-code
+++ a/arch/powerpc/kernel/crash.c
@@ -46,61 +46,6 @@ int crashing_cpu = -1;
 static cpumask_t cpus_in_crash = CPU_MASK_NONE;
 cpumask_t cpus_in_sr = CPU_MASK_NONE;
 
-static u32 *append_elf_note(u32 *buf, char *name, unsigned type, void *data,
-							       size_t data_len)
-{
-	struct elf_note note;
-
-	note.n_namesz = strlen(name) + 1;
-	note.n_descsz = data_len;
-	note.n_type   = type;
-	memcpy(buf, &note, sizeof(note));
-	buf += (sizeof(note) +3)/4;
-	memcpy(buf, name, note.n_namesz);
-	buf += (note.n_namesz + 3)/4;
-	memcpy(buf, data, note.n_descsz);
-	buf += (note.n_descsz + 3)/4;
-
-	return buf;
-}
-
-static void final_note(u32 *buf)
-{
-	struct elf_note note;
-
-	note.n_namesz = 0;
-	note.n_descsz = 0;
-	note.n_type   = 0;
-	memcpy(buf, &note, sizeof(note));
-}
-
-static void crash_save_this_cpu(struct pt_regs *regs, int cpu)
-{
-	struct elf_prstatus prstatus;
-	u32 *buf;
-
-	if ((cpu < 0) || (cpu >= NR_CPUS))
-		return;
-
-	/* Using ELF notes here is opportunistic.
-	 * I need a well defined structure format
-	 * for the data I pass, and I need tags
-	 * on the data to indicate what information I have
-	 * squirrelled away.  ELF notes happen to provide
-	 * all of that that no need to invent something new.
-	 */
-	buf = (u32*)per_cpu_ptr(crash_notes, cpu);
-	if (!buf) 
-		return;
-
-	memset(&prstatus, 0, sizeof(prstatus));
-	prstatus.pr_pid = current->pid;
-	elf_core_copy_regs(&prstatus.pr_reg, regs);
-	buf = append_elf_note(buf, "CORE", NT_PRSTATUS, &prstatus,
-			sizeof(prstatus));
-	final_note(buf);
-}
-
 #ifdef CONFIG_SMP
 static atomic_t enter_on_soft_reset = ATOMIC_INIT(0);
 
@@ -113,7 +58,7 @@ void crash_ipi_callback(struct pt_regs *
 
 	hard_irq_disable();
 	if (!cpu_isset(cpu, cpus_in_crash))
-		crash_save_this_cpu(regs, cpu);
+		crash_save_cpu(regs, cpu);
 	cpu_set(cpu, cpus_in_crash);
 
 	/*
@@ -306,7 +251,7 @@ void default_machine_crash_shutdown(stru
 	 * such that another IPI will not be sent.
 	 */
 	crashing_cpu = smp_processor_id();
-	crash_save_this_cpu(regs, crashing_cpu);
+	crash_save_cpu(regs, crashing_cpu);
 	crash_kexec_prepare_cpus(crashing_cpu);
 	cpu_set(crashing_cpu, cpus_in_crash);
 	if (ppc_md.kexec_cpu_down)
diff -puN arch/x86_64/kernel/crash.c~kexec--kdump-unify-elf-note-code arch/x86_64/kernel/crash.c
--- a/arch/x86_64/kernel/crash.c~kexec--kdump-unify-elf-note-code
+++ a/arch/x86_64/kernel/crash.c
@@ -28,71 +28,6 @@
 /* This keeps a track of which one is crashing cpu. */
 static int crashing_cpu;
 
-static u32 *append_elf_note(u32 *buf, char *name, unsigned type,
-						void *data, size_t data_len)
-{
-	struct elf_note note;
-
-	note.n_namesz = strlen(name) + 1;
-	note.n_descsz = data_len;
-	note.n_type   = type;
-	memcpy(buf, &note, sizeof(note));
-	buf += (sizeof(note) +3)/4;
-	memcpy(buf, name, note.n_namesz);
-	buf += (note.n_namesz + 3)/4;
-	memcpy(buf, data, note.n_descsz);
-	buf += (note.n_descsz + 3)/4;
-
-	return buf;
-}
-
-static void final_note(u32 *buf)
-{
-	struct elf_note note;
-
-	note.n_namesz = 0;
-	note.n_descsz = 0;
-	note.n_type   = 0;
-	memcpy(buf, &note, sizeof(note));
-}
-
-static void crash_save_this_cpu(struct pt_regs *regs, int cpu)
-{
-	struct elf_prstatus prstatus;
-	u32 *buf;
-
-	if ((cpu < 0) || (cpu >= NR_CPUS))
-		return;
-
-	/* Using ELF notes here is opportunistic.
-	 * I need a well defined structure format
-	 * for the data I pass, and I need tags
-	 * on the data to indicate what information I have
-	 * squirrelled away.  ELF notes happen to provide
-	 * all of that, no need to invent something new.
-	 */
-
-	buf = (u32*)per_cpu_ptr(crash_notes, cpu);
-
-	if (!buf)
-		return;
-
-	memset(&prstatus, 0, sizeof(prstatus));
-	prstatus.pr_pid = current->pid;
-	elf_core_copy_regs(&prstatus.pr_reg, regs);
-	buf = append_elf_note(buf, "CORE", NT_PRSTATUS, &prstatus,
-					sizeof(prstatus));
-	final_note(buf);
-}
-
-static void crash_save_self(struct pt_regs *regs)
-{
-	int cpu;
-
-	cpu = smp_processor_id();
-	crash_save_this_cpu(regs, cpu);
-}
-
 #ifdef CONFIG_SMP
 static atomic_t waiting_for_crash_ipi;
 
@@ -117,7 +52,7 @@ static int crash_nmi_callback(struct not
 		return NOTIFY_STOP;
 	local_irq_disable();
 
-	crash_save_this_cpu(regs, cpu);
+	crash_save_cpu(regs, cpu);
 	disable_local_APIC();
 	atomic_dec(&waiting_for_crash_ipi);
 	/* Assume hlt works */
@@ -196,5 +131,5 @@ void machine_crash_shutdown(struct pt_re
 
 	disable_IO_APIC();
 
-	crash_save_self(regs);
+	crash_save_cpu(regs, smp_processor_id());
 }
diff -puN include/linux/kexec.h~kexec--kdump-unify-elf-note-code include/linux/kexec.h
--- a/include/linux/kexec.h~kexec--kdump-unify-elf-note-code
+++ a/include/linux/kexec.h
@@ -105,6 +105,7 @@ extern struct page *kimage_alloc_control
 						unsigned int order);
 extern void crash_kexec(struct pt_regs *);
 int kexec_should_crash(struct task_struct *);
+void crash_save_cpu(struct pt_regs *regs, int cpu);
 extern struct kimage *kexec_image;
 extern struct kimage *kexec_crash_image;
 
diff -puN kernel/kexec.c~kexec--kdump-unify-elf-note-code kernel/kexec.c
--- a/kernel/kexec.c~kexec--kdump-unify-elf-note-code
+++ a/kernel/kexec.c
@@ -20,6 +20,8 @@
 #include <linux/syscalls.h>
 #include <linux/ioport.h>
 #include <linux/hardirq.h>
+#include <linux/elf.h>
+#include <linux/elfcore.h>
 
 #include <asm/page.h>
 #include <asm/uaccess.h>
@@ -1066,6 +1068,60 @@ void crash_kexec(struct pt_regs *regs)
 	}
 }
 
+static u32 *append_elf_note(u32 *buf, char *name, unsigned type, void *data,
+			    size_t data_len)
+{
+	struct elf_note note;
+
+	note.n_namesz = strlen(name) + 1;
+	note.n_descsz = data_len;
+	note.n_type   = type;
+	memcpy(buf, &note, sizeof(note));
+	buf += (sizeof(note) + 3)/4;
+	memcpy(buf, name, note.n_namesz);
+	buf += (note.n_namesz + 3)/4;
+	memcpy(buf, data, note.n_descsz);
+	buf += (note.n_descsz + 3)/4;
+
+	return buf;
+}
+
+static void final_note(u32 *buf)
+{
+	struct elf_note note;
+
+	note.n_namesz = 0;
+	note.n_descsz = 0;
+	note.n_type   = 0;
+	memcpy(buf, &note, sizeof(note));
+}
+
+void crash_save_cpu(struct pt_regs *regs, int cpu)
+{
+	struct elf_prstatus prstatus;
+	u32 *buf;
+
+	if ((cpu < 0) || (cpu >= NR_CPUS))
+		return;
+
+	/* Using ELF notes here is opportunistic.
+	 * I need a well defined structure format
+	 * for the data I pass, and I need tags
+	 * on the data to indicate what information I have
+	 * squirrelled away.  ELF notes happen to provide
+	 * all of that, so there is no need to invent something new.
+	 */
+	buf = (u32*)per_cpu_ptr(crash_notes, cpu);
+	if (!buf)
+		return;
+	memset(&prstatus, 0, sizeof(prstatus));
+	prstatus.pr_pid = current->pid;
+	elf_core_copy_regs(&prstatus.pr_reg, regs);
+	buf = append_elf_note(buf, "CORE", NT_PRSTATUS, &prstatus,
+				sizeof(prstatus));
+	final_note(buf);
+}
+
 static int __init crash_notes_memory_init(void)
 {
 	/* Allocate memory for saving cpu registers. */
_

Patches currently in -mm which might be from magnus@valinux.co.jp are

origin.patch

