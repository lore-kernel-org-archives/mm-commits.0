From: akpm@linux-foundation.org
Subject: + ptrace-change-signature-of-arch_ptrace.patch added to -mm tree
Date: Mon, 04 Oct 2010 16:41:35 -0700
Message-ID: <201010042341.o94NfZib022699@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56234 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757026Ab0JDXmc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 4 Oct 2010 19:42:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: namhyung@gmail.com, davem@davemloft.net, dhowells@redhat.com, geert@linux-m68k.org, linux-arch@vger.kernel.org, roland@redhat.com


The patch titled
     ptrace: change signature of arch_ptrace()
has been added to the -mm tree.  Its filename is
     ptrace-change-signature-of-arch_ptrace.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ptrace: change signature of arch_ptrace()
From: Namhyung Kim <namhyung@gmail.com>

Fix up the arguments to arch_ptrace() to take account of the fact that
@addr and @data are now unsigned long rather than long as of a preceding
patch in this series.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
Cc: <linux-arch@vger.kernel.org>
Acked-by: Roland McGrath <roland@redhat.com>
Acked-by: David Howells <dhowells@redhat.com>
Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>
Acked-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/kernel/ptrace.c         |    7 ++++---
 arch/arm/kernel/ptrace.c           |    3 ++-
 arch/avr32/kernel/ptrace.c         |    3 ++-
 arch/blackfin/kernel/ptrace.c      |    3 ++-
 arch/cris/arch-v10/kernel/ptrace.c |    7 ++++---
 arch/cris/arch-v32/kernel/ptrace.c |    3 ++-
 arch/frv/kernel/ptrace.c           |    3 ++-
 arch/h8300/kernel/ptrace.c         |    7 ++++---
 arch/ia64/kernel/ptrace.c          |    3 ++-
 arch/m32r/kernel/ptrace.c          |    3 ++-
 arch/m68k/kernel/ptrace.c          |    9 +++++----
 arch/m68knommu/kernel/ptrace.c     |    7 ++++---
 arch/microblaze/kernel/ptrace.c    |    3 ++-
 arch/mips/kernel/ptrace.c          |    3 ++-
 arch/mn10300/kernel/ptrace.c       |    3 ++-
 arch/parisc/kernel/ptrace.c        |   11 ++++++-----
 arch/powerpc/kernel/ptrace.c       |   15 ++++++++-------
 arch/s390/kernel/ptrace.c          |    3 ++-
 arch/score/kernel/ptrace.c         |    3 ++-
 arch/sh/kernel/ptrace_32.c         |   21 +++++++++++----------
 arch/sh/kernel/ptrace_64.c         |    6 ++++--
 arch/sparc/kernel/ptrace_32.c      |    3 ++-
 arch/sparc/kernel/ptrace_64.c      |    7 ++++---
 arch/tile/kernel/ptrace.c          |    7 ++++---
 arch/um/kernel/ptrace.c            |    5 +++--
 arch/um/sys-i386/ptrace.c          |    4 ++--
 arch/um/sys-x86_64/ptrace.c        |    4 ++--
 arch/x86/kernel/ptrace.c           |    7 ++++---
 arch/xtensa/kernel/ptrace.c        |    3 ++-
 include/linux/ptrace.h             |    3 ++-
 30 files changed, 99 insertions(+), 70 deletions(-)

diff -puN arch/alpha/kernel/ptrace.c~ptrace-change-signature-of-arch_ptrace arch/alpha/kernel/ptrace.c
--- a/arch/alpha/kernel/ptrace.c~ptrace-change-signature-of-arch_ptrace
+++ a/arch/alpha/kernel/ptrace.c
@@ -269,7 +269,8 @@ void ptrace_disable(struct task_struct *
 	user_disable_single_step(child);
 }
 
-long arch_ptrace(struct task_struct *child, long request, long addr, long data)
+long arch_ptrace(struct task_struct *child, long request,
+		 unsigned long addr, unsigned long data)
 {
 	unsigned long tmp;
 	size_t copied;
@@ -292,7 +293,7 @@ long arch_ptrace(struct task_struct *chi
 	case PTRACE_PEEKUSR:
 		force_successful_syscall_return();
 		ret = get_reg(child, addr);
-		DBG(DBG_MEM, ("peek $%ld->%#lx\n", addr, ret));
+		DBG(DBG_MEM, ("peek $%lu->%#lx\n", addr, ret));
 		break;
 
 	/* When I and D space are separate, this will have to be fixed.  */
@@ -302,7 +303,7 @@ long arch_ptrace(struct task_struct *chi
 		break;
 
 	case PTRACE_POKEUSR: /* write the specified register */
-		DBG(DBG_MEM, ("poke $%ld<-%#lx\n", addr, data));
+		DBG(DBG_MEM, ("poke $%lu<-%#lx\n", addr, data));
 		ret = put_reg(child, addr, data);
 		break;
 	default:
diff -puN arch/arm/kernel/ptrace.c~ptrace-change-signature-of-arch_ptrace arch/arm/kernel/ptrace.c
--- a/arch/arm/kernel/ptrace.c~ptrace-change-signature-of-arch_ptrace
+++ a/arch/arm/kernel/ptrace.c
@@ -1075,7 +1075,8 @@ out:
 }
 #endif
 
-long arch_ptrace(struct task_struct *child, long request, long addr, long data)
+long arch_ptrace(struct task_struct *child, long request,
+		 unsigned long addr, unsigned long data)
 {
 	int ret;
 
diff -puN arch/avr32/kernel/ptrace.c~ptrace-change-signature-of-arch_ptrace arch/avr32/kernel/ptrace.c
--- a/arch/avr32/kernel/ptrace.c~ptrace-change-signature-of-arch_ptrace
+++ a/arch/avr32/kernel/ptrace.c
@@ -146,7 +146,8 @@ static int ptrace_setregs(struct task_st
 	return ret;
 }
 
-long arch_ptrace(struct task_struct *child, long request, long addr, long data)
+long arch_ptrace(struct task_struct *child, long request,
+		 unsigned long addr, unsigned long data)
 {
 	int ret;
 
diff -puN arch/blackfin/kernel/ptrace.c~ptrace-change-signature-of-arch_ptrace arch/blackfin/kernel/ptrace.c
--- a/arch/blackfin/kernel/ptrace.c~ptrace-change-signature-of-arch_ptrace
+++ a/arch/blackfin/kernel/ptrace.c
@@ -232,7 +232,8 @@ void user_disable_single_step(struct tas
 	clear_tsk_thread_flag(child, TIF_SINGLESTEP);
 }
 
-long arch_ptrace(struct task_struct *child, long request, long addr, long data)
+long arch_ptrace(struct task_struct *child, long request,
+		 unsigned long addr, unsigned long data)
 {
 	int ret;
 	unsigned long __user *datap = (unsigned long __user *)data;
diff -puN arch/cris/arch-v10/kernel/ptrace.c~ptrace-change-signature-of-arch_ptrace arch/cris/arch-v10/kernel/ptrace.c
--- a/arch/cris/arch-v10/kernel/ptrace.c~ptrace-change-signature-of-arch_ptrace
+++ a/arch/cris/arch-v10/kernel/ptrace.c
@@ -76,7 +76,8 @@ ptrace_disable(struct task_struct *child
  * (in user space) where the result of the ptrace call is written (instead of
  * being returned).
  */
-long arch_ptrace(struct task_struct *child, long request, long addr, long data)
+long arch_ptrace(struct task_struct *child, long request,
+		 unsigned long addr, unsigned long data)
 {
 	int ret;
 	unsigned long __user *datap = (unsigned long __user *)data;
@@ -141,7 +142,7 @@ long arch_ptrace(struct task_struct *chi
 					break;
 				}
 				
-				data += sizeof(long);
+				data += sizeof(unsigned long);
 			}
 
 			break;
@@ -165,7 +166,7 @@ long arch_ptrace(struct task_struct *chi
 				}
 				
 				put_reg(child, i, tmp);
-				data += sizeof(long);
+				data += sizeof(unsigned long);
 			}
 			
 			break;
diff -puN arch/cris/arch-v32/kernel/ptrace.c~ptrace-change-signature-of-arch_ptrace arch/cris/arch-v32/kernel/ptrace.c
--- a/arch/cris/arch-v32/kernel/ptrace.c~ptrace-change-signature-of-arch_ptrace
+++ a/arch/cris/arch-v32/kernel/ptrace.c
@@ -126,7 +126,8 @@ ptrace_disable(struct task_struct *child
 }
 
 
-long arch_ptrace(struct task_struct *child, long request, long addr, long data)
+long arch_ptrace(struct task_struct *child, long request,
+		 unsigned long addr, unsigned long data)
 {
 	int ret;
 	unsigned long __user *datap = (unsigned long __user *)data;
diff -puN arch/frv/kernel/ptrace.c~ptrace-change-signature-of-arch_ptrace arch/frv/kernel/ptrace.c
--- a/arch/frv/kernel/ptrace.c~ptrace-change-signature-of-arch_ptrace
+++ a/arch/frv/kernel/ptrace.c
@@ -254,7 +254,8 @@ void ptrace_disable(struct task_struct *
 	user_disable_single_step(child);
 }
 
-long arch_ptrace(struct task_struct *child, long request, long addr, long data)
+long arch_ptrace(struct task_struct *child, long request,
+		 unsigned long addr, unsigned long data)
 {
 	unsigned long tmp;
 	int ret;
diff -puN arch/h8300/kernel/ptrace.c~ptrace-change-signature-of-arch_ptrace arch/h8300/kernel/ptrace.c
--- a/arch/h8300/kernel/ptrace.c~ptrace-change-signature-of-arch_ptrace
+++ a/arch/h8300/kernel/ptrace.c
@@ -50,7 +50,8 @@ void ptrace_disable(struct task_struct *
 	user_disable_single_step(child);
 }
 
-long arch_ptrace(struct task_struct *child, long request, long addr, long data)
+long arch_ptrace(struct task_struct *child, long request,
+		 unsigned long addr, unsigned long data)
 {
 	int ret;
 
@@ -120,7 +121,7 @@ long arch_ptrace(struct task_struct *chi
 				ret = -EFAULT;
 				break;
 			    }
-			    data += sizeof(long);
+			    data += sizeof(unsigned long);
 			}
 			ret = 0;
 			break;
@@ -135,7 +136,7 @@ long arch_ptrace(struct task_struct *chi
 				break;
 			    }
 			    h8300_put_reg(child, i, tmp);
-			    data += sizeof(long);
+			    data += sizeof(unsigned long);
 			}
 			ret = 0;
 			break;
diff -puN arch/ia64/kernel/ptrace.c~ptrace-change-signature-of-arch_ptrace arch/ia64/kernel/ptrace.c
--- a/arch/ia64/kernel/ptrace.c~ptrace-change-signature-of-arch_ptrace
+++ a/arch/ia64/kernel/ptrace.c
@@ -1177,7 +1177,8 @@ ptrace_disable (struct task_struct *chil
 }
 
 long
-arch_ptrace (struct task_struct *child, long request, long addr, long data)
+arch_ptrace (struct task_struct *child, long request,
+	     unsigned long addr, unsigned long data)
 {
 	switch (request) {
 	case PTRACE_PEEKTEXT:
diff -puN arch/m32r/kernel/ptrace.c~ptrace-change-signature-of-arch_ptrace arch/m32r/kernel/ptrace.c
--- a/arch/m32r/kernel/ptrace.c~ptrace-change-signature-of-arch_ptrace
+++ a/arch/m32r/kernel/ptrace.c
@@ -622,7 +622,8 @@ void ptrace_disable(struct task_struct *
 }
 
 long
-arch_ptrace(struct task_struct *child, long request, long addr, long data)
+arch_ptrace(struct task_struct *child, long request,
+	    unsigned long addr, unsigned long data)
 {
 	int ret;
 
diff -puN arch/m68k/kernel/ptrace.c~ptrace-change-signature-of-arch_ptrace arch/m68k/kernel/ptrace.c
--- a/arch/m68k/kernel/ptrace.c~ptrace-change-signature-of-arch_ptrace
+++ a/arch/m68k/kernel/ptrace.c
@@ -156,7 +156,8 @@ void user_disable_single_step(struct tas
 	singlestep_disable(child);
 }
 
-long arch_ptrace(struct task_struct *child, long request, long addr, long data)
+long arch_ptrace(struct task_struct *child, long request,
+		 unsigned long addr, unsigned long data)
 {
 	unsigned long tmp;
 	int i, ret = 0;
@@ -200,7 +201,7 @@ long arch_ptrace(struct task_struct *chi
 			 * into internal fpu reg representation
 			 */
 			if (FPU_IS_EMU && (addr < 45) && !(addr % 3)) {
-				data = (unsigned long)data << 15;
+				data <<= 15;
 				data = (data & 0xffff0000) |
 				       ((data & 0x0000ffff) >> 1);
 			}
@@ -215,7 +216,7 @@ long arch_ptrace(struct task_struct *chi
 			ret = put_user(tmp, (unsigned long *)data);
 			if (ret)
 				break;
-			data += sizeof(long);
+			data += sizeof(unsigned long);
 		}
 		break;
 
@@ -229,7 +230,7 @@ long arch_ptrace(struct task_struct *chi
 				tmp |= get_reg(child, PT_SR) & ~SR_MASK;
 			}
 			put_reg(child, i, tmp);
-			data += sizeof(long);
+			data += sizeof(unsigned long);
 		}
 		break;
 
diff -puN arch/m68knommu/kernel/ptrace.c~ptrace-change-signature-of-arch_ptrace arch/m68knommu/kernel/ptrace.c
--- a/arch/m68knommu/kernel/ptrace.c~ptrace-change-signature-of-arch_ptrace
+++ a/arch/m68knommu/kernel/ptrace.c
@@ -111,7 +111,8 @@ void ptrace_disable(struct task_struct *
 	user_disable_single_step(child);
 }
 
-long arch_ptrace(struct task_struct *child, long request, long addr, long data)
+long arch_ptrace(struct task_struct *child, long request,
+		 unsigned long addr, unsigned long data)
 {
 	int ret;
 
@@ -183,7 +184,7 @@ long arch_ptrace(struct task_struct *chi
 				ret = -EFAULT;
 				break;
 			    }
-			    data += sizeof(long);
+			    data += sizeof(unsigned long);
 			}
 			ret = 0;
 			break;
@@ -203,7 +204,7 @@ long arch_ptrace(struct task_struct *chi
 				tmp |= get_reg(child, PT_SR) & ~(SR_MASK << 16);
 			    }
 			    put_reg(child, i, tmp);
-			    data += sizeof(long);
+			    data += sizeof(unsigned long);
 			}
 			ret = 0;
 			break;
diff -puN arch/microblaze/kernel/ptrace.c~ptrace-change-signature-of-arch_ptrace arch/microblaze/kernel/ptrace.c
--- a/arch/microblaze/kernel/ptrace.c~ptrace-change-signature-of-arch_ptrace
+++ a/arch/microblaze/kernel/ptrace.c
@@ -73,7 +73,8 @@ static microblaze_reg_t *reg_save_addr(u
 	return (microblaze_reg_t *)((char *)regs + reg_offs);
 }
 
-long arch_ptrace(struct task_struct *child, long request, long addr, long data)
+long arch_ptrace(struct task_struct *child, long request,
+		 unsigned long addr, unsigned long data)
 {
 	int rval;
 	unsigned long val = 0;
diff -puN arch/mips/kernel/ptrace.c~ptrace-change-signature-of-arch_ptrace arch/mips/kernel/ptrace.c
--- a/arch/mips/kernel/ptrace.c~ptrace-change-signature-of-arch_ptrace
+++ a/arch/mips/kernel/ptrace.c
@@ -255,7 +255,8 @@ int ptrace_set_watch_regs(struct task_st
 	return 0;
 }
 
-long arch_ptrace(struct task_struct *child, long request, long addr, long data)
+long arch_ptrace(struct task_struct *child, long request,
+		 unsigned long addr, unsigned long data)
 {
 	int ret;
 
diff -puN arch/mn10300/kernel/ptrace.c~ptrace-change-signature-of-arch_ptrace arch/mn10300/kernel/ptrace.c
--- a/arch/mn10300/kernel/ptrace.c~ptrace-change-signature-of-arch_ptrace
+++ a/arch/mn10300/kernel/ptrace.c
@@ -295,7 +295,8 @@ void ptrace_disable(struct task_struct *
 /*
  * handle the arch-specific side of process tracing
  */
-long arch_ptrace(struct task_struct *child, long request, long addr, long data)
+long arch_ptrace(struct task_struct *child, long request,
+		 unsigned long addr, unsigned long data)
 {
 	unsigned long tmp;
 	int ret;
diff -puN arch/parisc/kernel/ptrace.c~ptrace-change-signature-of-arch_ptrace arch/parisc/kernel/ptrace.c
--- a/arch/parisc/kernel/ptrace.c~ptrace-change-signature-of-arch_ptrace
+++ a/arch/parisc/kernel/ptrace.c
@@ -110,7 +110,8 @@ void user_enable_block_step(struct task_
 	pa_psw(task)->l = 0;
 }
 
-long arch_ptrace(struct task_struct *child, long request, long addr, long data)
+long arch_ptrace(struct task_struct *child, long request,
+		 unsigned long addr, unsigned long data)
 {
 	unsigned long tmp;
 	long ret = -EIO;
@@ -120,8 +121,8 @@ long arch_ptrace(struct task_struct *chi
 	/* Read the word at location addr in the USER area.  For ptraced
 	   processes, the kernel saves all regs on a syscall. */
 	case PTRACE_PEEKUSR:
-		if ((addr & (sizeof(long)-1)) ||
-		    (unsigned long) addr >= sizeof(struct pt_regs))
+		if ((addr & (sizeof(unsigned long)-1)) ||
+		     addr >= sizeof(struct pt_regs))
 			break;
 		tmp = *(unsigned long *) ((char *) task_regs(child) + addr);
 		ret = put_user(tmp, (unsigned long *) data);
@@ -151,8 +152,8 @@ long arch_ptrace(struct task_struct *chi
 			break;
 		}
 
-		if ((addr & (sizeof(long)-1)) ||
-		    (unsigned long) addr >= sizeof(struct pt_regs))
+		if ((addr & (sizeof(unsigned long)-1)) ||
+		     addr >= sizeof(struct pt_regs))
 			break;
 		if ((addr >= PT_GR1 && addr <= PT_GR31) ||
 				addr == PT_IAOQ0 || addr == PT_IAOQ1 ||
diff -puN arch/powerpc/kernel/ptrace.c~ptrace-change-signature-of-arch_ptrace arch/powerpc/kernel/ptrace.c
--- a/arch/powerpc/kernel/ptrace.c~ptrace-change-signature-of-arch_ptrace
+++ a/arch/powerpc/kernel/ptrace.c
@@ -1406,8 +1406,8 @@ static long ppc_del_hwdebug(struct task_
  * Here are the old "legacy" powerpc specific getregs/setregs ptrace calls,
  * we mark them as obsolete now, they will be removed in a future version
  */
-static long arch_ptrace_old(struct task_struct *child, long request, long addr,
-			    long data)
+static long arch_ptrace_old(struct task_struct *child, long request,
+			    unsigned long addr, unsigned long data)
 {
 	switch (request) {
 	case PPC_PTRACE_GETREGS:	/* Get GPRs 0 - 31. */
@@ -1434,7 +1434,8 @@ static long arch_ptrace_old(struct task_
 	return -EPERM;
 }
 
-long arch_ptrace(struct task_struct *child, long request, long addr, long data)
+long arch_ptrace(struct task_struct *child, long request,
+		 unsigned long addr, unsigned long data)
 {
 	int ret = -EPERM;
 
@@ -1446,11 +1447,11 @@ long arch_ptrace(struct task_struct *chi
 		ret = -EIO;
 		/* convert to index and check */
 #ifdef CONFIG_PPC32
-		index = (unsigned long) addr >> 2;
+		index = addr >> 2;
 		if ((addr & 3) || (index > PT_FPSCR)
 		    || (child->thread.regs == NULL))
 #else
-		index = (unsigned long) addr >> 3;
+		index = addr >> 3;
 		if ((addr & 7) || (index > PT_FPSCR))
 #endif
 			break;
@@ -1474,11 +1475,11 @@ long arch_ptrace(struct task_struct *chi
 		ret = -EIO;
 		/* convert to index and check */
 #ifdef CONFIG_PPC32
-		index = (unsigned long) addr >> 2;
+		index = addr >> 2;
 		if ((addr & 3) || (index > PT_FPSCR)
 		    || (child->thread.regs == NULL))
 #else
-		index = (unsigned long) addr >> 3;
+		index = addr >> 3;
 		if ((addr & 7) || (index > PT_FPSCR))
 #endif
 			break;
diff -puN arch/s390/kernel/ptrace.c~ptrace-change-signature-of-arch_ptrace arch/s390/kernel/ptrace.c
--- a/arch/s390/kernel/ptrace.c~ptrace-change-signature-of-arch_ptrace
+++ a/arch/s390/kernel/ptrace.c
@@ -343,7 +343,8 @@ poke_user(struct task_struct *child, add
 	return __poke_user(child, addr, data);
 }
 
-long arch_ptrace(struct task_struct *child, long request, long addr, long data)
+long arch_ptrace(struct task_struct *child, long request,
+		 unsigned long addr, unsigned long data)
 {
 	ptrace_area parea; 
 	int copied, ret;
diff -puN arch/score/kernel/ptrace.c~ptrace-change-signature-of-arch_ptrace arch/score/kernel/ptrace.c
--- a/arch/score/kernel/ptrace.c~ptrace-change-signature-of-arch_ptrace
+++ a/arch/score/kernel/ptrace.c
@@ -325,7 +325,8 @@ void ptrace_disable(struct task_struct *
 }
 
 long
-arch_ptrace(struct task_struct *child, long request, long addr, long data)
+arch_ptrace(struct task_struct *child, long request,
+	    unsigned long addr, unsigned long data)
 {
 	int ret;
 	unsigned long __user *datap = (void __user *)data;
diff -puN arch/sh/kernel/ptrace_32.c~ptrace-change-signature-of-arch_ptrace arch/sh/kernel/ptrace_32.c
--- a/arch/sh/kernel/ptrace_32.c~ptrace-change-signature-of-arch_ptrace
+++ a/arch/sh/kernel/ptrace_32.c
@@ -365,7 +365,8 @@ const struct user_regset_view *task_user
 	return &user_sh_native_view;
 }
 
-long arch_ptrace(struct task_struct *child, long request, long addr, long data)
+long arch_ptrace(struct task_struct *child, long request,
+		 unsigned long addr, unsigned long data)
 {
 	struct user * dummy = NULL;
 	unsigned long __user *datap = (unsigned long __user *)data;
@@ -383,17 +384,17 @@ long arch_ptrace(struct task_struct *chi
 
 		if (addr < sizeof(struct pt_regs))
 			tmp = get_stack_long(child, addr);
-		else if (addr >= (long) &dummy->fpu &&
-			 addr < (long) &dummy->u_fpvalid) {
+		else if (addr >= (unsigned long) &dummy->fpu &&
+			 addr < (unsigned long) &dummy->u_fpvalid) {
 			if (!tsk_used_math(child)) {
-				if (addr == (long)&dummy->fpu.fpscr)
+				if (addr == (unsigned long)&dummy->fpu.fpscr)
 					tmp = FPSCR_INIT;
 				else
 					tmp = 0;
 			} else
-				tmp = ((long *)child->thread.xstate)
+				tmp = ((unsigned long *)child->thread.xstate)
 					[(addr - (long)&dummy->fpu) >> 2];
-		} else if (addr == (long) &dummy->u_fpvalid)
+		} else if (addr == (unsigned long) &dummy->u_fpvalid)
 			tmp = !!tsk_used_math(child);
 		else if (addr == PT_TEXT_ADDR)
 			tmp = child->mm->start_code;
@@ -417,13 +418,13 @@ long arch_ptrace(struct task_struct *chi
 
 		if (addr < sizeof(struct pt_regs))
 			ret = put_stack_long(child, addr, data);
-		else if (addr >= (long) &dummy->fpu &&
-			 addr < (long) &dummy->u_fpvalid) {
+		else if (addr >= (unsigned long) &dummy->fpu &&
+			 addr < (unsigned long) &dummy->u_fpvalid) {
 			set_stopped_child_used_math(child);
-			((long *)child->thread.xstate)
+			((unsigned long *)child->thread.xstate)
 				[(addr - (long)&dummy->fpu) >> 2] = data;
 			ret = 0;
-		} else if (addr == (long) &dummy->u_fpvalid) {
+		} else if (addr == (unsigned long) &dummy->u_fpvalid) {
 			conditional_stopped_child_used_math(data, child);
 			ret = 0;
 		}
diff -puN arch/sh/kernel/ptrace_64.c~ptrace-change-signature-of-arch_ptrace arch/sh/kernel/ptrace_64.c
--- a/arch/sh/kernel/ptrace_64.c~ptrace-change-signature-of-arch_ptrace
+++ a/arch/sh/kernel/ptrace_64.c
@@ -383,7 +383,8 @@ const struct user_regset_view *task_user
 	return &user_sh64_native_view;
 }
 
-long arch_ptrace(struct task_struct *child, long request, long addr, long data)
+long arch_ptrace(struct task_struct *child, long request,
+		 unsigned long addr, unsigned long data)
 {
 	int ret;
 
@@ -471,7 +472,8 @@ long arch_ptrace(struct task_struct *chi
 	return ret;
 }
 
-asmlinkage int sh64_ptrace(long request, long pid, long addr, long data)
+asmlinkage int sh64_ptrace(long request, long pid,
+			   unsigned long addr, unsigned long data)
 {
 #define WPC_DBRMODE 0x0d104008
 	static unsigned long first_call;
diff -puN arch/sparc/kernel/ptrace_32.c~ptrace-change-signature-of-arch_ptrace arch/sparc/kernel/ptrace_32.c
--- a/arch/sparc/kernel/ptrace_32.c~ptrace-change-signature-of-arch_ptrace
+++ a/arch/sparc/kernel/ptrace_32.c
@@ -323,7 +323,8 @@ const struct user_regset_view *task_user
 	return &user_sparc32_view;
 }
 
-long arch_ptrace(struct task_struct *child, long request, long addr, long data)
+long arch_ptrace(struct task_struct *child, long request,
+		 unsigned long addr, unsigned long data)
 {
 	unsigned long addr2 = current->thread.kregs->u_regs[UREG_I4];
 	const struct user_regset_view *view;
diff -puN arch/sparc/kernel/ptrace_64.c~ptrace-change-signature-of-arch_ptrace arch/sparc/kernel/ptrace_64.c
--- a/arch/sparc/kernel/ptrace_64.c~ptrace-change-signature-of-arch_ptrace
+++ a/arch/sparc/kernel/ptrace_64.c
@@ -969,7 +969,8 @@ struct fps {
 	unsigned long fsr;
 };
 
-long arch_ptrace(struct task_struct *child, long request, long addr, long data)
+long arch_ptrace(struct task_struct *child, long request,
+		 unsigned long addr, unsigned long data)
 {
 	const struct user_regset_view *view = task_user_regset_view(current);
 	unsigned long addr2 = task_pt_regs(current)->u_regs[UREG_I4];
@@ -977,8 +978,8 @@ long arch_ptrace(struct task_struct *chi
 	struct fps __user *fps;
 	int ret;
 
-	pregs = (struct pt_regs __user *) (unsigned long) addr;
-	fps = (struct fps __user *) (unsigned long) addr;
+	pregs = (struct pt_regs __user *) addr;
+	fps = (struct fps __user *) addr;
 
 	switch (request) {
 	case PTRACE_PEEKUSR:
diff -puN arch/tile/kernel/ptrace.c~ptrace-change-signature-of-arch_ptrace arch/tile/kernel/ptrace.c
--- a/arch/tile/kernel/ptrace.c~ptrace-change-signature-of-arch_ptrace
+++ a/arch/tile/kernel/ptrace.c
@@ -64,7 +64,8 @@ void ptrace_disable(struct task_struct *
 	clear_tsk_thread_flag(child, TIF_SYSCALL_TRACE);
 }
 
-long arch_ptrace(struct task_struct *child, long request, long addr, long data)
+long arch_ptrace(struct task_struct *child, long request,
+		 unsigned long addr, unsigned long data)
 {
 	unsigned long __user *datap;
 	unsigned long tmp;
@@ -102,7 +103,7 @@ long arch_ptrace(struct task_struct *chi
 	case PTRACE_GETREGS:  /* Get all registers from the child. */
 		if (!access_ok(VERIFY_WRITE, datap, PTREGS_SIZE))
 			break;
-		for (i = 0; i < PTREGS_SIZE; i += sizeof(long)) {
+		for (i = 0; i < PTREGS_SIZE; i += sizeof(unsigned long)) {
 			ret = __put_user(getreg(child, i), datap);
 			if (ret != 0)
 				break;
@@ -113,7 +114,7 @@ long arch_ptrace(struct task_struct *chi
 	case PTRACE_SETREGS:  /* Set all registers in the child. */
 		if (!access_ok(VERIFY_READ, datap, PTREGS_SIZE))
 			break;
-		for (i = 0; i < PTREGS_SIZE; i += sizeof(long)) {
+		for (i = 0; i < PTREGS_SIZE; i += sizeof(unsigned long)) {
 			ret = __get_user(tmp, datap);
 			if (ret != 0)
 				break;
diff -puN arch/um/kernel/ptrace.c~ptrace-change-signature-of-arch_ptrace arch/um/kernel/ptrace.c
--- a/arch/um/kernel/ptrace.c~ptrace-change-signature-of-arch_ptrace
+++ a/arch/um/kernel/ptrace.c
@@ -42,10 +42,11 @@ void ptrace_disable(struct task_struct *
 extern int peek_user(struct task_struct * child, long addr, long data);
 extern int poke_user(struct task_struct * child, long addr, long data);
 
-long arch_ptrace(struct task_struct *child, long request, long addr, long data)
+long arch_ptrace(struct task_struct *child, long request,
+		 unsigned long addr, unsigned long data)
 {
 	int i, ret;
-	unsigned long __user *p = (void __user *)(unsigned long)data;
+	unsigned long __user *p = (void __user *)data;
 
 	switch (request) {
 	/* read word at location addr. */
diff -puN arch/um/sys-i386/ptrace.c~ptrace-change-signature-of-arch_ptrace arch/um/sys-i386/ptrace.c
--- a/arch/um/sys-i386/ptrace.c~ptrace-change-signature-of-arch_ptrace
+++ a/arch/um/sys-i386/ptrace.c
@@ -203,8 +203,8 @@ int set_fpxregs(struct user_fxsr_struct 
 				     (unsigned long *) &fpregs);
 }
 
-long subarch_ptrace(struct task_struct *child, long request, long addr,
-		    long data)
+long subarch_ptrace(struct task_struct *child, long request,
+		    unsigned long addr, unsigned long data)
 {
 	return -EIO;
 }
diff -puN arch/um/sys-x86_64/ptrace.c~ptrace-change-signature-of-arch_ptrace arch/um/sys-x86_64/ptrace.c
--- a/arch/um/sys-x86_64/ptrace.c~ptrace-change-signature-of-arch_ptrace
+++ a/arch/um/sys-x86_64/ptrace.c
@@ -175,8 +175,8 @@ int set_fpregs(struct user_i387_struct _
 	return restore_fp_registers(userspace_pid[cpu], fpregs);
 }
 
-long subarch_ptrace(struct task_struct *child, long request, long addr,
-		    long data)
+long subarch_ptrace(struct task_struct *child, long request,
+		    unsigned long addr, unsigned long data)
 {
 	int ret = -EIO;
 
diff -puN arch/x86/kernel/ptrace.c~ptrace-change-signature-of-arch_ptrace arch/x86/kernel/ptrace.c
--- a/arch/x86/kernel/ptrace.c~ptrace-change-signature-of-arch_ptrace
+++ a/arch/x86/kernel/ptrace.c
@@ -801,7 +801,8 @@ void ptrace_disable(struct task_struct *
 static const struct user_regset_view user_x86_32_view; /* Initialized below. */
 #endif
 
-long arch_ptrace(struct task_struct *child, long request, long addr, long data)
+long arch_ptrace(struct task_struct *child, long request,
+		 unsigned long addr, unsigned long data)
 {
 	int ret;
 	unsigned long __user *datap = (unsigned long __user *)data;
@@ -888,14 +889,14 @@ long arch_ptrace(struct task_struct *chi
 
 #if defined CONFIG_X86_32 || defined CONFIG_IA32_EMULATION
 	case PTRACE_GET_THREAD_AREA:
-		if (addr < 0)
+		if ((int) addr < 0)
 			return -EIO;
 		ret = do_get_thread_area(child, addr,
 					 (struct user_desc __user *) data);
 		break;
 
 	case PTRACE_SET_THREAD_AREA:
-		if (addr < 0)
+		if ((int) addr < 0)
 			return -EIO;
 		ret = do_set_thread_area(child, addr,
 					 (struct user_desc __user *) data, 0);
diff -puN arch/xtensa/kernel/ptrace.c~ptrace-change-signature-of-arch_ptrace arch/xtensa/kernel/ptrace.c
--- a/arch/xtensa/kernel/ptrace.c~ptrace-change-signature-of-arch_ptrace
+++ a/arch/xtensa/kernel/ptrace.c
@@ -256,7 +256,8 @@ int ptrace_pokeusr(struct task_struct *c
 	return 0;
 }
 
-long arch_ptrace(struct task_struct *child, long request, long addr, long data)
+long arch_ptrace(struct task_struct *child, long request,
+		 unsigned long addr, unsigned long data)
 {
 	int ret = -EPERM;
 
diff -puN include/linux/ptrace.h~ptrace-change-signature-of-arch_ptrace include/linux/ptrace.h
--- a/include/linux/ptrace.h~ptrace-change-signature-of-arch_ptrace
+++ a/include/linux/ptrace.h
@@ -100,7 +100,8 @@
 #include <linux/sched.h>		/* For struct task_struct.  */
 
 
-extern long arch_ptrace(struct task_struct *child, long request, long addr, long data);
+extern long arch_ptrace(struct task_struct *child, long request,
+			unsigned long addr, unsigned long data);
 extern int ptrace_traceme(void);
 extern int ptrace_readdata(struct task_struct *tsk, unsigned long src, char __user *dst, int len);
 extern int ptrace_writedata(struct task_struct *tsk, char __user *src, unsigned long dst, int len);
_

Patches currently in -mm which might be from namhyung@gmail.com are

origin.patch
linux-next.patch
vfs-remove-a-warning-on-open_fmode.patch
vfs-add-__fmode_exec.patch
mm-cleanup-gfp_zone-fix-sparse-warnings.patch
init-mark-__user-address-space-on-string-literals.patch
kernel-userc-add-lock-release-annotation-on-free_user.patch
printk-fixup-declaration-of-kmsg_reasons.patch
printk-add-lock-context-annotation.patch
printk-change-type-of-boot_delay-to-int.patch
printk-declare-printk_ratelimit_state-in-ratelimith.patch
printk-declare-printk_ratelimit_state-in-ratelimith-fix.patch
ptrace-annotate-lock-context-change-on-exit_ptrace.patch
signals-annotate-lock_task_sighand.patch
signals-annotate-lock-context-change-on-ptrace_stop.patch
exit-add-lock-context-annotation-on-find_new_reaper.patch
ptrace-change-signature-of-sys_ptrace-and-friends.patch
ptrace-cleanup-ptrace_request.patch
ptrace-change-signature-of-arch_ptrace.patch
ptrace-cleanup-arch_ptrace-on-x86.patch
ptrace-cleanup-arch_ptrace-on-arm.patch
ptrace-cleanup-arch_ptrace-on-avr32.patch
ptrace-cleanup-arch_ptrace-and-friends-on-blackfin.patch
ptrace-cleanup-arch_ptrace-on-cris.patch
ptrace-cleanup-arch_ptrace-on-frv.patch
ptrace-cleanup-arch_ptrace-on-h8300.patch
ptrace-cleanup-arch_ptrace-on-m32r.patch
ptrace-cleanup-arch_ptrace-on-m68k.patch
ptrace-cleanup-arch_ptrace-on-microblaze.patch
ptrace-cleanup-arch_ptrace-on-mips.patch
ptrace-cleanup-arch_ptrace-on-mn10300.patch
ptrace-cleanup-arch_ptrace-on-parisc.patch
ptrace-cleanup-arch_ptrace-on-powerpc.patch
ptrace-cleanup-arch_ptrace-on-score.patch
ptrace-cleanup-arch_ptrace-on-sh.patch
ptrace-cleanup-arch_ptrace-on-sparc.patch
ptrace-cleanup-arch_ptrace-on-tile.patch
ptrace-cleanup-arch_ptrace-on-um.patch
ptrace-cleanup-arch_ptrace-on-xtensa.patch

