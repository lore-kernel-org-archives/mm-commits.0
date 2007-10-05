From: akpm@linux-foundation.org
Subject: + increase-at_vector_size-to-terminate-saved_auxv-properly-updates.patch added to -mm tree
Date: Fri, 05 Oct 2007 16:54:32 -0700
Message-ID: <200710052354.l95NsW0E031394@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44157 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761390AbXJEXym (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Oct 2007 19:54:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: olaf@aepfle.de, tony.luck@intel.com


The patch titled
     increase-at_vector_size-to-terminate-saved_auxv-properly updates
has been added to the -mm tree.  Its filename is
     increase-at_vector_size-to-terminate-saved_auxv-properly-updates.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: increase-at_vector_size-to-terminate-saved_auxv-properly updates
From: Olaf Hering <olaf@aepfle.de>

On Wed, Sep 26, Luck, Tony wrote:

> +#define AT_VECTOR_SIZE_BASE  (14 + 2) /* generic entries in auxiliary table. */
>
> It might be nice to add a more descriptive comment here saying that
> the "14" and the "2" come from the number of NEW_AUX_ENT() insertions
> in fs/binfmt_elf.c.  Perhaps even more important would be an extra
> comment in fs/binfmt_elf.c pointing out that AT_VECTOR_SIZE_BASE needs
> to be changed if the number of NEW_AUX_ENT() calls changes.
>
> Similarly adding AT_VECTOR_SIZE_ARCH definition to asm/system.h is quite
> far away from the code that constrains the value (ARCH_DLINFO definition
> in <asm/elf.h>).  If it is hard to move this definition next to the code
> that requires it, then some more comments are needed to point out the
> dependency.

See the update for 2.6.23-rc8-mm2 below.
Is this acceptable for you?

> And/or add a BUG_ON() just before the memset() in fs/binfmt_elf.c that
> checks there are at least the two entries for the AT_NULL entry available
> in saved_auxv?

I'm not sure if this is needed. In the worst case, the app may crash.
No need to bring down the entire system.

Signed-off-by: Olaf Hering <olaf@aepfle.de>
Acked-by: Tony Luck <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN fs/binfmt_elf.c~increase-at_vector_size-to-terminate-saved_auxv-properly-updates fs/binfmt_elf.c
--- a/fs/binfmt_elf.c~increase-at_vector_size-to-terminate-saved_auxv-properly-updates
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
diff -puN include/asm-alpha/elf.h~increase-at_vector_size-to-terminate-saved_auxv-properly-updates include/asm-alpha/elf.h
--- a/include/asm-alpha/elf.h~increase-at_vector_size-to-terminate-saved_auxv-properly-updates
+++ a/include/asm-alpha/elf.h
@@ -155,6 +155,7 @@ extern int alpha_l1d_cacheshape;
 extern int alpha_l2_cacheshape;
 extern int alpha_l3_cacheshape;
 
+/* update AT_VECTOR_SIZE_ARCH if the number of NEW_AUX_ENT entries changes */
 #define ARCH_DLINFO						\
   do {								\
     NEW_AUX_ENT(AT_L1I_CACHESHAPE, alpha_l1i_cacheshape);	\
diff -puN include/asm-alpha/system.h~increase-at_vector_size-to-terminate-saved_auxv-properly-updates include/asm-alpha/system.h
--- a/include/asm-alpha/system.h~increase-at_vector_size-to-terminate-saved_auxv-properly-updates
+++ a/include/asm-alpha/system.h
@@ -48,7 +48,7 @@
 
 #ifndef __ASSEMBLY__
 #include <linux/kernel.h>
-#define AT_VECTOR_SIZE_ARCH 4
+#define AT_VECTOR_SIZE_ARCH 4 /* entries in ARCH_DLINFO */
 
 /*
  * This is the logout header that should be common to all platforms
diff -puN include/asm-i386/elf.h~increase-at_vector_size-to-terminate-saved_auxv-properly-updates include/asm-i386/elf.h
--- a/include/asm-i386/elf.h~increase-at_vector_size-to-terminate-saved_auxv-properly-updates
+++ a/include/asm-i386/elf.h
@@ -152,6 +152,7 @@ extern int arch_setup_additional_pages(s
 
 extern unsigned int vdso_enabled;
 
+/* update AT_VECTOR_SIZE_ARCH if the number of NEW_AUX_ENT entries changes */
 #define ARCH_DLINFO							\
 do if (vdso_enabled) {							\
 		NEW_AUX_ENT(AT_SYSINFO,	VDSO_ENTRY);			\
diff -puN include/asm-i386/system.h~increase-at_vector_size-to-terminate-saved_auxv-properly-updates include/asm-i386/system.h
--- a/include/asm-i386/system.h~increase-at_vector_size-to-terminate-saved_auxv-properly-updates
+++ a/include/asm-i386/system.h
@@ -7,7 +7,7 @@
 #include <asm/cmpxchg.h>
 
 #ifdef __KERNEL__
-#define AT_VECTOR_SIZE_ARCH 2
+#define AT_VECTOR_SIZE_ARCH 2 /* entries in ARCH_DLINFO */
 
 struct task_struct;	/* one of the stranger aspects of C forward declarations.. */
 extern struct task_struct * FASTCALL(__switch_to(struct task_struct *prev, struct task_struct *next));
diff -puN include/asm-ia64/elf.h~increase-at_vector_size-to-terminate-saved_auxv-properly-updates include/asm-ia64/elf.h
--- a/include/asm-ia64/elf.h~increase-at_vector_size-to-terminate-saved_auxv-properly-updates
+++ a/include/asm-ia64/elf.h
@@ -192,6 +192,7 @@ extern int dump_task_fpu (struct task_st
 
 #define GATE_EHDR	((const struct elfhdr *) GATE_ADDR)
 
+/* update AT_VECTOR_SIZE_ARCH if the number of NEW_AUX_ENT entries changes */
 #define ARCH_DLINFO								\
 do {										\
 	extern char __kernel_syscall_via_epc[];					\
diff -puN include/asm-ia64/system.h~increase-at_vector_size-to-terminate-saved_auxv-properly-updates include/asm-ia64/system.h
--- a/include/asm-ia64/system.h~increase-at_vector_size-to-terminate-saved_auxv-properly-updates
+++ a/include/asm-ia64/system.h
@@ -32,7 +32,7 @@
 #include <linux/kernel.h>
 #include <linux/types.h>
 
-#define AT_VECTOR_SIZE_ARCH 2
+#define AT_VECTOR_SIZE_ARCH 2 /* entries in ARCH_DLINFO */
 
 struct pci_vector_struct {
 	__u16 segment;	/* PCI Segment number */
diff -puN include/asm-powerpc/elf.h~increase-at_vector_size-to-terminate-saved_auxv-properly-updates include/asm-powerpc/elf.h
--- a/include/asm-powerpc/elf.h~increase-at_vector_size-to-terminate-saved_auxv-properly-updates
+++ a/include/asm-powerpc/elf.h
@@ -283,6 +283,7 @@ extern int arch_setup_additional_pages(s
  *   AT_IGNOREPPC is used for that.
  * - for compatibility with glibc ARCH_DLINFO must always be defined on PPC,
  *   even if DLINFO_ARCH_ITEMS goes to zero or is undefined.
+ * update AT_VECTOR_SIZE_ARCH if the number of NEW_AUX_ENT entries changes
  */
 #define ARCH_DLINFO							\
 do {									\
diff -puN include/asm-powerpc/system.h~increase-at_vector_size-to-terminate-saved_auxv-properly-updates include/asm-powerpc/system.h
--- a/include/asm-powerpc/system.h~increase-at_vector_size-to-terminate-saved_auxv-properly-updates
+++ a/include/asm-powerpc/system.h
@@ -40,7 +40,7 @@
 #define set_mb(var, value)	do { var = value; mb(); } while (0)
 
 #ifdef __KERNEL__
-#define AT_VECTOR_SIZE_ARCH 6
+#define AT_VECTOR_SIZE_ARCH 6 /* entries in ARCH_DLINFO */
 #ifdef CONFIG_SMP
 #define smp_mb()	mb()
 #define smp_rmb()	rmb()
diff -puN include/asm-sh/elf.h~increase-at_vector_size-to-terminate-saved_auxv-properly-updates include/asm-sh/elf.h
--- a/include/asm-sh/elf.h~increase-at_vector_size-to-terminate-saved_auxv-properly-updates
+++ a/include/asm-sh/elf.h
@@ -133,6 +133,7 @@ extern void __kernel_vsyscall;
 #define VDSO_BASE		((unsigned long)current->mm->context.vdso)
 #define VDSO_SYM(x)		(VDSO_BASE + (unsigned long)(x))
 
+/* update AT_VECTOR_SIZE_ARCH if the number of NEW_AUX_ENT entries changes */
 #define ARCH_DLINFO						\
 do {								\
 	if (vdso_enabled)					\
diff -puN include/asm-sh/system.h~increase-at_vector_size-to-terminate-saved_auxv-properly-updates include/asm-sh/system.h
--- a/include/asm-sh/system.h~increase-at_vector_size-to-terminate-saved_auxv-properly-updates
+++ a/include/asm-sh/system.h
@@ -15,7 +15,7 @@
 struct task_struct *__switch_to(struct task_struct *prev,
 				struct task_struct *next);
 
-#define AT_VECTOR_SIZE_ARCH 1
+#define AT_VECTOR_SIZE_ARCH 1 /* entries in ARCH_DLINFO */
 /*
  *	switch_to() should switch tasks to task nr n, first
  */
diff -puN include/linux/auxvec.h~increase-at_vector_size-to-terminate-saved_auxv-properly-updates include/linux/auxvec.h
--- a/include/linux/auxvec.h~increase-at_vector_size-to-terminate-saved_auxv-properly-updates
+++ a/include/linux/auxvec.h
@@ -27,7 +27,7 @@
 #define AT_SECURE 23   /* secure mode boolean */
 
 #ifdef __KERNEL__
-#define AT_VECTOR_SIZE_BASE  (14 + 2) /* generic entries in auxiliary table. */
+#define AT_VECTOR_SIZE_BASE (14 + 2) /* NEW_AUX_ENT entries in auxiliary table */
 #endif
 
 #endif /* _LINUX_AUXVEC_H */
_

Patches currently in -mm which might be from olaf@aepfle.de are

git-powerpc.patch
git-net.patch
unexport-asm-shmparamh.patch
remove-consolemaph-from-header-exports.patch
include-linux-typesh-in-if_fddih.patch
increase-at_vector_size-to-terminate-saved_auxv-properly.patch
increase-at_vector_size-to-terminate-saved_auxv-properly-updates.patch
keep-track-of-network-interface-renaming.patch
