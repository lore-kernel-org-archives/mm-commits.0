From: akpm@linux-foundation.org
Subject: - kdump-kexec-calculate-note-size-at-compile-time.patch removed from -mm tree
Date: Tue, 08 May 2007 19:48:29 -0700
Message-ID: <200705090248.l492mTR2009116@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:44378 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934575AbXEICsn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 22:48:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: horms@verge.net.au, vgoyal@in.ibm.com, mm-commits@vger.kernel.org


The patch titled
     kdump/kexec: calculate note size at compile time
has been removed from the -mm tree.  Its filename was
     kdump-kexec-calculate-note-size-at-compile-time.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: kdump/kexec: calculate note size at compile time
From: Simon Horman <horms@verge.net.au>

Currently the size of the per-cpu region reserved to save crash notes is
set by the per-architecture value MAX_NOTE_BYTES.  Which in turn is
currently set to 1024 on all supported architectures.

While testing ia64 I recently discovered that this value is in fact too
small.  The particular setup I was using actually needs 1172 bytes.  This
lead to very tedious failure mode where the tail of one elf note would
overwrite the head of another if they ended up being alocated sequentially
by kmalloc, which was often the case.

It seems to me that a far better approach is to caclculate the size that
the area needs to be.  This patch does just that.

If a simpler stop-gap patch for ia64 to be squeezed into 2.6.21(.X) is
needed then this should be as easy as making MAX_NOTE_BYTES larger in
arch/asm-ia64/kexec.h.  Perhaps 2048 would be a good choice.  However, I
think that the approach in this patch is a much more robust idea.

Acked-by:  Vivek Goyal <vgoyal@in.ibm.com>
Signed-off-by: Simon Horman <horms@verge.net.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/kernel/crash.c    |    2 +-
 include/asm-arm/kexec.h     |    2 --
 include/asm-i386/kexec.h    |    2 --
 include/asm-ia64/kexec.h    |    2 --
 include/asm-mips/kexec.h    |    2 --
 include/asm-powerpc/kexec.h |    2 --
 include/asm-s390/kexec.h    |    2 --
 include/asm-sh/kexec.h      |    2 --
 include/asm-x86_64/kexec.h  |    2 --
 include/linux/kexec.h       |   17 ++++++++++++++++-
 kernel/kexec.c              |    4 ++--
 11 files changed, 19 insertions(+), 20 deletions(-)

diff -puN arch/ia64/kernel/crash.c~kdump-kexec-calculate-note-size-at-compile-time arch/ia64/kernel/crash.c
--- a/arch/ia64/kernel/crash.c~kdump-kexec-calculate-note-size-at-compile-time
+++ a/arch/ia64/kernel/crash.c
@@ -74,7 +74,7 @@ crash_save_this_cpu(void)
 	buf = (u64 *) per_cpu_ptr(crash_notes, cpu);
 	if (!buf)
 		return;
-	buf = append_elf_note(buf, "CORE", NT_PRSTATUS, prstatus,
+	buf = append_elf_note(buf, KEXEC_CORE_NOTE_NAME, NT_PRSTATUS, prstatus,
 			sizeof(*prstatus));
 	final_note(buf);
 }
diff -puN include/asm-arm/kexec.h~kdump-kexec-calculate-note-size-at-compile-time include/asm-arm/kexec.h
--- a/include/asm-arm/kexec.h~kdump-kexec-calculate-note-size-at-compile-time
+++ a/include/asm-arm/kexec.h
@@ -16,8 +16,6 @@
 
 #ifndef __ASSEMBLY__
 
-#define MAX_NOTE_BYTES 1024
-
 struct kimage;
 /* Provide a dummy definition to avoid build failures. */
 static inline void crash_setup_regs(struct pt_regs *newregs,
diff -puN include/asm-i386/kexec.h~kdump-kexec-calculate-note-size-at-compile-time include/asm-i386/kexec.h
--- a/include/asm-i386/kexec.h~kdump-kexec-calculate-note-size-at-compile-time
+++ a/include/asm-i386/kexec.h
@@ -45,8 +45,6 @@
 /* We can also handle crash dumps from 64 bit kernel. */
 #define vmcore_elf_check_arch_cross(x) ((x)->e_machine == EM_X86_64)
 
-#define MAX_NOTE_BYTES 1024
-
 /* CPU does not save ss and esp on stack if execution is already
  * running in kernel mode at the time of NMI occurrence. This code
  * fixes it.
diff -puN include/asm-ia64/kexec.h~kdump-kexec-calculate-note-size-at-compile-time include/asm-ia64/kexec.h
--- a/include/asm-ia64/kexec.h~kdump-kexec-calculate-note-size-at-compile-time
+++ a/include/asm-ia64/kexec.h
@@ -14,8 +14,6 @@
 /* The native architecture */
 #define KEXEC_ARCH KEXEC_ARCH_IA_64
 
-#define MAX_NOTE_BYTES 1024
-
 #define kexec_flush_icache_page(page) do { \
                 unsigned long page_addr = (unsigned long)page_address(page); \
                 flush_icache_range(page_addr, page_addr + PAGE_SIZE); \
diff -puN include/asm-mips/kexec.h~kdump-kexec-calculate-note-size-at-compile-time include/asm-mips/kexec.h
--- a/include/asm-mips/kexec.h~kdump-kexec-calculate-note-size-at-compile-time
+++ a/include/asm-mips/kexec.h
@@ -21,8 +21,6 @@
 /* The native architecture */
 #define KEXEC_ARCH KEXEC_ARCH_MIPS
 
-#define MAX_NOTE_BYTES 1024
-
 static inline void crash_setup_regs(struct pt_regs *newregs,
 				    struct pt_regs *oldregs)
 {
diff -puN include/asm-powerpc/kexec.h~kdump-kexec-calculate-note-size-at-compile-time include/asm-powerpc/kexec.h
--- a/include/asm-powerpc/kexec.h~kdump-kexec-calculate-note-size-at-compile-time
+++ a/include/asm-powerpc/kexec.h
@@ -108,8 +108,6 @@ static inline void crash_setup_regs(stru
 					struct pt_regs *oldregs) { }
 #endif /* !__powerpc64 __ */
 
-#define MAX_NOTE_BYTES 1024
-
 extern void kexec_smp_wait(void);	/* get and clear naca physid, wait for
 					  master to copy new code to 0 */
 extern int crashing_cpu;
diff -puN include/asm-s390/kexec.h~kdump-kexec-calculate-note-size-at-compile-time include/asm-s390/kexec.h
--- a/include/asm-s390/kexec.h~kdump-kexec-calculate-note-size-at-compile-time
+++ a/include/asm-s390/kexec.h
@@ -34,8 +34,6 @@
 /* The native architecture */
 #define KEXEC_ARCH KEXEC_ARCH_S390
 
-#define MAX_NOTE_BYTES 1024
-
 /* Provide a dummy definition to avoid build failures. */
 static inline void crash_setup_regs(struct pt_regs *newregs,
 					struct pt_regs *oldregs) { }
diff -puN include/asm-sh/kexec.h~kdump-kexec-calculate-note-size-at-compile-time include/asm-sh/kexec.h
--- a/include/asm-sh/kexec.h~kdump-kexec-calculate-note-size-at-compile-time
+++ a/include/asm-sh/kexec.h
@@ -26,8 +26,6 @@
 /* The native architecture */
 #define KEXEC_ARCH KEXEC_ARCH_SH
 
-#define MAX_NOTE_BYTES 1024
-
 static inline void crash_setup_regs(struct pt_regs *newregs,
 				    struct pt_regs *oldregs)
 {
diff -puN include/asm-x86_64/kexec.h~kdump-kexec-calculate-note-size-at-compile-time include/asm-x86_64/kexec.h
--- a/include/asm-x86_64/kexec.h~kdump-kexec-calculate-note-size-at-compile-time
+++ a/include/asm-x86_64/kexec.h
@@ -48,8 +48,6 @@
 /* The native architecture */
 #define KEXEC_ARCH KEXEC_ARCH_X86_64
 
-#define MAX_NOTE_BYTES 1024
-
 /*
  * Saving the registers of the cpu on which panic occured in
  * crash_kexec to save a valid sp. The registers of other cpus
diff -puN include/linux/kexec.h~kdump-kexec-calculate-note-size-at-compile-time include/linux/kexec.h
--- a/include/linux/kexec.h~kdump-kexec-calculate-note-size-at-compile-time
+++ a/include/linux/kexec.h
@@ -7,6 +7,8 @@
 #include <linux/linkage.h>
 #include <linux/compat.h>
 #include <linux/ioport.h>
+#include <linux/elfcore.h>
+#include <linux/elf.h>
 #include <asm/kexec.h>
 
 /* Verify architecture specific macros are defined */
@@ -31,6 +33,19 @@
 #error KEXEC_ARCH not defined
 #endif
 
+#define KEXEC_NOTE_HEAD_BYTES ALIGN(sizeof(struct elf_note), 4)
+#define KEXEC_CORE_NOTE_NAME "CORE"
+#define KEXEC_CORE_NOTE_NAME_BYTES ALIGN(sizeof(KEXEC_CORE_NOTE_NAME), 4)
+#define KEXEC_CORE_NOTE_DESC_BYTES ALIGN(sizeof(struct elf_prstatus), 4)
+/*
+ * The per-cpu notes area is a list of notes terminated by a "NULL"
+ * note header.  For kdump, the code in vmcore.c runs in the context
+ * of the second kernel to combine them into one note.
+ */
+#define KEXEC_NOTE_BYTES ( (KEXEC_NOTE_HEAD_BYTES * 2) +		\
+			    KEXEC_CORE_NOTE_NAME_BYTES +		\
+			    KEXEC_CORE_NOTE_DESC_BYTES )
+
 /*
  * This structure is used to hold the arguments that are used when loading
  * kernel binaries.
@@ -136,7 +151,7 @@ extern struct kimage *kexec_crash_image;
 /* Location of a reserved region to hold the crash kernel.
  */
 extern struct resource crashk_res;
-typedef u32 note_buf_t[MAX_NOTE_BYTES/4];
+typedef u32 note_buf_t[KEXEC_NOTE_BYTES/4];
 extern note_buf_t *crash_notes;
 
 
diff -puN kernel/kexec.c~kdump-kexec-calculate-note-size-at-compile-time kernel/kexec.c
--- a/kernel/kexec.c~kdump-kexec-calculate-note-size-at-compile-time
+++ a/kernel/kexec.c
@@ -1118,8 +1118,8 @@ void crash_save_cpu(struct pt_regs *regs
 	memset(&prstatus, 0, sizeof(prstatus));
 	prstatus.pr_pid = current->pid;
 	elf_core_copy_regs(&prstatus.pr_reg, regs);
-	buf = append_elf_note(buf, "CORE", NT_PRSTATUS, &prstatus,
-				sizeof(prstatus));
+	buf = append_elf_note(buf, KEXEC_CORE_NOTE_NAME, NT_PRSTATUS,
+		      	      &prstatus, sizeof(prstatus));
 	final_note(buf);
 }
 
_

Patches currently in -mm which might be from horms@verge.net.au are

origin.patch
git-ia64.patch
use-menuconfig-objects-ipvs.patch
