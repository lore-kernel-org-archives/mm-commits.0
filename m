From: akpm@linux-foundation.org
Subject: [merged] elf-coredump-replace-elf_core_extra_-macros-by-functions.patch removed from -mm tree
Date: Tue, 09 Mar 2010 11:09:46 -0800
Message-ID: <201003091909.o29J9keB031545@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51361 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755751Ab0CITLb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Mar 2010 14:11:31 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: d.hatayama@jp.fujitsu.com, alan@lxorguk.ukuu.org.uk, andi@firstfloor.org, dhowells@redhat.com, gerg@snapgear.com, jdike@addtoit.com, linux-arch@vger.kernel.org, mingo@elte.hu, oleg@re


The patch titled
     elf coredump: replace ELF_CORE_EXTRA_* macros by functions
has been removed from the -mm tree.  Its filename was
     elf-coredump-replace-elf_core_extra_-macros-by-functions.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: elf coredump: replace ELF_CORE_EXTRA_* macros by functions
From: Daisuke HATAYAMA <d.hatayama@jp.fujitsu.com>

elf_core_dump() and elf_fdpic_core_dump() use #ifdef and the corresponding
macro for hiding _multiline_ logics in functions.  This patch removes
#ifdef and replaces ELF_CORE_EXTRA_* by corresponding functions.  For
architectures not implemeonting ELF_CORE_EXTRA_*, we use weak functions in
order to reduce a range of modification.

This cleanup is for my next patches, but I think this cleanup itself is
worth doing regardless of my firnal purpose.

Signed-off-by: Daisuke HATAYAMA <d.hatayama@jp.fujitsu.com>
Cc: "Luck, Tony" <tony.luck@intel.com>
Cc: Jeff Dike <jdike@addtoit.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Greg Ungerer <gerg@snapgear.com>
Cc: Roland McGrath <roland@redhat.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: <linux-arch@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/include/asm/elf.h |   48 ------------------------
 arch/ia64/kernel/Makefile   |    2 +
 arch/ia64/kernel/elfcore.c  |   64 ++++++++++++++++++++++++++++++++
 arch/um/sys-i386/Makefile   |    2 +
 arch/um/sys-i386/asm/elf.h  |   43 ---------------------
 arch/um/sys-i386/elfcore.c  |   67 ++++++++++++++++++++++++++++++++++
 fs/binfmt_elf.c             |   14 ++-----
 fs/binfmt_elf_fdpic.c       |   14 ++-----
 fs/compat_binfmt_elf.c      |    2 +
 include/linux/elf.h         |    2 +
 include/linux/elfcore.h     |   16 ++++++++
 kernel/Makefile             |    3 +
 kernel/elfcore.c            |   23 +++++++++++
 13 files changed, 191 insertions(+), 109 deletions(-)

diff -puN arch/ia64/include/asm/elf.h~elf-coredump-replace-elf_core_extra_-macros-by-functions arch/ia64/include/asm/elf.h
--- a/arch/ia64/include/asm/elf.h~elf-coredump-replace-elf_core_extra_-macros-by-functions
+++ a/arch/ia64/include/asm/elf.h
@@ -219,54 +219,6 @@ do {										\
 	NEW_AUX_ENT(AT_SYSINFO_EHDR, (unsigned long) GATE_EHDR);		\
 } while (0)
 
-
-/*
- * These macros parameterize elf_core_dump in fs/binfmt_elf.c to write out
- * extra segments containing the gate DSO contents.  Dumping its
- * contents makes post-mortem fully interpretable later without matching up
- * the same kernel and hardware config to see what PC values meant.
- * Dumping its extra ELF program headers includes all the other information
- * a debugger needs to easily find how the gate DSO was being used.
- */
-#define ELF_CORE_EXTRA_PHDRS		(GATE_EHDR->e_phnum)
-#define ELF_CORE_WRITE_EXTRA_PHDRS						\
-do {										\
-	const struct elf_phdr *const gate_phdrs =			      \
-		(const struct elf_phdr *) (GATE_ADDR + GATE_EHDR->e_phoff);   \
-	int i;									\
-	Elf64_Off ofs = 0;						      \
-	for (i = 0; i < GATE_EHDR->e_phnum; ++i) {				\
-		struct elf_phdr phdr = gate_phdrs[i];			      \
-		if (phdr.p_type == PT_LOAD) {					\
-			phdr.p_memsz = PAGE_ALIGN(phdr.p_memsz);	      \
-			phdr.p_filesz = phdr.p_memsz;			      \
-			if (ofs == 0) {					      \
-				ofs = phdr.p_offset = offset;		      \
-			offset += phdr.p_filesz;				\
-		}							      \
-		else							      \
-				phdr.p_offset = ofs;			      \
-		}							      \
-		else							      \
-			phdr.p_offset += ofs;					\
-		phdr.p_paddr = 0; /* match other core phdrs */			\
-		DUMP_WRITE(&phdr, sizeof(phdr));				\
-	}									\
-} while (0)
-#define ELF_CORE_WRITE_EXTRA_DATA					\
-do {									\
-	const struct elf_phdr *const gate_phdrs =			      \
-		(const struct elf_phdr *) (GATE_ADDR + GATE_EHDR->e_phoff);   \
-	int i;								\
-	for (i = 0; i < GATE_EHDR->e_phnum; ++i) {			\
-		if (gate_phdrs[i].p_type == PT_LOAD) {			      \
-			DUMP_WRITE((void *) gate_phdrs[i].p_vaddr,	      \
-				   PAGE_ALIGN(gate_phdrs[i].p_memsz));	      \
-			break;						      \
-		}							      \
-	}								\
-} while (0)
-
 /*
  * format for entries in the Global Offset Table
  */
diff -puN arch/ia64/kernel/Makefile~elf-coredump-replace-elf_core_extra_-macros-by-functions arch/ia64/kernel/Makefile
--- a/arch/ia64/kernel/Makefile~elf-coredump-replace-elf_core_extra_-macros-by-functions
+++ a/arch/ia64/kernel/Makefile
@@ -45,6 +45,8 @@ endif
 obj-$(CONFIG_DMAR)		+= pci-dma.o
 obj-$(CONFIG_SWIOTLB)		+= pci-swiotlb.o
 
+obj-$(CONFIG_BINFMT_ELF)	+= elfcore.o
+
 # fp_emulate() expects f2-f5,f16-f31 to contain the user-level state.
 CFLAGS_traps.o  += -mfixed-range=f2-f5,f16-f31
 
diff -puN /dev/null arch/ia64/kernel/elfcore.c
--- /dev/null
+++ a/arch/ia64/kernel/elfcore.c
@@ -0,0 +1,64 @@
+#include <linux/elf.h>
+#include <linux/coredump.h>
+#include <linux/fs.h>
+#include <linux/mm.h>
+
+#include <asm/elf.h>
+
+
+Elf64_Half elf_core_extra_phdrs(void)
+{
+	return GATE_EHDR->e_phnum;
+}
+
+int elf_core_write_extra_phdrs(struct file *file, loff_t offset, size_t *size,
+			       unsigned long limit)
+{
+	const struct elf_phdr *const gate_phdrs =
+		(const struct elf_phdr *) (GATE_ADDR + GATE_EHDR->e_phoff);
+	int i;
+	Elf64_Off ofs = 0;
+
+	for (i = 0; i < GATE_EHDR->e_phnum; ++i) {
+		struct elf_phdr phdr = gate_phdrs[i];
+
+		if (phdr.p_type == PT_LOAD) {
+			phdr.p_memsz = PAGE_ALIGN(phdr.p_memsz);
+			phdr.p_filesz = phdr.p_memsz;
+			if (ofs == 0) {
+				ofs = phdr.p_offset = offset;
+				offset += phdr.p_filesz;
+			} else {
+				phdr.p_offset = ofs;
+			}
+		} else {
+			phdr.p_offset += ofs;
+		}
+		phdr.p_paddr = 0; /* match other core phdrs */
+		*size += sizeof(phdr);
+		if (*size > limit || !dump_write(file, &phdr, sizeof(phdr)))
+			return 0;
+	}
+	return 1;
+}
+
+int elf_core_write_extra_data(struct file *file, size_t *size,
+			      unsigned long limit)
+{
+	const struct elf_phdr *const gate_phdrs =
+		(const struct elf_phdr *) (GATE_ADDR + GATE_EHDR->e_phoff);
+	int i;
+
+	for (i = 0; i < GATE_EHDR->e_phnum; ++i) {
+		if (gate_phdrs[i].p_type == PT_LOAD) {
+			void *addr = (void *)gate_phdrs[i].p_vaddr;
+			size_t memsz = PAGE_ALIGN(gate_phdrs[i].p_memsz);
+
+			*size += memsz;
+			if (*size > limit || !dump_write(file, addr, memsz))
+				return 0;
+			break;
+		}
+	}
+	return 1;
+}
diff -puN arch/um/sys-i386/Makefile~elf-coredump-replace-elf_core_extra_-macros-by-functions arch/um/sys-i386/Makefile
--- a/arch/um/sys-i386/Makefile~elf-coredump-replace-elf_core_extra_-macros-by-functions
+++ a/arch/um/sys-i386/Makefile
@@ -6,6 +6,8 @@ obj-y = bug.o bugs.o checksum.o delay.o 
 	ptrace_user.o setjmp.o signal.o stub.o stub_segv.o syscalls.o sysrq.o \
 	sys_call_table.o tls.o
 
+obj-$(CONFIG_BINFMT_ELF) += elfcore.o
+
 subarch-obj-y = lib/semaphore_32.o lib/string_32.o
 subarch-obj-$(CONFIG_HIGHMEM) += mm/highmem_32.o
 subarch-obj-$(CONFIG_MODULES) += kernel/module.o
diff -puN arch/um/sys-i386/asm/elf.h~elf-coredump-replace-elf_core_extra_-macros-by-functions arch/um/sys-i386/asm/elf.h
--- a/arch/um/sys-i386/asm/elf.h~elf-coredump-replace-elf_core_extra_-macros-by-functions
+++ a/arch/um/sys-i386/asm/elf.h
@@ -116,47 +116,4 @@ do {								\
 	}							\
 } while (0)
 
-/*
- * These macros parameterize elf_core_dump in fs/binfmt_elf.c to write out
- * extra segments containing the vsyscall DSO contents.  Dumping its
- * contents makes post-mortem fully interpretable later without matching up
- * the same kernel and hardware config to see what PC values meant.
- * Dumping its extra ELF program headers includes all the other information
- * a debugger needs to easily find how the vsyscall DSO was being used.
- */
-#define ELF_CORE_EXTRA_PHDRS						      \
-	(vsyscall_ehdr ? (((struct elfhdr *)vsyscall_ehdr)->e_phnum) : 0 )
-
-#define ELF_CORE_WRITE_EXTRA_PHDRS					      \
-if ( vsyscall_ehdr ) {							      \
-	const struct elfhdr *const ehdrp = (struct elfhdr *)vsyscall_ehdr;    \
-	const struct elf_phdr *const phdrp =				      \
-		(const struct elf_phdr *) (vsyscall_ehdr + ehdrp->e_phoff);   \
-	int i;								      \
-	Elf32_Off ofs = 0;						      \
-	for (i = 0; i < ehdrp->e_phnum; ++i) {				      \
-		struct elf_phdr phdr = phdrp[i];			      \
-		if (phdr.p_type == PT_LOAD) {				      \
-			ofs = phdr.p_offset = offset;			      \
-			offset += phdr.p_filesz;			      \
-		}							      \
-		else							      \
-			phdr.p_offset += ofs;				      \
-		phdr.p_paddr = 0; /* match other core phdrs */		      \
-		DUMP_WRITE(&phdr, sizeof(phdr));			      \
-	}								      \
-}
-#define ELF_CORE_WRITE_EXTRA_DATA					      \
-if ( vsyscall_ehdr ) {							      \
-	const struct elfhdr *const ehdrp = (struct elfhdr *)vsyscall_ehdr;    \
-	const struct elf_phdr *const phdrp =				      \
-		(const struct elf_phdr *) (vsyscall_ehdr + ehdrp->e_phoff);   \
-	int i;								      \
-	for (i = 0; i < ehdrp->e_phnum; ++i) {				      \
-		if (phdrp[i].p_type == PT_LOAD)				      \
-			DUMP_WRITE((void *) phdrp[i].p_vaddr,		      \
-				   phdrp[i].p_filesz);			      \
-	}								      \
-}
-
 #endif
diff -puN /dev/null arch/um/sys-i386/elfcore.c
--- /dev/null
+++ a/arch/um/sys-i386/elfcore.c
@@ -0,0 +1,67 @@
+#include <linux/elf.h>
+#include <linux/coredump.h>
+#include <linux/fs.h>
+#include <linux/mm.h>
+
+#include <asm/elf.h>
+
+
+Elf32_Half elf_core_extra_phdrs(void)
+{
+	return vsyscall_ehdr ? (((struct elfhdr *)vsyscall_ehdr)->e_phnum) : 0;
+}
+
+int elf_core_write_extra_phdrs(struct file *file, loff_t offset, size_t *size,
+			       unsigned long limit)
+{
+	if ( vsyscall_ehdr ) {
+		const struct elfhdr *const ehdrp =
+			(struct elfhdr *) vsyscall_ehdr;
+		const struct elf_phdr *const phdrp =
+			(const struct elf_phdr *) (vsyscall_ehdr + ehdrp->e_phoff);
+		int i;
+		Elf32_Off ofs = 0;
+
+		for (i = 0; i < ehdrp->e_phnum; ++i) {
+			struct elf_phdr phdr = phdrp[i];
+
+			if (phdr.p_type == PT_LOAD) {
+				ofs = phdr.p_offset = offset;
+				offset += phdr.p_filesz;
+			} else {
+				phdr.p_offset += ofs;
+			}
+			phdr.p_paddr = 0; /* match other core phdrs */
+			*size += sizeof(phdr);
+			if (*size > limit
+			    || !dump_write(file, &phdr, sizeof(phdr)))
+				return 0;
+		}
+	}
+	return 1;
+}
+
+int elf_core_write_extra_data(struct file *file, size_t *size,
+			      unsigned long limit)
+{
+	if ( vsyscall_ehdr ) {
+		const struct elfhdr *const ehdrp =
+			(struct elfhdr *) vsyscall_ehdr;
+		const struct elf_phdr *const phdrp =
+			(const struct elf_phdr *) (vsyscall_ehdr + ehdrp->e_phoff);
+		int i;
+
+		for (i = 0; i < ehdrp->e_phnum; ++i) {
+			if (phdrp[i].p_type == PT_LOAD) {
+				void *addr = (void *) phdrp[i].p_vaddr;
+				size_t filesz = phdrp[i].p_filesz;
+
+				*size += filesz;
+				if (*size > limit
+				    || !dump_write(file, addr, filesz))
+					return 0;
+			}
+		}
+	}
+	return 1;
+}
diff -puN fs/binfmt_elf.c~elf-coredump-replace-elf_core_extra_-macros-by-functions fs/binfmt_elf.c
--- a/fs/binfmt_elf.c~elf-coredump-replace-elf_core_extra_-macros-by-functions
+++ a/fs/binfmt_elf.c
@@ -1878,9 +1878,7 @@ static int elf_core_dump(struct coredump
 	 * Please check DEFAULT_MAX_MAP_COUNT definition when you modify here.
 	 */
 	segs = current->mm->map_count;
-#ifdef ELF_CORE_EXTRA_PHDRS
-	segs += ELF_CORE_EXTRA_PHDRS;
-#endif
+	segs += elf_core_extra_phdrs();
 
 	gate_vma = get_gate_vma(current);
 	if (gate_vma != NULL)
@@ -1958,9 +1956,8 @@ static int elf_core_dump(struct coredump
 			goto end_coredump;
 	}
 
-#ifdef ELF_CORE_WRITE_EXTRA_PHDRS
-	ELF_CORE_WRITE_EXTRA_PHDRS;
-#endif
+	if (!elf_core_write_extra_phdrs(cprm->file, offset, &size, cprm->limit))
+		goto end_coredump;
 
  	/* write out the notes section */
 	if (!write_note_info(&info, cprm->file, &foffset))
@@ -1999,9 +1996,8 @@ static int elf_core_dump(struct coredump
 		}
 	}
 
-#ifdef ELF_CORE_WRITE_EXTRA_DATA
-	ELF_CORE_WRITE_EXTRA_DATA;
-#endif
+	if (!elf_core_write_extra_data(cprm->file, &size, cprm->limit))
+		goto end_coredump;
 
 end_coredump:
 	set_fs(fs);
diff -puN fs/binfmt_elf_fdpic.c~elf-coredump-replace-elf_core_extra_-macros-by-functions fs/binfmt_elf_fdpic.c
--- a/fs/binfmt_elf_fdpic.c~elf-coredump-replace-elf_core_extra_-macros-by-functions
+++ a/fs/binfmt_elf_fdpic.c
@@ -1664,9 +1664,7 @@ static int elf_fdpic_core_dump(struct co
 	elf_core_copy_regs(&prstatus->pr_reg, cprm->regs);
 
 	segs = current->mm->map_count;
-#ifdef ELF_CORE_EXTRA_PHDRS
-	segs += ELF_CORE_EXTRA_PHDRS;
-#endif
+	segs += elf_core_extra_phdrs();
 
 	/* Set up header */
 	fill_elf_fdpic_header(elf, segs + 1);	/* including notes section */
@@ -1773,9 +1771,8 @@ static int elf_fdpic_core_dump(struct co
 			goto end_coredump;
 	}
 
-#ifdef ELF_CORE_WRITE_EXTRA_PHDRS
-	ELF_CORE_WRITE_EXTRA_PHDRS;
-#endif
+	if (!elf_core_write_extra_phdrs(cprm->file, offset, &size, cprm->limit))
+		goto end_coredump;
 
  	/* write out the notes section */
 	for (i = 0; i < numnote; i++)
@@ -1799,9 +1796,8 @@ static int elf_fdpic_core_dump(struct co
 				    mm_flags) < 0)
 		goto end_coredump;
 
-#ifdef ELF_CORE_WRITE_EXTRA_DATA
-	ELF_CORE_WRITE_EXTRA_DATA;
-#endif
+	if (!elf_core_write_extra_data(cprm->file, &size, cprm->limit))
+		goto end_coredump;
 
 	if (cprm->file->f_pos != offset) {
 		/* Sanity check */
diff -puN fs/compat_binfmt_elf.c~elf-coredump-replace-elf_core_extra_-macros-by-functions fs/compat_binfmt_elf.c
--- a/fs/compat_binfmt_elf.c~elf-coredump-replace-elf_core_extra_-macros-by-functions
+++ a/fs/compat_binfmt_elf.c
@@ -28,10 +28,12 @@
 
 #undef	elfhdr
 #undef	elf_phdr
+#undef	elf_shdr
 #undef	elf_note
 #undef	elf_addr_t
 #define elfhdr		elf32_hdr
 #define elf_phdr	elf32_phdr
+#define elf_shdr	elf32_shdr
 #define elf_note	elf32_note
 #define elf_addr_t	Elf32_Addr
 
diff -puN include/linux/elf.h~elf-coredump-replace-elf_core_extra_-macros-by-functions include/linux/elf.h
--- a/include/linux/elf.h~elf-coredump-replace-elf_core_extra_-macros-by-functions
+++ a/include/linux/elf.h
@@ -396,6 +396,7 @@ extern Elf32_Dyn _DYNAMIC [];
 #define elf_phdr	elf32_phdr
 #define elf_note	elf32_note
 #define elf_addr_t	Elf32_Off
+#define Elf_Half	Elf32_Half
 
 #else
 
@@ -404,6 +405,7 @@ extern Elf64_Dyn _DYNAMIC [];
 #define elf_phdr	elf64_phdr
 #define elf_note	elf64_note
 #define elf_addr_t	Elf64_Off
+#define Elf_Half	Elf64_Half
 
 #endif
 
diff -puN include/linux/elfcore.h~elf-coredump-replace-elf_core_extra_-macros-by-functions include/linux/elfcore.h
--- a/include/linux/elfcore.h~elf-coredump-replace-elf_core_extra_-macros-by-functions
+++ a/include/linux/elfcore.h
@@ -8,6 +8,8 @@
 #include <linux/user.h>
 #endif
 #include <linux/ptrace.h>
+#include <linux/elf.h>
+#include <linux/fs.h>
 
 struct elf_siginfo
 {
@@ -150,5 +152,19 @@ static inline int elf_core_copy_task_xfp
 
 #endif /* __KERNEL__ */
 
+/*
+ * These functions parameterize elf_core_dump in fs/binfmt_elf.c to write out
+ * extra segments containing the gate DSO contents.  Dumping its
+ * contents makes post-mortem fully interpretable later without matching up
+ * the same kernel and hardware config to see what PC values meant.
+ * Dumping its extra ELF program headers includes all the other information
+ * a debugger needs to easily find how the gate DSO was being used.
+ */
+extern Elf_Half elf_core_extra_phdrs(void);
+extern int
+elf_core_write_extra_phdrs(struct file *file, loff_t offset, size_t *size,
+			   unsigned long limit);
+extern int
+elf_core_write_extra_data(struct file *file, size_t *size, unsigned long limit);
 
 #endif /* _LINUX_ELFCORE_H */
diff -puN kernel/Makefile~elf-coredump-replace-elf_core_extra_-macros-by-functions kernel/Makefile
--- a/kernel/Makefile~elf-coredump-replace-elf_core_extra_-macros-by-functions
+++ a/kernel/Makefile
@@ -91,6 +91,9 @@ obj-$(CONFIG_TASK_DELAY_ACCT) += delayac
 obj-$(CONFIG_TASKSTATS) += taskstats.o tsacct.o
 obj-$(CONFIG_TRACEPOINTS) += tracepoint.o
 obj-$(CONFIG_LATENCYTOP) += latencytop.o
+obj-$(CONFIG_BINFMT_ELF) += elfcore.o
+obj-$(CONFIG_COMPAT_BINFMT_ELF) += elfcore.o
+obj-$(CONFIG_BINFMT_ELF_FDPIC) += elfcore.o
 obj-$(CONFIG_FUNCTION_TRACER) += trace/
 obj-$(CONFIG_TRACING) += trace/
 obj-$(CONFIG_X86_DS) += trace/
diff -puN /dev/null kernel/elfcore.c
--- /dev/null
+++ a/kernel/elfcore.c
@@ -0,0 +1,23 @@
+#include <linux/elf.h>
+#include <linux/fs.h>
+#include <linux/mm.h>
+
+#include <asm/elf.h>
+
+
+Elf_Half __weak elf_core_extra_phdrs(void)
+{
+	return 0;
+}
+
+int __weak elf_core_write_extra_phdrs(struct file *file, loff_t offset, size_t *size,
+				      unsigned long limit)
+{
+	return 1;
+}
+
+int __weak elf_core_write_extra_data(struct file *file, size_t *size,
+				     unsigned long limit)
+{
+	return 1;
+}
_

Patches currently in -mm which might be from d.hatayama@jp.fujitsu.com are


