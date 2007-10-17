From: akpm@linux-foundation.org
Subject: - increase-at_vector_size-to-terminate-saved_auxv-properly.patch removed from -mm tree
Date: Wed, 17 Oct 2007 02:56:24 -0700
Message-ID: <200710170956.l9H9uOSD014961@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54168 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755081AbXJQJ52 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 17 Oct 2007 05:57:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: olaf@aepfle.de, benh@kernel.crashing.org, ink@jurassic.park.msu.ru, jakub@redhat.com, lethal@linux-sh.org, olh@suse.de, paulus@samba.org, roland@redhat.com, rth@twiddle.net, tony.luck


The patch titled
     increase AT_VECTOR_SIZE to terminate saved_auxv properly
has been removed from the -mm tree.  Its filename was
     increase-at_vector_size-to-terminate-saved_auxv-properly.patch

This patch was dropped because it is obsolete

------------------------------------------------------
Subject: increase AT_VECTOR_SIZE to terminate saved_auxv properly
From: Olaf Hering <olaf@aepfle.de>

include/asm-powerpc/elf.h has 6 entries in ARCH_DLINFO.  fs/binfmt_elf.c
has 14 unconditional NEW_AUX_ENT entries and 2 conditional NEW_AUX_ENT
entries.  So in the worst case, saved_auxv does not get an AT_NULL entry at
the end.

The saved_auxv array must be terminated with an AT_NULL entry.  Make the
size of mm_struct->saved_auxv arch dependend, based on the number of
ARCH_DLINFO entries.

Signed-off-by: Olaf Hering <olh@suse.de>
Cc: Roland McGrath <roland@redhat.com>
Cc: Jakub Jelinek <jakub@redhat.com>
Cc: Richard Henderson <rth@twiddle.net>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: "Luck, Tony" <tony.luck@intel.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Paul Mundt <lethal@linux-sh.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/binfmt_elf.c              |    3 +++
 include/asm-alpha/elf.h      |    1 +
 include/asm-alpha/system.h   |    1 +
 include/asm-ia64/elf.h       |    1 +
 include/asm-ia64/system.h    |    2 ++
 include/asm-powerpc/elf.h    |    1 +
 include/asm-powerpc/system.h |    1 +
 include/asm-sh/elf.h         |    1 +
 include/asm-sh/system.h      |    1 +
 include/asm-x86/elf_32.h     |    1 +
 include/asm-x86/system_32.h  |    1 +
 include/linux/auxvec.h       |    4 +++-
 include/linux/elf.h          |    1 -
 include/linux/mm_types.h     |    7 ++++++-
 14 files changed, 23 insertions(+), 3 deletions(-)

diff -puN fs/binfmt_elf.c~increase-at_vector_size-to-terminate-saved_auxv-properly fs/binfmt_elf.c
--- a/fs/binfmt_elf.c~increase-at_vector_size-to-terminate-saved_auxv-properly
+++ a/fs/binfmt_elf.c
@@ -175,6 +175,7 @@ create_elf_tables(struct linux_binprm *b
 
 	/* Create the ELF interpreter info */
 	elf_info = (elf_addr_t *)current->mm->saved_auxv;
+	/* update AT_VECTOR_SIZE_BASE if the number of NEW_AUX_ENT() changes */
 #define NEW_AUX_ENT(id, val) \
 	do { \
 		elf_info[ei_index++] = id; \
@@ -185,6 +186,8 @@ create_elf_tables(struct linux_binprm *b
 	/* 
 	 * ARCH_DLINFO must come first so PPC can do its special alignment of
 	 * AUXV.
+	 * update AT_VECTOR_SIZE_ARCH if the number of NEW_AUX_ENT() in
+	 * ARCH_DLINFO changes
 	 */
 	ARCH_DLINFO;
 #endif
diff -puN include/asm-alpha/elf.h~increase-at_vector_size-to-terminate-saved_auxv-properly include/asm-alpha/elf.h
--- a/include/asm-alpha/elf.h~increase-at_vector_size-to-terminate-saved_auxv-properly
+++ a/include/asm-alpha/elf.h
@@ -155,6 +155,7 @@ extern int alpha_l1d_cacheshape;
 extern int alpha_l2_cacheshape;
 extern int alpha_l3_cacheshape;
 
+/* update AT_VECTOR_SIZE_ARCH if the number of NEW_AUX_ENT entries changes */
 #define ARCH_DLINFO						\
   do {								\
     NEW_AUX_ENT(AT_L1I_CACHESHAPE, alpha_l1i_cacheshape);	\
diff -puN include/asm-alpha/system.h~increase-at_vector_size-to-terminate-saved_auxv-properly include/asm-alpha/system.h
--- a/include/asm-alpha/system.h~increase-at_vector_size-to-terminate-saved_auxv-properly
+++ a/include/asm-alpha/system.h
@@ -48,6 +48,7 @@
 
 #ifndef __ASSEMBLY__
 #include <linux/kernel.h>
+#define AT_VECTOR_SIZE_ARCH 4 /* entries in ARCH_DLINFO */
 
 /*
  * This is the logout header that should be common to all platforms
diff -puN include/asm-ia64/elf.h~increase-at_vector_size-to-terminate-saved_auxv-properly include/asm-ia64/elf.h
--- a/include/asm-ia64/elf.h~increase-at_vector_size-to-terminate-saved_auxv-properly
+++ a/include/asm-ia64/elf.h
@@ -192,6 +192,7 @@ extern int dump_task_fpu (struct task_st
 
 #define GATE_EHDR	((const struct elfhdr *) GATE_ADDR)
 
+/* update AT_VECTOR_SIZE_ARCH if the number of NEW_AUX_ENT entries changes */
 #define ARCH_DLINFO								\
 do {										\
 	extern char __kernel_syscall_via_epc[];					\
diff -puN include/asm-ia64/system.h~increase-at_vector_size-to-terminate-saved_auxv-properly include/asm-ia64/system.h
--- a/include/asm-ia64/system.h~increase-at_vector_size-to-terminate-saved_auxv-properly
+++ a/include/asm-ia64/system.h
@@ -32,6 +32,8 @@
 #include <linux/kernel.h>
 #include <linux/types.h>
 
+#define AT_VECTOR_SIZE_ARCH 2 /* entries in ARCH_DLINFO */
+
 struct pci_vector_struct {
 	__u16 segment;	/* PCI Segment number */
 	__u16 bus;	/* PCI Bus number */
diff -puN include/asm-powerpc/elf.h~increase-at_vector_size-to-terminate-saved_auxv-properly include/asm-powerpc/elf.h
--- a/include/asm-powerpc/elf.h~increase-at_vector_size-to-terminate-saved_auxv-properly
+++ a/include/asm-powerpc/elf.h
@@ -291,6 +291,7 @@ extern int arch_setup_additional_pages(s
  *   AT_IGNOREPPC is used for that.
  * - for compatibility with glibc ARCH_DLINFO must always be defined on PPC,
  *   even if DLINFO_ARCH_ITEMS goes to zero or is undefined.
+ * update AT_VECTOR_SIZE_ARCH if the number of NEW_AUX_ENT entries changes
  */
 #define ARCH_DLINFO							\
 do {									\
diff -puN include/asm-powerpc/system.h~increase-at_vector_size-to-terminate-saved_auxv-properly include/asm-powerpc/system.h
--- a/include/asm-powerpc/system.h~increase-at_vector_size-to-terminate-saved_auxv-properly
+++ a/include/asm-powerpc/system.h
@@ -40,6 +40,7 @@
 #define set_mb(var, value)	do { var = value; mb(); } while (0)
 
 #ifdef __KERNEL__
+#define AT_VECTOR_SIZE_ARCH 6 /* entries in ARCH_DLINFO */
 #ifdef CONFIG_SMP
 #define smp_mb()	mb()
 #define smp_rmb()	rmb()
diff -puN include/asm-sh/elf.h~increase-at_vector_size-to-terminate-saved_auxv-properly include/asm-sh/elf.h
--- a/include/asm-sh/elf.h~increase-at_vector_size-to-terminate-saved_auxv-properly
+++ a/include/asm-sh/elf.h
@@ -133,6 +133,7 @@ extern void __kernel_vsyscall;
 #define VDSO_BASE		((unsigned long)current->mm->context.vdso)
 #define VDSO_SYM(x)		(VDSO_BASE + (unsigned long)(x))
 
+/* update AT_VECTOR_SIZE_ARCH if the number of NEW_AUX_ENT entries changes */
 #define ARCH_DLINFO						\
 do {								\
 	if (vdso_enabled)					\
diff -puN include/asm-sh/system.h~increase-at_vector_size-to-terminate-saved_auxv-properly include/asm-sh/system.h
--- a/include/asm-sh/system.h~increase-at_vector_size-to-terminate-saved_auxv-properly
+++ a/include/asm-sh/system.h
@@ -15,6 +15,7 @@
 struct task_struct *__switch_to(struct task_struct *prev,
 				struct task_struct *next);
 
+#define AT_VECTOR_SIZE_ARCH 1 /* entries in ARCH_DLINFO */
 /*
  *	switch_to() should switch tasks to task nr n, first
  */
diff -puN include/asm-x86/elf_32.h~increase-at_vector_size-to-terminate-saved_auxv-properly include/asm-x86/elf_32.h
--- a/include/asm-x86/elf_32.h~increase-at_vector_size-to-terminate-saved_auxv-properly
+++ a/include/asm-x86/elf_32.h
@@ -153,6 +153,7 @@ extern int arch_setup_additional_pages(s
 
 extern unsigned int vdso_enabled;
 
+/* update AT_VECTOR_SIZE_ARCH if the number of NEW_AUX_ENT entries changes */
 #define ARCH_DLINFO							\
 do if (vdso_enabled) {							\
 		NEW_AUX_ENT(AT_SYSINFO,	VDSO_ENTRY);			\
diff -puN include/asm-x86/system_32.h~increase-at_vector_size-to-terminate-saved_auxv-properly include/asm-x86/system_32.h
--- a/include/asm-x86/system_32.h~increase-at_vector_size-to-terminate-saved_auxv-properly
+++ a/include/asm-x86/system_32.h
@@ -7,6 +7,7 @@
 #include <asm/cmpxchg.h>
 
 #ifdef __KERNEL__
+#define AT_VECTOR_SIZE_ARCH 2 /* entries in ARCH_DLINFO */
 
 struct task_struct;	/* one of the stranger aspects of C forward declarations.. */
 extern struct task_struct * FASTCALL(__switch_to(struct task_struct *prev, struct task_struct *next));
diff -puN include/linux/auxvec.h~increase-at_vector_size-to-terminate-saved_auxv-properly include/linux/auxvec.h
--- a/include/linux/auxvec.h~increase-at_vector_size-to-terminate-saved_auxv-properly
+++ a/include/linux/auxvec.h
@@ -26,6 +26,8 @@
 
 #define AT_SECURE 23   /* secure mode boolean */
 
-#define AT_VECTOR_SIZE  44 /* Size of auxiliary table.  */
+#ifdef __KERNEL__
+#define AT_VECTOR_SIZE_BASE (14 + 2) /* NEW_AUX_ENT entries in auxiliary table */
+#endif
 
 #endif /* _LINUX_AUXVEC_H */
diff -puN include/linux/elf.h~increase-at_vector_size-to-terminate-saved_auxv-properly include/linux/elf.h
--- a/include/linux/elf.h~increase-at_vector_size-to-terminate-saved_auxv-properly
+++ a/include/linux/elf.h
@@ -2,7 +2,6 @@
 #define _LINUX_ELF_H
 
 #include <linux/types.h>
-#include <linux/auxvec.h>
 #include <linux/elf-em.h>
 #include <asm/elf.h>
 
diff -puN include/linux/mm_types.h~increase-at_vector_size-to-terminate-saved_auxv-properly include/linux/mm_types.h
--- a/include/linux/mm_types.h~increase-at_vector_size-to-terminate-saved_auxv-properly
+++ a/include/linux/mm_types.h
@@ -1,7 +1,7 @@
 #ifndef _LINUX_MM_TYPES_H
 #define _LINUX_MM_TYPES_H
 
-#include <linux/auxvec.h>	/* For AT_VECTOR_SIZE */
+#include <linux/auxvec.h>
 #include <linux/types.h>
 #include <linux/threads.h>
 #include <linux/list.h>
@@ -13,6 +13,11 @@
 #include <asm/page.h>
 #include <asm/mmu.h>
 
+#ifndef AT_VECTOR_SIZE_ARCH
+#define AT_VECTOR_SIZE_ARCH 0
+#endif
+#define AT_VECTOR_SIZE (2*(AT_VECTOR_SIZE_ARCH + AT_VECTOR_SIZE_BASE + 1))
+
 struct address_space;
 
 #if NR_CPUS >= CONFIG_SPLIT_PTLOCK_CPUS
_

Patches currently in -mm which might be from olaf@aepfle.de are

origin.patch
unexport-asm-shmparamh.patch
remove-consolemaph-from-header-exports.patch
include-linux-typesh-in-if_fddih.patch
increase-at_vector_size-to-terminate-saved_auxv-properly.patch
keep-track-of-network-interface-renaming.patch
