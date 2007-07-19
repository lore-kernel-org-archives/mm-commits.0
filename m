From: akpm@linux-foundation.org
Subject: + consolidate-ptrace_detach.patch added to -mm tree
Date: Thu, 19 Jul 2007 11:56:28 -0700
Message-ID: <200707191856.l6JIuSWE016772@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49201 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933884AbXGSTEG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Jul 2007 15:04:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: adobriyan@sw.ru, hch@infradead.org


The patch titled
     Consolidate PTRACE_DETACH
has been added to the -mm tree.  Its filename is
     consolidate-ptrace_detach.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Consolidate PTRACE_DETACH
From: Alexey Dobriyan <adobriyan@sw.ru>

Identical handlers of PTRACE_DETACH go into ptrace_request().
Not touching compat code.
Not touching archs that don't call ptrace_request.

Signed-off-by: Alexey Dobriyan <adobriyan@sw.ru>
Acked-by: Christoph Hellwig <hch@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/kernel/ptrace.c         |    4 ----
 arch/arm/kernel/ptrace.c           |    4 ----
 arch/arm26/kernel/ptrace.c         |    4 ----
 arch/avr32/kernel/ptrace.c         |    5 -----
 arch/blackfin/kernel/ptrace.c      |    6 ------
 arch/cris/arch-v10/kernel/ptrace.c |    4 ----
 arch/cris/arch-v32/kernel/ptrace.c |    4 ----
 arch/i386/kernel/ptrace.c          |    5 -----
 arch/m32r/kernel/ptrace.c          |    8 --------
 arch/m68k/kernel/ptrace.c          |    4 ----
 arch/mips/kernel/ptrace.c          |    4 ----
 arch/parisc/kernel/ptrace.c        |    4 ----
 arch/powerpc/kernel/ptrace.c       |    4 ----
 arch/s390/kernel/ptrace.c          |    5 -----
 arch/sh/kernel/ptrace.c            |    4 ----
 arch/sh64/kernel/ptrace.c          |    4 ----
 arch/um/kernel/ptrace.c            |    5 -----
 arch/x86_64/kernel/ptrace.c        |    5 -----
 arch/xtensa/kernel/ptrace.c        |    4 ----
 kernel/ptrace.c                    |    3 +++
 20 files changed, 3 insertions(+), 87 deletions(-)

diff -puN arch/alpha/kernel/ptrace.c~consolidate-ptrace_detach arch/alpha/kernel/ptrace.c
--- a/arch/alpha/kernel/ptrace.c~consolidate-ptrace_detach
+++ a/arch/alpha/kernel/ptrace.c
@@ -368,10 +368,6 @@ do_sys_ptrace(long request, long pid, lo
 		ret = 0;
 		goto out;
 
-	case PTRACE_DETACH:	 /* detach a process that was attached. */
-		ret = ptrace_detach(child, data);
-		goto out;
-
 	default:
 		ret = ptrace_request(child, request, addr, data);
 		goto out;
diff -puN arch/arm/kernel/ptrace.c~consolidate-ptrace_detach arch/arm/kernel/ptrace.c
--- a/arch/arm/kernel/ptrace.c~consolidate-ptrace_detach
+++ a/arch/arm/kernel/ptrace.c
@@ -731,10 +731,6 @@ long arch_ptrace(struct task_struct *chi
 			ret = 0;
 			break;
 
-		case PTRACE_DETACH:
-			ret = ptrace_detach(child, data);
-			break;
-
 		case PTRACE_GETREGS:
 			ret = ptrace_getregs(child, (void __user *)data);
 			break;
diff -puN arch/arm26/kernel/ptrace.c~consolidate-ptrace_detach arch/arm26/kernel/ptrace.c
--- a/arch/arm26/kernel/ptrace.c~consolidate-ptrace_detach
+++ a/arch/arm26/kernel/ptrace.c
@@ -609,10 +609,6 @@ long arch_ptrace(struct task_struct *chi
 			ret = 0;
 			break;
 
-		case PTRACE_DETACH:
-			ret = ptrace_detach(child, data);
-			break;
-
 		case PTRACE_GETREGS:
 			ret = ptrace_getregs(child, (void *)data);
 			break;
diff -puN arch/avr32/kernel/ptrace.c~consolidate-ptrace_detach arch/avr32/kernel/ptrace.c
--- a/arch/avr32/kernel/ptrace.c~consolidate-ptrace_detach
+++ a/arch/avr32/kernel/ptrace.c
@@ -227,11 +227,6 @@ long arch_ptrace(struct task_struct *chi
 		ret = 0;
 		break;
 
-	/* Detach a process that was attached */
-	case PTRACE_DETACH:
-		ret = ptrace_detach(child, data);
-		break;
-
 	case PTRACE_GETREGS:
 		ret = ptrace_getregs(child, (void __user *)data);
 		break;
diff -puN arch/blackfin/kernel/ptrace.c~consolidate-ptrace_detach arch/blackfin/kernel/ptrace.c
--- a/arch/blackfin/kernel/ptrace.c~consolidate-ptrace_detach
+++ a/arch/blackfin/kernel/ptrace.c
@@ -373,12 +373,6 @@ long arch_ptrace(struct task_struct *chi
 			break;
 		}
 
-	case PTRACE_DETACH:
-		{		/* detach a process that was attached. */
-			ret = ptrace_detach(child, data);
-			break;
-		}
-
 	case PTRACE_GETREGS:
 		{
 
diff -puN arch/cris/arch-v10/kernel/ptrace.c~consolidate-ptrace_detach arch/cris/arch-v10/kernel/ptrace.c
--- a/arch/cris/arch-v10/kernel/ptrace.c~consolidate-ptrace_detach
+++ a/arch/cris/arch-v10/kernel/ptrace.c
@@ -177,10 +177,6 @@ long arch_ptrace(struct task_struct *chi
 			ret = 0;
 			break;
 
-		case PTRACE_DETACH:
-			ret = ptrace_detach(child, data);
-			break;
-
 		/* Get all GP registers from the child. */
 		case PTRACE_GETREGS: {
 		  	int i;
diff -puN arch/cris/arch-v32/kernel/ptrace.c~consolidate-ptrace_detach arch/cris/arch-v32/kernel/ptrace.c
--- a/arch/cris/arch-v32/kernel/ptrace.c~consolidate-ptrace_detach
+++ a/arch/cris/arch-v32/kernel/ptrace.c
@@ -245,10 +245,6 @@ long arch_ptrace(struct task_struct *chi
 			break;
 
 		}
-		case PTRACE_DETACH:
-			ret = ptrace_detach(child, data);
-			break;
-
 		/* Get all GP registers from the child. */
 		case PTRACE_GETREGS: {
 		  	int i;
diff -puN arch/i386/kernel/ptrace.c~consolidate-ptrace_detach arch/i386/kernel/ptrace.c
--- a/arch/i386/kernel/ptrace.c~consolidate-ptrace_detach
+++ a/arch/i386/kernel/ptrace.c
@@ -526,11 +526,6 @@ long arch_ptrace(struct task_struct *chi
 		ret = 0;
 		break;
 
-	case PTRACE_DETACH:
-		/* detach a process that was attached. */
-		ret = ptrace_detach(child, data);
-		break;
-
 	case PTRACE_GETREGS: { /* Get all gp regs from the child. */
 	  	if (!access_ok(VERIFY_WRITE, datap, FRAME_SIZE*sizeof(long))) {
 			ret = -EIO;
diff -puN arch/m32r/kernel/ptrace.c~consolidate-ptrace_detach arch/m32r/kernel/ptrace.c
--- a/arch/m32r/kernel/ptrace.c~consolidate-ptrace_detach
+++ a/arch/m32r/kernel/ptrace.c
@@ -703,14 +703,6 @@ do_ptrace(long request, struct task_stru
 		break;
 	}
 
-	/*
-	 * detach a process that was attached.
-	 */
-	case PTRACE_DETACH:
-		ret = 0;
-		ret = ptrace_detach(child, data);
-		break;
-
 	case PTRACE_GETREGS:
 		ret = ptrace_getregs(child, (void __user *)data);
 		break;
diff -puN arch/m68k/kernel/ptrace.c~consolidate-ptrace_detach arch/m68k/kernel/ptrace.c
--- a/arch/m68k/kernel/ptrace.c~consolidate-ptrace_detach
+++ a/arch/m68k/kernel/ptrace.c
@@ -227,10 +227,6 @@ long arch_ptrace(struct task_struct *chi
 		wake_up_process(child);
 		break;
 
-	case PTRACE_DETACH:	/* detach a process that was attached. */
-		ret = ptrace_detach(child, data);
-		break;
-
 	case PTRACE_GETREGS:	/* Get all gp regs from the child. */
 		for (i = 0; i < 19; i++) {
 			tmp = get_reg(child, i);
diff -puN arch/mips/kernel/ptrace.c~consolidate-ptrace_detach arch/mips/kernel/ptrace.c
--- a/arch/mips/kernel/ptrace.c~consolidate-ptrace_detach
+++ a/arch/mips/kernel/ptrace.c
@@ -435,10 +435,6 @@ long arch_ptrace(struct task_struct *chi
 		wake_up_process(child);
 		break;
 
-	case PTRACE_DETACH: /* detach a process that was attached. */
-		ret = ptrace_detach(child, data);
-		break;
-
 	case PTRACE_GET_THREAD_AREA:
 		ret = put_user(task_thread_info(child)->tp_value,
 				(unsigned long __user *) data);
diff -puN arch/parisc/kernel/ptrace.c~consolidate-ptrace_detach arch/parisc/kernel/ptrace.c
--- a/arch/parisc/kernel/ptrace.c~consolidate-ptrace_detach
+++ a/arch/parisc/kernel/ptrace.c
@@ -329,10 +329,6 @@ long arch_ptrace(struct task_struct *chi
 		/* give it a chance to run. */
 		goto out_wake;
 
-	case PTRACE_DETACH:
-		ret = ptrace_detach(child, data);
-		goto out_tsk;
-
 	case PTRACE_GETEVENTMSG:
                 ret = put_user(child->ptrace_message, (unsigned int __user *) data);
 		goto out_tsk;
diff -puN arch/powerpc/kernel/ptrace.c~consolidate-ptrace_detach arch/powerpc/kernel/ptrace.c
--- a/arch/powerpc/kernel/ptrace.c~consolidate-ptrace_detach
+++ a/arch/powerpc/kernel/ptrace.c
@@ -503,10 +503,6 @@ long arch_ptrace(struct task_struct *chi
 		ret = ptrace_set_debugreg(child, addr, data);
 		break;
 
-	case PTRACE_DETACH:
-		ret = ptrace_detach(child, data);
-		break;
-
 #ifdef CONFIG_PPC64
 	case PTRACE_GETREGS64:
 #endif
diff -puN arch/s390/kernel/ptrace.c~consolidate-ptrace_detach arch/s390/kernel/ptrace.c
--- a/arch/s390/kernel/ptrace.c~consolidate-ptrace_detach
+++ a/arch/s390/kernel/ptrace.c
@@ -683,11 +683,6 @@ do_ptrace(struct task_struct *child, lon
 		wake_up_process(child);
 		return 0;
 
-	case PTRACE_DETACH:
-		/* detach a process that was attached. */
-		return ptrace_detach(child, data);
-
-
 	/* Do requests that differ for 31/64 bit */
 	default:
 #ifdef CONFIG_COMPAT
diff -puN arch/sh/kernel/ptrace.c~consolidate-ptrace_detach arch/sh/kernel/ptrace.c
--- a/arch/sh/kernel/ptrace.c~consolidate-ptrace_detach
+++ a/arch/sh/kernel/ptrace.c
@@ -210,10 +210,6 @@ long arch_ptrace(struct task_struct *chi
 		break;
 	}
 
-	case PTRACE_DETACH: /* detach a process that was attached. */
-		ret = ptrace_detach(child, data);
-		break;
-
 #ifdef CONFIG_SH_DSP
 	case PTRACE_GETDSPREGS: {
 		unsigned long dp;
diff -puN arch/sh64/kernel/ptrace.c~consolidate-ptrace_detach arch/sh64/kernel/ptrace.c
--- a/arch/sh64/kernel/ptrace.c~consolidate-ptrace_detach
+++ a/arch/sh64/kernel/ptrace.c
@@ -244,10 +244,6 @@ long arch_ptrace(struct task_struct *chi
 		break;
 	}
 
-	case PTRACE_DETACH: /* detach a process that was attached. */
-		ret = ptrace_detach(child, data);
-		break;
-
 	default:
 		ret = ptrace_request(child, request, addr, data);
 		break;
diff -puN arch/um/kernel/ptrace.c~consolidate-ptrace_detach arch/um/kernel/ptrace.c
--- a/arch/um/kernel/ptrace.c~consolidate-ptrace_detach
+++ a/arch/um/kernel/ptrace.c
@@ -119,11 +119,6 @@ long arch_ptrace(struct task_struct *chi
 		break;
 	}
 
-	case PTRACE_DETACH:
-		/* detach a process that was attached. */
-		ret = ptrace_detach(child, data);
- 		break;
-
 #ifdef PTRACE_GETREGS
 	case PTRACE_GETREGS: { /* Get all gp regs from the child. */
 		if (!access_ok(VERIFY_WRITE, p, MAX_REG_OFFSET)) {
diff -puN arch/x86_64/kernel/ptrace.c~consolidate-ptrace_detach arch/x86_64/kernel/ptrace.c
--- a/arch/x86_64/kernel/ptrace.c~consolidate-ptrace_detach
+++ a/arch/x86_64/kernel/ptrace.c
@@ -505,11 +505,6 @@ long arch_ptrace(struct task_struct *chi
 		ret = 0;
 		break;
 
-	case PTRACE_DETACH:
-		/* detach a process that was attached. */
-		ret = ptrace_detach(child, data);
-		break;
-
 	case PTRACE_GETREGS: { /* Get all gp regs from the child. */
 	  	if (!access_ok(VERIFY_WRITE, (unsigned __user *)data,
 			       sizeof(struct user_regs_struct))) {
diff -puN arch/xtensa/kernel/ptrace.c~consolidate-ptrace_detach arch/xtensa/kernel/ptrace.c
--- a/arch/xtensa/kernel/ptrace.c~consolidate-ptrace_detach
+++ a/arch/xtensa/kernel/ptrace.c
@@ -304,10 +304,6 @@ long arch_ptrace(struct task_struct *chi
 		ret = put_user(sizeof(elf_fpregset_t), (unsigned long *) data);
 		break;
 
-	case PTRACE_DETACH: /* detach a process that was attached. */
-		ret = ptrace_detach(child, data);
-		break;
-
 	default:
 		ret = ptrace_request(child, request, addr, data);
 		goto out;
diff -puN kernel/ptrace.c~consolidate-ptrace_detach kernel/ptrace.c
--- a/kernel/ptrace.c~consolidate-ptrace_detach
+++ a/kernel/ptrace.c
@@ -385,6 +385,9 @@ int ptrace_request(struct task_struct *c
 	case PTRACE_SETSIGINFO:
 		ret = ptrace_setsiginfo(child, (siginfo_t __user *) data);
 		break;
+	case PTRACE_DETACH:	 /* detach a process that was attached. */
+		ret = ptrace_detach(child, data);
+		break;
 	default:
 		break;
 	}
_

Patches currently in -mm which might be from adobriyan@sw.ru are

origin.patch
isdn-sc-compile-breakage-re-check_reset.patch
consolidate-ptrace_detach.patch
git-dvb.patch
git-ubi.patch
use-list_head-in-binfmt-handling.patch
make-unregister_binfmt-return-void.patch
fix-leaks-on-proc-schedsched_debugtimer_listtimer_stats.patch
fix-leak-on-proc-lockdep_stats.patch
slab_panic-more-proc-posix-timers-shmem.patch
