From: akpm@linux-foundation.org
Subject: + make-aout-executables-work-again.patch added to -mm tree
Date: Fri, 09 Feb 2007 20:21:28 -0800
Message-ID: <200702100421.l1A4LSd7003418@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:35569 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753018AbXBJEVz (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 9 Feb 2007 23:21:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: parag.warudkar@gmail.com, ak@suse.de, benh@kernel.crashing.org, joerg@hydrops.han.de, lethal@linux-sh.org, paulus@samba.org


The patch titled
     Make aout executables work again
has been added to the -mm tree.  Its filename is
     make-aout-executables-work-again.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Make aout executables work again
From: Parag Warudkar <parag.warudkar@gmail.com>

Fix http://bugzilla.kernel.org/show_bug.cgi?id=7891

  "In kernel 2.6.18 the vdso page is no longer mapped for a.out binaries. 
   For instance a program using sleep will sigsegv on delivery of SIGALRM (to
   be precise: on return from signal handling).  I tested this using a static
   a.out binary.  This program does work in 2.6.17 .  

   cat /proc/pid/smaps does show that vdso is not mapped in 2.6.18 for an
   a.out binary.  I had a look at fs/binfmt_elf.c and found that the vdso
   pages is mapped using arch_setup_additional_pages from
   arch/i386/kernel/sysenter.c for elf."


1) Define arch_setup_additional_pages() as weak in linux/interp.h

2) Include linux/interp.h in appropriate places

3) Conditionally call arch_setup_additional_pages() from binfmt_*.c if
   the arch defines it

4) EXPORT_SYMBOL_GPL(arch_setup_additional_pages) for all x86{64},
   powerpc, sh - binfmt_aout can be built as module

5) Get rid of ARCH_HAS_SETUP_ADDITIONAL_PAGES from various places

6) For x86_64 - define and export arch_setup_additional_pages as a
   wrapper over syscall32_setup_pages, call it from ia32_aout.c

Fully tested on x86. (Compile, boot and run the aout binary at
http://ftp.funet.fi/pub/Linux/bin/as86.tar.Z). Other arches - changes are
minimal but still I'll appreciate if someone tests them.

Signed-off-by: Parag Warudkar <parag.warudkar@gmail.com>
Cc: Joerg Ahrens <joerg@hydrops.han.de>
Cc: Andi Kleen <ak@suse.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mundt <lethal@linux-sh.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/sysenter.c        |    1 +
 arch/powerpc/kernel/vdso.c         |    1 +
 arch/sh/kernel/vsyscall/vsyscall.c |    1 +
 arch/x86_64/ia32/ia32_aout.c       |    7 +++++++
 arch/x86_64/ia32/ia32_binfmt.c     |    4 ----
 arch/x86_64/ia32/syscall32.c       |    6 ++++++
 fs/binfmt_aout.c                   |    9 +++++++++
 fs/binfmt_elf.c                    |   13 +++++++------
 include/linux/interp.h             |    8 ++++++++
 9 files changed, 40 insertions(+), 10 deletions(-)

diff -puN arch/i386/kernel/sysenter.c~make-aout-executables-work-again arch/i386/kernel/sysenter.c
--- a/arch/i386/kernel/sysenter.c~make-aout-executables-work-again
+++ a/arch/i386/kernel/sysenter.c
@@ -137,6 +137,7 @@ up_fail:
 	up_write(&mm->mmap_sem);
 	return ret;
 }
+EXPORT_SYMBOL_GPL(arch_setup_additional_pages);
 
 const char *arch_vma_name(struct vm_area_struct *vma)
 {
diff -puN arch/powerpc/kernel/vdso.c~make-aout-executables-work-again arch/powerpc/kernel/vdso.c
--- a/arch/powerpc/kernel/vdso.c~make-aout-executables-work-again
+++ a/arch/powerpc/kernel/vdso.c
@@ -254,6 +254,7 @@ int arch_setup_additional_pages(struct l
 	up_write(&mm->mmap_sem);
 	return rc;
 }
+EXPORT_SYMBOL_GPL(arch_setup_additional_pages);
 
 const char *arch_vma_name(struct vm_area_struct *vma)
 {
diff -puN arch/sh/kernel/vsyscall/vsyscall.c~make-aout-executables-work-again arch/sh/kernel/vsyscall/vsyscall.c
--- a/arch/sh/kernel/vsyscall/vsyscall.c~make-aout-executables-work-again
+++ a/arch/sh/kernel/vsyscall/vsyscall.c
@@ -85,6 +85,7 @@ up_fail:
 	up_write(&mm->mmap_sem);
 	return ret;
 }
+EXPORT_SYMBOL_GPL(arch_setup_additional_pages);
 
 const char *arch_vma_name(struct vm_area_struct *vma)
 {
diff -puN arch/x86_64/ia32/ia32_aout.c~make-aout-executables-work-again arch/x86_64/ia32/ia32_aout.c
--- a/arch/x86_64/ia32/ia32_aout.c~make-aout-executables-work-again
+++ a/arch/x86_64/ia32/ia32_aout.c
@@ -23,6 +23,7 @@
 #include <linux/user.h>
 #include <linux/slab.h>
 #include <linux/binfmts.h>
+#include <linux/interp.h>
 #include <linux/personality.h>
 #include <linux/init.h>
 
@@ -411,6 +412,12 @@ beyond_if:
 		return retval;
 	}
 
+	retval = arch_setup_additional_pages(bprm, EXSTACK_DEFAULT);
+	if (retval < 0) {
+		send_sig(SIGKILL, current, 0);
+		return retval;
+	}
+
 	current->mm->start_stack =
 		(unsigned long)create_aout_tables((char __user *)bprm->p, bprm);
 	/* start thread */
diff -puN arch/x86_64/ia32/ia32_binfmt.c~make-aout-executables-work-again arch/x86_64/ia32/ia32_binfmt.c
--- a/arch/x86_64/ia32/ia32_binfmt.c~make-aout-executables-work-again
+++ a/arch/x86_64/ia32/ia32_binfmt.c
@@ -258,10 +258,6 @@ MODULE_AUTHOR("Eric Youngdale, Andi Klee
 
 static void elf32_init(struct pt_regs *);
 
-#define ARCH_HAS_SETUP_ADDITIONAL_PAGES 1
-#define arch_setup_additional_pages syscall32_setup_pages
-extern int syscall32_setup_pages(struct linux_binprm *, int exstack);
-
 #include "../../../fs/binfmt_elf.c" 
 
 static void elf32_init(struct pt_regs *regs)
diff -puN arch/x86_64/ia32/syscall32.c~make-aout-executables-work-again arch/x86_64/ia32/syscall32.c
--- a/arch/x86_64/ia32/syscall32.c~make-aout-executables-work-again
+++ a/arch/x86_64/ia32/syscall32.c
@@ -48,6 +48,12 @@ int syscall32_setup_pages(struct linux_b
 	return ret;
 }
 
+int arch_setup_additional_pages(struct linux_binprm* bprm, int exstack)
+{
+	return syscall32_setup_pages(bprm, exstack);
+}
+EXPORT_SYMBOL_GPL(arch_setup_additional_pages);
+
 const char *arch_vma_name(struct vm_area_struct *vma)
 {
 	if (vma->vm_start == VSYSCALL32_BASE &&
diff -puN fs/binfmt_aout.c~make-aout-executables-work-again fs/binfmt_aout.c
--- a/fs/binfmt_aout.c~make-aout-executables-work-again
+++ a/fs/binfmt_aout.c
@@ -22,6 +22,7 @@
 #include <linux/user.h>
 #include <linux/slab.h>
 #include <linux/binfmts.h>
+#include <linux/interp.h>
 #include <linux/personality.h>
 #include <linux/init.h>
 
@@ -446,6 +447,14 @@ beyond_if:
 		return retval;
 	}
 
+	if(arch_setup_additional_pages) {
+		retval = arch_setup_additional_pages(bprm, EXSTACK_DEFAULT);
+		if (retval < 0) {
+			send_sig(SIGKILL, current, 0);
+			return retval;
+		}
+	}
+
 	current->mm->start_stack =
 		(unsigned long) create_aout_tables((char __user *) bprm->p, bprm);
 #ifdef __alpha__
diff -puN fs/binfmt_elf.c~make-aout-executables-work-again fs/binfmt_elf.c
--- a/fs/binfmt_elf.c~make-aout-executables-work-again
+++ a/fs/binfmt_elf.c
@@ -20,6 +20,7 @@
 #include <linux/errno.h>
 #include <linux/signal.h>
 #include <linux/binfmts.h>
+#include <linux/interp.h>
 #include <linux/string.h>
 #include <linux/file.h>
 #include <linux/fcntl.h>
@@ -974,13 +975,13 @@ static int load_elf_binary(struct linux_
 
 	set_binfmt(&elf_format);
 
-#ifdef ARCH_HAS_SETUP_ADDITIONAL_PAGES
-	retval = arch_setup_additional_pages(bprm, executable_stack);
-	if (retval < 0) {
-		send_sig(SIGKILL, current, 0);
-		goto out;
+	if (arch_setup_additional_pages) {
+		retval = arch_setup_additional_pages(bprm, executable_stack);
+		if (retval < 0) {
+			send_sig(SIGKILL, current, 0);
+			goto out;
+		}
 	}
-#endif /* ARCH_HAS_SETUP_ADDITIONAL_PAGES */
 
 	compute_creds(bprm);
 	current->flags &= ~PF_FORKNOEXEC;
diff -puN /dev/null include/linux/interp.h
--- /dev/null
+++ a/include/linux/interp.h
@@ -0,0 +1,8 @@
+#ifndef _LINUX_INTERP_H
+#define _LINUX_INTERP_H
+
+struct linux_binprm;
+
+extern int __attribute__((weak))
+	arch_setup_additional_pages(struct linux_binprm*, int);
+#endif /* _LINUX_INTERP_H */
_

Patches currently in -mm which might be from parag.warudkar@gmail.com are

make-aout-executables-work-again.patch
x86-fix-vdso-mapping-for-aout-executables.patch
