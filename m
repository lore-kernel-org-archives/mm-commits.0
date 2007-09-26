From: akpm@linux-foundation.org
Subject: + increase-at_vector_size-to-terminate-saved_auxv-properly.patch added to -mm tree
Date: Wed, 26 Sep 2007 13:25:14 -0700
Message-ID: <200709262025.l8QKPEpv002244@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58058 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753033AbXIZU0c (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 26 Sep 2007 16:26:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: olaf@aepfle.de, benh@kernel.crashing.org, ink@jurassic.park.msu.ru, jakub@redhat.com, lethal@linux-sh.org, olh@suse.de, paulus@samba.org, roland@redhat.com, rth@twiddle.net, tony.luck@intel.com


The patch titled
     increase AT_VECTOR_SIZE to terminate saved_auxv properly
has been added to the -mm tree.  Its filename is
     increase-at_vector_size-to-terminate-saved_auxv-properly.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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


diff -puN include/asm-alpha/system.h~increase-at_vector_size-to-terminate-saved_auxv-properly include/asm-alpha/system.h
--- a/include/asm-alpha/system.h~increase-at_vector_size-to-terminate-saved_auxv-properly
+++ a/include/asm-alpha/system.h
@@ -48,6 +48,7 @@
 
 #ifndef __ASSEMBLY__
 #include <linux/kernel.h>
+#define AT_VECTOR_SIZE_ARCH 4
 
 /*
  * This is the logout header that should be common to all platforms
diff -puN include/asm-i386/system.h~increase-at_vector_size-to-terminate-saved_auxv-properly include/asm-i386/system.h
--- a/include/asm-i386/system.h~increase-at_vector_size-to-terminate-saved_auxv-properly
+++ a/include/asm-i386/system.h
@@ -7,6 +7,7 @@
 #include <asm/cmpxchg.h>
 
 #ifdef __KERNEL__
+#define AT_VECTOR_SIZE_ARCH 2
 
 struct task_struct;	/* one of the stranger aspects of C forward declarations.. */
 extern struct task_struct * FASTCALL(__switch_to(struct task_struct *prev, struct task_struct *next));
diff -puN include/asm-ia64/system.h~increase-at_vector_size-to-terminate-saved_auxv-properly include/asm-ia64/system.h
--- a/include/asm-ia64/system.h~increase-at_vector_size-to-terminate-saved_auxv-properly
+++ a/include/asm-ia64/system.h
@@ -32,6 +32,8 @@
 #include <linux/kernel.h>
 #include <linux/types.h>
 
+#define AT_VECTOR_SIZE_ARCH 2
+
 struct pci_vector_struct {
 	__u16 segment;	/* PCI Segment number */
 	__u16 bus;	/* PCI Bus number */
diff -puN include/asm-powerpc/system.h~increase-at_vector_size-to-terminate-saved_auxv-properly include/asm-powerpc/system.h
--- a/include/asm-powerpc/system.h~increase-at_vector_size-to-terminate-saved_auxv-properly
+++ a/include/asm-powerpc/system.h
@@ -40,6 +40,7 @@
 #define set_mb(var, value)	do { var = value; mb(); } while (0)
 
 #ifdef __KERNEL__
+#define AT_VECTOR_SIZE_ARCH 6
 #ifdef CONFIG_SMP
 #define smp_mb()	mb()
 #define smp_rmb()	rmb()
diff -puN include/asm-sh/system.h~increase-at_vector_size-to-terminate-saved_auxv-properly include/asm-sh/system.h
--- a/include/asm-sh/system.h~increase-at_vector_size-to-terminate-saved_auxv-properly
+++ a/include/asm-sh/system.h
@@ -15,6 +15,7 @@
 struct task_struct *__switch_to(struct task_struct *prev,
 				struct task_struct *next);
 
+#define AT_VECTOR_SIZE_ARCH 1
 /*
  *	switch_to() should switch tasks to task nr n, first
  */
diff -puN include/linux/auxvec.h~increase-at_vector_size-to-terminate-saved_auxv-properly include/linux/auxvec.h
--- a/include/linux/auxvec.h~increase-at_vector_size-to-terminate-saved_auxv-properly
+++ a/include/linux/auxvec.h
@@ -26,6 +26,8 @@
 
 #define AT_SECURE 23   /* secure mode boolean */
 
-#define AT_VECTOR_SIZE  44 /* Size of auxiliary table.  */
+#ifdef __KERNEL__
+#define AT_VECTOR_SIZE_BASE  (14 + 2) /* generic entries in auxiliary table. */
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

git-powerpc.patch
git-net.patch
unexport-asm-shmparamh.patch
remove-consolemaph-from-header-exports.patch
include-linux-typesh-in-if_fddih.patch
increase-at_vector_size-to-terminate-saved_auxv-properly.patch
keep-track-of-network-interface-renaming.patch
