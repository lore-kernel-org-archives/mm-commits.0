From: akpm@linux-foundation.org
Subject: + ptrace-use-ptrace_request-in-the-remaining-architectures.patch added to -mm tree
Date: Mon, 01 Feb 2010 15:16:03 -0800
Message-ID: <201002012316.o11NG3fB018653@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59860 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753215Ab0BAXRG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 1 Feb 2010 18:17:06 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hch@lst.de, geert@linux-m68k.org, gerg@snapgear.com, monstr@monstr.eu, oleg@redhat.com, roland@redhat.com, ysato@users.sourceforge.jp


The patch titled
     ptrace: use ptrace_request() in the remaining architectures
has been added to the -mm tree.  Its filename is
     ptrace-use-ptrace_request-in-the-remaining-architectures.patch

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
Subject: ptrace: use ptrace_request() in the remaining architectures
From: Christoph Hellwig <hch@lst.de>

Use ptrace_request() in the three remaining architectures that didn't use it
(m68knommu, h8300, microblaze).  This means:

 - ptrace_request now handles PTRACE_{PEEK,POKE}{TEXT,DATA} and PTRACE_DETATCH
   calls that were previously called directly, or in case of h8300 even open
   coded.
 - adds new support for PTRACE_SETOPTIONS/PTRACE_GETEVENTMSG/
   PTRACE_GETSIGINFO/PTRACE_SETSIGINFO

Signed-off-by: Christoph Hellwig <hch@lst.de>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Greg Ungerer <gerg@snapgear.com>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Michal Simek <monstr@monstr.eu>
Acked-by: Roland McGrath <roland@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/h8300/kernel/ptrace.c      |   30 +-----------------------------
 arch/m68knommu/kernel/ptrace.c  |   18 +-----------------
 arch/microblaze/kernel/ptrace.c |   27 +--------------------------
 3 files changed, 3 insertions(+), 72 deletions(-)

diff -puN arch/h8300/kernel/ptrace.c~ptrace-use-ptrace_request-in-the-remaining-architectures arch/h8300/kernel/ptrace.c
--- a/arch/h8300/kernel/ptrace.c~ptrace-use-ptrace_request-in-the-remaining-architectures
+++ a/arch/h8300/kernel/ptrace.c
@@ -42,14 +42,6 @@ extern void h8300_enable_trace(struct ta
  * in exit.c or in signal.c.
  */
 
-inline
-static int read_long(struct task_struct * tsk, unsigned long addr,
-	unsigned long * result)
-{
-	*result = *(unsigned long *)addr;
-	return 0;
-}
-
 void ptrace_disable(struct task_struct *child)
 {
 	h8300_disable_trace(child);
@@ -60,17 +52,6 @@ long arch_ptrace(struct task_struct *chi
 	int ret;
 
 	switch (request) {
-		case PTRACE_PEEKTEXT: /* read word at location addr. */ 
-		case PTRACE_PEEKDATA: {
-			unsigned long tmp;
-
-			ret = read_long(child, addr, &tmp);
-			if (ret < 0)
-				break ;
-			ret = put_user(tmp, (unsigned long *) data);
-			break ;
-		}
-
 	/* read the word at location addr in the USER area. */
 		case PTRACE_PEEKUSR: {
 			unsigned long tmp = 0;
@@ -109,11 +90,6 @@ long arch_ptrace(struct task_struct *chi
 		}
 
       /* when I and D space are separate, this will have to be fixed. */
-		case PTRACE_POKETEXT: /* write the word at location addr. */
-		case PTRACE_POKEDATA:
-			ret = generic_ptrace_pokedata(child, addr, data);
-			break;
-
 		case PTRACE_POKEUSR: /* write the word at location addr in the USER area */
 			if ((addr & 3) || addr < 0 || addr >= sizeof(struct user)) {
 				ret = -EIO;
@@ -175,10 +151,6 @@ long arch_ptrace(struct task_struct *chi
 			break;
 		}
 
-		case PTRACE_DETACH:	/* detach a process that was attached. */
-			ret = ptrace_detach(child, data);
-			break;
-
 		case PTRACE_GETREGS: { /* Get all gp regs from the child. */
 		  	int i;
 			unsigned long tmp;
@@ -210,7 +182,7 @@ long arch_ptrace(struct task_struct *chi
 		}
 
 		default:
-			ret = -EIO;
+			ret = ptrace_request(child, request, addr, data);
 			break;
 	}
 	return ret;
diff -puN arch/m68knommu/kernel/ptrace.c~ptrace-use-ptrace_request-in-the-remaining-architectures arch/m68knommu/kernel/ptrace.c
--- a/arch/m68knommu/kernel/ptrace.c~ptrace-use-ptrace_request-in-the-remaining-architectures
+++ a/arch/m68knommu/kernel/ptrace.c
@@ -116,12 +116,6 @@ long arch_ptrace(struct task_struct *chi
 	int ret;
 
 	switch (request) {
-		/* when I and D space are separate, these will need to be fixed. */
-		case PTRACE_PEEKTEXT: /* read word at location addr. */ 
-		case PTRACE_PEEKDATA:
-			ret = generic_ptrace_peekdata(child, addr, data);
-			break;
-
 		/* read the word at location addr in the USER area. */
 		case PTRACE_PEEKUSR: {
 			unsigned long tmp;
@@ -160,12 +154,6 @@ long arch_ptrace(struct task_struct *chi
 			break;
 		}
 
-		/* when I and D space are separate, this will have to be fixed. */
-		case PTRACE_POKETEXT: /* write the word at location addr. */
-		case PTRACE_POKEDATA:
-			ret = generic_ptrace_pokedata(child, addr, data);
-			break;
-
 		case PTRACE_POKEUSR: /* write the word at location addr in the USER area */
 			ret = -EIO;
 			if ((addr & 3) || addr < 0 ||
@@ -258,10 +246,6 @@ long arch_ptrace(struct task_struct *chi
 			break;
 		}
 
-		case PTRACE_DETACH:	/* detach a process that was attached. */
-			ret = ptrace_detach(child, data);
-			break;
-
 		case PTRACE_GETREGS: { /* Get all gp regs from the child. */
 		  	int i;
 			unsigned long tmp;
@@ -325,7 +309,7 @@ long arch_ptrace(struct task_struct *chi
 		break;
 
 		default:
-			ret = -EIO;
+			ret = ptrace_request(child, request, addr, data);
 			break;
 	}
 	return ret;
diff -puN arch/microblaze/kernel/ptrace.c~ptrace-use-ptrace_request-in-the-remaining-architectures arch/microblaze/kernel/ptrace.c
--- a/arch/microblaze/kernel/ptrace.c~ptrace-use-ptrace_request-in-the-remaining-architectures
+++ a/arch/microblaze/kernel/ptrace.c
@@ -78,26 +78,6 @@ long arch_ptrace(struct task_struct *chi
 	unsigned long copied;
 
 	switch (request) {
-	case PTRACE_PEEKTEXT: /* read word at location addr. */
-	case PTRACE_PEEKDATA:
-		pr_debug("PEEKTEXT/PEEKDATA at %08lX\n", addr);
-		copied = access_process_vm(child, addr, &val, sizeof(val), 0);
-		rval = -EIO;
-		if (copied != sizeof(val))
-			break;
-		rval = put_user(val, (unsigned long *)data);
-		break;
-
-	case PTRACE_POKETEXT: /* write the word at location addr. */
-	case PTRACE_POKEDATA:
-		pr_debug("POKETEXT/POKEDATA to %08lX\n", addr);
-		rval = 0;
-		if (access_process_vm(child, addr, &data, sizeof(data), 1)
-		    == sizeof(data))
-			break;
-		rval = -EIO;
-		break;
-
 	/* Read/write the word at location ADDR in the registers. */
 	case PTRACE_PEEKUSR:
 	case PTRACE_POKEUSR:
@@ -167,13 +147,8 @@ long arch_ptrace(struct task_struct *chi
 		wake_up_process(child);
 		break;
 
-	case PTRACE_DETACH: /* detach a process that was attached. */
-		pr_debug("PTRACE_DETACH\n");
-		rval = ptrace_detach(child, data);
-		break;
 	default:
-		/* rval = ptrace_request(child, request, addr, data); noMMU */
-		rval = -EIO;
+		rval = ptrace_request(child, request, addr, data);
 	}
 	return rval;
 }
_

Patches currently in -mm which might be from hch@lst.de are

linux-next.patch
vfs-fix-vfs_rename_dir-for-fs_rename_does_d_move-filesystems.patch
xtensa-convert-to-asm-generic-hardirqh.patch
add-generic-sys_old_select.patch
add-generic-sys_old_mmap.patch
add-generic-sys_ipc-wrapper.patch
improve-sys_personality-for-compat-architectures.patch
improve-sys_newuname-for-compat-architectures.patch
add-generic-sys_olduname.patch
ptrace-use-ptrace_request-in-the-remaining-architectures.patch

