From: akpm@linux-foundation.org
Subject: + cleanup-asm-elfpageuserh-ifdef-__kernel__-is-no-longer-needed-fix.patch added to -mm tree
Date: Fri, 09 Nov 2007 14:37:30 -0800
Message-ID: <200711092237.lA9MbURv002728@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50934 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752125AbXKIWhr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 9 Nov 2007 17:37:47 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: k.shutemov@gmail.com, dwmw2@infradead.org, linux-arch@vger.kernel.org


The patch titled
     Cleanup asm/{elf,page,user}.h: #ifdef __KERNEL__ is no longer needed (fix)
has been added to the -mm tree.  Its filename is
     cleanup-asm-elfpageuserh-ifdef-__kernel__-is-no-longer-needed-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Cleanup asm/{elf,page,user}.h: #ifdef __KERNEL__ is no longer needed (fix)
From: "Kirill A. Shutemov" <k.shutemov@gmail.com>

asm/elf.h, asm/page.h and asm/user.h don't export to userspace now, so
we can drop #ifdef __KERNEL__ for them.

Signed-off-by: Kirill A. Shutemov <k.shutemov@gmail.com>
CcDavid Woodhouse <dwmw2@infradead.org>
Cc: <linux-arch@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-powerpc/elf.h |    9 +++++++++
 1 file changed, 9 insertions(+)

diff -puN include/asm-powerpc/elf.h~cleanup-asm-elfpageuserh-ifdef-__kernel__-is-no-longer-needed-fix include/asm-powerpc/elf.h
--- a/include/asm-powerpc/elf.h~cleanup-asm-elfpageuserh-ifdef-__kernel__-is-no-longer-needed-fix
+++ a/include/asm-powerpc/elf.h
@@ -1,9 +1,11 @@
 #ifndef _ASM_POWERPC_ELF_H
 #define _ASM_POWERPC_ELF_H
 
+#ifdef __KERNEL__
 #include <linux/sched.h>	/* for task_struct */
 #include <asm/page.h>
 #include <asm/string.h>
+#endif
 
 #include <asm/types.h>
 #include <asm/ptrace.h>
@@ -158,6 +160,7 @@ typedef elf_vrreg_t elf_vrregset_t[ELF_N
 typedef elf_vrreg_t elf_vrregset_t32[ELF_NVRREG32];
 #endif
 
+#ifdef __KERNEL__
 /*
  * This is used to ensure we don't load something for the wrong architecture.
  */
@@ -219,6 +222,8 @@ extern int dump_task_altivec(struct task
 #define ELF_CORE_XFPREG_TYPE NT_PPC_VMX
 #endif
 
+#endif /* __KERNEL__ */
+
 /* ELF_HWCAP yields a mask that user programs can use to figure out what
    instruction set this cpu supports.  This could be done in userspace,
    but it's not easy, and we've already done it here.  */
@@ -236,6 +241,8 @@ extern int dump_task_altivec(struct task
 } while (0)
 #endif /* __powerpc64__ */
 
+#ifdef __KERNEL__
+
 #ifdef __powerpc64__
 # define SET_PERSONALITY(ex, ibcs2)				\
 do {								\
@@ -263,6 +270,8 @@ do {								\
 # define SET_PERSONALITY(ex, ibcs2) set_personality((ibcs2)?PER_SVR4:PER_LINUX)
 #endif /* __powerpc64__ */
 
+#endif /* __KERNEL__ */
+
 extern int dcache_bsize;
 extern int icache_bsize;
 extern int ucache_bsize;
_

Patches currently in -mm which might be from k.shutemov@gmail.com are

unexport-asm-userh-and-linux-userh.patch
cleanup-asm-elfpageuserh-ifdef-__kernel__-is-no-longer-needed.patch
cleanup-asm-elfpageuserh-ifdef-__kernel__-is-no-longer-needed-fix.patch
